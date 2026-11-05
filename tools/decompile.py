#!/usr/bin/env python3
"""decompile.py — disassemble the program's code and name it from the image.

The reconstruction so far recovered *what* the units are (names, `uses`,
published methods, form streams, constants).  This tool attacks the other half:
the code itself.  Three sources of ground truth are combined, none of them
guessed:

* **Entry scan** — Delphi 1 emits `push bp; mov bp,sp` (55 89 E5) at the
  start of every frame-based procedure, and most of the program's procedures
  are frame-based.
* **Method tables**: published names carry far pointers. Original resolved
  offsets are read directly; native internal NE relocations provide unresolved
  targets. Only complete same-segment tables are returned by the offset API.
* **Call/jump targets** — a fixpoint pass adds any address named by a `call`
  or `jmp` immediate, so procedures the entry scan misses still appear.

Everything the disassembler shows is also harvested as a *codegen pattern* (see
`patterns()`), because Delphi 1's idiom vocabulary is what a decompilation of
this target has to speak.
"""

from __future__ import annotations

from collections import Counter

import argparse
import collections
import contextlib
import hashlib
import re
import struct
import sys
from dataclasses import dataclass, field
from pathlib import Path

import capstone
from rebrew.formats.ne_analysis import NeImage, published_method_candidates
from capstone import CS_AC_READ, CS_AC_WRITE

REPO = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(REPO / "tools"))

ORIGINAL = REPO / "original" / "holiday.exe"

PROLOGUE = b"\x55\x89\xe5"  # push bp; mov bp,sp
#: `enter imm16, imm8` is the *other* Delphi 1 frame form and is far more
#: common in this binary than the push/mov prologue: a scan for push/mov alone
#: found 649 procedures where the whole program holds 1421 enter-framed ones,
#: and the segments it missed (1, 2, 15, 18-22) are exactly the logic units
#: the building-placement code lives in.
ENTER_OPCODE = 0xC8
NEAR_RELOCATION = 5
NEAR_TARGET_INDEX = 1
X86_MAX_INSTRUCTION_BYTES = 15
#: A relocation's stored target is one-based. Internal references use the
#: caller's segment; external library references have no local image segment.
INTERNAL_TARGET_SEGMENT = 1
NE_SEGMENT_CAPACITY = 0x10000


def engine() -> "capstone.Cs":
    """A 16-bit x86 engine with operand detail on (capstone 5 takes it as an
    attribute, not a constructor keyword)."""
    md = capstone.Cs(capstone.CS_ARCH_X86, capstone.CS_MODE_16)
    md.detail = True
    return md


#: `leave; retf` (CB, one byte) or `leave; retf imm16` (CA iw).
#:
#: The legacy matcher, kept for the measurements that were taken through it: the
#: `retf imm16` arm matches only its first two bytes, so a procedure whose last
#: instruction is `retf imm16` gets an `end` two bytes short of the return and the
#: truncated instruction disappears from `procedure_body`. That is where the
#: round-405 census's **916 procedures with no return** came from; with the whole
#: instruction matched (`EPILOGUE_RE_WHOLE`, the default) the counts are
#: **1049 far, 254 near and 3 with no return**.
EPILOGUE_RE = re.compile(rb"\xc9[\xcb\xca]")  # leave; retf (short/long)

#: The same pattern with the whole instruction: `retf` is one byte, but `retf imm16`
#: and `ret imm16` carry a two-byte immediate that is part of them. `EPILOGUE_RE`
#: matches only the first two bytes of that three-byte instruction, so the range ends
#: two bytes early and the truncated return drops out of `procedure_body` — the defect
#: measured in round 405 (916 procedures reporting no return; the real census is
#: 1029 far, 254 near, 23 without).
#:
#: The whole-instruction matcher is the default. `use_whole_epilogue()` stays for
#: code that has to ask for it explicitly; the legacy pattern is only what the
#: round-405 numbers in the documents were measured through.
EPILOGUE_RE_WHOLE = re.compile(rb"\xc9(?:\xcb|\xca..|\xc2..)", re.DOTALL)

#: Which of the two matchers the discovery uses: `"whole"` matches the immediate of
#: `retf imm16`/`ret imm16` as part of the instruction.
EPILOGUE_MODE = "whole"

#: Word 1.0 opcodes the 16-bit decoder needs to read an immediate target out
#: of: the near call/jmp family and the far call/jmp family.
NEAR_JUMP = {0xE8, 0xE9}  # call rel16, jmp rel16
FAR_JUMP = {0x9A, 0xEA}  # call far ptr16:16, jmp far ptr16:16


@dataclass
class Function:
    """One procedure located in the image."""

    segment: int
    offset: int
    end: int | None = None
    name: str | None = None
    published: bool = False

    @property
    def size(self) -> int:
        return (self.end or self.offset) - self.offset


@dataclass
class Segment:
    index: int
    data: bytes
    functions: list[Function] = field(default_factory=list)
    alloc: int = 0
    image: object | None = None  # the Image this came from, for memo keys

    def at(self, offset: int, length: int = 8) -> bytes:
        return self.data[offset : offset + length]

    @property
    def bss(self) -> int:
        """Bytes present at run time but not in the file.

        A code segment's minimum allocation comes from the NE header; a
        declared tail beyond its physical bytes is zero-filled. The data
        segment model adds the `min alloc` field to its file length, and
        that field's worth of bytes is zero-filled at
        load.  Every global the program reaches above `len(data)` lives there.
        """
        return max(0, self.alloc - len(self.data))


class Image:
    """The NE image, split into segments with helpers for the passes above."""

    def __init__(self, path: Path) -> None:
        self.source = str(path)
        self.data = path.read_bytes()
        self.cache_key = (self.source, hashlib.sha256(self.data).digest())
        self.native = NeImage(path)
        self.align = self.native.align
        self.seg_count = self.native.seg_count
        self.segments: list[Segment] = []
        for i, record in enumerate(self.native.segment_records):
            length, flags, minimum = record.length, record.flags, record.min_allocation
            segment = Segment(
                i,
                self.native.seg_bytes(i),
                # The segment table's `min alloc` field reads as a *total* for the
                # 34 code segments (it is `length` in 11 and `length + 1` in 23,
                # never anything else) but the data segment's value, 30 598, is
                # smaller than addresses the code reaches with a bare `[0x...]`
                # access (up to 0xA335 = 41 781).  With only one data segment in the
                # image, one of the two readings has to give; round 277/278 record
                # the ambiguity in `docs/data-segment.md` and take the larger size
                # here, because the accesses are evidence and the field is a
                # convention.
                alloc=length + minimum if flags & 1 else max(length, minimum or NE_SEGMENT_CAPACITY),
            )
            segment.image = self
            self.segments.append(segment)

    def program_segments(self) -> list[Segment]:
        """Segments 0-24 hold the game; 25+ are the VCL/System and the data
        segment (see docs/segment-map.md)."""
        return self.segments[:25]

    def data_segment(self) -> Segment:
        """The one segment with more allocation than file bytes: DGROUP."""
        return max(self.segments[25:], key=lambda s: s.bss)


# --- ground truth ---------------------------------------------------------


def far_calls(image: Image | None = None) -> tuple[dict[int, dict], int]:
    """Rank every far call in the program by the callee's entry offset.

    The offset half of an `lcall` is final — intra-segment offsets do not move
    — but the segment half is a placeholder that differs at every call site
    (measured: 480 distinct values over 486 sites calling one offset), so the
    target segment has to be inferred.  A segment is a candidate when a frame
    prologue sits at that offset; `callers` records which segments make the
    call, because a callee usually belongs to one of them.

    Returns `(offset -> {sites, callers, candidates, context}, indirect sites)`.
    An indirect site is `lcall es:[di+0x30]` — a virtual method call, whose
    callee is in memory rather than in the instruction, so it has no offset to
    rank and is only counted.

    Instances are walked per discovered procedure, not by a linear sweep: 16 of
    the 25 segments begin with a table or a string, and a sweep from offset 0
    derails there (capstone stops at the first byte it cannot decode, after 19
    instructions in segment 3).
    """
    image = image or Image(ORIGINAL)
    classes = form_classes_by_segment(image)
    out: dict[int, dict] = {}
    seen: set[tuple[int, int]] = set()
    indirect = 0
    for segment in image.program_segments():
        for function in discover(segment, classes.get(segment.index, [])):
            previous: list[str] = []
            for ins in procedure_body(segment, function):
                # discovered ranges overlap (a callee inside a caller), so an
                # instruction is counted once by its address
                if (segment.index, ins.address) in seen:
                    continue
                seen.add((segment.index, ins.address))
                if ins.mnemonic in ("lcall", "ljmp"):
                    if len(ins.operands) < 2:
                        indirect += 1
                    else:
                        offset = ins.operands[1].imm
                        entry = out.setdefault(
                            offset, {"sites": 0, "callers": set(), "context": Counter()}
                        )
                        entry["sites"] += 1
                        entry["callers"].add(segment.index)
                        entry["context"][tuple(previous[-2:])] += 1
                previous.append(f"{ins.mnemonic} {ins.op_str}")
    for offset, entry in out.items():
        entry["candidates"] = [
            segment.index
            for segment in image.segments
            if entry_point_at(segment, offset)
        ]
    return out, indirect


