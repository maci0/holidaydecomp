unit KOMPASS;
{ Reconstructed scaffold, holiday.exe code segment 7 (16296 bytes).
  This is unit holding TKompassform, TLadenForm, TInfobox2; the original kept its forms inside the
  segment's own  unit (docs/tree.md).
  Evidence: form TKompassform (1 components), form TLadenForm (1 components), form TInfobox2 (1
  components).
  `uses` comes from this segment's relocation records, the class members
  from RTTI and form streams. Known close-handler bodies are recovered;
  other method bodies remain stubs. }
{$F+}
interface

uses ExtCtrls, Graphics, Controls, Forms, Classes, SysUtils;

type
  TObj7 = object
    Pad1D: array[1..30] of Byte;
    W1E: Word;
    W20: Word;
    Pad22: array[1..350] of Byte;
    B180: Byte;
    Pad181: array[1..97] of Byte;
    L1E2: LongInt;
    procedure SetFlag;
  end;
  TBlk7 = packed record
    Pad180: array[0..$17F] of Byte;
    F180: Pointer;
    F184: Pointer;
    F188: Pointer;
    F18C: Pointer;
    F190: Pointer;
    F194: Pointer;
    F198: Pointer;
    F19C: Pointer;
    F1A0: Pointer;
  end;
  PBlk7 = ^TBlk7;
  PByte7 = ^Byte;
  TDisp7 = record
    Pad: array[0..$1F] of Byte;
    Handler: function(A0, A1: Word; A2, A3: Pointer): Byte;
  end;
  PDisp7 = ^TDisp7;
  TItem7 = packed record
    Pad: array[0..8] of Byte;
    Disp: PDisp7;
    Rest: array[0..266] of Byte;
  end;
  TOuter7 = packed record
    Pad0: array[0..$17B] of Byte;
    F17C: Pointer;
    Pad180: array[0..32] of Byte;
    Items: array[0..3] of TItem7;
  end;
  POuter7 = ^TOuter7;
  TRecLad7 = packed record
    Pad: array[0..279] of Byte;
  end;
  TLad7 = packed record
    Pad17C: array[0..$17B] of Byte;
    L17C: LongInt;
    Pad180: array[0..$23] of Byte;
    Items: array[0..3] of TRecLad7;
  end;
  PLad7 = ^TLad7;
  TDispO7 = packed record
    Pad0: array[0..11] of Byte;
    H0C: procedure(A0, A1: Pointer);
    H10: procedure(A0, A1, A2: Pointer);
    H14: procedure(A0, A1: Pointer);
    Pad18: array[0..3] of Byte;
    H1C: function(A0, A1: Word; A2, A3: Pointer): Boolean;
    H20: function(A0, A1: Word; A2: Byte; A3, A4: Pointer): Boolean;
  end;
  PDispO7 = ^TDispO7;
  TSub7 = packed record
    Pad0: array[0..8] of Byte;
    Disp: PDispO7;
    Pad1: array[0..17] of Byte;
    W1F: Word;
  end;
  PSub7 = ^TSub7;
  TItemO7 = packed record
    Pad0: array[0..8] of Byte;
    Disp: PDispO7;
    Rest: array[0..264] of Byte;
  end;
  TBlob7 = packed record
    Pad: array[0..0] of Byte;
  end;
  PBlob7 = ^TBlob7;
  PObs7 = ^TObs7;
  TObs7 = packed record
    Pad0: array[0..$17B] of Byte;
    F17C: PBlob7;
    Sub180: TSub7;
    Items: array[0..3] of TItemO7;
    Sub5F9: TSub7;
  end;
  PSeg7 = ^TSeg7;
  TSeg7 = packed record
    Pad0: array[0..$19B] of Byte;
    F19C: PBlob7;
    Pad1A0: array[0..619] of Byte;
    Sub40C: TSub7;
  end;
  TDisp1C7 = packed record
    Pad0: array[0..27] of Byte;
    H1C: function(A0, A1: Word; A2, A3: Pointer): Boolean;
    H20: function(A0, A1: Word; A2, A3: Pointer): Boolean;
  end;
  PDisp1C7 = ^TDisp1C7;
  TItemD7 = packed record
    Pad0: array[0..8] of Byte;
    Disp: PDisp1C7;
    Rest: array[0..264] of Byte;
  end;
  TObs3329 = packed record
    Pad1C: array[0..$1D] of Byte;
    W1E: Word;
    W20: Word;
    W22: SmallInt;
    W24: Word;
    Pad26: array[0..341] of Byte;
    F17C: PBlob7;
    Pad180: array[0..$23] of Byte;
    Items: array[0..3] of TItem7;
    Sub604: TItemD7;
    B71A: Byte;
    W71B: Word;
    W71D: Word;
    Pad71F: array[0..3] of Byte;
    W723: Word;
    B725: Byte;
  end;
