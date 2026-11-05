"""Cheap checks to run between editing the generator and building.

Rounds 443 and 445 each produced a broken generator that `build.sh` either rejected with a
Pascal error or, worse, accepted against a stale image: a duplicate dict key shadowed an
entry (F601 twice), a splice duplicated a block, and twice the edit did not apply at all.
Every one of those is caught here in under a second, which is the point of running this
*before* the two-minute build rather than the fifteen-minute suite after it.

Usage: python tools/preflight.py
"""

from __future__ import annotations

import ast
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent


def duplicate_keys(path: Path) -> list[str]:
    """Dict literals with a repeated constant key: the first entry is shadowed silently."""
    problems = []
    tree = ast.parse(path.read_text(encoding="utf-8"))
    for node in ast.walk(tree):
        if not isinstance(node, ast.Dict):
            continue
        seen = set()
        for key in node.keys:
            if not isinstance(key, ast.Constant):
                continue
            if key.value in seen:
                problems.append(f"{path.name}:{node.lineno}: duplicate key {key.value!r}")
            seen.add(key.value)
    return problems


def main() -> int:
    problems = []
    for name in ("gen_tree.py",):
        try:
            problems.extend(duplicate_keys(ROOT / "tools" / name))
        except SyntaxError as error:
            problems.append(f"{name}: {error}")
    # the generator must run, or the build reuses whatever image is on disk
    run = subprocess.run([sys.executable, "tools/gen_tree.py"], cwd=ROOT,
                         capture_output=True, text=True, check=False)
    if run.returncode:
        problems.append(f"gen_tree.py failed: {run.stderr.strip().splitlines()[-1:]}")
    for problem in problems:
        print(f"PREFLIGHT: {problem}")
    if not problems:
        print("preflight: generator parses, has no shadowed keys and runs")
    return 1 if problems else 0


if __name__ == "__main__":
    raise SystemExit(main())
