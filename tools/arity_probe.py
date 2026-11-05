#!/usr/bin/env python3
"""Find how many arguments a library member takes, by asking the compiler.

The `.DCU` symbol tables give member *names* but not signatures, and guessing
call shapes kept failing (rounds 116, 126's sweep). The compiler knows the
signature, and it says so in its errors: calling a parameterless member compiles,
calling one that takes arguments without parentheses is `Error 88: "(" expected`,
and calling it with too few is `Error 87: "," expected` while enough arguments
with wrong types is `Error 26: Type mismatch`. That is a decision procedure for
the arity, and this tool runs it.

    python3 tools/arity_probe.py --unit Graphics --class TCanvas --var gCanvas
"""

from __future__ import annotations

import argparse
import re
import subprocess
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

import dcu_symbols  # noqa: E402

ROOT = Path(__file__).resolve().parent.parent
WORK = ROOT / "src" / "main"
LIB = ROOT / "toolchain" / "recompile-toolchains" / "delphi" / "1.0-win16" / "source" / "DELPHI" / "LIB"
ERROR = re.compile(r"Error (\d+):")
TOO_FEW = 87  # `,` expected
NEEDS_PAREN = 88  # `(` expected
TYPE_MISMATCH = 26


def compile_call(unit: str, klass: str, variable: str, call: str) -> int | None:
    """The compiler's error number for one statement, or None if it compiles."""
    (WORK / "RCHSWU.PAS").write_text(
        "unit RCHSWU;\ninterface\nprocedure Sweep;\nimplementation\n"
        f"uses {unit};\nvar {variable}: {klass};\n"
        "  n2: Integer; s2: string; b3: Boolean;\nprocedure Sweep;\nbegin\n"
        f"  {call}\nend;\nend.\n",
        encoding="utf-8",
    )
    (WORK / "RCHSWP.DPR").write_text(
        "program RCHSWP;\nuses Forms, RCHSWU;\nbegin\n  Sweep;\nend.\n", encoding="utf-8"
    )
    result = subprocess.run(
        [sys.executable, "-m", "rebrew.app.main", "build", "delphi", str(WORK / "RCHSWP.DPR"),
         "--output", str(ROOT / "build" / "rchswp.exe"),
         "--work-dir", str(ROOT / "build" / "dcc-arity")],
        capture_output=True, text=True, cwd=ROOT,
    )
    if result.returncode == 0:
        return None
    match = ERROR.search(result.stdout + result.stderr)
    return int(match.group(1)) if match else -1


# a statement that reads a property into a variable of a known type: the round-140
# lesson, which the first version of this tool did not carry
READS = ("n2 := {var}.{member};", "s2 := {var}.{member};", "b3 := {var}.{member};")
INACCESSIBLE = 44  # `Field identifier expected` — a private or protected member


def arity(unit: str, klass: str, variable: str, member: str, limit: int = 12) -> str:
    """`property`, `method/<n>`, `inaccessible`, or `unknown` for one member.

    A property cannot be classified by compiling `v.Member;` — that is not a
    statement, and DCC answers `Error 122`. The first version of this tool did
    exactly that and reported every property as `other/122` (round 140); it now
    classifies through a typed read, which is the rule the reach work uses.
    """
    plain = compile_call(unit, klass, variable, f"{variable}.{member};")
    if plain is None:
        return "property"
    if plain == INACCESSIBLE:
        return "inaccessible"
    if plain not in (NEEDS_PAREN, TOO_FEW):
        for template in READS:
            code = compile_call(
                unit, klass, variable, template.format(var=variable, member=member)
            )
            if code in (None, TYPE_MISMATCH):
                return "property"
            if code == INACCESSIBLE:
                return "inaccessible"
        return f"other/{plain}"
    for count in range(1, limit + 1):
        code = compile_call(
            unit, klass, variable, f"{variable}.{member}(" + ", ".join(["0"] * count) + ");"
        )
        if code in (None, TYPE_MISMATCH):
            return f"method/{count}"
        if code != TOO_FEW:
            return f"other/{code}@{count}"
    return "unknown"


def batch(
    unit: str, klass: str, variable: str, limit: int, out: Path, reads: list[str]
) -> int:
    """Classify a class's members and write the usable calls as candidates."""
    members = [
        name
        for name in reads
        if name and name[0].isupper() and not name.startswith(("F", "CM", "CN", "W", "Do"))
    ][:limit]
    lines = [f"VAR: {variable}: {klass};", "VAR: n2: Integer;", "VAR: s2: string;",
             "VAR: b3: Boolean;"]
    found: list[tuple[str, str]] = []
    for name in members:
        kind = arity(unit, klass, variable, name)
        found.append((name, kind))
        if kind == "property":
            lines.append(f"STMT: n2 := {variable}.{name};")
            lines.append(f"STMT: s2 := {variable}.{name};")
            lines.append(f"STMT: {variable}.{name} := 0;")
        elif kind.startswith("method/"):
            count = int(kind.split("/")[1])
            arguments = ", ".join(["0"] * count)
            lines.append(f"STMT: {variable}.{name}({arguments});")
        print(f"{klass}.{name}: {kind}", flush=True)
    out.write_text("\n".join(lines) + "\n", encoding="utf-8")
    usable = sum(1 for _name, kind in found if kind != "inaccessible")
    print(f"{klass}: {usable} of {len(found)} usable, written to {out}")
    return 0


def main() -> int:
    parser = argparse.ArgumentParser(description="Probe library member arities")
    parser.add_argument("--unit", required=True)
    parser.add_argument("--class", dest="klass", required=True)
    parser.add_argument("--var", required=True)
    parser.add_argument("--limit", type=int, default=40)
    parser.add_argument("--out", type=Path, default=None)
    parser.add_argument("--dcu-unit", default=None, help="read members from this DCU instead")
    args = parser.parse_args()

    dcu = LIB / f"{(args.dcu_unit or args.unit).upper()}.DCU"
    members = dcu_symbols.class_members(dcu_symbols.strings(dcu)).get(args.klass, [])
    if args.out is not None:
        return batch(args.unit, args.klass, args.var, args.limit, args.out, members)
    verbs = [m for m in members if m[0].isupper() and not m.startswith(("On", "F"))]
    found: dict[str, list[str]] = {"property": [], "method": []}
    for member in verbs[: args.limit]:
        kind = arity(args.unit, args.klass, args.var, member)
        if kind == "property":
            found["property"].append(member)
        elif kind.startswith("method/"):
            found["method"].append(f"{member}:{kind.split('/')[1]}")
        print(f"{member}: {kind}", flush=True)
    print(f"\nproperties: {len(found['property'])}")
    print(f"methods: {len(found['method'])}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
