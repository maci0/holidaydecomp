#!/usr/bin/env python3
"""resolve_placeholder.py — resolve `lcall 0xFFFF:0` sites through the NE relocation table.

Before relocation a far call inside the image is written `9A FF FF 00 00` — the offset half is
`0xFFFF` and the segment half zero. The linker replaces both halves from a relocation record, so
the record's `target` (a segment number) and `addend` (an offset) are the call's real destination.

    Measured on the original: **347 decoded `lcall` sites** carry an `FFFF` offset half — the same
    347 that `decompile.relocation_form` reports — of which **180 resolve** to a target and offset
    and **167 do not**. The residual 167 is an open item, not a solved one. Sites come from decoded
    instructions rather than a byte scan; a scan also finds the pattern inside operands, where it has
    no record at `offset + 1`.

    python3 tools/resolve_placeholder.py            # every site, with its destination
    python3 tools/resolve_placeholder.py --count     # totals only
"""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

import decompile  # noqa: E402

ROOT = Path(__file__).resolve().parent.parent
ORIGINAL = ROOT / "original" / "holiday.exe"

#: `lcall <off16>:<seg16>` with the **offset half** unresolved. Only the offset half is checked:
#: the segment half is what the loader patches, so it is not necessarily zero in the file —
#: `decompile.relocation_form` counts the same way, and requiring a zero segment half here found
#: 194 of the 347 sites the tool accounts for.
PLACEHOLDER = b"\x9a\xff\xff"


def sites(image=None) -> list[tuple[int, int, tuple[int, int, int, int, int, int] | None]]:
    """Every unresolved far-call site as `(segment, offset, record or None)`.

    The sites are **decoded `lcall` instructions**, not a byte scan. A scan finds the same pattern
    wherever it occurs — including inside another instruction's operand — and a pattern that is not
    an instruction start has no relocation record at `offset + 1`, which is how a byte scan came to
    report 194 resolutions where `decompile.relocation_form` accounts for 347. Enumerating the
    decoded calls is what the two instruments can agree on.
    """
    image = image or decompile.Image(ORIGINAL)
    by_site = {(record[0], record[3], record[1]): record
               for record in decompile.relocation_records(image)}
    found: list[tuple[int, int, tuple[int, int, int, int, int, int] | None]] = []
    for segment in image.segments:
        data = bytes(segment.data)
        for function in decompile.discover(segment):
            for instruction in decompile.procedure_body(segment, function):
                if instruction.mnemonic != "lcall" or len(instruction.operands) < 2:
                    continue          # indirect, e.g. `lcall es:[di+0x30]`
                address = instruction.address
                if data[address : address + 3] != PLACEHOLDER:
                    continue
                record = by_site.get((segment.index, address + 1, 3))
                if record is None:
                    record = (by_site.get((segment.index, address, 3))
                              or by_site.get((segment.index, address + 3, 3)))
                found.append((segment.index, address, record))
    return found


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--count", action="store_true")
    args = parser.parse_args()

    found = sites()
    resolved = [entry for entry in found if entry[2]]
    print(f"placeholder sites: {len(found)} | with a relocation record: {len(resolved)}")
    if not args.count:
        for segment, offset, record in found:
            destination = (f"-> {record[4]}:{record[5]:#06x}" if record else "-> NO RECORD")
            print(f"  {segment}:{offset:#06x}  {destination}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
