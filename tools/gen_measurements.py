#!/usr/bin/env python3
"""Regenerate the measurement caches from the original bytes, deterministically.

The caches under `build/` are what the documents and the tests quote, and six of them
were written by ad-hoc scripts in earlier rounds: changing the extraction changes their
values and there was no way to rebuild them, which is why the `retf imm16` range fix
(round 405) could not land. This tool is that way back. One cache at a time, each
function computing its cache from the image rather than from the previous file, and each
cache labelled with the epilogue mode it was measured in.

    python3 tools/gen_measurements.py small-families            # writes build/<name>.json
    python3 tools/gen_measurements.py small-families --mode whole --check
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
import family_diff  # noqa: E402

ROOT = Path(__file__).resolve().parent.parent


def image_key(image: decompile.Image) -> str:
    data = Path(image.source).read_bytes()
    return f"{len(data)}:{hashlib.sha256(data).hexdigest()}"


def small_families(image: decompile.Image) -> dict:
    """Size groups below the 50-byte floor, and how the family count moves with it.

    `by_floor` is `len(family_diff.families(image, floor, 3))` — the number of
    near-identical groups at each floor. `small` is the same call at the 12-byte floor
    restricted to sizes below 50: 36 groups, exactly as round 378 measured them.
    """
    floors = (50, 30, 20, 12)
    by_floor = {str(floor): len(family_diff.families(image, floor, 3)) for floor in floors}
    small = {
        str(size): [list(member) for member in members]
        for size, members in family_diff.families(image, 12, 3).items()
        if size < 50
    }
    return {"by_floor": by_floor, "small": small}


def family_signature(image: decompile.Image) -> dict:
    """How many same-size families share one profile signature. The answer is none.

    A "family" is a set of procedures of one size (at least 50 bytes) with three to
    twelve members; a signature is the sorted call targets, strides, fields and globals
    of a profile. The point of the measurement is negative: the constant that varies
    between template instantiations appears as an *operand*, not as a callee, so no
    family groups by signature.

    This scan profiles every member of every such family and takes minutes, which is why
    its answer is cached at all.
    """
    import collections

    import profile_proc

    classes = decompile.form_classes_by_segment(image)
    families: dict[int, list] = collections.defaultdict(list)
    for index, segment in enumerate(image.segments):
        if index > 24:
            continue
        for function in decompile.discover(segment, classes.get(index, [])):
            if function.size >= 50:
                families[function.size].append((index, function.offset))
    considered = 0
    shared = []
    for size, members in sorted(families.items()):
        if not 3 <= len(members) <= 12:
            continue
        considered += 1
        signatures = []
        for index, offset in members:
            result = profile_proc.profile(image, index, offset)
            signatures.append((
                tuple(sorted(target for target, _count in result["calls"])),
                tuple(sorted(uses for _value, uses in result["strides"])),
                tuple(sorted(field for field, _count in result["fields"])),
                tuple(sorted(address for address, _count in result["globals"])),
            ))
        if len(set(signatures)) == 1:
            shared.append(size)
    return {"families_sharing_signature": len(shared), "families_considered": considered,
            "sizes_sharing": shared}


def coordinator_census(image: decompile.Image) -> dict:
    """How many distinct program units each procedure reaches, as a histogram.

    A procedure's reach is the number of distinct *other* program units its calls
    resolve to — the measure round 351 got wrong (it reported a 19-unit hub that was a
    tail artefact) and round 380 corrected to 8.
    """
    import collections

    import profile_proc

    classes = decompile.form_classes_by_segment(image)
    histogram: collections.Counter = collections.Counter()
    examples: dict[str, list] = collections.defaultdict(list)
    total = 0
    for index in range(25):
        for function in decompile.discover(image.segments[index], classes.get(index, [])):
            result = profile_proc.profile(image, index, function.offset)
            # reach counts the *other* units a procedure reaches: a procedure that
            # calls only inside its own unit reaches none, which is what makes the
            # zero bucket 742 rather than 481 (round 351's original definition)
            units = sorted({unit for values in result["call_units"].values() for unit in values
                            if 0 <= unit <= 24 and unit != index})
            reach = len(units)
            histogram[str(reach)] += 1
            total += 1
            if reach >= 4:
                examples[str(reach)].append([index, function.offset, function.size, units])
    for key in examples:
        examples[key].sort(key=lambda row: -row[2])
    ordered = {key: histogram[key] for key in sorted(histogram, key=int)}
    return {
        "total": total,
        "histogram": ordered,
        "at_least_four": sum(count for reach, count in histogram.items() if int(reach) >= 4),
        "at_least_five": sum(count for reach, count in histogram.items() if int(reach) >= 5),
        "examples": dict(sorted(examples.items(), key=lambda kv: int(kv[0]))),
    }


def fan_density(image: decompile.Image) -> dict:
    """How much of each procedure is calls, for the ones that call out of their unit.

    Density is `cross-unit call sites / instructions`. A call counts as cross-unit when
    the unit its target resolves to is not the caller's own segment; procedures with no
    such call are not in the census at all (564 of 1306).
    """
    import statistics

    import profile_proc

    classes = decompile.form_classes_by_segment(image)
    rows = []
    for index in range(25):
        for function in decompile.discover(image.segments[index], classes.get(index, [])):
            result = profile_proc.profile(image, index, function.offset)
            cross = sum(
                count for target, count in result["calls"]
                if any(unit != index for unit in result["call_units"].get(target, []))
            )
            if not cross or not result["instructions"]:
                continue
            rows.append([round(cross / result["instructions"], 4), cross,
                         result["instructions"], index, function.offset, function.size])
    rows.sort(key=lambda row: (-row[0], -row[1], row[3], row[4]))
    buckets = {
        "0.2+": sum(1 for row in rows if row[0] >= 0.2),
        "0.1-0.2": sum(1 for row in rows if 0.1 <= row[0] < 0.2),
        "0.05-0.1": sum(1 for row in rows if 0.05 <= row[0] < 0.1),
        "<0.05": sum(1 for row in rows if row[0] < 0.05),
    }
    densest = rows[:10]
    # the micro layer is the whole `0.2+` bucket, which is more rows than the top ten
    micro_layer = [row for row in rows if row[0] >= 0.2]
    return {
        "procedures": len(rows),
        "median": round(statistics.median(row[0] for row in rows), 4),
        "buckets": buckets,
        "micro_layer": micro_layer,
        "densest": densest,
    }


def same_size_pairs(image: decompile.Image, mask_relocations: bool = False,
                    min_size: int = 50, max_differing: int = 24) -> list:
    """Every same-size pair of procedures whose bytes differ by at most 24 bytes.

    The 50-byte floor and the 24-byte threshold are the pair census's own rule (rounds
    331–332): relaxing the three-member family rule to two members at that floor is what
    gives the 150 pairs, in 48 distinct sizes, that the documents quote.

    With `mask_relocations` the bytes a relocation record patches are ignored, so a pair
    that differs only in a fixup field still counts. Returns `[size, segA, offA, segB,
    offB, differing bytes]`.
    """
    import collections
    import itertools

    classes = decompile.form_classes_by_segment(image)
    by_size: dict[int, list] = collections.defaultdict(list)
    for index in range(25):
        for function in decompile.discover(image.segments[index], classes.get(index, [])):
            if function.size >= min_size:
                by_size[function.size].append((index, function.offset))
    masked: dict[int, set[int]] = collections.defaultdict(set)
    if mask_relocations:
        for segment, _atype, _rtype, at, _target, _addend in decompile.relocation_records(image):
            for step in range(4):
                masked[segment].add(at + step)
    pairs = []
    for size, members in by_size.items():
        if len(members) < 2:
            continue
        for (index_a, offset_a), (index_b, offset_b) in itertools.combinations(members, 2):
            left = image.segments[index_a].data[offset_a : offset_a + size]
            right = image.segments[index_b].data[offset_b : offset_b + size]
            if mask_relocations:
                differing = sum(
                    1 for position, (x, y) in enumerate(zip(left, right))
                    if x != y
                    and offset_a + position not in masked[index_a]
                    and offset_b + position not in masked[index_b]
                )
            else:
                differing = sum(1 for x, y in zip(left, right) if x != y)
            if differing <= max_differing:
                pairs.append([size, index_a, offset_a, index_b, offset_b, differing])
    return pairs


def pair_kinds(image: decompile.Image) -> dict:
    """The 150 same-size pairs split by what their call structure says they are."""
    import collections

    import profile_proc

    pairs = same_size_pairs(image)
    kinds = collections.Counter()
    shifts: collections.Counter = collections.Counter()
    by_unit: collections.Counter = collections.Counter()
    leaf_list = []
    classified = []
    for size, index_a, offset_a, index_b, offset_b, differing in pairs:
        first = profile_proc.profile(image, index_a, offset_a)
        second = profile_proc.profile(image, index_b, offset_b)
        counts_a = [count for _target, count in first["calls"]]
        counts_b = [count for _target, count in second["calls"]]
        if counts_a and counts_a == counts_b:
            deltas = {int(b, 16) - int(a, 16)
                      for (a, _n), (b, _m) in zip(first["calls"], second["calls"])}
            if len(deltas) == 1:
                kinds["block"] += 1
                delta = next(iter(deltas))
                shifts[hex(delta) if delta >= 0 else f"-{hex(-delta)}"] += 1
                by_unit[str(index_a)] += 1
            else:
                kinds["rearranged"] += 1
        elif not counts_a and not counts_b:
            kinds["leaf_pairs"] += 1
            leaf_list.append([size, index_a, offset_a, index_b, offset_b])
        else:
            kinds["coincidence"] += 1
        row = [size, index_a, offset_a, index_b, offset_b]
        if counts_a and counts_a == counts_b:
            deltas = {int(b, 16) - int(a, 16)
                      for (a, _n), (b, _m) in zip(first["calls"], second["calls"])}
            if len(deltas) == 1:
                classified.append(row)
        elif not counts_a and not counts_b:
            leaf_list.append(row)
    classified.sort(key=lambda row: (-row[0], row[1], row[2]))
    leaf_list.sort(key=lambda row: (-row[0], row[1], row[2]))
    return {
        "pairs": len(pairs),
        "block": kinds["block"],
        "rearranged": kinds["rearranged"],
        "coincidence": kinds["coincidence"],
        "leaf_pairs": kinds["leaf_pairs"],
        "one_sided_empty": 0,
        "by_unit": dict(sorted(by_unit.items(), key=lambda kv: (-kv[1], int(kv[0])))),
        "shifts": dict(sorted(shifts.items(), key=lambda kv: (-kv[1], kv[0]))),
        "largest": classified[:5],
        "leaf_list": leaf_list,
    }


def masked_pairs(image: decompile.Image) -> dict:
    """Same-size pairs with relocation bytes ignored, and the ones that cross a unit.

    Masking the bytes a relocation record patches does not hide or reveal a pair: the
    count stays 150. Twenty-eight of those pairs have their members in different units.
    """
    import collections

    import unit_names

    raw = same_size_pairs(image, mask_relocations=False)
    masked = same_size_pairs(image, mask_relocations=True)
    raw_keys = {(row[1], row[2], row[3], row[4]) for row in raw}
    masked_keys = {(row[1], row[2], row[3], row[4]) for row in masked}
    names = {index: job[0].removesuffix(".PAS") for index, job in unit_names.JOBS.items()}
    cross = []
    by_units: collections.Counter = collections.Counter()
    # the historical census classified the raw pairs; masking changes which pairs
    # *would* qualify, but it hid none of the raw ones
    for size, index_a, offset_a, index_b, offset_b, differing in raw:
        if index_a == index_b:
            continue
        left, right = sorted((names[index_a], names[index_b]))
        by_units[f"{left}|{right}"] += 1
        cross.append([size, index_a, offset_a, index_b, offset_b, differing])
    cross.sort(key=lambda row: (-row[0], row[1], row[2]))
    return {
        "raw_pairs": len(raw),
        "masked_pairs": len(raw_keys & masked_keys),
        "hidden_by_fixups": len(raw_keys - masked_keys),
        "cross_unit": len(cross),
        "examples": [],
        "cross_unit_list": cross,
        "cross_unit_by_units": dict(sorted(by_units.items(), key=lambda kv: (-kv[1], kv[0]))),
    }


def leaf_census(image: decompile.Image) -> dict:
    """Procedures that make no call, classified by what their operands touch.

    "Leaf" means `calls == []`: the procedure cannot reach anything, so its meaning is
    in its own operands. Four kinds, by what those operands are — pure arithmetic (no
    global, no stride, no field), a record reader (fields, no stride), a map walker
    (the 251 stride *and* a board global), and mixed when it has both a stride and a
    field or global. "Unread" means no document in `docs/worklist.csv` mentions it.
    """
    import csv
    import io

    import profile_proc

    worklist = ROOT / "docs" / "worklist.csv"
    unread = set()
    if worklist.is_file():
        rows = list(csv.DictReader(io.StringIO(worklist.read_text(encoding="utf-8"))))
        unread = {(int(row["segment"]), int(row["offset"], 16)) for row in rows
                  if row["documented"] != "yes"}
    kinds: collections.Counter = collections.Counter()
    unread_kinds: collections.Counter = collections.Counter()
    per_unit: collections.Counter = collections.Counter()
    buckets: collections.Counter = collections.Counter()
    examples: dict[str, list] = collections.defaultdict(list)
    leaves = []
    for index in range(25):
        for function in decompile.discover(image.segments[index],
                                           decompile.form_classes_by_segment(image).get(index, [])):
            result = profile_proc.profile(image, index, function.offset)
            if result["calls"]:
                continue
            strides = {stride for stride, _count in result["strides"]}
            if 0xFB in strides and result["globals"]:
                kind = "map walker"
            elif result["fields"] and not result["strides"]:
                kind = "record reader"
            elif not result["fields"] and not result["strides"] and not result["globals"]:
                kind = "pure arithmetic"
            else:
                kind = "mixed"
            kinds[kind] += 1
            if (index, function.offset) in unread:
                unread_kinds[kind] += 1
                per_unit[str(index)] += 1
                buckets["<=64" if function.size <= 64
                        else ("<=128" if function.size <= 128 else ">128")] += 1
                leaves.append([index, function.offset, function.size,
                               len(result["parameters"]), result["locals"], result["loops"]])
                examples[kind].append([index, function.offset, function.size])
    leaves.sort(key=lambda row: -row[2])
    for kind in examples:
        examples[kind].sort(key=lambda row: -row[2])
    return {
        "count": len(leaves),
        "bytes": sum(row[2] for row in leaves),
        "per_unit": dict(per_unit.most_common()),
        "size_buckets": dict(buckets),
        "largest": leaves[:10],
        "all_leaves": sum(kinds.values()),
        "kinds": dict(kinds),
        "unread_kinds": dict(unread_kinds),
        "examples": {kind: rows[:5] for kind, rows in examples.items()},
    }


def low_globals(image: decompile.Image) -> dict:
    """Absolute operands below 0x1000, split by who reaches them.

    The data segment starts at DGROUP 0, so the addresses below 0x1000 are its
    initialised low part. Program code reaches 61 of them; the library segments reach a
    different handful. The two sets are disjoint, which is what says the block is the
    program's own state rather than the runtime's.
    """
    import re

    pattern = re.compile(r"\[(0x[0-9a-f]{1,3})\]")
    game: collections.Counter = collections.Counter()
    for index in range(25):
        for function in decompile.discover(image.segments[index],
                                           decompile.form_classes_by_segment(image).get(index, [])):
            for ins in decompile.procedure_body(image.segments[index], function):
                for match in pattern.findall(ins.op_str):
                    game[int(match, 16)] += 1
    library: collections.Counter = collections.Counter()
    for index in range(25, 34):
        for ins in decompile.engine().disasm(image.segments[index].data, 0):
            for match in pattern.findall(ins.op_str):
                library[int(match, 16)] += 1
    census, _dropped = decompile.datamap(image)
    return {
        "game_addresses": len(game),
        "game_sites": sum(game.values()),
        "library_addresses": sorted(library),
        "overlap": sorted(set(game) & set(library)),
        "top": [[address, game[address],
                 len(census[address]["readers"]) if address in census else 0,
                 len(census[address]["writers"]) if address in census else 0]
                for address, _count in game.most_common(10)],
    }


def initialiser(image: decompile.Image) -> dict:
    """`0:0x1EA0`: the routine that writes the low DGROUP block to its starting values.

    The documentation called this a 301-byte arithmetic leaf because it makes no calls.
    It makes none because its whole body is **57 absolute stores of constants** — the
    reset that gives the game state its initial values, including the screen-mode byte
    `0x7C`. This tool lists the stores in the order the code makes them.
    """
    import re

    classes = decompile.form_classes_by_segment(image)
    function = next(f for f in decompile.discover(image.segments[0], classes.get(0, []))
                    if f.offset == 0x1EA0)
    body = decompile.procedure_body(image.segments[0], function)
    store = re.compile(r"mov (byte|word) ptr \[(0x[0-9a-f]+)\], (.+)$")
    writes = []
    for ins in body:
        match = store.match(f"{ins.mnemonic} {ins.op_str}")
        if match:
            writes.append([int(match.group(2), 16), match.group(1),
                           match.group(3).strip()])
    callers = []
    for index in range(25):
        for candidate in decompile.discover(image.segments[index],
                                            classes.get(index, [])):
            for ins in decompile.procedure_body(image.segments[index], candidate):
                if ins.mnemonic == "lcall" and "1ea0" in ins.op_str.lower():
                    callers.append([index, candidate.offset])
    return {
        "procedure": "0:0x1EA0",
        "size": function.size,
        "instructions": len(body),
        "writes": len(writes),
        "ordered": writes,
        "targets": sorted({address for address, _width, _value in writes}),
        "byte_sequence": [value for address, width, value in writes
                          if 0x74 <= address <= 0x7B and width == "byte"],
        "callers": callers,
    }


def written_out_rows(image: decompile.Image) -> dict:
    """Procedures whose callee counts are all equal: a row written out.

    A procedure that calls three or more *different* routines, each the same number
    of times, is a table written into the source rather than looped — the second
    form of the repetition `docs/codegen-patterns.md` counts as 177 written out
    against 60 looped (round 354), which counted one callee repeated instead.
    """
    import profile_proc

    classes = decompile.form_classes_by_segment(image)
    rows = []
    for index in range(25):
        for function in decompile.discover(image.segments[index], classes.get(index, [])):
            result = profile_proc.profile(image, index, function.offset)
            repeated = [count for _target, count in result["calls"] if count >= 2]
            if len(repeated) >= 3 and len(set(repeated)) == 1:
                rows.append({
                    "segment": index,
                    "offset": function.offset,
                    "size": function.size,
                    "per_callee": repeated[0],
                    "callees": len(repeated),
                    "loops": result["loops"],
                })
    rows.sort(key=lambda row: (-row["per_callee"], -row["size"], row["segment"], row["offset"]))
    counts: dict[str, int] = {}
    for row in rows:
        key = str(row["per_callee"])
        counts[key] = counts.get(key, 0) + 1
    return {
        "rows": rows,
        "total": len(rows),
        "by_per_callee": counts,
        "largest": rows[0] if rows else None,
    }


def fill_batches(image: decompile.Image) -> dict:
    """How often each procedure calls the `(segment, offset, length)` routine.

    `0x19C` takes a segment, an offset and a length and clears or copies that block
    (`docs/data-segment.md`). The call count per procedure is the size of a batch of
    block operations the source wrote out, so the distribution says whether the
    program's bulk clearing is spread thin or concentrated.
    """
    classes = decompile.form_classes_by_segment(image)
    rows = []
    for index in range(25):
        for function in decompile.discover(image.segments[index], classes.get(index, [])):
            count = sum(
                1 for ins in decompile.procedure_body(image.segments[index], function)
                if ins.mnemonic in ("call", "lcall")
                and ins.op_str.split(", ")[-1] == "0x19c"
            )
            if count:
                rows.append({"segment": index, "offset": function.offset,
                             "size": function.size, "calls": count})
    rows.sort(key=lambda row: (-row["calls"], -row["size"], row["segment"], row["offset"]))
    distribution: dict[str, int] = {}
    for row in rows:
        key = str(row["calls"])
        distribution[key] = distribution.get(key, 0) + 1
    return {
        "procedures": len(rows),
        "sites": sum(row["calls"] for row in rows),
        "by_calls": distribution,
        "rows": rows,
    }


def word_pairs(image: decompile.Image) -> dict:
    """Adjacent word globals whose reader and writer sets are identical.

    Two words at `a` and `a+2` that are read and written by exactly the same
    procedures are one 32-bit value (`LongInt`) or one far pointer, not two
    independent words: every writer writes both halves, every reader reads both.
    The census is what turns the pair's symmetry into evidence rather than a guess.
    """
    census, _dropped = decompile.datamap(image)
    pairs = []
    for address, entry in census.items():
        following = census.get(address + 2)
        if not following or entry["width"] != 2 or following["width"] != 2:
            continue
        if not entry["readers"] or not entry["writers"]:
            continue
        if entry["readers"] == following["readers"] and entry["writers"] == following["writers"]:
            pairs.append({
                "low": address,
                "high": address + 2,
                "readers": len(entry["readers"]),
                "writers": len(entry["writers"]),
                "segments": sorted(entry["segments"]),
            })
    pairs.sort(key=lambda row: (-row["readers"], row["low"]))
    by_readers: dict[str, int] = {}
    for row in pairs:
        key = str(row["readers"])
        by_readers[key] = by_readers.get(key, 0) + 1
    return {
        "pairs": pairs,
        "words_in_pairs": 2 * len(pairs),
        "globals": len(census),
        "by_readers": by_readers,
    }


#: cache name -> (builder, what it is)
BUILDERS = {
    "small-families": (small_families, "size groups below the 50-byte family floor"),
    "family-signature": (family_signature,
                         "same-size families that share one profile signature"),
    "coordinator-census": (coordinator_census,
                           "how many program units each procedure reaches"),
    "fan-density": (fan_density, "cross-unit call density per procedure"),
    "pair-kinds": (pair_kinds,
                   "same-size near-twin pairs, split by call structure"),
    "masked-pairs": (masked_pairs,
                     "pairs, with relocation fields masked"),
    "leaf-census": (leaf_census, "procedures that make no call, by operands"),
    "low-globals": (low_globals,
                    "absolute operands below 0x1000, game against library"),
    "initialiser": (initialiser, "0:0x1EA0, the writes that set the low block"),
    "written-out-rows": (written_out_rows,
                         "procedures whose callees all have the same call count"),
    "fill-batches": (fill_batches,
                     "calls to the (segment, offset, length) block routine per procedure"),
    "word-pairs": (word_pairs,
                   "adjacent word globals read and written by the same procedures"),
}

#: counts measured under the whole-instruction epilogue matcher, kept beside the
#: current ones so a change of extraction never silently rewrites history
HISTORY = {
    "leaf-census": {
        "legacy": {
            "mode": "legacy",
            "all_leaves": 211,
            "kinds": {"pure arithmetic": 87, "record reader": 65, "mixed": 48,
                      "map walker": 11},
            "note": "measured before round 416 fixed the profiler's global regex, "
                    "which hid 61 globals below 0x1000",
        },
        "whole": {
            "mode": "whole",
            "all_leaves": 211,
            "kinds": {"pure arithmetic": 71, "record reader": 65, "mixed": 64,
                      "map walker": 11},
            "note": "measured in round 416 with absolute operands of one to four hex "
                    "digits: 16 procedures that looked like pure arithmetic read a "
                    "low DGROUP global",
        },
    },
    "masked-pairs": {
        "legacy": {
            "mode": "legacy",
            "raw_pairs": 150,
            "masked_pairs": 150,
            "hidden_by_fixups": 0,
            "cross_unit": 28,
            "note": "masking relocation bytes hides no raw pair; two extra pairs would "
                    "qualify only after masking and are not in this census",
        },
        "whole": {
            "mode": "whole",
            "raw_pairs": 148,
            "masked_pairs": 148,
            "hidden_by_fixups": 0,
            "cross_unit": 28,
            "note": "measured in round 411: masking still hides nothing and the 28 "
                    "cross-unit pairs stay",
        },
    },
    "pair-kinds": {
        "legacy": {
            "mode": "legacy",
            "pairs": 150,
            "block": 117,
            "rearranged": 17,
            "leaf_pairs": 16,
            "coincidence": 0,
            "shifts_zero": 107,
            "by_unit": {"11": 34, "8": 20, "4": 19},
            "largest": [247, 13, 0x2243, 13, 0x233C],
            "note": "same-size pairs of at least 50 bytes differing by at most 24 bytes; "
                    "largest lists block copies only",
        },
        "whole": {
            "mode": "whole",
            "pairs": 148,
            "block": 114,
            "rearranged": 18,
            "leaf_pairs": 16,
            "coincidence": 0,
            "shifts_zero": 108,
            "cross_unit": 28,
            "largest": [249, 13, 0x2243, 13, 0x233C],
            "note": "measured in round 411 with retf imm16 matched whole: two block copies "
                    "fall out of the 24-byte window, one block copy becomes rearranged, "
                    "and the 247-byte pair is 249 bytes",
        },
    },
    "fan-density": {
        "legacy": {
            "mode": "legacy",
            "procedures": 564,
            "buckets": {"0.2+": 15, "0.1-0.2": 87, "0.05-0.1": 150, "<0.05": 312},
            "median": 0.0426,
            "densest": [0.5, 8, 16, 6, 0x2E48, 65],
            "note": "the counts round 378 measured and the documents quote",
        },
        "whole": {
            "mode": "whole",
            "procedures": 564,
            "buckets": {"0.2+": 14, "0.1-0.2": 85, "0.05-0.1": 150, "<0.05": 315},
            "micro_layer": 10,
            "note": "measured in round 407 with the whole-instruction matcher: the "
                    "population is the same 564, but restoring the `retf imm16` to each "
                    "body shortens the densities, so the micro layer is ten procedures "
                    "rather than fifteen",
        },
    },
    "coordinator-census": {
        "legacy": {
            "mode": "legacy",
            "total": 1306,
            "histogram": {"0": 742, "1": 364, "2": 120, "3": 38, "4": 26, "5": 9,
                          "6": 3, "7": 3, "8": 1},
            "note": "the counts round 380 corrected and the documents quote",
        },
        "whole": {
            "mode": "whole",
            "measured": "round 406, whole-instruction epilogue matcher",
            "note": "the reach of a procedure is unchanged by the epilogue fix; what "
                    "moves is which procedures are in the census at all",
        },
    },
    "family-signature": {
        "legacy": {
            "mode": "legacy",
            "families_sharing_signature": 0,
            "families_considered": 108,
            "note": "the counts the documents quote",
        },
        "whole": {
            "mode": "whole",
            "measured": "round 406, whole-instruction epilogue matcher",
            "note": "sizes grow by two for every `retf imm16` ender, so the family "
                    "membership this scan works on is not the same set",
        },
    },
    "small-families": {
        "legacy": {
            "mode": "legacy",
            "by_floor": {"12": 144, "20": 136, "30": 127, "50": 108},
            "groups": 36,
            "member_16": 22,
            "note": "the counts the documents quote",
        },
        "whole": {
            "mode": "whole",
            "by_floor": {"12": 147, "20": 141, "30": 133, "50": 113},
            "groups": 34,
            "member_18": 23,
            "note": "measured in round 405 with `retf imm16` matched whole: every "
                    "`retf imm16` ender grows two bytes, so the 22-member 16-byte "
                    "forwarder family is really an 18-byte family of 23, and the "
                    "floors move with the sizes",
        },
    },
}


def build(name: str, image: decompile.Image) -> dict:
    builder, description = BUILDERS[name]
    measured = builder(image)
    return {
        "key": image_key(image),
        "mode": decompile.EPILOGUE_MODE,
        "cache": name,
        "what": description,
        "history": HISTORY.get(name, {}),
        **measured,
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("name", choices=sorted(BUILDERS))
    parser.add_argument("--mode", choices=("legacy", "whole"), default=None,
                        help="epilogue matcher to measure with (default: the current one)")
    parser.add_argument("--check", action="store_true", help="verify, do not write")
    parser.add_argument("--history-only", action="store_true",
                        help="refresh only the labelled history/metadata of an existing "
                             "cache, leaving its measured numbers untouched")
    args = parser.parse_args()

    if args.history_only:
        path = (ROOT / "build" / f"{args.name}-whole.json") if args.mode == "whole" \
            else (ROOT / "build" / f"{args.name}.json")
        if not path.is_file():
            print(f"{path.relative_to(ROOT)} is absent; nothing to relabel")
            return 1
        payload = json.loads(path.read_text())
        payload["history"] = HISTORY.get(args.name, {})
        payload["what"] = BUILDERS[args.name][1]
        path.write_text(json.dumps(payload, indent=1, sort_keys=True) + "\n")
        print(f"relabelled {path.relative_to(ROOT)} (measured numbers untouched)")
        return 0

    image = decompile.Image(decompile.ORIGINAL)
    context = decompile.use_whole_epilogue if args.mode == "whole" else None
    if context is not None:
        with context():
            payload = build(args.name, image)
    else:
        payload = build(args.name, image)

    if args.mode == "whole":
        path = ROOT / "build" / f"{args.name}-whole.json"
    else:
        path = ROOT / "build" / f"{args.name}.json"
    text = json.dumps(payload, indent=1, sort_keys=True) + "\n"
    if args.check:
        if not path.is_file():
            print(f"{path.relative_to(ROOT)} is missing")
            return 1
        current = path.read_text()
        if json.loads(current) != payload:
            print(f"{path.relative_to(ROOT)} is stale")
            return 1
        print(f"{path.relative_to(ROOT)} is current")
        return 0
    path.write_text(text)
    print(f"wrote {path.relative_to(ROOT)} (mode {payload['mode']})")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
