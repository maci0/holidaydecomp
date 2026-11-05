unit HAUS;
{ Reconstructed scaffold, holiday.exe code segment 9 (16016 bytes).
  This is form unit for TFernseher; the original kept its forms inside the segment's own  unit
  (docs/tree.md).
  Evidence: form TFernseher, 5 components.
  `uses` comes from this segment's relocation records, the class members
  from RTTI and form streams. Known close-handler bodies are recovered;
  other method bodies remain stubs. }
{$F+}
interface

uses MPlayer, ExtCtrls, Graphics, Controls, Forms, Classes, SysUtils;

type
  PFar9 = ^TFar9;
  TFar9 = packed record
    Len: Byte;
    Data: array[0..255] of Byte;
  end;
  PChar9 = ^Char;
  PWord9 = ^Word;

  PPointer9 = ^Pointer;
  TArr9 = array[0..1023] of PChar;
  PArr9 = ^TArr9;
  { 9:0x0A54 and 9:0x1FFD share this record: 0x11c = 284 bytes, ten header Words at 0x00..0x12 with 0x00
    and 0x02 the $FFFF empty sentinel, a 255-byte field at 0x14, one pad byte at 0x113, then the eight
    tail bytes 0x114..0x11b, so 20 + 255 + 1 + 8 = 284. Initialisation is per caller and not per type.
    1FFD clears only 0x00..0x12 and FillChars 0x14 for 255 bytes, and never reads the array at all:
    every es:[di + ...] in that body is a store, and its four es:[di] reads are the VMT loads through
    0x6650, 0x666c, 0x6666 and 0x6658, not through 0x663a. 0A54 writes the tail at rel 0x1a0, 0x1a5,
    0x1cd, 0x1d2, 0x2e8, 0x2ed, 0x304 and 0x309 and reads it at rel 0x18b, 0x190, 0x1b8, 0x1bd, 0x344,
    0x355, 0x469, 0x47a, 0x58e, 0x59f, 0x6b3 and 0x6c4, so the split is safe: 0x113 is touched by
    neither body, and every tail read in 0A54 sees either loader zero or a value 0A54 itself stored on
    an earlier call, which is the state the original also has. The one ordering that does matter is the
    head: 0A54 tests 0x00 and 0x02 against $FFFF at rel 0x1e and 0x25, so 1FFD's clear must already have
    run. It does, because 1FFD's only caller is GFX 6:0x36E5 while 0A54's 46 sites sit in DATEN, AUKTION
    and SOUND. }
  TPair9 = array[0..1] of Word;
  TRec9 = packed record
    H00: TPair9;
    F04, F06: Integer;
    P08: Pointer;
    P0C: Pointer;
    F10, F12: Integer;
    Buf: array[0..254] of Byte;
    Pad113: Byte;
    P114: Pointer;
    P118: Pointer;
  end;
  PRec9 = ^TRec9;
  TRecArr9 = array[0..25] of TRec9;
  PRecArr9 = ^TRecArr9;
