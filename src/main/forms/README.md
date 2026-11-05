# Form sources

`layouts.json` is the editable form model; the `.DFM` files are generated text snapshots.
Run `make forms` after editing the model. `make generate` compiles these layouts into local `HOLIDAY.RES`.
The embedded main-window icon was omitted. No artwork or raw binary properties are stored here.
Layouts describe component geometry, properties and event wiring; they do not implement the callbacks.

See [form reconstruction](../../../docs/forms.md) for the build and evidence boundaries.

| Form | Pascal unit | Components | Events |
| --- | --- | ---: | ---: |
| [THintergrund](THintergrund.DFM) | [THINTERG.PAS](../THINTERG.PAS) | 5 | 8 |
| [TBaumenue](TBaumenue.DFM) | [BAUFEN.PAS](../BAUFEN.PAS) | 1 | 6 |
| [THauptschirm](THauptschirm.DFM) | [DATWIN.PAS](../DATWIN.PAS) | 11 | 23 |
| [TAuktionsform](TAuktionsform.DFM) | [AUKTION.PAS](../AUKTION.PAS) | 6 | 9 |
| [TSabowin](TSabowin.DFM) | [AUKTION.PAS](../AUKTION.PAS) | 1 | 6 |
| [TInfobox2](TInfobox2.DFM) | [KOMPASS.PAS](../KOMPASS.PAS) | 1 | 3 |
| [TDateimenue](TDateimenue.DFM) | [HIGHSCOR.PAS](../HIGHSCOR.PAS) | 1 | 6 |
| [TEndeform](TEndeform.DFM) | [DATWIN.PAS](../DATWIN.PAS) | 1 | 6 |
| [TKompassform](TKompassform.DFM) | [KOMPASS.PAS](../KOMPASS.PAS) | 1 | 4 |
| [TDummyForm](TDummyForm.DFM) | [TDUMMYFO.PAS](../TDUMMYFO.PAS) | 1 | 1 |
| [TFernseher](TFernseher.DFM) | [HAUS.PAS](../HAUS.PAS) | 5 | 8 |
| [TStartform](TStartform.DFM) | [START.PAS](../START.PAS) | 1 | 4 |
| [TLadenForm](TLadenForm.DFM) | [KOMPASS.PAS](../KOMPASS.PAS) | 1 | 3 |
| [TOptionenform](TOptionenform.DFM) | [OPTION.PAS](../OPTION.PAS) | 1 | 7 |
| [Thighscoreform](Thighscoreform.DFM) | [HIGHSCOR.PAS](../HIGHSCOR.PAS) | 1 | 2 |
| [TSchlussform](TSchlussform.DFM) | [SCHLUSS.PAS](../SCHLUSS.PAS) | 6 | 5 |
| [TGeldmenuform](TGeldmenuform.DFM) | [GELD.PAS](../GELD.PAS) | 3 | 9 |
| [Tumenuform](Tumenuform.DFM) | [MENU.PAS](../MENU.PAS) | 1 | 4 |
| [TWasNunForm](TWasNunForm.DFM) | [HIGHSCOR.PAS](../HIGHSCOR.PAS) | 1 | 0 |
| [TCreditform](TCreditform.DFM) | [GFX.PAS](../GFX.PAS) | 1 | 3 |
| [TPauseform](TPauseform.DFM) | [HIGHSCOR.PAS](../HIGHSCOR.PAS) | 1 | 3 |
| [TUebersichtsmap2](TUebersichtsmap2.DFM) | [UEBERMAP.PAS](../UEBERMAP.PAS) | 7 | 17 |
| [THelpform](THelpform.DFM) | [HIGHSCOR.PAS](../HIGHSCOR.PAS) | 1 | 0 |

## THintergrund

