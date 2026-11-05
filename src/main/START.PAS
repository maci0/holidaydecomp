unit START;
{ Reconstructed scaffold, holiday.exe code segment 11 (17387 bytes).
  This is form unit for TStartform; the original kept its forms inside the segment's own  unit
  (docs/tree.md).
  Evidence: form TStartform, 1 components.
  `uses` comes from this segment's relocation records, the class members
  from RTTI and form streams. Known close-handler bodies are recovered;
  other method bodies remain stubs. }
{$F+}
interface

uses ExtCtrls, Graphics, Controls, Forms, Classes, SysUtils;

type
  TThing412F = packed record
    Pad: array[0..0] of Byte;
  end;
  PThing412F = ^TThing412F;
  TItem412F = packed record
    B: Byte;
  end;  { The dispatch object the mouse and key bodies call through. Nine field
    bytes put the instance's near VMT pointer at +9; the VMT header is 8 bytes
    and seven slots of 4. Nothing in our build writes that pointer: the
    instances never run, so an unreferenced VMT costs no data (probe). }
  TDispatch = object
    F0, F1, F2, F3, F4, F5, F6, F7, F8: Byte;
    procedure Slot1; virtual;
    procedure Slot2(O: Pointer); virtual;
    { Slot2 and Slot3 arities amended with the lead's nod, 2026-11-01:
      11:0x02cf carries 26 slot2 sites and 21 slot4 sites at the identical
      4-push shape, one Pointer argument read in the two-word memory form
      plus the receiver, and 26 slot3 sites at 6 pushes, two Pointers plus
      the receiver. The Word, Word, Pointer reading does not compile: no
      word-typed lvalue exists at +0x17e while +0x17c is the Pointer field
      that slot4 pushes, the same impossibility that forced the Pointer
      reading on 1C1B. The landed eight touch slots 1, 4, 6, 7 only, so
      they are unaffected; slot1 stays no-argument per 2C72 and slot5
      stays evidence-open. }
    procedure Slot3(O1, O2: Pointer); virtual;
    procedure Slot4(O: Pointer); virtual;
    procedure Slot5; virtual;
    function Slot6(X, Y: Word; O: Pointer): Boolean; virtual;
    function Slot7(X, Y: Word; O: Pointer): Boolean; virtual;
  end;
  PDispatch = ^TDispatch;
  { What MAP's P6456 points at: data-globals confirmed P6456 spans
    0x6456..0x6459 with Pad645A after it, so no storage changes here:
    +0x184 holds the next Pointer and the second record carries
    L000C at +0x0C. Types only, no allocation. }
  P6456A = ^T6456A;
  T6456A = packed record
    Pad: array[0..387] of Byte;   { 0x000 .. 0x183 }
    Ptr184: Pointer;              { 0x184 }
  end;
  P6456B = ^T6456B;
  T6456B = packed record
    Pad: array[0..11] of Byte;    { 0x00 .. 0x0B }
    L000C: LongInt;               { 0x0C }
  end;

  TThing23 = class(TObject)
    procedure Slot0; virtual;
    procedure Slot1; virtual;
    procedure Slot2; virtual;
    procedure Slot3; virtual;
    procedure Slot4; virtual;
    procedure Slot5; virtual;
    procedure Slot6; virtual;
    procedure Slot7; virtual;
    procedure Slot8; virtual;
    procedure Slot9; virtual;
    procedure Slot10; virtual;
    procedure Slot11; virtual;
    procedure Slot12; virtual;
  end;
  TS1E8 = packed record
      P0: array[0..35] of Byte;
      W24: LongInt;
      W28: Word;
      W2A: Word;
      W2C: LongInt;
  end;
  TS226 = packed record
      P0: array[0..35] of Byte;
      W24: LongInt;
      W28: Word;
      W2A: Word;
      W2C: LongInt;
  end;
  TS264 = packed record
      P0: array[0..35] of Byte;
      W24: LongInt;
      W28: Word;
      W2A: Word;
      W2C: LongInt;
  end;
  TS3577 = packed record
      P0: array[0..35] of Byte;
      W24: LongInt;
      W28: Word;
      W2A: Word;
      W2C: LongInt;
  end;
  TS2A2 = packed record
      P0: array[0..35] of Byte;
      W24: LongInt;
      W28: Word;
      W2A: Word;
      W2C: LongInt;
  end;
  TRecP = packed record
    P0: array[0..33] of Byte;
    F22: Word;
    F24: Word;
    P26: array[0..341] of Byte;
    F17C: Pointer;
    F180: TThing23;
    F184: TThing23;
    F188: TThing23;
    F18C: TThing23;
    F190: TThing23;
    F194: TThing23;
    F198: TThing23;
    F19C: TThing23;
    F1A0: TThing23;
    F1A4: TThing23;
    F1A8: TThing23;
    F1AC: TThing23;
    F1B0: TThing23;
    F1B4: TThing23;
    F1B8: TThing23;
    F1BC: TThing23;
    F1C0: TThing23;
    F1C4: TThing23;
    F1C8: TThing23;
    F1CC: TThing23;
    F1D0: TThing23;
    F1D4: TThing23;
    F1D8: TThing23;
    F1DC: TThing23;
    F1E0: TThing23;
    F1E4: TThing23;
    S1E8: TS1E8;
    P218: array[0..13] of Byte;
    S226: TS226;
    P256: array[0..13] of Byte;
    S264: TS264;
    P294: array[0..13] of Byte;
    S2A2: TS2A2;
    P2D2: array[0..13] of Byte;
    F2E0: Pointer;
    P2E4: array[0..273] of Byte;
    F3F6: Pointer;
    P3FA: array[0..15] of Byte;
    F40A: Pointer;
    P40E: array[0..253] of Byte;
    F50C: Pointer;
    P510: array[0..273] of Byte;
    F622: Pointer;
    P626: array[0..273] of Byte;
    F738: Pointer;
    P73C: array[0..266] of Byte;
    F847: Pointer;
    P84B: array[0..266] of Byte;
    F956: Pointer;
    P95A: array[0..266] of Byte;
    FA65: Pointer;
    PA69: array[0..266] of Byte;
    FB74: Pointer;
    PB78: array[0..266] of Byte;
    FC83: Pointer;
    PC87: array[0..266] of Byte;
    FD92: Pointer;
    PD96: array[0..266] of Byte;
    FEA1: Pointer;
    PEA5: array[0..266] of Byte;
    FFB0: Pointer;
    PFB4: array[0..266] of Byte;
    F10BF: Pointer;
    P10C3: array[0..266] of Byte;
    F11CE: Pointer;
    P11D2: array[0..266] of Byte;
    F12DD: Pointer;
    P12E1: array[0..266] of Byte;
    F13EC: Pointer;
    P13F0: array[0..266] of Byte;
    F14FB: Pointer;
    P14FF: array[0..266] of Byte;
    F160A: Pointer;
    P160E: array[0..266] of Byte;
    F1719: Pointer;
    P171D: array[0..266] of Byte;
    F1828: Pointer;
    P182C: array[0..266] of Byte;
    F1937: Pointer;
    P193B: array[0..266] of Byte;
    F1A46: Pointer;
    P1A4A: array[0..266] of Byte;
    F1B55: Pointer;
    P1B59: array[0..266] of Byte;
    F1C64: Pointer;
    P1C68: array[0..266] of Byte;
    F1D73: Pointer;
    P1D77: array[0..266] of Byte;
    F1E82: Pointer;
    P1E86: array[0..266] of Byte;
    F1F91: Pointer;
    P1F95: array[0..266] of Byte;
    F20A0: Byte;
    P20A1: array[0..9] of Byte;
    F20AB: Pointer;
    P20AF: array[0..266] of Byte;
    F21BA: Byte;
    P21BB: array[0..9] of Byte;
    F21C5: Pointer;
    P21C9: array[0..266] of Byte;
    F22D4: Byte;
    P22D5: array[0..9] of Byte;
    F22DF: Pointer;
    P22E3: array[0..266] of Byte;
    F23EE: Byte;
    P23EF: array[0..7] of Byte;
    F23F7: Pointer;
    P23FB: array[0..275] of Byte;
    F250F: Pointer;
    P2513: array[0..275] of Byte;
    F2627: Pointer;
    P262B: array[0..275] of Byte;
    F273F: Pointer;
    P2743: array[0..275] of Byte;
    F2857: Pointer;
    P285B: array[0..275] of Byte;
    F296F: Pointer;
    P2973: array[0..275] of Byte;
    F2A87: Pointer;
    P2A8B: array[0..275] of Byte;
    F2B9F: Pointer;
    P2BA3: array[0..6] of Byte;
    F2BAA: Pointer;
    P2BAE: array[0..255] of Byte;
    F2CAE: Pointer;
    P2CB2: array[0..266] of Byte;
    F2DBD: Byte;
    P2DBE: array[0..9] of Byte;
    F2DC8: Pointer;
    P2DCC: array[0..277] of Byte;
    F2EE2: Pointer;
    P2EE6: array[0..277] of Byte;
    F2FFC: Pointer;
    P3000: array[0..277] of Byte;
    F3116: Pointer;
    P311A: array[0..277] of Byte;
    F3230: Pointer;
    P3234: array[0..277] of Byte;
    F334A: Pointer;
    P334E: array[0..273] of Byte;
    F3460: TThing23;
    F3464: Pointer;
    P3468: array[0..270] of Byte;
    S3577: TS3577;
  end;
  TBuf02 = record
    Pad0: array[0..379] of Byte;
    F17C: Pointer;
    Pad180: array[0..103] of Byte;
    H1E8: TDispatch;
    Pad1F3: array[0..50] of Byte;
    H226: TDispatch;
    Pad231: array[0..50] of Byte;
    H264: TDispatch;
    Pad26F: array[0..50] of Byte;
    H2A2: TDispatch;
    Pad2AD: array[0..50] of Byte;
    H2E0: TDispatch;
    Pad2EB: array[0..266] of Byte;
    H3F6: TDispatch;
    Pad401: array[0..8] of Byte;
    F40A: Byte;
    Pad40B: array[0..256] of Byte;
    H50C: TDispatch;
    Pad517: array[0..266] of Byte;
    H622: TDispatch;
    Pad62D: array[0..266] of Byte;
    H738: TDispatch;
    Pad743: array[0..259] of Byte;
    H847: TDispatch;
    Pad852: array[0..1343] of Byte;
    HD92: TDispatch;
    PadD9D: array[0..259] of Byte;
    HEA1: TDispatch;
    PadEAC: array[0..259] of Byte;
    HFB0: TDispatch;
    PadFBB: array[0..259] of Byte;
    H10BF: TDispatch;
    Pad10CA: array[0..259] of Byte;
    H11CE: TDispatch;
    Pad11D9: array[0..259] of Byte;
    H12DD: TDispatch;
    Pad12E8: array[0..259] of Byte;
    H13EC: TDispatch;
    Pad13F7: array[0..259] of Byte;
    H14FB: TDispatch;
    Pad1506: array[0..259] of Byte;
    H160A: TDispatch;
    Pad1615: array[0..259] of Byte;
    H1719: TDispatch;
    Pad1724: array[0..259] of Byte;
    H1828: TDispatch;
    Pad1833: array[0..259] of Byte;
    H1937: TDispatch;
    Pad1942: array[0..259] of Byte;
    H1A46: TDispatch;
    Pad1A51: array[0..259] of Byte;
    H1B55: TDispatch;
    Pad1B60: array[0..259] of Byte;
    H1C64: TDispatch;
    Pad1C6F: array[0..259] of Byte;
    H1D73: TDispatch;
    Pad1D7E: array[0..259] of Byte;
    H1E82: TDispatch;
    Pad1E8D: array[0..259] of Byte;
    H1F91: TDispatch;
    Pad1F9C: array[0..270] of Byte;
    H20AB: TDispatch;
    Pad20B6: array[0..270] of Byte;
    H21C5: TDispatch;
    Pad21D0: array[0..270] of Byte;
    H22DF: TDispatch;
    Pad22EA: array[0..268] of Byte;
    H23F7: TDispatch;
    Pad2402: array[0..268] of Byte;
    H250F: TDispatch;
    Pad251A: array[0..268] of Byte;
    H2627: TDispatch;
    Pad2632: array[0..268] of Byte;
    H273F: TDispatch;
    Pad274A: array[0..268] of Byte;
    H2857: TDispatch;
    Pad2862: array[0..268] of Byte;
    H296F: TDispatch;
    Pad297A: array[0..268] of Byte;
    H2A87: TDispatch;
    Pad2A92: array[0..268] of Byte;
    H2B9F: TDispatch;
    Pad2BAA: array[0..259] of Byte;
    H2CAE: TDispatch;
    Pad2CB9: array[0..270] of Byte;
    H2DC8: TDispatch;
    Pad2DD3: array[0..270] of Byte;
    H2EE2: TDispatch;
    Pad2EED: array[0..270] of Byte;
    H2FFC: TDispatch;
    Pad3007: array[0..270] of Byte;
    H3116: TDispatch;
    Pad3121: array[0..270] of Byte;
    H3230: TDispatch;
    Pad323B: array[0..548] of Byte;
    F3460: TThing23;
    H3464: TDispatch;
    Pad346F: array[0..263] of Byte;
    H3577: TDispatch;
  end;
  PBuf02 = ^TBuf02;
  PPtr02 = ^Pointer;
  PWord11 = ^Word;
