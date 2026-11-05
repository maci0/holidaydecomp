"""Regression checks for candidate comparison windows."""

from types import SimpleNamespace
from pathlib import Path
import contextlib
import io
import json
import sys
import tempfile
import unittest
from unittest.mock import patch

import byte_match
import decompile


class CandidateWindowTest(unittest.TestCase):
    def test_direct_far_call_selector_placeholders_share_shape(self) -> None:
        original = list(decompile.engine().disasm(bytes.fromhex("9a5f05b905"), 0))
        candidate = list(decompile.engine().disasm(bytes.fromhex("9affff0000"), 0))
        self.assertEqual(byte_match.shape(original), byte_match.shape(candidate))
        indirect = list(decompile.engine().disasm(bytes.fromhex("26ff5dfc"), 0))
        self.assertNotEqual(byte_match.shape(indirect), byte_match.shape(candidate))
        constants = list(decompile.engine().disasm(bytes.fromhex("b000b001"), 0))
        self.assertNotEqual(byte_match.shape(constants[:1]), byte_match.shape(constants[1:]))

    def test_exact_body_excludes_following_function(self) -> None:
        target = bytes.fromhex("c8020000b001c9ca0800")
        following = bytes.fromhex("c8020000b000c9ca0800")
        wanted = byte_match.shape(list(decompile.engine().disasm(target, 0)))
        image = SimpleNamespace(data=target + following)
        best, _ = byte_match.find_candidate(image, wanted, target[:4], target)
        score, found, got = best
        # The score's third element is the shape F1: ranking reads it to tell a body
        # that covers the target from a window that merely runs past it.
        self.assertEqual(score, (len(target), len(wanted), 1.0))
        self.assertIsNotNone(found)
        self.assertEqual(len(found[1]), len(wanted))
        self.assertEqual(got, wanted)

    def test_enter_anchor_excludes_following_global_address(self) -> None:
        target = bytes.fromhex("c8040000a1f46fc9cb")
        function = SimpleNamespace(offset=0, size=len(target))
        image = SimpleNamespace(segments={17: SimpleNamespace(data=target)})
        with (
            patch.object(decompile, "form_classes_by_segment", return_value={}),
            patch.object(decompile, "discover", return_value=[function]),
            patch.object(decompile, "procedure_body", return_value=list(decompile.engine().disasm(target, 0))),
        ):
            self.assertEqual(byte_match.prologue(image, 17, 0), target[:4])

    def test_exact_candidate_wins_over_partial(self) -> None:
        target = bytes.fromhex("c8020000b001c9ca0800")
        candidate = bytes.fromhex("c8020000b000c9ca0800")
        wanted = byte_match.shape(list(decompile.engine().disasm(target, 0)))
        image = SimpleNamespace(data=candidate + target)
        best, _ = byte_match.find_candidate(image, wanted, target[:4], target)
        self.assertEqual(best[1][0], len(candidate))
        self.assertEqual(best[2], wanted)

    def test_collect_lists_every_scored_candidate(self) -> None:
        """The pool behind `--candidates` is every start the search scored."""
        target = bytes.fromhex("c8020000b001c9ca0800")
        following = bytes.fromhex("c8020000b000c9ca0800")
        wanted = byte_match.shape(list(decompile.engine().disasm(target, 0)))
        image = SimpleNamespace(data=target + following)
        pool: list = []
        best, _ = byte_match.find_candidate(image, wanted, target[:4], target, collect=pool)
        self.assertEqual(len(pool), 2)
        starts = {entry[1][0] for entry in pool}
        self.assertEqual(starts, {0, len(target)})
        self.assertIn(best[1][0], starts)
        # the shared ranking key: a perfect shape outranks a longer prefix
        # (round 644), a longer prefix outranks pure agreement (round 675)
        self.assertEqual(byte_match._pick_key((4, 4, 1.0)), (True, 4, 1.0, 4))
        self.assertGreater(byte_match._pick_key((9, 9, 0.5)),
                           byte_match._pick_key((0, 5, 0.9)))

    def test_owner_names_entry_interior_and_none(self) -> None:
        """owner_of maps a file offset to segment, offset, entry-or-interior, size, name."""
        function = SimpleNamespace(offset=10, size=20, name="Proc2_1838")
        segment = SimpleNamespace(index=0, data=b"\x00" * 64)
        record = SimpleNamespace(file_offset=0)
        image = SimpleNamespace(native=SimpleNamespace(segment_records=[record]),
                                segments=[segment])
        with patch.object(decompile, "discover", return_value=[function]):
            self.assertEqual(byte_match.owner_of(image, 10),
                             "SEG0:0xa entry, 20 bytes (Proc2_1838)")
            self.assertIn("interior", byte_match.owner_of(image, 11))
            self.assertIsNone(byte_match.owner_of(image, 64))
        # a probe-shaped image with no NE records has no owners to report
        self.assertIsNone(byte_match.owner_of(SimpleNamespace(data=b"\x00" * 8), 0))

    def test_the_level_byte_cannot_hide_the_candidates_body(self) -> None:
        """The pool is opcode-wide and the match is level-neutral.

        The target is `enter 2, 0`; a library window holds those bytes
        verbatim but continues differently, while the candidate was
        compiled with `enter 2, 1` and then the target's own body. An
        exact-anchor pool scored only the library (unique exact hit) and
        the level byte also cost the candidate F1 and prefix. Merged pool
        plus level-neutral shapes: the candidate scores 1.0 and wins on
        the key despite its shorter prefix.
        """
        target = bytes.fromhex("c8020000b001c9ca0800")
        library = bytes.fromhex("c8020000b000c3909090")
        probe = bytes.fromhex("c8020001b001c9ca0800")
        wanted = byte_match.shape(list(decompile.engine().disasm(target, 0)))
        probe_got = byte_match.shape(list(decompile.engine().disasm(probe, 0)))
        self.assertEqual(byte_match._shape_f1(wanted, probe_got), 1.0)
        image = SimpleNamespace(data=library + b"\x90" * 8 + probe)
        probe_offset = len(library) + 8
        pool: list = []
        best, _ = byte_match.find_candidate(image, wanted, target[:4], target,
                                                             collect=pool)
        self.assertEqual(best[1][0], probe_offset)   # the candidate, not the library window
        self.assertIn(probe_offset, [entry[1][0] for entry in pool])
        # raw display still shows the level difference
        self.assertIn("enter 2, 1", best[2])

    def test_a_large_body_is_scored_whole_not_capped(self) -> None:
        """The nonexact window takes the target's size, so every instruction is decoded.

        A fixed 0x400 decodes about 342 instructions, which caps a large
        body near 0.59 F1: seg11-12's 811-instruction `02cf` read 0.55
        against a full-body 0.903, and the picked entry was right the
        whole time. Here the target is 310 instructions over 1,530 bytes;
        one differing `mov` makes the match nonexact, and only the hint
        decodes the 300 `lcall`s behind it (the old window stops at 1,024
        bytes, near 0.80 F1).
        """
        target = bytes.fromhex("b80100") * 10 + bytes.fromhex("9a11112222") * 300
        candidate = (
            bytes.fromhex("b80200")
            + bytes.fromhex("b80100") * 9
            + bytes.fromhex("9a11112222") * 300
        )
        wanted = byte_match.shape(list(decompile.engine().disasm(target, 0)))
        image = SimpleNamespace(data=b"\x90" * 16 + candidate)
        best, _ = byte_match.find_candidate(
            image, wanted, target[:4], target, body_hint=len(target))
        # The interior mov at 19 leads the prefix tiebreak by a hair; the
        # window is the measurement here: every one of the 310 decoded.
        self.assertGreater(len(best[2]), 300)
        self.assertGreater(byte_match._shape_f1(wanted, best[2]), 0.97)


