unit HIGHSCOR;
{ Reconstructed scaffold, holiday.exe code segment 8 (16070 bytes).
  This is unit holding TDateimenue, THelpform, TPauseform, TWasNunForm, Thighscoreform; the
  original kept its forms inside the segment's own  unit (docs/tree.md).
  Evidence: form TDateimenue (1 components), form THelpform (1 components), form TPauseform (1
  components), form TWasNunForm (1 components), form Thighscoreform (1 components).
  `uses` comes from this segment's relocation records, the class members
  from RTTI and form streams. Known close-handler bodies are recovered;
  other method bodies remain stubs. }
{$F+}
interface

uses Buttons, ExtCtrls, Graphics, Controls, Forms, Classes, SysUtils;

type
  TBlk8 = packed record
    Pad180: array[0..$17F] of Byte;
    F180: Pointer;
    F184: Pointer;
    F188: Pointer;
    F18C: Pointer;
    Pad190: array[0..$AF7] of Byte;
    FC88: Pointer;
  end;
  PBlk8 = ^TBlk8;
  TBlob8 = packed record
    Pad: array[0..0] of Byte;
  end;
  PBlob8 = ^TBlob8;
  TDisp14 = packed record
    Pad0: array[0..19] of Byte;
    H14: procedure(A0, A1: Pointer);
  end;
  PDisp14 = ^TDisp14;
  TSub292 = packed record
    Pad0: array[0..8] of Byte;
    Disp: PDisp14;
    Rest: array[0..5] of Byte;
  end;
  TRec8 = packed record
    Pad22: array[0..$21] of Byte;
    W22: Word;
    W24: Word;
    Pad26: array[0..$155] of Byte;
    F17C: PBlob8;
    W180: Word;
    F182: string;
    Buf: Pointer;
    P286: Pointer;
    Pad28A: array[0..7] of Byte;
    Sub292: TSub292;
    L2A5: LongInt;
  end;
  PRec8 = ^TRec8;
  PByte8 = ^Byte;
  TObj8 = object
    Pad23: array[1..36] of Byte;
    W24: Word;
    procedure Probe;
  end;
  TDisp8 = record
    Pad: array[0..$1F] of Byte;
    Handler: function(A0, A1: Word; A2, A3: Pointer): Byte;
  end;
  PDisp8 = ^TDisp8;
  TItem8 = packed record
    Pad: array[0..8] of Byte;
    Disp: PDisp8;
    Rest: array[0..266] of Byte;
  end;
  TOuter8 = packed record
    Pad0: array[0..$17B] of Byte;
    F17C: Pointer;
    Pad180: array[0..15] of Byte;
    Items: array[0..2] of TItem8;
  end;
  POuter8 = ^TOuter8;
  TRow8 = string;
  TGrid8 = array[0..3] of TRow8;
  PGrid8 = ^TGrid8;
  TRecLad8 = packed record
    Pad: array[0..281] of Byte;
  end;
  THLad8 = packed record
    Pad17C: array[0..$17B] of Byte;
    L17C: LongInt;
    Pad184: array[0..$351] of Byte;
    Items: array[0..6] of TRecLad8;
  end;
  PHLad8 = ^THLad8;
  TDisp1C8 = packed record
    Pad0: array[0..27] of Byte;
    H1C: function(A0, A1: Word; A2, A3: Pointer): Boolean;
  end;
  PDisp1C8 = ^TDisp1C8;
  TItemD8 = packed record
    Pad0: array[0..8] of Byte;
    Disp: PDisp1C8;
    Rest: array[0..264] of Byte;
  end;
  TObs31BC = packed record
    Pad0: array[0..$17B] of Byte;
    F17C: PBlob8;
    Pad180: array[0..15] of Byte;
    Items: array[0..2] of TItemD8;
    Cells: array[0..6] of TRecLad8;
  end;
