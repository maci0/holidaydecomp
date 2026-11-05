# Native format and addresses

The recorded German reference is a 16-bit Windows **NE** executable behind an MZ stub. It is the Windows 3.1 target, not a Win32 PE build. Windows 95 compatibility does not itself imply a different executable. Other language/patch editions require their own hashes and inventory.

The current reference has 35 NE segments: program code at zero-based indices 0–24, library/runtime code at 25–33, and DGROUP at 34. Segment zero is represented by two reconstructed source units. The [unit map](units.md) records that source split.

## Native addresses

The project's analytical addresses encode a **zero-based segment index** and an offset:

```text
20:0x2453 -> 20 * 0x10000 + 0x2453 -> MAIN.0x00142453
```

`MAIN` is the Rebrew metadata namespace. This packed address is not a file offset or a live protected-mode selector. The NE header numbers segments from one; [segments.json](../layout/main/segments.json) records both zero-based `index` and one-based `number`, with `index_base` explicit.

Look up the source without a decompiler:

```sh
git grep -n -F '{ ADDRESS: MAIN 0x00142453 }' -- src/main
```

[Function metadata](../rebrew-functions.toml) carries the source binding and native size. [The inventory](../src/main/function_structure.json) carries reviewed discovery extents. Unknown bodies stay unbound rather than acquiring an invented definition.

## Calls and relocations

A far-call instruction's stored segment word can be a relocation placeholder. Resolve the NE fixup and its target segment before naming a callee. Equal offsets in different segments are different candidates; an offset-only lookup is insufficient.

For internal fixups, convert the target's one-based segment number to the zero-based index used in this project's notation. Read encoded operand widths and near/far returns before choosing a Pascal signature. [decompile.py](../tools/decompile.py) and Rebrew's NE loader provide those mechanics.

## DGROUP and mapped bytes

For the recorded reference, DGROUP stores 11,641 bytes and requests 30,598 bytes of allocation. The remainder is loader-initialized storage. A DS-relative global offset is not an instruction VA. Heap/stack and code allocation fields have their own meanings; use the parsed header rather than applying one rule to every segment.

A physically short code tail can be completed by declared mapped zero bytes. Keep that scope distinct from bytes present in the file; see [physical and mapped tails](codegen-patterns.md#physical-and-mapped-tails).
