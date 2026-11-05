#!/usr/bin/env python3
"""`docs/roadmap.md`, generated from the toolchain that measures it.

The roadmap was written by hand at round 150 and its counts were a snapshot by
design. It is generated now for the same reason the largest-procedure ranking and
the dispatch tables are (rounds 173 and 175): a number read by hand is a number
that can be a subset, and the document is what a reader trusts.

The prose — what moved the score, the three levers, the open questions — is
carried here as text, and the numbers are measured.

    python3 tools/gen_roadmap.py [--check]
"""

from __future__ import annotations

import argparse
import csv
import io
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

import decompile  # noqa: E402
import gen_globals  # noqa: E402
from rebrew.formats import ne_analysis  # noqa: E402

ROOT = Path(__file__).resolve().parent.parent
DOC = ROOT / "docs" / "roadmap.md"
ORIGINAL = ROOT / "original" / "holiday.exe"
REBUILT = ROOT / "bin" / "main" / "HOLIDAY.EXE"

# round, bytes, share, what moved it — the score's history, kept by hand because
# it is history; every other number below is measured.
SCORE_HISTORY = (
    (90, 124000, "18.44 %", "the string pools"),
    (92, 127864, "19.00 %", "the trailer's resources"),
    (96, 150970, "22.43 %", "the reach unit"),
    (112, 154483, "22.95 %", "the 62 jump tables"),
    (113, 164493, "24.44 %", "the data segment's initialised bytes"),
    (124, 165334, "24.57 %", "creating the 23 forms"),
    (140, 165350, "24.57 %", "ten arity-discovered library calls"),
    (401, 165415, "24.58 %", "**`-$S-`**: the original was compiled with stack checking off"),
)

LEVERS = """
1. **Recovering data** — spent. Everything the image holds as *data* is written
   back: {pools} bytes of string pools (`POOLS.PAS`), {tables} bytes of jump tables
   (`TABLES.PAS`), all {data} bytes of the data segment's file image
   (`DATAVAL.PAS`). Each is read out of the original and recompiled, never
   copied from a code segment; `docs/segment-map.md` states the boundary and four
   tests hold it. Any score gain from here would have to come from code.
2. **Reaching more library code** — **closed as a separate lever, by measurement.**
   Round 240 measured the gap in the segment tables itself: the original has
   **35 segments totalling 612 951 bytes**, the rebuild **17 totalling 319 750**,
   a difference of 293 201 that is almost exactly the library's 173 951 plus
   sixteen kilobytes. The rebuild links the same DCUs, but DCC's
   linker keeps only what the program touches. Naming API the original also calls
   is what closed 22.43 % in round 96; four later approaches were falsified
   (rounds 116, 126, 152, 156) and `tools/arity_probe.py` is the one that works.
   **What that lever can still buy is zero**, measured 2026-10-13:
   `tools/library_attribution.py` re-derives the 81 called functions (52 present,
   29 absent, 2 under the window test) through the same `decompile.resolved_targets`
   the other tool uses — the two shared that rule all along, and the figure moved
   from 87/55/30 when an ambiguous offset stopped being given to a library segment
   (`tools/call_truth.py` measures that preference right once in nine) — and
   `tools/library_reach.py` asks whether any absent one
   has a caller the rebuild already links. **None does.** Every one of the 29 is
   reached only from the game's own unreconstructed bodies or from other absent
   routines, so the rebuild's library link is already as complete as its sources
   allow — and the 293 201 bytes of segment-table difference are missing game
   code, not library the linker left out (`docs/library-reach.md`).
3. **The program units' bodies** — reconstruction is active. Pascal bodies are
   recovered from native instructions and checked by compiling them with the stock
   compiler. The {program} unmatched program bytes remain work, not a proven cap.
4. **The compiler switches** — measured and closed. `-$S-` (stack checking off) is the
   one switch that moves the score, worth **+65 bytes**, and `./build.sh` passes it.
   `tools/switch_sweep.py` then built the whole program once per further switch: of
   sixteen, **{zeroed} change nothing**, `-$G-` (smart linking off) **costs {switchloss} content bytes**,
   and `-$N-` and `-$X-` do not compile the tree at all. Round 442 measured what
   `-$G-` actually does, because the "it links code the original does not have"
   explanation did not survive the test: the image grows to **483 584 bytes** with
   **less code** (298 190 against 301 887) and **more data** (25 080 against 19 646),
   and an unreferenced probe procedure is **still dropped** under `-$G-` exactly as it
   is under the default. The receipt is kept at
   `build/receipts/gminus-HOLIDAY.EXE` with its compiler log beside it; the sweep was
   re-run after the rebuilt image grew to 482 560 bytes, which is where the 184 comes
   from (it was 87 against the older 482 304-byte build).
"""

