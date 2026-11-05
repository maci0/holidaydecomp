#!/usr/bin/env python3
"""gen_functions_json.py — write the function inventory rebrew expects.

`rebrew recommend` refuses to advise this project: *"No function inventory (needed
here) — run `rebrew intake` first"*.  Intake would run a discoverer over the binary and
write `src/<target>/function_structure.json`, but a Delphi 1 NE image is not what those
discoverers are built for — this project already has its own inventory, the 1306
procedures `tools/decompile.py` finds from the image's prologue table, and it is the
one `docs/worklist.csv` is derived from.

So the inventory is translated rather than rediscovered:

* **VA model.** Rebrew linearises a 16-bit segment and offset as `segment * 0x10000 +
  offset`.  The two rows already in `src/rebrew-functions.toml` confirm it: segment 7,
  offset `0x3AC` is stored as `MAIN.0x000703ac`.
* **Names.** `func_<va:08x>` — the same shape the existing rows use
  (`func_000703ac`), because the original's identifiers are not in the image and a
  name invented per procedure would read as recovered source.
* **Size.** The prologue table's span to the next procedure, the same number
  `docs/worklist.csv` reports.

Only the program segments (0-24) are inventoried: segments 25-33 are the linked VCL
library and segment 34 is data, so a "function" there is not this project's reversing
target.

**Reviewed merges.** `rebrew binary repair-extents --merge <head>=<tail>` folds a
false boundary into its neighbour and writes `extent_history` into the head row;
the next regeneration would discard that edit because every size above comes from
the prologue table. The applied extent repairs live in
`src/main/function_merges.toml` instead: each run rebuilds the same rows (head
size, folded tail removed, one history event carrying this image's sha256), so
regeneration cannot silently undo a reviewed extent. Two block kinds: `[[merge]]`
for a fold (head, tail, old and new sizes) and `[[span]]` for a pure
end-correction (va, old and new size, the `repair-extents 0xVA=SIZE` form).
After applying either, append its block there with the recording time and a
reason naming the command and its receipt.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import sys
import tomllib
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
if str(ROOT / "tools") not in sys.path:
    sys.path.insert(0, str(ROOT / "tools"))

import decompile  # noqa: E402

TARGET = ROOT / "src" / "main"
OUT = TARGET / "function_structure.json"
PROGRAM_SEGMENTS = range(25)
MERGE_STORE = TARGET / "function_merges.toml"


def va(segment: int, offset: int) -> int:
    """Rebrew's linearisation of (segment, offset) — confirmed against the store."""
    return segment * 0x10000 + offset


def apply_merges(rows: list[dict[str, object]]) -> list[dict[str, object]]:
    """Fold every recorded merge into the discovered rows, in store order.

    The checks mirror `repair-extents` itself: head and tail must both be
    discovered, the head's size must be the recorded old one, the head must end
    where the tail starts, and the tail must end at the recorded new size. A
    discovery shift therefore fails loudly instead of replaying an extent
    against moved bytes.
    """
    if not MERGE_STORE.is_file():
        raise SystemExit(f"{MERGE_STORE} is missing; reviewed extents cannot be replayed")
    store = tomllib.loads(MERGE_STORE.read_text(encoding="utf-8"))
    by_va = {int(row["va"]): row for row in rows}
    binary_hash = hashlib.sha256(decompile.ORIGINAL.read_bytes()).hexdigest()
    for entry in store.get("merge", []):
        head_va = int(str(entry["head"]), 16)
        tail_va = int(str(entry["tail"]), 16)
        old_size = int(entry["old_size"])
        new_size = int(entry["new_size"])
        if head_va not in by_va or tail_va not in by_va:
            raise SystemExit(
                f"merge {entry['head']}={entry['tail']}: "
                f"{[hex(va) for va in (head_va, tail_va) if va not in by_va]} not discovered"
            )
        head = by_va[head_va]
        tail = by_va[tail_va]
        head_size = int(head["size"])
        tail_size = int(tail["size"])
        expected = tail_va + tail_size - head_va
        if head_size != old_size or head_va + head_size != tail_va or new_size != expected:
            raise SystemExit(
                f"merge {entry['head']}={entry['tail']}: discovery reads "
                f"{head_size} ending {head_va + head_size:#x} then {tail_size} ending "
                f"{tail_va + tail_size:#x}, so the fold is {expected} bytes; "
                f"the store records old {old_size} and new {new_size}"
            )
        event = {
            "old_size": old_size,
            "new_size": new_size,
            "reason": str(entry["reason"]),
            "binary_hash": binary_hash,
            "changed_at": str(entry["changed_at"]),
            "merged": {
                "va": tail_va,
                "size": tail_size,
                "name": str(tail.get("name") or ""),
                "extent_history": [],
            },
        }
        head["extent_history"] = [*head.get("extent_history", []), event]
        head["size"] = new_size
        by_va.pop(tail_va)
        rows.remove(tail)
    return rows


def apply_spans(rows: list[dict[str, object]]) -> list[dict[str, object]]:
    """Apply every recorded end-correction: one row's own extent, no tail.

    The checks are the drift guard, same as a merge's head check: the row
    must exist and read the recorded old size. The event mirrors
    `repair-extents`'s update-event shape, with no `merged` key.
    """
    if not MERGE_STORE.is_file():
        raise SystemExit(f"{MERGE_STORE} is missing; reviewed extents cannot be replayed")
    store = tomllib.loads(MERGE_STORE.read_text(encoding="utf-8"))
    binary_hash = hashlib.sha256(decompile.ORIGINAL.read_bytes()).hexdigest()
    by_va = {int(row["va"]): row for row in rows}
    for entry in store.get("span", []):
        va = int(str(entry["va"]), 16)
        old_size = int(entry["old_size"])
        new_size = int(entry["new_size"])
        row = by_va.get(va)
        if row is None:
            raise SystemExit(f"span {entry['va']}: no discovered row for it")
        current = int(row["size"])
        if current != old_size:
            raise SystemExit(
                f"span {entry['va']}: discovery reads {current}, the store records {old_size}"
            )
        row["size"] = new_size
        event = {
            "old_size": old_size,
            "new_size": new_size,
            "reason": str(entry["reason"]),
            "binary_hash": binary_hash,
            "changed_at": str(entry["changed_at"]),
        }
        row["extent_history"] = [*row.get("extent_history", []), event]
    return rows


def inventory() -> list[dict[str, object]]:
    """`[{va, size, name}]` for every procedure in the program segments."""
    image = decompile.Image(decompile.ORIGINAL)
    classes = decompile.form_classes_by_segment(image)
    rows: list[dict[str, object]] = []
    for segment in PROGRAM_SEGMENTS:
        for function in decompile.discover(image.segments[segment], classes.get(segment, [])):
            rows.append({
                "va": va(segment, function.offset),
                "size": function.size,
                "name": f"func_{va(segment, function.offset):08x}",
            })
    rows = apply_merges(rows)
    rows = apply_spans(rows)
    rows.sort(key=lambda row: int(row["va"]))
    return rows


def render() -> str:
    return json.dumps(inventory(), indent=2) + "\n"


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--check", action="store_true",
                        help="fail when the inventory on disk is stale")
    args = parser.parse_args()

    text = render()
    if args.check:
        if not OUT.is_file() or OUT.read_text(encoding="utf-8") != text:
            print(f"{OUT} is stale; run python3 tools/gen_functions_json.py", file=sys.stderr)
            return 1
        print(f"{OUT} is current ({len(inventory())} functions)")
        return 0
    OUT.write_text(text, encoding="utf-8")
    print(f"wrote {OUT}: {len(inventory())} functions")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
