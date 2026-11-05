#!/usr/bin/env python3
"""reachable.py — which procedures can be byte-exact from an isolated probe.

The reconstruction campaign knows several ways in which this compiler's output differs from the
original's, and each one excludes bodies:

* **calls** — a probe's `lcall` goes to a different selector and a near `call`'s displacement
  depends on the probe's own layout, so a body with any call cannot match in isolation. This is
  the largest exclusion by far, and it is why whole-unit reconstruction, not single bodies, is
  the route to the program segments.
* **globals** — a bare `[0x....]` operand is a data-segment address; the probe's data segment is
  laid out differently.
* **indexed** — the same, with an index register (`[di + 0x6F8C]`).
* **loops** — a counted `for` loop emits `mov [bp-1], 1` with `jle` where the original's has 0 and
  `jne` (round 525), and no measured source form or setting changes it.
* **reloads** — a far-pointer parameter read from two separate statements is re-loaded here and
  was not in the original; `with` cures the reload but spills the base into the frame instead
  (rounds 524, 528, 531). A body whose *same* parameter slot is loaded more than once is written
  off here, which is the conservative reading of that difference.

Anything that survives all five is a candidate for an isolated reconstruction. The output is the
campaign's worklist, largest first.

    python3 tools/reachable.py               # the census and the list
    python3 tools/reachable.py --count       # the totals only
    python3 tools/reachable.py --within-unit # bodies whose calls all resolve inside their unit
"""

from __future__ import annotations

import argparse
import csv
import io
import json
import re
import sys
from collections import Counter
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

import decompile  # noqa: E402
import profile_proc  # noqa: E402

ROOT = Path(__file__).resolve().parent.parent
FLOOR = 0xA9          # the compiler's own first free data address (round 616)

ORIGINAL = ROOT / "original" / "holiday.exe"
WORKLIST = ROOT / "docs" / "worklist.csv"

#: `les di, ptr [bp + N]` — a far-pointer parameter load.
PARAM_LOAD = re.compile(r"les di, ptr \[bp \+ (0x[0-9a-f]+|\d+)\]")


def census(image=None) -> tuple[list[tuple], Counter]:
    """(reachable bodies, the reason each other body was excluded)."""
    image = image or decompile.Image(ORIGINAL)
    rows = list(csv.DictReader(io.StringIO(WORKLIST.read_text(encoding="utf-8"))))
    reachable: list[tuple] = []
    excluded: Counter = Counter()
    for row in rows:
        segment, offset = int(row["segment"]), int(row["offset"], 16)
        profile = profile_proc.profile(image, segment, offset)
        if not profile:
            continue
        if profile["calls"]:
            excluded["calls"] += 1
            continue
        if profile["globals"]:
            excluded["globals"] += 1
            continue
        if profile["indexed"]:
            excluded["indexed"] += 1
            continue
        functions = {f.offset: f for f in decompile.discover(image.segments[segment])}
        body = list(decompile.procedure_body(image.segments[segment], functions[offset]))
        if any(instruction.mnemonic.startswith("j")
               and instruction.op_str.startswith("0x")
               and _target(instruction) is not None
               and _target(instruction) < instruction.address
               for instruction in body):
            excluded["loop"] += 1
            continue
        text = " ".join(f"{i.mnemonic} {i.op_str}" for i in body)
        loads = PARAM_LOAD.findall(text)
        if len(loads) != len(set(loads)):
            excluded["reload"] += 1
            continue
        reachable.append((profile["size"], segment, offset, profile["instructions"],
                          profile["frame"]))
    reachable.sort(reverse=True)
    return reachable, excluded


def _function_at(image, segment: int, offset: int):
    """The discovered procedure at `segment:offset`."""
    classes = decompile.form_classes_by_segment(image)
    return {f.offset: f for f in decompile.discover(image.segments[segment],
                                                    classes.get(segment, []))}[offset]


