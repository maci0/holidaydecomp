"""Checks for decoding returns completed by declared zero-filled code tails."""

from pathlib import Path
import struct
import tempfile
import unittest

import decompile
import gen_tree


class CodeTailTest(unittest.TestCase):
    def test_declared_zero_byte_completes_far_return(self) -> None:
        physical = bytes.fromhex("5589e5c47e0a26c60502c9ca0c")
        segment = decompile.Segment(0, physical, alloc=len(physical) + 1)
        function = decompile.Function(0, 0, end=len(physical))
        body = decompile.procedure_body(segment, function)
        self.assertEqual((body[-1].mnemonic, body[-1].op_str), ("retf", "0xc"))
        self.assertEqual(segment.data, physical)
        self.assertEqual(function.size, len(physical))

    def test_no_zero_tail_without_allocation(self) -> None:
        physical = bytes.fromhex("5589e5c47e0a26c60502c9ca0c")
        segment = decompile.Segment(0, physical, alloc=len(physical))
        function = decompile.Function(0, 0, end=len(physical))
        self.assertNotIn("retf", [i.mnemonic for i in decompile.procedure_body(segment, function)])

    @unittest.skipUnless((gen_tree.REPO / "original" / "holiday.exe").is_file(), "original binary absent")
    def test_rebuilt_image_path_does_not_reuse_old_body(self) -> None:
        scratch = gen_tree.REPO / ".scratch"
        scratch.mkdir(exist_ok=True)
        data = (gen_tree.REPO / "original" / "holiday.exe").read_bytes()
        header = struct.unpack_from("<I", data, 0x3C)[0]
        alignment = 1 << struct.unpack_from("<H", data, header + 0x32)[0]
        code_start = struct.unpack_from("<H", data, header + 0x40)[0] * alignment
        function = decompile.Function(0, 0x2241, end=0x2254)
        with tempfile.TemporaryDirectory(dir=scratch) as directory:
            path = Path(directory) / "CHECK.EXE"
            path.write_bytes(data)
            first = decompile.Image(path)
            self.assertEqual(decompile.procedure_body(first.segments[0], function)[0].mnemonic, "push")
            changed = bytearray(data)
            changed[code_start + function.offset] = 0x90
            path.write_bytes(changed)
            rebuilt = decompile.Image(path)
            self.assertEqual(decompile.procedure_body(rebuilt.segments[0], function)[0].mnemonic, "nop")

    @unittest.skipUnless((gen_tree.REPO / "original" / "holiday.exe").is_file(), "original binary absent")
    def test_code_allocation_follows_header_minimum(self) -> None:
        image = decompile.Image(gen_tree.REPO / "original" / "holiday.exe")
        header = struct.unpack_from("<I", image.data, 0x3C)[0]
        checked = 0
        for index in range(image.seg_count):
            _, length, flags, minimum = struct.unpack_from("<HHHH", image.data, header + 0x40 + index * 8)
            if not flags & 1 and minimum == length:
                self.assertEqual(image.segments[index].alloc, length)
                checked += 1
        self.assertGreater(checked, 0)


if __name__ == "__main__":
    unittest.main()