procedure Far22C6(var A0);
procedure Far56CE(A0: Pointer);
procedure Far20C4(A0: Pointer);
procedure Far17E1(A0: Word; A1: TObj8);
procedure Far19C(A0: Pointer; A1: Word);
procedure Proc8_0180(A0, A1: Word);
procedure Proc8_0192(A0, A1, A2, A3, A4, A5, A6: Word);
procedure Proc8_0244(A0, A1: Word);
procedure Proc8_0286(A0, A1: Word);
procedure Proc8_02C8(A0, A1: Word);
procedure Proc8_0327(A0, A1, A2: Word);
procedure Proc8_03E5(A0, A1, A2, A3, A4: Word);
procedure Proc8_0460(A0, A1, A2, A3, A4: Word);
procedure Proc8_04D9(A0, A1, A2: Word);
procedure Proc8_05A4(A0, A1, A2: Word);
procedure Proc8_073C(A0, A1, A2, A3, A4, A5, A6, A7: Word);
procedure Proc8_09CA(A0, A1, A2, A3, A4, A5, A6: Word);
procedure Proc8_0A4C(A0, A1, A2, A3, A4, A5, A6, A7: Word);
procedure Proc8_0CD3(A0, A1, A2, A3, A4, A5, A6: Word);
procedure Proc8_0E03(A0, A1: Word);
procedure Proc8_0F27(A0, A1: Word);
procedure Proc8_1175(A0, A1: Word);
procedure Proc8_11F2(A0, A1: Word);
procedure Proc8_12BE(A0, A1, A2, A3: Word);
procedure Proc8_1525(A0, A1, A2, A3: Word);
procedure Proc8_154D;
procedure Proc8_1564(A0, A1: Word);
procedure Proc8_156B(A0, A1: Word);
procedure Proc8_1572(A0, A1, A2, A3, A4, A5, A6: Word);
procedure Proc8_1853(A0, A1: Word);
procedure Proc8_1B5C(A0, A1: Word);
procedure Proc8_1BA5(A0, A1: Word);
procedure Proc8_1BC2(A0, A1: Word);
procedure Proc8_1BDF(A0, A1, A2, A3, A4, A5, A6, A7, A8, A9: Word);
procedure Proc8_1CA7(A0, A1: Word);
procedure Proc8_1D49(A0: Pointer);
procedure Proc8_1F38(A0, A1: Word);
procedure Proc8_1FFD(A0, A1: Word);
procedure Proc8_20C2(A0, A1: Word);
procedure Proc8_2187(A0, A1: Word);
procedure Proc8_224C(A0, A1: Word);
procedure Proc8_2311(A0, A1: Word);
procedure Proc8_23D6(A0, A1: Word);
procedure Proc8_24A8(A0, A1: Word);
procedure Proc8_2517(A0, A1: Word);
procedure Proc8_2579(A0, A1: Word);
procedure Proc8_284C(A0, A1: Word);
procedure Proc8_2BF0(A0, A1: Word);
procedure Proc8_310A(P: PBlk8);
procedure Proc8_315C(A0, A1: Word);
procedure Proc8_3183(A0, A1: Word);
procedure Proc8_31BC(A0, A1, A2: Word; A3: Byte; A4, A5: Word; var A6: TObs31BC);
procedure Proc8_3347(A0, A1, A2, A3, A4, A5: Word; P: POuter8);
procedure Proc8_34AF(A0, A1: Word);
procedure Proc8_355F(A0, A1: Word);
procedure Proc8_372C(P: PRec8);
procedure Proc8_3748(A0: ShortInt; A1: PRec8);
procedure Proc8_376E(A0: Word; A1: Pointer);
procedure Proc8_37D8(A0: string; A1: Word; A2: PRec8);
procedure Far15E7(A0, A1: Pointer; A2: Word);
function Far0E60(A0, A1: Word; A2: Pointer; var A3): Pointer;
procedure Far1B39(A0: Pointer);
procedure Proc8_38A1(A0, A1: Word);
procedure Proc8_390F(P: PRec8);
procedure Proc8_3A45(A0, A1: Word);
procedure Proc8_3BAC(A0: Pointer);
procedure Proc8_3BF4(A0, A1: Word; P: Pointer);
procedure Proc8_3C05(A0, A1, A2, A3, A4: Word; P: Pointer);
procedure Proc8_3C16(A0, A1: Word; P: PByte8; A4, A5: Word);
procedure Proc8_3D02(A0, A1: Word);
procedure Proc8_3DB1(A0, A1: Word);
procedure Proc8_3DC7(A0, A1, A2, A3, A4: Word);


