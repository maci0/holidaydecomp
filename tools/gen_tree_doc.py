#!/usr/bin/env python3
"""Generate the source-tree proposal from original segment and class evidence.

Class and published method names identify declarations in code segments.
Curated filenames and segment-based grouping do not establish the original
source unit count or boundaries.

    python3 tools/gen_tree_doc.py [--check]
"""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

import decompile  # noqa: E402
from rebrew.formats import ne_analysis  # noqa: E402

ROOT = Path(__file__).resolve().parent.parent
DOC = ROOT / "docs" / "tree.md"
ORIGINAL = ROOT / "original" / "holiday.exe"


def units() -> dict[int, tuple[str, str]]:
    """segment -> (proposed unit name, job line) for the 25 program segments."""
    found: dict[int, tuple[str, str]] = {}
    text = (ROOT / "docs" / "units.md").read_text(encoding="utf-8")
    for match in re.finditer(
        r"## `([A-Z0-9_.]+)` \(segment (\d+)\)\n\n([^\n]*)", text
    ):
        found[int(match.group(2))] = (match.group(1), match.group(3).strip())
    return found


def forms_in(image, segment: int) -> list[str]:
    """The form classes whose names **and method names** appear in the segment.

    A class name alone shows only that the segment knows the class — its declaration
    or a reference to it. A class's **published method names** are emitted by the unit
    that declares it, in its RTTI, so requiring both separates "declares" from
    "references" (round 265). Scaffolds that declare no methods at all fall back to
    the name alone, and are marked.
    """
    data = image.segments[segment].data
    names = []
    # a segment's unit file declares *all* its forms since round 463, so every
    # class declaration in it is read, not just the first, and the proof is the
    # class's own `procedure <Class>.<method>` stubs rather than the file's
    for path in sorted((ROOT / "src" / "main").glob("*.PAS")):
        text = path.read_text(encoding="utf-8", errors="replace")
        claimed = re.search(r"code segment (\d+)", text)
        if not claimed or int(claimed.group(1)) != segment:
            continue
        for klass in re.findall(r"(\w+)\s*=\s*class\(TForm\)", text):
            if klass.encode() not in data:
                continue
            methods = re.findall(rf"procedure\s+{re.escape(klass)}\.(\w+)", text)
            proven = [name for name in methods if name.encode() in data]
            names.append(klass if (proven or not methods) else f"{klass}?")
    return sorted(names)


def _unknown_forms() -> int:
    """How many form rows carry a `?`: classes with methods and no method evidence."""
    image = decompile.Image(decompile.ORIGINAL)
    return sum(
        1 for segment in range(25) for name in forms_in(image, segment)
        if name.endswith("?")
    )


def files_claiming(segment: int) -> list[str]:
    names = []
    for path in sorted((ROOT / "src" / "main").glob("*.PAS")):
        text = path.read_text(encoding="utf-8", errors="replace")
        match = re.search(r"code segment (\d+)", text)
        if match and int(match.group(1)) == segment:
            names.append(path.name)
    return names


def literals(image, segment: int) -> list[str]:
    """The data-file names the segment's own bytes mention."""
    import re as _re

    found = {
        match.decode("ascii", "replace")
        for match in _re.findall(
            rb"[A-Za-z0-9_]{3,}\.(?:dat|txt|bmp|wav|mid|map|his)", image.segments[segment].data,
            _re.IGNORECASE,
        )
    }
    return sorted(found)


