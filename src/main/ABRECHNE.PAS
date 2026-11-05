unit ABRECHNE;
{ Reconstructed scaffold, holiday.exe code segment 1 (22644 bytes).
  This is unit; the original kept its forms inside the segment's own  unit (docs/tree.md).
  Evidence: abrechne.dat.
  `uses` comes from this segment's relocation records, the class members
  from RTTI and form streams. Recovered free bodies are listed in the
  implementation; the other bodies are not recovered. }
{$F+}
interface

uses SysUtils;

type
  TRow1 = packed record
    Pair: LongInt;
    Cells: array[0..9] of LongInt;
  end;
  TBoard1 = packed record
    Head: LongInt;
    Mid: array[0..9] of LongInt;
    Rows: array[0..2] of TRow1;
    Tail: array[3..9] of LongInt;
  end;
  PBoard1 = ^TBoard1;
procedure Proc1_05D9(A0: Word);
procedure Proc1_062C;
procedure Proc1_0660(A0, A1: Word);
procedure Proc1_0B0B(A0: Word);
procedure Proc1_0C6E(A0: Word);
procedure Proc1_1B4B;
procedure Proc1_5307;
procedure Proc1_539F(A0, A1: Word);
procedure Proc1_54C0(A0, A1: Word);
procedure Proc1_55EE;
procedure Proc1_57DC;
procedure Proc1_582F;


implementation

uses DATEN, GFX, KOMPASS, HIGHSCOR, DARSTELL, SCHLUSS, GELD, SEG15, MENU, ANIM, BAUEN, UEBERMAP;

{$F-}
procedure Proc1_0002;
begin
end;
{$F+}

{$F-}
procedure Proc1_00A2;
begin
end;
{$F+}

{$F-}
procedure Proc1_0134;
begin
end;
{$F+}

{$F-}
procedure Proc1_01D2;
begin
end;
{$F+}

{$F-}
procedure Proc1_0297;
begin
end;
{$F+}

{$F-}
procedure Proc1_042B;
begin
end;
{$F+}

{$F-}
procedure Proc1_0512;
begin
end;
{$F+}

procedure Proc1_05D9;
begin
end;

procedure Proc1_062C;
begin
end;

procedure Proc1_0660;
begin
end;

{$F-}
function Proc1_06B6(A0, A1: LongInt): Byte;
begin
  if A1 > 0 then
    Proc1_06B6 := Proc6_0F53(100, Proc6_0F19(0, (A0 * 50) div A1))
  else
    Proc1_06B6 := 0;
end;
{$F+}

{$F-}
function Proc1_0709(A0, A1: Byte): LongInt;
begin
  Proc1_0709 := 0;
end;
{$F+}

{$F-}
function Proc1_0776(N: LongInt; A0, A1: Byte): Byte;
var
  U, T: LongInt;
begin
  T := Proc1_0709(A0, A1);
  if N > 0 then
    U := (T * 50) div N
  else
    U := 100;
  if U >= 50 then
    Proc1_0776 := Proc6_0F53(100, Proc6_0F19(0, U))
  else
    Proc1_0776 := Proc6_0F53(100, Proc6_0F19(0, (U - 25) * 2));
end;
{$F+}

{$F-}
function Proc1_0829(A0: Byte): LongInt;
begin
  Proc1_0829 := 0;
end;
{$F+}

{$F-}
function Proc1_0863(N: LongInt; B: Byte): Byte;
var
  U, T: LongInt;
begin
  if N = 0 then
    Proc1_0863 := 100
  else
  begin
    T := Proc1_0829(B);
    U := (T * 50) div N;
    if U >= 50 then
      Proc1_0863 := Proc6_0F53(100, Proc6_0F19(0, U))
    else
      Proc1_0863 := Proc6_0F53(100, Proc6_0F19(0, (U - 25) * 2));
  end;
end;
{$F+}

{$F-}
procedure Proc1_0907;
begin
end;
{$F+}

{$F-}
procedure Proc1_097F;
begin
end;
{$F+}

{$F-}
procedure Proc1_0A56;
begin
end;
{$F+}

procedure Proc1_0B0B;
begin
end;

procedure Proc1_0C6E;
begin
end;

{$F-}
procedure Proc1_0D10;
begin
end;
{$F+}

{$F-}
procedure Proc1_0DE9;
begin
end;
{$F+}

{$F-}
procedure Proc1_0EA1;
begin
end;
{$F+}

{$F-}
procedure Proc1_0F37;
begin
end;
{$F+}

{$F-}
procedure Proc1_15DD;
begin
end;
{$F+}

{$F-}
procedure Proc1_16BE;
begin
end;
{$F+}

{$F-}
procedure Proc1_179F;
begin
end;
{$F+}

{$F-}
procedure Proc1_1848;
begin
end;
{$F+}

{$F-}
procedure Proc1_19EA;
begin
end;
{$F+}

{$F-}
procedure Proc1_1A52;
begin
end;
{$F+}

{$F-}
procedure Proc1_1A81;
begin
end;
{$F+}

{$F-}
procedure Proc1_1AEA;
begin
end;
{$F+}

procedure Proc1_1B4B;
begin
end;

{$F-}
procedure Proc1_1BF7;
begin
end;
{$F+}

{$F-}
procedure Proc1_4F64;
begin
end;
{$F+}

{$F-}
procedure Proc1_5212;
begin
end;
{$F+}

procedure Proc1_5307;
begin
end;

procedure Proc1_539F;
begin
end;

procedure Proc1_54C0;
begin
end;

procedure Proc1_55EE;
begin
end;

procedure Proc1_57DC;
begin
end;

procedure Proc1_582F;
begin
end;

{$F-}
procedure Proc1_09C8(P: PBoard1);
var
  I: Byte;
  J: ShortInt;
begin
  with P^ do
  begin
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
{$F+}
procedure CallersInit1;
var
  RowsBoard: TBoard1;
  ProbeClampB: Byte;
begin
  Proc1_09C8(@RowsBoard);

  ProbeClampB := Proc1_06B6(1, 1);
  ProbeClampB := Proc1_0776(1, 1, 1);
  ProbeClampB := Proc1_0863(1, 1);
end;

begin
  CallersInit1;
end.
