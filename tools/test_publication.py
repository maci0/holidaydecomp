import contextlib
import io
from pathlib import Path
import subprocess
import tempfile
import unittest
from unittest.mock import patch

import check_publication
from check_publication import permitted


class PublicationTest(unittest.TestCase):
    def test_only_source_inventory_and_original_logo_are_allowed(self):
        for path in ("tools/gen_tree.py", "assets/logo.png", "src/main/function_structure.json", "templates/REACH.PAS"):
            with self.subTest(path=path):
                self.assertTrue(permitted(path))
        for path in ("original/holiday.exe", "tools/game.py.exe", "assets/icon.ico",
                     "assets/screenshot.png", "src/main/DATAVAL.PAS", "src/main/forms/Title.DFM",
                     "templates/DATAVAL.PAS", "notes.txt", ".scratch/recovery.json", "old-history.bundle"):
            with self.subTest(path=path):
                self.assertFalse(permitted(path))


class TestPublicationHistory(unittest.TestCase):
    def test_tag_names_are_ignored_but_removed_assets_are_rejected(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)

            def git(*args):
                subprocess.run(["git", *args], cwd=root, check=True, capture_output=True)

            git("init")
            git("config", "user.name", "Fixture")
            git("config", "user.email", "fixture@example.invalid")
            (root / "README.md").write_text("Source fixture\n")
            (root / "tools").mkdir()
            (root / "tools/gen_tree.py").write_text("BODY = 'pass'\n")
            git("add", ".")
            git("commit", "-m", "Source fixture")
            git("tag", "-a", "v0.1.0", "-m", "Release fixture")
            with patch.object(check_publication, "ROOT", root), contextlib.redirect_stdout(io.StringIO()):
                self.assertEqual(check_publication.main(), 0)
                (root / "original").mkdir()
                asset = root / "original/fixture.txt"
                asset.write_text("Excluded fixture\n")
                git("add", ".")
                git("commit", "-m", "Excluded fixture")
                git("rm", "original/fixture.txt")
                git("commit", "-m", "Remove fixture")
                errors = io.StringIO()
                with contextlib.redirect_stderr(errors):
                    self.assertEqual(check_publication.main(), 1)
                self.assertIn("excluded historical path: original/fixture.txt", errors.getvalue())


if __name__ == "__main__":
    unittest.main()
