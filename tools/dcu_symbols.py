#!/usr/bin/env python3
"""List candidate Delphi 1 DCU strings grouped by class-like spellings.

This exploratory heuristic scans printable strings, not the DCU symbol grammar.
A `.DCU` contains strings resembling the unit's dependencies, then
types, classes and members. A class's published properties follow its name
contiguously (measured on `GRAPHICS.DCU`: `TCanvas` is followed by `Brush`,
`CopyMode`, `Font`, `Pen`), which is what makes this useful — a property *read*
in the probe pulls the property's getter, and the sweep keeps whatever compiles.

    python3 tools/dcu_symbols.py --lib <delphi lib dir> --unit Graphics
"""

from __future__ import annotations

import argparse
import re
import subprocess
from pathlib import Path

CLASS = re.compile(r"^T[A-Z][A-Za-z0-9_]*$")
MEMBER = re.compile(r"^[A-Za-z_][A-Za-z0-9_]*$")
SKIP = {"DCU1", "_0_6_6_", "System", "WinTypes", "WinProcs", "SysUtils", "Classes",
        "Consts", "Controls", "Forms", "Dialogs", "Graphics", "StdCtrls", "Buttons",
        "Menus", "ExtCtrls", "MPlayer", "FileCtrl", "ComCtrls", "Outline", "TabNotBk"}


def strings(path: Path) -> list[str]:
    result = subprocess.run(["strings", "-n", "3", str(path)], capture_output=True, text=True)
    return [line.strip() for line in result.stdout.splitlines()]


def class_members(names: list[str]) -> dict[str, list[str]]:
    out: dict[str, list[str]] = {}
    current: str | None = None
    for name in names:
        if CLASS.match(name):
            current = name
            out.setdefault(current, [])
        elif current and MEMBER.match(name) and name not in SKIP:
            if name not in out[current]:
                out[current].append(name)
    return out


def main() -> int:
    parser = argparse.ArgumentParser(description="List a DCU's classes and members")
    parser.add_argument("--lib", type=Path, required=True)
    parser.add_argument("--unit", required=True)
    args = parser.parse_args()
    members = class_members(strings(args.lib / f"{args.unit.upper()}.DCU"))
    for name, fields in members.items():
        if len(fields) >= 2:
            print(f"{name}: {', '.join(fields)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