procedure Proc11_014D(A0, A1: Word);
procedure Proc11_015E(A0, A1: Word);
procedure Proc11_016F(A0, A1: Word);
procedure Proc11_01F8(var A0: TS2A2);
procedure Proc11_0209(A0, A1: Word);
procedure Proc11_021A(A0, A1: Word);
procedure Proc11_02B0(A0, A1: Word);
procedure Proc11_02CF(A0, A1: Word);
procedure Proc11_0C7D(A0, A1: Word);
procedure Proc11_0CBB(A0, A1: Word);
procedure Proc11_0CDD(A0, A1: Word);
procedure Proc11_0D23(A0, A1: Word);
procedure Proc11_0D6A(A0, A1: Word);
procedure Proc11_0DED(A0, A1: Word);
procedure Proc11_0EC4(A0, A1: Word);
procedure Proc11_0F9B(A0, A1: Word);
procedure Proc11_1072(A0, A1: Word);
procedure Proc11_1149(A0, A1: Word);
procedure Proc11_1220(A0, A1: Word);
procedure Proc11_12F7(A0, A1: Word);
procedure Proc11_13CE(A0, A1: Word);
procedure Proc11_14A5(A0, A1: Word);
procedure Proc11_1584(A0, A1: Word);
procedure Proc11_1663(A0, A1: Word);
procedure Proc11_1742(A0, A1: Word);
procedure Proc11_1821(A0, A1: Word);
procedure Proc11_1900(A0, A1: Word);
procedure Proc11_19DF(A0, A1, A2, A3: Word);
procedure Proc11_1A29(A0, A1, A2, A3: Word);
procedure Proc11_1A30(A0, A1: Word);
procedure Proc11_1ED0(A0, A1: Word);
procedure Proc11_27E6(var A0: TRecP);
procedure Proc11_3B61(A0, A1: Word);
procedure Proc11_3CFD(A0, A1, A2, A3, A4, A5, A6, A7: Word);
function Far13B0(A0, A1: Word; A2: Pointer; var A3): Boolean;
function Far15F7(A0, A1: Word; A2: Pointer; var A3): Boolean;
function FarFE3(A0, A1: Word; A2: Pointer; var A3): Boolean;
function Far666(A0, A1: Word; A2: Pointer; var A3): Boolean;
function Far1C1B(A0, A1: Word; A2: Pointer; var A3, A4): Boolean;
procedure Far125E(A0: Word; var A1: TThing412F);
procedure Far123D(A0: Word; var A1: TThing412F);
procedure Far38DA;
function Far19D7(A0: Word; A1: TShiftState; A2: Pointer; var A3, A4): Boolean;
procedure Far22C6(var X: TThing412F);
procedure Proc11_412F(A0, A1, A2, A3, A4, A5, A6: Word);
procedure Proc11_41FB(A0, A1, A2, A3, A4, A5, A6, A7: Word);
procedure Proc11_4381(A0, A1, A2, A3, A4, A5, A6: Word);
function Far535A(A0: Byte; A1: Pointer): TThing23;
procedure Far15CD(A0, A1: Pointer);
function Far0E60(A0, A1: Word; A2, A3: Pointer): Pointer;
procedure Far1B39(A0: Pointer);
procedure Far177B(A0: Word; A1: Pointer);
procedure Far179D(A0: Word; A1: Pointer);
procedure Far17BF(A0: Word; A1: Pointer);
procedure Far1930(A0: Word; A1: Pointer; A2, A3, A4, A5, A6, A7, A8: Word; A9: Pointer);
procedure Far1ED0(A0: Pointer);
procedure Far2A2(A0: string; A1, A2, A3, A4, A5, A6, A7: Word; A8: Pointer);
procedure Far559(A0, A1: Pointer; A2: string; A3, A4, A5, A6, A7, A8, A9: Word; A10: Pointer);
procedure Far72C(A0, A1: Pointer; A2: string; A3, A4, A5, A6, A7, A8, A9, A10: Word; A11: Pointer);
procedure Far83B(A0, A1: Pointer; A2: string; A3, A4, A5, A6, A7, A8: Word; A9: Pointer);
procedure Far9EB(A0, A1, A2, A3, A4, A5: Pointer; A6, A7, A8, A9, A10: Word; A11: Pointer);
procedure Far2a2B(A0, A1, A2, A3, A4, A5, A6: Word; A7: Pointer);


