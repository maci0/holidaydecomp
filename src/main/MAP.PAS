unit MAP;
{ Reconstructed scaffold, holiday.exe code segment 22 (22740 bytes).
  This is unit; the original kept its forms inside the segment's own  unit (docs/tree.md).
  Evidence: Maperste.dat: map data.
  `uses` comes from this segment's relocation records, the class members
  from RTTI and form streams. Recovered free bodies are listed in the
  implementation; the other bodies are not recovered. }
{$F+}
interface

uses Classes;

type
  TThree22 = packed record
    A: Byte;
    B: Byte;
    C: Byte;
  end;

  PFar4 = ^TFar4;
  TFar4 = packed record
    Lo: Word;
    Hi: Word;
  end;
  TCell22 = packed record
    X: Word;
    Y: Word;
  end;
  PCell22 = ^TCell22;
  TBytes22 = array[0..0] of Byte;
  PBytes22 = ^TBytes22;
  TGrid22 = array[0..0, 0..250] of Byte;
  PGrid22 = ^TGrid22;
  THalfGrid22 = array[0..0, 0..250] of Word;
  PWords22 = ^THalfGrid22;
  TSlot22W = packed record
    W0, W1: Word;
    Pad: array[0..19] of Byte;
    W18: Word;
    Rest: array[0..13] of Byte;
  end;
  TSlotArr22W = array[0..0] of TSlot22W;
  PSlotArr22W = ^TSlotArr22W;
  TSlot22B = packed record
    W0, W1: Word;
    Pad: array[0..19] of Byte;
    B18: Byte;
    Rest: array[0..14] of Byte;
  end;
  TSlotArr22B = array[0..0] of TSlot22B;
  PSlotArr22B = ^TSlotArr22B;
  TNarrow22 = array[0..0, 0..125] of Byte;
  PNarrow22 = ^TNarrow22;
  TSlot22WA = packed record
    W0, W1: Word;
    Pad: array[0..19] of Byte;
    W18, W1A: Word;
    Rest: array[0..11] of Byte;
  end;
  PSlotArrWA22 = ^TSlotArr22WA;
  TSlotArr22WA = array[0..0] of TSlot22WA;
  TFour22 = packed record B0, B1, B2, B3: Byte; end;
  TTableRow22 = array[0..46] of TFour22;
  TTable22 = array[0..0] of TTableRow22;
  PTable22 = ^TTable22;
  TSlotF17 = packed record
    W0, W1, W2, W3, W4, W5: Word;
    Pad: array[0..7] of Byte;
    B14, B15, B16, B17: Byte;
    W18: Word;
    L1A: LongInt;
    W1E, W20, W22, W24, W26: Word;
  end;
  TSlotArrF17 = array[0..0] of TSlotF17;
  PSlotArrF17 = ^TSlotArrF17;
  PLong22 = ^LongInt;
  TGrid5W22 = array[0..4, 0..4] of Word;
  PGrid5W22 = ^TGrid5W22;
  PByte22 = ^Byte;
  TFar4Arr22 = array[0..63] of TFar4;
  PFar4Arr22 = ^TFar4Arr22;
  TGridM50W22 = array[-50..50, -50..50] of Word;
  PTGridM50W22 = ^TGridM50W22;
  TMask20 = record
    Cells: array[-20..20, -20..20] of Byte;
  end;
  PMask20 = ^TMask20;
  PW22 = ^Word;
  TEnt2 = packed record
    F0: Byte;
    F1: Byte;
  end;
  TEntArr = array[0..0] of TEnt2;
  PTEntArr = ^TEntArr;
  TRec6456 = packed record
    Pad: array[0..399] of Byte;
    B190: Byte;
    B191: Byte;
  end;
  PTRec6456 = ^TRec6456;
  TRecLad22 = packed record
    Pad: array[0..279] of Byte;
  end;
  TLad22 = packed record
    Pad17C: array[0..$17B] of Byte;
    L17C: LongInt;
    Pad180: array[0..$23] of Byte;
    Items: array[0..3] of TRecLad22;
  end;
  PLad22 = ^TLad22;
  TCell17 = packed record
    W0: Word;
    Pad: Word;
    Key: SmallInt;
  end;
  TCellArr17 = array[0..0] of TCell17;
  PCell17 = ^TCellArr17;
  TFar22L = packed record
    Head: array[0..$23] of Byte;
    W24: SmallInt;
    Tail: array[0..34] of Byte;
    Items: array[0..255] of LongInt;
  end;
  PFar22L = ^TFar22L;
  TPair653A = array[0..1] of Word;
