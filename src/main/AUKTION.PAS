unit AUKTION;
{ Reconstructed scaffold, holiday.exe code segment 5 (15943 bytes).
  This is unit holding TAuktionsform, TSabowin; the original kept its forms inside the segment's
  own  unit (docs/tree.md).
  Evidence: form TAuktionsform (6 components), form TSabowin (1 components).
  `uses` comes from this segment's relocation records, the class members
  from RTTI and form streams. Recovered free bodies are listed in the
  implementation; the other bodies are not recovered. }
{$F+}
interface

uses ExtCtrls, Graphics, Controls, Forms, Classes, SysUtils;

procedure Proc5_0476;
procedure Proc5_08AC(A0, A1, A2, A3: Word);
procedure Proc5_190D(A0, A1, A2, A3: Word);
procedure Proc5_1940(A0, A1, A2, A3: Word);
procedure Proc5_1973(A0, A1, A2, A3: Word);
procedure Proc5_1B77(A0, A1, A2, A3, A4, A5, A6, A7: Word);
procedure Proc5_1C4D(A0, A1, A2, A3, A4, A5, A6: Word);
procedure Proc5_1CE0(A0, A1, A2, A3, A4, A5, A6, A7: Word);
procedure Proc5_1E23(A0, A1, A2, A3, A4, A5, A6, A7: Word);
procedure Proc5_2208(A0, A1, A2, A3, A4, A5, A6, A7: Word);
procedure Proc5_2449;
procedure Proc5_24F1;
procedure Proc5_2506(A0, A1: Word);
procedure Proc5_25F4(A0, A1: Word);
procedure Proc5_26E4(A0, A1, A2, A3, A4, A5, A6: Word);
procedure Proc5_2B24(A0, A1, A2, A3, A4: Word);
procedure Proc5_2B9F(A0, A1, A2, A3, A4: Word);
procedure Proc5_2C18(A0, A1, A2: Word);
procedure Proc5_2C62(A0, A1, A2: Word);
procedure Proc5_2D67(A0, A1, A2, A3, A4, A5, A6, A7: Word);
procedure Proc5_2ECC(A0, A1, A2, A3, A4, A5, A6: Word);
procedure Proc5_2F4E(A0, A1, A2, A3, A4, A5, A6, A7: Word);
procedure Proc5_3079(A0, A1: Word);
procedure Proc5_33D0(A0, A1, A2: Word);
procedure Proc5_34A2(A0, A1, A2, A3: Word);
procedure Proc5_35EE(A0, A1, A2, A3: Word);
procedure Proc5_361F;
procedure Proc5_38F8;
procedure Proc5_394C(A0, A1, A2, A3, A4, A5, A6: Word);
procedure Proc5_3DD0;
procedure Proc5_3E3A(A0, A1: Word);
procedure Proc5_3E41(A0, A1: Word);
var
  Pad3D9E: array[0..17] of Byte;
  W3DB0: Word;
  Pad3DB2: array[0..27] of Byte;

type
  TAuktionsform = class(TForm)
    AuktionsImage: TImage;
    Timer1: TTimer;
    Timer2: TTimer;
    Timer3: TTimer;
    leiste: TImage;
    knopfimage: TImage;
  published
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
    procedure leisteMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure leisteMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure leisteMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure knopfimageMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure knopfimageMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  end;
  TSabowin = class(TForm)
    Saboimage: TImage;
  published
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure SaboimageMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure SaboimageMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure SaboimageMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Schreibaufpressedbutton;
    procedure Schreibaufunpressedbutton;
    procedure Malbuttonunpressed;
    procedure ErneuerFenster;
    procedure Malbuttonpressed;
    procedure Textefestlegen;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  end;

implementation

uses DATEN, BAUFEN, DATWIN, GFX, KOMPASS, HAUS, GELD, SEG15, ANIM, SOUND, BAUEN, MAP;

{$F-}
{ ADDRESS: MAIN 0x000501d4 }
procedure Proc5_01D4;
begin
end;
{$F+}

{$F-}
{ ADDRESS: MAIN 0x00050221 }
procedure Proc5_0221;
begin
end;
{$F+}

