#!/usr/bin/env python3
"""Check the numbers in prose against the tools that measure them.

Five rounds in a row (162, 172, 174, 179, 181) a document stated a count that was
true of a subset — a prefix of a table, a couple of units, the busiest readers —
and each time the fix was to derive the number from a tool instead of reading it.
This is the same fix applied to the prose that already exists: every sentence of
the form "<segment N> ... P procedures in B bytes" is extracted from
`docs/segment-map.md` and checked against `decompile.segment_analysis()`.

    python3 tools/audit_docs.py
"""

from __future__ import annotations

import json
import re
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

import decompile  # noqa: E402

ROOT = Path(__file__).resolve().parent.parent
DOCS = (ROOT / "docs" / "segment-map.md", ROOT / "docs" / "units.md")
CODEGEN = ROOT / "docs" / "codegen-patterns.md"
# how a row in the idiom table names its census key
IDIOMS = (
    ("enter", "enter"),
    ("push bp", "push bp"),
    ("les reg", "les"),
    ("xor ah, ah", "xor ah, ah"),
    ("adc", "adc"),
    ("jmp word ptr cs:", "jump table"),
)
IDIOM_ROW = re.compile(r"^\| ([^|]+) \| (\d+) \|")
#: `| `0x18` | 86 | ...` and `| `0x18` (24) | — | 86 | ...`: the address, then the columns
STRIDE_ROW = re.compile(r"^\| `(0x[0-9a-f]+)`(?: \(\d+\))? \| ([^|]+)\|([^|]*)\|")
CLAIM = re.compile(r"(\d+) procedures[ ,]*(?:in )?(\d+) bytes")
SEGMENT = re.compile(r"[Ss]egment (\d+)")
# "## What segment 19 does" / "## What segments 4 and 15 do"
SECTION = re.compile(r"^## .*?[Ss]egments? ((?:\d+[^\d\n]*)+)")
SITE_CLAIM = re.compile(r"`(0x[0-9a-f]{2,4})`[^`\n]{0,60}?\b(\d+) sites")


def claims() -> list[tuple[str, int, int, int]]:
    """(file, segment, procedures, bytes) for every checkable sentence."""
    found: list[tuple[str, int, int, int]] = []
    for path in DOCS:
        for line in path.read_text(encoding="utf-8").splitlines():
            for match in CLAIM.finditer(line):
                before = line[: match.start()]
                segment = None
                for candidate in SEGMENT.finditer(before):
                    segment = int(candidate.group(1))
                if segment is None:
                    continue
                found.append(
                    (path.name, segment, int(match.group(1)), int(match.group(2)))
                )
    return found


def section_claims() -> list[tuple[str, int, list[int], str, int]]:
    """(file, line number, the segments the section covers, address, sites)."""
    found: list[tuple[str, int, list[int], str, int]] = []
    for path in DOCS:
        segments: list[int] = []
        for number, line in enumerate(path.read_text(encoding="utf-8").splitlines(), 1):
            header = SECTION.match(line)
            if header:
                segments = [int(value) for value in re.findall(r"\d+", header.group(1))]
                continue
            if line.startswith("## "):
                segments = []
                continue
            if not segments:
                continue
            for match in SITE_CLAIM.finditer(line):
                found.append(
                    (path.name, number, list(segments), match.group(1), int(match.group(2)))
                )
    return found


def idiom_claims() -> list[tuple[str, int]]:
    """(idiom key, count) for every row of the codegen idiom tables.

    Only inside those sections: a `| `0x14` | 81 |` row in another table is not a
    stride, and an earlier version of this scan read one of them as a claim of 81
    for stride `0x14` (round 220).
    """
    claims: list[tuple[str, int]] = []
    inside = False
    for line in CODEGEN.read_text(encoding="utf-8").splitlines():
        if line.startswith("## "):
            inside = "idiom" in line.lower() or "stride" in line.lower()
        if not inside:
            continue
        stride = STRIDE_ROW.match(line)
        if stride:
            cells = [stride.group(2).strip(), stride.group(3).strip()]
            counts = [int(cell) for cell in cells if cell.isdigit()]
            if counts:
                # the LAST numeric cell: the table now carries the register-form count first
                # and the all-forms count second, and the historical expectations are the latter
                claims.append((f"stride {stride.group(1)}", counts[-1]))
            continue
        row = IDIOM_ROW.match(line)
        if not row:
            continue
        label = row.group(1)
        for name, key in IDIOMS:
            if name in label:
                claims.append((key, int(row.group(2))))
                break
    return claims


# Sentences that make a claim about whether a procedure loops, and name it.  The
# two directions are separate patterns: `written out`, `straight-line` and
# `no backward jump` say a procedure does **not** loop, and counting them as loop
# claims made the audit demand a backward jump from every written-out row — a bug
# round 467 found on `3:0x1B5E`, whose eleven written-out calls have no jump.
LOOP_AFFIRMING = re.compile(r"\b(is a loop|a row loop|loops? over|loop whose"
                            r"|distribution loop|iterates)\b", re.IGNORECASE)
LOOP_DENYING = re.compile(r"\b(no loop|no backward jump|straight-line|not a loop"
                          r"|written out|written-out)\b", re.IGNORECASE)
