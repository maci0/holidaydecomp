#!/usr/bin/env python3
"""library_reach.py — would linking more of the same DCUs supply what is missing?

The library lever has had three readings and each was measured rather than
argued. `library_gap` counts what the original's library segments hold that the
rebuild does not (454 functions, 63 910 bytes) — a census of presence.
`library_calls` counts what the game *calls* (81 distinct functions, 52 present,
29 missing) — a census of reachability from the source. This tool asks the
question the third reading needs an answer to:

    Of the 30 called-but-absent library routines, is any of them a routine the
    rebuild simply did not link yet — reachable from the code it already has?

The answer decides what the lever is. If an absent routine were reached by a
call from code the rebuild already links, then touching more of the API in a
reconstructed unit would pull it in, and the lever is *source*. If every absent
routine is reached only from the game's own unreconstructed bodies, then the
rebuild's link is already as complete as its sources allow, and the lever is the
missing source and nothing else.

    python3 tools/library_reach.py            # the verdict, with the numbers
    python3 tools/library_reach.py --json     # structured

Method, and its bounds:

* "the rebuild already has it" is the same 16-byte window test `library_calls`
  uses: the routine's first 16 bytes appear somewhere in the built image.
* A caller is "reachable" when the same test finds *its* first 16 bytes in the
  rebuild. A caller whose own body is not in the image is not a route by which
  the linker could pull anything in.
* Bodies are read to their first return with a 64-byte cap, so a call count is
  a floor; the *set* of callee offsets is what the verdict uses, and it is
  complete for the bytes read.
* Each caller also carries whether the project has **reconstructed it byte-exactly**
  (`build/matched-procedures.json`). That is a stronger signal than the window test:
  reconstructed code is source the project could link at will, so a missing routine
  with a byte-exact caller is one a build change would pull in. Measured 2026-10-14:
  none of the missing routines has one, and the caller list per routine is what a
  future round would have to reconstruct to reopen the lever.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import re
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

import decompile  #: noqa: E402
import library_attribution  #: noqa: E402
from rebrew.formats import ne_analysis  #: noqa: E402

ROOT = Path(__file__).resolve().parent.parent
ORIGINAL = ROOT / "original" / "holiday.exe"
REBUILT = ROOT / "bin" / "main" / "HOLIDAY.EXE"
CACHE = ROOT / "build" / "library-reach.json"
LEDGER = ROOT / "build" / "matched-procedures.json"

LIBRARY = set(range(25, 34))
WINDOW = 16


def _present(windows: set[bytes], data: bytes, offset: int) -> bool:
    window = data[offset : offset + WINDOW]
    return len(window) == WINDOW and window in windows


NUMBER = re.compile(r"-?0x[0-9a-f]+|\b\d+\b")


def _masked(text: str) -> str:
    """Mask address-like operands, keep code. A small immediate is code.

    A near call's displacement, a far call's offset and a DGROUP address all move with
    the packing; a `mov ah, 0x4a` is a DOS function number and a `cmp al, 5` is a
    comparison. Masking every number would call any two routines with the same skeleton
    identical, so only values at or above 0x100 are masked.
    """
    def replace(match: re.Match) -> str:
        value = match.group(0).lstrip("-")
        number = int(value, 16) if value.startswith("0x") else int(value)
        return "#" if number >= 0x100 else match.group(0)

    return NUMBER.sub(replace, text)


def _shape(instruction) -> tuple[str, str]:
    """A far call's operands are both layout: the original's file holds a resolved
    segment and offset, the rebuild's holds `0` and a placeholder whose atype-3
    relocation record carries the real target."""
    if instruction.mnemonic in ("lcall", "ljmp"):
        return instruction.mnemonic, "#"
    return instruction.mnemonic, _masked(instruction.op_str)


def code_identity(original: Path = ORIGINAL, rebuilt: Path = REBUILT) -> dict:
    """Are the library routines the rebuild *does* link the same code as the original's?

    This is the other half of the reach question. The rebuild links the same DCUs, so a
    present routine should be the same code; if it is, the library's unmatched share is
    *which* functions get linked and not how they compile, and no source change can move
    it. Measured 2026-10-14: 50 present routines, 21 byte-identical in the file, and all
    50 identical instruction for instruction once layout operands are masked, with small
    immediates compared exactly.
    """
    image = decompile.Image(original)
    built = ne_analysis.NeImage(rebuilt).data
    engine = decompile.engine()
    rows = [r for r in library_attribution.census(original, rebuilt)["rows"]
            if r["presence"] == "present"]
    literal, streams, unaligned = 0, 0, []
    for row in rows:
        body = image.segments[row["segment"]].data[row["offset"] : row["offset"] + row["size"]]
        if built.find(body) >= 0:
            literal += 1
        # the copy that matches the longest prefix is the routine: a fixed-length search
        # finds unrelated bytes and disassembles those
        at, prefix = -1, 0
        for start in range(0, len(built) - 8):
            length = 0
            while (length < len(body) and start + length < len(built)
                   and built[start + length] == body[length]):
                length += 1
            if length > prefix:
                at, prefix = start, length
        if prefix < 12:
            unaligned.append(f"{row['segment']}:{row['offset']:#06x}")
            continue
        theirs = [_shape(i) for i in engine.disasm(body, 0)]
        ours = [_shape(i) for i in engine.disasm(built[at : at + len(body)], 0)]
        shared = min(len(theirs), len(ours))
        if shared and theirs[:shared] == ours[:shared]:
            streams += 1
        else:
            unaligned.append(f"{row['segment']}:{row['offset']:#06x}")
    return {
        "present": len(rows),
        "byte_identical_in_the_file": literal,
        "same_instruction_stream": streams,
        "different": unaligned,
    }


def _size(image, caller: str) -> int:
    """The caller procedure's size, for the worklist line."""
    segment, _, offset = caller.partition(":")
    for function in decompile.discover(image.segments[int(segment)]):
        if function.offset == int(offset, 16):
            return function.size
    return 0


