# Codegen patterns

These are working rules for the stock Delphi 1 target, not universal Pascal laws. A particular spelling still needs its own compile/native check. [Calling convention](calling-convention.md) owns stack interpretation; [codegen walls](codegen-walls.md) owns unresolved spellings.

## Comments and source syntax

The pinned Delphi 1 compiler rejected `//` at program scope with Error 36, “BEGIN expected.” A brace-comment control compiled successfully. The [syntax receipt](evidence/comment-syntax.json) records both inputs and outcomes.

Native address comments use `{ ADDRESS: MAIN 0x... }`. They are references to managed identities, not evidence of a byte verdict. Keep lines within Delphi 1's source-line limit; [gen_tree.py](../tools/gen_tree.py) wraps generated declarations.

## Pointer argument shapes

A four-byte value Pointer can compile into two memory-word pushes, while a `var` object/record view can produce `les` followed by `push es; push di` in the reviewed families. The same stack size does not make these instruction forms equal.

Typed far-pointer arithmetic, record field access and local spills can change pointer reloads. Check the full caller and callee contracts before changing a formal merely to select one push sequence.

## Locals and results

An empty body can still require an unused local to reproduce its native frame. [GELD's mouse-move callback](findings.md#empty-callback-frame) is a concrete example. A Boolean expression assigned once can produce a different store/branch shape from explicit true/false arms.

Signed and unsigned types select different comparison branches even if one test input produces the same result. Local declaration order, result slots and compiler temporaries can move frame offsets.

## Physical and mapped tails

A native routine can end inside an explicitly allocated, zero-filled code tail. Comparing physical file bytes and comparing mapped instructions are different checks. The [code-tail tests](../tools/test_code_tail.py) cover declared zero completion and reject an invented tail without allocation.

Never append zeros to a physical function merely to complete a desired `retf` operand. Use the native segment's declared allocation and retain the physical extent separately.

## Reachability and data placement

DCC's linker can discard unreferenced bodies. The reconstruction has synthetic force-keep callers and [REACH](../src/main/REACH.PAS) to retain code for measurement. Their presence is not evidence for native startup behavior.

Aliases, array elements, unit order and generated data blocks can move DGROUP displacements. Equal instruction shape with a changed data address is not raw equality. Verify the backing object and operands rather than masking every displacement.