type
  TDateimenue = class(TForm)
    Dateimenuebild: TImage;
  private
    { shortcut: opaque private storage; name fields as accesses are recovered. }
    UnrecoveredState: array[0..863] of Byte;
  published
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure DateimenuebildMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure DateimenuebildMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure DateimenuebildMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure EditierfensterKeyDown;
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  end;
  THelpform = class(TForm)
    Bild: TImage;
  private
    { shortcut: opaque private storage; name fields as accesses are recovered. }
    UnrecoveredState: array[0..4] of Byte;
  end;
  TPauseform = class(TForm)
    Pausebild: TImage;
  private
    { shortcut: opaque private storage; name fields as accesses are recovered. }
    UnrecoveredState: array[0..3] of Byte;
  published
    procedure PausebildClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  end;
  TWasNunForm = class(TForm)
    Bild: TImage;
  private
    { shortcut: opaque private storage; name fields as accesses are recovered. }
    UnrecoveredState: array[0..296] of Byte;
  end;
  Thighscoreform = class(TForm)
    Bild: TImage;
  private
    { shortcut: opaque private storage; name fields as accesses are recovered. }
    UnrecoveredState: array[0..2828] of Byte;
  published
    procedure BildMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure BildMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  end;

implementation

uses DATEN, DATWIN, GFX, HAUS, SOUND, MAP, SEG24;

procedure Far22C6(var A0);
begin
end;

procedure Far56CE(A0: Pointer);
begin
end;

procedure Far20C4(A0: Pointer);
begin
end;

procedure Far17E1(A0: Word; A1: TObj8);
begin
end;

procedure Far19C(A0: Pointer; A1: Word);
begin
end;

{$F-}
function Proc8_0D0F(Src: string): Boolean;
var
  I: Integer;
begin
  Proc8_0D0F := True;
  if Length(Src) < 1 then
    Proc8_0D0F := False
  else if Length(Src) > 8 then
    Proc8_0D0F := False
  else if not ((((Src[1] >= 'a') and (Src[1] <= 'z')) or
                ((Src[1] >= 'A') and (Src[1] <= 'Z')))) then
    Proc8_0D0F := False
  else
    for I := 2 to Length(Src) do
      if not ((((Src[I] >= 'a') and (Src[I] <= 'z')) or
               ((Src[I] >= 'A') and (Src[I] <= 'Z')) or
               ((Src[I] >= '0') and (Src[I] <= '9')) or
               (Src[I] = '_'))) then
        Proc8_0D0F := False;
end;
{$F+}

procedure Proc8_0180;
begin
end;

procedure Proc8_0192;
begin
end;

procedure Proc8_0244;
begin
end;

procedure Proc8_0286;
begin
end;

procedure Proc8_02C8;
begin
end;

{$F-}
procedure Proc8_02DA;
begin
end;
{$F+}

procedure Proc8_0327;
begin
end;

procedure Proc8_03E5;
begin
end;

procedure Proc8_0460;
begin
end;

procedure Proc8_04D9;
begin
end;

procedure Proc8_05A4;
begin
end;

procedure Proc8_073C;
begin
end;

procedure Proc8_09CA;
begin
end;

procedure Proc8_0A4C;
begin
end;

procedure Proc8_0CD3;
begin
end;

procedure Proc8_0E03;
begin
end;

procedure Proc8_0F27;
begin
end;

{$F-}
procedure Proc8_0FB0;
begin
end;
{$F+}

{$F-}
procedure Proc8_0FBD;
begin
end;
{$F+}

{$F-}
procedure Proc8_0FFF;
begin
end;
{$F+}

{$F-}
procedure Proc8_106F;
begin
end;
{$F+}

{$F-}
procedure Proc8_10E5;
begin
end;
{$F+}

procedure Proc8_1175;
begin
end;

procedure Proc8_11F2;
begin
end;

procedure Proc8_12BE;
begin
end;

procedure Proc8_1525;
begin
end;

procedure Proc8_154D;
begin
end;

procedure Proc8_1564(A0, A1: Word);
begin
end;

procedure Proc8_156B(A0, A1: Word);
begin
end;

procedure Proc8_1572;
begin
end;

procedure Proc8_1853;
begin
end;

procedure Proc8_1B5C;
begin
end;

procedure Proc8_1BA5;
begin
end;

procedure Proc8_1BC2;
begin
end;

