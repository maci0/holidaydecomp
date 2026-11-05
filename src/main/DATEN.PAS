unit DATEN;
{ Reconstructed scaffold, holiday.exe code segment 2 (16195 bytes).
  This is unit; the original kept its forms inside the segment's own  unit (docs/tree.md).
  Evidence: MoDatyp/Namen/ereignis/holiday.mid, font tables.
  `uses` comes from this segment's relocation records, the class members
  from RTTI and form streams. Recovered free bodies are listed in the
  implementation; the other bodies are not recovered. }
{$F+}
interface

uses MPlayer, Controls, Forms, SysUtils;

type
  TRow3 = packed record
    Pair: LongInt;
    Cells: array[0..9] of LongInt;
  end;
  TBoard2 = packed record
    Head: LongInt;
    Mid: array[0..9] of LongInt;
    Rows: array[0..2] of TRow3;
    Tail: array[3..9] of LongInt;
  end;
  PBoard2 = ^TBoard2;
  PWord2 = ^Word;
function Proc2_1D62(N: LongInt): LongInt;
function Proc2_1E05(N: LongInt): LongInt;
procedure Kick2_2;
procedure Proc2_0414;
procedure Proc2_064A;
procedure Proc2_0765;
procedure Proc2_0B02(A0, A1: Word);
procedure Proc2_0D4C(A0, A1: Word);
procedure Proc2_0F96;
procedure Proc2_0FAA(A0: Word);
procedure Proc2_1129(A0, A1: Word);
procedure Proc2_11CD(A0, A1, A2: Word);
procedure Proc2_122F(A0, A1: Word);
procedure Proc2_129E;
procedure Proc2_1432(A0, A1, A2, A3: Word);
procedure Proc2_14C1(A0, A1, A2, A3, A4, A5: Word);
procedure Proc2_14F7(A0, A1, A2, A3, A4, A5: Word);
procedure Proc2_152D(A0, A1, A2, A3: Word);
procedure Proc2_1572(A0, A1, A2, A3: Word);
procedure Proc2_15D2(A0, A1: Word);
procedure Proc2_15EA(A0, A1, A2, A3: Word);
procedure Proc2_169D(A0, A1: Word);
procedure Proc2_16B5(A0, A1, A2, A3: Word);
procedure Proc2_1715(A0, A1: Word);
procedure Proc2_172F(A0, A1, A2, A3: Word);
procedure Proc2_17F0(A0, A1: Word);
procedure Proc2_1808(A0, A1: Word);
procedure Proc2_1820(A0, A1: Word);
procedure Proc2_1838(A0: Pointer; var A1);
procedure Proc2_1919(A0, A1: Word);
procedure Proc2_1931(A0, A1, A2: Word);
procedure Proc2_19F1(A0, A1, A2: Word);
procedure Proc2_1AE2(A0, A1, A2: Word);
function Proc2_1C86(A0: LongInt): LongInt;
function Proc2_1F8F(A0, A1, A2, A3, A4: SmallInt; P1, P2: PWord2): Word;
function Proc2_20E0(A0, A1, A2, A3, A4: SmallInt; P1, P2: PWord2): Word;
procedure Proc2_2225(A0, A1, A2, A3: Word);
procedure Proc2_23D6(P: PBoard2);
procedure Proc2_2493(A0: Word);
procedure Proc2_254D(A0: Word);
procedure Proc2_25DC;
procedure Proc2_26EA;
procedure Proc2_26FA;
procedure Proc2_2820;
procedure Proc2_2970(A0: Word);
procedure Proc2_29CC;
procedure Proc2_2A0C;
procedure Proc2_2A5A;
procedure Proc2_2AC7(A0: ShortInt);
procedure Proc2_2ADE(A0: ShortInt);
procedure Proc2_2AF5;
procedure Proc2_2B3B;
procedure Proc2_2B60;
procedure Proc2_2BC4(A0: Byte);
procedure Proc2_2C20;
procedure Proc2_2C8B;
procedure Proc2_2FA9;
procedure Proc2_2FCE(A0, A1: Word);
procedure Proc2_2FEA(A0, A1: Word);
procedure Proc2_3006(A0: Word; A1, A2, A3, A4: LongInt; A5, A6: Word);
procedure Proc2_3084;
procedure Proc2_36F8(A0, A1: Word);
procedure Proc2_3AB4;
procedure Proc2_3E75;
procedure Proc2_3E8A(A0, A1: Word);
procedure Proc2_3EE7(A0, A1: Word);
procedure Refresh2_2;
procedure Stub2B5A;
procedure Stub2CB6;
procedure Stub2E9F;
procedure StubFFFF74;