def _prologue_at(segment: Segment, offset: int) -> bool:
    data = segment.data
    return offset < len(data) and (
        data[offset : offset + 3] == PROLOGUE or data[offset] == ENTER_OPCODE
    )


def fixup_offset_targets(image: Image) -> dict[int, int]:
    """Offset -> callee segment, where the fixups agree on one for that offset.

    A fixup names the callee segment for the call site it covers, and one offset
    can be called from several sites, so an offset is reported only when every
    covered site agrees. See `fixup_call_targets` for what the fixups are.
    """
    classes = form_classes_by_segment(image)
    offset_of: dict[tuple[int, int], int] = {}
    for segment in image.program_segments():
        for function in discover(segment, classes.get(segment.index, [])):
            for ins in procedure_body(segment, function):
                if ins.mnemonic in ("lcall", "ljmp") and len(ins.operands) >= 2:
                    offset_of[(segment.index, ins.address)] = ins.operands[1].imm
    found: dict[int, set[int]] = {}
    for site, callee in fixup_call_targets(image).items():
        offset = offset_of.get(site)
        if offset is not None:
            found.setdefault(offset, set()).add(callee)
    return {offset: next(iter(segments)) for offset, segments in found.items()
            if len(segments) == 1}


def resolved_targets(image: Image | None = None, census: dict | None = None) -> dict[int, int]:
    """The far-call offsets that name exactly one segment.

    One credible entry point in the whole image is the whole answer. More than one
    used to be decided by a caller test — "a candidate counts when the calling
    segments include it, or when it is a library segment" — and that test is
    **measurably wrong**: on the 23 multi-candidate offsets the NE fixups cover it
    commits on 9 and is right once and wrong eight times, each time preferring a
    library segment where the callee is a program segment (`tools/call_truth.py`,
    2026-10-14). So an ambiguous offset is now decided by the fixups where they
    settle it and left unresolved otherwise: **773** offsets resolve, 692 program
    and 81 library, against 775/687/88 before, with 22 answers changed.
    """
    if census is None:
        census, _ = far_calls(image)
    settled = fixup_offset_targets(image) if hasattr(image, "segments") else {}
    out = {}
    for offset, entry in census.items():
        candidates = entry["candidates"]
        if len(candidates) == 1:
            # One credible entry point in the whole image: nothing to choose.
            out[offset] = candidates[0]
            continue
        if offset in settled:
            out[offset] = settled[offset]
    return out


def fixup_call_targets(image: Image) -> dict[tuple[int, int], int]:
    """(caller segment, call site) -> callee segment, from the NE fixups.

    The original's far calls are the resolved form: the file holds the callee's
    offset and an **atype-2 fixup patches the segment word**, so for the calls the
    linker recorded a fixup for the answer is written down rather than inferred.
    `tools/call_truth.py` measures the prologue rule against these and finds it
    right on 252 of 257 comparable sites, with all five errors being calls into
    frame-less `System` routines the prologue test cannot see — so a caller that
    needs the callee segment should prefer this map where it applies.
    """
    data = {segment.index: segment.data for segment in image.segments}
    out: dict[tuple[int, int], int] = {}
    for source, atype, _rtype, offset, target, _addend in relocation_records(image):
        if atype != 2:
            continue
        site = offset - 3
        if site < 0 or source not in data or site >= len(data[source]):
            continue
        if data[source][site] != 0x9A:
            continue                      # a segment word that is not a far call
        if 1 <= target <= len(image.segments):
            out[(source, site)] = target - 1
    return out


def call_targets(image: Image) -> dict[tuple[int, int], int]:
    """Where every far call in the program segments goes, fixups first.

    The fixup map is exact for the calls it covers; the rest are named by the
    prologue rule, and only when exactly one segment has a credible entry point at
    the call's offset. A call whose offset several segments could claim is left
    out rather than guessed.
    """
    out = fixup_call_targets(image)
    classes = form_classes_by_segment(image)
    for segment in image.program_segments():
        for function in discover(segment, classes.get(segment.index, [])):
            for ins in procedure_body(segment, function):
                if ins.mnemonic not in ("lcall", "ljmp") or len(ins.operands) < 2:
                    continue
                key = (segment.index, ins.address)
                if key in out:
                    continue
                offset = ins.operands[1].imm
                candidates = [
                    s
                    for s in range(len(image.segments))
                    if entry_point_at(image.segments[s], offset)
                ]
                if len(candidates) == 1:
                    out[key] = candidates[0]
    return out


def published_methods(segment: Segment, cls: str) -> list[tuple[str, int]]:
    """Return complete published method tables with same-segment NE pointers resolved."""
    fixups = {}
    if isinstance(segment.image, Image):
        fixups = _memo("published_internal_pointers", segment.image, lambda: {
            (source, site): (target - 1, addend)
            for source, atype, rtype, site, target, addend in relocation_records(segment.image)
            if atype == 3 and rtype == 0
        })
    return published_method_candidates(segment.data, cls, source_segment=segment.index, fixups=fixups)


def form_classes_by_segment(image: Image) -> dict[int, list[str]]:
    """Every form class a program segment declares, in RTTI order — a segment
    can hold several units (the 16 KB packing rule), so this is a list."""
    try:
        from gen_tree import UNITS
    except (ImportError, SyntaxError) as error:
        # The generator is edited while this runs, so a half-written
        # `tools/gen_tree.py` reaches here as a SyntaxError. The decoding tools
        # should name that and say to retry rather than die in an import.
        raise RuntimeError(
            "tools/gen_tree.py is mid-write or broken, so the unit table is "
            f"unreadable; retry once it parses ({error})"
        ) from error

    out: dict[int, list[str]] = {}
    for index, (_unit, classes, _evidence) in UNITS.items():
        if classes:
            out[index] = list(classes)
    return out


# --- function discovery ---------------------------------------------------


#: A frame larger than this, or an `enter` nesting level above it, is not a
#: frame the compiler would emit — see `plausible_entry`.
MAX_FRAME = 0x2000
MAX_NESTING = 3


def entry_point_at(segment: Segment, offset: int) -> bool:
    """Do the bytes at *offset* look like a procedure the compiler emitted?

    Both frame forms count, but the `enter` form only when its nesting level
    and frame size are ones DCC emits — a bare `0xC8` is a common immediate and
    displacement byte, so the frame fields are what make it credible.
    """
    data = segment.data
    if offset < 0 or offset + 4 > len(data):
        return False
    if data[offset : offset + 3] == PROLOGUE:
        return True
    if data[offset] != ENTER_OPCODE:
        return False
    frame = struct.unpack_from("<H", data, offset + 1)[0]
    return data[offset + 3] <= MAX_NESTING and frame <= MAX_FRAME


def plausible_entry(segment: Segment, offset: int, published: bool = False) -> bool:
    """Is *offset* an entry point, or a `0xC8` byte inside another instruction?

    The push/mov prologue is three bytes, so finding it is strong evidence.  A
    lone `0xC8` is not: it is also the low byte of very common immediates and
    displacements, and a scan for it lands in the middle of instructions all
    over the program — `C8 8B DA` is the tail of one instruction followed by
    `mov bx, dx`.  In this image 701 of the 2024 entry-scan candidates were of
    that kind, and 658 of them were not referenced by any call.

    An `enter` frame is therefore accepted only when its nesting level and
    frame size are ones the compiler emits, or when a published method table
    vouches for the offset.
    """
    if published:
        return offset < len(segment.data)
    return entry_point_at(segment, offset)


@contextlib.contextmanager
def use_whole_epilogue():
    """Run discovery with the whole-instruction epilogue matcher.

    Restores the final `retf imm16`/`ret imm16` to every procedure's range for the
    duration of the block. A context manager rather than a flag because the discovered
    ranges are memoised per segment: tests and generators that need one mode must not
    leave the other's cached ranges behind.
    """
    global EPILOGUE_MODE
    previous = EPILOGUE_MODE
    EPILOGUE_MODE = "whole"
    _MEMO.clear()
    try:
        yield EPILOGUE_RE_WHOLE
    finally:
        EPILOGUE_MODE = previous
        _MEMO.clear()