class ShapeScoreTest(unittest.TestCase):
    """The `4:0x0fa2` ranking failure, as the probe builds measured it.

    DCC expanded the target's `test byte, 8` into `mov`/`and`/`or`, so the real
    body carries every later instruction three slots later: positional agreement
    was 7 of 96 while a VCL window agreed in place nine times and won the
    report. By instruction sequence the same two candidates score 86 and 20.
    The lists below are that shape, with the target's slots named `op0..op95`.
    """

    TARGET = [f"op{index}" for index in range(96)]
    #: the real body: every target instruction, in order, after three extras
    EXPANDED = TARGET[:1] + ["mov", "and", "or"] + TARGET[1:]
    #: the window that agreed in place: nine of the target's slots, then junk
    WINDOW = TARGET[:9] + ["junk"] * 57

    def test_positional_agreement_picks_the_wrong_one(self) -> None:
        def positional(candidate: list[str]) -> int:
            return sum(1 for left, right in zip(self.TARGET, candidate) if left == right)

        self.assertLess(positional(self.EXPANDED), positional(self.WINDOW))

    def test_the_shape_score_picks_the_real_body(self) -> None:
        self.assertAlmostEqual(byte_match._shape_f1(self.TARGET, self.TARGET), 1.0)
        self.assertGreater(byte_match._shape_f1(self.TARGET, self.EXPANDED),
                           byte_match._shape_f1(self.TARGET, self.WINDOW))
        self.assertGreater(byte_match._shape_f1(self.TARGET, self.EXPANDED), 0.9)
        self.assertLess(byte_match._shape_f1(self.TARGET, self.WINDOW), 0.2)


