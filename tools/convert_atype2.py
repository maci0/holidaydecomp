#!/usr/bin/env python3
"""convert_atype2.py — rewrite internal far fixups into the original's record form.

Rule 2 of the emission (`.scratch/decode-far-segment-words.md` section 5): one
atype-2 record per chain, `rtype = 0`, `target =` the callee segment 1-based,
`addend = 0`. Our toolchain writes the same information as an atype-3 record
with the callee's offset in the addend, because the operand carries
`FFFF 0000` instead of the offset.

What the conversion changes, measured rather than assumed: NE fixup records here
are a **fixed eight bytes** (`<BBHHH>`, the stride `ne_analysis.fixups` reads and
bounds with `count * 8`), and a two-byte addend field sits in every record. So an
internal `(3, 0)` record becomes `(2, 0)` by rewriting its atype byte and zeroing
the addend: **nothing shifts, no count changes, no record moves**, and the block
keeps its length. `.scratch/verify_record_layout.py` discriminates the fixed
stride from a spec-shaped variable one by asking which reading puts record
operands on `9A` far calls: 734 of 928 against 80 in this rebuild, 22 of 36
against 2 in the reference.

Run it last: `tools/emit_chains.py` reads every addend, and
`tools/prune_chain_records.py` looks each site up at the operand position this
tool then moves:

    python3 tools/emit_chains.py bin/main/HOLIDAY.EXE build/chained.exe
    python3 tools/prune_chain_records.py build/chained.exe build/pruned.exe
    python3 tools/convert_atype2.py build/pruned.exe build/final.exe
    uv run --frozen python tools/convert_atype2.py build/pruned.exe build/final.exe --score

Import records (`rtype = 1`) keep atype 3 in the reference as well, and every
other atype is left alone. The tool writes a copy; it never edits its input.
"""

from __future__ import annotations

import argparse
import struct
import sys
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(REPO / "tools"))

from rebrew.formats import ne_analysis  # noqa: E402
from rebrew.formats.ne_analysis import NeImage  # noqa: E402

#: The window the project's score quotes (docs/roadmap.md); the gates read 32.
DEFAULT_WINDOW = 16
#: One record: atype, rtype, source offset, target, addend.
RECORD = "<BBHHH"
RECORD_SIZE = 8


def convert(image: NeImage) -> tuple[bytearray, dict]:
    """Return the image with internal atype-3 records converted, and what changed.

    An atype-3 record patches the four-byte far pointer starting at its source
    offset, so ours sit at the operand (`site + 1`) and carry the callee's
    offset in the addend. The reference's atype-2 records on far calls sit at
    the **segment word** (`site + 3`; `.scratch/verify_record_layout.py` checks
    `offset - 3` against the `9A`), so a converted record moves its source
    offset by two as well: without that the loader would write the selector
    over the callee's offset instead of over the segment word.
    """
    out = bytearray(image.data)
    converted = imports_kept = records = 0
    segments = 0
    for segment in image.segment_records:
        if not segment.flags & 0x0100 or not segment.on_disk:
            continue
        start = segment.file_offset + segment.length
        count = struct.unpack_from("<H", out, start)[0]
        segments += 1
        for index in range(count):
            position = start + 2 + index * RECORD_SIZE
            atype, rtype = out[position], out[position + 1]
            records += 1
            if atype == 3 and rtype != 0:
                imports_kept += 1
                continue
            if atype != 3:
                continue
            out[position] = 2
            # the source offset is the u16 after atype and rtype; a far call
            # needs five bytes, so `site + 3` cannot leave the u16 range
            source_offset = struct.unpack_from("<H", out, position + 2)[0]
            struct.pack_into("<H", out, position + 2, source_offset + 2)
            out[position + 6 : position + 8] = b"\x00\x00"
            converted += 1
    return out, {
        "converted": converted,
        "records": records,
        "imports_kept": imports_kept,
        "segments": segments,
    }


def census(path: Path) -> dict[tuple[int, int, int], int]:
    """(segment, atype, rtype) -> count, read back through rebrew's own parser."""
    from collections import Counter

    ne = NeImage(path)
    return Counter(
        (segment, fixup.address_type, fixup.relocation_type)
        for segment in range(ne.seg_count)
        for fixup in ne.fixups(segment)
    )


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("source", type=Path, help="the EXE to convert")
    ap.add_argument("out", type=Path, help="where to write the converted image")
    ap.add_argument("--score", action="store_true",
                    help="print the raw and the converted content score against the original")
    ap.add_argument("--window", type=int, default=DEFAULT_WINDOW,
                    help=f"score window, default {DEFAULT_WINDOW}")
    args = ap.parse_args()

    image = NeImage(args.source)
    data, stats = convert(image)
    args.out.parent.mkdir(parents=True, exist_ok=True)
    args.out.write_bytes(bytes(data))
    print(
        f"converted {stats['converted']} internal far records to atype-2 in "
        f"{stats['records']} records over {stats['segments']} segment(s) "
        f"({stats['imports_kept']} import records left at atype-3) "
        f"-> {args.out} ({len(data)} bytes)"
    )
    if args.score:
        original = ne_analysis.NeImage(REPO / "original" / "holiday.exe")
        for label, path in (("raw", args.source), ("converted", args.out)):
            covered, total = ne_analysis.byte_score(
                original, ne_analysis.NeImage(path), args.window)
            print(f"{label:10} {covered:,} / {total:,} = "
                  f"{100.0 * covered / total:.2f} % (window {args.window})")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
