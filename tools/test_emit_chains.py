#!/usr/bin/env python3
"""Checks for tools/emit_chains.py.  Run: python3 -m unittest tools.test_emit_chains"""

from __future__ import annotations

import shutil
import struct
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "tools"))

import decompile as D  # noqa: E402
import emit_chains  # noqa: E402

ORIGINAL = ROOT / "original" / "holiday.exe"
REBUILD = ROOT / "bin" / "main" / "HOLIDAY.EXE"
FOLDED_TMP = ROOT / ".scratch" / "emit-chains-folded.tmp.exe"


@unittest.skipUnless(ORIGINAL.is_file(), "original binary missing")
class EmitTest(unittest.TestCase):
    def test_the_original_is_already_in_the_target_form(self) -> None:
        """The reference carries no `atype-3 rtype-0` records, so emission is a no-op.

        `docs/link-form.md` counts zero of them against the rebuild, and this is
        that count as a behaviour: an image already in the resolved form comes
        out of `chain()` byte for byte, with nothing written on either word.
        """
        image = D.Image(ORIGINAL)
        data, stats = emit_chains.chain(image)
        self.assertEqual(stats["offsets"], 0)
        self.assertEqual(stats["links"], 0)
        self.assertEqual(stats["chains"], 0)
        self.assertEqual(bytes(data), image.data)

    @unittest.skipUnless(REBUILD.is_file(), "rebuilt image missing")
    def test_words_land_where_the_reference_rule_puts_them(self) -> None:
        """Rules 3 and 4, plus the split pairs, checked against the reference.

        `reference_chains` must reproduce `.scratch/chain_split.py`: 1973
        chains, 296 covered, 31 strict pairs, 192 sibling chains. Every offset
        word carries its record's addend (rule 4); every segment word holds the
        next node's field, where the reference puts that node (the next member
        of its own chain for a split pair, the next offset of the
        `(source, target)` group otherwise); a terminal or a split-pair node
        with no reference counterpart keeps the placeholder the image had.
        """
        membership, split_pairs, structure = emit_chains.reference_chains(D.Image(ORIGINAL))
        self.assertEqual(structure, {"pairs": 31, "siblings": 192,
                                     "chains": 1973, "covered": 296})
        self.assertEqual(len(split_pairs), 31)

        image = D.Image(REBUILD)
        starts = emit_chains.segment_starts(image, bytearray(image.data))
        data, stats = emit_chains.chain(image)
        self.assertEqual((stats["split_pairs"], stats["sibling_chains"]), (31, 192))
        self.assertEqual(stats["links"],
                         stats["offsets"] - stats["split_unmatched"] - stats["chains"])

        internal: list[tuple[int, int, int]] = []
        for segment, atype, rtype, offset, target, addend in D.relocation_records(image):
            if atype != 3 or rtype != 0:
                continue
            if offset + 4 > len(image.segments[segment].data):
                continue
            internal.append((segment, offset, target))
            base = starts[segment] + offset
            self.assertEqual(struct.unpack_from("<H", data, base)[0], addend,
                             f"{segment}:{offset:#x} lost its addend")
        self.assertEqual(len(internal), stats["offsets"])
        self.assertTrue(internal, "the rebuild has no internal atype-3 records")
        ours = {(segment, offset) for segment, offset, _target in internal}

        # expectations, derived from the reference and the records, not from chain()
        chain_links: dict[tuple[int, int], int] = {}
        by_chain: dict[int, list[tuple[int, int, int]]] = {}
        for (segment, site), (chain, position) in membership.items():
            if (segment, site + 1) in ours:
                by_chain.setdefault(chain, []).append((position, segment, site))
        for nodes in by_chain.values():
            nodes.sort()
            for (_position, segment, site), (_next_pos, _next_seg, next_site) in zip(
                    nodes, nodes[1:]):
                chain_links[(segment, site + 1)] = next_site + 3

        pair_links: dict[tuple[int, int], int] = {}
        pair_members: dict[tuple[int, int], list[int]] = {}
        for segment, offset, target in internal:
            if (segment, target) in split_pairs and (segment, offset - 1) not in membership:
                continue
            if (segment, offset - 1) in membership:
                continue
            pair_members.setdefault((segment, target), []).append(offset)
        for key, offsets in pair_members.items():
            offsets.sort()
            for offset, following in zip(offsets, offsets[1:]):
                pair_links[(key[0], offset)] = following + 2
        self.assertEqual(len(chain_links) + len(pair_links), stats["links"])

        skipped = 0
        for segment, offset, target in internal:
            base = starts[segment] + offset + 2
            expected = chain_links.get((segment, offset)) or pair_links.get((segment, offset))
            if expected is None:
                if (segment, target) in split_pairs and (segment, offset - 1) not in membership:
                    skipped += 1
                self.assertEqual(
                    struct.unpack_from("<H", data, base)[0],
                    struct.unpack_from("<H", image.data, base)[0],
                    f"{segment}:{offset:#x} has no reference successor but was written",
                )
                continue
            self.assertEqual(struct.unpack_from("<H", data, base)[0], expected)
        self.assertEqual(skipped, stats["split_unmatched"])


@unittest.skipUnless(ORIGINAL.is_file(), "original binary missing")
class EmitScoreTest(unittest.TestCase):
    def test_score_prints_raw_folded_and_chained(self) -> None:
        with tempfile.TemporaryDirectory(dir=ROOT / ".scratch") as tmp:
            source = Path(tmp) / "in.exe"
            out = Path(tmp) / "out.exe"
            shutil.copy2(ORIGINAL, source)
            result = subprocess.run(
                [sys.executable, str(ROOT / "tools" / "emit_chains.py"),
                 str(source), str(out), "--score"],
                capture_output=True, text=True, cwd=ROOT, timeout=600)
        self.assertEqual(result.returncode, 0, result.stderr)
        lines = [line for line in result.stdout.splitlines()
                 if "%" in line and line.split()[0] in ("raw", "folded", "chained")]
        self.assertEqual(len(lines), 3, result.stdout)
        # The reference is already in the form, so none of the three moves it.
        self.assertEqual({tuple(line.split()[1:]) for line in lines}, {tuple(lines[0].split()[1:])})
        self.assertFalse(FOLDED_TMP.exists(), "the temporary folded image must be removed")


if __name__ == "__main__":
    unittest.main()
