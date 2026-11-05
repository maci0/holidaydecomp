#!/usr/bin/env python3
"""`src/main/DATAVAL.PAS`: the data segment's initialised bytes, written back.

The original's DGROUP has a file image of 11641 bytes — its *initialised* data,
which the units' own typed constants and variable initialisers put there. The
tool can read those bytes exactly, and this unit writes them back as constants so
the compiler emits the same byte sequences again. Nothing is invented: every byte
is what the original image contains, and the file describes the method as the
same one `tools/gen_pools.py` and `tools/gen_tables.py` use for the code
segments.

    python3 tools/gen_data.py [--check]
"""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

import decompile  # noqa: E402

ROOT = Path(__file__).resolve().parent.parent
UNIT = ROOT / "src" / "main" / "DATAVAL.PAS"
CHUNK = 512


def chunks(image) -> list[tuple[int, bytes]]:
    data = image.data_segment().data
    return [
        (offset, data[offset : offset + CHUNK])
        for offset in range(0, len(data), CHUNK)
    ]


def _rows(blob) -> str:
    rows = ""
    line = "    "
    for index, byte in enumerate(blob):
        token = f"${byte:02X}" + ("," if index < len(blob) - 1 else "")
        if len(line) + len(token) > 96:
            rows += line.rstrip() + "\n"
            line = "    "
        line += token + " "
    rows += line.rstrip()
    return rows.rstrip()


def _decl(name, blob) -> str:
    return (
        f"{{ data segment offset, {len(blob)} bytes }}\n"
        f"{name}: array[0..{len(blob) - 1}] of Byte = (\n{_rows(blob)});"
    )


def _rows(blob) -> str:
    rows = ""
    line = "    "
    for index, byte in enumerate(blob):
        token = f"${byte:02X}" + ("," if index < len(blob) - 1 else "")
        if len(line) + len(token) > 96:
            rows += line.rstrip() + "\n"
            line = "    "
        line += token + " "
    rows += line.rstrip()
    return rows.rstrip()


def _decl(name, blob) -> str:
    return f"{name}: array[0..{len(blob) - 1}] of Byte = (\n{_rows(blob)});"


