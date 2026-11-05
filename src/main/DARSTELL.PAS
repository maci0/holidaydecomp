unit DARSTELL;
{ Reconstructed scaffold, holiday.exe code segment 10 (16036 bytes).
  This is unit; the original kept its forms inside the segment's own  unit (docs/tree.md).
  Evidence: darstell.dat, links TPrinter (Printers unit).
  `uses` comes from this segment's relocation records, the class members
  from RTTI and form streams. Recovered free bodies are listed in the
  implementation; the other bodies are not recovered. }
{$F+}
interface

uses ExtCtrls, Graphics, Classes, SysUtils;

type
  PPChar10 = ^PChar;
  TRec10 = packed record
    K: Byte;
    P1: array[1..5] of Byte;
    F6: Byte;
    F7: Byte;
    F8: Byte;
    F9: Byte;
    FA: Byte;
    FB: Byte;
    W0C: Integer;
    Rest: array[0..7] of Byte;
  end;
  PRec10 = ^TRec10;
  TRow16 = packed record
    F0, F1, F2, F3, F4, F5: Byte;
    F6, F7, F8, F9: Byte;
    FA, FB: Byte;
    W0C: Integer;
    Rest: array[0..1] of Byte;
  end;
  TArr16 = array[0..255] of TRow16;
  PSel16 = ^TArr16;
function Hit10(A, B, C, D, E, F: Word): Boolean;
function Proc10_0997(R: PRec10; X: Byte): Byte;
function StubF19(V: LongInt): Word;
function StubF53(V: LongInt): Word;
procedure CallE68Const;
procedure GuardedSpan10(N: Integer; M: Word);
procedure MaybeCall10(N: Word);
procedure MaybeCallNeg10(N: Integer);
procedure Proc10_0002(A0: ShortInt);
procedure Proc10_0074(A0: ShortInt);
procedure Proc10_0144(A0, A1: Word);
procedure Proc10_075E(A0, A1: Word);
procedure Proc10_0E68(A0, A1, A2: Word);
procedure Proc10_21F9(A0, A1, A2, A3: Word);
procedure Proc10_245B(A0, A1: Word);
procedure Proc10_264D(A0, A1, A2, A3: Word);
procedure Proc10_2697(A0: Word);
procedure Proc10_26AE(A0: Word);
procedure Proc10_26C8(A0, A1: Word);
procedure Proc10_2700;
procedure Proc10_271B;
procedure Proc10_2D4C;
procedure Proc10_2DF8;
procedure Proc10_2EAA(A0, A1: Word);
procedure Proc10_313A(A0, A1: Word);
procedure Proc10_3529(A0, A1, A2, A3, A4, A5, A6, A7, A8: Word);
procedure Proc10_35A0(A0, A1, A2: Word);
procedure Proc10_35E2(A0, A1, A2, A3, A4, A5, A6, A7: Word);
procedure Proc10_3644(A0, A1, A2: Word);
procedure Proc10_3682(A0, A1, A2: Word);
procedure Proc10_36F3(A0, A1, A2: Word);
procedure Proc10_383C(A0, A1, A2: Word);
procedure Proc10_3863(A0, A1: Word);
procedure Proc10_38B1(A0, A1, A2, A3, A4, A5, A6, A7, A8: Word);
procedure Proc10_3B4E(A0, A1: Word);
procedure Proc10_3B8D(A0, A1: Word);
procedure Proc10_3D7B(A0, A1: Word);
procedure Proc10_3DD3(A0, A1: Word);
procedure Proc10_3E49(A0, A1: Word);
procedure Proc10_3E6B;
procedure Proc10_3E7B;
procedure StubE68(A, B, C: Word);


implementation

uses GFX, MAP, DataVal;

function Hit10(A, B, C, D, E, F: Word): Boolean;
begin
  Hit10 := (F <= $13) and (E >= 0) and (A * 9 div 32 + 1 <= C)
    and (B * 9 div 32 + $2A >= D);
end;

{$F-}
function Near0811(A, B, C: Byte): Byte;
var
  Tmp: Word;
