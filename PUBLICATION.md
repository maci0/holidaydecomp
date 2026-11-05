# Publication scope

This repository publishes newly written analysis tools and reconstruction
generation logic. It does not redistribute the original game's executable,
media, extracted strings/data, form resources, memory dumps, raw disassembly
archives or proprietary compiler files.

The technical inventories record procedure addresses, sizes, identifiers and
reviewed extent corrections. Extraction tools operate on a reference supplied
locally by the user. Their generated output is ignored and excluded from the
publication audit.

The old research history, binary-safe working-tree patches and unapplied
experiments were retained privately before creating this fresh history.
Historical byte-overlap results from that research are not measurements of this
source-only release. The three excluded assembly experiments are listed in
`PUBLICATION.json`.

Only `assets/logo.png`, an original project mark, is included as artwork.
No game icon or screenshot was copied into it.

`tools/check_publication.py` checks the index and historical paths against a
source-only allowlist and rejects binary assets and generated game files.
It is a technical safeguard against accidental inclusion, not a determination
of rights in arbitrary future contributions.
