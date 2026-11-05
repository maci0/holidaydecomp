unit MENU;
{ Reconstructed scaffold, holiday.exe code segment 16 (15517 bytes).
  This is form unit for Tumenuform; the original kept its forms inside the segment's own  unit
  (docs/tree.md).
  Evidence: form Tumenuform, 1 components.
  `uses` comes from this segment's relocation records, the class members
  from RTTI and form streams. Recovered free bodies are listed in the
  implementation; the other bodies are not recovered. }
{$F+}
interface

uses ExtCtrls, Graphics, Controls, Forms, Classes, SysUtils;

type
  TDisp16 = packed record
    Pad: array[0..$1F] of Byte;
    Handler: function(A0, A1: Word; A2, A3: Pointer): Boolean;
  end;
  PDisp16 = ^TDisp16;
  TItem16 = packed record
    Pad: array[0..8] of Byte;
    Disp: PDisp16;
    Rest: array[0..264] of Byte;
  end;
  PItem16 = ^TItem16;
  TThing16 = packed record
    Pad: array[0..1] of Byte;
  end;
  PThing16 = ^TThing16;
  TOuter16 = packed record
    Pad0: array[0..$17B] of Byte;
    F17C: PThing16;
    Pad180: array[0..59] of Byte;
    Items: array[0..4] of TItem16;
    B72A: Byte;
    Pad72B: array[0..7] of Byte;
    W733: Word;
    B735: Byte;
    Pad736: array[0..3] of Byte;
    Obj73A: Byte;
  end;
  POuter16 = ^TOuter16;

procedure Proc16_0123;
procedure Proc16_014C(A0, A1: Word);
procedure Proc16_017F(A0, A1: Word);
procedure Proc16_01B2(A0, A1: Word);
procedure Proc16_0235(A0, A1: Word);
procedure Proc16_02BC(A0, A1: Word);
procedure Proc16_02D9(A0: Word);
procedure Proc16_0BE9(A0, A1: Word);
procedure Proc16_0E8B(A0, A1: Word);
procedure Far56CE(A0: Pointer);
procedure Proc16_0E92(A0: Pointer);
procedure Proc16_0EA8(A0, A1: Word);
procedure Proc16_1141(A0, A1: Word);
procedure Proc16_145F(A0, A1: Word);
procedure Proc16_1B24(A0, A1: Word);
procedure Proc16_1C3B(A0, A1, A2, A3, A4, A5, A6, A7: Word);
procedure Proc16_1E54(A0, A1, A2, A3, A4, A5, A6: Word);
function Far15F7(A0, A1: Word; A2, A3: Pointer): Boolean;
procedure Far22C6(var A0);
procedure Far17E1(A0: Word; A1: Pointer);
procedure Proc16_1F18(A0, A1, A2, A3, A4, A5: Word; P: POuter16);
procedure Proc16_202B(A0, A1, A2, A3, A4, A5, A6: Word);
procedure Far3199(A0, A1: Byte);
procedure Proc16_2831(A0, A1: Word);
function Proc16_29D8(A0, A1: Word): Boolean;
function Proc16_2A82(A0, A1: Word): Boolean;
procedure Proc16_2B0C(A0, A1: Word);
procedure Proc16_302A(A0, A1: Word);
procedure Proc16_3195;
procedure Proc16_31ED;
procedure Proc16_3216(A0, A1, A2, A3, A4, A5, A6, A7, A8, A9, A10: Word);
procedure Proc16_3C3C(A0, A1: Word);
procedure Proc16_3C6D(A0, A1: Word);


type
  Tumenuform = class(TForm)
    bild: TImage;
  private
    { shortcut: opaque private storage; name fields as accesses are recovered. }
    UnrecoveredState: array[0..1527] of Byte;
  published
    procedure BildMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure BildMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure BildMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  end;

implementation

uses THINTERG, TDUMMYFO, DATEN, BAUFEN, DATWIN, GFX, SEG15, SOUND, MAP, SEG24;

{ ADDRESS: MAIN 0x00100123 }
procedure Proc16_0123;
begin
end;

{ ADDRESS: MAIN 0x0010014c }
procedure Proc16_014C;
begin
end;

{ ADDRESS: MAIN 0x0010017f }
procedure Proc16_017F;
begin
end;

