unit BAUEN;
{ Reconstructed scaffold, holiday.exe code segment 21 (15314 bytes).
  This is unit; the original kept its forms inside the segment's own  unit (docs/tree.md).
  Evidence: WLB*/WLT* road- and building-placement logic, Compbau.dat.
  `uses` comes from this segment's relocation records, the class members
  from RTTI and form streams. Recovered free bodies are listed in the
  implementation; the other bodies are not recovered. }
{$F+}
interface

uses Classes;

type
  TFit21 = packed record
    Lo: Integer;
    Hi: Integer;
  end;
  PFitting21 = ^TFit21;
  TByte21 = array[2..384] of Byte;
  PByte21 = ^TByte21;
  TGuard21 = array[-127..255] of Byte;
  PGuard21 = ^TGuard21;
  TRec736E = packed record
    A: LongInt;
    Gap4: array[0..3] of Byte;
    C: LongInt;
    GapC: array[0..3] of Byte;
  end;
  TRec736ETab = array[0..255] of TRec736E;
  PRec736E = ^TRec736ETab;
  TVar21 = packed record
    case Word of
      0: (W: TFit21);
      1: (Ptr: Pointer);
  end;
  TCell12 = packed record
    P0: array[0..1] of Byte;
    B2: Byte;
    P3: Byte;
    B4: Byte;
    P5: array[0..2] of Byte;
    B8: Byte;
    P9: Byte;
    B10: Byte;
    P11: Byte;
  end;
  TCell12Tab = array[2..257] of TCell12;
  PCell12 = ^TCell12Tab;
  TSel21 = packed record
    P0: array[0..9] of Byte;
    W10: Integer;
    P12: array[0..3] of Byte;
  end;
  TSel21Tab = array[0..255] of TSel21;
  PSel21 = ^TSel21Tab;
procedure Proc21_0002;
procedure Proc21_0373(A0, A1: Word);
procedure Proc21_0523(A0: Word);
procedure Proc21_2CC1(A0, A1: Word);
procedure Proc21_302E;
procedure Proc21_3080(A0, A1: Word);
procedure Proc21_32EC(A0, A1: Word);
procedure Proc21_3558;
procedure Proc21_388B;
procedure Proc21_3A6C;


implementation

uses DATEN, GFX, SCHLUSS, SEG15, ANIM, MAP;

procedure Proc21_0002;
begin
end;

{$F-}
procedure Proc21_0167;
begin
end;
{$F+}

{$F-}
procedure Proc21_0221;
begin
end;
{$F+}

procedure Proc21_0373;
begin
end;

{$F-}
procedure Proc21_03A6;
begin
end;
{$F+}

procedure Proc21_0523;
begin
end;

{$F-}
procedure Proc21_064B;
begin
end;
{$F+}

{$F-}
function Proc21_078A(A0: Byte): Boolean;
begin
  Proc21_078A := False;
end;
{$F+}

{$F-}
procedure Proc21_0927;
begin
end;
{$F+}

{$F-}
procedure Proc21_0987(A0: Byte);
begin
end;
{$F+}

{$F-}
function Proc21_0CB6(Value: Byte; RowOrigin, ColOrigin: Integer; RowSpan, ColSpan: Byte): Boolean;
var
  I, J: Integer;
  Ok: Boolean;
begin
  Proc21_0CB6 := False;
  Ok := True;
  I := RowOrigin - 1;
  while (RowSpan + RowOrigin >= I) and Ok do
  begin
    Ok := False;
    J := ColOrigin - 3;
    while (ColSpan + ColOrigin - 1 + 3 >= J) and not Ok do
    begin
      if Proc6_1F93(I, J) and (MapTileA^[I, J] >= 10) and (MapTileA^[I, J] <= 58) and (G5514^[I, J] = Value) then
        Ok := True;
      Inc(J);
    end;
    Inc(I);
  end;
  if Ok then
    Proc21_0CB6 := True
  else
  begin
    Ok := True;
    J := ColOrigin - 1;
    while (ColSpan + ColOrigin >= J) and Ok do
    begin
      Ok := False;
      I := RowOrigin - 3;
      while (RowSpan + RowOrigin - 1 + 3 >= I) and not Ok do
      begin
        if Proc6_1F93(I, J) and (MapTileA^[I, J] >= 10) and (MapTileA^[I, J] <= 58) and (G5514^[I, J] = Value) then
          Ok := True;
        Inc(I);
      end;
      Inc(J);
    end;
    if Ok then
      Proc21_0CB6 := True;
  end;
