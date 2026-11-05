unit GELD;
{ Reconstructed scaffold, holiday.exe code segment 14 (15560 bytes).
  This is form unit for TGeldmenuform; the original kept its forms inside the segment's own  unit
  (docs/tree.md).
  Evidence: form TGeldmenuform, 3 components.
  `uses` comes from this segment's relocation records, the class members
  from RTTI and form streams. Known close-handler bodies are recovered;
  other method bodies remain stubs. }
{$F+}
interface

uses ExtCtrls, Graphics, Controls, Forms, Classes, SysUtils;

type
  PFar14 = ^TFar14;
  TFour14 = packed record
    Lo: Word;
    Hi: Word;
  end;
  TFar14 = packed record
    Pad: array[0..$48] of Byte;
    Items: array[0..255] of TFour14;
  end;
  TFar14L = packed record
    Head: array[0..$23] of Byte;
    W24: SmallInt;
    Tail: array[0..34] of Byte;
    Items: array[0..255] of LongInt;
  end;
  PFar14L = ^TFar14L;
  TRec14 = record
    Filler: array[0..379] of Byte;
    At17C: Pointer;
    At180: Pointer;
    At184: Pointer;
  end;
  PRec14 = ^TRec14;
  TItem0DEA = packed record
    W0: Word;
    W2: Word;
    W4: Word;
    W6: Word;
  end;
  PTItems0DEA = ^TItems0DEA;
  TItems0DEA = array[0..255] of TItem0DEA;
  TInner0DEA = packed record
    Pad: array[0..$3FF] of Byte;
    Str400: String;
    Str500: String;
  end;
  PInner0DEA = ^TInner0DEA;
  TInner3 = packed record
    Str0: String;
  end;
  PInner3 = ^TInner3;
  TRec0DEA = packed record
    Pad: array[0..$188] of Byte;
    F189: PInner0DEA;
    F18D: PInner3;
    PadB: array[0..$500] of Byte;
    Items: PTItems0DEA;
  end;
  PRec0DEA = ^TRec0DEA;
  TThing38 = packed record W: Word; end;
  PThing38 = ^TThing38;
  TThing300 = packed record W: Word; end;
  PThing300 = ^TThing300;
  TThing3B27 = packed record W: Word; end;
  PThing3B27 = ^TThing3B27;
  TRec2AB8 = packed record
    Pad: array[0..$1F8] of Byte;
    A: LongInt;
    B: LongInt;
    C: LongInt;
  end;
  T2D1345 = array[0..119, 1..8] of LongInt;
  TTab1345 = packed record
    Tab: T2D1345;
    Gap: array[0..7] of Byte;
    F08: Byte;
    F09: Byte;
  end;
  PTab1345 = ^TTab1345;
  TRec1345 = packed record
    Pad1: array[0..$24A] of Byte;
    Ptr24B: PChar;
  end;
  TThing14B4 = packed record
    W: Word;
  end;
  PThing14B4 = ^TThing14B4;
  TRec14B4 = packed record
    Pad1: array[0..$17F] of Byte;
    F180: PThing14B4;
    Pad2: array[0..$8A] of Byte;
    F20F: PThing14B4;
  end;
    TAcc1452 = packed record
    Head: array[0..$23] of Byte;
    W24: SmallInt;
    Tail: array[0..34] of Byte;
    Items: array[0..$6A] of LongInt;
    Acc: LongInt;
  end;
  PAcc1452 = ^TAcc1452;
  TRec3B27 = packed record
    Pad1: array[0..$24A] of Byte;
    Ptr24B: PThing3B27;
    Pad2: array[0..$448] of Byte;
  end;
  TRec300 = packed record
    Pad0: array[0..$17F] of Byte;
    F180: PThing300;
    Pad1: array[0..3] of Byte;
    F188: Byte;
    Pad2: array[0..$7B] of Byte;
    F205: Byte;
    Pad3: array[0..$490] of Byte;
    F697: Byte;
  end;
  PRec300 = ^TRec300;
  TRec38D2 = packed record
    Pad0: array[0..$188] of Byte;
    F189: Pointer;
    F18D: Pointer;
    Pad1: array[0..$7d] of Byte;
    F20F: PThing38;
    F213: PThing38;
    F217: PThing38;
    F21B: PThing38;
    PadGap: array[0..$7] of Byte;
    F227: PThing38;
    F22B: PThing38;
    F22F: PThing38;
    F233: PThing38;
    F237: PThing38;
    Pad2: array[0..$f] of Byte;
    F24B: Pointer;
    Pad3: array[0..$442] of Byte;
    F692: Pointer;
  end;
  TObj14 = object
    pad: array[1..392] of Byte;
    kind: Byte;
    gap: array[1..138] of Byte;
    f213: Pointer;
    f217: Pointer;
    f21B: Pointer;
    f21F: Pointer;
    f223: Pointer;
    function Pick(mode: ShortInt): Pointer;
  end;
