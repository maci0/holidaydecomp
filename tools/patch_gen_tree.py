#!/usr/bin/env python3
"""Patch `tools/gen_tree.py` atomically, or not at all.

    python3 tools/patch_gen_tree.py .scratch/wrap-published.json
    python3 tools/patch_gen_tree.py .scratch/wrap-published.json --dry-run

A patch spec is a JSON file, read as data and never executed:

    {
      "why": "wrap the published declaration too, not only the header",
      "replacements": [
        {"anchor": "decls.append(f\"    {decl}\")",
         "replacement": "decls.extend(wrap_decl(decl, indent=\"    \").split(\"\\n\"))"}
      ]
    }

`why` is one sentence naming the change; each `anchor` must occur exactly once
in the file as its turn comes, so a stale or ambiguous anchor stops the patch
instead of rewriting the wrong line. The whole result is parsed with
`ast.parse` **and imported** before anything is written: a note whose quote
closes early leaves a bare name, which parses and then raises `NameError` at
module level, and only running the module sees that (seg16-20's patch passed
the syntax check and still killed the generator). The write is a single
`os.replace` of a temporary file in the same directory: a teammate gets a valid
`gen_tree.py` or the file they started with, never a half-written one.
The byte count printed after validation is the UTF-8 size that
reaches disk, the number `stat` reports, not the character count. Five
pipeline breaks on 2026-10-30 came from raw writes that left an unterminated
string literal in the generator.

The patch takes `.scratch/proj.lock` for its read-validate-write, so two patches
cannot lose each other and a patch cannot land under a running build. It locks
internally, like `tools/run_tests.py` and `tools/regen_build_compare.py`: never
wrap it in an outer `flock` (see `proj_lock.locked()`).

After a successful patch the generated tree is stale by construction; run
`python3 tools/regen_build_compare.py`.

Exit status: 0 written (or nothing written under `--dry-run`), 1 refused (anchor
count, parse failure, no change), 2 bad usage (missing or malformed spec).
"""

from __future__ import annotations

import argparse
import ast
import importlib.util
import json
import os
import subprocess
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

from proj_lock import locked, project_root  # noqa: E402

ROOT = project_root()
TARGET = ROOT / "tools" / "gen_tree.py"


class PatchRefused(Exception):
    """The patch did not apply; the file on disk is untouched."""


def load_spec(path: Path) -> dict:
    """The spec, or a usage error naming what the file is missing."""
    try:
        text = path.read_text(encoding="utf-8")
    except OSError as error:
        raise SystemExit(f"cannot read the patch spec {path}: {error.strerror}")
    try:
        spec = json.loads(text)
    except json.JSONDecodeError as error:
        raise SystemExit(f"{path} is not valid JSON: {error}")
    if not isinstance(spec, dict):
        raise SystemExit(f"{path}: the spec must be a JSON object")
    why = spec.get("why")
    if not isinstance(why, str) or not why.strip():
        raise SystemExit(f"{path}: `why` must be one sentence naming the change")
    replacements = spec.get("replacements")
    if not isinstance(replacements, list) or not replacements:
        raise SystemExit(f"{path}: `replacements` must be a non-empty list")
    for index, item in enumerate(replacements):
        if not isinstance(item, dict):
            raise SystemExit(f"{path}: replacement {index} must be an object")
        for key in ("anchor", "replacement"):
            value = item.get(key)
            if not isinstance(value, str) or not value:
                raise SystemExit(
                    f"{path}: replacement {index} needs a non-empty `{key}`")
    return spec


def apply(text: str, spec: dict) -> str:
    """The patched text, or `PatchRefused` naming what stopped it."""
    patched = text
    for index, item in enumerate(spec["replacements"]):
        anchor, replacement = item["anchor"], item["replacement"]
        count = patched.count(anchor)
        if count != 1:
            raise PatchRefused(
                f"replacement {index}: the anchor occurs {count} times, "
                f"expected exactly once:\n  {anchor}")
        patched = patched.replace(anchor, replacement, 1)
    if patched == text:
        raise PatchRefused("the replacements change nothing")
    try:
        ast.parse(patched)
    except SyntaxError as error:
        raise PatchRefused(f"the patched file does not parse: {error}")
    return patched