| Component | Event | Handler | Native address |
| --- | --- | --- | --- |
| `Hintergrund` | `OnActivate` | [FormActivate](../THINTERG.PAS) | `0:0x3A77` / `MAIN.0x00003a77` |
| `Hintergrund` | `OnClose` | [FormClose](../THINTERG.PAS) | `0:0x3A8E` / `MAIN.0x00003a8e` |
| `Hintergrund` | `OnCreate` | [FormCreate](../THINTERG.PAS) | `0:0x3A4D` / `MAIN.0x00003a4d` |
| `Hintergrund` | `OnKeyDown` | [FormKeyDown](../THINTERG.PAS) | `0:0x3938` / `MAIN.0x00003938` |
| `Hintergrund` | `OnShow` | [FormShow](../THINTERG.PAS) | `0:0x2254` / `MAIN.0x00002254` |
| `backgroundimage` | `OnClick` | [backgroundimageClick](../THINTERG.PAS) | `0:0x3A36` / `MAIN.0x00003a36` |
| `FilmPanel` | `OnClick` | [FilmPanelClick](../THINTERG.PAS) | `0:0x39B7` / `MAIN.0x000039b7` |
| `Timer1` | `OnTimer` | [Timer1Timer](../THINTERG.PAS) | `0:0x2466` / `MAIN.0x00002466` |

## TBaumenue

| Component | Event | Handler | Native address |
| --- | --- | --- | --- |
| `Baumenue` | `OnCreate` | [FormCreate](../BAUFEN.PAS) | `3:0x2D12` / `MAIN.0x00032d12` |
| `Baumenue` | `OnDestroy` | [FormDestroy](../BAUFEN.PAS) | `3:0x3175` / `MAIN.0x00033175` |
| `Baumenue` | `OnKeyDown` | [FormKeyDown](../BAUFEN.PAS) | `3:0x3290` / `MAIN.0x00033290` |
| `Baumenuebild` | `OnMouseDown` | [BaumenuebildMouseDown](../BAUFEN.PAS) | `3:0x0208` / `MAIN.0x00030208` |
| `Baumenuebild` | `OnMouseMove` | [BaumenuebildMouseMove](../BAUFEN.PAS) | `3:0x0461` / `MAIN.0x00030461` |
| `Baumenuebild` | `OnMouseUp` | [BaumenuebildMouseUp](../BAUFEN.PAS) | `3:0x04E7` / `MAIN.0x000304e7` |

## THauptschirm

