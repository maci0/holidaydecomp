#!/usr/bin/env python3
"""Project root discovery and the lock every pipeline command takes first.

`project_root()` walks up to `rebrew-project.toml`, so a script works from any
directory of the checkout. `locked()` holds `.scratch/proj.lock` across a run
that writes the tree, which is how twenty teammates keep `tools/gen_tree.py`,
`./build.sh` and `rebrew binary ne-compare` from interleaving: the lock is the
same file the shared locked commands take with `flock`, so a shell `flock` run
and a Python `locked()` run exclude each other.

    from proj_lock import locked

    with locked():
        ...  # regenerate, build, compare

The split of which commands lock, and therefore which must never be wrapped in
an outer `flock`, is on `locked()` itself.
"""

from __future__ import annotations

import contextlib
import fcntl
import os
import sys
from collections.abc import Iterator
from pathlib import Path

#: The lock file, shared with the shell commands that run the same pipeline.
LOCK_NAME = ".scratch/proj.lock"


def project_root(start: Path | None = None) -> Path:
    """The checkout root, found by walking up to the project marker."""
    here = (start or Path(__file__)).resolve()
    for candidate in (here, *here.parents):
        if (candidate / "rebrew-project.toml").is_file():
            return candidate
    raise FileNotFoundError("no rebrew-project.toml above this script")


def inherits_lock(path: Path) -> bool:
    """True when this process already has `path` open, as `flock -c` leaves it.

    The descriptor arrives by inheritance, so it is visible in this process's
    own table: an outer holder is already serialising the run, and locking again
    would wait for it. Without `/proc` there is nothing to read, and the caller
    blocks as it would on any other holder.
    """
    try:
        names = os.listdir("/proc/self/fd")
    except OSError:
        return False
    wanted = os.path.realpath(path)
    for name in names:
        try:
            target = os.readlink(f"/proc/self/fd/{name}")
        except OSError:
            continue                      # the descriptor closed while we read it
        if os.path.realpath(target.removesuffix(" (deleted)")) == wanted:
            return True
    return False


@contextlib.contextmanager
def locked(root: Path | None = None, *, quiet: bool = False) -> Iterator[Path]:
    """Hold `.scratch/proj.lock` for the duration of the block.

    **Lock internally, so never wrap in `flock .scratch/proj.lock -c '...'`:**
    `tools/run_tests.py`, `tools/regen_build_compare.py`,
    `tools/patch_gen_tree.py`, and `./progress.sh` (it ends in
    `tools/run_tests.py`). `flock FILE cmd` locks the file and runs `cmd` with
    that descriptor inherited, so an inner `locked()` locks the same file again
    and waits for its own parent: on 2026-10-30 that held the lock for thirty
    minutes behind a twelve-process convoy.

    **Take an outer `flock` yourself, because none of these lock:** plain
    `./build.sh`, plain `rebrew binary ne-compare`, standalone
    `tools/gen_tree.py`, and the `dfm`/`gen_*` `--check` scripts.

    A wait prints one line first, so a run that blocks on another teammate's
    build says why it is not moving instead of looking hung. An outer holder is
    not waited for: it already covers this run, so the block runs under it.
    """
    base = root or project_root()
    path = base / LOCK_NAME
    if inherits_lock(path):
        if not quiet:
            print(f"running under an outer {LOCK_NAME} holder", file=sys.stderr,
                  flush=True)
        yield path
        return
    path.parent.mkdir(parents=True, exist_ok=True)
    with path.open("a+") as handle:
        try:
            fcntl.flock(handle, fcntl.LOCK_EX | fcntl.LOCK_NB)
        except BlockingIOError:
            if not quiet:
                print(f"waiting for {LOCK_NAME}", file=sys.stderr, flush=True)
            fcntl.flock(handle, fcntl.LOCK_EX)
        try:
            yield path
        finally:
            fcntl.flock(handle, fcntl.LOCK_UN)
