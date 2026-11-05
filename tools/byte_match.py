#!/usr/bin/env python3
"""Compile a candidate reconstruction and compare it with an original procedure.

The owned toolchain is DCC 1.0 through `rebrew build delphi`. This tool wraps it for one
procedure at a time: write a probe program that contains the candidate source, compile
it, find the emitted procedure, and report how its bytes and instructions compare with
the original's.

Two numbers matter, and they are different questions:

* **shape** — do the instructions match, with absolute data addresses wildcarded? A
  procedure compiled in isolation cannot place its globals where the original's data
  segment had them, so `les di, ptr [0x5504]` becomes `les di, ptr [0x2A1C]` and the two
  displacement bytes differ. A shape match says the *code* is right and only the data
  layout is not.
* **bytes** — do the raw bytes match? In isolation this can only be true if every
  absolute operand happens to agree, which needs the data layout too.

        python3 tools/byte_match.py --target 22:0x4786 --source build/cand-4786.pas
"""

from __future__ import annotations

import argparse
import json
import re
import subprocess
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

import decompile  # noqa: E402

ROOT = Path(__file__).resolve().parent.parent
#: probes live under `build/` so a candidate can never pollute the tree, one directory per tag:
#: a shared directory is not concurrency-safe, and concurrent probes corrupt each other's sources
#: (`docker: invalid mode: /work` when the directory changes under a running DCC)
WORK = ROOT / "build" / "bmatch-src"
ADDRESS = re.compile(r"0x[0-9a-f]{1,4}")


def target_function(segment: int, offset: int):
        """The discovered procedure at `segment:offset` in the original."""
        image = decompile.Image(decompile.ORIGINAL)
        classes = decompile.form_classes_by_segment(image)
        for function in decompile.discover(image.segments[segment], classes.get(segment, [])):
                if function.offset == offset:
                        return image, function
        return image, None


def shape(instructions) -> list[str]:
        return [
                "lcall <addr>, <addr>" if i.mnemonic == "lcall" and len(i.operands) == 2
                else f"{i.mnemonic} {ADDRESS.sub('<addr>', i.op_str)}".strip()
                for i in instructions
        ]


def _procedures(image) -> list[tuple[int, int, int, int, int, str]]:
        """(file start, file end, segment index, offset, size, name) for every
        procedure discover finds in this build. Form classes are the project's
        own units, so a probe build is scanned with the default pass instead."""
        native = getattr(image, "native", None)
        if native is None:
                return []
        found = []
        for segment in image.segments:
                base = native.segment_records[segment.index].file_offset
                for function in decompile.discover(segment):
                        start = base + function.offset
                        found.append((start, start + function.size, segment.index,
                                                       function.offset, function.size, function.name or ""))
        return found


def owner_of(image, start: int, procedures: list | None = None) -> str | None:
        """The procedure holding this file offset, as SEG<index>:<offset>
        entry-or-interior with its size and name; None outside every procedure."""
        rows = procedures if procedures is not None else _procedures(image)
        for low, high, index, offset, size, name in rows:
                if low <= start < high:
                        where = "entry" if start == low else "interior"
                        named = f" ({name})" if name else ""
                        return f"SEG{index}:{offset:#x} {where}, {size} bytes{named}"
        return None


def prologue(image: decompile.Image, segment: int, offset: int) -> bytes:
        """Frame prefix: ENTER alone, otherwise the first two instructions."""
        function = None
        classes = decompile.form_classes_by_segment(image)
        for candidate in decompile.discover(image.segments[segment], classes.get(segment, [])):
                if candidate.offset == offset:
                        function = candidate
                        break
        if function is None:
                return image.segments[segment].data[offset : offset + 4]
        body = decompile.procedure_body(image.segments[segment], function)
        frame_length = 1 if body and body[0].mnemonic == "enter" else 2
        return b"".join(
                image.segments[segment].data[ins.address : ins.address + ins.size]
                for ins in body[:frame_length]
        )


