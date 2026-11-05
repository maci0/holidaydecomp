#!/usr/bin/env python3
"""Which calls actually pull in library code the original has.

The sweeps measured the score after a *batch* of candidates, so a call that
reaches nothing the original contains looks the same as a call that reaches a
little. This compares a single candidate against a baseline instead: compile a
probe with the candidate, compile one without, and report **two** numbers.

`library` counts the 16-byte windows of the original's library segments (25-33)
that the candidate adds. It is a *local* number and it is not a reason to adopt a
call: round 260 measured one candidate at `library +125` and the project's own
score **fell 16 bytes**, because adding a call also changes the code already in the
reach unit, and the windows that stop matching are invisible to a count of windows
that start. `net` is the difference the project actually cares about —
`ne_analysis.byte_score()` over the whole image, before and after — and it is the
number to decide on.

    python3 tools/reach_oracle.py --statement "gCanvas.LineTo(0, 0);" --var gCanvas --class TCanvas
"""

from __future__ import annotations

import argparse
import subprocess
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

from rebrew.formats import ne_analysis  # noqa: E402

ROOT = Path(__file__).resolve().parent.parent
WORK = ROOT / "src" / "main"
ORIGINAL = ROOT / "original" / "holiday.exe"
LIBRARY = range(25, 34)


def library_bytes(executable: Path) -> int:
    """16-byte windows of the original's library segments present in a build."""
    rows = ne_analysis.segment_budget(ne_analysis.NeImage(ORIGINAL), ne_analysis.NeImage(executable), 16)
    return sum(length and reproduced for index, length, reproduced in rows if index in LIBRARY)


def compile_probe(statements: list[str], declarations: list[str], tag: str) -> Path | None:
    (WORK / "RCHSWU.PAS").write_text(
        "unit RCHSWU;\ninterface\nprocedure Sweep;\nimplementation\n"
        "uses WinTypes, WinProcs, Forms, Graphics, StdCtrls, Buttons, Menus, ExtCtrls,\n"
        "  Dialogs, Controls, Classes, SysUtils, MPlayer, FileCtrl;\n"
        + "".join(f"var {line}\n" for line in declarations)
        + "procedure Sweep;\nbegin\n"
        + "".join(f"  {line}\n" for line in statements)
        + "end;\nend.\n",
        encoding="utf-8",
    )
    (WORK / "RCHSWP.DPR").write_text(
        "program RCHSWP;\nuses Forms, RCHSWU;\nbegin\n  Sweep;\nend.\n", encoding="utf-8"
    )
    out = ROOT / "build" / f"oracle-{tag}.exe"
    result = subprocess.run(
        [sys.executable, "-m", "rebrew.app.main", "build", "delphi", str(WORK / "RCHSWP.DPR"),
         "--output", str(out), "--work-dir", str(ROOT / "build" / f"dcc-oracle-{tag}")],
        capture_output=True, text=True, cwd=ROOT,
    )
    return out if result.returncode == 0 else None


def net_score(executable: Path) -> int:
    """The project's own progress number for a whole build."""
    score, _of = ne_analysis.byte_score(
        ne_analysis.NeImage(ORIGINAL), ne_analysis.NeImage(executable), 16
    )
    return score


def batch(path: Path, declarations: list[str], out: Path, baseline: int,
          baseline_net: int = 0) -> int:
    """Measure every `STMT:` line in a candidate file against one baseline."""
    statements = [
        line[6:].strip()
        for line in path.read_text(encoding="utf-8").splitlines()
        if line.startswith("STMT: ")
    ]
    kept: list[tuple[int, str]] = []
    with out.open("w", encoding="utf-8") as handle:
        for index, statement in enumerate(statements, 1):
            executable = compile_probe([statement], declarations, f"b{index}")
            if executable is None:
                handle.write(f"0\t0\t{statement}\n")
                handle.flush()
                continue
            gained = library_bytes(executable) - baseline
            net = net_score(executable) - baseline_net
            handle.write(f"{net}\t{gained}\t{statement}\n")
            handle.flush()
            if net > 0:
                kept.append((net, statement))
            print(f"[{index}/{len(statements)}] net {net:+5d}  library {gained:+5d}  {statement}",
                  flush=True)
    print(f"\n{len(kept)} of {len(statements)} candidates raise the score")
    for gained, statement in sorted(kept, reverse=True)[:20]:
        print(f"  {gained:+5d}  {statement}")
    return 0


def main() -> int:
    parser = argparse.ArgumentParser(description="Marginal library bytes of one call")
    parser.add_argument("--statement", action="append", default=[])
    parser.add_argument("--declaration", action="append", default=[])
    parser.add_argument("--file", type=Path, default=None, help="a candidate file of STMT: lines")
    parser.add_argument("--out", type=Path, default=ROOT / "build" / "oracle-results.txt")
    parser.add_argument("--declarations-file", type=Path, default=None)
    parser.add_argument("--tag", default="probe")
    args = parser.parse_args()
    if args.declarations_file is not None:
        args.declaration += [
            line.strip()
            for line in args.declarations_file.read_text(encoding="utf-8").splitlines()
            if line.strip()
        ]
    if not args.statement and args.file is None:
        parser.error("give --statement or --file")

    baseline = compile_probe([], args.declaration, f"base-{args.tag}")
    if baseline is None:
        print("the baseline probe does not compile")
        return 1
    base = library_bytes(baseline)
    base_net = net_score(baseline)
    if args.file is not None:
        return batch(args.file, args.declaration, args.out, base, base_net)
    candidate = compile_probe(args.statement, args.declaration, args.tag)
    if candidate is None:
        print(f"the candidate does not compile: {args.statement}")
        return 1
    gained = library_bytes(candidate) - base
    print(f"baseline library bytes {base}")
    print(f"with the candidate       {library_bytes(candidate)}")
    print(f"marginal library         {gained:+d}")
    print(f"net score                {net_score(candidate) - base_net:+d}")
    for statement in args.statement:
        print(f"  {statement}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
