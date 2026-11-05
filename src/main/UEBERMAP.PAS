unit UEBERMAP;
{ Reconstructed scaffold, holiday.exe code segment 23 (21383 bytes).
  This is form unit for TUebersichtsmap2; the original kept its forms inside the segment's own
  unit (docs/tree.md).
  Evidence: form TUebersichtsmap2, 7 components.
  `uses` comes from this segment's relocation records, the class members
  from RTTI and form streams. Known close-handler bodies are recovered;
  other method bodies remain stubs. }
{$F+}
interface

uses ExtCtrls, Graphics, Controls, Forms, Classes, SysUtils;

type
  TCell21 = packed record
    F0, F1, F2, F3, F4, F5, F6: Byte;
  end;
  TCellArr21 = array[0..0] of TCell21;
  PCell21 = ^TCellArr21;
  TMap21 = packed record
    W0, W1, W2, W3, W4: Word;
    W5: Word;
    W6, W7, W8, W9: Word;
  end;
  TMapArr21 = array[0..0] of TMap21;
  PMap21 = ^TMapArr21;
  TInner = packed record
    Pad: array[0..11] of Byte;
    Sel: Word;
    More: Word;
  end;
  PInner = ^TInner;
  TOuter = packed record
    Pad: array[0..$18f] of Byte;
    Inner: PInner;
  end;
  POuter = ^TOuter;
  TOuter2 = packed record
    Pad: array[0..$193] of Byte;
    Inner: PInner;
  end;
  POuter2 = ^TOuter2;
  TCell8 = packed record W0, W1, W2, W3: Word; end;
  TRec176 = packed record Pad00: array[0..$67] of Byte; W68, W6A, W6C: Integer; end;
  TArr176 = array[0..255] of TRec176;
  PArr176 = ^TArr176;
  TGrid8 = array[0..255, 0..21] of TCell8;
  PGrid8 = ^TGrid8;
  TTab8 = array[16..255] of TCell8;
  PTab8 = ^TTab8;
  PPtr23 = ^Pointer;
  TThing23 = class(TObject)
    procedure Slot0; virtual;
    procedure Slot1; virtual;
    procedure Slot2; virtual;
    procedure Slot3; virtual;
    procedure Slot4; virtual;
    procedure Slot5; virtual;
    procedure Slot6; virtual;
    procedure Slot7; virtual;
    procedure Slot8; virtual;
    procedure Slot9; virtual;
    procedure Slot10; virtual;
    procedure Slot11; virtual;
    procedure Slot12; virtual;
  end;
  TRec18C = packed record
    Pad: array[0..$21] of Byte;
    W22: Integer;
    W24: Integer;
  end;
  PRec18C = ^TRec18C;
  TRec20N = packed record
    W0, W2: Integer;
    Pad: array[0..15] of Byte;
  end;
  TArr20N = array[0..255] of TRec20N;
  TSet7 = set of 0..7;
  TRec7372N = packed record
    Pad: array[0..9] of Byte;
    W0A: Word;
    Rest: array[0..7] of Byte;
  end;
  TArr7372N = array[0..126] of TRec7372N;
  PArr7372N = ^TArr7372N;
  TOverState23 = packed record
    F198: ShortInt;
    F199: ShortInt;
    F19A: Byte;
    F19B: Integer;
    F19D: Integer;
    F19F: Byte;
    F1A0: Word;
    F1A2: Word;
    F1A4: Byte;
    F1A5: Byte;
    F1A6: Byte;
    F1A7: Byte;
    F1A8: PTab8;
    F1AC: Pointer;
    F1B0: Word;
    F1B2: Word;
    Pad1B4: array[0..7] of Byte;
    F1BC: Integer;
    F1BE: Word;
    F1C0, F1C2: Integer;
    F1C4: Word;
    F1C6: Integer;
    F1C8: Integer;
    F1CA: Integer;
    Pad1CC: array[0..5] of Byte;
    F1D2: TThing23;
    F1D6: TThing23;
    F1DA: TThing23;
    F1DE: TThing23;
    F1E2: TThing23;
    F1E6: TThing23;
    F1EA: TThing23;
    F1EE: TThing23;
    F1F2: TThing23;
    F1F6: TThing23;
    F1FA: TThing23;
    F1FE: TThing23;
    F202: TThing23;
    F206: TThing23;
    F20A: TThing23;
    F20E: PGrid8;
    Pad212: Byte;
    F213: ShortInt;
  end;
  TOver23 = packed record
    Pad000: array[0..$23] of Byte;
    F24: Integer;
    Pad26: array[0..$159] of Byte;
    F180: Pointer;
    F184: Pointer;
    F188: Pointer;
    F18C: PRec18C;
    Pad190: array[0..7] of Byte;
    F198: ShortInt;
    F199: ShortInt;
    F19A: Byte;
    F19B: Integer;
    F19D: Integer;
    F19F: Byte;
    F1A0: Word;
    F1A2: Word;
    F1A4: Byte;
    F1A5: Byte;
    F1A6: Byte;
    F1A7: Byte;
    F1A8: PTab8;
    F1AC: Pointer;
    F1B0: Word;
    F1B2: Word;
    Pad1B4: array[0..7] of Byte;
    F1BC: Integer;
    F1BE: Word;
    F1C0, F1C2: Integer;
    F1C4: Word;
    F1C6: Integer;
    F1C8: Integer;
    F1CA: Integer;
    Pad1CC: array[0..5] of Byte;
    F1D2: TThing23;
    F1D6: TThing23;
    F1DA: TThing23;
    F1DE: TThing23;
    F1E2: TThing23;
    F1E6: TThing23;
    F1EA: TThing23;
    F1EE: TThing23;
    F1F2: TThing23;
    F1F6: TThing23;
    F1FA: TThing23;
    F1FE: TThing23;
    F202: TThing23;
    F206: TThing23;
    F20A: TThing23;
    F20E: PGrid8;
    Pad212: Byte;
    F213: ShortInt;
  end;
  POver23 = ^TOver23;
  TCallback23 = function(A0, A1: Word): Word;
  TRec6532 = packed record
    Pad: array[0..$407] of Byte;
    W408: Integer;
    W40A: Integer;
  end;
  PRec6532 = ^TRec6532;