implementation

uses THINTERG, TDUMMYFO, ABRECHNE, BAUFEN, DATWIN, AUKTION, GFX, KOMPASS, HIGHSCOR, HAUS, DARSTELL,
  START, OPTION, SCHLUSS, GELD, SEG15, MENU, ANIM, SOUND, MAP, UEBERMAP, SEG24;

function Proc2_1D62(N: LongInt): LongInt;
begin
  if N < 80 then
    Proc2_1D62 := N + 4
  else if N < 200 then
    Proc2_1D62 := N + 8
  else if N < 400 then
    Proc2_1D62 := N + 20
  else if N <= 1560 then
    Proc2_1D62 := N + 40
  else
    Proc2_1D62 := 1600;
end;

function Proc2_1E05(N: LongInt): LongInt;
begin
  if N > 400 then
    Proc2_1E05 := N - 40
  else if N > 200 then
    Proc2_1E05 := N - 20
  else if N > 80 then
    Proc2_1E05 := N - 8
  else if N >= 4 then
    Proc2_1E05 := N - 4
  else
    Proc2_1E05 := 0;
end;

procedure Kick2_2;
begin
  StubFFFF74;
  Stub2B5A;
end;

{$F-}
procedure Proc2_000E;
begin
end;
{$F+}

procedure Proc2_0414;
begin
end;

procedure Proc2_064A;
begin
end;

procedure Proc2_0765;
begin
end;

{$F-}
procedure Proc2_0799;
begin
end;
{$F+}

{$F-}
procedure Proc2_08D7;
begin
end;
{$F+}

procedure Proc2_0B02;
begin
end;

procedure Proc2_0D4C;
begin
end;

procedure Proc2_0F96;
begin
end;

procedure Proc2_0FAA;
begin
end;

procedure Proc2_1129;
begin
end;

procedure Proc2_11CD;
begin
end;

procedure Proc2_122F;
begin
end;

procedure Proc2_129E;
begin
end;

procedure Proc2_1432;
begin
end;

procedure Proc2_14C1;
begin
end;

procedure Proc2_14F7;
begin
end;

procedure Proc2_152D;
begin
end;

procedure Proc2_1572;
begin
end;

procedure Proc2_15D2;
begin
end;

procedure Proc2_15EA;
begin
end;

procedure Proc2_169D;
begin
end;

procedure Proc2_16B5;
begin
end;

procedure Proc2_1715;
begin
end;

procedure Proc2_172F;
begin
end;

procedure Proc2_17F0;
begin
end;

procedure Proc2_1808;
begin
end;

procedure Proc2_1820;
begin
end;

procedure Proc2_1838(A0: Pointer; var A1);
type
  { One element is enough: the array only exists to make D1 scale by 256, which
    is the size of a string in a record. It starts at 1 so that indexing it
    yields base + (Idx-1)*256 the way the original computes it, shl 8 then an
    add of $FF00, rather than a dec before the shift. }
  TStrVec = array[1..1] of string;
  PStrVec = ^TStrVec;
  TRec1838 = packed record
    F00, F02, F04: Word;
    Pad06: array[0..8] of Byte;
    F0F, F11, F13: Word;
    F15: Integer;
    F17: Pointer;
    F1B: Integer;
    F1D, F1F: Integer;
  end;
  PRec1838 = ^TRec1838;
var
  Idx: Integer;
  G: Word;
begin
  Proc24_04ED(A0, A1);
  G := 0;
  for Idx := PRec1838(@A1)^.F1F to
            Integer(Proc6_0F53(LongInt(PRec1838(@A1)^.F1F + PRec1838(@A1)^.F15 - 1),
                               LongInt(PRec1838(@A1)^.F1D))) do
  begin
    if Idx = PRec1838(@A1)^.F1B then
      Proc6_23D3(A0, PRec1838(@A1)^.F11, PRec1838(@A1)^.F02,
                 G * PRec1838(@A1)^.F13 + PRec1838(@A1)^.F00,
                 PRec1838(@A1)^.F04, 0, 1, PStrVec(PRec1838(@A1)^.F17)^[Idx])
    else
      Proc6_23D3(A0, PRec1838(@A1)^.F0F, PRec1838(@A1)^.F02,
                 G * PRec1838(@A1)^.F13 + PRec1838(@A1)^.F00,
                 PRec1838(@A1)^.F04, 0, 1, PStrVec(PRec1838(@A1)^.F17)^[Idx]);
    Inc(G);
  end;
