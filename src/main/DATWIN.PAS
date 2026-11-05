unit DATWIN;
{ Reconstructed scaffold, holiday.exe code segment 4 (16212 bytes).
  This is unit holding TEndeform, THauptschirm; the original kept its forms inside the segment's
  own  unit (docs/tree.md).
  Evidence: form TEndeform (1 components), form THauptschirm (11 components).
  `uses` comes from this segment's relocation records, the class members
  from RTTI and form streams. Known close-handler bodies are recovered;
  other method bodies remain stubs. }
{$F+}
interface

uses ExtCtrls, Graphics, Controls, Forms, Classes;

type
  TFlagSet4 = set of 0..7;
  TInnerA = packed record
    Pad: array[0..35] of Byte;      { 0x00 .. 0x23 }
    W24: Integer;                   { 0x24 .. 0x25 }
  end;
  PInnerA = ^TInnerA;
  TInnerB = packed record
    Pad: array[0..33] of Byte;      { 0x00 .. 0x21 }
    W22: Integer;                   { 0x22 .. 0x23 }
  end;
  PInnerB = ^TInnerB;
  { What TState4.Ptr190 points at: only the word at +0x1c is read, by
    4:0x2e09 before its Proc6_0F19 and Proc6_0F53 calls; extent unknown. }
  TInner190 = packed record
    Pad: array[0..27] of Byte;      { 0x00 .. 0x1b }
    W1C: Word;                      { 0x1c .. 0x1d }
  end;
  PInner190 = ^TInner190;
  { What MAP.P6612 points at, read by 4:0x2e09 (Byte at +0x180) and by
    the mode-2 arm of that ladder; extent unknown, nothing allocated. }
  TRec6612 = packed record
    Pad: array[0..383] of Byte;     { 0x000 .. 0x17f }
    B180: Byte;                     { 0x180 }
  end;
  PRec6612 = ^TRec6612;
  { The dispatch key object behind 4:0x2e09's A2: only the first word is
    read, as the case selector; extent unknown. }
  TKey4 = packed record
    W0: Word;                       { 0x00 .. 0x01 }
  end;
  PKey4 = ^TKey4;  { What MAP.G723A points at. Only the far pointer at +0x18c is read,
    by 4:0x0cf7 before its Far22C6 call, so the object's own extent is
    not established and nothing here is allocated. }
  TThing18C = packed record
    Pad: array[0..0] of Byte;
  end;
  PThing18C = ^TThing18C;
  TObj18C = packed record
    Pad: array[0..395] of Byte;      { 0x00 .. 0x18b }
    F18C: PThing18C;                 { 0x18c .. 0x18f }
  end;
  PObj18C = ^TObj18C;
  { What MAP.P6532 points at, for the two Far123D callers at 4:0x24A0 and
    4:0x24B7: the far pointer at +0x190 is the second argument each pushes. }
  TRec6532 = packed record
    Pad: array[0..399] of Byte;      { 0x000 .. 0x18f }
    F190: Pointer;                   { 0x190 .. 0x193 }
  end;
  PTRec6532 = ^TRec6532;  { Four object references the free-four wrapper releases, then the record it sets. }
  TObj4 = packed record
    Pad0: array[0..423] of Byte;    { 0x000 .. 0x1a7 }
    Obj1A8, Obj1AC, Obj1B0, Obj1B4: TObject;  { 0x1a8 .. 0x1b7 }
  end;
  { The twenty-one BlockRead/BlockWrite field addresses of 4:0x2909 and 4:0x2b1d. }
  { Each pad lands on the offset the call site adds to the record base. }
  TState4 = packed record
    Pad0: array[0..270] of Byte;      { 0x000 .. 0x10e }
    B10F: Byte;                       { 0x10f }
    Pad110: array[0..119] of Byte;    { 0x110 .. 0x187 }
    Ptr188: PInnerA;                  { 0x188 .. 0x18b }
    Ptr18C: PInnerB;                  { 0x18c .. 0x18f }
    Ptr190: PInner190;               { 0x190 .. 0x193 }
    Pad194: array[0..7] of Byte;      { 0x194 .. 0x19b }
    Ptr19C: Pointer;                  { 0x19c .. 0x19f }
    Ptr1A0: Pointer;                  { 0x1a0 .. 0x1a3 }
    Ptr1A4: Pointer;                  { 0x1a4 .. 0x1a7 }
    Pad1A8: array[0..15] of Byte;     { 0x1a8 .. 0x1b7 }
    W1B8: Integer;                    { 0x1b8 .. 0x1b9 }
    W1BA: Integer;                    { 0x1ba .. 0x1bb }
    W1BC, W1BE, W1C0: Integer;        { 0x1bc .. 0x1c1 }
    W1C2, W1C4, W1C6: Integer;        { 0x1c2 .. 0x1c7 }
    L1C8: LongInt;                    { 0x1c8 .. 0x1cb }
    B1CC, B1CD, B1CE, B1CF: Byte;     { 0x1cc .. 0x1cf }
    B1D0, B1D1: Byte;                 { 0x1d0 .. 0x1d1 }
    L1D2: LongInt;                    { 0x1d2 .. 0x1d5 }
    W1D6, W1D8: Word;                 { 0x1d6 .. 0x1d9 }
    B1DA: Byte;                       { 0x1da }
    Pad1DB: array[0..277] of Byte;    { 0x1db .. 0x2f0 }
    Pad2F1: array[0..277] of Byte;    { 0x2f1 .. 0x406 }
    B407: Byte;                       { 0x407 }
    L408: LongInt;                    { 0x408 .. 0x40b }
    Pad40C: array[0..270] of Byte;    { 0x40c .. 0x51a }
    B51B: Byte;                       { 0x51b }
  end;