def write(target: Path, text: str) -> None:
    """One atomic replace: a reader sees the old file or the new one."""
    mode = target.stat().st_mode
    temporary = target.with_name(f".{target.name}.{os.getpid()}.tmp")
    try:
        with temporary.open("w", encoding="utf-8") as handle:
            handle.write(text)
            handle.flush()
            os.fsync(handle.fileno())
        os.chmod(temporary, mode)
        os.replace(temporary, target)
    finally:
        temporary.unlink(missing_ok=True)


def import_check(path: Path) -> int:
    """Exit status for `--import-check`: load the module and report what it raises.

    Runs in a subprocess of its own so a failing import never reaches the caller
    as anything but a status and one line on stderr.
    """
    spec = importlib.util.spec_from_file_location("gen_tree", path)
    if spec is None or spec.loader is None:
        print(f"cannot load {path}", file=sys.stderr)
        return 2
    module = importlib.util.module_from_spec(spec)
    try:
        spec.loader.exec_module(module)
    except BaseException as error:          # NameError, ImportError, SyntaxError, ...
        print(f"{type(error).__name__}: {error}", file=sys.stderr)
        return 1
    return 0


def import_failure(patched: str) -> str:
    """The import error for `patched`, or "" when the module imports cleanly.

    `ast.parse` accepts a note whose quote closes early: what follows becomes a
    bare name, which parses and then raises `NameError` at module level, which is
    how seg16-20's patch passed validation and killed the generator. Running the
    module is the only check that sees it, so the patched text is loaded in the
    pinned environment before anything is written to `gen_tree.py`.
    """
    check = ROOT / ".scratch" / "gen_tree-import-check.py"
    check.parent.mkdir(parents=True, exist_ok=True)
    check.write_text(patched, encoding="utf-8")
    try:
        result = subprocess.run(
            ["uv", "run", "--frozen", "--no-sync", "python", str(Path(__file__).resolve()),
             "--import-check", str(check)],
            cwd=ROOT, capture_output=True, text=True, timeout=180)
    except (FileNotFoundError, subprocess.TimeoutExpired) as error:
        check.unlink(missing_ok=True)
        return f"the import check could not run ({error}), so the patch is refused"
    check.unlink(missing_ok=True)
    if result.returncode == 0:
        return ""
    lines = [line for line in (result.stderr or result.stdout).splitlines() if line.strip()]
    return lines[-1] if lines else "the patched module failed to import"


def patch(target: Path, spec: dict, *, dry_run: bool = False) -> str:
    """The patched text, written unless `dry_run`; a refusal leaves `target` alone."""
    original = target.read_text(encoding="utf-8")
    patched = apply(original, spec)
    failure = import_failure(patched)
    if failure:
        raise PatchRefused(f"the patched module does not import: {failure}")
    if not dry_run:
        write(target, patched)
    return patched


def main(argv: list[str] | None = None) -> int:
    argv = list(sys.argv[1:] if argv is None else argv)
    if argv[:1] == ["--import-check"]:
        if len(argv) != 2:
            print("usage: patch_gen_tree.py --import-check PATH", file=sys.stderr)
            return 2
        return import_check(Path(argv[1]))
    parser = argparse.ArgumentParser(
        description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("spec", type=Path, help="JSON patch spec, usually under .scratch/")
    parser.add_argument("--dry-run", action="store_true",
                        help="validate and report without writing")
    args = parser.parse_args(argv)

    spec = load_spec(args.spec)
    try:
        with locked(ROOT):
            patched = patch(TARGET, spec, dry_run=args.dry_run)
    except PatchRefused as error:
        print(f"refused: {error}", file=sys.stderr)
        print(f"{TARGET} is unchanged", file=sys.stderr)
        return 1
    print(f"why: {spec['why']}")
    print(f"{len(spec['replacements'])} replacement(s), "
          f"{len(patched.encode('utf-8')):,} bytes after")
    if args.dry_run:
        print("dry run: nothing written")
        return 0
    print(f"wrote {TARGET}")
    print("the generated tree is now stale; run python3 tools/regen_build_compare.py")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