| Component | Event | Handler | Native address |
| --- | --- | --- | --- |
| `Hauptschirm` | `OnClose` | [FormClose](../DATWIN.PAS) | `4:0x28BF` / `MAIN.0x000428bf` |
| `Hauptschirm` | `OnKeyDown` | [FormKeyDown](../DATWIN.PAS) | `4:0x2E09` / `MAIN.0x00042e09` |
| `Hauptschirm` | `OnShow` | [FormShow](../DATWIN.PAS) | `4:0x2866` / `MAIN.0x00042866` |
| `NSScrollbild` | `OnMouseDown` | [NSScrollbildMouseDown](../DATWIN.PAS) | `4:0x0D92` / `MAIN.0x00040d92` |
| `NSScrollbild` | `OnMouseMove` | [NSScrollbildMouseMove](../DATWIN.PAS) | `4:0x0FA2` / `MAIN.0x00040fa2` |
| `NSScrollbild` | `OnMouseUp` | [NSScrollbildMouseUp](../DATWIN.PAS) | `4:0x10B6` / `MAIN.0x000410b6` |
| `Kleinbild` | `OnMouseDown` | [KleinbildMouseDown](../DATWIN.PAS) | `4:0x32C0` / `MAIN.0x000432c0` |
| `Kleinbild` | `OnMouseUp` | [KleinbildMouseUp](../DATWIN.PAS) | `4:0x32FA` / `MAIN.0x000432fa` |
| `CloseBild` | `OnMouseDown` | [CloseBildMouseDown](../DATWIN.PAS) | `4:0x324C` / `MAIN.0x0004324c` |
| `CloseBild` | `OnMouseUp` | [CloseBildMouseUp](../DATWIN.PAS) | `4:0x3286` / `MAIN.0x00043286` |
| `Hauptbild` | `OnMouseDown` | [HauptbildMouseDown](../DATWIN.PAS) | `4:0x1984` / `MAIN.0x00041984` |
| `Hauptbild` | `OnMouseMove` | [HauptbildMouseMove](../DATWIN.PAS) | `4:0x1AE6` / `MAIN.0x00041ae6` |
| `Hauptbild` | `OnMouseUp` | [HauptbildMouseUp](../DATWIN.PAS) | `4:0x1B31` / `MAIN.0x00041b31` |
| `Ueberschriftbild` | `OnMouseDown` | [UeberschriftbildMouseDown](../DATWIN.PAS) | `4:0x1B8E` / `MAIN.0x00041b8e` |
| `Ueberschriftbild` | `OnMouseMove` | [UeberschriftbildMouseMove](../DATWIN.PAS) | `4:0x1BD9` / `MAIN.0x00041bd9` |
| `Ueberschriftbild` | `OnMouseUp` | [UeberschriftbildMouseUp](../DATWIN.PAS) | `4:0x1C58` / `MAIN.0x00041c58` |
| `ButtonImage` | `OnClick` | [ButtonImageClick](../DATWIN.PAS) | `4:0x1946` / `MAIN.0x00041946` |
| `ButtonImage` | `OnMouseMove` | [ButtonImageMouseMove](../DATWIN.PAS) | `4:0x1952` / `MAIN.0x00041952` |
| `WOScrollbild` | `OnMouseDown` | [WOScrollbildMouseDown](../DATWIN.PAS) | `4:0x151A` / `MAIN.0x0004151a` |
| `WOScrollbild` | `OnMouseMove` | [WOScrollbildMouseMove](../DATWIN.PAS) | `4:0x172A` / `MAIN.0x0004172a` |
| `WOScrollbild` | `OnMouseUp` | [WOScrollbildMouseUp](../DATWIN.PAS) | `4:0x181F` / `MAIN.0x0004181f` |
| `eckimage` | `OnMouseDown` | [eckimageMouseDown](../DATWIN.PAS) | `4:0x3214` / `MAIN.0x00043214` |
| `AnimationsTimer` | `OnTimer` | [AnimationsTimerTimer](../DATWIN.PAS) | `4:0x1E9B` / `MAIN.0x00041e9b` |

## TAuktionsform

| Component | Event | Handler | Native address |
| --- | --- | --- | --- |
| `Auktionsform` | `OnKeyDown` | [FormKeyDown](../AUKTION.PAS) | `5:0x26E4` / `MAIN.0x000526e4` |
| `leiste` | `OnMouseDown` | [leisteMouseDown](../AUKTION.PAS) | `5:0x1B77` / `MAIN.0x00051b77` |
| `leiste` | `OnMouseMove` | [leisteMouseMove](../AUKTION.PAS) | `5:0x1C4D` / `MAIN.0x00051c4d` |
| `leiste` | `OnMouseUp` | [leisteMouseUp](../AUKTION.PAS) | `5:0x1CE0` / `MAIN.0x00051ce0` |
| `knopfimage` | `OnMouseDown` | [knopfimageMouseDown](../AUKTION.PAS) | `5:0x1E23` / `MAIN.0x00051e23` |
| `knopfimage` | `OnMouseUp` | [knopfimageMouseUp](../AUKTION.PAS) | `5:0x2208` / `MAIN.0x00052208` |
| `Timer1` | `OnTimer` | [Timer1Timer](../AUKTION.PAS) | `5:0x190D` / `MAIN.0x0005190d` |
| `Timer2` | `OnTimer` | [Timer2Timer](../AUKTION.PAS) | `5:0x1940` / `MAIN.0x00051940` |
| `Timer3` | `OnTimer` | [Timer3Timer](../AUKTION.PAS) | `5:0x1973` / `MAIN.0x00051973` |

## TSabowin