procedure Proc4_0456(var A0: TState4);
procedure Proc4_0480(A0, A1: Word);
procedure Proc4_049E(A0, A1: Word);
procedure Proc4_04B0(A0: Pointer);
procedure Proc4_04BC(A0, A1: Word);
procedure Proc4_050B(A0: Pointer);
procedure Proc4_051D(A0, A1: Pointer);
procedure Proc4_052E(A0, A1: Pointer);
procedure Proc4_0549(A0, A1, A2, A3: Word);
procedure Proc4_0550(A0: Pointer);
procedure Proc4_0558(A0, A1, A2, A3: Word);
procedure Proc4_055F(A0: Pointer);
procedure Proc4_0566(A0, A1: Pointer);
procedure Proc4_0577(A0, A1, A2, A3: Word);
procedure Proc4_0595(A0, A1, A2, A3: Word);
procedure Proc4_05A7(A0: Pointer);
procedure Proc4_067C(A0: Pointer);
procedure Proc4_0697(A0, A1: Word);
procedure Proc4_06F1(A0, A1: Word);
procedure Proc4_074D(A0, A1: Word);
procedure Proc4_0787(A0, A1, A2, A3: Word);
procedure Proc4_07DC(A0, A1: Word; A2: Pointer);
procedure Proc4_0A55(A0, A1, A2, A3, A4, A5: Word);
procedure Proc4_0B0F(A0, A1, A2: Word; var A3: TState4);
function Proc4_0B38(var A0: TState4): LongInt;
procedure Proc4_0BF4(var A0: TState4);
procedure Proc4_0C8B(A0: Pointer);
procedure Proc4_0CF7(A0: Integer; var A1: TState4);
procedure Proc4_0D92(A0, A1, A2, A3, A4, A5, A6, A7: Word);
procedure Proc4_0FA2(A0, A1: Word; A2: TFlagSet4; A3: Word; A4: Integer; var A5: TState4);
procedure Proc4_10B6(A0, A1, A2, A3, A4, A5, A6, A7: Word);
procedure Proc4_11DD(A0, A1, A2, A3, A4, A5: Word);
procedure Proc4_1297(A0, A1, A2: Word; var A3: TState4);
function Proc4_12C0(var A0: TState4): LongInt;
procedure Proc4_137C(var A0: TState4);
procedure Proc4_1413(A0: Pointer);
procedure Proc4_147F(A0: Integer; var A1: TState4);
procedure Proc4_151A(A0, A1, A2, A3, A4, A5, A6, A7: Word);
procedure Proc4_172A(A0, A1: Word; A2: TFlagSet4; A3: Integer; A4: Word; var A5: TState4);
procedure Proc4_181F(A0, A1, A2, A3, A4, A5, A6, A7: Word);
procedure Proc4_1946(A0, A1, A2, A3: Word);
procedure Proc4_1952(A0, A1, A2, A3, A4, A5, A6: Word);
procedure Proc4_1984(A0, A1, A2, A3, A4, A5, A6, A7: Word);
procedure Proc4_1AE6(A0, A1, A2, A3, A4, A5, A6: Word);
procedure Proc4_1B31(A0, A1, A2, A3, A4, A5, A6, A7: Word);
procedure Proc4_1B8E(A0, A1, A2, A3, A4, A5, A6, A7: Word);
procedure Proc4_1BD9(A0, A1, A2, A3, A4, A5, A6: Word);
procedure Proc4_1C58(A0, A1, A2, A3, A4, A5, A6, A7: Word);
procedure Proc4_1CE9(A0, A1: Word);
procedure Proc4_1DF3(A0, A1: Word);
procedure Proc4_1E4F(A0, A1: Word);
procedure Proc4_1E9B(A0, A1, A2, A3: Word);
procedure Far123D(A0: Word; var A1);
procedure Proc4_24A0;
procedure Proc4_24B7;
procedure Proc4_2501(A0, A1: Word);
procedure Proc4_283B(A0, A1: Word);
procedure Proc4_2866(A0, A1, A2, A3: Word);
procedure Proc4_28BF(var A0: TObj4; var A1: Byte; var A2: Byte);
procedure Proc4_2909(var A0: file; var A1: TState4);
procedure Proc4_2B1D(var A0: file; var A1: TState4);
procedure Proc4_2E09(A0: Pointer; A1: Pointer; A2: TShiftState; A3: Pointer);
procedure Proc4_3214(A0, A1, A2, A3, A4, A5: Word; var A6: TState4);
procedure Proc4_324C(A0, A1, A2, A3, A4, A5, A6, A7: Word);
procedure Proc4_3286(A0, A1, A2, A3, A4, A5, A6, A7: Word);
procedure Proc4_32C0(A0, A1, A2, A3, A4, A5, A6, A7: Word);
procedure Proc4_32FA(A0, A1, A2, A3, A4, A5, A6, A7: Word);
procedure Proc4_34CA(A0, A1, A2: Word);
procedure Proc4_3588(A0, A1, A2, A3, A4: Word);
procedure Proc4_3603(A0, A1, A2, A3, A4: Word);
procedure Proc4_367C(A0, A1, A2: Word);
procedure Proc4_36CE(A0, A1, A2: Word);
procedure Proc4_37DD(A0, A1, A2, A3, A4, A5, A6, A7: Word);
procedure Proc4_38D4(A0, A1, A2, A3, A4, A5, A6: Word);
procedure Proc4_395F(A0, A1, A2, A3, A4, A5, A6, A7: Word);
procedure Proc4_3AAD(A0, A1: Word);
procedure Proc4_3B5F(A0, A1, A2, A3: Word);
procedure Proc4_3D05(A0, A1, A2, A3: Word);
procedure Proc4_3D30(A0, A1, A2, A3, A4, A5, A6: Word);
procedure Proc4_3EA6;
procedure Proc4_3F02;
procedure Proc4_3F47(A0, A1: Word);
procedure Proc4_3F4E(A0, A1: Word);


