# Source layout and naming

The tracked tree contains reconstructed program units, form classes and support code. It is not recovered original source with established filenames. [The unit map](units.md) owns the current mapping; [native addressing](native-format.md#native-addresses) owns identity conventions.

## Ownership evidence

- Form class names and published callbacks are observed in RTTI/form streams.
- Segment membership and relocation edges constrain source grouping.
- Unit filenames and many private record/field names are curated reconstruction choices.
- A declaration, a readable name or a matching byte sequence does not prove original ownership.

Program segment zero is split into THINTERG and TDUMMYFO in this reconstruction. Other units generally follow program segments. REACH is synthetic compiler support. Data-only units generated from the reference are local build inputs, not reconstructed game logic.

## Generator and snapshots

Change [gen_tree.py](../tools/gen_tree.py), regenerate, then commit both it and the changed `.PAS`/`.DPR` files. Near declarations, uses order, packed fields and initialization calls can affect code generation. Preserve their measured contracts when reorganizing code.

The generator emits `{ ADDRESS: MAIN 0x... }` above bound implementations. Delphi 1 rejected `//` in the [compiler control](evidence/comment-syntax.json), so address comments use its supported brace syntax. Interface declarations and synthetic helpers do not receive duplicate or invented bindings.

[layouts.json](../src/main/forms/layouts.json) is the form-source owner. DFM files are generated readable snapshots; rebuilding resources uses the same structured model, not a hidden raw reference stream. See [forms](forms.md).

## Rename or move

Inspect callers, target identity, native extent, source ownership and compiler inputs first. Update managed bindings through Rebrew's APIs, regenerate address comments and check every affected source file. A source move earns no new byte verdict.

Do not assign an original type because an offset happens to fit. Keep descriptive names or opaque storage until field width, lifetime and backing ownership are established. [Data ownership](data-ownership.md) owns that review.
