#!/usr/bin/env python3
"""prune_chain_records.py — keep one far-call fixup per chain head.

Rule 2 of the emission (`.scratch/decode-far-segment-words.md` section 5): **one
atype-2 record per chain, at the chain head**, `rtype = 0`, `target =` the
callee segment 1-based, `addend = 0`. Our toolchain emits one record for every
internal far call, so the corpus never matched: 12461 call records against the
reference's 296. This tool deletes the ones that are not their group's head.

Grouping is `emit_chains.node_groups`'s, so the heads are the same chains the
segment-word links already follow: walk order for a proven split pair's chain,
address order inside a `(source, target)` group otherwise. What stays:

* the head of every group;
* every record with no group, which today means a proven split pair's nodes
  with no reference counterpart. Nothing else patches those sites, so their
  record is all they have;
* import records (`rtype = 1`), the other atypes, and the atype-2 records that
  do not sit on a far call (the reference's data-segment references).

Records shrink in place: the block's count drops, later records slide eight
bytes left, the tail the count no longer covers is zeroed, and no segment
after the block moves, because each segment's file offset lives in the NE
header, not in the previous block's length. The file keeps its size.

Section 5's reading is that a head record resolves every node of its chain;
*how* the loader reaches those nodes (following the pointer in the patched
word?) is section 6's open question, with the Windows 3.1 `Nefixup` source and
a load trace named as the settlement. The rebuild is compared byte for byte and
never run, so pruning is a byte-level step on that open question.

Run order, because each step reads what the next one changes:

    emit_chains      writes offsets from every record's addend
    prune_chain_records   deletes non-head records (this tool)
    convert_atype2   rewrites the survivors' atype, addend and source offset

`node_groups` looks a record's site up as `source offset - 1`, which holds only
before `convert_atype2` moves it to `site + 3`, so pruning after conversion
would silently regroup every record and prune the wrong set.

Usage:
    uv run --frozen python tools/emit_chains.py bin/main/HOLIDAY.EXE build/ch.exe
    uv run --frozen python tools/prune_chain_records.py build/ch.exe build/pruned.exe
    uv run --frozen python tools/prune_chain_records.py build/ch.exe build/pruned.exe --score
    uv run --frozen python tools/convert_atype2.py build/pruned.exe build/final.exe

`--score` prints the input and the pruned content score against the original,
so the count-converging step's own byte effect is visible beside the form's.
"""

from __future__ import annotations

import argparse
import struct
import sys
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(REPO / "tools"))

import decompile as D  # noqa: E402
import emit_chains  # noqa: E402
from rebrew.formats import ne_analysis  # noqa: E402
from rebrew.formats.ne_analysis import NeImage  # noqa: E402

#: The window the project's score quotes (docs/roadmap.md); the gates read 32.
DEFAULT_WINDOW = 16
#: One record: atype, rtype, source offset, target, addend.
RECORD = "<BBHHH"
RECORD_SIZE = 8


def prune(image: NeImage) -> tuple[bytearray, dict]:
    """Return the image with non-head call records removed, and what changed."""
    out = bytearray(image.data)
    grouped, _split_pairs, group_stats = emit_chains.node_groups(
        D.Image(image.path))
    heads: set[tuple[int, int]] = set()
    members: set[tuple[int, int]] = set()
    for nodes in grouped.values():
        for index, (segment, offset, _addend, _position) in enumerate(nodes):
            members.add((segment, offset))
            if index == 0:
                heads.add((segment, offset))

    before = deleted = blocks = 0
    # segment_records[].index is one-based (1, 2, 3, ...); relocation_records
    # numbers segments zero-based, so enumerate instead of reading .index
    for number, segment in enumerate(image.segment_records):
        if not segment.flags & 0x0100 or not segment.on_disk:
            continue
        start = segment.file_offset + segment.length
        count = struct.unpack_from("<H", out, start)[0]
        before += count
        blocks += 1
        kept = bytearray()
        for index in range(count):
            position = start + 2 + index * RECORD_SIZE
            atype, rtype, source = out[position], out[position + 1], struct.unpack_from(
                "<H", out, position + 2)[0]
            key = (number, source)
            if rtype == 0 and atype in (2, 3) and key in members and key not in heads:
                deleted += 1                # a non-head of a chain: the head resolves it
                continue
            kept += out[position:position + RECORD_SIZE]
        new_count = len(kept) // RECORD_SIZE
        struct.pack_into("<H", out, start, new_count)
        out[start + 2:new_count * RECORD_SIZE + start + 2] = kept
        # the tail the count no longer covers would still read as records
        out[start + 2 + new_count * RECORD_SIZE:start + 2 + count * RECORD_SIZE] = (
            b"\x00" * (count - new_count) * RECORD_SIZE)
    return out, {
        "records": before,
        "deleted": deleted,
        "kept": before - deleted,
        "blocks": blocks,
        "heads": len(heads),
        "split_unmatched": group_stats["split_unmatched"],
    }


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("source", type=Path, help="the chained EXE to prune")
    ap.add_argument("out", type=Path, help="where to write the pruned image")
    ap.add_argument("--score", action="store_true",
                    help="print the input and pruned content scores against the original")
    ap.add_argument("--window", type=int, default=DEFAULT_WINDOW,
                    help=f"score window, default {DEFAULT_WINDOW}")
    args = ap.parse_args()

    image = NeImage(args.source)
    data, stats = prune(image)
    args.out.parent.mkdir(parents=True, exist_ok=True)
    args.out.write_bytes(bytes(data))
    print(
        f"pruned {stats['deleted']} of {stats['records']} records across "
        f"{stats['blocks']} block(s): {stats['kept']} left ({stats['heads']} heads, "
        f"{stats['split_unmatched']} unplaceable node records kept) "
        f"{args.source} -> {args.out} ({len(data)} bytes)"
    )
    if args.score:
        original = ne_analysis.NeImage(REPO / "original" / "holiday.exe")
        for label, path in (("input", args.source), ("pruned", args.out)):
            covered, total = ne_analysis.byte_score(
                original, ne_analysis.NeImage(path), args.window)
            print(f"{label:7} {covered:,} / {total:,} = "
                  f"{100.0 * covered / total:.2f} % (window {args.window})")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