type
  TStartform = class(TForm)
  published
    Bild: TImage;
  private
    { Observed private fields; original field names are unresolved. }
    Pad180: array[0..103] of Byte;
    Item1E8: TItem412F;
    Pad1E9: array[0..60] of Byte;
    Item226: TItem412F;
    Pad227: array[0..60] of Byte;
    Item264: TItem412F;
    Pad265: array[0..60] of Byte;
    Item2A2: TItem412F;
    Pad2A3: array[0..60] of Byte;
    Host2E0: TDispatch;
    Pad2EB: array[0..266] of Byte;
    Host3F6: TDispatch;
    Pad401: array[0..266] of Byte;
    Host50C: TDispatch;
    Pad517: array[0..266] of Byte;
    Host622: TDispatch;
    Pad62D: array[0..6499] of Byte;
    Item1F91: TItem412F;
    Pad1F92: array[0..280] of Byte;
    Item20AB: TItem412F;
    Pad20AC: array[0..280] of Byte;
    Item21C5: TItem412F;
    Pad21C6: array[0..280] of Byte;
    Item22DF: TItem412F;
    Pad22E0: array[0..278] of Byte;
    Item23F7: TItem412F;
    Pad23F8: array[0..278] of Byte;
    Item250F: TItem412F;
    Pad2510: array[0..278] of Byte;
    Item2627: TItem412F;
    Pad2628: array[0..278] of Byte;
    Item273F: TItem412F;
    Pad2740: array[0..278] of Byte;
    Item2857: TItem412F;
    Pad2858: array[0..278] of Byte;
    Item296F: TItem412F;
    Pad2970: array[0..278] of Byte;
    Item2A87: TItem412F;
    Pad2A88: array[0..549] of Byte;
    Item2CAE: TItem412F;
    Pad2CAF: array[0..280] of Byte;
    Item2DC8: TItem412F;
    Pad2DC9: array[0..280] of Byte;
    Item2EE2: TItem412F;
    Pad2EE3: array[0..280] of Byte;
    Item2FFC: TItem412F;
    Pad2FFD: array[0..280] of Byte;
    Item3116: TItem412F;
    Pad3117: array[0..280] of Byte;
    Item3230: TItem412F;
    Pad3231: array[0..280] of Byte;
    Host334A: TDispatch;
    Pad3355: array[0..266] of Byte;
    Item3460: TItem412F;
    Pad3461: array[0..2] of Byte;
    Item3464: TItem412F;
    Pad3465: array[0..273] of Byte;
    Item3577: TItem412F;
    procedure M56CE;
  published
  private
    { shortcut: opaque private storage; name fields as accesses are recovered. }
    UnrecoveredState: array[0..60] of Byte;
  published
    procedure MaperstButtonClick(Sender: TObject);
    procedure SprachButtonClick(Sender: TObject);
    procedure BildMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure BildMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure BildMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  end;

