#!/usr/bin/env python3
"""Checks for tools/region_score.py.  Run: python3 -m unittest tools.test_region_score"""

from __future__ import annotations

import ast
import json
import subprocess
import sys
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "tools"))

import region_score  # noqa: E402
from rebrew.formats import ne_analysis  # noqa: E402

ORIGINAL = ROOT / "original" / "holiday.exe"
REBUILT = ROOT / "bin" / "main" / "HOLIDAY.EXE"


class TestParseTarget(unittest.TestCase):
    def test_hex_and_decimal_offsets(self) -> None:
        self.assertEqual(region_score.parse_target("17:0x5841"), (17, 0x5841))
        self.assertEqual(region_score.parse_target("24:67"), (24, 67))

    def test_a_target_without_an_offset_is_rejected(self) -> None:
        for text in ("17", "0x17:0x1", "17:0xzz", "seg:0x1"):
            with self.subTest(text=text), self.assertRaises(ValueError):
                region_score.parse_target(text)


class TestScoreRegion(unittest.TestCase):
    """The window sequence, measured on bytes whose windows are all distinct."""

    BODY = bytes(range(32))
    WINDOW = 4

    def test_the_unit_is_a_window_not_an_instruction(self) -> None:
        # The default window is the score's own (docs/roadmap.md), and a range of
        # 32 NOPs is 32 instructions but 17 windows: the tool counts the second
        # and never decodes the first, so the two units cannot be mixed.
        self.assertEqual(region_score.DEFAULT_WINDOW, 16)
        score = region_score.score_region(b"\x90" * 32, set(),
                                          region_score.DEFAULT_WINDOW)
        self.assertEqual(score["windows"], 17)
        self.assertNotEqual(score["windows"], 32)

    def test_matching_ignores_where_the_other_image_keeps_the_bytes(self) -> None:
        # The window set is taken from the whole other image, so bytes sitting at
        # a different offset there still match: content overlap, not placement.
        relocated = b"\xcc" * 7 + self.BODY
        runs = ne_analysis.block_set(relocated, self.WINDOW)
        score = region_score.score_region(self.BODY, runs, self.WINDOW)
        self.assertEqual(score["matched"], score["windows"])
        self.assertEqual(score["longest"], score["windows"])
        self.assertEqual(score["runs"], 1)

    def test_one_contiguous_run(self) -> None:
        runs = ne_analysis.block_set(self.BODY[8:16], self.WINDOW)
        score = region_score.score_region(self.BODY, runs, self.WINDOW)
        self.assertEqual(score["windows"], 29)
        self.assertEqual(score["matched"], 5)      # the slice's five windows, 8..12
        self.assertEqual(score["covered"], 8)      # their union, [8, 16)
        self.assertEqual(score["runs"], 1)
        self.assertEqual(score["longest"], 5)
        self.assertEqual(score["longest_at"], 8)

    def test_scattered_windows_are_separate_runs(self) -> None:
        runs = {self.BODY[0:4], self.BODY[10:14]}
        score = region_score.score_region(self.BODY, runs, self.WINDOW)
        self.assertEqual(score["matched"], 2)
        self.assertEqual(score["covered"], 8)
        self.assertEqual(score["runs"], 2)
        self.assertEqual(score["longest"], 1)
        self.assertEqual(score["longest_at"], 0)

    def test_no_window_matches(self) -> None:
        score = region_score.score_region(self.BODY, set(), self.WINDOW)
        self.assertEqual(score["matched"], 0)
        self.assertEqual(score["covered"], 0)
        self.assertEqual(score["runs"], 0)
        self.assertEqual(score["longest"], 0)

    def test_a_range_shorter_than_the_window_has_no_window(self) -> None:
        score = region_score.score_region(b"abc", set(), self.WINDOW)
        self.assertEqual(score["windows"], 0)
        self.assertEqual(score["matched"], 0)
        self.assertEqual(score["covered"], 0)

    def test_a_non_positive_window_is_rejected(self) -> None:
        with self.assertRaises(ValueError):
            region_score.score_region(self.BODY, set(), 0)


