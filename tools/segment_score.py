"""The score the project quotes, in one place.

Three numbers are useful and they measure different things: `byte_score` compares whole-file
16-byte windows, `segment_budget` compares each original segment's bytes against the rebuilt
image's content, and the roadmap row is a size sum. The documents quote the **segment budget**,
and the third argument (16) is load-bearing: without it the per-segment rows are not comparable
and the sum is meaningless. Round 227's withdrawn test missed that argument and read 594.
"""
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "tools"))

from rebrew.formats import ne_analysis  # noqa: E402

WINDOW = 16


def score(original: Path, rebuilt: Path) -> tuple[int, int]:
    """Return the segment-budget (matched, budget) pair the documents quote."""
    budget = ne_analysis.segment_budget(
        ne_analysis.NeImage(original), ne_analysis.NeImage(rebuilt), WINDOW)
    return sum(row[2] for row in budget), sum(row[1] for row in budget)


def stale_sources(binary: Path) -> list[str]:
    """Sources newer than the image it was built from.

    A broken generator does not fail the build; it leaves the previous image in place, and the
    score then reads a binary nobody just built. Round 261 lost a round to exactly that.
    """
    if not binary.is_file():
        return ["missing image"]
    when = binary.stat().st_mtime
    return [path.name for path in sorted((ROOT / "src" / "main").glob("*.PAS"))
            if path.stat().st_mtime > when]


def main() -> int:
    binary = ROOT / "bin" / "main" / "HOLIDAY.EXE"
    stale = stale_sources(binary)
    if stale:
        print(f"STALE: {len(stale)} source unit(s) are newer than {binary.name}: "
              f"{', '.join(stale[:5])}" + (" ..." if len(stale) > 5 else ""))
        print("run ./build.sh before trusting this number")
        return 1
    if "--game-only" in sys.argv:
        # The library segments are relinked from the same RTL, so they are present in both
        # images by construction. The game's own share is the honest reconstruction figure
        # (round 436): 12.46 per cent against the 29.05 headline.
        budget = ne_analysis.segment_budget(
            ne_analysis.NeImage(ROOT / "original" / "holiday.exe"),
            ne_analysis.NeImage(binary), WINDOW)
        matched = sum(row[2] for row in budget if 0 <= row[0] <= 24)
        total = sum(row[1] for row in budget if 0 <= row[0] <= 24)
        print(f"game segments 0-24: {matched:,} / {total:,} = {100 * matched / total:.2f} %")
        return 0
    if "--per-segment" in sys.argv:
        # Which original segment the matched windows sit in. A reconstruction adds to the
        # score only where its 16-byte window already exists in the original, so this is
        # the table to read before choosing the next body (round 308).
        budget = ne_analysis.segment_budget(
            ne_analysis.NeImage(ROOT / "original" / "holiday.exe"),
            ne_analysis.NeImage(binary), WINDOW)
        for index, total, matched in budget:
            share = 100 * matched / total if total else 0.0
            print(f"  segment {index:2d}: {matched:7,} / {total:7,} = {share:5.1f} %")
        return 0
    matched, budget = score(ROOT / "original" / "holiday.exe", binary)
    print(f"segment budget: {matched:,} / {budget:,} = {100 * matched / budget:.2f} %")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
