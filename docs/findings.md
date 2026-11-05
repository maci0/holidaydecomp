# Finding index

These records link concrete questions to current source and tests. They are scoped findings; the [status tracker](../STATUS.md) remains authoritative for stored progress and per-function verdict counts.

## Signed flag index

**Observation:** DATEN's `2:0x2AC7` and `2:0x2ADE` setters use a signed byte index, reflected by `A0: ShortInt` in [DATEN.PAS](../src/main/DATEN.PAS). The index selects a byte in `MAP.Pad651A`; the setters then refresh state through `Proc2_2AF5`.

The historical correction was from a mistaken zero-extension reading to `cbw`, which sign-extends AL. This establishes why Byte/Word are different candidates; it does not establish valid application index bounds or every callee's semantics.

## Self and Sender

**Observation:** Self and Sender occupy different far-pointer slots in the reviewed event families. [HIGHSCOR.PAS](../src/main/HIGHSCOR.PAS) includes PausebildClick forwarding Self, and the [form index](../src/main/forms/README.md) links each wired callback to its metadata address.

The recovered declaration and receiver use are source evidence. Correct native callee identity and the complete function's operands still need their own comparison; a matching push shape is insufficient.

## Empty callback frame

**Observation:** `TGeldmenuform.MenuImageMouseMove` remains semantically empty but declares `Reserved: Integer` to retain a two-byte local frame. See [GELD.PAS](../src/main/GELD.PAS) and the [recovered-form source tests](../tools/test_recovered_forms.py).

Empty source, empty native semantics and a frameless implementation are different claims. Removing the local can change bytes without adding behavior.

## Numeric volume

**Observation:** [SOUND.PAS](../src/main/SOUND.PAS), native `20:0x2453`, uses numeric LongInt state and the expression `X * $28F + (X * $28F) * $10000` before MMSYSTEM ordinal 416.

An earlier review mistakenly assumed the multiply helper's result was discarded between the first two calls. The corrected review tracked the live result; the second multiply consumes the first product. For X=1, the low-32 result is `0x028F028F`. This is arithmetic with wrapping semantics under the original settings, not pointer arithmetic.

[The native recovery test](../tools/test_native_recovery.py) checks the selected body/import family. This is not proof that the entire audio subsystem or all input ranges work.

## Close-handler ownership

**Observation:** THINTERG's close handler releases nine references through MAP's `ShutdownObjects` view, then writes `caFree` through Action. See [THINTERG.PAS](../src/main/THINTERG.PAS), [MAP.PAS](../src/main/MAP.PAS) and [recovered-form tests](../tools/test_recovered_forms.py).

The original reference sites and Action contract do not prove an original array name, concrete subclasses or allocation owner. Older notebooks that placed this array directly in THINTERG describe an earlier reconstruction; the current source is authoritative for present placement.

## Comment syntax control

**Reproduced:** the pinned Delphi 1 compiler rejects `//` and accepts brace comments. The [receipt](evidence/comment-syntax.json) records both control programs. [The generator](../tools/gen_tree.py) uses brace address comments; [the test](../tools/test_form_sources.py) prevents a return to incompatible syntax or invented helper addresses.