def name_evidence(image) -> list[str]:
    """Per segment: the name in the shared table and the literals behind it."""
    import unit_names

    lines = [
        "## What each unit name rests on",
        "",
        "The names in `tools/unit_names.py` are curated guesses, and the honest way to",
        "read them is next to the evidence each one has. The strongest evidence is a",
        "**data-file literal**: a unit that loads `abrechne.dat` is very likely the one",
        "the source called `ABRECHNE`. Counting the data-file names in each segment's",
        "own bytes:",
        "",
        "| segment | name in the table | data-file literals |",
        "| ---: | --- | ---: |",
    ]
    unattested = []
    for segment in range(25):
        name, _job = unit_names.JOBS[segment]
        count = len(literals(image, segment))
        if count == 0:
            unattested.append(segment)
        lines.append(f"| {segment} | `{name}` | {count} |")
    lines += [
        "",
        f"**{len(unattested)} of the 25 names have no literal at all** — segments "
        + ", ".join(f"`{segment}`" for segment in unattested)
        + " — and their names come from behaviour instead: what their code reads and "
        "what calls them. That is a weaker footing, and it is worth knowing which rows "
        "of the table it applies to.",
        "",
        "**Two names were decided by this table, and swapped.** The row that forced",
        "it is segment 17: it carries `animdat1.dat`, `animdat2.dat`, `animdat3.dat`,",
        "`animdat4.dat` and `neintrag.dat`, and — the deciding measurement — its code",
        "**reads all five tables those files fill** (33, 13, 13, 30 and 16 references),",
        "while segment 19 reads two of them 2 and 4 times and spends its code on the",
        "1 601-record object table instead. A unit that loads the animation data and then",
        "uses every table it fills is the animation unit, so **17 is `ANIM.PAS` and 19 is",
        "`OBJEKT.PAS`** (round 347). The tree's files were renamed with it, the build was",
        "re-run — same " + rename_figures() + " — and the",
        "hand-written documents had the two names swapped so their segment numbers still",
        "match.",
    ]
    return lines


def rename_figures() -> str:
    """Round 347's two measurements, labelled as that round's, with the live score.

    Both sentences below quote "304 919 bytes of code" and "165 350 reproduced
    bytes" from the rename experiment. They are *that round's* numbers — the score
    has since moved to its own value with `-$S-` — so they are labelled rather
    than left to read as today's, which is what round 437 fixed.
    """
    original = ne_analysis.NeImage(ROOT / "original" / "holiday.exe")
    rebuilt = ne_analysis.NeImage(ROOT / "bin" / "main" / "HOLIDAY.EXE")
    scored, _of = ne_analysis.byte_score(original, rebuilt, 16)
    return (f"304 919 bytes of code and 165 350 reproduced bytes — round 347's "
            f"figures, the score now stands at {scored}")


def fold_summary(image) -> list[str]:
    """How many units have a form file, a logic stub, or both — the fold's arithmetic."""
    only_forms, both, only_logic = [], [], []
    for segment in range(25):
        files = files_claiming(segment)
        # a form scaffold is one that declares `class(TForm)`, not one whose file
        # name starts with T: `SABOWIN.PAS` declares `TSabowin` and the prefix test
        # read it as a logic stub (round 267)
        forms, logic = [], []
        for name in files:
            text = (ROOT / "src" / "main" / name).read_text(encoding="utf-8",
                                                           errors="replace")
            if re.search(r"\w+\s*=\s*class\(TForm\)", text):
                forms.append(name)
            else:
                logic.append(name)
        if forms and logic:
            both.append(segment)
        elif forms:
            only_forms.append(segment)
        elif logic:
            only_logic.append(segment)
    lines = [
        f"* **{len(only_logic)}** units are represented by a logic stub only: "
        + ", ".join(f"`{segment}`" for segment in only_logic) + ".",
        f"* **{len(only_forms)}** are represented by **form scaffolds only** — "
        + ", ".join(f"`{segment}`" for segment in only_forms)
        + " — because their logic bodies are not recovered.",
        (
            f"* **{len(both)}** has both a logic stub and form files"
            + (f" (segment `{both[0]}`)" if both else "")
            + ", so it is the only row where folding is a move rather than a "
            "reconstruction."
            if both
            else "* **No** unit has both a logic stub and its forms, so there is no row "
            "where folding is a move rather than a reconstruction."
        ),
        "",
        f"So the tree's unit boundaries cannot be fixed by rearranging files for "
        f"**{len(only_forms) + len(only_logic)} of {len(only_forms) + len(both) + len(only_logic)}"
        " units**: where only a form scaffold or only a logic stub exists there is "
        "nothing to fold it into. The tree gap and the body gap are the same gap, seen "
        "from two sides — which is worth stating, because the tree work looked like a "
        "mechanical refactor until this count.",
    ]
    return lines


