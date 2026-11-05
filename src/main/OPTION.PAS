unit OPTION;
{ Reconstructed scaffold, holiday.exe code segment 12 (13272 bytes).
  This is form unit for TOptionenform; the original kept its forms inside the segment's own  unit
  (docs/tree.md).
  Evidence: form TOptionenform, 1 components.
  `uses` comes from this segment's relocation records, the class members
  from RTTI and form streams. Known close-handler bodies are recovered;
  other method bodies remain stubs. }
{$F+}
interface

uses MPlayer, ExtCtrls, Graphics, Controls, Forms, Classes;

type
  TThing = packed record
    Pad: array[0..0] of Byte;
  end;
  PThing = ^TThing;
  TItem = packed record
    B: Byte;
  end;
  { The dispatch object the mouse and key bodies call through. Nine field
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
  TRecP = packed record
    P0: array[0..33] of Byte;
    F22: Word;
    P24: array[0..343] of Byte;
    F17C: Pointer;
    P180: array[0..11] of Byte;
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
    F1C8: Pointer;
    P1CC: array[0..273] of Byte;
    F2DE: Pointer;
    P2E2: array[0..273] of Byte;
    F3F4: Pointer;
    P3F8: array[0..273] of Byte;
    F50A: Pointer;
    P50E: array[0..273] of Byte;
    F620: Pointer;
    P624: array[0..275] of Byte;
    F738: Pointer;
    P73C: array[0..275] of Byte;
    F850: Pointer;
    P854: array[0..275] of Byte;
    F968: Pointer;
    P96C: array[0..275] of Byte;
    FA80: Pointer;
    PA84: array[0..275] of Byte;
    FB98: Pointer;
    PB9C: array[0..275] of Byte;
    FCB0: Pointer;
    PCB4: array[0..275] of Byte;
    FDC8: Pointer;
    PDCC: array[0..275] of Byte;
    FEE0: Pointer;
    PEE4: array[0..275] of Byte;
    FFF8: Pointer;
    PFFC: array[0..275] of Byte;
    F1110: Pointer;
    P1114: array[0..275] of Byte;
    F1228: Pointer;
    P122C: array[0..275] of Byte;
    F1340: Pointer;
    P1344: array[0..275] of Byte;
    F1458: Pointer;
    P145C: array[0..275] of Byte;
    F1570: Pointer;
    P1574: array[0..275] of Byte;
    F1688: Pointer;
    P168C: array[0..57] of Byte;
    F16C6: Pointer;
    P16CA: array[0..275] of Byte;
    F17DE: Pointer;
    P17E2: array[0..57] of Byte;
    F181C: Pointer;
    P1820: array[0..275] of Byte;
    F1934: Pointer;
    P1938: array[0..57] of Byte;
    F1972: Pointer;
    P1976: array[0..275] of Byte;
    F1A8A: Pointer;
    P1A8E: array[0..275] of Byte;
    F1BA2: Pointer;
    P1BA6: array[0..275] of Byte;
    F1CBA: Pointer;
    P1CBE: array[0..275] of Byte;
    F1DD2: Pointer;
    P1DD6: array[0..275] of Byte;
    F1EEA: Pointer;
    P1EEE: array[0..275] of Byte;
    F2002: Pointer;
    P2006: array[0..275] of Byte;
    F211A: Pointer;
    P211E: array[0..275] of Byte;
    F2232: Pointer;
    P2236: array[0..57] of Byte;
    F2270: Pointer;
    P2274: array[0..275] of Byte;
    F2388: Pointer;
    P238C: array[0..266] of Byte;
    F2497: Pointer;
    P249B: array[0..266] of Byte;
    F25A6: Pointer;
    P25AA: array[0..266] of Byte;
    F26B5: Pointer;
    P26B9: array[0..266] of Byte;
    F27C4: Pointer;
    P27C8: array[0..266] of Byte;
    F28D3: Pointer;
    P28D7: array[0..266] of Byte;
    F29E2: Pointer;
    P29E6: array[0..266] of Byte;
    F2AF1: Pointer;
    P2AF5: array[0..266] of Byte;
    F2C00: Pointer;
    P2C04: array[0..275] of Byte;
    F2D18: Pointer;
    P2D1C: array[0..275] of Byte;
    F2E30: Pointer;
  end;
function Far15F7(A0, A1: Word; A2: Pointer; var A3): Boolean;
function Far797(A0, A1: Word; A2: Pointer; var A3): Boolean;
function Far666(A0, A1: Word; A2: Pointer; var A3): Boolean;
function FarFE3(A0, A1: Word; A2: Pointer; var A3): Boolean;
procedure Far6C7(A0: Pointer; var A1);
procedure Far7FA(A0: Pointer; var A1);
procedure Far17E1(A0: Word; var A1);
procedure Far2AA5(var X);
procedure Far185(var X);
function Far13B0(A0, A1: Word; A2: Pointer; var A3): Boolean;
function FarF19(A0, A1, A2: LongInt): LongInt;
function FarF53(A0: LongInt): Word;
function FarF19B(A0, A1: LongInt): LongInt;
function FarF53B(A0, A1: LongInt): LongInt;
procedure Far22C6(var X: TThing);
procedure Proc12_0151(A0, A1: Word);
procedure Proc12_0163(A0, A1: Word);
procedure Proc12_0175(A0, A1: Word);
procedure Proc12_01AB(A0, A1: Word);
procedure Proc12_01DC(A0, A1: Word);
procedure Proc12_0224(A0, A1: Word);
procedure Proc12_0239(A0, A1: Word);
procedure Proc12_024E(A0, A1: Word);
procedure Proc12_0263(A0, A1: Word);
procedure Proc12_0278(A0, A1: Word);
procedure Proc12_028D(A0, A1: Word);
procedure Proc12_02A2(A0, A1: Word);
procedure Proc12_044F(A0, A1: Word);
procedure Proc12_0464(A0, A1: Word);
procedure Proc12_0479(A0, A1: Word);
procedure Proc12_048E(A0, A1: Word);
procedure Proc12_04A3(A0, A1: Word);
procedure Proc12_04B8(A0, A1: Word);
procedure Proc12_04CD(A0, A1: Word);
procedure Proc12_04E2(A0, A1: Word);
procedure Proc12_04F9(A0, A1: Word);
procedure Proc12_050B(A0, A1: Word);
procedure Proc12_0522(A0, A1: Word);
procedure Proc12_0534(A0, A1: Word);
procedure Proc12_054D(A0, A1: Word);
procedure Proc12_055F(A0, A1: Word);
procedure Proc12_0571(A0, A1: Word);
procedure Proc12_0583(A0, A1: Word);
procedure Proc12_0595(A0, A1: Word);
procedure Proc12_05A7(A0, A1: Word);
procedure Proc12_05B9(A0, A1: Word);
procedure Proc12_05CB(A0, A1: Word);
procedure Proc12_0619(A0, A1: Word);
procedure Proc12_0637(A0, A1: Word);
procedure Proc12_0656(A0, A1: Word);
procedure Proc12_06BA(A0, A1: Word);
procedure Proc12_071E(A0, A1: Word);
procedure Proc12_0782(A0, A1, A2, A3: Word);
procedure Proc12_0789(A0, A1: Word);
procedure Proc12_0E79(A0, A1, A2, A3: Word);
procedure Proc12_0E80(A0, A1: Word);
procedure Proc12_0ED0(A0, A1: Word);
procedure Proc12_14F1(var A0: TRecP);
procedure Proc12_231C(A0, A1: Word);
procedure Proc12_2404(A0, A1, A2, A3, A4, A5, A6, A7: Word);
procedure Proc12_29F0(A0, A1, A2, A3, A4, A5, A6: Word);
procedure Proc12_2B17(A0, A1, A2, A3, A4, A5, A6, A7: Word);
procedure Proc12_2C72(A0, A1, A2, A3, A4, A5, A6: Word);
procedure Proc12_33CB(A0, A1, A2, A3, A4, A5: Word);
function Far535A(A0: Byte; A1: Pointer): TThing23;
procedure Far15CD(A0, A1: Pointer);
procedure Far177B(A0: Word; A1: Pointer);
procedure Far179D(A0: Word; A1: Pointer);
procedure Far17BF(A0: Word; A1: Pointer);
procedure Far2A2(A0: string; A1, A2, A3, A4, A5, A6, A7: Word; A8: Pointer);
procedure Far559(A0, A1: Pointer; A2: string; A3, A4, A5, A6, A7, A8, A9: Word; A10: Pointer);
procedure Far83B(A0, A1: Pointer; A2: string; A3, A4, A5, A6, A7, A8: Word; A9: Pointer);
procedure Far9EB(A0, A1, A2, A3, A4, A5: Pointer; A6, A7, A8, A9, A10: Word; A11: Pointer);
procedure FarED0(A0: Pointer);


type
  TOptionenform = class(TForm)
  published
    bild: TImage;
  private
    { Observed private fields; original field names are unresolved. }
    Flag180: Byte;
    Field181: Integer;
    Field183: Integer;
    Field185: Integer;
    Field187: Integer;
    Field189: Integer;
    Flag18B: Byte;
    Pad18C: array[0..59] of Byte;
    Host1C8: TDispatch;
    Pad1D3: array[0..266] of Byte;
    Host2DE: TDispatch;
    Pad2E9: array[0..266] of Byte;
    Host3F4: TDispatch;
    Pad3FF: array[0..266] of Byte;
    Host50A: TDispatch;
    Pad515: array[0..266] of Byte;
    Item620: TItem;
    Pad621: array[0..278] of Byte;
    Item738: TItem;
    Pad739: array[0..278] of Byte;
    Item850: TItem;
    Pad851: array[0..278] of Byte;
    Item968: TItem;
    Pad969: array[0..278] of Byte;
    ItemA80: TItem;
    PadA81: array[0..278] of Byte;
    ItemB98: TItem;
    PadB99: array[0..278] of Byte;
    ItemCB0: TItem;
    PadCB1: array[0..278] of Byte;
    ItemDC8: TItem;
    PadDC9: array[0..278] of Byte;
    ItemEE0: TItem;
    PadEE1: array[0..278] of Byte;
    ItemFF8: TItem;
    PadFF9: array[0..278] of Byte;
    Item1110: TItem;
    Pad1111: array[0..278] of Byte;
    Item1228: TItem;
    Pad1229: array[0..278] of Byte;
    Item1340: TItem;
    Pad1341: array[0..278] of Byte;
    Item1458: TItem;
    Pad1459: array[0..278] of Byte;
    Item1570: TItem;
    Pad1571: array[0..278] of Byte;
    Host1688: TDispatch;
    Pad1693: array[0..24] of Byte;
    L16AC: LongInt;
    L16B0: LongInt;
    L16B4: LongInt;
    Pad16B8: array[0..13] of Byte;
    Item16C6: TItem;
    Pad16C7: array[0..278] of Byte;
    Host17DE: TDispatch;
    Pad17E9: array[0..24] of Byte;
    L1802: LongInt;
    L1806: LongInt;
    L180A: LongInt;
    Pad180E: array[0..13] of Byte;
    Item181C: TItem;
    Pad181D: array[0..278] of Byte;
    Host1934: TDispatch;
    Pad193F: array[0..24] of Byte;
    L1958: LongInt;
    L195C: LongInt;
    L1960: LongInt;
    Pad1964: array[0..13] of Byte;
    Item1972: TItem;
    Pad1973: array[0..278] of Byte;
    Item1A8A: TItem;
    Pad1A8B: array[0..278] of Byte;
    Item1BA2: TItem;
    Pad1BA3: array[0..278] of Byte;
    Item1CBA: TItem;
    Pad1CBB: array[0..278] of Byte;
    Item1DD2: TItem;
    Pad1DD3: array[0..278] of Byte;
    Item1EEA: TItem;
    Pad1EEB: array[0..278] of Byte;
    Item2002: TItem;
    Pad2003: array[0..278] of Byte;
    Item211A: TItem;
    Pad211B: array[0..278] of Byte;
    Host2232: TDispatch;
    Pad223D: array[0..24] of Byte;
    L2256: LongInt;
    L225A: LongInt;
    L225E: LongInt;
    Pad2262: array[0..13] of Byte;
    Item2270: TItem;
    Pad2271: array[0..2446] of Byte;
    Item2C00: TItem;
    Pad2C01: array[0..278] of Byte;
    Item2D18: TItem;
    Pad2D19: array[0..278] of Byte;
    Item2E30: TItem;
    procedure M17E1(A0: Word);
    procedure M177B(A0: Word);
    procedure M179D(A0: Word);
  published
  private
    { shortcut: opaque private storage; name fields as accesses are recovered. }
    UnrecoveredState: array[0..278] of Byte;
  published
    procedure FormShow(Sender: TObject);
    procedure FormHide(Sender: TObject);
    procedure bildMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure bildMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure bildMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  end;

implementation

uses DATEN, BAUFEN, DATWIN, GFX, HIGHSCOR, ANIM, SOUND, SEG24, DataVal, MAP;

function Far15F7(A0, A1: Word; A2: Pointer; var A3): Boolean;
begin
  Far15F7 := False;
end;

function Far797(A0, A1: Word; A2: Pointer; var A3): Boolean;
begin
  Far797 := False;
end;

function Far666(A0, A1: Word; A2: Pointer; var A3): Boolean;
begin
  Far666 := False;
end;

function FarFE3(A0, A1: Word; A2: Pointer; var A3): Boolean;
begin
  FarFE3 := False;
end;

procedure Far6C7(A0: Pointer; var A1);
begin
end;

procedure Far7FA(A0: Pointer; var A1);
begin
end;

procedure Far17E1(A0: Word; var A1);
begin
end;

procedure Far2AA5(var X);
begin
end;

procedure Far185(var X);
begin
end;

function Far13B0(A0, A1: Word; A2: Pointer; var A3): Boolean;
begin
  Far13B0 := False;
end;

function FarF19(A0, A1, A2: LongInt): LongInt;
begin
  FarF19 := 0;
end;

function FarF53(A0: LongInt): Word;
begin
  FarF53 := 0;
end;

function FarF19B(A0, A1: LongInt): LongInt;
begin
  FarF19B := 0;
end;

function FarF53B(A0, A1: LongInt): LongInt;
begin
  FarF53B := 0;
end;

procedure Far22C6(var X: TThing);
begin
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

procedure Proc12_0151;
begin
end;

procedure Proc12_0163;
begin
end;

procedure Proc12_0175;
begin
end;

procedure Proc12_01AB;
begin
end;

procedure Proc12_01DC;
begin
end;

{$F-}
procedure Proc12_01FA;
begin
end;
{$F+}

procedure Proc12_0224;
begin
end;

procedure Proc12_0239;
begin
end;

procedure Proc12_024E;
begin
end;

procedure Proc12_0263;
begin
end;

procedure Proc12_0278;
begin
end;

procedure Proc12_028D;
begin
end;

procedure Proc12_02A2;
begin
end;

{$F-}
procedure Proc12_02B7;
begin
end;
{$F+}

procedure Proc12_044F;
begin
end;

procedure Proc12_0464;
begin
end;

procedure Proc12_0479;
begin
end;

procedure Proc12_048E;
begin
end;

procedure Proc12_04A3;
begin
end;

procedure Proc12_04B8;
begin
end;

procedure Proc12_04CD;
begin
end;

procedure Proc12_04E2;
begin
end;

procedure Proc12_04F9;
begin
end;

procedure Proc12_050B;
begin
end;

procedure Proc12_0522;
begin
end;

procedure Proc12_0534;
begin
end;

procedure Proc12_054D;
begin
end;

procedure Proc12_055F;
begin
end;

procedure Proc12_0571;
begin
end;

procedure Proc12_0583;
begin
end;

procedure Proc12_0595;
begin
end;

procedure Proc12_05A7;
begin
end;

procedure Proc12_05B9;
begin
end;

procedure Proc12_05CB;
begin
end;

procedure Proc12_0619;
begin
end;

procedure Proc12_0637;
begin
end;

procedure Proc12_0656;
begin
end;

procedure Proc12_06BA;
begin
end;

procedure Proc12_071E;
begin
end;

procedure Proc12_0782;
begin
end;

procedure Proc12_0789;
begin
end;

procedure Proc12_0E79;
begin
end;

procedure Proc12_0E80;
begin
end;

procedure Proc12_0ED0;
begin
end;

procedure Proc12_14F1(var A0: TRecP);
var
  S: string;
begin
  A0.F18C := Far535A(1, TThing23);
  A0.F190 := Far535A(1, TThing23);
  A0.F194 := Far535A(1, TThing23);
  A0.F198 := Far535A(1, TThing23);
  A0.F19C := Far535A(1, TThing23);
  A0.F1A8 := Far535A(1, TThing23);
  A0.F1AC := Far535A(1, TThing23);
  A0.F1A0 := Far535A(1, TThing23);
  A0.F1A4 := Far535A(1, TThing23);
  A0.F1B0 := Far535A(1, TThing23);
  A0.F1B4 := Far535A(1, TThing23);
  A0.F1B8 := Far535A(1, TThing23);
  A0.F1BC := Far535A(1, TThing23);
  A0.F1C0 := Far535A(1, TThing23);
  A0.F1C4 := Far535A(1, TThing23);
  Far15cd(@S, @MAP.G4F98);
  Far164c('optionen.bmp');
  A0.F18C.Slot12;
  Far15cd(@S, @MAP.G4F98);
  Far164c('optch.bmp');
  A0.F190.Slot12;
  Far15cd(@S, @MAP.G4F98);
  Far164c('optchpr.bmp');
  A0.F194.Slot12;
  Far15cd(@S, @MAP.G4F98);
  Far164c('optra.bmp');
  A0.F198.Slot12;
  Far15cd(@S, @MAP.G4F98);
  Far164c('optrapr.bmp');
  A0.F19C.Slot12;
  Far15cd(@S, @MAP.G4F98);
  Far164c('optkn.bmp');
  A0.F1A8.Slot12;
  Far15cd(@S, @MAP.G4F98);
  Far164c('optknpr.bmp');
  A0.F1AC.Slot12;
  Far15cd(@S, @MAP.G4F98);
  Far164c('opttop.bmp');
  A0.F1A0.Slot12;
  Far15cd(@S, @MAP.G4F98);
  Far164c('opttoppr.bmp');
  A0.F1A4.Slot12;
  Far15cd(@S, @MAP.G4F98);
  Far164c('optli.bmp');
  A0.F1B0.Slot12;
  Far15cd(@S, @MAP.G4F98);
  Far164c('optlipr.bmp');
  A0.F1B4.Slot12;
  Far15cd(@S, @MAP.G4F98);
  Far164c('optre.bmp');
  A0.F1B8.Slot12;
  Far15cd(@S, @MAP.G4F98);
  Far164c('optrepr.bmp');
  A0.F1BC.Slot12;
  Far15cd(@S, @MAP.G4F98);
  Far164c('optscrol.bmp');
  A0.F1C0.Slot12;
  Far15cd(@S, @MAP.G4F98);
  Far164c('optpanel.bmp');
  A0.F1C4.Slot12;
  Far83b(@MAP.ShutdownObjects, @MAP.ShutdownObjects[1], 'x', 9, 0, 0, $10, $10, $1F06, @A0.F1C8);
  Far83b(@A0.F1A8, @A0.F1AC, 'x', 9, $B3, $158, $96, $16, $1F2A, @A0.F2DE);
  Far83b(@A0.F1A0, @A0.F1A4, 'x', 9, $B3, $13E, $46, $16, $1F4E, @A0.F3F4);
  Far83b(@A0.F1A0, @A0.F1A4, 'x', 9, $103, $13E, $46, $16, $1F72, @A0.F50A);
  Far559(@A0.F190, @A0.F194, 'x', 0, 9, $C, $18, $7A, $10, $1F96, @A0.F620);
  Far559(@A0.F190, @A0.F194, 'Anotrian', 0, 9, $C, $2C, $7A, $10, $1FB6, @A0.F738);
  Far559(@A0.F190, @A0.F194, 'Dub''o''What?', 0, 9, $C, $3E, $7A, $10, $1FD6, @A0.F850);
  Far559(@A0.F190, @A0.F194, 'Floatin''', 0, 9, $C, $50, $7A, $10, $1FF6, @A0.F968);
  Far559(@A0.F190, @A0.F194, 'Samba do...', 0, 9, $C, $62, $7A, $10, $2016, @A0.FA80);
  Far559(@A0.F190, @A0.F194, 'Ukanchi', 0, 9, $C, $74, $7A, $10, $2036, @A0.FB98);
  Far559(@A0.F190, @A0.F194, 'Cuban Memories', 0, 9, $C, $86, $7A, $10, $2056, @A0.FCB0);
  Far559(@A0.F190, @A0.F194, 'Holiday Island', 0, 9, $C, $98, $7A, $10, $2076, @A0.FDC8);
  Far559(@A0.F198, @A0.F19C, 'x', 0, 9, $92, $2C, $10, $10, $2096, @A0.FEE0);
  Far559(@A0.F198, @A0.F19C, 'x', 0, 9, $92, $3E, $10, $10, $20B6, @A0.FFF8);
  Far559(@A0.F198, @A0.F19C, 'x', 0, 9, $92, $50, $10, $10, $20D6, @A0.F1110);
  Far559(@A0.F198, @A0.F19C, 'x', 0, 9, $92, $62, $10, $10, $20F6, @A0.F1228);
  Far559(@A0.F198, @A0.F19C, 'x', 0, 9, $92, $74, $10, $10, $2116, @A0.F1340);
  Far559(@A0.F198, @A0.F19C, 'x', 0, 9, $92, $86, $10, $10, $2136, @A0.F1458);
  Far559(@A0.F198, @A0.F19C, 'x', 0, 9, $92, $98, $10, $10, $2156, @A0.F1570);
  Far9eb(@A0.F1B0, @A0.F1B8, @A0.F1B4, @A0.F1BC, @A0.F1C0, @A0.F1C4, $C, $BE, $97, $10, $2176, @A0.F1688);
  Far559(@A0.F190, @A0.F194, 'x', 0, 9, $C, $D7, $7A, $10, $219E, @A0.F16C6);
  Far9eb(@A0.F1B0, @A0.F1B8, @A0.F1B4, @A0.F1BC, @A0.F1C0, @A0.F1C4, $C, $FB, $97, $10, $21BE, @A0.F17DE);
  Far559(@A0.F190, @A0.F194, 'x', 0, 9, $C, $113, $7A, $10, $21E6, @A0.F181C);
  Far9eb(@A0.F1B0, @A0.F1B8, @A0.F1B4, @A0.F1BC, @A0.F1C0, @A0.F1C4, $C, $137, $97, $10, $2206, @A0.F1934);
  Far559(@A0.F190, @A0.F194, 'x', 0, 9, $B3, $2A, $7A, $10, $222E, @A0.F1972);
  Far559(@A0.F190, @A0.F194, 'x', 0, 9, $B3, $3C, $7A, $10, $224E, @A0.F1A8A);
  Far559(@A0.F190, @A0.F194, 'x', 0, 9, $B3, $4E, $7A, $10, $226E, @A0.F1BA2);
  Far559(@A0.F190, @A0.F194, 'x', 0, 9, $B3, $60, $7A, $10, $228E, @A0.F1CBA);
  Far559(@A0.F190, @A0.F194, 'x', 0, 9, $B3, $D9, $7A, $10, $22AE, @A0.F1DD2);
  Far559(@A0.F190, @A0.F194, 'x', 0, 9, $B3, $EB, $7A, $10, $22CE, @A0.F1EEA);
  Far559(@A0.F190, @A0.F194, 'x', 0, 9, $B3, $FD, $7A, $10, $22EE, @A0.F2002);
  Far559(@A0.F190, @A0.F194, 'x', 0, 9, $B3, $10F, $7A, $10, $230E, @A0.F211A);
  Far9eb(@A0.F1B0, @A0.F1B8, @A0.F1B4, @A0.F1BC, @A0.F1C0, @A0.F1C4, $C, $161, $97, $10, $232E, @A0.F2232);
  Far559(@A0.F190, @A0.F194, 'x', 0, 9, $B3, $127, $7A, $10, $2356, @A0.F2270);
  Far559(@A0.F190, @A0.F194, 'x', 0, 9, $B3, $8B, $7A, $10, $2376, @A0.F2C00);
  Far559(@A0.F190, @A0.F194, 'x', 0, 9, $B3, $9D, $7A, $10, $2396, @A0.F2D18);
  Far559(@A0.F190, @A0.F194, 'x', 0, 9, $B3, $AF, $7A, $10, $23B6, @A0.F2E30);
  Far2a2('x', 1, 1, $10, 0, $146, $10, $1492, @A0.F2388);
  Far2a2('x', 0, 9, $18, $AC, $96, $10, $1492, @A0.F2497);
  Far2a2('x', 0, 9, $18, $E9, $96, $10, $1492, @A0.F25A6);
  Far2a2('x', 0, 9, $18, $125, $96, $10, $1492, @A0.F26B5);
  Far2a2('x', 0, 9, $18, $14F, $96, $10, $1492, @A0.F27C4);
  Far2a2('x', 0, 9, $B3, $17, $96, $10, $1492, @A0.F28D3);
  Far2a2('x', 0, 9, $B3, $78, $96, $10, $1492, @A0.F29E2);
  Far2a2('x', 0, 9, $B3, $C6, $96, $10, $1492, @A0.F2AF1);
  Far17e1($179, A0);
  Far17bf($156, @A0);
  Far17e1($179, A0.F17C);
  Far17bf($156, A0.F17C);
  Far179d(0, A0.F17C);
  Far177b(0, A0.F17C);
  Far179d(0, @A0);
  Far177b((MAP.W54FC - A0.F22) div 2, @A0);
  Fared0(@A0);
end;

procedure Proc12_231C;
begin
end;

procedure Proc12_2404;
begin
end;

procedure Proc12_29F0;
begin
end;

procedure Proc12_2B17;
begin
end;

procedure Proc12_2C72;
begin
end;

procedure Proc12_33CB;
begin
end;

function Far535A(A0: Byte; A1: Pointer): TThing23;
begin
end;

procedure Far15CD(A0, A1: Pointer);
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

procedure Far2A2(A0: string; A1, A2, A3, A4, A5, A6, A7: Word; A8: Pointer);
begin
end;

procedure Far559(A0, A1: Pointer; A2: string; A3, A4, A5, A6, A7, A8, A9: Word; A10: Pointer);
begin
end;

procedure Far83B(A0, A1: Pointer; A2: string; A3, A4, A5, A6, A7, A8: Word; A9: Pointer);
begin
end;

procedure Far9EB(A0, A1, A2, A3, A4, A5: Pointer; A6, A7, A8, A9, A10: Word; A11: Pointer);
begin
end;

procedure FarED0(A0: Pointer);
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

procedure TOptionenform.FormShow;
begin
end;

procedure TOptionenform.FormHide;
begin
end;

procedure TOptionenform.bildMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Flag180 := 0;
  if
    Host1C8.Slot6(X, Y, PThing(Bild)) or Host2DE.Slot6(X, Y, PThing(Bild)) or Host3F4.Slot6(X, Y, PThing(Bild)) or
      Host50A.Slot6(X, Y, PThing(Bild)) or Far797(X, Y, PThing(Bild), Item620) or Far797(X, Y, PThing(Bild), Item738) or
        Far797(X, Y, PThing(Bild), Item850) or
      Far797(X, Y, PThing(Bild), Item968) or
      Far797(X, Y, PThing(Bild), ItemA80) or
        Far797(X, Y, PThing(Bild), ItemB98) or
      Far797(X, Y, PThing(Bild), ItemCB0) or
      Far797(X, Y, PThing(Bild), ItemDC8) or
        Far666(X, Y, PThing(Bild), ItemEE0) or
      Far666(X, Y, PThing(Bild), ItemFF8) or
      Far666(X, Y, PThing(Bild), Item1110) or
        Far666(X, Y, PThing(Bild), Item1228) or
      Far666(X, Y, PThing(Bild), Item1340) or
      Far666(X, Y, PThing(Bild), Item1458) or
        Far666(X, Y, PThing(Bild), Item1570) or
      FarFE3(X, Y, PThing(Bild), Host1688) or
      Far797(X, Y, PThing(Bild), Item16C6) or
        FarFE3(X, Y, PThing(Bild), Host17DE) or
      Far797(X, Y, PThing(Bild), Item181C) or
      FarFE3(X, Y, PThing(Bild), Host1934) or
        Far797(X, Y, PThing(Bild), Item1972) or
      Far797(X, Y, PThing(Bild), Item1A8A) or
      Far797(X, Y, PThing(Bild), Item1BA2) or
        Far797(X, Y, PThing(Bild), Item1CBA) or
      Far797(X, Y, PThing(Bild), Item1DD2) or
      Far797(X, Y, PThing(Bild), Item1EEA) or
        Far797(X, Y, PThing(Bild), Item2002) or
      Far797(X, Y, PThing(Bild), Item211A) or
      FarFE3(X, Y, PThing(Bild), Host2232) or
        Far797(X, Y, PThing(Bild), Item2270) or
      Far666(X, Y, PThing(Bild), Item2C00) or
      Far666(X, Y, PThing(Bild), Item2D18) or
        Far666(X, Y, PThing(Bild), Item2E30)
  then
    Far22C6(PThing(Bild)^)
  else if (X >= 16) and (X <= Width) and (Y >= 0) and (Y < 16) then begin
    Flag180 := 1;
    Far2AA5(Field181);
    Field181 := Field181 - Left;
    Field183 := Field183 - Top;
    if Flag18B = 0 then begin
      Field189 := Height;
      Self.M17E1($10);
    end;
    Flag18B := Ord(ssDouble in Shift);
  end;
end;

procedure TOptionenform.bildMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  if
    Far13B0(X, Y, PThing(Bild), Host1688) or Far13B0(X, Y, PThing(Bild), Host17DE) or
      Far13B0(X, Y, PThing(Bild), Host1934) or Far13B0(X, Y, PThing(Bild), Host2232)
  then
    Far22C6(PThing(Bild)^)
  else if Flag180 <> 0 then
    if ssLeft in Shift then begin
      Far185(Field185);
      Self.M177B(FarF53(FarF19(LongInt(Integer(W54FC) - Width), 0, LongInt(Field185 - Field181))));
      Self.M179D(FarF53(FarF19(LongInt(Integer(W54FE) - Height), 0, LongInt(Field187 - Field183))));
    end;
end;

procedure TOptionenform.bildMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if
    Host1C8.Slot7(X, Y, PThing(Bild)) or Host2DE.Slot7(X, Y, PThing(Bild)) or Host3F4.Slot7(X, Y, PThing(Bild)) or
      Host50A.Slot7(X, Y, PThing(Bild)) or
      Far15F7(X, Y, PThing(Bild), Host1688) or
      Far15F7(X, Y, PThing(Bild), Host17DE) or
      Far15F7(X, Y, PThing(Bild), Host1934) or Far15F7(X, Y, PThing(Bild), Host2232)
  then
    Far22C6(PThing(Bild)^)
  else if (Flag180 <> 0) and (Flag18B = 0) then
    Self.M17E1(Field189);
end;

procedure TOptionenform.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if (Shift = []) or (Shift = [ssShift]) then
    case Key of
      $1B, $0D: Host1C8.Slot1;
      $20: Host50A.Slot1;
      $54: Host3F4.Slot1;
      $4D: Far7FA(PThing(Bild), Item620);
      $31: Far7FA(PThing(Bild), Item738);
      $32: Far7FA(PThing(Bild), Item850);
      $33: Far7FA(PThing(Bild), Item968);
      $34: Far7FA(PThing(Bild), ItemA80);
      $35: Far7FA(PThing(Bild), ItemB98);
      $36: Far7FA(PThing(Bild), ItemCB0);
      $37: Far7FA(PThing(Bild), ItemDC8);
      $61: Far6C7(PThing(Bild), ItemEE0);
      $62: Far6C7(PThing(Bild), ItemFF8);
      $63: Far6C7(PThing(Bild), Item1110);
      $64: Far6C7(PThing(Bild), Item1228);
      $65: Far6C7(PThing(Bild), Item1340);
      $66: Far6C7(PThing(Bild), Item1458);
      $67: Far6C7(PThing(Bild), Item1570);
      $25: begin
        L16B4 := FarF19B(L16B4 - 1, L16AC);
        Host1688.Slot1;
        Host1688.Slot4(PThing(Bild));
      end;
      $27: begin
        L16B4 := FarF53B(L16B4 + 1, L16B0);
        Host1688.Slot1;
        Host1688.Slot4(PThing(Bild));
      end;
      $47: Far7FA(PThing(Bild), Item16C6);
      $53: Far7FA(PThing(Bild), Item181C);
      $70: Far7FA(PThing(Bild), Item1972);
      $71: Far7FA(PThing(Bild), Item1A8A);
      $72: Far7FA(PThing(Bild), Item1BA2);
      $73: Far7FA(PThing(Bild), Item1CBA);
      $74: Far6C7(PThing(Bild), Item2C00);
      $75: Far6C7(PThing(Bild), Item2D18);
      $76: Far6C7(PThing(Bild), Item2E30);
      $78: Far7FA(PThing(Bild), Item1DD2);
      $79: Far7FA(PThing(Bild), Item1EEA);
      $7A: Far7FA(PThing(Bild), Item2002);
      $7B: Far7FA(PThing(Bild), Item211A);
      $BD, $6D: begin
        L225E := FarF19B(L225E - 1, L2256);
        Host2232.Slot1;
        Host2232.Slot4(PThing(Bild));
      end;
      $BB, $6B: begin
        L225E := FarF53B(L225E + 1, L225A);
        Host2232.Slot1;
        Host2232.Slot4(PThing(Bild));
      end;
      $4B: Far7FA(PThing(Bild), Item2270);
    end
  else if Shift = [ssCtrl] then
    case Key of
      $25: begin
        L180A := FarF19B(L180A - 1, L1802);
        Host17DE.Slot1;
        Host17DE.Slot4(PThing(Bild));
      end;
      $27: begin
        L180A := FarF53B(L180A + 1, L1806);
        Host17DE.Slot1;
        Host17DE.Slot4(PThing(Bild));
      end;
    end
  else if Shift = [ssAlt] then
    case Key of
      $25: begin
        L1960 := FarF19B(L1960 - 1, L1958);
        Host1934.Slot1;
        Host1934.Slot4(PThing(Bild));
      end;
      $27: begin
        L1960 := FarF53B(L1960 + 1, L195C);
        Host1934.Slot1;
        Host1934.Slot4(PThing(Bild));
      end;
      $73: begin
        Key := $00FF;
        Host1C8.Slot1;
      end;
    end;
  Far22C6(PThing(Bild)^);
end;

procedure TOptionenform.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TOptionenform.M17E1(A0: Word);
begin
end;

procedure TOptionenform.M177B(A0: Word);
begin
end;

procedure TOptionenform.M179D(A0: Word);
begin
end;
procedure CallersInit12;
var
  Rec14: TRecP;
begin
  Proc12_14F1(Rec14);
end;

begin
  CallersInit12;
end.