PROC_REF = re.compile(r"`(\d{1,2}):0x([0-9a-fA-F]{2,5})`")


def loop_claims() -> list[tuple[str, int, int, bool]]:
    """(document, segment, offset, claims_a_loop) for every sentence that claims one."""
    found = []
    for document in sorted((ROOT / "docs").glob("*.md")):
        text = document.read_text(encoding="utf-8")
        for sentence in re.split(r"(?<=[.\n])", text):
            affirms = LOOP_AFFIRMING.search(sentence)
            denies = LOOP_DENYING.search(sentence)
            if not (affirms or denies):
                continue
            if affirms and denies:
                continue        # a sentence that says both claims neither
            claims_a_loop = bool(affirms)
            for segment, offset in PROC_REF.findall(sentence):
                found.append((document.name, int(segment), int(offset, 16), claims_a_loop))
    return found


CURRENT_FIGURES = (
    # (document, pattern with two groups, what the tool derives)
    ("docs/roadmap.md", r"\*\*now\*\* \| \*\*(\d+)\*\* \| \*\*([0-9.]+) %\*\*"),
    ("docs/data-segment.md", r"\*\*([\d ]+) of ([\d ]+) bytes reproduced"),
)


def current_figures() -> list[tuple[str, int, float]]:
    """Numbers the tools can derive today, in the documents that quote them.

    Round 329 found `docs/data-segment.md` still quoting the data segment's budget
    from before the pools and the trailer were matched. This checks the two places
    that make a *current* claim.
    """
    found = []
    for name, pattern in CURRENT_FIGURES:
        text = (ROOT / name).read_text(encoding="utf-8")
        for match in re.finditer(pattern, text):
            first = int(match.group(1).replace(" ", ""))
            second = match.group(2).replace(" ", "")
            found.append((name, first, float(second)))
    return found


SIZE = re.compile(r"`(\d{1,2}):0x([0-9a-f]{1,4})`\s*[,(]\s*(\d[\d\s]*)\s*bytes", re.I)
#: the same claim with a descriptor between the address and the number, as in
#: ``**`14:0x210A`, the money screen's formatter** (1291 bytes, 441 instructions)``.
#: Round 638 found the one claim this form hid: it had said 1291 bytes and 441 instructions
#: since the sentence was written, while the worklist and the decoder both say 1293 and 442.
#: The window stops at a full stop or a newline and rejects another address in between, so
#: a sentence naming two procedures cannot lend one size to the other.
SIZE_NAMED = re.compile(
    r"`(\d{1,2}):0x([0-9a-f]{1,4})`[^.\n]{0,90}?\((\d[\d\s]*)\s*bytes", re.I)
#: the same claim without parentheses: ``* **`22:0x239A`** — 41 bytes, 14 instructions``.
#: Round 44 found the two claims this form hid, and both numbers in them were wrong: the span was
#: measured to the next function instead of to the routine's own `ret`, which swallowed a table.
SIZE_DASH = re.compile(
    r"`(\d{1,2}):0x([0-9a-f]{1,4})`\**[ \t]*(?:\u2014|-{1,2})[ \t]*(\d[\d\s]*)\s*bytes",
    re.I)
#: a bare count with no size beside it; the size check cannot see these
INSTRUCTIONS = re.compile(r"(\d[\d\s]*)\s+instructions")
ADDRESS = re.compile(r"`(\d{1,2}):0x([0-9a-f]{1,4})`", re.I)
CLAUSE_END = re.compile(r"[.\n]")
#: "the same N instructions" counts a compared pair, not a body: `docs/library-reach.md` uses it
#: for the original library routine against the rebuilt one, where the two differ at one operand
SAME_COUNT = re.compile(r"\bthe same\b", re.I)
#: a sentence that sizes several procedures at once, so the number is not one of them
#: a sentence that sizes several procedures at once, so the number is not one of them
COMBINED = re.compile(r"\btogether\b|\bcombined\b|\bfamily\b|\bmembers?\b", re.I)
#: another address just before this one: the size belongs to both, not to this one
ANOTHER_ADDRESS = re.compile(r"\d{1,2}:0x[0-9a-f]{1,4}", re.I)


