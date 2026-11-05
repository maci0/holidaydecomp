unit ANIM;
{ Reconstructed scaffold, holiday.exe code segment 17 (35517 bytes).
  This is unit; the original kept its forms inside the segment's own  unit (docs/tree.md).
  Evidence: animdat1-4.dat, neintrag.dat: animation tables.
  `uses` comes from this segment's relocation records, the class members
  from RTTI and form streams. Recovered free bodies are listed in the
  implementation; the other bodies are not recovered. }
{$F+}
interface

uses ExtCtrls, Graphics, Controls, SysUtils;

type
  TCell17 = packed record
    W0: Word;
    Pad: Word;
    Key: SmallInt;
  end;
  TCellArr17 = array[0..0] of TCell17;
  PCell17 = ^TCellArr17;
  THold17 = packed record
    Pad: array[0..0] of Byte;
  end;
  PHold17 = ^THold17;
  TRec6532 = packed record
    Pad: array[0..$183] of Byte;
    P184: PHold17;
  end;
  PRec6532 = ^TRec6532;
  TSlotW17 = packed record
    W0, W1: SmallInt;
    W2, W3, W4, W5: Word;
    Pad: array[0..7] of Byte;
    B14, B15, B16, B17: Byte;
    W18: Word;
    L1A: LongInt;
    W1E, W20, W22, W24, W26: Word;
  end;
  TSlotWArr17 = array[0..0] of TSlotW17;
  PSlotWArr17 = ^TSlotWArr17;
procedure Proc17_0002;
function Proc17_000C(A0, A1: Word): Byte;
function Far412B(A1, A0: Word): Byte;
procedure Proc17_0153(A0, A1, A2, A3: Word);
procedure Proc17_0324(A0, A1, A2: Word);
procedure Proc17_2C04(A0, A1, A2, A3, A4: Word);
function Proc17_2C3B(A0, A1: Word): Boolean;
function Proc17_2D2A(A0, A1: Word): Boolean;
procedure Proc17_2DF2(A0: Word);
procedure Proc17_3496(A0: Word);
procedure Proc17_385D;
procedure Proc17_38C4;
procedure Proc17_3A19(A0, A1, A2, A3, A4, A5, A6: Word);
function Proc17_4B93(Col, Row: Word): Boolean;
procedure Proc17_4BFA(A0, A1: Word);
function Far4DD6(A0, A1: Word): Boolean;
function StubFFFF75E(A0, A1: Word): Byte;
function Proc17_4C27(A0, A1: Word): Byte;
procedure Proc17_4C55(A0: Word);
function Proc17_4E18(A0: Byte; A1: Word): Boolean;
procedure Proc17_4F4F(A0, A1, A2, A3, A4, A5, A6, A7: Word);
procedure Proc17_5386(A0, A1: Word);
procedure Proc17_5F3E(A0, A1: Word);
function Far68B9(A0: Word): Word;
function Far68F9(A0: Word): Word;
procedure Proc17_6769(A0, A1, A2: Word);
procedure Proc17_68F1(A0: Word);
procedure Proc17_6975(A0, A1: Word);
procedure Proc17_6BAC(A0, A1, A2: SmallInt);
procedure Proc17_6C5A(A0, A1: Word);
procedure Proc17_6C8B;
procedure Proc17_6CBA(A0: Word);
procedure Proc17_6EE7(A0: Word);
procedure Proc17_75DE(A0: Word);
procedure Proc17_7EE3;
procedure Proc17_7F4A;
procedure Proc17_7FB1;
procedure Far8062(var A0: THold17);
procedure StubFFFF22C6(var A0: THold17);
procedure Proc17_868C;
procedure Proc17_88BB;
procedure Proc17_8950(A0, A1: Word);
procedure Proc17_8A07(A0, A1: Word);
procedure Proc17_571E(Idx: Word);
procedure Proc17_5E73(Idx: Word);
procedure Proc17_5841(Idx: Word);
function Proc17_4AE2(Col, Row, Kind, Unused: Word): Boolean;
var
  SortAnchor17: array[0..15] of Byte;