procedure Far22C6(var A0);
procedure Far56CE(A0: Pointer);
procedure Far20C4(A0: Pointer);
procedure Far17E1(A0: Word; var A1);
procedure Proc7_014B(A0, A1, A2: Word);
procedure Proc7_098D(A0, A1, A2: Word);
procedure Proc7_0A44(A0, A1, A2: Word);
procedure Proc7_0AFE(A0, A1, A2: Word);
procedure Proc7_0B40(A0, A1, A2: Word);
procedure Proc7_0C00(A0, A1, A2: Word);
procedure Proc7_0D3A(A0, A1, A2: Word);
procedure Proc7_0E13(A0, A1: Word);
procedure Proc7_17F3(A0, A1: Word);
procedure Proc7_1899(A0, A1: Word);
procedure Proc7_1A75(A0, A1: Word);
procedure Proc7_1B92(A0, A1: Word);
procedure Proc7_1CCF(A0, A1: Word; A2: LongInt; A3: TObj7);
procedure Proc7_1EAC(A0, A1, A2, A3, A4, A5: Word);
procedure Proc7_1EE0(A0, A1: Word);
procedure Proc7_1F69(A0, A1: Word);
procedure Proc7_2302(A0, A1: Word);
procedure Proc7_24D6(A0, A1, A2: Word);
procedure Proc7_2742(A0, A1, A2, A3, A4, A5, A6, A7: Word);
procedure Proc7_27B4(A0, A1, A2, A3, A4, A5, A6, A7: Word);
procedure Proc7_284B(A0, A1, A2, A3, A4, A5, A6: Word);
procedure Proc7_29E3(A0, A1: Word);
procedure Proc7_2A41(A0, A1: Word);
procedure Proc7_2A9F(A0, A1: Word);
procedure Proc7_2AFD(A0, A1: Word);
procedure Proc7_2B5B(A0: Pointer);
procedure Proc7_2C04(A0, A1: Word);
procedure Proc7_30B7(P: PBlk7);
procedure Proc7_314F(var A0);
procedure Proc7_3243(var A0);
procedure Proc7_3256(A0, A1: Word);
procedure Proc7_3329(A0, A1, A2: Word; A3: Byte; A4, A5: Word; var A6: TObs3329);
procedure Far348A(A0: Pointer);
procedure Proc7_346F(A0, A1, A2, A3, A4, A5, A6: Word);
procedure Proc7_34FC(A0, A1, A2, A3, A4, A5: Word; var A6: TObs3329);
procedure Proc7_3557(A0, A1, A2, A3, A4, A5, A6: Word);
procedure Proc7_3682(A0, A1: Word);
procedure Proc7_36A2(A0, A1, A2, A3, A4, A5, A6: Word);
procedure Proc7_36D5(A0: PSub7);
procedure Proc7_3776(A0: PSub7);
procedure Proc7_3817(A0, A1: Word);
procedure Proc7_3836(A0, A1: Word);
procedure Proc7_3A13(A0, A1: Word);
procedure Proc7_3A95(A0, A1: Word);
procedure Proc7_3B46(A0, A1: Word);
procedure Proc7_3DFA(A0, A1: Word);
procedure Proc7_3E24(A0, A1, A2: Word; A3: Byte; A4, A5: Word; A6: PObs7);
procedure Proc7_3EF5(A0, A1, A2, A3, A4, A5: Word; P: POuter7);
procedure Proc7_3F9B(A0, A1: Word; P: PByte7; A4, A5: Word);