end;
{$F+}

{$F-}
procedure Proc21_0E30;
begin
end;
{$F+}

{$F-}
procedure Proc21_0F67;
begin
end;
{$F+}

{$F-}
procedure Proc21_1098;
begin
end;
{$F+}

{$F-}
procedure Proc21_11F7;
begin
end;
{$F+}

{$F-}
procedure Proc21_1269;
begin
end;
{$F+}

{$F-}
procedure Proc21_1309;
begin
end;
{$F+}

{$F-}
function Proc21_13F6(A0: Byte): Boolean;
begin
  Proc21_13F6 := False;
end;
{$F+}

{$F-}
function Proc21_1454(A0: Byte): Boolean;
begin
  Proc21_1454 := False;
end;
{$F+}

{$F-}
procedure Proc21_14B2;
begin
end;
{$F+}

{$F-}
function Proc21_163B(A0: Byte): Word;
begin
  Proc21_163B := 0;
end;
{$F+}

{$F-}
function Proc21_173B(A0: Byte): Boolean;
begin
  Proc21_173B := False;
end;
{$F+}

{$F-}
function Proc21_1B0A(A0: Byte): Boolean;
begin
  Proc21_1B0A := False;
end;
{$F+}

{$F-}
procedure Proc21_1DED;
begin
end;
{$F+}

{$F-}
procedure Proc21_1F44;
begin
end;
{$F+}

{$F-}
function Proc21_2060(A0: Byte): Boolean;
begin
  Proc21_2060 := False;
end;
{$F+}

{$F-}
function Proc21_207B(A0: Byte): Boolean;
begin
  Proc21_207B := False;
end;
{$F+}

{$F-}
function Proc21_21DE(A0: Byte): Boolean;
begin
  Proc21_21DE := False;
end;
{$F+}

{$F-}
procedure Proc21_2463(A0: Byte);
const
  M11 = 'WLBNichtstun';
  M9 = 'WLBStartInselsuchen';
  M8 = 'WLBInselwechseln';
  M0 = 'WLBGebaeudeartauswaehlen';
  M1 = 'WLBGebaedewaehlen';
  M2 = 'WLBGebaeudeBauPunktsuchen';
  M3 = 'WLBGebaeudeBauPunktsuchen2';
  M4 = 'WLBGebaeudebauen';
  M5 = 'WLBBauplatzebenmachen';
  M6 = 'WLBBauplatzhoeheausgleichen';
  M7 = 'WLBStrassebauen';
  M10 = 'WLBStrassenBauPunktsuchen';
var
  N: Integer;
