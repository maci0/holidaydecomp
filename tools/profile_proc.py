#!/usr/bin/env python3
"""Print everything the toolchain can say about one procedure.

Nine rounds have profiled a procedure by hand — frame, parameters, globals, calls,
strides, dispatch — and each round rewrote the same scan. This is that scan once.

`globals` holds direct absolute operands only. An indexed read,
`add ax, word ptr [di + 0x3C2E]`, is printed on its own `indexed` line as
(register, table base, sites), because it names a table and an index rather than
one address; `tables` holds jump tables, not data tables.

    python3 tools/profile_proc.py 12:0x2404
    python3 tools/profile_proc.py --largest-undocumented 6
"""

from __future__ import annotations

import argparse
import collections
import re
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

import capstone  # noqa: E402
import decompile  # noqa: E402

ROOT = Path(__file__).resolve().parent.parent


_SEGMENTS_BY_OFFSET: dict = {}


def segments_by_offset(image) -> dict:
    """offset -> the set of segments holding a procedure there.

    A profile's call list gives offsets, and whether a call is near or far is only
    known once the target is matched against the entry tables (round 301). This is
    that match, computed once per image.
    """
    key = getattr(image, "source", None)
    if key in _SEGMENTS_BY_OFFSET:
        return _SEGMENTS_BY_OFFSET[key]
    found: dict[int, set] = {}
    classes = decompile.form_classes_by_segment(image)
    for index in range(25):
        for function in decompile.discover(image.segments[index], classes.get(index, [])):
            found.setdefault(function.offset, set()).add(index)
    _SEGMENTS_BY_OFFSET[key] = found
    return found


#: The lowest displacement that can be a data-segment address rather than a record
#: field: the game's globals start above 0x400 and its record fields sit below 0x28.
INDEXED_FLOOR = 0x100

PARAMETER_LIMIT = 0x30   # 24 arguments: wider than any procedure in this program