def compile_probe(source: Path, tag: str, call: str, dcc_args: str = "") -> list[Path]:
        """Compile the candidate unit into every program that works, minimal first.

        The call matters: DCC 1.0 smart-links, so a procedure nothing references is not
        emitted at all and the probe would carry none of the candidate's code.

        **Both programs are built, and both are searched.** Round 569 measured that the same
        unit compiles to different code depending on the program's `uses` clause: `9:0x392D`'s
        body appears in the `Forms` build and not in the minimal one, while round 566 measured a
        frame offset that was right minimally and wrong with `Forms`. Neither program is
        therefore "the honest one", and a probe that matches under either is a match.
        """
        work = WORK / tag
        work.mkdir(parents=True, exist_ok=True)
        unit_text = source.read_text(encoding="utf-8")
        (work / "BMATCHU.PAS").write_text(unit_text, encoding="utf-8")
        statement = call or "Run;"
        out = ROOT / "build" / f"bmatch-{tag}.exe"
        # Two programs, and the MINIMAL one first. Round 566 measured that the same unit compiled
        # inside a program that `uses Forms` can lay its frame out differently from the same unit in
        # a minimal program — the declarations under test had their far pointer at -0xa through the
        # Forms harness and at -0xc minimally, which is a whole instruction's worth of difference.
        # The minimal program is the honest one; Forms is the fallback for probes that need VCL types.
        programs = (
                ("minimal", "program BMATCHP;\nuses BMATCHU;\nbegin\n  " + statement + "\nend.\n",
                out),
                ("forms", "program BMATCHP;\nuses Forms, BMATCHU;\nbegin\n  " + statement + "\nend.\n",
                out.with_name(out.stem + "-forms.exe")),
        )
        # A previous run's compiled units in the work directory can be picked up instead of
        # this run's sources, which is how two suite tests failed for reasons that were not
        # regressions (round 229). Clear both the work directory and the compiler's own.
        import shutil as _shutil

        # only the compiler's own work directory: `work` holds this run's sources
        _shutil.rmtree(ROOT / "build" / f"dcc-bmatch-{tag}", ignore_errors=True)

        built: list[Path] = []
        for label, program, path in programs:
                (work / "BMATCHP.DPR").write_text(program, encoding="utf-8")
                # Never let a previous build's output stand in for this one's.
                path.unlink(missing_ok=True)
                command = [sys.executable, "-m", "rebrew.app.main", "build", "delphi",
                                str(work / "BMATCHP.DPR"),
                                "--output", str(path), "--work-dir", str(ROOT / "build" / f"dcc-bmatch-{tag}")]
                if dcc_args:
                        command.append(f"--dcc-args={dcc_args}")   # `=` so argparse takes a leading dash
                result = subprocess.run(command, capture_output=True, text=True, cwd=ROOT)
                if result.returncode == 0 and path.is_file():
                        built.append(path)
                elif label == "forms" and not built:
                        print(result.stdout[-2000:])
                        print(result.stderr[-2000:])
        if not built:
                print("note: neither the minimal nor the Forms program compiled")
        return built


def _call_targets(data: bytes) -> set[int]:
        """Offsets the image's direct near and far calls target.

        Near `call rel16` is `e8 lo hi` at 16-bit offsets; far calls in a Delphi 1 image go through
        `lcall ptr16:16`, whose segment and offset both appear as operands. Only the near form is
        decoded here, because the matcher's probes always call the candidate with a near call.
        """
        targets = set()
        for position in range(len(data) - 3):
                if data[position] != 0xE8:
                        continue
                delta = data[position + 1] | (data[position + 2] << 8)
                if delta >= 0x8000:
                        delta -= 0x10000
                targets.add((position + 3 + delta) & 0xFFFF)
        return targets



def _call_site_counts(data: bytes) -> dict[int, int]:
        """How many near calls in the image target each offset."""
        counts: dict[int, int] = {}
        for target in _call_targets(data):
                counts[target] = counts.get(target, 0) + 1
        return counts




