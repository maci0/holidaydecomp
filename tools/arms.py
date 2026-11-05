#!/usr/bin/env python3
"""arms.py — print a decision-table body as one line per leaf, with the guards that select it.

    python3 tools/arms.py 22:0x424F
    python3 tools/arms.py 22:0x424F --store "[bp - 3]"

The bodies in the queue are structured compiler output, so the guards form a tree that can be read off
the linear instruction order: a `cmp`/`jne T` pair means "the path that follows holds when the
comparison is equal, and the path at T holds when it is not", and a leaf is a store of a constant.
Walking the order with a stack of pending negations therefore recovers each leaf's guard path without
a general control-flow reconstruction — which matters because 29 of them in one body is a table, and a
table should be emitted by a generator rather than transcribed by hand.
"""

from __future__ import annotations

import argparse
import re
import sys
from collections import Counter
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))

import decompile  # noqa: E402


def char_code(value: str) -> str:
    """`#N` for a byte constant, so a `Char` comparison or store type-checks.

    Pascal spells a character code in DECIMAL (`#255`), not hex, and the disassembler prints the
    constant as `0x...`. Round 683: without this the decision-table output cannot be used for a body
    whose operands D1 keeps in a register, which needs `Char` rather than `Byte` (round 682).
    """
    try:
        number = int(value, 0)
    except ValueError:
        return value
    return f"#{number}"