function ItemAt14(P: PFar14; N: Byte): TFour14;
procedure Proc14_01E8(A0, A1: Word);
procedure Proc14_01FC(A0, A1: Word);
function Proc14_0294(A0: Word; A1: Word; A2: ShortInt; var A3: TRec0DEA): Byte;
function Far6D7(A0, A1, A2, A3, A4, A5: Word): Byte;
procedure Proc14_0300(A0: Pointer; A1: Byte; A2: Word; A3: Pointer; var A4: TRec300);
function Far35A6(A0: Pointer; A1: Pointer; A2: Pointer): Boolean;
procedure Far381(var A0: TThing300);
procedure Far3C2(var A0: TThing300);
procedure Far403(var A0: TThing300);
procedure Far444(var A0: TThing300);
procedure Far484(var A0: TThing300);
procedure Far4C4(var A0: TThing300);
procedure Far546(var A0: TThing300);
function Far372(A0: Pointer; A1: Byte; var A2: TRec300): Boolean;
function Far3B3(A0: Pointer; A1: Byte; var A2: TRec300): Boolean;
function Far3F4(A0: Pointer; A1: Byte; var A2: TRec300): Boolean;
function Far435(A0: Pointer; A1: Byte; var A2: TRec300): Boolean;
function Far475(A0: Pointer; A1: Byte; var A2: TRec300): Boolean;
function Far4B5(A0: Pointer; A1: Byte; var A2: TRec300): Boolean;
procedure Far39D(A0: Byte; var A1: TRec300);
procedure Far3DE(A0: Byte; var A1: TRec300);
procedure Far41F(A0: Byte; var A1: TRec300);
procedure Far45F(A0: Byte; var A1: TRec300);
procedure Far49F(A0: Byte; var A1: TRec300);
procedure Far4FE(A0: Byte; var A1: TRec300);
procedure Far3C9(A0: Byte);
procedure Far40A(A0: Byte);
procedure Far44B(A0: Byte);
procedure Far48B(A0: Byte);
procedure Far4CB(A0: Byte);
procedure Far54D(A0: Byte);
procedure Proc14_04D3(A0, A1, A2, A3, A4, A5, A6, A7: Word);
procedure Proc14_0820(A0, A1, A2, A3, A4, A5, A6, A7: Word);
procedure Proc14_08E0(A0, A1, A2, A3, A4, A5, A6: Word);
procedure Proc14_096D(A0, A1, A2, A3, A4, A5, A6, A7: Word);
procedure Proc14_09F7(A0, A1, A2, A3, A4, A5, A6, A7: Word);
procedure Proc14_0AD5(A, B, C: LongInt; D: Byte);
procedure Proc14_0ADD(A0, A1, A2, A3, A4, A5, A6, A7: Word);
function Proc14_0B76(k: ShortInt; P: PRec14): Pointer;
function Proc14_0C8B(N: Byte; var P: TRec0DEA): Word;
function Proc14_0CBD(N: Byte; var P: TRec0DEA): Word;
function FarCCD(A0: Byte; A1: Pointer): Pointer;
function Far14C5(A0: Pointer): Pointer;
function FarCD8(A0: Pointer): Word;
function FarCFF(A0: Byte; A1: Pointer): Pointer;
function FarCE3(A0: Pointer): Pointer;
function Far119D(A0: Pointer): Word;
procedure Proc14_0CEF(A0: ShortInt; P: PRec0DEA);
procedure Far12DA(A0, A1, A2, A3, A4, A5, A6, A7, A8, A9: Word);
procedure Proc14_0DEA(S: ShortInt; R: ShortInt; Q: String; var P: TRec0DEA);
procedure FarF2F(A0: Pointer; A1, A2, A3, A4, A5, A6: Word; A7: String);
procedure FarFA1(A0: Pointer; A1, A2, A3, A4, A5, A6: Word; A7: String);
procedure Far1013(A0: Pointer; A1, A2, A3, A4, A5, A6: Word; A7: String);
procedure Far1085(A0: Pointer; A1, A2, A3, A4, A5, A6: Word; A7: String);
procedure Far10FA(A0: Pointer; A1, A2, A3, A4, A5, A6: Word; A7: String);
procedure Far1375(A0: Pointer; A1, A2, A3, A4, A5, A6: Word; A7: String);
procedure Proc14_1100(A0: Byte; var A1: TRec0DEA);
procedure Proc14_1178(A0, A1, A2: Word);
function Proc14_1345(A0: Byte; var A1: TRec1345): LongInt;
function Far19B6(A0: LongInt; A1, A2: Word): Byte;
function Proc14_13F1(X: ShortInt; P: PFar14L): LongInt;
procedure Proc14_1419(I: ShortInt; N: LongInt; G: PFar14L);
procedure Proc14_1452(P: Pointer);
procedure Far14AE(var A0: TAcc1452);
procedure Far15BD(var A0: TAcc1452);
procedure Proc14_14B4(A0: Byte; A1: Word; A2: Word; var A3: TRec14B4);
function Far1FB3(var A0: TThing14B4): Pointer;
function Far14E2(var A0: TThing14B4): Word;
function Far14ED(var A0: TThing14B4): Pointer;
function Far1F96(var A0: TThing14B4): Word;
procedure Far20A8(A0, A1, A2, A3, A4, A5, A6, A7, A8, A9: Word);
procedure Far15FD(A0: Byte; A1, A2: Word; A3: Pointer);
procedure Far169D(A0: Byte; A1, A2: Word; A3: Pointer);
procedure Far165D(A0, A1: Word; A2: Pointer);
procedure Far1975(A0: Word; A1: Pointer);
function Far1639(A0: Byte; A1: Double): Word;
function Far16FE(A0: Byte; A1: Word; A2: Double): Word;
procedure Proc14_151B(K: Byte; D, C, B, A: Integer; var P: TFar14);
procedure Proc14_16B7(var A0: TRec300);
procedure Proc14_1BA5(var A0: TRec300);
procedure Proc14_1D1F(var A0: TRec300);
procedure Proc14_1EEB(var P: TRec300);
procedure Far1F73(var A0: TThing300);
procedure Proc14_1F3F(A0, A1: Word);
procedure Proc14_1F79(P: PFar14L);
procedure Proc14_20E7(A0: Byte; var P: TRec300);
procedure Proc14_210A(A0: Pointer);
procedure Proc14_2617(var P: TFar14L);
procedure Proc14_2630(var P: TFar14L);
procedure Proc14_2653(P: PFar14L);
procedure Proc14_269D(P: PFar14L);
procedure Proc14_270F(var A0: TRec300);
procedure Proc14_28D3(var A0: TRec300);
procedure Proc14_2AB8(var P: TRec2AB8);
function Far2AD4(A0: Word): LongInt;
function Far2AEF(A0: Word): LongInt;
function Far2AF8(A0: Word): LongInt;
function Far317B(A0: Word): LongInt;
procedure Proc14_2B11(A0: Byte; var P: TRec300);
procedure Proc14_2B3A(var P: TRec300);
procedure Proc14_2BB4(A0, A1: Word);
procedure Proc14_2BFA(A0, A1: Word);
procedure Proc14_2E6C(A0, A1: Word);
procedure Proc14_38D2(var P: TRec38D2);
procedure FarFFFF(var A0: TRec38D2);
procedure Far3908(A0: Pointer; A1: Word);
procedure Far391D(A0: Pointer; A1: Word);
procedure Far3932(A0: Pointer; A1: Word);
procedure Far3941(A0: Pointer; A1: Word);
procedure Far3950(var A0: TThing38);
procedure Far395F(var A0: TThing38);
procedure Far396E(var A0: TThing38);
procedure Far397D(var A0: TThing38);
procedure Far398C(var A0: TThing38);
procedure Far399B(var A0: TThing38);
procedure Far39AA(var A0: TThing38);
procedure Far39B9(var A0: TThing38);
procedure Far3B41(var A0: TThing38);
procedure Proc14_39BF(A0, A1, A2, A3, A4, A5, A6: Word);
procedure Proc14_3B27(var A0, A1: TRec3B27);
procedure Far3B5A(var A0: TRec3B27; A1: Pointer; A2: Word; A3: Pointer);
procedure Far3B73(var A0: TRec3B27; A1: Pointer; A2: Word; A3: Pointer);
procedure Far3B8C(var A0: TRec3B27; A1: Pointer; A2: Word; A3: Pointer);
procedure Far3BA5(var A0: TRec3B27; A1: Pointer; A2: Word; A3: Pointer);
procedure Far3BBE(var A0: TRec3B27; A1: Pointer; A2: Word; A3: Pointer);
procedure Far3BD7(var A0: TRec3B27; A1: Pointer; A2: Word; A3: Pointer);
procedure Far3BF2(var A0: TRec3B27; A1: Pointer; A2: Word; A3: Pointer);
procedure Far3C12(var A0: TRec3B27; var A1: TThing3B27; A2: Word; A3: Pointer);
procedure Proc14_3BF8(var A0, A1: TRec3B27);
procedure Far3C2B(var A0: TRec3B27; A1: Pointer; A2: Word; A3: Pointer);
procedure Far3C44(var A0: TRec3B27; A1: Pointer; A2: Word; A3: Pointer);
procedure Far3C5D(var A0: TRec3B27; A1: Pointer; A2: Word; A3: Pointer);
procedure Far3C76(var A0: TRec3B27; A1: Pointer; A2: Word; A3: Pointer);
procedure Far3C8F(var A0: TRec3B27; A1: Pointer; A2: Word; A3: Pointer);
procedure Far3CA8(var A0: TRec3B27; A1: Pointer; A2: Word; A3: Pointer);
procedure Far3CC3(var A0: TRec3B27; A1: Pointer; A2: Word; A3: Pointer);
procedure FarCB7(var A0: TRec3B27; var A1: TThing3B27; A2: Word; A3: Pointer);