def _code_ranges(image) -> list[tuple[int, int]]:
        """The probe's code segments as (file offset, length) pairs.

        `image.data` is the whole file: headers, resources and imports included. Searching it
        finds 4-byte coincidences in data (round 355: `0x00E3E0` is not a code address at all),
        so the candidate search is confined to real code.
        """
        ranges = []
        for segment in image.segments:
                if segment.data:
                        ranges.append((segment.at(), len(segment.data)))
        return ranges


def _in_code(ranges: list[tuple[int, int]], position: int) -> bool:
        for start, length in ranges:
                if start <= position < start + length:
                        return True
        return False



def _trim_at_ret(body):
    """Round 646: bound a scoring window at its first near/far return.

    Nonexact windows are disassembled from `0x400` bytes or the target's body size,
    whichever is larger, and the window can still overrun a short candidate into
    neighbouring code and dilute its agreement ratio (the
    round-645 loss: candidate 42-instr body seen as 116 instructions). Trimming at
    ret/retf scores each window over the procedure-shaped extent only; windows
    without a return keep their full span.
    """
    for index, insn in enumerate(body):
        if insn.mnemonic in ("ret", "retf", "retf 2", "ret 2") or insn.mnemonic.startswith("ret"):
            return body[: index + 1]
    return body


def _lcs_length(wanted: list[str], got: list[str]) -> int:
    """Length of the longest common subsequence of two instruction-shape lists."""
    previous = [0] * (len(got) + 1)
    for left in wanted:
        current = [0]
        for index, right in enumerate(got, 1):
            current.append(previous[index - 1] + 1 if left == right
                            else max(previous[index], current[-1]))
        previous = current
    return previous[-1]


def _level_neutral(shape_line: str) -> str:
    """`enter 6, 0` and `enter 6, 1` are the same instruction for matching.

    The level operand is the compiler's nesting save, not the frame the
    comparison is about (the frame size stays in the token). Scoring it
    raw cost a probe compiled with `enter 6, 1` both its F1 and its byte
    prefix against a library `enter 6, 0` window, so the level byte alone
    could pick the library body (seg2-3's picker anomaly). Reports stay
    raw: this applies where shapes are compared, not where they print.
    """
    return re.sub(r"^(enter [^,]+), \d+$", r"\1, <level>", shape_line)


def _shape_f1(wanted: list[str], got: list[str]) -> float:
    """F1 of the target's instruction sequence against a candidate's.

    Recall is how much of the target the candidate carries **in order**, which is
    the part positional agreement gets wrong: `4:0x0fa2`'s probe form expands
    `test byte, 8` into `mov`/`and`/`or`, every later instruction sits three
    slots later, positional agreement collapses to 7 of 96, and a VCL window with
    9 in place won the report while the real body scored 86 by subsequence
    against the window's 20. Precision is how much of the candidate is the
    target, which is what stops a window that runs past the procedure into the
    next one: `test_exact_body_excludes_following_function`'s overrun covers the
    whole target and still loses, 0.75 against 1.0. Round 644's rule holds too:
    both terms are ratios, so a 377-instruction library window cannot win on
    volume.
    """
    if not wanted or not got:
        return 1.0 if not wanted and not got else 0.0
    wanted = [_level_neutral(line) for line in wanted]
    got = [_level_neutral(line) for line in got]
    common = _lcs_length(wanted, got)
    if common == 0:
        return 0.0
    precision = common / len(got)
    recall = common / len(wanted)
    return 2 * precision * recall / (precision + recall)


def _pick_key(score: tuple) -> tuple:
        """Ranking key for one scored candidate: perfect shape, then prefix, F1,
        agreement (round 675's signature priority, round 644's ratio)."""
        common, agree, f1 = score
        return (f1 == 1.0, common, f1, agree)


