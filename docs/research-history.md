# Research history

The former research repository and worker notebooks were preserved privately before the separate repository was created. They are historical records with evolving hypotheses, not current verified state. [STATUS.md](../STATUS.md), managed metadata and source-hashed receipts own current results.

## Historical notebook owners

| Old notebook | Topic now summarized here |
| --- | --- |
| `docs/segment-map.md`, `docs/units.md`, `docs/tree.md` | [Native format](native-format.md), [source layout](source-layout.md), [unit map](units.md) |
| `docs/codegen-patterns.md`, `docs/signature-recovery-codegen.md` | [Codegen patterns](codegen-patterns.md), [calling convention](calling-convention.md) |
| `docs/data-segment.md`, `docs/globals.md` | [Data ownership](data-ownership.md) |
| `docs/object-model.md`, `docs/object-types.md`, `docs/game-state.md` | [Game model](game-model.md) |
| `docs/forms.md`, `docs/recovered-methods.md`, close/empty-frame codegen notes | [Forms](forms.md), [finding index](findings.md) |
| `docs/data-files.md`, `docs/media.md`, `docs/map-layer.md` | [Game model](game-model.md) and current source-unit readers |
| `docs/session-state.md`, `docs/roadmap.md`, `docs/provenance.md` | [Current work](TODO.md), [measurement](measurement.md), [decision ledger](provenance.md) |

Other per-pattern notebooks remain in that history. Address references inside generator evidence comments may name those historical paths. A path in a comment does not mean an up-to-date public notebook exists there.

## Private archive lookup

The retained archive is named `holidaydecomp-private-research-2026-11-05.tar.gz` outside the repository. Its consolidated Git bundle ends at commit `eed417509d7795821a9f605c6da53d37831f546a`; it also preserves deduplicated worker patches and research objects. This is a private recovery artifact, not a dependency of the public checkout.

If you have that archive, recover the Git bundle into a separate research directory, clone it without checking out files, and use `git show` to inspect a notebook at its recorded revision. Never merge that old history into the current repository merely to retrieve notes: it also contains unrelated extracted inputs and old binaries.

A historical claim should be promoted into a focused current note only after its reference, complete extent, compiler inputs and receipt are identified. Preserve a correction rather than silently replacing the old account; [the provenance ledger](provenance.md) records the present decision.
