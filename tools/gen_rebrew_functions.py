#!/usr/bin/env python3
"""gen_rebrew_functions.py — put this project's procedures into the function store.

`rebrew status` reported **1306 functions and 0 covered**, and the two rows in
`rebrew-functions.toml` were the only identities the store held — so the reversal's
own progress (822 of 1306 procedures read, each with measured behaviour in a document)
was invisible to every rebrew view: `status`, `todo`, `coverage`, the dashboards.

This writes one identity row per procedure in the inventory, through rebrew's own locked
writer (`rebrew.metadata.functions.record_function_rows`), which is the sanctioned route — the
store must never be hand-edited:

* ``module="MAIN"``, ``va = segment * 0x10000 + offset``, ``file`` = the unit that owns
  the segment (from `unit_names.py`), ``kind="FUNCTION"``, ``name``/``symbol`` as
  ``func_<va:08x>``, and the prologue table's ``size``.
* The provenance tag is ``intake``: rebrew's tag set is **closed**
  (`rebrew.metadata.functions.PROVENANCE_TAGS`), so a generator cannot invent `gen_rebrew_functions`,
  and onboarding a target's function list is what ``intake`` names.
* A **note** on the rows that are documented, naming the worklist as the evidence, and
  dropped again from a row the worklist no longer holds (a reviewed extent fold retires
  the tail's row while its identity stays).  What
  the note must not do is claim a byte match: nothing here is compiled, ``STATUS`` is
  deliberately left to `rebrew test`/`verify`, and a FUNCTION row records identity without a match claim.
"""

from __future__ import annotations

import argparse
import csv
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
if str(ROOT / "tools") not in sys.path:
    sys.path.insert(0, str(ROOT / "tools"))

import unit_names  # noqa: E402

WORKLIST = ROOT / "docs" / "worklist.csv"
DOCUMENTED_NOTE = (
    "read and documented in docs/segment-map.md with measured behaviour; "
    "no source, not compiled (docs/worklist.csv documented=yes)"
)


def rows() -> list[dict[str, object]]:
    """One identity row per procedure in the worklist."""
    out: list[dict[str, object]] = []
    with WORKLIST.open(encoding="utf-8") as handle:
        for row in csv.DictReader(handle):
            segment = int(row["segment"])
            offset = int(row["offset"], 16)
            va = segment * 0x10000 + offset
            name = f"func_{va:08x}"
            # segment 0's unit is the program file itself, and the table stores it
            # as `HOLIDAY.DPR` — a name that already carries its extension
            unit = unit_names.JOBS.get(segment, ("", ""))[0]
            file_name = unit if unit.upper().endswith((".PAS", ".DPR")) else f"{unit}.PAS"
            entry: dict[str, object] = {
                "module": "MAIN",
                "va": va,
                "identity": {
                    "file": f"src/main/{file_name}",
                    "name": name,
                    "symbol": f"_{name}",
                    "kind": "FUNCTION",
                },
                "fields": {"size": int(row["size"])},
            }
            if row["documented"] == "yes":
                entry["fields"]["note"] = DOCUMENTED_NOTE   # type: ignore[index]
            out.append(entry)
    return out


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--dry-run", action="store_true",
                        help="report what would be written without writing")
    parser.add_argument("--check", action="store_true",
                        help="fail when the store does not hold every procedure")
    args = parser.parse_args()

    wanted = rows()
    documented = sum(1 for row in wanted
                     if isinstance(row["fields"], dict) and "note" in row["fields"])
    from rebrew.config import load_config

    metadata_dir = load_config(root=ROOT).metadata_dir
    store = metadata_dir / "rebrew-functions.toml"

    if args.check:
        if not store.is_file():
            print(f"{store} is missing; run python3 tools/gen_rebrew_functions.py",
                  file=sys.stderr)
            return 1
        from rebrew.metadata.functions import load_metadata

        current = load_metadata(metadata_dir)
        missing = [row for row in wanted
                   if ("MAIN", int(row["va"])) not in current]  # type: ignore[arg-type]
        if missing:
            print(f"{len(missing)} procedures are not in the store", file=sys.stderr)
            return 1
        print(f"{store} holds all {len(wanted)} procedures ({documented} documented)")
        return 0
    if args.dry_run:
        print(f"would write {len(wanted)} rows ({documented} with a note) to {store}")
        return 0

    from rebrew.metadata.functions import load_metadata, record_function_rows, remove_field

    record_function_rows(metadata_dir, wanted, updated_by="intake")
    # Rows the worklist no longer holds keep their identity (the store
    # must not shrink) but lose the documented note, which is a claim
    # only the worklist can back: a reviewed extent fold retires the
    # tail's row from the worklist, so its note goes too.
    wanted_keys = {(row["module"], int(row["va"])) for row in wanted}
    cleared = 0
    for (module, va), stored in load_metadata(metadata_dir).items():
        if (module, va) in wanted_keys:
            continue
        note = stored.get("note")
        if isinstance(note, str) and DOCUMENTED_NOTE in note:
            remove_field(metadata_dir, va, "note", module)
            cleared += 1
    print(f"wrote {len(wanted)} rows ({documented} documented) to {store}"
          + (f"; cleared {cleared} stale documented note(s)" if cleared else ""))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
