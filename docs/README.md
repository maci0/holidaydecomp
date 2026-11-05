# Knowledge base

Each topic has one owner. Link to it instead of copying its rules, measurements or findings. This follows guild-rebrew's documentation structure, adapted to this Win16 target.

## Start here

| Need | Canonical page |
| --- | --- |
| Project and checked-in source | [Repository README](../README.md) |
| Current measured progress | [Decompilation status](../STATUS.md) |
| Validation scope and priorities | [Current work](TODO.md) |
| Build and compare | [Build guide](build.md) |
| Resume an investigation | [Handoff](HANDOFF.md) |
| Implementation rules | [AGENTS.md](../AGENTS.md) |

## Workflow

| Topic | Canonical page |
| --- | --- |
| Open the repository as a linked notebook | [Obsidian vault](obsidian.md) |
| Claims, confidence and receipts | [Evidence rules](evidence.md) |
| Compilation, matching and metrics | [Measurement](measurement.md) |
| Tools and managed metadata | [Rebrew workflow](workflow.md) |
| Decisions and corrections | [Provenance ledger](provenance.md) |
| Repeated process mistakes | [Workflow traps](workflow-traps.md) |
| Historical notebooks | [Research history](research-history.md) |

## Technical reference

| Question | Canonical page |
| --- | --- |
| What is the target and what does an address mean? | [Native format and addresses](native-format.md) |
| Which unit owns the code? | [Source unit map](units.md) |
| Which ownership and naming claims are inferred? | [Source layout](source-layout.md) |
| Where are the form layouts and event addresses? | [Forms](forms.md) |
| How do Delphi 1 stack slots and calls work? | [Calling convention](calling-convention.md) |
| Which source spellings affect code generation? | [Codegen patterns](codegen-patterns.md) |
| What has already failed or remains blocked? | [Codegen walls](codegen-walls.md) |
| What allocates a global or record? | [Data ownership](data-ownership.md) |
| What game concepts are understood? | [Game model](game-model.md) |
| Which concrete findings can be followed into source? | [Finding index](findings.md) |

## Obsidian and maintenance

Open the repository root as a vault and start here. Notes live in `docs/`, attachments in `docs/assets/`; ordinary relative Markdown links work in both Obsidian and GitHub. No community plugins are required. Personal `.obsidian/` settings remain local.

Run `make vault` once to prepare the local settings. Run `make docs` after changes to the unit map and `make docs-check` to check generated pages, local links and anchors. [Status](../STATUS.md), [function metadata](../rebrew-functions.toml), [data metadata](../rebrew-data.toml) and [form sources](../src/main/forms/README.md) remain with their owners.