type
  TGeldmenuform = class(TForm)
    UeberschriftImage: TImage;
    BildImage: TImage;
    MenuImage: TImage;
  private
    { shortcut: opaque private storage; name fields as accesses are recovered. }
    UnrecoveredState: array[0..1574] of Byte;
  published
    procedure BildimageMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure BildimageMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure UeberschriftImageMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure UeberschriftImageMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure UeberschriftImageMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure MenuImageMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure MenuImageMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure MenuImageMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
  end;

implementation

uses ABRECHNE, DATEN, DATWIN, GFX, KOMPASS, SEG15, MENU, SOUND, SEG24;

function ItemAt14(P: PFar14; N: Byte): TFour14;
begin
  ItemAt14 := P^.Items[N];
end;

{ ADDRESS: MAIN 0x000e01e8 }
procedure Proc14_01E8;
begin
end;

{ ADDRESS: MAIN 0x000e01fc }
procedure Proc14_01FC;
begin
end;

{ ADDRESS: MAIN 0x000e0294 }
function Proc14_0294(A0: Word; A1: Word; A2: ShortInt; var A3: TRec0DEA): Byte;
begin
  Result := Far6D7(A0, A1, A3.Items^[A2].W0, A3.Items^[A2].W2,
                   A3.Items^[A2].W4, A3.Items^[A2].W6);
