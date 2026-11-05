#!/usr/bin/env python3
"""show_body.py — disassemble one inventory body, with the facts a reconstruction needs.

    python3 tools/show_body.py 19:0x0745
    python3 tools/show_body.py 19:0x0745 --limit 60

Prints the address, size and instruction count, then every instruction numbered from the body's
start. The global addresses and the frame slots are what decide the source shape, so they are printed
rather than left to be read off the mnemonics.

The `globals` line holds direct absolute operands only. A cell reached through a register,
`[di + 0x6F27]`, is not one address, so it prints on the `indexed` line with its displacement and
its use count instead of being folded into `globals`.
"""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))

import decompile  # noqa: E402
import profile_proc  # noqa: E402


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("target", help="SEGMENT:OFFSET, e.g. 19:0x0745")
    parser.add_argument("--limit", type=int, default=0, help="print only the first N instructions")
    parser.add_argument("--binary", type=Path, default=None)
    parser.add_argument("--branches", action="store_true",
                        help="list every conditional with its target OFFSET — the structure, not the bytes")
    args = parser.parse_args()

    match = re.fullmatch(r"(\d+):(0x[0-9a-fA-F]+|\d+)", args.target)
    if not match:
        raise SystemExit("target must look like 19:0x0745")
    segment, offset = int(match.group(1)), int(match.group(2), 0)

    image = decompile.Image(args.binary or decompile.ORIGINAL)
    classes = decompile.form_classes_by_segment(image)
    functions = {f.offset: f for f in decompile.discover(image.segments[segment],
                                                        classes.get(segment, []))}
    function = functions.get(offset)
    if function is None:
        raise SystemExit(f"no discovered procedure at {segment}:{offset:#06x}")

    profile = profile_proc.profile(image, segment, offset)
    body = decompile.procedure_body(image.segments[segment], function)
    print(f"{segment}:{offset:#06x}  {function.size} bytes  {len(body)} instructions")
    if profile:
        def _addresses(items) -> str:
            out = []
            for item in items:
                address = item[0] if isinstance(item, (tuple, list)) else item
                out.append(f"{address:#06x}" if isinstance(address, int) else str(address))
            return ", ".join(out) or "none"

        globals_ = _addresses(profile["globals"])
        calls = ", ".join(f"{target}#{count}"
                          for target, count in sorted(dict(profile["calls"]).items())) or "none"
        # `globals` counts direct absolute operands only, so the three cells
        # `21:0x2d5a` reads through `di` (0x6f27, 0x7060, 0x7070) reached
        # neither line: the census counted them while the dump said
        # `indexed: yes`. The displacements print here, with their totals.
        cells = ", ".join(f"{base}+{cell:#x}#{count}"
                         for (base, cell), count in profile["indexed"]) or "none"
        print(f"  globals: {globals_} (direct operands only)")
        print(f"  far calls: {calls}")
        print(f"  indexed: {cells}  "
              f"({profile['distinct_indexed']} distinct, {profile['indexed_sites']} sites)")
    if args.branches:
        # Round 634: listing every conditional with the offset it jumps to makes a body's structure
        # fall out — overlapping targets mean a conjunction, a chain means nested ifs. Round 635 found
        # the last correction for `21:0x03a6` by comparing this table with the probe's.
        conditional = ("je", "jne", "jg", "jl", "jge", "jle", "ja", "jb", "jae", "jbe", "jmp")
        for instruction in body:
            if instruction.mnemonic not in conditional:
                continue
            try:
                target = int(instruction.op_str, 16) - offset
            except ValueError:
                target = None
            print(f"{instruction.address - offset:5d} {instruction.mnemonic:5} -> {target}")
        return 0

    shown = body if not args.limit else body[:args.limit]
    for index, instruction in enumerate(shown):
        print(f"{index:4d} {instruction.address - offset:5d} {instruction.mnemonic:9} {instruction.op_str}")
    if args.limit and len(body) > args.limit:
        print(f"  … {len(body) - args.limit} more")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