implementation

uses THINTERG, TDUMMYFO, GFX, DARSTELL, EREIGN, OBJEKT, SOUND, MAP, DataVal;

procedure Proc17_0002;
begin
end;

function Proc17_000C(A0, A1: Word): Byte;
var
  Spare: LongInt;              { declared and never used: the target's frame is 6, not 2 }
begin
  Proc17_000C := Far412B(A1, A0);
end;

function Far412B(A1, A0: Word): Byte;
begin
  Far412B := 0;
end;

procedure Proc17_0153;
begin
end;

procedure Proc17_0324(A0, A1, A2: Word);
begin
end;

procedure Proc17_2C04;
begin
end;

function Proc17_2C3B(A0, A1: Word): Boolean;
var
  I: Integer;
begin
  Proc17_2C3B := False;
  for I := $2F to HighMark17 do
    with PSlotWArr17(Slots)^[I] do
      case B17 of
        $11, $12, $13, $14, $15, $16:
          if (A1 = W22) and (A0 = W24) then
          begin
            Proc17_5841(I);
            Proc17_2DF2(I);
            Proc17_2C3B := True;
            MapTile1^[W0, W1] := $FF;
            I := HighMark17;
          end;
        $20, $21:
          if (A1 = W22) and (A0 = W24) then
          begin
            Proc17_2DF2(I);
            Proc17_2C3B := True;
            MapTile1^[W0, W1] := $FF;
            I := HighMark17;
          end;
      end;
end;

function Proc17_2D2A(A0, A1: Word): Boolean;
var
  I: Integer;
begin
  Proc17_2D2A := False;
  for I := $2F to HighMark17 do
    with PSlotWArr17(Slots)^[I] do
      case B17 of
        $11, $12, $13, $14, $15, $16:
          if (A1 = W22) and (A0 = W24) then
          begin
            Proc17_5841(I);
            Proc17_2DF2(I);
            Proc17_2D2A := True;
          end;
        $20, $21:
          if (A1 = W22) and (A0 = W24) then
          begin
            MapTile1^[W0, W1] := $FF;
            Proc17_2DF2(I);
            Proc17_2D2A := True;
          end;
      end;
end;

procedure Proc17_2DF2(A0: Word);
type
  TSlotF2 = packed record
    W0, W1: SmallInt;
    W2, W3, W4, W5: Word;
    Pad: array[0..7] of Byte;
    B14, B15, B16, B17: Byte;
    W18: Word;
    L1A: LongInt;
    W1E, W20, W22, W24, W26: Word;
  end;
  TSlotF2Arr = array[0..0] of TSlotF2;
  PSlotF2Arr = ^TSlotF2Arr;
begin
  case PSlotF2Arr(Slots)^[A0].B17 of
    7, 8, 9, $2E:
      begin
        PSlotF2Arr(Slots)^[A0].B17 := 0;
        PSlotF2Arr(Slots)^[A0 + 100].B17 := 0;
      end;
    $11, $12, $13, $14, $15, $16:
      begin
        if MapTile1^[PSlotF2Arr(Slots)^[A0].W22, PSlotF2Arr(Slots)^[A0].W24] > 0 then
          Dec(MapTile1^[PSlotF2Arr(Slots)^[A0].W22, PSlotF2Arr(Slots)^[A0].W24]);
        if MapTile1^[PSlotF2Arr(Slots)^[A0].W22, PSlotF2Arr(Slots)^[A0].W24] = 0 then
          MapTile1^[PSlotF2Arr(Slots)^[A0].W22, PSlotF2Arr(Slots)^[A0].W24] := $FF;
        Proc17_5841(A0);
      end;
    $20, $21:
      begin
        if MapTile1^[PSlotF2Arr(Slots)^[A0].W22, PSlotF2Arr(Slots)^[A0].W24] > 0 then
          Dec(MapTile1^[PSlotF2Arr(Slots)^[A0].W22, PSlotF2Arr(Slots)^[A0].W24]);
        if MapTile1^[PSlotF2Arr(Slots)^[A0].W22, PSlotF2Arr(Slots)^[A0].W24] = 0 then
          MapTile1^[PSlotF2Arr(Slots)^[A0].W22, PSlotF2Arr(Slots)^[A0].W24] := $FF;
      end;
    else
      if (PSlotF2Arr(Slots)^[A0].B17 <> 0) and (PSlotF2Arr(Slots)^[A0].W0 > 0) and
         (PSlotF2Arr(Slots)^[A0].W0 < $FA) and (PSlotF2Arr(Slots)^[A0].W1 > 0) and
         (PSlotF2Arr(Slots)^[A0].W1 < $FA) then
      begin
        MapTile1^[PSlotF2Arr(Slots)^[A0].W0, PSlotF2Arr(Slots)^[A0].W1] := $FF;
        MapTile2^[PSlotF2Arr(Slots)^[A0].W0, PSlotF2Arr(Slots)^[A0].W1] := $FF;
      end;
  end;
  PSlotF2Arr(Slots)^[A0].B17 := 0;
end;

{$F-}
procedure Proc17_3083;
begin
end;
{$F+}

{$F-}
procedure Proc17_30BA;
begin
end;
{$F+}

procedure Proc17_3496;
begin
end;

{$F-}
procedure Proc17_3727;
var
  i, j: SmallInt;
  T4: SmallInt;
  T0: Word;
  Spare: Word;                    { declared and never used: the target's frame is 0xe, not 0xc }
begin
  for i := 1 to SortCount17 - 1 do
    for j := 1 to SortCount17 - 1 do
      if SortSlots17^[j].Key > SortSlots17^[j + 1].Key then
      begin
        T4 := SortSlots17^[j].Key;
        T0 := SortSlots17^[j].W0;
        SortSlots17^[j].Key := SortSlots17^[j + 1].Key;
        SortSlots17^[j].W0 := SortSlots17^[j + 1].W0;
        SortSlots17^[j + 1].Key := T4;
        SortSlots17^[j + 1].W0 := T0;
      end;
end;
{$F+}

procedure Proc17_385D;
var
  I: Word;
begin
  SortCount17 := 0;
  for I := $24 to $640 do
    if (PSlotArrF17(Slots)^[I].B17 <> 0) and (PSlotArrF17(Slots)^[I].B16 = 1) then
      if Proc17_000C(PSlotArrF17(Slots)^[I].W1, Slots^[I].W0) = 1 then
      begin
        Inc(SortCount17);
        Proc17_3496(I);
      end;
  Proc17_3727;
end;

procedure Proc17_38C4;
begin
end;

procedure Proc17_3A19;
begin
end;

function Proc17_4B93(Col, Row: Word): Boolean;
var
  I: Integer;
begin
  Proc17_4B93 := False;
  for I := $2F to HighMark17 do
    if (PSlotArrF17(Slots)^[I].B17 <> 0) and (Slots^[I].W0 = Row) and
       (Slots^[I].W1 = Col) then
      Proc17_4B93 := True;
end;

procedure Proc17_4BFA;
begin
end;

function Far4DD6(A0, A1: Word): Boolean;
begin
  Far4DD6 := False;
end;

function StubFFFF75E(A0, A1: Word): Byte;
begin
  StubFFFF75E := 0;
end;

function Proc17_4C27(A0, A1: Word): Byte;
begin
  if Far1AB3(A0, A1) then
    Proc17_4C27 := StubFFFF75E(A0, A1)
  else
    Proc17_4C27 := 0;
end;

procedure Proc17_4C55;
begin
end;

function Proc17_4E18(A0: Byte; A1: Word): Boolean;
begin
  Proc17_4E18 := False;
end;

procedure Proc17_4F4F;
begin
end;

procedure Proc17_5386;
begin
end;

procedure Proc17_5F3E;
begin
end;

function Far68B9(A0: Word): Word;
begin
  Far68B9 := 0;
end;

function Far68F9(A0: Word): Word;
begin
  Far68F9 := 0;
end;

procedure Proc17_6769(A0, A1, A2: Word);
begin
  if Proc17_4E18(A2, A0) = False then
  begin
    case A1 of
      5, 7, 9, $B:
        if Far68B9($64) < $3C then
        begin
          Proc17_571E(A0);
          PSlotArrF17(Slots)^[A0].W18 := A1;
          Proc17_5E73(A0);
        end;
    else
      begin
        Proc17_571E(A0);
        PSlotArrF17(Slots)^[A0].W18 := A1;
        Proc17_5E73(A0);
      end;
    end;
  end
  else if ((MapTile1^[PSlotArrF17(Slots)^[A0].W0, PSlotArrF17(Slots)^[A0].W1] = $FF) and
           (MapTile2^[PSlotArrF17(Slots)^[A0].W0, PSlotArrF17(Slots)^[A0].W1] = PSlotArrF17(Slots)^[A0].W18)) or
          ((MapTile2^[PSlotArrF17(Slots)^[A0].W0, PSlotArrF17(Slots)^[A0].W1] = $FF) and
           (MapTile1^[PSlotArrF17(Slots)^[A0].W0, PSlotArrF17(Slots)^[A0].W1] = PSlotArrF17(Slots)^[A0].W18)) then
  begin
    if Far68F9($64) < $32 then
    begin
      Proc17_571E(A0);
      PSlotArrF17(Slots)^[A0].W18 := A1;
      Proc17_5E73(A0);
    end;
  end;
end;

procedure Proc17_68F1;
begin
end;

procedure Proc17_6975;
begin
end;

procedure Proc17_6BAC(A0, A1, A2: SmallInt);
type
  TSlotS17 = packed record
    S0, S1: SmallInt;
    Pad1: array[0..17] of Byte;
    B16: Byte;
    B17: Byte;
    Rest: array[0..15] of Byte;
  end;
  PSlotSArr17 = ^TSlotS17Arr;
  TSlotS17Arr = array[0..0] of TSlotS17;
  TCell16 = packed record
    Pad: array[0..5] of Byte;
    W6: Integer;
    W8: Integer;
    Rest: array[0..5] of Byte;
  end;
  TCell16Arr = array[0..0] of TCell16;
  PCell16Arr = ^TCell16Arr;
var
  I: Word;
begin
  for I := $2F to $578 do
    if (PSlotSArr17(Slots)^[I].S0 >= A1) and
       (PSlotSArr17(Slots)^[I].S0 < PCell16Arr(Sel10Board)^[Byte(A2)].W6 + A1) and
       (PSlotSArr17(Slots)^[I].S1 >= A0) and
       (PSlotSArr17(Slots)^[I].S1 < PCell16Arr(Sel10Board)^[Byte(A2)].W8 + A0) and
       (PSlotSArr17(Slots)^[I].B17 = $26) then
      Proc17_2DF2(I);
end;

procedure Proc17_6C5A;
begin
end;

procedure Proc17_6C8B;
begin
end;

procedure Proc17_6CBA;
begin
end;

procedure Proc17_6EE7;
begin
end;

{$F-}
procedure Proc17_70AB;
begin
end;
{$F+}

procedure Proc17_75DE;
begin
end;

{$F-}
procedure Proc17_7A14;
begin
end;
{$F+}

procedure Proc17_7EE3;
var
  I: Integer;
begin
  for I := $2F to HighMark17 do
    case PSlotArrF17(Slots)^[I].B17 of
      6, $2A, $46, 1, $19, $25, $2B, $2C, $2D:
        ;
    else
      PSlotArrF17(Slots)^[I].B16 := 0;
    end;
end;

procedure Proc17_7F4A;
var
  I: Integer;
begin
  for I := $2F to HighMark17 do
    case PSlotArrF17(Slots)^[I].B17 of
      6, $2A, $46, 1, $19, $25, $2B, $2C, $2D:
        ;
    else
      PSlotArrF17(Slots)^[I].B16 := 1;
    end;
end;

procedure Proc17_7FB1;
begin
  Proc17_7A14;
  if Data0000_004E[$6] <> 0 then
  begin
    if G0056 = 1 then
    begin
      Proc18_2373;
      Proc17_385D;
      if (SmallInt(W6056) <= $15) and (SmallInt(W6056) >= 8) or (W6056 = 6) or (W6056 = 7) then
        Proc18_124F;
      Proc17_38C4;
      if (SmallInt(W6056) <= $15) and (SmallInt(W6056) >= 8) or (W6056 = 6) or (W6056 = 7) then
        Proc18_155B;
      Far8062(PRec6532(P6532)^.P184^);
      if (SmallInt(W6056) <= $15) and (SmallInt(W6056) >= 8) or (W6056 = 6) or (W6056 = 7) then
        Proc18_1836;
      Proc18_1919;
    end;
  end
  else
    StubFFFF22C6(PRec6532(P6532)^.P184^);
end;

procedure Far8062(var A0: THold17);
begin
end;

procedure StubFFFF22C6(var A0: THold17);
begin
end;

{$F-}
procedure Proc17_80A7;
begin
end;
{$F+}

procedure Proc17_868C;
begin
end;

procedure Proc17_88BB;
begin
end;

procedure Proc17_8950;
begin
end;

procedure Proc17_8A07;
begin
end;

procedure Proc17_571E(Idx: Word);
begin
  if MapTile1^[Slots^[Idx].W0, Slots^[Idx].W1] = PSlotArr22W(Slots)^[Idx].W18 then
    MapTile1^[Slots^[Idx].W0, Slots^[Idx].W1] := $ff;
  if MapTile2^[Slots^[Idx].W0, Slots^[Idx].W1] = PSlotArr22W(Slots)^[Idx].W18 then
    MapTile2^[Slots^[Idx].W0, Slots^[Idx].W1] := $ff;
  MapTile1^[Slots^[Idx].W0, Slots^[Idx].W1] := $ff;
  MapTile2^[Slots^[Idx].W0, Slots^[Idx].W1] := $ff;
end;

procedure Proc17_5E73(Idx: Word);
begin
  if MapTile1^[Slots^[Idx].W0, Slots^[Idx].W1] = $ff then
  begin
    MapTile1^[Slots^[Idx].W0, Slots^[Idx].W1] := Slots^[Idx].B18;
  end
  else if MapTile2^[Slots^[Idx].W0, Slots^[Idx].W1] = $ff then
    MapTile2^[Slots^[Idx].W0, Slots^[Idx].W1] := Slots^[Idx].B18;
end;

procedure Proc17_5841(Idx: Word);
begin
  case Table^[PSlotArrWA22(Slots)^[Idx].W18, PSlotArrWA22(Slots)^[Idx].W1A].B3 of
    $a:
      begin
        if MapTile1^[PSlotArrWA22(Slots)^[Idx].W0 + 1, PSlotArrWA22(Slots)^[Idx].W1] = PSlotArrWA22(Slots)^[Idx].W18 then
          MapTile1^[PSlotArrWA22(Slots)^[Idx].W0 + 1, PSlotArrWA22(Slots)^[Idx].W1] := $ff;
        if MapTile2^[PSlotArrWA22(Slots)^[Idx].W0 + 1, PSlotArrWA22(Slots)^[Idx].W1] = PSlotArrWA22(Slots)^[Idx].W18 then
          MapTile2^[PSlotArrWA22(Slots)^[Idx].W0 + 1, PSlotArrWA22(Slots)^[Idx].W1] := $ff;
        MapTile1^[PSlotArrWA22(Slots)^[Idx].W0 + 1, PSlotArrWA22(Slots)^[Idx].W1] := $ff;
        MapTile2^[PSlotArrWA22(Slots)^[Idx].W0 + 1, PSlotArrWA22(Slots)^[Idx].W1] := $ff;
      end;
    $b:
      begin
        if MapTile1^[PSlotArrWA22(Slots)^[Idx].W0 - 1, PSlotArrWA22(Slots)^[Idx].W1] = PSlotArrWA22(Slots)^[Idx].W18 then
          MapTile1^[PSlotArrWA22(Slots)^[Idx].W0 - 1, PSlotArrWA22(Slots)^[Idx].W1] := $ff;
        if MapTile2^[PSlotArrWA22(Slots)^[Idx].W0 - 1, PSlotArrWA22(Slots)^[Idx].W1] = PSlotArrWA22(Slots)^[Idx].W18 then
          MapTile2^[PSlotArrWA22(Slots)^[Idx].W0 - 1, PSlotArrWA22(Slots)^[Idx].W1] := $ff;
        MapTile1^[PSlotArrWA22(Slots)^[Idx].W0 - 1, PSlotArrWA22(Slots)^[Idx].W1] := $ff;
        MapTile2^[PSlotArrWA22(Slots)^[Idx].W0 - 1, PSlotArrWA22(Slots)^[Idx].W1] := $ff;
      end;
    $c:
      begin
        if MapTile1^[PSlotArrWA22(Slots)^[Idx].W0, PSlotArrWA22(Slots)^[Idx].W1 - 1] = PSlotArrWA22(Slots)^[Idx].W18 then
          MapTile1^[PSlotArrWA22(Slots)^[Idx].W0, PSlotArrWA22(Slots)^[Idx].W1 - 1] := $ff;
        if MapTile2^[PSlotArrWA22(Slots)^[Idx].W0, PSlotArrWA22(Slots)^[Idx].W1 - 1] = PSlotArrWA22(Slots)^[Idx].W18 then
          MapTile2^[PSlotArrWA22(Slots)^[Idx].W0, PSlotArrWA22(Slots)^[Idx].W1 - 1] := $ff;
        MapTile1^[PSlotArrWA22(Slots)^[Idx].W0, PSlotArrWA22(Slots)^[Idx].W1 - 1] := $ff;
        MapTile2^[PSlotArrWA22(Slots)^[Idx].W0, PSlotArrWA22(Slots)^[Idx].W1 - 1] := $ff;
      end;
    $d:
      begin
        if MapTile1^[PSlotArrWA22(Slots)^[Idx].W0, PSlotArrWA22(Slots)^[Idx].W1 + 1] = PSlotArrWA22(Slots)^[Idx].W18 then
          MapTile1^[PSlotArrWA22(Slots)^[Idx].W0, PSlotArrWA22(Slots)^[Idx].W1 + 1] := $ff;
        if MapTile2^[PSlotArrWA22(Slots)^[Idx].W0, PSlotArrWA22(Slots)^[Idx].W1 + 1] = PSlotArrWA22(Slots)^[Idx].W18 then
          MapTile2^[PSlotArrWA22(Slots)^[Idx].W0, PSlotArrWA22(Slots)^[Idx].W1 + 1] := $ff;
        MapTile1^[PSlotArrWA22(Slots)^[Idx].W0, PSlotArrWA22(Slots)^[Idx].W1 + 1] := $ff;
        MapTile2^[PSlotArrWA22(Slots)^[Idx].W0, PSlotArrWA22(Slots)^[Idx].W1 + 1] := $ff;
      end;
  else
    begin
      if MapTile1^[PSlotArrWA22(Slots)^[Idx].W0, PSlotArrWA22(Slots)^[Idx].W1] = PSlotArrWA22(Slots)^[Idx].W18 then
        MapTile1^[PSlotArrWA22(Slots)^[Idx].W0, PSlotArrWA22(Slots)^[Idx].W1] := $ff;
      if MapTile2^[PSlotArrWA22(Slots)^[Idx].W0, PSlotArrWA22(Slots)^[Idx].W1] = PSlotArrWA22(Slots)^[Idx].W18 then
        MapTile2^[PSlotArrWA22(Slots)^[Idx].W0, PSlotArrWA22(Slots)^[Idx].W1] := $ff;
      MapTile1^[PSlotArrWA22(Slots)^[Idx].W0, PSlotArrWA22(Slots)^[Idx].W1] := $ff;
      MapTile2^[PSlotArrWA22(Slots)^[Idx].W0, PSlotArrWA22(Slots)^[Idx].W1] := $ff;
    end;
  end;
end;

{$F-}
procedure Proc17_0025(Idx: Word; P26, P24, P22, P20, P1E, P1C: Word;
               P1A, P18, P16, P14: Byte; P12: Word; L10: LongInt;
               PC, PA, P8, P6, P4: Word);
begin
  PSlotArrF17(Slots)^[Idx].W0 := P26;
  PSlotArrF17(Slots)^[Idx].W1 := P24;
  PSlotArrF17(Slots)^[Idx].W2 := P22;
  PSlotArrF17(Slots)^[Idx].W3 := P20;
  PSlotArrF17(Slots)^[Idx].W4 := P1E;
  PSlotArrF17(Slots)^[Idx].W5 := P1C;
  PSlotArrF17(Slots)^[Idx].B14 := P1A;
  PSlotArrF17(Slots)^[Idx].B15 := P18;
  PSlotArrF17(Slots)^[Idx].B16 := P16;
  PSlotArrF17(Slots)^[Idx].B17 := P14;
  PSlotArrF17(Slots)^[Idx].W18 := P12;
  PSlotArrF17(Slots)^[Idx].L1A := L10;
  PSlotArrF17(Slots)^[Idx].W1E := PC;
  PSlotArrF17(Slots)^[Idx].W20 := PA;
  PSlotArrF17(Slots)^[Idx].W22 := P8;
  PSlotArrF17(Slots)^[Idx].W24 := P6;
  PSlotArrF17(Slots)^[Idx].W26 := P4;
end;
{$F+}

function Proc17_4AE2(Col, Row, Kind, Unused: Word): Boolean;
var
  J: Integer;
begin
  Proc17_4AE2 := False;
  case Kind of
    $11, $12, $13, $14, $15, $16:
      begin
        if (MapTile1^[Row, Col] <> $ff) or (MapTile2^[Row, Col] <> $ff) then
          Proc17_4AE2 := True;
      end
  else
    for J := $2f to HighMark17 do
      if (PSlotArrF17(Slots)^[J].B17 = Kind) and (PSlotArr22W(Slots)^[J].W0 = Row) and
         (PSlotArr22W(Slots)^[J].W1 = Col) then
        Proc17_4AE2 := True;
  end;
end;
procedure CallersInit17;
var
  Tick17: Word;
begin
  Tick17 := 0;
  Proc17_571E(0);
  Proc17_5E73(0);
  Proc17_5841(0);
  Proc17_0025(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);
  Proc17_3727;
  Proc17_385D;
  Proc17_7EE3;
  Proc17_7F4A;
  if Proc17_4B93(0, 0) then;
  Proc17_6BAC(0, 0, 0);
  if Proc17_4C27(0, 0) = 0 then;
  if Proc17_4AE2(0, 0, 0, 0) then;
  Proc17_6769(0, 0, 0);
  Proc17_7FB1;
  if Proc17_2C3B(0, 0) then;
  if Proc17_2D2A(0, 0) then;
end;

begin
  CallersInit17;
end.