implementation

uses GFX, KOMPASS, SEG24, MAP, DataVal;

{ ADDRESS: MAIN 0x000b014d }
procedure Proc11_014D;
begin
end;

{ ADDRESS: MAIN 0x000b015e }
procedure Proc11_015E;
begin
end;

{ ADDRESS: MAIN 0x000b016f }
procedure Proc11_016F;
begin
end;

{ ADDRESS: MAIN 0x000b01f8 }
procedure Proc11_01F8;
begin
  DataVal.G0092 := Word(A0.W2C);
end;

{ ADDRESS: MAIN 0x000b0209 }
procedure Proc11_0209;
begin
end;

{ ADDRESS: MAIN 0x000b021a }
procedure Proc11_021A;
begin
end;

{ ADDRESS: MAIN 0x000b02b0 }
procedure Proc11_02B0;
begin
end;

{ ADDRESS: MAIN 0x000b02cf }
procedure Proc11_02CF;
var
  X: LongInt;
  Buf: PBuf02;
  S: string;
begin
    Buf := PPtr02(@MAP.Pad66CA)^;
    if MAP.Pad66CA[2052] = 0 then begin
    MAP.Pad66CA[2052] := 1;
    DataVal.G006E := 1;
    Buf^.HD92.Slot3(Buf^.F17C, @Buf^.F3460);
    Buf^.HEA1.Slot3(Buf^.F17C, @Buf^.F3460);
    Buf^.HFB0.Slot3(Buf^.F17C, @Buf^.F3460);
    Buf^.H10BF.Slot3(Buf^.F17C, @Buf^.F3460);
    Buf^.H11CE.Slot3(Buf^.F17C, @Buf^.F3460);
    Buf^.H12DD.Slot3(Buf^.F17C, @Buf^.F3460);
    Buf^.H13EC.Slot3(Buf^.F17C, @Buf^.F3460);
    Buf^.H14FB.Slot3(Buf^.F17C, @Buf^.F3460);
    Buf^.H160A.Slot3(Buf^.F17C, @Buf^.F3460);
    Buf^.H1719.Slot3(Buf^.F17C, @Buf^.F3460);
    Buf^.H1828.Slot3(Buf^.F17C, @Buf^.F3460);
    Buf^.H1937.Slot3(Buf^.F17C, @Buf^.F3460);
    Buf^.H1F91.Slot3(Buf^.F17C, @Buf^.F3460);
    Buf^.H20AB.Slot3(Buf^.F17C, @Buf^.F3460);
    Buf^.H21C5.Slot3(Buf^.F17C, @Buf^.F3460);
    Buf^.H1E8.Slot3(Buf^.F17C, @Buf^.F3460);
    Buf^.H226.Slot3(Buf^.F17C, @Buf^.F3460);
    Buf^.H264.Slot3(Buf^.F17C, @Buf^.F3460);
    Buf^.H2A2.Slot3(Buf^.F17C, @Buf^.F3460);
    Far15E7(@MAP.Pad66CA[260], @Buf^.F40A, $FF);
    Far20C4(Buf^.F3460);
    Buf^.F3460 := Far535A(1, TThing23);
    Far15CD(@S, @MAP.G4F98);
    Far164C('startsze.bmp');
    Buf^.F3460.Slot12;
    Far1B39(Far0E60(0, 0, Buf^.F3460, Buf^.F17C));
    Buf^.H2B9F.Slot2(Buf^.F17C);
    Buf^.H2CAE.Slot2(Buf^.F17C);
    Buf^.H2DC8.Slot2(Buf^.F17C);
    Buf^.H2EE2.Slot2(Buf^.F17C);
    Buf^.H2FFC.Slot2(Buf^.F17C);
    Buf^.H3116.Slot2(Buf^.F17C);
    Buf^.H3230.Slot2(Buf^.F17C);
  end else begin
    MAP.Pad66CA[2052] := 0;
    DataVal.G006E := 0;
    Buf^.H2B9F.Slot3(Buf^.F17C, @Buf^.F3460);
    Buf^.H2CAE.Slot3(Buf^.F17C, @Buf^.F3460);
    Buf^.H2DC8.Slot3(Buf^.F17C, @Buf^.F3460);
    Buf^.H2EE2.Slot3(Buf^.F17C, @Buf^.F3460);
    Buf^.H2FFC.Slot3(Buf^.F17C, @Buf^.F3460);
    Buf^.H3116.Slot3(Buf^.F17C, @Buf^.F3460);
    Buf^.H3230.Slot3(Buf^.F17C, @Buf^.F3460);
    Far20C4(Buf^.F3460);
    Buf^.F3460 := Far535A(1, TThing23);
    Far15CD(@S, @MAP.G4F98);
    Far164C('start1.bmp');
    Buf^.F3460.Slot12;
    Far1B39(Far0E60(0, 0, Buf^.F3460, Buf^.F17C));
    Buf^.HD92.Slot2(Buf^.F17C);
    Buf^.HEA1.Slot2(Buf^.F17C);
    Buf^.HFB0.Slot2(Buf^.F17C);
    Buf^.H10BF.Slot2(Buf^.F17C);
    Buf^.H11CE.Slot2(Buf^.F17C);
    Buf^.H12DD.Slot2(Buf^.F17C);
    Buf^.H13EC.Slot2(Buf^.F17C);
    Buf^.H14FB.Slot2(Buf^.F17C);
    Buf^.H160A.Slot2(Buf^.F17C);
    Buf^.H1719.Slot2(Buf^.F17C);
    Buf^.H1828.Slot2(Buf^.F17C);
    Buf^.H1937.Slot2(Buf^.F17C);
    Buf^.H1F91.Slot2(Buf^.F17C);
    Buf^.H20AB.Slot2(Buf^.F17C);
    Buf^.H21C5.Slot2(Buf^.F17C);
    Buf^.H1E8.Slot2(Buf^.F17C);
    Buf^.H226.Slot2(Buf^.F17C);
    Buf^.H264.Slot2(Buf^.F17C);
    Buf^.H2A2.Slot2(Buf^.F17C);
    Far15E7(@MAP.Pad66CA[4], @Buf^.F40A, $FF);
  end;
    Buf^.H2E0.Slot4(Buf^.F17C);
    Buf^.H3F6.Slot4(Buf^.F17C);
    Buf^.H50C.Slot4(Buf^.F17C);
    Buf^.H622.Slot4(Buf^.F17C);
    Buf^.H738.Slot4(Buf^.F17C);
    Buf^.H847.Slot4(Buf^.F17C);
    Buf^.H1A46.Slot4(Buf^.F17C);
    Buf^.H1B55.Slot4(Buf^.F17C);
    Buf^.H3464.Slot4(Buf^.F17C);
    Buf^.H3577.Slot4(Buf^.F17C);
    Buf^.H1C64.Slot4(Buf^.F17C);
    Buf^.H1D73.Slot4(Buf^.F17C);
    Buf^.H1E82.Slot4(Buf^.F17C);
    Buf^.H22DF.Slot4(Buf^.F17C);
    Buf^.H23F7.Slot4(Buf^.F17C);
    Buf^.H250F.Slot4(Buf^.F17C);
    Buf^.H2627.Slot4(Buf^.F17C);
    Buf^.H273F.Slot4(Buf^.F17C);
    Buf^.H2857.Slot4(Buf^.F17C);
    Buf^.H296F.Slot4(Buf^.F17C);
    Buf^.H2A87.Slot4(Buf^.F17C);