def census(original: Path = ORIGINAL, rebuilt: Path = REBUILT) -> dict:
    """Which callers could still pull each missing routine in, and are they there."""
    image = decompile.Image(original)
    data = original.read_bytes()
    built = ne_analysis.NeImage(rebuilt)
    windows = {built.data[i : i + WINDOW] for i in range(len(built.data) - WINDOW + 1)}
    attributed = library_attribution.census(original, rebuilt)
    missing = [row for row in attributed["rows"] if row["presence"] == "absent"]
    exact: set[str] = set()
    if LEDGER.is_file():
        exact = {
            row["target"]
            for row in json.loads(LEDGER.read_text(encoding="utf-8"))["procedures"]
            if row["verdict"] == "byte-exact"
        }

    # Callers of the missing routines, per callee offset.
    callers_of: dict[int, set[tuple[int, int]]] = {}
    for segment in image.program_segments():
        for function in decompile.discover(
            segment, decompile.form_classes_by_segment(image).get(segment.index, [])
        ):
            body = decompile.procedure_body(segment, function)
            for ins in body:
                if ins.mnemonic in ("lcall", "ljmp") and len(ins.operands) >= 2:
                    callers_of.setdefault(ins.operands[1].imm, set()).add(
                        (segment.index, function.offset)
                    )

    rows: list[dict] = []
    for row in missing:
        offset = row["offset"]
        callers = sorted(callers_of.get(offset, ()))
        routes = []
        for segment, at in callers:
            segment_data = image.segments[segment].data
            built_in = _present(windows, segment_data, at)
            name = f"{segment}:{at:#06x}"
            routes.append(
                {
                    "caller": name,
                    "in_rebuild": built_in,
                    "library_caller": segment in LIBRARY,
                    "byte_exact": name in exact,
                }
            )
        from_rebuild = [r for r in routes if r["in_rebuild"] and not r["library_caller"]]
        from_library = [r for r in routes if r["in_rebuild"] and r["library_caller"]]
        from_ledger = [r for r in routes if r["byte_exact"]]
        rows.append(
            {
                "target": f"{row['segment']}:{row['offset']:#06x}",
                "sites": row["sites"],
                "size": row["size"],
                "callers": len(routes),
                "routes_in_rebuild": len(from_rebuild),
                "routes_from_library": len(from_library),
                "byte_exact_callers": [r["caller"] for r in from_ledger],
                "caller_list": [
                    {
                        "caller": r["caller"],
                        "in_rebuild": r["in_rebuild"],
                        "byte_exact": r["byte_exact"],
                        "size": _size(image, r["caller"]),
                    }
                    for r in routes
                ],
            }
        )

    pullable = [row for row in rows if row["routes_in_rebuild"] or row["routes_from_library"]]
    return {
        "key": f"{len(data)}:{hashlib.sha256(data).hexdigest()}",
        "missing": len(rows),
        "with_byte_exact_caller": len([row for row in rows if row["byte_exact_callers"]]),
        "pullable_from_the_rebuild": len(pullable),
        "pullable_from_a_linked_library_routine": len(
            [row for row in rows if row["routes_from_library"]]
        ),
        "rows": rows,
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--json", action="store_true", help="print the census as JSON")
    args = parser.parse_args()

    result = census()
    if args.json:
        print(json.dumps(result, indent=1))
        return 0
    text = json.dumps(result, indent=1)
    if not CACHE.is_file() or CACHE.read_text(encoding="utf-8") != text:
        CACHE.parent.mkdir(parents=True, exist_ok=True)
        CACHE.write_text(text, encoding="utf-8")
        print(f"wrote {CACHE.relative_to(ROOT)}")
    print(
        f"missing library routines: {result['missing']}; "
        f"{result['pullable_from_the_rebuild']} have a caller the rebuild already links"
        + (
            ""
            if result["pullable_from_the_rebuild"]
            else " — so the rebuild's link is already as complete as its sources allow"
        )
    )
    print(
        f"{result['with_byte_exact_caller']} of them have a caller the ledger has already "
        "reconstructed byte-exactly, which is the only route a source change could open"
    )
    for row in result["rows"]:
        if row["routes_in_rebuild"] or row["routes_from_library"]:
            print(
                f"  {row['target']}: {row['sites']} sites, {row['callers']} callers, "
                f"{row['routes_in_rebuild']} from game code the rebuild has, "
                f"{row['routes_from_library']} from library code it has"
            )
    identity = code_identity()
    print(
        f"\nof the {identity['present']} library routines the rebuild links, "
        f"{identity['byte_identical_in_the_file']} are byte-identical in the file and "
        f"{identity['same_instruction_stream']} are the same code instruction for "
        f"instruction once layout operands are masked"
        + (f"; {len(identity['different'])} differ" if identity["different"] else "")
    )
    print("\nthe worklist, per missing routine: its game callers and their sizes")
    for row in result["rows"]:
        if row["byte_exact_callers"]:
            continue
        listed = ", ".join(
            f"{c['caller']} ({c['size']} B{', reconstructed' if c['byte_exact'] else ''})"
            for c in row["caller_list"][:4]
        )
        print(f"  {row['target']}: {row['callers']} callers — {listed}"
              f"{' ...' if row['callers'] > 4 else ''}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
