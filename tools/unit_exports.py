#!/usr/bin/env python3
"""unit_exports.py — what each unit publishes, and how much of it is recovered.

`tools/call_pairs.py` measures a unit's *outbound* surface: the far calls it makes
into the library. This is the other half — the **inbound** one. A procedure that
some other unit calls is that unit's interface: it has to exist in the unit's
`interface` section for the callers to link, so the set of them is the shape of
the original source tree rather than a guess about it.

    python3 tools/unit_exports.py            # the per-unit table
    python3 tools/unit_exports.py --json     # structured, with the entry offsets

The rule is the same conservative one `tools/call_pairs.py` uses: an offset counts
only when **exactly one** segment carries a credible entry point there, so an
offset several units could claim is attributed to none of them. A call from a
segment to an offset inside that same segment is not an export and is not counted.

The `byte-exact` column cross-references `build/matched-procedures.json`, so the
table doubles as a worklist: the units with the largest published byte counts and
the smallest recovered share are where a reconstruction has the most to win, and
the `--json` form carries every entry offset for one to start from.
"""

from __future__ import annotations

import argparse
import collections
import hashlib
import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

import decompile  # noqa: E402
import gen_tree  # noqa: E402


def project_root(start: Path | None = None) -> Path:
    """The checkout root, found by walking up to the project marker."""
    here = (start or Path(__file__)).resolve()
    for candidate in [here, *here.parents]:
        if (candidate / "rebrew-project.toml").is_file():
            return candidate
    raise FileNotFoundError("no rebrew-project.toml above this script")


ROOT = project_root()
ORIGINAL = ROOT / "original" / "holiday.exe"
CACHE = ROOT / "build" / "unit-exports.json"
LEDGER = ROOT / "build" / "matched-procedures.json"

#: The game's own segments. A call into segments 25-33 is a library call and
#: belongs to `tools/call_pairs.py`, not to a unit's published interface.
UNITS = range(25)


def census(original: Path = ORIGINAL) -> dict:
    """Every cross-unit entry point, by the unit that publishes it."""
    image = decompile.Image(original)
    classes = decompile.form_classes_by_segment(image)
    published: dict[int, collections.Counter] = collections.defaultdict(collections.Counter)
    sizes: dict[tuple[int, int], int] = {}
    targets = decompile.call_targets(image)
    for segment in image.program_segments():
        for function in decompile.discover(segment, classes.get(segment.index, [])):
            sizes[(segment.index, function.offset)] = function.size
            seen: set[tuple[int, int]] = set()
            for ins in decompile.procedure_body(segment, function):
                if ins.mnemonic not in ("lcall", "ljmp") or len(ins.operands) < 2:
                    continue
                # the same dedupe `tools/call_pairs.py` documents: discovered
                # ranges overlap, so a site counts once by its own address
                if (segment.index, ins.address) in seen:
                    continue
                seen.add((segment.index, ins.address))
                # the callee the fixups name where they cover the call, otherwise
                # the one candidate among *all* segments; an offset several
                # segments could claim and no fixup settles is attributed to none
                callee = targets.get((segment.index, ins.address))
                if callee is None or callee not in UNITS or callee == segment.index:
                    continue
                published[callee][ins.operands[1].imm] += 1

    exact = set()
    if LEDGER.is_file():
        for row in json.loads(LEDGER.read_text(encoding="utf-8"))["procedures"]:
            if row["verdict"] == "byte-exact":
                exact.add(row["target"])

    rows = []
    for segment in sorted(published):
        unit = gen_tree.UNITS.get(segment, ("?", [], ""))[0]
        exports = {
            f"{segment}:{offset:#06x}": {
                "offset": offset,
                "size": sizes.get((segment, offset), 0),
                "callers": published[segment][offset],
                "byte_exact": f"{segment}:{offset:#06x}" in exact,
            }
            for offset in sorted(published[segment])
        }
        rows.append(
            {
                "unit": unit,
                "segment": segment,
                "exports": len(exports),
                "bytes": sum(e["size"] for e in exports.values()),
                "recovered": sum(e["size"] for e in exports.values() if e["byte_exact"]),
                "inbound_sites": sum(e["callers"] for e in exports.values()),
                "entries": exports,
            }
        )
    rows.sort(key=lambda row: -row["bytes"])
    data = original.read_bytes()
    return {
        "key": f"{len(data)}:{hashlib.sha256(data).hexdigest()}",
        "units": rows,
        "exports": sum(row["exports"] for row in rows),
        "bytes": sum(row["bytes"] for row in rows),
        "recovered": sum(row["recovered"] for row in rows),
        "inbound_sites": sum(row["inbound_sites"] for row in rows),
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=(__doc__ or "").splitlines()[0])
    parser.add_argument("--json", action="store_true", help="print the census as JSON")
    parser.add_argument("--unit", help="list one unit's entry offsets")
    args = parser.parse_args()

    result = census()
    if args.json:
        print(json.dumps(result, indent=1))
        return 0

    text = json.dumps(result, indent=1, sort_keys=True) + "\n"
    if not CACHE.is_file() or CACHE.read_text(encoding="utf-8") != text:
        CACHE.parent.mkdir(parents=True, exist_ok=True)
        CACHE.write_text(text, encoding="utf-8")

    if args.unit:
        for row in result["units"]:
            if row["unit"] != args.unit:
                continue
            print(f"{row['unit']} (segment {row['segment']}): {row['exports']} entry points")
            for target, entry in sorted(row["entries"].items(), key=lambda kv: -kv[1]["size"]):
                mark = "exact" if entry["byte_exact"] else "     "
                print(
                    f"  {target:12s} {entry['size']:6d} bytes "
                    f"{entry['callers']:4d} call sites  {mark}"
                )
            return 0

    print(f"{'unit':10s} {'seg':>4} {'exports':>8} {'bytes':>8} {'inbound':>8} {'exact':>7} {'share':>7}")
    for row in result["units"]:
        share = f"{100 * row['recovered'] / row['bytes']:.0f}%" if row["bytes"] else "-"
        print(
            f"{row['unit']:10s} {row['segment']:4d} {row['exports']:8d} {row['bytes']:8d} "
            f"{row['inbound_sites']:8d} {row['recovered']:7d} {share:>7}"
        )
    print(
        f"{'program':10s} {'':4s} {result['exports']:8d} {result['bytes']:8d} "
        f"{result['inbound_sites']:8d} {result['recovered']:7d} "
        f"{100 * result['recovered'] / result['bytes']:6.1f}%"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
