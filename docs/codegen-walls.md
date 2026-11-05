# Negative results and unresolved codegen

A failed spelling rejects that spelling under those inputs. It does not prove the compiler can never express the native shape. [Research history](research-history.md) retains the old notebooks; [handoff](HANDOFF.md) describes how to resume a bounded probe.

| Family | Observed obstacle | Required next evidence |
| --- | --- | --- |
| Word-sized dispatch receiver | Native `mov di,es:[di+9]` followed by an indirect call differs from a far-pointer `les` spelling | Exact receiver/layout and source type without inventing an allocation |
| Borrowed stack destination | Older probes for `2:0x2225`, `6:0x0263`, `17:0x3A19` could not preserve both borrowed argument use and cleanup | Complete caller chain and stack ownership; receipts are historical |
| Pointer forwarding | Word pushes and `les`/register pushes use the same four-byte value but differ in code | A tested parameter/source view with the same ABI |
| Frame temporaries | Boolean/result/local choices produce different `enter` sizes or spill offsets | A complete local/result-slot map and one controlled declaration change |
| Empty callback frame | An empty event body can lose the native reserved local | Retain the known local and prove the compiled callback extent |
| Symbol retention | A correct-looking body disappears when unreachable | A documented reachability control, kept distinct from native roots |

The old signature notebook explains why cleanup-size arity guesses and far-pointer guesses failed. Its current lessons are in [calling convention](calling-convention.md); its entire historical count table is not a present-day verdict.

Before broad sweeps, fix one compiler input at a time and preserve a successful control. Do not introduce assembly, postlink rewriting, copied function bytes, guessed types or changed masks to turn an unresolved candidate into an exact claim.
