#!/usr/bin/env python3
"""place_global.py — emit a probe unit whose variable sits at a chosen data-segment offset.

Round 608 measured that 999 of the 1,306 bodies are blocked only because their code names an
absolute data address, which a probe cannot normally reproduce. Round 609 measured that it can: D1
lays globals out in declaration order from the top of the data segment, so a byte-array filler of
`n` bytes moves the next variable to

    address = 0xAA + (n - 2)        (measured at n = 0, 256 and 1024)

The `- 2` is a constant head and does not scale. So a probe with the right filler puts a symbol
exactly where the target's code expects it, which is the method the campaign was missing.

    python3 tools/place_global.py 0x5504            # print the filler size and the body
    python3 tools/place_global.py 0x5504 --write build/probes/placed.pas
"""

from __future__ import annotations

import argparse
from pathlib import Path

#: A word variable's address with no filler, and the constant head the filler cannot move.
BASE = 0xAA
HEAD = 2

TEMPLATE = """unit BMATCHU;
{{ Round 609: `{name}` placed at data offset {address:#06x} with a {filler}-byte filler.

  Measured: D1 lays globals out in declaration order from the top of the data segment, and a byte
  array of n bytes moves the next variable to BASE + (n - {head}), where BASE = {base:#04x} is the
  address a word takes with no filler. The `- {head}` is a constant head. }}
interface

var
  Filler: array[0..{last}] of Byte;
  {name}: {kind};
  Sink: Word;

procedure Touch;
procedure Run;

implementation

procedure Touch;
begin
  Sink := Word({name});
  if {name} = 0 then Sink := 1;
end;

procedure Run;
begin
  Touch;
  Touch;
end;

end.
"""


def filler_for(address: int) -> int:
    """The byte count that places the next word variable at `address`."""
    return address - BASE + HEAD


def render(address: int, name: str = "Target", kind: str = "Word") -> str:
    filler = filler_for(address)
    if filler < 0:
        raise SystemExit(f"{address:#06x} is below the base {BASE:#06x}")
    return TEMPLATE.format(address=address, name=name, kind=kind, filler=filler,
                           last=max(filler - 1, 0), base=BASE, head=HEAD)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("address", help="data-segment offset, e.g. 0x5504")
    parser.add_argument("--name", default="Target")
    parser.add_argument("--write", type=Path, help="write the unit here")
    args = parser.parse_args()

    address = int(args.address, 0)
    text = render(address, args.name)
    print(f"filler {filler_for(address)} bytes places {args.name} at {address:#06x}")
    if args.write:
        args.write.parent.mkdir(parents=True, exist_ok=True)
        args.write.write_text(text, encoding="utf-8")
        print(f"wrote {args.write}")
    else:
        print(text)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
