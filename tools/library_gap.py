#!/usr/bin/env python3
"""Which of the original's library functions the rebuild does not contain.

Both builds link the same DCUs; DCC's linker keeps only what the program touches,
so the gap is a list of *functions*, not of bytes. This finds function starts in
the original's library segments by the three prologues the compiler emits — `push
bp` / `mov bp, sp`, the same with `mov bp, sp` encoded directly, and `enter` — and
asks whether a build contains a 16-byte window from each start.

Boundaries are approximate: a function without a frame pointer is folded into the
one before it, so a "size" here is an upper bound. What it is good for is the
shape of the gap — how many functions are missing and how large they are — and
for naming a target to look at.

    python3 tools/library_gap.py [--build bin/main/HOLIDAY.EXE] [--top 20]
"""

from __future__ import annotations

import argparse
import collections
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

from rebrew.formats import ne_analysis  # noqa: E402

ROOT = Path(__file__).resolve().parent.parent
ORIGINAL = ROOT / "original" / "holiday.exe"
LIBRARY = range(25, 34)
WINDOW = 16


def function_starts(data: bytes) -> list[int]:
    starts: list[int] = []
    for index in range(len(data) - 3):
        if data[index : index + 3] in (b"\x55\x89\xe5", b"\x55\x8b\xec"):
            starts.append(index)
        elif data[index] == 0xC8 and data[index + 3] in (0x00, 0x01):
            starts.append(index)
    return starts


def windows(build: ne_analysis.NeImage) -> set[bytes]:
    data = build.data
    return {data[i : i + WINDOW] for i in range(len(data) - WINDOW + 1)}


def census(build: ne_analysis.NeImage, original: ne_analysis.NeImage) -> dict:
    present = windows(build)
    missing: list[tuple[int, int, int]] = []
    total = 0
    for index in LIBRARY:
        data = original.seg_bytes(index)
        starts = function_starts(data)
        for position, start in enumerate(starts):
            end = starts[position + 1] if position + 1 < len(starts) else len(data)
            size = end - start
            if size < WINDOW:
                continue
            total += 1
            if data[start : start + WINDOW] not in present:
                missing.append((index, start, size))
    return {"total": total, "missing": missing}


def main() -> int:
    parser = argparse.ArgumentParser(description="The library's missing functions")
    parser.add_argument("--build", type=Path, default=ROOT / "bin" / "main" / "HOLIDAY.EXE")
    parser.add_argument("--top", type=int, default=10)
    args = parser.parse_args()

    result = census(ne_analysis.NeImage(args.build), ne_analysis.NeImage(ORIGINAL))
    missing = result["missing"]
    per_segment: collections.Counter = collections.Counter()
    for index, _start, size in missing:
        per_segment[index] += size
    print(f"library functions: {result['total']}; missing {len(missing)}")
    print(f"missing bytes (upper bound): {sum(size for _i, _s, size in missing)}")
    print("by segment: " + ", ".join(f"{index}:{size}" for index, size in sorted(per_segment.items())))
    for index, start, size in sorted(missing, key=lambda item: -item[2])[: args.top]:
        print(f"  seg{index} {start:#06x}  {size}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
