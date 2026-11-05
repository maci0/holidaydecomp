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
procedure Proc5_01D4;
begin
end;
{$F+}

{$F-}
procedure Proc5_0221;
begin
end;
{$F+}

procedure Proc5_0476;
begin
end;

{$F-}
procedure Proc5_05A3;
begin
end;
{$F+}

procedure Proc5_08AC;
begin
end;

{$F-}
procedure Proc5_08E7;
begin
end;
{$F+}

{$F-}
procedure Proc5_0C82;
begin
end;
{$F+}

{$F-}
procedure Proc5_0DDE;
begin
end;
{$F+}

{$F-}
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

procedure Proc5_2449;
begin
end;

procedure Proc5_24F1;
begin
end;

procedure Proc5_2506;
begin
end;

procedure Proc5_25F4;
begin
end;

procedure Proc5_26E4;
begin
end;

{$F-}
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

procedure Proc5_361F;
begin
end;

procedure Proc5_38F8;
begin
end;

procedure Proc5_394C;
begin
end;

{$F-}
procedure Proc5_3A68;
begin
end;
{$F+}

{$F-}
procedure Proc5_3B7C;
begin
end;
{$F+}

{$F-}
procedure Proc5_3C90;
begin
end;
{$F+}

{$F-}
procedure Proc5_3CB1(A0: Word);
begin
end;
{$F+}

{$F-}
procedure Proc5_3D25;
begin
  Proc5_3CB1(1);
end;
{$F+}

{$F-}
procedure Proc5_3D2F;
begin
  Proc5_3CB1(1);
end;
{$F+}

{$F-}
procedure Proc5_3D39;
begin
  Proc5_3CB1(1);
end;
{$F+}

{$F-}
procedure Proc5_3D43;
begin
  Proc5_3CB1(1);
end;
{$F+}

{$F-}
procedure Proc5_3D4D;
begin
  Proc5_3CB1(1);
end;
{$F+}

{$F-}
procedure Proc5_3D57;
begin
  Proc5_3CB1(1);
end;
{$F+}

{$F-}
procedure Proc5_3D61;
begin
  Proc5_3CB1(1);
end;
{$F+}

{$F-}
procedure Proc5_3D6B;
begin
  Proc5_3CB1(1);
end;
{$F+}

{$F-}
procedure Proc5_3D75;
begin
  Proc5_3CB1(1);
end;
{$F+}

{$F-}
procedure Proc5_3D7F;
begin
  Proc5_3CB1(1);
end;
{$F+}

{$F-}
procedure Proc5_3D89;
begin
  Proc5_3CB1(1);
end;
{$F+}

{$F-}
procedure Proc5_3D93;
begin
end;
{$F+}

procedure Proc5_3DD0;
begin
end;

procedure Proc5_3E3A;
begin
end;

procedure Proc5_3E41;
begin
end;

procedure TAuktionsform.Timer1Timer(Sender: TObject);
begin
end;

procedure TAuktionsform.Timer2Timer(Sender: TObject);
begin
end;

procedure TAuktionsform.Timer3Timer(Sender: TObject);
begin
end;

procedure TAuktionsform.leisteMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
end;

procedure TAuktionsform.leisteMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
end;

procedure TAuktionsform.leisteMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
end;

procedure TAuktionsform.knopfimageMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
end;

procedure TAuktionsform.knopfimageMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
end;

procedure TAuktionsform.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
end;

procedure TSabowin.FormShow;
begin
end;

procedure TSabowin.FormHide;
begin
end;

procedure TSabowin.SaboimageMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
end;

procedure TSabowin.SaboimageMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
end;

procedure TSabowin.SaboimageMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
end;

procedure TSabowin.Schreibaufpressedbutton;
begin
end;

procedure TSabowin.Schreibaufunpressedbutton;
begin
end;

procedure TSabowin.Malbuttonunpressed;
begin
end;

procedure TSabowin.ErneuerFenster;
begin
end;

procedure TSabowin.Malbuttonpressed;
begin
end;

procedure TSabowin.Textefestlegen;
begin
end;

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
