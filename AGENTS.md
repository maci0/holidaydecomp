# Project rules

- Keep the Python, uv and Rebrew pins. This is a separate tool project from the
  Python 3.13 game clones in openholiday.
- Run `make check` before publishing. Native integration checks require local
  reference and rebuilt images; do not describe skipped checks as verified.
- Never commit original game files, extracted forms/data, compiler binaries,
  generated Pascal/resource output, raw dumps or old research archives.
- Run `uv run --frozen python tools/check_publication.py` against staged files.
- `tools/gen_tree.py` owns Pascal generation. Use `tools/patch_gen_tree.py` for
  anchored edits and `tools/regen_build_compare.py` for the locked build flow.
- Preserve native stack slots, field widths, signedness, branches and near/far
  returns. Masked matches are not raw byte equality. Unknown semantics stay
  explicit; do not invent roots or callees to improve a score.
- Keep all task and commit text free of attribution to automated assistants.
