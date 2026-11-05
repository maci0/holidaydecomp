#!/usr/bin/env python3
"""rtl_helper_probe.py — which System helper a Pascal construct compiles to.

`docs/system-helpers.md` named the game's System helpers by reading segment 33: a
body that loads a length byte, stores it and `rep movsb`s the characters is a
string copy, and a variant that clamps the length first is a bounded copy. Reading
tells you what a routine *does*; it cannot tell you which source construct the
compiler emits it for, and that is the half that names it.

This compiles a minimal probe for each construct and reports which System routine
the compiler calls, identified by matching the original's routine bodies inside the
probe. The DCU compiled both images, so a body that matches byte for byte is the
same routine — and the call site's position in the probe's source is the construct.

    python3 tools/rtl_helper_probe.py             # build the probes and report
    python3 tools/rtl_helper_probe.py --json

The probes live in `tools/probes/rtl_helpers/`, each in its own directory: a build
stages every sibling of the source, so a shared directory makes the build refuse
when one sibling's basename is not 8.3-safe.
"""

from __future__ import annotations

import argparse
import json
import os
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

import decompile  # noqa: E402

ROOT = Path(__file__).resolve().parents[1]
ORIGINAL = ROOT / "original" / "holiday.exe"
PROBES = ROOT / "tools" / "probes" / "rtl_helpers"

#: The System routines to identify: the two the game calls most, by offset.
HELPERS = {
    "164C": 0x164C,
    "15CD": 0x15CD,
    "15E7": 0x15E7,
    "0CB7": 0x0CB7,
    "0CBE": 0x0CBE,
    "14A4": 0x14A4,
    "14E1": 0x14E1,
    "1899": 0x1899,
}
#: Longest body compared. Each helper's signature is its own extent — decoded to its
#: first terminal instruction — not a fixed window: `15E7` is 25 bytes and `15CD`
#: begins immediately after it in the original, so a fixed 25-byte window runs into
#: the neighbour and can match *its* signature by accident. A fixed window also
#: cannot be shortened for a 34-byte routine like `14A4`, which `14E1` follows.
MAX_SIGNATURE = 96
TERMINALS = ("ret", "retf", "jmp")

def extent(data: bytes, offset: int) -> bytes:
    """The routine's own bytes: from *offset* to its first terminal instruction."""
    end = offset
    for ins in decompile.engine().disasm(data[offset : offset + MAX_SIGNATURE], offset):
        end = ins.address + ins.size
        if ins.mnemonic in TERMINALS:
            break
    return data[offset:end]


def matches(a: bytes, b: bytes) -> tuple[bool, list[int]]:
    """Do two routine bodies agree, allowing one patched **word** to differ?

    The arithmetic helpers test the CPU-detection byte at a DGROUP address, which is
    `14 4a` in the original and `70 00` in a probe: two adjacent bytes. An exact
    signature therefore misses every routine that reads a global. Allowing *any* two
    differing bytes is too loose — a 25-byte body then matches a dozen unrelated
    helpers that share a prologue — so the difference has to be exactly one adjacent
    pair, which is what a patched operand looks like.
    """
    differing = [index for index, (x, y) in enumerate(zip(a, b)) if x != y]
    if not differing:
        return True, []
    # one patched word: either both bytes changed or only the one that matters
    if len(differing) == 1 or (len(differing) == 2 and differing[1] == differing[0] + 1):
        return True, differing
    return False, differing


def build(probe: Path, out: Path) -> bool:
    """Compile one probe with the project's toolchain."""
    env = dict(os.environ)
    env.setdefault("UV_CACHE_DIR", str(ROOT / ".scratch" / "uv-cache"))
    env.setdefault("XDG_CACHE_HOME", str(ROOT / ".scratch" / "cache"))
    work = Path(tempfile.mkdtemp(prefix="rtlprobe-", dir=ROOT / ".scratch"))
    command = [
        str(ROOT / ".venv" / "bin" / "rebrew"), "build", "delphi", str(probe),
        "--output", str(out), "--work-dir", str(work),
    ]
    result = subprocess.run(command, capture_output=True, text=True, env=env, cwd=ROOT)
    shutil.rmtree(work, ignore_errors=True)
    if result.returncode != 0:
        print(result.stdout[-400:], result.stderr[-400:], file=sys.stderr)
    return result.returncode == 0


def census(rebuild: bool = False) -> dict:
    original = decompile.Image(ORIGINAL)
    data = original.segments[33].data
    bodies = {name: extent(data, offset) for name, offset in HELPERS.items()}
    rows = []
    for probe in sorted(PROBES.glob("*/")):
        source = next(iter(probe.glob("*.dpr")), None)
        if source is None:
            continue
        built = ROOT / "build" / "probes" / f"{probe.name}.exe"
        built.parent.mkdir(parents=True, exist_ok=True)
        if rebuild or not built.is_file():
            if not build(source, built):
                continue
        image = decompile.Image(built)
        # which helpers the probe's System unit carries at all
        hits = []
        for name, signature in bodies.items():
            for segment in image.segments:
                if any(matches(segment.data[at : at + len(signature)], signature)[0]
                       for at in range(max(0, len(segment.data) - len(signature)))):
                    hits.append(name)
                    break
        # which ones a call site in the program actually reaches, and what differs
        called = []
        evidence = []
        ambiguous = []
        for source_segment, atype, _rtype, offset, target, addend in decompile.relocation_records(image):
            if atype != 3 or source_segment != 0 or target > len(image.segments):
                continue
            body = image.segments[target - 1].data[addend : addend + len(max(bodies.values(), key=len))]
            found = []
            for name, signature in bodies.items():
                ok, differing = matches(body[: len(signature)], signature)
                if ok:
                    found.append(name)
                    evidence.append({"site": f"{source_segment}:{offset:#06x}",
                                     "helper": name, "differing_bytes": differing})
            if len(found) == 1:
                called.append(found[0])
            elif found:
                ambiguous.append({"site": f"{source_segment}:{offset:#06x}", "matched": found})
        rows.append({"probe": probe.name, "linked": sorted(set(hits)),
                     "called": called, "calls": len(called),
                     "ambiguous": ambiguous, "evidence": evidence})
    return {"helpers": sorted(HELPERS), "probes": rows}


def main() -> int:
    parser = argparse.ArgumentParser(description=(__doc__ or "").splitlines()[0])
    parser.add_argument("--rebuild", action="store_true", help="recompile every probe")
    parser.add_argument("--json", action="store_true")
    args = parser.parse_args()

    result = census(rebuild=args.rebuild)
    if args.json:
        print(json.dumps(result, indent=1))
        return 0
    print(f"System helpers under test: {', '.join(result['helpers'])}")
    for row in result["probes"]:
        print(f"  {row['probe']:12s} linked {','.join(row['linked']) or '-':12s} "
              f"called {','.join(row['called']) or '-'}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