def size_claims() -> list[tuple[str, int, str, int, int]]:
    """(file, line, address, stated, inventory) for every procedure size in prose.

    Round 615 found 30 of these stale: the documents quote a procedure's size, the
    inventory is that size, and nothing checked the two against each other, because
    a size in a sentence is neither a generated table nor a citation.
    """
    import csv
    import io

    rows = csv.DictReader(
        io.StringIO((ROOT / "docs" / "worklist.csv").read_text(encoding="utf-8"))
    )
    size = {(int(r["segment"]), int(r["offset"], 16)): int(r["size"]) for r in rows}
    found = []
    for path in sorted((ROOT / "docs").glob("*.md")):
        for number, line in enumerate(path.read_text(encoding="utf-8").splitlines(), 1):
            direct = list(SIZE.finditer(line))
            matches = [(match, False) for match in direct]
            for match in list(SIZE_NAMED.finditer(line)) + list(SIZE_DASH.finditer(line)):
                # a claim the direct pattern already read is not read twice
                if any(match.start() >= other.start() and match.end(3) <= other.end(3)
                       for other in direct):
                    continue
                # a second address between the two halves means the size is not this one's
                if ANOTHER_ADDRESS.search(line[match.end(2): match.start(3)]):
                    continue
                matches.append((match, True))
            for match, _named in matches:
                address = (int(match.group(1)), int(match.group(2), 16))
                if address not in size or COMBINED.search(line):
                    continue
                # `22:0x025B, 22:0x0ACE, 350 bytes together` and `A and B, 98 bytes each`
                # size more than one procedure, so the number cannot be checked against
                # the single address the pattern matched
                before = line[: match.start()]
                if len(ANOTHER_ADDRESS.findall(before)) > 1:
                    continue
                stated = int(match.group(3).replace(" ", ""))
                found.append((path.name, number, f"{address[0]}:{address[1]:#06x}",
                              stated, size[address]))
    return found


def instruction_claims() -> list[tuple[str, int, str, int, int]]:
    """(file, line, address, stated, live) for every prose instruction count.

    Sizes in prose were checked since round 615 and instruction counts only where they sat
    beside a size, which round 42 corrected by hand. The rest were unchecked: round 44 found
    **20 wrong**, eighteen of them the same one-instruction staleness the sizes had (the
    epilogue that an earlier extent rule left out) and two that measured a span to the next
    function instead of to the routine's own `ret`.
    """
    image = decompile.Image(decompile.ORIGINAL)
    classes = decompile.form_classes_by_segment(image)
    cache: dict[tuple[int, int], int | None] = {}

    def live_count(segment: int, offset: int) -> int | None:
        if (segment, offset) not in cache:
            found = next((f for f in decompile.discover(image.segments[segment],
                                                        classes.get(segment, []))
                          if f.offset == offset), None)
            cache[(segment, offset)] = (len(list(decompile.procedure_body(
                image.segments[segment], found))) if found else None)
        return cache[(segment, offset)]

    found = []
    for path in sorted((ROOT / "docs").glob("*.md")):
        for number, line in enumerate(path.read_text(encoding="utf-8").splitlines(), 1):
            if line.lstrip().startswith("|"):
                continue
            for match in INSTRUCTIONS.finditer(line):
                before = line[: match.start()]
                addresses = list(ADDRESS.finditer(before))
                if not addresses:
                    continue
                address = addresses[-1]
                between = before[address.end():]
                if CLAUSE_END.search(between) or ANOTHER_ADDRESS.search(between):
                    continue
                if SAME_COUNT.search(before[address.end():] + match.group(0)):
                    continue
                pair = (int(address.group(1)), int(address.group(2), 16))
                live = live_count(*pair)
                if live is None:
                    continue
                found.append((path.name, number, f"{pair[0]}:{pair[1]:#06x}",
                              int(match.group(1).replace(" ", "")), live))
    return found


EPILOGUE = re.compile(r"`(retf|ret)\s+([0-9a-fx]+)`", re.I)
#: a value a document records as a *corrected* misreading is history, not a claim:
#: `docs/codegen-patterns.md` writes "`14:0x0ad5` was misread in round 559 as `retf 4`"
MISREADING = re.compile(r"\bmisread\b|\bwas read as\b|\bearlier reading\b", re.I)


def epilogue_claims() -> list[tuple[str, int, str, str, str]]:
    """(file, line, address, stated, live) for every prose claim about a routine's epilogue.

    `ret N` and `retf N` are the arity evidence a body carries, and the documents state them in
    the same sentences that state sizes. Round 640 found two wrong and one quoted misreading: the
    comparison is numeric, because the decoder prints small operands in decimal (`ret 38`) and
    large ones in hex (`retf 0x10`), so comparing text flags claims that agree.
    """
    image = decompile.Image(decompile.ORIGINAL)
    classes = decompile.form_classes_by_segment(image)
    cache: dict[tuple[int, int], tuple[str, int] | None] = {}

    def live_epilogue(segment: int, offset: int) -> tuple[str, int] | None:
        if (segment, offset) not in cache:
            found = next((f for f in decompile.discover(image.segments[segment],
                                                        classes.get(segment, []))
                          if f.offset == offset), None)
            if found is None:
                cache[(segment, offset)] = None
            else:
                body = list(decompile.procedure_body(image.segments[segment], found))
                last = body[-1]
                if last.mnemonic in ("ret", "retf"):
                    operand = last.op_str.strip()
                    cache[(segment, offset)] = (
                        last.mnemonic,
                        (int(operand, 16) if operand.lower().startswith("0x")
                         else int(operand)) if operand else 0)
                else:
                    cache[(segment, offset)] = None
        return cache[(segment, offset)]

    found = []
    for path in sorted((ROOT / "docs").glob("*.md")):
        for number, line in enumerate(path.read_text(encoding="utf-8").splitlines(), 1):
            if line.lstrip().startswith("|") or MISREADING.search(line):
                continue
            addresses = list(ADDRESS.finditer(line))
            for match in EPILOGUE.finditer(line):
                before = [item for item in addresses if item.end() <= match.start()]
                if not before:
                    continue
                address = before[-1]
                pair = (int(address.group(1)), int(address.group(2), 16))
                live = live_epilogue(*pair)
                if live is None:
                    continue
                stated_operand = match.group(2)
                stated = (int(stated_operand, 16) if stated_operand.lower().startswith("0x")
                          else int(stated_operand))
                found.append((path.name, number, f"{pair[0]}:{pair[1]:#06x}",
                              f"{match.group(1).lower()} {stated}", f"{live[0]} {live[1]}"))
    return found


