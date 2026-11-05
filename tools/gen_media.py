#!/usr/bin/env python3
"""`docs/media.md`: which unit names which file.

Every asset the game refers to is a string in a program segment, so the segments
say who uses what: one unit plays the ending films, another owns the auction's
five bitmaps, and so on. The tables are built from the same literal census that
`docs/strings.md` prints, grouped by segment and by the file's extension.

    python3 tools/gen_media.py [--check]
"""

from __future__ import annotations

import argparse
import collections
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

import decompile  # noqa: E402
import gen_strings  # noqa: E402
import gen_tree  # noqa: E402

ROOT = Path(__file__).resolve().parent.parent
DOC = ROOT / "docs" / "media.md"
EXTENSIONS = ("AVI", "BMP", "DAT", "MID", "TXT", "WAV")


def inventory(image) -> dict[str, dict[int, list[str]]]:
    """extension -> segment -> sorted file names."""
    found: dict[str, dict[int, list[str]]] = {
        suffix: collections.defaultdict(set) for suffix in EXTENSIONS
    }
    for text, owners in gen_strings.literals(image).items():
        if "." not in text:
            continue
        suffix = text.rsplit(".", 1)[-1].upper()
        if suffix not in found:
            continue
        for segment, _offset in owners:
            if 0 <= segment <= 24:
                found[suffix][segment].add(text)
    return {suffix: {segment: sorted(names) for segment, names in groups.items()}
            for suffix, groups in found.items()}


def unit_names(image) -> dict[int, str]:
    names: dict[int, str] = {}
    for index, name, _cls, _evidence in gen_tree.generated_units():
        names.setdefault(index, name)
    return names


def render(image) -> str:
    found = inventory(image)
    names = unit_names(image)
    lines = [
        "# Which unit names which file",
        "",
        "Every asset name the game uses is a string in one of the program segments,",
        "so the segments say who uses what. Built by `tools/gen_media.py` from the",
        "same literal census as `docs/strings.md`.",
        "",
    ]
    for suffix in EXTENSIONS:
        groups = found[suffix]
        total = sum(len(v) for v in groups.values())
        lines.append(f"## `.{suffix}` — {total} names in {len(groups)} units")
        lines.append("")
        lines.append("| unit | segment | names |")
        lines.append("| --- | ---: | ---: |")
        for segment in sorted(groups):
            label = names.get(segment, f"segment {segment}")
            lines.append(f"| `{label}` | {segment} | {len(groups[segment])} |")
        lines.append("")
        for segment in sorted(groups):
            label = names.get(segment, f"segment {segment}")
            listing = ", ".join(f"`{name}`" for name in groups[segment])
            lines.append(f"**{label}** (segment {segment}): {listing}")
            lines.append("")
    return "\n".join(lines).rstrip() + "\n"


def main() -> int:
    parser = argparse.ArgumentParser(description="Generate docs/media.md")
    parser.add_argument("--check", action="store_true", help="compare instead of writing")
    args = parser.parse_args()
    text = render(decompile.Image(decompile.ORIGINAL))
    if args.check:
        current = DOC.read_text(encoding="utf-8") if DOC.is_file() else ""
        if current != text:
            print("docs/media.md is stale; run python3 tools/gen_media.py")
            return 1
        print("docs/media.md is current")
        return 0
    DOC.write_text(text, encoding="utf-8")
    print(f"wrote {DOC.relative_to(ROOT)}: {len(text.splitlines())} lines")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
