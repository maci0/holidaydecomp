#!/usr/bin/env python3
"""converge.py — regenerate every generated document, in the one order that works.

Rounds 546-586 ran only three of these each round, so the generated documents drifted and five
tests that check them were failing the whole time. They were invisible for the same reason round
585's shadowed class was: the full suite does not finish under this machine's load, and nothing
else ran those checks. One command is the fix — a partial converge should not be expressible.

    python3 tools/converge.py            # marker, worklists, generators, stores
    python3 tools/converge.py --check    # non-zero if anything would change
"""

from __future__ import annotations

import argparse
import csv
import io
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent

#: Generators, in the order the workflow established: the reading marker first, because the
#: worklist is generated from it, then the documents that read the worklist.
GENERATORS = [
    "gen_roadmap.py", "gen_globals.py", "gen_units.py", "gen_tree_doc.py",
    "gen_media.py", "gen_strings.py", "gen_records.py", "gen_forms.py", "gen_pools.py",
    "gen_status.py", "gen_docs_index.py",
]


def documented_count() -> int:
    rows = list(csv.DictReader(io.StringIO((ROOT / "docs" / "worklist.csv").read_text())))
    return sum(1 for row in rows if row["documented"] == "yes")


def run(script: str, *, check: bool = False) -> None:
    """Run one generator using the project's pinned environment."""
    result = subprocess.run([sys.executable, str(ROOT / "tools" / script), *(["--check"] if check else [])], cwd=ROOT,
                            capture_output=True, text=True)
    if result.returncode != 0:
        print(f"{script} failed:\n{result.stdout[-800:]}\n{result.stderr[-800:]}")
        raise SystemExit(1)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()

    run("worklist.py", check=args.check)
    count = documented_count()
    segment_map = ROOT / "docs" / "segment-map.md"
    text = segment_map.read_text(encoding="utf-8")
    updated = re.sub(r"\*\*\d+ discussed\*\*", f"**{count} discussed**", text)
    if updated != text:
        if args.check:
            print("docs/segment-map.md has a stale discussed marker")
            return 1
        segment_map.write_text(updated, encoding="utf-8")
    print(f"discussed marker: {count}")
    for script in GENERATORS:
        run(script, check=args.check)
        print(f"{script} ok")
    # `gen_tree.py --check` is a check, not a writer: the tree layout has to agree with the map
    result = subprocess.run([sys.executable, str(ROOT / "tools" / "gen_tree.py"), "--check"],
                            cwd=ROOT, capture_output=True, text=True)
    print("gen_tree.py --check: " + ("ok" if result.returncode == 0 else "FAILED"))
    if result.returncode != 0:
        print(result.stdout[-800:])
        return 1
    if (ROOT / "tools" / "gen_rebrew_functions.py").is_file():
        run("gen_rebrew_functions.py", check=args.check)
        print("gen_rebrew_functions.py ok")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