@unittest.skipUnless(ORIGINAL.is_file() and REBUILT.is_file(), "images missing")
class TestCommandLine(unittest.TestCase):
    """The shipped output of the tool, not a re-derivation of its arithmetic."""

    def run_tool(self, *args: str) -> subprocess.CompletedProcess[str]:
        return subprocess.run(
            [sys.executable, str(ROOT / "tools" / "region_score.py"), *args],
            capture_output=True, text=True, cwd=ROOT, timeout=300)

    def test_json_output_for_one_procedure(self) -> None:
        result = self.run_tool("17:0x5841", "--json")
        self.assertEqual(result.returncode, 0, result.stderr)
        payload = json.loads(result.stdout)
        row = payload["regions"][0]
        self.assertEqual(row["name"], "func_00115841")
        self.assertEqual(row["bytes"], 1586)
        self.assertEqual(row["windows"], 1586 - payload["window"] + 1)
        self.assertLessEqual(row["matched"], row["windows"])
        self.assertLessEqual(row["covered"], row["bytes"])
        self.assertLessEqual(row["longest"], row["matched"])
        if row["matched"]:
            self.assertGreaterEqual(row["runs"], 1)
        # Every window of a body that occurs verbatim must match, and an absent
        # body reports the offset the search did not find.
        if row["verbatim"]:
            self.assertEqual(row["matched"], row["windows"])
            self.assertGreaterEqual(row["verbatim_at"], 0)
        else:
            self.assertEqual(row["verbatim_at"], -1)
        self.assertGreater(payload["image"]["covered"], 0)
        self.assertLessEqual(payload["image"]["covered"], payload["image"]["bytes"])

    def test_a_range_the_inventory_does_not_hold_needs_a_size(self) -> None:
        unknown = self.run_tool("24:0x0001", "--json")
        self.assertEqual(unknown.returncode, 2, unknown.stdout)
        self.assertIn("not in function_structure.json", unknown.stderr)
        sized = self.run_tool("24:0x0001", "--size", "8", "--json")
        self.assertEqual(sized.returncode, 0, sized.stderr)
        self.assertEqual(json.loads(sized.stdout)["regions"][0]["bytes"], 8)

    def test_a_segment_outside_the_image_is_rejected(self) -> None:
        result = self.run_tool("99:0x0", "--size", "8", "--json")
        self.assertEqual(result.returncode, 2, result.stdout)
        self.assertIn("out of range", result.stderr)

    def test_a_range_past_the_end_of_its_segment_is_rejected(self) -> None:
        result = self.run_tool("24:0x0000", "--size", "999999", "--json")
        self.assertEqual(result.returncode, 2, result.stdout)
        self.assertIn("leaves segment", result.stderr)


class TestTheDocstringIsTheContract(unittest.TestCase):
    """The definition lives in the tool's docstring; losing it loses the metric."""

    def test_the_four_choices_and_the_dead_numbers_are_written_down(self) -> None:
        text = (ROOT / "tools" / "region_score.py").read_text(encoding="utf-8")
        doc = text.split('"""')[1]
        for phrase in (
            "## The metric",
            "The original image's segment bytes",          # range selection
            "Windows of `--window` bytes",                 # unit
            "Instructions are never counted",              # unit, the exclusion
            "Exact byte equality against **any** window",  # matching rule
            "each byte counted once",                      # the covered rule
            "## The region figures in `notes.txt` are not reproducible",
            "unreproducible mid-flight measurements",
        ):
            with self.subTest(phrase=phrase):
                self.assertIn(phrase, doc)


class TestTheScorerDoesNotReadTheGenerator(unittest.TestCase):
    """A half-written `tools/gen_tree.py` must not stop a score from being taken."""

    def test_the_module_imports_no_generator(self) -> None:
        tree = ast.parse((ROOT / "tools" / "region_score.py").read_text(encoding="utf-8"))
        imported: set[str] = set()
        for node in ast.walk(tree):
            if isinstance(node, ast.Import):
                imported.update(alias.name for alias in node.names)
            elif isinstance(node, ast.ImportFrom) and node.module:
                imported.add(node.module)
        self.assertNotIn("gen_tree", imported)


if __name__ == "__main__":
    unittest.main()