type
  TEndeform = class(TForm)
    EndeImage: TImage;
  private
    { shortcut: opaque private storage; name fields as accesses are recovered. }
    UnrecoveredState: array[0..0] of Byte;
  published
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure EndeImageMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure EndeImageMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure EndeImageMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  end;
  THauptschirm = class(TForm)
    Ueberschriftbild: TImage;
    ButtonImage: TImage;
    Hauptbild: TImage;
    NSScrollbild: TImage;
    WOScrollbild: TImage;
    AnimationsTimer: TTimer;
    InfoImage: TImage;
    Statusimage: TImage;
    eckimage: TImage;
    CloseBild: TImage;
    Kleinbild: TImage;
  private
    { Observed private references; original field names and subclasses are unresolved. }
    CloseObjects: array[0..3] of TObject;
    procedure GlobalInfo;
  private
    { shortcut: opaque private storage; name fields as accesses are recovered. }
    UnrecoveredState: array[0..875] of Byte;
  published
    procedure InfoboxOKButtonClick;
    procedure InfoboxInselbuttonClick;
    procedure InselboxOkbuttonClick(Sender: TObject);
    procedure GlobalboxOkbuttonClick(Sender: TObject);
    procedure InfoboxGlobalbuttonClick(Sender: TObject);
    procedure CloseButtonDblClick;
    procedure MinimizeButtonClick(Sender: TObject);
    procedure NSScrollBildMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure NSScrollbildMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure NSScrollBildMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure WOScrollBildMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure WOScrollbildMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure WOScrollBildMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure ButtonImageClick(Sender: TObject);
    procedure ButtonImageMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure HauptbildMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure HauptbildMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure HauptbildMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure UeberschriftbildMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure UeberschriftbildMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure UeberschriftbildMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure AnimationsTimerTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure eckimageMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure CloseBildMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure CloseBildMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure KleinbildMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure KleinbildMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  end;