def is_text(byte: int) -> bool:
    """Latin-1 text, which is what the game's strings are: `ä` is 0xE4."""
    return 0x20 <= byte < 0xFF


def string_run(data: bytes) -> int:
    """Bytes consumed by a run of length-prefixed strings from the region's start."""
    at = 0
    while at < len(data):
        length = data[at]
        if length == 0 or at + 1 + length > len(data):
            break
        if not all(is_text(byte) for byte in data[at + 1 : at + 1 + length]):
            break
        at += 1 + length
    return at


SEPARATOR = re.compile(r"^\|[-: |]+\|$")
ADDRESS_CELL = re.compile(r"`?(\d{1,2}):0x([0-9a-f]{1,4})`?")
NUMBER_CELL = re.compile(r"\*{0,2}(\d[\d\s]*)\*{0,2}")


def table_size_claims() -> list[tuple[str, int, str, int, int]]:
    """Sizes in markdown table cells, where the *header* says the column is bytes.

    The prose sweep above cannot see these, and 132 of the rows it could not check were
    wrong, in the same 1-or-2-byte way. The header is the authority on what a column
    means: `| procedure | bytes |` is a size claim, `| procedure | self-calls |` is not,
    and treating the second column as bytes unconditionally would read a self-call count
    as a size.
    """
    import csv
    import io

    rows = csv.DictReader(
        io.StringIO((ROOT / "docs" / "worklist.csv").read_text(encoding="utf-8"))
    )
    size = {(int(r["segment"]), int(r["offset"], 16)): int(r["size"]) for r in rows}
    found = []
    for path in sorted((ROOT / "docs").glob("*.md")):
        lines = path.read_text(encoding="utf-8").splitlines()
        index = 0
        while index < len(lines) - 1:
            head = lines[index].strip()
            if not head.startswith("|") or not SEPARATOR.match(lines[index + 1].strip()):
                index += 1
                continue
            cells = [cell.strip() for cell in head.strip("|").split("|")]
            size_column = next(
                (j for j, cell in enumerate(cells) if cell.lower() in ("bytes", "size")), None
            )
            address_column = next(
                (j for j, cell in enumerate(cells) if "procedure" in cell.lower()), None
            )
            cursor = index + 2
            while (
                size_column is not None
                and address_column is not None
                and cursor < len(lines)
                and lines[cursor].strip().startswith("|")
            ):
                body = [cell.strip() for cell in lines[cursor].strip().strip("|").split("|")]
                if max(size_column, address_column) < len(body):
                    address = ADDRESS_CELL.fullmatch(body[address_column])
                    number = NUMBER_CELL.fullmatch(body[size_column])
                    if address and number:
                        pair = (int(address.group(1)), int(address.group(2), 16))
                        if pair in size:
                            found.append((path.name, cursor + 1,
                                          f"{pair[0]}:{pair[1]:#06x}",
                                          int(number.group(1).replace(" ", "")), size[pair]))
                cursor += 1
            index = cursor
    return found


LEDGER = ROOT / "build" / "matched-procedures.json"
LEDGER_PATTERNS = (
    re.compile(r"(\d[\d,]*) byte-exact procedures"),
    re.compile(r"(\d[\d,]*) byte-exact reconstructions"),
    re.compile(r"the (\d[\d,]*) procedures in `build/matched-procedures.json`"),
)
LEDGER_BYTES = re.compile(r"byte-exact procedures, ([\d, ]+) bytes")


def ledger_totals() -> tuple[int, int]:
    """(procedures, bytes) that the ledger holds as byte-exact."""
    import json

    rows = json.loads(LEDGER.read_text(encoding="utf-8"))["procedures"]
    exact = [row for row in rows if row["verdict"] == "byte-exact"]
    return len(exact), sum(row["size"] for row in exact)