class BuildSelectionTest(unittest.TestCase):
    def test_nonexact_build_with_full_shape_wins(self) -> None:
        target = bytes.fromhex("5589e58b5604a1fe6fc9c20200")
        faithful = bytes.fromhex("5589e58b5604a16409c9c20200")
        wrong = bytes.fromhex("5589e531c08b5604a16409c9c20200")
        original = SimpleNamespace(segments={17: SimpleNamespace(data=target)})
        function = SimpleNamespace(offset=0, size=len(target))
        wrong_path = Path("bmatch-test-s0-forms.exe")
        faithful_path = Path("bmatch-test-s1-forms.exe")
        misleading = target[:10] + bytes.fromhex("31c0c20200")
        images = {
            wrong_path: SimpleNamespace(data=wrong),
            faithful_path: SimpleNamespace(data=misleading + faithful),
        }
        output = io.StringIO()
        scratch = byte_match.ROOT / ".scratch"
        scratch.mkdir(exist_ok=True)
        with (
            tempfile.TemporaryDirectory(dir=scratch) as directory,
            patch.object(byte_match, "ROOT", Path(directory)),
            patch.object(sys, "argv", ["byte_match.py", "--target", "17:0x0", "--source", "probe.pas", "--record"]),
            patch.object(byte_match, "target_function", return_value=(original, function)),
            patch.object(byte_match, "prologue", return_value=target[:3]),
            patch.object(byte_match, "compile_probe", side_effect=[[wrong_path], [faithful_path]]),
            patch.object(decompile, "Image", side_effect=images.__getitem__),
            patch.object(decompile, "procedure_body", return_value=list(decompile.engine().disasm(target, 0))),
            contextlib.redirect_stdout(output),
        ):
            (Path(directory) / "build").mkdir()
            self.assertEqual(byte_match.main(), 0)
            row = json.loads((Path(directory) / "build" / "matched-procedures.json").read_text())["procedures"][0]
            self.assertEqual(row["verdict"], "instruction-exact")
            self.assertEqual(row["switches"], "-$S-")
            self.assertEqual(row["harness"], "forms")
            self.assertEqual(row["shape_agree"], 6)
            self.assertEqual(row["byte_differences"], [7, 8])
        text = output.getvalue()
        self.assertIn("0 (forms build, -$S-)", text)
        self.assertIn("6 agreeing in shape", text)
        self.assertIn(f"closest probe code: 0x{len(misleading):06x}", text)

    def test_a_four_value_byte_best_does_not_break_the_nonexact_report(self) -> None:
        """`find_candidate`'s unique-anchor path returns four values, the loop path three.

        The report unpacked three, so every non-exact build died with
        `ValueError: too many values to unpack (expected 3, got 4)` right after
        printing "exact occurrences of the target bytes in the probe: 0". Exact
        builds take another path, which is why the ledger never saw it.
        """
        target = bytes.fromhex("5589e58b5604a1fe6fc9c20200")
        faithful = bytes.fromhex("5589e58b5604a16409c9c20200")
        original = SimpleNamespace(segments={17: SimpleNamespace(data=target)})
        function = SimpleNamespace(offset=0, size=len(target))
        faithful_path = Path("bmatch-test-s1-forms.exe")
        images = {faithful_path: SimpleNamespace(data=faithful)}
        four_value_byte_best = ((6, 4, 0.5), (0, []), [], None)
        output = io.StringIO()
        scratch = byte_match.ROOT / ".scratch"
        scratch.mkdir(exist_ok=True)
        with (
            tempfile.TemporaryDirectory(dir=scratch) as directory,
            patch.object(byte_match, "ROOT", Path(directory)),
            patch.object(sys, "argv", ["byte_match.py", "--target", "17:0x0",
                                       "--source", "probe.pas", "--record"]),
            patch.object(byte_match, "target_function", return_value=(original, function)),
            patch.object(byte_match, "prologue", return_value=target[:3]),
            patch.object(byte_match, "compile_probe", side_effect=[[], [faithful_path]]),
            patch.object(byte_match, "find_candidate",
                         return_value=(four_value_byte_best, (0.5, (0, []), []))),
            patch.object(decompile, "Image", side_effect=images.__getitem__),
            patch.object(decompile, "procedure_body",
                         return_value=list(decompile.engine().disasm(target, 0))),
            contextlib.redirect_stdout(output),
        ):
            (Path(directory) / "build").mkdir()
            self.assertEqual(byte_match.main(), 0)
        text = output.getvalue()
        self.assertIn("exact occurrences of the target bytes in the probe: 0", text)
        self.assertNotIn("too many values to unpack", text)


