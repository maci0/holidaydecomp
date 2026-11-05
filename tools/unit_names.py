#!/usr/bin/env python3
"""The one curated unit-name table.

Round 344 found `tools/gen_tree.py` and `tools/gen_units.py` carrying *different*
naming tables for the same segments: the tree called segment 17 `ANIM` and the
dossier called it `OBJEKT`. Two tables for one fact is one table too many, so
the names live here and both generators import them.

The names are curated guesses argued from each segment's evidence, not
recovered identifiers; `docs/units.md` carries the evidence per unit, and
`docs/tree.md` records that the file literals of segment 17 (`animdat1-4.dat`)
sit in the unit this table calls `OBJEKT`.

Two entries were corrected by the round that created this file: segment 1 was
`ABRECH.PAS` here while the tree called it `ABRECHNE.PAS`, and the tree is right
by evidence — the unit's own literal is `abrechne.dat`, so the name it loads
matches. The table now says `ABRECHNE.PAS`.

Segments 17 and 19 were swapped in round 347. The deciding measurement is not
which segment *holds* the literals but which one **uses the tables they fill**:
segment 17's code references all five tables the animation loader fills — 33,
13, 13, 30 and 16 times — while segment 19 references two of them 2 and 4 times
and spends its code on the 1601-record object table instead. A unit that loads
`animdat1-4.dat` and then reads every table they fill is the animation unit, so
17 is `ANIM.PAS` and 19 — no literals, object table read 625 times — is
`OBJEKT.PAS`.
"""

from __future__ import annotations

JOBS: dict[int, tuple[str, str]] = {
    0: ("HOLIDAY.DPR", "start-up, the CD check, the intro and the main form's bitmap"),
    1: ("ABRECHNE.PAS", "the accounting pass over a game's ledger"),
    2: ("DATEN.PAS", "loads and saves the game data files and the map"),
    3: ("BAUFEN.PAS", "the building window"),
    4: ("DATWIN.PAS", "the data window"),
    5: ("AUKTION.PAS", "the auction of buildings and land"),
    6: ("GFX.PAS", "the display's shared helpers, bitmaps and the map allocators"),
    7: ("KOMPASS.PAS", "the compass window"),
    8: ("HIGHSCOR.PAS", "the high-score table"),
    9: ("HAUS.PAS", "the house and object data files"),
    10: ("DARSTELL.PAS", "the map's rendering pass"),
    11: ("START.PAS", "the start screen and the credits"),
    12: ("OPTION.PAS", "the options screen"),
    13: ("SCHLUSS.PAS", "the end-of-game form and the linked lists"),
    14: ("GELD.PAS", "the money screen"),
    15: ("SEG15.PAS", "the shared rules unit (name unrecoverable)"),
    16: ("MENU.PAS", "the main menu"),
    17: ("ANIM.PAS", "the animation tables: animdat1-4.dat and neintrag.dat"),
    18: ("EREIGN.PAS", "events and construction"),
    19: ("OBJEKT.PAS", "the object step: the object table and its dispatch"),
    20: ("SOUND.PAS", "the 42 sound commands"),
    21: ("BAUEN.PAS", "the building unit: placement, roads and the eleven kinds"),
    22: ("MAP.PAS", "the map unit: six maps, the board and the search"),
    23: ("UEBERMAP.PAS", "the overview map"),
    24: ("SEG24.PAS", "the shared formatting unit (name unrecoverable)"),
}