{ ADDRESS: MAIN 0x001001b2 }
procedure Proc16_01B2;
begin
end;

{ ADDRESS: MAIN 0x00100235 }
procedure Proc16_0235;
begin
end;

{ ADDRESS: MAIN 0x001002bc }
procedure Proc16_02BC;
begin
end;

{ ADDRESS: MAIN 0x001002d9 }
procedure Proc16_02D9;
begin
end;

{ ADDRESS: MAIN 0x00100be9 }
procedure Proc16_0BE9;
begin
end;

{$F-}
{ ADDRESS: MAIN 0x00100bfb }
procedure Proc16_0BFB;
begin
end;
{$F+}

{ ADDRESS: MAIN 0x00100e8b }
procedure Proc16_0E8B;
begin
end;

procedure Far56CE(A0: Pointer);
begin
end;

{ ADDRESS: MAIN 0x00100e92 }
procedure Proc16_0E92;
begin
  Far56CE(A0);
end;

{ ADDRESS: MAIN 0x00100ea8 }
procedure Proc16_0EA8;
begin
end;

{ ADDRESS: MAIN 0x00101141 }
procedure Proc16_1141;
begin
end;

{ ADDRESS: MAIN 0x0010145f }
procedure Proc16_145F;
begin
end;

{ ADDRESS: MAIN 0x00101b24 }
procedure Proc16_1B24;
begin
end;

procedure Proc16_1C3B;
begin
end;

procedure Proc16_1E54;
begin
end;

function Far15F7(A0, A1: Word; A2, A3: Pointer): Boolean;
begin
  Far15F7 := False;
end;

procedure Far22C6(var A0);
begin
end;

procedure Far17E1(A0: Word; A1: Pointer);
begin
end;

procedure Proc16_1F18(A0, A1, A2, A3, A4, A5: Word; P: POuter16);
begin
  if Far15F7(A4, A5, P^.F17C, @P^.Obj73A) or
     P^.Items[0].Disp^.Handler(A4, A5, P^.F17C, @P^.Items[0]) or
     P^.Items[1].Disp^.Handler(A4, A5, P^.F17C, @P^.Items[1]) or
     P^.Items[2].Disp^.Handler(A4, A5, P^.F17C, @P^.Items[2]) or
     P^.Items[3].Disp^.Handler(A4, A5, P^.F17C, @P^.Items[3]) or
     P^.Items[4].Disp^.Handler(A4, A5, P^.F17C, @P^.Items[4]) then
    Far22C6(P^.F17C^)
  else if (P^.B72A <> 0) and (P^.B735 = 0) then
    Far17E1(P^.W733, P);
end;

procedure Proc16_202B;
begin
end;

{$F-}
{ ADDRESS: MAIN 0x001022be }
function Proc16_22BE(A0, A1: Word): Word;
begin
  case Proc0_3E0D(A0, A1) of
    0: Proc16_22BE := 0;
    1: Proc16_22BE := $0F;
    2: Proc16_22BE := $5F;
    3: Proc16_22BE := $5F;
    4, 5: Proc16_22BE := $1E;
  else
    Proc16_22BE := 0;
  end;
end;
{$F+}

procedure Far3199(A0, A1: Byte);
begin
end;

{$F-}
{ ADDRESS: MAIN 0x0010232a }
function Proc16_232A(A0, A1: Word): Word;
var
  N: Word;
  M: Word;