procedure Proc8_1BDF;
begin
end;

procedure Proc8_1CA7;
begin
end;

procedure Proc8_1D49(A0: Pointer);
begin
end;

procedure Proc8_1F38(A0, A1: Word);
begin
  Proc24_06FE(PHLad8(G6EE0)^.L17C, @PHLad8(G6EE0)^.Items[1]);
  Proc24_06FE(PHLad8(G6EE0)^.L17C, @PHLad8(G6EE0)^.Items[2]);
  Proc24_06FE(PHLad8(G6EE0)^.L17C, @PHLad8(G6EE0)^.Items[3]);
  Proc24_06FE(PHLad8(G6EE0)^.L17C, @PHLad8(G6EE0)^.Items[4]);
  Proc24_06FE(PHLad8(G6EE0)^.L17C, @PHLad8(G6EE0)^.Items[5]);
  Proc24_06FE(PHLad8(G6EE0)^.L17C, @PHLad8(G6EE0)^.Items[6]);
  G6EE8 := 1;
  Proc8_1D49(G6EE0);
end;

procedure Proc8_1FFD(A0, A1: Word);
begin
  Proc24_06FE(PHLad8(G6EE0)^.L17C, @PHLad8(G6EE0)^.Items[0]);
  Proc24_06FE(PHLad8(G6EE0)^.L17C, @PHLad8(G6EE0)^.Items[2]);
  Proc24_06FE(PHLad8(G6EE0)^.L17C, @PHLad8(G6EE0)^.Items[3]);
  Proc24_06FE(PHLad8(G6EE0)^.L17C, @PHLad8(G6EE0)^.Items[4]);
  Proc24_06FE(PHLad8(G6EE0)^.L17C, @PHLad8(G6EE0)^.Items[5]);
  Proc24_06FE(PHLad8(G6EE0)^.L17C, @PHLad8(G6EE0)^.Items[6]);
  G6EE8 := 2;
  Proc8_1D49(G6EE0);
end;

procedure Proc8_20C2(A0, A1: Word);
begin
  Proc24_06FE(PHLad8(G6EE0)^.L17C, @PHLad8(G6EE0)^.Items[0]);
  Proc24_06FE(PHLad8(G6EE0)^.L17C, @PHLad8(G6EE0)^.Items[1]);
  Proc24_06FE(PHLad8(G6EE0)^.L17C, @PHLad8(G6EE0)^.Items[3]);
  Proc24_06FE(PHLad8(G6EE0)^.L17C, @PHLad8(G6EE0)^.Items[4]);
  Proc24_06FE(PHLad8(G6EE0)^.L17C, @PHLad8(G6EE0)^.Items[5]);
  Proc24_06FE(PHLad8(G6EE0)^.L17C, @PHLad8(G6EE0)^.Items[6]);
  G6EE8 := 3;
  Proc8_1D49(G6EE0);
end;

procedure Proc8_2187(A0, A1: Word);
begin
  Proc24_06FE(PHLad8(G6EE0)^.L17C, @PHLad8(G6EE0)^.Items[0]);
  Proc24_06FE(PHLad8(G6EE0)^.L17C, @PHLad8(G6EE0)^.Items[1]);
  Proc24_06FE(PHLad8(G6EE0)^.L17C, @PHLad8(G6EE0)^.Items[2]);
  Proc24_06FE(PHLad8(G6EE0)^.L17C, @PHLad8(G6EE0)^.Items[4]);
  Proc24_06FE(PHLad8(G6EE0)^.L17C, @PHLad8(G6EE0)^.Items[5]);
  Proc24_06FE(PHLad8(G6EE0)^.L17C, @PHLad8(G6EE0)^.Items[6]);
  G6EE8 := 4;
  Proc8_1D49(G6EE0);
end;

procedure Proc8_224C(A0, A1: Word);
begin
  Proc24_06FE(PHLad8(G6EE0)^.L17C, @PHLad8(G6EE0)^.Items[0]);
  Proc24_06FE(PHLad8(G6EE0)^.L17C, @PHLad8(G6EE0)^.Items[1]);
  Proc24_06FE(PHLad8(G6EE0)^.L17C, @PHLad8(G6EE0)^.Items[2]);
  Proc24_06FE(PHLad8(G6EE0)^.L17C, @PHLad8(G6EE0)^.Items[3]);
  Proc24_06FE(PHLad8(G6EE0)^.L17C, @PHLad8(G6EE0)^.Items[5]);
  Proc24_06FE(PHLad8(G6EE0)^.L17C, @PHLad8(G6EE0)^.Items[6]);
  G6EE8 := 5;
  Proc8_1D49(G6EE0);
