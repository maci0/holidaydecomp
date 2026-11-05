#!/usr/bin/env python3
"""gen_reach_calls.py — call candidates for DCU members, with argument shapes.

`tools/gen_reach_candidates.py` emits four forms per member (read as an integer, read as a
string, assign a number, call with no arguments). Round 516 swept the CLASSES classes with it
and kept 5 of 90, because the library routines this project still lacks are **methods that take
arguments** — `TList.Add`, `TStream.Read`, `TControl.Invalidate` — and no form in that generator
calls a member with one.

This emits the missing forms. The shapes come from the measured call sites of the routines the
rebuild lacks (`tools/library_calls.py --missing`, whose argument shapes are in
`docs/call-graph.md`):

* **`push es` / `push di`** — a far pointer — is the most common shape of all: 17 of the 30
  missing routines are called that way, one of them from 134 sites. In Pascal that is a `var`
  parameter or a pointer argument, so the shapes are `(gPoint)`, `(gRect)` and `(gControl)`.
* **`push dx` / `push ax`** — two integers — is the second: `(0, 0)` and `(1, 1)`.
* A member may also take a string (`(gStr)`) or a single integer (`(0)`).

Wrong guesses cost the sweep one compile each and are dropped, so the generator can be generous.
Members are read from the Delphi 1 `.DCU` symbol tables (`tools/dcu_symbols.py`), which carry
names but no signatures — that is why the shapes are enumerated rather than derived.

    python3 tools/gen_reach_calls.py --units Classes,Controls,StdCtrls --out /tmp/calls.txt
"""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

import dcu_symbols  # noqa: E402

ROOT = Path(__file__).resolve().parent.parent
LIB = ROOT / "toolchain" / "recompile-toolchains" / "delphi" / "1.0-win16" / "source" / "DELPHI" / "LIB"

#: The reach unit's variable per class, so a member becomes `gVar.Member(...)`.
OBJECTS: dict[str, str] = {
    "TForm": "gSweepForm", "TScrollBox": "gSweepBox", "TCanvas": "gSweepCanvas",
    "TPen": "gSweepPen", "TBrush": "gSweepBrush", "TFont": "gSweepFont",
    "TPicture": "gSweepPicture", "TIcon": "gSweepIcon", "TMetafile": "gSweepMeta",
    "TBitmap": "gSweepBmp", "TStringList": "gSweepStrings", "TList": "gSweepList2",
    "TStream": "gSweepStream", "TComponent": "gSweepComponent", "TControl": "gSweepControl",
    "TWinControl": "gSweepWin", "TListBox": "gSweepList", "TComboBox": "gSweepCombo",
    "TEdit": "gSweepEdit", "TLabel": "gSweepLabel", "TCheckBox": "gSweepCheck",
    "TRadioButton": "gSweepRadio", "TGroupBox": "gSweepGroup", "TMemo": "gSweepMemo",
    "TButton": "gSweepButton", "TMediaPlayer": "gSweepPlayer", "TMenuItem": "gSweepItem",
    "TMainMenu": "gSweepMenu", "TPopupMenu": "gSweepPopup", "TSpeedButton": "gSweepSpeed",
    "TImage": "gSweepImage", "TPanel": "gSweepPanel", "TTimer": "gSweepTimer",
    "TShape": "gSweepShape", "TBevel": "gSweepBevel", "TNotebook": "gSweepNotebook",
    "THeader": "gSweepHeader", "TFileListBox": "gSweepFileList",
    "TDriveComboBox": "gSweepDrive", "TDirectoryListBox": "gSweepDir",
    "TFilterComboBox": "gSweepFilter", "TOpenDialog": "gSweepOpen", "TSaveDialog": "gSweepSave",
    "TColorDialog": "gSweepColor", "TFontDialog": "gSweepFontDlg",
    "TPrintDialog": "gSweepPrint", "TFindDialog": "gSweepFind",
    "TReplaceDialog": "gSweepReplace", "TScrollBar": "gSweepScroll",
    "TGraphic": "gSweepGraphic", "TPersistent": "gSweepComponent",
}

#: `(template, what the sweep needs declared for it)`.
SHAPES: list[tuple[str, str]] = [
    ("{v}.{m}(g0, g0)", "VAR: g0: Integer;"),
    ("{v}.{m}(gPt)", "VAR: gPt: TPoint;"),
    ("{v}.{m}(gRect)", "VAR: gRect: TRect;"),
    ("{v}.{m}(gStr)", "VAR: gStr: string;"),
    ("{v}.{m}(gSweepControl)", ""),
    ("{v}.{m}(g0)", "VAR: g0: Integer;"),
]


def candidates(units: list[str]) -> list[str]:
    """`VAR:`/`STMT:` lines for every member of every class in *units*."""
    out: list[str] = []
    declared: set[str] = set()
    for unit in units:
        dcu = LIB / f"{unit.upper()}.DCU"
        if not dcu.is_file():
            continue
        members = dcu_symbols.class_members(dcu_symbols.strings(dcu))
        for cls, names in members.items():
            variable = OBJECTS.get(cls)
            if variable is None:
                continue
            if f"VAR: {variable}: {cls};" not in declared:
                out.append(f"VAR: {variable}: {cls};")
                declared.add(f"VAR: {variable}: {cls};")
            for member in names:
                for template, declaration in SHAPES:
                    if declaration and declaration not in declared:
                        out.append(declaration)
                        declared.add(declaration)
                    out.append(f"STMT: {template.format(v=variable, m=member)};")
    return out


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--units", required=True,
                        help="comma-separated Delphi unit names, e.g. Classes,Controls")
    parser.add_argument("--out", type=Path, required=True)
    args = parser.parse_args()

    units = [unit.strip() for unit in args.units.split(",") if unit.strip()]
    lines = ["# Generated by tools/gen_reach_calls.py.", *candidates(units)]
    args.out.write_text("\n".join(lines) + "\n", encoding="utf-8")
    statements = sum(1 for line in lines if line.startswith("STMT:"))
    print(f"wrote {args.out} with {statements} candidates for {len(units)} unit(s)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