function Div4_22(A: Byte): SmallInt;
function Init22(P: PFar4): Boolean;
function Lookup22(Y, X: Word): Word;
function Stub45A7(Y, X: Word): Byte;
function Stub470C(Y, X: Word): Word;
function Stub4786(Y, X: Word): Boolean;
function StubRand(N: Word): Word;
procedure Fill22;
procedure Loop22(N: Word);
function Proc22_069F(X, Y: Word; B: Byte; var L: LongInt): Word;
function Far7B2(A0: Word): PW22;
function Far7C1(A0: Word): Pointer;
function FarA7A(A0: Word): Pointer;
function Far0909(A0, A1: Word): Byte;
function Far9FB(A0: Byte): LongInt;
function Far91E(A0, A1: Word; A2: LongInt): Word;
function Far956(A0, A1: Word; A2: LongInt): Word;
function Far941(A0, A1: Word; A2: LongInt): Word;
function FarC55(A0, A1: Word; A2: LongInt): Word;
procedure Far1A82(A0, A1: Byte);
procedure FarA8A(A0: Pointer; A1: Word);
procedure FarAC5(A0: Pointer; A1: Word);
procedure FarE16(A0: Pointer; A1: Word);
function Far4CC(A0, A1: LongInt): Byte;
function Far4EC(A0, A1: LongInt): Byte;
function Far50C(A0, A1: LongInt): Byte;
function Far6DF(A0, A1: LongInt): Byte;
function Far0F07(A0: Word): PW22;
function Far0F16(A0: Word): Pointer;
function Far112E(A0: Word): Pointer;
function Far103A(A0, A1: Word): Byte;
function Far104F(A0, A1: Word; A2: LongInt): Word;
function Far1087(A0, A1: Word; A2: LongInt): Word;
function Far1072(A0, A1: Word; A2: LongInt): Word;
function Far172B(A0, A1: Word; A2: LongInt): Word;
procedure Far113E(A0: Pointer; A1: Word);
procedure Far1159(A0: Pointer; A1: Word);
procedure Far1972(A0: Pointer; A1: Word);
function FarC75(A0, A1: LongInt): Byte;
function FarC95(A0, A1: LongInt): Byte;
function FarCB5(A0, A1: LongInt): Byte;
function FarE34(A0, A1: LongInt): Byte;
function Proc22_1907(X, Y: Word; B: Byte; var L: LongInt): Word;
function Far1AB3(A0, A1: Word): Boolean;
function Far1AC8(A0, A1: Word; A2: LongInt): Word;
function Far1AEB(A0, A1: Word; A2: LongInt): Word;
function Far1B00(A0, A1: Word; A2: LongInt): Word;
function Far1ECA(A0, A1: Word; A2: LongInt): Word;
function Far1BFE(A0: Byte): LongInt;
function Far174B(A0, A1: LongInt): Byte;
function Far176B(A0, A1: LongInt): Byte;
function Far178B(A0, A1: LongInt): Byte;
function Far19AF(A0, A1: LongInt): Byte;
function Far1981(A0: Word): Pointer;
function Far1C0E(A0: Word): Pointer;
procedure Far1C1E(A0: Pointer; A1: Word);
procedure Far20A6(A0: Pointer; A1: Word);
function Far20B5(A0: Word): Pointer;
function Far22B7(A0: Word): Pointer;
function Far21C3(A0, A1: Word): Byte;
function Far21D8(A0, A1: Word; A2: LongInt): Word;
function Far2210(A0, A1: Word; A2: LongInt): Word;
function Far21FB(A0, A1: Word; A2: LongInt): Word;
function Far31AB(A0, A1: Word; A2: LongInt): Word;
procedure Far22C7(A0: Pointer; A1: Word);
procedure Far29CA(A0: Pointer; A1: Word);
function Far1EEA(A0, A1: LongInt): Byte;
function Far1F0A(A0, A1: LongInt): Byte;
function Far1F2A(A0, A1: LongInt): Byte;
function Far20E3(A0, A1: LongInt): Byte;
function Far29D8(Arg: Word): Pointer;
function Far29E6(Arg: Word): Pointer;
function Far2B7B(Arg: Word): Pointer;
procedure Far2B89(Arg: Word; P: Pointer);
procedure Far2B97(Arg: Word; P: Pointer);
procedure Far37C1(Arg: Word; P: Pointer);
function Proc22_2B9B(X, Y, W: Integer; B: Byte; P: PLong22): Word;
function Proc22_2C83(X, Y, W: Integer; B: Byte; P: PLong22): Word;
procedure Proc22_3199(X, Y: Byte);
function Far31E4(A0, A1: Byte): Byte;
procedure Proc22_33BC(A0, A1, A2, A3: Byte);
function Far4059(A0: LongInt; A1, A2: Word): Word;
function Far39FF(A0: Word): Word;
function Far3A14(A0: Word): Word;
function Far3A20(A0: Word): Word;
function Far3A35(A0: Word): Word;
function Far3A4A(A0: Word): Word;
function Far3A56(A0: Word): Word;
function Far3A62(A0: Word): Word;
function Far3C82(A0: Word): Word;
function Far406E(A0: LongInt): LongInt;
function Far40BA(A0, A1: Word; A2: LongInt): Word;
function Far40CA(A0: LongInt): LongInt;
function Far4542(A0: LongInt): LongInt;
function Far40F4(A0: Word): Word;
function Far416B(A0: Word): Word;
function Far41E4(Arg: Word): Word;
function Far41EF(Arg: Word): Word;
function Far4219(Arg: Word): Word;
function Far4518(Arg: Word): Word;
function Far4527(Arg: Word): Word;
function Far4621(Arg: Word): Word;
function Far49DC(A0, A1: LongInt): Byte;
function Far4E68(Arg: Word): Byte;
function Far49E3(A0, A1, A2, A3: LongInt): LongInt;
function Far49EA(A0: LongInt): LongInt;
function Far4AE0(A0: LongInt): LongInt;
function Far4D58(A0, A1: Word; A2: LongInt): Byte;
procedure Far4D05(A0, A1: Byte);
procedure Far54E7(A0, A1: Byte);
procedure Proc22_4DAE;
function Far4EF8(Arg: Word): Word;
function Far4F3D(Arg: Word): Word;
function Far4F6D(Arg: Word): Word;
function Far5332(Arg: Word): Word;
procedure Far5200(A0, A1: Byte; A2, A3: Word);
procedure Far5251(A0, A1: Byte; A2, A3: Word);
procedure Far529E(A0, A1: Byte; A2, A3: Word);
procedure Far550C(A0, A1, A2: Byte; A3: Word);
procedure Proc22_52D4;
function Far5341(A0: Word): Pointer;
function Far5379(A0: Word): Pointer;
procedure Far5389(A0: Pointer; A1: Word);
procedure Far5677(A0: Pointer; A1: Word);
function Proc22_53FE(Y, X: Integer; Dir, A: Byte): Byte;
function Far5693(A0: Pointer): Word;
procedure Far56A7;
procedure Far56BB(A0: Pointer);
procedure Far56E6(A0: Pointer);
procedure Proc22_5788;
procedure Proc22_582A;
procedure Step22(Dir: Byte; P: PFar4);
procedure Store3_22(var P: TThree22; B, C: Byte);
procedure Stub4D19;
procedure Stub517B(P: Word; J, I: Byte);
procedure Swap22(P, Q: PFar4);
var
  Pad3E93: array[0..3] of Byte;
  MapShift22: array[0..3155] of Byte;
  G4AEE: Word;
  G4AF0: Word;
  Pad0C54: array[0..27] of Byte;
  G4B0E: Word;
  G4B10: Word;
  Pad0C74: array[0..27] of Byte;
  G4B2E: Word;
  G4B30: Word;
  Pad0C94: array[0..27] of Byte;
  G4B4E: Word;
  G4B50: Word;
  Pad0CB4: array[0..27] of Byte;
  G4B6E: Word;
  G4B70: Word;
  Pad0CD4: array[0..27] of Byte;
  G4B8E: Word;
  G4B90: Word;
  Pad0CF4: array[0..27] of Byte;
  G4BAE: Word;
  G4BB0: Word;
  Pad0D14: array[0..27] of Byte;
  G4BCE: Word;
  G4BD0: Word;
  Pad0D34: array[0..27] of Byte;
  G4BEE: Word;
  G4BF0: Word;
  Pad0D54: array[0..27] of Byte;
  G4C0E: Word;
  G4C10: Word;
  Pad0D74: array[0..27] of Byte;
  G4C2E: Word;
  G4C30: Word;
  Pad0D94: array[0..75] of Byte;
  G4C7E: Word;
  G4C80: Word;
  G4C82: Word;
  G4C84: Word;
  G4C86: Word;
  G4C88: Word;
  G4C8A: Word;
  G4C8C: Word;
  G4C8E: Word;
  G4C90: Word;
  Pad0DF4: array[0..3] of Byte;
  G4C96: Word;
  G4C98: Word;
  Pad0DFC: array[0..3] of Byte;
  G4C9E: Word;
  G4CA0: Word;
  Pad0E04: array[0..3] of Byte;
  G4CA6: Byte;
  Pad0E09: Byte;
  G4CA8: Word;
  G4CAA: Word;
  G4CAC: Word;
  G4CAE: Byte;
  G4CB0: array[0..2, 0..9] of LongInt;
  G4D28: array[3..9] of LongInt;
  G4D44: Word;
  G4D46: Word;
  G4D48: Word;
  G4D4A: Word;
  G4D4C: Word;
  G4D4E: Word;
  L4D48: LongInt absolute G4D48;
  L4D4C: LongInt absolute G4D4C;
  Pad4D50: array[0..145] of Byte;
  G4DE2: array[0..0] of Char;
  Pad4DE3: array[0..143] of Byte;
  AuktionTxt: array[0..22] of Char;
  Pad4E8B: Byte;
  Pad4E8C: array[0..267] of Byte;
  G4F98: array[0..3] of Char;
  Pad4F9C: array[0..243] of Byte;
  TileAnchorA: array[0..1063] of Byte;
  ShutdownObjects: array[0..8] of TObject;
  Pad54DC: array[0..9] of Byte;
  Tbl54E6: Pointer;
  Pad54EA: array[0..7] of Byte;
  Sel10Board: Pointer;
  Pad54F6: array[0..3] of Byte;
  B54FA: Byte;
  B54FB: Byte;
  W54FC: Word;
  W54FE: Word;
  Map0: PGrid22;
  MapTileA: PGrid22;
  MapTileMid: PGrid22;
  MapTileC: PGrid22;
  G5510: PGrid22;
  G5514: PGrid22;
  G5518: PGrid22;
  MapTile1: PGrid22;
  MapTile2: PGrid22;
  G5524: PNarrow22;
  HalfMap: PWords22;
  W552C: Word;
  Pad552E: array[0..1] of Byte;
  W5530: Word;
  W5532: Word;
  W5534: Word;
  Pad5536: array[0..609] of Byte;
  Pad723E: array[0..2073] of Byte;
  W5FB2: Word;
  W5FB4: Word;
  W5FB6: Word;
  W5FB8: Word;
  W5FBA: Word;
  W5FBC: Word;
  W5FBE: Word;
  B5FBE: Byte absolute W5FBE;
  W5FC0: Word;
  W5FC2: Word;
  Pad5FC4: array[0..9] of Byte;
  W5FCE: Word;
  Pad5FD0: array[0..17] of Byte;
  W5FE2: Word;
  Pad5FE4: array[0..69] of Byte;
  G602A: Pointer;
  G602E: Pointer;
  Pad6032: array[0..15] of Byte;
  P6042: Pointer;
  P6046: Pointer;
  Pad604A: array[0..1] of Byte;
  P604C: Pointer;
  P6050: Pointer;
  B6054: Byte;
  B6055: Byte;
  W6056: Word;
  Pad6058: array[0..1] of Byte;
  W605A: Word;
  W605C: Word;
  W605E: Word;
  Pad6060: array[0..1] of Byte;
  W6062: Word;
  W6064: Word;
  W6066: Word;
  W6068: Word;
  W606A: Word;
  W606C: Word;
  W606E: Word;
  W6070: Word;
  W6072: Word;
  W6074: Word;
  W6076: Word;
  Pad6078: array[0..1] of Byte;
  W607A: Word;
  W607C: Word;
  W607E: Word;
  B6080: Byte;
  B6081: Byte;
  Pad6082: array[0..1] of Byte;
  W6084: Word;
  W6086: Word;
  W6088: Word;
  W608A: Word;
  Pad608C: array[0..1] of Byte;
  W608E: Word;
  G6090: array[0..670] of Byte;
  B632F: Byte;
  P6330: Pointer;
  P6334: LongInt;
  P6338: Pointer;
  Pad633C: array[0..7] of Byte;
  G6344: Word;
  G6346: Word;
  P6348: Pointer;
  G634C: Byte;
  Pad634E: array[0..263] of Byte;
  P6456: Pointer;
  Pad645A: array[0..95] of Byte;
  W64BA: Word;
  W64BC: Word;
  Pad64BE: array[0..0] of Byte;
  G64BF: Byte;
  G64C0: Word;
  Pad64C2: array[0..23] of Byte;
  L64DA: LongInt;
  L64DE: LongInt;
  L64E2: LongInt;
  L64E6: LongInt;
  Pad64EA: array[0..7] of Byte;
  L64F2: LongInt;
  Pad64F6: array[0..31] of Byte;
  P6516: Pointer;
  Pad651A: array[0..23] of Byte;
  P6532: Pointer;
  Pad6536: array[0..3] of Byte;
  G653A: Pointer;
  Pair653A: TPair653A absolute G653A;
  Pad653E: array[0..125] of Byte;
  G65BC: Pointer;
  Pad65C0: array[0..21] of Byte;
  G65D6: Pointer;
  G65DA: Pointer;
  G65DE: Pointer;
  G65E2: Pointer;
  W65E6: Word;
  Pad65E8: array[0..19] of Byte;
  P65FC: Pointer;
  Pad6600: array[0..17] of Byte;
  P6612: Pointer;
  Pad6616: array[0..9] of Byte;
  G6620: PLad22;
  G6624: Pointer;
  G6628: Pointer;
  B662C: Byte;
  B662D: Byte;
  B662E: Byte;
  Pad662F: Byte;
  G6630: Pointer;
  G6634: Pointer;
  W6638: Word;
  G663A: Pointer;
  G663E: array[0..2] of Pointer;
  W664A: Word;
  W664C: Word;
  Pad664E: array[0..1] of Byte;
  G6650: Pointer;
  Pad6654: array[0..3] of Byte;
  G6658: Pointer;
  Pad665C: array[0..5] of Byte;
  B6662: Byte;
  B6663: Byte;
  W6664: Word;
  G6666: Pointer;
  Pad666A: array[0..1] of Byte;
  G666C: Pointer;
  Pad6670: array[0..5] of Byte;
  W6676: Word;
  W6678: Word;
  Pad667A: array[0..1] of Byte;
  B667C: Byte;
  B667D: Byte;
  G667E: Pointer;
  G6682: Pointer;
  G6686: Pointer;
  G668A: Pointer;
  G668E: Pointer;
  G6692: Pointer;
  G6696: Pointer;
  G669A: Pointer;
  G669E: Pointer;
  W66A2: Word;
  W66A4: Word;
  W66A6: Word;
  W66A8: Word;
  W66AA: Word;
  W66AC: Word;
  W66AE: Word;
  W66B0: Word;
  W66B2: Word;
  W66B4: Word;
  W66B6: Word;
  W66B8: Word;
  W66BA: Word;
  B66BC: Byte;
  B66BD: Byte;
  B66BE: Byte;
  B66BF: Byte;
  B66C0: Byte;
  B66C1: Byte;
  G66C2: Pointer;
  G66C6: Pointer;
  Pad66CA: array[0..2053] of Byte;
  G6ED0: Pointer;
  Pad6ED4: array[0..11] of Byte;
  G6EE0: Pointer;
  Pad174C: array[0..3] of Byte;
  G6EE8: Byte;
  Pad1751: array[0..25] of Byte;
  G6F04: PFar22L;
  W6F08: Word;
  W6F0A: Word;
  W6F0C: Word;
  W6F0E: Word;
  W6F10: Word;
  W6F12: Word;
  W6F14: Word;
  W6F16: Word;
  W6F18: Word;
  W6F1A: Word;
  W6F1C: Word;
  Pad1786: array[0..5] of Byte;
  G6F24: Pointer;
  G6F28: array[0..7] of Byte;
  Pad6F30: array[0..131] of Byte;
  G6FB4: Word;
  Pad1822: array[0..1] of Byte;
  G6FB8: Word;
  Pad1826: array[0..3] of Byte;
  G6FBE: Word;
  G6FC0: Word;
  Pad182E: array[0..1] of Byte;
  G6FC4: Word;
  G6FC6: Pointer;
  W6FCA: Word;
  W6FCC: Word;
  Pad6FCE: array[0..7] of Byte;
  Slots: PSlotArr22B;
  Table: PTable22;
  Pad717E: array[0..3] of Byte;
  G6FE2: Pointer;
  G6FE6: Word;
  Pad6FE8: array[0..1] of Byte;
  G6FEA: Pointer;
  G6FEE: Word;
  G6FF0: Word;
  Pad6FF2: array[0..1] of Byte;
  HighMark17: Word;
  SortPad17: array[0..3] of Byte;
  W6FFA: Word;
  W6FFC: Word;
  SortCount17: SmallInt;
  SortSlots17: PCell17;
  Pad7004: array[0..59] of Byte;
  W7040: Word;
  W7042: Word;
  Pad7044: array[0..11] of Byte;
  G7050: Word;
  G7052: Word;
  G7054: Byte;
  G7055: Byte;
  G7056: Word;
  G7058: Word;
  G705A: Word;
  G705C: Word;
  G705E: Word;
  G7060: array[0..7] of Word;
  G7070: array[0..7] of Word;
  Pad7080: array[0..69] of Byte;
  G70C6: Pointer;
  G70CA: Pointer;
  G70CE: Pointer;
  G70D2: Pointer;
  G70D6: Pointer;
  G70DA: Pointer;
  G70DE: Pointer;
  Pad70E2: array[0..11] of Byte;
  G70EE: Pointer;
  G70F2: string[255];
  G71F2: array[0..17] of Pointer;
  G723A: Pointer;
  SwapP22A: TCell22;
  SwapP22B: TCell22;
  TileAnchorB: array[0..259] of Byte;
  G734A: Pointer;
  Pad734E: array[0..19] of Byte;
  G7362: Pointer;
  G7366: Pointer;
  G736A: Pointer;
  G736E: Pointer;
  G7372: Pointer;

implementation

uses GFX, HIGHSCOR, DARSTELL, SEG15, ANIM, UEBERMAP, DataVal, OBJEKT;

function Div4_22(A: Byte): SmallInt;
var
  R: SmallInt;
begin
  R := (A + 2) div 4;
  Div4_22 := R;
end;

function Init22(P: PFar4): Boolean;
var
  I: Word;
begin
  Init22 := False;
  for I := 2 to $5DC do
  begin
    P^.Lo := StubRand(249) + 1;
    P^.Hi := StubRand(249) + 1;
    if I >= $5DC then
      Break;
    if Stub45A7(P^.Lo, P^.Hi) < 4 then
    begin
      Init22 := True;
      Break;
    end;
  end;
end;

function Lookup22(Y, X: Word): Word;
var
  R: Word;
label
  Done;
begin
  R := $FFFF;
  if Y < 1 then goto Done;
  if X < 1 then goto Done;
  if Y > 249 then goto Done;
  if X > 249 then goto Done;
  if Stub4786(Y, X) then goto Done;
  R := Stub470C(Y, X);
Done:
  Lookup22 := R;
end;

{$F-}
{ ADDRESS: MAIN 0x00164786 }
function Proc22_4786(Row, Col: Integer): Boolean;
const
  AdjacentThreshold = $37;
begin
  if (MapTileA^[Row - 1][Col] >= AdjacentThreshold) or
     (MapTileA^[Row + 1][Col] >= AdjacentThreshold) or
     (MapTileA^[Row][Col - 1] >= AdjacentThreshold) or
     (MapTileA^[Row][Col + 1] >= AdjacentThreshold) then
    Proc22_4786 := True
  else
    Proc22_4786 := False;
end;
{$F+}

function Stub45A7(Y, X: Word): Byte;
begin
  Stub45A7 := 0;
end;

function Stub470C(Y, X: Word): Word;
begin
  Stub470C := 0;
end;

function Stub4786(Y, X: Word): Boolean;
begin
  Stub4786 := False;
end;

function StubRand(N: Word): Word;
begin
  StubRand := 1;
end;

procedure Fill22;
var
  I, J: Byte;
begin
  for I := 0 to 250 do
    for J := 0 to 250 do
      Stub517B(0, J, I);
end;

procedure Loop22(N: Word);
var I: Word;
begin
  for I := 1 to N do
    Stub4D19;
end;

{$F-}
{ ADDRESS: MAIN 0x00160130 }
function Proc22_0130(A0, A1: Integer): Word;
var
  R: Word;
procedure Proc22_0002(X, Y: Word);
begin
  Inc(Map0^[X, Y]);
  if Map0^[X, Y] - Map0^[X + 1, Y] = 2 then
    Proc22_0002(X + 1, Y);
  if Map0^[X, Y] - Map0^[X, Y + 1] = 2 then
    Proc22_0002(X, Y + 1);
  if Map0^[X, Y] - Map0^[X - 1, Y] = 2 then
    Proc22_0002(X - 1, Y);
  if Map0^[X, Y] - Map0^[X, Y - 1] = 2 then
    Proc22_0002(X, Y - 1);
end;

begin
  if (Map0^[A0, A1] < $14) and (Map0^[A0, A1] <= $FA - A0 - 2) and
     (Map0^[A0, A1] <= A1 - 2) and (Map0^[A0, A1] <= A0 - 2) and
     (Map0^[A0, A1] <= $FA - A1 - 2) then
  begin
    Proc22_0002(A0, A1);
    R := 0;
  end
  else
    R := 1;
  Proc22_0130 := R;
end;
{$F+}

