#!/usr/bin/env python3
"""The reversal worklist: every discovered procedure with what is known.

Writes `docs/worklist.csv`, one row per procedure: where it is, how big, which
frame form it opens with, whether a method table names it, how many calls it
makes and receives, and whether any document already discusses it.  The last
column is what makes the file useful: it is how much of the program is still
unread (13 of 1306 when this was written).

Sizes and the row set come from the reviewed inventory
(`src/main/function_structure.json`): a reviewed extent merge folds a tail
into its head there, so this file follows the reviewed boundary rather than
the raw prologue table, and the other columns stay discovery's.

    python3 tools/worklist.py            # write
    python3 tools/worklist.py --check    # fail if the file is stale
"""

from __future__ import annotations

import argparse
import collections
import csv
import io
import json
import re
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent
sys.path.insert(0, str(HERE))

import decompile as D  # noqa: E402

ORIGINAL = ROOT / "original" / "holiday.exe"
OUT = ROOT / "docs" / "worklist.csv"


#: sections that name procedures in order to list work rather than describe it
NOT_DOCUMENTATION = ("## What is left to read",)


def documented_offsets() -> str:
    """Every offset any document mentions, as one blob to search.

    A section that exists to say *what has not been read* does not count as having
    read it. Without this the file feeds itself: `docs/units.md` lists the largest
    undocumented procedures, those addresses then count as documented, the list
    changes, and the two generators oscillate instead of converging (round 223).
    """
    chunks = []
    for path in (ROOT / "docs").glob("*.md"):
        if path.name == "worklist.csv":
            continue
        text = path.read_text(encoding="utf-8", errors="replace")
        for heading in NOT_DOCUMENTATION:
            position = text.find(heading)
            if position >= 0:
                text = text[:position]
        chunks.append(text.lower())
    return " ".join(chunks)


def described_pairs() -> set[tuple[int, int]]:
    """Every `<segment>:0x<offset>` a document mentions **outside a table row**.

    The worklist's `documented` column means "the address appears somewhere", and a
    per-segment size dump counts. That is the right test for "has anyone written this
    address down", and the wrong one for "is its behaviour described": 475 of the 1306
    procedures appear only inside tables, 380 of them only in `docs/segment-map.md`'s
    dumps, which give size, frame and call counts. This is the stricter set, and
    `docs/roadmap.md` publishes both so the difference is visible.

    **The count is wrong in both directions, and each has a measured cause.**

    * It over-counts, because **citing a procedure marks it described**: a section that names
      the callers and callees of the procedure it is about counts all of them, so writing up
      `14:0x16B7` and `16:0x145F` moved this set by 7 rather than 2.
    * It under-counts, because a routine can be read and written about **without its address
      ever appearing in prose**. Measured 2026-10-17: **12 of the ledger's 114 byte-exact
      entries** have their address only in table rows, so they read as table-only although
      their bodies are recovered source in a probe. `0:0x3E0D`, the map cell accessor, is the
      shape of the other side: `docs/map-layer.md` describes it in prose *and* names it in a
      list of readers, so it is credited, while a routine described the same way without a
      list would not be.

    The number is therefore neither a floor nor a ceiling for "has anyone read this". It is a
    measure of *how many procedure addresses appear in a sentence*, which is what
    `docs/worklist.csv` can check mechanically.
    """
    pairs: set[tuple[int, int]] = set()
    for path in (ROOT / "docs").glob("*.md"):
        if path.name == "worklist.csv":
            continue
        text = path.read_text(encoding="utf-8", errors="replace")
        for heading in NOT_DOCUMENTATION:
            position = text.find(heading)
            if position >= 0:
                text = text[:position]
        for line in text.splitlines():
            if line.strip().startswith("|"):
                continue
            for match in re.finditer(r"\b(\d{1,2}):0x([0-9a-f]{1,4})\b", line.lower()):
                pairs.add((int(match.group(1)), int(match.group(2), 16)))
    return pairs


