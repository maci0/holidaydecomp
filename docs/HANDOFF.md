# Investigation handoff

Start with [current status](../STATUS.md), [current work](TODO.md) and the [unit map](units.md). The previous parallel worker campaign is stopped; its notes are historical evidence, not active assignments.

## Pick one native identity

Choose the metadata row and inspect the bound Pascal definition. Use its `{ ADDRESS: MAIN 0x... }` comment and the [address convention](native-format.md#native-addresses). Confirm the source is a candidate or an empty scaffold, and check whether it is game code, a synthetic helper or library support.

Read the relevant form callback entry or subsystem note. Search the [finding index](findings.md) and [negative results](codegen-walls.md) before repeating probes. Existing names and a matching offset alone do not prove a callee or original unit.

## Minimum handoff record

Use the [finding template](templates/finding.md). Record:

- Native identity, complete reviewed extent and reference hash.
- Source file/symbol, current declaration and what is still unknown.
- Exact compiler inputs and the bounded question being tested.
- The result, its scope and a rejecting control if operand identity is claimed.
- The next concrete action and any missing input.

Do not overwrite generator-owned Pascal by hand. Change [gen_tree.py](../tools/gen_tree.py), regenerate and commit the changed snapshots. Edit form structure in [layouts.json](../src/main/forms/layouts.json), then render it with `make forms`.

## Finish the bounded task

Refresh managed metadata through Rebrew's writers, run relevant tests, build/measure when the claim needs native evidence, and refresh [status](../STATUS.md). Add a dated decision to [provenance](provenance.md). Report failed or skipped checks without converting them into a success claim.

Private historical notebooks can be recovered as described in [research history](research-history.md). A missing receipt is a limitation, not permission to infer its result.
