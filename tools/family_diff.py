#!/usr/bin/env python3
"""Which same-size procedures are copies of one another, and where they differ.

Round 310 showed that a profile cannot group families: a template instantiation
differs from its siblings in an **operand**, and operands are what a profile
summarises away. This is the instrument that can — byte-diff the members of each
exact-size family and report where they differ.

    python3 tools/family_diff.py [--min-size 50] [--min-members 3]
"""

from __future__ import annotations

import argparse
import collections
import re
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

import decompile  # noqa: E402

ROOT = Path(__file__).resolve().parent.parent
ORIGINAL = ROOT / "original" / "holiday.exe"
PROGRAM_SEGMENTS = 25


def families(image, min_size: int, min_members: int) -> dict:
    found: dict[int, list] = collections.defaultdict(list)
    classes = decompile.form_classes_by_segment(image)
    for index in range(PROGRAM_SEGMENTS):
        for function in decompile.discover(image.segments[index], classes.get(index, [])):
            if function.size >= min_size:
                found[function.size].append((index, function.offset))
    return {
        size: members
        for size, members in found.items()
        if len(members) >= min_members
    }


def diff(image, members: list, size: int) -> dict:
    """Where each member differs from the family's modal member.

    The base is a member from the segment that holds most of the family, not
    simply the first discovered: a same-size procedure from another unit can
    land in the list and differ from all the real copies in nearly every byte
    (round 311 learned that the hard way).
    """
    modal_segment = collections.Counter(segment for segment, _o in members).most_common(1)[0][0]
    base_segment, base_offset = next(m for m in members if m[0] == modal_segment)
    ordered = [(base_segment, base_offset)] + [m for m in members if m != (base_segment, base_offset)]
    base = image.segments[base_segment].data[base_offset : base_offset + size]
    rows = []
    for segment, offset in ordered[1:]:
        other = image.segments[segment].data[offset : offset + size]
        positions = [i for i in range(min(len(base), len(other))) if base[i] != other[i]]
        rows.append((segment, offset, positions))
    return {"base": ordered[0], "rows": rows}


NUMBER = re.compile(r"-?0x[0-9a-f]+|\b\d+\b")


def shape_key(body: list) -> str:
    """A procedure's instruction shape: mnemonics and operand kinds, numbers masked."""
    parts = []
    for instruction in body:
        if instruction.mnemonic in ("lcall", "ljmp"):
            parts.append(f"{instruction.mnemonic} <far>")
        else:
            parts.append(f"{instruction.mnemonic} {NUMBER.sub('#', instruction.op_str)}".strip())
    return "\n".join(parts)


def visible(instruction) -> str:
    """The same instruction with **small** immediates kept.

    A number at or above 0x100 is an address or a displacement and moves with the
    layout; a `push 1` against a `push 2` is the whole difference between two family
    members and has to stay visible, or every clone family reads as identical.
    """
    if instruction.mnemonic in ("lcall", "ljmp"):
        return f"{instruction.mnemonic} <far>"
    def replace(match: "re.Match[str]") -> str:
        value = match.group(0).lstrip("-")
        number = int(value, 16) if value.startswith("0x") else int(value)
        return "#" if number >= 0x100 else match.group(0)

    return f"{instruction.mnemonic} {NUMBER.sub(replace, instruction.op_str)}".strip()


def shape_families(image, min_members: int = 2, min_size: int = 0) -> dict:
    """Procedures with the same instruction *shape*, whatever their size.

    The size-based census above cannot see a family whose members are different
    lengths, and it also counts same-size procedures that share nothing. Grouping by
    shape is tight: measured 2026-10-14 it finds **117 families and 41 396 bytes** where
    the same-size rule finds 249 families and 157 619 bytes, of which 14 families and
    4 793 bytes have members of *differing* sizes that only this rule can see.
    """
    classes = decompile.form_classes_by_segment(image)
    found: dict[str, list] = collections.defaultdict(list)
    for index in range(PROGRAM_SEGMENTS):
        for function in decompile.discover(image.segments[index], classes.get(index, [])):
            if function.size < min_size:
                continue
            body = list(decompile.procedure_body(image.segments[index], function))
            if body:
                found[shape_key(body)].append((index, function.offset, function.size))
    return {key: members for key, members in found.items() if len(members) >= min_members}