implementation

uses ABRECHNE, DATEN, BAUFEN, AUKTION, GFX, KOMPASS, HIGHSCOR, HAUS, DARSTELL, SCHLUSS, GELD,
  SEG15, MENU, ANIM, EREIGN, SOUND, MAP, UEBERMAP, SEG24, DataVal;

procedure Proc4_0456;
begin
  if A0.B10F <> 0 then
    Proc7_314F(MAP.G6620^)
  else
    Proc7_3243(MAP.G6620^);
end;

procedure Proc4_0480;
begin
end;

procedure Proc4_049E;
begin
end;

procedure Proc4_04B0;
begin
  Proc10_2700;
end;

procedure Proc4_04BC;
begin
end;

procedure Proc4_050B;
begin
end;

procedure Proc4_051D;
begin
  Proc4_050B(A1);
end;

procedure Proc4_052E;
begin
  Proc4_050B(A1);
  Proc4_0550(A1);
end;

procedure Proc4_0549;
begin
end;

procedure Proc4_0550;
var
  Spare550: LongInt;
begin
end;

procedure Proc4_0558;
begin
end;

procedure Proc4_055F;
begin
end;

procedure Proc4_0566;
begin
  Proc4_055F(A1);
end;

procedure Proc4_0577;
begin
end;

procedure Proc4_0595;
begin
end;

procedure Proc4_05A7;
begin
end;

procedure Proc4_067C;
begin
  Proc4_0C8B(A0);
  Proc4_1413(A0);
end;

procedure Proc4_0697;
begin
end;

procedure Proc4_06F1;
begin
end;

procedure Proc4_074D;
begin
end;

procedure Proc4_0787;
begin
end;

procedure Proc4_07DC;
begin
end;

procedure Proc4_0A55;
begin
end;

procedure Proc4_0B0F;
begin
  A3.W1BE := A0;
  A3.W1BC := A1;
  A3.W1C0 := A2;
  Proc4_0BF4(A3);
end;

function Proc4_0B38(var A0: TState4): LongInt;
var
  V1, V2, V3, C16, T, R: LongInt;
begin
  V1 := A0.W1BE;
  V2 := A0.W1BC;
  V3 := A0.W1C0;
  C16 := 16;
  T := A0.Ptr188^.W24 - $10 - $13;
  R := ((V3 - V1) * (T - C16) + (V2 - V1) * C16) div (V2 - V1);
  Result := R;
end;

procedure Proc4_0BF4;
begin
end;

procedure Proc4_0C8B;
begin
end;

procedure Proc4_0CF7;
var
  T, Diff: Integer;
begin
  T := A1.W1C0 + A0;
  if T < A1.W1BE then
    T := A1.W1BE
  else if T > A1.W1BC then
    T := A1.W1BC;
  Diff := T - A1.W1C0;
  Proc4_0C8B(@A1);
  A1.W1C0 := T;
  Proc4_0BF4(A1);
  Proc23_1485(UEBERMAP.POver23(MAP.G723A)^);
  Proc4_07DC(0, Diff, @A1);
  Proc23_1349(UEBERMAP.POver23(MAP.G723A)^);
  Far22C6(PObj18C(MAP.G723A)^.F18C^);
