# Workflow traps

These are project-specific mistakes to avoid. Tool behavior and durable state belong in [workflow](workflow.md); confidence rules belong in [evidence](evidence.md).

## Source and cleanup

Generated reconstructed Pascal is still source worth tracking. The earlier blanket ignore/clean rule hid and deleted the source snapshots. The current cleanup preserves Pascal, forms, metadata and the knowledge base; [the regression test](../tools/test_project.py) exercises that behavior.

Do not confuse generated authored code with extracted media/resource bytes. The tracked form model is asset-free and used by the resource build; raw reference extraction goes to ignored build output.

## Compiler and native addresses

Test syntax on the actual toolchain: Delphi 1 rejected `//`, so modern Delphi conventions cannot be assumed. One-based NE segment numbers, zero-based analytical indices, file offsets and live selectors are different values.

Far-call segment words can be placeholders. Resolve fixups before naming a callee. A `retf 4` cleanup can describe one pointer, two words or a scalar; read the uses and callers.

## Counting and matching

A non-empty body is not a completed body. Rebrew's source coverage includes stubs. A shape score or masked match is not raw byte identity, and matching-window content overlap includes libraries/data/resources.

Archived headline scores and old assertion strings do not define the current metric. [Measurement](measurement.md) owns the definition and [status](../STATUS.md) owns current numbers.

## Checks and caches

Run the actual project gate and read which tests executed. A `-k` expression matching zero tests does not validate the change. A missing input that causes skips is a reported limitation. Use fresh images and their matching map files; do not compare a stale probe while editing a different source.

Keep metadata writes, source edits and builds serialized. Retire bounded probes after recording their results, and preserve unique research rather than deleting it as a cache.