end;

function Far6D7(A0, A1, A2, A3, A4, A5: Word): Byte;
begin
  Far6D7 := 0;
end;

procedure Proc14_0300(A0: Pointer; A1: Byte; A2: Word; A3: Pointer; var A4: TRec300);
begin
  if A1 <> 0 then Exit;
  if Far35A6(A3, A4.F180, @A4.F697) then begin
    Far381(A4.F180^);
    Exit;
  end;
  if A4.F188 <> 0 then Exit;
  if Far372(A3, $17, A4) then begin
    A4.F205 := $17;
    Far39D($17, A4);
    Far3C2(A4.F180^);
    Far3C9(8);
    Exit;
  end;
  if Far3B3(A3, $18, A4) then begin
    A4.F205 := $18;
    Far3DE($18, A4);
    Far403(A4.F180^);
    Far40A(8);
    Exit;
  end;
  if Far3F4(A3, $12, A4) then begin
    A4.F205 := $12;
    Far41F($12, A4);
    Far444(A4.F180^);
    Far44B(8);
    Exit;
  end;
  if Far435(A3, $13, A4) then begin
    A4.F205 := $13;
    Far45F($13, A4);
    Far484(A4.F180^);
    Far48B(8);
    Exit;
  end;
  if Far475(A3, $14, A4) then begin
    A4.F205 := $14;
    Far49F($14, A4);
    Far4C4(A4.F180^);
    Far4CB(8);
    Exit;
  end;
  if Far4B5(A3, $15, A4) then begin
    A4.F205 := $15;
    Far4FE($15, A4);
    Far546(A4.F180^);
    Far54D(8);
    Exit;
  end;
end;

function Far35A6(A0: Pointer; A1: Pointer; A2: Pointer): Boolean;
begin
Far35A6 := False;
end;

procedure Far381(var A0: TThing300);
begin
end;

procedure Far3C2(var A0: TThing300);
begin
end;

procedure Far403(var A0: TThing300);
begin
end;

procedure Far444(var A0: TThing300);
begin
end;

procedure Far484(var A0: TThing300);
begin
end;

procedure Far4C4(var A0: TThing300);
begin
end;

procedure Far546(var A0: TThing300);
begin
end;

function Far372(A0: Pointer; A1: Byte; var A2: TRec300): Boolean;
begin
Far372 := False;
end;

function Far3B3(A0: Pointer; A1: Byte; var A2: TRec300): Boolean;
begin
Far3B3 := False;
end;

function Far3F4(A0: Pointer; A1: Byte; var A2: TRec300): Boolean;
begin
Far3F4 := False;
end;

function Far435(A0: Pointer; A1: Byte; var A2: TRec300): Boolean;
begin
Far435 := False;
end;

function Far475(A0: Pointer; A1: Byte; var A2: TRec300): Boolean;
begin
Far475 := False;
end;

function Far4B5(A0: Pointer; A1: Byte; var A2: TRec300): Boolean;
begin
Far4B5 := False;
end;

procedure Far39D(A0: Byte; var A1: TRec300);
begin
end;

procedure Far3DE(A0: Byte; var A1: TRec300);
begin
end;

procedure Far41F(A0: Byte; var A1: TRec300);
begin
end;

procedure Far45F(A0: Byte; var A1: TRec300);
begin
end;

procedure Far49F(A0: Byte; var A1: TRec300);
begin
end;

procedure Far4FE(A0: Byte; var A1: TRec300);
begin
end;

procedure Far3C9(A0: Byte);
begin
end;

procedure Far40A(A0: Byte);
begin
end;

procedure Far44B(A0: Byte);
begin
end;

procedure Far48B(A0: Byte);
begin
end;

procedure Far4CB(A0: Byte);
begin
end;

procedure Far54D(A0: Byte);
begin
end;

procedure Proc14_04D3;
begin
end;

procedure Proc14_0820;
begin
end;

procedure Proc14_08E0;
begin
end;

procedure Proc14_096D;
begin
end;

procedure Proc14_09F7;
begin
end;

procedure Proc14_0AD5(A, B, C: LongInt; D: Byte);
var
  W: Word;
begin
end;

procedure Proc14_0ADD;
begin
end;

{ ADDRESS: MAIN 0x000e0b76 }
function Proc14_0B76(k: ShortInt; P: PRec14): Pointer;
begin
  if (k >= $11) and (k <= $75) then
    Result := P^.At180
  else if (k >= 8) and (k <= $10) then
    Result := P^.At184
  else if (k >= 4) and (k <= 7) then
    Result := P^.At17C;
end;

function TObj14.Pick(mode: ShortInt): Pointer;
begin
  if (mode >= 17) and (mode <= 117) then
  begin
    case kind of
      0: Pick := f213;
      1: Pick := f217;
    else
      Pick := f21B;
    end;
    Exit;
  end;
  if (mode >= 8) and (mode <= 16) then
    Pick := f21F
  else if (mode >= 4) and (mode <= 7) then
    Pick := f223;
end;

{ ADDRESS: MAIN 0x000e0c8b }
function Proc14_0C8B(N: Byte; var P: TRec0DEA): Word;
begin
  Proc14_0C8B := FarCD8(Far14C5(FarCCD(N, @P)));
end;

{ ADDRESS: MAIN 0x000e0cbd }
function Proc14_0CBD(N: Byte; var P: TRec0DEA): Word;
begin
  Proc14_0CBD := Far119D(FarCE3(FarCFF(N, @P)));
