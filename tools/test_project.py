from pathlib import Path
import json
import re
import shutil
import subprocess
import tempfile
import tomllib
import unittest

import gen_rebrew_functions
import gen_status
from rebrew.config import load_config
from rebrew.metadata.data import load_data_metadata
from rebrew.metadata.functions import load_metadata

ROOT = Path(__file__).resolve().parent.parent


class TestProject(unittest.TestCase):
    def test_cleanup_preserves_reconstructed_source(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            shutil.copy(ROOT / "Makefile", root / "Makefile")
            (root / "tools").mkdir()
            names = ("src/main/START.PAS", "src/main/HOLIDAY.DPR", "rebrew-functions.toml", "STATUS.md")
            for name in (*names, "src/main/DATAVAL.PAS", "build/cache.bin", ".scratch/probe.pas"):
                path = root / name
                path.parent.mkdir(parents=True, exist_ok=True)
                path.write_text("fixture\n")
            result = subprocess.run(["make", "clean"], cwd=root, capture_output=True, text=True)
            self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
            for name in names:
                self.assertEqual((root / name).read_text(), "fixture\n")
            self.assertFalse((root / "src/main/DATAVAL.PAS").exists())
            self.assertFalse((root / "build").exists())
            self.assertFalse((root / ".scratch").exists())

    def test_native_bindings_resolve_to_committed_pascal_definitions(self):
        config = load_config(root=ROOT)
        self.assertEqual(config.metadata_dir, ROOT)
        self.assertEqual(config.arch, "x86_16")
        metadata = load_metadata(ROOT)
        inventory = json.loads((ROOT / "src/main/function_structure.json").read_text())
        self.assertEqual({va for module, va in metadata if module == "MAIN"}, {row["va"] for row in inventory})
        for (module, va), row in metadata.items():
            if module != "MAIN" or not row.get("file"):
                continue
            with self.subTest(va=hex(va)):
                path = ROOT / row["file"]
                self.assertTrue(path.is_file())
                self.assertRegex(path.read_text(), r"(?im)^\s*(?:procedure|function|constructor|destructor)\s+" + re.escape(row["symbol"]) + r"\b")
        self.assertEqual(tomllib.loads((ROOT / "rebrew-functions.toml").read_text())["format"], 3)
        self.assertEqual(tomllib.loads((ROOT / "rebrew-data.toml").read_text())["format"], 2)
        load_data_metadata(ROOT)

    def test_status_matches_sources_and_does_not_claim_candidates_are_exact(self):
        data = gen_status.report()
        self.assertEqual(len(gen_status.source_paths()), 28)
        self.assertEqual(data, json.loads((ROOT / "status.json").read_text()))
        text = gen_status.render(data)
        self.assertEqual(text, (ROOT / "STATUS.md").read_text())
        self.assertIn("not a percentage decompiled", text)
        self.assertGreater(data["procedures"]["empty_stub"], 0)
        self.assertGreater(data["procedures"]["candidate"], 0)
        self.assertEqual(gen_rebrew_functions.body_state("procedure P; begin { pending } end;"), "empty stub")
        self.assertEqual(gen_rebrew_functions.body_state("procedure P; begin Value := 1; end;"), "candidate")

    def test_git_keeps_code_but_ignores_extracted_inputs(self):
        tracked = set(subprocess.check_output(["git", "ls-files"], cwd=ROOT, text=True).splitlines())
        for path in gen_status.source_paths():
            self.assertIn(path.relative_to(ROOT).as_posix(), tracked)
        forbidden = {"src/main/DATAVAL.PAS", "src/main/POOLS.PAS", "src/main/TABLES.PAS", "src/main/HOLIDAY.RES", "original/holiday.exe"}
        self.assertFalse(tracked & forbidden)
        result = subprocess.run(["git", "check-ignore", *sorted(forbidden)], cwd=ROOT, capture_output=True, text=True, check=True)
        self.assertEqual(set(result.stdout.splitlines()), forbidden)


if __name__ == "__main__":
    unittest.main()
