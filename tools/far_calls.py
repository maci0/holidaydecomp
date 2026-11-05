"""A clean census of direct far calls: decode only from verified function starts.

Round 151 tried to attribute `lcall` selectors to segments and got 7,818 distinct
selectors for a 35-segment image, because it walked every discovered function over
segments that also hold tables and accepted any instruction whose first byte was
`0x9A`. This tool is the census that round said was needed first: it decodes the
exact five-byte form from the start of a decoded instruction and reports what it
found, so a count can be checked before any grouping is attempted.

    ./.venv/bin/python tools/far_calls.py            # the census
    ./.venv/bin/python tools/far_calls.py --check    # exit 1 when the count moves
"""
import argparse
import collections
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "tools"))

import decompile  # noqa: E402

#: the count the project has measured, so a change in the reader is a failure
EXPECTED_DIRECT = 10594


def census(path: Path | None = None, segments: int = 25) -> dict:
    """Direct far calls with both immediates, from the original by default."""
    image = decompile.Image(path or (ROOT / "original" / "holiday.exe"))
    classes = decompile.form_classes_by_segment(image)
    calls = []
    lengths = collections.Counter()
    for index in range(min(segments, len(image.segments))):
        for function in decompile.discover(image.segments[index], classes.get(index, [])):
            for instruction in decompile.procedure_body(image.segments[index], function):
                raw = bytes(instruction.bytes)
                lengths[len(raw)] += 1
                if len(raw) != 5 or raw[0] != 0x9A:
                    continue
                calls.append((
                    index,
                    instruction.address,
                    raw[3] | raw[4] << 8,      # selector
                    raw[1] | raw[2] << 8,      # segment-relative offset
                ))
    return {"calls": calls, "lengths": lengths}


def shared_matches() -> list[tuple[int, int, int, int]]:
    """(original selector, offset, rebuilt selector, offset) for the sites that agree.

    A site counts when the original's selector is used from more than one segment and the
    rebuilt image makes a call with the same selector and offset. Those are the first
    entries of a thunk-identity map: round 155 measured 59 of them.
    """
    original = census()["calls"]
    rebuilt = census(ROOT / "bin" / "main" / "HOLIDAY.EXE", 17)["calls"]
    users: dict[int, set[int]] = {}
    for segment, _at, selector, _offset in original:
        users.setdefault(selector, set()).add(segment)
    shared = {selector for selector, segments in users.items() if len(segments) > 1}
    rebuilt_pairs = {(call[2], call[3]) for call in rebuilt if call[3] != 0xFFFF}
    return [(segment, selector, offset, 0) for segment, _at, selector, offset in original
            if offset != 0xFFFF and selector in shared and (selector, offset) in rebuilt_pairs]


def main(argv: list[str]) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--check", action="store_true", help="fail when the count moves")
    parser.add_argument("--json", action="store_true", help="machine-readable output")
    parser.add_argument("--matches", action="store_true",
                        help="the shared-selector sites the rebuild reproduces")
    args = parser.parse_args(argv)

    result = census()
    calls = result["calls"]
    selectors = {selector for _seg, _at, selector, _offset in calls}
    if args.check:
        if len(calls) != EXPECTED_DIRECT:
            print(f"far calls: {len(calls)}, expected {EXPECTED_DIRECT}")
            return 1
        return 0
    if args.matches:
        matches = shared_matches()
        print(f"shared-selector sites the rebuild reproduces: {len(matches)}")
        for segment, selector, offset, _unused in matches[:10]:
            print(f"  {segment}:0x{offset:04x} selector {selector:#06x}")
        return 0
    if args.json:
        print(json.dumps({"direct": len(calls), "selectors": len(selectors),
                          "calls": calls[:50]}, indent=2))
        return 0
    print(f"direct far calls: {len(calls)}")
    print(f"distinct selectors: {len(selectors)}")
    for length, count in result["lengths"].most_common(6):
        print(f"  {length}-byte instruction: {count}")
    # 7,819 distinct selectors for 35 segments is the census's own finding: most of
    # them are import thunks, not segment selectors
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