def active_epilogue():
    """The epilogue pattern the current mode uses."""
    return EPILOGUE_RE_WHOLE if EPILOGUE_MODE == "whole" else EPILOGUE_RE


def procedure_body(segment, function) -> list:
    """A procedure's instructions, truncated at its last return, memoised per procedure.

    A discovered procedure's range is bounded by the next entry, not by its own code,
    so a linear scan can run past its final `ret` into whatever follows — a string, a
    table, padding. Those bytes decode as instructions and inflate any per-procedure
    count taken from them. Round 376 found the defect on a parameter list and round
    377 measured it: one procedure's *call* list and eight parameter lists were
    affected. Every consumer that counts operands should read the body through here.
    """
    # A COPY, not the cached list. Some callers annotate or sort the body they are given, and
    # handing them the shared cache corrupted it: round 603 found `jump_tables` reporting segment
    # 19's table at 0x1001 instead of 0x2406 once the memo existed. The copy costs a fraction of the
    # decode it saves.
    return list(_memo(
        f"body:{segment.index}:{function.offset}:{function.end}",
        getattr(segment, "image", None),
        lambda: _procedure_body_uncached(segment, function),
    ))


def _procedure_body_uncached(segment: Segment, function: Function) -> list[capstone.CsInsn]:
    """The uncached decode behind `procedure_body` (round 598).

    Round 578 described this as a reachability walk. It is not: it is a **linear** decode of the
    procedure's range, truncated at the last return in the result. The `ret` that round could not
    find in `19:0x109F` was swallowed because the linear decode desynchronises on data bytes inside
    the range and reads the `c3` as part of another instruction.

    It is memoised because it re-decodes on every call and round 598 measured 159 call sites across
    71 test classes, each asking for the same procedures: seconds per class, and the reason the full
    module takes 38 minutes.
    """
    code = segment.data[function.offset : function.end]
    if function.end == len(segment.data) and segment.alloc > len(segment.data):
        tail = min(segment.alloc - len(segment.data), X86_MAX_INSTRUCTION_BYTES)
        code += bytes(tail)
    body = list(engine().disasm(code, function.offset))
    for index in range(len(body) - 1, -1, -1):
        if body[index].mnemonic in ("ret", "retf"):
            return body[: index + 1]
    return body


def discover(
    segment: Segment, classes: list[str] | None = None, plausible_only: bool = True
) -> list[Function]:
    """Entry scan + method tables + call-target fixpoint, memoised per segment.

    The scan is the expensive half of most passes and the tests ask for the same
    segments repeatedly, so the result is cached on the segment's image, index
    and class list.
    """
    return _memo(
        f"discover:{segment.index}:{plausible_only}:{tuple(classes or ())}",
        getattr(segment, "image", None),
        lambda: _discover_uncached(segment, classes, plausible_only),
    )


def _discover_uncached(
    segment: Segment, classes: list[str] | None = None, plausible_only: bool = True
) -> list[Function]:
    """Entry scan + method tables + call-target fixpoint.

    `plausible_only` drops entry-scan candidates that only a byte inside an
    instruction can explain; pass False for the raw scan (the difference is
    what `tools/decompile.py --prologues` reports).
    """
    md = engine()
    functions: dict[int, Function] = {}
    data = segment.data

    def add(offset: int, name: str | None = None, published: bool = False) -> bool:
        if offset < 0 or offset >= len(data):
            return False
        existing = functions.get(offset)
        if existing is None:
            functions[offset] = Function(
                segment.index, offset, name=name, published=published
            )
        elif name and existing.name is None:
            existing.name = name
            existing.published = published
        return True

    # 1. entry scan, both frame forms
    pos = 0
    while True:
        pos = data.find(PROLOGUE, pos)
        if pos < 0:
            break
        add(pos)
        pos += 1
    pos = 0
    while True:
        pos = data.find(bytes([ENTER_OPCODE]), pos)
        if pos < 0:
            break
        # A 0xC8 only starts an `enter` where the decoder agrees; elsewhere it
        # is a displacement or immediate byte, so check before adding.
        decoded = next(md.disasm(data[pos : pos + 4], pos), None)
        if decoded is not None and decoded.mnemonic == "enter":
            add(pos)
        pos += 1

    # 2. published method tables — the name source, and the reason the
    # 4-byte pointer's offset half is trusted as an entry point.
    for cls in classes or []:
        for name, offset in published_methods(segment, cls):
            add(offset, f"{cls}.{name}", published=True)

    # 3. call/jump targets (fixpoint, so nested-only procedures appear)
    for _round in range(4):
        found = []
        for offset, func in functions.items():
            for ins in md.disasm(data[offset : offset + 0x4000], offset):
                if ins.id in NEAR_JUMP and ins.operands and ins.operands[0].type == 2:
                    found.append(ins.operands[0].imm)
                elif ins.id in FAR_JUMP and len(ins.operands) >= 2:
                    seg = ins.operands[0].imm
                    if seg == segment.index:
                        found.append(ins.operands[1].imm)
                if ins.mnemonic.startswith("ret"):
                    break
        before = len(functions)
        for target in found:
            add(target)
        if len(functions) == before:
            break

    if plausible_only:
        for offset, func in list(functions.items()):
            if not plausible_entry(segment, offset, func.published):
                del functions[offset]

    # 4. extents: the first `leave; retf`, else the next entry.
    #
    # "Next entry" alone is not enough: once the spurious entries are gone, a
    # span stretches from a procedure's real end to whatever entry follows,
    # sweeping the data in between into the disassembly (that is how the
    # far-call census grew when the spurious entries were removed).  The
    # epilogue bounds it instead, and a *nested* procedure still shows up as an
    # entry before it.
    ordered = sorted(functions)
    for position, offset in enumerate(ordered):
        func = functions[offset]
        nxt = ordered[position + 1] if position + 1 < len(ordered) else None
        match = active_epilogue().search(data, offset, nxt or len(data))
        if match is not None:
            func.end = match.end()
        elif nxt is None:
            last = None
            for last in active_epilogue().finditer(data, offset):
                pass
            func.end = last.end() if last else len(data)
        else:
            func.end = nxt
    return [functions[o] for o in ordered]


# --- patterns -------------------------------------------------------------

#: The codegen vocabulary, keyed by the counter `patterns()` emits. The
#: prose version with measurements lives in docs/codegen-patterns.md.
PATTERN_NOTES = {
    "prologue": "push bp; mov bp,sp (55 89 E5) — a frame-based procedure",
    "enter": "C8 nn nn nn — `enter <locals>, <level>`, the majority frame form here",
    "epilogue": "leave; retf (C9 CB) or leave; retf imm16 (C9 CA xx xx)",
    "op:les": "les reg, [bp+N] — a far pointer parameter: Self or a class reference",
    "frame:access": "mov/lea against [bp-N] — a local or parameter",
    "imm:absolute": "an absolute address immediate: a global or a far pointer",
    "op:lcall": "far call (9A) into another unit; the selector is a placeholder",
    "call:near": "near call (E8) inside the same unit",
    "call:self": "near call of the following address — the recursive-call idiom",
    "op:cwde": "byte/word to int — the Integer conversions",
    "op:imul": "record-array indexing: the multiply is the element stride",
    "op:idiv": "integer division",
    "op:retf": "procedure epilogue",
}


def patterns(functions: list[Function], segment: Segment) -> dict[str, int]:
    """Count the codegen patterns across *functions* — the catalogue input."""
    md = engine()
    counts: collections.Counter = collections.Counter()
    for func in functions:
        counts["total_functions"] += 1
        for ins in md.disasm(segment.data[func.offset : func.end], func.offset):
            name = ins.mnemonic
            counts[f"op:{name}"] += 1
            ops = ins.op_str
            if name == "call":
                counts[
                    "call:near"
                    if ins.operands and ins.operands[0].type == 2
                    else "call:far"
                ] += 1
                if (
                    ins.operands
                    and ins.operands[0].type == 2
                    and ins.operands[0].imm == ins.address + ins.size
                ):
                    counts["call:self"] += 1
            if name == "jmp" and ins.operands and ins.operands[0].type == 2:
                counts["jmp:near"] += 1
            if name in ("ret", "retf"):
                counts["op:return"] += 1
            if name == "leave":
                counts["op:leave"] += 1
            if "bp" in ops and name in ("mov", "lea"):
                counts["frame:access"] += 1
            if name in ("mov", "cmp", "test") and re.search(r"0x[0-9a-f]{2,4}\b", ops):
                counts["imm:absolute"] += 1
    return dict(counts)


