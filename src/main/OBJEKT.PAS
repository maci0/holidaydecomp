unit OBJEKT;
{ Reconstructed scaffold, holiday.exe code segment 19 (14811 bytes).
  This is unit; the original kept its forms inside the segment's own  unit (docs/tree.md).
  Evidence: no strings, logic-only unit, name unknown.
  `uses` comes from this segment's relocation records, the class members
  from RTTI and form streams. Recovered free bodies are listed in the
  implementation; the other bodies are not recovered. }
{$F+}
interface

uses Classes;

function InMap19(Y, X: Word): Boolean;
function Wrap19(N: Word): Word;
function Proc19_0002(A0: Word): Word;
procedure Proc19_00EF(A0, A1: Word);
function Proc19_01C0(A1, A2, A3: Word): Boolean;
procedure Proc19_03B3(A0, A1, A2: Word);
procedure Proc19_0745(A0: Word);
procedure Proc19_0A14(A0: Word);
procedure Proc19_0CE3(A0: Word);
procedure Proc19_0E6D(A0: Word);
procedure Proc19_109F(A0: Word);
var
  Pad3C6C: array[0..7] of Byte;
  G3C74: array[0..95] of Byte;
  G3CD4: array[0..15] of Byte;
  W3CE4: Word;
  W3CE6: Word;
  W3CE8: Word;
  W3CEA: Word;
  W3CEC: Word;
  W3CEE: Word;
  W3CF0: Word;
  W3CF2: Word;
  G3CF4: array[0..12, 0..3] of Integer;{ row 12 covers 0x3d54..0x3d5a; 0:0x3d54 is the grid reader in code space }

implementation

uses THINTERG, TDUMMYFO, ANIM, SOUND, MAP, DataVal;

function InMap19(Y, X: Word): Boolean;
begin
  InMap19 := (Y > 0) and (Y < 250) and (X > 0) and (X < 250);
end;

{$F-}
function Proc19_0497(P: Integer): Integer;
var
  R: Integer;
begin
  if P > 7 then
    Proc19_0497 := P - 8
  else if P < 0 then
    Proc19_0497 := P + 8
  else
    Proc19_0497 := P;
end;
{$F+}

{$F-}
function Proc19_04CA(X, A, B: Integer): Boolean;
begin
  if (A > 0) and (A < $FA) and (B > 0) and (B < $FA) then
    Proc19_04CA := False
  else
    Proc19_04CA := True;
end;
{$F+}

function Wrap19(N: Word): Word;
var
  R: Word;
begin
  if N > 7 then
    R := N - 8
  else if N < 0 then
    R := N + 8
  else
    R := N;
  Wrap19 := R;
end;

function Proc19_0002(A0: Word): Word;
begin
  with PSlotArrF17(Slots)^[A0] do
    if (Proc0_3DC9(W0 + 1, W2) >= $58) and (Proc0_3DC9(W0 + 1, W2) <= $6B) then
      Proc19_0002 := 2
    else if (Proc0_3DC9(W0 - 1, W2) >= $58) and (Proc0_3DC9(W0 - 1, W2) <= $6B) then
      Proc19_0002 := 2
    else if (Proc0_3DC9(W0, W2 - 1) >= $58) and (Proc0_3DC9(W0, W2 - 1) <= $6B) then
      Proc19_0002 := 0
    else if (Proc0_3DC9(W0, W2 + 1) >= $58) and (Proc0_3DC9(W0, W2 + 1) <= $6B) then
      Proc19_0002 := 0
    else
      Proc17_2DF2(A0);
end;

procedure Proc19_00EF;
begin
end;

function Proc19_01C0(A1, A2, A3: Word): Boolean;
begin
  if (Proc0_3E0D(A2, A1) = 2) and (Proc0_3E8D(A2, A1) = $10) and
     (Proc0_3D54(0, A1, A2) = $FF) and (Proc0_3DC9(A2, A1) = $FF) then
    Proc19_01C0 := True
  else
    Proc19_01C0 := False;
end;

{$F-}
procedure Proc19_0217;
begin
end;
{$F+}

{$F-}
procedure Proc19_02C3;
begin
end;
{$F+}

{$F-}
function Proc19_0357(A0, A1: Word): Byte;
begin
end;
{$F+}

procedure Proc19_03B3;
begin
end;

{$F-}
procedure Proc19_04F9;
begin
end;
{$F+}

