# Evidence rules

State the claim, its inputs and its scope. A label is a reading aid, not a substitute for a receipt. [Measurement](measurement.md) owns comparison terminology; [managed metadata](workflow.md) owns verification state.

## Confidence vocabulary

| Label | Meaning |
| --- | --- |
| Observation | Directly read from a named artifact or source revision. |
| Inference | A proposed meaning or ownership consistent with observations. |
| Candidate | Source exists; complete semantics or native byte agreement is not established. |
| Reproduced | The named check was rerun with recorded inputs and produced the stated result. |
| Rejected | A bounded hypothesis failed its stated check; this is not a proof that every spelling fails. |
| Unresolved | Required evidence or a unique interpretation is still missing. |

Native offsets, field widths and form wiring can be observations while names and original source ownership remain inferred. Never collapse those into one claim.

## A useful receipt

Record target/reference hash, native identity and extent, source revision/fingerprint, toolchain and switches, exact command, result and remaining differences. For a masked comparison, identify every excluded operand and the evidence for its binding. For a semantic claim, state the modeled inputs, bounds and unmodeled calls.

The [comment-syntax receipt](evidence/comment-syntax.json) is a small example with a failing syntax control and a successful compatible control. The [status receipt](../status.json) records current build fingerprints and overlap; the [native tests](../tools/test_native_recovery.py) encode selected independently checked contracts.

## Historical evidence

An old notebook entry is a claim made at that revision. A private probe receipt that is no longer available cannot be described as freshly reproduced. Preserve corrections as new entries in [provenance](provenance.md) and retain the original wording in the private history if needed.

Do not transplant archived overlap totals or EXACT labels into today's [function store](../rebrew-functions.toml). Current verified state comes from the corresponding Rebrew matching/verification workflow.
