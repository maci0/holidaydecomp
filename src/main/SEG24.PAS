unit SEG24;
{ Reconstructed scaffold, holiday.exe code segment 24 (7430 bytes).
  This is unit; the original kept its forms inside the segment's own  unit (docs/tree.md).
  Evidence: no strings, logic-only unit, name unknown.
  `uses` comes from this segment's relocation records, the class members
  from RTTI and form streams. Recovered free bodies are listed in the
  implementation; the other bodies are not recovered. }
{$F+}
interface

uses ExtCtrls, Graphics;

type
  { The far-procedure directive above makes procedure variables far, so a table entry can
    hold a loader-assigned selector:offset pair and still be callable. Without it an entry
    is a near pointer and the far indirect call cannot be expressed at all (round 246). }
  TDispatchMethod = procedure(Second, First: Word; P: Pointer);
  { Wrapped in a record so `^TDispatch` is a NEAR pointer: the target loads it with
    `mov di, [es:di + 9]`, and a pointer to an array type compiles far (round 252). }
  { A Turbo Pascal `object` with virtual methods: the instance carries a NEAR VMT offset
    at its start, the VMT lives in the data segment, and a virtual call compiles to
    `mov di, [es:di + 9]` then `lcall [di + slot]` â exactly the target's pair (round 259). }
  TDispatch = object
    procedure Call(Second, First: Word; P: Pointer); virtual;
    procedure Slot2(Second, First: Word; P: Pointer); virtual;
    procedure Slot3(Second, First: Word; P: Pointer); virtual;
    procedure Slot4(Second, First: Word; P: Pointer); virtual;
    procedure Slot5(Second, First: Word; P: Pointer); virtual;
    procedure Slot6(Second, First: Word; P: Pointer); virtual;
  end;
  PDispatch = ^TDispatch;

  PRecord24 = ^TRecord24;
  TRecord24 = packed record
    Pad0: array[0..7] of Byte;
    Flag: Byte;
    Dispatch: TDispatch;   { an INLINE object: its first word at +0x09 is the VMT offset }
    Left: SmallInt;
    Top: SmallInt;
    Height: SmallInt;
    Width: SmallInt;
    Word0F: Word;
    Field15: SmallInt;
    Field17: Word;
    Field19: Word;
    Field1B: SmallInt;
    Field1D: SmallInt;
    Field1F: SmallInt;
    Pad21: array[0..$16] of Byte;   { 0x21 .. 0x37 }
    Field38: Word;                  { 0x38 }
    Pad3A: array[0..2] of Byte;     { 0x3a .. 0x3c }
    Field3D: Word;                  { 0x3d }
    Pad3F: Byte;                    { 0x3f }
    Pad40: array[0..$CE] of Byte;   { through +0x10E }
    Byte10F: Byte;                  { 0x10f }
  end;
  TRectState = object
    Left, Top, Height, Width: SmallInt;
    Enabled: Byte;
    constructor Init(E: Byte; W, H, T, L: SmallInt);
  end;

type
  { The record the flag setters write and RectContains reads: four SmallInt
    fields and a Byte, the nine-byte layout the constructor allocates. }
  PRectState = ^TRectState;
  PByteArray = ^TByteArray;
  TByteArray = array[0..32767] of Byte;
  TRect24 = packed record
    Left: Integer;
    Top: Integer;
    Height: Integer;
    Width: Integer;
    Valid: Boolean;
  end;
  PRect24 = ^TRect24;
  TRectState24 = packed record
    Left, Top, Height, Width: SmallInt;
    Valid: Byte;
  end;
  TRec409 = packed record
    Pad: array[0..$1A] of Byte;
    F1B: Integer;
    F1D: Integer;
  end;
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
  T74CA = class
    function M6F58: Byte;
  end;
function HasRoom(R: PRecord24): Boolean;
function HitTest(R: PRecord24; Y, X: Word): Boolean;
function Past1(R: PRecord24): Boolean;
function Proc24_006B(Y, X: SmallInt; var R: TRectState24): Boolean;
function Proc24_0409(var R: TRec409): Boolean;
function RectContains(Y, X: SmallInt; var R: TRectState): Boolean;
function SpanAtLeast(R: PRecord24): Boolean;
procedure Empty0;
procedure Empty2(a: LongInt);
procedure Empty4(a: LongInt; b: LongInt);
procedure EmptySevenA;
procedure EmptySevenB;
procedure EmptySevenC;
procedure EmptySevenD;
procedure EmptySevenE;
procedure EmptySevenF;
procedure EmptySevenG;
procedure Flag0(P: PByteArray);
procedure Flag1(P: PByteArray);
procedure ForwardToTarget(Second, First: Word; var P: TRecord24);
procedure ForwardedTarget(Second, First: Word; var P: TRecord24);
procedure GuardedCall(Second, First: Word; var P: TRecord24);
procedure GuardedCallEx(Second, First: Word; var P: TRecord24);
procedure MakeNine(A, B, C: Word);
procedure Proc24_0002(A0, A1, A2, A3, A4, A5, A6, A7: Word);
procedure Proc24_003E(A0, A1, A2: Word);
procedure Proc24_004D(A0, A1: Word);
procedure Proc24_005C(A0, A1: Word);
procedure Proc24_00B3(A0, A1: Word);
procedure Proc24_00BA(A0, A1, A2, A3: Word);
procedure Proc24_00E4(A0, A1, A2, A3, A4, A5: Word);
procedure Proc24_0116(A0, A1, A2, A3: Word);
procedure Proc24_011D(A0, A1, A2, A3, A4, A5: Word);
procedure Proc24_0181(A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10: Word);
procedure Proc24_01DC(A0, A1, A2, A3: Word);
procedure Proc24_02A2(A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10: Word);
procedure Proc24_0316(A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11: Word);
procedure Proc24_039D(A0, A1, A2: Word);
function Proc24_03CC(A0: Pointer): Boolean;
function Proc24_03E7(A0: Pointer): Boolean;
function Proc24_0431(A0, A1: Word; A2: Byte; A3, A4: Word; var A5: TRectState24): Boolean;
procedure Proc24_04ED(A0: Pointer; var A1);
procedure Proc24_0552(A0, A1: Word);
procedure Proc24_0559(A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14: Word);
procedure Proc24_05D6(A0, A1, A2, A3: Word);
function Proc24_0666(A0, A1: Word; A2, A3: Pointer): Boolean;
procedure Proc24_06C7(A0, A1, A2, A3: Word);
procedure Proc24_06FE(A0: LongInt; A1: Pointer);
procedure Proc24_0725(A0, A1: Word);
procedure Proc24_072C(A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15: Word);
function Proc24_0797(A0, A1: Word; A2: Pointer; var A3): Byte;
procedure Proc24_07FA(A0, A1, A2, A3: Word);
procedure Proc24_083B(A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13: Word);
procedure Proc24_08CB(A0, A1, A2, A3: Word);
procedure Proc24_0958(A0, A1, A2, A3, A4, A5: Word);
procedure Proc24_0998(A0, A1, A2, A3, A4, A5: Word);
procedure Proc24_09EB(A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11, A12, A13, A14, A15, A16, A17, A18: Word);
procedure Proc24_0AEC(A0, A1, A2, A3: Word);
procedure Proc24_0E21(A0, A1, A2: Word);
procedure Proc24_0F10(A0, A1, A2: Word);
procedure Proc24_0FE3(A0, A1, A2, A3, A4, A5: Word);
procedure Proc24_13B0(A0, A1, A2, A3, A4, A5: Word);
procedure Proc24_15F7(A0, A1, A2, A3, A4, A5: Word);
procedure Proc24_191B(A0, A1: Word);
procedure Proc24_1922(A0, A1: Word);
procedure Proc24_1929(A0, A1: Word);
procedure Proc24_1930(A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, A11: Word);
procedure Proc24_19C0(A0, A1, A2, A3: Word);
function Proc24_19D7(A0, A1, A2, A3: Word; var A4; var A5): Boolean;
function Proc24_1C1B(A0, A1: Word; A2: Pointer; var A3; var A4: TRectState24): Boolean;
procedure Proc24_1CC1(A0: ShortInt; var A1);
procedure ResetAndCall(Second, First: Word; var P: TRecord24);
procedure SetFlagOne(var P: TRecord24);
procedure SetFlagZero(var P: TRecord24);
procedure Far16E9(A0: string; A1: Char);
procedure Far1716B(A0: string; A1, A2: Word);
var
  Pad73AE: array[0..283] of Byte;
  G74CA: T74CA;
  P74CA: Pointer absolute G74CA;

implementation


function T74CA.M6F58: Byte;
begin
  Result := 0;
end;

constructor TRectState.Init(E: Byte; W, H, T, L: SmallInt);
begin
  Left := L;
  Top := T;
  Height := H;
  Width := W;
  Enabled := E;
end;

function HasRoom(R: PRecord24): Boolean;
begin
  HasRoom := (R^.Field1B > 0) and (R^.Field1B <= R^.Field1D);
end;

function HitTest(R: PRecord24; Y, X: Word): Boolean;
begin
  HitTest := (R^.Flag <> 0) and (Y >= R^.Top) and (X >= R^.Left)
    and (R^.Top + R^.Height >= Y) and (R^.Left + R^.Width >= X);
end;

function Past1(R: PRecord24): Boolean;
begin
  Past1 := R^.Field1F > 1;
end;

{ ADDRESS: MAIN 0x0018006b }
function Proc24_006B(Y, X: SmallInt; var R: TRectState24): Boolean;
begin
  Proc24_006B := (R.Valid <> 0) and (Y >= R.Top) and (X >= R.Left) and
                  (R.Top + R.Height >= Y) and (R.Left + R.Width >= X);
end;

{ ADDRESS: MAIN 0x00180409 }
function Proc24_0409(var R: TRec409): Boolean;
begin
  Proc24_0409 := (R.F1B > 0) and (R.F1B <= R.F1D);
end;

function RectContains(Y, X: SmallInt; var R: TRectState): Boolean;
begin
  RectContains := (R.Enabled <> 0) and (Y >= R.Top) and (X >= R.Left) and
                  (R.Top + R.Height >= Y) and (R.Left + R.Width >= X);
end;

function SpanAtLeast(R: PRecord24): Boolean;
begin
  SpanAtLeast := (R^.Field1D - R^.Field15) >= R^.Field1F;
end;

procedure Empty0; begin end;

procedure Empty2(a: LongInt); begin end;

procedure Empty4(a: LongInt; b: LongInt); begin end;

procedure EmptySevenA;
begin
end;

procedure EmptySevenB;
begin
end;

procedure EmptySevenC;
begin
end;

procedure EmptySevenD;
begin
end;

procedure EmptySevenE;
begin
end;

procedure EmptySevenF;
begin
end;

procedure EmptySevenG;
begin
end;

procedure Flag0(P: PByteArray);
begin
  P^[8] := 0;
end;

procedure Flag1(P: PByteArray);
begin
  P^[8] := 1;
end;

procedure ForwardToTarget(Second, First: Word; var P: TRecord24);
begin
  ForwardedTarget(Second, First, P);
end;

procedure ForwardedTarget(Second, First: Word; var P: TRecord24);
begin
end;

procedure GuardedCall(Second, First: Word; var P: TRecord24);
var M: TDispatchMethod;
begin
  if P.Flag = 0 then
  begin
    P.Dispatch.Call(Second, First, @P);
    M(Second, First, @P);
  end;
end;

procedure GuardedCallEx(Second, First: Word; var P: TRecord24);
begin
  if P.Flag = 0 then
    P.Dispatch.Slot6(Second, First, @P);
end;

procedure MakeNine(A, B, C: Word);
var P: PRecord24;
begin
  New(P);
end;

{ ADDRESS: MAIN 0x00180002 }
procedure Proc24_0002;
begin
end;

{ ADDRESS: MAIN 0x0018003e }
procedure Proc24_003E;
begin
end;

{ ADDRESS: MAIN 0x0018004d }
procedure Proc24_004D;
begin
end;

{ ADDRESS: MAIN 0x0018005c }
procedure Proc24_005C;
begin
end;

{ ADDRESS: MAIN 0x001800b3 }
procedure Proc24_00B3;
begin
end;

{ ADDRESS: MAIN 0x001800ba }
procedure Proc24_00BA;
begin
end;

{ ADDRESS: MAIN 0x001800e4 }
procedure Proc24_00E4;
begin
end;

{ ADDRESS: MAIN 0x00180116 }
procedure Proc24_0116;
begin
end;

{ ADDRESS: MAIN 0x0018011d }
procedure Proc24_011D;
begin
end;

{ ADDRESS: MAIN 0x00180181 }
procedure Proc24_0181;
begin
end;

{ ADDRESS: MAIN 0x001801dc }
procedure Proc24_01DC;
begin
end;

{ ADDRESS: MAIN 0x001802a2 }
procedure Proc24_02A2;
begin
end;

{ ADDRESS: MAIN 0x00180316 }
procedure Proc24_0316;
begin
end;

{ ADDRESS: MAIN 0x0018039d }
procedure Proc24_039D;
begin
end;

{ ADDRESS: MAIN 0x001803cc }
function Proc24_03CC(A0: Pointer): Boolean;
begin
end;

{ ADDRESS: MAIN 0x001803e7 }
function Proc24_03E7(A0: Pointer): Boolean;
begin
end;

{ ADDRESS: MAIN 0x00180431 }
function Proc24_0431(A0, A1: Word; A2: Byte; A3, A4: Word; var A5: TRectState24): Boolean;
begin
end;

{ ADDRESS: MAIN 0x001804ed }
procedure Proc24_04ED(A0: Pointer; var A1);
begin
end;

{ ADDRESS: MAIN 0x00180552 }
procedure Proc24_0552;
begin
end;

{ ADDRESS: MAIN 0x00180559 }
procedure Proc24_0559;
begin
end;

{ ADDRESS: MAIN 0x001805d6 }
procedure Proc24_05D6;
begin
end;

{ ADDRESS: MAIN 0x00180666 }
function Proc24_0666(A0, A1: Word; A2, A3: Pointer): Boolean;
begin
end;

{ ADDRESS: MAIN 0x001806c7 }
procedure Proc24_06C7;
begin
end;

{ ADDRESS: MAIN 0x001806fe }
procedure Proc24_06FE(A0: LongInt; A1: Pointer);
begin
end;

{ ADDRESS: MAIN 0x00180725 }
procedure Proc24_0725;
begin
end;

{ ADDRESS: MAIN 0x0018072c }
procedure Proc24_072C;
begin
end;

{ ADDRESS: MAIN 0x00180797 }
function Proc24_0797(A0, A1: Word; A2: Pointer; var A3): Byte;
begin
  Proc24_0797 := 0;
end;

{ ADDRESS: MAIN 0x001807fa }
procedure Proc24_07FA;
begin
end;

{ ADDRESS: MAIN 0x0018083b }
procedure Proc24_083B;
begin
end;

{ ADDRESS: MAIN 0x001808cb }
procedure Proc24_08CB;
begin
end;

{ ADDRESS: MAIN 0x00180958 }
procedure Proc24_0958;
begin
end;

{ ADDRESS: MAIN 0x00180998 }
procedure Proc24_0998;
begin
end;

{ ADDRESS: MAIN 0x001809eb }
procedure Proc24_09EB;
begin
end;

{ ADDRESS: MAIN 0x00180aec }
procedure Proc24_0AEC;
begin
end;

{ ADDRESS: MAIN 0x00180e21 }
procedure Proc24_0E21;
begin
end;

{ ADDRESS: MAIN 0x00180f10 }
procedure Proc24_0F10;
begin
end;

{ ADDRESS: MAIN 0x00180fe3 }
procedure Proc24_0FE3;
begin
end;

{ ADDRESS: MAIN 0x001813b0 }
procedure Proc24_13B0;
begin
end;

{ ADDRESS: MAIN 0x001815f7 }
procedure Proc24_15F7;
begin
end;

{ ADDRESS: MAIN 0x0018191b }
procedure Proc24_191B;
begin
end;

{ ADDRESS: MAIN 0x00181922 }
procedure Proc24_1922;
begin
end;

{ ADDRESS: MAIN 0x00181929 }
procedure Proc24_1929;
begin
end;

{ ADDRESS: MAIN 0x00181930 }
procedure Proc24_1930;
begin
end;

{ ADDRESS: MAIN 0x001819c0 }
procedure Proc24_19C0;
begin
end;

{ ADDRESS: MAIN 0x001819d7 }
function Proc24_19D7(A0, A1, A2, A3: Word; var A4; var A5): Boolean;
begin
end;

{ ADDRESS: MAIN 0x00181c1b }
function Proc24_1C1B(A0, A1: Word; A2: Pointer; var A3; var A4: TRectState24): Boolean;
begin
end;

{ ADDRESS: MAIN 0x00181cc1 }
procedure Proc24_1CC1(A0: ShortInt; var A1);
type
  TR1C = packed record
    Pad0: array[0..$10] of Byte;   { 0x00 .. 0x10 }
    S: string;                       { 0x11 .. 0x110, length byte at 0x11 }
    N111: Byte;                      { 0x111 }
    Cap112: Byte;                     { 0x112 }
  end;
  PR1C = ^TR1C;
var
  S: string;
begin
  if Length(PR1C(@A1)^.S) < PR1C(@A1)^.Cap112 then
  begin
    Inc(PR1C(@A1)^.N111);
    Far16E9(S, Char(A0));
    Far1716B(PR1C(@A1)^.S, $FF, PR1C(@A1)^.N111);
  end;
end;

procedure ResetAndCall(Second, First: Word; var P: TRecord24);
begin
  if P.Byte10F <> 0 then
  begin
    P.Byte10F := 0;
    P.Dispatch.Call(Second, First, @P);
  end;
end;

procedure SetFlagOne(var P: TRecord24);
begin
  P.Flag := 1;
end;

procedure SetFlagZero(var P: TRecord24);
begin
  P.Flag := 0;
end;

procedure TDispatch.Call(Second, First: Word; P: Pointer);
begin
end;

procedure TDispatch.Slot2(Second, First: Word; P: Pointer);
begin
end;

procedure TDispatch.Slot3(Second, First: Word; P: Pointer);
begin
end;

procedure TDispatch.Slot4(Second, First: Word; P: Pointer);
begin
end;

procedure TDispatch.Slot5(Second, First: Word; P: Pointer);
begin
end;

procedure TDispatch.Slot6(Second, First: Word; P: Pointer);
begin
end;

procedure Far16E9(A0: string; A1: Char);
begin
end;

procedure Far1716B(A0: string; A1, A2: Word);
begin
end;
procedure CallersInit24;
var
  HitRect24: TRectState24;
  PredRec409: TRec409;
  CallerRecord: TRecord24;
begin
  if Past1(@CallerRecord) then CallerRecord.Flag := 0;
  if HitTest(@CallerRecord, 1, 2) then CallerRecord.Flag := 0;
  if SpanAtLeast(@CallerRecord) then CallerRecord.Flag := 0;
  if HasRoom(@CallerRecord) then CallerRecord.Flag := 0;
  HitRect24.Valid := 0;
  if Proc24_006B(0, 0, HitRect24) then HitRect24.Valid := 1;
  if Proc24_0409(PredRec409) then HitRect24.Valid := 1;
  GuardedCall(0, 0, CallerRecord);
  GuardedCallEx(0, 0, CallerRecord);
  ResetAndCall(0, 0, CallerRecord);
  Proc24_1CC1(0, CallerRecord);
end;

begin
  CallersInit24;
end.