{ ADDRESS: MAIN 0x0016069f }
function Proc22_069F(X, Y: Word; B: Byte; var L: LongInt): Word;
var
  Res: Word;
  Flag: Word;
  PosY: Word;
  PosX: Word;
  Q: PW22;
  V9: Byte;
  VA: Byte;
  VB: Byte;
  VC: Byte;
  o1: Integer;
  o2: Integer;
  function Proc22_01F0(A0, A1: Byte): Byte;
  var
    i: Word;
    Stopped: Byte;
  begin
    i := 1;
    Stopped := 0;
    while (i <= Q^) and (Stopped = 0) do
    begin
      if (PTEntArr(Q)^[i].F0 = A0) and (PTEntArr(Q)^[i].F1 = A1) then
      begin
        Proc22_01F0 := 1;
        Stopped := 1;
      end
      else
        Inc(i);
    end;
    Proc22_01F0 := Stopped;
  end;
  procedure Proc22_025B(A0, A1: Word);
  var
    P: PW22;
  begin
    P := Q;
    Inc(Q^);
    PTEntArr(Q)^[Q^].F0 := A0;
    PTEntArr(P)^[P^].F1 := A1;
  end;
  procedure Proc22_03FA(A0, A1: Word);
  function Proc22_0291(A0, A1: Word): Word;
  var
    Flag2: Word;
  begin
    Flag2 := 0;
    if PMask20(G71F2[12])^.Cells[A0, A1] <> $FF then
    begin
      if PMask20(G71F2[12])^.Cells[A0, A1] = $C then
      begin
        PMask20(G71F2[12])^.Cells[A0, A1] := $FF;
        L := L + L64F2;
      end
      else
        Flag2 := 1;
    end;
    if Flag2 = 0 then
      if MapTileA^[X + A0, Y + A1] >= $0a then
        if MapTileA^[X + A0, Y + A1] < $37 then
          Flag2 := 2;
    if Flag2 = 0 then
      if MapTileA^[X + A0, Y + A1] >= $37 then
        Flag2 := $10;
    if Flag2 = 0 then
      if MapTile1^[X + A0, Y + A1] <> $FF then
        Flag2 := $1c;
    if Flag2 <> 0 then
    begin
      PosX := X + A0;
      PosY := Y + A1;
    end;
    Proc22_0291 := Flag2;
  end;
  begin
    if Flag = 0 then
      Flag := Proc22_0291(A0, A1);
    if Flag = 0 then
      Flag := Proc22_0291(A0 + 1, A1);
    if Flag = 0 then
      Flag := Proc22_0291(A0, A1 + 1);
    if Flag = 0 then
      Flag := Proc22_0291(A0 + 1, A1 + 1);
    if Flag = 0 then
    begin
      Inc(PMask20(G71F2[11])^.Cells[A0, A1]);
      V9 := Far4CC(V9, X + A0);
      VB := Far4EC(VB, Y + A1);
      VA := Far50C(VA, X + A0);
      VC := Far6DF(VC, Y + A1);
      if PMask20(G71F2[11])^.Cells[A0, A1] = 1 then
      begin
        L := L + L64DA;
        Proc22_025B(X + A0, Y + A1);
      end
      else
        L := L + L64DE;
      if PMask20(G71F2[11])^.Cells[A0, A1] -
         PMask20(G71F2[11])^.Cells[A0 + 1, A1] = 2 then
        Proc22_03FA(A0 + 1, A1);
      if PMask20(G71F2[11])^.Cells[A0, A1] -
         PMask20(G71F2[11])^.Cells[A0, A1 + 1] = 2 then
        Proc22_03FA(A0, A1 + 1);
      if PMask20(G71F2[11])^.Cells[A0, A1] -
         PMask20(G71F2[11])^.Cells[A0 - 1, A1] = 2 then
        Proc22_03FA(A0 - 1, A1);
      if PMask20(G71F2[11])^.Cells[A0, A1] -
         PMask20(G71F2[11])^.Cells[A0, A1 - 1] = 2 then
        Proc22_03FA(A0, A1 - 1);
    end;
  end;
begin
  Q := Far7B2($A2);
  Q^ := 0;
  PosX := X;
  PosY := Y;
  Flag := 0;
  L := 0;
  if Far0909(X, Y) = 0 then
    Flag := 13
  else
  begin
    if Map0^[X, Y] >= $14 then Flag := 4
    else if Map0^[X, Y] > Pred(Pred(250 - X)) then Flag := 5
    else if Map0^[X, Y] > Pred(Pred(Y)) then Flag := 6
    else if Map0^[X, Y] > Pred(Pred(X)) then Flag := 7
    else if Map0^[X, Y] > Pred(Pred(250 - Y)) then Flag := 8
    else
    begin
      G71F2[11] := Far7C1($691);
      G71F2[12] := FarA7A($691);
      for o1 := -20 to 20 do
        for o2 := -20 to 20 do
          if (X + o1 >= 0) and (X + o1 <= 250) and (Y + o2 >= 0)
             and (Y + o2 <= 250) then
          begin
            PMask20(G71F2[11])^.Cells[o1, o2] := Map0^[X + o1, Y + o2];
            PMask20(G71F2[12])^.Cells[o1, o2] :=
              MapTileMid^[X + o1, Y + o2];
          end
          else
          begin
            PMask20(G71F2[11])^.Cells[o1, o2] := 0;
            PMask20(G71F2[12])^.Cells[o1, o2] := $FF;
          end;
      Proc22_03FA(0, 0);
      if B = 1 then
        if Far9FB(B) < L then
          Flag := 14;
      if Flag = 0 then
      begin
        for o1 := Far941(0, 0, X - 20) to Far91E(0, $fa, X + 20) do
          for o2 := FarC55(0, 0, Y - 20) to Far956(0, $fa, Y + 20) do
          begin
            Map0^[o1, o2] :=
              PMask20(G71F2[11])^.Cells[o1 - X, o2 - Y];
            MapTileMid^[o1, o2] :=
              PMask20(G71F2[12])^.Cells[o1 - X, o2 - Y];
            if Map0^[o1, o2] = 1 then
              if Proc22_01F0(Byte(o1), Byte(o2)) <> 0 then
                Far1A82(Byte(o1), Byte(o2));
          end;
        Proc22_33BC(V9, VB, VA, VC);
        Proc10_264D(V9, VB, VA + 1, VC + 1);
        Proc23_1504(V9, VB, VA + 1, VC + 1, G723A);
      end;
      FarA8A(G71F2[11], $691);
      FarAC5(G71F2[12], $691);
    end;
  end;
  if Flag <> 0 then
  begin
    Proc17_0324(PosY, PosX, $2a);
    W64BA := PosX;
    W64BC := PosY;
  end;
  Res := Flag;
  FarE16(Q, $A2);
  Proc22_069F := Res;
end;

function Far7B2(A0: Word): PW22;
begin
  Far7B2 := NIL;
end;

function Far7C1(A0: Word): Pointer;
begin
  Far7C1 := NIL;
end;

function FarA7A(A0: Word): Pointer;
begin
  FarA7A := NIL;
end;

function Far0909(A0, A1: Word): Byte;
begin
  Far0909 := 0;
end;

function Far9FB(A0: Byte): LongInt;
begin
  Far9FB := 0;
end;

function Far91E(A0, A1: Word; A2: LongInt): Word;
begin
  Far91E := 0;
end;

function Far956(A0, A1: Word; A2: LongInt): Word;
begin
  Far956 := 0;
end;

function Far941(A0, A1: Word; A2: LongInt): Word;
begin
  Far941 := 0;
end;

function FarC55(A0, A1: Word; A2: LongInt): Word;
begin
  FarC55 := 0;
end;

procedure Far1A82(A0, A1: Byte);
begin
end;

procedure FarA8A(A0: Pointer; A1: Word);
begin
end;

procedure FarAC5(A0: Pointer; A1: Word);
begin
end;

procedure FarE16(A0: Pointer; A1: Word);
begin
end;

function Far4CC(A0, A1: LongInt): Byte;
begin
  Far4CC := 0;
end;

function Far4EC(A0, A1: LongInt): Byte;
begin
  Far4EC := 0;
end;

function Far50C(A0, A1: LongInt): Byte;
begin
  Far50C := 0;
end;

function Far6DF(A0, A1: LongInt): Byte;
begin
  Far6DF := 0;
end;

{$F-}
{ ADDRESS: MAIN 0x00160e0c }
function Proc22_0E0C(A0, A1: Word): Word;
var
  Flag: Word;
  Q: PW22;
  M1: Byte;
  M2: Byte;
  M3: Byte;
  M4: Byte;
  o1: Integer;
  o2: Integer;
  procedure Proc22_0ACE(A0, A1: Word);
  var
    P: PW22;
  begin
    P := Q;
    Inc(Q^);
    PTEntArr(Q)^[Q^].F0 := A0;
    PTEntArr(P)^[P^].F1 := A1;
  end;
  procedure Proc22_0BA3(P1, P2: Word);
  function Proc22_0B04(P1, P2: Word): Word;
  var
    Flag2: Word;
  begin
    Flag2 := 0;
    if PMask20(G71F2[12])^.Cells[P1, P2] = $C then
      PMask20(G71F2[12])^.Cells[P1, P2] := $FF;
    if Flag2 = 0 then
      if (MapTileA^[A0 + P1, A1 + P2] >= $37) and
         (MapTileA^[A0 + P1, A1 + P2] <= $5e) then
        Flag2 := $10;
    Proc22_0B04 := Flag2;
  end;
  begin
    if Flag = 0 then
      Flag := Proc22_0B04(P1, P2);
    if Flag = 0 then
      Flag := Proc22_0B04(P1 + 1, P2);
    if Flag = 0 then
      Flag := Proc22_0B04(P1, P2 + 1);
    if Flag = 0 then
      Flag := Proc22_0B04(P1 + 1, P2 + 1);
    if Flag = 0 then
    begin
      Inc(PMask20(G71F2[11])^.Cells[P1, P2]);
      M1 := FarC75(M1, A0 + P1);
      M3 := FarC95(M3, A1 + P2);
      M2 := FarCB5(M2, A0 + P1);
      M4 := FarE34(M4, A1 + P2);
      if PMask20(G71F2[11])^.Cells[P1, P2] = 1 then
        Proc22_0ACE(A0 + P1, A1 + P2);
      if PMask20(G71F2[11])^.Cells[P1, P2] -
         PMask20(G71F2[11])^.Cells[P1 + 1, P2] = 2 then
        Proc22_0BA3(P1 + 1, P2);
      if PMask20(G71F2[11])^.Cells[P1, P2] -
         PMask20(G71F2[11])^.Cells[P1, P2 + 1] = 2 then
        Proc22_0BA3(P1, P2 + 1);
      if PMask20(G71F2[11])^.Cells[P1, P2] -
         PMask20(G71F2[11])^.Cells[P1 - 1, P2] = 2 then
        Proc22_0BA3(P1 - 1, P2);
      if PMask20(G71F2[11])^.Cells[P1, P2] -
         PMask20(G71F2[11])^.Cells[P1, P2 - 1] = 2 then
        Proc22_0BA3(P1, P2 - 1);
    end;
  end;
begin
  Q := Far0F07($A2);
  Q^ := 0;
  Flag := 0;
  if Far103A(A0, A1) = 0 then
    Flag := 13
  else
  begin
    if Map0^[A0, A1] >= $14 then Flag := 4
    else if Map0^[A0, A1] > Pred(Pred(250 - A0)) then Flag := 5
    else if Map0^[A0, A1] > Pred(Pred(A1)) then Flag := 6
    else if Map0^[A0, A1] > Pred(Pred(A0)) then Flag := 7
    else if Map0^[A0, A1] > Pred(Pred(250 - A1)) then Flag := 8
    else
    begin
      G71F2[11] := Far0F16($691);
      G71F2[12] := Far112E($691);
      for o1 := -20 to 20 do
        for o2 := -20 to 20 do
          if (A0 + o1 >= 0) and (A0 + o1 <= 250) and (A1 + o2 >= 0)
             and (A1 + o2 <= 250) then
          begin
            PMask20(G71F2[11])^.Cells[o1, o2] := Map0^[A0 + o1, A1 + o2];
            PMask20(G71F2[12])^.Cells[o1, o2] :=
              MapTileMid^[A0 + o1, A1 + o2];
          end
          else
          begin
            PMask20(G71F2[11])^.Cells[o1, o2] := 0;
            PMask20(G71F2[12])^.Cells[o1, o2] := $FF;
          end;
      M1 := A0;
      M2 := A0;
      M3 := A1;
      M4 := A1;
      Proc22_0BA3(0, 0);
      if Flag = 0 then
      begin
        for o1 := Far1072(0, 0, A0 - 20) to Far104F(0, $fa, A0 + 20) do
          for o2 := Far172B(0, 0, A1 - 20) to Far1087(0, $fa, A1 + 20) do
          begin
            Map0^[o1, o2] :=
              PMask20(G71F2[11])^.Cells[o1 - A0, o2 - A1];
            MapTileMid^[o1, o2] :=
              PMask20(G71F2[12])^.Cells[o1 - A0, o2 - A1];
          end;
        Proc22_33BC(M1, M3, M2, M4);
      end;
      Far113E(G71F2[11], $691);
      Far1159(G71F2[12], $691);
    end;
  end;
  Proc22_0E0C := Flag;
  Far1972(Q, $A2);
end;
{$F+}

function Far0F07(A0: Word): PW22;
begin
  Far0F07 := NIL;
end;

function Far0F16(A0: Word): Pointer;
begin
  Far0F16 := NIL;
end;

function Far112E(A0: Word): Pointer;
begin
  Far112E := NIL;
end;

function Far103A(A0, A1: Word): Byte;
begin
  Far103A := 0;
end;

function Far104F(A0, A1: Word; A2: LongInt): Word;
begin
  Far104F := 0;
end;

function Far1087(A0, A1: Word; A2: LongInt): Word;
begin
  Far1087 := 0;
end;