begin
  case Pred7c of
    0: Tmp := C;
    1: Tmp := (C div A) + B * ((A - 1) - (C mod A));
    2: Tmp := A * B - 1 - C;
    3: Tmp := (B - 1) - (C div A) + B * (C mod A);
  end;
  Near0811 := Tmp;
end;
{$F+}

function Proc10_0997(R: PRec10; X: Byte): Byte;
begin
  case R^.K of
    $b: Proc10_0997 := TblA[Pred7c * 4 + X];
    $34: Proc10_0997 := TblB[Pred7c * 6 + X];
    0, $15, $0c, $1f, $24: Proc10_0997 := X;
  else
    begin
    Proc10_0997 := Near0811(PSel16(Sel10Board)^[R^.K].F6, PSel16(Sel10Board)^[R^.K].F8, X mod PSel16(Sel10Board)^[R^.K].W0C);
    case Pred7c of
      1, 3: R^.K := PSel16(Sel10Board)^[R^.K].F2;
    end;
    case Pred7c of
      2, 1:
        case R^.K of
          $28: R^.K := $51;
          $2c: R^.K := $53;
          $30: R^.K := $55;
        end;
    end;
    case Pred7c of
      2, 3:
        case R^.K of
          $29: R^.K := $52;
          $2d: R^.K := $54;
          $31: R^.K := $56;
        end;
    end;
    case Pred7c of
      2:
      case R^.K of
      $58: R^.K := $5a;
      $59: R^.K := $5b;
      $5a: R^.K := $58;
      $5b: R^.K := $59;
      $5c: R^.K := $5e;
      $5d: R^.K := $5f;
      $5e: R^.K := $5c;
      $5f: R^.K := $5d;
      $60: R^.K := $62;
      $61: R^.K := $63;
      $62: R^.K := $60;
      $63: R^.K := $61;
      $64: R^.K := $66;
      $65: R^.K := $67;
      $66: R^.K := $64;
      $67: R^.K := $65;
      $68: R^.K := $6a;
      $69: R^.K := $6b;
      $6a: R^.K := $68;
      $6b: R^.K := $69;
      $71: R^.K := $73;
      $72: R^.K := $74;
      $73: R^.K := $71;
      $74: R^.K := $72;
      $75: R^.K := $77;
      $76: R^.K := $78;
      $77: R^.K := $75;
      $78: R^.K := $76;
      end;
      3:
      case R^.K of
      $58: R^.K := $5b;
      $59: R^.K := $58;
      $5a: R^.K := $59;
      $5b: R^.K := $5a;
      $5c: R^.K := $5f;
      $5d: R^.K := $5c;
      $5e: R^.K := $5d;
      $5f: R^.K := $5e;
      $60: R^.K := $63;
      $61: R^.K := $60;
      $62: R^.K := $61;
      $63: R^.K := $62;
      $64: R^.K := $67;
      $65: R^.K := $64;
      $66: R^.K := $65;
      $67: R^.K := $66;
      $68: R^.K := $6b;
      $69: R^.K := $68;
      $6a: R^.K := $69;
      $6b: R^.K := $6a;
      $71: R^.K := $74;
      $72: R^.K := $71;
      $73: R^.K := $72;
      $74: R^.K := $73;
      $75: R^.K := $78;
      $76: R^.K := $75;
      $77: R^.K := $76;
      $78: R^.K := $77;
      end;
      1:
      case R^.K of
      $58: R^.K := $59;
      $59: R^.K := $5a;
      $5a: R^.K := $5b;
      $5b: R^.K := $58;
      $5c: R^.K := $5d;
      $5d: R^.K := $5e;
      $5e: R^.K := $5f;
      $5f: R^.K := $5c;
      $60: R^.K := $61;
      $61: R^.K := $62;
      $62: R^.K := $63;
      $63: R^.K := $60;
      $64: R^.K := $65;
      $65: R^.K := $66;
      $66: R^.K := $67;
      $67: R^.K := $64;
      $68: R^.K := $69;
      $69: R^.K := $6a;
      $6a: R^.K := $6b;
      $6b: R^.K := $68;
      $71: R^.K := $72;
      $72: R^.K := $73;
      $73: R^.K := $74;
      $74: R^.K := $71;
      $75: R^.K := $76;
      $76: R^.K := $77;
      $77: R^.K := $78;
      $78: R^.K := $75;
      end;
    end;
    end;
  end;