end;

function FarCCD(A0: Byte; A1: Pointer): Pointer;
begin
  FarCCD := NIL;
end;

function Far14C5(A0: Pointer): Pointer;
begin
  Far14C5 := NIL;
end;

function FarCD8(A0: Pointer): Word;
begin
  FarCD8 := 0;
end;

function FarCFF(A0: Byte; A1: Pointer): Pointer;
begin
  FarCFF := NIL;
end;

function FarCE3(A0: Pointer): Pointer;
begin
  FarCE3 := NIL;
end;

function Far119D(A0: Pointer): Word;
begin
  Far119D := 0;
end;

{ ADDRESS: MAIN 0x000e0cef }
procedure Proc14_0CEF(A0: ShortInt; P: PRec0DEA);
var
  Vcbd: Word;
  Vc8b: Word;
begin
  Vcbd := Proc14_0CBD(A0, P^);
  Vc8b := Proc14_0C8B(A0, P^);
  Far12DA(Vc8b,
          P^.Items^[A0].W0,
          P^.Items^[A0].W2,
          P^.Items^[A0].W4 - P^.Items^[A0].W0 + 1,
          P^.Items^[A0].W6 - P^.Items^[A0].W2 + 1,
          Vcbd,
          P^.Items^[A0].W0,
          P^.Items^[A0].W2,
          $CC,
          $20);
end;

procedure Far12DA(A0, A1, A2, A3, A4, A5, A6, A7, A8, A9: Word);
begin
end;

{ ADDRESS: MAIN 0x000e0dea }
procedure Proc14_0DEA(S: ShortInt; R: ShortInt; Q: String; var P: TRec0DEA);
var
  T: Pointer;
begin
  case R of
    4, 7, 5, 6:
      Proc14_0CEF(S, @P);
  end;
  T := Proc14_0B76(S, PRec14(@P));
  case R of
    2, 6:
      FarF2F(T, 9, P.Items^[S].W0, P.Items^[S].W2,
             P.Items^[S].W4 - P.Items^[S].W0 + 1, 0, 0, Q);
    1, 5, 9:
      FarFA1(T, 9, P.Items^[S].W0, P.Items^[S].W2,
             P.Items^[S].W4 - P.Items^[S].W0 + 1, 0, 1, Q);
    3:
      Far1013(T, 1, P.Items^[S].W0, P.Items^[S].W2,
              P.Items^[S].W4 - P.Items^[S].W0 + 1, 0, 1, Q);
    0, 4:
      Far1085(T, 9, P.Items^[S].W0, P.Items^[S].W2,
              P.Items^[S].W4 - P.Items^[S].W0 + 1, 0, 2, Q);
    7:
      Far10FA(T, 11, P.Items^[S].W0, P.Items^[S].W2,
              P.Items^[S].W4 - P.Items^[S].W0 + 1, 0, 2, Q);
    8:
      Far1375(T, 9, P.Items^[S].W0 + 1, P.Items^[S].W2 + 1,
              P.Items^[S].W4 - P.Items^[S].W0 + 1, 0, 1, Q);
  end;
end;

procedure FarF2F(A0: Pointer; A1, A2, A3, A4, A5, A6: Word; A7: String);
begin
end;

procedure FarFA1(A0: Pointer; A1, A2, A3, A4, A5, A6: Word; A7: String);
begin
end;

procedure Far1013(A0: Pointer; A1, A2, A3, A4, A5, A6: Word; A7: String);
begin
end;

procedure Far1085(A0: Pointer; A1, A2, A3, A4, A5, A6: Word; A7: String);
begin
end;

procedure Far10FA(A0: Pointer; A1, A2, A3, A4, A5, A6: Word; A7: String);
begin
end;

procedure Far1375(A0: Pointer; A1, A2, A3, A4, A5, A6: Word; A7: String);
begin
end;

{ ADDRESS: MAIN 0x000e1100 }
procedure Proc14_1100(A0: Byte; var A1: TRec0DEA);
begin
  Proc14_0CEF(A0, @A1);
  case A0 of
    $17: Proc14_0DEA($20, 9, A1.F189^.Str400, A1);
    $18: Proc14_0DEA($21, 9, A1.F189^.Str500, A1);
    $0F: Proc14_0DEA($10, 9, A1.F18D^.Str0, A1);
  end;
end;

{ ADDRESS: MAIN 0x000e1178 }
procedure Proc14_1178;
begin
end;

{ ADDRESS: MAIN 0x000e1345 }
function Proc14_1345(A0: Byte; var A1: TRec1345): LongInt;
var
  I: Byte;
  T: Byte;
  Acc: LongInt;
  Base: PTab1345;
begin
  Base := PTab1345(A1.Ptr24B + $1E14);
  Acc := 0;
  for I := 1 to Far19B6(LongInt(Base^.F08), 0, $C) do
    Acc := Acc + Base^.Tab
      [(Byte(Base^.F08) + Byte(Base^.F09) - I) mod 120, A0];
  Result := Acc;
end;

function Far19B6(A0: LongInt; A1, A2: Word): Byte;
begin
  Far19B6 := 0;
end;

{ ADDRESS: MAIN 0x000e13f1 }
function Proc14_13F1(X: ShortInt; P: PFar14L): LongInt;
begin
  Proc14_13F1 := P^.Items[X];
end;

