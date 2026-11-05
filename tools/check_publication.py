"""Reject game assets, generated output and research archives from publication."""
from __future__ import annotations

import ast
from pathlib import Path, PurePosixPath
import re
import subprocess
import sys

ROOT = Path(__file__).resolve().parent.parent
ROOT_FILES = {
    ".gitignore", ".python-version", "AGENTS.md", "README.md", "PUBLICATION.md",
    "PUBLICATION.json", "CHANGELOG.md", "Makefile", "build.sh", "verify.sh",
    "pyproject.toml", "uv.lock", "rebrew-project.toml",
}


def permitted(path: str) -> bool:
    p = PurePosixPath(path)
    return (
        path in ROOT_FILES
        or path == "assets/logo.png"
        or path == "templates/REACH.PAS"
        or path in {"src/main/function_structure.json", "src/main/function_merges.toml"}
        or (len(p.parts) == 2 and p.parts[0] == "tools" and p.suffix == ".py")
        or (p.parts[:2] == (".github", "workflows") and p.suffix in {".yml", ".yaml"})
    )


def main() -> int:
    staged = subprocess.check_output(["git", "ls-files", "-z"], cwd=ROOT).decode().split("\0")
    paths = [path for path in staged if path]
    if not paths:
        print("No staged/tracked publication files to audit.", file=sys.stderr)
        return 1
    failures = [f"excluded path: {path}" for path in paths if not permitted(path)]
    history = subprocess.check_output(["git", "rev-list", "--objects", "--all"], cwd=ROOT).decode()
    for line in history.splitlines():
        _, _, path = line.partition(" ")
        if path and path not in {"assets", "src", "src/main", "tools", "templates", ".github", ".github/workflows"} and not permitted(path):
            failures.append(f"excluded historical path: {path}")
    for path in paths:
        p = ROOT / path
        if p.is_symlink():
            failures.append(f"symlink: {path}")
            continue
        blob = p.read_bytes()
        if path == "assets/logo.png":
            if not blob.startswith(b"\x89PNG\r\n\x1a\n"):
                failures.append("logo is not a PNG")
        else:
            try:
                blob.decode("utf-8")
            except UnicodeDecodeError:
                failures.append(f"non-text file: {path}")
            if b"\0" in blob or blob.startswith((b"MZ", b"\x7fELF", b"PK\x03\x04", b"TPF0")):
                failures.append(f"binary content: {path}")
    generator = ast.parse((ROOT / "tools/gen_tree.py").read_text())
    if any(isinstance(n, ast.Constant) and isinstance(n.value, str)
           and re.search(r"(?im)^\s*asm\b", n.value) for n in ast.walk(generator)):
        failures.append("inline-assembly experiment in generator")
    if failures:
        print("\n".join(sorted(set(failures))), file=sys.stderr)
        return 1
    print(f"Publication audit passed: {len(paths)} source files and original logo; no excluded paths in history.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