procedure Proc19_0745;
begin
  case Pred7c of
    0:
      case PSlotArrF17(Slots)^[A0].W20 of
        3:
          begin
            PSlotArrF17(Slots)^[A0].W2 := 8;
            PSlotArrF17(Slots)^[A0].W3 := 9;
          end;
        2:
          begin
            PSlotArrF17(Slots)^[A0].W2 := 16;
            PSlotArrF17(Slots)^[A0].W3 := 5;
          end;
        1:
          begin
            PSlotArrF17(Slots)^[A0].W2 := 24;
            PSlotArrF17(Slots)^[A0].W3 := 1;
          end;
        0:
          begin
            PSlotArrF17(Slots)^[A0].W2 := PSlotArrF17(Slots)^[A0].W20;
            PSlotArrF17(Slots)^[A0].W3 := 14;
          end;
      end;
    2:
      case PSlotArrF17(Slots)^[A0].W20 of
        3:
          begin
            PSlotArrF17(Slots)^[A0].W2 := 16;
            PSlotArrF17(Slots)^[A0].W3 := 5;
          end;
        2:
          begin
            PSlotArrF17(Slots)^[A0].W2 := 8;
            PSlotArrF17(Slots)^[A0].W3 := 9;
          end;
        1:
          begin
            PSlotArrF17(Slots)^[A0].W2 := PSlotArrF17(Slots)^[A0].W20;
            PSlotArrF17(Slots)^[A0].W3 := 14;
          end;
        0:
          begin
            PSlotArrF17(Slots)^[A0].W2 := 24;
            PSlotArrF17(Slots)^[A0].W3 := 1;
          end;
      end;
    1:
      case PSlotArrF17(Slots)^[A0].W20 of
        3:
          begin
            PSlotArrF17(Slots)^[A0].W2 := 20;
            PSlotArrF17(Slots)^[A0].W3 := 9;
          end;
        2:
          begin
            PSlotArrF17(Slots)^[A0].W2 := 12;
            PSlotArrF17(Slots)^[A0].W3 := 4;
          end;
        1:
          begin
            PSlotArrF17(Slots)^[A0].W2 := 4;
            PSlotArrF17(Slots)^[A0].W3 := 1;
          end;
        0:
          begin
            PSlotArrF17(Slots)^[A0].W2 := 28;
            PSlotArrF17(Slots)^[A0].W3 := 14;
          end;
      end;
    3:
      case PSlotArrF17(Slots)^[A0].W20 of
        3:
          begin
            PSlotArrF17(Slots)^[A0].W2 := 12;
            PSlotArrF17(Slots)^[A0].W3 := 4;
          end;
        2:
          begin
            PSlotArrF17(Slots)^[A0].W2 := 20;
            PSlotArrF17(Slots)^[A0].W3 := 9;
          end;
        1:
          begin
            PSlotArrF17(Slots)^[A0].W2 := 28;
            PSlotArrF17(Slots)^[A0].W3 := 14;
          end;
        0:
          begin
            PSlotArrF17(Slots)^[A0].W2 := 4;
            PSlotArrF17(Slots)^[A0].W3 := 1;
          end;
      end;
  end;
end;

procedure Proc19_0A14;
begin
  case Pred7c of
    3:
      case PSlotArrF17(Slots)^[A0].W20 of
        3:
          begin
            PSlotArrF17(Slots)^[A0].W2 := 8;
            PSlotArrF17(Slots)^[A0].W3 := 9;
          end;
        2:
          begin
            PSlotArrF17(Slots)^[A0].W2 := 16;
            PSlotArrF17(Slots)^[A0].W3 := 5;
          end;
        1:
          begin
            PSlotArrF17(Slots)^[A0].W2 := 24;
            PSlotArrF17(Slots)^[A0].W3 := 1;
          end;
        0:
          begin
            PSlotArrF17(Slots)^[A0].W2 := PSlotArrF17(Slots)^[A0].W20;
            PSlotArrF17(Slots)^[A0].W3 := 14;
          end;
      end;
    1:
      case PSlotArrF17(Slots)^[A0].W20 of
        3:
          begin
            PSlotArrF17(Slots)^[A0].W2 := 16;
            PSlotArrF17(Slots)^[A0].W3 := 5;
          end;
        2:
          begin
            PSlotArrF17(Slots)^[A0].W2 := 8;
            PSlotArrF17(Slots)^[A0].W3 := 9;
          end;
        1:
          begin
            PSlotArrF17(Slots)^[A0].W2 := PSlotArrF17(Slots)^[A0].W20;
            PSlotArrF17(Slots)^[A0].W3 := 14;
          end;
        0:
          begin
            PSlotArrF17(Slots)^[A0].W2 := 24;
            PSlotArrF17(Slots)^[A0].W3 := 1;
          end;
      end;
    0:
      case PSlotArrF17(Slots)^[A0].W20 of
        3:
          begin
            PSlotArrF17(Slots)^[A0].W2 := 20;
            PSlotArrF17(Slots)^[A0].W3 := 9;
          end;
        2:
          begin
            PSlotArrF17(Slots)^[A0].W2 := 12;
            PSlotArrF17(Slots)^[A0].W3 := 4;
          end;
        1:
          begin
            PSlotArrF17(Slots)^[A0].W2 := 4;
            PSlotArrF17(Slots)^[A0].W3 := 1;
          end;
        0:
          begin
            PSlotArrF17(Slots)^[A0].W2 := 28;
            PSlotArrF17(Slots)^[A0].W3 := 14;
          end;
      end;
    2:
      case PSlotArrF17(Slots)^[A0].W20 of
        3:
          begin
            PSlotArrF17(Slots)^[A0].W2 := 12;
            PSlotArrF17(Slots)^[A0].W3 := 4;
          end;
        2:
          begin
            PSlotArrF17(Slots)^[A0].W2 := 20;
            PSlotArrF17(Slots)^[A0].W3 := 9;
          end;
        1:
          begin
            PSlotArrF17(Slots)^[A0].W2 := 28;
            PSlotArrF17(Slots)^[A0].W3 := 14;
          end;
        0:
          begin
            PSlotArrF17(Slots)^[A0].W2 := 4;
            PSlotArrF17(Slots)^[A0].W3 := 1;
          end;
      end;
  end;
