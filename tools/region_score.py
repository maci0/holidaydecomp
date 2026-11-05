#!/usr/bin/env python3
"""Score one procedure's byte range against the rebuilt image: the canonical region metric.

    uv run --frozen python tools/region_score.py 17:0x5841
    uv run --frozen python tools/region_score.py 17:0x5841 22:0x3030 --json
    uv run --frozen python tools/region_score.py 24:0x006b --window 32
    uv run --frozen python tools/region_score.py 24:0x006b --rebuilt build/sweep-g.exe
    uv run --frozen python tools/region_score.py 24:0x006b --size 72

`rebrew binary ne-compare` scores the whole image, so a round that lands one body
cannot see it: that body's windows are a fraction of a percent of 672 992 bytes.
This scores a range instead. Four choices define the number it prints, and
`tools/test_region_score.py` pins them; a figure computed anywhere else is not
comparable with one printed here.

## The metric

* **Range.** The original image's segment bytes `[offset, offset + size)` of one
  procedure, `size` read from `src/main/function_structure.json`: the span
  `tools/gen_functions_json.py` derives from the prologue table, the column
  `docs/worklist.csv` quotes. `--size` overrides it for a range the inventory
  does not hold. The range is never trimmed or extended to an instruction
  boundary.
* **Unit.** Windows of `--window` bytes, **16 by default**, the unit the score in
  `docs/roadmap.md` quotes. A range of `n` bytes has `n - window + 1` windows.
  Instructions are never counted: this tool decodes nothing, so a body's
  instruction count and its window count are different units of the same bytes
  and must never share a ratio.
* **Matching.** Exact byte equality against **any** window of the other image
  (`rebrew.formats.ne_analysis.block_set`): no masking, no relocation handling,
  no allowance for a different offset. Content overlap, never placement.
* **Reported.** `matched`, the number of matching window starts; `covered`, the
  bytes in the union of the matching windows, each byte counted once; `runs` and
  `longest`, the maximal runs of consecutive matching starts along the range;
  and `verbatim`, whether the whole range occurs as one contiguous run in the
  other image, with that image's offset.

The rebuild packs its segments differently from the original
(docs/obstacles.md), so the windows of one run may match at unrelated offsets in
the other image, and `verbatim` names an offset in the other image rather than a
location the range had in the original.

## What this tool does not read

`rebrew binary ne-compare`'s per-segment rows are index-paired, not
content-paired: row `i` sets the original's segment `i` against the rebuild's
segment `i`, and the label is **one-based** (`"segment": i + 1`), so
`Segment 19` is original index 18. The rebuild packs its segments differently
from the original (docs/obstacles.md), so index `i` holds different content in
the two images and a row's `content=` moves when the packing moves: seg19 read
22B for a segment whose bodies measure 100% verbatim here. Do not diff those
rows across builds. Nothing in this tool uses them: `matched`, `covered`, `runs`
and `verbatim` are measured over the whole other image, and only the
whole-image `covered` figure at the bottom is shared with `ne-compare`.

## The region figures in `notes.txt` are not reproducible

Per-procedure region numbers were published mid-flight by a script that no
longer exists: `0.6320 (79/81 seq)` for `22:0x4FD1`, `0.3136 (37/51)` for
`22:0x354C`, `0.4131 (44/54 window-seq)` for `22:0x33BC`, `0.8800 (44/50 seq)`
for `22:0x2D70`. None of them can be rebuilt from the images:

* their paired totals (81, 51, 54) are neither those bodies' window counts
  (411, 451, 385) nor their instruction counts (159, 178, 147), and three of the
  four ratios do not even equal their own pair (79/81 is 0.9753, 37/51 is
  0.7255, 44/54 is 0.8148);
* this tool measures the same four ranges as **301/411, 272/451, 113/385 and
  25/132** matched windows, which no combination of the published figures
  reproduces.

So those numbers are unreproducible mid-flight measurements. They are not a
baseline, not a target, and not comparable with anything this tool prints; only
the definition above and the test that pins it are canonical.
"""

from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

from proj_lock import project_root  # noqa: E402
from rebrew.formats import ne_analysis  # noqa: E402

ROOT = project_root()
ORIGINAL = ROOT / "original" / "holiday.exe"
REBUILT = ROOT / "bin" / "main" / "HOLIDAY.EXE"
INVENTORY = ROOT / "src" / "main" / "function_structure.json"

#: The window the project's score quotes (docs/roadmap.md); the gates read 32.
DEFAULT_WINDOW = 16

TARGET_RE = re.compile(r"(\d+):(0x[0-9a-fA-F]+|\d+)$")


def parse_target(text: str) -> tuple[int, int]:
    """`SEGMENT:OFFSET`, the address form every tool in this directory takes."""
    match = TARGET_RE.fullmatch(text.strip())
    if not match:
        raise ValueError(f"target must look like 17:0x5841, got {text!r}")
    return int(match.group(1)), int(match.group(2), 0)