function Const38(P: Pointer): Word;
function Const3A(P: Pointer): Word;
function Const3C(P: Pointer): Word;
procedure Arm216E(X: Integer; var O: TOuter);
procedure Arm28E5(X: Integer; var O: TOuter2);
function Proc23_02E9(A0, A1: Word; A2: Byte; A3: Pointer): Byte;
procedure Proc23_038D(X, Y: Integer; var MapY, MapX, DX, DY: Integer; var Obj: TOver23);
function Proc23_0422(A0, A1: Word; A2: Pointer): Word;
function Proc23_0443(A0, A1: Word; A2: Pointer): Word;
function Proc23_045F(A0, A1: Word): Word;
function Proc23_04B1(A0, A1: Word): Word;
function Proc23_05F8(A0, A1: Word): Word;
function Proc23_0684(A0, A1: Word): Word;
function Proc23_0786(A0, A1: Word): Word;
function Proc23_07DF(A0, A1: Word): Word;
function Proc23_08A8(A0, A1: Word): Word;
function Proc23_0934(A0, A1: Word): Word;
function Proc23_098C(A0, A1: Word): Word;
function Proc23_0A0A(A0, A1: Word): Word;
function Proc23_0B57(A0, A1: Word): Word;
function Proc23_0C10(A0, A1: Word): Word;
function Proc23_0D18(A0, A1: Word): Word;
function Proc23_0D28(A0, A1: Word): Word;
function Proc23_0D53(A0, A1: Word): Word;
function Proc23_0D63(A0, A1: Word): Word;
function Proc23_0DC2(A0, A1: Word): Word;
function Proc23_0DD2(A0, A1: Word): Word;
procedure Proc23_0EEB(A0, A1, A2, A3: Word; C0, C1: TCallback23; var Obj: TOver23);
procedure Proc23_11B4(A0, A1, A2, A3: Word; A4: Pointer);
procedure Proc23_11E1(A0, A1, A2, A3: Word; A4: Pointer);
procedure Proc23_120E(A0, A1, A2, A3: Word; A4: Pointer);
procedure Proc23_123B(A0, A1, A2, A3: Word; A4: Pointer);
procedure Proc23_1268(A0, A1, A2, A3: Word; A4: Pointer);
procedure Proc23_1295(A0, A1, A2, A3: Word; A4: Pointer);
procedure Proc23_12C2(A0, A1, A2, A3: Word; A4: Pointer);
procedure Proc23_12EF(A0, A1, A2, A3: Word; A4: Pointer);
procedure Proc23_131C(A0, A1, A2, A3: Word; A4: Pointer);
procedure Proc23_1349(var Obj: TOver23);
procedure Proc23_1485(var Obj: TOver23);
procedure Proc23_1504(A0, A1, A2, A3: Word; A4: Pointer);
procedure Proc23_1534(A0, A1, A2, A3: Word; A4: Pointer);
procedure Proc23_1564(A0, A1, A2, A3: Word; A4: Pointer);
procedure Proc23_1594(A0, A1, A2, A3: Word; A4: Pointer);
procedure Proc23_15C4(A0, A1, A2, A3: Word; A4: Pointer);
procedure Proc23_15F4(A0, A1, A2, A3: Word; A4: Pointer);
procedure Proc23_1624(A0, A1, A2, A3: Word; A4: Pointer);
procedure Proc23_1654(A0, A1, A2, A3: Word; A4: Pointer);
procedure Proc23_1684(A0: Byte; A1, A2, A3, A4: Word; A5: Byte; A6: Pointer);
procedure Proc23_16FA(A0, A1, A2, A3: Word; var Obj: TOver23);
procedure Proc23_171B(A0, A1, A2, A3: Word; var Obj: TOver23);
procedure Proc23_173E(A0: Byte; A1, A2, A3, A4: Word; A5: Byte; var A6: TOver23);
procedure Proc23_1765(A0: TSet7; A1, A2, A3, A4: Word; A5, A6: Byte; var A7: TOver23);
procedure Proc23_17CF(A0: TSet7; A1, A2, A3, A4: Word; A5: Byte; var A6: TOver23);
procedure Proc23_1A49(A0: Pointer);
procedure Proc23_1A6E(DX, DY: Integer; var Obj: TOver23);
procedure Proc23_1C74(A0, A1, A2, A3, A4, A5, A6, A7: Word);
procedure Proc23_1D21(A0, A1, A2, A3, A4, A5: Word; A6: POver23);
procedure Proc23_1E25(A0: Pointer);
procedure Proc23_1E4A(A0, A1, A2: Word; A3: Pointer);
procedure Proc23_1E73(A0, A1, A2: Word);
procedure Proc23_1E96(A0, A1: Word);
procedure Proc23_1F52(A0, A1, A2, A3: Word);
procedure Proc23_200E(A0, A1: Word);
procedure Proc23_20A5(var Obj: TOver23);
procedure Proc23_20F2(A0, A1, A2: Word);
procedure Proc23_216E(A, B: Word; R: POuter);
procedure Proc23_21C7(A0, A1, A2: Word);
procedure Proc23_21FA(A0: Pointer);
procedure Proc23_222B(A0, A1, A2, A3, A4, A5, A6, A7: Word);
procedure Proc23_2421(A0, A1, A2, A3, A4, A5, A6: Word);
procedure Proc23_24A1(A0, A1, A2, A3, A4, A5: Word; A6: POver23);
procedure Proc23_257F(A0, A1, A2: Word; A3: Pointer);
procedure Proc23_25A8(A0, A1, A2: Word);
function Proc23_25CB(A0: POver23): LongInt;
function Proc23_26A8(A0: POver23; A1: LongInt): LongInt;
procedure Proc23_2785(var Obj: TOver23);
procedure Proc23_281C(var Obj: TOver23);
procedure Proc23_2869(A0: Integer; var Obj: TOver23);
procedure Proc23_28E5(A, B: Word; R: POuter2);
procedure Proc23_293E(A0: Integer; A1: Pointer);
procedure Proc23_2971(A0: Pointer);
procedure Proc23_29A2;
procedure Proc23_2DD3(A0, A1, A2, A3, A4, A5, A6, A7: Word);
procedure Proc23_2E01(A0, A1, A2, A3, A4, A5, A6: Word);
procedure Proc23_2E99(A0, A1, A2, A3, A4, A5: Word; A6: POver23);
procedure Proc23_303E(A0: ShortInt; A1: POver23);
procedure Proc23_31F8(var A0; A1: ShortInt; var A2; var A3: TOver23);
procedure Proc23_3363(A0, A1, A2, A3, A4: Word);
procedure Proc23_346A(A0: PPtr23; A1: ShortInt; A2: PPtr23; A3: POver23);
procedure Proc23_3553(A0: Pointer);
procedure Proc23_37F5(A0, A1, A2, A3, A4, A5, A6, A7: Word);
procedure Proc23_39B1(Sender: TObject; A1: Byte; A2, A3: Integer; A4: POver23);
procedure Proc23_3AAB(A0, A1, A2, A3, A4, A5, A6, A7: Word);
procedure Proc23_3AC3(A0, A1, A2, A3, A4, A5, A6, A7: Word);
procedure Proc23_3C9B(A0, A1, A2, A3, A4, A5, A6: Word);
procedure Proc23_3D2B(A0, A1, A2, A3, A4, A5, A6, A7: Word);
procedure Proc23_3E73(var Obj: TOver23);
procedure Proc23_3EEE(A0: Pointer);
procedure Proc23_3F7F(var Obj: TOver23);
procedure Proc23_3FAB(var Obj: TOver23);
procedure Proc23_4079(A0: POver23);
procedure Proc23_41AD(A0: Pointer);
procedure Proc23_4538(A0: POver23);
function Far535A(A0: Byte; A1: Pointer): TThing23;
procedure Far15CD(A0, A1: Pointer);
procedure Far164C(A0: string);
function Far182(A0: Word): Pointer;
procedure Far179D(A0: Word; A1: Pointer);
procedure Far177B(A0: Word; A1: Pointer);
procedure Far56E1(A0: Pointer);
procedure Proc23_4B29(A0, A1: Word);
procedure Proc23_4C95(A0, A1, A2, A3, A4, A5, A6: Word);
procedure Proc23_4E34(var A0: file; var A1: TOver23);
procedure Proc23_50DE(A0, A1, A2, A3: Word);
procedure Far22C6(var A0);
function FarE60(A0: Pointer): Pointer;
function Far1F2E(A0: Pointer): Word;
function Far56AC(A0: Pointer): Pointer;
procedure Far335B(A0, A1, A2, A3, A4, A5, A6, A7, A8, A9: Word);
procedure Far354B(A0, A1, A2, A3, A4, A5, A6, A7, A8: Word);
function Far1517(A0, A1, A2, A3, A4, A5: Word): Byte;
procedure Far206A(A0, A1, A2, A3, A4, A5, A6, A7, A8, A9: Word);
procedure Far17E1(A0: Word; A1: Pointer);
procedure Far17BF(A0: Word; A1: Pointer);
procedure Far2ACE(A0, A1, A2, A3, A4, A5, A6, A7, A8, A9: Word);
procedure Far2DD3(A0, A1, A2, A3, A4, A5, A6, A7, A8, A9: Word);
procedure Far31C8(A0, A1, A2, A3, A4, A5, A6, A7, A8, A9: Word);
procedure Far3B41(A0, A1, A2, A3, A4, A5, A6, A7, A8, A9: Word);
procedure Far201C(A0: Pointer);
var
  Pad3D5C: array[0..35] of Byte;
  W3D80: Word;
  W3D82: Word;
  W3D84: Word;
  W3D86: Word;
  W3D88: Word;
  W3D8A: Word;
  W3D8C: Word;
  W3D8E: Word;
  W3D90: Word;
  W3D92: Word;

type
  TUebersichtsmap2 = class(TForm)
    Ueberschriftbild: TImage;
    Umschaltbild: TImage;
    NSScrollbild: TImage;
    Menubild: TImage;
    MapBild: TImage;
    NSScrolltimer: TTimer;
    WOScrolltimer: TTimer;
  private
    State: TOverState23;
  published
    procedure MapBildMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure MapBildMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure MapBildMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure NSScrollBildMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure NSScrollbildMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure NSScrollBildMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure NSScrolltimerTimer(Sender: TObject);
    procedure WOScrolltimerTimer(Sender: TObject);
    procedure UmschaltbildMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure UmschaltbildMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure MenubildMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure MenubildMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure MenubildMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure UeberschriftbildMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure UeberschriftbildMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure UeberschriftbildMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  end;

implementation

uses DATEN, DATWIN, GFX, SOUND, MAP, DataVal, WinProcs;

function Const38(P: Pointer): Word;
var
  R: Word;
begin
  R := $38;
  Const38 := R;
end;

function Const3A(P: Pointer): Word;
var
  R: Word;
begin
  R := $3A;
  Const3A := R;
end;

function Const3C(P: Pointer): Word;
var
  R: Word;
begin
  R := $3C;
  Const3C := R;
end;

procedure Arm216E(X: Integer; var O: TOuter);
begin
end;

procedure Arm28E5(X: Integer; var O: TOuter2);
begin
end;

function Proc23_02E9(A0, A1: Word; A2: Byte; A3: Pointer): Byte;
begin
end;

