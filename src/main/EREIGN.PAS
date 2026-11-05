unit EREIGN;
{ Reconstructed scaffold, holiday.exe code segment 18 (24990 bytes).
  This is unit; the original kept its forms inside the segment's own  unit (docs/tree.md).
  Evidence: no strings, logic-only unit, name unknown.
  `uses` comes from this segment's relocation records, the class members
  from RTTI and form streams. Recovered free bodies are listed in the
  implementation; the other bodies are not recovered. }
{$F+}
interface

uses Classes;

procedure Proc18_0014;
procedure Proc18_124F;
procedure Proc18_155B;
procedure Proc18_1836;
procedure Far190B(A0, A1, A2, A3, A4, A5, A6, A7, A8, A9: Word);
procedure Far1A08(A0, A1, A2, A3, A4, A5, A6, A7, A8, A9: Word);
procedure Proc18_1919;
procedure Proc18_1A25(A0, A1: Word);
procedure Proc18_2373;
procedure Proc18_2CE5(A0: Word);
procedure Proc18_5293;


implementation

uses THINTERG, TDUMMYFO, BAUFEN, GFX, DARSTELL, SEG15, MENU, ANIM, OBJEKT, SOUND, MAP, DataVal;

procedure Proc18_0014;
begin
end;

procedure Proc18_124F;
type
  TCell124 = packed record
    W0, W2: Integer;
    W4, W6: Word;
    PAB: array[0..1] of Byte;
    W0A: Word;
    P2: array[0..7] of Byte;
    B14, B15, B16, B17: Byte;
    P3: array[0..15] of Byte;
  end;
  TCellArr124 = array[0..0] of TCell124;
  PCellArr124 = ^TCellArr124;
  PWord124 = ^Word;
begin
  case Integer(W6056) of
    6, 7:
    begin
      Proc3_3DAD(W605A);
      PCellArr124(Slots)^[0].B17 := 0;
      PWord124(@Pad6FCE[0])^ := 0;
      PCellArr124(Slots)^[0].W0 := W605A;
      PCellArr124(Slots)^[0].W2 := W605C;
      PCellArr124(Slots)^[0].W4 := $19;
      PCellArr124(Slots)^[0].W6 := 6;
      PCellArr124(Slots)^[0].B14 := 1;
      PCellArr124(Slots)^[0].B15 := 1;
      Inc(Pad6FCE[6]);
      if Pad6FCE[6] > 7 then
        Pad6FCE[6] := 0;
      case W6056 of
        6:
        begin
          PCellArr124(Slots)^[0].W0A := Pad6FCE[6] + $10;
          PCellArr124(Slots)^[0].B17 := $0E;
        end;
        7:
        begin
          PCellArr124(Slots)^[0].W0A := Pad6FCE[6] + 8;
          PCellArr124(Slots)^[0].B17 := $0F;
        end;
      end;
      W6FFC := (PCellArr124(Slots)^[0].W0 - Integer(W5530) -
        (PCellArr124(Slots)^[0].W2 - Integer(W5532)) + $3E8) div 2 - $1F4;
      W6FFA := PCellArr124(Slots)^[0].W0 - Integer(W5530) +
        (PCellArr124(Slots)^[0].W2 - Integer(W5532));
      PWord124(@Pad6FCE[2])^ := PCellArr124(Slots)^[0].W0;
      PWord124(@Pad6FCE[4])^ := PCellArr124(Slots)^[0].W2;
      PCellArr124(Slots)^[0].B16 := 1;
      Proc17_3496(0);
    end;
    8..$15:
    begin
      Proc3_3D8D(W605A);
      PCellArr124(Slots)^[0].B17 := 0;
      PWord124(@Pad6FCE[0])^ := 0;
      Proc18_0014;
      if W6056 = 8 then
      begin
        PCellArr124(Slots)^[0].B17 := $0D;
        PCellArr124(Slots)^[0].W0 := W605A;
        PCellArr124(Slots)^[0].W2 := W605C;
        PCellArr124(Slots)^[0].W4 := $10;
        PCellArr124(Slots)^[0].W6 := 0;
        PCellArr124(Slots)^[0].B14 := 1;
        PCellArr124(Slots)^[0].B15 := 1;
        Inc(Pad6FCE[6]);
        if Pad6FCE[6] > 7 then
          Pad6FCE[6] := 0;
        PCellArr124(Slots)^[0].W0A := Pad6FCE[6] + $3C;
        W6FFC := (PCellArr124(Slots)^[0].W0 - Integer(W5530) -
          (PCellArr124(Slots)^[0].W2 - Integer(W5532)) + $3E8) div 2 - $1F4;
        W6FFA := PCellArr124(Slots)^[0].W0 - Integer(W5530) +
          (PCellArr124(Slots)^[0].W2 - Integer(W5532));
        PWord124(@Pad6FCE[2])^ := PCellArr124(Slots)^[0].W0;
        PWord124(@Pad6FCE[4])^ := PCellArr124(Slots)^[0].W2;
        PCellArr124(Slots)^[0].B16 := 1;
        Proc17_3496(0);
      end;
      if W6056 = $15 then
      begin
        PCellArr124(Slots)^[0].B17 := $10;
        PCellArr124(Slots)^[0].W0 := W605A;
        PCellArr124(Slots)^[0].W2 := W605C;
        PCellArr124(Slots)^[0].W4 := $16;
        PCellArr124(Slots)^[0].W6 := 0;
        PCellArr124(Slots)^[0].B14 := 1;
        PCellArr124(Slots)^[0].B15 := 1;
        Inc(Pad6FCE[6]);
        if Pad6FCE[6] > 7 then
          Pad6FCE[6] := 0;
        PCellArr124(Slots)^[0].W0A := Pad6FCE[6] + $44;
        W6FFC := (PCellArr124(Slots)^[0].W0 - Integer(W5530) -
          (PCellArr124(Slots)^[0].W2 - Integer(W5532)) - $3E8) div 2 - $1F4;
        W6FFA := PCellArr124(Slots)^[0].W0 - Integer(W5530) +
          (PCellArr124(Slots)^[0].W2 - Integer(W5532));
        PWord124(@Pad6FCE[2])^ := PCellArr124(Slots)^[0].W0;
        PWord124(@Pad6FCE[4])^ := PCellArr124(Slots)^[0].W2;
        PCellArr124(Slots)^[0].B16 := 1;
        Proc17_3496(0);
      end;
    end;
  end;