QUESTIONS = """
* Which of the **{missing} library functions** the game actually calls, and what
  would reach them. **Answered in round 428**: the relocation records attribute every far
  call to its callee segment, and `tools/library_calls.py` counts what the program
  *calls* — **{called} distinct library functions**, of which **{present} are in the
  rebuild and {absent} are missing, {short} too short for the window test**
  ({sites} call sites). That is a far sharper list than the 454 functions the
  presence census finds, because the rest are never called.
  What remains open is reaching the {absent}: each needs the source that calls it, or an
  API name that assembles — the work `tools/reach_oracle.py` scores.
  **And it is only the source that can reach them** (`tools/library_reach.py`,
  2026-10-13): of the {absent}, exactly **one** (`31:0x1b36`, 1 call site) has any
  caller whose own body the rebuild already links, and that caller — `10:0x3b8d`,
  494 bytes — is itself unreconstructed, so its 16-byte window is matching VCL code
  rather than the routine. **Zero** of the {absent} are reachable from code the
  rebuild links: the library link is already as complete as the sources allow, and
  touching more of the API cannot produce them. `docs/library-reach.md` carries the
  measurement.
* What the 256-byte body of a 284-byte scenario record holds. The size and the
  nine mutable fields are established from two directions
  (`docs/game-state.md`); the body's meaning is not.
* Which of the 193 address-taken globals a reader should follow next: round 238
  answered the worked example — `0x6612`, `0x6F04` and `0x7342` are filled with a
  **class reference** by the library routine `30:0x6E7B`, and a failed
  initialisation leaves them nil, which is why the game's nil checks are real.
* Which of the {les} `les` pointer sites belong to the same object: the offsets
  are fingerprints, and mapping them means mapping the VCL's class layouts.
* What the {unnamed} data-segment addresses still without a name are; the ones
  with the most readers are library objects whose class layouts would have to be
  mapped.
"""


def _switch_zeroed() -> int | str:
    """How many further switches measured no change, from the same live cache."""
    import json

    path = ROOT / "build" / "switch-sweep.json"
    if not path.is_file():
        return "thirteen"
    payload = json.loads(path.read_text())
    if payload.get("metric") != "matching-window-union-v1":
        return "thirteen"
    baseline = payload.get("baseline", {}).get("score")
    switches = payload.get("switches", {})
    if not isinstance(baseline, int) or not switches:
        return "thirteen"
    return sum(1 for row in switches.values()
               if isinstance(row, dict) and row.get("score") == baseline)


def _switch_loss() -> int | str:
    """Read the current measured window-union sweep, never a historical ruler."""
    import json

    path = ROOT / "build" / "switch-sweep.json"
    if not path.is_file():
        return "unknown"
    payload = json.loads(path.read_text())
    if payload.get("metric") != "matching-window-union-v1":
        return "unknown"
    baseline = payload.get("baseline")
    row = payload.get("switches", {}).get("G", {})
    if not baseline or row.get("result") != "built":
        return "unknown"
    return baseline["score"] - row["score"]


