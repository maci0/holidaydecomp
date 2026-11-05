#!/usr/bin/env python3
"""Generate Holiday's recovered form files and project unit index."""

import argparse
import sys
from pathlib import Path

from rebrew.formats import dfm

REPO = Path(__file__).resolve().parent.parent
ORIGINAL = REPO / "original" / "holiday.exe"
OUT_DIR = REPO / "build" / "forms-reference"

def unit_for(cls: str) -> str | None:
    """The reconstructed form unit for *cls* (segment and unit name)."""
    sys.path.insert(0, str(REPO / "tools"))
    from gen_tree import segment_of_class, unit_name_for

    try:
        index = segment_of_class(cls)
    except SystemExit:
        return None
    return f"segment {index} -> {unit_name_for(cls)}.PAS"


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument(
        "--check", action="store_true", help="fail when the extracted forms are stale"
    )
    ap.add_argument("--out", type=Path, default=OUT_DIR)
    ap.add_argument("--original", type=Path, default=ORIGINAL)
    ap.add_argument(
        "--verify-roundtrip",
        action="store_true",
        help="re-encode every form and compare it with the bytes it came from",
    )
    args = ap.parse_args()

    data = args.original.read_bytes()
    if args.verify_roundtrip:
        count, bad = dfm.roundtrip(data)
        for cls in bad:
            print(f"MISMATCH {cls}", file=sys.stderr)
        print(f"round-trip: {count - len(bad)}/{count} form(s) byte-exact")
        return 1 if bad else 0
    forms = dfm.parse_forms(data)
    if not forms:
        raise SystemExit(f"no form streams found in {args.original}")

    files: dict[str, str] = {}
    for _offset, root, _end in forms:
        files[f"{root.cls}.DFM"] = dfm.render(root)

    # The index is built before the write loop: adding it afterwards reported a
    # file the loop had already passed over.
    index = [
        "# Recovered form definitions",
        "",
        "Each `.DFM` here is Delphi's own text form, recovered from the appended",
        "resource region of `original/holiday.exe` by `tools/dfm_extract.py`.",
        "The unit column is the reconstructed `src/main/*.PAS` whose code segment",
        "carries that form class's RTTI — a segment can hold several forms, which is",
        "what the 16 KB packing rule leaves behind.",
        "",
        "| form | instance | unit | components | event handlers | file offset |",
        "|---|---|---|---:|---:|---:|",
    ]
    for offset, root, _end in forms:
        comps = sum(1 for _ in root.walk())
        events = sum(len(c.events()) for c in root.walk())
        unit = unit_for(root.cls) or "not located in a code segment"
        index.append(
            f"| `{root.cls}` | `{root.name}` | {unit} | {comps} | {events} | {offset} |"
        )
    index.append("")
    files["INDEX.md"] = "\n".join(index)

    stale = []
    args.out.mkdir(parents=True, exist_ok=True)
    for name, text in files.items():
        path = args.out / name
        if path.is_file() and path.read_text(encoding="utf-8") == text:
            continue
        stale.append(name)
        if not args.check:
            path.write_text(text, encoding="utf-8")
    if args.check and stale:
        print("stale: " + ", ".join(sorted(stale)), file=sys.stderr)
        return 1

    if not args.check:  # --check is a one-liner for progress.sh
        for offset, root, _end in forms:
            comps = sum(1 for _ in root.walk())
            events = sum(len(c.events()) for c in root.walk())
            unit = unit_for(root.cls) or "not located in a code segment"
            print(
                f"{root.cls:16} {root.name:18} comps={comps:3d} events={events:3d} "
                f"{unit:32} off={offset}"
            )
    print(
        f"{'wrote' if not args.check else 'checked'} {len(files) - 1} form(s) + INDEX.md in {args.out}"
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
