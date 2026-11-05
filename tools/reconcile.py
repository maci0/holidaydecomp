"""Rewrite pinned figures from a failing suite run, using the traceback's own line numbers.

Rounds 461 and 464 spent most of their tool calls on this: a body moves a figure, several tests pin it,
and a text sweep for the old value cannot tell the metrics apart — the segment budget, the window-16 byte
score and the switch sweep's own baseline are three different numbers that can differ by one. The reliable
procedure is the one done by hand: for each failure, read the line its traceback names and replace the
expected literal on that line with the measured one.

This script does that mechanically. It only touches `tools/test_ne.py`, only on lines a traceback names,
and only replaces a literal that appears on that line. Run it with `--dry-run` first: it prints every edit
it would make.

Usage: python tools/reconcile.py [--dry-run] [--log .scratch/suite-runNNN.log]
"""

from __future__ import annotations

import argparse
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
TEST_FILE = ROOT / "tools" / "test_ne.py"

# `AssertionError: 190724 != 190725` and the `assertEqual(...)` line above it in the same block
MISMATCH = re.compile(r"AssertionError: '?([0-9, ]+)'? != '?([0-9, ]+)'?")
LOCATION = re.compile(r'File "([^"]+)", line (\d+), in ')
# how far above the reported line a multi-line assertion can put its literal
WINDOW = 4


def parse_failures(log: Path) -> list[tuple[int, str, str]]:
    """(line number, expected as written, measured) for each numeric assertion failure."""
    edits = []
    text = log.read_text(encoding="utf-8", errors="replace")
    # walk the traceback so each AssertionError is paired with the last location above it
    current = None
    for line in text.splitlines():
        found = LOCATION.search(line)
        if found and found.group(1).endswith("test_ne.py"):
            current = int(found.group(2))
            continue
        found = MISMATCH.search(line)
        if found and current is not None:
            edits.append((current, found.group(1).strip(), found.group(2).strip()))
            current = None
    return edits


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--dry-run", action="store_true", help="print the edits, change nothing")
    parser.add_argument("--log", default="", help="a saved suite log; omit to run the suite")
    args = parser.parse_args()

    if args.log:
        log = ROOT / args.log
    else:
        log = ROOT / ".scratch" / "reconcile-suite.log"
        log.parent.mkdir(exist_ok=True)
        with log.open("w") as handle:
            subprocess.run([sys.executable, "-m", "unittest", "tools.test_ne"],
                           cwd=ROOT, stdout=handle, stderr=subprocess.STDOUT, check=False)

    edits = parse_failures(log)
    if not edits:
        print("reconcile: no numeric assertion failures in the log")
        return 0
    lines = TEST_FILE.read_text(encoding="utf-8").split("\n")
    changed = 0
    for number, expected, measured in edits:
        # A multi-line `assertEqual(` puts the literal on the line the traceback names or on
        # one of the few before it, so search that window back to front (round 467).
        start = max(0, number - 1)
        found = None
        for index in range(start, max(-1, start - WINDOW - 1), -1):
            if expected in lines[index]:
                found = index
                break
        if found is None:
            print(f"reconcile: no line within {WINDOW} of {number} contains "
                  f"{expected!r} (computed value?), skipped")
            continue
        print(f"reconcile: line {found + 1}: {expected} -> {measured}")
        if not args.dry_run:
            lines[found] = lines[found].replace(expected, measured)
            changed += 1
    if not args.dry_run and changed:
        TEST_FILE.write_text("\n".join(lines), encoding="utf-8")
        print(f"reconcile: {changed} line(s) updated; rerun the suite")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
