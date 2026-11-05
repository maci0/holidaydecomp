import json
from pathlib import Path
import re
import tempfile
import unittest
from unittest.mock import patch

from rebrew.formats import dfm

import gen_forms
import gen_tree

ROOT = Path(__file__).resolve().parent.parent


class FormSourcesTest(unittest.TestCase):
    def test_invalid_reference_import_preserves_existing_model(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            directory = root / "src/main/forms"
            directory.mkdir(parents=True)
            model = directory / "layouts.json"
            model.write_text("existing source\n")
            (root / "original").mkdir()
            (root / "original/holiday.exe").write_bytes(b"invalid reference")
            with patch.object(gen_forms, "ROOT", root), patch.object(gen_forms, "DIRECTORY", directory), \
                    patch.object(gen_forms, "MODEL", model), patch.object(dfm, "parse_forms", return_value=[]), \
                    patch("sys.argv", ["gen_forms.py", "--import-reference", "--force"]):
                with self.assertRaises(ValueError):
                    gen_forms.main()
            self.assertEqual(model.read_text(), "existing source\n")

    def test_binary_property_is_omitted_without_mutating_reference(self):
        reference = dfm.Component("TForm", "Example", [("Left", dfm.Int8(1)), ("Icon.Data", dfm.Binary(b"image"))])
        omitted = []
        model = gen_forms.import_node(reference, omitted, "TForm")
        rebuilt = gen_forms.component(model)
        self.assertEqual([name for name, _ in rebuilt.props], ["Left"])
        self.assertEqual(omitted, [{"form": "TForm", "component": "Example", "property": "Icon.Data", "bytes": 5}])
        self.assertIsInstance(reference.props[1][1], dfm.Binary)
        with self.assertRaises(ValueError):
            gen_forms.component({"class": "TForm", "name": "Example", "children": [],
                                 "properties": [{"name": "Icon.Data", "wire_type": 10, "value": "payload"}]})

    def test_every_tracked_layout_roundtrips_and_matches_text(self):
        forms = gen_forms.load_forms()
        self.assertEqual({form.cls for form in forms}, set(gen_tree.FORM_ORDER))
        self.assertEqual(len(forms), 23)
        for form in forms:
            with self.subTest(form=form.cls):
                encoded = b"TPF0" + dfm.encode(form)
                parsed, end = dfm.parse_form(encoded)
                self.assertEqual(end, len(encoded))
                self.assertEqual(b"TPF0" + dfm.encode(parsed), encoded)
                self.assertEqual((gen_forms.DIRECTORY / f"{form.cls}.DFM").read_text(), dfm.render(parsed))
                self.assertFalse(any(isinstance(value, dfm.Binary) for node in parsed.walk() for _, value in node.props))
        self.assertNotIn(b"MAINICON", gen_forms.resource(forms))
        self.assertEqual(gen_forms.resource(forms).count(b"TPF0"), 23)

    def test_every_form_callback_has_a_pascal_implementation(self):
        for root in gen_forms.load_forms():
            file = ROOT / "src/main" / f"{gen_forms.unit_for_form(root.cls)}.PAS"
            text = file.read_text()
            for node in root.walk():
                for _, method in node.events():
                    with self.subTest(form=root.cls, method=method):
                        pattern = r"(?mi)^procedure\s+" + re.escape(f"{root.cls}.{method}") + r"\b"
                        self.assertTrue(re.search(pattern, text), f"Missing callback {root.cls}.{method} in {file.name}")
        index = gen_forms.render_index(gen_forms.load_forms())
        self.assertEqual(index, (gen_forms.DIRECTORY / "README.md").read_text())
        self.assertIn("MAIN.0x", index)
        data = json.loads(gen_forms.MODEL.read_text())
        self.assertEqual([(row["form"], row["property"]) for row in data["omitted_binary_properties"]], [("THauptschirm", "Icon.Data")])


class AddressCommentTest(unittest.TestCase):
    def test_annotations_use_delphi1_syntax_and_only_bind_implementations(self):
        source = "unit U;\ninterface\nprocedure P;\nimplementation\nprocedure P;\nbegin end;\nend.\n"
        rows = {("MAIN", 0x40010): {"file": "src/main/U.PAS", "symbol": "P"}}
        annotated = gen_tree.annotate_addresses(source, "src/main/U.PAS", rows)
        self.assertEqual(annotated.count("{ ADDRESS: MAIN 0x00040010 }"), 1)
        self.assertNotIn("ADDRESS", annotated.partition("\nimplementation\n")[0])
        self.assertNotIn("//", annotated)
        self.assertEqual(source, gen_tree.annotate_addresses(source, "src/main/OTHER.PAS", rows))
        with self.assertRaises(ValueError):
            gen_tree.annotate_addresses(source.replace("implementation\nprocedure P;", "implementation\nprocedure Q;"), "src/main/U.PAS", rows)


if __name__ == "__main__":
    unittest.main()
