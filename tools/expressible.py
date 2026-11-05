"""List the bodies a Pascal source form can reproduce byte for byte, in size order.

A body is *expressible* when nothing in it depends on where the program places code or data:
no absolute address, no indexed access with an absolute displacement, and no access to the
caller's frame through `ss`. Calls are allowed — a stub callee is enough for the caller's own
bytes to match — but they are counted, because a call's operand is a loader-assigned segment
selector and a body with one can only match if that selector happens to agree.

Two filters were written by hand before this tool and both missed `[di + 0x6F8C]`
(rounds 273 and 410), so the displacement rule lives here once.

Usage: python tools/expressible.py [--max-bytes N] [--segments 0,1,2]
"""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "tools"))

import decompile  # noqa: E402

# A large displacement in a base other than bp is an absolute address reached through a register.
INDEXED_ABSOLUTE = re.compile(r"\[\s*[a-z]+\s*\+\s*0x([0-9a-f]{1,4})\s*\]")
PURE_ABSOLUTE = re.compile(r"\[\s*(?:ds:)?0x[0-9a-f]{1,4}\s*\]")
CALLER_FRAME = "ss:[di"
# Anything at or above this is a program address, not a field of an addressed record.
FIELD_LIMIT = 0x100


def blockers(op_str: str) -> str | None:
    """Why this operand makes the body inexpressible, or None."""
    if CALLER_FRAME in op_str:
        return "caller frame"
    if PURE_ABSOLUTE.search(op_str):
        return "absolute address"
    match = INDEXED_ABSOLUTE.search(op_str)
    if match and int(match.group(1), 16) >= FIELD_LIMIT:
        return "indexed absolute"
    return None


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--max-bytes", type=int, default=0, help="only bodies up to this size")
    parser.add_argument("--unwritten", action="store_true",
                        help="list the units that carry no written body, with their totals")
    parser.add_argument("--segments", default="0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,"
                                             "18,19,20,21,22,23,24")
    args = parser.parse_args()
    wanted = {int(part) for part in args.segments.split(",") if part.strip()}

    if args.unwritten:
        # The units that carry no written body. This figure was quoted as "445 procedures"
        # for 160 rounds before it was recounted in round 451 at 792 across 16 units, because
        # nothing computed it; it is computed here.
        import gen_tree

        written = set(gen_tree._RECOVERED_FREE_BODIES)
        counted = []
        census = decompile.Image(ROOT / "original" / "holiday.exe")
        census_classes = decompile.form_classes_by_segment(census)
        for index in range(25):
            if index in written:
                continue
            found = list(decompile.discover(census.segments[index], census_classes.get(index, [])))
            if found:
                counted.append((index, len(found), sum(f.size for f in found)))
        print(f"units with no bodies: {len(counted)}")
        print(f"procedures: {sum(r[1] for r in counted)}  "
              f"bytes: {sum(r[2] for r in counted):,}")
        for index, procedures, size in counted:
            print(f"  segment {index:2d}: {procedures:3d} procedures, {size:6,} bytes")
        return 0

    image = decompile.Image(ROOT / "original" / "holiday.exe")
    classes = decompile.form_classes_by_segment(image)
    rows = []
    for index in sorted(wanted):
        if index >= len(image.segments):
            continue
        for function in decompile.discover(image.segments[index], classes.get(index, [])):
            body = list(decompile.procedure_body(image.segments[index], function))
            if any(blockers(step.op_str) for step in body):
                continue
            calls = sum(1 for step in body if step.mnemonic in ("call", "lcall"))
            if args.max_bytes and function.size > args.max_bytes:
                continue
            rows.append((function.size, calls, index, function.offset))
    rows.sort()
    print(f"expressible bodies: {len(rows)} (of which call-free: {sum(1 for r in rows if not r[1])})")
    for size, calls, index, offset in rows:
        print(f"  {index}:{offset:#06x} {size:4d}B {calls}c")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