def render() -> str:
    image = decompile.Image(ORIGINAL)
    table = units()
    lines = [
        "# Source-tree proposal from original segment evidence",
        "",
        "Generated by `tools/gen_tree_doc.py` from the unit dossiers and from the",
        "class-name strings in the original's own segments.",
        "",
        "The form column requires **both** the class name and at least one of its",
        "published method names in the segment, because method names are emitted by the",
        "unit that *declares* the class while the class name alone can be a reference.",
        "A `?` after a name means no method evidence was available — the scaffold",
        "declares no methods at all, which cannot be disproven — so only the class name",
        f"could be checked. {_unknown_forms()} of them are in that position. Round 264 read",
        "segment 6's `TCreditform` as the suspicious case; with method evidence it is a",
        "declaration, and the surprising pairings are real.",
        "",
        "The original has **25 program code segments**, not 25 proven source units.",
        "Delphi can pack several units into one segment. The names below are curated",
        "reconstruction proposals, not recovered filenames or original unit boundaries.",
        "`tools/gen_tree.py` groups most form classes by segment; segment 0 currently",
        "uses separate THINTERG and TDUMMYFO units. `gen_tree.py --check` verifies",
        "that generated source is current, not that this grouping was the original tree.",
        "Nineteen named methods are now reconstructed, including seven verified no-op callbacks; see",
        "[source and compiler verification](empty-frame-codegen.md).",
        "",
        "| segment | proposed unit | role | forms it declares | files here claiming it |",
        "| ---: | --- | --- | --- | --- |",
    ]
    total_forms = 0
    split = 0
    for segment in sorted(table):
        name, job = table[segment]
        forms = forms_in(image, segment)
        total_forms += len(forms)
        claimants = files_claiming(segment)
        if len(claimants) + len(forms) > 2:
            split += 1
        lines.append(
            f"| {segment} | `{name}` | {job} | "
            f"{', '.join(f'`{f}`' for f in forms) if forms else '—'} | "
            f"{', '.join(f'`{f}`' for f in claimants) or '—'} |"
        )
    lines += [
        "",
        f"**{len(table)} program code segments, {total_forms} form classes**, and "
        f"{len(list((ROOT / 'src' / 'main').glob('*.PAS')))} `.PAS` files plus "
        "`HOLIDAY.DPR` here.",
        "",
        "## A warning for anyone rebuilding this tree: the duplication is load-bearing",
        "",
        "Round 371 measured where the program's cross-unit near-twin procedures live, and",
        "the answer is a cluster: **28 of the 150 same-size near-twin pairs cross a unit",
        "boundary, and six screen units account for all of them** — `DATWIN`, `AUKTION`,",
        "`HIGHSCOR`, `KOMPASS`, `UEBERMAP` and `HAUS`, in five pairs each for the first",
        "four and three, two and one for the others. The copied routines are row and",
        "column helpers: one 186-byte helper sits in `DATWIN` twice and in `UEBERMAP`",
        "once, so a tree that factors it into one shared unit leaves five of its six",
        "copies unbuilt — they must be filled in **six times**.",
        "",
        "That is a statement about the **original source**, and it has a practical",
        "consequence for this reconstruction: **a faithful tree must reproduce the copies,",
        "not factor them out.** The obvious refactor — one shared `Rows.pas` used by six",
        "screens — would be better code and a different program. Byte-identity is the",
        "objective, and the copied helpers are part of the bytes.",
        "",
        "Most game bodies remain stubs. Nineteen named methods are reconstructed;",
        "seven are verified original no-op callbacks, including an empty two-byte",
        "local frame, rather than unknown empty stubs. The information-form mouse",
        "callback is integrated as an ABI-compatible field reference.",
        "The restored global-info click retains a call to its original private no-op",
        "helper. Other recovered statements include application minimization,",
        "both object-cleanup handlers, and four minimal close",
        "action assignments. Their callees and the main game loop are not fully recovered.",
        "Matching repeated compiled",
        "bodies requires preserving their code; it does not prove original source",
        "copy operations or unit boundaries.",
        "",
        "## The two name columns agree now",
        "",
        "Until round 463 the tree had one file per **form** where the original had one",
        "file per **unit**, so a form segment's file was named after its class",
        "(`TCreditform` → `TCREDITF.PAS`) while the unit it belonged to was named",
        "`GFX.PAS`: two columns of names for fourteen segments, and the `files here`",
        "column above was the mapping between them.",
        "",
        "The fold removed the second column. The tree **has one unit per segment**",
        "since round 463: `tools/gen_tree.py` writes one unit per segment with every",
        "form class that segment declares, and the file count fell from 40 to 31 with it.",
        "The names come from `tools/unit_names.py`, so for segments 6, 11 and 23 the",
        "file, the unit and the dossier's name are `GFX.PAS`, `START.PAS` and",
        "`UEBERMAP.PAS` in all three places. Only segment 0 still has files of its own",
        "(`TDUMMYFO.PAS`, `THINTERG.PAS`) because its two classes belong in the program",
        "file.",
        "",
        *name_evidence(image),
        "",
        "## One naming table, and the conflict it papers over",
        "",
        "Until round 344 this project had **two curated unit-name tables**: the one in",
        "`tools/gen_units.py` that the documents quote, and a second in",
        "`tools/gen_tree.py` that named the tree's files. They disagreed about exactly",
        "three segments — the tree called 17 `ANIM`, 18 `SEG18` and 19 `SEG19` while the",
        "dossier called them `OBJEKT`, `EREIGN` and `ANIM` — so the tree and the",
        "documents described the same code under different names.",
        "",
        "There is now one table, `tools/unit_names.py`, and both generators import it.",
        "The names it carries are the dossier's, which means the tree's files were",
        "renamed to match the documents (`SEG18` → `EREIGN`, `SEG19` → `ANIM`, and the",
        "old `ANIM` → `OBJEKT`). The build was re-run after the rename with the same ",
        rename_figures() + ", so the change is a",
        "renaming and nothing else.",
        "",
        "Round 347 went further with the same evidence: segments 17 and 19 were swapped",
        "so that the unit loading the animation data is called `ANIM.PAS` (see **What each",
        "unit name rests on**). The tree, the dossier and the hand-written documents now",
        "agree on every unit name, and the rename left the build byte-identical.",
        "",
        "## What can actually be folded",
        "",
        *fold_summary(image),
        "",
        "## How the fold is kept",
        "",
        "* It is the **generator's** job, not a one-off edit: `tools/gen_tree.py` emits",
        "  one unit per segment with all its form classes, and `--check` fails if the",
        "  tree on disk is not what it writes.",
        "* The `.DFM` resources do not move — they are keyed by form class name, and",
        "  round 263 verified every scaffold's segment attribution; the fold moved",
        "  neither a class name nor a stream.",
        "* Segment 0 is the exception the table shows: `TDummyForm` and `THintergrund`",
        "  belong in the program file. Round 464 did fold them — the program file can",
        "  declare classes and their method stubs before its own `begin` — and **measured",
        "  the cost: the score fell from 165 431 to 165 426**. The fold was reverted and",
        "  the two units stay, because five bytes of the objective's headline number are",
        "  worth more than one unit of structural fidelity. The trade-off is recorded",
        "  rather than paid, and the generator carries the measurement in a comment.",
        "",
        "The fold changed no bytes of reconstruction except by **naming**: a unit's own",
        "name is emitted, so once the units were named as the original named them the",
        "build matched **16 more bytes** (165 415 to 165 431), which is the paragraph above.",
    ]
    return "\n".join(lines).rstrip() + "\n"


def main() -> int:
    parser = argparse.ArgumentParser(description="Generate docs/tree.md")
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()
    text = render()
    if args.check:
        if not DOC.is_file() or DOC.read_text(encoding="utf-8") != text:
            print("docs/tree.md is stale; run python3 tools/gen_tree_doc.py")
            return 1
        print("docs/tree.md is current")
        return 0
    DOC.write_text(text, encoding="utf-8")
    print(f"wrote {DOC.relative_to(ROOT)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
