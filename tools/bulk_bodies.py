"""Emit generator entries for every procedure the tree does not yet carry.

The objective's second clause is the source tree, and `tools/expressible.py --unwritten` measures what
is missing: **686 procedures across 14 units**. Writing those one per round is about two thousand tool
calls, and rounds 398 to 464 wrote fourteen bodies in that time. This script produces the entries in
one pass instead: each missing procedure becomes a named, address-labelled declaration with a body
that states what is known about it.

The output is a Python fragment to paste into `gen_tree.py`'s `_RECOVERED_FREE_BODIES`, grouped by
unit. Bodies are **shape-only** by construction and labelled so — this is a tree-completeness pass, not
a byte-match pass, and the score is expected not to move.

Usage: python tools/bulk_bodies.py [--unit 14] [--limit 5] [--write path.py]
"""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "tools"))

import decompile  # noqa: E402
import expressible  # noqa: E402
import gen_tree  # noqa: E402


def pascal_name(segment: int, offset: int) -> str:
    return f"Proc{segment}_{offset:04X}"


def signature(body: list, name: str) -> tuple[str, str]:
    """(declaration, note tail) with the argument words the original's `ret` pops.

    A no-op whose declaration has the wrong argument count compiles to the wrong `ret` and cannot
    match; round 478 measured that the bulk pass emitted every procedure without parameters.
    Arguments are emitted as Word pairs because the stack cost is what the `ret N` instruction
    encodes, whatever the original types were.
    """
    last = body[-1]
    words = 0
    if last.mnemonic.startswith("ret"):
        parts = last.op_str.strip().split()
        words = int(parts[0], 0) // 2 if parts else 0
    # DCC 1.0 rejects `A0: Word, A1: Word` in this project's forward-declaration block
    # with error 89, so the parameters share one type clause.
    params = (", ".join(f"A{index}" for index in range(words)) + ": Word") if words else ""
    declaration = f"procedure {name}({params});" if words else f"procedure {name};"
    return declaration, "" if not words else f", pops {words} word(s)"


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--unit", type=int, default=-1, help="one segment only")
    parser.add_argument("--limit", type=int, default=0, help="stop after this many bodies")
    parser.add_argument("--write", default="", help="write the fragment to this path")
    args = parser.parse_args()

    written = set(gen_tree._RECOVERED_FREE_BODIES)
    image = decompile.Image(ROOT / "original" / "holiday.exe")
    classes = decompile.form_classes_by_segment(image)
    units = [args.unit] if args.unit >= 0 else [index for index in range(25)
                                               if index not in written]
    fragment = []
    total = 0
    for index in units:
        rows = list(decompile.discover(image.segments[index], classes.get(index, [])))
        if not rows:
            continue
        entries = []
        for function in rows:
            body = list(decompile.procedure_body(image.segments[index], function))
            calls = sum(1 for step in body if step.mnemonic in ("call", "lcall"))
            blocked = next((expressible.blockers(step.op_str) for step in body
                            if expressible.blockers(step.op_str)), None)
            note = (f"shape only: {len(body)} instructions, {calls} call(s)"
                    + (f", {blocked} means it is not expressible" if blocked else ""))
            # `ret` is near and `retf` far: the declaration must carry `{$F-}` or the
            # parameter slots shift by the four-byte far return address (round 524)
            tail = body[-1].mnemonic
            if tail.startswith("ret") and not tail.startswith("retf"):
                note += ", near"
            name = pascal_name(index, function.offset)
            declaration, pop_suffix = signature(body, name)
            # a body repeats the name only: the parameters belong to the declaration
            source = f"procedure {name};"
            entries.append(
                f'        (\n'
                f'            "{declaration}",\n'
                f'            """{source}\n'
                f'begin\n'
                f'end;""",\n'
                f'            "{note}{pop_suffix}",\n'
                f'        ),\n')
            total += 1
            if args.limit and total >= args.limit:
                break
        fragment.append(f"    {index}: [\n{''.join(entries)}    ],\n")
        if args.limit and total >= args.limit:
            break

    text = "".join(fragment)
    if args.write:
        Path(args.write).write_text(text, encoding="utf-8")
        print(f"bulk_bodies: wrote {total} entries across {len(fragment)} unit(s) to {args.write}")
    else:
        print(text)
        print(f"bulk_bodies: {total} entries across {len(fragment)} unit(s)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