type
  TKompassform = class(TForm)
    Bild: TImage;
  private
    { shortcut: opaque private storage; name fields as accesses are recovered. }
    UnrecoveredState: array[0..1445] of Byte;
  published
    procedure BildMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure BildMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure BildMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  end;
  TLadenForm = class(TForm)
    Bild: TImage;
  private
    { shortcut: opaque private storage; name fields as accesses are recovered. }
    UnrecoveredState: array[0..1148] of Byte;
  published
    procedure BildMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure BildMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  end;
  TInfobox2 = class(TForm)
    Infoimage: TImage;
  private
    { shortcut: opaque private storage; name fields as accesses are recovered. }
    UnrecoveredState: array[0..102] of Byte;
  published
    procedure InfoimageMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure InfoimageMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  end;

implementation

uses DATEN, DATWIN, GFX, HAUS, SCHLUSS, SEG15, MENU, SOUND, MAP, SEG24;

procedure Far22C6(var A0);
begin
end;

procedure Far56CE(A0: Pointer);
begin
end;

procedure Far20C4(A0: Pointer);
begin
end;

procedure Far17E1(A0: Word; var A1);
begin
end;

{ ADDRESS: MAIN 0x0007014b }
procedure Proc7_014B;
begin
end;

{ ADDRESS: MAIN 0x0007098d }
procedure Proc7_098D;
begin
end;

{ ADDRESS: MAIN 0x00070a44 }
procedure Proc7_0A44;
begin
end;

{ ADDRESS: MAIN 0x00070afe }
procedure Proc7_0AFE;
begin
end;

{ ADDRESS: MAIN 0x00070b40 }
procedure Proc7_0B40;
begin
end;

{ ADDRESS: MAIN 0x00070c00 }
procedure Proc7_0C00;
begin
end;

{ ADDRESS: MAIN 0x00070d3a }
procedure Proc7_0D3A;
begin
end;

{ ADDRESS: MAIN 0x00070e13 }
procedure Proc7_0E13;
begin
end;

{ ADDRESS: MAIN 0x000717f3 }
procedure Proc7_17F3;
begin
end;

{ ADDRESS: MAIN 0x00071899 }
procedure Proc7_1899;
begin
end;

{ ADDRESS: MAIN 0x00071a75 }
procedure Proc7_1A75;
begin
end;

{ ADDRESS: MAIN 0x00071b92 }
procedure Proc7_1B92;
begin
end;

{ ADDRESS: MAIN 0x00071ccf }
procedure Proc7_1CCF(A0, A1: Word; A2: LongInt; A3: TObj7);
begin
end;

procedure TObj7.SetFlag;
begin
  B180 := 1;
  Proc7_1CCF(W1E, W20, L1E2, Self);
end;

{ ADDRESS: MAIN 0x00071eac }
procedure Proc7_1EAC;
begin
end;

{ ADDRESS: MAIN 0x00071ee0 }
procedure Proc7_1EE0;
begin
end;

{ ADDRESS: MAIN 0x00071f69 }
procedure Proc7_1F69;
begin
end;

{ ADDRESS: MAIN 0x00072302 }
procedure Proc7_2302;
begin
end;

{$F-}
{ ADDRESS: MAIN 0x00072478 }
procedure Proc7_2478;
begin
end;
{$F+}

{ ADDRESS: MAIN 0x000724d6 }
procedure Proc7_24D6;
begin
end;

procedure Proc7_2742;
begin
end;

procedure Proc7_27B4;
begin
end;