| Component | Event | Handler | Native address |
| --- | --- | --- | --- |
| `Sabowin` | `OnHide` | [FormHide](../AUKTION.PAS) | `5:0x35EE` / `MAIN.0x000535ee` |
| `Sabowin` | `OnKeyDown` | [FormKeyDown](../AUKTION.PAS) | `5:0x394C` / `MAIN.0x0005394c` |
| `Sabowin` | `OnShow` | [FormShow](../AUKTION.PAS) | `5:0x34A2` / `MAIN.0x000534a2` |
| `Saboimage` | `OnMouseDown` | [SaboimageMouseDown](../AUKTION.PAS) | `5:0x2D67` / `MAIN.0x00052d67` |
| `Saboimage` | `OnMouseMove` | [SaboimageMouseMove](../AUKTION.PAS) | `5:0x2ECC` / `MAIN.0x00052ecc` |
| `Saboimage` | `OnMouseUp` | [SaboimageMouseUp](../AUKTION.PAS) | `5:0x2F4E` / `MAIN.0x00052f4e` |

## TInfobox2

| Component | Event | Handler | Native address |
| --- | --- | --- | --- |
| `Infobox2` | `OnKeyDown` | [FormKeyDown](../KOMPASS.PAS) | `7:0x284B` / `MAIN.0x0007284b` |
| `Infoimage` | `OnMouseDown` | [InfoimageMouseDown](../KOMPASS.PAS) | `7:0x2742` / `MAIN.0x00072742` |
| `Infoimage` | `OnMouseUp` | [InfoimageMouseUp](../KOMPASS.PAS) | `7:0x27B4` / `MAIN.0x000727b4` |

## TDateimenue

| Component | Event | Handler | Native address |
| --- | --- | --- | --- |
| `Dateimenue` | `OnHide` | [FormHide](../HIGHSCOR.PAS) | `8:0x1525` / `MAIN.0x00081525` |
| `Dateimenue` | `OnKeyDown` | [FormKeyDown](../HIGHSCOR.PAS) | `8:0x1572` / `MAIN.0x00081572` |
| `Dateimenue` | `OnShow` | [FormShow](../HIGHSCOR.PAS) | `8:0x12BE` / `MAIN.0x000812be` |
| `Dateimenuebild` | `OnMouseDown` | [DateimenuebildMouseDown](../HIGHSCOR.PAS) | `8:0x073C` / `MAIN.0x0008073c` |
| `Dateimenuebild` | `OnMouseMove` | [DateimenuebildMouseMove](../HIGHSCOR.PAS) | `8:0x09CA` / `MAIN.0x000809ca` |
| `Dateimenuebild` | `OnMouseUp` | [DateimenuebildMouseUp](../HIGHSCOR.PAS) | `8:0x0A4C` / `MAIN.0x00080a4c` |

## TEndeform

| Component | Event | Handler | Native address |
| --- | --- | --- | --- |
| `Endeform` | `OnHide` | [FormHide](../DATWIN.PAS) | `4:0x3D05` / `MAIN.0x00043d05` |
| `Endeform` | `OnKeyDown` | [FormKeyDown](../DATWIN.PAS) | `4:0x3D30` / `MAIN.0x00043d30` |
| `Endeform` | `OnShow` | [FormShow](../DATWIN.PAS) | `4:0x3B5F` / `MAIN.0x00043b5f` |
| `EndeImage` | `OnMouseDown` | [EndeImageMouseDown](../DATWIN.PAS) | `4:0x37DD` / `MAIN.0x000437dd` |
| `EndeImage` | `OnMouseMove` | [EndeImageMouseMove](../DATWIN.PAS) | `4:0x38D4` / `MAIN.0x000438d4` |
| `EndeImage` | `OnMouseUp` | [EndeImageMouseUp](../DATWIN.PAS) | `4:0x395F` / `MAIN.0x0004395f` |

## TKompassform

| Component | Event | Handler | Native address |
| --- | --- | --- | --- |
| `Kompassform` | `OnKeyDown` | [FormKeyDown](../KOMPASS.PAS) | `7:0x3557` / `MAIN.0x00073557` |
| `Bild` | `OnMouseDown` | [BildMouseDown](../KOMPASS.PAS) | `7:0x3329` / `MAIN.0x00073329` |
| `Bild` | `OnMouseMove` | [BildMouseMove](../KOMPASS.PAS) | `7:0x346F` / `MAIN.0x0007346f` |
| `Bild` | `OnMouseUp` | [BildMouseUp](../KOMPASS.PAS) | `7:0x34FC` / `MAIN.0x000734fc` |