end;


{$F-}
function Proc10_21B7(A, B, C, D, E, F: Integer): Boolean;
begin
  Proc10_21B7 := (A <= $13) and (B >= 0)
    and (((F * 9) div 32) + 1 <= D)
    and (((E * 9) div 32) + $2A >= C);
end;
{$F+}

{$F-}
function Proc10_341C(Cursor: PPChar10): PChar;
var
  Start, Walk: PChar;
begin
  Start := Cursor^;
  if Cursor^ <> nil then
  begin
    Walk := Cursor^;
    while Walk^ = ' ' do
      Inc(Walk);
    Start := Walk;
    while (Walk^ <> #0) and (Walk^ <> ',') do
      Inc(Walk);
    if Walk^ = ',' then
    begin
      Walk^ := #0;
      Inc(Walk);
    end;
    Cursor^ := Walk;
  end;
  Proc10_341C := Start;
end;
{$F+}

function StubF19(V: LongInt): Word;
begin
  StubF19 := 0;
end;

function StubF53(V: LongInt): Word;
begin
  StubF53 := 0;
end;

procedure CallE68Const;
begin
  StubE68(0, $13, 0);
end;

procedure GuardedSpan10(N: Integer; M: Word);
begin
  if (N >= 0) and (M <= $13) then
    StubE68(0, StubF19(M), StubF53(N));
end;

procedure MaybeCall10(N: Word);
begin
  if N > 0 then
    StubE68(0, $13, N);
end;

procedure MaybeCallNeg10(N: Integer);
begin
  if N > 0 then
    StubE68(0, $13, -N);
end;

procedure Proc10_0002;
begin
end;

procedure Proc10_0074;
begin
end;

procedure Proc10_0144;
begin
end;

procedure Proc10_075E;
begin
end;

procedure Proc10_0E68(A0, A1, A2: Word);
begin
end;

procedure Proc10_21F9;
begin
end;

procedure Proc10_245B;
begin
end;

procedure Proc10_264D(A0, A1, A2, A3: Word);
begin
end;

procedure Proc10_2697;
begin
end;

procedure Proc10_26AE;
begin
end;

procedure Proc10_26C8;
begin
end;

procedure Proc10_2700;
begin
end;

procedure Proc10_271B;
begin
end;

procedure Proc10_2D4C;
begin
end;

procedure Proc10_2DF8;
begin
end;

procedure Proc10_2EAA;
begin
end;

procedure Proc10_313A;
begin
end;

{$F-}
procedure Proc10_34A9;
begin
end;
{$F+}

{$F-}
procedure Proc10_34D6;
begin
end;
{$F+}

procedure Proc10_3529;
begin
end;

procedure Proc10_35A0;
begin
end;

procedure Proc10_35E2;
begin
end;

procedure Proc10_3644;
begin
end;

procedure Proc10_3682;
begin
end;

procedure Proc10_36F3;
begin
end;

procedure Proc10_383C;
begin
end;

procedure Proc10_3863;
begin
end;

procedure Proc10_38B1;
begin
end;

procedure Proc10_3B4E;
begin
end;

procedure Proc10_3B8D;
begin
end;

procedure Proc10_3D7B;
begin
end;

procedure Proc10_3DD3;
begin
end;

procedure Proc10_3E49;
begin
end;

procedure Proc10_3E6B;
begin
end;

procedure Proc10_3E7B;
begin
end;

procedure StubE68(A, B, C: Word);
begin
end;
procedure CallersInit10;
var
  SplitAt: PChar;
  SplitCursor: PPChar10;
begin
  if Hit10(1, 2, 3, 4, 5, 6) then Hit10(0, 0, 0, 0, 0, 0);
  CallE68Const;
  SplitAt := nil;
  SplitCursor := @SplitAt;
  if Proc10_341C(SplitCursor) = nil then SplitAt := nil;
  if Proc10_21B7(1, 0, 0, 0, 0, 0) then SplitAt := SplitAt;
  Proc10_0997(@Map0, 0);
end;

begin
  CallersInit10;
end.