procedure Proc7_284B;
begin
end;

{ ADDRESS: MAIN 0x000729e3 }
procedure Proc7_29E3(A0, A1: Word);
var
  P: Pointer;
begin
  Proc2_254D(0);
  P := G6620;
  Proc24_06FE(PLad7(P)^.L17C, @PLad7(P)^.Items[1]);
  Proc24_06FE(PLad7(P)^.L17C, @PLad7(P)^.Items[2]);
  Proc24_06FE(PLad7(P)^.L17C, @PLad7(P)^.Items[3]);
end;

{ ADDRESS: MAIN 0x00072a41 }
procedure Proc7_2A41(A0, A1: Word);
var
  P: Pointer;
begin
  Proc2_254D(3);
  P := G6620;
  Proc24_06FE(PLad7(P)^.L17C, @PLad7(P)^.Items[0]);
  Proc24_06FE(PLad7(P)^.L17C, @PLad7(P)^.Items[2]);
  Proc24_06FE(PLad7(P)^.L17C, @PLad7(P)^.Items[3]);
end;

{ ADDRESS: MAIN 0x00072a9f }
procedure Proc7_2A9F(A0, A1: Word);
var
  P: Pointer;
begin
  Proc2_254D(2);
  P := G6620;
  Proc24_06FE(PLad7(P)^.L17C, @PLad7(P)^.Items[0]);
  Proc24_06FE(PLad7(P)^.L17C, @PLad7(P)^.Items[1]);
  Proc24_06FE(PLad7(P)^.L17C, @PLad7(P)^.Items[3]);
end;

{ ADDRESS: MAIN 0x00072afd }
procedure Proc7_2AFD(A0, A1: Word);
var
  P: Pointer;
begin
  Proc2_254D(1);
  P := G6620;
  Proc24_06FE(PLad7(P)^.L17C, @PLad7(P)^.Items[0]);
  Proc24_06FE(PLad7(P)^.L17C, @PLad7(P)^.Items[1]);
  Proc24_06FE(PLad7(P)^.L17C, @PLad7(P)^.Items[2]);
end;

{ ADDRESS: MAIN 0x00072b5b }
procedure Proc7_2B5B(A0: Pointer);
begin
  Proc7_3243(G6620^);
  Proc24_06FE(LongInt(PSeg7(P6532)^.F19C), @PSeg7(P6532)^.Sub40C);
  Far22C6(PSeg7(P6532)^.F19C^);
end;

{ ADDRESS: MAIN 0x00072c04 }
procedure Proc7_2C04;
begin
end;

{ ADDRESS: MAIN 0x000730b7 }
procedure Proc7_30B7(P: PBlk7);
begin
  Far56CE(P);
  Far20C4(P^.F180);
  Far20C4(P^.F184);
  Far20C4(P^.F188);
  Far20C4(P^.F18C);
  Far20C4(P^.F190);
  Far20C4(P^.F194);
  Far20C4(P^.F198);
  Far20C4(P^.F19C);
  Far20C4(P^.F1A0);
end;

{ ADDRESS: MAIN 0x0007314f }
procedure Proc7_314F(var A0);
begin
end;

{ ADDRESS: MAIN 0x00073243 }
procedure Proc7_3243(var A0);
begin
  Far17E1(0, A0);
end;

{ ADDRESS: MAIN 0x00073256 }
procedure Proc7_3256;
begin
end;