procedure Proc23_038D;
var Half: Integer;
begin
  Half := (X + Integer(Obj.F1B0)) div 2;
  MapX := ((Y + Integer(Obj.F1B2) - Half + 250 + 1000) div 2) - 500;
  DY := (Y + Integer(Obj.F1B2) - Half + 250) mod 2;
  MapY := ((Y + Integer(Obj.F1B2) + Half - 250 + 1000) div 2) - 500;
  DX := (X + Integer(Obj.F1B0)) mod 2;
end;

function Proc23_0422(A0, A1: Word; A2: Pointer): Word;
begin
  Proc23_0422 := ((A0 - A1 + 250) * 2) - POver23(A2)^.F1B0;
end;

function Proc23_0443(A0, A1: Word; A2: Pointer): Word;
begin
  Proc23_0443 := (A0 + A1) - POver23(A2)^.F1B2;
end;

function Proc23_045F;
begin
  if (MapTileA^[A0, A1] = 1) and (MapTileMid^[A0, A1] in Set1358) then
    Proc23_045F := $32
  else
    Proc23_045F := $30;
end;

function Proc23_04B1;
var
  Bytes73: array[-3..8] of Byte absolute Pair0070;
begin
  if ((MapTileA^[A0, A1] >= $0A) and (MapTileA^[A0, A1] <= $3A)) or
     ((MapTileA^[A0, A1] >= $5F) and (MapTileA^[A0, A1] <= $64)) then
    Proc23_04B1 := $18
  else if (MapTileA^[A0, A1] > $3A) and (MapTileA^[A0, A1] <= $5E) then
    Proc23_04B1 := $1A
  else if not (MapTileMid^[A0, A1] in Set1358) then
    Proc23_04B1 := (Bytes73[G5514^[A0, A1]] - 1) * 2
  else
    if MapTileA^[A0, A1] = 1 then
      Proc23_04B1 := Proc6_0F53((Integer(Map0^[A0, A1]) - 3) * 2, $24)
    else
      Proc23_04B1 := Map0^[A0, A1] * 2 + $1A;
end;

function Proc23_05F8;
begin
  if MapTileMid^[A0, A1] in Set1358 then
  begin
    if MapTileA^[A0, A1] = 1 then
      Proc23_05F8 := $36
    else if (MapTileA^[A0, A1] = 0) or (MapTileA^[A0, A1] = 4) then
      Proc23_05F8 := $34
    else
      Proc23_05F8 := $30;
  end
  else
    Proc23_05F8 := $30;
end;

function Proc23_0684;
var
  Bytes73: array[-3..8] of Byte absolute Pair0070;
begin
  if ((MapTileA^[A0, A1] >= $0A) and (MapTileA^[A0, A1] <= $3A)) or
     ((MapTileA^[A0, A1] >= $5F) and (MapTileA^[A0, A1] <= $64)) then
    Proc23_0684 := $18
  else if (MapTileA^[A0, A1] > $3A) and (MapTileA^[A0, A1] <= $5E) then
    Proc23_0684 := $1A
  else if not (MapTileMid^[A0, A1] in Set1358) then
    Proc23_0684 := (Bytes73[G5514^[A0, A1]] - 1) * 2
  else
    Proc23_0684 := MapTileC^[A0, A1] * 2;
end;

function Proc23_0786;
begin
  if (MapTileA^[A0, A1] = 1) or
     ((MapTileA^[A0, A1] >= $19) and (MapTileA^[A0, A1] <= $27)) then
    Proc23_0786 := $32
  else
    Proc23_0786 := $30;
end;

function Proc23_07DF;
begin
  if (MapTileA^[A0, A1] >= $37) and (MapTileA^[A0, A1] <= $5E) then
    Proc23_07DF := $1A
  else if (MapTileA^[A0, A1] = 1) or
          ((MapTileA^[A0, A1] >= $19) and (MapTileA^[A0, A1] <= $27)) then
    Proc23_07DF := Proc6_0F53((Integer(Map0^[A0, A1]) - 3) * 2, $24)
  else
    Proc23_07DF := Map0^[A0, A1] * 2 + $1A;
end;

function Proc23_08A8;
begin
  if (MapTileA^[A0, A1] >= $37) and (MapTileA^[A0, A1] <= $5E) then
    Proc23_08A8 := $30
  else if (MapTileA^[A0, A1] = 1) or
          ((MapTileA^[A0, A1] >= $19) and (MapTileA^[A0, A1] <= $27)) then
    Proc23_08A8 := $36
  else
    Proc23_08A8 := $34;
end;

function Proc23_0934;
begin
  if (MapTileA^[A0, A1] >= $37) and (MapTileA^[A0, A1] <= $5E) then
    Proc23_0934 := $1A
  else
    Proc23_0934 := MapTileC^[A0, A1] * 2;
end;

function Proc23_098C;
begin
  if not (MapTileMid^[A0, A1] in Set1378) then
    Proc23_098C := $38
  else if (MapTileA^[A0, A1] = 1) and (MapTileMid^[A0, A1] in Set1358) then
    Proc23_098C := $32
  else
    Proc23_098C := $30;
end;

function Proc23_0A0A(A0, A1: Word): Word;
begin
  if ((MapTileA^[A0, A1] >= $0A) and (MapTileA^[A0, A1] <= $3A)) or
     ((MapTileA^[A0, A1] >= $5F) and (MapTileA^[A0, A1] <= $64)) then
  begin
    Proc23_0A0A := $18;
    Exit;
  end;
  if (MapTileA^[A0, A1] > $3A) and (MapTileA^[A0, A1] <= $5E) then
  begin
    Proc23_0A0A := $1A;
    Exit;
  end;
  if not (MapTileMid^[A0, A1] in Set1358) then
  Proc23_0A0A := (PArr7372N(G7372)^[MapTileMid^[A0, A1]].W0A shl 1) + 2
  else if MapTileA^[A0, A1] = 1 then
    Proc23_0A0A := Proc6_0F53((Map0^[A0, A1] - 3) * 2, $24)
  else
    Proc23_0A0A := Map0^[A0, A1] * 2 + $1A;
end;

function Proc23_0B57;
begin
  if not (MapTileMid^[A0, A1] in Set1378) then
    Proc23_0B57 := $38
  else if MapTileMid^[A0, A1] in Set1358 then
  begin
    if MapTileA^[A0, A1] = 1 then
      Proc23_0B57 := $36
    else if (MapTileA^[A0, A1] = 0) or (MapTileA^[A0, A1] = 4) then
      Proc23_0B57 := $34
    else
      Proc23_0B57 := $30;
  end
  else
    Proc23_0B57 := $30;
end;

function Proc23_0C10(A0, A1: Word): Word;
begin
  if ((MapTileA^[A0, A1] >= $0A) and (MapTileA^[A0, A1] <= $3A)) or
     ((MapTileA^[A0, A1] >= $5F) and (MapTileA^[A0, A1] <= $64)) then
  begin
    Proc23_0C10 := $18;
    Exit;
  end;
  if (MapTileA^[A0, A1] > $3A) and (MapTileA^[A0, A1] <= $5E) then
  begin
    Proc23_0C10 := $1A;
    Exit;
  end;
  if not (MapTileMid^[A0, A1] in Set1358) then
  Proc23_0C10 := (PArr7372N(G7372)^[MapTileMid^[A0, A1]].W0A shl 1) + 2
  else
    Proc23_0C10 := MapTileC^[A0, A1] * 2;
end;

function Proc23_0D18;
begin
  Proc23_0D18 := $3A;
end;

function Proc23_0D28;
begin
  Proc23_0D28 := $24 - (Integer(GFX.Proc6_180D(Integer(A0), Integer(A1))) * $24) div $FF;
end;

function Proc23_0D53;
begin
  Proc23_0D53 := $3C;
end;

function Proc23_0D63;
begin
  if MapTileMid^[A0, A1] in Set1378 then
    Proc23_0D63 := $24
  else
    Proc23_0D63 := $20 - (Integer(G5518^[A0, A1]) shl 5) div 100;
end;

function Proc23_0DC2;
begin
  Proc23_0DC2 := $38;
end;

function Proc23_0DD2(A0, A1: Word): Word;
begin
  if MapTileMid^[A0, A1] = $0C then
  begin
    Proc23_0DD2 := $1E;
    Exit;
  end;
  if not (MapTileMid^[A0, A1] in Set1378) then
  begin
    if PArr7372N(G7372)^[MapTileMid^[A0, A1]].W0A = 6 then
      Proc23_0DD2 := $20
    else
      Proc23_0DD2 := $22;
  end
  else
  begin
    if ((MapTileA^[A0, A1] >= $0A) and (MapTileA^[A0, A1] <= $3A)) or
       ((MapTileA^[A0, A1] >= $5F) and (MapTileA^[A0, A1] <= $64)) then
    begin
      Proc23_0DD2 := $22;
      Exit;
    end;
    if (MapTileA^[A0, A1] >= $37) and (MapTileA^[A0, A1] <= $5E) then
      Proc23_0DD2 := $20
    else
      Proc23_0DD2 := $24;
  end;
end;

