#!/usr/bin/env python3
"""Checks for tools/patch_gen_tree.py.  Run: python3 -m unittest tools.test_patch_gen_tree"""

from __future__ import annotations

import json
import sys
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "tools"))

import patch_gen_tree  # noqa: E402


def spec_for(anchor: str, replacement: str, why: str = "a test patch") -> dict:
    return {"why": why, "replacements": [{"anchor": anchor, "replacement": replacement}]}


class TestApply(unittest.TestCase):
    TARGET_TEXT = "def f():\n    return 1\n"

    def test_one_replacement_applies(self) -> None:
        patched = patch_gen_tree.apply(
            self.TARGET_TEXT, spec_for("return 1", "return 2"))
        self.assertEqual(patched, "def f():\n    return 2\n")

    def test_several_replacements_apply_in_order(self) -> None:
        spec = {"why": "two", "replacements": [
            {"anchor": "return 1", "replacement": "return 2"},
            {"anchor": "def f()", "replacement": "def g()"},
        ]}
        self.assertEqual(patch_gen_tree.apply(self.TARGET_TEXT, spec),
                         "def g():\n    return 2\n")

    def test_an_anchor_that_is_absent_refuses(self) -> None:
        with self.assertRaises(patch_gen_tree.PatchRefused) as caught:
            patch_gen_tree.apply(self.TARGET_TEXT, spec_for("return 9", "return 2"))
        self.assertIn("occurs 0 times", str(caught.exception))

    def test_an_ambiguous_anchor_refuses(self) -> None:
        text = "def f():\n    return 1\n    return 1\n"
        with self.assertRaises(patch_gen_tree.PatchRefused) as caught:
            patch_gen_tree.apply(text, spec_for("return 1", "return 2"))
        self.assertIn("expected exactly once", str(caught.exception))

    def test_a_patch_that_does_not_parse_refuses(self) -> None:
        with self.assertRaises(patch_gen_tree.PatchRefused) as caught:
            patch_gen_tree.apply(
                self.TARGET_TEXT, spec_for("return 1", "return ("))
        self.assertIn("does not parse", str(caught.exception))

    def test_a_patch_that_changes_nothing_refuses(self) -> None:
        with self.assertRaises(patch_gen_tree.PatchRefused) as caught:
            patch_gen_tree.apply(self.TARGET_TEXT, spec_for("return 1", "return 1"))
        self.assertIn("change nothing", str(caught.exception))


class TestTheFileIsNeverLeftBroken(unittest.TestCase):
    def write_target(self, text: str) -> tuple[Path, tempfile.TemporaryDirectory]:
        holder = tempfile.TemporaryDirectory()
        target = Path(holder.name) / "gen_tree.py"
        target.write_text(text, encoding="utf-8")
        return target, holder

    def test_a_refused_patch_leaves_the_original_bytes(self) -> None:
        target, holder = self.write_target("def f():\n    return 1\n")
        try:
            before = target.read_bytes()
            with self.assertRaises(patch_gen_tree.PatchRefused):
                patch_gen_tree.patch(target, spec_for("absent", "return 2"))
            self.assertEqual(target.read_bytes(), before)
            self.assertEqual(list(Path(holder.name).glob(".*tmp")), [])
        finally:
            holder.cleanup()

    def test_a_writing_patch_leaves_no_temporary_behind(self) -> None:
        target, holder = self.write_target("def f():\n    return 1\n")
        try:
            patch_gen_tree.patch(target, spec_for("return 1", "return 2"))
            self.assertEqual(target.read_text(encoding="utf-8"),
                             "def f():\n    return 2\n")
            self.assertEqual(list(Path(holder.name).glob(".*tmp")), [])
        finally:
            holder.cleanup()

    def test_a_dry_run_validates_and_writes_nothing(self) -> None:
        target, holder = self.write_target("def f():\n    return 1\n")
        try:
            before = target.read_bytes()
            patched = patch_gen_tree.patch(
                target, spec_for("return 1", "return 2"), dry_run=True)
            self.assertEqual(patched, "def f():\n    return 2\n")
            self.assertEqual(target.read_bytes(), before)
        finally:
            holder.cleanup()


class TestSpecLoading(unittest.TestCase):
    def load(self, spec: dict) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            path = Path(tmp) / "spec.json"
            path.write_text(json.dumps(spec), encoding="utf-8")
            patch_gen_tree.load_spec(path)

    def test_a_spec_without_a_reason_is_rejected(self) -> None:
        with self.assertRaises(SystemExit):
            self.load({"replacements": [{"anchor": "a", "replacement": "b"}]})

    def test_a_spec_without_replacements_is_rejected(self) -> None:
        with self.assertRaises(SystemExit):
            self.load({"why": "because", "replacements": []})

    def test_an_anchor_that_is_not_text_is_rejected(self) -> None:
        with self.assertRaises(SystemExit):
            self.load({"why": "because",
                       "replacements": [{"anchor": 1, "replacement": "b"}]})

    def test_malformed_json_is_rejected_with_the_parser_s_message(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            path = Path(tmp) / "spec.json"
            path.write_text("{not json", encoding="utf-8")
            with self.assertRaises(SystemExit) as caught:
                patch_gen_tree.load_spec(path)
        self.assertIn("not valid JSON", str(caught.exception))


class TestAnImportFailureRefusesTheWrite(unittest.TestCase):
    """`ast.parse` accepts a bare name; the generator does not (seg16-20).

    Their note's quote closed before `, near`, so the rest of the line became a
    name: valid syntax, `NameError` at module level, and a generator that died
    after the tool had approved the patch.
    """

    def test_a_quote_that_closes_early_is_refused_with_the_symbol_named(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            target = Path(tmp) / "gen_tree.py"
            target.write_text("VALUE = 1\n", encoding="utf-8")
            before = target.read_bytes()
            spec = spec_for("VALUE = 1", 'VALUE = note.endswith(", near")')
            with self.assertRaises(patch_gen_tree.PatchRefused) as caught:
                patch_gen_tree.patch(target, spec)
            message = str(caught.exception)
            self.assertIn("NameError", message)
            self.assertIn("note", message)
            self.assertEqual(target.read_bytes(), before)

    def test_the_check_runs_even_for_a_dry_run(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            target = Path(tmp) / "gen_tree.py"
            target.write_text("VALUE = 1\n", encoding="utf-8")
            spec = spec_for("VALUE = 1", "VALUE = missing_name")
            with self.assertRaises(patch_gen_tree.PatchRefused) as caught:
                patch_gen_tree.patch(target, spec, dry_run=True)
            self.assertIn("missing_name", str(caught.exception))
            self.assertEqual(target.read_text(encoding="utf-8"), "VALUE = 1\n")


if __name__ == "__main__":
    unittest.main()