#: Carve named cells out of chunks 0 and 13 so game units can address them at
#: their exact DGROUP offsets (round 661). Every piece stays EVEN-length so
#: DCC 8.0's word-aligned typed-constant emission inserts no padding bytes
#: (probe: 124-byte array followed directly by the next item); scalar cells go
#: through a zero-byte `var absolute` alias of a two-byte pair (round 660/661
#: probes: const order = source order, absolute-of-ident accepted, alias adds
#: no data).
#: absolute data-segment offset: (start, length, name, scalar-alias, type),
#: the fifth element naming the alias's type (default ShortInt). Round 713:
#: G008A/G008E/G0090/G0092 land at the index the original occupied, so the
#: identifier pays the +0xCE class like 0x00A2; G00A2 is its byte view;
#: chunk 0x1200's odd start (0x1273) puts G1341 on 0x1341 exactly.
#: Round 718 scope: the class is the whole early DATAVAL block, not only the
#: named views. seg0-24's landing check (107-immediate census) shows every
#: copy-resident spelling paying reference + 0xCE: 27 cells whose reference
#: addresses run from 0x54 (operand 0x122) through the early block, the two
#: buffer heads Buf0102 and Buf0902 with counts 2048 and 2304, 0x12bc, plus
#: the element spellings, chunk-array views (Data0000_004E[n], Data0000_008C,
#: Data0A00[2], Data1400[120]) and pair aliases over the same bytes, Pred7c
#: included. 0x54fa stays out of the class: MAP BSS, exact at the reference.
#: The exceptions inside the copy are the source-shifted pieces Set1418,
#: Set1438 and Tbl199E, whose source is built - 0xCE so they land on the
#: reference address and pay nothing. All of it rides the prefix-round (B)
#: acceptance: the operand is +0xCE against the reference, the rebuild is
#: compared and never run.
SPLITS = {
    0x0000: [(0x0000, 76, None, None),
             (0x004C, 2, "Pair004C", "G004C"),
             (0x004E, 8, "Data0000_004E", None),
             (0x0056, 2, "Pair0056", "G0056"),
             (0x0058, 2, "Pair0058", "G0058"),
             (0x005A, 2, "Pair005A", None),
             (0x005C, 2, "Pair005C", "G005C"),
             (0x005E, 2, "Pair005E", "G005E"),
             (0x0060, 6, "Pair0060", None),
             (0x0066, 2, "Pair0066", "G0066"),
             (0x0068, 6, "Pair0068", None),
             (0x006E, 2, "Pair006E", "G006E"),
             (0x0070, 12, "Pair0070", None),
             (0x007C, 2, "PredPair", "Pred7c"),
             (0x007E, 8, "Pair007E", None),
             (0x0086, 2, "Pair0086", "G0086"),
             (0x0088, 2, None, None),
             (0x008A, 2, "Pair008A", "G008A", "Word"),
             (0x008C, 2, None, None),
             (0x008E, 2, "Pair008E", "G008E", "Word"),
             (0x0090, 2, "Pair0090", "G0090", "Word"),
             (0x0092, 2, "Pair0092", "G0092", "Word"),
             (0x0094, 2, "Pair0094", None),
             (0x0096, 2, "Pair0096", "G0096", "Word"),
             (0x0098, 2, None, None),
             (0x009A, 2, "Pair009A", "G009A", "Word"),
             (0x009C, 2, "Pair009C", None),
             (0x009E, 2, "Pair009E", "G009E", "Word"),
             (0x00A0, 2, None, None),
             (0x00A2, 2, "Pair00A2", "G00A2"),
             (0x00A4, 94, "Pair00A4", None),
             (0x0102, 254, "Buf0102", None)],
    # G1341's odd-index piece pair is removed: it made DCC insert two zero
    # bytes at constants index 0x1277, shifting every DGROUP address past it
    # (measured on the 01:20 image, built[i+2] == ref[i] for 6912/6912 after
    # that index). An exact landing on odd address 0x1341 needs an odd piece
    # start and pads around it; the cell stays held.
    # Prefix cells 0x59/0x5d/0x5f sit at odd indices, so they keep no alias
    # of their own: read them as Pair0058[1], Pair005C[1], Pair005E[1]
    # (piece base + 1, same +0xCE class as G00A2). Piece starts stay even.
    # Round 732: the 032E cells spell by element pass on the piece names
    # (0x0054/0x0055 = Data0000_004E[6..7], 0x0057..0x0087 from the pair
    # bases, 0x0096/0x009A/0x009E = Pair0094[2]/[6]/[10], 0x00A6 =
    # Pair00A4[2], 0x12BC = Pair12AA[18]). Buf0102 and Buf0902 name the two
    # BlockWrite buffers that cross chunk seams: 0x0102 spans five pieces
    # (0x102..0x902), 0x902 spans six (0x902..0x1202), the head is the
    # spelling target, element pass pending seg0-24's probe.
    0x0800: [(0x0902, 254, "Buf0902", None)],
    0x1000: [(0x1134, 36, "Arr1134", "G1202", "array[0..35] of Byte"),
             (0x1158, 152, "Arr1158", "G1226",
              "array[0..18] of array[0..3] of Word"),
             (0x11F0, 2, "Pair11F0", "G12BE", "Word")],
     0x1200: [(0x128A, 32, "Pair128A", "Set1358", "TByteSet"),
              (0x12AA, 32, "Pair12AA", "Set1378", "TByteSet"),
              # Built 0x1418/0x1438: the reference tests
              # `test byte ptr [di + 0x1418]` beside lcall 0x1899 in seg1 and
              # seg2 and loads `mov di, 0x1438` (seg16), so the pieces sit at
              # source = built - 0xCE, inside this chunk, not at source
              # 0x1418 (which would land 0x14E6, one unrelated imm each).
              (0x134A, 32, "Pair134A", "Set1418", "TByteSet"),
              (0x136A, 32, "Pair136A", "Set1438", "TByteSet")],
    0x1800: [(0x1800, 208, None, None),
             (0x18D0, 180, "Tbl199E", "G199E", "array[0..89] of Word"),
             (0x1984, 56, None, None),
             (0x19BC, 4, "Pair1A8A", "G1A8A", "array[0..1] of Word"),
             (0x19C0, 64, None, None)],
    0x1A00: [(0x1A00, 142, None, None),
             (0x1A8E, 16, "TblA", None),
             (0x1A9E, 354, "TblB", None)],
}


