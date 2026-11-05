# Provenance ledger

Append-only decisions and corrections. Record the date, change, reason, evidence and validation scope. Current metrics belong in [STATUS.md](../STATUS.md); this ledger is not a copied progress table.

## 2026-11-05 — reconstructed source restored

The separate repository initially carried the generator but omitted the generated reconstructed Pascal. The project owner requested the missing source and a decompilation tracker. Commit `19d1022` restored the tracked Pascal/project files, managed Rebrew stores, NE segment facts and cleanup preservation. Source-only and reference-dependent checks were reported separately.

Evidence: [source tree](../src/main), [cleanup test](../tools/test_project.py), [function store](../rebrew-functions.toml) and [status receipt](../status.json).

## 2026-11-05 — documentation and vault organized

The project owner requested a knowledge base like guild-rebrew and an Obsidian vault. The repository root is the vault; notes use ordinary relative links and one owner per topic. Local settings follow guild-rebrew's arrangement and remain ignored. Current source state is linked from the tracker, while historical notebooks are indexed without importing their old headline claims.

Validation: generated unit-map consistency, Markdown destination/anchor checks and idempotent vault-setting tests. Obsidian desktop rendering is not implied by those checks.

## 2026-11-05 — form source and resource build aligned

The project owner identified the missing forms. Readable layouts and an editable structured model now accompany the Pascal source, and the normal resource build consumes that model. The observed embedded `Icon.Data` value and standalone original application icon are omitted. Raw reference extraction remains a separate local research operation.

Evidence: [form model and callback index](../src/main/forms/README.md), [form codec tests](../tools/test_form_sources.py) and the subsequent current build receipt. Resource changes require a fresh measurement; earlier original-icon overlap is not reused.

## 2026-11-05 — address comment syntax tested

The project owner requested address comments using `//` if the old compiler accepted it. The pinned compiler rejected that syntax with Error 36; the brace-comment control compiled. The generator therefore emits `{ ADDRESS: MAIN 0x... }` from managed source bindings, with no identity invented for unbound helpers.

Evidence: [syntax receipt](evidence/comment-syntax.json), [generator](../tools/gen_tree.py), [annotation test](../tools/test_form_sources.py). NE layout metadata also makes zero-based indices and one-based segment numbers explicit.