end;

{ ADDRESS: MAIN 0x000b0c7d }
procedure Proc11_0C7D;
begin
end;

{ ADDRESS: MAIN 0x000b0cbb }
procedure Proc11_0CBB;
begin
end;

{ ADDRESS: MAIN 0x000b0cdd }
procedure Proc11_0CDD;
begin
end;

{ ADDRESS: MAIN 0x000b0d23 }
procedure Proc11_0D23;
begin
end;

{ ADDRESS: MAIN 0x000b0d6a }
procedure Proc11_0D6A;
begin
end;

{$F-}
{ ADDRESS: MAIN 0x000b0db1 }
procedure Proc11_0DB1;
begin
end;
{$F+}

{ ADDRESS: MAIN 0x000b0ded }
procedure Proc11_0DED;
begin
end;

{ ADDRESS: MAIN 0x000b0ec4 }
procedure Proc11_0EC4;
begin
end;

{ ADDRESS: MAIN 0x000b0f9b }
procedure Proc11_0F9B;
begin
end;

{ ADDRESS: MAIN 0x000b1072 }
procedure Proc11_1072;
begin
end;

{ ADDRESS: MAIN 0x000b1149 }
procedure Proc11_1149;
begin
end;

{ ADDRESS: MAIN 0x000b1220 }
procedure Proc11_1220;
begin
end;

{ ADDRESS: MAIN 0x000b12f7 }
procedure Proc11_12F7;
begin
end;

{ ADDRESS: MAIN 0x000b13ce }
procedure Proc11_13CE;
begin
end;

{ ADDRESS: MAIN 0x000b14a5 }
procedure Proc11_14A5;
begin
end;

{ ADDRESS: MAIN 0x000b1584 }
procedure Proc11_1584;
begin
end;

{ ADDRESS: MAIN 0x000b1663 }
procedure Proc11_1663;
begin
end;

{ ADDRESS: MAIN 0x000b1742 }
procedure Proc11_1742;
begin
end;

{ ADDRESS: MAIN 0x000b1821 }
procedure Proc11_1821;
begin
end;

{ ADDRESS: MAIN 0x000b1900 }
procedure Proc11_1900;
begin
end;

procedure Proc11_19DF;
begin
end;

procedure Proc11_1A29;
begin
end;

{ ADDRESS: MAIN 0x000b1a30 }
procedure Proc11_1A30;
begin
end;

{ ADDRESS: MAIN 0x000b1ed0 }
procedure Proc11_1ED0;
begin
end;

{ ADDRESS: MAIN 0x000b27e6 }
procedure Proc11_27E6(var A0: TRecP);
var
  S: string;