{ ADDRESS: MAIN 0x00050476 }
procedure Proc5_0476;
begin
end;

{$F-}
{ ADDRESS: MAIN 0x000505a3 }
procedure Proc5_05A3;
begin
end;
{$F+}

{ ADDRESS: MAIN 0x000508ac }
procedure Proc5_08AC;
begin
end;

{$F-}
{ ADDRESS: MAIN 0x000508e7 }
procedure Proc5_08E7;
begin
end;
{$F+}

{$F-}
{ ADDRESS: MAIN 0x00050c82 }
procedure Proc5_0C82;
begin
end;
{$F+}

{$F-}
{ ADDRESS: MAIN 0x00050dde }
procedure Proc5_0DDE;
begin
end;
{$F+}

{$F-}
{ ADDRESS: MAIN 0x000515ef }
procedure Proc5_15EF;
begin
end;
{$F+}

procedure Proc5_190D;
begin
end;

procedure Proc5_1940;
begin
end;

procedure Proc5_1973;
begin
end;

procedure Proc5_1B77;
begin
end;

procedure Proc5_1C4D;
begin
end;

procedure Proc5_1CE0;
begin
end;

procedure Proc5_1E23;
begin
end;

procedure Proc5_2208;
begin
end;

{ ADDRESS: MAIN 0x00052449 }
procedure Proc5_2449;
begin
end;

{ ADDRESS: MAIN 0x000524f1 }
procedure Proc5_24F1;
begin
end;

{ ADDRESS: MAIN 0x00052506 }
procedure Proc5_2506;
begin
end;

{ ADDRESS: MAIN 0x000525f4 }
procedure Proc5_25F4;
begin
end;

procedure Proc5_26E4;
begin
end;

{$F-}
{ ADDRESS: MAIN 0x00052ad7 }
procedure Proc5_2AD7;
begin
end;
{$F+}

procedure Proc5_2B24;
begin
end;

procedure Proc5_2B9F;
begin
end;

procedure Proc5_2C18;
begin
end;

procedure Proc5_2C62;
begin
end;

procedure Proc5_2D67;
begin
end;

procedure Proc5_2ECC;
begin
end;

procedure Proc5_2F4E;
begin
end;

procedure Proc5_3079;
begin
end;

procedure Proc5_33D0;
begin
end;

procedure Proc5_34A2;
begin
end;

procedure Proc5_35EE;
begin
end;

{ ADDRESS: MAIN 0x0005361f }
procedure Proc5_361F;
begin
end;

{ ADDRESS: MAIN 0x000538f8 }
procedure Proc5_38F8;
begin
end;

procedure Proc5_394C;
begin
end;

{$F-}
{ ADDRESS: MAIN 0x00053a68 }
procedure Proc5_3A68;
begin
end;
{$F+}

{$F-}
{ ADDRESS: MAIN 0x00053b7c }
procedure Proc5_3B7C;
begin
end;
{$F+}

{$F-}
{ ADDRESS: MAIN 0x00053c90 }
procedure Proc5_3C90;
begin
end;
{$F+}

{$F-}
{ ADDRESS: MAIN 0x00053cb1 }
procedure Proc5_3CB1(A0: Word);
begin
end;
{$F+}

{$F-}
{ ADDRESS: MAIN 0x00053d25 }
procedure Proc5_3D25;
begin
  Proc5_3CB1(1);
end;
{$F+}

{$F-}
{ ADDRESS: MAIN 0x00053d2f }
procedure Proc5_3D2F;
begin
  Proc5_3CB1(1);
end;
{$F+}

{$F-}
{ ADDRESS: MAIN 0x00053d39 }
procedure Proc5_3D39;
begin
  Proc5_3CB1(1);
end;
{$F+}

{$F-}
{ ADDRESS: MAIN 0x00053d43 }
procedure Proc5_3D43;
begin
  Proc5_3CB1(1);
end;
{$F+}

{$F-}
{ ADDRESS: MAIN 0x00053d4d }
procedure Proc5_3D4D;
begin
  Proc5_3CB1(1);
end;
{$F+}

{$F-}
{ ADDRESS: MAIN 0x00053d57 }
procedure Proc5_3D57;
begin
  Proc5_3CB1(1);
end;
{$F+}

