# Build and compare

[Current work](TODO.md) records the validation scope; [measurement](measurement.md) defines what each result establishes.

## Prerequisites

Use Git, Make, Docker and the exact Python/uv/Rebrew versions in [.python-version](../.python-version), [pyproject.toml](../pyproject.toml) and [uv.lock](../uv.lock). The compiler is the `delphi-1.0` profile from [rebrew-project.toml](../rebrew-project.toml), running the stock Delphi 1 compiler in Docker.

```sh
uv sync --frozen
docker info
uv run --frozen rebrew toolchain pull delphi-1.0
uv run --frozen rebrew doctor --json
```

Existing toolchain installations can be reused. Do not run a bare-machine bootstrap over a provisioned checkout. Rebrew's optional analysis-tool warnings do not mean those tools are required for the Delphi build. Its PE layout generator does not support this NE target; see [layout notes](../layout/main/README.md).

## Local inputs

Supply your own German reference at `original/holiday.exe`. The reference SHA-256 and rebuilt SHA-256 for the last measurement are recorded in [status.json](../status.json). Another localization or patched executable is another reference, even if it has the same filename.

The reference is needed to regenerate native declarations and the local data-only units. Original executables, media, compiler files, raw reference extracts and compiled resources stay ignored. The [tracked form model](forms.md) contains no binary artwork.

## Source checks

```sh
make check
make docs-check
uv run --frozen rebrew init --check
```

These run on an asset-free checkout. Native integration checks skip if their reference/build inputs are absent. A green source-only run does not establish native execution or byte equality.

## Whole-program reconstruction

```sh
make generate
make metadata
make build
make compare
make status-measure
make check
```

`make generate` renders the tracked form model and packs local `HOLIDAY.RES`, generates local `POOLS.PAS`, `TABLES.PAS`, `DATAVAL.PAS`, and regenerates the tracked Pascal units. It does not replace edited form source from the reference. `make forms` only refreshes the readable DFM snapshots and callback index.

The compiler switch `-$S-` disables stack checking and is passed by [build.sh](../build.sh). Retain it during comparisons. Compile the complete [HOLIDAY.DPR](../src/main/HOLIDAY.DPR); PE/COFF per-function linking is not the target's build convention.

For serialized generation/build/comparison:

```sh
uv run --frozen python tools/regen_build_compare.py
```

The wrapper treats a differing image as a comparison result; read its output. A successful wrapper exit does not mean the images are equal. `make compare` itself reports a differing image with exit 1.

## Runtime scope

The tree is a research build, not a validated playable game. It contains empty callbacks and synthetic compiler-reach/force-keep calls. For example, DATWIN's initialization calls helpers with placeholder inputs, and REACH contains file and API exercises. These are not established original startup behavior. Review and replace synthetic roots before attempting runtime validation.

[REACH.PAS](../src/main/REACH.PAS) and [DATWIN.PAS](../src/main/DATWIN.PAS) show those mechanisms; [remaining work](TODO.md) owns the follow-up.

## Cleanup

`make clean` removes compiled output, caches, extracted data units and `HOLIDAY.RES`. It preserves reconstructed Pascal, tracked form layouts, metadata, the knowledge base and the last measured status receipt. Source cleanup has a regression check in [test_project.py](../tools/test_project.py).