begin
  if PGuard21(G6F24)^[A0] <> 0 then Exit;
  case PByte21(G70C6)^[A0] of
    11:
      G70F2 := M11;
    9:
      begin
        G70F2 := M9;
        if Proc21_207B(A0) then
        begin
          PByte21(G70C6)^[A0] := 1;
          PByte21(G70CE)^[A0] := 0;
          PByte21(G70D2)^[A0] := 1;
          PByte21(G70D6)^[A0] := 1;
        end;
      end;
    8:
      begin
        G70F2 := M8;
        if Proc21_21DE(A0) then
        begin
          PCell12(G70DE)^[A0].B8 := 0;
          PByte21(G70C6)^[A0] := 1;
          PByte21(G70CE)^[A0] := 0;
          PByte21(G70D2)^[A0] := 1;
          PByte21(G70D6)^[A0] := 1;
        end
        else
        begin
          Inc(PCell12(G70DE)^[A0].B8);
          if PCell12(G70DE)^[A0].B8 >= $64 then
          begin
            PCell12(G70DE)^[A0].B8 := 0;
            PByte21(G70C6)^[A0] := 1;
            PByte21(G70CE)^[A0] := 0;
            PByte21(G70D2)^[A0] := 1;
            PByte21(G70D6)^[A0] := 1;
          end;
        end;
      end;
    0:
      begin
        G70F2 := M0;
        Proc21_0987(A0);
        PByte21(G70C6)^[A0] := 1;
      end;
    1:
      begin
        G70F2 := M1;
        if Proc21_078A(A0) then
        begin
          PByte21(G70C6)^[A0] := 2;
          PCell12(G70DE)^[A0].B2 := 0;
        end
        else
        begin
          PByte21(G70C6)^[A0] := 0;
          PByte21(G70CA)^[A0] := 4;
        end;
      end;
    2:
      begin
        G70F2 := M2;
        Inc(PCell12(G70DE)^[A0].B2);
        if PCell12(G70DE)^[A0].B2 >
          Proc6_0F53(8, PSel21(Sel10Board)^[PByte21(G70DA)^[A0] * 16].W10) * 4 then
        begin
          PByte21(G70C6)^[A0] := $a;
          if PByte21(G70CA)^[A0] <> 1 then
            PByte21(G70CA)^[A0] := 2;
        end
        else if Proc21_13F6(A0) then
          PByte21(G70C6)^[A0] := 3;
      end;
    3:
      begin
        G70F2 := M3;
        if Proc21_1454(A0) then
        begin
          PByte21(G70C6)^[A0] := 4;
          PCell12(G70DE)^[A0].B4 := 0;
        end
        else
          PByte21(G70C6)^[A0] := 2;
      end;
    4:
      begin
        G70F2 := M4;
        Inc(PCell12(G70DE)^[A0].B4);
        N := Proc21_163B(A0);
        if N = 0 then
        begin
          if PByte21(G70D2)^[A0] <> 0 then
          begin
            PByte21(G70CA)^[A0] := 2;
            PByte21(G70C6)^[A0] := $a;
            PByte21(G70D2)^[A0] := 0;
          end
          else
          begin
            PByte21(G70C6)^[A0] := 0;
            PByte21(G70CA)^[A0] := 2;
          end;
        end
        else if PCell12(G70DE)^[A0].B4 > 1 then
          PByte21(G70C6)^[A0] := 2
        else if N = $14 then
          PByte21(G70C6)^[A0] := 5
        else if N = $c then
          PByte21(G70C6)^[A0] := 6
        else
          PByte21(G70C6)^[A0] := 2;
      end;
    5:
      begin
        G70F2 := M5;
        if Proc21_173B(A0) then
          PByte21(G70C6)^[A0] := 4;
      end;
    6:
      begin
        G70F2 := M6;
        if Proc21_173B(A0) then
          PByte21(G70C6)^[A0] := 4;
      end;
    7:
      begin
        G70F2 := M7;
        if G634C = 0 then
        begin
          if Proc21_1B0A(A0) then
          begin
            if PByte21(G70CA)^[A0] <> 1 then
            begin
              PByte21(G70CA)^[A0] := 2;
              PByte21(G70C6)^[A0] := 0;
            end
            else
            begin
              PByte21(G70C6)^[A0] := 2;
              PCell12(G70DE)^[A0].B2 := 0;
            end;
            PCell12(G70DE)^[A0].B10 := 0;
            if PByte21(G70D6)^[A0] <> 0 then
              PByte21(G70D6)^[A0] := 0;
          end
          else
            PByte21(G70C6)^[A0] := $a;
        end;
      end;
    10:
      begin
        G70F2 := M10;
        Inc(PCell12(G70DE)^[A0].B10);
        if PCell12(G70DE)^[A0].B10 <= $14 then
        begin
          if Proc21_2060(A0) then
            PByte21(G70C6)^[A0] := 7;
        end
        else
        begin
          PCell12(G70DE)^[A0].B10 := 0;
          PByte21(G70C6)^[A0] := 8;
        end;
      end;
  end;
end;
{$F+}

{$F-}
procedure Proc21_2A60(A0: Byte);
begin
end;
{$F+}

{$F-}
function Proc21_2ADE(var X: TFit21; A0: Word): Boolean;
begin
  Proc21_2ADE := False;
end;
{$F+}

procedure Proc21_2CC1;
begin
end;

