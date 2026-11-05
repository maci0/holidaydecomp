"""Report which declaration shapes DCC 1.0 compiles to which prologue and argument load.

`tools/byte_match.py` anchors a candidate on its frame opcode, so whether a body can be confirmed
depends on the compiler choosing `enter` and loading its first argument the way the original does.
Eleven hand-built probes for one body did not settle that (rounds 359 to 367), so this tool compiles
a grid of one-line bodies through the same harness and censuses the bytes.

Usage: python tools/frame_census.py [--keep]

The probe image path is `build/bmatch-<tag>-s1.exe`: the tag comes first, then the harness's `s1`
(minimal, no stack frame check) or `s1-forms` suffix.

Both bugs were fixed: the statement that references each declaration is generated per row, so smart
linking emits the body, and the tool reads whichever of `bmatch-census.exe`, `-s1.exe` or
`-s1-forms.exe` the harness produced. The grid now reports different counts per shape.

Round 370 should call
`tools.byte_match.compile_probe` directly instead of shelling out to the CLI, which removes the
path question entirely.
"""

from __future__ import annotations

import argparse
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "tools"))

PATTERNS = {
    "enter 2,0": "c80200",
    "enter 4,0": "c80400",
    "push bp": "55",
    "al<-[bp+4]": "8a4604",
    "al<-[bp+6]": "8a4606",
    "ax<-[bp+4]": "8b4604",
    "xor ah,ah": "32e4",
    "idiv cx": "f7f9",
}

# label -> (declaration, statement that references it). The statement is not decoration:
# DCC 1.0 smart-links, so an unreferenced body is not emitted and the row would census
# nothing but library code (round 370).
DECLARATIONS = {
    "byte param, no local":
        ("function F(A: Byte): Byte;\nbegin\n  F := A;\nend;", "B := F(1);"),
    "byte param, smallint local":
        ("function F(A: Byte): Byte;\nvar S: SmallInt;\nbegin\n  S := A + 2;\n  F := S div 4;\nend;",
         "B := F(1);"),
    "word param, word local":
        ("function F(A: Word): Word;\nvar S: Word;\nbegin\n  S := A + 2;\n  F := S div 4;\nend;",
         "B := F(1);"),
    "byte param, byte local":
        ("function F(A: Byte): Byte;\nvar S: Byte;\nbegin\n  S := A;\n  F := S;\nend;",
         "B := F(1);"),
    "const byte param":
        ("function F(const A: Byte): Byte;\nbegin\n  F := A;\nend;", "B := F(1);"),
    "var byte param":
        ("procedure F(var A: Byte);\nbegin\n  A := 0;\nend;", "B := 0;\n  F(B);"),
    "byte param, Boolean result":
        ("function F(A: Byte): Boolean;\nvar S: SmallInt;\nbegin\n  S := A + 2;\n  F := S div 4 = 1;\nend;",
         "if F(1) then B := 1;"),
    "byte param, Word result":
        ("function F(A: Byte): Word;\nvar S: SmallInt;\nbegin\n  S := A + 2;\n  F := S div 4;\nend;",
         "B := F(1);"),
    "byte param, out through var":
        ("procedure F(A: Byte; var R: Byte);\nvar S: SmallInt;\nbegin\n  S := A + 2;\n  R := S div 4;\nend;",
         "F(1, B);"),
    "word param, Lo() cast":
        ("function F(A: Word): Byte;\nvar S: SmallInt;\nbegin\n  S := Lo(A) + 2;\n  F := S div 4;\nend;",
         "B := F(1);"),
    "word param, byte cast":
        ("function F(A: Word): Byte;\nvar S: SmallInt;\nbegin\n  S := Byte(A) + 2;\n  F := S div 4;\nend;",
         "B := F(1);"),
}




def build(source: str, scratch: Path) -> Path | None:
    """Compile one candidate unit through the matcher's harness."""
    path = scratch / "BMATCHU.PAS"
    path.write_text(source, encoding="utf-8")
    # A previous grid row's image would otherwise be read back as this row's result: the same
    # staleness class tools/segment_score.py guards against (rounds 261 and 263).
    for name in ("bmatch-census.exe", "bmatch-census-s1.exe", "bmatch-census-s1-forms.exe"):
        stale = ROOT / "build" / name
        if stale.is_file():
            stale.unlink()
    # the return code is not consulted: what matters is whether an image appeared, and every
    # candidate image is probed by name below
    subprocess.run(
        [sys.executable, "-m", "tools.byte_match", "--target", "24:0x03cc",
         "--source", str(path), "--tag", "census"],
        cwd=ROOT, capture_output=True, text=True, check=False)
    for name in ("bmatch-census.exe", "bmatch-census-s1.exe", "bmatch-census-s1-forms.exe"):
        image = ROOT / "build" / name
        if image.is_file():
            return image
    return None


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--keep", action="store_true", help="keep the temporary units")
    args = parser.parse_args()
    scratch = Path(tempfile.mkdtemp(prefix="frame-census-"))
    for label, (declaration, statement) in DECLARATIONS.items():
        # the first line of each declaration is already a complete interface declaration
        header = declaration.split("\n")[0]
        source = (
            "{$S-}\nunit BMATCHU;\ninterface\n\n"
            + header + "\nprocedure Run;\n\nimplementation\n\n"
            + declaration
            + "\n\nprocedure Run;\nvar B: Byte;\nbegin\n  " + statement
            + "\nend;\n\nend.\n"
        )
        image = build(source, scratch)
        if image is None:
            print(f"{label:28s} build failed")
            continue
        data = image.read_bytes()
        hits = {name: data.count(bytes.fromhex(pattern)) for name, pattern in PATTERNS.items()}
        shown = [f"{name} x{count}" for name, count in hits.items() if count]
        print(f"{label:28s} " + ", ".join(shown))
    if not args.keep:
        for path in scratch.glob("*"):
            path.unlink()
        scratch.rmdir()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
