#!/usr/bin/env python3
"""library_attribution.py — how much of the library-call claim is measured.

`tools/library_calls.py` reports 81 distinct library functions (52 present, 29
missing). That attribution rests on `decompile.resolved_targets()`, whose rule
is *a callee offset with exactly one credible entry point in the whole image*.
This tool separates what the rule measures from what it assumes:

    python3 tools/library_attribution.py            # the census
    python3 tools/library_attribution.py --json     # structured

For every callee offset that resolves to a **library** segment (25-33) it
records the body behind the offset (its length and a digest), whether that
body's bytes appear in the rebuild at all, and — the part the presence test
cannot see — whether the body carries far calls of its own. A library routine
whose body calls further routines is one the *rebuild* cannot supply by
linking more of the same DCUs: the game reaches it, it reaches the rest, and
the reachability is transitive. That is the lever the 30-missing list has been
missing, and it is measured here rather than argued.

Both numbers are bounds, and the tool says which way each errs:

* only offsets with **one** candidate are attributed, so an offset that two
  library segments both look like is counted nowhere (under-count);
* "present" is a 16-byte window test, so a body shorter than 16 bytes is
  counted separately rather than guessed (under-count);
* a body is read to its first return, so a routine with several returns is
  measured short (its call count is a floor);
* 64 bytes is the cap: it is past the prologue of every attributed routine, and
  a longer cap only reaches into the routine that follows, which would credit
  this one with calls it does not make.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import sys
from collections import Counter
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

import decompile  # noqa: E402
from rebrew.formats import ne_analysis  # noqa: E402

ROOT = Path(__file__).resolve().parent.parent
ORIGINAL = ROOT / "original" / "holiday.exe"
REBUILT = ROOT / "bin" / "main" / "HOLIDAY.EXE"
CACHE = ROOT / "build" / "library-bodies.json"

#: The library segments: nine VCL/RTL units, no game unit lives here.
LIBRARY = range(25, 34)

#: A body shorter than this cannot be found by a window test and is not judged.
WINDOW = 16


def body_at(image: decompile.Image, segment: int, offset: int, cap: int = 64) -> bytes:
    """The bytes of the routine at *offset*, up to its first return."""
    data = image.segments[segment].data
    out = bytearray()
    for ins in decompile.engine().disasm(data[offset : offset + cap], offset):
        out += ins.bytes
        if ins.mnemonic in ("ret", "retf"):
            break
    return bytes(out)


def callees_in(
    image: decompile.Image, segment: int, offset: int, body: bytes
) -> tuple[int, set[int]]:
    """(far-call sites, distinct callee offsets) inside the body.

    Both matter and they say different things: the site count is how much of the
    image depends on the routine, the distinct offsets are how much of the
    library has to come with it.
    """
    if not body:
        return 0, set()
    code = image.segments[segment].data[offset : offset + len(body)]
    sites = 0
    targets: set[int] = set()
    for ins in decompile.engine().disasm(code, offset):
        if ins.mnemonic in ("lcall", "ljmp") and len(ins.operands) >= 2:
            sites += 1
            targets.add(ins.operands[1].imm)
    return sites, targets


def census(original: Path = ORIGINAL, rebuilt: Path = REBUILT) -> dict:
    """The attributed library callees, measured."""
    image = decompile.Image(original)
    data = original.read_bytes()
    calls, _indirect = decompile.far_calls(image)
    resolved = decompile.resolved_targets(image, calls)
    built = ne_analysis.NeImage(rebuilt)
    windows = {built.data[i : i + WINDOW] for i in range(len(built.data) - WINDOW + 1)}

    rows: list[dict] = []
    for offset, segment in sorted(resolved.items()):
        if segment not in LIBRARY:
            continue
        body = body_at(image, segment, offset)
        raw = image.segments[segment].data[offset : offset + WINDOW]
        if len(body) < WINDOW:
            presence = "short"
        elif len(raw) == WINDOW and raw in windows:
            presence = "present"
        else:
            presence = "absent"
        call_sites, targets = callees_in(image, segment, offset, body)
        rows.append(
            {
                "segment": segment,
                "offset": offset,
                "sites": calls[offset]["sites"],
                "size": len(body),
                "calls_out": call_sites,
                "distinct_callees": len(targets),
                "presence": presence,
                "sha": hashlib.sha256(body).hexdigest()[:12],
                "callers": sorted(calls[offset]["callers"]),
            }
        )

    # The bound on the other side: offsets whose candidates are *all* library, so
    # the rule attributes them to neither. Their bytes are in the rebuild either
    # way (both candidate segments are linked VCL); what is missing is the name.
    unattributed: list[dict] = []
    for offset, entry in calls.items():
        candidates = entry["candidates"]
        if len(candidates) == 1 or not candidates:
            continue
        if all(segment in LIBRARY for segment in candidates):
            unattributed.append(
                {
                    "offset": offset,
                    "sites": entry["sites"],
                    "candidates": candidates,
                    "callers": sorted(entry["callers"]),
                }
            )
    unattributed.sort(key=lambda row: -row["sites"])

    by_segment = Counter(row["segment"] for row in rows)
    present = [row for row in rows if row["presence"] == "present"]
    absent = [row for row in rows if row["presence"] == "absent"]
    short = [row for row in rows if row["presence"] == "short"]
    transitive = [row for row in absent if row["calls_out"]]
    # Which *other* offsets the absent bodies reach, and how many of them are
    # library routines the rebuild already has. The rest is what a rebuild that
    # linked them would have to bring along.
    reached: set[int] = set()
    for row in absent:
        body = body_at(image, row["segment"], row["offset"])
        _sites, targets = callees_in(image, row["segment"], row["offset"], body)
        reached |= targets
    reached_library = {t for t in reached if resolved.get(t) in LIBRARY}
    return {
        "key": f"{len(data)}:{hashlib.sha256(data).hexdigest()}",
        "attributed": len(rows),
        "present": len(present),
        "absent": len(absent),
        "under_window": len(short),
        "absent_with_calls_of_their_own": len(transitive),
        "sites_reaching_them": sum(row["sites"] for row in transitive),
        "distinct_callees_of_the_absent": len(reached),
        "of_those_library": len(reached_library),
        "per_segment": {str(k): by_segment[k] for k in sorted(by_segment)},
        "unattributed_library_offsets": len(unattributed),
        "unattributed_sites": sum(row["sites"] for row in unattributed),
        "unattributed": unattributed[:10],
        "rows": rows,
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--json", action="store_true", help="print the census as JSON")
    args = parser.parse_args()

    result = census()
    cache = json.dumps(result, indent=1)
    if not args.json:
        if not CACHE.is_file() or CACHE.read_text(encoding="utf-8") != cache:
            CACHE.parent.mkdir(parents=True, exist_ok=True)
            CACHE.write_text(cache, encoding="utf-8")
            print(f"wrote {CACHE.relative_to(ROOT)}")
    if args.json:
        print(json.dumps(result, indent=1))
        return 0
    print(
        f"library callees with exactly one candidate: {result['attributed']} "
        f"({result['present']} bodies present in the rebuild, {result['absent']} absent, "
        f"{result['under_window']} under the {WINDOW}-byte window test)"
    )
    print(
        f"of the absent: {result['absent_with_calls_of_their_own']} call further routines "
        f"themselves ({result['sites_reaching_them']} call sites), reaching "
        f"{result['distinct_callees_of_the_absent']} distinct offsets of which "
        f"{result['of_those_library']} are library routines"
    )
    print(
        "  so each of them is a whole VCL entry point with its own dependencies, not a "
        "leaf the linker dropped: linking more of the same DCUs is what the reachability "
        "test already measures, and it does not produce these"
    )
    for segment, count in sorted(result["per_segment"].items(), key=lambda kv: int(kv[0])):
        print(f"  segment {segment}: {count}")
    print(
        f"and {result['unattributed_library_offsets']} offsets whose candidates are all "
        f"library ({result['unattributed_sites']} sites) are attributed to neither: their "
        "bytes are in the rebuild either way, only their names are missing"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
