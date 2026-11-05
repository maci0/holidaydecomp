unit TDUMMYFO;
{ Reconstructed scaffold, holiday.exe code segment 0 (16333 bytes).
  This is form unit for TDummyForm; the original kept its forms inside the segment's own  unit
  (docs/tree.md).
  Evidence: form TDummyForm, 1 components.
  `uses` comes from this segment's relocation records, the class members
  from RTTI and form streams. Recovered free bodies are listed in the
  implementation; the other bodies are not recovered. }
{$F+}
interface

uses MPlayer, Buttons, ExtCtrls, Graphics, Controls, Forms, Classes, SysUtils;

procedure Proc0_0043;
procedure Proc0_0243(A0, A1: Word);
procedure Proc0_032E(var A0: file);
procedure Proc0_0C6A(A0, A1: Word);
procedure Proc0_17BC;
procedure Proc0_1E9B;
procedure Proc0_1EA0;
procedure Proc0_21A0;
procedure Proc0_2241(A0, A1, A2, A3: Word);
procedure Proc0_2254(A0, A1, A2, A3: Word);
procedure Proc0_2466(A0, A1, A2, A3: Word);
procedure Proc0_3938(A0, A1, A2, A3, A4, A5, A6: Word);
procedure Proc0_39B7(A0, A1, A2, A3: Word);
procedure Proc0_3A36(A0, A1, A2, A3: Word);
procedure Proc0_3A4D(A0, A1, A2, A3: Word);
procedure Proc0_3A77(A0, A1, A2, A3: Word);
procedure Proc0_3A8E(A0, A1, A2, A3, A4, A5: Word);
procedure Proc0_3AFF(A0, A1: Word);
procedure Proc0_3B06(A0, A1: Word);
procedure Proc0_3C01(var A0);
procedure Proc0_3CEC(A0, A1: Word);
procedure Proc0_3D0C(A0, A1, A2, A3, A4, A5, A6: Word);
function Proc0_3D54(A0, A1, A2: Word): Word;
procedure Proc0_3D9E(A0, A1: Word);
function Proc0_3DC9(A0, A1: Integer): Integer;
function Proc0_3E0D(A0, A1: Integer): Integer;
function Far0E60(A0, A1: Word; A2: Pointer; var A3): Pointer;
procedure Far1B39(A0: Pointer);
procedure Far16BE(A0: Pointer; A1: string);
procedure Far15E7S(A0: string; A1: Pointer; A2: Word);
function Far08E1(A0: string): Byte;
function Far08E1B: Byte;
function Far07BF(A0: string; A1, A2, A3, A4: Word): Integer;
procedure Far093;
procedure Far0625(A0: Pointer; A1: string);
procedure Far06AC(A0: Pointer);
procedure Far0A31(A0, A1: Pointer; A2: Word);
procedure Far08EF;
procedure Far070B(A0: Pointer);
procedure Proc0_3E51(A0, A1: Word);
function Proc0_3E8D(A0, A1: Integer): Integer;
function Proc0_3ED1(A0, A1: Word): Word;
function Proc0_3F15(A0, A1: Word): Word;
procedure Proc0_3F59(A0, A1, A2: Word);
procedure Proc0_3F7B(A0, A1, A2, A3, A4: Word);
procedure Proc0_3FAC(A0, A1: Word);


type
  TDummyForm = class(TForm)
    Bild: TImage;
  private
    { shortcut: opaque private storage; name fields as accesses are recovered. }
    UnrecoveredState: array[0..3] of Byte;
  published
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  end;

implementation

uses DATEN, BAUFEN, DATWIN, AUKTION, GFX, KOMPASS, HIGHSCOR, HAUS, DARSTELL, START, SCHLUSS, GELD,
  SEG15, MENU, SOUND, BAUEN, MAP, UEBERMAP, DataVal;

procedure Proc0_0043;
begin
end;

procedure Proc0_0243;
begin
end;