def ledger_claims() -> list[tuple[str, int, int, int]]:
    """(file, line, stated procedures, stated bytes) for every ledger figure in prose.

    The ledger grows whenever a body lands, and six documents quote its totals: measured
    2026-10-14, every one of them still said 101 procedures and 7 794 bytes after two more
    bodies landed. The tool that writes the ledger is the authority, so the numbers are
    checked rather than remembered.

    This covers the **prose** form ("101 byte-exact reconstructions"). The measured table in
    `docs/session-state.md` states the same totals in its cells, and that table is checked by
    its own test, which reads the ledger directly.
    """
    procedures, bytes_ = ledger_totals()
    found = []
    for path in sorted((ROOT / "docs").glob("*.md")):
        heading = ""
        for number, line in enumerate(path.read_text(encoding="utf-8").splitlines(), 1):
            if line.startswith("#"):
                heading = line
                continue
            # A claim under a round-labelled heading is a dated record of what the ledger
            # held then, and so is a table row whose provenance cell is a round number
            # (`| 69 byte-exact reconstructions ... | 584 | ... |`). Rewriting either would
            # destroy the history this project keeps on purpose. A row that does *not*
            # cite a round is a current statement and is checked: `docs/session-state.md`'s
            # measured table is one, and it had drifted.
            if "round" in heading.lower():
                continue
            if line.strip().startswith("|"):
                cells = [cell.strip() for cell in line.strip().strip("|").split("|")]
                if any(re.fullmatch(r"\d{3}(, ?\d{3})*", cell) for cell in cells):
                    continue
            stated_procedures = None
            for pattern in LEDGER_PATTERNS:
                match = pattern.search(line)
                if match:
                    stated_procedures = int(match.group(1).replace(",", ""))
                    break
            if stated_procedures is None:
                continue
            stated_bytes = None
            match = LEDGER_BYTES.search(line)
            if match:
                stated_bytes = int(match.group(1).replace(",", "").replace(" ", ""))
            found.append((path.name, number, stated_procedures,
                          stated_bytes if stated_bytes is not None else bytes_))
    return found


#: `docs/obstacles.md` states the pair as table cells with their own wording, so it needs
#: its own two patterns: without them that row, the one synced by hand every round, was the
#: only site the sweep did not read.
DESCRIBED = (
    re.compile(r"(\d[\d,]*)[^\d]{0,16}are described in a sentence"),
    re.compile(r"described in a sentence\*\* \| \*\*(\d[\d,]*)\*\*"),
)
TABULATED = (
    re.compile(r"(\d[\d,]*)[^\d]{0,10}procedures? no sentence describes"),
    re.compile(r"the other \*\*(\d[\d,]*)\*\* appear only inside tables"),
)


def _first(patterns, line):
    for pattern in patterns:
        match = pattern.search(line)
        if match:
            return match
    return None
TABULATED_BYTES = re.compile(r"no sentence describes, ([\d ]+) bytes")


def described_totals() -> tuple[int, int, int]:
    """(described, tabulated, tabulated bytes) from the worklist and the document sweep."""
    import csv
    import io

    import worklist

    rows = list(csv.DictReader(
        io.StringIO((ROOT / "docs" / "worklist.csv").read_text(encoding="utf-8"))))
    described = worklist.described_pairs()
    counted = [row for row in rows
               if (int(row["segment"]), int(row["offset"], 16)) in described]
    tabulated = [row for row in rows
                 if (int(row["segment"]), int(row["offset"], 16)) not in described]
    return len(counted), len(tabulated), sum(int(row["size"]) for row in tabulated)


def described_claims() -> list[tuple[str, int, int, int, int]]:
    """(file, line, described, tabulated, tabulated bytes) for every coverage figure.

    Four documents quote these counts and two of them are generated, so the two hand-written
    ones were synced by hand every round. Measured 2026-10-14, one of them had been stale for
    sixteen rounds: `docs/session-state.md`'s summary table still said **831** described while
    the documents said 860, and its provenance cell named rounds 583 and 585, which is why the
    round-scoped rules elsewhere never looked at it, and the other hand-written site sits under
    a heading whose text names round 583. A count in a "state of the reconstruction"
    table is current, not history, so this sweep reads every line including table rows.
    """
    described, tabulated, bytes_ = described_totals()
    found = []
    for path in sorted((ROOT / "docs").glob("*.md")):
        for number, line in enumerate(path.read_text(encoding="utf-8").splitlines(), 1):
            # no round-heading exemption here, unlike the ledger sweep: the coverage figures
            # are the live summary wherever they appear, and the section that carries the
            # largest one is titled "Two kinds of progress... (round 583)", so skipping
            # round-labelled headings hid exactly the row this check exists to catch
            described_match = _first(DESCRIBED, line)
            tabulated_match = _first(TABULATED, line)
            if not described_match and not tabulated_match:
                continue
            bytes_match = TABULATED_BYTES.search(line)
            found.append((
                path.name,
                number,
                int(described_match.group(1).replace(",", "")) if described_match else described,
                int(tabulated_match.group(1).replace(",", "")) if tabulated_match else tabulated,
                int(bytes_match.group(1).replace(" ", "")) if bytes_match else bytes_,
            ))
    return found


#: Every **current** statement of the headline score, and nothing else. A generic sweep of
#: the form `N of 672992` was tried first and flagged four figures that are not the score:
#: the ledger's byte row, a segment-map quantity, and two dated scores from rounds 347 and
#: 463. Explicit patterns per site are what the project already uses for this kind of claim.
SCORE_SITES = (
    ("docs/obstacles.md", re.compile(r"Score: \*\*(\d[\d ]*) of (\d[\d ]*) bytes = [\d.]+ %\*\*")),
    ("docs/obstacles.md", re.compile(r"Score \*\*(\d[\d ]*) of (\d[\d ]*) = [\d.]+ %\*\*")),
    ("docs/session-state.md", re.compile(r"matched-region bytes in the stored build \| \*\*(\d[\d ]*) of (\d[\d ]*)\*\*")),
    ("docs/session-state.md", re.compile(r"Current content-window union: \*\*(\d+) of (\d+) original bytes\*\*")),
    ("docs/recovered-methods.md", re.compile(r"`(\d+) of (\d+) original bytes = [\d.]+%`")),
    ("docs/tree.md", re.compile(r"the score now stands at (\d+)")),
)