function Far1072(A0, A1: Word; A2: LongInt): Word;
begin
  Far1072 := 0;
end;

function Far172B(A0, A1: Word; A2: LongInt): Word;
begin
  Far172B := 0;
end;

procedure Far113E(A0: Pointer; A1: Word);
begin
end;

procedure Far1159(A0: Pointer; A1: Word);
begin
end;

procedure Far1972(A0: Pointer; A1: Word);
begin
end;

function FarC75(A0, A1: LongInt): Byte;
begin
  FarC75 := 0;
end;

function FarC95(A0, A1: LongInt): Byte;
begin
  FarC95 := 0;
end;

function FarCB5(A0, A1: LongInt): Byte;
begin
  FarCB5 := 0;
end;

function FarE34(A0, A1: LongInt): Byte;
begin
  FarE34 := 0;
end;

{$F-}
{ ADDRESS: MAIN 0x00161290 }
function Proc22_1290(A0, A1: Word): Word;
var
  R: Word;
procedure Proc22_1162(X, Y: Word);
begin
  Dec(Map0^[X, Y]);
  if Map0^[X + 1, Y] - Map0^[X, Y] = 2 then
    Proc22_1162(X + 1, Y);
  if Map0^[X, Y + 1] - Map0^[X, Y] = 2 then
    Proc22_1162(X, Y + 1);
  if Map0^[X - 1, Y] - Map0^[X, Y] = 2 then
    Proc22_1162(X - 1, Y);
  if Map0^[X, Y - 1] - Map0^[X, Y] = 2 then
    Proc22_1162(X, Y - 1);
end;

begin
  if Map0^[A0, A1] > 0 then
  begin
    Proc22_1162(A0, A1);
    R := 0;
  end
  else
    R := 1;
  Proc22_1290 := R;
end;
{$F+}

{ ADDRESS: MAIN 0x00161907 }
function Proc22_1907(X, Y: Word; B: Byte; var L: LongInt): Word;
var
  Res: Word;
  Flag: Word;
  PosY: Word;
  PosX: Word;
  L9: Byte;
  LA: Byte;
  LB: Byte;
  LC: Byte;
  o1: Integer;
  o2: Integer;
  procedure Proc22_12C7(dx, dy: Word);
  begin
    if PMask20(G71F2[12])^.Cells[dx, dy] <> $FF then
    begin
      if PMask20(G71F2[12])^.Cells[dx, dy] = $C then
      begin
        PMask20(G71F2[12])^.Cells[dx, dy] := $FF;
        L := L + L64F2;
      end
      else
      begin
        Flag := 1;
        PosX := X + dx;
        PosY := Y + dy;
      end;
    end;
    if PMask20(G71F2[12])^.Cells[dx + 1, dy] <> $FF then
    begin
      if PMask20(G71F2[12])^.Cells[dx + 1, dy] = $C then
      begin
        PMask20(G71F2[12])^.Cells[dx + 1, dy] := $FF;
        L := L + L64F2;
      end
      else
      begin
        Flag := 1;
        PosX := X + dx + 1;
        PosY := Y + dy;
      end;
    end;
    if PMask20(G71F2[12])^.Cells[dx, dy + 1] <> $FF then
    begin
      if PMask20(G71F2[12])^.Cells[dx, dy + 1] = $C then
      begin
        PMask20(G71F2[12])^.Cells[dx, dy + 1] := $FF;
        L := L + L64F2;
      end
      else
      begin
        Flag := 1;
        PosX := X + dx;
        PosY := Y + dy + 1;
      end;
    end;
    if PMask20(G71F2[12])^.Cells[dx + 1, dy + 1] <> $FF then
    begin
      if PMask20(G71F2[12])^.Cells[dx + 1, dy + 1] = $C then
      begin
        PMask20(G71F2[12])^.Cells[dx + 1, dy + 1] := $FF;
        L := L + L64F2;
      end
      else
      begin
        Flag := 1;
        PosX := X + dx + 1;
        PosY := Y + dy + 1;
      end;
    end;
    if Flag = 0 then
    begin
      Dec(PMask20(G71F2[11])^.Cells[dx, dy]);
      L9 := Far174B(L9, X + dx);
      LB := Far176B(LB, Y + dy);
      LA := Far178B(LA, X + dx);
      LC := Far19AF(LC, Y + dy);
      if PMask20(G71F2[11])^.Cells[dx, dy] = 0 then
        L := L + L64E2
      else
        L := L + L64E6;
      if PMask20(G71F2[11])^.Cells[dx + 1, dy] -
         PMask20(G71F2[11])^.Cells[dx, dy] = 2 then
        Proc22_12C7(dx + 1, dy);
      if PMask20(G71F2[11])^.Cells[dx, dy + 1] -
         PMask20(G71F2[11])^.Cells[dx, dy] = 2 then
        Proc22_12C7(dx, dy + 1);
      if PMask20(G71F2[11])^.Cells[dx - 1, dy] -
         PMask20(G71F2[11])^.Cells[dx, dy] = 2 then
        Proc22_12C7(dx - 1, dy);
      if PMask20(G71F2[11])^.Cells[dx, dy - 1] -
         PMask20(G71F2[11])^.Cells[dx, dy] = 2 then
        Proc22_12C7(dx, dy - 1);
    end;
  end;
begin
  Res := 0;
  Flag := 0;
  L := 0;
  if (X >= 0) and (X <= 250) and (Y >= 0) and (Y <= 250) then
  begin
    if Map0^[X, Y] <= 0 then
      Flag := 3
    else
    begin
      G71F2[11] := Far1981($691);
      G71F2[12] := Far1C0E($691);
      for o1 := -20 to 20 do
        for o2 := -20 to 20 do
          if Far1AB3(X + o1, Y + o2) then
          begin
            PMask20(G71F2[11])^.Cells[o1, o2] := Map0^[X + o1, Y + o2];
            PMask20(G71F2[12])^.Cells[o1, o2] :=
              MapTileMid^[X + o1, Y + o2];
          end
          else
          begin
            PMask20(G71F2[11])^.Cells[o1, o2] := 0;
            PMask20(G71F2[12])^.Cells[o1, o2] := $FF;
          end;
      PosX := X;
      PosY := Y;
      Proc22_12C7(0, 0);
      if B = 1 then
        if Far1BFE(B) < L then
          Flag := 14;
      if Flag = 0 then
      begin
        for o1 := Far1AEB(0, 0, X - 20) to
                  Far1AC8(0, $fa, X + 20) do
          for o2 := Far1ECA(0, 0, Y - 20) to
                    Far1B00(0, $fa, Y + 20) do
          begin
            Map0^[o1, o2] :=
              PMask20(G71F2[11])^.Cells[o1 - X, o2 - Y];
            MapTileMid^[o1, o2] :=
              PMask20(G71F2[12])^.Cells[o1 - X, o2 - Y];
          end;
        Proc22_33BC(L9, LB, LA, LC);
        Proc10_264D(L9, LB, LA + 1, LC + 1);
        Proc23_1504(L9, LB, LA + 1, LC + 1, G723A);
        if Map0^[X, Y] = 0 then
          Proc15_0D00(Byte(X), Byte(Y));
      end;
      Far1C1E(G71F2[11], $691);
      Far20A6(G71F2[12], $691);
    end;
  end;
  if Flag <> 0 then
  begin
    Proc17_0324(PosY, PosX, $2a);
    W64BA := PosX;
    W64BC := PosY;
  end;
  Res := Flag;
  Proc22_1907 := Res;
end;

function Far1AB3(A0, A1: Word): Boolean;
begin
  Far1AB3 := False;
end;

function Far1AC8(A0, A1: Word; A2: LongInt): Word;
begin
  Far1AC8 := 0;
end;

function Far1AEB(A0, A1: Word; A2: LongInt): Word;
begin
  Far1AEB := 0;
end;

function Far1B00(A0, A1: Word; A2: LongInt): Word;
begin
  Far1B00 := 0;
end;

function Far1ECA(A0, A1: Word; A2: LongInt): Word;
begin
  Far1ECA := 0;
end;

function Far1BFE(A0: Byte): LongInt;
begin
  Far1BFE := 0;
end;

function Far174B(A0, A1: LongInt): Byte;
begin
  Far174B := 0;
end;

function Far176B(A0, A1: LongInt): Byte;
begin
  Far176B := 0;
end;

function Far178B(A0, A1: LongInt): Byte;
begin
  Far178B := 0;
end;

function Far19AF(A0, A1: LongInt): Byte;
begin
  Far19AF := 0;
end;

function Far1981(A0: Word): Pointer;
begin
  Far1981 := NIL;
end;

function Far1C0E(A0: Word): Pointer;
begin
  Far1C0E := NIL;
end;

procedure Far1C1E(A0: Pointer; A1: Word);
begin
end;

procedure Far20A6(A0: Pointer; A1: Word);
begin
end;

{$F-}
{ ADDRESS: MAIN 0x00162053 }
function Proc22_2053(A0, A1: Word): Word;
var
  Flag: Word;
  N1: Byte;
  N2: Byte;
  N3: Byte;
  N4: Byte;
  o1: Integer;
  o2: Integer;
  procedure Proc22_1C54(P1, P2: Word);
  begin
    if PMask20(G71F2[12])^.Cells[P1, P2] = $C then
      PMask20(G71F2[12])^.Cells[P1, P2] := $FF;
    if PMask20(G71F2[12])^.Cells[P1 + 1, P2] = $C then
      PMask20(G71F2[12])^.Cells[P1 + 1, P2] := $FF;
    if PMask20(G71F2[12])^.Cells[P1, P2 + 1] = $C then
      PMask20(G71F2[12])^.Cells[P1, P2 + 1] := $FF;
    if PMask20(G71F2[12])^.Cells[P1 + 1, P2 + 1] = $C then
      PMask20(G71F2[12])^.Cells[P1 + 1, P2 + 1] := $FF;
    if Flag = 0 then
      if (MapTileA^[A0 + P1, A1 + P2] >= $37) and
         (MapTileA^[A0 + P1, A1 + P2] <= $5e) then
        Flag := $10;
    if Flag = 0 then
      if (MapTileA^[A0 + P1 + 1, A1 + P2] >= $37) and
         (MapTileA^[A0 + P1 + 1, A1 + P2] <= $5e) then
        Flag := $10;
    if Flag = 0 then
      if (MapTileA^[A0 + P1, A1 + P2 + 1] >= $37) and
         (MapTileA^[A0 + P1, A1 + P2 + 1] <= $5e) then
        Flag := $10;
    if Flag = 0 then
      if (MapTileA^[A0 + P1 + 1, A1 + P2 + 1] >= $37) and
         (MapTileA^[A0 + P1 + 1, A1 + P2 + 1] <= $5e) then
        Flag := $10;
    if Flag = 0 then
    begin
      Dec(PMask20(G71F2[11])^.Cells[P1, P2]);
      N1 := Far1EEA(N1, A0 + P1);
      N3 := Far1F0A(N3, A1 + P2);
      N2 := Far1F2A(N2, A0 + P1);
      N4 := Far20E3(N4, A1 + P2);
      if PMask20(G71F2[11])^.Cells[P1 + 1, P2] -
         PMask20(G71F2[11])^.Cells[P1, P2] = 2 then
        Proc22_1C54(P1 + 1, P2);
      if PMask20(G71F2[11])^.Cells[P1, P2 + 1] -
         PMask20(G71F2[11])^.Cells[P1, P2] = 2 then
        Proc22_1C54(P1, P2 + 1);
      if PMask20(G71F2[11])^.Cells[P1 - 1, P2] -
         PMask20(G71F2[11])^.Cells[P1, P2] = 2 then
        Proc22_1C54(P1 - 1, P2);
      if PMask20(G71F2[11])^.Cells[P1, P2 - 1] -
         PMask20(G71F2[11])^.Cells[P1, P2] = 2 then
        Proc22_1C54(P1, P2 - 1);
    end;
  end;
begin
  Flag := 0;
  if (A0 >= 0) and (A0 <= 250) and (A1 >= 0) and (A1 <= 250) then
  begin
    if Map0^[A0, A1] <= 0 then
      Flag := 3
    else
    begin
      G71F2[11] := Far20B5($691);
      G71F2[12] := Far22B7($691);
      for o1 := -20 to 20 do
        for o2 := -20 to 20 do
          if (A0 + o1 >= 0) and (A0 + o1 <= 250) and (A1 + o2 >= 0)
             and (A1 + o2 <= 250) then
          begin
            PMask20(G71F2[11])^.Cells[o1, o2] := Map0^[A0 + o1, A1 + o2];
            PMask20(G71F2[12])^.Cells[o1, o2] :=
              MapTileMid^[A0 + o1, A1 + o2];
          end
          else
          begin
            PMask20(G71F2[11])^.Cells[o1, o2] := 0;
            PMask20(G71F2[12])^.Cells[o1, o2] := $FF;
          end;
      N1 := A0;
      N2 := A0;
      N3 := A1;
      N4 := A1;
      Proc22_1C54(0, 0);
      if Flag = 0 then
      begin
        for o1 := Far21FB(0, 0, A0 - 20) to Far21D8(0, $fa, A0 + 20) do
          for o2 := Far31AB(0, 0, A1 - 20) to Far2210(0, $fa, A1 + 20) do
          begin
            Map0^[o1, o2] :=
              PMask20(G71F2[11])^.Cells[o1 - A0, o2 - A1];
            MapTileMid^[o1, o2] :=
              PMask20(G71F2[12])^.Cells[o1 - A0, o2 - A1];
          end;
        Proc22_33BC(N1, N3, N2, N4);
      end;
      Far22C7(G71F2[11], $691);
      Far29CA(G71F2[12], $691);
    end;
  end
  else
    Flag := 3;
  Proc22_2053 := Flag;
