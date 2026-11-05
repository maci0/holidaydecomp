"""Checks for reconstructed background-form source emitted by the tree generator."""

import unittest

import gen_tree


class RecoveredBackgroundMethodsTest(unittest.TestCase):
    def test_emits_callback_signature_and_three_original_bodies(self) -> None:
        methods = {"THintergrund": ("AppOnActivate", "FormCreate", "FormActivate", "backgroundimageClick")}
        handlers = {"THintergrund": {"FormCreate": "OnCreate", "FormActivate": "OnActivate", "backgroundimageClick": "OnClick"}}
        declarations, bodies = gen_tree.class_block(("THintergrund",), {}, methods, handlers)
        self.assertIn("procedure AppOnActivate(Sender: TObject);", declarations)
        self.assertIn("Application.OnActivate := AppOnActivate;", bodies)
        self.assertIn("  AppOnActivate(Sender);", bodies)
        self.assertIn("  FilmPanelClick(Sender);", bodies)
        self.assertEqual(handlers["THintergrund"]["FormActivate"], "OnActivate")

    def test_onclose_has_reference_action_for_every_wired_class(self) -> None:
        declarations, _ = gen_tree.class_block(("TOther",), {}, {"TOther": ("FormClose",)},
                                               {"TOther": {"FormClose": "OnClose"}})
        self.assertIn("procedure FormClose(Sender: TObject; var Action: TCloseAction);", declarations)

    def test_background_close_releases_nine_owned_references(self) -> None:
        source = gen_tree.unit_source("THINTERG", 0, 16333, ("THintergrund",), "verified methods", ["Forms", "Classes"], ["MAP"],
                                      fields={}, methods={"THintergrund": ("FormClose",)},
                                      handlers={"THintergrund": {"FormClose": "OnClose"}})
        owner = gen_tree.unit_source("MAP", 22, 0, (), "shutdown reference owner", ["Classes"], [],
                                     fields={}, methods={}, handlers={})
        self.assertNotIn("ShutdownObjects: array", source)
        self.assertEqual(owner.count("ShutdownObjects: array[0..8] of TObject;"), 1)
        self.assertIn("ShutdownObjectCount = 9;", source)
        for index in range(9):
            self.assertIn(f"  ShutdownObjects[{index}].Free;", source)
        self.assertIn("  Action := caFree;", source)

    def test_four_minimal_close_handlers_set_free_action(self) -> None:
        for cls in ("TCreditform", "TLadenForm", "TPauseform", "TOptionenform"):
            with self.subTest(cls=cls):
                declarations, bodies = gen_tree.class_block((cls,), {}, {cls: ("FormClose",)},
                                                            {cls: {"FormClose": "OnClose"}})
                self.assertIn("var Action: TCloseAction", declarations)
                self.assertIn("  Action := caFree;", bodies)

    def test_main_form_close_has_four_private_references(self) -> None:
        fields = {"THauptschirm": (("Hauptbild", "TImage"), ("AnimationsTimer", "TTimer"))}
        declarations, bodies = gen_tree.class_block(("THauptschirm",), fields,
                                                   {"THauptschirm": ("FormClose",)},
                                                   {"THauptschirm": {"FormClose": "OnClose"}})
        self.assertEqual(declarations.count("CloseObjects: array[0..3] of TObject;"), 1)
        self.assertLess(declarations.index("AnimationsTimer: TTimer;"), declarations.index("CloseObjects:"))
        self.assertLess(declarations.index("CloseObjects:"), declarations.index("published"))
        for index in range(4):
            self.assertIn(f"  CloseObjects[{index}].Free;", bodies)
        self.assertIn("  Action := caFree;", bodies)

    def test_main_form_minimize_uses_application_with_sender(self) -> None:
        declarations, bodies = gen_tree.class_block(("THauptschirm",), {},
                                                   {"THauptschirm": ("MinimizeButtonClick",)}, {})
        self.assertIn("procedure MinimizeButtonClick(Sender: TObject);", declarations)
        self.assertIn("  Application.Minimize;", bodies)

    def test_original_empty_callbacks_are_recorded_as_recovered(self) -> None:
        callbacks = [("THauptschirm", "InselboxOkbuttonClick"), ("THauptschirm", "GlobalboxOkbuttonClick"),
                     ("TFernseher", "FormShow"), ("TStartform", "SprachButtonClick"),
                     ("TOptionenform", "FormShow"), ("TOptionenform", "FormHide")]
        for cls, method in callbacks:
            with self.subTest(cls=cls, method=method):
                self.assertEqual(gen_tree._RECOVERED_METHOD_BODIES[(cls, method)], "")
                declarations, bodies = gen_tree.class_block((cls,), {}, {cls: (method,)}, {})
                self.assertIn(f"procedure {method}(Sender: TObject);", declarations)
                self.assertNotIn("  Action :=", bodies)

    def test_global_info_click_calls_private_far_noop(self) -> None:
        declarations, bodies = gen_tree.class_block(("THauptschirm",), {},
                                                   {"THauptschirm": ("InfoboxGlobalbuttonClick",)}, {})
        self.assertIn("procedure GlobalInfo;", declarations)
        self.assertIn("procedure InfoboxGlobalbuttonClick(Sender: TObject);", declarations)
        self.assertIn("  GlobalInfo;", bodies)
        self.assertIn("procedure THauptschirm.GlobalInfo;\nbegin\nend;", bodies)

    def test_money_mousemove_preserves_unused_two_byte_frame(self) -> None:
        cls, method = "TGeldmenuform", "MenuImageMouseMove"
        declarations, bodies = gen_tree.class_block((cls,), {}, {cls: (method,)},
                                                   {cls: {method: "OnMouseMove"}})
        self.assertEqual(gen_tree._RECOVERED_METHOD_BODIES[(cls, method)], "")
        self.assertIn("Shift: TShiftState; X, Y: Integer", declarations)
        self.assertIn("var Reserved: Integer;\nbegin\nend;", bodies)

    def test_information_form_is_created_with_the_reconstructed_name(self) -> None:
        self.assertIn("TInfobox2", gen_tree.FORM_ORDER)
        self.assertEqual(gen_tree.segment_of_class("TInfobox2"), 7)
        self.assertEqual(gen_tree.form_variable("TInfobox2"), "FInfobox2")
        variables = "\n".join(
            f"  {gen_tree.form_variable(cls)}: {cls};" for cls in gen_tree.FORM_ORDER
        )
        self.assertIn("  FInfobox2: TInfobox2;", variables)
        creates = "\n".join(
            f"  Application.CreateForm({cls}, {gen_tree.form_variable(cls)});"
            for cls in gen_tree.FORM_ORDER
        )
        self.assertIn("  Application.CreateForm(TInfobox2, FInfobox2);", creates)

    def test_information_box_helper_clears_observed_flag(self) -> None:
        cls, method = "TInfobox2", "InfoimageMouseDown"
        declarations, bodies = gen_tree.class_block((cls,), {}, {cls: (method,)}, {})
        self.assertIn("    Infoimage: TImage;", declarations)
        self.assertIn("procedure InfoimageMouseDown(Sender: TObject;", declarations)
        self.assertIn("Button: TMouseButton; Shift: TShiftState; X, Y: Integer);", declarations)
        self.assertEqual(bodies, "\nprocedure TInfobox2.InfoimageMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);\nbegin\nend;\n")


    def test_unrecovered_body_stays_a_stub(self) -> None:
        _, bodies = gen_tree.class_block(("TOther",), {}, {"TOther": ("FormCreate",)}, {})
        self.assertEqual(bodies, "\nprocedure TOther.FormCreate;\nbegin\nend;\n")


if __name__ == "__main__":
    unittest.main()