{ ADDRESS: MAIN 0x000e1419 }
procedure Proc14_1419(I: ShortInt; N: LongInt; G: PFar14L);
begin
  G^.Items[I] := G^.Items[I] + N;
end;

{ ADDRESS: MAIN 0x000e1452 }
procedure Proc14_1452(P: Pointer);
var
  I: ShortInt;
begin
  PAcc1452(P)^.Acc := 0;
  for I := $5F to $6A do
    PAcc1452(P)^.Acc := PAcc1452(P)^.Acc + PAcc1452(P)^.Items[I];
  Far14AE(PAcc1452(P)^);
  Far15BD(PAcc1452(P)^);
end;

procedure Far14AE(var A0: TAcc1452);
begin
end;

procedure Far15BD(var A0: TAcc1452);
begin
end;

{ ADDRESS: MAIN 0x000e14b4 }
procedure Proc14_14B4(A0: Byte; A1: Word; A2: Word; var A3: TRec14B4);
var
  W1: Word;
  W2: Word;
begin
  W1 := Far14E2(PThing14B4(Far1FB3(A3.F180^))^);
  W2 := Far1F96(PThing14B4(Far14ED(A3.F20F^))^);
  Far20A8(W1, A1, A2, 2, 2, W2, (A0 - 1) * 2, 0, $CC, $20);
end;

function Far1FB3(var A0: TThing14B4): Pointer;
begin
  Far1FB3 := nil;
end;

function Far14E2(var A0: TThing14B4): Word;
begin
  Far14E2 := 0;
end;

function Far14ED(var A0: TThing14B4): Pointer;
begin
  Far14ED := nil;
end;

function Far1F96(var A0: TThing14B4): Word;
begin
  Far1F96 := 0;
end;

procedure Far20A8(A0, A1, A2, A3, A4, A5, A6, A7, A8, A9: Word);
begin
end;

procedure Far15FD(A0: Byte; A1, A2: Word; A3: Pointer);
begin
end;

procedure Far169D(A0: Byte; A1, A2: Word; A3: Pointer);
begin
end;

procedure Far165D(A0, A1: Word; A2: Pointer);
begin
end;

procedure Far1975(A0: Word; A1: Pointer);
begin
end;

function Far1639(A0: Byte; A1: Double): Word;
begin
  Far1639 := 0;
end;

function Far16FE(A0: Byte; A1: Word; A2: Double): Word;
begin
  Far16FE := 0;
end;

{ ADDRESS: MAIN 0x000e151b }
procedure Proc14_151B(K: Byte; D, C, B, A: Integer; var P: TFar14);
var
  i: Integer;
  tmp: Integer;
  Step: Double;
  T: Double;
  U: Double;
begin
  if Abs(C - A) > Abs(D - B) then
  begin
    if C > A then
    begin
      tmp := C;
      C := A;
      A := tmp;
      tmp := D;
      D := B;
      B := tmp;
    end;
    U := B - D;
    Step := U / (A - C);
    T := D;
    Far15FD(K, D, C, @P);
    for i := C + 1 to A do
    begin
      T := T + Step;
      Far165D(Far1639(K, T), i, @P);
    end;
  end
  else
  begin
    U := A - C;
    Step := U / (B - D);
    T := C;
    Far169D(K, D, C, @P);
    for i := D + 1 to B do
    begin
      T := T + Step;
      Far1975(Far16FE(K, i, T), @P);
    end;
  end;
end;

{ ADDRESS: MAIN 0x000e16b7 }
procedure Proc14_16B7(var A0: TRec300);
begin
end;

{ ADDRESS: MAIN 0x000e1ba5 }
procedure Proc14_1BA5(var A0: TRec300);
begin
end;

{ ADDRESS: MAIN 0x000e1d1f }
procedure Proc14_1D1F(var A0: TRec300);
begin
end;

{ ADDRESS: MAIN 0x000e1eeb }
procedure Proc14_1EEB(var P: TRec300);
begin
  Proc14_1BA5(P);
  Proc14_0CEF($11, @P);
  Proc14_28D3(P);
  Proc14_270F(P);
  Proc14_16B7(P);
  Proc14_1D1F(P);
  Far1F73(P.F180^);
end;

procedure Far1F73(var A0: TThing300);
begin
end;

{ ADDRESS: MAIN 0x000e1f3f }
procedure Proc14_1F3F;
begin
end;

{ ADDRESS: MAIN 0x000e1f79 }
procedure Proc14_1F79(P: PFar14L);
begin
end;

{ ADDRESS: MAIN 0x000e20e7 }
procedure Proc14_20E7(A0: Byte; var P: TRec300);
begin
end;

{ ADDRESS: MAIN 0x000e210a }
procedure Proc14_210A;
begin
end;

{ ADDRESS: MAIN 0x000e2617 }
procedure Proc14_2617(var P: TFar14L);
var
  T: Word;
begin
  if P.W24 > 0 then
    Proc14_1452(@P);
end;

{ ADDRESS: MAIN 0x000e2630 }
procedure Proc14_2630(var P: TFar14L);
var
  T: Word;
begin
  if P.W24 > 0 then
    Proc14_1452(@P);
  Proc14_1F79(@P);
end;

{ ADDRESS: MAIN 0x000e2653 }
procedure Proc14_2653(P: PFar14L);
var
  I, J: ShortInt;