function FieldAddr9(P: PFar9): Pointer;
function Proc9_3942(Root: PChar; N: Word): PChar;
function Proc9_396E(Key: string; Root: PChar): LongInt;
function Proc9_39C2(Key: string; Root: PChar): LongInt;
procedure Proc9_077A;
procedure Proc9_0A54(A0, A1, A2, A3, A4, A5, A6, A7, A8, A9: Word);
procedure Proc9_12E9(A0: Word);
procedure Proc9_15E6(A0, A1: Word);
procedure Proc9_1794(A0, A1: Word);
procedure Proc9_1939(A0, A1: Word);
procedure Proc9_1A4B(A0, A1: Word);
procedure Proc9_1B3E;
procedure Stub15CD(var A);
procedure Stub625(var A, B);
procedure Stub6AC(var A);
procedure Stub70B(var A);
procedure StubA31(var A, B; N: Word);
procedure Stub8EF;
procedure Proc9_1FFD;
procedure Proc9_249D;
procedure Proc9_2524(A0, A1: Word);
procedure Proc9_25EA(A0, A1: Word);
procedure Proc9_26B0(A0, A1, A2, A3: Word);
procedure Proc9_26F6(A0, A1, A2, A3, A4, A5, A6: Word);
procedure Proc9_286B(A0, A1, A2, A3, A4, A5, A6, A7: Word);
procedure Proc9_287D(A0, A1, A2, A3, A4, A5, A6, A7: Word);
procedure Proc9_288F(A0, A1, A2, A3, A4, A5, A6, A7: Word);
procedure Proc9_2922(A0, A1, A2, A3, A4, A5, A6, A7: Word);
procedure Proc9_2955(A0, A1, A2, A3, A4, A5, A6: Word);
procedure Proc9_29E2(A0, A1, A2, A3: Word);
procedure Proc9_2A05;
procedure Proc9_2A19(A0, A1: Word);
procedure Proc9_2BAE(A0, A1: Word);
procedure Proc9_2D72(A0, A1: Word);
procedure Proc9_2DFF;
procedure Proc9_2ED8;
procedure Proc9_2FBD;
procedure Proc9_3098;
procedure Proc9_3172;
procedure Proc9_3256;
procedure Proc9_3339;
procedure Proc9_341C;
procedure Proc9_34EE;
procedure Proc9_358F;
procedure Proc9_36B2;
procedure Proc9_375E;
procedure Proc9_387C;
procedure Proc9_392D(A0, A1: Word);
procedure Proc9_3A30(Bucket: PArr9; Root: PChar);
procedure Proc9_3A96(A0, A1, A2, A3: Word);
procedure Proc9_3AE1(A0, A1, A2, A3: Word);
procedure Proc9_3B71(A0, A1, A2, A3, A4, A5: Word);
procedure Proc9_3BF1(A0, A1, A2, A3: Word);
procedure Proc9_3C4B(A0, A1, A2, A3, A4, A5: Word);
procedure Proc9_3CBA(A0, A1, A2, A3: Word);
procedure Proc9_3D32(A0, A1, A2, A3, A4, A5, A6, A7, A8: Word);
procedure Proc9_3DCA(A0, A1, A2, A3: Word);
procedure Proc9_3E2A(A0, A1, A2, A3, A4, A5: Word);
var
  W3D94: Word;
  Pad3D96: array[0..5] of Byte;
  W3D9C: Word;

