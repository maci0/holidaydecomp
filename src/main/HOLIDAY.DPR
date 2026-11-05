program HOLIDAY;
{ Reconstructed from original/holiday.exe.  The program links 26 units, in
  the order their code segments appear in the image (segments 0-24); the
  VCL follows (segments 25-33) and the linked data segment is 34.
  The title string is the one embedded in segment 0.  Delphi 1 rejects a
  source line longer than 126 characters (Error 11), hence the wrapped uses.
  `$R *.RES` links the form streams tools/dfm_pack.py packed into HOLIDAY.RES
  and POOLS holds the recovered string constants of tools/gen_pools.py.
  TABLES writes the program's jump tables back as constants (tools/gen_tables.py)
  and DATAVAL the data segment's initialised bytes (tools/gen_data.py).
  REACH is a stand-in unit: the original's own units reach far more VCL and RTL
  code than a scaffold can, and naming that API is what closes the library gap
  (docs/segment-map.md).  Its own code is not the original's; the library code
  it pulls in is. }
uses Forms, THINTERG, TDUMMYFO, ABRECHNE, DATEN, BAUFEN, DATWIN, AUKTION, GFX, KOMPASS,
  HIGHSCOR, HAUS, DARSTELL, START, OPTION, SCHLUSS, GELD, SEG15, MENU, ANIM, EREIGN,
  OBJEKT, SOUND, BAUEN, MAP, UEBERMAP, SEG24, POOLS, TABLES, DATAVAL, REACH;
{$R *.RES}

var
  FHintergrund: THintergrund;
  FDummyForm: TDummyForm;
  FBaumenue: TBaumenue;
  FEndeform: TEndeform;
  FHauptschirm: THauptschirm;
  FAuktionsform: TAuktionsform;
  FSabowin: TSabowin;
  FCreditform: TCreditform;
  FKompassform: TKompassform;
  FLadenForm: TLadenForm;
  FInfobox2: TInfobox2;
  FDateimenue: TDateimenue;
  FHelpform: THelpform;
  FPauseform: TPauseform;
  FWasNunForm: TWasNunForm;
  Fhighscoreform: Thighscoreform;
  FFernseher: TFernseher;
  FStartform: TStartform;
  FOptionenform: TOptionenform;
  FSchlussform: TSchlussform;
  FGeldmenuform: TGeldmenuform;
  Fumenuform: Tumenuform;
  FUebersichtsmap2: TUebersichtsmap2;


begin
  LoadPools;
  LoadTables;
  LoadData;
  ReachMore;
  Application.Title := 'Holiday Island';
  Application.CreateForm(THintergrund, FHintergrund);
  Application.CreateForm(TDummyForm, FDummyForm);
  Application.CreateForm(TBaumenue, FBaumenue);
  Application.CreateForm(TEndeform, FEndeform);
  Application.CreateForm(THauptschirm, FHauptschirm);
  Application.CreateForm(TAuktionsform, FAuktionsform);
  Application.CreateForm(TSabowin, FSabowin);
  Application.CreateForm(TCreditform, FCreditform);
  Application.CreateForm(TKompassform, FKompassform);
  Application.CreateForm(TLadenForm, FLadenForm);
  Application.CreateForm(TInfobox2, FInfobox2);
  Application.CreateForm(TDateimenue, FDateimenue);
  Application.CreateForm(THelpform, FHelpform);
  Application.CreateForm(TPauseform, FPauseform);
  Application.CreateForm(TWasNunForm, FWasNunForm);
  Application.CreateForm(Thighscoreform, Fhighscoreform);
  Application.CreateForm(TFernseher, FFernseher);
  Application.CreateForm(TStartform, FStartform);
  Application.CreateForm(TOptionenform, FOptionenform);
  Application.CreateForm(TSchlussform, FSchlussform);
  Application.CreateForm(TGeldmenuform, FGeldmenuform);
  Application.CreateForm(Tumenuform, Fumenuform);
  Application.CreateForm(TUebersichtsmap2, FUebersichtsmap2);
  Application.Run;
end.