end;

procedure Proc2_1919;
begin
end;

procedure Proc2_1931;
begin
end;

procedure Proc2_19F1;
begin
end;

procedure Proc2_1AE2;
begin
end;

function Proc2_1C86(A0: LongInt): LongInt;
begin
  if A0 > 163840 then
    Proc2_1C86 := A0 - 40960
  else if A0 > 40960 then
    Proc2_1C86 := A0 - 10240
  else if A0 > 10240 then
    Proc2_1C86 := A0 - 2560
  else if A0 > 2560 then
    Proc2_1C86 := A0 - 640
  else if A0 > 640 then
    Proc2_1C86 := A0 - 160
  else
    Proc2_1C86 := Proc6_0F19(0, A0 - 40);
end;

{$F-}
function Proc2_1EA5(A0, A1: Word): Boolean;
begin
  Proc2_1EA5 := False;
end;
{$F+}

{$F-}
function Proc2_1EFA(A0, A1, A2: Word): Boolean;
begin
  Proc2_1EFA := (Proc6_16A2(A0, A1, A2) <> 0) and Proc2_1EA5(A1, A2);
end;
{$F+}

{$F-}
function Proc2_1F2D(A0, A1: Word): Boolean;
begin
  Proc2_1F2D := False;
end;
{$F+}

function Proc2_1F8F(A0, A1, A2, A3, A4: SmallInt; P1, P2: PWord2): Word;
var
  T, U, V, I: SmallInt;
  Done: Byte;
begin
  T := Proc6_1E62(A1, A2);
  Done := 0;
  I := 1;
  while (Done = 0) and (I <= A0) do
  begin
    U := A1 - I;
    while (Done = 0) and (A3 + I >= U) do
    begin
      if Done = 0 then
      begin
        V := A2 - I;
        if Proc2_1EFA(T, U, V) then
        begin
          Done := 1;
          Proc2_1F8F := I;
        end;
      end;
      if Done = 0 then
      begin
        V := A4 + I;
        if Proc2_1EFA(T, U, V) then
        begin
          Done := 1;
          Proc2_1F8F := I;
        end;
      end;
      if Done = 0 then
        Inc(U);
    end;
    if Done = 0 then
      V := A2 - I + 1;
    while (Done = 0) and (A4 + I - 1 >= V) do
    begin
      if Done = 0 then
      begin
        U := A1 - I;
        if Proc2_1EFA(T, U, V) then
        begin
          Done := 1;
          Proc2_1F8F := I;
        end;
      end;
      if Done = 0 then
      begin
        U := A3 + I;
        if Proc2_1EFA(T, U, V) then
        begin
          Done := 1;
          Proc2_1F8F := I;
        end;
      end;
      if Done = 0 then
        Inc(V);
      end;
    Inc(I);
  end;
  if Done = 0 then
    Proc2_1F8F := $FFFF
  else
  begin
    P1^ := U;
    P2^ := V;
  end;
end;

function Proc2_20E0(A0, A1, A2, A3, A4: SmallInt; P1, P2: PWord2): Word;
var
  T, U, V, I: SmallInt;
  Done: Byte;
begin
  T := Proc6_1E62(A1, A2);
  Done := 0;
  I := 1;
  while (Done = 0) and (I <= A0) do
  begin
    U := A1 - I;
    while (Done = 0) and (A3 + I >= U) do
    begin
      if Done = 0 then
      begin
        V := A2 - I;
        if Proc2_1F2D(U, V) then
        begin
          Done := 1;
          Proc2_20E0 := I;
        end;
      end;
      if Done = 0 then
      begin
        V := A4 + I;
        if Proc2_1F2D(U, V) then
        begin
          Done := 1;
          Proc2_20E0 := I;
        end;
      end;
      if Done = 0 then
        Inc(U);
    end;
    if Done = 0 then
    begin
      V := A2 - I + 1;
      while (Done = 0) and (A4 + I - 1 >= V) do
      begin
        if Done = 0 then
        begin
          U := A1 - I;
          if Proc2_1F2D(U, V) then
          begin
            Done := 1;
            Proc2_20E0 := I;
          end;
        end;
        if Done = 0 then
        begin
          U := A3 + I;
          if Proc2_1F2D(U, V) then
          begin
            Done := 1;
            Proc2_20E0 := I;
          end;
        end;
        if Done = 0 then
          Inc(V);
      end;
    end;
    Inc(I);
  end;
  if Done = 0 then
    Proc2_20E0 := $FFFF
  else
  begin
    P1^ := U;
    P2^ := V;
  end;
