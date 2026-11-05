# Data ownership and record views

The [data registry](../rebrew-data.toml) currently has no verified global ownership rows. [Current work](TODO.md) owns that migration. Names in Pascal and old notebooks are working identities, not automatically reviewed storage contracts.

## Storage versus views

A backing allocation owns bytes. A pointer cast, absolute alias, overlapping record view or high word of a LongInt does not allocate another object. Record the backing extent, offsets, width, signedness and lifetime before assigning a semantic type.

DGROUP's stored bytes and loader-zeroed allocation are different domains; see [native format](native-format.md#dgroup-and-mapped-bytes). A DS-relative offset is not a packed instruction address.

## Concrete boundaries

- `MAP.P6532` is a global far-pointer slot; the record reached through it is another object. Do not confuse the address of the slot with the stored pointer.
- `MAP.P6334` is numeric LongInt state in the reviewed volume path despite its P-prefixed name. [The volume finding](findings.md#numeric-volume) explains the arithmetic evidence.
- `ShutdownObjects` is declared in MAP and used by THINTERG's close handler. The array grouping and concrete source owner are reconstruction choices; the native reference addresses and release operations are the underlying evidence.
- An opaque packed record can expose one observed field without establishing the pointee's total allocation size or original class.

[MAP.PAS](../src/main/MAP.PAS), [THINTERG.PAS](../src/main/THINTERG.PAS) and [SOUND.PAS](../src/main/SOUND.PAS) are the current source owners for those examples.

## Layout edits

Check every affected caller and view before splitting a pad or changing a field type. Preserve total packed size and known offsets, and verify source/compiled layouts separately. A type used for code generation is not proof of the original declaration.

Do not replace pointer semantics with two unrelated words solely because cleanup bytes agree. Conversely, a four-byte scalar used in arithmetic is not a pointer simply because it occupies the same width.