#: One to four hex digits: DGROUP starts at 0, so its low initialised part holds
#: real globals (`[0x7C]` is read 290 times). Four digits only hid 61 of them
#: (round 416).
DATA_REF = re.compile(r"\[(0x[0-9a-f]{1,4})\]")

MEM = 3  # capstone x86 operand type for a memory reference


def absolute_operands(ins) -> list[tuple[int, int, int]]:
    """(address, byte width, access) for every `[0xNNNN]` operand of one instruction.

    Frame slots and register-indirect accesses are excluded: only an absolute
    displacement addresses a unit's global, and the operand's size says how wide
    that global is. `access` is capstone's `CS_AC_READ`/`CS_AC_WRITE` mask for
    the operand, which is the only way to tell a store from a load for the
    mnemonics where the operand order does not: `pop word ptr [0x49E4]` *writes*
    the global, but `pop` is not in any list of storing mnemonics, and a
    mnemonic-keyed test counts it as a reader (measured 2026-10-13 on
    `0x49E4`). The operand's own access bits are right for every form.
    """
    out = []
    for operand in ins.operands:
        if operand.type != MEM:
            continue
        mem = operand.mem
        if mem.base or mem.index:
            continue
        out.append((mem.disp & 0xFFFF, operand.size, operand.access))
    return out


def absolute_refs(ins) -> list[tuple[int, int]]:
    """(address, byte width) for every `[0xNNNN]` operand of one instruction."""
    return [(address, width) for address, width, _access in absolute_operands(ins)]



def immediate_refs(image):
    return _memo("immediate_refs", image, lambda: _immediate_refs_uncached(image))


def _immediate_refs_uncached(image) -> dict[int, int]:
    """DS addresses the code passes as immediates, which `absolute_refs` misses.

    The 16-bit compiler loads the address of a string or a record into a
    register and pushes it as a segment:offset pair — `mov di, 0x51E0 ;
    push ds ; push di` — so the operand is an immediate, not a `[0xNNNN]`
    memory reference, and a bracket-only census never sees it. This walks the
    same functions and counts an immediate when a segment-register push follows
    it, which is the idiom for "the address of a data-segment object".
    """
    found: dict[int, int] = {}
    classes = form_classes_by_segment(image)
    for segment in image.program_segments():
        for function in discover(segment, classes.get(segment.index, [])):
            insns = list(
                engine().disasm(segment.data[function.offset:function.end], function.offset)
            )
            for index, ins in enumerate(insns[:-2]):
                if ins.mnemonic != "mov" or not ins.operands:
                    continue
                target = ins.operands[0]
                if target.type != capstone.x86.X86_OP_REG or target.size != 2:
                    continue
                if len(ins.operands) < 2 or ins.operands[1].type != capstone.x86.X86_OP_IMM:
                    continue
                segment_push = insns[index + 1]
                if (
                    segment_push.mnemonic == "push"
                    and segment_push.op_str in ("ds", "cs", "es", "ss")
                ):
                    address = ins.operands[1].imm & 0xFFFF
                    found[address] = found.get(address, 0) + 1
    return found


def immediate_code_refs(image):
    return _memo("immediate_code_refs", image, lambda: _immediate_code_refs_uncached(image))


def _immediate_code_refs_uncached(image) -> set[int]:
    """The immediates `immediate_refs` finds that are pushed with `cs`.

    `push cs:offset` names code — a procedure passed as a callback or a method
    slot — while `push ds:offset` names a data-segment object. The two are the
    same instruction shape, so only the pushed segment tells them apart.
    """
    code: set[int] = set()
    classes = form_classes_by_segment(image)
    for segment in image.program_segments():
        for function in discover(segment, classes.get(segment.index, [])):
            insns = list(
                engine().disasm(segment.data[function.offset:function.end], function.offset)
            )
            for index, ins in enumerate(insns[:-2]):
                if ins.mnemonic != "mov" or not ins.operands:
                    continue
                target = ins.operands[0]
                if target.type != capstone.x86.X86_OP_REG or target.size != 2:
                    continue
                if len(ins.operands) < 2 or ins.operands[1].type != capstone.x86.X86_OP_IMM:
                    continue
                for later in insns[index + 1 : index + 4]:
                    if later.mnemonic == "push" and later.op_str == "cs":
                        code.add(ins.operands[1].imm & 0xFFFF)
                        break
                    if later.mnemonic == "push":
                        break
    return code


def immediate_literal_refs(image):
    return _memo("immediate_literal_refs", image, lambda: _immediate_literal_refs_uncached(image))


def _immediate_literal_refs_uncached(image) -> set[int]:
    """The `cs`-pushed immediates that are short-string constants.

    `push cs:offset` delivers either a procedure address or a constant the
    compiler placed in the code segment; the bytes tell them apart, since a
    literal is a length byte followed by that many printable characters.
    """
    literals: set[int] = set()
    classes = form_classes_by_segment(image)
    for segment in image.program_segments():
        data = segment.data
        for function in discover(segment, classes.get(segment.index, [])):
            insns = list(
                engine().disasm(data[function.offset:function.end], function.offset)
            )
            for index, ins in enumerate(insns[:-2]):
                if ins.mnemonic != "mov" or not ins.operands:
                    continue
                if len(ins.operands) < 2 or ins.operands[1].type != capstone.x86.X86_OP_IMM:
                    continue
                if not any(
                    later.mnemonic == "push" and later.op_str == "cs"
                    for later in insns[index + 1 : index + 4]
                ):
                    continue
                offset = ins.operands[1].imm & 0xFFFF
                if offset + 1 >= len(data):
                    continue
                length = data[offset]
                if not 3 <= length <= 120 or offset + 1 + length > len(data):
                    continue
                text = data[offset + 1 : offset + 1 + length]
                if all(32 <= byte < 127 or byte >= 0x80 for byte in text):
                    literals.add(offset)
    return literals


def far_pointers(image):
    return _memo("far_pointers", image, lambda: _far_pointers_uncached(image))


def _far_pointers_uncached(image) -> dict[int, dict]:
    """Every global loaded with `les reg, ptr [0xNNNN]`, with its field usage.

    A far pointer's target is a structure whose field offsets say what kind of
    object it is: a VCL control shows its rectangle at `+0x17C` onward, an
    application or form object a form pointer at `+0x184`. Collecting the offsets
    each pointer is indexed with is what lets two of them be told apart without
    knowing the VCL layout.
    """
    found: dict[int, dict] = {}
    classes = form_classes_by_segment(image)
    pattern = re.compile(r"(?:di|si|bx), ptr \[(0x[0-9a-f]{1,4})\]$")
    for segment in image.program_segments():
        for function in discover(segment, classes.get(segment.index, [])):
            insns = list(
                engine().disasm(segment.data[function.offset:function.end], function.offset)
            )
            for index, ins in enumerate(insns):
                if ins.mnemonic != "les":
                    continue
                match = pattern.fullmatch(ins.op_str)
                if not match:
                    continue
                address = int(match.group(1), 16)
                entry = found.setdefault(
                    address, {"sites": 0, "segments": set(), "fields": Counter()}
                )
                entry["sites"] += 1
                entry["segments"].add(segment.index)
                for later in insns[index + 1 : index + 6]:
                    field = re.search(r"es:\[di \+ (0x[0-9a-f]+)\]", later.op_str)
                    if field:
                        entry["fields"][int(field.group(1), 16)] += 1
    return found


def globals_census(functions: list[Function], segment: Segment) -> dict[int, dict]:
    """The data segment as the code sees it: every absolute address, its width
    and how many procedures reach it.

    One entry per address: `width` is the size the instructions use (a byte
    counter and a word counter are two different globals), `widths` collects
    every size seen at that address, and `writers` counts the procedures that
    store to it rather than only load it.
    """
    seen: dict[int, dict] = {}
    for function in functions:
        for ins in procedure_body(segment, function):
            for address, width, access in absolute_operands(ins):
                entry = seen.setdefault(
                    address, {"width": width, "widths": set(), "readers": set(), "writers": set()}
                )
                entry["widths"].add(width)
                entry["width"] = max(entry["width"], width)
                # The operand's own access bits, not the mnemonic: `push [g]`
                # reads and `pop [g]` writes, and no list of storing mnemonics
                # contains `pop` (2026-10-13, on `0x49E4`).
                where = (function.segment, function.offset)
                if access & CS_AC_WRITE:
                    entry["writers"].add(where)
                if access & CS_AC_READ:
                    entry["readers"].add(where)
    return seen


