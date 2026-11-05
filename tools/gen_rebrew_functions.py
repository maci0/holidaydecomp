#!/usr/bin/env python3
"""Bind the native inventory to reconstructed Pascal through Rebrew's managed API."""
from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path
import re

import gen_tree
from rebrew.config import load_config
from rebrew.metadata.functions import load_metadata, record_function_rows

ROOT = Path(__file__).resolve().parent.parent


def layout() -> dict:
    from rebrew.formats.ne_analysis import NeImage
    image = NeImage(gen_tree.ORIGINAL)
    return {
        "target": "main", "format": "ne",
        "reference_sha256": hashlib.sha256(image.data).hexdigest(),
        "address_encoding": "zero-based segment * 0x10000 + offset",
        "segments": [
            {"index": s.index, "file_offset": s.file_offset, "bytes": s.length,
             "min_allocation": s.min_allocation, "flags": s.flags,
             "code": s.is_code, "on_disk": s.on_disk}
            for s in image.segment_records
        ],
    }


def body_state(body: str) -> str:
    text = re.sub(r"\{.*?\}|\(\*.*?\*\)|//[^\n]*", "", body, flags=re.S)
    return "empty stub" if re.search(r"\bbegin\s*end\s*;\s*$", text, re.I) else "candidate"


def rows() -> list[dict]:
    inventory = json.loads((ROOT / "src/main/function_structure.json").read_text())
    current = load_metadata(ROOT)
    bindings = {}
    for segment, unit, classes, _ in gen_tree.generated_units():
        file = f"src/main/{unit}.PAS"
        for declaration, body, _ in gen_tree._RECOVERED_FREE_BODIES.get(segment, []):
            match = re.search(r"\b(Proc(\d+)_([0-9A-F]+))\b", declaration, re.I)
            if match and int(match[2]) == segment:
                va = segment * 0x10000 + int(match[3], 16)
                bindings.setdefault(va, (file, match[1], body_state(body)))
    if gen_tree.ORIGINAL.is_file():
        import decompile
        image = decompile.Image(gen_tree.ORIGINAL)
        for segment, unit, classes, _ in gen_tree.generated_units():
            for owner in classes:
                for method, offset in decompile.published_methods(image.segments[segment], owner):
                    body = gen_tree._RECOVERED_METHOD_BODIES.get((owner, method), "")
                    state = "candidate" if body.strip() else "empty stub"
                    bindings[segment * 0x10000 + offset] = (
                        f"src/main/{unit}.PAS", f"{owner}.{method}", state,
                    )
    else:
        # RTTI addresses were imported with the local reference; preserve them on asset-free clones.
        for (module, va), stored in current.items():
            name = stored.get("name", "")
            if module == "MAIN" and "." in name and stored.get("file"):
                state = "candidate" if stored.get("note") == "Source body: candidate; not a byte-match verdict." else "empty stub"
                bindings[va] = (stored["file"], name, state)
    result = []
    for native in inventory:
        va = int(native["va"])
        identity = {"kind": "FUNCTION", "name": native["name"]}
        fields = {"size": int(native["size"]), "note": "No reconstructed definition bound."}
        if va in bindings:
            file, symbol, state = bindings[va]
            identity.update(file=file, name=symbol, symbol=symbol)
            fields["note"] = f"Source body: {state}; not a byte-match verdict."
        result.append({"module": "MAIN", "va": va, "identity": identity, "fields": fields})
    return result


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--check", action="store_true")
    parser.add_argument("--dry-run", action="store_true")
    args = parser.parse_args()
    directory = load_config(root=ROOT).metadata_dir
    wanted = rows()
    if args.check:
        current = load_metadata(directory)
        for row in wanted:
            stored = current.get((row["module"], row["va"]), {})
            expected = row["identity"] | row["fields"]
            if any(stored.get(key) != value for key, value in expected.items()):
                print(f"Rebrew metadata is stale at {row['va']:#x}; run make metadata")
                return 1
        if gen_tree.ORIGINAL.exists():
            path = ROOT / "layout/main/segments.json"
            if not path.exists() or json.loads(path.read_text()) != layout():
                print("NE segment metadata is stale; run make metadata")
                return 1
        print(f"Rebrew metadata current: {len(wanted)} native procedures")
    elif args.dry_run:
        print(f"Would record {len(wanted)} native procedures")
    else:
        record_function_rows(directory, wanted, overwrite_name=True, updated_by="intake")
        if gen_tree.ORIGINAL.exists():
            path = ROOT / "layout/main/segments.json"
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text(json.dumps(layout(), indent=2) + "\n")
        print(f"Recorded {len(wanted)} native procedures; no match statuses assigned")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