def profile(image, segment: int, offset: int) -> dict:
    """Everything measurable about one procedure, by address."""
    functions = {
        function.offset: function for function in decompile.discover(image.segments[segment])
    }
    function = functions.get(offset)
    if function is None:
        return {}
    body = decompile.procedure_body(image.segments[segment], function)
    engine = decompile.engine()          # for `reg_name`, to label indexed accesses
    counts: collections.Counter = collections.Counter()
    fields: collections.Counter = collections.Counter()
    parameters: collections.Counter = collections.Counter()
    locals_: collections.Counter = collections.Counter()
    globals_: collections.Counter = collections.Counter()
    indexed: collections.Counter = collections.Counter()
    calls: collections.Counter = collections.Counter()
    indirect = collections.Counter()
    strides: collections.Counter = collections.Counter()
    selectors: collections.Counter = collections.Counter()
    placeholders: collections.Counter = collections.Counter()
    helpers = {"lmul": 0, "ldiv": 0}
    loops = 0
    implausible = collections.Counter()
    for ins in body:
        counts[ins.mnemonic] += 1
        if ins.mnemonic.startswith("j") and ins.op_str.startswith("0x"):
            try:
                if int(ins.op_str, 16) < ins.address:
                    loops += 1
            except ValueError:
                pass
        if ins.mnemonic == "imul":
            match = re.search(r"imul \w+, \w+, (0x[0-9a-f]+|\d+)$",
                              f"{ins.mnemonic} {ins.op_str}")
            if match:
                strides[int(match.group(1), 0)] += 1
        if ins.mnemonic in ("call", "lcall"):
            target = ins.op_str.split(", ")[-1]
            if target.startswith("["):
                indirect[ins.op_str.split("]")[0] + "]"] += 1
            elif target.startswith("0x"):
                # Group by *offset* so the counts stay meaningful (a far call's op_str
                # is `selector, offset`, and grouping by the pair splits one routine
                # across as many buckets as it has call sites — round 231). The
                # distinct selectors are collected separately, because the same offset
                # in two units is two different routines.
                calls[target] += 1
                if ins.mnemonic == "lcall":
                    selectors[ins.op_str.split(", ")[0]] += 1
                    if target.lower() in ("0xffff", "0x0"):
                        # the loader fills this one in from the relocation table
                        placeholders[ins.op_str.split(", ")[0]] += 1
                if target == "0x14a4":
                    helpers["lmul"] += 1
                if target == "0x14e1":
                    helpers["ldiv"] += 1
        for operand in ins.operands:
            if operand.type != capstone.x86.X86_OP_MEM:
                continue
            displacement = operand.mem.disp or 0
            base_name = engine.reg_name(operand.mem.base)
            if operand.mem.base == capstone.x86.X86_REG_BP:
                if 0 < displacement <= PARAMETER_LIMIT:
                    parameters[displacement] += 1
                elif displacement > PARAMETER_LIMIT:
                    # A linear scan runs past a procedure's own `ret` into the blob
                    # that follows it, and for eight procedures in this image the
                    # bytes there decoded into fake `[bp+N]` accesses at offsets up
                    # to 0x7C (round 376). A real argument cannot sit that far above
                    # `bp` — the widest procedure in this program takes eight — so
                    # they are counted apart instead of silently believed.
                    implausible[displacement] += 1
                elif displacement < 0:
                    locals_[-displacement] += 1
            elif operand.mem.base == capstone.x86.X86_REG_DI and 0 < displacement < 0x28:
                fields[displacement] += 1
            elif (operand.mem.base not in (capstone.x86.X86_REG_BP, 0)
                  and displacement >= INDEXED_FLOOR):
                # An **indexed** data access — `mov ax, [di + 0x6F8C]` — is not a
                # bare `[0x...]` and its displacement is far past the record fields
                # the `fields` arm keeps, so before round 511 it fell through and was
                # counted nowhere. Three bodies in `SEG15` are exactly this shape
                # (an index times 4 into one of three arrays) and profiled as having
                # no global at all. Counted here as (base register, displacement).
                indexed[(base_name, displacement)] += 1
        # One to four hex digits: the data segment starts at DGROUP 0, so its low
        # part holds real globals whose addresses are shorter than four digits.
        # Requiring exactly four hid **140 procedures, 612 sites and 61 addresses**
        # below 0x1000 (round 416) — `[0x7C]` alone is read 290 times, making it one
        # of the most-referenced globals in the image.
        for match in re.findall(r"\[(0x[0-9a-f]{1,4})\]", ins.op_str):
            globals_[int(match, 16)] += 1
    tables = {}
    for table in decompile.jump_tables(image):
        if table["segment"] != segment:
            continue
        site = table.get("site") or -1
        if function.offset <= site < function.end:
            tables[table["table"]] = len(table["entries"])
    return {
        "segment": segment,
        "offset": offset,
        "size": function.size,
        "instructions": len(body),
        "frame": decompile.disasm_first(body),
        "parameters": sorted(parameters),
        "parameter_uses": dict(parameters),
        "locals": len(locals_),
        "locals_bytes": max(locals_, default=0),
        "implausible_parameters": implausible.most_common(4),
        "implausible_sites": sum(implausible.values()),
        # The lists are capped so a profile stays readable, and the totals are
        # reported beside them because the cap is otherwise invisible: `2:0x254D`
        # makes **nine** calls and `0:0x1EA0` writes **57** globals, and a reader of
        # `calls`/`globals` alone would see eight of each (round 420).
        "globals": globals_.most_common(8),
        "distinct_globals": len(globals_),
        "global_sites": sum(globals_.values()),
        "indexed": indexed.most_common(8),
        "distinct_indexed": len(indexed),
        "indexed_sites": sum(indexed.values()),
        "calls": calls.most_common(8),
        "distinct_callees": len(calls),
        "call_sites": sum(calls.values()),
        "call_units": {
            target: sorted(segments_by_offset(image).get(int(target, 16), set()))
            for target, _count in calls.most_common(8)
        },
        "selectors": selectors.most_common(6),
        "distinct_selectors": len(selectors),
        "selector_sites": sum(selectors.values()),
        "indirect": indirect.most_common(4),
        "distinct_indirect": len(indirect),
        "indirect_sites": sum(indirect.values()),
        "strides": strides.most_common(4),
        "distinct_strides": len(strides),
        "stride_sites": sum(strides.values()),
        "fields": fields.most_common(8),
        "distinct_fields": len(fields),
        "field_sites": sum(fields.values()),
        "helpers": helpers,
        # Far calls whose target offset is the `0xFFFF` placeholder are resolved by
        # the loader from the relocation table, not from the file. They are counted
        # separately so a reader does not mistake the placeholder for a callee
        # (round 363: 59 such sites in 42 procedures).
        "placeholders": placeholders.most_common(4),
        "distinct_placeholders": len(placeholders),
        "placeholder_sites": sum(placeholders.values()),
        # A backward jump is the one unambiguous mark of a loop in this compiler's
        # output. Rounds 353-356 used it to correct three procedures the documents
        # called loops; it is here so no later round has to add it again.
        "loops": loops,
        "tables": tables,
        "returns": [f"{i.mnemonic} {i.op_str}" for i in body if i.mnemonic in
                    ("ret", "retf", "leave")],
    }