procedure Proc23_0EEB;
var
  Col, Row: Integer;
  Spare: array[0..3] of Integer;
  MapX, MapY, DY, DX: Integer;
  Dest, Src: Word;
begin
  Dest := TImage(Obj.F18C).Canvas.Handle;
  Src := TBitmap(Obj.F1D2).Canvas.Handle;
  for Row := 0 to (Integer(A3) - Integer(A1)) div $26 - 1 do
    for Col := 0 to (Integer(A2) - Integer(A0)) div $30 - 1 do
      WinProcs.BitBlt(Dest, Col * $30 + Integer(A0), Row * $26 + Integer(A1),
        $30, $26, Src, 0, 0, $00CC0020);
  for Row := 0 to (Integer(A3) - Integer(A1)) div $26 - 1 do
    WinProcs.BitBlt(Dest,
      ((Integer(A2) - Integer(A0)) div $30) * $30 + Integer(A0),
      Row * $26 + Integer(A1),
      Integer(A2) - (((Integer(A2) - Integer(A0)) div $30) * $30 + Integer(A0)),
      $26, Src, 0, 0, $00CC0020);
  for Col := 0 to (Integer(A2) - Integer(A0)) div $30 - 1 do
    WinProcs.BitBlt(Dest, Col * $30 + Integer(A0),
      ((Integer(A3) - Integer(A1)) div $26) * $26 + Integer(A1),
      $30, Integer(A3) - (((Integer(A3) - Integer(A1)) div $26) * $26 + Integer(A1)),
      Src, 0, 0, $00CC0020);
  WinProcs.BitBlt(Dest,
    ((Integer(A2) - Integer(A0)) div $30) * $30 + Integer(A0),
    ((Integer(A3) - Integer(A1)) div $26) * $26 + Integer(A1),
    Integer(A2) - (((Integer(A2) - Integer(A0)) div $30) * $30 + Integer(A0)),
    Integer(A3) - (((Integer(A3) - Integer(A1)) div $26) * $26 + Integer(A1)),
    Src, 0, 0, $00CC0020);
  Row := Integer(A1) - 2;
  while Row <= Integer(A3) + 2 do
  begin
    Col := Integer(A0) - 1;
    while Col <= Integer(A2) + 1 do
    begin
      Proc23_038D(Col, Row, MapY, MapX, DX, DY, Obj);
      if GFX.Proc6_1FC2(MapX, MapY) then
        if MAP.MapTileA^[MapY, MapX] <> 2 then
          WinProcs.BitBlt(Dest, Col - DX, Row - DY - 2,
            2, 2, Src, C0(MapY, MapX), C1(MapY, MapX), $00CC0020);
      Col := Col + 2;
    end;
    Row := Row + 2;
  end;
end;

procedure Proc23_11B4;
begin
  Proc23_0EEB(A0, A1, A2, A3, Proc23_045F, Proc23_04B1, POver23(A4)^);
end;

procedure Proc23_11E1;
begin
  Proc23_0EEB(A0, A1, A2, A3, Proc23_098C, Proc23_0A0A, POver23(A4)^);
end;

procedure Proc23_120E;
begin
  Proc23_0EEB(A0, A1, A2, A3, Proc23_0D18, Proc23_0D28, POver23(A4)^);
end;

procedure Proc23_123B;
begin
  Proc23_0EEB(A0, A1, A2, A3, Proc23_0DC2, Proc23_0DD2, POver23(A4)^);
end;

procedure Proc23_1268;
begin
  Proc23_0EEB(A0, A1, A2, A3, Proc23_0D53, Proc23_0D63, POver23(A4)^);
end;

procedure Proc23_1295;
begin
  Proc23_0EEB(A0, A1, A2, A3, Proc23_0786, Proc23_07DF, POver23(A4)^);
end;

procedure Proc23_12C2;
begin
  Proc23_0EEB(A0, A1, A2, A3, Proc23_0B57, Proc23_0C10, POver23(A4)^);
end;

procedure Proc23_12EF;
begin
  Proc23_0EEB(A0, A1, A2, A3, Proc23_05F8, Proc23_0684, POver23(A4)^);
end;

procedure Proc23_131C;
begin
  Proc23_0EEB(A0, A1, A2, A3, Proc23_08A8, Proc23_0934, POver23(A4)^);
end;

procedure Proc23_1349;
type TModeWords23 = array[0..0, 0..9] of Integer;
var
  Src, Dest: Word;
  View: TModeWords23 absolute W3D80;
begin
  Dest := TImage(Obj.F18C).Canvas.Handle;
  Src := TBitmap(Obj.F1D6).Canvas.Handle;
  WinProcs.BitBlt(Dest,
    (PRec6532(P6532)^.W408 * 2 - 1) - Integer(Obj.F1B0) - View[ShortInt(Pred7c), 6],
    PRec6532(P6532)^.W40A - Integer(Obj.F1B2) - View[ShortInt(Pred7c), 7],
    View[ShortInt(Pred7c), 0], View[ShortInt(Pred7c), 1], Src,
    View[ShortInt(Pred7c), 2], View[ShortInt(Pred7c), 3], $008800C6);
  WinProcs.BitBlt(Dest,
    (PRec6532(P6532)^.W408 * 2 - 1) - Integer(Obj.F1B0) - View[ShortInt(Pred7c), 6],
    PRec6532(P6532)^.W40A - Integer(Obj.F1B2) - View[ShortInt(Pred7c), 7],
    View[ShortInt(Pred7c), 0], View[ShortInt(Pred7c), 1], Src,
    View[ShortInt(Pred7c), 4], View[ShortInt(Pred7c), 5], $00660046);
end;

procedure Proc23_1485;
type TModeWords23 = array[0..0, 0..9] of Integer;
var
  X, Y: Integer;
  View: TModeWords23 absolute W3D80;
begin
  X := (PRec6532(P6532)^.W408 * 2 - 1) - Integer(Obj.F1B0) - View[ShortInt(Pred7c), 6];
  Y := PRec6532(P6532)^.W40A - Integer(Obj.F1B2) - View[ShortInt(Pred7c), 7];
  Proc23_16FA(X - 1, Y - 1,
    View[ShortInt(Pred7c), 0] + X, View[ShortInt(Pred7c), 1] + Y, Obj);
end;

procedure Proc23_1504(A0, A1, A2, A3: Word; A4: Pointer);
begin
  Proc23_1684($3F, A0, A1, A2, A3, 0, A4);
  Far22C6(POver23(A4)^.F18C^);
end;

procedure Proc23_1534(A0, A1, A2, A3: Word; A4: Pointer);
begin
  Proc23_1684($10, A0, A1, A2, A3, 0, A4);
  Far22C6(POver23(A4)^.F18C^);
end;

procedure Proc23_1564(A0, A1, A2, A3: Word; A4: Pointer);
begin
  Proc23_1684($1F, A0, A1, A2, A3, 1, A4);
  Far22C6(POver23(A4)^.F18C^);
end;

procedure Proc23_1594(A0, A1, A2, A3: Word; A4: Pointer);
begin
  Proc23_1684($1F, A0, A1, A2, A3, 1, A4);
  Far22C6(POver23(A4)^.F18C^);
end;

procedure Proc23_15C4(A0, A1, A2, A3: Word; A4: Pointer);
begin
  Proc23_1684(4, A0, A1, A2, A3, 1, A4);
  Far22C6(POver23(A4)^.F18C^);
end;

procedure Proc23_15F4(A0, A1, A2, A3: Word; A4: Pointer);
begin
  Proc23_1684($1F, A0, A1, A2, A3, 1, A4);
  Far22C6(POver23(A4)^.F18C^);
end;

procedure Proc23_1624(A0, A1, A2, A3: Word; A4: Pointer);
begin
  Proc23_1684($1F, A0, A1, A2, A3, 1, A4);
  Far22C6(POver23(A4)^.F18C^);
end;

procedure Proc23_1654(A0, A1, A2, A3: Word; A4: Pointer);
begin
  Proc23_1684($1E, A0, A1, A2, A3, 1, A4);
  Far22C6(POver23(A4)^.F18C^);
end;

procedure Proc23_1684(A0: Byte; A1, A2, A3, A4: Word; A5: Byte; A6: Pointer);
begin
  Proc23_173E(A0,
    Proc23_0422(A1, A2, @POver23(A6)^) - (A4 - A2) * 2,
    Proc23_0443(A1, A2, @POver23(A6)^),
    (A4 - A2) * 2 + Proc23_0422(A3, A4, @POver23(A6)^),
    Proc23_0443(A3, A4, @POver23(A6)^) + 1,
    A5, POver23(A6)^);
end;

procedure Proc23_16FA;
begin
  Proc23_17CF([0..5], A0, A1, A2, A3, 0, Obj);
end;

procedure Proc23_171B;
begin
  Proc23_1765([0..5], A0, A1, A2, A3, 0, 0, Obj);
end;

