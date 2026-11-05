from pathlib import Path
import subprocess
import sys
import unittest


class TestSourceRunner(unittest.TestCase):
    def test_keyword_runs_a_shipped_source_test(self):
        root = Path(__file__).resolve().parent.parent
        result = subprocess.run(
            [sys.executable, "tools/run_tests.py", "test_cleanup_preserves_reconstructed_source"],
            cwd=root, capture_output=True, text=True, timeout=60,
        )
        self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        self.assertIn("Ran 1 test", result.stdout + result.stderr)


if __name__ == "__main__":
    unittest.main()