end;

procedure Proc4_0D92;
begin
end;

procedure Proc4_0FA2;
var
  L: LongInt;
begin
  if 3 in A2 then
    if A5.B1CD <> 0 then
      if A4 > $10 then
        if A5.Ptr188^.W24 - $10 > A4 then
        begin
          L := A4 - A5.W1BA;
          if L < 0 then
            L := 0
          else
          begin
            if A5.Ptr188^.W24 - $0e < L then
              L := A5.Ptr188^.W24 - $0e;
          end;
          Proc4_0CF7(Word(((A5.Ptr188^.W24 - $2f) div 2 +
            (L - A5.L1C8) * LongInt(A5.W1BC - A5.W1BE)) div
            (A5.Ptr188^.W24 - $30)), A5);
          A5.L1C8 := L;
        end;
end;

procedure Proc4_10B6;
begin
end;

procedure Proc4_11DD;
begin
end;

procedure Proc4_1297;
begin
  A3.W1C4 := A0;
  A3.W1C2 := A1;
  A3.W1C6 := A2;
  Proc4_137C(A3);
end;

function Proc4_12C0(var A0: TState4): LongInt;
var
  V1, V2, V3, C16, T, R: LongInt;
begin
  V1 := A0.W1C4;
  V2 := A0.W1C2;
  V3 := A0.W1C6;
  C16 := 16;
  T := A0.Ptr18C^.W22 - $10 - $13;
  R := ((V3 - V1) * (T - C16) + (V2 - V1) * C16) div (V2 - V1);
  Result := R;
end;

procedure Proc4_137C;
begin
end;

procedure Proc4_1413;
begin
end;

procedure Proc4_147F;
var
  T, Diff: Integer;
begin
  T := A1.W1C6 + A0;
  if T < A1.W1C4 then
    T := A1.W1C4
  else if T > A1.W1C2 then
    T := A1.W1C2;
  Diff := T - A1.W1C6;
  Proc4_1413(@A1);
  A1.W1C6 := T;
  Proc4_137C(A1);
  Proc23_1485(UEBERMAP.POver23(MAP.G723A)^);
  Proc4_07DC(Diff, 0, @A1);
  Proc23_1349(UEBERMAP.POver23(MAP.G723A)^);
  Far22C6(PObj18C(MAP.G723A)^.F18C^);
end;

procedure Proc4_151A;
begin
end;

procedure Proc4_172A;
var
  L: Integer;
  Spare: Word;
begin
  if 3 in A2 then
    if A5.B1CC <> 0 then
      if A3 > $10 then
        if A5.Ptr18C^.W22 - $10 > A3 then
        begin
          L := A3 - A5.W1B8;
          if L < 0 then
            L := 0
          else
          begin
            if A5.Ptr18C^.W22 - $0e < L then
              L := A5.Ptr18C^.W22 - $0e;
          end;
          Proc4_147F(Word(((A5.Ptr18C^.W22 - $2f) div 2 +
            (LongInt(L) - A5.L1C8) * LongInt(A5.W1C2 - A5.W1C4)) div
            (A5.Ptr18C^.W22 - $30)), A5);
          A5.L1C8 := L;
        end;
end;

procedure Proc4_181F;
begin
end;

procedure Proc4_1946;
begin
  Proc2_2C20;
end;

procedure Proc4_1952;
begin
end;

procedure Proc4_1984;
begin
end;

procedure Proc4_1AE6;
begin
end;

procedure Proc4_1B31;
begin
end;

procedure Proc4_1B8E;
begin
end;

procedure Proc4_1BD9;
begin
end;

procedure Proc4_1C58;
begin
end;

{$F-}
procedure Proc4_1C79;
begin
end;
{$F+}

procedure Proc4_1CE9;
begin
end;

procedure Proc4_1DF3;
begin
end;

procedure Proc4_1E4F;
begin
end;

procedure Proc4_1E9B;
begin
end;

procedure Far123D(A0: Word; var A1);
begin
end;

procedure Proc4_24A0;
begin
  Far123D(0, PObj18C(PTRec6532(P6532)^.F190)^);
end;

