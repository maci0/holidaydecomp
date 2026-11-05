#!/usr/bin/env python3
"""Prove the `--check` modes can fail.

Every generator here is compared against its artifact by the suite, and a check
that cannot report a difference is worth nothing — the same argument as the
vacuous-pass floor elsewhere in this project. This tool mutates each artifact by
one byte, runs the generator's `--check`, and expects a non-zero exit. The
artifact is restored in a `finally`, so a crash cannot leave the tree dirty.

    python3 tools/audit_checks.py [--only gen_media]
"""

from __future__ import annotations

import argparse
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent

# (generator, the artifact it checks)
CHECKS = (
    ("gen_pools.py", "src/main/POOLS.PAS"),
    ("gen_tables.py", "src/main/TABLES.PAS"),
    ("gen_data.py", "src/main/DATAVAL.PAS"),
    ("gen_globals.py", "docs/globals.md"),
    ("gen_strings.py", "docs/strings.md"),
    ("gen_units.py", "docs/units.md"),
    ("gen_forms.py", "docs/forms.md"),
    ("gen_media.py", "docs/media.md"),
    ("gen_records.py", "docs/records.md"),
    ("gen_status.py", "docs/status.md"),
    ("worklist.py", "docs/worklist.csv"),
)


def mutate_once(path: Path) -> str:
    original = path.read_text(encoding="utf-8", errors="surrogateescape")
    path.write_text(original + "\\n<!-- audit -->\\n", encoding="utf-8",
                    errors="surrogateescape")
    return original


def main() -> int:
    parser = argparse.ArgumentParser(description="Audit the --check modes")
    parser.add_argument("--only", default=None)
    args = parser.parse_args()
    failures: list[str] = []
    for generator, artifact in CHECKS:
        if args.only and args.only not in generator:
            continue
        path = ROOT / artifact
        if not path.is_file():
            print(f"{generator:20s} {artifact:24s} MISSING ARTIFACT")
            failures.append(generator)
            continue
        # a baseline first: a check that fails on a clean tree "detects" every
        # mutation without checking anything
        baseline = subprocess.run(
            [sys.executable, str(ROOT / "tools" / generator), "--check"],
            capture_output=True, text=True, cwd=ROOT,
        )
        if baseline.returncode != 0:
            print(f"{generator:20s} {artifact:24s} BROKEN (fails on a clean tree)")
            failures.append(generator)
            continue
        original = mutate_once(path)
        try:
            result = subprocess.run(
                [sys.executable, str(ROOT / "tools" / generator), "--check"],
                capture_output=True, text=True, cwd=ROOT,
            )
            verdict = "detects" if result.returncode != 0 else "MISSES"
        finally:
            path.write_text(original, encoding="utf-8", errors="surrogateescape")
        print(f"{generator:20s} {artifact:24s} clean=pass mutation={verdict}")
        if verdict == "MISSES":
            failures.append(generator)
    print(f"\n{len(failures)} of the checks do not detect a change: {failures}")
    return 1 if failures else 0


if __name__ == "__main__":
    raise SystemExit(main())