def unit_source(image) -> tuple[str, int]:
    found = chunks(image)
    decls: list[str] = []
    aliases: list[str] = []
    refs: list[str] = []
    total = 0
    for offset, blob in found:
        total += len(blob)
        name = f"Data{offset:04X}"
        pieces = SPLITS.get(offset)
        if not pieces:
            decls.append(_decl(name, blob))
            refs.append(f"  b := {name}[0];\n  b := {name}[{len(blob) - 1}];")
            continue
        cursor = 0
        for split in pieces:
            start_off, length, piece_name, alias = split[:4]
            alias_type = split[4] if len(split) > 4 else "ShortInt"
            rel = start_off - offset
            assert rel >= cursor, (hex(offset), start_off, cursor)
            if rel > cursor:
                pad_name = f"Pad{name}_{cursor:04X}"
                pad = blob[cursor:rel]
                decls.append(_decl(pad_name, pad))
                refs.append(f"  b := {pad_name}[0];\n  b := {pad_name}[{len(pad) - 1}];")
            piece = blob[rel : rel + length]
            assert len(piece) % 2 == 0, (piece_name, len(piece))
            if piece_name is None:
                piece_name = f"{name}_{rel:04X}"
            decls.append(_decl(piece_name, piece))
            refs.append(f"  b := {piece_name}[0];\n  b := {piece_name}[{length - 1}];")
            if alias:
                aliases.append(f"  {alias}: {alias_type} absolute {piece_name};")
                # DCC 8 rejects Byte() casts of an array (Error 61 on
                # G1202), so array aliases read their first element, and
                # only get a Byte() when the leaf element is not a Byte.
                if "array[" in alias_type:
                    index = "".join("[0]" for _ in range(alias_type.count("array[")))
                    leaf = alias_type.rsplit("] of ", 1)[-1].strip()
                    expr = f"{alias}{index}"
                    refs.append(f"  b := {expr};" if leaf == "Byte"
                                else f"  b := Byte({expr});")
                elif "set" not in alias_type.lower():
                    # A set cannot cast to Byte; the piece touch above already
                    # keeps its bytes referenced.
                    refs.append(f"  b := Byte({alias});")
            cursor = rel + length
        if cursor < len(blob):
            pad_name = f"Pad{name}_{cursor:04X}"
            pad = blob[cursor:]
            assert len(pad) % 2 == 0, (pad_name, len(pad))
            decls.append(_decl(pad_name, pad))
            refs.append(f"  b := {pad_name}[0];\n  b := {pad_name}[{len(pad) - 1}];")
    var_block = ("\n".join(aliases) + "\n") if aliases else ""
    text = (
        "unit DataVal;\n"
        "{ The data segment's initialised bytes, generated by tools/gen_data.py.\n"
        f"  {len(found)} chunks, {total} bytes, read out of the original image and\n"
        "  written back as `array of Byte` constants so they compile to the same\n"
        "  bytes. Chunks 0 and 13 carry named pieces (PredPair/TblA/TblB)\n"
        "  plus zero-byte `absolute` aliases; typed-constant order is source order\n"
        "  with word alignment (round 660 probes). }\n\n"
        "interface\n\n"
        "procedure LoadData;\n\n"
        "type\n  TByteSet = set of 0..255;\n\n"
        "const\n  " + "\n  ".join(decls) + "\n\n"
        + ("var\n" + var_block + "\n" if aliases else "")
        + "implementation\n\n"
        "var\n  b: Byte;\n\n"
        "procedure LoadData;\nbegin\n" + "\n".join(refs) + "\nend;\n\nend.\n"
    )
    return text, total


def main() -> int:
    parser = argparse.ArgumentParser(description="Generate src/main/DATAVAL.PAS")
    parser.add_argument("--check", action="store_true", help="compare instead of writing")
    args = parser.parse_args()
    source, total = unit_source(decompile.Image(decompile.ORIGINAL))
    current = UNIT.read_text(encoding="cp1252") if UNIT.is_file() else ""
    if args.check:
        if current != source:
            print("src/main/DATAVAL.PAS is stale; run python3 tools/gen_data.py")
            return 1
        print("src/main/DATAVAL.PAS is current")
        return 0
    UNIT.write_text(source, encoding="cp1252")
    print(f"wrote {UNIT.relative_to(ROOT)}: {source.count('procedure Data')} chunks, {total} bytes")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