def find_candidate(image: decompile.Image, wanted: list[str], anchor: bytes,
                                common_bytes: bytes = b"", collect: list | None = None,
                                body_hint: int = 0):
        """The probe code whose instruction shape is closest to `wanted`.

        A discovery-based search is not enough here: the original's **near** procedures
        (`ret 4`) are private to their unit, and `discover()` finds entry points, not
        private code. So the search anchors on the prologue the compiler emits for the
        target's frame, and the pool is scored **opcode-wide**: every occurrence of the
        prologue's opcode (ENTER's `C8`, the first byte otherwise) enters one ranking
        under the same key, so a candidate whose ENTER level byte differs from the
        target's is scored instead of being invisible behind an exact library window.
        A nonexact window is `0x400` bytes or `body_hint`, whichever is larger: the
        target's own size, so a body past ~342 instructions scores whole instead of
        being capped near 0.59 F1 (seg11-12's 02cf: 811 instructions, reported 0.55
        over a full-body 0.903).
        """
        best = ((0, 0), None, None)
        best_key = None
        best_shape = (0.0, None, None)
        data = image.data
        # Opcode-wide pool, one ranking: the prologue's opcode, so `enter 6, 1`
        # is scorable beside the target's `enter 6, 0` (the pool merge; the
        # exact-only pool let a library prologue stand in for the candidate).
        wide = anchor[:2] if anchor[:1] == b"\xc8" else anchor[:1]
        starts = [index for index in range(len(data) - len(wide) + 1)
                        if data[index : index + len(wide)] == wide]
        if not starts:
                # Nothing matched the frame, so fall back to every call target the probe reaches.
                # A probe's entry point calls the candidate **once**, while a library routine is
                # called from many places, so targets with a single call site are preferred: that
                # is what distinguishes the candidate from a VCL window (round 354).
                counts = _call_site_counts(data)
                starts = sorted(counts)
                if any(counts[start] == 1 for start in starts):
                        starts = [start for start in starts if counts[start] == 1]
        if len(starts) == 1:
                # One prologue occurrence in the whole image is decisive: the frame identifies
                # this candidate and no other code in the probe shares it (round 279's result,
                # reached now through the opcode-wide pool, so the same body still wins when
                # its ENTER level byte differs from the target's).
                start = starts[0]
                body = list(decompile.engine().disasm(
                        data[start : start + max(0x400, body_hint)], start))
                body = _trim_at_ret(body)
                got = shape(body)
                agree = sum(1 for left, right in zip(wanted, got)
                                if _level_neutral(left) == _level_neutral(right))
                common = 0
                for left, right in zip(data[start:], common_bytes):
                        if left != right:
                                break
                        common += 1
                f1 = _shape_f1(wanted, got)
                if collect is not None:
                        collect.append(((common, agree, f1), (start, body), got))
                # unique pool: decisive as-is
                return ((common, agree, f1), (start, body), got, None), (f1, (start, body), got)
        for start in starts:
                exact = bool(common_bytes) and data[start : start + len(common_bytes)] == common_bytes
                window_size = len(common_bytes) if exact else max(0x400, body_hint)
                body = list(decompile.engine().disasm(data[start : start + window_size], start))
                body = _trim_at_ret(body)
                got = shape(body)
                agree = sum(1 for left, right in zip(wanted, got)
                                if _level_neutral(left) == _level_neutral(right))
                # The prologue is not a fingerprint: `enter N, 0` / `les di, ptr [bp + 6]` is also the
                # prologue of library code, and every probe executable carries ~60 occurrences of it.
                # Scoring only the agreeing *prefix* let one of those tie with the candidate's own body
                # and win on order (round 519 reported a VCL routine as "closest probe code" while the
                # real body sat elsewhere). The bytes are the tie-breaker that cannot lie: the
                # candidate's longest common byte prefix with the original is what identifies it.
                common = 0
                for left, right in zip(data[start:], common_bytes):
                        if left != right:
                                break
                        common += 1
                # Round 644: rank by a ratio, not a raw count, so a library window of
                # hundreds of instructions cannot win on volume (21:0x2D5A: VCL 8/377
                # beat the candidate 4/40). The ratio is `_shape_f1`: recall over the
                # target's instruction sequence, precision over the candidate's, because
                # positional agreement collapses as soon as the compiler expands one
                # statement (4:0x0fa2: 7 of 96 in place against a VCL window's 9, while
                # the real body carries 86 of the target's instructions in order).
                f1 = _shape_f1(wanted, got)
                score = (common, agree, f1)
                # Round 675: signature-priority with one guard above it. The candidate's own
                # first bytes are a signature, so among bodies that do NOT reproduce the shape
                # completely, the longest common prefix wins over instruction-shape agreement
                # (the queued round-668 fix: window search must not beat signature search).
                # A perfect shape still outranks everything (BuildSelection's
                # `test_nonexact_build_with_full_shape_wins`: a 10-byte misleading prefix
                # must not beat a full-shape body with 6 agreeing bytes).
                if collect is not None:
                        collect.append((score, (start, body), got))
                key = _pick_key(score)
                if best_key is None or key > best_key:
                        best = (score, (start, body), got)
                        best_key = key
                if f1 > best_shape[0]:
                        best_shape = (f1, (start, body), got)
        return best, best_shape