procedure Proc4_24B7;
begin
  Far123D(1, PObj18C(PTRec6532(P6532)^.F190)^);
end;

procedure Proc4_2501;
begin
end;

procedure Proc4_283B;
begin
end;

procedure Proc4_2866;
begin
end;

procedure Proc4_28BF;
begin
  A0.Obj1A8.Free;
  A0.Obj1AC.Free;
  A0.Obj1B0.Free;
  A0.Obj1B4.Free;
  A1 := 2;
end;

procedure Proc4_2909;
begin
  BlockWrite(A0, A1.L408, 4);
  BlockWrite(A0, A1.W1B8, 2);
  BlockWrite(A0, A1.W1BA, 2);
  BlockWrite(A0, A1.W1BC, 2);
  BlockWrite(A0, A1.W1BE, 2);
  BlockWrite(A0, A1.W1C0, 2);
  BlockWrite(A0, A1.W1C2, 2);
  BlockWrite(A0, A1.W1C4, 2);
  BlockWrite(A0, A1.W1C6, 2);
  BlockWrite(A0, A1.L1C8, 4);
  BlockWrite(A0, A1.B1CC, 1);
  BlockWrite(A0, A1.B1CD, 1);
  BlockWrite(A0, A1.B1CE, 1);
  BlockWrite(A0, A1.B1CF, 1);
  BlockWrite(A0, A1.B1D0, 1);
  BlockWrite(A0, A1.B1D1, 1);
  BlockWrite(A0, A1.L1D2, 4);
  BlockWrite(A0, A1.W1D6, 2);
  BlockWrite(A0, A1.W1D8, 2);
  BlockWrite(A0, A1.B1DA, 1);
  BlockWrite(A0, A1.B51B, 1);
end;

procedure Proc4_2B1D;
begin
  BlockRead(A0, A1.L408, 4);
  BlockRead(A0, A1.W1B8, 2);
  BlockRead(A0, A1.W1BA, 2);
  BlockRead(A0, A1.W1BC, 2);
  BlockRead(A0, A1.W1BE, 2);
  BlockRead(A0, A1.W1C0, 2);
  BlockRead(A0, A1.W1C2, 2);
  BlockRead(A0, A1.W1C4, 2);
  BlockRead(A0, A1.W1C6, 2);
  BlockRead(A0, A1.L1C8, 4);
  BlockRead(A0, A1.B1CC, 1);
  BlockRead(A0, A1.B1CD, 1);
  BlockRead(A0, A1.B1CE, 1);
  BlockRead(A0, A1.B1CF, 1);
  BlockRead(A0, A1.B1D0, 1);
  BlockRead(A0, A1.B1D1, 1);
  BlockRead(A0, A1.L1D2, 4);
  BlockRead(A0, A1.W1D6, 2);
  BlockRead(A0, A1.W1D8, 2);
  BlockRead(A0, A1.B1DA, 1);
  BlockRead(A0, A1.B51B, 1);
end;

{$F-}
procedure Proc4_2D31;
begin
end;
{$F+}

{$F-}
procedure Proc4_2D4C;
begin
end;
{$F+}

{$F-}
procedure Proc4_2DAA;
begin
end;
{$F+}

procedure Proc4_2E09;
begin
end;

procedure Proc4_3214;
begin
  if Proc24_0797(A4, A5, A6.Ptr19C, A6.Pad40C) <> 0 then
    Far22C6(A6.Ptr19C^);
end;

procedure Proc4_324C;
begin
end;

procedure Proc4_3286;
begin
end;

procedure Proc4_32C0;
begin
end;

procedure Proc4_32FA;
begin
end;

{$F-}
procedure Proc4_347D;
begin
end;
{$F+}

procedure Proc4_34CA;
begin
end;

procedure Proc4_3588;
begin
end;

procedure Proc4_3603;
begin
end;

procedure Proc4_367C;
begin
end;

procedure Proc4_36CE;
begin
end;

procedure Proc4_37DD;
begin
end;

procedure Proc4_38D4;
begin
end;

procedure Proc4_395F;
begin
end;

procedure Proc4_3AAD;
begin
end;

procedure Proc4_3B5F;
begin
end;

procedure Proc4_3D05;
begin
end;

procedure Proc4_3D30;
begin
end;