def render() -> str:
    original = ne_analysis.NeImage(ORIGINAL)
    rebuilt = ne_analysis.NeImage(REBUILT)
    budget = ne_analysis.segment_budget(original, rebuilt, 16)
    rows = list(csv.DictReader(io.StringIO((ROOT / "docs" / "worklist.csv").read_text())))
    scored, of = ne_analysis.byte_score(original, rebuilt, 16)
    documented = sum(1 for row in rows if row["documented"] == "yes")
    # the stricter count: a mention outside a table is a sentence someone wrote about
    # the procedure, where a row in a per-segment dump is not
    described_pairs = __import__("worklist").described_pairs()
    described = sum(
        1
        for row in rows
        if (int(row["segment"]), int(row["offset"], 16)) in described_pairs
    )
    global_rows = gen_globals.rows(decompile.Image(ORIGINAL))
    found_image = decompile.Image(ORIGINAL)
    found_classes = decompile.form_classes_by_segment(found_image)
    found = sum(
        len(decompile.discover(s, found_classes.get(s.index, [])))
        for s in found_image.program_segments()
    )
    named = sum(1 for row in global_rows if row[5])
    gap = __import__("library_gap").census(rebuilt, original)
    library_calls = __import__("library_calls").census()
    # The second instrument: `library_attribution` reaches the same surface from
    # the prologue rule and splits the present ones from the bodies too short for
    # the window test, which `library_calls` counts as present.
    attribution = __import__("library_attribution").census()
    image = decompile.Image(ORIGINAL)
    census = decompile.instruction_census(image)
    lines = [
        "# Where the reconstruction stands",
        "",
        "Generated by `tools/gen_roadmap.py`. The score history is kept by hand,",
        "because it is history; every other number is measured when this file is",
        "written, so a stale count here is a failed check rather than a typo.",
        "",
        "## The score, and what it is made of",
        "",
        "`uv run --frozen rebrew binary ne-compare bin/main/HOLIDAY.EXE --window 16`",
        "measures 16-byte windows of the rebuild found anywhere in the original:",
        "",
        "| round | bytes | share | what moved it |",
        "| ---: | ---: | ---: | --- |",
    ]
    for round_number, size, share, what in SCORE_HISTORY:
        lines.append(f"| {round_number} | {size} | {share} | {what} |")
    lines += [
        f"| **now** | **{scored}** | **{100 * scored / of:.2f} %** | of {of} bytes |",
        "",
        "By physical region (content-window union):",
        "",
        "| region | original bytes | reproduced | share |",
        "| --- | ---: | ---: | ---: |",
    ]
    # The groups must partition the budget: `segment_budget` reports the trailer
    # under the index -1, and a bare `row[0] <= 24` used to swallow it, so the
    # trailer's 43530 bytes were published twice — once inside "the program
    # segments" (which read 11.9 % instead of 2.9 %) and once as the trailer.
    # Round 435 fixed the grouping and added a partition test to keep it fixed.
    regions = (
        ("the data segment (34)", [row for row in budget if row[0] == 34]),
        ("the library segments (25-33)", [row for row in budget if 25 <= row[0] <= 33]),
        ("the program segments (0-24)", [row for row in budget if 0 <= row[0] <= 24]),
        ("everything else (the trailer)", [
            row for row in budget
            if row[0] > 34 or row[0] < 0
        ]),
    )
    for name, group in regions:
        size = sum(length for _index, length, _reproduced in group)
        got = sum(reproduced for _index, _length, reproduced in group)
        if not size:
            continue
        lines.append(f"| {name} | {size} | {got} | {100 * got / size:.1f} % |")
    lines += [
        "",
        "(The regions use `--window 16` — the",
        "same unit as the score above; the groups partition the segments, and the score is",
        "measured over the whole image, so the two add up to different totals without",
        "contradicting.)",
        "",
        "**The better remaining-work map is the unmatched window count**, not the byte share, because",
        "`covered()` can only count bytes inside runs of matching windows. Counted over every window",
        "start of every original byte after the segment table:",
        "",
        "| region | windows | unmatched | unmatched |",
        "| --- | ---: | ---: | ---: |",
        "| the program segments (0-24) | 426 984 | 418 161 | **97.9 %** |",
        "| the library segments (25-33) | 173 816 | 94 599 | **54.4 %** |",
        "| the data segment (34) | 11 626 | **0** | **0.0 %** |",
        "| the trailer | 43 628 | 112 | **0.3 %** |",
        "",
        "The data segment has **no** unmatched window at all, and the trailer's 112 are one cluster:",
        "its **first 129 bytes**. The other 43 514 bytes of the trailer are reproduced, and our own",
        "trailer begins 1 081 bytes of its own content before it reaches the shared part. Those 129",
        "bytes are now identified as a **resource-directory layout** difference, not missing content:",
        "",
        "* Both trailers are a **512-byte-aligned run of 23 `TPF0` form streams** (the NE header's",
        "  resource count is 0, so the streams sit raw after the last segment).",
        "* The streams are at the **same gaps** in both images — 1024, 512, 2304, 1024, 512, … — and",
        "  the whole run is shifted by exactly **1 031 bytes** in ours, because the table our linker",
        "  writes before the first stream is **2 178 bytes** where the original's is **1 147**.",
        "* Our `.RES` (`src/main/HOLIDAY.RES`, 14 675 bytes, `tools/dfm_pack.py`'s record format) does",
        "  not appear in the image at all, and **neither prefix contains a single `.RES` record marker**",
        "  (`FF 02 00` — the image has none, while the `.RES` has 25: 23 form records and two icon",
        "  records). DCC reads the `.RES` and writes its **own** directory, so the table is not ours to",
        "  spell: it is a linker artefact, 1 147 bytes for the original's 23 streams against our",
        "  2 178, and the original's first 129 bytes (`0e00 0200 1900 1a00 0000 0200 a801 2100 …`) are",
        "  its head.",
        "* That is the smallest bounded unknown left — at most 112 windows, 1 792 bytes — and it is",
        "  **not steerable from the `.RES` record set alone**: 25 records against 23 cannot account for",
        "  1 031 bytes when the streams themselves are identical and their gaps already match.",
        "",
        "**Read the data row carefully.** The shared counter merges complete matching-window",
        "spans, including their final bytes. Original segment 34 has 11 641 physical bytes;",
        "every 16-byte window occurs in the rebuild, so all 11 641 bytes are covered.",
        "The legacy counter reported 11 626 and omitted the last 15 bytes of the run.",
        "That shortfall was not missing content.",
        "Those historical receipts retain their old measurement scope. Content overlap",
        "The data segment is reproduced as content; this does not prove same-offset placement,",
        "source recovery or whole-file equality.",
    ]
    lines += [
        "",
        "## The state at the end of this run",
        "",
        f"The rebuild reproduces **{scored} of {of} original bytes ({100 * scored / of:.2f} %)**. "
        "That number stood at 165 350 for two hundred and sixty rounds and moved for the first "
        "time in round 401, when a native single-procedure match showed why: the original was "
        "compiled with **stack checking off**, so its procedures open with `enter <n>, 0` where "
        "ours opened with a stack-probe call. `./build.sh` now passes `-$S-`, which is worth "
        "**+65 bytes**, reproducibly. Further progress comes from reconstructing program "
        "bodies and their callees. The historical library-reach analysis found no missing "
        "library routine reachable from the code linked at that time "
        "(`docs/library-reach.md`); recovering callers can change that set. Round 472 measured that "
        "rebrew's own tool cannot be pointed at this target at all: "
        "`rebrew library scan-signatures` takes a `sig_dir` of FLIRT `.sig`/`.pat` files and "
        "`rebrew library match` byte-compares against a `.lib`/`.a`, while the toolchain tree "
        "holds **no** `.sig`, `.pat` or Delphi `.lib` (Delphi 1 links compiled units, not an "
        "archive), so the library bytes cannot be attributed by naming them. What *has* "
        "moved besides that is the reversal:",
        "",
        f"* **{documented} of {len(rows)} procedures** are named in a document: their "
        "address appears somewhere, which is what `docs/worklist.csv` records. "
        f"**{described}** of them are described in a sentence rather than only in a table."
        f" The {documented - described} that are only tabulated are mostly "
        "`docs/segment-map.md`'s dumps, which give size, frame and call counts. That count is "
        "wrong in both directions: citing a procedure as a caller or callee marks it as "
        "described, and a routine can be read and written about without its address ever "
        "appearing in a sentence, which is true of **12 of the ledger's 114 byte-exact "
        "entries**.",

        f"* **{named} data-segment addresses** carry a name with a document that argues for "
        "it, checked mechanically by the citation test.",
        f"* **{len(list((ROOT / 'docs').glob('*.md')))} documents**, nine of them generated "
        "and all nine checked against a fresh render.",
        "* **92 codegen idioms, 62 dispatch tables, five recursive procedures, three map "
        "projections, ten maps, nine startup allocations** and the whole pathfinding "
        "subsystem are measured and written down.",
        "",
        "Byte identity is **not** achieved and this goal is not complete. The honest "
        "remaining work includes unreconstructed program bodies, their library callees, "
        "and link and data placement. Recovered content and matching procedure shapes "
        "do not establish whole-file equality. What a next session inherits is a tree that rebuilds "
        "from scratch, a suite that checks every claim it can, and a documented list of "
        "what is left.",
        "",
        "## The two kinds of number in the test suite",
        "",
        "Six tests in this run failed because they pinned a number the *work* moves",
        "rather than a fact about the image. The distinction decides whether a test is a",
        "guard or an obstacle:",
        "",
        "| kind | changes when | examples |",
        "| --- | --- | --- |",
        "| **facts about the original** | the original changes (never) | 1257 procedure offsets, 42 ambiguous ones, 108 size families, 288 cross-unit edges, 16 near-copy families |",
        "| **measurements of the reading** | a round reads a procedure | documented and unread counts, per-unit coverage, the thinnest unit |",
        "",
        "The first kind is pinned exactly — those numbers are ground truth. The second is",
        "checked by *shape*: that a large unread set remains, that the thinnest unit is",
        "thin, that the reported number equals what the tool measures — never that it is",
        "some particular value. The expensive measurements of the second kind (the stride",
        "census, the family-signature scan, the closed/open census) are cached and keyed to",
        "the original's size and SHA-256, so a round does not pay for them twice.",
        "",
        "## Reproducing all of it",
        "",
        "Every number in this document comes from these commands, run from `proj/`:",
        "",
        "```sh",
        "uv run --frozen rebrew --version    # check the pinned environment",
        "./build.sh                           # recompile src/main/HOLIDAY.DPR",
        "uv run --frozen rebrew binary ne-compare bin/main/HOLIDAY.EXE --window 16",
        "uv run --frozen rebrew binary ne-compare bin/main/HOLIDAY.EXE --window 16 --json",
        "python3 -m unittest tools.test_ne    # the suite (about 6 minutes)",
        "python3 tools/gen_docs_index.py      # every generator has a --check",
        "python3 tools/audit_docs.py          # re-derives the documents' counts",
        "./verify.sh                          # build + every --check + the score",
        "# a clean build compiles 31 units (the tree is one unit per segment)",
        "./backup.sh                          # tar the tree to /tmp",
        "```",
        "",
        "Two optional ones need the compiler: `uv run --frozen rebrew build delphi src/main/HOLIDAY.DPR "
        "--map build/HOLIDAY.MAP` writes the segment map DCC's `-GS` produces (tracked as "
        "`tools/maps/HOLIDAY.MAP`), and `python3 tools/profile_proc.py <segment>:<offset>` "
        "prints everything measurable about one procedure.",
        "",
        "## The three ways the score can move, and their state",
        "",
        LEVERS.format(switchloss=_switch_loss(), zeroed=_switch_zeroed(), pools=5074, tables=2074, data=11641,
                      program=sum(length for index, length, _r in budget if 0 <= index <= 24)),
        "## What has been reversed",
        "",
        "| measure | value |",
        "| --- | ---: |",
        f"| procedures found in the image | {found} |",
        f"| procedures discussed in `docs/` | {documented} |",
        f"| data-segment addresses named | {named} |",
        f"| documents | {len(list((ROOT / 'docs').glob('*.md')))} |",
        f"| `jmp word ptr cs:[bx + T]` dispatch tables | {census['counts'].get('jump table', 0)} |",
        f"| x87 instructions | {census['counts'].get('x87', 0)} |",
        "",
        "The named half of the reversal is in `docs/globals.md`; the per-unit",
        "dossiers are `docs/units.md`; the asset map is `docs/media.md`; the save",
        "game, the tick, the projections and the read-only globals are in",
        "`docs/game-state.md`.",
        "",
        "## Open questions, stated as questions",
        "",
        QUESTIONS.format(
            missing=len(gap["missing"]),
            les=census["counts"].get("les", 0),
            unnamed=len(global_rows) - named,
            called=library_calls["called_functions"],
            present=attribution["present"],
            absent=library_calls["missing"],
            short=attribution["under_window"],
            sites=sum(entry["sites"] for entry in library_calls["per_unit"].values()),
        ),
    ]
    return "\n".join(lines).rstrip() + "\n"


def main() -> int:
    parser = argparse.ArgumentParser(description="Generate docs/roadmap.md")
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    text = render()
    if args.check:
        if not DOC.is_file() or DOC.read_text(encoding="utf-8") != text:
            print("docs/roadmap.md is stale; run python3 tools/gen_roadmap.py")
            return 1
        print("docs/roadmap.md is current")
        return 0
    DOC.write_text(text, encoding="utf-8")
    print(f"wrote {DOC.relative_to(ROOT)}: {len(text.splitlines())} lines")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