end;

procedure Proc8_2311(A0, A1: Word);
begin
  Proc24_06FE(PHLad8(G6EE0)^.L17C, @PHLad8(G6EE0)^.Items[0]);
  Proc24_06FE(PHLad8(G6EE0)^.L17C, @PHLad8(G6EE0)^.Items[1]);
  Proc24_06FE(PHLad8(G6EE0)^.L17C, @PHLad8(G6EE0)^.Items[2]);
  Proc24_06FE(PHLad8(G6EE0)^.L17C, @PHLad8(G6EE0)^.Items[3]);
  Proc24_06FE(PHLad8(G6EE0)^.L17C, @PHLad8(G6EE0)^.Items[4]);
  Proc24_06FE(PHLad8(G6EE0)^.L17C, @PHLad8(G6EE0)^.Items[6]);
  G6EE8 := 6;
  Proc8_1D49(G6EE0);
end;

procedure Proc8_23D6(A0, A1: Word);
begin
  Proc24_06FE(PHLad8(G6EE0)^.L17C, @PHLad8(G6EE0)^.Items[0]);
  Proc24_06FE(PHLad8(G6EE0)^.L17C, @PHLad8(G6EE0)^.Items[1]);
  Proc24_06FE(PHLad8(G6EE0)^.L17C, @PHLad8(G6EE0)^.Items[2]);
  Proc24_06FE(PHLad8(G6EE0)^.L17C, @PHLad8(G6EE0)^.Items[3]);
  Proc24_06FE(PHLad8(G6EE0)^.L17C, @PHLad8(G6EE0)^.Items[4]);
  Proc24_06FE(PHLad8(G6EE0)^.L17C, @PHLad8(G6EE0)^.Items[5]);
  G6EE8 := 0;
  Proc8_1D49(G6EE0);
end;

procedure Proc8_24A8;
begin
end;

procedure Proc8_2517;
begin
end;

procedure Proc8_2579;
begin
end;

procedure Proc8_284C;
begin
end;

procedure Proc8_2BF0;
begin
end;

procedure Proc8_310A(P: PBlk8);
begin
  Far20C4(P^.FC88);
  Far20C4(P^.F180);
  Far20C4(P^.F184);
  Far20C4(P^.F188);
  Far20C4(P^.F18C);
end;

procedure Proc8_315C;
begin
end;

procedure Proc8_3183;
begin
end;

procedure Proc8_31BC(A0, A1, A2: Word; A3: Byte; A4, A5: Word; var A6: TObs31BC);
begin
  if ((A3 and 8) <> 0)
     and (A6.Items[0].Disp^.H1C(A4, A5, A6.F17C, @A6.Items[0])
          or A6.Items[1].Disp^.H1C(A4, A5, A6.F17C, @A6.Items[1])
          or A6.Items[2].Disp^.H1C(A4, A5, A6.F17C, @A6.Items[2])
          or Proc24_0666(A4, A5, A6.F17C, @A6.Cells[0])
          or Proc24_0666(A4, A5, A6.F17C, @A6.Cells[1])
          or Proc24_0666(A4, A5, A6.F17C, @A6.Cells[2])
          or Proc24_0666(A4, A5, A6.F17C, @A6.Cells[3])
          or Proc24_0666(A4, A5, A6.F17C, @A6.Cells[4])
          or Proc24_0666(A4, A5, A6.F17C, @A6.Cells[5])
          or Proc24_0666(A4, A5, A6.F17C, @A6.Cells[6])) then
    Far22C6(A6.F17C^);
end;

procedure Proc8_3347(A0, A1, A2, A3, A4, A5: Word; P: POuter8);
label Tail, Done;
begin
  if P^.Items[0].Disp^.Handler(A4, A5, P^.F17C, @P^.Items[0]) <> 0 then goto Tail;
  if P^.Items[1].Disp^.Handler(A4, A5, P^.F17C, @P^.Items[1]) <> 0 then goto Tail;
  if P^.Items[2].Disp^.Handler(A4, A5, P^.F17C, @P^.Items[2]) = 0 then goto Done;