## TDummyForm

| Component | Event | Handler | Native address |
| --- | --- | --- | --- |
| `DummyForm` | `OnKeyDown` | [FormKeyDown](../TDUMMYFO.PAS) | `0:0x3D0C` / `MAIN.0x00003d0c` |

## TFernseher

| Component | Event | Handler | Native address |
| --- | --- | --- | --- |
| `Fernseher` | `OnHide` | [FormHide](../HAUS.PAS) | `9:0x29E2` / `MAIN.0x000929e2` |
| `Fernseher` | `OnKeyDown` | [FormKeyDown](../HAUS.PAS) | `9:0x26F6` / `MAIN.0x000926f6` |
| `Fernseher` | `OnShow` | [FormShow](../HAUS.PAS) | `9:0x26B0` / `MAIN.0x000926b0` |
| `tvimage` | `OnMouseDown` | [tvimageMouseDown](../HAUS.PAS) | `9:0x286B` / `MAIN.0x0009286b` |
| `tvimage` | `OnMouseUp` | [tvimageMouseUp](../HAUS.PAS) | `9:0x287D` / `MAIN.0x0009287d` |
| `tvleiimage` | `OnMouseDown` | [tvleiimageMouseDown](../HAUS.PAS) | `9:0x288F` / `MAIN.0x0009288f` |
| `tvleiimage` | `OnMouseMove` | [tvleiimageMouseMove](../HAUS.PAS) | `9:0x2955` / `MAIN.0x00092955` |
| `tvleiimage` | `OnMouseUp` | [tvleiimageMouseUp](../HAUS.PAS) | `9:0x2922` / `MAIN.0x00092922` |

## TStartform

| Component | Event | Handler | Native address |
| --- | --- | --- | --- |
| `Startform` | `OnKeyDown` | [FormKeyDown](../START.PAS) | `11:0x4381` / `MAIN.0x000b4381` |
| `Bild` | `OnMouseDown` | [BildMouseDown](../START.PAS) | `11:0x3CFD` / `MAIN.0x000b3cfd` |
| `Bild` | `OnMouseMove` | [BildMouseMove](../START.PAS) | `11:0x412F` / `MAIN.0x000b412f` |
| `Bild` | `OnMouseUp` | [BildMouseUp](../START.PAS) | `11:0x41FB` / `MAIN.0x000b41fb` |

## TLadenForm

| Component | Event | Handler | Native address |
| --- | --- | --- | --- |
| `LadenForm` | `OnClose` | [FormClose](../KOMPASS.PAS) | `7:0x3F9B` / `MAIN.0x00073f9b` |
| `Bild` | `OnMouseDown` | [BildMouseDown](../KOMPASS.PAS) | `7:0x3E24` / `MAIN.0x00073e24` |
| `Bild` | `OnMouseUp` | [BildMouseUp](../KOMPASS.PAS) | `7:0x3EF5` / `MAIN.0x00073ef5` |

## TOptionenform

| Component | Event | Handler | Native address |
| --- | --- | --- | --- |
| `Optionenform` | `OnClose` | [FormClose](../OPTION.PAS) | `12:0x33CB` / `MAIN.0x000c33cb` |
| `Optionenform` | `OnHide` | [FormHide](../OPTION.PAS) | `12:0x0E79` / `MAIN.0x000c0e79` |
| `Optionenform` | `OnKeyDown` | [FormKeyDown](../OPTION.PAS) | `12:0x2C72` / `MAIN.0x000c2c72` |
| `Optionenform` | `OnShow` | [FormShow](../OPTION.PAS) | `12:0x0782` / `MAIN.0x000c0782` |
| `bild` | `OnMouseDown` | [bildMouseDown](../OPTION.PAS) | `12:0x2404` / `MAIN.0x000c2404` |
| `bild` | `OnMouseMove` | [bildMouseMove](../OPTION.PAS) | `12:0x29F0` / `MAIN.0x000c29f0` |
| `bild` | `OnMouseUp` | [bildMouseUp](../OPTION.PAS) | `12:0x2B17` / `MAIN.0x000c2b17` |

