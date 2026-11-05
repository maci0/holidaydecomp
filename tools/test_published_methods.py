"""Regression checks for published method table decoding and NE references."""

import unittest
from unittest.mock import patch

import decompile
import gen_tree


class PublishedMethodTest(unittest.TestCase):
    def test_truncated_method_table_is_not_a_partial_result(self) -> None:
        marker = b"\x08TExample"
        for data in [marker, marker + b"\x01\x00", marker + b"\x01\x00\x10\x00\x00\x00\x04AB"]:
            with self.subTest(data=data):
                self.assertEqual(decompile.published_methods(decompile.Segment(0, data), "TExample"), [])

    def test_invalid_first_marker_does_not_hide_valid_table(self) -> None:
        marker = b"\x08TExample"
        data = marker + b"\x00\x00" + marker + b"\x01\x00\x10\x00\x00\x00\x04Test"
        self.assertEqual(decompile.published_methods(decompile.Segment(0, data), "TExample"), [("Test", 16)])

    def test_internal_pointer_resolution_without_build_artifact(self) -> None:
        data = b"\x08TExample\x01\x00\xff\xff\x00\x00\x04Test"
        image = decompile.Image.__new__(decompile.Image)
        segment = decompile.Segment(0, data, image=image)
        with patch.object(decompile, "relocation_records", return_value=[(0, 3, 0, 11, 1, 16)]):
            self.assertEqual(decompile.published_methods(segment, "TExample"), [("Test", 16)])
        with patch.object(decompile, "relocation_records", return_value=[(0, 3, 0, 11, 2, 16)]):
            self.assertEqual(decompile.published_methods(segment, "TExample"), [])

    @unittest.skipUnless((gen_tree.REPO / "build" / "HOLIDAY-empty-frame.EXE").is_file(), "compiled integration absent")
    def test_compiled_method_offset_uses_internal_relocation(self) -> None:
        image = decompile.Image(gen_tree.REPO / "build" / "HOLIDAY-empty-frame.EXE")
        found = []
        for segment in image.segments:
            for name, offset in decompile.published_methods(segment, "TGeldmenuform"):
                self.assertLess(offset, len(segment.data))
                if name == "MenuImageMouseMove":
                    self.assertEqual(segment.data[offset:offset+8], bytes.fromhex("c8020000c9ca0e00"))
                    found.append((segment.index, offset))
        self.assertEqual(len(found), 1)


if __name__ == "__main__":
    unittest.main()
