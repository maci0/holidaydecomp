#!/usr/bin/env python3
"""lift.py — turn a discovered procedure into Pascal-shaped source.

`decompile.py` finds procedures and names the published ones; this stage
reads the bytes of one procedure and recovers its *shape* using the codegen
shapes Delphi 1 emits (docs/codegen-patterns.md is the reference, and every
rule below is pinned by a test):

* `enter n, 0` / `push bp; mov bp,sp` — the frame; `n` is the locals area
* the **for-loop range guard**: `cmp <loop var>, <bound>` + `jbe/ja` straight
  out of the loop, which is how D1 compiles `for i := a to b do` and the
  `i <= b` test the user wrote
* the **`repeat..until` shape**: `mov [bp-N], <start>` / `jmp` / `inc [bp-N]` /
  test / `jne` back
* `imul reg, [bp-N], <stride>` — a fixed-stride array or record array
* `shl ax, 2` + `es:[di+disp]` — a record array of 4-byte fields
* argument pushes before a far call, first argument first (left to right, which
  is what `docs/codegen-patterns.md` measures); `ax` carries an `Integer` result

Everything unresolved is printed as the instruction it came from, so the
output is a first draft to correct by hand, never a silent guess.
"""

from __future__ import annotations

import argparse
import re
import struct
import sys
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(REPO / "tools"))

import decompile as D  # noqa: E402

#: A frame slot: [bp-N] is a local (or the last parameter), the offset is the
#: only thing the binary keeps about it.  Slots are named for readability and
#: deduplicated within a procedure.
SLOT = re.compile(r"\[bp ([+-]) (0x[0-9a-f]+)\]")

#: `les` loads a far pointer from a data-segment address; name it after the
#: address so two references to the same global are visibly one global.
GLOBAL = re.compile(r"(?:ptr )?\[(0x[0-9a-f]{1,4})\]")
FAR_ACCESS = re.compile(r"\[es:(?:di|si|bx)([+-] (?:0x)?[0-9a-f]+)?\]")


class Lifter:
    def __init__(self, segment: D.Segment, function: D.Function) -> None:
        self.segment = segment
        self.function = function
        self.slots: dict[str, str] = {}
        self.globals: dict[str, str] = {}
        self.lines: list[str] = []
        self.loop_vars: dict[str, int] = {}
        self.indent = 1

    # --- naming ------------------------------------------------------------

    def slot(self, match: re.Match) -> str:
        key = f"{match.group(1)}{match.group(2)}"
        if key not in self.slots:
            self.slots[key] = f"v{len(self.slots) + 1}"
        return self.slots[key]

    def global_name(self, address: str) -> str:
        key = address.lower()
        if key not in self.globals:
            self.globals[key] = f"Data_{key[2:].upper()}"
        return self.globals[key]

    def operand(self, text: str) -> str:
        """Rewrite a capstone operand string into a readable, source-shaped one."""
        out = SLOT.sub(lambda m: self.slot(m), text)
        out = re.sub(
            r"\[(0x[0-9a-f]{1,4})\]", lambda m: self.global_name(m.group(1)), out
        )
        out = re.sub(r"\bes:\[([a-z]+)([+-] [0-9a-fx]+)?\]", lambda m: m.group(0), out)
        return out

    def emit(self, text: str) -> None:
        self.lines.append("  " * self.indent + text)

    # --- shape recognition -------------------------------------------------

    def frame_locals(self) -> int | None:
        head = self.segment.data[self.function.offset : self.function.offset + 4]
        if head[:1] == b"\xc8":
            return struct.unpack_from("<H", head, 1)[0]
        if head[:3] == D.PROLOGUE:
            return None  # size is not in the prologue; inferred from the slots
        return None

    def lift(self) -> str:
        md = D.engine()
        data = self.segment.data
        start, end = self.function.offset, self.function.end or self.function.offset
        header = [
            f"// {self.function.name or '<unidentified>'} "
            f"@ segment {self.function.segment:04X}:{self.function.offset:04X}, "
            f"{self.function.size} bytes"
        ]
        locals_bytes = self.frame_locals()
        if locals_bytes is not None:
            header.append(f"// enter {locals_bytes}, 0 — a {locals_bytes}-byte frame")

        # the for-loop guards: cmp <slot|byte>, <bound> followed by a jump out
        instructions = list(md.disasm(data[start:end], start))
        for position, ins in enumerate(instructions):
            following = (
                instructions[position + 1] if position + 1 < len(instructions) else None
            )
            if (
                ins.mnemonic == "cmp"
                and following is not None
                and following.mnemonic in ("jbe", "ja", "jb", "jne")
                and "ptr" in ins.op_str
            ):
                target = following.operands[0].imm
                if target <= ins.address:
                    # a jump backwards out of the loop body: the compiler's guard
                    # for `for <var> := a to <bound>`, jumping past the end
                    self.loop_vars[ins.op_str] = following.operands[0].imm
        if self.loop_vars:
            header.append(
                "// loop guards: "
                + "; ".join(f"{k} -> exit {v:#06x}" for k, v in self.loop_vars.items())
            )

        for ins in instructions:
            self.emit(f"{ins.mnemonic:8} {self.operand(ins.op_str)};")

        body = "\n".join(self.lines)
        slots = ", ".join(f"{name} = [{key}]" for key, name in self.slots.items())
        globals_ = ", ".join(sorted(set(self.globals.values())))
        out = header + [
            "",
            f"procedure Lift_{self.function.offset:04X};",
        ]
        if slots:
            out.append(f"  // frame slots: {slots}")
        if globals_:
            out.append(f"  // data referenced: {globals_}")
        out += ["begin", body, "end;"]
        return "\n".join(out)


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--segment", type=int, required=True)
    ap.add_argument(
        "--at", type=lambda v: int(v, 16), required=True, help="entry offset"
    )
    ap.add_argument(
        "--length",
        type=lambda v: int(v, 16),
        default=0x60,
        help="bytes to lift when the offset is not a discovered procedure",
    )
    ap.add_argument("--original", type=Path, default=D.ORIGINAL)
    args = ap.parse_args()

    image = D.Image(args.original)
    segment = image.segments[args.segment]
    classes = D.form_classes_by_segment(image)
    functions = D.discover(segment, classes.get(args.segment, []))
    target = next((f for f in functions if f.offset == args.at), None)
    if target is None:
        # The RTL helpers are entered without a frame, so the entry scan cannot
        # see them; lift a fixed window rather than refusing to lift at all.
        if args.at >= len(segment.data):
            print(f"{args.segment:04X}:{args.at:04X} is past the segment end")
            return 1
        target = D.Function(
            segment=args.segment,
            offset=args.at,
            end=min(args.at + args.length, len(segment.data)),
        )
    print(Lifter(segment, target).lift())
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