Tail:
  Far22C6(P^.F17C^);
Done:
end;

procedure Proc8_34AF;
begin
end;

procedure Proc8_355F;
begin
end;

procedure Proc8_372C(P: PRec8);
begin
  Far19C(P^.Buf, $400);
end;

procedure Proc8_3748(A0: ShortInt; A1: PRec8);
begin
  Proc8_37D8(PGrid8(A1^.Buf)^[A0], 0, A1);
end;

procedure Proc8_376E(A0: Word; A1: Pointer);
begin
end;

procedure Proc8_37D8(A0: string; A1: Word; A2: PRec8);
begin
  A2^.W180 := A1;
  Far15E7(@A0, @A2^.F182, $FF);
  Far1B39(Far0E60(0, 0, A2^.P286, A2^.F17C^));
  A2^.L2A5 := A2^.W180;
  A2^.Sub292.Disp^.H14(A2^.F17C, @A2^.Sub292);
  Proc6_23D3(A2^.F17C, 9, 0, $15, A2^.W22, 1, 1, A2^.F182);
  Far22C6(A2^.F17C^);
end;

procedure Far15E7(A0, A1: Pointer; A2: Word);
begin
end;

function Far0E60(A0, A1: Word; A2: Pointer; var A3): Pointer;
begin
end;

procedure Far1B39(A0: Pointer);
begin
end;

procedure Proc8_38A1;
begin
end;

procedure Proc8_390F(P: PRec8);
begin
  Far56CE(P);
  Proc8_372C(P);
end;

procedure Proc8_3A45;
begin
end;

procedure Proc8_3BAC(A0: Pointer);
begin
end;

procedure Proc8_3BF4(A0, A1: Word; P: Pointer);
begin
  Proc8_3BAC(P);
end;

procedure Proc8_3C05(A0, A1, A2, A3, A4: Word; P: Pointer);
begin
  Proc8_3BAC(P);
end;

procedure Proc8_3C16(A0, A1: Word; P: PByte8; A4, A5: Word);
begin
  P^ := 2;
end;

procedure Proc8_3D02;
begin
end;

procedure Proc8_3DB1;
begin
end;

procedure Proc8_3DC7;
begin
end;

procedure TObj8.Probe;
begin
  if W24 <> 0 then
    Far17E1(0, Self);
end;

procedure TDateimenue.FormShow;
begin
end;

procedure TDateimenue.FormHide;
begin
end;

procedure TDateimenue.DateimenuebildMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
end;

procedure TDateimenue.DateimenuebildMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
end;

procedure TDateimenue.DateimenuebildMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
end;

procedure TDateimenue.EditierfensterKeyDown;
begin
end;

procedure TDateimenue.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
end;

procedure TPauseform.PausebildClick(Sender: TObject);
begin
end;

procedure TPauseform.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
end;

procedure TPauseform.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure Thighscoreform.BildMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
end;

procedure Thighscoreform.BildMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
end;
procedure CallersInit8;
var
  CheckName: string;
  State8: TObj8;
  Obs31BC: TObs31BC;
begin
  CheckName := 'A';
  if Proc8_0D0F(CheckName) then
    CheckName := 'B';
  Proc8_1564(0, 0);
  Proc8_156B(0, 0);
  Proc8_310A(nil);
  Proc8_372C(nil);
  Proc8_390F(nil);
  Proc8_3BF4(0, 0, nil);
  Proc8_3C05(0, 0, 0, 0, 0, nil);
  Proc8_3C16(0, 0, nil, 0, 0);
  State8.Probe;
  Proc8_31BC(0, 0, 0, 0, 0, 0, Obs31BC);
  Proc8_3347(0, 0, 0, 0, 0, 0, nil);
  Proc8_3748(0, nil);
  Proc8_1F38(0, 0);
  Proc8_1FFD(0, 0);
  Proc8_20C2(0, 0);
  Proc8_2187(0, 0);
  Proc8_224C(0, 0);
  Proc8_2311(0, 0);
  Proc8_23D6(0, 0);
end;

begin
  CallersInit8;
end.