procedure Proc0_032E(var A0: file);
begin
  BlockWrite(A0, Pair0066[1], 1);
  BlockWrite(A0, G009E, 2);
  BlockWrite(A0, P6330, 4);
  BlockWrite(A0, P6334, 4);
  BlockWrite(A0, P6338, 4);
  BlockWrite(A0, Data0000_004E[6], 1);
  BlockWrite(A0, Data0000_004E[7], 1);
  BlockWrite(A0, Pair0056[1], 1);
  BlockWrite(A0, Pair0058, 1);
  BlockWrite(A0, Pair0058[1], 1);
  BlockWrite(A0, Pair005A, 1);
  BlockWrite(A0, Pair005A[1], 1);
  BlockWrite(A0, Pair0060[1], 1);
  BlockWrite(A0, Pair0060, 1);
  BlockWrite(A0, Pair005C, 1);
  BlockWrite(A0, Pair005C[1], 1);
  BlockWrite(A0, Pair005E, 1);
  BlockWrite(A0, Pair005E[1], 1);
  BlockWrite(A0, Pair0060[3], 1);
  BlockWrite(A0, Pair0060[4], 1);
  BlockWrite(A0, Pair0060[5], 1);
  BlockWrite(A0, Pair0066, 1);
  BlockWrite(A0, Pair0070[4], 8);
  BlockWrite(A0, Pred7c, 1);
  BlockWrite(A0, Pair0086, 1);
  BlockWrite(A0, Pair0086[1], 1);
  BlockWrite(A0, Pair008A, 2);
  BlockWrite(A0, Pair008E, 2);
  BlockWrite(A0, Pair0090, 2);
  BlockWrite(A0, Pair0092, 2);
  BlockWrite(A0, Pair0094, 2);
  BlockWrite(A0, G0096, 4);
  BlockWrite(A0, G009A, 2);
  BlockWrite(A0, Pair00A2, 2);
  BlockWrite(A0, Pair00A4, 2);
  BlockWrite(A0, Pair00A4[2], 1);
  BlockWrite(A0, Buf0102, 2048);
  BlockWrite(A0, Buf0902, 2304);
  BlockWrite(A0, B54FA, 1);
  BlockWrite(A0, Map0^, $F619);
  BlockWrite(A0, MapTileA^, $F619);
  BlockWrite(A0, MapTileMid^, $F619);
  BlockWrite(A0, MapTileC^, $F619);
  BlockWrite(A0, G5510^, $F619);
  BlockWrite(A0, G5514^, $F619);
  BlockWrite(A0, G5518^, $F619);
  BlockWrite(A0, MapTile1^, $F619);
  BlockWrite(A0, MapTile2^, $F619);
  BlockWrite(A0, G5524^, $3E04);
  BlockWrite(A0, HalfMap^, $F714);
  BlockWrite(A0, W552C, 2);
  BlockWrite(A0, Pad552E, 1);
  BlockWrite(A0, W5530, 4);
  BlockWrite(A0, W5534, 2);
  BlockWrite(A0, Pad5536, 2684);
  BlockWrite(A0, W5FB2, 1);
  BlockWrite(A0, W5FB4, 2);
  BlockWrite(A0, W5FB6, 2);
  BlockWrite(A0, W5FB8, 2);
  BlockWrite(A0, W5FBA, 2);
  BlockWrite(A0, W5FBC, 2);
  BlockWrite(A0, W5FBE, 1);
  BlockWrite(A0, P6042, 4);
  BlockWrite(A0, P6046, 4);
  BlockWrite(A0, P604C, 4);
  BlockWrite(A0, P6050, 4);
  BlockWrite(A0, B6054, 1);
  BlockWrite(A0, W6056, 2);
  BlockWrite(A0, Pad6058, 2);
  BlockWrite(A0, W605A, 4);
  BlockWrite(A0, W605E, 2);
  BlockWrite(A0, W6062, 2);
  BlockWrite(A0, W6064, 2);
  BlockWrite(A0, W6066, 2);
  BlockWrite(A0, W6068, 2);
  BlockWrite(A0, W606A, 2);
  BlockWrite(A0, W606C, 2);
  BlockWrite(A0, W606E, 2);
  BlockWrite(A0, W6070, 2);
  BlockWrite(A0, W6072, 2);
  BlockWrite(A0, W6074, 2);
  BlockWrite(A0, W6076, 2);
  BlockWrite(A0, Pad6078, 2);
  BlockWrite(A0, W607A, 2);
  BlockWrite(A0, W607C, 2);
  BlockWrite(A0, W607E, 2);
  BlockWrite(A0, B6080, 1);
  BlockWrite(A0, B6081, 1);
  BlockWrite(A0, Pad6082, 1);
  BlockWrite(A0, W6084, 2);
  BlockWrite(A0, W6086, 2);
  BlockWrite(A0, W6088, 2);
  BlockWrite(A0, W608A, 1);
  BlockWrite(A0, Pad608C, 2);
  BlockWrite(A0, W608E, 2);
  BlockWrite(A0, G6090, 671);
  BlockWrite(A0, Pair0056, 1);
  BlockWrite(A0, Pair12AA[18], 2);
  BlockWrite(A0, G12BE, 2);
  BlockWrite(A0, Data0000_008C, 2);
  BlockWrite(A0, G6344, 4);
  BlockWrite(A0, P6348, 4);
  BlockWrite(A0, G634C, 1);
  BlockWrite(A0, W5530, 4);
  BlockWrite(A0, W5534, 2);
  BlockWrite(A0, W5FBA, 2);
  BlockWrite(A0, W5FBC, 2);
  BlockWrite(A0, G006E, 1);
  BlockWrite(A0, Pair006E[1], 1);
  BlockWrite(A0, Pair0070[1], 1);
  BlockWrite(A0, Pair0070[2], 1);
