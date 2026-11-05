#!/usr/bin/env python3
"""Append a sweep's survivors to `REACH.PAS` as one new procedure.

The sweeps produce kept-candidate files (`VAR:` and `STMT:` lines). Adopting them
by hand has been the fragile part — three times a merge was pasted in and then
debugged — so this does it mechanically: it de-duplicates the survivors across
several files, skips declarations and statements that are already in the unit,
and appends one `procedure <name>;` whose call is added to `ReachMore`.

    python3 tools/apply_sweep.py --name UseSweep4 build/reach_sweep4_p*.txt
"""

from __future__ import annotations

import argparse
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
REACH = ROOT / "src" / "main" / "REACH.PAS"


def survivors(paths: list[Path]) -> list[str]:
    seen: set[str] = set()
    out: list[str] = []
    for path in paths:
        for line in path.read_text(encoding="utf-8").splitlines():
            if line.startswith(("VAR: ", "STMT: ")):
                body = line[5:].strip()
                if body not in seen:
                    seen.add(body)
                    out.append(line)
    return out


def main() -> int:
    parser = argparse.ArgumentParser(description="Adopt a sweep's survivors")
    parser.add_argument("--name", required=True, help="the procedure name to add")
    parser.add_argument("kept", nargs="+", type=Path)
    args = parser.parse_args()

    text = REACH.read_text(encoding="cp1252")
    if f"procedure {args.name};" in text:
        print(f"{args.name} is already in REACH.PAS")
        return 1
    lines = survivors(args.kept)
    declarations = [line[5:].strip() for line in lines if line.startswith("VAR: ")]
    statements = [line[6:].strip() for line in lines if line.startswith("STMT: ")]
    if not statements:
        print("no survivors to adopt")
        return 1
    block = (
        f"\nprocedure {args.name};\nvar\n"
        + "".join(f"  {declaration}\n" for declaration in declarations if declaration not in text)
        + "begin\n"
        + "".join(f"  {statement}\n" for statement in statements)
        + "end;\n"
    )
    anchor = "procedure ReachMore;\nbegin"
    assert anchor in text, "REACH.PAS has no ReachMore"
    text = text.replace(anchor, block + "\n" + anchor, 1)
    text = text.replace("begin\n  UseRTL;", f"begin\n  UseRTL;  {args.name};", 1)
    REACH.write_text(text, encoding="cp1252")
    print(
        f"adopted {len(declarations)} declarations and {len(statements)} statements "
        f"into {args.name}"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