begin
  I := $52;
  J := $5F;
  while I <= $5E do
  begin
    P^.Items[I] := 0;
    P^.Items[J] := 0;
    Inc(I);
    Inc(J);
  end;
end;

{ ADDRESS: MAIN 0x000e269d }
procedure Proc14_269D(P: PFar14L);
var
  I: ShortInt;
  J: ShortInt;
begin
  Proc14_1452(P);
  I := $52;
  J := $5F;
  while I <= $5E do
  begin
    P^.Items[I] := P^.Items[J];
    P^.Items[J] := 0;
    Inc(I);
    Inc(J);
  end;
  Proc14_2617(P^);
end;

{ ADDRESS: MAIN 0x000e270f }
procedure Proc14_270F(var A0: TRec300);
begin
end;

{ ADDRESS: MAIN 0x000e28d3 }
procedure Proc14_28D3(var A0: TRec300);
begin
end;

{ ADDRESS: MAIN 0x000e2ab8 }
procedure Proc14_2AB8(var P: TRec2AB8);
begin
  P.A := Far2AD4(1);
  P.B := -Far2AEF(1);
  P.C := Far317B(1) - Far2AF8(1);
end;

function Far2AD4(A0: Word): LongInt;
begin
  Far2AD4 := 0;
end;

function Far2AEF(A0: Word): LongInt;
begin
  Far2AEF := 0;
end;

function Far2AF8(A0: Word): LongInt;
begin
  Far2AF8 := 0;
end;

function Far317B(A0: Word): LongInt;
begin
  Far317B := 0;
end;

{ ADDRESS: MAIN 0x000e2b11 }
procedure Proc14_2B11(A0: Byte; var P: TRec300);
begin
  if A0 <> P.F188 then
    Proc14_20E7(A0, P);
  Proc14_2B3A(P);
end;

{ ADDRESS: MAIN 0x000e2b3a }
procedure Proc14_2B3A(var P: TRec300);
begin
end;

{ ADDRESS: MAIN 0x000e2bb4 }
procedure Proc14_2BB4;
begin
end;

{ ADDRESS: MAIN 0x000e2bfa }
procedure Proc14_2BFA;
begin
end;

{ ADDRESS: MAIN 0x000e2e6c }
procedure Proc14_2E6C;
begin
end;

{ ADDRESS: MAIN 0x000e38d2 }
procedure Proc14_38D2(var P: TRec38D2);
var
  T: Word;
begin
  FarFFFF(P);
  Far3908(P.F18D, $100);
  Far391D(P.F189, $1900);
  Far3932(P.F692, $3b0);
  Far3941(P.F24B, $3c28);
  Far3950(P.F20F^);
  Far395F(P.F213^);
  Far396E(P.F217^);
  Far397D(P.F21B^);
  Far398C(P.F227^);
  Far399B(P.F22B^);
  Far39AA(P.F22F^);
  Far39B9(P.F233^);
  Far3B41(P.F237^);
end;

procedure FarFFFF(var A0: TRec38D2);
begin
end;

procedure Far3908(A0: Pointer; A1: Word);
begin
end;

procedure Far391D(A0: Pointer; A1: Word);
begin
end;

procedure Far3932(A0: Pointer; A1: Word);
begin
end;

procedure Far3941(A0: Pointer; A1: Word);
begin
end;

procedure Far3950(var A0: TThing38);
begin
end;

procedure Far395F(var A0: TThing38);
begin
end;

procedure Far396E(var A0: TThing38);
begin
end;

procedure Far397D(var A0: TThing38);
begin
end;

procedure Far398C(var A0: TThing38);
begin
end;

procedure Far399B(var A0: TThing38);
begin
end;

procedure Far39AA(var A0: TThing38);
begin
end;

procedure Far39B9(var A0: TThing38);
begin
end;

procedure Far3B41(var A0: TThing38);
begin
end;

procedure Proc14_39BF;
begin
end;

{ ADDRESS: MAIN 0x000e3b27 }
procedure Proc14_3B27(var A0, A1: TRec3B27);
begin
  Far3B5A(A0, @A1.Pad1[$188], 1, NIL);
  Far3B73(A0, @A1.Pad1[$191], $74, NIL);
  Far3B8C(A0, @A1.Pad1[$205], 1, NIL);
  Far3BA5(A0, @A1.Pad1[$206], 4, NIL);
  Far3BBE(A0, @A1.Pad1[$20A], 4, NIL);
  Far3BD7(A0, @A1.Pad1[$20E], 1, NIL);
  Far3BF2(A0, @A1.Pad2[$447], 1, NIL);
  Far3C12(A0, A1.Ptr24B^, $3C28, NIL);
end;

procedure Far3B5A(var A0: TRec3B27; A1: Pointer; A2: Word; A3: Pointer);
begin
end;

procedure Far3B73(var A0: TRec3B27; A1: Pointer; A2: Word; A3: Pointer);
begin
end;

procedure Far3B8C(var A0: TRec3B27; A1: Pointer; A2: Word; A3: Pointer);
begin
end;

procedure Far3BA5(var A0: TRec3B27; A1: Pointer; A2: Word; A3: Pointer);
begin
end;

procedure Far3BBE(var A0: TRec3B27; A1: Pointer; A2: Word; A3: Pointer);
begin
end;

procedure Far3BD7(var A0: TRec3B27; A1: Pointer; A2: Word; A3: Pointer);
begin
end;

procedure Far3BF2(var A0: TRec3B27; A1: Pointer; A2: Word; A3: Pointer);
begin
end;