{$F-}
procedure Proc21_2D5A(A0: Byte);
const
  Msg2 = 'WLTNaechstenSchrittubelegen';
  Msg5 = 'WLTNaechstenSchritte';
  Msg4 = 'WLTNAbwarten';
  Msg3 = 'WLTNGebaudeverkauf';
var
  Spot: TCoord6;
  Hold: LongInt;
  V: TVar21;
  Tile: Byte;
begin
  if PGuard21(G6F24)^[A0] <> 0 then Exit;
  case PByte21(G70CA)^[A0] of
    0:
      Proc21_2463(A0);
    1:
      Proc21_2463(A0);
    2:
      begin
        G70F2 := Msg2;
        Proc21_2A60(A0);
        if (G6F28[A0 - 1] <> 0) and (Proc15_0191(A0) < 0) then
        begin
          if Random(100) < 1 then
            PByte21(G70CA)^[A0] := 5
          else
            PByte21(G70CA)^[A0] := 4;
        end
        else if Random(1000) < 1 then
          PByte21(G70CA)^[A0] := 5
        else
          PByte21(G70CA)^[A0] := 0;
      end;
    5:
      begin
        G70F2 := Msg5;
        Inc(G7070[A0]);
        if G7070[A0] > 1 then
        begin
          G7070[A0] := 0;
          if Proc21_2ADE(V.W, A0) then
          begin
            if Random(100) < 20 then
            begin
              Proc6_154C(V.W.Hi, V.W.Lo, Spot);
              Tile := MapTileMid^[Spot.X, Spot.Y];
              if Tile <> $FF then
              begin
                if PRec736E(G736E)^[Tile].A <= 10 then
                  Proc2_3006(9, A0, 0, PRec736E(G736E)^[Tile].C * 2, 0, Spot.Y, Spot.X)
                else
                  Proc2_3006(9, A0, 0, PRec736E(G736E)^[Tile].A div 4, 0, Spot.Y, Spot.X);
              end;
            end
            else
            begin
              Proc17_6975(V.W.Hi, V.W.Lo);
              Proc15_280B(V.Ptr, A0);
              Proc17_6C5A(V.W.Hi, V.W.Lo);
            end;
            PByte21(G70CA)^[A0] := 2;
          end
          else
            PByte21(G70CA)^[A0] := 4;
        end;
      end;
    4:
      begin
        G70F2 := Msg4;
        Inc(G7060[A0]);
        if G7060[A0] > 10 then
        begin
          G7060[A0] := 0;
          PByte21(G70CA)^[A0] := 2;
        end;
      end;
    3:
      G70F2 := Msg3;
  end;
end;
{$F+}

procedure Proc21_302E;
begin
end;

procedure Proc21_3080;
begin
end;

procedure Proc21_32EC;
begin
end;

procedure Proc21_3558;
begin
end;

{$F-}
procedure Proc21_37DA;
begin
end;
{$F+}

procedure Proc21_388B;
begin
end;

procedure Proc21_3A6C;
begin
end;

{$F-}
function Proc21_0582(P: PFitting21; Amount, Code: Byte): Boolean;
var
  Ok: Boolean;
begin
  Ok := True;
  case Code of
    0:
      if (250 - Amount) >= P^.Hi then
        P^.Hi := Amount + P^.Hi
      else
        Ok := False;
    1:
      if (250 - Amount) >= P^.Lo then
        P^.Lo := Amount + P^.Lo
      else
        Ok := False;
    2:
      if Amount <= P^.Hi then
        P^.Hi := P^.Hi - Amount
      else
        Ok := False;
    3:
      if Amount <= P^.Lo then
        P^.Lo := P^.Lo - Amount
      else
        Ok := False;
  else
    Ok := False;
  end;
  Proc21_0582 := Ok;
end;
{$F+}
procedure CallersInit21;
var
  ClampRec: TFit21;
begin
  ClampRec.Lo := 0;
  ClampRec.Hi := 0;
  if Proc21_0582(@ClampRec, 1, 0) then
    ClampRec.Lo := 1;
  if Proc21_0CB6(1, 1, 0, 0, 0) then
    ClampRec.Hi := 1;
  Proc21_2D5A(1);
end;

begin
  CallersInit21;
end.