end;
{$F+}

function Far20B5(A0: Word): Pointer;
begin
  Far20B5 := NIL;
end;

function Far22B7(A0: Word): Pointer;
begin
  Far22B7 := NIL;
end;

function Far21C3(A0, A1: Word): Byte;
begin
  Far21C3 := 0;
end;

function Far21D8(A0, A1: Word; A2: LongInt): Word;
begin
  Far21D8 := 0;
end;

function Far2210(A0, A1: Word; A2: LongInt): Word;
begin
  Far2210 := 0;
end;

function Far21FB(A0, A1: Word; A2: LongInt): Word;
begin
  Far21FB := 0;
end;

function Far31AB(A0, A1: Word; A2: LongInt): Word;
begin
  Far31AB := 0;
end;

procedure Far22C7(A0: Pointer; A1: Word);
begin
end;

procedure Far29CA(A0: Pointer; A1: Word);
begin
end;

function Far1EEA(A0, A1: LongInt): Byte;
begin
  Far1EEA := 0;
end;

function Far1F0A(A0, A1: LongInt): Byte;
begin
  Far1F0A := 0;
end;

function Far1F2A(A0, A1: LongInt): Byte;
begin
  Far1F2A := 0;
end;

function Far20E3(A0, A1: LongInt): Byte;
begin
  Far20E3 := 0;
end;

{$F-}
{ ADDRESS: MAIN 0x001629c0 }
procedure Proc22_29C0;
var
  Count: Word;
  S1: Pointer;
  S2: Pointer;
  S3: Pointer;
  J: Byte;
  I: Byte;
procedure Proc22_23C3(A1, A2: Word);
label LoopTop;
var
  Flag: Byte;
  Code: Byte;
  Row: Byte;
  Col: Byte;
  Counter: Word;
  Temp: Byte;
  { Nested helpers: discovery entries 22:0x239A / 22DD / 233B,
    pushed-BP static-link protocol (round 675). This whole procedure is the
    middle frame of Proc22_29C0 (round 680): Count and S1..S3 resolve through
    the static link instead of a parameter. }
  procedure SetCell(First, Second: Byte);
  begin
    Col := Second;
    Row := First;
    Code := 0;
  end;
  procedure PushState(N: Byte);
  begin
    PBytes22(S1)^[Counter] := Col;
    PBytes22(S2)^[Counter] := Row;
    PBytes22(S3)^[Counter] := N;
    Inc(Counter);
  end;
  procedure PopState;
  begin
    Dec(Counter);
    Col := PBytes22(S1)^[Counter];
    Row := PBytes22(S2)^[Counter];
    Code := PBytes22(S3)^[Counter];
  end;
begin
  Counter := 0;
  Flag := 0;
  SetCell(Byte(A1), Byte(A2));
LoopTop:
  if Flag <> 0 then
    Exit;
  Temp := Code;
  case Temp of
    0:
      begin
        HalfMap^[Col div 2, Row] := Count;
        Code := 1;
      end;
    1:
      if Col mod 2 = 0 then
      begin
        if (Map0^[Col, Row - 1] <> 0) and (HalfMap^[Col div 2, Row - 1] = $FFFF) then
        begin
          PushState(2);
          SetCell(Row - 1, Col);
        end
        else if (Map0^[Col + 1, Row] <> 0) and (Map0^[Col + 1, Row - 1] <> 0)
          and (HalfMap^[Col div 2, Row - 1] = $FFFF) then
        begin
          PushState(2);
          SetCell(Row - 1, Col + 1);
        end
        else
          Code := 2;
      end
      else
      begin
        if (Map0^[Col, Row - 1] <> 0) and (HalfMap^[Col div 2, Row - 1] = $FFFF) then
        begin
          PushState(2);
          SetCell(Row - 1, Col);
        end
        else if (Map0^[Col - 1, Row] <> 0) and (Map0^[Col - 1, Row - 1] <> 0)
          and (HalfMap^[Col div 2, Row - 1] = $FFFF) then
        begin
          PushState(2);
          SetCell(Row - 1, Col - 1);
        end
        else
          Code := 2;
      end;
    2:
      if Col mod 2 = 0 then
      begin
        if (Map0^[Col, Row + 1] <> 0) and (HalfMap^[Col div 2, Row + 1] = $FFFF) then
        begin
          PushState(3);
          SetCell(Row + 1, Col);
        end
        else if (Map0^[Col + 1, Row] <> 0) and (Map0^[Col + 1, Row + 1] <> 0)
          and (HalfMap^[Col div 2, Row + 1] = $FFFF) then
        begin
          PushState(3);
          SetCell(Row + 1, Col + 1);
        end
        else
          Code := 3;
      end
      else
      begin
        if (Map0^[Col, Row + 1] <> 0) and (HalfMap^[Col div 2, Row + 1] = $FFFF) then
        begin
          PushState(3);
          SetCell(Row + 1, Col);
        end
        else if (Map0^[Col - 1, Row] <> 0) and (Map0^[Col - 1, Row + 1] <> 0)
          and (HalfMap^[Col div 2, Row + 1] = $FFFF) then
        begin
          PushState(3);
          SetCell(Row + 1, Col - 1);
        end
        else
          Code := 3;
      end;
    3:
      if Col mod 2 = 0 then
      begin
        if (Map0^[Col - 1, Row] <> 0) and (HalfMap^[(Col - 1) div 2, Row] = $FFFF) then
        begin
          PushState(4);
          SetCell(Row, Col - 1);
        end
        else
          Code := 4;
      end
      else
      begin
        if (Map0^[Col - 1, Row] <> 0) and (Map0^[Col - 2, Row] <> 0)
          and (HalfMap^[(Col - 1) div 2, Row] = $FFFF) then
        begin
          PushState(4);
          SetCell(Row, Col - 2);
        end
        else
          Code := 4;
      end;
    4:
      if Col mod 2 = 0 then
      begin
        if (Map0^[Col + 1, Row] <> 0) and (Map0^[Col + 2, Row] <> 0)
          and (HalfMap^[(Col + 1) div 2, Row] = $FFFF) then
        begin
          PushState(5);
          SetCell(Row, Col + 2);
        end
        else
          Code := 5;
      end
      else
      begin
        if (Map0^[Col + 1, Row] <> 0) and (HalfMap^[(Col + 1) div 2, Row] = $FFFF) then
        begin
          PushState(5);
          SetCell(Row, Col + 1);
        end
        else
          Code := 5;
      end;
    5:
      if Counter = 0 then
        Flag := 1
      else
        PopState;
  end;
  goto LoopTop;
end;
begin
  S1 := Far29D8($88B9);
  S2 := Far29E6($88B9);
  S3 := Far2B7B($88B9);
  Count := 1;
  for I := 0 to 250 do
    for J := 0 to 125 do
      HalfMap^[J, I] := $FFFF;
  for I := 0 to 250 do
    for J := 0 to 250 do
      if J mod 2 = 0 then
      begin
        if HalfMap^[J div 2, I] = $FFFF then
          HalfMap^[J div 2, I] := 0;
        if (Map0^[J, I] <> 0) and (HalfMap^[J div 2, I] = $FFFF) then
        begin
          Proc22_23C3(I, J);
          Inc(Count);
        end;
      end
      else if (Map0^[J, I] <> 0) and (HalfMap^[J div 2, I] = 0) then
      begin
        Proc22_23C3(I, J);
        Inc(Count);
      end;
  W552C := Count - 1;
  Far2B89($88B9, S1);
  Far2B97($88B9, S2);
  Far37C1($88B9, S3);
end;
{$F+}

function Far29D8(Arg: Word): Pointer;
begin
  Far29D8 := nil;
end;

function Far29E6(Arg: Word): Pointer;
begin
  Far29E6 := nil;
end;

function Far2B7B(Arg: Word): Pointer;
begin
  Far2B7B := nil;
end;

procedure Far2B89(Arg: Word; P: Pointer);
begin
end;

procedure Far2B97(Arg: Word; P: Pointer);
begin
end;

procedure Far37C1(Arg: Word; P: Pointer);
begin
end;

{ ADDRESS: MAIN 0x00162b9b }
function Proc22_2B9B(X, Y, W: Integer; B: Byte; P: PLong22): Word;
var
  Flag: Word;
  L: LongInt;
begin
  P^ := 0;
  if (X > 0) and (Y > 0) and (X < 250) and (Y < 250) then
  begin
    Flag := 0;
    while (Map0^[X, Y] < W) and (Flag = 0) do
    begin
      Flag := Proc22_069F(X, Y, B, L);
      P^ := P^ + L;
    end;
    while (Map0^[X, Y] > W) and (Flag = 0) do
    begin
      Flag := Proc22_1907(X, Y, B, L);
      P^ := P^ + L;
    end;
  end;
  Proc22_2B9B := Flag;
end;

{ ADDRESS: MAIN 0x00162c83 }
function Proc22_2C83(X, Y, W: Integer; B: Byte; P: PLong22): Word;
var
  Flag: Word;
  L: LongInt;
begin
  P^ := 0;
  if (X > 0) and (Y > 0) and (X < 250) and (Y < 250) then
  begin
    Flag := 0;
    if (Map0^[X, Y] < W) and (Flag = 0) then
    begin
      Flag := Proc22_069F(X, Y, B, L);
      P^ := P^ + L;
    end
    else if (Map0^[X, Y] > W) and (Flag = 0) then
    begin
      Flag := Proc22_1907(X, Y, B, L);
      P^ := P^ + L;
    end;
  end
  else
    Flag := 22;
  Proc22_2C83 := Flag;
end;

{$F-}
{ ADDRESS: MAIN 0x00162d70 }
function Proc22_2D70(X, Y, W: Integer): Word;
var
  Flag: Word;
begin
  Flag := 0;
  if (X > 0) and (Y > 0) and (X < 250) and (Y < 250) then
  begin
    while (Map0^[X, Y] < W) and (Flag = 0) do
      Flag := Proc22_0E0C(Y, X);
    while (Map0^[X, Y] > W) and (Flag = 0) do
      Flag := Proc22_2053(Y, X);
  end
  else
    Flag := 22;
  Proc22_2D70 := Flag;
end;
{$F+}

{$F-}
{ ADDRESS: MAIN 0x00162e03 }
function Proc22_2E03(Y, X, W: Integer): Word;
var
  Flag: Word;
begin
  Flag := 0;
  Flag := Proc22_2D70(X, Y, W);
  if Flag = 0 then
    Flag := Proc22_2D70(X, Y, W - 1);
  if Flag = 0 then
    Flag := Proc22_2D70(X, Y - 1, W);
  if Flag = 0 then
    Flag := Proc22_2D70(X, Y - 1, W - 1);
  Proc22_2E03 := Flag;
end;
{$F+}

{$F-}
{ ADDRESS: MAIN 0x00162e6f }
function Proc22_2E6F(Y, X: Integer; Cell, B: Byte): Word;
var
  R: Word;
begin
  R := 0;
  case B of
    0:
      begin
        R := Proc22_2D70(X, Y, Cell - 1);
        if R = 0 then
          R := Proc22_2D70(X - 1, Y, Cell - 1);
        if R = 0 then
          R := Proc22_2D70(X, Y - 1, Cell - 1);
        if R = 0 then
          R := Proc22_2D70(X - 1, Y - 1, Cell - 1);
      end;
    1:
      begin
        R := Proc22_2D70(X, Y, Cell - 1);
        if R = 0 then
          R := Proc22_2D70(X - 1, Y, Cell);
        if R = 0 then
          R := Proc22_2D70(X, Y - 1, Cell - 1);
        if R = 0 then
          R := Proc22_2D70(X - 1, Y - 1, Cell - 1);
      end;
    2:
      begin
        R := Proc22_2D70(X, Y, Cell);
        if R = 0 then
          R := Proc22_2D70(X - 1, Y, Cell);
        if R = 0 then
          R := Proc22_2D70(X, Y - 1, Cell - 1);
        if R = 0 then
          R := Proc22_2D70(X - 1, Y - 1, Cell - 1);
      end;
    3:
      begin
        R := Proc22_2D70(X, Y, Cell);
        if R = 0 then
          R := Proc22_2D70(X - 1, Y, Cell - 1);
        if R = 0 then
          R := Proc22_2D70(X, Y - 1, Cell);
        if R = 0 then
          R := Proc22_2D70(X - 1, Y - 1, Cell - 1);
      end;
  end;
  Proc22_2E6F := R;
end;
{$F+}

{$F-}
{ ADDRESS: MAIN 0x00163030 }
procedure Proc22_3030;
var
  Col, Row: Byte;
begin
  for Row := 0 to 250 do
  begin
    for Col := 0 to 250 do
    begin
      Map0^[Col, Row] := 0;
      MapTileC^[Col, Row] := $10;
      MapTileMid^[Col, Row] := $ff;
      MapTileA^[Col, Row] := 2;
      G5510^[Col, Row] := 0;
      G5514^[Col, Row] := 0;
      G5518^[Col, Row] := 0;
    end;
  end;
  for Row := 0 to 250 do
    for Col := 0 to 125 do
      HalfMap^[Col, Row] := 0;
  W552C := 0;
  for Row := 0 to 125 do
    for Col := 0 to 125 do
      G5524^[Col, Row] := $7f;
end;
{$F+}

{ ADDRESS: MAIN 0x00163199 }
procedure Proc22_3199(X, Y: Byte);
var
  R: Byte;
