#!/usr/bin/env python3
"""`docs/globals.md`: every data-segment address the code reaches, and its role.

The counts come from the two censuses — `datamap` for `[0xNNNN]` operands and
`immediate_refs` for addresses passed as `push ds:reg` — and the roles from the
reversal, which is why they are a table in this file rather than something the
generator could infer. Regenerate with `python3 tools/gen_globals.py`, check with
`--check` (the test does).
"""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

import decompile  # noqa: E402

ROOT = Path(__file__).resolve().parent.parent
DOC = ROOT / "docs" / "globals.md"

# Address -> (name, evidence). Every one of these is named in a document; the
# generator only adds the measured counts.
NAMES: dict[int, tuple[str, str]] = {
    0x007C: ("the view/quadrant (0..3)", "map-layer"),
    0x12BE: ("a scroll extent read by the display pass", "map-layer"),
    0x4AEA: ("the accounting block's per-player arrays (8 x 0x20)", "accounting"),
    0x4D50: ("the path temporary of the start-up builder", "data-files"),
    0x4DE2: ("the data directory string", "data-files"),
    0x4E74: ("the auction-text file name", "data-files"),
    0x4F06: ("the music file name", "data-files"),
    0x4F98: ("the graphics file name", "data-files"),
    0x502A: ("the movie file name", "data-files"),
    0x50BC: ("the map file name", "data-files"),
    0x514E: ("the high-score file name", "data-files"),
    0x51E0: ("the sound file name", "data-files"),
    0x54DE: ("a 12-byte family table, 133 records", "map-layer"),
    0x54E2: ("a 12-byte family table, 141 records", "map-layer"),
    0x54E6: ("a table of the display registry", "map-layer"),
    0x54EA: ("a 12-byte family table, 45 records", "map-layer"),
    0x54EE: ("a 12-byte family table, 40 records", "map-layer"),
    0x54F2: ("the 16-byte shape records, 127 tiles", "object-model"),
    0x54FC: ("the working screen width (800 or 640, from the form's size)", "map-layer"),
    0x54FE: ("the working screen height (600 or 480, from the form's size)", "map-layer"),
    0x54F6: ("the 24-byte sprite descriptors, 673 of them", "map-layer"),
    0x5500: ("the quadrant map", "map-layer"),
    0x5504: ("the tile map", "map-layer"),
    0x5508: ("the object kind map", "map-layer"),
    0x550C: ("the chip map", "map-layer"),
    0x5510: ("the fine position map", "map-layer"),
    0x5514: ("the flag board", "map-layer"),
    0x5518: ("a scratch map", "map-layer"),
    0x551C: ("stamp map 1", "map-layer"),
    0x5520: ("stamp map 2", "map-layer"),
    0x5524: ("the 126x126 scratch map (GetMem(0x3E04) at 6:0x2C5F)", "map-layer"),
    0x7226: ("one of two far-pointer pairs the map unit's search entry sets", "map-layer"),
    0x5528: ("the 251x252 buffer", "map-layer"),
    0x5530: ("the camera offset, x", "map-layer"),
    0x5532: ("the camera offset, y", "map-layer"),
    0x5FE2: ("the bitmap the draw calls use", "object-model"),
    0x6056: ("the current mode", "object-model"),
    0x605A: ("the current position, x", "object-model"),
    0x605C: ("the current position, y", "object-model"),
    0x6076: ("the display pass's hottest index", "map-layer"),
    0x6532: ("the object every unit asks for a form; the display reads its bitmap from it", "game-state"),
    0x667E: ("the chip lookup table", "map-layer"),
    0x6682: ("a DARSTELL.DAT table, 40-byte stride", "map-layer"),
    0x6686: ("a DARSTELL.DAT table, 45-byte stride", "map-layer"),
    0x66A2: ("the display state block", "map-layer"),
    0x66C2: ("gfxAuslastungszeigerpos, 264-byte quadrant stride", "game-state"),
    0x66CA: ("a far pointer a call returns, read by segments 0, 2, 7 and 11", "map-layer"),
    0x66C6: ("gfxspielerzeigerpos, 192-byte quadrant stride", "game-state"),
    0x6FB4: ("a far pointer to the menu's status object", "screens"),
    0x6FB8: ("a field of the menu's status object", "screens"),
    0x6FBE: ("a field of the menu's status object", "screens"),
    0x6FC0: ("a field of the menu's status object", "screens"),
    0x6FC4: ("a field of the menu's status object", "screens"),
    0x6F04: ("a far pointer nothing writes: nil in eleven segments", "game-state"),
    0x6344: ("the menu's saved click position, x", "segment-map"),
    0x6346: ("the menu's saved click position, y", "segment-map"),
    0x704E: ("the menu's mode byte; 2 and 3 ignore map clicks", "segment-map"),
    0x6544: ("the auction's picture control (rect fields +0x17C..+0x192)", "screens"),
    0x6570: ("a VCL object the auction sets +0x30 on", "screens"),
    0x6584: ("a VCL object the auction positions", "screens"),
    0x65B0: ("a second picture control of the auction", "screens"),
    0x6456: ("a VCL object read by nine segments", "game-state"),
    0x6516: ("a VCL object read by seven segments", "game-state"),
    0x662E: ("a single byte of the save file", "game-state"),
    0x6630: ("the 90 x 39 scenario name table (three 13-char strings each)", "game-state"),
    0x6638: ("two bytes of the save file", "game-state"),
    0x663A: ("a far pointer to the save block, 26 records of 284 bytes", "game-state"),
    0x663E: ("a far pointer to a scenario table", "game-state"),
    0x6664: ("the save block segment 9 writes and reads", "data-files"),
    0x6536: ("the 52-byte tick record table (stride 0x34)", "game-state"),
    0x653A: ("the low word of the 32-bit tick counter", "game-state"),
    0x653C: ("the high word of the 32-bit tick counter", "game-state"),
    0x70F2: ("the building unit's 255-character string buffer", "segment-map"),
    0x6F10: ("the head of a linked list of 44-byte nodes", "game-state"),
    0x6F12: ("the segment half of that list head", "game-state"),
    0x6F14: ("the head of a second linked list", "game-state"),
    0x6F16: ("the segment half of the second list head", "game-state"),
    0x6F18: ("a list counter", "game-state"),
    0x6F1A: ("a list counter", "game-state"),
    0x6F1C: ("a list counter", "game-state"),
    0x6F20: ("the rules unit's 411-byte record pointer", "segment-map"),
    0x6046: ("a position delta against a VCL control", "screens"),
    0x6048: ("a position delta against a VCL control", "screens"),
    0x74CA: ("a far pointer shared by eight segments, target not identified", "map-layer"),
    0x6F24: ("the shared building array", "segment-map"),
    0x6FC6: ("an 8 x 96 object table", "game-state"),
    0x6FD6: ("the object table, 1601 x 40 bytes", "object-model"),
    0x6FDA: ("the object definitions, 40 x 188", "object-model"),
    0x6FDE: ("a 101 x 4 object table", "game-state"),
    0x6FE2: ("a 16 x 186 object table", "game-state"),
    0x6FEA: ("the animation records, 683 x 22 bytes", "object-model"),
    0x6FF4: ("the object array's high-water mark", "object-model"),
    0x6FFA: ("a projection term", "map-layer"),
    0x6FFC: ("a projection term", "map-layer"),
    0x7000: ("a 9612-byte heap block", "game-state"),
    0x702C: ("the current sprite block, first word", "map-layer"),
    0x7036: ("the current sprite block, sixth word", "map-layer"),
    0x7040: ("the placement position, x", "object-model"),
    0x7042: ("the placement position, y", "object-model"),
    0x0748: ("a read-only typed constant, 130 (0x82)", "game-state"),
    0x0976: ("a read-only typed constant, 255 (0xFF)", "game-state"),
    0x120B: ("a read-only typed constant, 21 (0x15); read ten times in segment 18", "game-state"),
    0x172E: ("a read-only typed constant, 100 (a percentage)", "game-state"),
    0x1202: ("a read-only typed constant, 35", "game-state"),
    0x12C2: ("a read-only typed constant, 36", "game-state"),
    0x171C: ("a read-only typed constant, 188", "game-state"),
    0x120C: ("a read-only typed constant, 23 (0x17)", "game-state"),
    0x4C7E: ("the accounting record block, word 0", "segment-map"),
    0x4C80: ("the accounting record block, word 1", "segment-map"),
    0x4C8A: ("the accounting record block, word 5", "segment-map"),
    0x4C8E: ("the accounting record block, word 7", "segment-map"),
    0x4CA8: ("the accounting record block, the most-read word (132 sites)", "segment-map"),
    0x4CB0: ("the accounting pass's 40-byte record array, indexed by 0x4CAE", "accounting"),
    0x49E4: ("the exception frame pointer: `0x6E7B` saves `sp` here around a protected call", "game-state"),
    0x4CAE: ("the accounting record block, word 24: the index into 0x4CB0", "segment-map"),
    # the count read 100 until round 439, when the site histogram said 109; the
    # description is hand-written, so a test now recomputes every "(N sites)" here
    0x6EE0: ("the help screen's 4-word status object (109 sites)", "segment-map"),
    0x6628: ("a far pointer segment 9 reads 89 times, beside the save buffers", "game-state"),
    0x722E: ("a buffer pointer the main unit sets and segments 6 and 22 read", "screens"),
    0x66B4: ("a word of the display state block, written by the display pass", "segment-map"),
    0x7016: ("a word of the object unit's state (53 sites)", "segment-map"),
    0x66A8: ("a word of the display state block (51 sites)", "segment-map"),
    0x6F0C: ("the third far pointer of the 0x6F10 list structure", "segment-map"),
    0x6F0E: ("the segment half of 0x6F0C", "segment-map"),
    0x4C8C: ("accounting record word", "segment-map"),
    0x4C90: ("accounting record word", "segment-map"),
    0x4C96: ("accounting record word", "segment-map"),
    0x4C98: ("accounting record word", "segment-map"),
    0x6548: ("auction control state word", "segment-map"),
    0x654A: ("auction control state word", "segment-map"),
    0x654C: ("auction control state word", "segment-map"),
    0x6FF6: ("a word of the events unit (37 sites)", "segment-map"),
    0x6FF8: ("a word of the events unit (37 sites)", "segment-map"),
    0x6EE4: ("a far pointer in the help screen's status block", "segment-map"),
    0x70EA: ("a 13 x 41 byte grid (GetMem(0x215) at 21:0x388B)", "map-layer"),
    0x721E: ("a temporary 1681-byte buffer, allocated at four sites", "map-layer"),
    0x7222: ("the second temporary 1681-byte buffer", "map-layer"),
    0x6ECE: ("the start screen's run-once guard", "screens"),
    0x006E: ("a screen index: written 0 and 1..6, six of the writes being the members "
             "of the `11:0x14A5` clone family, one constant each; `1:0x0297` dispatches on "
             "it with eight cases (round 650)", "screens"),
    0x705A: ("the five 10-byte scenario records (50 bytes)", "game-state"),
    0x70A2: ("a per-building array", "segment-map"),
    0x70C6: ("a per-building array", "segment-map"),
    0x70EE: ("a per-building array", "segment-map"),
    0x723A: ("the accounting block's far pointer, read by nine segments", "accounting"),
    0x7220: ("a map unit pointer", "segment-map"),
    0x734E: ("a far pointer shared by six display-side segments", "map-layer"),
    0x7362: ("a 2048-byte display buffer", "map-layer"),
    0x7366: ("a 32512-byte display buffer", "map-layer"),
    0x736A: ("a 32512-byte display buffer", "map-layer"),
    0x736E: ("a 127 x 16 tile table", "map-layer"),
    0x7372: ("a 127 x 20 tile table", "map-layer"),
}