def _read_only_uncached(image) -> dict[int, tuple[int, int]]:
    """(reads, stores) per displacement reached with a register base.

    **Known defect, measured 2026-10-13 and deliberately not fixed yet.** The
    classification is by *operand position*: the first operand being memory makes
    an instruction a store, everything else a read. Two shapes break that, and
    capstone's per-operand access mask gets both right:

    * `push word ptr [g]` mentions memory first but **reads** it, so every global
      passed by value that way counts as a store. `push es:[di+0x17e]` alone is
      **668 sites**.
    * a read-modify-write (`adc word ptr [0x653C], 0`) reads as well as writes and
      is counted once, on the store side.

    Switching to the access mask is *not* a fix on its own, which is why it is not
    landed: this census keeps every displacement reached with a base register, and
    in this codebase `es:[di+disp]` means both "a field of the object `di` points
    at" and "a DGROUP address reached through a base" — Delphi 1 uses the same
    override for both, so no segment test separates them (measured: restricting to
    DS loses known globals `0x0748`, `0x0976` and `0x3460`, and the set then starts
    at offsets `0x1`, `0x8`, `0xC`, which are object fields). The mask alone moves
    **915 of 1603** addresses and grows the read-only-to-the-program set from 37 to
    70, of which **10 are below `0x1000`** and are `es:[di+off]` object fields, not
    globals. Landing it needs the two address classes told apart first — an
    instrument change, not a classifier change. `globals_census` (absolute
    operands, no base register, so no ambiguity) had the same direction bug and
    *was* fixed: see `docs/codegen-patterns.md`.
    """
    found: dict[int, list[int]] = {}
    classes = form_classes_by_segment(image)
    for segment in image.program_segments():
        for function in discover(segment, classes.get(segment.index, [])):
            for ins in procedure_body(segment, function):
                for position, operand in enumerate(ins.operands):
                    if operand.type != capstone.x86.X86_OP_MEM:
                        continue
                    # both forms count: `[di + 0x6F04]` and `[0x6F04]`. An address
                    # reached only the second way is invisible to a scan that asks
                    # for the first (round 143: `0x6F04` has 80 of one and 32 of
                    # the other, and the register-relative list missed it).
                    address = (operand.mem.disp or 0) & 0xFFFF
                    # a `bp`-relative operand is a stack local, and a negative
                    # displacement folded into an unsigned one lands past the
                    # segment (round 144: `[bp - 0x402]` reads as `0xFBFE`)
                    if operand.mem.base == capstone.x86.X86_REG_BP:
                        continue
                    if address > 0x7786:
                        continue
                    entry = found.setdefault(address, [0, 0])
                    entry[0 if position else 1] += 1
    return {address: (reads, stores) for address, (reads, stores) in found.items()}


def read_only_globals(image) -> dict[int, tuple[int, int]]:
    """The data segment's displacements with their read and store counts."""
    if not hasattr(image, "segments"):
        image = Image(Path(image))
    return _memo("read_only_globals", image, lambda: _read_only_uncached(image))


def _sound_commands_uncached(image) -> dict[int, set[int]]:
    """per segment, the sound command numbers it passes to 20:0x30B6.

    The offset alone is ambiguous (`0x30B6` exists in other segments), so a site
    counts only when the target segment is 20, or the operand is a relocation
    placeholder and the command is one the sound table has (1..42).
    """
    found: dict[int, set[int]] = {}
    classes = form_classes_by_segment(image)
    for index, segment in enumerate(image.segments):
        if index > 24:
            continue
        for function in discover(segment, classes.get(index, [])):
            body = list(
                procedure_body(segment, function)
            )
            for position, ins in enumerate(body):
                call = re.fullmatch(r"(0x[0-9a-f]+), 0x30b6", ins.op_str)
                if ins.mnemonic != "lcall" or not call or position == 0:
                    continue
                pushed = re.fullmatch(
                    r"push (\d+|0x[0-9a-f]+)",
                    f"{body[position - 1].mnemonic} {body[position - 1].op_str}",
                )
                if not pushed:
                    continue
                command = int(pushed.group(1), 0)
                target = int(call.group(1), 16)
                if target == 20 or (target > 0xFF and 1 <= command <= 42):
                    found.setdefault(index, set()).add(command)
    return found


def sound_commands(image) -> dict[int, set[int]]:
    """Per segment, the sound commands it issues through `20:0x30B6`."""
    if not hasattr(image, "segments"):
        image = Image(Path(image))
    return _memo("sound_commands", image, lambda: _sound_commands_uncached(image))


def _object_types_uncached(image) -> dict:
    """Loads of `Obj[i].type` (`+0x17`) and the values they are compared against.

    One implementation on purpose: two ad-hoc scans of the same pattern in round
    179 disagreed about the vocabulary, because a window of three instructions
    and a `break` interact differently depending on where the scan starts.
    """
    units: dict[int, int] = {}
    values: dict[int, int] = {}
    per_segment: dict[int, list[int]] = {}
    classes = form_classes_by_segment(image)
    for index, segment in enumerate(image.segments):
        if index > 24:
            continue
        for function in discover(segment, classes.get(index, [])):
            body = list(
                procedure_body(segment, function)
            )
            for position, ins in enumerate(body):
                if ins.mnemonic != "mov" or "es:[di + 0x17]" not in ins.op_str:
                    continue
                units[index] = units.get(index, 0) + 1
                for later in body[position + 1 : position + 4]:
                    match = re.fullmatch(
                        r"cmp (al|ax), (0x[0-9a-f]+|\d+)",
                        f"{later.mnemonic} {later.op_str}",
                    )
                    if match:
                        value = int(match.group(2), 0)
                        values[value] = values.get(value, 0) + 1
                        per_segment.setdefault(index, []).append(value)
                        break
    return {"units": units, "values": values, "by_segment": per_segment}


def object_types(image) -> dict:
    """How often each unit loads `Obj[i].type`, and what it compares it with."""
    if not hasattr(image, "segments"):
        image = Image(Path(image))
    return _memo("object_types", image, lambda: _object_types_uncached(image))


def _segment_analysis_uncached(image, index) -> dict:
    """Everything the per-unit tests keep recomputing, for one program segment.

    Tests have hand-rolled this scan about seventy times, and in round 179 two of
    those hand-rolled scans of the same pattern disagreed with each other. The
    rule is the same one every time: disassemble each discovered function, count
    `[0xNNNN]` operands, count far calls by their target offset, and report the
    sizes.
    """
    import collections

    segment = image.segments[index]
    classes = form_classes_by_segment(image)
    functions = list(discover(segment, classes.get(index, [])))
    globals_seen: collections.Counter = collections.Counter()
    calls: collections.Counter = collections.Counter()
    segments_called: collections.Counter = collections.Counter()
    for function in functions:
        for ins in procedure_body(segment, function):
            for match in re.findall(r"\[(0x[0-9a-f]{1,4})\]", ins.op_str):
                globals_seen[int(match, 16)] += 1
            if ins.mnemonic == "lcall":
                target = re.search(r"(0x[0-9a-f]+|\d+)$", ins.op_str)
                if target:
                    calls[target.group(1)] += 1
    return {
        "segment": index,
        "functions": functions,
        "count": len(functions),
        "bytes": sum(function.size for function in functions),
        "globals": globals_seen,
        "calls": calls,
        "segments_called": segments_called,
    }


def segment_analysis(image, index: int) -> dict:
    """Sizes, global reads and far calls for one program segment."""
    if not hasattr(image, "segments"):
        image = Image(Path(image))
    return _memo(("segment_analysis", index), image, lambda: _segment_analysis_uncached(image, index))


def _instruction_census_uncached(image, strides: int = 6) -> dict:
    """Whole-program counts of the codegen idioms the documents quote.

    One implementation for the same reason `object_types()` has one: the counts in
    `docs/codegen-patterns.md` were hand-written from a scan, and a scan over a
    subset looks exactly like a scan over the program.
    """
    import collections

    counts: collections.Counter = collections.Counter()
    stride_counts: collections.Counter = collections.Counter()
    x87 = {
        "fld", "fstp", "fild", "fistp", "fadd", "fsub", "fmul", "fdiv",
        "fcomp", "fsubp", "faddp", "fabs", "fchs", "fsqrt",
    }
    classes = form_classes_by_segment(image)
    for index, segment in enumerate(image.segments):
        if index > 24:
            continue
        for function in discover(segment, classes.get(index, [])):
            for ins in procedure_body(segment, function):
                text = f"{ins.mnemonic} {ins.op_str}"
                if ins.mnemonic == "enter":
                    counts["enter"] += 1
                elif text == "push bp":
                    counts["push bp"] += 1
                elif ins.mnemonic == "les":
                    counts["les"] += 1
                elif text == "xor ah, ah":
                    counts["xor ah, ah"] += 1
                elif ins.mnemonic == "adc":
                    counts["adc"] += 1
                elif ins.mnemonic == "jmp" and "cs:[" in ins.op_str:
                    counts["jump table"] += 1
                elif ins.mnemonic in x87:
                    counts["x87"] += 1
                if ins.mnemonic == "imul":
                    match = re.search(r", (0x[0-9a-f]+|\d+)$", ins.op_str)
                    if match:
                        stride_counts[int(match.group(1), 0)] += 1
    return {
        "counts": dict(counts),
        "strides": dict(sorted(stride_counts.items(), key=lambda kv: -kv[1])),
    }