procedure Far3C12(var A0: TRec3B27; var A1: TThing3B27; A2: Word; A3: Pointer);
begin
end;

{ ADDRESS: MAIN 0x000e3bf8 }
procedure Proc14_3BF8(var A0, A1: TRec3B27);
begin
  Far3C2B(A0, @A1.Pad1[$188], 1, NIL);
  Far3C44(A0, @A1.Pad1[$191], $74, NIL);
  Far3C5D(A0, @A1.Pad1[$205], 1, NIL);
  Far3C76(A0, @A1.Pad1[$206], 4, NIL);
  Far3C8F(A0, @A1.Pad1[$20A], 4, NIL);
  Far3CA8(A0, @A1.Pad1[$20E], 1, NIL);
  Far3CC3(A0, @A1.Pad2[$447], 1, NIL);
  FarCB7(A0, A1.Ptr24B^, $3C28, NIL);
end;

procedure Far3C2B(var A0: TRec3B27; A1: Pointer; A2: Word; A3: Pointer);
begin
end;

procedure Far3C44(var A0: TRec3B27; A1: Pointer; A2: Word; A3: Pointer);
begin
end;

procedure Far3C5D(var A0: TRec3B27; A1: Pointer; A2: Word; A3: Pointer);
begin
end;

procedure Far3C76(var A0: TRec3B27; A1: Pointer; A2: Word; A3: Pointer);
begin
end;

procedure Far3C8F(var A0: TRec3B27; A1: Pointer; A2: Word; A3: Pointer);
begin
end;

procedure Far3CA8(var A0: TRec3B27; A1: Pointer; A2: Word; A3: Pointer);
begin
end;

procedure Far3CC3(var A0: TRec3B27; A1: Pointer; A2: Word; A3: Pointer);
begin
end;

procedure FarCB7(var A0: TRec3B27; var A1: TThing3B27; A2: Word; A3: Pointer);
begin
end;

{ ADDRESS: MAIN 0x000e0300 }
procedure TGeldmenuform.BildimageMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
end;

{ ADDRESS: MAIN 0x000e04d3 }
procedure TGeldmenuform.BildimageMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
end;

{ ADDRESS: MAIN 0x000e0820 }
procedure TGeldmenuform.UeberschriftImageMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
end;

{ ADDRESS: MAIN 0x000e08e0 }
procedure TGeldmenuform.UeberschriftImageMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
end;

{ ADDRESS: MAIN 0x000e096d }
procedure TGeldmenuform.UeberschriftImageMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
end;

{ ADDRESS: MAIN 0x000e09f7 }
procedure TGeldmenuform.MenuImageMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
end;

{ ADDRESS: MAIN 0x000e0add }
procedure TGeldmenuform.MenuImageMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
end;

{ ADDRESS: MAIN 0x000e39bf }
procedure TGeldmenuform.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
end;

{ ADDRESS: MAIN 0x000e0ad5 }
procedure TGeldmenuform.MenuImageMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
{ Original two-byte frame; local name and type are unresolved. }
var Reserved: Integer;
begin
end;
procedure CallersInit14;
var
  Cells14L: TFar14L;
  Cells14: TFar14;
  Rec14: TFar14;
  Item14: TFour14;
  RecPick14: TRec14;
  PtrPick14: PRec14;
  Res14: LongInt;
  ResW14: Word;
  ResW14b: Word;
  Obj14: TObj14;
  ObjRes14: Pointer;
  Str14: String;
  Box14: TRec0DEA;
  Box300: TRec300;
  Ptr300: Pointer;
  Box38: TRec38D2;
  Box3Ba: TRec3B27;
  Box3Bb: TRec3B27;
  Box3Fa: TRec3B27;
  Box3Fb: TRec3B27;
  Box1345: TRec1345;
  ResL1345: LongInt;
  Box14B4: TRec14B4;
  Box1452: TAcc1452;
  Box2AB8: TRec2AB8;
begin
  Item14 := ItemAt14(@Rec14, 0);
  Proc14_2653(@Cells14);
  Proc14_1419(0, 0, @Cells14L);
  Proc14_0AD5(0, 0, 0, 0);
  PtrPick14 := Proc14_0B76(0, @RecPick14);
  Res14 := Proc14_13F1(0, @Cells14L);
  ResW14 := Proc14_0C8B(0, Box14);
  ResW14 := Proc14_0294(0, 0, 0, Box14);
  ResW14b := Proc14_0CBD(0, Box14);
  Obj14.kind := 0;
  ObjRes14 := Obj14.Pick(0);
  Proc14_269D(@Cells14);
  Proc14_2630(Cells14L);
  Proc14_151B(0, 2, 0, 1, 0, Cells14);
  Proc14_0DEA(0, 10, Str14, Box14);
  Proc14_0300(Ptr300, 0, 0, Ptr300, Box300);
  Proc14_38D2(Box38);
  Proc14_3B27(Box3Ba, Box3Bb);
  Proc14_3BF8(Box3Fa, Box3Fb);
  ResL1345 := Proc14_1345(0, Box1345);
  Proc14_1100(0, Box14);
  Proc14_14B4(0, 0, 0, Box14B4);
  Proc14_1452(@Box1452);
  Proc14_1EEB(Box300);
  Proc14_2B11(0, Box300);
  Proc14_2AB8(Box2AB8);
end;

begin
  CallersInit14;
end.
