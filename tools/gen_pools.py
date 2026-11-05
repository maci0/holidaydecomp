#!/usr/bin/env python3
"""gen_pools.py — recover each program unit's string constants and link them back.

Delphi 1 stores a `string` literal as a length byte plus its characters, packed
consecutively in the *unit's code segment*.  The original's program segments
still hold those pools, so the literals can be read out in their compiled order:

    seg 11 @ 0x2680: 'start1.bmp' 'scrli.bmp' 'scrre.bmp' ...  (27 literals, 314 bytes)

Writing them back as source restores them exactly — measured, a unit that
assigns the segment-11 pool in order compiles to a **314-byte run identical to
the original's**, in a code segment.  The placement depends on how a constant is
declared, which is what makes that possible:

| source | where the bytes land |
| --- | --- |
| `s := 'text'` (string) | the code segment |
| `s := 'text'` (PChar) | the data segment |
| `if s = 'text'` (comparison) | the code segment |
| `S: string = 'text'` (typed constant) | the data segment |

So the generated unit assigns every literal to a `string`, and the pools come
back as code-segment data.

The generated file is `src/main/POOLS.PAS`, one `procedure Pool<seg>_<offset>`
per recovered chain so the provenance (which segment, which offset) survives,
and a single `procedure LoadPools` that `HOLIDAY.DPR` calls.  The literals are
*recovered data*, and their placement inside the unit is a guess: when a unit's
body is reversed, its own constants belong there instead.

Usage:
    python3 tools/gen_pools.py [--check] [--min 2]

`--check` fails when the tree on disk is not what the generator would write.
"""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(REPO / "tools"))

import decompile as D  # noqa: E402

SRC = REPO / "src" / "main"
OUT = SRC / "POOLS.PAS"

#: ASCII only, deliberately.  The game's German text is Windows-1252 (measured:
#: `Dateiname ungültig` at segment 8 `0x0DEB` has `0xFC` for ü), and DCC does
#: round-trip high bytes unchanged, but allowing them recovers only ~30 extra
#: bytes of chains while admitting code bytes and RTTI class names that parse as
#: length-prefixed strings.  The message literals that are worth having are
#: single long strings, not chains, and are not worth a looser filter here.
PRINTABLE = set(range(32, 127)) | set(range(0xA0, 0x100))  # Latin-1, the game is German

#: A literal longer than this is far more likely to be a run of code that
#: happens to look like text.
MAX_LITERAL = 120  # Delphi short strings hold 255; the longest here is 85


def chains(data: bytes, minimum: int = 2) -> list[tuple[int, int, list[str]]]:
    """Recovered literal chains as `(offset, length, literals)`.

    A chain is a run of adjacent length-prefixed strings, which is how the
    compiler packs them.  Requiring at least *minimum* of them keeps a single
    length byte followed by text from being read as a literal.
    """
    out: list[tuple[int, int, list[str]]] = []
    position = 0
    while position < len(data) - 3:
        cursor = position
        found: list[str] = []
        while cursor < len(data) - 3:
            length = data[cursor]
            if not 2 <= length <= MAX_LITERAL or cursor + 1 + length > len(data):
                break
            text = data[cursor + 1 : cursor + 1 + length]
            if not all(byte in PRINTABLE for byte in text):
                break
            if not any(65 <= byte <= 122 for byte in text):
                break
            found.append(text.decode("latin1"))
            cursor += 1 + length
        if len(found) >= minimum:
            out.append((position, cursor - position, found))
            position = cursor
        else:
            position += 1
    return out


