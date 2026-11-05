# What a measurement proves

Choose the artifact that decides the claim. Keep source/input hashes and exact commands with the result. [STATUS.md](../STATUS.md) owns the current numbers; [evidence rules](evidence.md) own confidence labels.

| Check | Establishes | Does not establish |
| --- | --- | --- |
| Source/metadata check | Files, declarations, bindings and generated snapshots agree | Native execution or correct semantics |
| Form codec round trip | The modeled form stream re-encodes consistently | Callback recovery or original artwork |
| Successful Delphi build | The complete source compiles with the selected inputs | A runnable complete game or native byte equality |
| Complete masked body comparison | Agreement outside the explicitly excluded operands | Correct unresolved operands or raw equality |
| Recorded EXACT | The verified byte scope agrees under that workflow | Every other function or the whole image agrees |
| Whole-file byte equality | The entire compared files agree | Original source spelling or ownership |
| Matching-window union | Reference bytes covered by windows found anywhere in the rebuild | Placement, semantic recovery or percent decompiled |

## Current overlap metric

[gen_status.py](../tools/gen_status.py) uses Rebrew's `ne_analysis.comparison_content` with 16-byte windows. Each reference byte covered by any matching window is counted once. The comparison searches the whole rebuilt image, so matches may be at different offsets or in library/data/resource regions.

The receipt also records same-offset bytes and complete-file equality. These are separate from content overlap. A source candidate is not an EXACT verdict, and Rebrew source coverage includes empty stubs.

## Freshness

`make status-measure` reads the local original and rebuilt images and records their hashes plus the source/build-input fingerprint. `make status` retains that receipt only if the fingerprint still agrees. Native inputs are absent in an asset-free clone, so it can check the recorded source fingerprint and document consistency, not rerun the binary measurement.

Resource-source changes, including removal of the original icon, legitimately change overlap. Never restore excluded image bytes or alter comparison masks just to recover an old headline.

## Native scope

Review the complete function extent, including tails, switch data and cleanup paths. A prefix or first-return scan can miss later blocks. Raw file bytes and mapped zero-filled tails are distinct scopes; see [codegen patterns](codegen-patterns.md#physical-and-mapped-tails).

Per-segment content overlap uses zero-based reference segments in the status receipt. It does not assert that the rebuild's segment at the same index has the same contents. A comparison wrapper returning successfully after reporting differences is not file equality.
