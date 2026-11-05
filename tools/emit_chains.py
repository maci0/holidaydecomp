#!/usr/bin/env python3
"""emit_chains.py — write the original's far-call operand form into a rebuild.

The original stores internal far calls in *resolved* form: the callee's offset
sits in the instruction, the segment word carries a link to the next call site's
own segment-word field, and one atype-2 record per chain patches the head.
`.scratch/chain_split.py` and `.scratch/split_pairs.py` split that grouping: the
reference breaks one `(source, target)` pair into several chains (1973 chains
against at most one per pair), so this tool follows the reference's own chain
boundaries for the pairs where the target is provable: a covered chain whose
record names `T` together with an uncovered sibling whose nodes' entry-candidate
sets intersect in exactly `{T}`. That is `.scratch/chain_split.py`'s strict
predicate, **31 pairs and 192 sibling chains**, against a loose boundary of 34
and 195. A node of such a pair with no reference counterpart gets no link at
all, and every other pair keeps the one address-ordered chain it had. The
caveats live with the corpus in `.scratch/decode-far-segment-words.md`.

This tool writes that **operand form** into a rebuilt image:

    offset word  <- the record's addend  (the callee's own offset, rule 4)
    segment word <- next node's segment-word field, `next_offset + 2` in
                    segment coordinates, which is `next_site + 3` (rule 3)
    terminal     <- left as it is, so it keeps the `0000`/`FFFF` placeholder

It does **not** rewrite the relocation records (rule 2); that happens in two
later steps, both after this one: `tools/prune_chain_records.py` thins them to
one per chain, and `tools/convert_atype2.py` rewrites the survivors' form.
Pruning has to wait for this tool's addends and conversion has to wait for
both.

Standing caveat: the link words are *our* addresses, so they equal the
original's only where layout has converged, and the callee's offset is right
only where the linked function set matches. Sites whose chain carries no record
in the original (1,677 of them, 1,296 of those single-node) are the residual
the corpus cannot speak for.

Usage:
    python3 tools/emit_chains.py bin/main/HOLIDAY.EXE build/chained.exe
    uv run --frozen python tools/emit_chains.py bin/main/HOLIDAY.EXE build/chained.exe --score
    uv run --frozen python tools/emit_chains.py bin/main/HOLIDAY.EXE build/chained.exe --score --window 32

`--score` prints three numbers against the original: `raw` as built, `folded`
with only the offsets resolved (`tools/fold_far.py`), and `chained` with the
segment links as well, so the chain words are worth the difference between the
last two. The folded number is produced in a scratch file and removed.
"""

from __future__ import annotations

import argparse
import struct
import sys
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(REPO / "tools"))

import decompile as D  # noqa: E402
import fold_far  # noqa: E402
from rebrew.formats import ne_analysis  # noqa: E402

#: The window the project's score quotes (docs/roadmap.md); the gates read 32.
DEFAULT_WINDOW = 16
#: Where the `--score` comparison parks its temporary folded image.
SCRATCH = REPO / ".scratch"


def segment_starts(image: D.Image, out: bytearray) -> list[int]:
    ne = struct.unpack_from("<I", out, 0x3C)[0]
    return [
        struct.unpack_from("<H", out, ne + 0x40 + index * 8)[0] * image.align
        for index in range(len(image.segments))
    ]