def main() -> int:
        parser = argparse.ArgumentParser(description=__doc__)
        parser.add_argument("--target", required=True, help="segment:0xoffset of the original")
        parser.add_argument("--source", type=Path, required=True, help="candidate .pas unit")
        parser.add_argument("--tag", default="cand")
        parser.add_argument("--call", default="", help="a statement that references the candidate")
        parser.add_argument("--dcc-args", default="", help="extra DCC switches, e.g. -$S-")
        parser.add_argument("--candidates", action="store_true",
                                                    help="print every scored candidate with its owning procedure")
        parser.add_argument("--record", action="store_true",
                                                help="add this measurement to build/matched-procedures.json")
        args = parser.parse_args()

        # The generated program is `begin <call> end.`, so without --call it calls `Run;`:
        # a probe that declares no Run compiles nothing to compare, and DCC smart-links the
        # candidate away. Four Docker builds are not worth spending to learn that.
        if (not args.call and args.source.is_file()
                and not re.search(r"\bRun\b", args.source.read_text(encoding="utf-8"))):
                print(f"{args.source} declares no `Run`, and the default call is `Run;`: "
                      "pass --call '<statement>' that references the candidate")
                return 2

        segment, offset = args.target.split(":")
        segment, offset = int(segment), int(offset, 16)
        image, function = target_function(segment, offset)
        if function is None:
                print(f"no procedure at {args.target}")
                return 1
        original = image.segments[segment].data[offset : offset + function.size]
        wanted = shape(decompile.procedure_body(image.segments[segment], function))
        print(f"target {segment}:{offset:#06x}  {function.size} bytes, {len(wanted)} instructions")
        # Which return the target uses decides whether the probe routine must be near (implementation
        # private, under the F-minus directive) or far (declared in the interface): `c2` is `ret imm16`,
        # `ca` is `retf imm16`, and `cb` a plain `retf`. Rounds 551 and 552 both lost a compile to
        # guessing this from a note instead of reading these bytes.
        tail = bytes(original)[-3:]
        if tail[0] == 0xC2 or tail[0:1] == b"\xc3":
                print("target returns NEAR (`ret`) — the probe routine must be {$F-} and unit-private")
        elif tail[0] == 0xCA or tail[0] == 0xCB:
                print("target returns FAR (`retf`) — the probe routine goes in the interface")

        # Prologue selects attempt order, not a proven stack-check setting.
        head = bytes(image.segments[segment].data[function.offset:function.offset + 3])
        if head[0:1] == b"\xc8":
                detected, why = "-$S-", "`enter`"
        else:
                detected, why = "-$S+", "`push bp`"
        base_args = re.sub(r"-\$S[+-]", "", args.dcc_args).strip()
        dcc_args = f"{base_args} {detected}".strip()
        print(f"target opens with {why}; first compiler attempt uses {detected}")

        # Try BOTH $S settings, not just the one the prologue suggests. Round 614 derived the directive
        # from the first byte (`c8` => -$S-, `push bp` => -$S+), and round 663 measured that this
        # mis-fires: with -$S- the compiler emits `push bp ; mov bp, sp` for this body *and* leaves out the
        # per-routine `xor ax, ax ; lcall` preamble that -$S+ inserts. A prologue therefore does not
        # determine the directive, and both are cheap to build.
        executables = []
        attempts = (dcc_args, dcc_args.replace(detected, "-$S+" if detected == "-$S-" else "-$S-"))
        for index, candidate in enumerate(attempts):
                if candidate != dcc_args:
                        print(f"retrying with {candidate}")
                # A distinct tag per attempt, or the second build overwrites the first and the search reads
                # whichever finished last. Round 665 measured exactly that: the retry clobbered the build the
                # target's own `$S` had produced, and the comparison ran against the wrong one.
                executables.extend(compile_probe(args.source, f"{args.tag}-s{index}", args.call, candidate))
        if not executables:
                print("the candidate does not compile")
                return 1
        images = [(exe, decompile.Image(exe)) for exe in executables]
        anchor = prologue(image, segment, offset)
        counts = []
        for exe, candidate in images:
                exact_count = sum(1 for index in range(len(candidate.data) - len(original) + 1)
                                                if candidate.data[index : index + len(original)] == original)
                byte_best, shape_best = find_candidate(candidate, wanted, anchor, original,
                                                                        body_hint=function.size)
                counts.append((exact_count, shape_best[0], byte_best[0][0], exe, candidate,
                                        byte_best, shape_best))
        counts.sort(key=lambda item: (-item[0], -item[1], -item[2], str(item[3])))
        identical, _, _, executable, built, byte_best, shape_best = counts[0]
        # Which build matched, and with which directive. The stem carries both — `bmatch-<tag>-s1-forms`
        # is the second attempt under the Forms harness — and the entry has to record the switch of the
        # build that actually matched. Round 721: recording the caller's `dcc_args` put `-$S+` on bodies
        # whose match came from `-$S-`, which four ledger tests then failed on.
        stem = executable.stem
        attempt = 1 if "-s1" in stem else 0
        where = "forms" if stem.endswith("-forms") else "minimal"
        matched_now = attempts[attempt]
        print(f"exact occurrences of the target bytes in the probe: {identical} ({where} build, {matched_now})")

        # `find_candidate` returns four values on its unique-anchor path and three
        # from its window loop, so the report reads the first three either way.
        # `prefix_score` is (common byte prefix, agreeing in place, shape F1).
        prefix_score, found, got = byte_best[:3]
        shape_score, shape_found, shape_got = shape_best
        byte_f1 = prefix_score[2] if found else 0.0
        if not identical and shape_score > byte_f1:
                found, got = shape_found, shape_got
                common = 0
                for left, right in zip(built.data[found[0]:], original):
                        if left != right:
                                break
                        common += 1
                agreeing = sum(1 for left, right in zip(wanted, got) if left == right)
                prefix_score = (common, agreeing, shape_score)
        if found is None:
                print("no code in the probe resembles the target")
                return 1
        if shape_found is not None and shape_found[0] != found[0]:
                # The frame difference makes a faithful reconstruction findable by *shape* and never by
                # bytes: `enter 2, 0` against `push bp; mov bp, sp; sub sp, 2` share no prefix at all,
                # so a VCL routine that also starts with `enter` wins the byte metric by default
                # (round 520). Both are reported, and the shape one is the reconstruction.
                print(f"best by shape: 0x{shape_found[0]:06x} {shape_score} agreeing instructions")
        start, body = found
        if len(body) > 2 * len(wanted):
                print("WARNING: chosen window is " + str(len(body)) +
                        " instructions against a " + str(len(wanted)) +
                        "-instruction target: candidate extent unresolved, verdict unreliable (round 644)")
        elif len(wanted) > 2 * len(body):
                print("WARNING: chosen window is " + str(len(body)) +
                        " instructions against a " + str(len(wanted)) +
                        "-instruction target: candidate may be truncated (round 644)")
        candidate_bytes = built.data[start : start + len(original)]
        common_prefix, agreeing = prefix_score[:2]
        print(f"closest probe code: 0x{start:06x} "
                f"{len(body)} instructions, {agreeing} agreeing in shape, "
                f"{common_prefix} common byte prefix, "
                f"{prefix_score[2]:.2f} shape F1")
        pool: list = []
        find_candidate(built, wanted, anchor, original, collect=pool,
                                       body_hint=function.size)
        procedures = _procedures(built)
        closest_owner = owner_of(built, start, procedures) or (
                "outside every discovered procedure in this build")
        anchor_text = anchor.hex(" ")
        print(f"closest procedure: {closest_owner}")
        print(f"search pool: {len(pool)} candidate(s) scored in this build, "
                f"opcode-wide from target prologue {anchor_text}")
        if args.candidates:
                for score, (candidate_start, candidate_body), _got in sorted(
                        pool, key=lambda entry: _pick_key(entry[0]), reverse=True):
                        marker = "*" if candidate_start == start else " "
                        owner = owner_of(built, candidate_start, procedures) or "unknown"
                        print(f" {marker}candidate {candidate_start:#08x}: "
                                        f"{len(candidate_body)} instructions, F1 {score[2]:.2f}, "
                                        f"{score[1]} agree, {score[0]} prefix, {owner}")
        # Nonexact candidates use a search window, not a recovered procedure boundary.
        if not identical and shape_found is not None and len(shape_found[1]) > len(wanted):
                print(f"shape-search window: {len(shape_found[1])} instructions against "
                        f"{len(wanted)} in the target; candidate procedure extent is unknown")

        for number, (left, right) in enumerate(zip(wanted, got)):
                mark = " " if left == right else "*"
                print(f"  {mark} {number:3d}  orig {left:38s} | cand {right}")
        common = 0
        for left, right in zip(original, candidate_bytes):
                if left != right:
                        break
                common += 1
        print(f"longest common byte prefix: {common} of {len(original)}")

        if args.record:
                ledger = ROOT / "build" / "matched-procedures.json"
                entries = json.loads(ledger.read_text()) if ledger.is_file() else {"procedures": []}
                key = f"{segment}:{offset:#06x}"
                entries["procedures"] = [row for row in entries["procedures"] if row["target"] != key]
                entries["procedures"].append({
                        "target": key, "size": function.size, "instructions": len(wanted),
                        "shape_agree": agreeing, "shape_total": len(wanted),
                        "byte_differences": [number for number, left, right in
                                                                ((i, a, b) for i, (a, b) in enumerate(zip(original,
                                                                                                                                                candidate_bytes)))
                                                                if left != right],
                        "source": str(args.source.relative_to(ROOT)) if args.source.is_relative_to(ROOT)
                                        else str(args.source),
                        "switches": matched_now,
                        "call": args.call,
                        # Which program produced the match. Rounds 569-570 measured that the same unit
                        # compiles differently under `uses BMATCHU` and `uses Forms, BMATCHU`, and that the
                        # original — a VCL application — is reproduced by the Forms program. An entry
                        # without this field predates the measurement and was built by the Forms harness.
                        "harness": where,
                        # `identical` and `agreeing` come from DIFFERENT searches: the best byte match and the
                        # best shape match. Requiring both let a body whose bytes are identical record as
                        # `shape-partial` — exactly what happened to `17:0x5841` on round 719, a 1,586-byte
                        # match filed as partial because some other routine scored better on shape. A byte
                        # match is the stronger claim and stands alone; the shape is a diagnostic beside it.
                        "verdict": ("byte-exact" if identical
                                                else "instruction-exact" if agreeing == len(wanted) else "shape-partial"),
                })
                entries["procedures"].sort(key=lambda row: row["target"])
                ledger.write_text(json.dumps(entries, indent=1, sort_keys=True))
                print(f"recorded {key} in {ledger.relative_to(ROOT)}")
        return 0


if __name__ == "__main__":
        raise SystemExit(main())