begin
  N := 0;
  if Proc0_3E0D(A0, A1) >= $37 then
  begin
    M := Proc0_3E0D(A0, A1);
    case Proc0_3E0D(A0, A1) of
      $3B:
      begin
        M := $37;
        MapTileMid^[A0, A1] := $0B;
        G5510^[A0, A1] := 0;
      end;
      $3C:
      begin
        M := $39;
        MapTileMid^[A0, A1] := $0B;
        G5510^[A0, A1] := 2;
      end;
      $3D:
      begin
        M := $38;
        MapTileMid^[A0, A1] := $0B;
        G5510^[A0, A1] := 1;
      end;
      $3E:
      begin
        M := $3A;
        MapTileMid^[A0, A1] := $0B;
        G5510^[A0, A1] := 3;
      end;
    end;
    Proc16_232A := M;
  end
  else
  begin
    Far3199(Lo(A0), Lo(A1));
    if ((Proc0_3E0D(A0 + 1, A1) >= $0A) and (Proc0_3E0D(A0 + 1, A1) <= $3A)) or
       ((Proc0_3E0D(A0 + 1, A1) >= $5F) and (Proc0_3E0D(A0 + 1, A1) <= $64)) then
      N := N + 1;
    if ((Proc0_3E0D(A0, A1 + 1) >= $0A) and (Proc0_3E0D(A0, A1 + 1) <= $3A)) or
       ((Proc0_3E0D(A0, A1 + 1) >= $5F) and (Proc0_3E0D(A0, A1 + 1) <= $64)) then
      N := N + 2;
    if ((Proc0_3E0D(A0 - 1, A1) >= $0A) and (Proc0_3E0D(A0 - 1, A1) <= $3A)) or
       ((Proc0_3E0D(A0 - 1, A1) >= $5F) and (Proc0_3E0D(A0 - 1, A1) <= $64)) then
      N := N + 4;
    if ((Proc0_3E0D(A0, A1 - 1) >= $0A) and (Proc0_3E0D(A0, A1 - 1) <= $3A)) or
       ((Proc0_3E0D(A0, A1 - 1) >= $5F) and (Proc0_3E0D(A0, A1 - 1) <= $64)) then
      N := N + 8;
    case N of
      0: M := $0A;
      1: M := $0B;
      2: M := $0A;
      3: M := $13;
      4: M := $0B;
      5: M := $0B;
      6: M := $12;
      7: M := $0D;
      8: M := $0A;
      9: M := $14;
      10: M := $0A;
      11: M := $0E;
      12: M := $11;
      13: M := $0F;
      14: M := $0C;
      15: M := $10;
    end;
    Proc16_232A := Proc16_22BE(A0, A1) + M;
  end;
end;
{$F+}

{$F-}
{ ADDRESS: MAIN 0x0010261a }
function Proc16_261A(A0, A1: Word): Word;
var
  N: Word;
  M: Word;
begin
  N := 0;
  M := Proc0_3E0D(A0, A1);
  case Proc0_3E8D(A0, A1) of
    $10:
      if (((Proc0_3ED1(A0 + 1, A1) = 4) or (Proc0_3ED1(A0 + 1, A1) = 0) or
           (Proc0_3ED1(A0 + 1, A1) = 2)) and
          (Proc0_3E0D(A0 + 1, A1) >= $5F) and
          (Proc0_3E0D(A0 + 1, A1) <= $64)) or
         (((Proc0_3ED1(A0 - 1, A1) = 4) or (Proc0_3ED1(A0 - 1, A1) = 0) or
           (Proc0_3ED1(A0 - 1, A1) = 2)) and
          (Proc0_3E0D(A0 - 1, A1) >= $5F) and
          (Proc0_3E0D(A0 - 1, A1) <= $64)) then
      begin
        M := $63;
        MapTileMid^[A0, A1] := $34;
        G5510^[A0, A1] := 4;
      end
      else
      begin
        M := $64;
        MapTileMid^[A0, A1] := $34;
        G5510^[A0, A1] := 5;
      end;
    0:
    begin
      M := $5F;
      MapTileMid^[A0, A1] := $34;
      G5510^[A0, A1] := 0;
    end;
    1:
    begin
      M := $60;
      MapTileMid^[A0, A1] := $34;
      G5510^[A0, A1] := 1;
    end;
    2:
    begin
      M := $61;
      MapTileMid^[A0, A1] := $34;
      G5510^[A0, A1] := 2;
    end;
    3:
    begin
      M := $62;
      MapTileMid^[A0, A1] := $34;
      G5510^[A0, A1] := 3;
    end;
  end;
  Proc16_261A := M;
end;
{$F+}

{ ADDRESS: MAIN 0x00102831 }
procedure Proc16_2831;
begin
end;