def kind_of(address: int, code_refs: set[int], literal_refs: set[int]) -> str:
    """`data`, `literal` or `code`.

    `push ds:offset` names a data-segment object. `push cs:offset` names
    something in a code segment, which is either a **short-string constant** the
    compiler put there (the bytes are a length byte and that many printable
    characters, and `docs/strings.md` is the same set seen whole) or a
    **procedure address** passed as a callback. Only the pushed segment tells the
    code cases from data, and only the bytes tell the two code cases apart.
    """
    if address not in code_refs:
        return "data"
    return "literal" if address in literal_refs else "code"


def broken_links(directory=None) -> list[tuple[int, str, str]]:
    """Names that cite a document which never mentions the address.

    A name without a place that argues for it cannot be checked, and this is how
    one goes stale: `0x5524` was called "a 252x63 buffer" for rounds while the
    code indexed it with a stride of 126 (round 132). The citation is the part
    that can be verified mechanically, so it is checked mechanically.
    """
    directory = directory or ROOT / "docs"
    cache: dict[str, str] = {}
    broken: list[tuple[int, str, str]] = []
    for address, (label, document) in sorted(NAMES.items()):
        if document not in cache:
            path = Path(directory) / f"{document}.md"
            cache[document] = path.read_text(encoding="utf-8") if path.is_file() else ""
        text = cache[document]
        forms = (f"0x{address:04X}", f"0x{address:04x}", f"0x{address:X}", f"0x{address:x}")
        if not any(form in text for form in forms):
            broken.append((address, label, document))
    return broken



