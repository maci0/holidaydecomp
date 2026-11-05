# Current work

[STATUS.md](../STATUS.md) is the current measured inventory; do not copy its counts or headline into this page. [Handoff](HANDOFF.md) describes how to resume one bounded task.

## Validation scope

The source restoration was checked with the stock Delphi build and with an asset-free source checkout. Native tests cover selected keyboard/helper bindings, key/hide callback arguments, published field layouts, volume/import behavior and flag-refresh code. They do not establish complete gameplay.

Form-source changes and address annotations must pass the current build and [form tests](../tools/test_form_sources.py). The standard Delphi scaffold is checked separately with `rebrew init --check`. The knowledge-base gate checks local links, heading targets and the generated unit map.

Current numerical results belong in [status.json](../status.json), and per-function verified verdicts in [rebrew-functions.toml](../rebrew-functions.toml). A stored native comparison may be older than a documentation-only edit; its source/input fingerprint states the scope.

## Priorities

1. Separate synthetic compiler-reach/force-keep startup from real program initialization before treating a build as runnable.
2. Recover empty and unbound routines in the [unit map](units.md); review existing non-empty candidates before claiming them complete.
3. Resolve callee identities, stack contracts and near/far pointer distinctions for the [blocked codegen families](codegen-walls.md).
4. Establish global storage ownership and alias extents, then migrate reviewed identities into the [data registry](../rebrew-data.toml).
5. Reproduce selected complete bodies and operands through the matching workflow before promoting EXACT/RELOC verdicts.
6. Validate actual UI and gameplay behavior with appropriate original inputs. Layout/handler recovery is only one prerequisite.

## Definitions of completion

A source body existing, a form decoding, the compiler succeeding, matching windows, per-function byte equality and whole-game behavior are different milestones. [Evidence rules](evidence.md) and [measurement](measurement.md) define them. No percentage from one milestone substitutes for another.
