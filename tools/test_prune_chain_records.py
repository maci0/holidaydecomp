#!/usr/bin/env python3
"""Checks for tools/prune_chain_records.py.  Run: python3 -m unittest tools.test_prune_chain_records"""

from __future__ import annotations

import shutil
import subprocess
import sys
import tempfile
import unittest
from collections import Counter
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "tools"))

import convert_atype2  # noqa: E402
import decompile as D  # noqa: E402
import emit_chains  # noqa: E402
import prune_chain_records  # noqa: E402
from rebrew.formats.ne_analysis import NeImage  # noqa: E402

ORIGINAL = ROOT / "original" / "holiday.exe"
REBUILD = ROOT / "bin" / "main" / "HOLIDAY.EXE"


def internal_records(ne: NeImage) -> list[tuple[int, int, int, int]]:
    """(zero-based segment, atype, rtype, source offset) for every record."""
    sites = D.fixup_sites(ne)
    rows = []
    for number, segment in enumerate(ne.segment_records):
        if not (segment.flags & 0x0100 and segment.on_disk):
            continue
        for n, fixup in enumerate(ne.fixups(number)):
            rows.append((number, fixup.address_type, fixup.relocation_type,
                         sites[number][n]))
    return rows


def atypes(ne: NeImage) -> Counter:
    return Counter((segment, atype, rtype)
                   for segment, atype, rtype, _source in internal_records(ne))


@unittest.skipUnless(ORIGINAL.is_file(), "original binary missing")
class PruneTest(unittest.TestCase):
    def test_the_reference_is_left_alone(self) -> None:
        """No internal call records to prune: the reference comes out byte for byte."""
        image = NeImage(ORIGINAL)
        before = image.data
        data, stats = prune_chain_records.prune(image)
        self.assertEqual(stats["deleted"], 0)
        self.assertEqual(stats["heads"], 0)
        self.assertEqual(stats["split_unmatched"], 0)
        self.assertGreater(stats["records"], 0)
        self.assertEqual(bytes(data), before)

    @unittest.skipUnless(REBUILD.is_file(), "rebuilt image missing")
    def test_every_surviving_call_record_is_a_head(self) -> None:
        """Rule 2's count: one record per chain head, nothing else in a chain.

        Feed the chained image (the canonical order is emit, prune, convert),
        and check the three things the tool claims: exactly the group's
        non-head records disappear, nothing outside a group disappears, and
        the file and the untouched record classes keep their bytes.
        """
        chained, emit_stats = emit_chains.chain(D.Image(REBUILD))
        grouped, split_pairs, group_stats = emit_chains.node_groups(D.Image(REBUILD))
        members = set()
        heads = set()
        for nodes in grouped.values():
            for index, (segment, offset, _addend, _position) in enumerate(nodes):
                members.add((segment, offset))
                if index == 0:
                    heads.add((segment, offset))
        grouped_nodes = len(members)
        self.assertEqual(group_stats["chains"], len(heads))
        self.assertEqual(emit_stats["chains"], group_stats["chains"])

        with tempfile.TemporaryDirectory(dir=ROOT / ".scratch") as tmp:
            source = Path(tmp) / "chained.exe"
            out = Path(tmp) / "pruned.exe"
            source.write_bytes(bytes(chained))
            source_bytes = source.read_bytes()
            data, stats = prune_chain_records.prune(NeImage(source))
            self.assertEqual(source.read_bytes(), source_bytes,
                             "the tool must not touch its input")
            self.assertEqual(stats["deleted"], grouped_nodes - stats["heads"])
            self.assertEqual(stats["kept"], stats["records"] - stats["deleted"])
            out.write_bytes(bytes(data))
            self.assertEqual(len(data), len(source_bytes),
                             "records shrink inside the block, not the file")

            written = NeImage(out)
            rows = internal_records(written)
            self.assertEqual(len(rows), stats["kept"],
                             "re-read count must equal what the tool reports")
            for number, atype, rtype, source_offset in rows:
                key = (number, source_offset)
                if key in members:
                    self.assertIn(key, heads,
                                  f"{number}:{source_offset:#x} is not a head "
                                  "but kept its record")
            # imports and every other record class are untouched; only the
            # grouped non-head call records left the census
            self.assertEqual(atypes(written),
                             _minus_call_records(NeImage(source), members, heads))

            # the canonical order still converts afterwards
            converted, convert_stats = convert_atype2.convert(written)
            self.assertGreater(convert_stats["converted"], 0)

    def test_score_prints_input_and_pruned(self) -> None:
        with tempfile.TemporaryDirectory(dir=ROOT / ".scratch") as tmp:
            source = Path(tmp) / "in.exe"
            out = Path(tmp) / "out.exe"
            shutil.copy2(ORIGINAL, source)
            original_bytes = source.read_bytes()
            result = subprocess.run(
                [sys.executable, str(ROOT / "tools" / "prune_chain_records.py"),
                 str(source), str(out), "--score"],
                capture_output=True, text=True, cwd=ROOT, timeout=600)
            self.assertEqual(source.read_bytes(), original_bytes)
        self.assertEqual(result.returncode, 0, result.stderr)
        lines = [line for line in result.stdout.splitlines()
                 if "%" in line and line.split()[0] in ("input", "pruned")]
        self.assertEqual(len(lines), 2, result.stdout)
        # the reference has no internal call records, so pruning cannot move it
        self.assertEqual(lines[0].split()[1:], lines[1].split()[1:])


def _minus_call_records(ne: NeImage, members: set[tuple[int, int]],
                        heads: set[tuple[int, int]]) -> Counter:
    """The census a pruned image must show: every grouped non-head gone, rest same."""
    rows = internal_records(ne)
    dropped = Counter()
    for number, atype, rtype, source in rows:
        if rtype == 0 and atype in (2, 3) and (number, source) in members:
            if (number, source) not in heads:
                dropped[(number, atype, rtype)] += 1
    census = atypes(ne)
    for key, value in dropped.items():
        census[key] -= value
        if census[key] == 0:
            del census[key]
    return census


if __name__ == "__main__":
    unittest.main()