end;

procedure Proc2_2225;
begin
end;

procedure Proc2_23D6(P: PBoard2);
var
  I: Byte;
  J: ShortInt;
begin
  with P^ do
  begin
    Head := 0;
    for I := 0 to 9 do
      Mid[I] := 0;
    for J := 0 to 2 do
    begin
      Rows[J].Pair := 0;
      for I := 0 to 9 do
        Rows[J].Cells[I] := 0;
    end;
    for J := 3 to 9 do
      Tail[J] := 0;
  end;
end;

procedure Proc2_2493;
begin
end;

procedure Proc2_254D;
begin
end;

procedure Proc2_25DC;
begin
end;

procedure Proc2_26EA;
begin
end;

procedure Proc2_26FA;
begin
end;

procedure Proc2_2820;
begin
end;

procedure Proc2_2970;
begin
end;

procedure Proc2_29CC;
begin
end;

procedure Proc2_2A0C;
begin
end;

procedure Proc2_2A5A;
begin
end;

procedure Proc2_2AC7;
begin
  MAP.Pad651A[A0] := 1;
  Proc2_2AF5;
end;

procedure Proc2_2ADE;
begin
  MAP.Pad651A[A0] := 0;
  Proc2_2AF5;
end;

procedure Proc2_2AF5;
var I: ShortInt;
begin
  for I := 0 to $16 do
    if MAP.Pad651A[I] <> 0 then DARSTELL.Proc10_0002(I) else DARSTELL.Proc10_0074(I);
  DATWIN.THauptschirm(MAP.P6532).ButtonImage.Refresh;
end;

procedure Proc2_2B3B;
begin
end;

{$F-}
procedure Proc2_2B4C;
begin
end;
{$F+}

procedure Proc2_2B60;
begin
end;

procedure Proc2_2BC4;
begin
end;

{$F-}
procedure Proc2_2BE1;
begin
end;
{$F+}

procedure Proc2_2C20;
begin
end;

procedure Proc2_2C8B;
begin
end;

procedure Proc2_2FA9;
begin
end;

procedure Proc2_2FCE;
begin
end;

procedure Proc2_2FEA;
begin
end;

procedure Proc2_3006(A0: Word; A1, A2, A3, A4: LongInt; A5, A6: Word);
begin
end;

procedure Proc2_3084;
begin
end;

procedure Proc2_36F8;
begin
end;

procedure Proc2_3AB4;
begin
end;

procedure Proc2_3E75;
begin
end;

procedure Proc2_3E8A;
begin
end;

procedure Proc2_3EE7;
begin
end;

procedure Refresh2_2;
begin
  Stub2E9F;
  Stub2CB6;
end;

procedure Stub2B5A;
begin
end;

procedure Stub2CB6;
begin
end;

procedure Stub2E9F;
begin
end;

procedure StubFFFF74;
begin
end;
procedure CallersInit2;
var
  ProbeBoard: TBoard2;
  ProbeFee: LongInt;
  ProbePrice: LongInt;
  ProbeWalk: Word;
begin
  Proc2_23D6(@ProbeBoard);

  ProbeFee := Proc2_1E05(500);

  ProbePrice := Proc2_1D62(100);

  ProbePrice := Proc2_1C86(1);

  ProbeWalk := Proc2_20E0(1, 2, 3, 4, 5, PWord2(@ProbeBoard.Head), PWord2(@ProbeBoard.Mid[0]));

  if Proc2_1EFA(1, 2, 3) then;

  ProbeWalk := Proc2_1F8F(1, 2, 3, 4, 5, PWord2(@ProbeBoard.Head), PWord2(@ProbeBoard.Mid[0]));

  if ProbeWalk = $FFFF then Proc2_1838(nil, ProbeBoard);
end;

begin
  CallersInit2;
end.
