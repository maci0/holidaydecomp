#!/usr/bin/env python3
"""gen_rebrew_data.py — write the documented data globals into `rebrew-data.toml`.

The project had **no data store at all**: `src/rebrew-functions.toml` holds two rows
and `docs/globals.md` holds a hundred and fifty named addresses, so every data
identity this project argues for lived only in prose.  Rebrew's managed store is the
durable, tool-readable form of those identities, and it is written exclusively through
`rebrew data set` (locked + atomic) — this script is the reproducible way to run it.

Two kinds of row come out of the documentation:

* **Objects.** Every address in `gen_globals.NAMES` is a data-segment offset this
  project has a document for.  Each becomes one `object` in `.data`, named
  `<doc tag>_<offset>` so the name says which document argues for it and is stable
  when the prose changes.
* **Aliases.** Round 461's word-pair census found **102** adjacent word pairs whose
  reader and writer sets are identical — 32-bit values.  The low half is the
  allocation (`object`, 4 bytes); the high half is an **interior address**, which the
  project's rules say is a *view* of the same storage and not a second allocation.  So
  the high half is written as `alias` with `--backing` naming its low half.

Nothing here invents a size it cannot measure: only the pair halves get an explicit
`--size 4`; the rest are named and placed, and their sizes stay unset rather than
guessed.
"""

from __future__ import annotations

import argparse
import json
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
if str(ROOT / "tools") not in sys.path:
    sys.path.insert(0, str(ROOT / "tools"))

import gen_globals  # noqa: E402

def store_path() -> Path:
    """Resolve the same configured metadata directory as Rebrew's writers."""
    from rebrew.config import load_config

    return load_config(root=ROOT).metadata_dir / "rebrew-data.toml"


PAIRS = ROOT / "build" / "word-pairs.json"
SECTION = ".data"           # every address here is an offset in segment 34


def identifier(address: int, tag: str) -> str:
    """A stable C identifier for *address*, carrying the document that names it."""
    return f"{tag.replace('-', '_')}_{address:04x}"


def rows() -> tuple[dict[int, str], dict[int, int]]:
    """(address -> name, high half -> its low half) from the docs and the census."""
    names = {
        address: identifier(address, tag)
        for address, (_description, tag) in sorted(gen_globals.NAMES.items())
    }
    aliases: dict[int, int] = {}
    if PAIRS.is_file():
        for pair in json.loads(PAIRS.read_text(encoding="utf-8"))["pairs"]:
            low, high = pair["low"], pair["high"]
            aliases[high] = low
            # the low half of a pair is the allocation even when the prose did not
            # reach it, so it gets a name too
            names.setdefault(low, identifier(low, "word-pair"))
    return names, aliases


def commands(names: dict[int, str], aliases: dict[int, int]) -> list[list[str]]:
    """The `rebrew data set` calls, one per setter kind.

    The flag is repeated per value — `--name a=b --name c=d` — because a single
    `--name` followed by several values is read as one value plus stray positional
    arguments, which the CLI rejects as "unexpected extra argument(s)".
    """
    base = ["rebrew", "data", "set"]
    named = sorted(names)
    objects = sorted(set(names) - set(aliases))
    pair_lows = {
        pair["low"] for pair in json.loads(PAIRS.read_text(encoding="utf-8"))["pairs"]
    }

    def flag(name: str, pairs: list[str]) -> list[str]:
        out: list[str] = []
        for value in pairs:
            out += [name, value]
        return out

    return [
        base + flag("--name", [f"{address:#06x}={names[address]}" for address in named]),
        base + flag("--section", [f"{address:#06x}={SECTION}" for address in named]),
        base + flag("--storage-kind",
                    [f"{address:#06x}=object" for address in objects]
                    + [f"{address:#06x}=alias" for address in sorted(aliases)]),
        base + flag("--backing", [f"{address:#06x}={names[low]}"
                                  for address, low in sorted(aliases.items())]),
        # only the *allocation* half of a pair gets a size: an alias is a view of
        # that storage, so it records its backing and owns no extent of its own
        base + flag("--size", [f"{address:#06x}=4" for address in objects
                               if address in pair_lows]),
    ]


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--dry-run", action="store_true",
                        help="print the calls instead of running them")
    parser.add_argument("--check", action="store_true",
                        help="fail when `rebrew-data.toml` is missing or empty")
    args = parser.parse_args()

    names, aliases = rows()
    calls = commands(names, aliases)
    store = store_path()
    if args.check:
        if not store.is_file() or store.stat().st_size == 0:
            print(f"{store} is missing or empty; run python3 tools/gen_rebrew_data.py",
                  file=sys.stderr)
            return 1
        text = store.read_text(encoding="utf-8")
        missing = [name for name in names.values() if name not in text]
        if missing:
            print("not in the store: " + ", ".join(missing[:5]), file=sys.stderr)
            return 1
        print(f"{store} holds {len(names)} names and {len(aliases)} aliases")
        return 0
    if args.dry_run:
        for call in calls:
            print(" ".join(call[:2]), f"... {len(call) - 2} arguments")
        print(f"{len(names)} names, {len(aliases)} aliases, {len(calls)} calls")
        return 0
    for call in calls:
        result = subprocess.run(call, cwd=ROOT, capture_output=True, text=True)
        if result.returncode != 0:
            sys.stderr.write(result.stdout + result.stderr)
            return result.returncode
    print(f"wrote {store_path()}: {len(names)} names, {len(aliases)} aliases")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
