unit GFX;
{ Reconstructed scaffold, holiday.exe code segment 6 (16269 bytes).
  This is form unit for TCreditform; the original kept its forms inside the segment's own  unit
  (docs/tree.md).
  Evidence: form TCreditform, 1 components.
  `uses` comes from this segment's relocation records, the class members
  from RTTI and form streams. Known close-handler bodies are recovered;
  other method bodies remain stubs. }
{$F+}
interface

uses ExtCtrls, Graphics, Controls, Forms, Classes, SysUtils;

type
  PByte6 = ^Byte;
  PPByte6 = ^PByte6;
  TFlag6 = packed record
    Byte0: Byte;
  end;
  TThree6 = packed record
    B0: PChar;
    B1: PChar;
    B2: PChar;
  end;
  PThree6 = ^TThree6;
  { The cursor record the three field getters 0382/0397/03AC read: +4 and +5
    are the two Byte counters 0x00EB advances, +6 the Word page they report. }
  TCur6 = packed record
    B0, B1, B2, B3: Byte;
    B4, B5: Byte;
    W6: Word;
  end;
  PCur6 = ^TCur6;
  TThree6Ptr = packed record
    P0, P1, P2: Pointer;
  end;
  PThree6Ptr = ^TThree6Ptr;
  { Proc6_154C indexes a 16-byte stride record whose +6 and +6+4 fields are
    Words: neither DARSTELL's TRow16 (Bytes there) nor MAP's TCell22 fits, so
    GFX keeps its own; the Words are Integer because the body divides by them
    signed (cdq/idiv, not xor dx,dx/div). }
  TSel6 = packed record
    B0, B1, B2, B3, B4, B5: Byte;
    W6: Integer;
    B8, B9: Byte;
    W0A: Integer;
    BC, BD, BE, BF: Byte;
  end;
  TSelArr6 = array[0..255] of TSel6;
  PSel6 = ^TSelArr6;
  { The two-Word record Proc6_154C writes through its var parameter: same shape
    as MAP's TCell22, kept local so the interface needs no new uses edge. }
  TCoord6 = packed record
    X: Word;
    Y: Word;
  end;
  { The cell Proc6_0263 walks: Ptr at +0 is loaded with les di, and B4/B5/W6
    sit at +4/+5/+6 exactly as in TCur6. The grid is 16-byte stride: the
    element size is what shl ax,4 scales by, TCell6 fills the first 8 bytes,
    and the second 8 are never touched by Proc6_0263 or Proc6_0000d. }
  TCell6 = packed record
    Ptr: Pointer;
    B4, B5: Byte;
    W6: Word;
  end;
  { What keeps a computed far pointer in es:di so it pushes es then di: an
    index on a pointer-to-grid yields the address (les di, es:[di], add di,
    ax), where PChar arithmetic over a Pointer field moved the value through
    ax:dx and pushed dx then ax instead. }
  TCell16 = array[0..15] of Byte;
  TCell16Grid = array[0..0] of TCell16;
  PCell16Grid = ^TCell16Grid;
  { The dispatch twins Proc6_03EC4 and Proc6_03F22: flag byte at +8 and a
    dispatch-table pointer at +9 of the receiver (docs/object-model.md
    six-field record, 30-entry far-pointer table at 4-byte stride), sub-records
    embedded at +0x18c and +0x2a2, each 9 + pointer + Rest = 0x116 bytes, so
    the call sites address them exactly. The +9 pointer is two bytes in the
    original (mov di, word then lcall [di+slot]); the P-minus switch around the
    two-typed-pointer declaration left it four bytes in both placements tried,
    so PDisp1C/PDisp20 stay far here and the row notes carry the divergence. }
  TDisp1C = packed record
    Pad: array[0..$1B] of Byte;
    Handler: function(A0, A1: Word; A2, A3: Pointer): Boolean;
  end;
  PDisp1C = ^TDisp1C;
  TDisp20 = packed record
    Pad: array[0..$1F] of Byte;
    Handler: function(A0, A1: Word; A2, A3: Pointer): Boolean;
  end;
  PDisp20 = ^TDisp20;
  TThing6 = packed record
    Pad: array[0..1] of Byte;
  end;
  PThing6 = ^TThing6;
  TItem1C = packed record
    Pad: array[0..8] of Byte;
    Disp: PDisp1C;
    Rest: array[0..264] of Byte;
  end;
  TItem20 = packed record
    Pad: array[0..8] of Byte;
    Disp: PDisp20;
    Rest: array[0..264] of Byte;
  end;
  TOut6A = packed record
    Pad0: array[0..$17B] of Byte;
    F17C: PThing6;
    Pad180: array[0..$B] of Byte;
    Sub1: TItem1C;
    Sub2: TItem1C;
  end;
  POut6A = ^TOut6A;
  TOut6B = packed record
    Pad0: array[0..$17B] of Byte;
    F17C: PThing6;
    Pad180: array[0..$B] of Byte;
    Sub1: TItem20;
    Sub2: TItem20;
  end;
  POut6B = ^TOut6B;
  PPtr6 = ^Pointer;
  { The 16-byte tile shape record behind the 0x54f2 table Sel10Board
    points at: W6 and W8 are Integers at +6 and +8, and Delphi 1 packs
    without word alignment, so the six-byte pad in front lands the fields
    (Pad[0..4] measured at +5/+7 with imul 0x12 stride, tag seg6dc6h). }
  TTileTbl6 = packed record
    Pad0: array[0..5] of Byte;
    W6, W8: Integer;
    Rest: array[0..5] of Byte;
  end;
  TTileTblArr6 = array[0..0] of TTileTbl6;
  PTileTbl6 = ^TTileTblArr6;
  { The 20-byte tile record behind MAP.G7372, TRec736E's shape:
    127 records, WE at +0xe and W10 at +0x10 for the two
    Proc6_04E3 dispatches, W12 at +0x12 for the 1DC6/1D10 pair. }
  TTileRec6 = packed record
    Pad0: array[0..$d] of Byte;
    WE, W10: Word;
    W12: Integer;
  end;
  TTileRecArr6 = array[0..0] of TTileRec6;
  PTileRec6 = ^TTileRecArr6;
  { The 16-byte record behind MAP.G736E: Proc6_04E3 reads and writes
    the LongInt at +0 through its var parameter, shl ax,4 stride.
    Layout copies key21 TRec736E (A, gap, C, gap). }
  TRecE16 = packed record
    A: LongInt;
    Gap4: array[0..3] of Byte;
    C: LongInt;
    GapC: array[0..3] of Byte;
  end;
  TRecE16Arr = array[0..0] of TRecE16;
  PRecE16 = ^TRecE16Arr;
  TGrid6 = packed record
    Pad: array[0..191] of Byte;
  end;
  PGrid6 = ^TGrid6;
  { The cell Proc6_000D initialises: Grid at +0 takes New (192 bytes = 12
    16-byte cells) and the helper writes the near pointer at +8, while
    B4/B5/W6 at +4/+5/+6 sit where TCur6 and TCell6 put them. Kept apart
    from TCell6 so Proc6_0148's var record keeps its untyped Pointer. }
  TCell6G = packed record
    Grid: PGrid6;
    B4, B5: Byte;
    W6: Word;
  end;
  PCell6G = ^TCell6G;
  TPair2 = packed record
    X, Y: Integer;
  end;
  TThingQ = packed record
    Pad: array[0..3] of Byte;
  end;
  PThingQ = ^TThingQ;
  TCharWq = array[0..0] of Byte;
  PCharWq = ^TCharWq;
function Proc6_0AF2(var Buf: PChar; Ch: Char): Byte;
function Proc6_0CAF(S: PThree6; C1, C2, C3: Word): Byte;
function Proc6_0EE7(A: LongInt): LongInt;
function Proc6_0F19(A, B: LongInt): LongInt;
function Proc6_0F53(A, B: LongInt): LongInt;
function Proc6_0FB2(A, B: LongInt): LongInt;
function Proc6_1517(A, B, AMin, BMin, AMax, BMax: Integer): Boolean;
function Proc6_1E62(Row, Col: SmallInt): Word;
function Proc6_1F93(A, B: Integer): Boolean;
function Proc6_1FC2(A0, A1: Word): Boolean;
procedure Clear6(P: PPByte6);
procedure Proc6_000D(A0: Word; A1: PCell6G);
procedure Far0468;
procedure Far15CDB(A0, A1, A2: string);
procedure Far625;
procedure Far6AC(A0: string);
function FarB47(A0: string): Boolean;
procedure FarA31(A0, A1: string; A2: Word);
procedure Far8EF;
procedure Far15E7E(A0: string; A1: Pointer; A2: Word);
procedure Far70B(A0: string);
procedure Far0093;
procedure Proc6_00EB(var P: TCur6);
procedure Proc6_0148(var A0: Pointer; var A1: TCell6);
procedure Proc6_3F80(A0: Pointer; A1: PByte6; A2: Pointer);
procedure Far15E7D(A0, A1: string; A2: Word);
procedure Far15E7C(var A0; A1: Word);
procedure Far164C(A0: string);
procedure Far164CP(A0: Pointer);
procedure Far164C0;
procedure Far764(A0: Pointer; A1: LongInt);
procedure Far15E7(A0, A1: Pointer; A2: Word);
procedure Proc6_0263(Dest: PChar; Limit: LongInt; var Obj: TCell6);
procedure Far22C6(var A0);
procedure Proc6_03EC4(A0, A1, A2, A3, A4, A5: Word; P: POut6A);
procedure Proc6_03F22(A0, A1, A2, A3, A4, A5: Word; P: POut6B);
procedure Far15E7B(var A0, A1; A2: Word);
procedure Far16E9(A0: string; A1: Char);
procedure Far1716A(A0, A1: string; A2, A3: Word);
procedure Far1716B(A0: string; A1, A2: Word);
procedure Proc6_0FDD(var A0: Pointer; A1: string);
procedure Proc6_02EF(A0, A1, A2, A3: Word);
procedure Proc6_032C(A0, A1: Word);
procedure Proc6_0357(A0, A1: Word);
function Proc6_0382(P: PCur6): Byte;
function Proc6_0397(P: PCur6): Byte;
function Proc6_03AC(P: PCur6): Word;
procedure Proc6_03C1(A0, A1, A2, A3: Word);
procedure Proc6_0413(A0, A1, A2, A3: Word);
procedure Proc6_0465(A0: Word);
function Proc6_04E3(A0, A1: Integer; A2, A3: Byte; var A4: LongInt): Word;
procedure Proc6_0AD2(A0, A1: Word);
function Proc6_0B3D(P: PPByte6; N: Byte): Byte;
procedure Proc6_0B76(A0, A1, A2: Word);
function Proc6_0C01(P: PPByte6): Byte;
procedure Proc6_0C18(P: PPByte6);
procedure Proc6_0C29(A0, A1: Word);
procedure Proc6_0C42(A0, A1, A2, A3: Word);
procedure Proc6_0C62(A0, A1, A2, A3: Word);
procedure Proc6_0C82(A0, A1: Word);
procedure Proc6_0D20(A0, A1, A2, A3, A4: Word);
procedure Proc6_0D71(A0, A1, A2: Word);
function Proc6_0DCB(R: PThree6Ptr): Byte;
procedure Proc6_0E15(R: PThree6Ptr);
procedure Proc6_0E42(A0, A1: Word);
procedure Proc6_0E6F(A0, A1, A2, A3: Word);
procedure Proc6_0EAB(A0, A1, A2, A3: Word);
procedure Proc6_0F8D(A0, A1: Word);
procedure Proc6_11A0(A0, A1: Word);
procedure Proc6_13DA(A0, A1: Word);
procedure Proc6_1418;
procedure Proc6_154C(A0, A1: Integer; var P: TCoord6);
function Proc6_16A2(A0, A1, A2: Integer): Byte;
function Proc6_1706(A0, A1, A2, A3: Integer): Word;
function Proc6_180D(Row, Col: Integer): Byte;
procedure Proc6_185D(A0, A1: Integer; A2, A3: LongInt; A4: Byte);
procedure Proc6_1D10(A0, A1: Integer; A2, A3: Byte);
procedure Proc6_1DAA(A0, A1, A2, A3: Word);
procedure Proc6_1DC6(A0, A1: Integer; A2, A3: Byte);
function Proc6_1FDB(A0, A1: SmallInt): Byte;
function Proc6_208D(A0, A1: SmallInt): Byte;
procedure Proc6_213F(A0, A1: Word);
procedure Proc6_21A8(A0, A1: Word);
procedure Proc6_2211(A0, A1: Word);
procedure Proc6_228D(A0, A1: Word);
procedure Proc6_22DE(A0, A1: Word);
procedure Proc6_232D(A0: Word);
procedure Proc6_235A(A0, A1: Word);
procedure Proc6_23D3(A0: Pointer; A1: Word; A2, A3, A4: Integer; A5: Byte; A6: Word; A7: string);
procedure Far28EA(A0, A1, A2, A3, A4, A5, A6, A7, A8, A9: Word);
procedure FarFFFF(A0, A1, A2, A3, A4, A5, A6, A7, A8, A9: Word);
function Far1F2E(A0: Pointer): Word;
function Proc6_E60(var A0): Pointer;
function Proc6_56AC(var A0): Pointer;
procedure Proc6_2B19;
procedure Proc6_2B7E;
procedure Proc6_2BAE(A0, A1: Word);
procedure Proc6_2BC5(A0, A1: Word);
procedure Far19C(A0: Pointer; A1: Word);
procedure Proc6_38A3;
procedure Proc6_38DA;
procedure Far1E21;
procedure Far3C01(var A0);
procedure Far064A;
procedure Far2F5E;
procedure Far3EA6;
procedure Far0765;
procedure Far1E9B;
procedure Far2577;
procedure Far3F02;
procedure Far3CEC(var A0);
procedure Proc6_390E;
procedure Proc6_3932;
procedure Proc6_3974;
procedure Proc6_3C0F(A0, A1: Word);
procedure Proc6_3C42(A0, A1: Word);
procedure Proc6_3E6F(A0, A1: Word);
procedure Proc6_3EC4(A0, A1, A2, A3, A4, A5, A6, A7: Word);
procedure Proc6_3F22(A0, A1, A2, A3, A4, A5, A6, A7: Word);
procedure SetTwo6(A: Pointer; var P: TFlag6);
procedure SetTwo6B(A: Pointer; var P: TFlag6);
var
  MonateText6: string;


type
  TCreditform = class(TForm)
    Bild: TImage;
  private
    { shortcut: opaque private storage; name fields as accesses are recovered. }
    UnrecoveredState: array[0..567] of Byte;
  published
    procedure BildMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure BildMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  end;

implementation

uses THINTERG, TDUMMYFO, ABRECHNE, DATEN, BAUFEN, DATWIN, AUKTION, KOMPASS, HIGHSCOR, HAUS,
  DARSTELL, GELD, SEG15, ANIM, SOUND, BAUEN, MAP, UEBERMAP, SEG24, DataVal;

function Proc6_0AF2(var Buf: PChar; Ch: Char): Byte;
begin
  if Ord(Buf[0]) < $FE then
  begin
    Inc(Buf[0]);
    Buf[Ord(Buf[0])] := Ch;
    Proc6_0AF2 := Ord(Buf[0]);
  end
  else
    Proc6_0AF2 := $FF;
end;

function Proc6_0CAF(S: PThree6; C1, C2, C3: Word): Byte;
var
  R: Byte;
begin
  if Proc6_1FC2(C1, C2) then
  begin
    R := Proc6_0AF2(S^.B0, Chr(C3));
    if (R <> $FF) and (Proc6_0AF2(S^.B1, Chr(C2)) = R)
      and (Proc6_0AF2(S^.B2, Chr(C1)) = R) then
      Proc6_0CAF := R
    else
      Proc6_0CAF := $FF;
  end
  else
    Proc6_0CAF := $FF;
end;

function Proc6_0EE7(A: LongInt): LongInt;
begin
  if A > 0 then
    Proc6_0EE7 := A
  else
    Proc6_0EE7 := 0;
end;

function Proc6_0F19(A, B: LongInt): LongInt;
begin
  if A > B then
    Proc6_0F19 := A
  else
    Proc6_0F19 := B;
end;

function Proc6_0F53(A, B: LongInt): LongInt;
begin
  if A < B then
    Proc6_0F53 := A
  else
    Proc6_0F53 := B;
end;

function Proc6_0FB2(A, B: LongInt): LongInt;
begin
  Proc6_0FB2 := Abs(A - B);
end;

function Proc6_1517(A, B, AMin, BMin, AMax, BMax: Integer): Boolean;
begin
  if (A >= AMin) and (A <= AMax) and (B >= BMin) and (B <= BMax) then
    Proc6_1517 := True
  else
    Proc6_1517 := False;
end;

function Proc6_1E62(Row, Col: SmallInt): Word;
begin
  if (Row < 0) or (Row > $fa) or (Col < 0) or (Col > $fa) then
    Proc6_1E62 := 0
  else if HalfMap^[Row div 2, Col] > 0 then
    Proc6_1E62 := HalfMap^[Row div 2, Col]
  else
  begin
    case MapTileC^[Row, Col] of
      0: Proc6_1E62 := HalfMap^[(Row - 1) div 2, Col];
      1: Proc6_1E62 := HalfMap^[Row div 2, Col + 1];
      2: Proc6_1E62 := HalfMap^[(Row + 1) div 2, Col];
      3: Proc6_1E62 := HalfMap^[Row div 2, Col - 1];
    else
      Proc6_1E62 := 0;
    end;
  end;
end;

function Proc6_1F93(A, B: Integer): Boolean;
begin
  if (A < 0) or (A > $FA) or (B < 0) or (B > $FA) then
    Proc6_1F93 := False
  else
    Proc6_1F93 := True;
end;

function Proc6_1FC2(A0, A1: Word): Boolean;
begin
  Proc6_1FC2 := Proc6_1F93(Integer(A1), Integer(A0));
end;

procedure Clear6(P: PPByte6);
begin
  P^^ := 0;
end;

procedure Proc6_000D(A0: Word; A1: PCell6G);
begin
end;

procedure Far0468;
begin
end;

procedure Far15CDB(A0, A1, A2: string);
begin
end;

procedure Far625;
begin
end;

procedure Far6AC(A0: string);
begin
end;

function FarB47(A0: string): Boolean;
begin
  FarB47 := True;
end;

procedure FarA31(A0, A1: string; A2: Word);
begin
end;

procedure Far8EF;
begin
end;

procedure Far15E7E(A0: string; A1: Pointer; A2: Word);
begin
end;

procedure Far70B(A0: string);
begin
end;

procedure Far0093;
begin
end;

procedure Proc6_00EB(var P: TCur6);
begin
  Inc(P.B4);
  if Data1600[(P.W6 mod 4) * 12 + P.B5] < P.B4 then begin
    P.B4 := 1;
    Inc(P.B5);
    if P.B5 > $C then begin
      Inc(P.W6);
      P.B5 := 1;
    end;
  end;
end;

procedure Proc6_0148(var A0: Pointer; var A1: TCell6);
const
  C138 = 'st';
  C13B = 'nd';
  C13E = 'rd';
  C141 = 'th';
  C144 = '.';
  C146 = ' ';
var
  L4: string[3];
  S104: string;
  S204: string;
begin
  case MAP.Pad64BE[0] of
    1, 2:
      begin
        case A1.B4 of
          1, $15, $1F:
            Far15E7D(C138, L4, 3);
          2, $16:
            Far15E7D(C13B, L4, 3);
          3, $17:
            Far15E7D(C13E, L4, 3);
        else
          Far15E7D(C141, L4, 3);
        end;
      end;
    0:
      Far15E7D(C144, L4, 3);
    3:
      L4 := '';
  end;
  Far764(@S104, A1.B4);
  Far164C(L4);
  Far164C(C146);
  Far164CP(PChar(@PCell16Grid(A1.Ptr)^[A1.B5]) - 16);
  Far164C(C146);
  Far764(@S204, A1.W6);
  Far164C0;
  Far15E7C(A0, $FF);
end;

procedure Proc6_3F80(A0: Pointer; A1: PByte6; A2: Pointer);
begin
  A1^ := 2;
end;

procedure Far15E7D(A0, A1: string; A2: Word);
begin
end;

procedure Far15E7C(var A0; A1: Word);
begin
end;

procedure Far164C(A0: string);
begin
end;

procedure Far164CP(A0: Pointer);
begin
end;

procedure Far164C0;
begin
end;

procedure Far764(A0: Pointer; A1: LongInt);
begin
end;

procedure Far15E7(A0, A1: Pointer; A2: Word);
begin
end;

procedure Proc6_0263(Dest: PChar; Limit: LongInt; var Obj: TCell6);
begin
  if (Obj.W6 - $7CC) * 12 + Obj.B5 > Limit then
    Far15E7(
      PChar(@PCell16Grid(Obj.Ptr)^[Integer(((Obj.B5 + $1D4BF - Limit) mod 12) + 1)]) - 16,
      Dest, $FF)
  else
    Far15E7(PChar(@PCell16Grid(Obj.Ptr)^[0]), Dest, $FF);
end;

procedure Far22C6(var A0);
begin
end;

procedure Proc6_03EC4(A0, A1, A2, A3, A4, A5: Word; P: POut6A);
begin
  if P^.Sub2.Disp^.Handler(A4, A5, P^.F17C, @P^.Sub2) or
     P^.Sub1.Disp^.Handler(A4, A5, P^.F17C, @P^.Sub1) then
    Far22C6(P^.F17C^);
end;

procedure Proc6_03F22(A0, A1, A2, A3, A4, A5: Word; P: POut6B);
begin
  if P^.Sub2.Disp^.Handler(A4, A5, P^.F17C, @P^.Sub2) or
     P^.Sub1.Disp^.Handler(A4, A5, P^.F17C, @P^.Sub1) then
    Far22C6(P^.F17C^);
end;

procedure Far15E7B(var A0, A1; A2: Word);
begin
end;

procedure Far16E9(A0: string; A1: Char);
begin
end;

procedure Far1716A(A0, A1: string; A2, A3: Word);
begin
end;

procedure Far1716B(A0: string; A1, A2: Word);
begin
end;

{$F-}
procedure Proc6_0108B(var A0: Pointer; A1: string);
const
  C0 = '0';
var
  W102, W104: SmallInt;
  B105, B106: Char;
  S2: string;
begin
  case MAP.Pad64BE[0] of
    0:
    begin
      B105 := ',';
      B106 := '.';
    end;
    3:
    begin
      B105 := '.';
      B106 := '_';
    end;
  else
    begin
      B105 := '.';
      B106 := ',';
    end;
  end;
  if A1[1] = '-' then
    W104 := 1
  else
    W104 := 0;
  while Length(A1) - W104 < 3 do
    Far1716A(C0, A1, $FF, W104 + 1);
  W102 := Length(A1) - 1;
  Far16E9(S2, B105);
  Far1716B(A1, $FF, W102);
  W102 := W102 - 5;
  while W104 + 2 <= W102 do
  begin
    Far16E9(S2, B106);
    Far1716B(A1, $FF, W102);
    W102 := W102 - 3;
  end;
  Far15E7B(A1, A0, $FF);
end;
{$F+}

procedure Proc6_0FDD(var A0: Pointer; A1: string);
var
  W102, W104: SmallInt;
  B105: Char;
  Spare: Byte;
  S2: string;
begin
  case MAP.Pad64BE[0] of
    0: B105 := '.';
    3: B105 := '_';
  else
    B105 := ',';
  end;
  W102 := Length(A1) - 2;
  if A1[1] = '-' then
    W104 := 1
  else
    W104 := 0;
  while W104 + 2 <= W102 do
  begin
    Far16E9(S2, B105);
    Far1716B(A1, $FF, W102);
    W102 := W102 - 3;
  end;
  Far15E7B(A1, A0, $FF);
end;

procedure Proc6_02EF;
begin
end;

procedure Proc6_032C;
begin
end;

procedure Proc6_0357;
begin
end;

function Proc6_0382(P: PCur6): Byte;
begin
  Proc6_0382 := P^.B4;
end;

function Proc6_0397(P: PCur6): Byte;
begin
  Proc6_0397 := P^.B5;
end;

function Proc6_03AC(P: PCur6): Word;
begin
  Proc6_03AC := P^.W6;
end;

procedure Proc6_03C1;
begin
end;

procedure Proc6_0413;
begin
end;

procedure Proc6_0465;
begin
end;

function Proc6_04E3(A0, A1: Integer; A2, A3: Byte; var A4: LongInt): Word;
label LoopRow, LoopCol, NextRow, ContinueCol, Join, FDBCheck, Done;
var
  Row, Col: SmallInt;
  Check1: Byte;
  Flag: Word;
begin
  Flag := 0;
  if (A0 < 0) or (A1 < 0) or (PTileTbl6(MAP.Sel10Board)^[A2].W6 + A0 - 1 > $FA)
     or (PTileTbl6(MAP.Sel10Board)^[A2].W8 + A1 - 1 > $FA) then
  begin
    Flag := $16;
    goto Done;
  end;
  A4 := PRecE16(MAP.G736E)^[A2].A;
  if Proc15_0191(A3) < A4 then
    if A3 = 1 then
    begin
      Flag := $e;
      goto Done;
    end;
  Check1 := Proc6_1FDB(A0, A1);
  Row := A1;
LoopRow:
  if PTileTbl6(MAP.Sel10Board)^[A2].W8 + A1 - 1 < Row then goto Done;
  if Flag <> 0 then goto Done;
  Col := A0;
LoopCol:
  if PTileTbl6(MAP.Sel10Board)^[A2].W6 + A0 - 1 < Col then goto NextRow;
  if Flag <> 0 then goto NextRow;
  if Proc6_1FDB(Col, Row) > Proc6_208D(Col, Row) then
  begin
    if (PTileRec6(MAP.G7372)^[A2].WE = 2) and (A2 <> $C) then
    begin
      A4 := A4 + PLong22(@MAP.Pad64F6)^;
      if Proc15_0191(A3) < A4 then
        if A3 = 1 then
          Flag := $e;
    end;
  end;
  if Flag <> 0 then goto Join;
  if (MAP.MapTileA^[Col, Row] >= $A) and (MAP.MapTileA^[Col, Row] < $37) then
            begin
              Flag := $2;
              goto Join;
            end;
            if (MAP.MapTileA^[Col, Row] >= $37) and (MAP.MapTileA^[Col, Row] <= $3A) then
            begin
              Flag := $F;
              goto Join;
            end;
            if MAP.MapTileA^[Col, Row] > $3A then
            begin
              Flag := $10;
              goto Join;
            end;
            if (MAP.MapTileMid^[Col, Row] <> $FF) and (MAP.MapTileMid^[Col, Row] <> $C) then
            begin
              Flag := $1;
              MAP.W64BA := Col;
              MAP.W64BC := Row;
              goto Join;
  if Proc6_1FDB(Col, Row) <> Check1 then
  begin
    Flag := $C;
    goto Join;
  end;
            end;
  case PTileRec6(MAP.G7372)^[A2].WE of
              0: if MAP.MapTileA^[Col, Row] <> 0 then Flag := $11;
              1: if MAP.MapTileA^[Col, Row] <> 1 then Flag := $12;
              2: if MAP.MapTileA^[Col, Row] = 2 then Flag := $0B;
              3: if MAP.MapTileA^[Col, Row] <> 2 then Flag := $13;
              4: if Col = A0 then
                 begin
                   if MAP.MapTileA^[Col, Row] <> 0 then Flag := $11;
                 end
                 else if MAP.MapTileA^[Col, Row] <> 2 then Flag := $13;
              5: if Row = A1 then
                 begin
                   if MAP.MapTileA^[Col, Row] <> 2 then Flag := $13;
                 end
                 else if MAP.MapTileA^[Col, Row] <> 0 then Flag := $11;
              6: if Col = A0 then
                 begin
                   if MAP.MapTileA^[Col, Row] <> 2 then Flag := $13;
                 end
                 else if MAP.MapTileA^[Col, Row] <> 0 then Flag := $11;
              7: if Row = A1 then
                 begin
                   if MAP.MapTileA^[Col, Row] <> 0 then Flag := $11;
                 end
                 else if MAP.MapTileA^[Col, Row] <> 2 then Flag := $13;
            end;
  Join:
  if Flag <> 0 then goto ContinueCol;
  case PTileRec6(MAP.G7372)^[A2].W10 of
                0: if MAP.MapTileC^[Col, Row] <> $10 then Flag := $14;
                1: if (MAP.MapTileC^[Col, Row] >= 8) and (MAP.MapTileC^[Col, Row] <= $B) then Flag := $A;
                2: if (MAP.MapTileC^[Col, Row] < 0) or (MAP.MapTileC^[Col, Row] > 3) then Flag := $15;
                4: if Col = A0 then
                   begin
                     if MAP.MapTileC^[Col, Row] <> $10 then Flag := $14;
                   end
                   else if MAP.MapTileC^[Col, Row] <> 0 then Flag := $15;
                5: if Row = A1 then
                   begin
                     if MAP.MapTileC^[Col, Row] <> 1 then Flag := $15;
                   end
                   else if MAP.MapTileC^[Col, Row] <> $10 then Flag := $14;
                6: if Col = A0 then
                   begin
                     if MAP.MapTileC^[Col, Row] <> 2 then Flag := $15;
                   end
                   else if MAP.MapTileC^[Col, Row] <> $10 then Flag := $14;
                7: if Row = A1 then
                   begin
                     if MAP.MapTileC^[Col, Row] <> $10 then Flag := $14;
                   end
                   else if MAP.MapTileC^[Col, Row] <> 3 then Flag := $15;
                8: if MAP.MapTileMid^[Col, Row] = $C then Flag := $1B;
              end;
ContinueCol:
  Inc(Col);
  goto LoopCol;
NextRow:
  Inc(Row);
  goto LoopRow;
Done:
  Proc6_04E3 := Flag;
end;


procedure Proc6_0AD2;
begin
end;

function Proc6_0B3D(P: PPByte6; N: Byte): Byte;
begin
  if (Proc6_0C01(P) >= N) and (N > 0) then
    Proc6_0B3D := Ord(PChar(P^)[N])
  else
    Proc6_0B3D := $FF;
end;

procedure Proc6_0B76;
begin
end;

function Proc6_0C01(P: PPByte6): Byte;
begin
  Proc6_0C01 := P^^;
end;

procedure Proc6_0C18(P: PPByte6);
begin
  P^^ := 0;
end;

procedure Proc6_0C29;
begin
end;

procedure Proc6_0C42;
begin
end;

procedure Proc6_0C62;
begin
end;

procedure Proc6_0C82;
begin
end;

procedure Proc6_0D20;
begin
end;

procedure Proc6_0D71;
begin
end;

function Proc6_0DCB(R: PThree6Ptr): Byte;
var
  R0: Byte;
begin
  R0 := Proc6_0C01(@R^.P0);
  if (Proc6_0C01(@R^.P1) = R0) and (Proc6_0C01(@R^.P2) = R0) then
    Proc6_0DCB := R0
  else
    Proc6_0DCB := $FF;
end;

procedure Proc6_0E15(R: PThree6Ptr);
begin
  Proc6_0C18(@R^.P0);
  Proc6_0C18(@R^.P1);
  Proc6_0C18(@R^.P2);
end;

procedure Proc6_0E42;
begin
end;

procedure Proc6_0E6F;
begin
end;

procedure Proc6_0EAB;
begin
end;

procedure Proc6_0F8D;
begin
end;

{$F-}
procedure Proc6_108B;
begin
end;
{$F+}

procedure Proc6_11A0;
begin
end;

procedure Proc6_13DA;
begin
end;

procedure Proc6_1418;
begin
end;

procedure Proc6_154C(A0, A1: Integer; var P: TCoord6);
var
  N: Integer;
  Kind: Word;
  W: Integer;
  Spare: Word;
begin
  Kind := MapTileMid^[A1, A0];
  N := G5510^[A1, A0] mod PSel6(Sel10Board)^[Kind].W0A;
  W := PSel6(Sel10Board)^[Kind].W6;
  P.X := A1 - (N mod W);
  P.Y := A0 - (N div W);
end;

{$F-}
function Proc6_15D2(A0, A1, A2: Word): Boolean;
begin
end;
{$F+}

function Proc6_16A2(A0, A1, A2: Integer): Byte;
var
  Res: Byte;
begin
  Res := 0;
  if Proc6_1F93(A1, A2) and (Proc6_1E62(A1, A2) = A0) and
     (MapTileA^[A1, A2] >= $0A) and (MapTileA^[A1, A2] <= $3A) then
    Res := 1;
  Proc6_16A2 := Res;
end;

function Proc6_1706(A0, A1, A2, A3: Integer): Word;
var
  T, U, V, I: Integer;
  Flag, Spare: Byte;
begin
  T := Proc6_1E62(A0, A1);
  Flag := 0;
  I := 1;
  while (Flag = 0) and (I < 5) do begin
    for U := A0 - I to A2 + I do begin
      if Proc6_15D2(T, U, A1 - I) then begin
        Flag := 1;
        Proc6_1706 := I;
      end;
      if Proc6_15D2(T, U, A3 + I) then begin
        Flag := 1;
        Proc6_1706 := I;
      end;
    end;
    for V := A1 - I + 1 to A3 + I - 1 do begin
      if Proc6_15D2(T, A0 - I, V) then begin
        Flag := 1;
        Proc6_1706 := I;
      end;
      if Proc6_15D2(T, A2 + I, V) then begin
        Flag := 1;
        Proc6_1706 := I;
      end;
    end;
    Inc(I);
  end;
  if Flag = 0 then
    Proc6_1706 := $FFFF;
end;

function Proc6_180D(Row, Col: Integer): Byte;
begin
  if (Row >= 0) and (Row <= $FA) and (Col >= 0) and (Col <= $FA) then
    Proc6_180D := G5524^[Row div 2, Col div 2]
  else
    Proc6_180D := 0;
end;

procedure Proc6_185D(A0, A1: Integer; A2, A3: LongInt; A4: Byte);
begin
end;

{$F-}
procedure Proc6_1AE9(A0, A1: Integer; A2, A3: LongInt; A4: Byte);
begin
end;
{$F+}

procedure Proc6_1D10(A0, A1: Integer; A2, A3: Byte);
begin
  Proc6_1AE9(
    PTileTbl6(MAP.Sel10Board)^[A2].W6 div 2 + A0,
    PTileTbl6(MAP.Sel10Board)^[A2].W8 div 2 + A1,
    PTileRec6(MAP.G7372)^[A2].W12,
    Proc6_0F19(1, Proc6_0F53(MAP.G64BF shr 1,
      Abs(PTileRec6(MAP.G7372)^[A2].W12 - $64) div 6)),
    A3);
end;

procedure Proc6_1DAA;
begin
end;

procedure Proc6_1DC6(A0, A1: Integer; A2, A3: Byte);
begin
  Proc6_185D(
    PTileTbl6(MAP.Sel10Board)^[A2].W6 div 2 + A0,
    PTileTbl6(MAP.Sel10Board)^[A2].W8 div 2 + A1,
    PTileRec6(MAP.G7372)^[A2].W12,
    Proc6_0F19(1, Proc6_0F53(MAP.G64BF shr 1,
      Abs(PTileRec6(MAP.G7372)^[A2].W12 - $64) div 6)),
    A3);
end;

function Proc6_1FDB(A0, A1: SmallInt): Byte;
begin
  if (A0 <= 0) or (A0 >= $FA) or (A1 <= 0) or (A1 >= $FA) then
    Proc6_1FDB := 0
  else
    Proc6_1FDB := Proc6_0F19(Map0^[A0, A1],
      Proc6_0F19(Map0^[A0 - 1, A1],
        Proc6_0F19(Map0^[A0, A1 - 1], Map0^[A0 - 1, A1 - 1])));
end;

function Proc6_208D(A0, A1: SmallInt): Byte;
begin
  if (A0 <= 0) or (A0 >= $FA) or (A1 <= 0) or (A1 >= $FA) then
    Proc6_208D := 0
  else
    Proc6_208D := Proc6_0F53(Map0^[A0, A1],
      Proc6_0F53(Map0^[A0 - 1, A1],
        Proc6_0F53(Map0^[A0, A1 - 1], Map0^[A0 - 1, A1 - 1])));
end;

procedure Proc6_213F;
begin
end;

procedure Proc6_21A8;
begin
end;

procedure Proc6_2211;
begin
end;

procedure Proc6_228D;
begin
end;

procedure Proc6_22DE;
begin
end;

procedure Proc6_232D;
begin
end;

procedure Proc6_235A;
begin
end;

procedure Proc6_23D3(A0: Pointer; A1: Word; A2, A3, A4: Integer;
              A5: Byte; A6: Word; A7: string);
            label Done, Check1, WalkHead, Body1, Seg1, Tok1, Width2b,
                  Rollback, Seg2, Check2, ModeB2, SumReset, Single1,
                  RenderSetup, Final, TmpSet;
            var
              W102, Idx, LastSp, Sum, Cnt, Tmp: Integer;
              Slot: array[0..9] of TPair2;
              Flag1, Flag2: Byte;
            begin
              if Length(A7) <= 0 then
                goto Done;
              W102 := Far1F2E(Proc6_E60(PThingQ(A0)^));
              MAP.W65E6 := Far1F2E(Proc6_56AC(PThingQ(MAP.G65E2)^));
              Idx := 0;
              goto Check1;
              repeat
                Inc(Idx);
              Check1:
                Slot[Idx].X := 0;
                Slot[Idx].Y := 0;
              until Idx = 9;
              Idx := 1;
              LastSp := 1;
              Cnt := 0;
              Sum := 0;
              Tmp := 0;
              Slot[0].X := 0;
              Slot[1].X := 1;
              Slot[0].Y := 0;
              Slot[1].Y := 0;
              Flag1 := 1;
              if Length(A7) <= 1 then
                goto Single1;
            WalkHead:
              if Length(A7) <= Idx then
                goto TmpSet;
            Body1:
              while (PCharWq(MAP.G65DE)^[Ord(A7[Idx])] + Sum <= A4) and (Length(A7) > Idx) do
              begin
                if A7[Idx] = ' ' then
                begin
                  LastSp := Idx;
                  Tmp := Sum;
                  Flag1 := 0;
                end;
                Sum := Sum + PCharWq(MAP.G65DE)^[Ord(A7[Idx])];
                Inc(Idx);
              end;
            Seg1:
              if (Length(A7) <= Idx) and (Cnt = 0) then
                Flag2 := 1
              else
                Flag2 := 0;
              if Length(A7) <= LastSp then
                goto Seg2;
            Tok1:
              if A7[Idx] = ' ' then
                goto Seg2;
              if Length(A7) <= Idx then
                goto Seg2;
            Width2b:
              if PCharWq(MAP.G65DE)^[Ord(A7[Idx])] + Sum <= A4 then
                goto Seg2;
            Rollback:
              Idx := LastSp;
              Sum := Tmp;
              if Flag1 = 1 then
                Idx := Length(A7);
              Inc(Cnt);
              Slot[Cnt].X := Idx;
              case A6 of
                1:
                  Slot[Cnt].Y := (A4 - Sum) div 2;
                2:
                  Slot[Cnt].Y := A4 - Sum;
              else
                Slot[Cnt].Y := 0;
              end;
              goto SumReset;
            Seg2:
              if Flag1 <> 0 then
                Idx := Length(A7);
              Inc(Cnt);
              Slot[Cnt].X := Idx;
              if Flag1 = 0 then
                goto Check2;
              case A6 of
                1:
                  Slot[Cnt].Y := (A4 - Sum - PCharWq(MAP.G65DE)^[Ord(A7[Idx])]) div 2;
                2:
                  Slot[Cnt].Y := A4 - Sum - PCharWq(MAP.G65DE)^[Ord(A7[Idx])];
              else
                Slot[Cnt].Y := 0;
              end;
              goto SumReset;
            Check2:
              if Flag2 <> 0 then
              begin
                case A6 of
                  1:
                    Slot[Cnt].Y := (A4 - Sum - PCharWq(MAP.G65DE)^[Ord(A7[Idx])]) div 2;
                  2:
                    Slot[Cnt].Y := A4 - Sum - PCharWq(MAP.G65DE)^[Ord(A7[Idx])];
                else
                  Slot[Cnt].Y := 0;
                end;
                goto SumReset;
              end;
            ModeB2:
              case A6 of
                1:
                  Slot[Cnt].Y := (A4 - Sum) div 2;
                2:
                  Slot[Cnt].Y := A4 - Sum - PCharWq(MAP.G65DE)^[Ord(A7[Idx])];
              else
                Slot[Cnt].Y := 0;
              end;
            SumReset:
              Sum := 0;
              goto WalkHead;
            TmpSet:
              Tmp := Cnt;
              goto RenderSetup;
            Single1:
              Cnt := 1;
              case A6 of
                1:
                  Slot[Cnt].Y := (A4 - PCharWq(MAP.G65DE)^[Ord(A7[1])]) div 2;
                2:
                  Slot[Cnt].Y := A4 - PCharWq(MAP.G65DE)^[Ord(A7[1])];
              else
                Slot[Cnt].Y := 0;
              end;
            RenderSetup:
              Cnt := 1;
              Sum := A2 + Slot[Cnt].Y;
              for LastSp := 0 to Tmp do
              begin
                for Idx := Slot[Cnt - 1].X + 1 to Slot[Cnt].X do
                begin
                  Far28EA(W102, Sum, A3, $C, $E, MAP.W65E6,
                    PCharWq(MAP.G65DA)^[Ord(A7[Idx])] * 12, 0, $88, $C6);
                  FarFFFF(W102, Sum, A3, $C, $E, MAP.W65E6,
                    PCharWq(MAP.G65DA)^[Ord(A7[Idx])] * 12, A1 * 14, $66, $46);
                  Sum := Sum + PCharWq(MAP.G65DE)^[Ord(A7[Idx])];
                end;
                Inc(Cnt);
                A3 := A3 + $E;
                Sum := A2 + Slot[Cnt].Y;
              end;
            Final:
              if A5 <> 0 then
                Far22C6(PThingQ(A0)^);
            Done:
            end;

            procedure Far28EA(A0, A1, A2, A3, A4, A5, A6, A7, A8, A9: Word);
            begin
            end;

            procedure FarFFFF(A0, A1, A2, A3, A4, A5, A6, A7, A8, A9: Word);
            begin
            end;

            function Far1F2E(A0: Pointer): Word;
            begin
            end;

            function Proc6_E60(var A0): Pointer;
            begin
            end;

            function Proc6_56AC(var A0): Pointer;
            begin
            end;

{$F-}
procedure Proc6_2972;
begin
end;
{$F+}

procedure Proc6_2B19;
begin
end;

procedure Proc6_2B7E;
begin
end;

procedure Proc6_2BAE;
begin
end;

procedure Proc6_2BC5;
begin
end;

{$F-}
procedure Proc6_2BDC;
begin
end;
{$F+}

{$F-}
procedure Proc6_2C5F;
begin
end;
{$F+}

{$F-}
procedure Proc6_2CEB;
begin
end;
{$F+}

{$F-}
procedure Proc6_2D80;
begin
end;
{$F+}

{$F-}
procedure Proc6_2E48;
begin
end;
{$F+}

{$F-}
procedure Proc6_2E89;
begin
end;
{$F+}

{$F-}
procedure Proc6_2E94;
begin
  Far19C(PPtr6(@MAP.Pad54F6)^, $3F18);
  Far19C(PPtr6(@MAP.Sel10Board)^, $7F0);
  Far19C(PPtr6(@MAP.Pad54DC[6])^, $69C);
  Far19C(PPtr6(@MAP.Tbl54E6)^, $17C);
  Far19C(PPtr6(@MAP.Pad54DC[2])^, $63C);
  Far19C(PPtr6(@MAP.Pad54EA)^, $21C);
  Far19C(PPtr6(@MAP.Pad54EA[4])^, $1E0);
  Far19C(MAP.G7366, $7F00);
  Far19C(MAP.G736A, $7F00);
  Far19C(MAP.G7362, $800);
  Far19C(MAP.G736E, $7F0);
  Far19C(MAP.G7372, $9EC);
  Far19C(MAP.G734A, $1F00);
end;
{$F+}

procedure Far19C(A0: Pointer; A1: Word);
begin
end;

{$F-}
procedure Proc6_307A;
begin
end;
{$F+}

{$F-}
procedure Proc6_36E5;
begin
end;
{$F+}

procedure Proc6_38A3;
begin
  Far1E21;
  Far3C01(G6624^);
  Far064A;
  Proc22_5788;
  Proc6_2C5F;
  Proc6_2E89;
  Proc6_2BDC;
  Proc6_2B19;
  Far2F5E;
  Far3EA6;
end;

procedure Proc6_38DA;
begin
  Proc6_2E94;
  Proc22_582A;
  Proc6_2CEB;
  Far0765;
  Far1E9B;
  Proc6_2B7E;
  Far2577;
  Far3F02;
  Far3CEC(G6624^);
end;

procedure Far1E21;
begin
end;

procedure Far3C01(var A0);
begin
end;

procedure Far064A;
begin
end;

procedure Far2F5E;
begin
end;

procedure Far3EA6;
begin
end;

procedure Far0765;
begin
end;

procedure Far1E9B;
begin
end;

procedure Far2577;
begin
end;

procedure Far3F02;
begin
end;

procedure Far3CEC(var A0);
begin
end;

procedure Proc6_390E;
begin
end;

procedure Proc6_3932;
begin
end;

procedure Proc6_3974;
begin
end;

procedure Proc6_3C0F;
begin
end;

procedure Proc6_3C42;
begin
end;

procedure Proc6_3E6F;
begin
end;

procedure Proc6_3EC4;
begin
end;

procedure Proc6_3F22;
begin
end;

procedure SetTwo6(A: Pointer; var P: TFlag6);
begin
  P.Byte0 := 2;
end;

procedure SetTwo6B(A: Pointer; var P: TFlag6);
begin
  P.Byte0 := 2;
end;

procedure TCreditform.BildMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
end;

procedure TCreditform.BildMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
end;

procedure TCreditform.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;
procedure CallersInit6;
var
  Three6: TThree6;
  CallerFlag6: TFlag6;
  AppendBuf: PChar;
  Coord6: TCoord6;
  Cur6: TCur6;
  Obj6: TCell6;
  Ptr108: Pointer;
begin

  AppendBuf := nil;
  if Proc6_0AF2(AppendBuf, 'A') = $FF then AppendBuf := nil;
  if Proc6_0F53(0, 1) = 0 then AppendBuf := nil;
  if Proc6_0F19(0, 1) = 0 then AppendBuf := nil;
  if Proc6_1517(0, 0, 0, 0, 0, 0) then AppendBuf := AppendBuf;
  if Proc6_0EE7(1) = 0 then AppendBuf := nil;
  if Proc6_1F93(0, 0) then AppendBuf := AppendBuf;
  if Proc6_0FB2(0, 1) = 0 then AppendBuf := nil;
  if Proc6_0CAF(@Three6, 1, 2, 3) = $FF then AppendBuf := AppendBuf;
  if Proc6_1E62(0, 0) > 0 then AppendBuf := nil;
  if Proc6_0382(nil) = 0 then AppendBuf := nil;
  if Proc6_0397(nil) = 0 then AppendBuf := nil;
  if Proc6_03AC(nil) = 0 then AppendBuf := nil;
  if Proc6_0C01(nil) = 0 then AppendBuf := nil;
  Proc6_0C18(nil);
  if Proc6_16A2(0, 0, 0) <> 0 then AppendBuf := AppendBuf;
  if Proc6_180D(0, 0) = 0 then AppendBuf := nil;
  if Proc6_0B3D(nil, 1) = 0 then AppendBuf := nil;
  if Proc6_0DCB(nil) = 0 then AppendBuf := nil;
  Proc6_0E15(nil);
  Proc6_154C(0, 0, Coord6);
  Proc6_00EB(Cur6);
  if Proc6_1706(0, 0, 0, 0) = 0 then AppendBuf := nil;
  Proc6_0263(nil, 0, Obj6);
  Proc6_03EC4(0, 0, 0, 0, 0, 0, nil);
  Proc6_03F22(0, 0, 0, 0, 0, 0, nil);
  Proc6_0108B(Ptr108, 'x');
  Proc6_0FDD(Ptr108, 'y');
  Proc6_0148(Ptr108, Obj6);
  Proc6_3F80(nil, nil, nil);
  Proc6_38A3;
  Proc6_38DA;
  if Proc6_1FDB(1, 1) = 0 then AppendBuf := nil;
  if Proc6_208D(1, 1) = 0 then AppendBuf := nil;
  Proc6_1DC6(0, 0, 0, 0);
  Proc6_1D10(0, 0, 0, 0);
  if Proc6_04E3(1, 1, 1, 0, L64F2) = 0 then AppendBuf := nil;
end;

begin
  CallersInit6;
end.