begin
  if Far31E4(X, Y) <> 0 then
  begin
    if MapTileMid^[X, Y] = $FF then
    begin
      R := Proc6_208D(X, Y);
      if R = 0 then
        MapTileA^[X, Y] := 2
      else if R = 1 then
      begin
        if Proc6_1FDB(X, Y) < 3 then
          MapTileA^[X, Y] := 0
        else
        begin
          MapTileA^[X, Y] := 4;
          G5510^[X, Y] := 1;
        end;
      end
      else if R = 2 then
      begin
        if Proc6_1FDB(X, Y) < 3 then
          MapTileA^[X, Y] := 0
        else
        begin
          MapTileA^[X, Y] := 4;
          G5510^[X, Y] := 0;
        end;
      end
      else
        MapTileA^[X, Y] := 1;
      if MapTileA^[X, Y] <> 4 then
      begin
        if G5510^[X, Y] >=
          PFar4Arr22(Tbl54E6)^[G1202[MapTileA^[X, Y]] + MapTileC^[X, Y]].Lo then
          G5510^[X, Y] := 0;
      end;
    end;
  end;
end;

function Far31E4(A0, A1: Byte): Byte;
begin
  Far31E4 := 0;
end;

{ ADDRESS: MAIN 0x001633bc }
procedure Proc22_33BC(A0, A1, A2, A3: Byte);
label LoopTop, Done;
var
  N: Byte;
  v1: Word;
  v2: Word;
begin
  if A1 <= A3 + 1 then
  begin
    for v1 := A1 to A3 + 1 do
    begin
      if A0 <= A2 + 1 then
      begin
        for v2 := A0 to A2 + 1 do
        begin
          N := 0;
        LoopTop:
          if Map0^[v2, v1 - 1] + G1226[N][0] = Map0^[v2, v1 - 1] then
            if Map0^[v2 - 1, v1 - 1] + G1226[N][1] =
               Map0^[v2 - 1, v1 - 1] then
              if Map0^[v2 - 1, v1] + G1226[N][2] = Map0^[v2 - 1, v1] then
                goto Done;
          if N > $12 then
            goto Done;
          Inc(N);
          goto LoopTop;
        Done:
          if N > $12 then
            MapTileC^[v2, v1] := N
          else
            MapTileC^[v2, v1] := N;
          if MapTileA^[v2, v1] < $0a then
            Proc22_3199(Byte(v2), Byte(v1));
        end;
      end;
    end;
  end;
end;

{$F-}
{ ADDRESS: MAIN 0x0016354c }
procedure Proc22_354C;
label LoopTop, Done;
var
  N: Byte;
  v2: Byte;
  v1: Byte;
begin
  for v1 := 1 to $f9 do
    for v2 := 1 to $f9 do
      if Proc6_1FDB(v2, v1) <> 0 then
      begin
        N := 0;
      LoopTop:
        if Map0^[v2, v1 - 1] + G1226[N][0] = Map0^[v2, v1 - 1] then
          if Map0^[v2 - 1, v1 - 1] + G1226[N][1] =
             Map0^[v2 - 1, v1 - 1] then
            if Map0^[v2 - 1, v1] + G1226[N][2] = Map0^[v2 - 1, v1] then
              goto Done;
        if N > $12 then
          goto Done;
        Inc(N);
        goto LoopTop;
      Done:
        if N > $12 then
          MapTileC^[v2, v1] := N
        else
          MapTileC^[v2, v1] := N;
        Proc22_3199(v2, v1);
      end
      else
      begin
        MapTileC^[v2, v1] := $10;
        MapTileA^[v2, v1] := 2;
      end;
end;
{$F+}

{$F-}
{ ADDRESS: MAIN 0x0016371e }
procedure Proc22_371E(var A, B: TCell22);
var
  Temp: TCell22;
begin
  Temp := A;
  A := B;
  B := Temp;
end;
{$F+}

{$F-}
{ ADDRESS: MAIN 0x00163904 }
procedure Proc22_3904(A0, A1, A2: Word);
var
  C1: TCell22;
  C2: TCell22;
  C3: TCell22;
  C4: TCell22;
  Min: Integer;
  Bottom: Integer;
  v: Integer;
  x: Integer;
  procedure Proc22_375A(P1, P2: TCell22);
  var
    i: Integer;
    Slope: Double;
    Acc: Double;
  begin
    if Abs(P2.Y - P1.Y) > Abs(P2.X - P1.X) then
    begin
      if P1.Y > P2.Y then
        Proc22_371E(P1, P2);
      Slope := (P2.X - P1.X) / (P2.Y - P1.Y);
      Acc := P1.X;
      PTGridM50W22(G71F2[13])^[P1.X, P1.Y] := 1;
      for i := P1.Y + 1 to P2.Y do
      begin
        Acc := Acc + Slope;
        PTGridM50W22(G71F2[13])^[Trunc(Acc), i] := 1;
      end;
    end
    else
    begin
      if P1.X > P2.X then
        Proc22_371E(P1, P2);
      Slope := (P2.Y - P1.Y) / (P2.X - P1.X);
      Acc := P1.Y;
      PTGridM50W22(G71F2[13])^[P1.X, P1.Y] := 1;
      for i := P1.X + 1 to P2.X do
      begin
        Acc := Acc + Slope;
        PTGridM50W22(G71F2[13])^[i, Trunc(Acc)] := 1;
      end;
    end;
  end;
begin
  A2 := Far4059(A2, 0, 50);
  if (A0 > A2) and (A1 > A2) and (250 - A2 > A0) and (250 - A2 > A1) then
  begin
    for v := -A2 to A2 do
      for x := -A2 to A2 do
      begin
        PTGridM50W22(G71F2[13])^[v, x] := 0;
        PTGridM50W22(G71F2[14])^[v, x] := Map0^[v + A0, x + A1];
      end;
    C1.X := -(LongInt(Far39FF(A2) + 1));
    C1.Y := -(LongInt(Far3A14(A2) + 1));
    C2.X := Far3A20(A2) + 1;
    C2.Y := -(LongInt(Far3A35(A2) + 1));
    C3.X := -(LongInt(Far3A4A(A2) + 1));
    C3.Y := Far3A56(A2) + 1;
    C4.X := Far3A62(A2) + 1;
    C4.Y := Far3C82(A2) + 1;
    Proc22_375A(C1, C3);
    Proc22_375A(C2, C4);
    Proc22_375A(C1, C2);
    Proc22_375A(C3, C4);
    for x := -A2 to A2 do
    begin
      v := -A2;
      while (PTGridM50W22(G71F2[13])^[v, x] = 0) and (v <= A2) do
        Inc(v);
      if v < A2 then
      begin
        Min := v;
        v := A2;
        while (PTGridM50W22(G71F2[13])^[v, x] = 0) and (v > Min) do
          Dec(v);
        Bottom := v;
        if Min <= Bottom then
          for v := Min to Bottom do
            PTGridM50W22(G71F2[13])^[v, x] := 1;
      end;
    end;
    for v := -A2 to A2 do
      for x := -A2 to A2 do
        repeat
        until (Map0^[v + A0, x + A1] >=
                 PTGridM50W22(G71F2[14])^[v, x] +
                 PTGridM50W22(G71F2[13])^[v, x]) or
              (Map0^[v + A0, x + A1] >= $14) or
              (Proc22_0130(v + A0, x + A1) <> 0);
  end;
end;
{$F+}

function Far4059(A0: LongInt; A1, A2: Word): Word;
begin
  Far4059 := 0;
end;

function Far39FF(A0: Word): Word;
begin
  Far39FF := 0;
end;

function Far3A14(A0: Word): Word;
begin
  Far3A14 := 0;
end;

function Far3A20(A0: Word): Word;
begin
  Far3A20 := 0;
end;

function Far3A35(A0: Word): Word;
begin
  Far3A35 := 0;
end;

function Far3A4A(A0: Word): Word;
begin
  Far3A4A := 0;
end;

function Far3A56(A0: Word): Word;
begin
  Far3A56 := 0;
end;

function Far3A62(A0: Word): Word;
begin
  Far3A62 := 0;
end;

function Far3C82(A0: Word): Word;
begin
  Far3C82 := 0;
end;

{$F-}
{ ADDRESS: MAIN 0x00163c5c }
procedure Proc22_3C5C;
type
  TRange4 = packed record
    lo, hi: Integer;
  end;
  PGridI = ^TGridI;
  TGridI = array[0..4, 0..4] of Integer;
var
  A: array[0..12] of TRange4;
  R: Integer;
  S, P, Q, I: Word;
  K: Integer;
begin
  for I := 0 to 11 do
  begin
    A[I].lo := G3CF4[I, 0] + Random(G3CF4[I, 2] - G3CF4[I, 0]);
    A[I].hi := G3CF4[I, 1] + Random(G3CF4[I, 3] - G3CF4[I, 1]);
  end;
  A[12] := A[0];
  for I := 0 to 11 do
  begin
    for K := 1 to PGridI(G71F2[5])^[G008E, G0090] do
    begin
      R := Random(101);
      P := (A[I + 1].lo - A[I].lo) * R div 100 + A[I].lo
           + LongInt(Random(PGridI(G71F2[9])^[G008E, G0090]))
           - LongInt(PGridI(G71F2[9])^[G008E, G0090] div 2);
      Q := (A[I + 1].hi - A[I].hi) * R div 100 + A[I].hi
           + LongInt(Random(PGridI(G71F2[9])^[G008E, G0090]))
           - LongInt(PGridI(G71F2[9])^[G008E, G0090] div 2);
      Proc22_3904(P, Q, Random(PGridI(G71F2[7])^[G008E, G0090]) + 1);
    end;
    for K := 1 to PGridI(G71F2[6])^[G008E, G0090] do
    begin
      R := Random(101);
      P := (A[I + 1].lo - A[I].lo) * R div 100 + A[I].lo
           + LongInt(Random(PGridI(G71F2[10])^[G008E, G0090]))
           - LongInt(PGridI(G71F2[9])^[G008E, G0090] div 2);
      Q := (A[I + 1].hi - A[I].hi) * R div 100 + A[I].hi
           + LongInt(Random(PGridI(G71F2[10])^[G008E, G0090]))
           - LongInt(PGridI(G71F2[9])^[G008E, G0090] div 2);
      Proc22_3904(P, Q, Random(PGridI(G71F2[8])^[G008E, G0090]) + 1);
    end;
  end;
  S := Random(30) + 20;
  for K := 1 to S do
    Proc22_3904(LongInt(G3CF4[12, 2] - G3CF4[12, 0]) * Random(101) div 100 + G3CF4[12, 0],
                LongInt(G3CF4[12, 3] - G3CF4[12, 1]) * Random(101) div 100 + G3CF4[12, 1],
                Random(3) + 2);
end;
{$F+}

{$F-}
{ ADDRESS: MAIN 0x0016404c }
procedure Proc22_404C(A0, A1, A2, A3, A4: Word);
var
  Ext: LongInt;
  v1: Word;
  v2: Word;
  T: Integer;
begin
  Ext := Far406E(A2);
  A4 := Far40BA(0, $27, A4);
  for v1 := A0 - A2 to A0 + A2 do
    for v2 := A1 - A2 to A1 + A2 do
      if (Far40CA(v2 - A1) + Far4542(v1 - A0) <= Ext) and (Far40F4(A3) = 0) then
      begin
        T := Far416B(A4 - 4) + 4;
        if (T >= 1) and (T <= 49) then
          Proc22_3904(v1, v2, T);
      end;
end;
{$F+}

function Far406E(A0: LongInt): LongInt;
begin
  Far406E := 0;
end;

function Far40BA(A0, A1: Word; A2: LongInt): Word;
begin
  Far40BA := 0;
end;

function Far40CA(A0: LongInt): LongInt;
begin
  Far40CA := 0;
end;

function Far4542(A0: LongInt): LongInt;
begin
  Far4542 := 0;
end;

function Far40F4(A0: Word): Word;
begin
  Far40F4 := 0;
end;

function Far416B(A0: Word): Word;
begin
  Far416B := 0;
end;

{$F-}
{ ADDRESS: MAIN 0x0016412c }
procedure Proc22_412C;
begin
  Proc22_404C(125, 125,
    PGrid5W22(G71F2[2])^[G008E, G0090],
    PGrid5W22(G71F2[3])^[G008E, G0090], 35);
  Proc22_404C(Random(50) + 100, Random(50) + 100,
    PGrid5W22(G71F2[2])^[G008E, G0090] - 30,
    PGrid5W22(G71F2[4])^[G008E, G0090], 20);
end;
{$F+}

{$F-}
{ ADDRESS: MAIN 0x001641b5 }
procedure Proc22_41B5(N: Integer);
var
  i: Word;
begin
  for i := 1 to N do
  begin
    Proc22_404C(Far41E4(200) + $19, Far41EF(200) + $19,
      Far4219(10) + PGrid5W22(G71F2[1])^[G008E, G0090],
      Far4518(15) + PGrid5W22(G71F2[0])^[G008E, G0090], 15);
  end;
end;
{$F+}

function Far41E4(Arg: Word): Word;
begin
  Far41E4 := 0;
end;

function Far41EF(Arg: Word): Word;
begin
  Far41EF := 0;
end;

function Far4219(Arg: Word): Word;
begin
  Far4219 := 0;
end;

function Far4518(Arg: Word): Word;
begin
  Far4518 := 0;
end;

{$F-}
{ ADDRESS: MAIN 0x0016424f }
procedure Proc22_424F(Col, Row: Word; P6, P4: Byte);
var
  B1, B2, Result: Byte;
