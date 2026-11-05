#!/usr/bin/env python3
"""Which library functions the game *calls*, and which of them the rebuild contains.

`tools/library_gap.py` census the library by *presence*: it scans the original's library
segments for prologues and asks whether a build contains a window from each. That answers
"how many library functions are missing" — 454 of them, 63 910 bytes — but most of those
are never called by anything the program does, so the number cannot say what to name next.

This tool answers the other question, the one `docs/roadmap.md` leaves open: which library
functions does the program's code actually **call**? The relocation records give every far
call its callee segment (`decompile.resolved_targets`), so a call into segments 25–33 is
attributable to a unit and an offset without guessing.

    python3 tools/library_calls.py                 # the census
    python3 tools/library_calls.py --missing       # only what the rebuild lacks
"""

from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

import decompile  # noqa: E402
from rebrew.formats import ne_analysis  # noqa: E402

ROOT = Path(__file__).resolve().parent.parent
ORIGINAL = ROOT / "original" / "holiday.exe"
REBUILT = ROOT / "bin" / "main" / "HOLIDAY.EXE"
CACHE = ROOT / "build" / "library-calls.json"
LIBRARY = range(25, 34)
WINDOW = 16


def census(original: Path = ORIGINAL, rebuilt: Path = REBUILT) -> dict:
    image = decompile.Image(original)
    calls, _indirect = decompile.far_calls(image)
    resolved = decompile.resolved_targets(image, calls)
    built = ne_analysis.NeImage(rebuilt)
    windows = {built.data[i : i + WINDOW] for i in range(len(built.data) - WINDOW + 1)}

    per_unit: dict[int, dict] = {}
    present: list[list[int]] = []
    missing: list[list[int]] = []
    targets: list[dict] = []
    for offset, segment in sorted(resolved.items()):
        if segment not in LIBRARY:
            continue
        entry = per_unit.setdefault(segment, {"functions": 0, "sites": 0})
        entry["functions"] += 1
        entry["sites"] += calls[offset]["sites"]
        target = calls[offset]
        targets.append({
            "segment": segment,
            "offset": offset,
            "sites": target["sites"],
            "callers": sorted(target["callers"]),
            "arguments": [[f"{a} | {b}", count]
                          for (a, b), count in target["context"].most_common(2)],
        })
        window = image.segments[segment].data[offset : offset + WINDOW]
        if len(window) == WINDOW and window in windows:
            present.append([segment, offset])
        else:
            missing.append([segment, offset])
    targets.sort(key=lambda row: (-row["sites"], row["segment"], row["offset"]))
    return {
        "targets": targets[:20],
        "called_functions": len(present) + len(missing),
        "present": len(present),
        "missing": len(missing),
        "per_unit": {str(segment): per_unit[segment] for segment in sorted(per_unit)},
        "missing_targets": missing,
        "present_targets": present,
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--missing", action="store_true", help="list only the missing targets")
    args = parser.parse_args()

    measured = census()
    CACHE.parent.mkdir(parents=True, exist_ok=True)
    CACHE.write_text(json.dumps(measured, indent=1, sort_keys=True) + "\n")
    print(f"the program calls {measured['called_functions']} distinct library functions "
          f"({measured['present']} present in the rebuild, {measured['missing']} missing)")
    print(f"{'unit':>5} {'functions':>10} {'call sites':>11}")
    for segment, entry in measured["per_unit"].items():
        print(f"{segment:>5} {entry['functions']:>10} {entry['sites']:>11}")
    if args.missing:
        print()
        for segment, offset in measured["missing_targets"]:
            print(f"  {segment}:{offset:#06x}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
