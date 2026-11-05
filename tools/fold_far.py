#!/usr/bin/env python3
"""fold_far.py — resolve the far addresses this toolchain leaves for the loader.

Delphi 1.0 as vendored here writes every internal far pointer as `FFFF 0000`
and puts the callee in the relocation block instead:

    atype=3 rtype=0 offset=<patch site> target=<segment> addend=<callee offset>

The linker that produced `holiday.exe` — and the sibling English release, see
`docs/link-form.md` — instead writes the callee's offset into the instruction
and emits an atype-2 (segment word) record.  The information is the same; only
its location differs.

This tool moves it back: for every atype-3 record with an internal target, it
writes the record's addend into the word at the patch site.  Nothing else
changes, and the records stay in place, so the image keeps loading — the loader
overwrites the same word with the same value.

What it buys is comparable segment bytes: relocation blocks live *after* a
segment's data, so `ne_compare --score` and `--gap` never saw this difference as
relocation — they saw it as code that does not match.

Usage:
    uv run --frozen rebrew build delphi src/main/HOLIDAY.DPR --output build/HOLIDAY.EXE
    python3 tools/fold_far.py build/HOLIDAY.EXE build/HOLIDAY.folded.exe
    uv run --frozen python tools/fold_far.py bin/main/HOLIDAY.EXE build/HOLIDAY.folded.exe --score
    uv run --frozen python tools/ne_gap.py original/holiday.exe build/HOLIDAY.folded.exe

`--score` prints the two numbers a freeze records: the raw score of the image
as built, and the folded score of the same image with the operands resolved.
The second one isolates "body shape is right, layout shifted" from "body is
wrong", and it climbs as the linked function set converges on the original's.

The folded value is this image's offset, not the original's, so the folded score
is layout-dependent: with our `GRAPHICS` holding 82 of the original's 92
functions, folding moved 829 differing bytes over those pairs to 801 and the
score by five bytes (124117 to 124112, measured in `docs/link-form.md`). Past a
missing function the folded operand is wrong by exactly that function's size.

Import relocations (rtype=1) are left alone: their addend is an ordinal, not an
offset.
"""

from __future__ import annotations

import argparse
import struct
import sys
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(REPO / "tools"))

import decompile as D  # noqa: E402
from rebrew.formats import ne_analysis  # noqa: E402

#: The window the project's score quotes (docs/roadmap.md); the gates read 32.
DEFAULT_WINDOW = 16


def fold(image: D.Image) -> tuple[bytearray, dict]:
    """Return the folded image and what was written."""
    out = bytearray(image.data)
    ne = struct.unpack_from("<I", out, 0x3C)[0]
    written = skipped_import = 0
    for segment, atype, rtype, offset, target, addend in D.relocation_records(image):
        if atype != 3:
            continue
        if rtype != 0:
            skipped_import += 1
            continue
        start = struct.unpack_from("<H", out, ne + 0x40 + segment * 8)[0] * image.align
        if offset + 2 > len(image.segments[segment].data):
            continue
        struct.pack_into("<H", out, start + offset, addend)
        written += 1
    return out, {
        "written": written,
        "skipped_import": skipped_import,
    }


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("source", type=Path, help="the EXE to fold")
    ap.add_argument("out", type=Path, help="where to write the folded image")
    ap.add_argument("--score", action="store_true",
                    help="print the raw and the folded content score against the original")
    ap.add_argument("--window", type=int, default=DEFAULT_WINDOW,
                    help=f"score window, default {DEFAULT_WINDOW}")
    args = ap.parse_args()

    image = D.Image(args.source)
    data, stats = fold(image)
    args.out.parent.mkdir(parents=True, exist_ok=True)
    args.out.write_bytes(bytes(data))
    print(
        f"folded {stats['written']} far addresses in {args.source} "
        f"-> {args.out} ({len(data)} bytes), "
        f"{stats['skipped_import']} import records left alone"
    )
    if args.score:
        original = ne_analysis.NeImage(REPO / "original" / "holiday.exe")
        for label, path in (("raw", args.source), ("folded", args.out)):
            covered, total = ne_analysis.byte_score(
                original, ne_analysis.NeImage(path), args.window)
            print(f"{label:6} {covered:,} / {total:,} = "
                  f"{100.0 * covered / total:.2f} % (window {args.window})")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