def shape_diff(image, members: list) -> list:
    """Where each member's *visible* instruction stream differs from the modal member's."""
    modal = collections.Counter(segment for segment, _o, _s in members).most_common(1)[0][0]
    ordered = sorted(members, key=lambda row: (row[0] != modal, row[0], row[1]))
    classes = decompile.form_classes_by_segment(image)
    bodies = []
    for segment, offset, _size in ordered:
        function = next(f for f in decompile.discover(image.segments[segment],
                                                     classes.get(segment, []))
                        if f.offset == offset)
        bodies.append([visible(i) for i in decompile.procedure_body(image.segments[segment],
                                                                    function)])
    base = bodies[0]
    rows = []
    for (segment, offset, size), other in zip(ordered[1:], bodies[1:]):
        shared = min(len(base), len(other))
        differing = [(index, base[index], other[index])
                     for index in range(shared) if base[index] != other[index]]
        if len(base) != len(other):
            differing.append((shared, f"{len(base)} instructions", f"{len(other)} instructions"))
        rows.append((segment, offset, size, differing))
    return rows


LEDGER = ROOT / "build" / "matched-procedures.json"


def family_coverage(image, ledger: Path = LEDGER) -> dict:
    """How much of the family census the ledger has already landed.

    Measured 2026-10-14: 117 shape families, and **55 of the ledger's 103 byte-exact entries
    are family members**, so the campaign has been landing families all along (the 28-member
    seven-byte set, the `6:0x3F80` set and others). **105 families and 40 116 bytes are
    untouched**, and they are the hard set: every untouched family with no calls reads a
    global that a probe has to place, and the one that needs neither is
    `22:0x025B`/`22:0x0ACE`, which the documents already record as blocked.

    The key format matters and was wrong once: the ledger spells a target `6:0x0382`, zero
    padded to four digits, so a lookup that used `#x` counted six landed families as untouched.
    """
    import json

    found = shape_families(image, min_members=2)
    exact: set[str] = set()
    if ledger.is_file():
        rows = json.loads(ledger.read_text(encoding="utf-8"))["procedures"]
        exact = {row["target"] for row in rows if row["verdict"] == "byte-exact"}
    classes = decompile.form_classes_by_segment(image)
    targets = decompile.call_targets(image)
    # `calls` counts call *instructions* and `callees` their resolved targets separately. An
    # unresolved far call resolves to nothing, and a classification that reads only the
    # resolved list calls such a body call-free: round 625 found that on `22:0x0002`, whose
    # `call 2` is a relocation.
    callees: dict[tuple[int, int], tuple[int, list]] = {}
    for segment in image.program_segments():
        for function in decompile.discover(segment, classes.get(segment.index, [])):
            # both kinds: a near `call` has no resolved far target either, so counting only
            # `lcall` classed `12:0x0224` and `5:0x3D25` as call-free while `profile_proc`
            # counted a call site in each. That is round 625's trap in its third form.
            found_calls = [targets.get((segment.index, instruction.address))
                           for instruction in decompile.procedure_body(segment, function)
                           if instruction.mnemonic in ("call", "lcall")]
            callees[(segment.index, function.offset)] = (len(found_calls), found_calls)

    # Does any landed body contain a call at all? Measured 2026-10-14: none does, which is
    # what makes the "unit_local" bucket below a hope rather than a worklist. A far call's
    # segment half is image-specific, so a probe cannot reproduce it, and a whole-unit probe
    # changes the body's own position and with it every displacement.
    ledger_with_calls = 0
    for key in exact:
        segment_text, offset_text = key.split(":")
        segment, offset = int(segment_text), int(offset_text, 16)
        function = next((f for f in decompile.discover(image.segments[segment],
                                                        classes.get(segment, []))
                         if f.offset == offset), None)
        if function is None:
            continue
        mnemonics = {instruction.mnemonic
                     for instruction in decompile.procedure_body(image.segments[segment],
                                                                 function)}
        if "call" in mnemonics or "lcall" in mnemonics:
            ledger_with_calls += 1

    untouched, untouched_bytes, landed_members = 0, 0, 0
    easy_untouched: list[list[str]] = []
    by_class: dict[str, list[int]] = {"no_calls": [0, 0], "unit_local": [0, 0],
                                      "crosses_units": [0, 0]}
    best_unit_local: list[tuple[int, int, list]] = []
    for members in found.values():
        landed = sum(1 for segment, offset, _size in members
                     if f"{segment}:0x{offset:04x}" in exact)
        landed_members += landed
        if landed:
            continue
        size = sum(m[2] for m in members)
        untouched += 1
        untouched_bytes += size
        # the shape is identical across members, so the first member's call sites stand for
        # the family; what a call *resolves to* can differ, and the test over all members
        # would cost a second full disassembly for no gain here
        first_segment, first_offset, _first_size = members[0]
        count, resolved = callees.get((first_segment, first_offset), (0, []))
        if not count:
            kind = "no_calls"
        elif len(resolved) == count and all(callee == first_segment for callee in resolved):
            kind = "unit_local"
        else:
            kind = "crosses_units"
        by_class[kind][0] += 1
        by_class[kind][1] += size
        if kind == "unit_local":
            best_unit_local.append((size, len(members), members))
        # the class that needs nothing placed and nothing linked: no call instruction and
        # no absolute data address. `profile_proc` counts call *sites* (round 625: its
        # resolved-target list reports an unresolved call as nothing).
        if kind == "no_calls":
            import profile_proc

            profile = profile_proc.profile(image, first_segment, first_offset)
            if (profile and not profile["globals"] and not profile["indexed"]
                    and not profile["indirect"]):
                easy_untouched.append(sorted(f"{s}:0x{o:04x}" for s, o, _z in members))
    best_unit_local.sort(reverse=True)
    return {
        "families": len(found),
        "family_bytes": sum(sum(m[2] for m in members) for members in found.values()),
        "untouched_families": untouched,
        "untouched_bytes": untouched_bytes,
        "landed_members": landed_members,
        "ledger_entries": len(exact),
        "untouched_by_class": {name: tuple(value) for name, value in by_class.items()},
        "ledger_entries_with_calls": ledger_with_calls,
        "easy_untouched": sorted(easy_untouched),
        "largest_unit_local": [
            (size, count, [f"{s}:0x{o:04x}" for s, o, _z in members])
            for size, count, members in best_unit_local[:3]
        ],
    }