## Thighscoreform

| Component | Event | Handler | Native address |
| --- | --- | --- | --- |
| `bild` | `OnMouseDown` | [bildMouseDown](../HIGHSCOR.PAS) | `8:0x31BC` / `MAIN.0x000831bc` |
| `bild` | `OnMouseUp` | [bildMouseUp](../HIGHSCOR.PAS) | `8:0x3347` / `MAIN.0x00083347` |

## TSchlussform

| Component | Event | Handler | Native address |
| --- | --- | --- | --- |
| `Schlussform` | `OnKeyDown` | [FormKeyDown](../SCHLUSS.PAS) | `13:0x198A` / `MAIN.0x000d198a` |
| `Bild` | `OnMouseDown` | [BildMouseDown](../SCHLUSS.PAS) | `13:0x1613` / `MAIN.0x000d1613` |
| `Bild` | `OnMouseUp` | [BildMouseUp](../SCHLUSS.PAS) | `13:0x16E0` / `MAIN.0x000d16e0` |
| `Panel1` | `OnClick` | [Panel1Click](../SCHLUSS.PAS) | `13:0x199B` / `MAIN.0x000d199b` |
| `Timer1` | `OnTimer` | [Timer1Timer](../SCHLUSS.PAS) | `13:0x187F` / `MAIN.0x000d187f` |

## TGeldmenuform

| Component | Event | Handler | Native address |
| --- | --- | --- | --- |
| `Geldmenuform` | `OnKeyDown` | [FormKeyDown](../GELD.PAS) | `14:0x39BF` / `MAIN.0x000e39bf` |
| `UeberschriftImage` | `OnMouseDown` | [UeberschriftImageMouseDown](../GELD.PAS) | `14:0x0820` / `MAIN.0x000e0820` |
| `UeberschriftImage` | `OnMouseMove` | [UeberschriftImageMouseMove](../GELD.PAS) | `14:0x08E0` / `MAIN.0x000e08e0` |
| `UeberschriftImage` | `OnMouseUp` | [UeberschriftImageMouseUp](../GELD.PAS) | `14:0x096D` / `MAIN.0x000e096d` |
| `BildImage` | `OnMouseDown` | [BildImageMouseDown](../GELD.PAS) | `14:0x0300` / `MAIN.0x000e0300` |
| `BildImage` | `OnMouseUp` | [BildImageMouseUp](../GELD.PAS) | `14:0x04D3` / `MAIN.0x000e04d3` |
| `MenuImage` | `OnMouseDown` | [MenuImageMouseDown](../GELD.PAS) | `14:0x09F7` / `MAIN.0x000e09f7` |
| `MenuImage` | `OnMouseMove` | [MenuImageMouseMove](../GELD.PAS) | `14:0x0AD5` / `MAIN.0x000e0ad5` |
| `MenuImage` | `OnMouseUp` | [MenuImageMouseUp](../GELD.PAS) | `14:0x0ADD` / `MAIN.0x000e0add` |

## Tumenuform

| Component | Event | Handler | Native address |
| --- | --- | --- | --- |
| `umenuform` | `OnKeyDown` | [FormKeyDown](../MENU.PAS) | `16:0x202B` / `MAIN.0x0010202b` |
| `bild` | `OnMouseDown` | [bildMouseDown](../MENU.PAS) | `16:0x1C3B` / `MAIN.0x00101c3b` |
| `bild` | `OnMouseMove` | [bildMouseMove](../MENU.PAS) | `16:0x1E54` / `MAIN.0x00101e54` |
| `bild` | `OnMouseUp` | [bildMouseUp](../MENU.PAS) | `16:0x1F18` / `MAIN.0x00101f18` |

## TWasNunForm

| Component | Event | Handler | Native address |
| --- | --- | --- | --- |

## TCreditform

| Component | Event | Handler | Native address |
| --- | --- | --- | --- |
| `Creditform` | `OnClose` | [FormClose](../GFX.PAS) | `6:0x3F80` / `MAIN.0x00063f80` |
| `Bild` | `OnMouseDown` | [BildMouseDown](../GFX.PAS) | `6:0x3EC4` / `MAIN.0x00063ec4` |
| `Bild` | `OnMouseUp` | [BildMouseUp](../GFX.PAS) | `6:0x3F22` / `MAIN.0x00063f22` |