def reference_chains(image: D.Image) -> tuple[dict[tuple[int, int], tuple[int, int]],
                                              set[tuple[int, int]], dict[str, int]]:
    """Chain membership in the reference for the pairs where splitting is proven.

    Mirrors `.scratch/chain_split.py`: a chain starts at a far call nothing
    links into and follows each node's segment word to the next same-segment
    site's field until a terminal. A record never breaks the walk; that file
    documents why (zero call-site records sit at non-head nodes, so stopping
    there truncates a covered chain to its head). The split pairs are its
    strict set: a covered chain's `(source, T)` pair also holds an uncovered
    sibling where **the intersection over the sibling's nodes of the per-node
    entry-candidate sets equals exactly `{T}`**, resolved through
    `entry_point_at`. The predicate never looks at the sibling's terminal
    value. Its loose boundary (T in every node's candidates, without
    uniqueness) prints 34 pairs and 195 sibling chains; strict prints **31
    pairs and 192 sibling chains**, the set this tool splits along.

    Only those pairs come back with membership, so the caller splits exactly
    where `target` is provable and leaves every other pair alone.
    """
    rec: dict[tuple[int, int], int] = {}
    for segment, atype, _rtype, offset, target, _addend in D.relocation_records(image):
        if atype != 2:
            continue
        site = offset - 3
        data = image.segments[segment].data
        if 0 <= site < len(data) and data[site] == 0x9A:
            rec[(segment, site)] = target

    sites: dict[tuple[int, int], tuple[int, int]] = {}
    for segment in range(len(image.segments)):
        part = image.segments[segment]
        for function in D.discover(part):
            for instruction in D.procedure_body(part, function):
                if instruction.mnemonic not in ("lcall", "ljmp") or len(instruction.operands) < 2:
                    continue
                raw = part.at(instruction.address, 5)
                if len(raw) == 5 and raw[0] == 0x9A:
                    sites[(segment, instruction.address)] = (
                        raw[1] | raw[2] << 8, raw[3] | raw[4] << 8)

    anchors: dict[int, dict[int, int]] = {}
    for (segment, address) in sites:
        anchors.setdefault(segment, {})[address + 3] = address
    predecessor: set[tuple[int, int]] = set()
    for (segment, address), (_offset_word, segment_word) in sites.items():
        following = anchors.get(segment, {}).get(segment_word)
        if following is not None and following != address:
            predecessor.add((segment, following))
    chains: list[list[tuple[int, int]]] = []
    seen: set[tuple[int, int]] = set()
    for head in sorted(key for key in sites if key not in predecessor):
        if head in seen:
            continue
        path: list[tuple[int, int]] = []
        current: tuple[int, int] | None = head
        while current is not None and current not in seen:
            seen.add(current)
            path.append(current)
            following = anchors.get(current[0], {}).get(sites[current][1])
            current = (current[0], following) if following is not None else None
        chains.append(path)

    covered = [path for path in chains if path[0] in rec]
    covered_pairs = {(path[0][0], rec[path[0]]) for path in covered}
    candidates: dict[int, list[int]] = {}

    def entry_candidates(offset: int) -> list[int]:
        if offset not in candidates:
            candidates[offset] = [
                index for index in range(len(image.segments))
                if D.entry_point_at(image.segments[index], offset)
            ]
        return candidates[offset]

    membership: dict[tuple[int, int], tuple[int, int]] = {}
    split_pairs: set[tuple[int, int]] = set()
    siblings = 0
    for path in (item for item in chains if item[0] not in rec):
        common = [set(entry_candidates(sites[node][0])) for node in path]
        shared = set.intersection(*common) if common else set()
        if len(shared) != 1:
            continue
        target = next(iter(shared)) + 1
        pair = (path[0][0], target)
        if pair not in covered_pairs:
            continue
        split_pairs.add(pair)
        siblings += 1
    chain_number = 0
    for path in chains:
        if path[0] in rec:
            pair: tuple[int, int] | None = (path[0][0], rec[path[0]])
        else:
            common = [set(entry_candidates(sites[node][0])) for node in path]
            shared = set.intersection(*common) if common else set()
            pair = (path[0][0], next(iter(shared)) + 1) if len(shared) == 1 else None
        if pair not in split_pairs:
            continue
        chain_number += 1
        for position, node in enumerate(path):
            membership[node] = (chain_number, position)
    return membership, split_pairs, {"pairs": len(split_pairs), "siblings": siblings,
                                     "chains": len(chains), "covered": len(covered)}