procedure Proc23_173E(A0: Byte; A1, A2, A3, A4: Word; A5: Byte; var A6: TOver23);
begin
  Proc23_1765(TSet7(A0), A1, A2, A3, A4, A5, 1, A6);
end;

procedure Proc23_1765;
begin
  if A7.F199 in A0 then
  begin
    if A6 <> 0 then
      Proc23_1485(A7);
    Proc23_17CF(A0, A1, A2, A3, A4, A5, A7);
    Proc23_1349(A7);
  end;
end;

procedure Proc23_17CF(A0: TSet7; A1, A2, A3, A4: Word; A5: Byte; var A6: TOver23);
begin
  if A6.F199 in A0 then
    if A6.F19F = 1 then
    begin
      case A6.F199 of
        0: Proc23_11B4(A1, A2, A3, A4, @A6);
        1: Proc23_11E1(A1, A2, A3, A4, @A6);
        2: if A5 <> 0 then Proc23_120E(A1 - G64BF, A2 - G64BF, G64BF + A3, G64BF + A4, @A6)
           else Proc23_120E(A1, A2, A3, A4, @A6);
        3: if A5 <> 0 then Proc23_123B(A1 - Byte(G64C0), A2 - Byte(G64C0), Byte(G64C0) + A3, Byte(G64C0) + A4, @A6)
           else Proc23_123B(A1, A2, A3, A4, @A6);
        4: Proc23_1268(A1, A2, A3, A4, @A6);
        5: Proc23_1295(A1, A2, A3, A4, @A6);
      end;
    end
    else
    begin
      case A6.F199 of
        0: Proc23_12EF(A1, A2, A3, A4, @A6);
        1: Proc23_12C2(A1, A2, A3, A4, @A6);
        2: if A5 <> 0 then Proc23_120E(A1 - G64BF, A2 - G64BF, G64BF + A3, G64BF + A4, @A6)
           else Proc23_120E(A1, A2, A3, A4, @A6);
        3: if A5 <> 0 then Proc23_123B(A1 - Byte(G64C0), A2 - Byte(G64C0), Byte(G64C0) + A3, Byte(G64C0) + A4, @A6)
           else Proc23_123B(A1, A2, A3, A4, @A6);
        4: Proc23_1268(A1, A2, A3, A4, @A6);
        5: Proc23_131C(A1, A2, A3, A4, @A6);
      end;
    end;
end;

procedure Proc23_1A49(A0: Pointer);
begin
end;

procedure Proc23_1A6E;
var Dest: Word;
begin
  Dest := TImage(Obj.F18C).Canvas.Handle;
  if Integer(Obj.F1B0) + DX > Obj.F1C6 then
    DX := Obj.F1C6 - Integer(Obj.F1B0)
  else if Integer(Obj.F1B0) + DX < Obj.F1C8 then
    DX := Obj.F1C8 - Integer(Obj.F1B0);
  if Integer(Obj.F1B2) + DY > Obj.F1C0 then
    DY := Obj.F1C0 - Integer(Obj.F1B2)
  else if Integer(Obj.F1B2) + DY < Obj.F1C2 then
    DY := Obj.F1C2 - Integer(Obj.F1B2);
  WinProcs.BitBlt(Dest, Word(Proc6_0EE7(-DX)), Word(Proc6_0EE7(-DY)),
    Obj.F19B - Abs(DX), Obj.F19D - Abs(DY), Dest,
    Word(Proc6_0EE7(DX)), Word(Proc6_0EE7(DY)), $00CC0020);
  Obj.F1B0 := Integer(Obj.F1B0) + DX;
  Obj.F1B2 := Integer(Obj.F1B2) + DY;
  if DX > 0 then
    Proc23_171B(Obj.F19B - DX, 0, Obj.F19B, Obj.F19D, Obj);
  if DX < 0 then
    Proc23_171B(0, 0, -DX, Obj.F19D, Obj);
  if DY > 0 then
    Proc23_171B(Word(Proc6_0EE7(-DX)), Obj.F19D - DY,
      Word(LongInt(Obj.F19B) - Proc6_0EE7(DX)), Obj.F19D, Obj);
  if DY < 0 then
    Proc23_171B(Word(Proc6_0EE7(-DX)), 0,
      Word(LongInt(Obj.F19B) - Proc6_0EE7(DX)), -DY, Obj);
  TImage(Obj.F18C).Refresh;
end;

procedure Proc23_1C74;
begin
end;

procedure Proc23_1D21(A0, A1, A2, A3, A4, A5: Word; A6: POver23);
var
  T1, T2: Word;
begin
  if A2 = 0 then
  begin
    if A6^.F19A = 4 then
      if Far1517(A4, A5, 0, 0, $10, $10) <> 0 then
      begin
        if A6^.F19F = 1 then A6^.F19F := 0 else A6^.F19F := 1;
        Proc23_1A49(A6);
        Far22C6(A6^.F18C^);
      end;
    if A6^.F19F = 1 then
      T1 := Far1F2E(Far56AC(A6^.F1EE))
    else
      T1 := Far1F2E(Far56AC(A6^.F1EA));
    T2 := Far1F2E(FarE60(A6^.F180));
    Far206A(T2, 0, 0, $10, $10, T1, 0, 0, $CC, $20);
    Far22C6(A6^.F180^);
    Proc20_30B6($A);
    A6^.F19A := 0;
  end;
end;

procedure Proc23_1E25;
begin
end;

procedure Proc23_1E4A;
begin
end;

procedure Proc23_1E73;
begin
end;

procedure Proc23_1E96;
begin
end;

procedure Proc23_1F52;
begin
end;

procedure Proc23_200E;
begin
end;

procedure Proc23_20A5;
begin
  if Obj.F213 = 0 then
    Proc23_31F8(Obj.F184, 7, Obj.F206, Obj)
  else
    Proc23_31F8(Obj.F184, 7, Obj.F20A, Obj);
end;

procedure Proc23_20F2;
begin
end;

procedure Proc23_216E(A, B: Word; R: POuter);
begin
  case R^.Inner^.Sel of
    0: ;
    1: Arm216E(-5, R^);
    2: Arm216E(-30, R^);
    3: Arm216E(30, R^);
    4: Arm216E(5, R^);
  end;
end;

procedure Proc23_21C7;
begin
end;

procedure Proc23_21FA;
begin
end;

procedure Proc23_222B;
begin
end;

procedure Proc23_2421;
begin
end;

procedure Proc23_24A1(A0, A1, A2, A3, A4, A5: Word; A6: POver23);
var
  Pad4: LongInt;
begin
  if A6^.F1A7 <> 0 then
  begin
    if A6^.F213 = 0 then
      Proc23_31F8(A6^.F184, 8, A6^.F206, A6^)
    else
      Proc23_31F8(A6^.F184, 8, A6^.F20A, A6^);
    A6^.F1A7 := 0;
    Far22C6(A6^.F184^);
  end;
  if A6^.F1A6 <> 0 then
  begin
    if A6^.F213 = 0 then
      Proc23_31F8(A6^.F184, 6, A6^.F206, A6^)
    else
      Proc23_31F8(A6^.F184, 6, A6^.F20A, A6^);
    A6^.F1A6 := 0;
    Far22C6(A6^.F184^);
  end;
  A6^.F1A5 := 0;
  Proc23_21FA(A6);
end;

procedure Proc23_257F;
begin
end;

procedure Proc23_25A8;
begin
end;

function Proc23_25CB(A0: POver23): LongInt;
var
  L1, L2, L3, L4, L5, Q: LongInt;
begin
  L1 := A0^.F1C8;
  L2 := A0^.F1C6;
  L3 := A0^.F1CA;
  L4 := 16;
  L5 := PArr176(A0^.F20E)^[A0^.F213].W6C - PArr176(A0^.F20E)^[A0^.F213].W68 + 1;
  Q := ((L3 - L1) * (L5 - L4) + (L2 - L1) * L4) div (L2 - L1);
  Proc23_25CB := Q;
end;

function Proc23_26A8(A0: POver23; A1: LongInt): LongInt;
var
  L1, L2, L3, L4, L5, P: LongInt;
begin
  L1 := A0^.F1C8;
  L2 := A0^.F1C6;
  P := A1;
  L4 := 16;
  L5 := PArr176(A0^.F20E)^[A0^.F213].W6C - PArr176(A0^.F20E)^[A0^.F213].W68 + 1;
  L3 := ((P - L4) * (L2 - L1) + (L5 - L4) * L1) div (L5 - L4);
  Proc23_26A8 := L3;
end;

procedure Proc23_2785;
var Src, Dest: Word;
begin
  Src := TBitmap(PPtr23(@MAP.Pad5FE4[$32])^).Canvas.Handle;
  Dest := TImage(Obj.F188).Canvas.Handle;
  WinProcs.BitBlt(Dest, Word(Proc23_25CB(@Obj)), 0, $14, $10, Src, 0, 0, $008800C6);
  WinProcs.BitBlt(Dest, Word(Proc23_25CB(@Obj)), 0, $14, $10, Src, $14, 0, $00660046);
  TImage(Obj.F188).Refresh;
