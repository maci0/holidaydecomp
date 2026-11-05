import unittest
import re
import struct
from pathlib import Path
ROOT = Path(__file__).resolve().parent.parent
ORIGINAL = ROOT / 'original/holiday.exe'
REBUILT = ROOT / 'bin/main/HOLIDAY.EXE'

def _image():
    import decompile
    return decompile.Image(ORIGINAL)

@unittest.skipUnless(ORIGINAL.is_file() and REBUILT.is_file(), 'local original and rebuilt images required')
class NativeRecoveryTest(unittest.TestCase):

    @unittest.skipUnless(ORIGINAL.is_file() and REBUILT.is_file(), 'native and rebuilt binaries required')
    def test_build_menu_keyboard_binds_its_native_receiver_helper(self) -> None:
        import decompile
        from rebrew.formats import ne_loader
        native, rebuilt = (_image(), decompile.Image(REBUILT))
        matches = [(section, offset) for section in rebuilt.segments for name, offset in decompile.published_methods(section, 'TBaumenue') if name == 'FormKeyDown']
        self.assertEqual(len(matches), 1)
        section, start = matches[0]
        _, native_header = ne_loader.read_ne_header(native.data)
        _, built_header = ne_loader.read_ne_header(rebuilt.data)
        original_data = native.segments[native_header.autodata_segment - 1]
        rebuilt_data = rebuilt.segments[built_header.autodata_segment - 1]
        helper = None
        for offset, size in ((12944, 192), (11377, 46)):
            reference = native.segments[3].at(offset, size)
            instructions = list(decompile.engine().disasm(reference, 0))
            self.assertEqual(sum((ins.size for ins in instructions)), size)
            addresses = {byte for ins in instructions if ins.mnemonic == 'lcall' for byte in range(ins.address + 1, ins.address + 5)}
            for ins in instructions:
                if ins.disp in (5317, 5329):
                    self.assertEqual(ins.disp_size, 2)
                    addresses.update(range(ins.address + ins.disp_offset, ins.address + ins.disp_offset + 2))
            if offset == 11377:
                self.assertIsNotNone(helper)
                section, start = (rebuilt.segments[helper[0]], helper[1])
            actual = section.at(start, size)
            self.assertEqual([(byte, value) for byte, value in enumerate(reference) if byte not in addresses], [(byte, value) for byte, value in enumerate(actual) if byte not in addresses])
            records = {row[3]: row for row in decompile.relocation_records(rebuilt) if row[0] == section.index}
            for ins in instructions:
                if offset == 12944 and ins.mnemonic == 'lcall' and (ins.operands[1].imm == 11377):
                    record = records[start + ins.address + 1]
                    self.assertEqual(record[1:3], (3, 0))
                    destination = (record[4] - 1, record[5])
                    if helper is None:
                        helper = destination
                    self.assertEqual(destination, helper)
                if ins.disp in (5317, 5329):
                    operand = ins.address + ins.disp_offset
                    address = int.from_bytes(actual[operand:operand + 2], 'little')
                    self.assertEqual(address - ins.disp, 206)
                    self.assertEqual(original_data.at(ins.disp, 12), rebuilt_data.at(address, 12))

    @unittest.skipUnless(ORIGINAL.is_file() and REBUILT.is_file(), 'native and rebuilt binaries required')
    def test_key_and_hide_handlers_preserve_argument_bytes(self) -> None:
        import decompile
        native, rebuilt = (_image(), decompile.Image(REBUILT))
        for owner, name, segment, size in (('TKompassform', 'FormKeyDown', 7, 33), ('TFernseher', 'FormHide', 9, 35)):
            with self.subTest(method=f'{owner}.{name}'):
                start = dict(decompile.published_methods(native.segments[segment], owner))[name]
                reference = native.segments[segment].at(start, size)
                matches = [(section, offset) for section in rebuilt.segments for method, offset in decompile.published_methods(section, owner) if method == name]
                self.assertEqual(len(matches), 1)
                section, offset = matches[0]
                actual = section.at(offset, size)
                instructions = list(decompile.engine().disasm(reference, 0))
                self.assertEqual(sum((ins.size for ins in instructions)), size)
                addresses = {byte for ins in instructions if ins.mnemonic in ('call', 'lcall') for byte in range(ins.address + 1, ins.address + ins.size)}
                self.assertEqual([(byte, value) for byte, value in enumerate(reference) if byte not in addresses], [(byte, value) for byte, value in enumerate(actual) if byte not in addresses])

    @unittest.skipUnless(ORIGINAL.is_file() and REBUILT.is_file(), 'native and rebuilt binaries required')
    def test_native_instance_sizes_and_published_field_offsets(self) -> None:
        import decompile

        def layout(image, name):
            marker = bytes([len(name)]) + name.encode('latin1')
            candidates = [(segment, match.start()) for segment in image.segments for match in re.finditer(re.escape(marker), segment.data) if match.start() >= 148 and struct.unpack_from('<H', segment.data, match.start() - 148)[0] == match.start()]
            self.assertEqual(len(candidates), 1, name)
            segment, at = candidates[0]
            size = struct.unpack_from('<H', segment.data, at - 146)[0]
            table = struct.unpack_from('<H', segment.data, at - 154)[0]
            count = struct.unpack_from('<H', segment.data, table)[0]
            self.assertLess(count, 200)
            fields = {}
            pos = table + 4
            for _ in range(count):
                offset = struct.unpack_from('<H', segment.data, pos)[0]
                length = segment.data[pos + 4]
                field = segment.data[pos + 5:pos + 5 + length].decode('latin1')
                self.assertTrue(field.isidentifier())
                self.assertNotIn(field, fields)
                self.assertLessEqual(offset + 4, size)
                fields[field] = offset
                pos += 5 + length
            return (size, fields)
        native, rebuilt = (_image(), decompile.Image(REBUILT))
        for classes in decompile.form_classes_by_segment(native).values():
            for name in classes:
                with self.subTest(form=name):
                    self.assertEqual(layout(native, name), layout(rebuilt, name))

    @unittest.skipUnless(REBUILT.is_file(), 'rebuilt binary missing')
    def test_volume_and_activation_keep_native_code_and_imports(self) -> None:
        import decompile
        from rebrew.formats import ne_loader
        native, rebuilt = (_image(), decompile.Image(REBUILT))
        ne_offset, header = ne_loader.read_ne_header(rebuilt.data)
        modules = ne_loader.parse_imports(rebuilt.data, ne_offset, header)
        data = rebuilt.segments[header.autodata_segment - 1]
        for offset, size, gate, expected in ((9299, 105, 6, ('MMSYSTEM', 416)), (9551, 40, 5, ('WAVEMIX', 4))):
            with self.subTest(offset=hex(offset)):
                reference = native.segments[20].at(offset, size)
                instructions = list(decompile.engine().disasm(reference, 0))
                self.assertEqual(sum((ins.size for ins in instructions)), size)
                calls = [ins for ins in instructions if ins.mnemonic == 'lcall']
                addresses = {gate, gate + 1} | {byte for ins in calls for byte in range(ins.address + 1, ins.address + 5)}
                pattern = b''.join((b'.' if byte in addresses else re.escape(bytes([value])) for byte, value in enumerate(reference)))
                matches = [(section, match.start()) for section in rebuilt.segments for match in re.finditer(pattern, section.data, re.DOTALL)]
                self.assertEqual(len(matches), 1)
                section, start = matches[0]
                actual = section.at(start, size)
                flag = int.from_bytes(actual[gate:gate + 2], 'little')
                self.assertEqual(data.at(flag - 2, 6), bytes.fromhex('010000010028'))
                records = {row[3]: row for row in decompile.relocation_records(rebuilt) if row[0] == section.index}
                imported = records[start + calls[-1].address + 1]
                self.assertEqual(imported[1:3], (3, 1))
                self.assertEqual((modules[imported[4] - 1].module, imported[5]), expected)
                if offset == 9299:
                    multiplies = [records[start + ins.address + 1] for ins in calls[:-1]]
                    self.assertEqual(len({(row[4], row[5]) for row in multiplies}), 1)
                    self.assertTrue(all((row[1:3] == (3, 0) for row in multiplies)))
                    target = multiplies[0]
                    original_mul = native.segments[33].at(5284, 61)
                    built_mul = rebuilt.segments[target[4] - 1].at(target[5], 61)
                    self.assertEqual(original_mul[:2] + original_mul[4:], built_mul[:2] + built_mul[4:])

    @unittest.skipUnless(REBUILT.is_file(), 'rebuilt binary missing')
    def test_rebuilt_flag_refresh_preserves_non_call_bytes(self) -> None:
        import decompile
        rebuilt = decompile.Image(REBUILT)
        for offset, size in ((10974, 23), (10997, 70)):
            with self.subTest(offset=hex(offset)):
                native = _image().segments[2].at(offset, size)
                instructions = list(decompile.engine().disasm(native, 0))
                self.assertEqual(sum((ins.size for ins in instructions)), size)
                call_operands = {byte for ins in instructions if ins.mnemonic == 'lcall' for byte in range(ins.address + 1, ins.address + 5)}
                pattern = b''.join((b'.' if byte in call_operands else re.escape(bytes([value])) for byte, value in enumerate(native)))
                matches = [(segment.index, match.start()) for segment in rebuilt.segments for match in re.finditer(pattern, segment.data, re.DOTALL)]
                self.assertEqual(len(matches), 1, matches)
