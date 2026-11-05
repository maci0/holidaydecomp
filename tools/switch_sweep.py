#!/usr/bin/env python3
"""Sweep DCC's compiler switches and score each build against the original.

The switch lever is the one that moved the score: `-$S-` is worth +65 bytes because
the original was compiled with stack checking off. This tool asks the next question —
is any *other* switch worth anything — by building the whole program once per switch
and scoring each result with the project's own comparator.

    python3 tools/switch_sweep.py            # write build/switch-sweep.json
    python3 tools/switch_sweep.py --check    # compare the cache with a fresh sweep

`-$S-` is in every build because it is the accepted baseline; each run adds one more
switch on top. A switch the compiler rejects is recorded as `build-fail` rather than
dropped, because "the source does not compile with this" is itself the measurement.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import subprocess
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

from rebrew.formats import ne_analysis  # noqa: E402

ROOT = Path(__file__).resolve().parent.parent
ORIGINAL = ROOT / "original" / "holiday.exe"
SOURCE = ROOT / "src" / "main" / "HOLIDAY.DPR"
CACHE = ROOT / "build" / "switch-sweep.json"

#: the one switch already accepted, plus every further switch worth asking about
BASE = "-$S-"
SWITCHES = ("R", "Q", "I", "D", "V", "B", "A", "E", "N", "O", "G", "P", "T", "X", "U", "F")


def build(tag: str, dcc_args: str) -> Path | None:
    out = ROOT / "build" / f"sweep-{tag}.exe"
    command = [sys.executable, "-m", "rebrew.app.main", "build", "delphi", str(SOURCE),
               "--output", str(out), "--work-dir", str(ROOT / "build" / f"dcc-sweep-{tag}"),
               f"--dcc-args={dcc_args}"]
    result = subprocess.run(command, capture_output=True, text=True, cwd=ROOT)
    return out if result.returncode == 0 else None


def score(path: Path) -> int:
    original = ne_analysis.NeImage(ORIGINAL)
    rebuilt = ne_analysis.NeImage(path)
    covered, _total = ne_analysis.byte_score(original, rebuilt, 16)
    return covered


def sweep() -> dict:
    data = ORIGINAL.read_bytes()
    rows: dict[str, dict] = {}
    for switch in SWITCHES:
        tag = switch.lower()
        args = f"{BASE} -${switch}-"
        executable = build(tag, args)
        if executable is None:
            rows[switch] = {"switch": args, "result": "build-fail"}
            continue
        rows[switch] = {"switch": args, "result": "built", "bytes": executable.stat().st_size,
                        "score": score(executable)}
    baseline = build("base", BASE)
    return {
        "key": f"{len(data)}:{hashlib.sha256(data).hexdigest()}",
        "base": BASE,
        "metric": "matching-window-union-v1",
        "window": 16,
        "baseline": {"bytes": baseline.stat().st_size, "score": score(baseline)}
        if baseline else None,
        "switches": rows,
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--check", action="store_true", help="verify, do not write")
    args = parser.parse_args()

    measured = sweep()
    if args.check:
        if not CACHE.is_file():
            print(f"{CACHE.relative_to(ROOT)} is missing")
            return 1
        if json.loads(CACHE.read_text()) != measured:
            print(f"{CACHE.relative_to(ROOT)} is stale")
            return 1
        print(f"{CACHE.relative_to(ROOT)} is current")
        return 0
    CACHE.write_text(json.dumps(measured, indent=1, sort_keys=True) + "\n")
    baseline = measured["baseline"]
    print(f"wrote {CACHE.relative_to(ROOT)}; baseline {baseline['score']} in "
          f"{baseline['bytes']} bytes")
    for switch, row in sorted(measured["switches"].items()):
        if row["result"] == "build-fail":
            print(f"  -${switch}-  build-fail")
        else:
            delta = row["score"] - baseline["score"]
            print(f"  -${switch}-  {row['score']}  ({delta:+d})")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