{ ADDRESS: MAIN 0x001029d8 }
function Proc16_29D8(A0, A1: Word): Boolean;
begin
  if ((Proc0_3DC9(A0, A1) = $FF) or (Proc0_3DC9(A0, A1) = $C)) and
     ((Proc0_3E0D(A0, A1) <> 3) and (Proc0_3E0D(A0, A1) <> 2)) then
    if (Proc0_3E8D(A0, A1) = $10) or (Proc0_3E8D(A0, A1) = 0) or
       (Proc0_3E8D(A0, A1) = 1) or (Proc0_3E8D(A0, A1) = 2) or
       (Proc0_3E8D(A0, A1) = 3) then
      Proc16_29D8 := True
    else
      Proc16_29D8 := False
  else
    Proc16_29D8 := False;
end;

{ ADDRESS: MAIN 0x00102a82 }
function Proc16_2A82(A0, A1: Word): Boolean;
begin
  if (Proc0_3E0D(A0, A1) = 3) or (Proc0_3E0D(A0, A1) = 2) then
    if (Proc0_3E8D(A0, A1) = $10) or (Proc0_3E8D(A0, A1) = 0) or
       (Proc0_3E8D(A0, A1) = 1) or (Proc0_3E8D(A0, A1) = 2) or
       (Proc0_3E8D(A0, A1) = 3) then
      Proc16_2A82 := True
    else
      Proc16_2A82 := False
  else
    Proc16_2A82 := False;
end;

{ ADDRESS: MAIN 0x00102b0c }
procedure Proc16_2B0C(A0, A1: Word);
begin
  if Proc16_29D8(A0, A1) then
  begin
    if Proc0_3E8D(A0, A1) = $10 then
    begin
      G5510^[A0, A1] := 0;
      MapTileMid^[A0, A1] := $FF;
      MapTileA^[A0, A1] := Proc16_232A(A0, A1);
    end;
    if Proc0_3E8D(A0, A1) = 0 then
    begin
      G5510^[A0, A1] := 0;
      MapTileMid^[A0, A1] := $FF;
      MapTileA^[A0, A1] := Proc16_22BE(A0, A1) + $15;
    end;
    if Proc0_3E8D(A0, A1) = 1 then
    begin
      G5510^[A0, A1] := 0;
      MapTileMid^[A0, A1] := $FF;
      MapTileA^[A0, A1] := Proc16_22BE(A0, A1) + $16;
    end;
    if Proc0_3E8D(A0, A1) = 2 then
    begin
      G5510^[A0, A1] := 0;
      MapTileMid^[A0, A1] := $FF;
      MapTileA^[A0, A1] := Proc16_22BE(A0, A1) + $17;
    end;
    if Proc0_3E8D(A0, A1) = 3 then
    begin
      G5510^[A0, A1] := 0;
      MapTileMid^[A0, A1] := $FF;
      MapTileA^[A0, A1] := Proc16_22BE(A0, A1) + $18;
    end;
    if (Proc0_3E8D(A0 + 1, A1) = $10) and (Proc0_3E0D(A0 + 1, A1) >= $0A) and
       (Proc0_3E0D(A0 + 1, A1) <= $3A) then
      MapTileA^[A0 + 1, A1] := Proc16_232A(A0 + 1, A1);
    if (Proc0_3E8D(A0 - 1, A1) = $10) and (Proc0_3E0D(A0 - 1, A1) >= $0A) and
       (Proc0_3E0D(A0 - 1, A1) <= $3A) then
      MapTileA^[A0 - 1, A1] := Proc16_232A(A0 - 1, A1);
    if (Proc0_3E8D(A0, A1 + 1) = $10) and (Proc0_3E0D(A0, A1 + 1) >= $0A) and
       (Proc0_3E0D(A0, A1 + 1) <= $3A) then
      MapTileA^[A0, A1 + 1] := Proc16_232A(A0, A1 + 1);
    if (Proc0_3E8D(A0, A1 - 1) = $10) and (Proc0_3E0D(A0, A1 - 1) >= $0A) and
       (Proc0_3E0D(A0, A1 - 1) <= $3A) then
      MapTileA^[A0, A1 - 1] := Proc16_232A(A0, A1 - 1);
    MapTile1^[A0, A1] := $FF;
    MapTile2^[A0, A1] := $FF;
  end;
end;