begin
  B1 := MapTileA^[Row, Col];
  B2 := MapTileC^[Row, Col];
    Result := $ff;
    case P6 of
      0:
        begin
          case P4 of
            0:
              begin
                case B2 of
                  $10:
                    begin
                      case B1 of
                        0:
                          begin
                            Result := 4;
                          end;
                        1:
                          begin
                            Result := 5;
                          end;
                      end;
                    end;
                  3:
                    begin
                      case B1 of
                        0:
                          begin
                            Result := $19;
                          end;
                        1:
                          begin
                            Result := $1a;
                          end;
                        4:
                          begin
                            Result := $1b;
                          end;
                        2:
                          begin
                            Result := $1f;
                          end;
                      end;
                    end;
                end;
              end;
            1:
              begin
                case B1 of
                  0:
                    begin
                      Result := $c;
                    end;
                  1:
                    begin
                      Result := $d;
                    end;
                end;
              end;
            3:
              begin
                case B1 of
                  0:
                    begin
                      Result := $a;
                    end;
                  1:
                    begin
                      Result := $b;
                    end;
                end;
              end;
          end;
        end;
      1:
        begin
          case P4 of
            0:
              begin
                case B1 of
                  0:
                    begin
                      Result := 8;
                    end;
                  1:
                    begin
                      Result := 9;
                    end;
                end;
              end;
            1:
              begin
                case B2 of
                  $10:
                    begin
                      case B1 of
                        0:
                          begin
                            Result := 6;
                          end;
                        1:
                          begin
                            Result := 7;
                          end;
                      end;
                    end;
                  0:
                    begin
                      case B1 of
                        0:
                          begin
                            Result := $10;
                          end;
                        1:
                          begin
                            Result := $11;
                          end;
                        4:
                          begin
                            Result := $12;
                          end;
                        2:
                          begin
                            Result := $1c;
                          end;
                      end;
                    end;
                end;
              end;
            2:
              begin
                case B1 of
                  0:
                    begin
                      Result := $a;
                    end;
                  1:
                    begin
                      Result := $b;
                    end;
                end;
              end;
          end;
        end;
      2:
        begin
          case P4 of
            1:
              begin
                case B1 of
                  0:
                    begin
                      Result := $e;
                    end;
                  1:
                    begin
                      Result := $f;
                    end;
                end;
              end;
            2:
              begin
                case B2 of
                  $10:
                    begin
                      case B1 of
                        0:
                          begin
                            Result := 4;
                          end;
                        1:
                          begin
                            Result := 5;
                          end;
                      end;
                    end;
                  1:
                    begin
                      case B1 of
                        0:
                          begin
                            Result := $13;
                          end;
                        1:
                          begin
                            Result := $14;
                          end;
                        4:
                          begin
                            Result := $15;
                          end;
                        2:
                          begin
                            Result := $1d;
                          end;
                      end;
                    end;
                end;
              end;
            3:
              begin
                case B1 of
                  0:
                    begin
                      Result := 8;
                    end;
                  1:
                    begin
                      Result := 9;
                    end;
                end;
              end;
          end;
        end;
      3:
        begin
          case P4 of
            0:
              begin
                case B1 of
                  0:
                    begin
                      Result := $e;
                    end;
                  1:
                    begin
                      Result := $f;
                    end;
                end;
              end;
            2:
              begin
                case B1 of
                  0:
                    begin
                      Result := $c;
                    end;
                  1:
                    begin
                      Result := $d;
                    end;
                end;
              end;
            3:
              begin
                case B2 of
                  $10:
                    begin
                      case B1 of
                        0:
                          begin
                            Result := 6;
                          end;
                        1:
                          begin
                            Result := 7;
                          end;
                      end;
                    end;
                  2:
                    begin
                      case B1 of
                        0:
                          begin
                            Result := $16;
                          end;
                        1:
                          begin
                            Result := $17;
                          end;
                        4:
                          begin
                            Result := $18;
                          end;
                        2:
                          begin
                            Result := $1e;
                          end;
                      end;
                    end;
                end;
              end;
          end;
        end;
    end;
  { 40 leaves, 28 distinct values }
  if Result <> $ff then
  begin
    MapTileMid^[Row, Col] := $ff;
    MapTileA^[Row, Col] := Result + $37;
  end;
end;
{$F+}

{$F-}
{ ADDRESS: MAIN 0x00164506 }
function Proc22_4506(P: PCell22): Boolean;
var
  Counter: Word;
begin
  Counter := 0;
  repeat
    Inc(Counter);
    P^.X := Far4527($F9) + 1;
    P^.Y := Far4621($F9) + 1;
  until (Counter >= 1500) or (Proc6_208D(P^.X, P^.Y) >= 4);
  Proc22_4506 := Counter <= 1500;
end;
{$F+}

function Far4527(Arg: Word): Word;
begin
  Far4527 := 0;
end;

function Far4621(Arg: Word): Word;
begin
  Far4621 := 0;
end;

{$F-}
{ ADDRESS: MAIN 0x00164560 }
procedure Proc22_4560(Dest: PCell22; Mode: Byte);
begin
  case Mode of
    0:
      Inc(Dest^.Y);
    1:
      Inc(Dest^.X);
    2:
      Dec(Dest^.Y);
    3:
      Dec(Dest^.X);
  end;
end;
{$F+}

{$F-}
{ ADDRESS: MAIN 0x0016459a }
function Proc22_459A(A0, A1: TCell22; A2: Byte): Word;
var
  Res: Word;
  T: Byte;
  R: Word;
begin
  T := Far49DC(Proc6_208D(A0.X, A0.Y), Proc6_208D(A1.X, A1.Y));
  if T < 3 then
    Res := 1
  else
  begin
    R := Proc22_2E03(A0.Y, A0.X, T);
    if R = 0 then
      R := Proc22_2E03(A1.Y, A1.X, T);
    if R = 0 then
      Res := 0
    else
      Res := 1;
  end;
  Proc22_459A := Res;
end;
{$F+}

function Far49DC(A0, A1: LongInt): Byte;
begin
  Far49DC := 0;
end;

{$F-}
{ ADDRESS: MAIN 0x00164618 }
function Proc22_4618(B: PCell22; A: PByte22): Word;
var
  Temp: TCell22;
begin
  A^ := Far4E68(4);
  Temp := B^;
  Proc22_4560(@Temp, A^);
  if Proc22_459A(B^, Temp, A^) = 0 then
  begin
    MapTileMid^[B^.X, B^.Y] := $FF;
    MapTileMid^[Temp.X, Temp.Y] := $FF;
    MapTileA^[B^.X, B^.Y] := A^ * 2 + $57;
    MapTileA^[Temp.X, Temp.Y] := A^ * 2 + $58;
    B^ := Temp;
    Proc22_4560(B, A^);
    Proc22_4618 := 0;
  end
  else
    Proc22_4618 := 1;
end;
{$F+}

function Far4E68(Arg: Word): Byte;
begin
  Far4E68 := 0;
end;

{$F-}
{ ADDRESS: MAIN 0x0016470c }
function Proc22_470C(X, Y: Integer): Word;
begin
  Proc22_470C := Map0^[X - 1, Y] + Map0^[X, Y - 1] + Map0^[X, Y] +
    Map0^[X - 1, Y - 1];
end;
{$F+}

{$F-}
{ ADDRESS: MAIN 0x001647ff }
function Proc22_47FF(Row, Col: Integer): Word;
var
  Count: Word;
begin
  Count := 0;
  if MapTileA^[Col - 1, Row] >= $37 then Inc(Count);
  if MapTileA^[Col, Row - 1] >= $37 then Inc(Count);
  if MapTileA^[Col + 1, Row] >= $37 then Inc(Count);
  if MapTileA^[Col, Row + 1] >= $37 then Inc(Count);
  Proc22_47FF := Count;
end;
{$F+}

{$F-}
{ ADDRESS: MAIN 0x001648d7 }
function Proc22_48D7(Y, X: Integer; Mode: Byte): Byte;
var
  M0: Word;
  M1: Word;
  M2: Word;
  M3: Word;
  R0: Word;
  R1: Word;
  R2: Word;
  R3: Word;
  K: Word;
  Best: Word;
  Res: Byte;
  function Proc22_4885(A, B: Integer): Word;
  var
    Tmp: Word;
  begin
    if (A >= 1) and (B >= 1) and (A <= 249) and (B <= 249) then
    begin
      if Proc22_4786(A, B) then
        Tmp := $FFFF
      else
        Tmp := Proc22_470C(A, B);
    end
    else
      Tmp := $FFFF;
    Proc22_4885 := Tmp;
  end;
begin
  M0 := 1;
  M1 := 1;
  M2 := 1;
  M3 := 1;
  case Mode of
    0:
      begin
        M0 := 0;
        R0 := $FFFF;
      end;
    1:
      begin
        M1 := 0;
        R1 := $FFFF;
      end;
    2:
      begin
        M2 := 0;
        R2 := $FFFF;
      end;
    3:
      begin
        M3 := 0;
        R3 := $FFFF;
      end;
  end;
  K := 1;
  repeat
    if M0 = 1 then
      R0 := Proc22_4885(X, Y - K);
    if M1 = 1 then
      R1 := Proc22_4885(X - K, Y);
    if M2 = 1 then
      R2 := Proc22_4885(X, Y + K);
    if M3 = 1 then
      R3 := Proc22_4885(X + K, Y);
    Best := Far4AE0(Far49EA(Far49E3(R0, R1, R2, R3)));
    if R0 > Best then
    begin
      M0 := 0;
      R0 := $FFFF;
    end;
    if R1 > Best then
    begin
      M1 := 0;
      R1 := $FFFF;
    end;
    if R3 > Best then
    begin
      M3 := 0;
      R3 := $FFFF;
    end;
    if R2 > Best then
    begin
      M2 := 0;
      R2 := $FFFF;
    end;
    Inc(K);
  until (M1 + M0 + M2 + M3) <= 1;
  if M1 = 1 then
    Res := 3;
  if M0 = 1 then
    Res := 2;
  if M2 = 1 then
    Res := 0;
  if M3 = 1 then
    Res := 1;
  Proc22_48D7 := Res;
end;
{$F+}

function Far49E3(A0, A1, A2, A3: LongInt): LongInt;
begin
  Far49E3 := 0;
end;

function Far49EA(A0: LongInt): LongInt;
begin
  Far49EA := 0;
end;

function Far4AE0(A0: LongInt): LongInt;
begin
  Far4AE0 := 0;
end;

{$F-}
{ ADDRESS: MAIN 0x00164a7d }
function Proc22_4A7D(C: PCell22; B: PByte22): Word;
var
  Cell: Byte;
  Alt: Byte;
  Dir: Byte;
  R: Word;
begin
  if (B^ = 0) or (B^ = 1) then
    Cell := Map0^[C^.X - 1, C^.Y - 1]
  else if (B^ = 2) or (B^ = 3) then
    Cell := Map0^[C^.X, C^.Y];
  if Proc6_1FDB(C^.X, C^.Y) > Cell then
    Alt := Cell
  else
    Alt := Far4D58(0, 0, Cell - 1);
  R := 0;
  if Alt = Cell then
  begin
    R := Proc22_2E03(C^.Y, C^.X, Cell);
    if R = 0 then
      Dir := Proc22_48D7(C^.Y, C^.X, B^);
  end
  else
  begin
    R := Proc22_2E6F(C^.Y, C^.X, Cell, B^);
    Dir := B^;
  end;
  if R = 0 then
  begin
    if Proc22_47FF(C^.Y, C^.X) > 1 then
      R := 1
    else
    begin
      Proc22_424F(C^.Y, C^.X, B^, Dir);
      case Dir of
        0: Inc(C^.Y);
        1: Inc(C^.X);
        2: Dec(C^.Y);
        3: Dec(C^.X);
      end;
      B^ := Dir;
    end;
  end;
  Proc22_4A7D := R;
end;
{$F+}

function Far4D58(A0, A1: Word; A2: LongInt): Byte;
begin
  Far4D58 := 0;
end;

{$F-}
{ ADDRESS: MAIN 0x00164bea }
function Proc22_4BEA(A: Byte): ShortInt;
var
  Tmp: ShortInt;
begin
  Tmp := (A + 2) mod 4;
  Proc22_4BEA := Tmp;
end;
{$F+}

{$F-}
{ ADDRESS: MAIN 0x00164cb1 }
procedure Proc22_4CB1(C: TCell22; B: Byte);
var
  R: Word;
  function Proc22_4C06(P: PCell22): Word;
  var
    Flag: Word;
  begin
    Flag := 0;
    if MapTileA^[P^.X, P^.Y - 1] >= $37 then
      Dec(P^.Y)
    else if MapTileA^[P^.X - 1, P^.Y] >= $37 then
      Dec(P^.X)
    else if MapTileA^[P^.X, P^.Y + 1] >= $37 then
      Inc(P^.Y)
    else if MapTileA^[P^.X + 1, P^.Y] >= $37 then
      Inc(P^.X)
    else
      Flag := 1;
    Proc22_4C06 := Flag;
  end;
begin
  Proc22_4560(@C, Proc22_4BEA(B));
  if MapTileA^[C.X, C.Y] >= $37 then
    Far4D05(Byte(C.X), Byte(C.Y));
  R := Proc22_4C06(@C);
  while R = 0 do
  begin
    Far54E7(Byte(C.X), Byte(C.Y));
    R := Proc22_4C06(@C);
  end;
end;
{$F+}

{$F-}
{ ADDRESS: MAIN 0x00164d19 }
procedure Proc22_4D19;
var
  C: TCell22;
  B: Byte;
  R: Word;