def live_scores() -> tuple[int, int, int]:
    """(window-16 bytes, window-32 bytes, the file size) as the tools measure them today."""
    from rebrew.formats import ne_analysis

    original = ne_analysis.NeImage(decompile.ORIGINAL)
    rebuilt = ne_analysis.NeImage(ROOT / "bin" / "main" / "HOLIDAY.EXE")
    window16, total = ne_analysis.byte_score(original, rebuilt, 16)
    window32, _total = ne_analysis.byte_score(original, rebuilt, 32)
    return window16, window32, total


def score_claims() -> list[tuple[str, int, int, int]]:
    """(file, line, stated window-16 bytes, stated total) for every current score statement."""
    window16, _window32, total = live_scores()
    found = []
    for name, pattern in SCORE_SITES:
        text = (ROOT / name).read_text(encoding="utf-8")
        for match in pattern.finditer(text):
            line = text[: match.start()].count("\n") + 1
            stated = int(match.group(1).replace(" ", "").replace(",", ""))
            stated_total = (int(match.group(2).replace(" ", "").replace(",", ""))
                            if match.lastindex and match.lastindex >= 2 else total)
            found.append((name, line, stated, stated_total))
    return found


def gap_kinds(image) -> dict[str, int]:
    """The bytes between declared ranges, by what they are.

    The first version of this called 7 480 of the 10 130 bytes unclassified because it
    tested for ASCII text: the strings are German, so 0xE4 failed and each run was
    rejected whole. With Latin-1 allowed they split into string runs (some with a
    tail), 16-bit tables that land in the segment's own code, and padding.
    """
    classes = decompile.form_classes_by_segment(image)
    totals: dict[str, int] = {}
    for segment in image.program_segments():
        spans = sorted(
            (f.offset, f.size)
            for f in decompile.discover(segment, classes.get(segment.index, []))
        )
        code = [offset for offset, _size in spans]
        low, high = min(code), max(offset + size for offset, size in spans) + 1
        for (offset, size), (following, _size) in zip(spans, spans[1:]):
            gap = segment.data[offset + size : following]
            if not gap:
                continue
            consumed = string_run(gap)
            words = [int.from_bytes(gap[i : i + 2], "little")
                     for i in range(0, len(gap) - 1, 2)]
            inside = [word for word in words if low <= word < high]
            if consumed == len(gap):
                kind = "strings"
            elif consumed * 2 >= len(gap):
                kind = "strings with a tail"
            elif words and len(inside) * 2 >= len(words):
                kind = "16-bit tables"
            elif all(byte in (0x00, 0xCC, 0x90) for byte in gap):
                kind = "padding"
            else:
                kind = "unclassified"
            totals[kind] = totals.get(kind, 0) + len(gap)
    return totals


def gaps_that_are_procedures(image) -> list[str]:
    """Gaps that decode as a whole procedure, entry to return at the exact end.

    This is the test that decides whether the 10 130 bytes hide a procedure the
    inventory missed. An `enter` or `push bp` at the start is not enough, and a
    terminal `retf` at the end is not enough: the region has to do both. None does.
    """
    classes = decompile.form_classes_by_segment(image)
    found = []
    for segment in image.program_segments():
        spans = sorted(
            (f.offset, f.size)
            for f in decompile.discover(segment, classes.get(segment.index, []))
        )
        for (offset, size), (following, _size) in zip(spans, spans[1:]):
            gap = segment.data[offset + size : following]
            if len(gap) < 8:
                continue
            instructions = list(decompile.engine().disasm(gap, offset + size))
            if not instructions:
                continue
            first, last = instructions[0], instructions[-1]
            entry = first.mnemonic == "enter" or (
                first.mnemonic == "push" and "bp" in first.op_str
            )
            if entry and last.address + last.size == following and last.mnemonic in ("ret", "retf"):
                found.append(f"{segment.index}:{offset + size:#06x}")
    return found


def unattributed_gaps(image) -> int:
    """Bytes inside the program segments that belong to no declared range.

    The inventory's ranges are a partition of the code, not of the segments: round 615
    measured 10 130 bytes sitting between one range's end and the next range's start.
    The gaps are not all data, and the ones sampled are length-prefixed string
    literals, which is what `21:0x234B` holds.
    """
    classes = decompile.form_classes_by_segment(image)
    total = 0
    for segment in image.program_segments():
        found = sorted(
            (f.offset, f.size)
            for f in decompile.discover(segment, classes.get(segment.index, []))
        )
        for (offset, size), (following, _size) in zip(found, found[1:]):
            total += max(0, following - (offset + size))
    return total