def documented_pairs() -> set[tuple[int, int]]:
    """Every `<segment>:0x<offset>` a document mentions, as (segment, offset).

    Comparing numbers rather than spellings matters: `{offset:#06x}` drops leading
    zeros, so the blob this used to search held `21:0x2` and a document that wrote
    `21:0x0002` — the natural spelling — never matched, and a procedure the reversal
    had already read stayed on the worklist. Round 455 found it on `21:0x0002`,
    which `docs/segment-map.md` describes as a hand-lifted procedure.
    """
    pairs: set[tuple[int, int]] = set()
    for match in re.finditer(r"\b(\d{1,2}):0x([0-9a-f]{1,4})\b", documented_offsets()):
        pairs.add((int(match.group(1)), int(match.group(2), 16)))
    return pairs


def rows(image: D.Image) -> list[dict[str, object]]:
    documented = documented_pairs()
    inventory_rows = json.loads(
        (ROOT / "src" / "main" / "function_structure.json").read_text(encoding="utf-8")
    )
    extents = {int(row["va"]): int(row["size"]) for row in inventory_rows}
    classes = D.form_classes_by_segment(image)
    out = []
    for segment in image.program_segments():
        functions = D.discover(segment, classes.get(segment.index, []))
        callers: collections.Counter = collections.Counter()
        near: dict[int, int] = {}
        for function in functions:
            count = 0
            for ins in D.procedure_body(segment, function):
                if ins.mnemonic in ("call",) and ins.operands and ins.operands[0].type == 2:
                    count += 1
                    callers[ins.operands[0].imm] += 1
            near[function.offset] = count
        for function in functions:
            va = function.segment * 0x10000 + function.offset
            if va not in extents:
                continue          # folded into a neighbour by a reviewed extent merge
            body = D.procedure_body(segment, function)
            globals_ = collections.Counter(
                int(match, 16)
                for ins in body
                for match in re.findall(r"\[(0x[0-9a-f]{1,4})\]", ins.op_str)
                # no floor: a bare bracketed address is DGROUP, and DGROUP's
                # initialised part begins at 0 (`[0x7C]` is read 290 times)
            )
            frame = (
                "enter"
                if segment.data[function.offset] == D.ENTER_OPCODE
                else "push/mov"
            )
            out.append(
                {
                    "segment": function.segment,
                    "offset": f"{function.offset:#06x}",
                    "size": extents[va],
                    "frame": frame,
                    "published": function.name or "",
                    "calls_out": near[function.offset],
                    "callers": callers[function.offset],
                    "hottest_global": f"{globals_.most_common(1)[0][0]:#06x}" if globals_ else "",
                    "documented": "yes"
                    if (function.segment, function.offset) in documented
                    else "",
                }
            )
    return out


def render(rows_: list[dict[str, object]]) -> str:
    buffer = io.StringIO()
    writer = csv.DictWriter(buffer, fieldnames=list(rows_[0]), lineterminator="\n")
    writer.writeheader()
    writer.writerows(rows_)
    return buffer.getvalue()


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--check", action="store_true", help="fail when stale")
    args = parser.parse_args()
    if not ORIGINAL.is_file():
        print("original binary missing", file=sys.stderr)
        return 1
    text = render(rows(D.Image(ORIGINAL)))
    if args.check:
        current = OUT.read_text(encoding="utf-8") if OUT.is_file() else ""
        if current != text:
            print(f"{OUT.relative_to(ROOT)} is stale; run tools/worklist.py", file=sys.stderr)
            return 1
        print("worklist is current")
        return 0
    OUT.write_text(text, encoding="utf-8")
    lines = text.splitlines()[1:]
    documented = sum(1 for line in lines if line.endswith("yes"))
    sizes = [int(line.split(",")[2]) for line in lines]
    print(f"{len(lines)} procedures, {documented} discussed in docs/")
    print(f"largest {max(sizes)} bytes, median {sorted(sizes)[len(sizes) // 2]} bytes")
    per_segment: collections.Counter = collections.Counter(
        int(line.split(",")[0]) for line in lines
    )
    print("per segment:", dict(sorted(per_segment.items())))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
