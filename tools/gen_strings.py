#!/usr/bin/env python3
"""Every string literal the code passes as `push cs:offset`.

The 16-bit compiler hands a literal to a routine by loading its address and
pushing the code segment with it — `mov di, 0x15F0 ; push cs ; push di` — so a
sweep over the discovered procedures finds every literal the program uses,
without guessing where an embedded string starts. `docs/strings.md` is that
sweep, regenerated here so it cannot drift; `--check` compares instead of
writing.
"""

from __future__ import annotations

import argparse
import collections
import re
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

import decompile  # noqa: E402

ROOT = Path(__file__).resolve().parent.parent
DOC = ROOT / "docs" / "strings.md"
LOAD = re.compile(r"(di|si|bx), (0x[0-9a-f]{4})$")
EXTENSIONS = ("bmp", "wav", "dat", "avi", "txt", "his", "map", "mid", "exe", "dll")


def literals(image) -> dict[str, list[tuple[int, int]]]:
    """(string) -> the (segment, procedure) pairs that reference it."""
    classes = decompile.form_classes_by_segment(image)
    found: dict[str, list[tuple[int, int]]] = collections.defaultdict(list)
    for segment in image.program_segments():
        for function in decompile.discover(segment, classes.get(segment.index, [])):
            body = decompile.procedure_body(segment, function)
            for index, ins in enumerate(body[:-1]):
                if ins.mnemonic != "mov":
                    continue
                match = LOAD.fullmatch(ins.op_str)
                if not match:
                    continue
                following = body[index + 1 : index + 4]
                if not any(
                    ins.mnemonic == "push" and ins.op_str == "cs" for ins in following
                ):
                    continue
                offset = int(match.group(2), 16)
                if not 0 < offset < len(segment.data):
                    continue
                length = segment.data[offset]
                if length == 0 or length > 120 or offset + 1 + length > len(segment.data):
                    continue
                text = segment.data[offset + 1 : offset + 1 + length]
                if not all(
                    32 <= byte < 127 or 0xA0 <= byte or byte in (9, 10, 13)
                    for byte in text
                ):
                    continue
                found[text.decode("cp1252")].append((segment.index, function.offset))
        byte_sweep(segment, found)
    return found


PATTERNS = {
    b"\xbf": b"\x0e\x57",  # mov di, imm16 ; push cs ; push di
    b"\xbe": b"\x0e\x56",  # mov si, imm16 ; push cs ; push si
    b"\xbb": b"\x0e\x53",  # mov bx, imm16 ; push cs ; push bx
}


def byte_sweep(segment, found: dict[str, list[tuple[int, int]]]) -> None:
    """The same idiom, found by its bytes.

    Linear disassembly from a procedure entry desynchronises where the compiler
    interleaved data, and the `mov di, imm16 ; push cs ; push di` pair then falls
    out of the instruction stream. The five bytes are unambiguous, so they are
    matched directly as a fallback.
    """
    data = segment.data
    for opcode, tail in PATTERNS.items():
        start = 0
        while True:
            index = data.find(opcode, start)
            if index < 0:
                break
            start = index + 1
            if index + 4 >= len(data) or data[index + 3 : index + 5] != tail:
                continue
            offset = data[index + 1] | (data[index + 2] << 8)
            if not 0 < offset < len(data):
                continue
            length = data[offset]
            if length == 0 or length > 120 or offset + 1 + length > len(data):
                continue
            text = data[offset + 1 : offset + 1 + length]
            if not all(
                32 <= byte < 127 or 0xA0 <= byte or byte in (9, 10, 13) for byte in text
            ):
                continue
            entry = (segment.index, 0)
            decoded = text.decode("cp1252")
            if entry not in found[decoded]:
                found[decoded].append(entry)


def extension(text: str) -> str | None:
    if "." not in text:
        return None
    tail = text.rsplit(".", 1)[1].lower()
    return tail if tail in EXTENSIONS else None


def render(found: dict[str, list[tuple[int, int]]]) -> str:
    by_extension: dict[str, list[str]] = collections.defaultdict(list)
    other: list[str] = []
    for text in sorted(found, key=lambda t: (-len(found[t]), t.lower())):
        tail = extension(text)
        if tail:
            by_extension[tail].append(text)
        else:
            other.append(text)
    lines = [
        "# String literals in the program",
        "",
        "Every literal the 16-bit compiler hands to a routine as a `push cs:offset`",
        "pair, extracted by `tools/gen_strings.py`. The offsets are gone by the time",
        "the string is here, because what matters is which unit uses which name.",
        "The text is German, so the bytes are read as Latin-1 (`zunächst` and",
        "`Gebäude` are in here) and the `\\n` that a `string` cannot hold stays",
        "regenerate with `python3 tools/gen_strings.py` and check with `--check`.",
        "",
        f"**{len(found)} distinct literals** over {sum(len(v) for v in found.values())} sites.",
        "",
    ]
    for tail in sorted(by_extension, key=lambda t: (-len(by_extension[t]), t)):
        names = by_extension[tail]
        lines += [f"## `.{tail}` — {len(names)} names", "", "| literal | sites | used by |", "| --- | ---: | --- |"]
        for text in names:
            owners = found[text]
            where = ", ".join(f"{segment}:{offset:#06x}" for segment, offset in sorted(set(owners))[:3])
            if len(set(owners)) > 3:
                where += f", +{len(set(owners)) - 3} more"
            lines.append(f"| `{text}` | {len(owners)} | {where} |")
        lines.append("")
    lines += [f"## Other — {len(other)} literals", "", "| literal | sites | used by |", "| --- | ---: | --- |"]
    for text in other:
        owners = found[text]
        where = ", ".join(f"{segment}:{offset:#06x}" for segment, offset in sorted(set(owners))[:3])
        if len(set(owners)) > 3:
            where += f", +{len(set(owners)) - 3} more"
        shown = text if "\n" not in text else text.replace("\n", "\\n")
        lines.append(f"| `{shown}` | {len(owners)} | {where} |")
    lines.append("")
    return "\n".join(lines)


def main() -> int:
    parser = argparse.ArgumentParser(description="Generate docs/strings.md")
    parser.add_argument("--check", action="store_true", help="compare instead of writing")
    args = parser.parse_args()
    text = render(literals(decompile.Image(decompile.ORIGINAL)))
    if args.check:
        if not DOC.is_file() or DOC.read_text(encoding="utf-8") != text:
            print("docs/strings.md is stale; run python3 tools/gen_strings.py")
            return 1
        print("docs/strings.md is current")
        return 0
    DOC.write_text(text, encoding="utf-8")
    print(f"wrote {DOC.relative_to(ROOT)} ({text.count(chr(10))} lines)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