end;

procedure Proc18_155B;
type
  TCell155 = packed record
    W0, W1: Integer;
    PA: array[0..5] of Byte;
    W0A: Integer;
    PB: array[0..9] of Byte;
    B16: Byte;
    PC: array[0..16] of Byte;
  end;
  TCellArr155 = array[0..0] of TCell155;
  PCellArr155 = ^TCellArr155;
  PWord155 = ^Word;
var
  I: Integer;
label Loop155, AfterLoop, Exit155;
begin
  case Integer(W6056) of
    6, 7:
    begin
      case W6056 of
        6: PCellArr155(Slots)^[0].W0A := Pad6FCE[6] + $10;
        7: PCellArr155(Slots)^[0].W0A := Pad6FCE[6] + 8;
      end;
      W6FFC := (PCellArr155(Slots)^[0].W0 - Integer(W5530) -
        (PCellArr155(Slots)^[0].W1 - Integer(W5532)) + $3E8) div 2 - $1F4;
      W6FFA := PCellArr155(Slots)^[0].W0 - Integer(W5530) +
        (PCellArr155(Slots)^[0].W1 - Integer(W5532));
      PWord155(@Pad6FCE[2])^ := PCellArr155(Slots)^[0].W0;
      PWord155(@Pad6FCE[4])^ := PCellArr155(Slots)^[0].W1;
      PCellArr155(Slots)^[0].B16 := 1;
      Proc17_3A19(0, PWord155(@Pad6FCE[2])^, PWord155(@Pad6FCE[4])^, 0, 5, 2, 1);
    end;
    8..$15:
      goto Loop155;
  end;
  goto Exit155;
Loop155:
  if PWord155(@Pad6FCE[0])^ = 0 then
    goto AfterLoop;
  for I := 1 to PWord155(@Pad6FCE[0])^ + 1 - 1 do
  begin
    W6FFC := (PCellArr155(Slots)^[I].W0 - Integer(W5530) -
      (PCellArr155(Slots)^[I].W1 - Integer(W5532)) + $3E8) div 2 - $1F4;
    W6FFA := PCellArr155(Slots)^[I].W0 - Integer(W5530) +
      (PCellArr155(Slots)^[I].W1 - Integer(W5532));
    PWord155(@Pad6FCE[2])^ := PCellArr155(Slots)^[I].W0;
    PWord155(@Pad6FCE[4])^ := PCellArr155(Slots)^[I].W1;
    PCellArr155(Slots)^[I].B16 := 1;
    Proc17_3A19(I, PWord155(@Pad6FCE[2])^, PWord155(@Pad6FCE[4])^, 0, 7, 4, 0);
  end;