end;

procedure Proc23_281C;
begin
  if Obj.F213 = 0 then
    Proc23_31F8(Obj.F188, $0D, Obj.F1FA, Obj)
  else
    Proc23_31F8(Obj.F188, $0D, Obj.F1FE, Obj);
end;

procedure Proc23_2869;
var T: Integer;
begin
  T := Obj.F1CA + A0;
  if T < Obj.F1C8 then
    T := Obj.F1C8
  else if T > Obj.F1C6 then
    T := Obj.F1C6;
  Proc23_281C(Obj);
  Obj.F1CA := T;
  Proc23_2785(Obj);
  Proc23_1A6E(Obj.F1CA - Integer(Obj.F1B0), 0, Obj);
end;

procedure Proc23_28E5(A, B: Word; R: POuter2);
begin
  case R^.Inner^.Sel of
    0: ;
    1: Arm28E5(-5, R^);
    2: Arm28E5(-30, R^);
    3: Arm28E5(30, R^);
    4: Arm28E5(5, R^);
  end;
end;

procedure Proc23_293E;
begin
end;

procedure Proc23_2971(A0: Pointer);
begin
end;

procedure Proc23_29A2;
begin
end;

procedure Proc23_2DD3;
begin
end;

procedure Proc23_2E01;
begin
end;

procedure Proc23_2E99(A0, A1, A2, A3, A4, A5: Word; A6: POver23);
var
  Pad4: LongInt;
begin
  if A6^.F19A = $C then
  begin
    if A6^.F213 = 0 then
      Proc23_31F8(A6^.F188, $C, A6^.F1FA, A6^)
    else
      Proc23_31F8(A6^.F188, $C, A6^.F1FE, A6^);
    Far22C6(A6^.F188^);
  end
  else if A6^.F19A = $E then
  begin
    if A6^.F213 = 0 then
      Proc23_31F8(A6^.F188, $E, A6^.F1FA, A6^)
    else
      Proc23_31F8(A6^.F188, $E, A6^.F1FE, A6^);
    Far22C6(A6^.F188^);
  end
  else if (A6^.F19A >= $10) and (A6^.F19A <= $14) then
  begin
    if Proc23_02E9(A4, A5, A6^.F19A, A6) <> 0 then
      Proc23_303E(A6^.F19A, A6);
  end
  else if A6^.F19A = $15 then
  begin
    if A6^.F213 = 0 then
      Proc23_31F8(A6^.F188, $15, A6^.F1FA, A6^)
    else
      Proc23_31F8(A6^.F188, $15, A6^.F1FE, A6^);
    Proc23_3EEE(A6);
    Far22C6(A6^.F188^);
    Proc20_30B6($A);
    if Proc23_02E9(A4, A5, A6^.F19A, A6) <> 0 then
      Proc23_3F7F(A6^);
  end;
  A6^.F19A := 0;
  Proc23_2971(A6);
end;

procedure Proc23_303E(A0: ShortInt; A1: POver23);
var
  TB, TA: Word;
begin
  if A0 <> $A then
  begin
    if A1^.F198 = A0 then
    begin
      A1^.F198 := $A;
      A1^.F199 := 5;
    end
    else
    begin
      A1^.F198 := A0;
      case A0 of
        $10: A1^.F199 := 0;
        $11: A1^.F199 := 1;
        $12: A1^.F199 := 2;
        $13: A1^.F199 := 3;
        $14: A1^.F199 := 4;
      end;
    end;
  end;
  if A1^.F213 = 0 then
    Proc23_31F8(A1^.F188, $F, A1^.F1FA, A1^)
  else
    Proc23_31F8(A1^.F188, $F, A1^.F1FE, A1^);
  if A1^.F198 <> $A then
  begin
    TA := Far1F2E(Far56AC(A1^.F202));
    TB := Far1F2E(FarE60(A1^.F188));
    Far335B(TB,
      A1^.F20E^[A1^.F213, A1^.F198].W0,
      A1^.F20E^[A1^.F213, A1^.F198].W1,
      $20, $20, TA,
      A1^.F1A8^[A1^.F198].W0,
      A1^.F1A8^[A1^.F198].W1,
      $CC, $20);
  end;
  Far22C6(A1^.F188^);
  Proc23_1A49(A1);
  Far22C6(A1^.F18C^);
end;

procedure Proc23_31F8;
var Dest, Src: Word;
begin
  Dest := TImage(PPtr23(@A0)^).Canvas.Handle;
  Src := TBitmap(PPtr23(@A2)^).Canvas.Handle;
  WinProcs.BitBlt(Dest,
    A3.F20E^[A3.F213, A1].W0,
    A3.F20E^[A3.F213, A1].W1,
    Integer(A3.F20E^[A3.F213, A1].W2) - Integer(A3.F20E^[A3.F213, A1].W0) + 1,
    Integer(A3.F20E^[A3.F213, A1].W3) - Integer(A3.F20E^[A3.F213, A1].W1) + 1,
    Src,
    A3.F20E^[A3.F213, A1].W0,
    A3.F20E^[A3.F213, A1].W1, $00CC0020);
end;

procedure Proc23_3363;
begin
end;

procedure Proc23_346A(A0: PPtr23; A1: ShortInt; A2: PPtr23; A3: POver23);
var
  T1, T2: Word;
begin
  T1 := Far1F2E(FarE60(A0^));
  T2 := Far1F2E(Far56AC(A2^));
  Far3B41(T1, 0, 0,
          A3^.F20E^[A3^.F213, A1].W2 - A3^.F20E^[A3^.F213, A1].W0 + 1,
          A3^.F20E^[A3^.F213, A1].W3 - A3^.F20E^[A3^.F213, A1].W1 + 1,
          T2, 0, 0, $CC, $20);
end;

procedure Proc23_3553;
begin
end;

procedure Proc23_37F5;
begin
end;

procedure Proc23_39B1(Sender: TObject; A1: Byte; A2, A3: Integer; A4: POver23);
var
  T20View: TArr20N absolute W3D90;
  FramePadA, FramePadB: LongInt;
begin
  if A2 < 0 then Exit;
  if A2 > A4^.F18C^.W22 then Exit;
  if A3 < 0 then Exit;
  if A3 > A4^.F18C^.W24 then Exit;
  if A1 <> 8 then Exit;
  Proc23_1485(A4^);
  A2 := A2 - T20View[Pred7c].W0;
  A3 := A3 - T20View[Pred7c].W2;
  PRec6532(P6532)^.W408 := (A2 + Integer(A4^.F1B0)) div 2;
  PRec6532(P6532)^.W40A := A3 + Integer(A4^.F1B2);
  A2 := T20View[Pred7c].W0 + A2;
  A3 := T20View[Pred7c].W2 + A3;
  Proc23_1349(A4^);
  Far22C6(A4^.F18C^);
  Proc4_05A7(@P6532^);
  Proc4_04B0(@P6532^);
end;

procedure Proc23_3AAB;
begin
end;

procedure Proc23_3AC3;
begin
end;

procedure Proc23_3C9B;
begin
end;

procedure Proc23_3D2B;
begin
end;

procedure Proc23_3E73;
begin
  TUebersichtsmap2(@Obj).Height := 0;
  TUebersichtsmap2(@Obj).Width := Integer(Obj.F20E^[Obj.F213, 0].W2) + 1;
  Proc23_3553(@Obj);
  Proc23_303E($A, @Obj);
  Proc23_1E25(@Obj);
  TUebersichtsmap2(@Obj).Height := Integer(Obj.F20E^[Obj.F213, 0].W3) + 1;
end;

procedure Proc23_3EEE(A0: Pointer);
begin
end;

procedure Proc23_3F7F;
begin
  Proc20_30B6($E);
  TUebersichtsmap2(@Obj).Height := 0;
  DATEN.Proc2_2ADE(5);
  TControl(@MAP.P6532^).BringToFront;
end;

procedure Proc23_3FAB;
begin
  Obj.F213 := 0;
  if Obj.F24 > 0 then
  begin
    TUebersichtsmap2(@Obj).Height := 0;
    TUebersichtsmap2(@Obj).Width := Integer(Obj.F20E^[Obj.F213, 0].W2) + 1;
    Proc23_3553(@Obj);
    Proc23_303E($A, @Obj);
    Proc23_1E25(@Obj);
    TUebersichtsmap2(@Obj).Height := Integer(Obj.F20E^[Obj.F213, 0].W3) + 1;
  end
  else
  begin
    TUebersichtsmap2(@Obj).Width := Integer(Obj.F20E^[Obj.F213, 0].W2) + 1;
    Proc23_3553(@Obj);
    Proc23_303E($A, @Obj);
    Proc23_1E25(@Obj);
  end;
end;

