# Delphi 1 calling convention

Read the native stack and use the stock compiler to test a proposed declaration. [Codegen patterns](codegen-patterns.md) owns source-shape effects, and [findings](findings.md) links concrete examples.

## Frames and arguments

For a frame beginning with `push bp; mov bp,sp`, a near return places the nearest argument word at `[bp+4]`; a far return places it at `[bp+6]`. A `ret N` or `retf N` states stack cleanup bytes, not the count or types of source parameters.

Delphi's Pascal argument order places earlier explicit formals higher in the argument area. A far pointer or LongInt uses two words. A byte-sized argument can still occupy a word-sized stack slot. Infer the kind from actual loads, signed extension, uses and caller evidence, not cleanup alone.

`les di,[bp+N]` reads a far pointer. `mov di,es:[di+9]` reads a word; replacing it with `les` changes both the value kind and generated call shape.

## Hidden receiver and results

A method's implicit Self is also a far pointer. In the reviewed event families it occupies `[bp+6]`, with explicit arguments above it. Thus `retf 8` can consume Self plus Sender even when Sender is unread. Forwarding `[bp+6]` in a published method often forwards Self; do not relabel it as an explicit parameter.

A VCL close notification has `Sender: TObject; var Action: TCloseAction`. Together with Self, the two far arguments explain the reviewed `retf 12` close-handler frame. The Action reference and enum width matter; a Sender-only declaration changes the ABI.

Integer, LongInt and Boolean results can reserve hidden local slots and be reloaded into AX, DX:AX or AL. `enter K,0` includes compiler-created temporaries/results; do not choose source locals from K alone.

## Signedness and arithmetic

`cbw` sign-extends AL into AX. It is not zero extension, and it supports a ShortInt interpretation when a byte argument becomes an index. The [DATEN flag setters](findings.md#signed-flag-index) retain this distinction.

LongInt multiplication through the runtime helper is numeric arithmetic, not evidence for a pointer type. Preserve low-32-bit behavior and overflow-check settings when comparing the [volume expression](findings.md#numeric-volume).

## Near and far declarations

Delphi 1 interface declarations are far in the measured families; a nearby `{$F-}` alone does not turn that public declaration into the required private near routine. The generator's near marker and implementation placement are therefore part of the source contract. Caller stack slots and return cleanup must be checked together.
