#!/usr/bin/env python3
"""Holiday's approximate prologue/epilogue function-pair gap experiment."""

import argparse
from pathlib import Path

from rebrew.formats import ne_analysis


def best_match(runs: set[bytes], rebuilt_runs: list[set[bytes]]) -> tuple[int, float]:
    """Best segment by shared distinct windows; ties retain the earlier index.

    Also dropped by rebrew 6.15.0 (56acc207); same body, same wheel
    `block_set` underneath.
    """
    best, score = -1, 0
    for i, other in enumerate(rebuilt_runs):
        shared = len(runs & other)
        if shared > score:
            best, score = i, shared
    return best, 100.0 * score / len(runs) if runs else 0.0


def run_sets(ne, block: int = 32):
    """Each segment's overlapping windows once.

    rebrew 6.15.0 dropped its `run_sets` as unused (56acc207); this is
    that three-line body, still on the wheel's `block_set`.
    """
    return [ne_analysis.block_set(ne.seg_bytes(i), block)
            for i in range(ne.seg_count)]

def function_spans(segment: bytes) -> list[tuple[int, int]]:
    """Approximate function extents: `push bp; mov bp,sp` … `leave; retf`."""
    starts = []
    i = 0
    while True:
        j = segment.find(b"\x55\x89\xe5", i)
        if j < 0:
            break
        starts.append(j)
        i = j + 1
    spans = []
    for k, start in enumerate(starts):
        limit = starts[k + 1] if k + 1 < len(starts) else len(segment)
        j = start
        while j + 2 <= len(segment) and j <= limit:
            if segment[j] == 0xC9 and segment[j + 1] in (0xCB, 0xCA):
                spans.append((start, j + 2 + (2 if segment[j + 1] == 0xCA else 0)))
                break
            j += 1
    return spans


def gap_report(a: ne_analysis.NeImage, b: ne_analysis.NeImage) -> None:
    """Where the bytes differ: layout first, then per-unit code coverage."""
    print("layout")
    print(
        f"  alignment shift   original {a.align and a.align.bit_length() - 1} ({a.align}-byte)"
        f"  rebuilt {b.align and b.align.bit_length() - 1} ({b.align}-byte)"
    )
    for label, ne in (("original", a), ("rebuilt", b)):
        offsets = [s[0] for s in ne.segments]
        atypes, rtypes = ne_analysis.relocation_census(ne)
        print(
            f"  {label:8} segments {ne.seg_count:3d}  file order monotone: {offsets == sorted(offsets)}"
        )
        print(
            f"           reloc address types {dict(sorted(atypes.items()))}  "
            f"types {dict(sorted(rtypes.items()))}"
        )
    print()
    print(
        "code: same-size function pairs per original segment (scanner: 55 89 E5 … C9 CB/CA)"
    )
    print(
        f"{'orig':>5} {'rebuilt':>7} {'origlen':>8} {'reblen':>7} {'pairs':>6} {'ident':>6} {'diff bytes':>12} {'shared32%':>9}"
    )
    rebuilt_runs = run_sets(b)
    for i in range(a.seg_count):
        sa = a.seg_bytes(i)
        j, cov = best_match(ne_analysis.block_set(sa, 32), rebuilt_runs)
        if j < 0 or cov == 0.0:
            print(
                f"{i:5d} {'-':>7} {len(sa):8d} {'-':>7} {'-':>6} {'-':>6} {'-':>12} {cov:9.1f}"
            )
            continue
        sb = b.seg_bytes(j)
        spans_a, spans_b = function_spans(sa), function_spans(sb)
        k = 0
        pairs = []
        for start, end in spans_b:
            length = end - start
            while k < len(spans_a) and spans_a[k][1] - spans_a[k][0] != length:
                k += 1
            if k == len(spans_a):
                break
            pairs.append(((start, end), spans_a[k]))
            k += 1
        diffs = [
            sum(1 for p, q in zip(sb[x:y], sa[u:v]) if p != q)
            for (x, y), (u, v) in pairs
        ]
        total = sum(y - x for (x, y), _ in pairs)
        print(
            f"{i:5d} {j:7d} {len(sa):8d} {len(sb):7d} {len(pairs):6d} "
            f"{sum(1 for d in diffs if d == 0):6d} {sum(diffs):5d}/{total:<6d} {cov:9.1f}"
        )


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("original", type=Path)
    parser.add_argument("rebuilt", type=Path)
    args = parser.parse_args()
    a, b = ne_analysis.NeImage(args.original), ne_analysis.NeImage(args.rebuilt)
    gap_report(a, b)
    return 0 if a.data == b.data else 1


if __name__ == "__main__":
    raise SystemExit(main())