#: How many claims each sweep must find. A checker whose pattern stops matching passes vacuously,
#: which reads as a clean audit while nothing is checked: the coverage sweep did exactly that in
#: round 661 after a generated document lost a section. The floors are today's counts and ratchet
#: up with the documents, never down.
FLOORS = {
    "sentences": 14,
    "procedure sizes in prose": 343,
    # round 127: the unread table shrinks as rounds read, so gen_units now also emits the
    # twelve largest *described* procedures. That is a stable table of real size claims,
    # so the count rose from 525 to 537 and the floor ratchets with it.
    # round 715 folded two tails into their heads
    # (src/main/function_merges.toml): the worklist-driven sweep lost
    # `23:0x2dd3`'s size cell, so the measured count is 540 and the floor
    "procedure sizes in tables": 540,
    "ledger figures": 4,
    "epilogue claims": 30,
    "instruction claims": 211,
    "score figures": 7,
    "coverage figures": 4,
    "loop claims": 19,
    "current figures": 2,
    "site claims": 42,
    "idiom claims": 11,
}


def floor_missed(name: str, found: int) -> int:
    """1 when a sweep read fewer claims than its floor, so the caller can fail the run."""
    minimum = FLOORS[name]
    if found < minimum:
        print(f"{name}: read {found} claims, the floor is {minimum}; the documents stopped "
              f"matching this sweep")
        return 1
    return 0


