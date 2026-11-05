<p align="center">
  <img src="assets/logo.png" alt="holidaydecomp" width="560">
</p>

# holidaydecomp

Reconstructed Delphi 1 / Win16 source and analysis tools for **Holiday Island**.
The Pascal units and project file are checked into [src/main](src/main).
The reconstruction is incomplete; many routines are empty stubs or unverified candidates.

**[Knowledge base](docs/README.md)** · [Decompilation status](STATUS.md) · [Form sources](src/main/forms/README.md)

Original game executables, media, extracted strings/data, form resources and compiler files are not included. Supply your own local inputs to build.

## Project layout

- `src/main/HOLIDAY.DPR` and `src/main/*.PAS`: reconstructed program, code units and compiler-reach support.
- `src/main/forms/`: editable asset-free form model, generated DFM layouts and native callback index.
- `docs/`: linked knowledge base; open the repository root as an [Obsidian vault](docs/obsidian.md).
- `src/main/function_structure.json`: native procedure inventory.
- `rebrew-project.toml`: target `main`, module `MAIN`, NE / x86_16, Delphi 1 toolchain.
- `rebrew-functions.toml`: native addresses, sizes, source bindings and notes, maintained through Rebrew's managed API.
- `rebrew-data.toml`: data metadata registry; reviewed global ownership still needs migration.
- `layout/main`: NE segment metadata and the whole-program build convention.
- `STATUS.md` / `status.json`: candidates, empty stubs, unbound procedures and the latest source-hashed build measurement.
- `original/`: your local reference input, ignored except for its README.
- `tools/`: source generators, native analysis and checks.

## Setup and checks

Use Python **3.15.2**, uv **0.13.6** and the pinned Rebrew **6.20.0**.
This project is independent of the Python/web clones in [openholiday](https://github.com/maci0/openholiday).

```sh
uv sync --frozen
make check
make vault
uv run --frozen rebrew status --json
```

Source checks run without the game. Native integration checks skip when the reference or rebuilt executable is absent. Rebrew's source coverage includes empty stubs and is not a completion percentage.

## Build and update progress

Place your reference at `original/holiday.exe` and configure the stock Delphi 1 toolchain for Rebrew.

```sh
make generate       # regenerate code, compile tracked forms and derive local data
make metadata       # refresh native-to-source bindings through Rebrew
make build          # compile the complete Delphi project with -$S-
make compare        # report NE file agreement and content overlap
make status-measure # save the current build measurement and refresh the tracker
make check
```

`tools/gen_tree.py` owns reconstructed code generation. Change it, regenerate, and commit both the generator and changed Pascal units. `tools/patch_gen_tree.py` supports anchored generator edits. `tools/regen_build_compare.py` serializes generation/build/comparison under the project lock.

The tracked form model excludes binary artwork. `make forms` refreshes its readable DFM snapshots; the resource build encodes that same model. Extracted `DATAVAL.PAS`, `POOLS.PAS`, `TABLES.PAS`, raw reference form streams, `HOLIDAY.RES` and compiled executables stay local and ignored. `make clean` preserves reconstructed code, tracked forms, documentation, metadata and the status tracker.

The generator adds `{ ADDRESS: MAIN 0x... }` comments from managed bindings. The pinned Delphi 1 compiler rejects `//`; the [compiler control](docs/evidence/comment-syntax.json) records the compatible syntax.

The current build contains synthetic reach/initialization calls and is not a validated playable game. See the [build and runtime scope](docs/build.md#runtime-scope), [evidence rules](docs/evidence.md) and [current work](docs/TODO.md).

`make status` refreshes source counts without building. A stored measurement is retained only while its source/input fingerprint matches; it is content overlap, including libraries/data/resources, **not a percentage decompiled**. Per-function EXACT/RELOC verdicts remain unset until verified through the matching workflow.

See [layout/main](layout/main) for NE address conventions and the limitation of Rebrew's PE layout scaffolder.

## Release

Current release: **v0.2.0**. See [CHANGELOG.md](CHANGELOG.md).
Full gameplay parity remains unverified. There is no production service to deploy.
