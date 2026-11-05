# Working game model

This page orients subsystem research. It does not claim complete recovered game behavior. The [unit map](units.md) ties working roles to source; [finding records](findings.md) carry concrete source/byte questions.

## Subsystems

| Area | Working source anchors | What remains incomplete |
| --- | --- | --- |
| Startup, forms and media | THINTERG, TDUMMYFO, HOLIDAY.DPR | Real initialization versus synthetic retention roots; missing external media |
| UI and menus | BAUFEN, DATWIN, KOMPASS, HIGHSCOR, START, OPTION, GELD, MENU | Many callbacks, private fields and runtime state |
| Rendering and display | GFX, DARSTELL | Complete drawing paths and near/far dispatch receiver types |
| Map and placement | MAP, UEBERMAP, BAUEN | Global ownership, placement rules and full scroll/selection behavior |
| Object and animation steps | ANIM, OBJEKT, EREIGN | Full state transitions and the semantic meaning of record variants |
| Finance and auctions | ABRECHNE, AUKTION | Complete accounting and auction control flow |
| Save/load and audio | DATEN, HAUS, SOUND | File contracts, numeric state and runtime multimedia behavior |

## Historical object model

Earlier native research described a 40-byte placed-object record reached through DGROUP `0x6FD6`, a 188-byte definition family at `0x6FDA`, and map references including `0x551C`/`0x5520`. Those are research observations tied to the recorded reference, not complete named classes or a reconstructed original schema.

The old object-model notebook relates field accesses and allocation sizes; it is indexed in [research history](research-history.md). Recheck the relevant native extent, current record views and ownership before extending this model. Do not treat every field used by one object kind as simultaneously meaningful for every kind.

## Data and assets

Game `.DAT` names, bitmap/audio/movie names and record strides help locate readers and writers. They do not independently establish the parser or a source unit's original name. The sibling [openholiday project](https://github.com/maci0/openholiday) contains a separate Python/web reconstruction; its data interpretation is another source to cross-check, not native binary proof for this repository.

Layouts alone cannot reproduce visuals: many images and text are loaded at runtime. The tracked form tree deliberately omits the embedded original icon. [Forms](forms.md) owns that boundary.
