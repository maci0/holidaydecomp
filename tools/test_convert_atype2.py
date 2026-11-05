#!/usr/bin/env python3
"""Checks for tools/convert_atype2.py.  Run: python3 -m unittest tools.test_convert_atype2"""

from __future__ import annotations

import shutil
import struct
import subprocess
import sys
import tempfile
import unittest
from collections import Counter
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "tools"))

import convert_atype2  # noqa: E402
import decompile  # noqa: E402
from rebrew.formats.ne_analysis import NeImage  # noqa: E402

ORIGINAL = ROOT / "original" / "holiday.exe"
REBUILD = ROOT / "bin" / "main" / "HOLIDAY.EXE"


def atypes(ne: NeImage) -> Counter:
    return Counter(
        (segment, fixup.address_type, fixup.relocation_type)
        for segment in range(ne.seg_count)
        for fixup in ne.fixups(segment)
    )


def placements(ne: NeImage) -> list[tuple[int, int, int, int]]:
    sites = decompile.fixup_sites(ne)
    return sorted(
        (segment, sites[segment][n], fixup.target, fixup.relocation_type)
        for segment in range(ne.seg_count)
        for n, fixup in enumerate(ne.fixups(segment))
    )


def block_counts(ne: NeImage) -> list[tuple[int, int]]:
    """(segment file offset, relocation count) for every block on disk."""
    rows = []
    for segment in ne.segment_records:
        if segment.flags & 0x0100 and segment.on_disk:
            start = segment.file_offset + segment.length
            rows.append((start, struct.unpack_from("<H", ne.data, start)[0]))
    return rows


@unittest.skipUnless(ORIGINAL.is_file(), "original binary missing")
class ConvertTest(unittest.TestCase):
    def test_the_reference_is_already_in_this_form(self) -> None:
        """The original has no internal atype-3 records, so conversion is a no-op.

        That is the round trip against the reference's own layout: an image the
        linker already built in the atype-2 form comes out byte for byte, with
        every count and every segment's data untouched.
        """
        image = NeImage(ORIGINAL)
        before = image.data
        data, stats = convert_atype2.convert(image)
        self.assertEqual(stats["converted"], 0)
        self.assertEqual(bytes(data), before)
        self.assertGreater(stats["records"], 0)     # it did read the blocks

    @unittest.skipUnless(REBUILD.is_file(), "rebuilt image missing")
    def test_counts_placements_and_bytes_round_trip(self) -> None:
        """Same size and same counts; every record lands where the rule puts it.

        The record is a fixed eight bytes, so only its bytes change: the atype,
        the addend, and for a converted record the source offset, which moves
        from the operand (`site + 1`) to the segment word (`site + 3`) because
        that is where the reference's atype-2 records on far calls sit. An
        untouched record keeps its placement exactly, and the re-read gives the
        internal atype-3 records gone with the import records untouched.
        """
        source = NeImage(REBUILD)
        data, stats = convert_atype2.convert(source)
        self.assertEqual(len(data), len(source.data))
        self.assertGreater(stats["converted"], 0)
        source_offsets = decompile.fixup_sites(source)
        converted_sites = {
            (segment, source_offsets[segment][n])
            for segment in range(source.seg_count)
            for n, fixup in enumerate(source.fixups(segment))
            if fixup.address_type == 3 and fixup.relocation_type == 0
        }
        self.assertTrue(converted_sites)

        with tempfile.TemporaryDirectory(dir=ROOT / ".scratch") as tmp:
            out = Path(tmp) / "converted.exe"
            out.write_bytes(bytes(data))
            written = NeImage(out)

            self.assertEqual(block_counts(written), block_counts(source))
            expected = sorted(
                (segment, offset + 2 if (segment, offset) in converted_sites else offset,
                 target, rtype)
                for segment, offset, target, rtype in placements(source)
            )
            self.assertEqual(placements(written), expected)

            before, after = atypes(source), atypes(written)
            moved = sum(count for (seg, atype, rtype), count in before.items()
                        if atype == 3 and rtype == 0)
            self.assertEqual(stats["converted"], moved)
            self.assertFalse([key for key in after if key[1] == 3 and key[2] == 0])
            imports_before = sum(count for (_seg, atype, rtype), count in before.items()
                                 if atype == 3 and rtype != 0)
            imports_after = sum(count for (_seg, atype, rtype), count in after.items()
                                if atype == 3 and rtype != 0)
            self.assertEqual(imports_after, imports_before)
            for segment in range(source.seg_count):
                self.assertEqual(written.seg_bytes(segment),
                                 source.seg_bytes(segment),
                                 f"segment {segment + 1} data changed")

            # the internal records moved from atype 3 to atype 2 one for one
            seg2_after = sum(count for (_s, atype, rtype), count in after.items()
                             if atype == 2 and rtype == 0)
            seg2_before = sum(count for (_s, atype, rtype), count in before.items()
                              if atype == 2 and rtype == 0)
            self.assertEqual(seg2_after, seg2_before + moved)

            # every site the conversion touched now reads atype 2 with addend 0,
            # like the reference's; a record that was already atype 2 keeps its
            # own addend, so only the touched sites are checked here
            written_offsets = decompile.fixup_sites(written)
            for segment in range(written.seg_count):
                for n, fixup in enumerate(written.fixups(segment)):
                    if (segment, written_offsets[segment][n]) in converted_sites:
                        self.assertEqual(fixup.address_type, 2)
                        self.assertEqual(fixup.addend, 0)


@unittest.skipUnless(ORIGINAL.is_file(), "original binary missing")
class ConvertScoreTest(unittest.TestCase):
    def test_score_prints_two_numbers_and_leaves_the_source_alone(self) -> None:
        with tempfile.TemporaryDirectory(dir=ROOT / ".scratch") as tmp:
            source = Path(tmp) / "in.exe"
            out = Path(tmp) / "out.exe"
            shutil.copy2(ORIGINAL, source)
            original_bytes = source.read_bytes()
            result = subprocess.run(
                [sys.executable, str(ROOT / "tools" / "convert_atype2.py"),
                 str(source), str(out), "--score"],
                capture_output=True, text=True, cwd=ROOT, timeout=600)
            self.assertEqual(source.read_bytes(), original_bytes,
                             "the tool must write a copy, never its input")
        self.assertEqual(result.returncode, 0, result.stderr)
        lines = [line for line in result.stdout.splitlines()
                 if "%" in line and line.split()[0] in ("raw", "converted")]
        self.assertEqual(len(lines), 2, result.stdout)
        # The reference has nothing to convert, so its score cannot move.
        self.assertEqual(lines[0].split()[1:], lines[1].split()[1:])


if __name__ == "__main__":
    unittest.main()