def rows(image) -> list[tuple[int, int, int, int, int, str, str, str]]:
    census, _dropped = decompile.datamap(image)
    immediate = decompile.immediate_refs(image)
    code_refs = decompile.immediate_code_refs(image)
    literal_refs = decompile.immediate_literal_refs(image)
    out = []
    for address in sorted(set(census) | set(immediate)):
        entry = census.get(address, {"width": 0, "readers": set(), "writers": set(), "segments": set()})
        name, where = NAMES.get(address, ("", ""))
        out.append(
            (
                address,
                entry["width"],
                len(entry["readers"]),
                len(entry["writers"]),
                immediate.get(address, 0),
                name,
                where,
                kind_of(address, code_refs, literal_refs),
            )
        )
    return out


def per_segment_reads(image) -> dict[int, list[tuple[int, int, int]]]:
    """address -> [(segment, sites, les sites)] for every address read 10+ times."""
    import collections

    sites: dict[int, collections.Counter] = collections.defaultdict(collections.Counter)
    pointers: collections.Counter = collections.Counter()
    classes = decompile.form_classes_by_segment(image)
    for index, segment in enumerate(image.segments):
        if index > 24:
            continue
        for function in decompile.discover(segment, classes.get(index, [])):
            for ins in decompile.procedure_body(segment, function):
                for match in __import__("re").findall(r"\[(0x[0-9a-f]{1,4})\]", ins.op_str):
                    address = int(match, 16)
                    sites[address][index] += 1
                    if ins.mnemonic == "les":
                        pointers[address] += 1
    out: dict[int, list[tuple[int, int, int]]] = {}
    for address, counter in sites.items():
        total = sum(counter.values())
        if total >= 10:
            out[address] = [
                (index, count, 0) for index, count in sorted(counter.items(), key=lambda t: -t[1])
            ]
    return out