def instruction_census(image, strides: int = 6) -> dict:
    """Counts of the codegen idioms, over every discovered function in 0..24.

    Every stride is returned, not the top few: the document's table quotes some of
    the smaller ones, and a census that stopped at six reported them as missing
    (round 187).
    """
    if not hasattr(image, "segments"):
        image = Image(Path(image))
    return _memo(("instruction_census", strides), image,
                 lambda: _instruction_census_uncached(image, strides))


def memory_displacement(ins, position: int = 0) -> int | None:
    """The displacement of a memory operand, whatever syntax capstone printed.

    Capstone prints displacements below `0x10` in **decimal** (`es:[di + 8]`) and
    the rest in hex (`es:[di + 0x17]`), which has made several scans in this project
    find nothing and conclude that a field is unused (rounds 188 and earlier). Any
    scan over memory operands should go through this function or through
    `capstone`'s operand fields rather than through a regular expression.

    The value is **signed**, as capstone gives it: `[bp - 9]` is -9, not 65527.
    Masking it to 16 bits is what turned a stack local into the address `0xFBFE`
    in round 144, so the mask is not applied here — a caller that wants an address
    applies `& 0xFFFF` itself.
    """
    memory = [
        operand for operand in ins.operands if operand.type == capstone.x86.X86_OP_MEM
    ]
    if position >= len(memory):
        return None
    return memory[position].mem.disp or 0


def disasm_first(body: list) -> str:
    """The first instruction of a disassembled procedure, as text.

    A procedure's opening instruction says how its frame is built: `push bp` for the
    push/mov form, `enter N, L` for the other. Scanners keep needing it.
    """
    if not body:
        return ""
    return f"{body[0].mnemonic} {body[0].op_str}".strip()


def frame_base(image, segment: int, offset: int) -> int | None:
    """The displacement of a function's **first argument**, or None if unknown.

    A near procedure's return address is two bytes, so its first argument is at
    `[bp+4]`; a far procedure's is four, so its first argument is `[bp+6]`. This
    project got that wrong twice in one direction and once in the other — rounds
    214 and 215 — because the offset was read off a disassembly without asking how
    the function is called.

    The evidence, in order: a `ret N` in the function's own bytes (N is the size of
    the arguments, so N > 0 means the frame is whatever the call form implies), then
    a `retf`/`ret` epilogue, then how its callers reach it (`call` -> 4,
    `lcall` -> 6). A function whose epilogue is shared (a `jmp` to a common exit) has
    no `ret` of its own, so the callers decide.
    """
    if not hasattr(image, "segments"):
        image = Image(Path(image))
    if not 0 <= segment < len(image.segments):
        return None
    call_forms: set[str] = set()
    classes = form_classes_by_segment(image)
    for index, seg in enumerate(image.segments):
        if index > 24:
            continue
        for other in discover(seg, classes.get(index, [])):
            for ins in engine().disasm(seg.data[other.offset : other.end], other.offset):
                if ins.mnemonic not in ("call", "lcall"):
                    continue
                target = ins.op_str.split(", ")[-1]
                if not target.startswith("0x"):
                    continue
                if int(target, 16) == offset and (index == segment or ins.mnemonic == "lcall"):
                    call_forms.add(ins.mnemonic)
            if other.offset == offset and index == segment:
                for ins in engine().disasm(seg.data[other.offset : other.end], other.offset):
                    if ins.mnemonic == "retf":
                        return 6
                    if ins.mnemonic == "ret":
                        break
    if call_forms == {"lcall"}:
        return 6
    if call_forms == {"call"}:
        return 4
    if not call_forms:
        return None
    return None


def argument_slot(index: int, base: int) -> int:
    """The displacement of argument `index` (1-based) for a frame `base`."""
    if index < 1:
        raise ValueError("arguments are numbered from 1")
    return base + 2 * (index - 1)


def call_pushes(body: list, position: int) -> list[str]:
    """The `push` operands of the block that ends at `body[position]`, argument 1 first.

    A call's arguments are computed in the block in front of it, so counting
    backwards from the call until a control-flow boundary is the only reliable way
    to see them: an earlier attempt stopped at the first instruction that was not a
    `push`, which cut the list short whenever a value was loaded between two
    pushes, and reported three different argument counts for three sites of the
    same routine (rounds 214-216).

    The boundary is the previous **call** or return: arguments are set up fresh
    after one, and a branch in between does not move a value. Stopping at a branch
    instead was the first version and it cut the sequence short at some sites — the
    constructor `17:0x0025` came out with three different argument counts from its
    39 calls (19, 17 and 13) — while stopping only at a call to a *different*
    target merged consecutive calls into one (counts of 38, 57 and 55, which are two
    and three times 19).
    """
    boundaries = {"call", "lcall", "ret", "retf"}
    pushed: list[str] = []
    cursor = position - 1
    while cursor >= 0:
        ins = body[cursor]
        if ins.mnemonic in boundaries:
            break
        if ins.mnemonic == "push":
            pushed.append(ins.op_str)
        cursor -= 1
    pushed.reverse()
    return pushed


def address_taken_globals(image: Image | None = None) -> dict[int, list[str]]:
    """Data-segment addresses the code passes **by address**, and where.

    Delphi 1 passes a `var` parameter as the address of the variable: the source
    `Foo(x)` with `var x` compiles to

        mov di, 0x6F04      ; the address of x
        push ds
        push di
        ...                 ; and the object's far pointer as the second argument
        lcall ...

    so the variable is written by the *callee*, through the pointer, and no
    displacement-based store scan can see it. This is why round 143's list of
    addresses "no program unit stores to" was an artefact for many of its entries
    (round 237): 477 data-segment addresses are taken this way.
    """
    import re as _re

    image = image or Image(ORIGINAL)
    found: dict[int, list[str]] = {}
    for index, segment in enumerate(image.segments):
        if index > 34:
            continue
        body = list(engine().disasm(segment.data, 0))
        for position, ins in enumerate(body):
            match = _re.fullmatch(r"mov (?:di|si|bx|ax), (0x[0-9a-f]+)",
                                  f"{ins.mnemonic} {ins.op_str}")
            if not match:
                continue
            address = int(match.group(1), 16)
            if not 0x1000 <= address <= 0x7786:
                continue
            window = [f"{later.mnemonic} {later.op_str}" for later in body[position : position + 5]]
            if any("push ds" in line for line in window):
                found.setdefault(address, []).append(f"seg{index}:{ins.address:#06x}")
    return found


_MEMO: dict[tuple, object] = {}


def _memo(name: str, image, produce):
    """Memoise analysis by loaded file path and content digest.

    Anonymous segments are not cached. Rebuilding the same path with new bytes
    produces a different key. The digest is computed once by Image.

    Each of these walks every discovered procedure and disassembles it, which is
    seconds apiece; the generators, the documents and the tests ask for the same
    ones repeatedly (the suite went from ten minutes to four with this).
    """
    image_key = getattr(image, "cache_key", None)
    if image_key is None:
        return produce()
    key = (name, image_key)
    if key not in _MEMO:
        _MEMO[key] = produce()
    return _MEMO[key]


def datamap(image=None):
    if image is None:
        image = Image(ORIGINAL)
    elif not hasattr(image, "segments"):
        image = Image(Path(image))
    return _memo("datamap", image, lambda: _datamap_uncached(image))


