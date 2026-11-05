<p align="center">
  <img src="assets/logo.png" alt="holidaydecomp" width="560">
</p>

# holidaydecomp

Experimental source reconstruction and analysis tools for the Windows 3.1
version of **Holiday Island**. This repository contains newly written tooling,
Pascal generation logic, an authored library-reach template and technical inventories. It is not a playable remake
or a complete, byte-identical reconstruction.

**No original game executable, artwork, audio, extracted text/data, form
resources or compiler binaries are distributed here.** The project logo is
original artwork. The repository starts with a fresh source-only history.
See [publication scope](PUBLICATION.md).

## Setup

The tools use Python **3.15.2**, uv **0.13.6** and the pinned Rebrew **6.20.0**
dependency. These are independent of the Python/web game clones in
[`openholiday`](https://github.com/maci0/openholiday).

```sh
uv sync --frozen
make check
```

Source tests run without the game. Native integration checks skip when the local
reference or rebuilt executable is absent; passing source tests does not prove
native behavior or binary equality.

## Local reconstruction

Supply your own reference at `original/holiday.exe` and configure the stock
Delphi 1 toolchain for Rebrew. Those inputs remain local and ignored by Git.

```sh
make generate       # derive local forms, data units and Pascal sources
make build          # compile with stock Delphi 1 and stack checking disabled
make compare        # report complete-file agreement and content overlap
```

Generated forms, data, resources, source copies and executables are local build
outputs. They must not be committed. `make clean` removes generated output and
project caches while retaining the local reference and toolchain.

`tools/gen_tree.py` is the source of truth for reconstruction changes.
`tools/patch_gen_tree.py` applies anchored proposals; generated Pascal files are
not edited by hand. `tools/regen_build_compare.py` serializes generation, build
and comparison under the project lock.

The recovered logic covers selected rendering, scrolling, overview, form,
callback, keyboard and audio paths. Many game routines remain stubs. Private
names, field views and argument types remain proposals wherever the native
evidence does not establish a unique original spelling. Three inline-assembly
experiments are excluded from this high-level source export.

## Release

Current release: **v0.1.1**. See [CHANGELOG.md](CHANGELOG.md).
This is a research toolkit; there is no production service to deploy.
