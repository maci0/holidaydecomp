#!/usr/bin/env python3
"""profile_row.py — render a procedure's profile as a document table row, without hiding anything.

The recurring defect this tool exists to remove: a measurement printed with `calls[:3]` or
`fields[:3]` looks complete, and a document sentence written from it then claims "three setters"
when the profile holds six (round 491), or names the wrong fields (round 472). The truncation was
mine, not the tool's, but nothing in the output said that anything had been left out.

So this prints **markdown table rows** and, whenever a list is capped, says how many entries it
did not show (`… +12 more`). A row can therefore be pasted into `docs/segment-map.md` as it stands,
and a capped row is visibly capped.

Usage:

    python3 tools/profile_row.py 19:0x109f 1:0x1bf7      # one row per procedure
    python3 tools/profile_row.py 24:0x072c --globals 6   # show more globals
"""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
if str(ROOT / "tools") not in sys.path:
    sys.path.insert(0, str(ROOT / "tools"))

import decompile  # noqa: E402
import gen_globals  # noqa: E402
import profile_proc  # noqa: E402

DEFAULT_SHOWN = 4


def _name(address: int) -> str:
    entry = gen_globals.NAMES.get(address)
    return f" ({entry[0]})" if entry else ""


def _listed(items: list[tuple[int, int]], shown: int, label: str) -> str:
    """`a n×, b n×` plus an explicit marker when entries are hidden."""
    parts = [f"`{value:#x}` {count}×" for value, count in items[:shown]]
    hidden = len(items) - len(parts)
    if hidden > 0:
        parts.append(f"**+{hidden} more {label}**")
    return ", ".join(parts) if parts else "—"


def row(segment: int, offset: int, shown: int = DEFAULT_SHOWN, target: Path | None = None) -> str:
    image = decompile.Image(target or decompile.ORIGINAL)
    result = profile_proc.profile(image, segment, offset)
    if not result:
        raise SystemExit(f"{segment}:{offset:#06x} is not a discovered procedure")
    globals_ = [(address, count) for address, count in (result["globals"] or [])]
    global_text = ", ".join(
        f"`{address:#x}`{_name(address)} ×{count}" for address, count in globals_[:shown]
    )
    if len(globals_) > shown:
        global_text += f", **+{len(globals_) - shown} more globals**"
    calls = [(int(offset_text, 16), count) for offset_text, count in (result["calls"] or [])]
    strides = [(size, count) for size, count in (result["strides"] or [])]
    fields = [(field, count) for field, count in (result["fields"] or [])]
    return (
        f"| `{segment}:{offset:#06x}` | {result['size']} | {result['instructions']} | "
        f"`{result['frame'].strip()}` | {len(result['parameters'])} | {result['loops']} | "
        f"{global_text or '—'} | {_listed(calls, shown, 'calls')} | "
        f"{_listed(strides, shown, 'strides')} | {_listed(fields, shown, 'fields')} |"
    )


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("procedures", nargs="+", metavar="SEGMENT:0xOFFSET")
    parser.add_argument("--globals", type=int, default=DEFAULT_SHOWN,
                        help=f"entries to show per list before marking the rest (default "
                             f"{DEFAULT_SHOWN})")
    args = parser.parse_args()

    print("| procedure | bytes | insns | frame | params | loops | globals | calls | strides | fields |")
    print("| --- | ---: | ---: | --- | ---: | ---: | --- | --- | --- | --- |")
    for text in args.procedures:
        segment_text, _, offset_text = text.partition(":")
        if not offset_text:
            raise SystemExit(f"expected SEGMENT:0xOFFSET, got {text!r}")
        print(row(int(segment_text), int(offset_text, 16), args.globals))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