end;

procedure Proc0_0C6A;
begin
end;

procedure Proc0_17BC;
begin
end;

procedure Proc0_1E9B;
begin
end;

procedure Proc0_1EA0;
type
  PLong11 = ^LongInt;
begin
  Data0000_004E[6] := 1;
  Data0000_004E[7] := 1;
  G0056 := 1;
  Pair0056[1] := 1;
  G0058 := 0;
  Pair0058[1] := 1;
  Pair005A[0] := 0;
  Pair005A[1] := 1;
  G005C := 1;
  Pair005C[1] := 1;
  G005E := 1;
  Pair005E[1] := 1;
  Pair0060[0] := 1;
  Pair0060[1] := 1;
  Pair0060[3] := 1;
  Pair0060[4] := 1;
  Pair0060[5] := 1;
  Pair0066[1] := 0;
  PLong11(@Pair0068[0])^ := 0;
  Pair0068[4] := 0;
  G006E := 0;
  Pair006E[1] := 0;
  Pair0070[0] := 0;
  Pair0070[1] := 0;
  Pair0070[2] := 0;
  Pair0070[4] := 1;
  Pair0070[5] := 2;
  Pair0070[6] := 3;
  Pair0070[7] := 4;
  Pair0070[8] := 5;
  Pair0070[9] := 6;
  Pair0070[10] := 7;
  Pair0070[11] := 8;
  Pred7c := 0;
  G0086 := 0;
  Pair0086[1] := 0;
  Data0000_0088[0] := 0;
  G008A := 1;
  G008E := 2;
  G0090 := 2;
  G0092 := 5;
  PWord11(@Data0000_008C)^ := 0;
  PWord11(@Pair0094[0])^ := $14;
  PLong11(@Pair0096)^ := 4;
  PWord11(@Pair009A)^ := 0;
  PWord11(@Pair009C)^ := 0;
  G009E := 0;
  Data0000_00A0[0] := 0;
  PWord11(@Pair00A2)^ := $14;
  PWord11(@Pair00A4[0])^ := 1;
  Pair00A4[2] := 0;
  PLong11(@Pair00A4[4])^ := 8;
  PLong11(@Pair12AA[18])^ := $01950270;
end;

procedure Proc0_21A0;
begin
  Proc3_26B9($6F, P6516^);
  Proc3_26B9($71, P6516^);
  Proc3_26B9($79, P6516^);
  Proc3_26B9($7E, P6516^);
  Proc3_26B9($25, P6516^);
  Proc3_26B9($3C, P6516^);
  Proc3_26B9($1E, P6516^);
  Proc3_26B9($1D, P6516^);
  Proc3_26B9($7D, P6516^);
  Proc3_26B9($23, P6516^);
  Proc3_26B9($6C, P6516^);
  Proc3_26B9($6E, P6516^);
end;

procedure Proc0_2241;
begin
end;

procedure Proc0_2254;
begin
end;

procedure Proc0_2466;
begin
end;

procedure Proc0_3938;
begin
end;

procedure Proc0_39B7;
begin
end;

