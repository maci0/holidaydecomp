#!/usr/bin/env python3
"""call_truth.py — how accurate is the far-call resolver, and is the call graph a DAG?

The project names a far call's callee by asking which segment has a credible entry
point at the call's offset half. That inference backs `tools/call_pairs.py`,
`tools/unit_exports.py` and the API census in `docs/call-graph.md`, and until now
its accuracy had never been measured against anything exact.

Two checks, both from the image alone:

* **Ground truth.** The original's far calls are the *resolved* form: the file
  holds the callee's offset and an atype-2 fixup patches the segment word, so the
  fixup names the callee segment exactly. Every call site a fixup covers is a test
  case; this compares the record's segment with the resolver's answer.
* **Acyclicity.** Delphi 1 forbids circular unit references, so the original's
  `uses` graph is acyclic. The measured cross-segment *call* graph is not, and this
  reports where the cycles are and whether dropping the weaker direction of each
  mutual pair removes them. The graph is built from `decompile.call_targets`, which
  prefers the fixups, so a call the prologue rule gets wrong does not invent an
  edge; the accuracy check above is what measures the prologue rule itself.

    python3 tools/call_truth.py            # both checks, loose resolver
    python3 tools/call_truth.py --strict   # require one candidate among all segments
    python3 tools/call_truth.py --json
"""

from __future__ import annotations

import argparse
import collections
import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

import decompile  # noqa: E402
import gen_tree  # noqa: E402

ROOT = Path(__file__).resolve().parents[1]
ORIGINAL = ROOT / "original" / "holiday.exe"
UNITS = range(25)


def call_sites(image) -> dict[tuple[int, int], int]:
    """(caller segment, instruction address) -> callee offset, over program segments."""
    classes = decompile.form_classes_by_segment(image)
    sites: dict[tuple[int, int], int] = {}
    for segment in image.program_segments():
        for function in decompile.discover(segment, classes.get(segment.index, [])):
            for ins in decompile.procedure_body(segment, function):
                if ins.mnemonic not in ("lcall", "ljmp") or len(ins.operands) < 2:
                    continue
                key = (segment.index, ins.address)
                if key in sites:
                    continue
                sites[key] = ins.operands[1].imm
    return sites


def resolver(image, sites: dict[tuple[int, int], int], strict: bool) -> dict:
    """The callee the project's rule names for each call site, where it names one."""
    answers = {}
    for (segment, address), offset in sites.items():
        candidates = [
            s
            for s in range(len(image.segments))
            if decompile.entry_point_at(image.segments[s], offset)
        ]
        if strict and len(candidates) != 1:
            continue
        if len(candidates) == 1:
            answers[(segment, address)] = candidates[0]
    return answers


def ground_truth(image, sites: dict[tuple[int, int], int]) -> dict[tuple[int, int], int]:
    """The callee segment the NE fixups name, for the sites they cover."""
    data_by_segment = {segment.index: segment.data for segment in image.segments}
    truth = {}
    for source, atype, _rtype, offset, target, _addend in decompile.relocation_records(image):
        if atype != 2 or source >= 25:
            continue
        site = offset - 3
        if site < 0 or (source, site) not in sites:
            continue
        if data_by_segment[source][site] != 0x9A:
            continue                       # not a far call's segment word
        truth[(source, site)] = target
    return truth


def topological(edges: dict[tuple[int, int], int]) -> list[int] | None:
    """A topological order of the edges, or None when they form a cycle."""
    nodes = sorted({node for edge in edges for node in edge})
    indegree = dict.fromkeys(nodes, 0)
    adjacency: dict[int, list[int]] = collections.defaultdict(list)
    for a, b in edges:
        adjacency[a].append(b)
        indegree[b] += 1
    ready = [node for node in nodes if indegree[node] == 0]
    order = []
    while ready:
        node = ready.pop()
        order.append(node)
        for nxt in adjacency[node]:
            indegree[nxt] -= 1
            if indegree[nxt] == 0:
                ready.append(nxt)
    return order if len(order) == len(nodes) else None