begin
  A0.F3460 := Far535A(1, TThing23);
  A0.F180 := Far535A(1, TThing23);
  A0.F184 := Far535A(1, TThing23);
  A0.F188 := Far535A(1, TThing23);
  A0.F18C := Far535A(1, TThing23);
  A0.F190 := Far535A(1, TThing23);
  A0.F194 := Far535A(1, TThing23);
  A0.F198 := Far535A(1, TThing23);
  A0.F19C := Far535A(1, TThing23);
  A0.F1A0 := Far535A(1, TThing23);
  A0.F1A4 := Far535A(1, TThing23);
  A0.F1A8 := Far535A(1, TThing23);
  A0.F1AC := Far535A(1, TThing23);
  A0.F1B0 := Far535A(1, TThing23);
  A0.F1B4 := Far535A(1, TThing23);
  A0.F1B8 := Far535A(1, TThing23);
  A0.F1BC := Far535A(1, TThing23);
  A0.F1C0 := Far535A(1, TThing23);
  A0.F1C4 := Far535A(1, TThing23);
  A0.F1C8 := Far535A(1, TThing23);
  A0.F1CC := Far535A(1, TThing23);
  A0.F1D0 := Far535A(1, TThing23);
  A0.F1D4 := Far535A(1, TThing23);
  A0.F1D8 := Far535A(1, TThing23);
  A0.F1DC := Far535A(1, TThing23);
  A0.F1E0 := Far535A(1, TThing23);
  A0.F1E4 := Far535A(1, TThing23);
  Far15cd(@S, @MAP.G4F98);
  Far164c('start1.bmp');
  A0.F3460.Slot12;
  Far15cd(@S, @MAP.G4F98);
  Far164c('scrli.bmp');
  A0.F180.Slot12;
  Far15cd(@S, @MAP.G4F98);
  Far164c('scrre.bmp');
  A0.F184.Slot12;
  Far15cd(@S, @MAP.G4F98);
  Far164c('scrlipr.bmp');
  A0.F188.Slot12;
  Far15cd(@S, @MAP.G4F98);
  Far164c('scrrepr.bmp');
  A0.F18C.Slot12;
  Far15cd(@S, @MAP.G4F98);
  Far164c('scrolli.bmp');
  A0.F190.Slot12;
  Far15cd(@S, @MAP.G4F98);
  Far164c('scrpanel.bmp');
  A0.F194.Slot12;
  Far15cd(@S, @MAP.G4F98);
  Far164c('stkn.bmp');
  A0.F198.Slot12;
  Far15cd(@S, @MAP.G4F98);
  Far164c('stknpr.bmp');
  A0.F19C.Slot12;
  Far15cd(@S, @MAP.G4F98);
  Far164c('strakn.bmp');
  A0.F1A0.Slot12;
  Far15cd(@S, @MAP.G4F98);
  Far164c('straknpr.bmp');
  A0.F1A4.Slot12;
  Far15cd(@S, @MAP.G4F98);
  Far164c('stgelb.bmp');
  A0.F1A8.Slot12;
  Far15cd(@S, @MAP.G4F98);
  Far164c('storan.bmp');
  A0.F1AC.Slot12;
  Far15cd(@S, @MAP.G4F98);
  Far164c('strot.bmp');
  A0.F1B0.Slot12;
  Far15cd(@S, @MAP.G4F98);
  Far164c('stlila.bmp');
  A0.F1B4.Slot12;
  Far15cd(@S, @MAP.G4F98);
  Far164c('strosa.bmp');
  A0.F1B8.Slot12;
  Far15cd(@S, @MAP.G4F98);
  Far164c('stcyan.bmp');
  A0.F1BC.Slot12;
  Far15cd(@S, @MAP.G4F98);
  Far164c('stblau.bmp');
  A0.F1C0.Slot12;
  Far15cd(@S, @MAP.G4F98);
  Far164c('stgrue.bmp');
  A0.F1C4.Slot12;
  Far15cd(@S, @MAP.G4F98);
  Far164c('stgelbpr.bmp');
  A0.F1C8.Slot12;
  Far15cd(@S, @MAP.G4F98);
  Far164c('storanpr.bmp');
  A0.F1CC.Slot12;
  Far15cd(@S, @MAP.G4F98);
  Far164c('strotpr.bmp');
  A0.F1D0.Slot12;
  Far15cd(@S, @MAP.G4F98);
  Far164c('stlilapr.bmp');
  A0.F1D4.Slot12;
  Far15cd(@S, @MAP.G4F98);
  Far164c('strosapr.bmp');
  A0.F1D8.Slot12;
  Far15cd(@S, @MAP.G4F98);
  Far164c('stcyanpr.bmp');
  A0.F1DC.Slot12;
  Far15cd(@S, @MAP.G4F98);
  Far164c('stblaupr.bmp');
  A0.F1E0.Slot12;
  Far15cd(@S, @MAP.G4F98);
  Far164c('stgruepr.bmp');
  A0.F1E4.Slot12;
  Far9eb(@A0.F180, @A0.F184, @A0.F188, @A0.F18C, @A0.F190, @A0.F194, $142, $C2, $60, $10, $1C6A, @A0.S3577);
  Far9eb(@A0.F180, @A0.F184, @A0.F188, @A0.F18C, @A0.F190, @A0.F194, $142, $118, $60, $10, $1B52, @A0.S2A2);
  Far9eb(@A0.F180, @A0.F184, @A0.F188, @A0.F18C, @A0.F190, @A0.F194, $142, $104, $60, $10, $1B02, @A0.S226);
  Far9eb(@A0.F180, @A0.F184, @A0.F188, @A0.F18C, @A0.F190, @A0.F194, $142, $F0, $60, $10, $1ADA, @A0.S1E8);
  Far9eb(@A0.F180, @A0.F184, @A0.F188, @A0.F18C, @A0.F190, @A0.F194, $142, $DC, $60, $10, $1B2A, @A0.S264);
  Far83b(@A0.F198, @A0.F19C, 'x', 9, $152, $132, $90, $16, $1B7A, @A0.F2E0);
  Far83b(@A0.F198, @A0.F19C, 'x', 9, $12, $132, $90, $16, $1B9E, @A0.F3F6);
  Far83b(@A0.F198, @A0.F19C, 'x', 9, $B2, $132, $90, $16, $1BC2, @A0.F50C);
  Far83b(@MAP.ShutdownObjects, @MAP.ShutdownObjects[1], 'x', 9, 0, 0, $10, $10, $1BE6, @A0.F622);
  Far2a2('x', 1, 1, 0, $3C, $1F4, $10, $1492, @A0.F738);
  Far2a2('x', 0, $A, $12, $55, $8C, $10, $1492, @A0.F847);
  Far2a2('Moritz Baer', 0, 9, $AC, $1C, $8C, $18, $1492, @A0.F956);
  Far2a2('Niels Kokkelink', 0, 9, $AC, $34, $8C, $18, $1492, @A0.FA65);
  Far2a2('Rainer Michael', 0, 9, $AC, $4C, $8C, $18, $1492, @A0.FB74);
  Far2a2('x', 1, 9, 0, $68, $1A9, $F, $1492, @A0.FC83);
  Far2a2('x', 0, 9, $AA, $DC, $B4, $10, $1492, @A0.FD92);
  Far764(@S, LongInt(DataVal.Data1400[120]));
  Far2a2B(1, 9, $130, $DC, $10, $10, $1492, @A0.FEA1);
  Far2a2('x', 0, 9, $AA, $F0, $55, $10, $1492, @A0.FFB0);
  Far2a2('x', 2, 9, $104, $F0, $34, $10, $1492, @A0.F10BF);
  Far2a2('x', 0, 9, $1AC, $F0, $3C, $10, $1492, @A0.F11CE);
  Far2a2('x', 0, 9, $AA, $104, $55, $10, $1492, @A0.F12DD);
  Far2a2('x', 2, 9, $104, $104, $34, $10, $1492, @A0.F13EC);
  Far2a2('x', 0, 9, $1AC, $104, $3C, $10, $1492, @A0.F14FB);
  Far2a2('x', 0, 9, $AA, $118, $55, $10, $1492, @A0.F160A);
  Far2a2('x', 2, 9, $104, $118, $34, $10, $1492, @A0.F1719);
  Far2a2('x', 0, 9, $1AC, $118, $3C, $10, $1492, @A0.F1828);
  Far2a2('x', 1, 9, $12C, $AE, $8C, $10, $1492, @A0.F1C64);
  Far2a2('x', 2, 9, $104, $C2, $34, $10, $1492, @A0.F1D73);
  Far2a2('x', 0, 9, $1AC, $C2, $3C, $10, $1492, @A0.F1E82);
  Far2a2('x', 0, 9, $12, $DC, $76, $10, $1492, @A0.F1937);
  Far2a2('x', 2, 9, 4, $C2, $41, $10, $1492, @A0.F1A46);
  Far2a2('x', 2, 9, 4, $AE, $41, $10, $1492, @A0.F1B55);
  Far72c(@A0.F1A0, @A0.F1A4, 'x', 0, 9, $A, $12, $F0, $76, $10, $1C0A, @A0.F1F91);
  Far72c(@A0.F1A0, @A0.F1A4, 'x', 0, 9, $A, $12, $118, $76, $10, $1C4A, @A0.F20AB);
  Far72c(@A0.F1A0, @A0.F1A4, 'x', 0, 9, $A, $12, $104, $76, $10, $1C2A, @A0.F21C5);
  Far1930($C, @DataVal.Data0A00[2], 9, $B, $4A, $AE, $9C, $10, $14AE, @A0.F3464);
  Far559(@A0.F1A8, @A0.F1C8, 'x', 0, 9, $4A, $C2, $10, $10, $1C92, @A0.F22DF);
  Far559(@A0.F1AC, @A0.F1CC, 'x', 0, 9, $5E, $C2, $10, $10, $1CB2, @A0.F23F7);
  Far559(@A0.F1B0, @A0.F1D0, 'x', 0, 9, $72, $C2, $10, $10, $1CD2, @A0.F250F);
  Far559(@A0.F1B4, @A0.F1D4, 'x', 0, 9, $86, $C2, $10, $10, $1CF2, @A0.F2627);
  Far559(@A0.F1B8, @A0.F1D8, 'x', 0, 9, $9A, $C2, $10, $10, $1D12, @A0.F273F);
  Far559(@A0.F1BC, @A0.F1DC, 'x', 0, 9, $AE, $C2, $10, $10, $1D32, @A0.F2857);
  Far559(@A0.F1C0, @A0.F1E0, 'x', 0, 9, $C2, $C2, $10, $10, $1D52, @A0.F296F);
  Far559(@A0.F1C4, @A0.F1E4, 'x', 0, 9, $D6, $C2, $10, $10, $1D72, @A0.F2A87);
  Far2a2('x', 1, $A, $10, $104, $1D4, $25, $1492, @A0.F2B9F);
  Far72c(@A0.F1A0, @A0.F1A4, 'x', 0, 9, $A, $12, $DC, $82, $10, $1D92, @A0.F2CAE);
  Far72c(@A0.F1A0, @A0.F1A4, 'x', 0, 9, $A, $12, $F0, $82, $10, $1DB2, @A0.F2DC8);
  Far72c(@A0.F1A0, @A0.F1A4, 'x', 0, 9, $A, $B3, $DC, $82, $10, $1DD2, @A0.F2EE2);
  Far72c(@A0.F1A0, @A0.F1A4, 'x', 0, 9, $A, $B3, $F0, $82, $10, $1DF2, @A0.F2FFC);
  Far72c(@A0.F1A0, @A0.F1A4, 'x', 0, 9, $A, $153, $DC, $82, $10, $1E12, @A0.F3116);
  Far72c(@A0.F1A0, @A0.F1A4, 'x', 0, 9, $A, $153, $F0, $82, $10, $1E32, @A0.F3230);
  Far83b(@A0.F198, @A0.F19C, 'x', 9, 8, $8E, $90, $16, $1AB6, @A0.F334A);
  Far17e1($14E, A0);
  Far17bf($1F4, @A0);
  Far17e1($14E, A0.F17C);
  Far17bf($1F4, A0.F17C);
  Far179d(0, A0.F17C);
  Far177b(0, A0.F17C);
  Far179d((MAP.W54FE - A0.F24) div 2, @A0);
  Far177b((MAP.W54FC - A0.F22) div 2, @A0);
  MAP.Pad66CA[2052] := 0;
  Far1ed0(@A0);
  Far15e7(@MAP.Pad66CA[4], @A0.F40A, $FF);
  A0.S3577.W24 := 0;
  A0.S3577.W28 := 2;
  A0.S3577.W2A := 0;
  A0.S3577.W2C := PWord11(@DataVal.Data0000_008C)^;
  A0.S2A2.W24 := 0;
  A0.S2A2.W28 := 10;
  A0.S2A2.W2A := 0;
  A0.S2A2.W2C := DataVal.G0092;
  A0.S226.W24 := 0;
  A0.S226.W28 := 4;
  A0.S226.W2A := 0;
  A0.S226.W2C := DataVal.G0090;
  A0.S1E8.W24 := 0;
  A0.S1E8.W28 := 4;
  A0.S1E8.W2A := 0;
  A0.S1E8.W2C := DataVal.G008E;
  A0.S264.W24 := 0;
  A0.S264.W28 := 7;
  A0.S264.W2A := 0;
  A0.S264.W2C := DataVal.Data1400[120];
  if DataVal.G008A = 0 then begin
    A0.F20A0 := 1;
  end
  else if DataVal.G008A = 1 then begin
    A0.F22D4 := 1;
  end
  else if DataVal.G008A = 2 then begin
    A0.F21BA := 1;
    A0.F23EE := 1;
    A0.F2DBD := 1;
  end;
  Far15e7(@MAP.Pad66CA[516], @A0.F2BAA, $FF);
