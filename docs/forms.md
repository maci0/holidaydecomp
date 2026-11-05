# Form reconstruction

The [form source index](../src/main/forms/README.md) is the canonical list of layouts, Pascal owners, event handlers and bound native callback addresses.

## What is tracked

`src/main/forms/layouts.json` is the editable model. It preserves component order, Delphi property wire types, geometry, short labels, font settings and event names. The `.DFM` files are generated readable Delphi text. Rebrew's codec encodes the same model into the local `HOLIDAY.RES` used by the build.

All known form classes must occur exactly once. The model omits binary properties: the observed main-window `Icon.Data` payload was removed. The resource build also does not copy the original standalone application icon. External game bitmaps, movies and sound files are not part of these layouts.

## Edit and rebuild

```sh
make forms
make generate
make build
```

Edit the JSON model first; `make forms` renders DFM snapshots and the callback index. Do not edit only a snapshot and assume it controls the next resource build. The structured model retains wire types which the existing Rebrew decoder/encoder understands; it avoids inventing an untested text-DFM parser.

Changes to the component roster or handler names also require review of the Pascal generator and native class layout. The callback check rejects a handler that has no implementation; it does not infer a new private field or original allocation.

The one-time `tools/gen_forms.py --import-reference` command imports layout properties while omitting binary values. Replacing an existing model requires explicit `--force`; normal generation never imports over source edits.

[Legacy dfm_extract.py](../tools/dfm_extract.py) writes raw reference views under ignored `build/forms-reference/`. [Legacy dfm_pack.py](../tools/dfm_pack.py) can reproduce raw reference resources for local research. Neither is the normal tracked-form build path.

## What a form does not establish

A decoded or round-tripped form establishes structure and wiring, not the event body. A listed callback can still be an empty stub. Correct geometry also does not prove runtime class layout, original private fields or complete rendering.

The form index derives callback addresses from managed identities. Addresses annotate the Pascal implementations with compatible brace comments; they are not inserted into DFM syntax. [Form tests](../tools/test_form_sources.py) check round trips, absence of binary payloads, snapshot freshness and callback definitions.

## Runtime appearance

The omission of original icons is deliberate and changes resource bytes. The current build must be remeasured; old raw-resource overlap totals do not apply. Layouts can be inspected without the game media, but a visually faithful, functioning UI still requires reconstructed behavior and appropriate local inputs.