## TPauseform

| Component | Event | Handler | Native address |
| --- | --- | --- | --- |
| `Pauseform` | `OnClose` | [FormClose](../HIGHSCOR.PAS) | `8:0x3C16` / `MAIN.0x00083c16` |
| `Pauseform` | `OnKeyDown` | [FormKeyDown](../HIGHSCOR.PAS) | `8:0x3C05` / `MAIN.0x00083c05` |
| `Pausebild` | `OnClick` | [PausebildClick](../HIGHSCOR.PAS) | `8:0x3BF4` / `MAIN.0x00083bf4` |

## TUebersichtsmap2

| Component | Event | Handler | Native address |
| --- | --- | --- | --- |
| `Uebersichtsmap2` | `OnKeyDown` | [FormKeyDown](../UEBERMAP.PAS) | `23:0x4C95` / `MAIN.0x00174c95` |
| `Ueberschriftbild` | `OnMouseDown` | [UeberschriftbildMouseDown](../UEBERMAP.PAS) | `23:0x3AC3` / `MAIN.0x00173ac3` |
| `Ueberschriftbild` | `OnMouseMove` | [UeberschriftbildMouseMove](../UEBERMAP.PAS) | `23:0x3C9B` / `MAIN.0x00173c9b` |
| `Ueberschriftbild` | `OnMouseUp` | [UeberschriftbildMouseUp](../UEBERMAP.PAS) | `23:0x3D2B` / `MAIN.0x00173d2b` |
| `Umschaltbild` | `OnMouseDown` | [UmschaltbildMouseDown](../UEBERMAP.PAS) | `23:0x1C74` / `MAIN.0x00171c74` |
| `Umschaltbild` | `OnMouseUp` | [UmschaltbildMouseUp](../UEBERMAP.PAS) | `23:0x1D21` / `MAIN.0x00171d21` |
| `NSScrollbild` | `OnMouseDown` | [NSScrollbildMouseDown](../UEBERMAP.PAS) | `23:0x222B` / `MAIN.0x0017222b` |
| `NSScrollbild` | `OnMouseMove` | [NSScrollbildMouseMove](../UEBERMAP.PAS) | `23:0x2421` / `MAIN.0x00172421` |
| `NSScrollbild` | `OnMouseUp` | [NSScrollbildMouseUp](../UEBERMAP.PAS) | `23:0x24A1` / `MAIN.0x001724a1` |
| `Menubild` | `OnMouseDown` | [MenubildMouseDown](../UEBERMAP.PAS) | `23:0x29A2` / `MAIN.0x001729a2` |
| `Menubild` | `OnMouseMove` | [MenubildMouseMove](../UEBERMAP.PAS) | `23:0x2E01` / `MAIN.0x00172e01` |
| `Menubild` | `OnMouseUp` | [MenubildMouseUp](../UEBERMAP.PAS) | `23:0x2E99` / `MAIN.0x00172e99` |
| `MapBild` | `OnMouseDown` | [MapBildMouseDown](../UEBERMAP.PAS) | `23:0x37F5` / `MAIN.0x001737f5` |
| `MapBild` | `OnMouseMove` | [MapBildMouseMove](../UEBERMAP.PAS) | `23:0x39B1` / `MAIN.0x001739b1` |
| `MapBild` | `OnMouseUp` | [MapBildMouseUp](../UEBERMAP.PAS) | `23:0x3AAB` / `MAIN.0x00173aab` |
| `NSScrolltimer` | `OnTimer` | [NSScrolltimerTimer](../UEBERMAP.PAS) | `23:0x216E` / `MAIN.0x0017216e` |
| `WOScrolltimer` | `OnTimer` | [WOScrolltimerTimer](../UEBERMAP.PAS) | `23:0x28E5` / `MAIN.0x001728e5` |

## THelpform

| Component | Event | Handler | Native address |
| --- | --- | --- | --- |
