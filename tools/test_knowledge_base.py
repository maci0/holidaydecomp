import json
from pathlib import Path
import tempfile
import unittest

import gen_docs_index


class KnowledgeBaseTest(unittest.TestCase):
    def test_local_links_and_anchors_are_checked_without_parsing_code_examples(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            target = root / "a note.md"
            target.write_text('# A heading\n\n## Repeated\n\n## Repeated\n\n<a id="explicit"></a>\n')
            page = root / "README.md"
            page.write_text('[ok](a%20note.md#a-heading)\n[duplicate](a%20note.md#repeated-1)\n'
                            '[explicit](a%20note.md#explicit)\n[external](https://example.invalid/page)\n'
                            '```md\n[example](does-not-exist.md)\n```\n')
            self.assertEqual(gen_docs_index.link_errors(page, root), [])
            page.write_text('[missing](absent.md)\n[bad heading](a%20note.md#wrong)\n')
            errors = gen_docs_index.link_errors(page, root)
            self.assertEqual(len(errors), 2)
            self.assertIn('missing local link', errors[0])
            self.assertIn('missing anchor', errors[1])

    def test_vault_initialization_preserves_personal_settings(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            gen_docs_index.init_vault(root)
            app = root / '.obsidian/app.json'
            self.assertTrue(json.loads(app.read_text())['useMarkdownLinks'])
            self.assertEqual(json.loads((root / '.obsidian/community-plugins.json').read_text()), [])
            app.write_text('{"personal": true}\n')
            gen_docs_index.init_vault(root)
            self.assertEqual(app.read_text(), '{"personal": true}\n')
            self.assertTrue((root / 'docs/assets').is_dir())

    def test_knowledge_map_and_curated_links_are_current(self):
        self.assertEqual(gen_docs_index.UNIT_INDEX.read_text(), gen_docs_index.render())
        errors = [error for path in gen_docs_index.document_paths() for error in gen_docs_index.link_errors(path)]
        self.assertEqual(errors, [])


if __name__ == '__main__':
    unittest.main()