end;

{ ADDRESS: MAIN 0x000b3b61 }
procedure Proc11_3B61;
begin
end;

procedure Proc11_3CFD;
begin
end;

function Far13B0(A0, A1: Word; A2: Pointer; var A3): Boolean;
begin
  Far13B0 := False;
end;

function Far15F7(A0, A1: Word; A2: Pointer; var A3): Boolean;
begin
  Far15F7 := False;
end;

function FarFE3(A0, A1: Word; A2: Pointer; var A3): Boolean;
begin
  FarFE3 := False;
end;

function Far666(A0, A1: Word; A2: Pointer; var A3): Boolean;
begin
  Far666 := False;
end;

function Far1C1B(A0, A1: Word; A2: Pointer; var A3, A4): Boolean;
begin
  Far1C1B := False;
end;

procedure Far125E(A0: Word; var A1: TThing412F);
begin
end;

procedure Far123D(A0: Word; var A1: TThing412F);
begin
end;

procedure Far38DA;
begin
end;

function Far19D7(A0: Word; A1: TShiftState; A2: Pointer; var A3, A4): Boolean;
begin
  Far19D7 := False;
end;

procedure TDispatch.Slot1;
begin
end;

procedure TDispatch.Slot2;
begin
end;

procedure TDispatch.Slot3;
begin
end;

procedure TDispatch.Slot5;
begin
end;

procedure TDispatch.Slot4(O: Pointer);
begin
end;

function TDispatch.Slot6(X, Y: Word; O: Pointer): Boolean;
begin
  Slot6 := False;
end;

function TDispatch.Slot7(X, Y: Word; O: Pointer): Boolean;
begin
  Slot7 := False;
end;

procedure Far22C6(var X: TThing412F);
begin
end;

procedure Proc11_412F;
begin
end;

procedure Proc11_41FB;
begin
end;

procedure Proc11_4381;
begin
end;

function Far535A(A0: Byte; A1: Pointer): TThing23;
begin
end;

procedure Far15CD(A0, A1: Pointer);
begin
end;