def summarise(rows: list) -> str:
    counts = sorted({len(positions) for _s, _o, positions in rows})
    if counts == [0]:
        return "identical"
    if len(counts) == 1:
        return f"differs in {counts[0]} byte(s) in every copy"
    return f"differs in {counts[0]}..{counts[-1]} bytes"


def main() -> int:
    parser = argparse.ArgumentParser(description="Byte-diff same-size procedure families")
    parser.add_argument("--min-size", type=int, default=50)
    parser.add_argument("--min-members", type=int, default=3)
    parser.add_argument("--by-shape", action="store_true",
                        help="group by instruction shape instead of exact size")
    args = parser.parse_args()
    image = decompile.Image(ORIGINAL)
    if args.by_shape:
        return by_shape(image, args.min_members)
    found = families(image, args.min_size, args.min_members)
    copies = 0
    for size, members in sorted(found.items(), key=lambda kv: (-len(kv[1]), -kv[0]))[:15]:
        result = diff(image, members, size)
        if all(not positions for _s, _o, positions in result["rows"]):
            copies += 1
        print(f"{size:5d} bytes x{len(members):2d}: {summarise(result['rows'])}")
        for segment, offset, positions in result["rows"][:3]:
            shown = ", ".join(f"+0x{p:x}" for p in positions[:6])
            print(f"        {segment}:0x{offset:04x} differs at {shown}"
                  + (" ..." if len(positions) > 6 else ""))
    print(f"\n{len(found)} families; {copies} of the top fifteen are byte-identical copies")
    return 0


def by_shape(image, min_members: int) -> int:
    found = shape_families(image, min_members)
    sizes = {key: sum(size for _s, _o, size in members) for key, members in found.items()}
    mixed = [key for key, members in found.items() if len({m[2] for m in members}) > 1]
    print(f"{len(found)} shape families (>= {min_members} members), "
          f"{sum(sizes.values())} bytes; {len(mixed)} have members of different sizes")
    coverage = family_coverage(image)
    print(f"ledger coverage: {coverage['landed_members']} of its "
          f"{coverage['ledger_entries']} byte-exact entries are family members; "
          f"{coverage['untouched_families']} families and {coverage['untouched_bytes']} "
          f"bytes untouched")
    for name, (count, size) in sorted(coverage["untouched_by_class"].items()):
        print(f"  untouched, {name:14s} {count:3d} families, {size:6d} bytes")
    print(f"  landed bodies containing a call: {coverage['ledger_entries_with_calls']} "
          f"of {coverage['ledger_entries']} (a call has never been reproduced)")
    print(f"  untouched families needing nothing placed and nothing linked: "
          f"{len(coverage['easy_untouched'])}")
    for members in coverage["easy_untouched"]:
        print(f"    {', '.join(members)}")
    for size, count, members in coverage["largest_unit_local"]:
        print(f"  unit-local: {size} bytes, {count} members of {members[0]}")
    for key, _members in sorted(found.items(), key=lambda kv: -sizes[kv[0]])[:12]:
        members = found[key]
        rows = shape_diff(image, members)
        worst = max((len(row[3]) for row in rows), default=0)
        addresses = ", ".join(f"{s}:{o:#06x}" for s, o, _z in members[:3])
        print(f"  {len(members):3d} members {sizes[key]:6d} bytes, worst difference "
              f"{worst} instruction(s): {addresses}{' ...' if len(members) > 3 else ''}")
        for index, (_s, _o, _z, differing) in enumerate(rows[:2]):
            for position, before, after in differing[:3]:
                print(f"        #{position}: {before}  vs  {after}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