end;

procedure Proc19_0CE3;
begin
  case Pred7c of
    3:
      case PSlotArrF17(Slots)^[A0].W20 of
        0:
          begin
            PSlotArrF17(Slots)^[A0].W2 := 10;
            PSlotArrF17(Slots)^[A0].W3 := 2;
          end;
        1:
          begin
            PSlotArrF17(Slots)^[A0].W2 := 25;
            PSlotArrF17(Slots)^[A0].W3 := 11;
          end;
      end;
    1:
      case PSlotArrF17(Slots)^[A0].W20 of
        1:
          begin
            PSlotArrF17(Slots)^[A0].W2 := 10;
            PSlotArrF17(Slots)^[A0].W3 := 2;
          end;
        0:
          begin
            PSlotArrF17(Slots)^[A0].W2 := 25;
            PSlotArrF17(Slots)^[A0].W3 := 11;
          end;
      end;
    0:
      case PSlotArrF17(Slots)^[A0].W20 of
        1:
          begin
            PSlotArrF17(Slots)^[A0].W2 := 22;
            PSlotArrF17(Slots)^[A0].W3 := 2;
          end;
        0:
          begin
            PSlotArrF17(Slots)^[A0].W2 := 7;
            PSlotArrF17(Slots)^[A0].W3 := 11;
          end;
      end;
    2:
      case PSlotArrF17(Slots)^[A0].W20 of
        0:
          begin
            PSlotArrF17(Slots)^[A0].W2 := 22;
            PSlotArrF17(Slots)^[A0].W3 := 2;
          end;
        1:
          begin
            PSlotArrF17(Slots)^[A0].W2 := 7;
            PSlotArrF17(Slots)^[A0].W3 := 11;
          end;
      end;
  end;
end;

procedure Proc19_0E6D;
begin
  case Pred7c of
    3:
      case PSlotArrF17(Slots)^[A0].W20 of
        1:
          begin
            PSlotArrF17(Slots)^[A0].W2 := 23;
            PSlotArrF17(Slots)^[A0].W3 := 3;
          end;
        0:
          begin
            PSlotArrF17(Slots)^[A0].W2 := 8;
            PSlotArrF17(Slots)^[A0].W3 := 12;
          end;
      end;
    1:
      case PSlotArrF17(Slots)^[A0].W20 of
        0:
          begin
            PSlotArrF17(Slots)^[A0].W2 := 23;
            PSlotArrF17(Slots)^[A0].W3 := 3;
          end;
        1:
          begin
            PSlotArrF17(Slots)^[A0].W2 := 8;
            PSlotArrF17(Slots)^[A0].W3 := 12;
          end;
      end;
    0:
      case PSlotArrF17(Slots)^[A0].W20 of
        1:
          begin
            PSlotArrF17(Slots)^[A0].W2 := 11;
            PSlotArrF17(Slots)^[A0].W3 := 3;
          end;
        0:
          begin
            PSlotArrF17(Slots)^[A0].W2 := 26;
            PSlotArrF17(Slots)^[A0].W3 := 12;
          end;
      end;
    2:
      case PSlotArrF17(Slots)^[A0].W20 of
        0:
          begin
            PSlotArrF17(Slots)^[A0].W2 := 11;
            PSlotArrF17(Slots)^[A0].W3 := 3;
          end;
        1:
          begin
            PSlotArrF17(Slots)^[A0].W2 := 26;
            PSlotArrF17(Slots)^[A0].W3 := 12;
          end;
      end;
  end;
end;

procedure Proc19_109F;
begin
end;
begin
  if InMap19(1, 2) then Wrap19(3);
  if Proc19_0497(9) = 1 then Wrap19(3);
  if Proc19_04CA(1, 1, 2) then Wrap19(3);
  if Proc19_01C0(1, 2, 3) then Wrap19(3);
  if Proc19_0002(1) = 0 then Wrap19(3);
  Proc19_0745(1);
  Proc19_0A14(1);
  Proc19_0CE3(1);
  Proc19_0E6D(1);
  Proc19_109F(1);
end.