class _PastTheCheck(Exception):
    """Raised by a stubbed `target_function` to show the default-call check was passed."""


class DefaultCallTest(unittest.TestCase):
    """The generated program calls `Run;`, so a probe that declares none cannot match.

    The refusal happens before the first Docker build: four builds and a "neither
    the minimal nor the Forms program compiled" note are a long way to learn that
    the default call had nothing to call.
    """

    def run_main(self, source_text: str):
        with tempfile.TemporaryDirectory() as tmp:
            source = Path(tmp) / "probe.pas"
            source.write_text(source_text, encoding="utf-8")
            output = io.StringIO()
            with (
                patch.object(sys, "argv", ["byte_match.py", "--target", "22:0x4786",
                                           "--source", str(source)]),
                patch.object(byte_match, "target_function", side_effect=_PastTheCheck),
                contextlib.redirect_stdout(output),
            ):
                try:
                    status = byte_match.main()
                except _PastTheCheck:
                    status = "past"
        return status, output.getvalue()

    def test_a_probe_without_run_is_refused(self) -> None:
        status, text = self.run_main("unit Probe;\ninterface\nimplementation\nend.\n")
        self.assertEqual(status, 2)
        self.assertIn("declares no `Run`", text)

    def test_a_probe_that_declares_run_gets_past_the_check(self) -> None:
        status, text = self.run_main(
            "unit Probe;\ninterface\nprocedure Run;\nimplementation\n"
            "procedure Run;\nbegin\nend;\nend.\n")
        self.assertEqual(status, "past")
        self.assertNotIn("declares no `Run`", text)

    def test_an_unreadable_source_does_not_fail_the_check(self) -> None:
        # The build-selection test passes a source that does not exist; the check
        # reads the file only when there is one.
        output = io.StringIO()
        with (
            patch.object(sys, "argv", ["byte_match.py", "--target", "22:0x4786",
                                       "--source", "probe.pas"]),
            patch.object(byte_match, "target_function", side_effect=_PastTheCheck),
            contextlib.redirect_stdout(output),
        ):
            try:
                status = byte_match.main()
            except _PastTheCheck:
                status = "past"
        self.assertEqual(status, "past")


if __name__ == "__main__":
    unittest.main()