def load_inventory(path: Path = INVENTORY) -> dict[int, tuple[int, str]]:
    """`va -> (size, name)`, keyed by the store's `segment * 0x10000 + offset`."""
    rows = json.loads(path.read_text(encoding="utf-8"))
    return {int(row["va"]): (int(row["size"]), str(row["name"])) for row in rows}


def score_region(body: bytes, runs: set[bytes], window: int) -> dict[str, int | None]:
    """Window score for one byte range: counts, covered bytes and the sequence."""
    if window < 1:
        raise ValueError("window size must be positive")
    starts = len(body) - window + 1
    if starts < 1:
        # A range shorter than the window has no complete window at all. That is
        # reported as zero windows, never as a zero score of a real measurement.
        return {"bytes": len(body), "windows": 0, "matched": 0, "covered": 0,
                "runs": 0, "longest": 0, "longest_at": 0}

    hits = [i for i in range(starts) if body[i : i + window] in runs]
    runs_count = run = longest = longest_at = 0
    for index, start in enumerate(hits):
        run = run + 1 if index and start == hits[index - 1] + 1 else 1
        if run == 1:
            runs_count += 1
        if run > longest:
            longest, longest_at = run, start - (run - 1)
    return {
        "bytes": len(body),
        "windows": starts,
        "matched": len(hits),
        "covered": ne_analysis.covered_bytes(body, runs, window),
        "runs": runs_count,
        "longest": longest,
        "longest_at": longest_at,
    }


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(
        description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("targets", nargs="+", metavar="SEG:OFF",
                        help="one or more procedures, e.g. 17:0x5841")
    parser.add_argument("--size", type=int, default=None,
                        help="override the inventory size (one target only)")
    parser.add_argument("--window", type=int, default=DEFAULT_WINDOW,
                        help=f"window size, default {DEFAULT_WINDOW}")
    parser.add_argument("--original", type=Path, default=ORIGINAL)
    parser.add_argument("--rebuilt", type=Path, default=REBUILT,
                        help="the image to score against, default bin/main/HOLIDAY.EXE")
    parser.add_argument("--json", action="store_true", help="structured output")
    args = parser.parse_args(argv)

    if args.size is not None and len(args.targets) > 1:
        parser.error("--size applies to a single target")
    if not args.original.is_file():
        parser.error(f"missing original image: {args.original}")
    if not args.rebuilt.is_file():
        parser.error(f"missing rebuilt image: {args.rebuilt}")

    inventory = load_inventory()
    original = ne_analysis.NeImage(args.original)
    rebuilt = ne_analysis.NeImage(args.rebuilt)
    runs = ne_analysis.block_set(rebuilt.data, args.window)

    rows: list[dict] = []
    for text in args.targets:
        segment, offset = parse_target(text)
        key = segment * 0x10000 + offset
        if args.size is not None:
            size, name = args.size, ""
        elif key in inventory:
            size, name = inventory[key]
        else:
            print(f"{text}: not in {INVENTORY.name}; pass --size", file=sys.stderr)
            return 2
        if not 0 <= segment < original.seg_count:
            print(f"{text}: segment {segment} out of range "
                  f"(image has {original.seg_count})", file=sys.stderr)
            return 2
        segment_bytes = original.seg_bytes(segment)
        if offset + size > len(segment_bytes):
            print(f"{text}: range {offset:#x}+{size} leaves segment {segment} "
                  f"({len(segment_bytes)} bytes)", file=sys.stderr)
            return 2
        body = segment_bytes[offset : offset + size]
        position = rebuilt.data.find(body) if body else -1
        row = {"target": text, "segment": segment, "offset": offset, "name": name,
               "verbatim": position >= 0, "verbatim_at": position}
        row.update(score_region(body, runs, args.window))
        rows.append(row)

    covered, total = ne_analysis.byte_score(original, rebuilt, args.window)
    if args.json:
        print(json.dumps({
            "window": args.window,
            "original": str(args.original),
            "rebuilt": str(args.rebuilt),
            "image": {"covered": covered, "bytes": total},
            "regions": rows,
        }, indent=2))
        return 0

    for row in rows:
        windows = int(row["windows"])
        matched = int(row["matched"])
        share = (100.0 * matched / windows) if windows else 0.0
        size = int(row["bytes"])
        name = f"  {row['name']}" if row["name"] else ""
        print(f"{row['target']}  {size} bytes{name}  window {args.window}")
        if not windows:
            print("  shorter than the window: no complete window")
        else:
            print(f"  windows {windows}   matched {matched} ({share:.2f} %)"
                  f"   covered {row['covered']} bytes")
            if matched:
                span = int(row["longest"]) + args.window - 1
                print(f"  runs {row['runs']}   longest {row['longest']} windows"
                      f" ({span} bytes) at +{int(row['longest_at']):#x}")
            else:
                print("  runs 0   no window of this range occurs in the other image")
        if row["verbatim"]:
            print(f"  verbatim at {int(row['verbatim_at']):#x}"
                  f" in {args.rebuilt.name}")
        else:
            print("  not present verbatim in the other image")
    print(f"image  {covered:,} / {total:,} = {100.0 * covered / total:.2f} %"
          f"  ({args.rebuilt.name} against {args.original.name})")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
