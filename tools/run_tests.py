#!/usr/bin/env python3
"""Run the published source and optional native integration tests.

    python3 tools/run_tests.py                        # the full suite, ~6 minutes
    python3 tools/run_tests.py Reproduction Budget    # -k Reproduction -k Budget
    python3 tools/run_tests.py -v gen_tree            # verbose, one keyword
    python3 tools/run_tests.py --durations 10         # also name the 10 slowest

**Never wrap this runner in `flock .scratch/proj.lock -c '...'`.** It takes that
lock itself, so an outer wrapper deadlocks against its own child: on 2026-10-30
one held the lock for thirty minutes behind a twelve-process convoy. Run it
directly, as `./progress.sh` does. Started under an outer holder anyway, it finds
the inherited descriptor and runs under it instead of locking twice; the list of
commands that lock internally is in `tools/proj_lock.py`.

Every positional argument is a `unittest -k` pattern, so the command to run the
dozen tests around one generator is the generator's name. `--durations N` is
unittest's own flag: it lists the slowest tests, which is how a suite that takes
six minutes gets faster rather than only more selective.

Before the suite starts the runner runs `tools/gen_tree.py --check` and names a
stale or broken generated tree. Two tests in the suite run that check, so an
edit to `tools/gen_tree.py` that has not been regenerated turns a whole run red
on two failures; the warning says so in a second instead of after sixteen
minutes.

The runner imports nothing from the project. A bare `python3` here is CPython
3.14 without Rebrew, so `python3 -m unittest tools.test_ne` dies with
`ModuleNotFoundError: No module named 'rebrew'` before it collects a single
test; this starts the pinned environment instead (`uv run --frozen --no-sync
python`), which is where Rebrew 6.8.0 lives. The run takes `.scratch/proj.lock`,
the lock the suite's own build tests need, so a targeted run cannot interleave
with another teammate's build or suite.
"""

from __future__ import annotations

import argparse
import subprocess
import sys
import time
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

from proj_lock import locked, project_root  # noqa: E402

ROOT = project_root()

# Discover the tests shipped in this source-only repository.
SUITE = "discover"


def command(patterns: list[str], *, verbose: bool, quiet: bool, failfast: bool,
            durations: int | None) -> list[str]:
    """The unittest invocation for these patterns, with nothing else added."""
    args = ["uv", "run", "--frozen", "--no-sync", "python", "-m", "unittest", SUITE,
            "-s", "tools", "-p", "test_*.py"]
    if verbose:
        args.append("-v")
    if quiet:
        args.append("-q")
    if failfast:
        args.append("-f")
    if durations is not None:
        args += ["--durations", str(durations)]
    for pattern in patterns:
        args += ["-k", pattern]
    return args


def tree_status() -> str:
    """`gen_tree.py --check`'s complaint, or an empty string when the tree is current.

    The generated units are checked by two tests in the suite, so a teammate who
    has edited `tools/gen_tree.py` without regenerating turns a sixteen-minute run
    red on two failures at the very end. Saying so first costs one command.
    """
    if not (ROOT / "original" / "holiday.exe").is_file() or not (ROOT / "src" / "main" / "HOLIDAY.DPR").is_file():
        return ""
    check = ["uv", "run", "--frozen", "--no-sync", "python",
             str(ROOT / "tools" / "gen_tree.py"), "--check"]
    result = subprocess.run(check, cwd=ROOT, capture_output=True, text=True)
    if result.returncode == 0:
        return ""
    lines = [line for line in (result.stderr or result.stdout).splitlines() if line.strip()]
    return lines[-1] if lines else "gen_tree.py --check failed"


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(
        description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("patterns", nargs="*", metavar="PATTERN",
                        help="unittest -k patterns; repeatable")
    parser.add_argument("-v", "--verbose", action="store_true")
    parser.add_argument("-q", "--quiet", action="store_true")
    parser.add_argument("-f", "--failfast", action="store_true",
                        help="stop at the first failure")
    parser.add_argument("--durations", type=int, default=None, metavar="N",
                        help="report the N slowest tests (0 for all)")
    args = parser.parse_args(argv)

    invocation = command(args.patterns, verbose=args.verbose, quiet=args.quiet,
                         failfast=args.failfast, durations=args.durations)
    print(f"+ {' '.join(invocation)}", flush=True)
    started = time.monotonic()
    with locked(ROOT):
        try:
            stale = tree_status()
        except FileNotFoundError:
            stale = None       # the suite run below reports uv's absence itself
        if stale:
            print(f"warning: the generated tree does not match tools/gen_tree.py:"
                  f" {stale}", file=sys.stderr)
            print("the suite's gen_tree --check tests will fail;"
                  " python3 tools/regen_build_compare.py regenerates, rebuilds"
                  " and compares", file=sys.stderr)
        try:
            result = subprocess.run(invocation, cwd=ROOT)
        except FileNotFoundError:
            print("uv not found: the suite runs in the project's pinned "
                  "environment (uv is the only supported Python toolchain)",
                  file=sys.stderr)
            return 2
    elapsed = time.monotonic() - started
    print(f"exit status {result.returncode} after {elapsed:.1f} s"
          + (f" ({len(args.patterns)} pattern(s))" if args.patterns else ""))
    return result.returncode


if __name__ == "__main__":
    raise SystemExit(main())