{$F-}
{ ADDRESS: MAIN 0x00102e6a }
procedure Proc16_2E6A(A0, A1: Word);
begin
  if Proc16_2A82(A0, A1) then
  begin
    MapTileA^[A0, A1] := Proc16_261A(A0, A1);
    MapTile1^[A0, A1] := $FF;
    MapTile2^[A0, A1] := $FF;
  end
  else
  begin
    if (Proc0_3E8D(A0 + 1, A1) = $10) and (Proc0_3E0D(A0 + 1, A1) >= $0A) and
       (Proc0_3E0D(A0 + 1, A1) <= $3A) then
      MapTileA^[A0 + 1, A1] := Proc16_232A(A0 + 1, A1);
    if (Proc0_3E8D(A0 - 1, A1) = $10) and (Proc0_3E0D(A0 - 1, A1) >= $0A) and
       (Proc0_3E0D(A0 - 1, A1) <= $3A) then
      MapTileA^[A0 - 1, A1] := Proc16_232A(A0 - 1, A1);
    if (Proc0_3E8D(A0, A1 + 1) = $10) and (Proc0_3E0D(A0, A1 + 1) >= $0A) and
       (Proc0_3E0D(A0, A1 + 1) <= $3A) then
      MapTileA^[A0, A1 + 1] := Proc16_232A(A0, A1 + 1);
    if (Proc0_3E8D(A0, A1 - 1) = $10) and (Proc0_3E0D(A0, A1 - 1) >= $0A) and
       (Proc0_3E0D(A0, A1 - 1) <= $3A) then
      MapTileA^[A0, A1 - 1] := Proc16_232A(A0, A1 - 1);
  end;
end;
{$F+}

{ ADDRESS: MAIN 0x0010302a }
procedure Proc16_302A(A0, A1: Word);
begin
  if (Proc0_3E8D(A0 + 1, A1) = $10) and (Proc0_3E0D(A0 + 1, A1) >= $0A) and
     (Proc0_3E0D(A0 + 1, A1) <= $3A) then
    MapTileA^[A0 + 1, A1] := Proc16_232A(A0 + 1, A1);
  if (Proc0_3E8D(A0 - 1, A1) = $10) and (Proc0_3E0D(A0 - 1, A1) >= $0A) and
     (Proc0_3E0D(A0 - 1, A1) <= $3A) then
    MapTileA^[A0 - 1, A1] := Proc16_232A(A0 - 1, A1);
  if (Proc0_3E8D(A0, A1 + 1) = $10) and (Proc0_3E0D(A0, A1 + 1) >= $0A) and
     (Proc0_3E0D(A0, A1 + 1) <= $3A) then
    MapTileA^[A0, A1 + 1] := Proc16_232A(A0, A1 + 1);
  if (Proc0_3E8D(A0, A1 - 1) = $10) and (Proc0_3E0D(A0, A1 - 1) >= $0A) and
     (Proc0_3E0D(A0, A1 - 1) <= $3A) then
    MapTileA^[A0, A1 - 1] := Proc16_232A(A0, A1 - 1);
end;

{ ADDRESS: MAIN 0x00103195 }
procedure Proc16_3195;
begin
end;

{ ADDRESS: MAIN 0x001031ed }
procedure Proc16_31ED;
begin
end;

{ ADDRESS: MAIN 0x00103216 }
procedure Proc16_3216;
begin
end;

{ ADDRESS: MAIN 0x00103c3c }
procedure Proc16_3C3C;
begin
end;

{ ADDRESS: MAIN 0x00103c6d }
procedure Proc16_3C6D;
begin
end;

{ ADDRESS: MAIN 0x00101c3b }
procedure Tumenuform.BildMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
end;

{ ADDRESS: MAIN 0x00101e54 }
procedure Tumenuform.BildMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
end;

{ ADDRESS: MAIN 0x00101f18 }
procedure Tumenuform.BildMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
end;

{ ADDRESS: MAIN 0x0010202b }
procedure Tumenuform.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
end;

begin
  if Proc16_29D8(1, 2) then;
  if Proc16_2A82(1, 2) then;
  if Proc16_22BE(1, 2) <> 0 then;
  if Proc16_261A(1, 2) <> 0 then;
  if Proc16_232A(1, 2) <> 0 then;
  Proc16_2E6A(1, 2);
  Proc16_302A(1, 2);
  Proc16_2B0C(1, 2);
  Proc16_1F18(1, 2, 3, 4, 5, 6, nil);
end.