function Far0E60(A0, A1: Word; A2, A3: Pointer): Pointer;
begin
end;

procedure Far1B39(A0: Pointer);
begin
end;

procedure Far177B(A0: Word; A1: Pointer);
begin
end;

procedure Far179D(A0: Word; A1: Pointer);
begin
end;

procedure Far17BF(A0: Word; A1: Pointer);
begin
end;

procedure Far1930(A0: Word; A1: Pointer; A2, A3, A4, A5, A6, A7, A8: Word; A9: Pointer);
begin
end;

procedure Far1ED0(A0: Pointer);
begin
end;

procedure Far2A2(A0: string; A1, A2, A3, A4, A5, A6, A7: Word; A8: Pointer);
begin
end;

procedure Far559(A0, A1: Pointer; A2: string; A3, A4, A5, A6, A7, A8, A9: Word; A10: Pointer);
begin
end;

procedure Far72C(A0, A1: Pointer; A2: string; A3, A4, A5, A6, A7, A8, A9, A10: Word; A11: Pointer);
begin
end;

procedure Far83B(A0, A1: Pointer; A2: string; A3, A4, A5, A6, A7, A8: Word; A9: Pointer);
begin
end;

procedure Far9EB(A0, A1, A2, A3, A4, A5: Pointer; A6, A7, A8, A9, A10: Word; A11: Pointer);
begin
end;

procedure TThing23.Slot0;
begin
end;

procedure TThing23.Slot1;
begin
end;

procedure TThing23.Slot2;
begin
end;

procedure TThing23.Slot3;
begin
end;

procedure TThing23.Slot4;
begin
end;

procedure TThing23.Slot5;
begin
end;

procedure TThing23.Slot6;
begin
end;

procedure TThing23.Slot7;
begin
end;

procedure TThing23.Slot8;
begin
end;

procedure TThing23.Slot9;
begin
end;

procedure TThing23.Slot10;
begin
end;

procedure TThing23.Slot11;
begin
end;

procedure TThing23.Slot12;
begin
end;

procedure Far2a2B(A0, A1, A2, A3, A4, A5, A6: Word; A7: Pointer);
begin
end;

{ ADDRESS: MAIN 0x000b19df }
procedure TStartform.MaperstButtonClick(Sender: TObject);
begin
begin
  Self.M56CE;
  P6456B(P6456A(P6456)^.Ptr184)^.L000C := $000002BC;
  Far125E(1, PThing412F(P6456A(P6456)^.Ptr184)^);
  Far123D(1, PThing412F(P6456A(P6456)^.Ptr184)^);
end;
end;

{ ADDRESS: MAIN 0x000b1a29 }
procedure TStartform.SprachButtonClick(Sender: TObject);
begin
end;

{ ADDRESS: MAIN 0x000b3cfd }
procedure TStartform.BildMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if ssLeft in Shift then
  if
    FarFE3(X, Y, PThing412F(Bild), Item226) or
      FarFE3(X, Y, PThing412F(Bild), Item1E8) or
      FarFE3(X, Y, PThing412F(Bild), Item264) or
      FarFE3(X, Y, PThing412F(Bild), Item3577) or
      FarFE3(X, Y, PThing412F(Bild), Item2A2) or
      Host2E0.Slot6(X, Y, PThing412F(Bild)) or
      Host334A.Slot6(X, Y, PThing412F(Bild)) or
      Host3F6.Slot6(X, Y, PThing412F(Bild)) or
      Host50C.Slot6(X, Y, PThing412F(Bild)) or
      Host622.Slot6(X, Y, PThing412F(Bild)) or
      Far666(X, Y, PThing412F(Bild), Item20AB) or
      Far666(X, Y, PThing412F(Bild), Item1F91) or
      Far666(X, Y, PThing412F(Bild), Item21C5) or
      Far666(X, Y, PThing412F(Bild), Item22DF) or
      Far666(X, Y, PThing412F(Bild), Item23F7) or
      Far666(X, Y, PThing412F(Bild), Item250F) or
      Far666(X, Y, PThing412F(Bild), Item2627) or
      Far666(X, Y, PThing412F(Bild), Item273F) or
      Far666(X, Y, PThing412F(Bild), Item2857) or
      Far666(X, Y, PThing412F(Bild), Item296F) or
      Far666(X, Y, PThing412F(Bild), Item2A87) or
      Far666(X, Y, PThing412F(Bild), Item2CAE) or
      Far666(X, Y, PThing412F(Bild), Item2DC8) or
      Far666(X, Y, PThing412F(Bild), Item2EE2) or
      Far666(X, Y, PThing412F(Bild), Item2FFC) or
      Far666(X, Y, PThing412F(Bild), Item3116) or
      Far666(X, Y, PThing412F(Bild), Item3230) or
      Far1C1B(X, Y, PThing412F(Bild), Item3460, Item3464)
  then
    Far22C6(PThing412F(Bild)^);
end;

{ ADDRESS: MAIN 0x000b412f }
procedure TStartform.BildMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  if Shift = [ssLeft] then
    if Far13B0(X, Y, PThing412F(Bild), Item226) or Far13B0(X, Y, PThing412F(Bild), Item1E8) or
       Far13B0(X, Y, PThing412F(Bild), Item264) or Far13B0(X, Y, PThing412F(Bild), Item2A2) or
       Far13B0(X, Y, PThing412F(Bild), Item3577) then
      Far22C6(PThing412F(Bild)^);
end;

{ ADDRESS: MAIN 0x000b41fb }
procedure TStartform.BildMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if
    Far15F7(X, Y, PThing412F(Bild), Item226) or
      Far15F7(X, Y, PThing412F(Bild), Item1E8) or
      Far15F7(X, Y, PThing412F(Bild), Item264) or
      Far15F7(X, Y, PThing412F(Bild), Item3577) or
      Far15F7(X, Y, PThing412F(Bild), Item2A2) or
      Host2E0.Slot7(X, Y, PThing412F(Bild)) or
      Host334A.Slot7(X, Y, PThing412F(Bild)) or
      Host3F6.Slot7(X, Y, PThing412F(Bild)) or
      Host50C.Slot7(X, Y, PThing412F(Bild)) or
      Host622.Slot7(X, Y, PThing412F(Bild))
  then
    Far22C6(PThing412F(Bild)^);
end;

{ ADDRESS: MAIN 0x000b4381 }
procedure TStartform.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
begin
  if (Shift = [ssAlt]) and (Key = $73) then begin
    Key := $00FF;
    Far38DA;
    G74CA.M6F58;
  end
  else if Far19D7(Key, Shift, PThing412F(Bild), Item3460, Item3464) then
    Far22C6(PThing412F(Bild)^);
end;
end;

procedure TStartform.M56CE;
begin
end;
end.