def show(result: dict) -> int:
    if not result:
        print("no procedure at that address")
        return 1
    print(f"{result['segment']}:{result['offset']:#06x}  "
          f"{result['size']} bytes, {result['instructions']} instructions")
    print(f"  frame        {result['frame']}")
    print(f"  parameters   {[hex(p) for p in result['parameters']]}  "
          f"uses {result['parameter_uses']}")
    print(f"  locals       {result['locals']} slots, deepest {result['locals_bytes']:#x}")
    print(f"  returns      {result['returns'][:6]}")
    # The lists are capped at eight (round 420), so the totals travel with them:
    # `1:0x1BF7` reads 74 globals and a reader of the list alone would see eight.
    print(f"  calls        {result['calls']}  "
          f"({result['distinct_callees']} distinct, {result['call_sites']} sites)")
    print(f"  call units   {result['call_units']}")
    print(f"  indirect     {result['indirect']}")
    print(f"  helpers      32-bit: {result['helpers']}")
    print(f"  strides      {[(hex(k), v) for k, v in result['strides']]}")
    print(f"  object fields {[(hex(k), v) for k, v in result['fields']]}")
    print(f"  globals      {[(hex(a), n) for a, n in result['globals']]}  "
          f"({result['distinct_globals']} distinct, {result['global_sites']} sites, "
          f"direct operands only)")
    # An indexed read, `add ax, word ptr [di + 0x3C2E]`, names a table base and an
    # index, not one address, so it is not a global and never reaches `tables`
    # (which holds jump tables). seg17's survey of `4f4f` called the body clean
    # because this line was not printed: the body reads 0x3C2E and 0x3C30 through
    # `di` twenty-eight times between them.
    print(f"  indexed      {[(base, hex(disp), n) for (base, disp), n in result['indexed']]}  "
          f"({result['distinct_indexed']} distinct, {result['indexed_sites']} sites, "
          f"table reads through a register)")
    print(f"  tables       {[(hex(k), v) for k, v in result['tables'].items()]}")
    return 0


def loop_signature(result: dict) -> str:
    """The strongest loop evidence in a profile: repeated call counts.

    A helper called the same number of times as the parameter with the most uses is
    a loop over that many items — how `12:0x0ED0` (three helpers, 26 times each) and
    `14:0x210A` (the money formatter) were read in round 225. This turns that reading
    into one line per procedure.
    """
    if not result:
        return ""
    repeated = [(int(target, 16), count) for target, count in result["calls"] if count >= 5]
    if not repeated:
        if result["strides"]:
            stride, count = result["strides"][0]
            return f"array walk x{count} at stride {stride:#x}"
        return "no repetition"
    best = max(repeated, key=lambda item: item[1])
    return f"calls {best[0]:#06x} x{best[1]}"


def main() -> int:
    parser = argparse.ArgumentParser(description="Profile one procedure")
    parser.add_argument("address", nargs="?", help="segment:offset, in hex")
    parser.add_argument("--largest-undocumented", type=int, default=0)
    parser.add_argument("--loop-signatures", type=int, default=0,
                        help="print a one-line signature for the N largest unread")
    args = parser.parse_args()
    image = decompile.Image(ROOT / "original" / "holiday.exe")
    if args.loop_signatures:
        import csv as _csv

        rows = list(_csv.DictReader((ROOT / "docs" / "worklist.csv").open()))
        on_worklist = {(int(r["segment"]), int(r["offset"], 16)) for r in rows}
        documented = {
            (int(r["segment"]), int(r["offset"], 16))
            for r in rows if r["documented"] == "yes"
        }
        classes = decompile.form_classes_by_segment(image)
        # Unread means on the worklist and not documented, the set the
        # tests check: a procedure a reviewed extent fold folded into its
        # neighbour is not an unread body, it is not on the worklist.
        unread = sorted(
            (
                (function.size, index, function.offset)
                for index, segment in enumerate(image.segments)
                if index <= 24
                for function in decompile.discover(segment, classes.get(index, []))
                if (index, function.offset) in on_worklist
                and (index, function.offset) not in documented
            ),
            reverse=True,
        )[: args.loop_signatures]
        for size, index, offset in unread:
            result = profile(image, index, offset)
            print(f"{index}:{offset:#06x} {size:5d}  {loop_signature(result)}")
        return 0
    if args.largest_undocumented:
        rows = list(__import__("csv").DictReader((ROOT / "docs" / "worklist.csv").open()))
        on_worklist = {(int(r["segment"]), int(r["offset"], 16)) for r in rows}
        documented = {
            (int(r["segment"]), int(r["offset"], 16))
            for r in rows if r["documented"] == "yes"
        }
        classes = decompile.form_classes_by_segment(image)
        # same rule as --loop-signatures: a folded tail is off the
        # worklist, so it is not an undocumented body either.
        sized = sorted(
            (
                (function.size, index, function.offset)
                for index, segment in enumerate(image.segments)
                if index <= 24
                for function in decompile.discover(segment, classes.get(index, []))
                if (index, function.offset) in on_worklist
                and (index, function.offset) not in documented
            ),
            reverse=True,
        )[: args.largest_undocumented]
        for size, index, offset in sized:
            print(f"{index}:{offset:#06x} {size} bytes")
        return 0
    if not args.address:
        parser.error("give an address, or --largest-undocumented N")
    segment, _, offset = args.address.partition(":")
    return show(profile(image, int(segment, 0), int(offset, 0)))


if __name__ == "__main__":
    raise SystemExit(main())