AfterLoop:
  if W6056 = 8 then
  begin
    PCellArr155(Slots)^[0].W0A := Pad6FCE[6] + $3C;
    W6FFC := (PCellArr155(Slots)^[0].W0 - Integer(W5530) -
      (PCellArr155(Slots)^[0].W1 - Integer(W5532)) + $3E8) div 2 - $1F4;
    W6FFA := PCellArr155(Slots)^[0].W0 - Integer(W5530) +
      (PCellArr155(Slots)^[0].W1 - Integer(W5532));
    PWord155(@Pad6FCE[2])^ := PCellArr155(Slots)^[0].W0;
    PWord155(@Pad6FCE[4])^ := PCellArr155(Slots)^[0].W1;
    PCellArr155(Slots)^[0].B16 := 1;
    Proc17_3A19(0, PWord155(@Pad6FCE[2])^, PWord155(@Pad6FCE[4])^, 0, 5, 2, 0);
  end;
  if W6056 = $15 then
  begin
    PCellArr155(Slots)^[0].W0A := Pad6FCE[6] + $44;
    W6FFC := (PCellArr155(Slots)^[0].W0 - Integer(W5530) -
      (PCellArr155(Slots)^[0].W1 - Integer(W5532)) + $3E8) div 2 - $1F4;
    W6FFA := PCellArr155(Slots)^[0].W0 - Integer(W5530) +
      (PCellArr155(Slots)^[0].W1 - Integer(W5532));
    PWord155(@Pad6FCE[2])^ := PCellArr155(Slots)^[0].W0;
    PWord155(@Pad6FCE[4])^ := PCellArr155(Slots)^[0].W1;
    PCellArr155(Slots)^[0].B16 := 1;
    Proc17_3A19(0, PWord155(@Pad6FCE[2])^, PWord155(@Pad6FCE[4])^, 0, 5, 2, 0);
  end;
Exit155:
end;

procedure Proc18_1836;
type
  TObj1836 = packed record
    W0, W1: Word;
    PA: array[0..7] of Byte;
    W0C, W0E, W10, W12: Word;
    PB: array[0..2] of Byte;
    B17: Byte;
    B18: Byte;
    PC: array[0..8] of Byte;
    W22, W24: Word;
    PD: array[0..1] of Byte;
  end;
  TObjArr1836 = array[0..0] of TObj1836;
  PObjArr1836 = ^TObjArr1836;
  PWord18 = ^Word;
label Exit1836;
var
  I: Integer;
begin
  if PObjArr1836(Slots)^[0].B17 <> 0 then
    Far190B(PWord18(@W5FE2)^, PObjArr1836(Slots)^[0].W0C,
            PObjArr1836(Slots)^[0].W0E, PObjArr1836(Slots)^[0].W10,
            PObjArr1836(Slots)^[0].W12, PWord18(@Pad5FE4[0])^,
            PObjArr1836(Slots)^[0].W0C, PObjArr1836(Slots)^[0].W0E,
            $CC, $20);
  if PWord18(@Pad66CA[1540])^ = 0 then
    goto Exit1836;
  for I := 1 to PWord18(@Pad66CA[1540])^ + 1 - 1 do
    Far1A08(PWord18(@W5FE2)^, PObjArr1836(Slots)^[I].W0C,
            PObjArr1836(Slots)^[I].W0E, PObjArr1836(Slots)^[I].W10,
            PObjArr1836(Slots)^[I].W12, PWord18(@Pad5FE4[0])^,
            PObjArr1836(Slots)^[I].W0C, PObjArr1836(Slots)^[I].W0E,
            $CC, $20);
Exit1836:
end;

procedure Far190B;
begin
end;

procedure Far1A08;
begin
end;

procedure Proc18_1919;
type
  TCell19 = packed record
    W0: Word;
    Pad19: Word;
    Key: SmallInt;
  end;
  TCellArr19 = array[0..0] of TCell19;
  PCellArr19 = ^TCellArr19;
  TObj19 = packed record
    Pad0: array[0..11] of Byte;
    W0C, W0E, W10, W12: Word;
    Pad1: array[0..19] of Byte;
  end;
  TObjArr19 = array[0..0] of TObj19;
  PObjArr19 = ^TObjArr19;
  PWord19 = ^Word;
var
  I: Integer;
begin
  if SortCount17 > 0 then
    for I := 1 to SortCount17 do
      Far190B(PWord19(@W5FE2)^,
              PObjArr19(Slots)^[PCellArr19(SortSlots17)^[I].W0].W0C,
              PObjArr19(Slots)^[PCellArr19(SortSlots17)^[I].W0].W0E,
              PObjArr19(Slots)^[PCellArr19(SortSlots17)^[I].W0].W10,
              PObjArr19(Slots)^[PCellArr19(SortSlots17)^[I].W0].W12,
              PWord19(@Pad5FE4[0])^,
              PObjArr19(Slots)^[PCellArr19(SortSlots17)^[I].W0].W0C,
              PObjArr19(Slots)^[PCellArr19(SortSlots17)^[I].W0].W0E,
              $CC, $20);
end;

procedure Proc18_1A25;
begin
end;

procedure Proc18_2373;
begin
end;

{$F-}
procedure Proc18_2C1F;
begin
end;
{$F+}

procedure Proc18_2CE5;
begin
end;

procedure Proc18_5293;
begin
end;
end.