procedure Proc23_4079(A0: POver23);
begin
  A0^.F1B0 := Proc6_0F19(Proc6_0F53((PRec6532(P6532)^.W408 + 10) * 2 - A0^.F19B div 2, $3EA - A0^.F19B), 0);
  A0^.F1B2 := Proc6_0F19(Proc6_0F53(PRec6532(P6532)^.W40A + $D - A0^.F19D div 2, $1F6 - A0^.F19D), 0);
  Proc23_1E4A(0, $1F6 - A0^.F19D, A0^.F1B2, A0);
  Proc23_257F(0, $3EA - A0^.F19B, A0^.F1B0, A0);
  Proc23_303E($A, A0);
  Far201C(A0);
  Proc23_1E25(A0);
  Proc23_3EEE(A0);
  Far17E1(A0^.F20E^[A0^.F213, 0].W3 + 1, A0);
  Proc20_30B6($D);
end;

procedure Proc23_41AD;
begin
end;

procedure Proc23_4538(A0: POver23);
var
  Buf: string;
begin
  A0^.F1D2 := Far535A(1, Ptr($454A, $083F));
  A0^.F1D6 := Far535A(1, Ptr($4567, $083F));
  A0^.F1DA := Far535A(1, Ptr($4584, $083F));
  A0^.F1DE := Far535A(1, Ptr($45A1, $083F));
  A0^.F1E2 := Far535A(1, Ptr($45BE, $083F));
  A0^.F1E6 := Far535A(1, Ptr($45DB, $083F));
  A0^.F1EA := Far535A(1, Ptr($45F8, $083F));
  A0^.F1EE := Far535A(1, Ptr($4615, $083F));
  A0^.F1F2 := Far535A(1, Ptr($4632, $083F));
  A0^.F1F6 := Far535A(1, Ptr($464F, $083F));
  A0^.F1FA := Far535A(1, Ptr($466C, $083F));
  A0^.F1FE := Far535A(1, Ptr($4689, $083F));
  A0^.F202 := Far535A(1, Ptr($46A6, $083F));
  A0^.F206 := Far535A(1, Ptr($46C3, $083F));
  A0^.F20A := Far535A(1, Ptr($46E0, $083F));
  Far15CD(@Buf, @G4F98);
  Far164C('Ueberma2.BMP');
  A0^.F1D2.Slot12;
  Far15CD(@Buf, @G4F98);
  Far164C('UeRecht.BMP');
  A0^.F1D6.Slot12;
  Far15CD(@Buf, @G4F98);
  Far164C('uebigueb.BMP');
  A0^.F1DA.Slot12;
  Far15CD(@Buf, @G4F98);
  Far164C('uesmaueb.BMP');
  A0^.F1DE.Slot12;
  Far15CD(@Buf, @G4F98);
  Far164C('uebigpre.BMP');
  A0^.F1E2.Slot12;
  Far15CD(@Buf, @G4F98);
  Far164C('uesmapre.BMP');
  A0^.F1E6.Slot12;
  Far15CD(@Buf, @G4F98);
  Far164C('uehoebut.BMP');
  A0^.F1EA.Slot12;
  Far15CD(@Buf, @G4F98);
  Far164C('ueschbut.BMP');
  A0^.F1EE.Slot12;
  Far15CD(@Buf, @G4F98);
  Far164C('uehoepre.BMP');
  A0^.F1F2.Slot12;
  Far15CD(@Buf, @G4F98);
  Far164C('ueschpre.BMP');
  A0^.F1F6.Slot12;
  Far15CD(@Buf, @G4F98);
  Far164C('uebigmen.BMP');
  A0^.F1FA.Slot12;
  Far15CD(@Buf, @G4F98);
  Far164C('uesmamen.BMP');
  A0^.F1FE.Slot12;
  Far15CD(@Buf, @G4F98);
  Far164C('uemenpre.BMP');
  A0^.F202.Slot12;
  Far15CD(@Buf, @G4F98);
  Far164C('uebigns.BMP');
  A0^.F206.Slot12;
  Far15CD(@Buf, @G4F98);
  Far164C('uesmans.BMP');
  A0^.F20A.Slot12;
  A0^.F1A8 := Far182($30);
  A0^.F20E := Far182($160);
  A0^.F1AC := Far182($100);
  Proc23_41AD(A0);
  A0^.F19B := 0;
  A0^.F19D := 0;
  A0^.F1A0 := 0;
  A0^.F1A2 := 0;
  A0^.F213 := 0;
  A0^.F1A4 := 0;
  A0^.F1A5 := 0;
  A0^.F1A6 := 0;
  A0^.F1A7 := 0;
  A0^.F19F := 1;
  A0^.F198 := $0A;
  A0^.F19A := 0;
  A0^.F199 := 5;
  Proc23_3553(A0);
  Far17E1(0, A0);
  Far17BF(A0^.F20E^[A0^.F213, 0].W2 + 1, A0);
  Far179D(0, A0);
  Far177B(0, A0);
  A0^.F1B0 := Proc6_0F19(Proc6_0F53((PRec6532(P6532)^.W408 + 10) * 2 - A0^.F19B div 2, $3EA - A0^.F19B), 0);
  A0^.F1B2 := Proc6_0F19(Proc6_0F53(PRec6532(P6532)^.W40A + $D - A0^.F19D div 2, $1F6 - A0^.F19D), 0);
  Proc23_1E4A(0, $1F6 - A0^.F19D, A0^.F1B2, A0);
  Proc23_257F(0, $3EA - A0^.F19B, A0^.F1B0, A0);
  Far56E1(A0);
end;

function Far535A(A0: Byte; A1: Pointer): TThing23;
begin
end;

procedure Far15CD(A0, A1: Pointer);
begin
end;

procedure Far164C(A0: string);
begin
end;

function Far182(A0: Word): Pointer;
begin
end;

procedure Far179D(A0: Word; A1: Pointer);
begin
end;

procedure Far177B(A0: Word; A1: Pointer);
begin
end;

procedure Far56E1(A0: Pointer);
begin
end;

procedure TThing23.Slot0;
begin
end;

procedure TThing23.Slot1;
begin
end;

procedure TThing23.Slot2;
begin
end;

procedure TThing23.Slot3;
begin
end;

procedure TThing23.Slot4;
begin
end;

procedure TThing23.Slot5;
begin
end;

procedure TThing23.Slot6;
begin
end;

procedure TThing23.Slot7;
begin
end;

procedure TThing23.Slot8;
begin
end;

procedure TThing23.Slot9;
begin
end;

procedure TThing23.Slot10;
begin
end;

procedure TThing23.Slot11;
begin
end;

procedure TThing23.Slot12;
begin
end;

procedure Proc23_4B29;
begin
end;

{$F-}
procedure Proc23_4C59;
begin
end;
{$F+}

procedure Proc23_4C95;
begin
end;

procedure Proc23_4E34(var A0: file; var A1: TOver23);
begin
  BlockWrite(A0, A1.F198, 1);
  BlockWrite(A0, A1.F199, 1);
  BlockWrite(A0, A1.F19A, 1);
  BlockWrite(A0, A1.F19B, 2);
  BlockWrite(A0, A1.F19D, 2);
  BlockWrite(A0, A1.F19F, 1);
  BlockWrite(A0, A1.F1A0, 2);
  BlockWrite(A0, A1.F1A2, 2);
  BlockWrite(A0, A1.F213, 1);
  BlockWrite(A0, A1.F1A4, 1);
  BlockWrite(A0, A1.F1A5, 1);
  BlockWrite(A0, A1.F1A6, 1);
  BlockWrite(A0, A1.F1A7, 1);
  BlockWrite(A0, A1.F1B0, 4);
  BlockWrite(A0, A1.Pad1B4[0], 4);
  BlockWrite(A0, A1.Pad1B4[4], 4);
  BlockWrite(A0, A1.F1BC, 2);
  BlockWrite(A0, A1.F1BE, 2);
  BlockWrite(A0, A1.F1C0, 2);
  BlockWrite(A0, A1.F1C2, 2);
  BlockWrite(A0, A1.F1C4, 2);
  BlockWrite(A0, A1.F1C6, 2);
  BlockWrite(A0, A1.F1C8, 2);
  BlockWrite(A0, A1.F1CA, 2);
  BlockWrite(A0, A1.Pad1CC[0], 4);
  BlockWrite(A0, A1.Pad1CC[4], 2);
  BlockWrite(A0, A1.Pad212, 1);
end;

procedure Proc23_50DE;
begin
end;

procedure Far22C6(var A0);
begin
end;

function FarE60(A0: Pointer): Pointer;
begin
  FarE60 := NIL;
end;

function Far1F2E(A0: Pointer): Word;
begin
  Far1F2E := 0;
end;

function Far56AC(A0: Pointer): Pointer;
begin
  Far56AC := NIL;
end;

procedure Far335B(A0, A1, A2, A3, A4, A5, A6, A7, A8, A9: Word);
begin
end;