procedure Proc7_3329(A0, A1, A2: Word; A3: Byte; A4, A5: Word; var A6: TObs3329);
begin
  A6.B71A := 0;
  if Proc24_0666(A4, A5, A6.F17C, @A6.Items[0])
     or Proc24_0666(A4, A5, A6.F17C, @A6.Items[1])
     or Proc24_0666(A4, A5, A6.F17C, @A6.Items[2])
     or Proc24_0666(A4, A5, A6.F17C, @A6.Items[3])
     or A6.Sub604.Disp^.H1C(A4, A5, A6.F17C, @A6.Sub604) then
    Far22C6(A6.F17C^)
  else if (SmallInt(A4) >= $10) and (SmallInt(A4) <= A6.W22) and (SmallInt(A5) >= 0)
         and (SmallInt(A5) < $10) then
  begin
    A6.B71A := 1;
    Far348A(@A6.W71B);
    A6.W71B := A6.W71B - A6.W1E;
    A6.W71D := A6.W71D - A6.W20;
    if A6.B725 = 0 then
    begin
      A6.W723 := A6.W24;
      Far17E1($10, A6);
    end;
    if (A3 and $40) <> 0 then
      A6.B725 := 1
    else
      A6.B725 := 0;
  end;
end;

procedure Far348A(A0: Pointer);
begin
end;

procedure Proc7_346F;
begin
end;

procedure Proc7_34FC(A0, A1, A2, A3, A4, A5: Word; var A6: TObs3329);
begin
  if A6.Sub604.Disp^.H20(A4, A5, A6.F17C, @A6.Sub604) then
    Far22C6(A6.F17C^)
  else if (A6.B71A <> 0) and (A6.B725 = 0) then
    Far17E1(A6.W723, A6);
end;

procedure Proc7_3557;
begin
end;

{ ADDRESS: MAIN 0x00073682 }
procedure Proc7_3682;
begin
end;

{ ADDRESS: MAIN 0x000736a2 }
procedure Proc7_36A2;
begin
end;

{ ADDRESS: MAIN 0x000736d5 }
procedure Proc7_36D5(A0: PSub7);
var
  Q: PSub7;
begin
  Q := @PObs7(G6ED0)^.Sub180;
  if Proc24_03CC(Q) then
  begin
    Q^.W1F := Q^.W1F - 1;
    Q^.Disp^.H14(PObs7(G6ED0)^.F17C, Q);
  end;
  if not Proc24_03CC(Q) then
    A0^.Disp^.H10(PObs7(G6ED0)^.F17C, @PObs7(G6ED0)^.Sub5F9, A0);
  if Proc24_03E7(Q) then
    PObs7(G6ED0)^.Items[1].Disp^.H0C(PObs7(G6ED0)^.F17C, @PObs7(G6ED0)^.Items[1]);
end;

{ ADDRESS: MAIN 0x00073776 }
procedure Proc7_3776(A0: PSub7);
var
  Q: PSub7;
begin
  Q := @PObs7(G6ED0)^.Sub180;
  if Proc24_03E7(Q) then
  begin
    Q^.W1F := Q^.W1F + 1;
    Q^.Disp^.H14(PObs7(G6ED0)^.F17C, Q);
  end;
  if not Proc24_03E7(Q) then
    A0^.Disp^.H10(PObs7(G6ED0)^.F17C, @PObs7(G6ED0)^.Sub5F9, A0);
  if Proc24_03CC(Q) then
    PObs7(G6ED0)^.Items[0].Disp^.H0C(PObs7(G6ED0)^.F17C, @PObs7(G6ED0)^.Items[0]);
end;

{ ADDRESS: MAIN 0x00073817 }
procedure Proc7_3817;
begin
end;

{ ADDRESS: MAIN 0x00073836 }
procedure Proc7_3836;
begin
end;

{$F-}
{ ADDRESS: MAIN 0x0007385b }
procedure Proc7_385B;
begin
end;
{$F+}

{$F-}
{ ADDRESS: MAIN 0x0007389d }
procedure Proc7_389D;
begin
end;
{$F+}

{$F-}
{ ADDRESS: MAIN 0x0007390d }
procedure Proc7_390D;
begin
end;
{$F+}

{$F-}
{ ADDRESS: MAIN 0x00073983 }
procedure Proc7_3983;
begin
end;
{$F+}

{ ADDRESS: MAIN 0x00073a13 }
procedure Proc7_3A13;
begin
end;

{ ADDRESS: MAIN 0x00073a95 }
procedure Proc7_3A95;
begin
end;