begin
  if Proc22_4506(@C) then
  begin
    R := Proc22_4618(@C, @B);
    if R = 0 then
    begin
      repeat
        R := Proc22_4A7D(@C, @B);
      until (Proc6_1FDB(C.X, C.Y) = 0) or (R <> 0);
      if R <> 0 then
        Proc22_4CB1(C, B);
    end;
  end;
end;
{$F+}

procedure Far4D05(A0, A1: Byte);
begin
end;

procedure Far54E7(A0, A1: Byte);
begin
end;

{$F-}
{ ADDRESS: MAIN 0x00164d79 }
procedure Proc22_4D79(N: Word);
var
  i: Word;
begin
  for i := 1 to N do
    Proc22_4D19;
end;
{$F+}

{ ADDRESS: MAIN 0x00164dae }
procedure Proc22_4DAE;
label Body, Mid;
var
  Col, Row: Byte;
  Sel: Word;
begin
  Row := 1;
  Col := 1;
Body:
  if (MapTileA^[Col, Row] = 1) or (MapTileA^[Col, Row] = 0)
    or (MapTileA^[Col, Row] = 4) then
  begin
    if MapTileA^[Col, Row] = 4 then goto Mid;
    if MapTileC^[Col, Row] = $10 then
    begin
      Sel := Far4EF8(6);
      if Sel <= 5 then
        case Sel of
          0: G5510^[Col, Row] := 0;
          1: G5510^[Col, Row] := 1;
          2: G5510^[Col, Row] := 2;
          3: G5510^[Col, Row] := 3;
        end;
    end
    else
      G5510^[Col, Row] := Far4F3D(2);
  end;
Mid:
  if MapTileMid^[Col, Row] = $ff then
  begin
    Sel := Far4F6D($64);
    if Sel < W552C then
    begin
      MapTileMid^[Col, Row] := $0c;
      Sel := Far5332(PSel16(Sel10Board)^[12].F0);
      G5510^[Col, Row] := Byte(G5510^[Col, Row]
        * PSel16(Sel10Board)^[12].W0C + Sel);
    end;
  end;
  if Col <> $f9 then
  begin
    Inc(Col);
    goto Body;
  end;
  if Row <> $f9 then
  begin
    Inc(Row);
    Col := 1;
    goto Body;
  end;
end;

function Far4EF8(Arg: Word): Word;
begin
  Far4EF8 := 0;
end;

function Far4F3D(Arg: Word): Word;
begin
  Far4F3D := 0;
end;

function Far4F6D(Arg: Word): Word;
begin
  Far4F6D := 0;
end;

function Far5332(Arg: Word): Word;
begin
  Far5332 := 0;
end;

{$F-}
{ ADDRESS: MAIN 0x00164fd1 }
procedure Proc22_4FD1;
var
  Val: Word;
  v1: Word;
  v2: Word;
begin
  for v1 := 1 to $f9 do
    for v2 := 1 to $f9 do
    begin
      Val := Map0^[v1, v2] * 4 - Map0^[v1 - 1, v2] - Map0^[v1, v2 - 1] -
             Map0^[v1 + 1, v2] - Map0^[v1, v2 + 1];
      if Val >= 3 then
        Proc22_1290(v1, v2)
      else if Val <= -3 then
        Proc22_0130(v1, v2);
    end;
  for v1 := $f9 downto 1 do
    for v2 := $f9 downto 1 do
    begin
      Val := Map0^[v1, v2] * 4 - Map0^[v1 - 1, v2] - Map0^[v1, v2 - 1] -
             Map0^[v1 + 1, v2] - Map0^[v1, v2 + 1];
      if Val >= 3 then
        Proc22_1290(v1, v2)
      else if Val <= -3 then
        Proc22_0130(v1, v2);
    end;
end;
{$F+}

{$F-}
{ ADDRESS: MAIN 0x001652a4 }
procedure Proc22_52A4;
var
  i1: Byte;
  i2: Byte;
  procedure Proc22_517B(A0, A1: Byte);
  begin
    if MapTileA^[A0, A1] >= $37 then
      Far5200(A0, A1, 0, $70);
    if MapTileA^[A0, A1] = 2 then
      if MapTileC^[A0, A1] <> $10 then
        Far5251(A0, A1, 0, $6c);
    if MapTileA^[A0, A1] = 0 then
      if Map0^[A0, A1] <= 1 then
        Far529E(A0, A1, 0, $65);
    if MapTileMid^[A0, A1] <> $FF then
      Far550C(A0, A1, MapTileMid^[A0, A1], 0);
  end;
begin
  for i1 := 0 to 250 do
    for i2 := 0 to 250 do
      Proc22_517B(i1, i2);
end;
{$F+}

procedure Far5200(A0, A1: Byte; A2, A3: Word);
begin
end;

procedure Far5251(A0, A1: Byte; A2, A3: Word);
begin
end;

procedure Far529E(A0, A1: Byte; A2, A3: Word);
begin
end;

procedure Far550C(A0, A1, A2: Byte; A3: Word);
begin
end;

{ ADDRESS: MAIN 0x001652d4 }
procedure Proc22_52D4;
begin
  if (PTRec6456(P6456)^.B190 <> 0) or (PTRec6456(P6456)^.B191 <> 0) then
  begin
    Proc8_3748(3, G71F2[15]);
    Proc22_3030;
    Proc8_376E($64, G71F2[15]);
  end
  else
  begin
    Proc8_3748(1, G71F2[15]);
    Proc22_3030;
    Proc8_376E(5, G71F2[15]);
    G71F2[13] := Far5341($4FB2);
    G71F2[14] := Far5379($4FB2);
    if G008A = 0 then
      Proc22_3C5C
    else if G008A = 1 then
      Proc22_41B5($14)
    else if G008A = 2 then
      Proc22_412C;
    Far5389(G71F2[13], $4FB2);
    Far5677(G71F2[14], $4FB2);
    Proc8_376E($1a, G71F2[15]);
    Proc22_4FD1;
    Proc8_376E($20, G71F2[15]);
    Proc22_354C;
    Proc8_376E($30, G71F2[15]);
    Proc22_4DAE;
    Proc8_376E($33, G71F2[15]);
    Proc22_4D79(G0092);
    Proc8_376E($46, G71F2[15]);
    Proc22_29C0;
    Proc8_376E($4a, G71F2[15]);
    Proc22_52A4;
    Proc8_376E($64, G71F2[15]);
  end;
end;

function Far5341(A0: Word): Pointer;
begin
  Far5341 := NIL;
end;

function Far5379(A0: Word): Pointer;
begin
  Far5379 := NIL;
end;

procedure Far5389(A0: Pointer; A1: Word);
begin
end;

procedure Far5677(A0: Pointer; A1: Word);
begin
end;

{ ADDRESS: MAIN 0x001653fe }
function Proc22_53FE(Y, X: Integer; Dir, A: Byte): Byte;
var
  Res: Byte;
  Acc: LongInt;
  Cell: Byte;
  X2: Integer;
  Y2: Integer;
  X1: Integer;
  Y1: Integer;
begin
  if (X > 0) and (X < 250) and (Y > 0) and (Y < 250) then
  begin
    X1 := X;
    Y1 := Y;
    X2 := X;
    Y2 := Y;
    case Dir of
      1:
        begin
          Cell := Map0^[X - 1, Y];
          Dec(Y2);
        end;
      0:
        begin
          Cell := Map0^[X, Y - 1];
          Dec(X1);
        end;
      2:
        begin
          Cell := Map0^[X, Y];
          Dec(X1);
          Dec(Y1);
          Dec(Y2);
        end;
      3:
        begin
          Cell := Map0^[X, Y];
          Dec(X1);
          Dec(X2);
          Dec(Y2);
        end;
    end;
    Proc22_2B9B(X1, Y1, Cell, A, @Acc);
    Proc22_2B9B(X2, Y2, Cell, A, @Acc);
    if Proc6_208D(X, Y) = Proc6_1FDB(X, Y) then
      Res := 1
    else if Proc6_208D(X, Y) < Cell then
    begin
      Proc22_2B9B(X1, Y1, Cell - 1, A, @Acc);
      Proc22_2B9B(X2, Y2, Cell - 1, A, @Acc);
      if Map0^[X1, Y1] = Cell - 1 then
      begin
        if Map0^[X2, Y2] = Cell - 1 then
          Res := 1
        else
          Res := 0;
      end
      else
        Res := 0;
    end
    else
    begin
      Proc22_2B9B(X1, Y1, Cell + 1, A, @Acc);
      Proc22_2B9B(X2, Y2, Cell + 1, A, @Acc);
      if Map0^[X1, Y1] = Cell + 1 then
      begin
        if Map0^[X2, Y2] = Cell + 1 then
          Res := 1
        else
          Res := 0;
      end
      else
        Res := 0;
    end;
  end
  else
    Res := 0;
  Proc22_53FE := Res;
end;

{$F-}
{ ADDRESS: MAIN 0x001656ce }
procedure Proc22_56CE;
var
  EnclosingBuf: array[0..255] of Byte;
  SecondBuf: array[0..255] of Byte;
procedure Proc22_5653(A0: Pointer);
var
  I, J: Word;
begin
  for I := 0 to 4 do
  begin
    for J := 0 to 4 do
    begin
      PGrid5W22(A0)^[I, J] := Far5693(@EnclosingBuf);
      Far56A7;
    end;
    Far56BB(@EnclosingBuf);
  end;
  Far56E6(@EnclosingBuf);
end;

begin
  Proc22_5653(G71F2[0]);
  Proc22_5653(G71F2[1]);
  Proc22_5653(G71F2[2]);
  Proc22_5653(G71F2[3]);
  Proc22_5653(G71F2[4]);
  Proc22_5653(G71F2[5]);
  Proc22_5653(G71F2[6]);
  Proc22_5653(G71F2[7]);
  Proc22_5653(G71F2[8]);
  Proc22_5653(G71F2[9]);
  Proc22_5653(G71F2[10]);
end;
{$F+}

function Far5693(A0: Pointer): Word;
begin
  Far5693 := 0;
end;

procedure Far56A7;
begin
end;

procedure Far56BB(A0: Pointer);
begin
end;

procedure Far56E6(A0: Pointer);
begin
end;

{ ADDRESS: MAIN 0x00165788 }
procedure Proc22_5788;
begin
  GetMem(G71F2[0], 50);
  GetMem(G71F2[1], 50);
  GetMem(G71F2[2], 50);
  GetMem(G71F2[3], 50);
  GetMem(G71F2[4], 50);
  GetMem(G71F2[5], 50);
  GetMem(G71F2[6], 50);
  GetMem(G71F2[7], 50);
  GetMem(G71F2[8], 50);
  GetMem(G71F2[9], 50);
  GetMem(G71F2[10], 50);
  Proc22_56CE;
end;

{ ADDRESS: MAIN 0x0016582a }
procedure Proc22_582A;
begin
  FreeMem(G71F2[0], 50);
  FreeMem(G71F2[1], 50);
  FreeMem(G71F2[2], 50);
  FreeMem(G71F2[3], 50);
  FreeMem(G71F2[4], 50);
  FreeMem(G71F2[5], 50);
  FreeMem(G71F2[6], 50);
  FreeMem(G71F2[7], 50);
  FreeMem(G71F2[8], 50);
  FreeMem(G71F2[9], 50);
  FreeMem(G71F2[10], 50);
end;

procedure Step22(Dir: Byte; P: PFar4);
begin
  case Dir of
    0: Inc(P^.Hi);
    1: Inc(P^.Lo);
    2: Dec(P^.Hi);
    3: Dec(P^.Lo);
  end;
end;

procedure Store3_22(var P: TThree22; B, C: Byte);
begin
  P.A := 0;
  P.B := C;
  P.C := B;
end;

procedure Stub4D19;
begin
end;

procedure Stub517B(P: Word; J, I: Byte);
begin
end;

procedure Swap22(P, Q: PFar4);
var T: TFar4;
begin
  T := Q^;
  Q^ := P^;
  P^ := T;
end;
procedure CallersInit22;
var
  SwapA22: LongInt;
  SwapB22: LongInt;
  Nudge22: TCell22;
  CallerThree22: TThree22;
  CallerFour22: TFar4;
begin
  if Div4_22(1) = 2 then Loop22(1);
  if Lookup22(1, 2) = 3 then Loop22(1);
  if Init22(@CallerFour22) then Loop22(1);
  Proc22_4560(@Nudge22, 0);
  Proc22_371E(SwapP22A, SwapP22B);
  Proc22_424F(0, 0, 0, 0);
  Proc22_3030;
  if Proc22_4786(0, 0) then;
  Proc22_4DAE;
  Proc22_29C0;
  if Proc22_2B9B(1, 1, 1, 0, @SwapA22) = 0 then;
  if Proc22_53FE(1, 1, 1, 0) = 0 then;
  if Proc22_2C83(1, 1, 1, 0, @SwapA22) = 0 then;
  if Proc22_2D70(1, 1, 1) = 0 then;
  if Proc22_2E03(1, 1, 1) = 0 then;
  if Proc22_470C(1, 1) = 0 then;
  if Proc22_47FF(1, 1) = 0 then;
  if Proc22_4618(PCell22(@SwapA22), PByte22(@SwapB22)) = 0 then;
  Proc22_41B5(1);
  if Proc22_4506(PCell22(@SwapA22)) then;
  Proc22_4D79(1);
  if Proc22_4BEA(0) = 0 then;
  if Proc22_48D7(1, 1, 0) = 0 then;
  Proc22_3199(0, 0);
  Proc22_52A4;
  Proc22_52D4;
end;

begin
  CallersInit22;
end.