procedure Far354B(A0, A1, A2, A3, A4, A5, A6, A7, A8: Word);
begin
end;

function Far1517(A0, A1, A2, A3, A4, A5: Word): Byte;
begin
  Far1517 := 0;
end;

procedure Far206A(A0, A1, A2, A3, A4, A5, A6, A7, A8, A9: Word);
begin
end;

procedure Far17E1(A0: Word; A1: Pointer);
begin
end;

procedure Far17BF(A0: Word; A1: Pointer);
begin
end;

procedure Far2ACE(A0, A1, A2, A3, A4, A5, A6, A7, A8, A9: Word);
begin
end;

procedure Far2DD3(A0, A1, A2, A3, A4, A5, A6, A7, A8, A9: Word);
begin
end;

procedure Far31C8(A0, A1, A2, A3, A4, A5, A6, A7, A8, A9: Word);
begin
end;

procedure Far3B41(A0, A1, A2, A3, A4, A5, A6, A7, A8, A9: Word);
begin
end;

procedure Far201C(A0: Pointer);
begin
end;

procedure TUebersichtsmap2.MapBildMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
end;

procedure TUebersichtsmap2.MapBildMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
end;

procedure TUebersichtsmap2.MapBildMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then Proc4_04B0(@MAP.P6532^);
end;

procedure TUebersichtsmap2.NSScrollBildMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
end;

procedure TUebersichtsmap2.NSScrollbildMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
end;

procedure TUebersichtsmap2.NSScrollBildMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
end;

procedure TUebersichtsmap2.NSScrolltimerTimer(Sender: TObject);
begin
end;

procedure TUebersichtsmap2.WOScrolltimerTimer(Sender: TObject);
begin
end;

procedure TUebersichtsmap2.UmschaltbildMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
end;

procedure TUebersichtsmap2.UmschaltbildMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
end;

procedure TUebersichtsmap2.MenubildMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var T1, T2: Word;
begin
  if Button <> mbLeft then Exit;
  if Proc23_02E9(X, Y, $0C, Self) <> 0 then
  begin
    T1 := Far1F2E(Far56AC(G602A));
    T2 := Far1F2E(FarE60(POver23(Self)^.F188));
    Far2ACE(T2, 0, 0, $10, $10, T1, 0, 0, $CC, $20);
    POver23(Self)^.F19A := $0C;
    Far22C6(POver23(Self)^.F188);
    Proc20_30B6(9);
    Proc23_2869(-5, POver23(Self)^);
    Proc23_293E(1, Self);
  end
  else if Proc23_02E9(X, Y, $0E, Self) <> 0 then
  begin
    T1 := Far1F2E(Far56AC(G602E));
    T2 := Far1F2E(FarE60(POver23(Self)^.F188));
    Far2DD3(T2, POver23(Self)^.F20E^[POver23(Self)^.F213, 14].W0, 0, $10, $10, T1, 0, 0, $CC, $20);
    POver23(Self)^.F19A := $0E;
    Far22C6(POver23(Self)^.F188);
    Proc20_30B6(9);
    Proc23_2869(5, POver23(Self)^);
    Proc23_293E(4, Self);
  end
  else if Proc23_02E9(X, Y, $0D, Self) <> 0 then
  begin
    if X < Proc23_25CB(POver23(Self)) then
    begin
      Proc23_2869(-$1E, POver23(Self)^);
      Proc20_30B6(9);
      Proc23_293E(2, Self);
    end
    else if X > Proc23_25CB(POver23(Self)) + 15 then
    begin
      Proc23_2869($1E, POver23(Self)^);
      Proc20_30B6(9);
      Proc23_293E(3, Self);
    end
    else
    begin
      POver23(Self)^.F1BC := X - Proc23_25CB(POver23(Self));
      Proc20_30B6(9);
      POver23(Self)^.F19A := $0D;
    end;
  end
  else if Proc23_02E9(X, Y, $10, Self) <> 0 then
  begin
    POver23(Self)^.F19A := $10;
    Proc20_30B6(9);
  end
  else if Proc23_02E9(X, Y, $11, Self) <> 0 then
  begin
    POver23(Self)^.F19A := $11;
    Proc20_30B6(9);
  end
  else if Proc23_02E9(X, Y, $12, Self) <> 0 then
  begin
    POver23(Self)^.F19A := $12;
    Proc20_30B6(9);
  end
  else if Proc23_02E9(X, Y, $13, Self) <> 0 then
  begin
    POver23(Self)^.F19A := $13;
    Proc20_30B6(9);
  end
  else if Proc23_02E9(X, Y, $14, Self) <> 0 then
  begin
    POver23(Self)^.F19A := $14;
    Proc20_30B6(9);
  end
  else if Proc23_02E9(X, Y, $15, Self) <> 0 then
  begin
    T1 := Far1F2E(Far56AC(POver23(Self)^.F202));
    T2 := Far1F2E(FarE60(POver23(Self)^.F188));
    Far31C8(T2,
            POver23(Self)^.F20E^[POver23(Self)^.F213, 21].W0,
            POver23(Self)^.F20E^[POver23(Self)^.F213, 21].W1,
            POver23(Self)^.F20E^[POver23(Self)^.F213, 21].W2 - POver23(Self)^.F20E^[POver23(Self)^.F213, 21].W0,
            POver23(Self)^.F20E^[POver23(Self)^.F213, 21].W3 - POver23(Self)^.F20E^[POver23(Self)^.F213, 21].W1 + 1,
            T1,
            POver23(Self)^.F20E^[POver23(Self)^.F213, 21].W0 - POver23(Self)^.F20E^[POver23(Self)^.F213, 16].W0,
            0, $CC, $20);
    Proc23_3EEE(Self);
    POver23(Self)^.F19A := $15;
    Far22C6(POver23(Self)^.F188);
    Proc20_30B6(8);
  end;
end;

procedure TUebersichtsmap2.MenubildMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
end;

procedure TUebersichtsmap2.MenubildMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
end;

procedure TUebersichtsmap2.UeberschriftbildMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
end;

procedure TUebersichtsmap2.UeberschriftbildMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
end;

procedure TUebersichtsmap2.UeberschriftbildMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  if State.F19A = 2 then
  begin
    Proc23_31F8(Ueberschriftbild, 2, State.F1DE, POver23(Self)^);
    Ueberschriftbild.Refresh;
    Proc20_30B6($A);
    if Proc23_02E9(X, Y, 2, @POver23(Self)^) <> 0 then
      Proc23_3F7F(POver23(Self)^);
  end
  else if State.F19A = 3 then
  begin
    if State.F213 = 0 then
      Proc23_31F8(Ueberschriftbild, 3, State.F1DA, POver23(Self)^)
    else
      Proc23_31F8(Ueberschriftbild, 3, State.F1DE, POver23(Self)^);
    Ueberschriftbild.Refresh;
    Proc20_30B6($A);
    if Proc23_02E9(X, Y, 3, @POver23(Self)^) <> 0 then
    begin
      if State.F213 = 0 then State.F213 := 1 else State.F213 := 0;
      Proc23_3E73(POver23(Self)^);
    end;
  end
  else if State.F19A = 1 then
    if State.Pad212 = 0 then
      Height := Integer(State.F20E^[State.F213, 0].W3) + 1;
  State.F19A := 0;
end;

procedure TUebersichtsmap2.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
end;
procedure CallersInit23;
var
  N: Word;
  F: file;
  R: TOver23;
begin
  N := Const3A(nil);
  N := Const38(nil);
  N := Const3C(nil);
  Proc23_216E(0, 0, POuter(nil));
  Proc23_28E5(0, 0, POuter2(nil));
  Proc23_1504(0, 0, 0, 0, nil);
  Proc23_1534(0, 0, 0, 0, nil);
  Proc23_1564(0, 0, 0, 0, nil);
  Proc23_1594(0, 0, 0, 0, nil);
  Proc23_15C4(0, 0, 0, 0, nil);
  Proc23_15F4(0, 0, 0, 0, nil);
  Proc23_1624(0, 0, 0, 0, nil);
  Proc23_1654(0, 0, 0, 0, nil);
  Proc23_2E99(0, 0, 0, 0, 0, 0, nil);
  Proc23_1D21(0, 0, 0, 0, 0, 0, nil);
  Proc23_24A1(0, 0, 0, 0, 0, 0, nil);
  if Proc23_25CB(nil) = 0 then Proc23_26A8(nil, 0);
  Proc23_3FAB(R);
  Proc23_346A(nil, 0, nil, nil);
  Proc23_4E34(F, R);
  Proc23_4079(nil);
  Proc23_4538(nil);
  Proc23_39B1(nil, 0, 0, 0, nil);
  Proc23_17CF([], 0, 0, 0, 0, 0, R);
  Proc23_0C10(0, 0);
  Proc23_0DD2(0, 0);
  Proc23_0A0A(0, 0);
end;

begin
  CallersInit23;
end.