def census(original: Path = ORIGINAL, strict: bool = False) -> dict:
    image = decompile.Image(original)
    sites = call_sites(image)
    answers = resolver(image, sites, strict)
    truth = ground_truth(image, sites)

    agree = disagree = uncovered = 0
    disagreements = []
    for site, target in sorted(truth.items()):
        answer = answers.get(site)
        if answer is None:
            uncovered += 1
            continue
        expected = target - 1
        if answer == expected or answer == target:
            agree += 1
        else:
            disagree += 1
            disagreements.append(
                {
                    "site": f"{site[0]}:{site[1]:#06x}",
                    "offset": sites[site],
                    "resolved": answer,
                    "record": target,
                }
            )

    # The graph uses the fixup map, which is exact where it applies: the prologue
    # rule above is the thing being measured, not the thing to build a graph from.
    edges: collections.Counter[tuple[int, int]] = collections.Counter()
    for (segment, _address), callee in decompile.call_targets(image).items():
        if callee < 25 and callee != segment:
            edges[(segment, callee)] += 1
    mutual = sorted((a, b) for (a, b) in edges if (b, a) in edges and a < b)
    dominant = {
        edge: count
        for edge, count in edges.items()
        if not (edges.get((edge[1], edge[0])) is not None and edges[(edge[1], edge[0])] > count)
    }
    dropped = {edge: count for edge, count in edges.items() if edge not in dominant}
    order = topological(dominant)

    return {
        "sites": len(sites),
        "resolved": len(answers),
        "ground_truth_sites": len(truth),
        "compared_sites": agree + disagree,
        "agree": agree,
        "disagree": disagree,
        "uncovered": uncovered,
        "disagreements": disagreements,
        "edges": len(edges),
        "edge_sites": sum(edges.values()),
        "mutual_pairs": len(mutual),
        "dropped_edges": len(dropped),
        "dropped_sites": sum(dropped.values()),
        "dominant_is_acyclic": order is not None,
        "order": order,
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=(__doc__ or "").splitlines()[0])
    parser.add_argument("--strict", action="store_true",
                        help="only sites with one candidate among all segments")
    parser.add_argument("--json", action="store_true")
    args = parser.parse_args()

    result = census(strict=args.strict)
    if args.json:
        print(json.dumps(result, indent=1))
        return 0

    share = 100 * result["agree"] / max(1, result["agree"] + result["disagree"])
    print("ground truth (atype-2 fixups on far calls):")
    print(f"  covered sites {result['ground_truth_sites']}, compared "
          f"{result['agree'] + result['disagree']}, agree {result['agree']} "
          f"({share:.1f} %), disagree {result['disagree']}, no unique candidate "
          f"{result['uncovered']}")
    unit = {i: gen_tree.UNITS.get(i, ("?", [], ""))[0] for i in range(35)}
    for row in result["disagreements"]:
        print(f"    {row['site']} -> offset {row['offset']:#06x}: resolver says "
              f"{unit.get(row['resolved'], row['resolved'])} ({row['resolved']}), "
              f"the record says {row['record']} ({unit.get(row['record'] - 1, '?')})")
    print("\ncross-unit call graph:")
    print(f"  {result['edges']} edges, {result['edge_sites']} sites, "
          f"{result['mutual_pairs']} mutual pairs")
    print(f"  dropping each mutual pair's weaker direction leaves "
          f"{result['edges'] - result['dropped_edges']} edges and "
          f"{result['edge_sites'] - result['dropped_sites']} sites "
          f"({100 * result['dropped_sites'] / max(1, result['edge_sites']):.1f} % dropped)")
    print(f"  acyclic after that? {'yes' if result['dominant_is_acyclic'] else 'no'}")
    if result["order"]:
        print("  implied order: " + " -> ".join(unit[i] for i in result["order"]))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