procedure Proc0_3A36;
begin
end;

procedure Proc0_3A4D;
begin
end;

procedure Proc0_3A77;
begin
end;

procedure Proc0_3A8E;
begin
end;

procedure Proc0_3AFF;
begin
end;

procedure Proc0_3B06;
begin
end;

procedure Proc0_3C01(var A0);
type
  PC3 = ^TC3;
  TC3 = packed record
    Pad: array[0..$17B] of Byte;   { 0x00 .. 0x17b }
    P17C: Pointer;                   { 0x17c .. 0x17f }
    F180: TThing23;                  { 0x180 .. 0x183 }
  end;
var
  Buf: string;
begin
  PC3(@A0)^.F180 := Far535A(1, Ptr($3C13, $083F));
  Far15CD(@Buf, @G4F98);
  Far164C(#9'close.bmp');
  PC3(@A0)^.F180.Slot12;
  UEBERMAP.Far17E1($10, PC3(@A0)^.P17C);
  Far17BF($10, PC3(@A0)^.P17C);
  Far179D(0, PC3(@A0)^.P17C);
  Far177B(0, PC3(@A0)^.P17C);
  Far1B39(Far0E60(0, 0, PC3(@A0)^.F180, PC3(@A0)^.P17C^));
  UEBERMAP.Far17E1(0, @A0);
  Far17BF($10, @A0);
  Far179D(0, @A0);
  Far177B(0, @A0);
  Far56E1(@A0);
end;

procedure Proc0_3CEC;
begin
end;

procedure Proc0_3D0C;
begin
end;

function Proc0_3D54(A0, A1, A2: Word): Word;
begin
end;

procedure Proc0_3D9E;
begin
end;

function Proc0_3DC9(A0, A1: Integer): Integer;
begin
  if (A0 > 0) and (A0 < 250) and (A1 > 0) and (A1 < 250) then
    Proc0_3DC9 := MapTileMid^[A0, A1]
  else Proc0_3DC9 := 255;
end;

function Proc0_3E0D(A0, A1: Integer): Integer;
begin
  if (A0 > 0) and (A0 < 250) and (A1 > 0) and (A1 < 250) then
    Proc0_3E0D := MapTileA^[A0, A1]
  else Proc0_3E0D := 2;
end;

function Far0E60(A0, A1: Word; A2: Pointer; var A3): Pointer;
begin
end;

procedure Far1B39(A0: Pointer);
begin
end;

procedure Far16BE(A0: Pointer; A1: string);
begin
end;

procedure Far15E7S(A0: string; A1: Pointer; A2: Word);
begin
end;

function Far08E1(A0: string): Byte;
begin
end;

function Far08E1B: Byte;
begin
end;

function Far07BF(A0: string; A1, A2, A3, A4: Word): Integer;
begin
end;

procedure Far093;
begin
end;

procedure Far0625(A0: Pointer; A1: string);
begin
end;

procedure Far06AC(A0: Pointer);
begin
end;

procedure Far0A31(A0, A1: Pointer; A2: Word);
begin
end;

procedure Far08EF;
begin
end;

procedure Far070B(A0: Pointer);
begin
end;

procedure Proc0_3E51;
begin
end;

function Proc0_3E8D(A0, A1: Integer): Integer;
begin
  if (A0 > 0) and (A0 < 250) and (A1 > 0) and (A1 < 250) then
    Proc0_3E8D := MapTileC^[A0, A1]
  else Proc0_3E8D := 16;
end;

function Proc0_3ED1(A0, A1: Word): Word;
begin
end;

function Proc0_3F15(A0, A1: Word): Word;
begin
end;

procedure Proc0_3F59;
begin
end;

procedure Proc0_3F7B;
begin
end;

procedure Proc0_3FAC;
begin
end;

procedure TDummyForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
end;
procedure CallersInit0;
var
  Rec3C: array[0..$1FF] of Byte;
  F32E: file;
  Rec27: START.TRecP;
begin
  if Map0 = nil then;
  Proc0_21A0;
  Proc0_3C01(Rec3C);
  Proc0_032E(F32E);
  Proc11_02CF(0, 0);
  Proc11_27E6(Rec27);
  Proc0_1EA0;
  Proc0_17BC;
end;

begin
  CallersInit0;
end.