{$F-}
{ ADDRESS: MAIN 0x00053d61 }
procedure Proc5_3D61;
begin
  Proc5_3CB1(1);
end;
{$F+}

{$F-}
{ ADDRESS: MAIN 0x00053d6b }
procedure Proc5_3D6B;
begin
  Proc5_3CB1(1);
end;
{$F+}

{$F-}
{ ADDRESS: MAIN 0x00053d75 }
procedure Proc5_3D75;
begin
  Proc5_3CB1(1);
end;
{$F+}

{$F-}
{ ADDRESS: MAIN 0x00053d7f }
procedure Proc5_3D7F;
begin
  Proc5_3CB1(1);
end;
{$F+}

{$F-}
{ ADDRESS: MAIN 0x00053d89 }
procedure Proc5_3D89;
begin
  Proc5_3CB1(1);
end;
{$F+}

{$F-}
{ ADDRESS: MAIN 0x00053d93 }
procedure Proc5_3D93;
begin
end;
{$F+}

{ ADDRESS: MAIN 0x00053dd0 }
procedure Proc5_3DD0;
begin
end;

{ ADDRESS: MAIN 0x00053e3a }
procedure Proc5_3E3A;
begin
end;

{ ADDRESS: MAIN 0x00053e41 }
procedure Proc5_3E41;
begin
end;

{ ADDRESS: MAIN 0x0005190d }
procedure TAuktionsform.Timer1Timer(Sender: TObject);
begin
end;

{ ADDRESS: MAIN 0x00051940 }
procedure TAuktionsform.Timer2Timer(Sender: TObject);
begin
end;

{ ADDRESS: MAIN 0x00051973 }
procedure TAuktionsform.Timer3Timer(Sender: TObject);
begin
end;

{ ADDRESS: MAIN 0x00051b77 }
procedure TAuktionsform.leisteMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
end;

{ ADDRESS: MAIN 0x00051c4d }
procedure TAuktionsform.leisteMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
end;

{ ADDRESS: MAIN 0x00051ce0 }
procedure TAuktionsform.leisteMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
end;

{ ADDRESS: MAIN 0x00051e23 }
procedure TAuktionsform.knopfimageMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
end;

{ ADDRESS: MAIN 0x00052208 }
procedure TAuktionsform.knopfimageMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
end;

{ ADDRESS: MAIN 0x000526e4 }
procedure TAuktionsform.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
end;

{ ADDRESS: MAIN 0x000534a2 }
procedure TSabowin.FormShow;
begin
end;

{ ADDRESS: MAIN 0x000535ee }
procedure TSabowin.FormHide;
begin
end;

{ ADDRESS: MAIN 0x00052d67 }
procedure TSabowin.SaboimageMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
end;

{ ADDRESS: MAIN 0x00052ecc }
procedure TSabowin.SaboimageMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
end;

{ ADDRESS: MAIN 0x00052f4e }
procedure TSabowin.SaboimageMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
end;

{ ADDRESS: MAIN 0x00052b24 }
procedure TSabowin.Schreibaufpressedbutton;
begin
end;

{ ADDRESS: MAIN 0x00052b9f }
procedure TSabowin.Schreibaufunpressedbutton;
begin
end;

{ ADDRESS: MAIN 0x00052c18 }
procedure TSabowin.Malbuttonunpressed;
begin
end;

{ ADDRESS: MAIN 0x000533d0 }
procedure TSabowin.ErneuerFenster;
begin
end;

{ ADDRESS: MAIN 0x00052c62 }
procedure TSabowin.Malbuttonpressed;
begin
end;

{ ADDRESS: MAIN 0x00053079 }
procedure TSabowin.Textefestlegen;
begin
end;

{ ADDRESS: MAIN 0x0005394c }
procedure TSabowin.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
end;
begin
  Proc5_3D25;
  Proc5_3D2F;
  Proc5_3D39;
  Proc5_3D43;
  Proc5_3D4D;
  Proc5_3D57;
  Proc5_3D61;
  Proc5_3D6B;
  Proc5_3D75;
  Proc5_3D7F;
  Proc5_3D89;
  Proc5_3E3A(0, 0);
  Proc5_3E41(0, 0);
end.
