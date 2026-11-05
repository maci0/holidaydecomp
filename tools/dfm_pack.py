#!/usr/bin/env python3
"""dfm_pack.py — pack the recovered form streams back into a Delphi 1 `.RES`.

Delphi 1's linker appends `{$R}`-linked resources after the segment data and
records their names in a table inside the NE header area.  In
`original/holiday.exe` that name table holds one entry per form, upper-cased
(`THINTERGRUND`, `TBAUMENUE`, …), in the same order as the appended streams —
which is the order `rebrew.formats.dfm` recovers them in.

A `.RES` is a flat sequence of records:

    FF 02 00 | name (ASCII, NUL-terminated) | WORD 0x1030 | DWORD size | data

(`BUTTONS.RES` walks exactly this way: ten records, the last one ending on the
final byte.)

Packing the recovered streams this way lets `{$R *.RES}` put the original form
bytes back into a build.  Two DCC quirks found while testing this:

* a one-record `.RES` dies with `Error 164: Duplicate resource identifier`
  (two or more records link fine);
* a `.RES` whose base name matches a *unit* is auto-linked by that unit and
  then linked again by the directive — same error.

Usage: python3 tools/dfm_pack.py [--check] [--out src/main/HOLIDAY.RES]
"""

from __future__ import annotations

import argparse
import struct
import sys
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(REPO / "tools"))

ORIGINAL = REPO / "original" / "holiday.exe"
OUT = REPO / "src" / "main" / "HOLIDAY.RES"

#: The record marker every `{$R}` resource in this toolchain carries (bitmaps
#: and forms alike — the linker does not distinguish them).
MARKER = 0x1030


def record(name: str, data: bytes) -> bytes:
    return (
        b"\xff\x02\x00"
        + name.encode("ascii")
        + b"\x00"
        + struct.pack("<H", MARKER)
        + struct.pack("<I", len(data))
        + data
    )


def recover_icon(data: bytes, first_form: int) -> tuple[bytes, bytes] | None:
    """The application icon the project linked, as (image, group-directory).

    The trailer holds it just before the form streams: the icon image (a DIB
    whose `biSize` is 40) then, after padding, the 22-byte `RT_GROUP_ICON`
    directory whose entry names the image by id.  Both are recovered from the
    image rather than from the shipped `.ico`, because the linker rewrites the
    directory (the entry's last field is the resource id, not the file offset).
    """
    start = max(0, first_form - 2048)
    window = data[start:first_form]
    for pos in range(len(window) - 22, -1, -1):
        cand = window[pos : pos + 22]
        if cand[:6] != b"\x00\x00\x01\x00\x01\x00":
            continue
        width, height = cand[6], cand[7]
        planes = int.from_bytes(cand[10:12], "little")
        bpp = int.from_bytes(cand[12:14], "little")
        size = int.from_bytes(cand[14:18], "little")
        ident = int.from_bytes(cand[18:20], "little")
        if not (width and height and planes in (0, 1) and bpp in (1, 4, 8, 24, 32)):
            continue
        if size <= 0 or ident == 0:
            continue
        # The image ends at most one 512-byte alignment unit before the directory.
        absolute = start + pos
        for pad in range(0, 512):
            image_end = absolute - pad
            image_start = image_end - size
            if (
                image_start < start
                or data[image_start : image_start + 4] != b"\x28\x00\x00\x00"
            ):
                continue
            return data[image_start:image_end], cand
    return None


def build(data: bytes) -> tuple[bytes, list[str]]:
    """The `.RES` bytes plus the resource names in order."""
    from rebrew.formats.dfm import parse_forms

    forms = parse_forms(data)
    out = bytearray()
    names = []
    icon = recover_icon(data, forms[0][0]) if forms else None
    if icon is not None:
        image, group = icon
        # The image's name is its numeric resource id, which the linker does not
        # copy into the name table — the original's first entry is MAINICON.
        out += record("1", image)
        out += record("MAINICON", group)
        names.append("MAINICON")
    for offset, root, end in forms:
        name = root.cls.upper()
        names.append(name)
        out += record(name, data[offset:end])
    return bytes(out), names


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument(
        "--check", action="store_true", help="fail when the packed .RES is stale"
    )
    ap.add_argument("--out", type=Path, default=OUT)
    ap.add_argument("--original", type=Path, default=ORIGINAL)
    args = ap.parse_args()

    packed, names = build(args.original.read_bytes())
    stale = not args.out.is_file() or args.out.read_bytes() != packed
    if args.check:
        if stale:
            print(f"stale: {args.out}", file=sys.stderr)
            return 1
        print(f"checked {args.out.name}: {len(names)} record(s)")
        return 0
    args.out.parent.mkdir(parents=True, exist_ok=True)
    args.out.write_bytes(packed)
    print(f"packed {len(names)} record(s) into {args.out} ({len(packed)} bytes)")
    print("names: " + " ".join(names))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