def main() -> int:
    image = decompile.Image(decompile.ORIGINAL)
    #: every checker adds its own wrong count here; a printed count that does not is a gate that
    #: cannot fail (round 663 measured seven of twelve in that state)
    bad = 0
    wrong_sentences = 0
    # The count stays discovery's: a segment's procedures are its prologue
    # entries, and a folded tail is still one (the 1306-not-1304 rule). The
    # bytes follow the reviewed inventory, because discovery's prologue table
    # still holds a corrected row's pre-span size and would call segment 14's
    # 14807 wrong (the no-pre-span-size rule gen_units and gen_records follow).
    by_segment: dict[int, int] = {}
    for row in json.loads(
            (ROOT / "src" / "main" / "function_structure.json").read_text(encoding="utf-8")):
        by_segment[row["va"] // 0x10000] = (
            by_segment.get(row["va"] // 0x10000, 0) + int(row["size"]))
    for document, segment, procedures, size in claims():
        if segment > 24:
            continue
        count = decompile.segment_analysis(image, segment)["count"]
        total = by_segment.get(segment, 0)
        ok = count == procedures and total == size
        if not ok:
            wrong_sentences += 1
            print(
                f"{document}: segment {segment} says {procedures} procedures in "
                f"{size} bytes; the image has {count} and the inventory {total}"
            )
    checked = len([c for c in claims() if c[1] <= 24])
    bad += wrong_sentences
    bad += floor_missed("sentences", checked)
    print(f"{checked} sentences checked, {wrong_sentences} wrong")
    # procedure sizes quoted in prose, against the inventory
    sizes = size_claims()
    wrong_sizes = [(f, n, a, s, i) for f, n, a, s, i in sizes if s != i]
    for name, line, address, stated, inventory in wrong_sizes:
        print(f"{name}:{line}: {address} says {stated} bytes; the inventory has {inventory}")
    bad += len(wrong_sizes)
    bad += floor_missed("procedure sizes in prose", len(sizes))
    print(f"{len(sizes)} procedure sizes in prose checked, {len(wrong_sizes)} wrong")
    cells = table_size_claims()
    wrong_cells = [(f, n, a, s, i) for f, n, a, s, i in cells if s != i]
    for name, line, address, stated, inventory in wrong_cells:
        print(f"{name}:{line}: {address} says {stated} bytes; the inventory has {inventory}")
    bad += len(wrong_cells)
    bad += floor_missed("procedure sizes in tables", len(cells))
    print(f"{len(cells)} procedure sizes in tables checked, {len(wrong_cells)} wrong")
    actual_procedures, actual_bytes = ledger_totals()
    ledger = ledger_claims()
    wrong_ledger = [row for row in ledger
                    if row[2] != actual_procedures or row[3] != actual_bytes]
    for name, line, stated_procedures, stated_bytes in wrong_ledger:
        print(f"{name}:{line}: says {stated_procedures} byte-exact procedures and "
              f"{stated_bytes} bytes; the ledger has {actual_procedures} and {actual_bytes}")
    bad += len(wrong_ledger)
    bad += floor_missed("ledger figures", len(ledger))
    print(f"{len(ledger)} ledger figures checked, {len(wrong_ledger)} wrong")
    epilogues = epilogue_claims()
    wrong_epilogues = [row for row in epilogues if row[3] != row[4]]
    for name, line, address, stated, live in wrong_epilogues:
        print(f"{name}:{line}: {address} says {stated}; its own last instruction is {live}")
    bad += len(wrong_epilogues)
    bad += floor_missed("epilogue claims", len(epilogues))
    print(f"{len(epilogues)} epilogue claims checked, {len(wrong_epilogues)} wrong")
    counts = instruction_claims()
    wrong_counts = [row for row in counts if row[3] != row[4]]
    for name, line, address, stated, live in wrong_counts:
        print(f"{name}:{line}: {address} says {stated} instructions; the decoder has {live}")
    bad += len(wrong_counts)
    bad += floor_missed("instruction claims", len(counts))
    print(f"{len(counts)} instruction claims checked, {len(wrong_counts)} wrong")
    window16, window32, total = live_scores()
    scores = score_claims()
    wrong_scores = [row for row in scores if (row[2], row[3]) != (window16, total)]
    for name, line, stated, stated_total in wrong_scores:
        print(f"{name}:{line}: says {stated} of {stated_total}; the images measure "
              f"{window16} of {total}")
    bad += len(wrong_scores)
    bad += floor_missed("score figures", len(scores))
    print(f"{len(scores)} score figures checked, {len(wrong_scores)} wrong "
          f"(window 16 {window16}, window 32 {window32}, file {total})")
    described, tabulated, tabulated_bytes = described_totals()
    coverage = described_claims()
    wrong_coverage = [row for row in coverage
                      if (row[2], row[3], row[4]) != (described, tabulated, tabulated_bytes)]
    for name, line, stated, stated_tab, stated_bytes in wrong_coverage:
        print(f"{name}:{line}: says {stated} described and {stated_tab} tabulated "
              f"({stated_bytes} bytes); the documents have {described}, {tabulated} "
              f"and {tabulated_bytes}")
    bad += len(wrong_coverage)
    bad += floor_missed("coverage figures", len(coverage))
    print(f"{len(coverage)} coverage figures checked, {len(wrong_coverage)} wrong "
          f"({described} described, {tabulated} tabulated, {tabulated_bytes} bytes)")
    gaps = unattributed_gaps(image)
    kinds = gap_kinds(image)
    split = ", ".join(f"{name} {total}" for name, total in sorted(kinds.items()))
    print(f"{gaps} bytes of the program segments sit in no declared range ({split})")
    print(f"gaps that decode as a whole procedure: {len(gaps_that_are_procedures(image))}")
    # the two documents that quote a *current* figure rather than a dated one
    from rebrew.formats import ne_analysis

    score, total = ne_analysis.byte_score(
        ne_analysis.NeImage(decompile.ORIGINAL),
        ne_analysis.NeImage(ROOT / "bin" / "main" / "HOLIDAY.EXE"),
        16,
    )
    budget = {
        index: (length, reproduced)
        for index, length, reproduced in ne_analysis.segment_budget(
            ne_analysis.NeImage(decompile.ORIGINAL),
            ne_analysis.NeImage(ROOT / "bin" / "main" / "HOLIDAY.EXE"),
            16,
        )
    }
    import profile_proc

    loop_total = 0
    loop_bad = 0
    for document, segment, offset, claims_a_loop in loop_claims():
        result = profile_proc.profile(image, segment, offset)
        if not result:
            continue
        loop_total += 1
        if claims_a_loop != (result["loops"] > 0):
            loop_bad += 1
            bad += 1
            print(
                f"{document}: says {segment}:0x{offset:04x} "
                f"{'loops' if claims_a_loop else 'does not loop'}, "
                f"the profile counts {result['loops']} backward jumps"
            )
    bad += floor_missed("loop claims", loop_total)
    print(f"{loop_total} loop claims checked, {loop_bad} wrong")

    current = 0
    wrong_current = 0
    for name, first, second in current_figures():
        if name.endswith("roadmap.md"):
            percentage = 100 * score / total
            ok = first == score and abs(second - percentage) < 0.005
            expected = f"{score} ({percentage:.2f} %)"
        else:
            length, reproduced = budget[34]
            ok = first == reproduced and second == length
            expected = f"{reproduced} of {length}"
        current += 1
        if not ok:
            bad += 1
            wrong_current += 1
            print(f"{name}: says {first} / {second}, the tools derive {expected}")
    bad += floor_missed("current figures", current)
    print(f"{current} current figures checked, {wrong_current} wrong")
    site_rows = 0
    wrong_sites = 0
    for document, number, segments, address, count in section_claims():
        value = int(address, 16)
        observed = [
            decompile.segment_analysis(image, segment)["globals"].get(value)
            for segment in segments
            if segment <= 24
        ]
        site_rows += 1
        if not any(seen == count for seen in observed):
            bad += 1
            wrong_sites += 1
            print(
                f"{document}:{number}: '{address}' claimed {count} sites; the unit "
                f"counts are {observed} for segments {segments}"
            )
    bad += floor_missed("site claims", site_rows)
    print(f"{site_rows} site claims checked, {wrong_sites} wrong")
    census = decompile.instruction_census(image)
    checked = 0
    wrong_idioms = 0
    for key, count in idiom_claims():
        checked += 1
        if key.startswith("stride "):
            observed = census["strides"].get(int(key.split()[1], 16))
        else:
            observed = census["counts"].get(key)
        if observed != count:
            bad += 1
            wrong_idioms += 1
            print(f"{CODEGEN.name}: '{key}' claimed {count}; the census says {observed}")
    bad += floor_missed("idiom claims", checked)
    print(f"{checked} idiom claims checked, {wrong_idioms} wrong")
    print(f"{bad} checks wrong in total")
    return 1 if bad else 0


if __name__ == "__main__":
    raise SystemExit(main())
