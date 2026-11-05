import unittest

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


if __name__ == "__main__":
    unittest.main()
