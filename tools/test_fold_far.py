#!/usr/bin/env python3
"""Checks for tools/fold_far.py.  Run: python3 -m unittest tools.test_fold_far"""

from __future__ import annotations

import shutil
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "tools"))

import fold_far  # noqa: E402

ORIGINAL = ROOT / "original" / "holiday.exe"


@unittest.skipUnless(ORIGINAL.is_file(), "original binary missing")
class FoldTest(unittest.TestCase):
    def test_folding_the_original_writes_nothing(self) -> None:
        """The original has no `atype-3 rtype-0` records, so folding is a no-op.

        `docs/link-form.md` counts zero of them against the rebuild's 3952, and
        this is that count as a behaviour: an image already in the resolved form
        comes out of `fold()` byte for byte.
        """
        image = fold_far.D.Image(ORIGINAL)
        data, stats = fold_far.fold(image)
        self.assertEqual(stats["written"], 0)
        self.assertEqual(bytes(data), image.data)


@unittest.skipUnless(ORIGINAL.is_file(), "original binary missing")
class ScoreFlagTest(unittest.TestCase):
    def test_score_prints_both_numbers(self) -> None:
        with tempfile.TemporaryDirectory(dir=ROOT / ".scratch") as tmp:
            source = Path(tmp) / "in.exe"
            folded = Path(tmp) / "out.exe"
            shutil.copy2(ORIGINAL, source)
            result = subprocess.run(
                [sys.executable, str(ROOT / "tools" / "fold_far.py"),
                 str(source), str(folded), "--score"],
                capture_output=True, text=True, cwd=ROOT, timeout=600)
        self.assertEqual(result.returncode, 0, result.stderr)
        lines = [line for line in result.stdout.splitlines()
                 if "%" in line and line.split()[0] in ("raw", "folded")]
        self.assertEqual(len(lines), 2, result.stdout)
        # Folding an image that is already resolved must not move its score.
        self.assertEqual(lines[0].split()[1:], lines[1].split()[1:])


if __name__ == "__main__":
    unittest.main()