{ ADDRESS: MAIN 0x00073b46 }
procedure Proc7_3B46;
begin
end;

{ ADDRESS: MAIN 0x00073dfa }
procedure Proc7_3DFA;
begin
end;

procedure Proc7_3E24(A0, A1, A2: Word; A3: Byte; A4, A5: Word; A6: PObs7);
begin
  if A6^.Sub180.Disp^.H20(A4, A5, A3, A6^.F17C, @A6^.Sub180)
     or A6^.Items[3].Disp^.H1C(A4, A5, A6^.F17C, @A6^.Items[3])
     or A6^.Items[2].Disp^.H1C(A4, A5, A6^.F17C, @A6^.Items[2])
     or A6^.Items[1].Disp^.H1C(A4, A5, A6^.F17C, @A6^.Items[1])
     or A6^.Items[0].Disp^.H1C(A4, A5, A6^.F17C, @A6^.Items[0]) then
    Far22C6(A6^.F17C^);
end;

procedure Proc7_3EF5(A0, A1, A2, A3, A4, A5: Word; P: POuter7);
label Tail, Done;
begin
  if P^.Items[2].Disp^.Handler(A4, A5, P^.F17C, @P^.Items[2]) <> 0 then goto Tail;
  if P^.Items[3].Disp^.Handler(A4, A5, P^.F17C, @P^.Items[3]) <> 0 then goto Tail;
  if P^.Items[1].Disp^.Handler(A4, A5, P^.F17C, @P^.Items[1]) <> 0 then goto Tail;
  if P^.Items[0].Disp^.Handler(A4, A5, P^.F17C, @P^.Items[0]) = 0 then goto Done;
Tail:
  Far22C6(P^.F17C^);
Done:
end;

procedure Proc7_3F9B(A0, A1: Word; P: PByte7; A4, A5: Word);
begin
  P^ := 2;
end;

{ ADDRESS: MAIN 0x00073329 }
procedure TKompassform.BildMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
end;

{ ADDRESS: MAIN 0x000734fc }
procedure TKompassform.BildMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
end;

{ ADDRESS: MAIN 0x0007346f }
procedure TKompassform.BildMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
end;

{ ADDRESS: MAIN 0x00073557 }
procedure TKompassform.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  DATWIN.Proc4_2E09(Pointer(Sender), @Key, Shift, @MAP.P6532^);
end;

{ ADDRESS: MAIN 0x00073e24 }
procedure TLadenForm.BildMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
end;

{ ADDRESS: MAIN 0x00073ef5 }
procedure TLadenForm.BildMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
end;

{ ADDRESS: MAIN 0x00073f9b }
procedure TLadenForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

{ ADDRESS: MAIN 0x00072742 }
procedure TInfobox2.InfoimageMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
end;

{ ADDRESS: MAIN 0x000727b4 }
procedure TInfobox2.InfoimageMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
end;

{ ADDRESS: MAIN 0x0007284b }
procedure TInfobox2.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
end;
procedure CallersInit7;
var
  State7: TObj7;
  Obs3329: TObs3329;
  Obs34FC: TObs3329;
begin
  Proc7_30B7(nil);
  State7.SetFlag;
  Proc7_3243(State7);
  Proc7_36D5(nil);
  Proc7_3776(nil);
  Proc7_2B5B(nil);
  Proc7_3329(0, 0, 0, 0, 0, 0, Obs3329);
  Proc7_34FC(0, 0, 0, 0, 0, 0, Obs34FC);
  Proc7_3E24(0, 0, 0, 0, 0, 0, nil);
  Proc7_3F9B(0, 0, nil, 0, 0);
  Proc7_3EF5(0, 0, 0, 0, 0, 0, nil);
  Proc7_29E3(0, 0);
  Proc7_2A41(0, 0);
  Proc7_2A9F(0, 0);
  Proc7_2AFD(0, 0);
end;

begin
  CallersInit7;
end.
