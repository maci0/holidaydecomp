#!/usr/bin/env python3
"""call_pairs.py — which of the game's units asks the library for what.

`tools/library_calls.py` answers *which* library routines the program calls. The
caller's side needs no inference at all: a far call sits inside a procedure, a
procedure sits inside one segment, and every segment's unit is named. So the pair
(caller unit, callee segment) is as firm as either half, and it is the per-unit
form of the reach problem — how much of each unit's call surface is VCL rather
than game.

    python3 tools/call_pairs.py            # the per-unit table
    python3 tools/call_pairs.py --json     # structured, with the per-segment split

The resolver is deliberately the conservative one: an offset counts only when
**exactly one** library segment carries a credible entry point there, so an offset
two library units could claim is attributed to neither and shows up in the
`unresolved` line instead of being guessed: a call the fixups do not cover and
whose offset no single segment can claim. The fixups come first, because they name
the callee outright where they exist (`decompile.call_targets`). `tools/library_calls.py` uses
`resolved_targets`, which adds the caller rule on top; the two agree on the total
call sites reaching the library to within that difference.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

import decompile  # noqa: E402
import gen_tree  # noqa: E402

ROOT = Path(__file__).resolve().parent.parent
ORIGINAL = ROOT / "original" / "holiday.exe"
CACHE = ROOT / "build" / "call-pairs.json"

#: The library segments the game calls into: nine VCL/RTL units.
LIBRARY = range(25, 34)

#: Segment number -> unit name, as the round-3 tree evidence names them.
UNITS = gen_tree.UNITS


def _unit(segment: int) -> str:
    return UNITS.get(segment, ("?", [], ""))[0]


def census(original: Path = ORIGINAL) -> dict:
    """Every far call in segments 0-24, by caller unit and callee segment."""
    image = decompile.Image(original)
    classes = decompile.form_classes_by_segment(image)
    data = original.read_bytes()

    rows: dict[int, dict] = {}
    unresolved = 0
    seen: set[tuple[int, int]] = set()
    # The callee segment the NE fixups name outright, where they cover the call.
    # The prologue rule is wrong on 5 of the 257 sites `tools/call_truth.py` can
    # check — every one a call into a frame-less `System` routine, which is how
    # segment 33 was reported as uncalled until 2026-10-14.
    targets = decompile.call_targets(image)
    for segment in image.program_segments():
        entry = rows.setdefault(
            segment.index,
            {"unit": _unit(segment.index), "sites": 0, "to_library": 0, "per_segment": {}},
        )
        for function in decompile.discover(segment, classes.get(segment.index, [])):
            for ins in decompile.procedure_body(segment, function):
                if ins.mnemonic not in ("lcall", "ljmp") or len(ins.operands) < 2:
                    continue
                # Discovered ranges overlap (a callee sits inside a caller's
                # range), so a site counts once, by its address — the same rule
                # `decompile.far_calls` uses. Without it the totals are a few
                # sites too high and depend on how many callers enclose a callee.
                if (segment.index, ins.address) in seen:
                    continue
                seen.add((segment.index, ins.address))
                entry["sites"] += 1
                callee = targets.get((segment.index, ins.address))
                if callee is not None and callee in LIBRARY:
                    entry["to_library"] += 1
                    target = str(callee)
                    entry["per_segment"][target] = entry["per_segment"].get(target, 0) + 1
                elif callee is None:
                    # no fixup covers the call and no single segment can claim its
                    # offset: not attributed
                    entry["unresolved"] = entry.get("unresolved", 0) + 1
                    unresolved += 1

    ordered = [rows[s] for s in sorted(rows)]
    ordered.sort(key=lambda row: -row["to_library"])
    return {
        "key": f"{len(data)}:{hashlib.sha256(data).hexdigest()}",
        "units": ordered,
        "sites": sum(row["sites"] for row in ordered),
        "to_library": sum(row["to_library"] for row in ordered),
        "unresolved": unresolved,
        "library_segments_called": sorted(
            {int(s) for row in ordered for s in row["per_segment"]}
        ),
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--json", action="store_true", help="print the census as JSON")
    args = parser.parse_args()

    result = census()
    if args.json:
        print(json.dumps(result, indent=1))
        return 0

    text = json.dumps(result, indent=1, sort_keys=True) + "\n"
    if not CACHE.is_file() or CACHE.read_text(encoding="utf-8") != text:
        CACHE.parent.mkdir(parents=True, exist_ok=True)
        CACHE.write_text(text, encoding="utf-8")
        print(f"wrote {CACHE.relative_to(ROOT)}")

    print(f"{'unit':10s} {'seg':>4} {'far sites':>9} {'to library':>10} {'share':>7}")
    for row in result["units"]:
        segment = next(s for s in sorted(UNITS) if UNITS[s][0] == row["unit"])
        share = f"{100 * row['to_library'] / row['sites']:.0f}%" if row["sites"] else "-"
        print(f"{row['unit']:10s} {segment:4d} {row['sites']:9d} {row['to_library']:10d} {share:>7}")
    share = 100 * result["to_library"] / result["sites"]
    print(f"{'program':10s} {'':4s} {result['sites']:9d} {result['to_library']:10d} {share:6.0f}%")
    print(
        f"\nlibrary segments the game calls into: "
        f"{', '.join(str(s) for s in result['library_segments_called'])} "
        f"({result['unresolved']} sites have no fixup and no single candidate segment, "
        "so they are attributed to neither)"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
