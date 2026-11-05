#!/usr/bin/env python3
"""Render and compile tracked form layouts using Rebrew's Delphi form codec."""
from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path
import re

from rebrew.formats import dfm
from rebrew.metadata.functions import load_metadata

import gen_tree
from dfm_pack import record

ROOT = Path(__file__).resolve().parent.parent
DIRECTORY = ROOT / "src/main/forms"
MODEL = DIRECTORY / "layouts.json"


def unit_for_form(cls: str) -> str:
    return next(name for _, name, classes, _ in gen_tree.generated_units() if cls in classes)


def import_node(node: dfm.Component, omitted: list[dict], form: str) -> dict:
    properties = []
    for name, value in node.props:
        if isinstance(value, dfm.Binary):
            omitted.append({"form": form, "component": node.name, "property": name, "bytes": len(value.data)})
            continue
        properties.append({"name": name, "wire_type": value.type_byte,
                           "value": value.items if isinstance(value, dfm.SetOfIdentifiers) else value.value})
    return {"class": node.cls, "name": node.name, "properties": properties,
            "children": [import_node(child, omitted, form) for child in node.kids]}


def component(row: dict) -> dfm.Component:
    for key in ("class", "name"):
        if not re.fullmatch(r"[A-Za-z_]\w*", row[key]):
            raise ValueError(f"Invalid component {key}: {row[key]!r}")
    constructors = {2: dfm.Int8, 3: dfm.Int16, 4: dfm.Int32, 6: dfm.Str,
                    7: dfm.Identifier, 11: dfm.SetOfIdentifiers}
    properties = []
    for prop in row["properties"]:
        kind, value = prop["wire_type"], prop["value"]
        if kind in (8, 9):
            if type(value) is not bool or value != (kind == 9):
                raise ValueError("Boolean form value disagrees with its wire type")
            decoded = dfm.Bool(value, kind)
        elif kind in constructors:
            decoded = constructors[kind](value)
        else:
            raise ValueError(f"Unsupported form wire type {kind}; binary assets are not form source")
        properties.append((prop["name"], decoded))
    result = dfm.Component(row["class"], row["name"], properties,
                           [component(child) for child in row["children"]])
    dfm.encode(result)  # validate Delphi widths, identifiers and short strings before writing resources
    return result


def forms_from_model(data: dict) -> list[dfm.Component]:
    if data.get("format") != 1:
        raise ValueError("Unsupported form source format")
    forms = [component(row) for row in data["forms"]]
    classes = [form.cls for form in forms]
    if len(classes) != len(set(classes)) or set(classes) != set(gen_tree.FORM_ORDER):
        raise ValueError("Form sources must define every known form class exactly once")
    return forms


def load_forms(path: Path = MODEL) -> list[dfm.Component]:
    return forms_from_model(json.loads(path.read_text()))


def render_index(forms: list[dfm.Component]) -> str:
    metadata = load_metadata(ROOT)
    bindings = {row.get("name", "").casefold(): (va, row.get("file"))
                for (module, va), row in metadata.items() if module == "MAIN"}
    lines = ["# Form sources", "",
             "`layouts.json` is the editable form model; the `.DFM` files are generated text snapshots.",
             "Run `make forms` after editing the model. `make generate` compiles these layouts into local `HOLIDAY.RES`.",
             "The embedded main-window icon was omitted. No artwork or raw binary properties are stored here.",
             "Layouts describe component geometry, properties and event wiring; they do not implement the callbacks.", "",
             "See [form reconstruction](../../../docs/forms.md) for the build and evidence boundaries.", "",
             "| Form | Pascal unit | Components | Events |", "| --- | --- | ---: | ---: |"]
    for root in forms:
        unit = unit_for_form(root.cls)
        lines.append(f"| [{root.cls}]({root.cls}.DFM) | [{unit}.PAS](../{unit}.PAS) | "
                     f"{len(list(root.walk())) - 1} | {sum(len(node.events()) for node in root.walk())} |")
    for root in forms:
        lines += ["", f"## {root.cls}", "", "| Component | Event | Handler | Native address |",
                  "| --- | --- | --- | --- |"]
        for node in root.walk():
            for event, method in node.events():
                va, file = bindings.get(f"{root.cls}.{method}".casefold(), (None, None))
                address = f"`{va >> 16}:0x{va & 0xffff:04X}` / `MAIN.0x{va:08x}`" if va is not None else "not bound"
                handler = f"[{method}](../{Path(file).name})" if file else f"`{method}`"
                lines.append(f"| `{node.name}` | `{event}` | {handler} | {address} |")
    return "\n".join(lines) + "\n"


def snapshots(forms: list[dfm.Component]) -> dict[Path, str]:
    return {**{DIRECTORY / f"{form.cls}.DFM": dfm.render(form) for form in forms},
            DIRECTORY / "README.md": render_index(forms)}


def resource(forms: list[dfm.Component]) -> bytes:
    return b"".join(record(form.cls.upper(), b"TPF0" + dfm.encode(form)) for form in forms)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--check", action="store_true")
    parser.add_argument("--resource", type=Path, help="write local compiled form resources")
    parser.add_argument("--import-reference", action="store_true", help="explicitly import layouts, omitting binary properties")
    parser.add_argument("--force", action="store_true", help="replace an existing model during import")
    args = parser.parse_args()
    if args.import_reference:
        if args.check or args.resource:
            parser.error("--import-reference excludes --check and --resource")
        if MODEL.exists() and not args.force:
            parser.error("form model already exists; --force is required to replace source edits")
        data = (ROOT / "original/holiday.exe").read_bytes()
        omitted = []
        rows = [import_node(root, omitted, root.cls) for _, root, _ in dfm.parse_forms(data)]
        value = {"format": 1, "reference_sha256": hashlib.sha256(data).hexdigest(),
                 "omitted_binary_properties": omitted, "forms": rows}
        forms_from_model(value)
        DIRECTORY.mkdir(parents=True, exist_ok=True)
        MODEL.write_text(json.dumps(value, indent=2) + "\n")
    forms = load_forms()
    files = snapshots(forms)
    if args.check:
        stale = [p.name for p, text in files.items() if not p.exists() or p.read_text() != text]
        if stale:
            print("Stale form sources: " + ", ".join(stale) + "; run make forms")
            return 1
        print(f"Form sources current: {len(forms)} asset-free layouts")
    else:
        for path, text in files.items():
            path.write_text(text)
        print(f"Rendered {len(forms)} tracked form layouts")
    if args.resource:
        if args.check:
            parser.error("--check excludes --resource")
        args.resource.parent.mkdir(parents=True, exist_ok=True)
        args.resource.write_bytes(resource(forms))
        print(f"Packed {len(forms)} form resources into {args.resource}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