{$F-}
procedure Proc4_3DC4;
begin
end;
{$F+}

procedure Proc4_3EA6;
begin
end;

procedure Proc4_3F02;
begin
end;

procedure Proc4_3F47;
begin
end;

procedure Proc4_3F4E;
begin
end;

procedure TEndeform.FormShow;
begin
end;

procedure TEndeform.FormHide;
begin
end;

procedure TEndeform.EndeImageMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
end;

procedure TEndeform.EndeImageMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
end;

procedure TEndeform.EndeImageMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
end;

procedure TEndeform.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
end;

procedure THauptschirm.InfoboxOKButtonClick;
begin
end;

procedure THauptschirm.InfoboxInselbuttonClick;
begin
end;

procedure THauptschirm.InselboxOkbuttonClick(Sender: TObject);
begin
end;

procedure THauptschirm.GlobalboxOkbuttonClick(Sender: TObject);
begin
end;

procedure THauptschirm.InfoboxGlobalbuttonClick(Sender: TObject);
begin
  GlobalInfo;
end;

procedure THauptschirm.CloseButtonDblClick;
begin
end;

procedure THauptschirm.MinimizeButtonClick(Sender: TObject);
begin
  Application.Minimize;
end;

procedure THauptschirm.NSScrollBildMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
end;

procedure THauptschirm.NSScrollbildMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
end;

procedure THauptschirm.NSScrollBildMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
end;

procedure THauptschirm.WOScrollBildMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
end;

procedure THauptschirm.WOScrollbildMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
end;

procedure THauptschirm.WOScrollBildMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
end;

procedure THauptschirm.ButtonImageClick(Sender: TObject);
begin
end;

procedure THauptschirm.ButtonImageMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
end;

procedure THauptschirm.HauptbildMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
end;

procedure THauptschirm.HauptbildMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
end;

procedure THauptschirm.HauptbildMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
end;

procedure THauptschirm.UeberschriftbildMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
end;

procedure THauptschirm.UeberschriftbildMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
end;

procedure THauptschirm.UeberschriftbildMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
end;

procedure THauptschirm.AnimationsTimerTimer(Sender: TObject);
begin
end;

procedure THauptschirm.FormShow;
begin
end;

procedure THauptschirm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  CloseObjects[0].Free;
  CloseObjects[1].Free;
  CloseObjects[2].Free;
  CloseObjects[3].Free;
  Action := caFree;
end;

procedure THauptschirm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
end;

procedure THauptschirm.eckimageMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
end;

procedure THauptschirm.CloseBildMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
end;

procedure THauptschirm.CloseBildMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
end;

procedure THauptschirm.KleinbildMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
end;

procedure THauptschirm.KleinbildMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
end;

procedure THauptschirm.GlobalInfo;
begin
end;
procedure CallersInit4;
var
  SaveFile4: file;
  SaveB4: Byte;
  SaveState4: TState4;
  SaveObj4: TObj4;
  R0B38, R12C0: LongInt;
begin
  Proc4_2909(SaveFile4, SaveState4);
  Proc4_2B1D(SaveFile4, SaveState4);
  Proc4_0B0F(0, 0, 0, SaveState4);
  Proc4_1297(0, 0, 0, SaveState4);
  Proc4_28BF(SaveObj4, SaveB4, SaveB4);
  Proc4_04B0(nil);
  Proc4_051D(nil, nil);
  Proc4_052E(nil, nil);
  Proc4_0566(nil, nil);
  Proc4_067C(nil);
  Proc4_1946(0, 0, 0, 0);
  Proc4_0549(0, 0, 0, 0);
  Proc4_0558(0, 0, 0, 0);
  Proc4_3F47(0, 0);
  Proc4_3F4E(0, 0);
  R0B38 := Proc4_0B38(SaveState4);
  R12C0 := Proc4_12C0(SaveState4);
  Proc4_0FA2(0, 0, [], 0, 0, SaveState4);
  Proc4_172A(0, 0, [], 0, 0, SaveState4);
  Proc4_3214(0, 0, 0, 0, 0, 0, SaveState4);
  Proc4_0456(SaveState4);
  Proc4_24A0;
  Proc4_24B7;
end;

begin
  CallersInit4;
end.