type
  TFernseher = class(TForm)
    tvimage: TImage;
    tvleiimage: TImage;
    MediaPlayer1: TMediaPlayer;
    Panel1: TPanel;
    MediaPlayer2: TMediaPlayer;
  private
    { shortcut: opaque private storage; name fields as accesses are recovered. }
    UnrecoveredState: array[0..11] of Byte;
  published
    procedure FormShow(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure tvimageMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure tvimageMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure tvleiimageMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure tvleiimageMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure tvleiimageMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormHide(Sender: TObject);
  end;

implementation

uses THINTERG, TDUMMYFO, ABRECHNE, DATEN, BAUFEN, DATWIN, AUKTION, GFX, KOMPASS, HIGHSCOR,
  DARSTELL, SCHLUSS, GELD, SEG15, MENU, ANIM, SOUND, BAUEN, MAP, UEBERMAP, OBJEKT;

function FieldAddr9(P: PFar9): Pointer;
begin
  FieldAddr9 := @P^.Data[P^.Len];
end;

function Proc9_3942(Root: PChar; N: Word): PChar;
var
  At: PChar;
  K: Word;
begin
  Root := PChar(PPointer9(@Root[Ord(Root[1]) + $B])^);
  At := PChar(@Root[Ord(Root[1]) + $F]);
  for K := 1 to N do
    Inc(At, Ord(At[0]) + 1);
  Proc9_3942 := At;
end;

function Proc9_396E(Key: string; Root: PChar): LongInt;
var
  K, Count: Word;
  At: PChar;
begin
  Root := PChar(PPointer9(@Root[Ord(Root[1]) + $B])^);
  Count := PWord9(@Root[Ord(Root[1]) + 7])^;
  At := PChar(@Root[Ord(Root[1]) + $F]);
  for K := 0 to Count do
  begin
    if Ord(At[0]) = Ord(Key[0]) then
    begin
      Count := 0;
      for Count := 1 to Ord(Key[0]) do
        if UpCase(At[Count]) <> UpCase(Key[Count]) then
        begin
          Count := 0;
          Break;
        end;
      if Count <> 0 then
      begin
        Proc9_396E := K;
        Break;
      end;
    end;
    Inc(At, Ord(At[0]) + 1);
  end;
  Proc9_396E := -1;
end;

function Proc9_39C2(Key: string; Root: PChar): LongInt;
var
  K, Count: Word;
  P: PChar;
  Hit: PChar;
begin
  repeat
    Inc(Root, Ord(Root[1]) + 2);
    Count := PWord9(@Root[Ord(Root[$A]) + $B])^;
    P := PChar(@Root[Ord(Root[$A]) + $D]);
    Hit := nil;
    for K := 1 to Count do
    begin
      if (PWord9(@Key[0])^ and $DFFF) = (PWord9(@P[$18])^ and $DFFF) then
      begin
        Hit := P;
        Break;
      end;
      Inc(P, Ord(P[$18]) + $19);
    end;
    if Hit <> nil then
    begin
      for K := 1 to Ord(Key[0]) do
        if UpCase(PChar(@Hit[$19])[K]) <> UpCase(Key[K]) then
        begin
          Hit := nil;
          Break;
        end;
      if Hit <> nil then
      begin
        Proc9_39C2 := LongInt(PWord9(@Hit[$18])^);
        Exit;
      end;
    end;
    Root := PChar(PPointer9(@Root[4])^);
  until Root = nil;
  Proc9_39C2 := 0;
end;

{$F-}
procedure Proc9_01BD;
begin
end;
{$F+}

{$F-}
procedure Proc9_034F;
begin
end;
{$F+}

{$F-}
procedure Proc9_03C5;
begin
end;
{$F+}

procedure Proc9_077A;
begin
end;

{$F-}
procedure Proc9_087F;
begin
end;
{$F+}

procedure Proc9_0A54;
begin
end;

procedure Proc9_12E9;
begin
end;

{$F-}
procedure Proc9_1599;
begin
end;
{$F+}

procedure Proc9_15E6;
begin
end;

procedure Proc9_1794;
begin
end;

procedure Proc9_1939;
begin
end;

procedure Proc9_1A4B;
begin
end;

procedure Proc9_1B3E;
begin
end;

procedure Stub15CD(var A);
begin
end;

procedure Stub625(var A, B);
begin
end;

procedure Stub6AC(var A);
begin
end;

procedure Stub70B(var A);
begin
end;

procedure StubA31(var A, B; N: Word);
begin
end;

procedure Stub8EF;
begin
end;

procedure Proc9_1FFD;
var
  Unused128: array[0..127] of Byte;
  I, J: Word;
  BufC: array[0..255] of Byte;
  BufB: array[0..255] of Byte;
  BufA: array[0..255] of Byte;
  FEv: Integer absolute MAP.W54FE;
  FCv: Integer absolute MAP.W54FC;
  PT: array[0..2] of Pointer absolute MAP.G663E;
  O6650: TThing23 absolute MAP.G6650;
  O666C: TThing23 absolute MAP.G666C;
  O6666: TThing23 absolute MAP.G6666;
  O6658: TThing23 absolute MAP.G6658;
begin
  { phase 1: three plane allocations and the first line setup }
  for I := 0 to 2 do
    PT[I] := Far182($5a00);
  MAP.G6634 := Far182($1f);
  Stub15CD(MAP.AuktionTxt);
  Far164C('line 1');
  Stub625(BufB, BufA);
  Stub6AC(BufB);
  StubA31(BufB, BufC, $ff);
  Stub8EF;
  Far15E7(@BufC, MAP.G6634, $1e);

  { phase 2: fill the three planes, 90 rows of 255 bytes each }
  for I := 0 to $59 do
    for J := 0 to 2 do
    begin
      StubA31(BufB, BufC, $ff);
      Stub8EF;
      Far15E7(@BufC, Ptr(Seg(PT[J]), Ofs(PT[J]) + I * 256), $ff);
    end;

  { phase 3: name table, row stride $27, three $c-byte fields at 0, $d, $1a }
  Stub70B(BufB);
  MAP.G6630 := Far182($db6);
  MAP.G663A := Far182($1cd8);
  Stub15CD(MAP.G4DE2);
  Far164C('line 2');
  Stub625(BufB, BufA);
  Stub6AC(BufB);
  for I := 0 to $59 do
  begin
    StubA31(BufB, BufC, $ff);
    Stub8EF;
    Far15E7(@BufC, Ptr(Seg(MAP.G6630), Ofs(MAP.G6630) + I * $27), $c);
  end;

  Stub70B(BufB);
  Stub15CD(MAP.G4DE2);
  Far164C('line 3');
  Stub625(BufB, BufA);
  Stub6AC(BufB);
  for I := 0 to $59 do
  begin
    StubA31(BufB, BufC, $ff);
    Stub8EF;
    Far15E7(@BufC, Ptr(Seg(MAP.G6630), Ofs(MAP.G6630) + I * $27 + $d), $c);
  end;

  Stub70B(BufB);
  Stub15CD(MAP.G4DE2);
  Far164C('line 4');
  Stub625(BufB, BufA);
  Stub6AC(BufB);
  for I := 0 to $59 do
  begin
    StubA31(BufB, BufC, $ff);
    Stub8EF;
    Far15E7(@BufC, Ptr(Seg(MAP.G6630), Ofs(MAP.G6630) + I * $27 + $1a), $c);
  end;

  { phase 6: clear the 26 records of the shared array }
  Stub70B(BufB);
  for I := 0 to $19 do
  begin
    PRecArr9(MAP.G663A)^[I].H00[0] := $FFFF;
    PRecArr9(MAP.G663A)^[I].H00[1] := $FFFF;
    PRecArr9(MAP.G663A)^[I].F04 := 0;
    PRecArr9(MAP.G663A)^[I].F06 := 0;
    PRecArr9(MAP.G663A)^[I].P08 := nil;
    PRecArr9(MAP.G663A)^[I].P0C := nil;
    PRecArr9(MAP.G663A)^[I].F10 := 0;
    PRecArr9(MAP.G663A)^[I].F12 := 0;
    Far15E7(Ptr(CSeg, $1fc5), @PRecArr9(MAP.G663A)^[I].Buf, $ff);
  end;

  { phase 7: derived scalars }
  MAP.W664C := (FEv - $14e) div 2;
  MAP.W664A := (FCv - $160) div 2;
  MAP.B667C := 1;
  MAP.B6663 := 1;
  MAP.B6662 := 0;
  MAP.W6664 := 0;
  MAP.W6638 := 0;

  { phase 8: four virtual method constructions }
  O6650 := Far535A(1, Ptr($23b1, $83f));
  Stub15CD(MAP.G4F98);
  Far164C('line 5');
  O6650.Slot12;

  O666C := Far535A(1, Ptr($23ef, $83f));
  Stub15CD(MAP.G4F98);
  Far164C('line 6');
  O666C.Slot12;

  O6666 := Far535A(1, Ptr($242d, $83f));
  Stub15CD(MAP.G4F98);
  Far164C('line 7');
  O6666.Slot12;

  O6658 := Far535A(1, Ptr($246b, $83f));
  Stub15CD(MAP.G4F98);
  Far164C('line 8');
  O6658.Slot12;
end;

procedure Proc9_249D;
begin
end;

procedure Proc9_2524;
begin
end;

procedure Proc9_25EA;
begin
end;

procedure Proc9_26B0;
begin
end;

{$F-}
procedure Proc9_26B7;
begin
end;
{$F+}

procedure Proc9_26F6;
begin
end;

procedure Proc9_286B;
begin
end;

procedure Proc9_287D;
begin
end;

procedure Proc9_288F;
begin
end;

procedure Proc9_2922;
begin
end;

procedure Proc9_2955;
begin
end;

procedure Proc9_29E2;
begin
end;

procedure Proc9_2A05;
begin
end;

procedure Proc9_2A19;
begin
end;

procedure Proc9_2BAE;
begin
end;

procedure Proc9_2D72;
begin
end;

procedure Proc9_2DFF;
begin
end;

procedure Proc9_2ED8;
begin
end;

procedure Proc9_2FBD;
begin
end;

procedure Proc9_3098;
begin
end;

procedure Proc9_3172;
begin
end;

procedure Proc9_3256;
begin
end;

procedure Proc9_3339;
begin
end;

procedure Proc9_341C;
begin
end;

procedure Proc9_34EE;
begin
end;

procedure Proc9_358F;
begin
end;

procedure Proc9_36B2;
begin
end;

procedure Proc9_375E;
begin
end;

procedure Proc9_387C;
begin
end;

procedure Proc9_392D;
begin
end;

procedure Proc9_3A30(Bucket: PArr9; Root: PChar);
var
  K, Count, Idx: Word;
  Entry, Next: PChar;
begin
  FillChar(Bucket^, PWord9(@Root[Ord(Root[1]) + $A])^ * 4, 0);
  repeat
    Inc(Root, Ord(Root[1]) + 2);
    Next := PChar(PPointer9(@Root[4])^);
    Count := PWord9(@Root[Ord(Root[1]) + $B])^;
    Entry := PChar(@Root[Ord(Root[1]) + $D]);
    for K := 1 to Count do
    begin
      Idx := PWord9(@Entry[$16])^;
      if Bucket^[Idx] = nil then
        Bucket^[Idx] := Entry;
      Inc(Entry, Ord(Entry[$18]) + $19);
    end;
    Root := Next;
  until Root = nil;
end;

procedure Proc9_3A96;
begin
end;

procedure Proc9_3AE1;
begin
end;

procedure Proc9_3B71;
begin
end;

procedure Proc9_3BF1;
begin
end;

procedure Proc9_3C4B;
begin
end;

procedure Proc9_3CBA;
begin
end;

procedure Proc9_3D32;
begin
end;

procedure Proc9_3DCA;
begin
end;

procedure Proc9_3E2A;
begin
end;

procedure TFernseher.FormShow;
begin
end;

procedure TFernseher.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
end;

procedure TFernseher.tvimageMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
end;

procedure TFernseher.tvimageMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
end;

procedure TFernseher.tvleiimageMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
end;

procedure TFernseher.tvleiimageMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
end;

procedure TFernseher.tvleiimageMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
end;

procedure TFernseher.FormHide;
begin
  if MAP.B662C <> 0 then Proc9_034F;
  Proc20_254F;
  Proc20_2453(MAP.P6334);
end;
procedure CallersInit9;
var
  Buf9: TFar9;
  LookupTable: PChar;
  LookupAt: PChar;
  Bucket9: PArr9;
begin
  Buf9.Len := 0;
  if FieldAddr9(@Buf9) = nil then Buf9.Len := 1;

  LookupTable := nil;
  LookupAt := nil;
  if Proc9_39C2('A', LookupTable) <> 0 then Buf9.Len := 1;

  Proc9_3A30(@Bucket9, LookupAt);
  LookupAt := Proc9_3942(LookupAt, 1);
end;

begin
  CallersInit9;
end.