def _datamap_uncached(image: Image | None = None) -> tuple[dict[int, dict], int]:
    """DGROUP as the whole program sees it: every address any segment reaches.

    DGROUP is one segment that allocates more than the file stores (see
    `Segment.bss`), so an address is either **initialized** — its bytes are in
    the image and have to be reproduced for a byte-identical rebuild — or
    **BSS**: allocated at load, zero-filled, and therefore invisible to the
    file.  `segments` is the set of program segments touching the address,
    which is the only ownership a shared data segment preserves.

    Returns `(address -> entry, dropped)`.  A reference above the segment's
    allocation cannot be a DGROUP address, so it is dropped and counted: in
    this image they are `call word ptr [0x9a57]`-shaped, eleven of them, which
    is a misdecode rather than a global.
    """
    image = image or Image(ORIGINAL)
    data_segment = image.data_segment()
    alloc = data_segment.alloc
    classes = form_classes_by_segment(image)
    out: dict[int, dict] = {}
    dropped = 0
    for segment in image.program_segments():
        functions = discover(segment, classes.get(segment.index, []))
        for address, entry in globals_census(functions, segment).items():
            if address >= alloc:
                dropped += len(entry["readers"]) + len(entry["writers"])
                continue
            merged = out.setdefault(
                address,
                {
                    "width": 0,
                    "widths": set(),
                    "readers": set(),
                    "writers": set(),
                    "segments": set(),
                },
            )
            merged["widths"] |= entry["widths"]
            merged["width"] = max(merged["width"], entry["width"])
            merged["readers"] |= entry["readers"]
            merged["writers"] |= entry["writers"]
            merged["segments"].add(segment.index)
    for address, entry in out.items():
        entry["bss"] = address >= len(data_segment.data)
    return out, dropped


def heap_allocations(
    image: Image | None = None, segment: int = 17, offset: int = 0x868C, length: int = 160
) -> list[tuple[int, int]]:
    """The program's startup allocations as `(size, global)`.

    Delphi 1 allocates through the System wrapper at `33:0182`: `push <size>`
    is followed by the call and by two stores of the returned far pointer,
    `mov [g],ax` and `mov [g+2],dx`.  Reading those pairs names the game's
    global heap state — the buffer sizes are the arrays' shapes.
    """
    image = image or Image(ORIGINAL)
    md = engine()
    data = image.segments[segment].data[offset : offset + length]
    out: list[tuple[int, int]] = []
    pending: int | None = None
    for ins in md.disasm(data, offset):
        if ins.mnemonic == "push" and re.fullmatch(r"0x[0-9a-f]+", ins.op_str):
            pending = int(ins.op_str, 16)
        match = re.search(r"\[(0x[0-9a-f]+)\], ax", ins.op_str)
        if match and pending is not None:
            out.append((pending, int(match.group(1), 16)))
            pending = None
    return out


def inventory(function: Function, segment: Segment) -> dict[str, object]:
    """What one procedure touches: the calls it makes and the data it reads.

    This is the working list for a unit: an entry with no calls and one data
    reference is a leaf; a procedure called from many places is a shared
    helper.  Both facts come from the bytes, not from the reconstruction.
    """
    calls: list[tuple[str, int, int]] = []
    data: set[str] = set()
    for ins in procedure_body(segment, function):
        if ins.mnemonic in ("call", "lcall"):
            immediates = [o.imm for o in ins.operands if o.type == 2]
            if ins.mnemonic == "call" and immediates:
                calls.append(("call", function.segment, immediates[0]))
            elif len(immediates) >= 2:
                calls.append(("call", immediates[0] - 1, immediates[1]))
        data.update(m.group(1) for m in DATA_REF.finditer(ins.op_str))
    return {"calls": calls, "data": sorted(data)}


# --- rendering ------------------------------------------------------------


def fixup_sites(ne: NeImage) -> list[list[int]]:
    """Source offset of every fixup record, per segment, in record order.

    rebrew 6.15.0's `NeFixup` dropped `source_offset` (56acc207); the
    record still carries it, bytes 2-3 of each 8-byte record, which the
    loader's `<BB2xHH` now skips as `2x`.  Emit chains, atype conversion
    and coverage all need the pointer site, so this reads those bytes with
    the loader's own block layout on an image `fixups()` has validated.
    """
    sites: list[list[int]] = []
    for segment in ne.segment_records:
        if not segment.on_disk:
            sites.append([])
            continue
        start = segment.file_offset + segment.length
        count = struct.unpack_from("<H", ne.data, start)[0]
        sites.append([struct.unpack_from("<H", ne.data, start + 4 + i * 8)[0]
                      for i in range(count)])
    return sites


def relocation_records(image: Image) -> list[tuple[int, int, int, int, int, int]]:
    """Native fixups from the shared validated NE inventory (zero-based source segment)."""
    sites = fixup_sites(image.native)
    return [(i, f.address_type, f.relocation_type, sites[i][n], f.target, f.addend)
            for i in range(image.seg_count)
            for n, f in enumerate(image.native.fixups(i))]


def relocation_form(image: Image | None = None) -> dict:
    """How an image encodes a far pointer, and what that costs it.

    Two forms exist for a direct far call `9A off16 seg16`:

    * **resolved** — the file holds the callee's offset and the segment word is
      left to an atype-2 (segment word) fixup.  This is the original's form.
    * **unresolved** — the file holds `FFFF 0000` and the linker emits an
      atype-3 (far address) fixup instead.  Every image this project's
      toolchain produces has this form, from the 221696-byte rebuild down to a
      15-line test program, and no compiler switch changes it.

    Returns the counts that tell them apart; `docs/link-form.md` explains what
    the difference costs a byte-identical rebuild.
    """
    image = image or Image(ORIGINAL)
    records = relocation_records(image)
    kinds = Counter((atype, rtype) for _seg, atype, rtype, _o, _t, _a in records)
    by_segment: dict[int, set[tuple[int, int]]] = {}
    for segment, atype, _rtype, offset, _target, _addend in records:
        by_segment.setdefault(segment, set()).add((offset, atype))
    classes = form_classes_by_segment(image)
    sites = unresolved = segment_fixups = far_fixups = 0
    for segment in image.segments:
        positions = by_segment.get(segment.index, set())
        seen: set[int] = set()
        for function in discover(segment, classes.get(segment.index, [])):
            for ins in procedure_body(segment, function):
                if ins.address in seen or ins.mnemonic != "lcall":
                    continue
                seen.add(ins.address)
                if len(ins.operands) < 2:
                    continue  # indirect, e.g. lcall es:[di+0x30]
                sites += 1
                raw = segment.data[ins.address + 1 : ins.address + 5]
                if len(raw) == 4 and int.from_bytes(raw[:2], "little") == 0xFFFF:
                    unresolved += 1
                if (ins.address + 1, 3) in positions:
                    far_fixups += 1
                if (ins.address + 3, 2) in positions:
                    segment_fixups += 1
    return {
        "kinds": kinds,
        "records": len(records),
        "sites": sites,
        "unresolved": unresolved,
        "far_fixups": far_fixups,
        "segment_fixups": segment_fixups,
    }


def render(function: Function, segment: Segment, limit: int = 40) -> str:
    body = procedure_body(segment, function)
    lines = [
        f"{function.segment:04X}:{function.offset:04X} "
        f"{function.name or '<unidentified>'}  ; {function.size} bytes"
        + ("  [published]" if function.published else "")
    ]
    count = 0
    for ins in body:
        lines.append(f"    {ins.address:04X}  {ins.mnemonic:8} {ins.op_str}")
        count += 1
        if count >= limit:
            lines.append("    ...")
            break
    return "\n".join(lines)


