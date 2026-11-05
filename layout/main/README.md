# Win16 target layout

`segments.json` records NE segment indices, file offsets, extents and flags from the local reference. Native procedure identities use zero-based `segment * 0x10000 + offset`; these are the addresses in `rebrew-functions.toml` and `src/main/function_structure.json`.

The target is `main`, module `MAIN`, format `ne`, architecture `x86_16`, using the `delphi-1.0` toolchain. Compile the complete `src/main/HOLIDAY.DPR`; this target does not use per-function C/COFF linking.

Rebrew 6.20's `build layout` emits PE linker scaffolding and rejects NE input. No fake PE `rebrew-layout.toml` or extracted byte blobs are supplied. `rebrew doctor` therefore warns about the absent PE layout package; the whole-program Delphi build and NE comparison are the applicable checks.