def operand_guard(instruction) -> tuple[str, str] | None:
    """(lhs, rhs) for a `cmp` whose left side is not `al`.

    The name keeps the addressing mode, so a reader can see which record and which field a guard is
    about, and the caller declares the type the name refers to.
    """
    match = re.fullmatch(r"(byte ptr |word ptr )?(.+),\s*(.+)$", instruction.op_str)
    if not match or instruction.mnemonic != "cmp":
        return None
    size, lhs, rhs = match.group(1) or "", match.group(2).strip(), match.group(3).strip()
    if lhs == "al":                       # handled by the two-instruction window below
        return None
    memory = re.fullmatch(r"(es|ss|ds):\[di(?: ([+-]) (0x[0-9a-f]+|\d+))?\]", lhs)
    if memory:
        base = "es" if memory.group(1) == "es" else "ss"
        offset = memory.group(3) or "0"
        sign = memory.group(2) or "+"
        lhs = f"{base}[di{'' if sign == '+' and offset == '0' else f' {sign} {offset}'}]"
    return f"{size}{lhs}", rhs


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("target", help="SEGMENT:OFFSET, e.g. 22:0x424F")
    parser.add_argument("--store", default=None,
                        help="regex for the result slot's operand; detected when omitted")
    parser.add_argument("--binary", type=Path, default=None)
    parser.add_argument("--pascal", action="store_true",
                        help="emit the leaf table as nested `if` source, one store per leaf")
    parser.add_argument("--result", default="Result", help="name for the slot the leaves store into")
    parser.add_argument("--case", action="store_true",
                        help="emit the tree as nested `case` statements, the shape D1 gives a selector")
    parser.add_argument("--chars", action="store_true",
                        help="render constants as Pascal character codes (#N) for Char operands")
    args = parser.parse_args()

    match = re.fullmatch(r"(\d+):(0x[0-9a-fA-F]+|\d+)", args.target)
    if not match:
        raise SystemExit("target must look like 22:0x424F")
    segment, offset = int(match.group(1)), int(match.group(2), 0)
    image = decompile.Image(args.binary or decompile.ORIGINAL)
    classes = decompile.form_classes_by_segment(image)
    function = {f.offset: f for f in decompile.discover(image.segments[segment],
                                                        classes.get(segment, []))}[offset]
    body = decompile.procedure_body(image.segments[segment], function)
    # Detect the result slot when none is given: the local that the body stores constants into most
    # often is the decision table's result. Round 696 found every other queue body reporting zero leaves
    # because a slot hard-coded for `22:0x424f` was carried into bodies that use a different one.
    if args.store is None:
        counts: Counter[str] = Counter()
        for instruction in body:
            found = re.fullmatch(r"mov (?:byte|word) ptr (\[bp [-+] (?:0x[0-9a-f]+|\d+)\]), "
                                 r"(?:0x[0-9a-f]+|\d+)",
                                 f"{instruction.mnemonic} {instruction.op_str}")
            if found:
                counts[found.group(1)] += 1
        if not counts:
            raise SystemExit("no constant store found; pass --store")
        slot = counts.most_common(1)[0][0]
        args.store = re.escape(slot)
        print(f"result slot: {slot}")
    store = re.compile(rf"mov\s+byte ptr {args.store},\s*(\S+)$")
    # The comparison and its branch are two instructions, so the constant is carried across them
    # rather than searched for in the branch's own operand.
    comment = re.compile(r"cmp\s+al,\s*(0x[0-9a-f]+|\d+)$")
    # A guard can compare a memory operand rather than `al`: `cmp byte ptr es:[di + 4], 0xff` is a
    # record field, and `cmp ax, dx` a register. Round 626 read a body whose guards are all of that
    # kind, and round 627 names them instead of dropping them (see `operand_guard`).
    out: list[tuple[str, list[str]]] = []
    # The `al` source map is a PER-PATH fact, so it travels with the pending stack: a load that
    # happens inside one branch must not rename a comparison that another branch reaches. Round 674
    # measured `22:0x424f`, where offset 99 is reached only by the `jne` at 74 and its `al` is still
    # `B2` even though the other branch loaded `B1` at 76 in between.
    pending: list[tuple[int, str, list[str], dict[str, str]]] = []
    path: list[str] = []
    previous_constant: str | None = None
    previous_guard: tuple[str, str] | None = None
    loaded_from: dict[str, str] = {}          # `al` -> the variable the last load named
    dead = False                              # the previous instruction was an unconditional jump
    for instruction in body:
        address = instruction.address
        matched = False
        # Take every pending entry whose target is HERE, not just one sitting on top. An `if/else`
        # compiles as `je L ; <then> ; jmp M`, and the `jne`s of the following test are pushed after
        # the `je` — so the entry for L is buried and a top-only check never reached it. Round 677:
        # that left later leaves carrying an earlier group's guard and missing the routine's own
        # opening one. The last pushed matching entry wins, which keeps the nesting order.
        while True:
            index = None
            for position in range(len(pending) - 1, -1, -1):
                if pending[position][0] == address:
                    index = position
                    break
            if index is None:
                break
            _, guard, saved, saved_loads = pending.pop(index)
            path = saved + ([guard] if guard is not None else [])
            loaded_from.clear()
            loaded_from.update(saved_loads)
            matched = True
        if dead and not matched:
            # The previous instruction was an unconditional jump, so this one is reachable only through
            # a pending target. Nothing matched, so the path accumulated before the jump describes a
            # branch that never gets here: drop it. Round 676: an `if/else` written `je L ; <then> ;
            # jmp M` otherwise left the fall-through's negated guard on the arm at L, printing
            # `P4 <> 1 ; P4 = 1` for one leaf.
            path = []
        if instruction.mnemonic == "jmp" and instruction.op_str.startswith("0x"):
            # An unconditional jump is an edge too: its target inherits the current path unchanged,
            # and needs the `al` map and the guard path as they stand. Round 678: without this the
            # target of a `jmp` had no snapshot, so it kept whatever the linear walk last saw and
            # printed a guard from the wrong branch (`P4 = 1 ; P4 = 0` for `22:0x424f`).
            pending.append((int(instruction.op_str, 16), None, list(path), dict(loaded_from)))
        dead = instruction.mnemonic == "jmp"
        text = f"{instruction.mnemonic} {instruction.op_str}"
        if instruction.mnemonic == "mov" and instruction.op_str.startswith("al,"):
            loaded = re.fullmatch(r"al, byte ptr \[bp ([+-]) (0x[0-9a-f]+|\d+)\]",
                                  instruction.op_str)
            if loaded:
                sign, raw = loaded.group(1), loaded.group(2)
                depth = -int(raw, 0) if sign == "-" else int(raw, 0)
                loaded_from["al"] = f"B{-depth}" if depth < 0 else f"P{depth}"
            else:
                # Any other load of `al` — `mov al, byte ptr es:[di]` reads a map, for instance —
                # invalidates the name. Round 674: leaving the old name in place labelled a
                # comparison with a variable it did not read, which printed an impossible path
                # (`if B1 = 3 then ... if B1 = 0`) for `22:0x424f`.
                loaded_from.pop("al", None)
        if (m := comment.match(text)):
            previous_constant = m.group(1)
            previous_guard = None
            continue
        if (named := operand_guard(instruction)) is not None:
            previous_constant = None
            previous_guard = named
            continue
        if (m := store.search(text)):
            out.append((m.group(1), list(path)))
            continue
        if instruction.mnemonic in ("jne", "je") and (previous_constant is not None
                                                      or previous_guard is not None):
            target = int(instruction.op_str, 0)
            if previous_guard is not None:
                # A memory-operand guard: keep both sides as the disassembler names them.
                left, right = previous_guard
                shown = char_code(right) if args.chars else (
                    f"${right[2:]}" if right.lower().startswith("0x") else right)
                equal, unequal = f"{left} = {shown}", f"{left} <> {shown}"
            else:
                # Resolve `al` to the variable it was loaded from HERE, not at print time: every
                # comparison reloads `al`, so the name is only correct while its load is the latest.
                name = loaded_from.get("al", "al")
                shown = char_code(previous_constant) if args.chars else (
                    f"${previous_constant[2:]}" if previous_constant.lower().startswith("0x")
                    else previous_constant)
                equal, unequal = f"{name} = {shown}", f"{name} <> {shown}"
            if instruction.mnemonic == "jne":
                pending.append((target, unequal, list(path), dict(loaded_from)))
                path = path + [equal]
            else:
                pending.append((target, equal, list(path), dict(loaded_from)))
                path = path + [unequal]
            previous_constant = None
            previous_guard = None
    print(f"{segment}:{offset:#06x}  {function.size} bytes  {len(body)} instructions  "
          f"{len(out)} leaves into `{args.store}`")
    if args.pascal:
        # Leaves reachable with no guard at all are the default assignments the tree then refines,
        # so they come first as plain stores (that is how the body opens, `Result := $ff`).
        def literal(value: str) -> str:
            # Pascal spells hexadecimal with `$`, not `0x`, and the disassembler prints the latter.
            if args.chars:
                return char_code(value)
            return f"${value[2:]}" if value.lower().startswith("0x") else value

        default = [(value, guards) for value, guards in out if not guards]
        for value, _ in default:
            print(f"  {args.result} := {literal(value)};")
        out = [(value, guards) for value, guards in out if guards]
        # A NESTED tree, because that is the shape the compiler emitted: the guards are a chain of
        # tests, not one flat conjunction, and the branch structure decides the bytes.
        def emit(entries, depth: int):
            if not entries:
                return
            if len(entries) == 1 and not entries[0][1]:
                print(f"{'  ' * depth}{args.result} := {entries[0][0]};")
                return
            guard = entries[0][1][0]
            same = [(value, guards[1:]) for value, guards in entries if guards and guards[0] == guard]
            other = [(value, guards) for value, guards in entries if not guards or guards[0] != guard]
            # When the two sides are exact complements (`x = 0` and `x <> 0`), the else branch needs
            # no test of its own — emitting one would add a comparison the original does not have.
            complements = {guard.replace(" = ", " <> ") if " = " in guard
                           else guard.replace(" <> ", " = ")}
            collapse = bool(other) and all(guards and guards[0] in complements
                                           for _value, guards in other)
            rest = [(value, guards[1:] if guards and guards[0] in complements else guards)
                    for value, guards in other] if collapse else other
            # `end` takes a semicolon unless an `else` follows it — the compiler rejects the file
            # otherwise, which is how this was found.
            terminator = "end" if other else "end;"
            print(f"{'  ' * depth}if {guard} then")
            print(f"{'  ' * depth}begin")
            emit(same, depth + 1)
            print(f"{'  ' * depth}{terminator}")
            if other:
                print(f"{'  ' * depth}else")
                print(f"{'  ' * depth}begin")
                emit(rest, depth + 1)
                print(f"{'  ' * depth}end;")

        out = [(literal(value), guards) for value, guards in out]

        def split(guard: str) -> tuple[str, str, str]:
            """(selector, operator, value) for `X = v` and `X <> v`."""
            for operator in (" = ", " <> "):
                if operator in guard:
                    left, _, right = guard.partition(operator)
                    return left, operator, right
            return guard, " = ", "?"

        def emit_case(entries, depth: int):
            """Emit the same tree as `case` statements.

            Round 685 measured that D1 loads a `case` selector into `al` before comparing it, which is
            the `mov al, <operand> ; cmp al, <imm>` shape the targets have. The tree is unchanged: the
            first guard names the selector, the entries sharing it are that case's arms, and everything
            else — including the `<>` complements of the arms already taken — is the `else`.
            """
            if not entries:
                return
            # Entries whose whole path has been consumed are this level's plain stores. Handling them
            # here rather than inside the arms keeps the walk finite: without it a mixed list recursed
            # on the same entries forever, and an entry with an empty path then indexed `guards[0]`.
            for value, guards in [(v, g) for v, g in entries if not g]:
                print(f"{'  ' * depth}{args.result} := {value};")
            entries = [(v, g) for v, g in entries if g]
            if not entries:
                return
            # A `SEL <> v` immediately followed by `SEL = w` is the SAME case's next arm, not a nested
            # level: D1 emits `jne <next arm>`, so the fall-through keeps comparing the register it
            # already holds. Round 690 measured the difference as a reload of `al` and 27 bytes; dropping
            # the negated guard here makes the two tests one case, which is what the target does.
            # Collapse a `SEL <> v` immediately followed by `SEL = w`: D1 emits `jne <next arm>` and the
            # fall-through keeps the register, so both tests are arms of ONE case (round 690). Round 692
            # added a guard against doing this when an arm takes `SEL = v` as well — and round 693 showed
            # the guard was unnecessary: the target collapses there too, and what looked like a wrong
            # label was the arm ORDER, because the arms were sorted numerically ($10, 3, 4) instead of in
            # the order the body presents them.
            # Drop a RUN of leading `SEL <> u` guards when the same selector is tested for equality
            # further along the path. D1 emits a case's arms as `cmp al, v ; jne <next arm>` and the
            # fall-through keeps the register, so `B1 <> 0 ; B1 <> 1 ; B1 = 4` is the FOURTH arm of one
            # case, not a nested one. Round 695: handling only a single negation nested the later arms,
            # which costs a `mov al` reload each and the 15 bytes the diff showed.
            merged = []
            for value, guards in entries:
                trimmed = guards
                while trimmed and split(trimmed[0])[1] == " <> ":
                    name = split(trimmed[0])[0]
                    if any(split(g)[0] == name and split(g)[1] == " = " for g in trimmed[1:]):
                        trimmed = trimmed[1:]
                        continue
                    break
                merged.append((value, trimmed))
            entries = merged
            selector, _operator, _value = split(entries[0][1][0])
            # keep the guards intact here; the arm below strips exactly one, and stripping in both
            # places removed a whole level of the tree.
            inside = [(value, guards) for value, guards in entries
                      if guards and split(guards[0])[0] == selector]
            other = [(value, guards) for value, guards in entries
                     if not guards or split(guards[0])[0] != selector]
            # entries whose whole path is consumed go to the else side, not to an arm
            other.extend((value, []) for value, guards in entries if not guards)
            # arms that share a value belong to one `case` label
            arms: dict[str, list[tuple[str, list[str]]]] = {}
            for value, guards in [e for e in inside if e[1]]:
                _sel, operator, constant = split(guards[0])
                if operator == " <> ":
                    # a negated guard is the else side, not an arm
                    other.append((value, guards))
                    continue
                # `inside` already stripped the selector's guard, so this is the NEXT level's first
                # guard and must be kept. Stripping it again dropped a whole level of the tree, which
                # is why `22:0x424f`'s emitted case skipped from `P6` straight to `B2` (round 689).
                arms.setdefault(constant, []).append((value, guards[1:]))
            if not arms:
                # No entry takes this selector as an `=`, so the guard in hand is a `<>` — the else
                # side. Consume it and continue; recursing with the list unchanged was an infinite
                # loop, which is how this branch was found.
                emit_case([(v, g[1:] if g and split(g[0])[0] == selector else g)
                           for v, g in entries], depth)
                return
            print(f"{'  ' * depth}case {selector} of")
            # Arms in the order the body presents them, NOT numerically: D1 compares them in source
            # order, and `$10` before `3` is what the target does for this body.
            for constant in arms:
                label = literal(constant) if not constant.lower().startswith("0x") else f"${constant[2:]}"
                print(f"{'  ' * depth}  {label}:")
                print(f"{'  ' * depth}    begin")
                emit_case(arms[constant], depth + 3)
                print(f"{'  ' * depth}    end;")
            if other:
                print(f"{'  ' * depth}else")
                print(f"{'  ' * depth}  begin")
                emit_case([(v, g[1:] if g and split(g[0])[0] == selector else g)
                           for v, g in other], depth + 2)
                print(f"{'  ' * depth}  end;")
            print(f"{'  ' * depth}end;")

        if args.case:
            emit_case(out, 1)
            counts = Counter(value for value, _ in out)
            print(f"{{ {len(out)} leaves, {len(counts)} distinct values }}")
            return 0
        emit(out, 1)
        counts = Counter(value for value, _ in out)
        print(f"{{ {len(out)} leaves, {len(counts)} distinct values }}")
        return 0
    for value, guards in out:
        # `--chars` applies to the leaf values as well: a `Char` result stores a character code, so
        # the table has to spell it `#N` the same way it spells the guards.
        shown_value = char_code(value) if args.chars else value
        print(f"  {shown_value:>6}  <-  " + " ; ".join(guards))
    counts = Counter(value for value, _ in out)
    print(f"  distinct values: {len(counts)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
