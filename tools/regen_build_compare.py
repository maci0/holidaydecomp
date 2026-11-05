#!/usr/bin/env python3
"""Regenerate the tree, rebuild and compare: one command, one lock.

    python3 tools/regen_build_compare.py
    python3 tools/regen_build_compare.py --dry-run
    python3 tools/regen_build_compare.py --window 32

This script locks `.scratch/proj.lock` itself, so never wrap it in an outer
`flock .scratch/proj.lock -c '...'`; the split of which commands lock is on
`proj_lock.locked()`.

This checkout is shared, and `tools/gen_tree.py`, `./build.sh` and
`rebrew binary ne-compare` touch the same files: a tree regenerated under a
running build scores a half-written image, and a build that starts while the
generator is still writing compiles a mix of old and new units. The three steps
therefore run in order, under `.scratch/proj.lock`, the same lock the shared
`flock` commands take:

1. `uv run --frozen python tools/gen_tree.py`
2. `./build.sh`
3. `uv run --frozen --no-sync rebrew binary ne-compare bin/main/HOLIDAY.EXE --window 16`

The first failing step stops the run and exits with that step's status, so a
compile error can never be read as a score. `ne-compare` exits 1 while the two
files differ, which is the honest state of this tree and not a failure of the
pipeline: the report is printed and the exit status is 0, the rule `./verify.sh`
already uses. Exit status 2 means the comparison itself broke (a missing image,
an unparsable file). `--dry-run` prints the commands and runs nothing.
"""

from __future__ import annotations

import argparse
import subprocess
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

from proj_lock import locked, project_root  # noqa: E402

ROOT = project_root()

#: The window the project's score quotes (docs/roadmap.md); the gates read 32.
DEFAULT_WINDOW = 16

#: `ne-compare`: 0 identical, 1 the files differ, 2 the comparison broke.
COMPARE_DIFFERS = 1


def plan(root: Path, window: int) -> list[list[str]]:
    """The pipeline as commands, in the only order that works."""
    return [
        ["uv", "run", "--frozen", "python", str(root / "tools" / "gen_tree.py")],
        [str(root / "build.sh")],
        ["uv", "run", "--frozen", "--no-sync", "rebrew", "binary", "ne-compare",
         str(root / "bin" / "main" / "HOLIDAY.EXE"), "--window", str(window)],
    ]


def run(commands: list[list[str]], root: Path) -> int:
    """Run the steps in order; stop at the first failure, report the difference."""
    for command in commands:
        print(f"+ {' '.join(command)}", flush=True)
        result = subprocess.run(command, cwd=root)
        if result.returncode == COMPARE_DIFFERS and "ne-compare" in command:
            print("the two images differ (exit 1); the report above is the score")
            return 0
        if result.returncode != 0:
            print(f"step failed with exit {result.returncode}: "
                  f"{' '.join(command)}", file=sys.stderr)
            return result.returncode
    return 0


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(
        description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--window", type=int, default=DEFAULT_WINDOW,
                        help=f"ne-compare window, default {DEFAULT_WINDOW}")
    parser.add_argument("--dry-run", action="store_true",
                        help="print the commands without taking the lock")
    args = parser.parse_args(argv)

    commands = plan(ROOT, args.window)
    if args.dry_run:
        for command in commands:
            print(" ".join(command))
        return 0
    with locked(ROOT):
        return run(commands, ROOT)


if __name__ == "__main__":
    raise SystemExit(main())
