#!/usr/bin/env python3
"""Checks for tools/regen_build_compare.py and tools/proj_lock.py.

Run: python3 -m unittest tools.test_regen_build_compare
"""

from __future__ import annotations

import fcntl
import subprocess
import sys
import tempfile
import threading
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "tools"))

import proj_lock  # noqa: E402
import regen_build_compare  # noqa: E402


class TestPlan(unittest.TestCase):
    def test_the_three_steps_run_in_order(self) -> None:
        commands = regen_build_compare.plan(ROOT, 16)
        self.assertEqual(len(commands), 3)
        self.assertIn("gen_tree.py", commands[0][-1])
        self.assertTrue(commands[1][0].endswith("build.sh"))
        self.assertIn("ne-compare", commands[2])
        self.assertEqual(commands[2][-2:], ["--window", "16"])

    def test_the_window_is_the_command_s_not_a_default_in_the_shell(self) -> None:
        commands = regen_build_compare.plan(ROOT, 32)
        self.assertEqual(commands[2][-1], "32")


class TestDryRun(unittest.TestCase):
    def test_it_prints_the_commands_and_runs_nothing(self) -> None:
        result = subprocess.run(
            [sys.executable, str(ROOT / "tools" / "regen_build_compare.py"),
             "--dry-run"],
            capture_output=True, text=True, cwd=ROOT, timeout=60)
        self.assertEqual(result.returncode, 0, result.stderr)
        lines = [line for line in result.stdout.splitlines() if line.strip()]
        self.assertEqual(len(lines), 3, result.stdout)
        self.assertIn("tools/gen_tree.py", lines[0])
        self.assertIn("build.sh", lines[1])
        self.assertIn("ne-compare", lines[2])
        self.assertIn("--window 16", lines[2])


class TestLock(unittest.TestCase):
    def test_locked_holds_against_a_second_handle_and_releases(self) -> None:
        # A temporary root: the suite itself runs under the project lock, so a
        # test that waited on .scratch/proj.lock would wait on its own runner.
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            with proj_lock.locked(root) as path:
                self.assertEqual(path, root / proj_lock.LOCK_NAME)
                other = path.open("a+")
                try:
                    with self.assertRaises(BlockingIOError):
                        fcntl.flock(other, fcntl.LOCK_EX | fcntl.LOCK_NB)
                finally:
                    other.close()
            released = path.open("a+")
            try:
                fcntl.flock(released, fcntl.LOCK_EX | fcntl.LOCK_NB)
            finally:
                released.close()

    def test_the_lock_lives_in_the_checkout(self) -> None:
        self.assertEqual(proj_lock.LOCK_NAME, ".scratch/proj.lock")
        self.assertEqual(proj_lock.project_root(), ROOT)

    def test_inherits_lock_reads_this_process_s_own_descriptors(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            path = Path(tmp) / "x.lock"
            path.touch()
            self.assertFalse(proj_lock.inherits_lock(path))
            with path.open("a+"):
                self.assertTrue(proj_lock.inherits_lock(path))
            self.assertFalse(proj_lock.inherits_lock(path))

    def test_a_nested_lock_runs_under_the_outer_holder_instead_of_waiting(self) -> None:
        # The 2026-10-30 deadlock: `flock FILE cmd` hands its descriptor to
        # `cmd`, and a second lock on the same file then waits for the parent.
        # The inner call is made on a daemon thread so a regression fails the
        # assertion instead of wedging the suite.
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            finished = threading.Event()

            def nested() -> None:
                with proj_lock.locked(root, quiet=True):
                    pass
                finished.set()

            with proj_lock.locked(root, quiet=True):
                worker = threading.Thread(target=nested, daemon=True)
                worker.start()
                self.assertTrue(
                    finished.wait(10),
                    "a nested locked() blocked: inherits_lock missed the "
                    "outer holder's descriptor")


if __name__ == "__main__":
    unittest.main()