def jump_tables(image: Image | None = None) -> list[dict]:
    """Every `jmp word ptr cs:[bx + table]` in the program, with its bound.

    The compiler emits a `case` over a byte range as a word table in the code
    segment reached through a `cs:` override.  Finding them all is how a state
    machine is located without reading every procedure: 62 of them are in the
    program segments, and the ones with a `cmp`/`ja` bound in front are the
    complete dispatches (`docs/object-types.md`).
    """
    image = image or Image(ORIGINAL)
    classes = form_classes_by_segment(image)
    out = []
    for segment in image.program_segments():
        for function in discover(segment, classes.get(segment.index, [])):
            insns = list(
                procedure_body(segment, function)
            )
            for index, ins in enumerate(insns):
                if ins.mnemonic != "jmp" or "cs:[" not in ins.op_str:
                    continue
                match = re.search(r"\[bx \+ (0x[0-9a-f]+)\]", ins.op_str)
                if match is None:
                    continue
                table = int(match.group(1), 16)
                bound = base = None
                for earlier in reversed(insns[max(0, index - 40) : index]):
                    # note: `op_str` carries the operands only, no mnemonic
                    if earlier.mnemonic == "sub" and base is None:
                        found = re.search(r"(?:al|ax), (0x[0-9a-f]+|\d+)$", earlier.op_str)
                        if found:
                            text = found.group(1)
                            base = int(text, 16) if text.startswith("0x") else int(text)
                    if earlier.mnemonic == "cmp":
                        found = re.search(r"(?:al|ax), (0x[0-9a-f]+|\d+)$", earlier.op_str)
                        if found:
                            text = found.group(1)
                            bound = int(text, 16) if text.startswith("0x") else int(text)
                            break
                count = bound + 1 if bound is not None else None
                entries = (
                    [
                        struct.unpack_from("<H", segment.data, table + 2 * i)[0]
                        for i in range(count)
                    ]
                    if count
                    else []
                )
                out.append(
                    {
                        "segment": segment.index,
                        "procedure": function.offset,
                        "site": ins.address,
                        "table": table,
                        "base": base,
                        "bound": bound,
                        "count": count,
                        "handlers": len(set(entries)),
                        "entries": entries,
                    }
                )
    return out


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--original", type=Path, default=ORIGINAL)
    ap.add_argument("--segment", type=int, default=11, help="which program segment")
    ap.add_argument("--disasm", action="store_true", help="print the disassembly")
    ap.add_argument(
        "--patterns", action="store_true", help="print the codegen catalogue"
    )
    ap.add_argument(
        "--all", action="store_true", help="discover functions in every program segment"
    )
    ap.add_argument(
        "--inventory",
        action="store_true",
        help="list every procedure with its calls and the data it references",
    )
    ap.add_argument(
        "--globals",
        action="store_true",
        help="census the absolute data addresses the code reaches",
    )
    ap.add_argument(
        "--calls",
        action="store_true",
        help="rank the program's far calls by callee offset and infer the target",
    )
    ap.add_argument(
        "--datamap",
        action="store_true",
        help="census DGROUP across every segment: initialized vs BSS",
    )
    ap.add_argument(
        "--tables",
        action="store_true",
        help="every cs-relative jump table, with its bound and handler count",
    )
    ap.add_argument(
        "--prologues",
        action="store_true",
        help="how many entry-scan candidates are really entry points",
    )
    ap.add_argument(
        "--reloc",
        action="store_true",
        help="which far-pointer form this image carries (see docs/link-form.md)",
    )
    ap.add_argument("--limit", type=int, default=40)
    args = ap.parse_args()

    image = Image(args.original)
    classes = form_classes_by_segment(image)
    if args.tables:
        tables = jump_tables(image)
        bounded = [row for row in tables if row["count"]]
        print(
            f"{len(tables)} cs-relative jump tables; {len(bounded)} with a bound "
            f"in front, {len(tables) - len(bounded)} whose bound was not found"
        )
        for row in sorted(bounded, key=lambda r: -r["count"])[:15]:
            print(
                f"  seg{row['segment']:2d} proc{row['procedure']:#06x} "
                f"table={row['table']:#06x} base={row['base']} "
                f"count={row['count']} handlers={row['handlers']}"
            )
        return 0
    if args.prologues:
        raw = kept = 0
        for segment in image.program_segments():
            for function in discover(segment, classes.get(segment.index, []), False):
                raw += 1
                if plausible_entry(segment, function.offset, function.published):
                    kept += 1
        print(
            f"entry-scan candidates: {raw}; plausible entry points: {kept}; "
            f"rejected {raw - kept} ({100 * (raw - kept) / raw:.0f}%)"
        )
        print(
            f"an `enter` frame is accepted up to nesting {MAX_NESTING} and "
            f"frame size {MAX_FRAME:#06x}"
        )
        return 0
    if args.reloc:
        form = relocation_form(image)
        print(
            f"{args.original}: {form['sites']} direct far-call sites, "
            f"{form['unresolved']} with an unresolved (0xFFFF) offset"
        )
        print(f"  relocation records: {form['records']}")
        for (atype, rtype), count in sorted(form["kinds"].items()):
            print(f"    atype={atype} rtype={rtype}: {count}")
        print(
            f"  fixups landing on a call: atype-2 segment {form['segment_fixups']}, "
            f"atype-3 far address {form['far_fixups']}"
        )
        return 0 if form["unresolved"] == 0 else 1
    if args.calls:
        census, indirect = far_calls(image)
        likely = resolved_targets(image, census)
        sites = sum(e["sites"] for e in census.values())
        named_sites = sum(e["sites"] for o, e in census.items() if o in likely)
        print(
            f"far calls: {len(census)} distinct callee offsets over {sites} direct "
            f"sites plus {indirect} indirect (virtual) sites; "
            f"{len(likely)} offsets name one segment "
            f"({named_sites} of {sites} direct sites, {100 * named_sites / sites:.0f}%)"
        )
        for offset, entry in sorted(
            census.items(), key=lambda kv: -kv[1]["sites"]
        )[: args.limit]:
            target = likely.get(offset)
            where = f"seg {target:2d}" if target is not None else "     ?"
            candidates = ",".join(str(s) for s in entry["candidates"]) or "-"
            context = " ; ".join(entry["context"].most_common(1)[0][0])
            print(
                f"  {offset:04X} x{entry['sites']:4d} "
                f"callers={len(entry['callers']):2d} target={where} "
                f"cand={candidates:12} | {context}"
            )
        return 0
    if args.datamap:
        census, dropped = datamap(image)
        segment = image.data_segment()
        initialized = [a for a, e in census.items() if not e["bss"]]
        bss = [a for a, e in census.items() if e["bss"]]
        print(
            f"DGROUP segment {segment.index + 1}: {len(segment.data)} bytes in the "
            f"file, {segment.alloc} allocated, {segment.bss} BSS"
        )
        print(
            f"{len(census)} distinct addresses reached: {len(initialized)} initialized, "
            f"{len(bss)} BSS; {dropped} references above the allocation dropped"
        )
        for address, entry in sorted(
            census.items(),
            key=lambda kv: -(len(kv[1]["readers"]) + len(kv[1]["writers"])),
        )[: args.limit]:
            where = "bss" if entry["bss"] else "dat"
            widths = "+".join(str(w) for w in sorted(entry["widths"]))
            print(
                f"  0x{address:04X} {where} width={widths:3} "
                f"reads={len(entry['readers']):3d} writes={len(entry['writers']):3d} "
                f"segments={','.join(str(s) for s in sorted(entry['segments']))}"
            )
        return 0
    if args.all:
        total = 0
        for segment in image.program_segments():
            found = discover(segment, classes.get(segment.index, []))
            named = sum(1 for f in found if f.name)
            total += len(found)
            print(
                f"segment {segment.index:2d} {len(segment.data):6d} bytes: "
                f"{len(found):3d} procedures, {named:3d} named"
            )
        print(f"total {total} procedures in the program's 25 segments")
        return 0

    segment = image.segments[args.segment]
    for cls in classes.get(args.segment, []):
        for name, offset in published_methods(segment, cls):
            print(f"published {cls}.{name} -> {segment.index:04X}:{offset:04X}")
    functions = discover(segment, classes.get(args.segment, []))
    if args.inventory:
        print(f"inventory, segment {args.segment} ({len(functions)} procedures):")
        for function in functions:
            facts = inventory(function, segment)
            marker = "*" if function.published else " "
            print(
                f" {marker} {function.offset:04X} {function.size:5d} "
                f"{(function.name or ''):34} calls={len(facts['calls']):3d} "
                f"data={len(facts['data']):3d}"
            )
    if args.disasm:
        for function in functions[: args.limit]:
            print(render(function, segment, args.limit))
            print()
    if args.patterns:
        counts = patterns(functions, segment)
        print(
            "codegen pattern catalogue (segment "
            f"{args.segment}, {len(functions)} procedures):"
        )
        for key, value in sorted(counts.items(), key=lambda kv: -kv[1]):
            print(f"  {key:18} {value:6d}")
        print()
        print("pattern glossary:")
        for key, note in PATTERN_NOTES.items():
            print(f"  {key:10} {note}")
    if args.globals:
        census = globals_census(functions, segment)
        print(f"globals, segment {args.segment} ({len(census)} absolute addresses):")
        ranked = sorted(
            census.items(),
            key=lambda kv: -(len(kv[1]["readers"]) + len(kv[1]["writers"])),
        )
        for address, entry in ranked[: args.limit]:
            widths = "+".join(str(w) for w in sorted(entry["widths"]))
            print(
                f"   0x{address:04X}  width={widths:3} "
                f"reads={len(entry['readers']):3d} writes={len(entry['writers']):3d}"
            )
    if not (args.disasm or args.patterns or args.inventory or args.globals):
        print(f"segment {args.segment}: {len(functions)} procedures")
        for function in functions:
            marker = "*" if function.published else " "
            print(
                f" {marker} {function.offset:04X} {function.size:5d}  {function.name or ''}"
            )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