def node_groups(image: D.Image) -> tuple[dict[tuple, list[tuple[int, int, int, int | None]]],
                                          set[tuple[int, int]], dict]:
    """Group the image's internal far-call records, for linking and for pruning.

    The reference's own chain boundaries group the records of a proven split
    pair; every other record joins its `(source, target)` group. Groups come
    back sorted (walk order for a chain group, address order otherwise) with
    the record's source offset in slot 1, which is what both writers need.
    """
    membership, split_pairs, structure = reference_chains(
        D.Image(REPO / "original" / "holiday.exe"))
    grouped: dict[tuple, list[tuple[int, int, int, int | None]]] = {}
    skipped = 0
    for segment, atype, rtype, offset, target, _addend in D.relocation_records(image):
        if atype != 3 or rtype != 0 or offset + 4 > len(image.segments[segment].data):
            continue
        entry = membership.get((segment, offset - 1))
        if entry is not None:
            grouped.setdefault(("chain", entry[0]), []).append((segment, offset, 0, entry[1]))
        elif (segment, target) in split_pairs:
            skipped += 1                  # a proven split pair, and no reference chain to place it in
        else:
            grouped.setdefault(("pair", segment, target), []).append((segment, offset, 0, None))
    for key, nodes in grouped.items():
        if key[0] == "chain":
            nodes.sort(key=lambda node: node[3])       # the reference's walk order
        else:
            nodes.sort(key=lambda node: node[1])
    return grouped, split_pairs, {
        "chains": len(grouped),
        "subchains": sum(1 for key in grouped if key[0] == "chain"),
        "split_pairs": structure["pairs"],
        "sibling_chains": structure["siblings"],
        "split_unmatched": skipped,
        "single_node": sum(1 for nodes in grouped.values() if len(nodes) == 1),
    }


def chain(image: D.Image) -> tuple[bytearray, dict]:
    """Return the image with resolved offsets and chain links, and what was written."""
    out = bytearray(image.data)
    starts = segment_starts(image, out)
    grouped, _split_pairs, group_stats = node_groups(image)

    # rule 4 applies to every internal record, wherever its segment word ends up
    offsets_written = 0
    for segment, atype, rtype, offset, _target, addend in D.relocation_records(image):
        if atype != 3 or rtype != 0:
            continue                      # imports: the addend is an ordinal, not an offset
        if offset + 4 > len(image.segments[segment].data):
            continue                      # the segment word is outside the segment
        struct.pack_into("<H", out, starts[segment] + offset, addend)
        offsets_written += 1

    links_written = 0
    for nodes in grouped.values():        # rule 3: sorted groups from node_groups
        start = starts[nodes[0][0]]
        for index, (_segment, offset, _addend, _position) in enumerate(nodes):
            if index + 1 == len(nodes):
                continue                  # terminal: keep the placeholder the file already has
            # `next_offset + 2` is the next node's segment-word field: the record's
            # source offset points at the instruction's operand, so the instruction
            # starts at `offset - 1` and its segment word at `offset + 2`.
            struct.pack_into("<H", out, start + offset + 2, nodes[index + 1][1] + 2)
            links_written += 1
    return out, {
        **group_stats,
        "offsets": offsets_written,
        "links": links_written,
    }


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("source", type=Path, help="the EXE to emit into")
    ap.add_argument("out", type=Path, help="where to write the chained image")
    ap.add_argument("--score", action="store_true",
                    help="print the raw, folded and chained content scores against the original")
    ap.add_argument("--window", type=int, default=DEFAULT_WINDOW,
                    help=f"score window, default {DEFAULT_WINDOW}")
    args = ap.parse_args()

    image = D.Image(args.source)
    data, stats = chain(image)
    args.out.parent.mkdir(parents=True, exist_ok=True)
    args.out.write_bytes(bytes(data))
    print(
        f"chained {stats['links']} segment words across {stats['chains']} group(s) "
        f"({stats['subchains']} follow the reference's splits, {stats['split_pairs']} proven "
        f"pairs with {stats['sibling_chains']} siblings, {stats['split_unmatched']} node(s) "
        f"left unlinked, {stats['single_node']} single-node) and resolved "
        f"{stats['offsets']} offsets in {args.source} -> {args.out} ({len(data)} bytes)"
    )
    if args.score:
        original = ne_analysis.NeImage(REPO / "original" / "holiday.exe")
        SCRATCH.mkdir(exist_ok=True)
        folded = SCRATCH / "emit-chains-folded.tmp.exe"
        folded_data, _stats = fold_far.fold(image)
        folded.write_bytes(bytes(folded_data))
        try:
            for label, path in (("raw", args.source), ("folded", folded),
                                ("chained", args.out)):
                covered, total = ne_analysis.byte_score(
                    original, ne_analysis.NeImage(path), args.window)
                print(f"{label:7} {covered:,} / {total:,} = "
                      f"{100.0 * covered / total:.2f} % (window {args.window})")
        finally:
            folded.unlink(missing_ok=True)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