def tight_census(image=None) -> tuple[list[tuple], Counter]:
    """Bodies needing nothing but the placement method: call-free, not indexed, globals above the floor.

    Round 624. The floor is the compiler's own first free data address, measured at `0xa9` (round 616),
    and a filler can only raise a symbol above it (round 615). Round 625 added the call rule: a body
    with *any* call instruction is out, resolved or not, because an unresolved near call looks like no
    call at all.
    """
    image = image or decompile.Image(ORIGINAL)
    rows = list(csv.DictReader(io.StringIO(WORKLIST.read_text(encoding="utf-8"))))
    ledger = json.loads((ROOT / "build" / "matched-procedures.json").read_text())["procedures"]
    recorded = {row["target"] for row in ledger}
    out: list[tuple] = []
    excluded: Counter = Counter()
    for row in rows:
        segment, offset = int(row["segment"]), int(row["offset"], 16)
        profile = profile_proc.profile(image, segment, offset)
        if not profile:
            continue
        if f"{segment}:{offset:#06x}" in recorded:
            excluded["already recorded"] += 1
            continue
        if profile["indexed"]:
            excluded["indexed/indirect"] += 1
            continue
        addresses = [g[0] if isinstance(g, (tuple, list)) else g for g in profile["globals"]]
        if addresses and min(addresses) < FLOOR:
            excluded["below the floor"] += 1
            continue
        body = decompile.procedure_body(image.segments[segment],
                                        _function_at(image, segment, offset))
        if any(ins.mnemonic in ("call", "lcall") for ins in body) or profile["calls"]:
            excluded["has a call"] += 1
            continue
        out.append((profile["size"], segment, offset, addresses))
    out.sort(reverse=True)
    return out, excluded


def within_unit_census(image=None) -> tuple[list[tuple], Counter]:
    """Bodies reachable from a probe that links their **whole unit**.

    The isolated census excludes any body with a call, because a probe's far call goes to a selector
    that cannot match. A probe that compiles the unit itself resolves the unit's *internal* calls the
    way the original did, so only calls that leave the unit are out of reach — and the exclusion list
    changes shape: data addresses become the dominant obstacle (round 608).
    """
    image = image or decompile.Image(ORIGINAL)
    rows = list(csv.DictReader(io.StringIO(WORKLIST.read_text(encoding="utf-8"))))
    entries: dict[int, set[int]] = {}
    for row in rows:
        entries.setdefault(int(row["segment"]), set()).add(int(row["offset"], 16))
    reachable: list[tuple] = []
    excluded: Counter = Counter()
    for row in rows:
        segment, offset = int(row["segment"]), int(row["offset"], 16)
        profile = profile_proc.profile(image, segment, offset)
        if not profile:
            continue
        # Split, because they are different blockers with different methods (round 610): absolute
        # data addresses are what `tools/place_global.py` reproduces, while indexed/indirect uses
        # (virtual calls through a VMT) need the class declared.
        has_data, has_indirect = bool(profile["globals"]), bool(profile["indexed"])
        if has_data or has_indirect:
            if has_data and has_indirect:
                excluded["absolute data AND indexed/indirect"] += 1
            elif has_data:
                excluded["absolute data only"] += 1
            else:
                excluded["indexed/indirect only"] += 1
            continue
        # A call whose target is an unresolved relocation resolves to nothing, so counting
        # `profile["calls"]` misses it: `22:0x0002` shows `far calls: none` while containing `call 2`.
        # Any call instruction at all rules a body out of the call-free set (round 625).
        body = decompile.procedure_body(image.segments[segment],
                                        _function_at(image, segment, offset))
        call_instructions = [ins for ins in body if ins.mnemonic in ("call", "lcall")]
        calls = dict(profile["calls"])
        if call_instructions or calls:
            excluded["calls (unresolved near call)"] += 1
            continue
        if any(int(target, 16) not in entries[segment] for target in calls):
            excluded["calls outside the unit"] += 1
            continue
        reachable.append((profile["size"], segment, offset, len(calls)))
    reachable.sort(reverse=True)
    return reachable, excluded


def _target(instruction) -> int | None:
    try:
        return int(instruction.op_str.split()[0], 16)
    except ValueError:
        return None


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--count", action="store_true", help="totals only")
    parser.add_argument("--within-unit", action="store_true",
                        help="count bodies whose calls all resolve inside their own unit")
    parser.add_argument("--limit", type=int, default=20)
    args = parser.parse_args()

    if args.within_unit:
        reachable, excluded = within_unit_census()
        print(f"reachable from a unit-level probe: {len(reachable)} procedures, "
              f"{sum(size for size, *_ in reachable)} bytes")
        print("excluded: " + ", ".join(f"{reason} {count}"
                                      for reason, count in excluded.most_common()))
        if not args.count:
            for size, segment, offset, calls in reachable[:args.limit]:
                print(f"  {segment}:{offset:#06x}  {size:4d} bytes  {calls} intra-unit call(s)")
        return 0
    reachable, excluded = census()
    print(f"reachable from an isolated probe: {len(reachable)} procedures, "
          f"{sum(size for size, *_ in reachable)} bytes")
    print("excluded: " + ", ".join(f"{reason} {count}" for reason, count in excluded.most_common()))
    if not args.count:
        for size, segment, offset, instructions, frame in reachable[:args.limit]:
            print(f"  {segment}:{offset:#06x}  {size:4d} bytes  {instructions:3d} insns  {frame!r}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