def known_literals(image: D.Image) -> list[tuple[int, int, str]]:
    """The literals the code itself passes, as `(segment, offset, text)`.

    The chain scanner needs two adjacent strings to be sure it is reading a
    literal pool rather than a byte that happens to look like a length; but a
    literal the code hands to a routine with `push cs:offset` is *known* to be
    one, whether or not it has neighbours. Those are added here so the pools
    carry every string the program demonstrably uses.
    """
    import gen_strings

    found = gen_strings.literals(image)
    out: list[tuple[int, int, str]] = []
    classes = D.form_classes_by_segment(image)
    for segment in image.program_segments():
        for function in D.discover(segment, classes.get(segment.index, [])):
            body = D.procedure_body(segment, function)
            for index, ins in enumerate(body[:-2]):
                if ins.mnemonic != "mov":
                    continue
                match = re.fullmatch(r"(di|si|bx), (0x[0-9a-f]+)", ins.op_str)
                if not match:
                    continue
                if not any(
                    later.mnemonic == "push" and later.op_str == "cs"
                    for later in body[index + 1 : index + 4]
                ):
                    continue
                offset = int(match.group(2), 16)
                length = segment.data[offset] if offset < len(segment.data) else 0
                text = segment.data[offset + 1 : offset + 1 + length]
                if length and all(byte in PRINTABLE for byte in text):
                    decoded = text.decode("latin1")
                    if decoded in found:
                        out.append((segment.index, offset, decoded))
    return out


def pool_source(image: D.Image, minimum: int = 2) -> tuple[str, int]:
    """The `POOLS.PAS` text and the number of recovered bytes."""
    declarations: list[str] = []
    bodies: list[str] = []
    total = 0
    covered: set[str] = set()
    for segment in image.program_segments():
        for offset, length, literals in chains(segment.data, minimum):
            total += length
            covered.update(literals)
            name = f"Pool{segment.index}_{offset:04X}"
            declarations.append(f"procedure {name};")
            assignments = "\n".join(
                "  s := '" + literal.replace("'", "''") + "';" for literal in literals
            )
            bodies.append(
                f"{{ segment {segment.index} offset {offset:#06x}: "
                f"{len(literals)} literals, {length} bytes }}\n"
                f"procedure {name};\nvar\n  s: string;\nbegin\n{assignments}\nend;\n"
            )
    for segment, offset, text in known_literals(image):
        if text in covered:
            continue
        covered.add(text)
        name = f"PoolS{segment}_{offset:04X}"
        declarations.append(f"procedure {name};")
        literals = [text]
        assignments = "\n".join(
            "  s := '" + literal.replace("'", "''") + "';" for literal in literals
        )
        bodies.append(
            f"{{ segment {segment} offset {offset:#06x}: a literal the code passes }}\n"
            f"procedure {name};\nvar\n  s: string;\nbegin\n{assignments}\nend;\n"
        )
        total += len(text) + 1

    calls = "\n".join(
        "  " + declaration.removeprefix("procedure ").removesuffix(";") + ";"
        for declaration in declarations
    )
    text = (
        "unit Pools;\n"
        "{ Recovered string constants, generated by tools/gen_pools.py.\n"
        f"  {len(declarations)} chains, {total} bytes, read out of the program's\n"
        "  code segments and written back as `string` literals so they compile\n"
        "  to the same bytes.  Provenance is per procedure. }\n\n"
        "interface\n\n"
        "procedure LoadPools;\n\n"
        "implementation\n\n"
        "var\n  s: string;\n\n"
        + "\n".join(bodies)
        + "\nprocedure LoadPools;\nbegin\n" + calls + "\nend;\n"
        "end.\n"
    )
    return text, total


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--check", action="store_true", help="fail when POOLS.PAS is stale")
    ap.add_argument("--min", type=int, default=2, help="minimum literals per chain")
    ap.add_argument("--original", type=Path, default=D.ORIGINAL)
    args = ap.parse_args()

    text, total = pool_source(D.Image(args.original), args.min)
    count = text.count("procedure Pool")
    if args.check:
        if not OUT.is_file() or OUT.read_text(encoding="latin1") != text:
            print(f"stale: {OUT}", file=sys.stderr)
            return 1
        print(f"checked {OUT}: {count} chains, {total} bytes recovered")
        return 0
    SRC.mkdir(parents=True, exist_ok=True)
    OUT.write_text(text, encoding="latin1")
    print(f"wrote {OUT}: {count} chains, {total} bytes recovered")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