def render(image) -> str:
    table = rows(image)
    named = [row for row in table if row[5]]
    callbacks = [row for row in table if not row[5] and row[7] != "data"]  # noqa: E501
    literals = [row for row in callbacks if row[7] == "literal"]
    lines = [
        "# Data-segment globals",
        "",
        "Every address the code reaches, with the counts the two censuses measure —",
        "`[0xNNNN]` operands for reads and writes, `push ds:reg` for address passes —",
        "and the role the reversal established. Generated by `tools/gen_globals.py`;",
        "the names are a table in that file, the counts are measured.",
        "",
        f"**{len(table)} addresses, {len(named)} of them named.** Of the rest, "
        f"**{len(callbacks)} are in code segments** — `push cs:offset`, where the "
        f"offset is a constant or a procedure, not a global. {len(literals)} of "
        "them parse as length-prefixed short strings (`docs/strings.md` is that "
        f"set seen whole); the other {len(callbacks) - len(literals)} are either "
        "PChar-style constants, whose length the caller passes separately, or "
        "procedure addresses for callbacks, and only the call site tells those "
        "two apart (`docs/call-graph.md`). The remaining addresses are data.",
        "",
        "## Named",
        "",
        "The `reads` and `writes` columns count **procedures**, not sites: one procedure that",
        "loads a global twice and stores to it once reads 1 / writes 1. Both are `datamap`'s",
        "per-procedure reader and writer sets, classified by each operand's own capstone access",
        "bits (`pop [g]` writes `g`; a read-modify-write is both) since 2026-10-13, when a",
        "mnemonic-keyed test was found to report `0x49E4` as 3 reads / 1 write where it is 1 / 3.",
        "",
        "| address | width | reads | writes | address passes | role |",
        "| ---: | ---: | ---: | ---: | ---: | --- |",
    ]
    for address, width, reads, writes, passes, name, where, _kind in named:
        lines.append(
            f"| `{address:#06x}` | {width} | {reads} | {writes} | {passes} "
            f"| {name} (`docs/{where}.md`) |"
        )
    lines += [
        "",
        "## The rest",
        "",
        "Data addresses the code reaches but whose role is not established yet, ordered by",
        "how much the code uses them — the head of this list is where the next names",
        "will come from.",
        "",
        "| address | kind | width | reads | writes | address passes |",
        "| ---: | --- | ---: | ---: | ---: | ---: |",
    ]
    unnamed = sorted(
        (row for row in table if not row[5] and row[7] == "data"),
        key=lambda row: -(row[2] + row[3] + row[4]),
    )
    for address, width, reads, writes, passes, _name, _where, _kind in unnamed[:80]:
        lines.append(
            f"| `{address:#06x}` | data | {width} | {reads} | {writes} | {passes} |"
        )
    if len(unnamed) > 80:
        lines.append(f"| ... | | | ({len(unnamed) - 80} more) |")
    lines.append("")
    busy = per_segment_reads(image)
    owners: dict[int, dict[int, int]] = {}
    for index in range(25):
        analysis = decompile.segment_analysis(image, index)
        for address, count in analysis["globals"].items():
            owners.setdefault(address, {})[index] = count
    hottest = sorted(
        owners.items(), key=lambda item: -sum(item[1].values())
    )[:15]
    # addresses that only ever appear with a register base: `[di + 0x4CB0]` is a
    # data-segment address the absolute census cannot see (rounds 143, 191)
    absolute, _dropped = decompile.datamap(image)
    relative = decompile.read_only_globals(image)
    relative_only = sorted(
        (
            (address, reads, stores)
            for address, (reads, stores) in relative.items()
            if address >= 0x1000 and address not in absolute and reads >= 2
        ),
        key=lambda item: -item[1],
    )
    lines += [
        "",
        "## Every address read ten times or more",
        "",
        "The census again, sorted by how many sites read each address, with the",
        "segments that do the reading. A label in the table above is a claim; this",
        "table is the measurement under it, and it exists because the busiest",
        "addresses turned out to be the ones most often still unnamed (rounds 165",
        "and 166).",
        "",
        "| address | sites | read from |",
        "| ---: | ---: | --- |",
    ]
    ranked = sorted(
        ((sum(count for _index, count, _les in groups), address, groups)
         for address, groups in busy.items()),
        key=lambda item: -item[0],
    )
    for total, address, groups in ranked:
        where = ", ".join(f"seg{index} ({count})" for index, count, _les in groups)
        lines.append(f"| `{address:#06x}` | {total} | {where} |")
    lines += [
        "",
        "## Who reads the hottest addresses",
        "",
        "The same census arranged by **structure** rather than by address: for each of",
        "the fifteen most-read data addresses, the units that read it and how often.",
        "A structure read by one unit is that unit's own state; one read by six is the",
        "game's shared boards.",
        "",
        "| address | total | readers |",
        "| ---: | ---: | --- |",
    ]
    for address, readers in hottest:
        total = sum(readers.values())
        where = ", ".join(
            f"seg{index} ({count})"
            for index, count in sorted(readers.items(), key=lambda item: -item[1])
        )
        lines.append(f"| `{address:#06x}` | {total} | {where} |")
    lines += [
        "",
        "## Addresses only reached with a register base",
        "",
        "The table above is built from absolute `[0xNNNN]` operands, which cannot see",
        "an address the code reaches as `[di + 0xNNNN]` — the same blind spot that",
        "hid `0x6F04` from the read-only sweep (round 143) and left `0x4CB0` out of",
        f"this document after round 191 named it. **{len(relative_only)}** data-segment",
        "addresses are reached only that way, with two or more reads:",
        "",
        "| address | reads | writes |",
        "| ---: | ---: | ---: |",
    ]
    for address, reads, stores in relative_only:
        lines.append(f"| `{address:#06x}` | {reads} | {stores} |")
    return "\n".join(lines)


def main() -> int:
    parser = argparse.ArgumentParser(description="Generate docs/globals.md")
    parser.add_argument("--check", action="store_true", help="compare instead of writing")
    args = parser.parse_args()
    text = render(decompile.Image(decompile.ORIGINAL))
    if args.check:
        if not DOC.is_file() or DOC.read_text(encoding="utf-8") != text:
            print("docs/globals.md is stale; run python3 tools/gen_globals.py")
            return 1
        print("docs/globals.md is current")
        return 0
    DOC.write_text(text, encoding="utf-8")
    print(f"wrote {DOC.relative_to(ROOT)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
