unit SCHLUSS;
{ Reconstructed scaffold, holiday.exe code segment 13 (13061 bytes).
  This is form unit for TSchlussform; the original kept its forms inside the segment's own  unit
  (docs/tree.md).
  Evidence: form TSchlussform, 6 components.
  `uses` comes from this segment's relocation records, the class members
  from RTTI and form streams. Recovered free bodies are listed in the
  implementation; the other bodies are not recovered. }
{$F+}
interface

uses MPlayer, ExtCtrls, Graphics, Controls, Forms, Classes, SysUtils;

type
  PNode13 = ^TNode13;
  TNode13 = packed record
    Data: Pointer;
    Next: Pointer;
  end;
  PSlot13 = ^Pointer;
  TThing13E = packed record
    W: Word;
  end;
  PThing13E = ^TThing13E;
  TRec0E1A = packed record
    Pad: array[0..$193] of Byte;
    F194: PThing13E;
    F198: PThing13E;
    F19C: PThing13E;
    F1A0: PThing13E;
  end;
  PRec0E1A = ^TRec0E1A;
procedure Proc13_0180(A0, A1: Word);
procedure Proc13_01B3(A0, A1: Word);
procedure Proc13_01DF(A0, A1: Word);
procedure Proc13_0201(A0, A1: Word);
procedure Proc13_0218(A0, A1: Word);
procedure Proc13_023A(A: Word; P: Pointer; N: Word);
procedure Far2A0(A0: Pointer);
procedure Proc13_0288(A0, A1: Word);
procedure Proc13_09A5(A0, A1: Word);
procedure Proc13_0E1A(var P: TRec0E1A);
procedure Far0E39(var A0: TThing13E);
procedure Far0E48(var A0: TThing13E);
procedure Far0E57(var A0: TThing13E);
procedure Far0EDC(var A0: TThing13E);
procedure Proc13_0E68(A0, A1: Word);
procedure Proc13_0F52(A0, A1: Word);
procedure Proc13_1016(A0, A1: Word);
procedure Proc13_1340(A0, A1: Word);
procedure Proc13_1593(A0, A1: Word);
procedure Proc13_1613(A0, A1, A2, A3, A4, A5, A6, A7: Word);
procedure Proc13_16E0(A0, A1, A2, A3, A4, A5, A6, A7: Word);
procedure Proc13_17AD(P: Pointer);
procedure Proc13_187F(A0, A1, A2, A3: Word);
procedure Proc13_198A(A0, A1, A2, A3, A4: Word; P: Pointer);
procedure Proc13_199B(A0, A1: Word; P: Pointer);
procedure Proc13_19AC;
procedure Proc13_19BE;
procedure Proc13_19D0;
procedure Proc13_19E2(P: PSlot13);
procedure Proc13_19F5(P: PSlot13);
procedure Proc13_1A08(A0, A1, A2: Word);
procedure Proc13_1B3E(A0, A1, A2: Word);
procedure Proc13_1C7D(A0, A1, A2, A3: Word);
procedure Proc13_1D05(var Head: PNode13; Data: Pointer);
procedure Proc13_1D55(var Head: PNode13; Data: Pointer);
function Far1D5E(A0: Word): Pointer;
function Far1F0E(A0: Word): Pointer;
procedure Proc13_1DA5(var Head: PNode13; Item: Pointer);
procedure Proc13_1E09(var Head: PNode13; Item: Pointer);
procedure Proc13_1E6D(A0, A1: Word);
procedure Proc13_1FE0(A0, A1: Word);
procedure Proc13_2153(A0, A1: Word);
procedure Proc13_2243(var Head: PNode13; Key: Pointer);
procedure Proc13_233C(var Head: PNode13; Key: Pointer);
procedure Far2336(A0: Pointer; A1: Word);
procedure Far23A4(A0: Pointer; A1: Word);
procedure Far242F(A0: Pointer; A1: Word);
procedure Far2461(A0: Pointer; A1: Word);
procedure Proc13_2435;
procedure Proc13_2479;
procedure Proc13_24BD;
procedure Proc13_2501(var Head: PNode13);
procedure Proc13_2549(var Head: PNode13);
procedure Far2579(A0: Pointer; A1: Word);
procedure Far26A6(A0: Pointer; A1: Word);
procedure Proc13_2591(A0: Word);
procedure Proc13_2698;
procedure Proc13_27A5(A0, A1: Word);
procedure Proc13_2A2B(A0: Word);
procedure Proc13_2BBA;
procedure Proc13_2CE9;
procedure Proc13_32B5(P: Pointer);
procedure Proc13_32DF(P: Pointer);


type
  TSchlussform = class(TForm)
    Bild: TImage;
    Panel1: TPanel;
    Filmplayer: TMediaPlayer;
    Timer1: TTimer;
    MusikPlayer: TMediaPlayer;
    Image1: TImage;
  private
    { shortcut: opaque private storage; name fields as accesses are recovered. }
    UnrecoveredState: array[0..3577] of Byte;
  published
    procedure BildMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure BildMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Timer1Timer(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Panel1Click(Sender: TObject);
  end;

implementation

uses ABRECHNE, DATEN, BAUFEN, DATWIN, GFX, HIGHSCOR, HAUS, GELD, SOUND, SEG24;

{ ADDRESS: MAIN 0x000d0180 }
procedure Proc13_0180;
begin
end;

{ ADDRESS: MAIN 0x000d01b3 }
procedure Proc13_01B3;
begin
end;

{ ADDRESS: MAIN 0x000d01df }
procedure Proc13_01DF;
begin
end;

{ ADDRESS: MAIN 0x000d0201 }
procedure Proc13_0201;
begin
end;

{ ADDRESS: MAIN 0x000d0218 }
procedure Proc13_0218;
begin
end;

{ ADDRESS: MAIN 0x000d023a }
procedure Proc13_023A(A: Word; P: Pointer; N: Word);
var
  i: Word;
begin
  for i := 1 to N do
    Far2A0(P);
end;

procedure Far2A0(A0: Pointer);
begin
end;

{ ADDRESS: MAIN 0x000d0288 }
procedure Proc13_0288;
begin
end;

{ ADDRESS: MAIN 0x000d09a5 }
procedure Proc13_09A5;
begin
end;

{ ADDRESS: MAIN 0x000d0e1a }
procedure Proc13_0E1A(var P: TRec0E1A);
begin
  Far0E39(P.F19C^);
  Far0E48(P.F1A0^);
  Far0E57(P.F194^);
  Far0EDC(P.F198^);
end;

procedure Far0E39(var A0: TThing13E);
begin
end;

procedure Far0E48(var A0: TThing13E);
begin
end;

procedure Far0E57(var A0: TThing13E);
begin
end;

procedure Far0EDC(var A0: TThing13E);
begin
end;

{ ADDRESS: MAIN 0x000d0e68 }
procedure Proc13_0E68;
begin
end;

{ ADDRESS: MAIN 0x000d0f52 }
procedure Proc13_0F52;
begin
end;

{ ADDRESS: MAIN 0x000d1016 }
procedure Proc13_1016;
begin
end;

{ ADDRESS: MAIN 0x000d1340 }
procedure Proc13_1340;
begin
end;

{ ADDRESS: MAIN 0x000d1593 }
procedure Proc13_1593;
begin
end;

procedure Proc13_1613;
begin
end;

procedure Proc13_16E0;
begin
end;

{ ADDRESS: MAIN 0x000d17ad }
procedure Proc13_17AD(P: Pointer);
begin
end;

procedure Proc13_187F;
begin
end;

procedure Proc13_198A(A0, A1, A2, A3, A4: Word; P: Pointer);
begin
  Proc13_17AD(P);
end;

procedure Proc13_199B(A0, A1: Word; P: Pointer);
begin
  Proc13_17AD(P);
end;

{ ADDRESS: MAIN 0x000d19ac }
procedure Proc13_19AC;
begin
end;

{ ADDRESS: MAIN 0x000d19be }
procedure Proc13_19BE;
begin
end;

{ ADDRESS: MAIN 0x000d19d0 }
procedure Proc13_19D0;
begin
end;

{ ADDRESS: MAIN 0x000d19e2 }
procedure Proc13_19E2(P: PSlot13);
begin
  P^ := nil;
end;

{ ADDRESS: MAIN 0x000d19f5 }
procedure Proc13_19F5(P: PSlot13);
begin
  P^ := nil;
end;

{ ADDRESS: MAIN 0x000d1a08 }
procedure Proc13_1A08;
begin
end;

{ ADDRESS: MAIN 0x000d1b3e }
procedure Proc13_1B3E;
begin
end;

{ ADDRESS: MAIN 0x000d1c7d }
procedure Proc13_1C7D;
begin
end;

{ ADDRESS: MAIN 0x000d1d05 }
procedure Proc13_1D05(var Head: PNode13; Data: Pointer);
var
  Node: PNode13;
  Held: PNode13;
begin
  Node := Far1D5E(8);
  Held := Node;
  Node^.Data := Data;
  Held^.Next := Head;
  Head := Node;
end;

{ ADDRESS: MAIN 0x000d1d55 }
procedure Proc13_1D55(var Head: PNode13; Data: Pointer);
var
  Node: PNode13;
  Held: PNode13;
begin
  Node := Far1F0E(8);
  Held := Node;
  Node^.Data := Data;
  Held^.Next := Head;
  Head := Node;
end;

function Far1D5E(A0: Word): Pointer;
begin
  Far1D5E := NIL;
end;

function Far1F0E(A0: Word): Pointer;
begin
  Far1F0E := NIL;
end;

{ ADDRESS: MAIN 0x000d1da5 }
procedure Proc13_1DA5(var Head: PNode13; Item: Pointer);
var
  Current: PNode13;
begin
  if Head = nil then
    Head := Item
  else
  begin
    Current := Head;
    while Current^.Next <> nil do
      Current := Current^.Next;
    Current^.Next := Item;
  end;
end;

{ ADDRESS: MAIN 0x000d1e09 }
procedure Proc13_1E09(var Head: PNode13; Item: Pointer);
var
  Current: PNode13;
begin
  if Head = nil then
    Head := Item
  else
  begin
    Current := Head;
    while Current^.Next <> nil do
      Current := Current^.Next;
    Current^.Next := Item;
  end;
end;

{ ADDRESS: MAIN 0x000d1e6d }
procedure Proc13_1E6D;
begin
end;

{ ADDRESS: MAIN 0x000d1fe0 }
procedure Proc13_1FE0;
begin
end;

{ ADDRESS: MAIN 0x000d2153 }
procedure Proc13_2153;
begin
end;

{ ADDRESS: MAIN 0x000d2243 }
procedure Proc13_2243(var Head: PNode13; Key: Pointer);
var
  Node: PNode13;
  Prev: PNode13;
  Found: Boolean;
begin
  if Head = nil then Exit;
  Node := Head;
  Prev := Head;
  Found := False;
  if Head^.Data = Key then
  begin
    Head := Head^.Next;
    Far2336(Node, 8);
    Found := True;
  end
  else
  begin
    Node := Head^.Next;
    while (Node <> nil) and not Found do
    begin
      if Node^.Data = Key then
        Found := True
      else
      begin
        Prev := Node;
        Node := Node^.Next;
      end;
    end;
    if Found then
    begin
      Prev^.Next := Node^.Next;
      Far23A4(Node, 8);
    end;
  end;
end;

{ ADDRESS: MAIN 0x000d233c }
procedure Proc13_233C(var Head: PNode13; Key: Pointer);
var
  Node: PNode13;
  Prev: PNode13;
  Found: Boolean;
begin
  if Head = nil then Exit;
  Node := Head;
  Prev := Head;
  Found := False;
  if Head^.Data = Key then
  begin
    Head := Head^.Next;
    Far242F(Node, 8);
    Found := True;
  end
  else
  begin
    Node := Head^.Next;
    while (Node <> nil) and not Found do
    begin
      if Node^.Data = Key then
        Found := True
      else
      begin
        Prev := Node;
        Node := Node^.Next;
      end;
    end;
    if Found then
    begin
      Prev^.Next := Node^.Next;
      Far2461(Node, 8);
    end;
  end;
end;

procedure Far2336(A0: Pointer; A1: Word);
begin
end;

procedure Far23A4(A0: Pointer; A1: Word);
begin
end;

procedure Far242F(A0: Pointer; A1: Word);
begin
end;

procedure Far2461(A0: Pointer; A1: Word);
begin
end;

{ ADDRESS: MAIN 0x000d2435 }
procedure Proc13_2435;
begin
end;

{ ADDRESS: MAIN 0x000d2479 }
procedure Proc13_2479;
begin
end;

{ ADDRESS: MAIN 0x000d24bd }
procedure Proc13_24BD;
begin
end;

{ ADDRESS: MAIN 0x000d2501 }
procedure Proc13_2501(var Head: PNode13);
var
  Next: PNode13;
begin
  while Head <> nil do
  begin
    Next := Head^.Next;
    Far2579(Head, 8);
    Head := Next;
  end;
end;

{ ADDRESS: MAIN 0x000d2549 }
procedure Proc13_2549(var Head: PNode13);
var
  Next: PNode13;
begin
  while Head <> nil do
  begin
    Next := Head^.Next;
    Far26A6(Head, 8);
    Head := Next;
  end;
end;

procedure Far2579(A0: Pointer; A1: Word);
begin
end;

procedure Far26A6(A0: Pointer; A1: Word);
begin
end;

{ ADDRESS: MAIN 0x000d2591 }
procedure Proc13_2591;
begin
end;

{$F-}
{ ADDRESS: MAIN 0x000d25fd }
procedure Proc13_25FD;
begin
end;
{$F+}

{ ADDRESS: MAIN 0x000d2698 }
procedure Proc13_2698;
begin
end;

{ ADDRESS: MAIN 0x000d27a5 }
procedure Proc13_27A5;
begin
end;

{ ADDRESS: MAIN 0x000d2a2b }
procedure Proc13_2A2B;
begin
end;

{ ADDRESS: MAIN 0x000d2bba }
procedure Proc13_2BBA;
begin
end;

{ ADDRESS: MAIN 0x000d2ce9 }
procedure Proc13_2CE9;
begin
end;

{$F-}
{ ADDRESS: MAIN 0x000d2d49 }
procedure Proc13_2D49;
begin
end;
{$F+}

{$F-}
{ ADDRESS: MAIN 0x000d2e05 }
procedure Proc13_2E05(P: Pointer);
begin
end;
{$F+}

{$F-}
{ ADDRESS: MAIN 0x000d2ebc }
procedure Proc13_2EBC(P: Pointer);
begin
end;
{$F+}

{$F-}
{ ADDRESS: MAIN 0x000d2f73 }
procedure Proc13_2F73(P: Pointer);
begin
end;
{$F+}

{$F-}
{ ADDRESS: MAIN 0x000d2fe1 }
procedure Proc13_2FE1(P: Pointer);
begin
end;
{$F+}

{$F-}
{ ADDRESS: MAIN 0x000d304f }
procedure Proc13_304F(P: Pointer);
begin
end;
{$F+}

{$F-}
{ ADDRESS: MAIN 0x000d30d0 }
procedure Proc13_30D0(P: Pointer);
begin
end;
{$F+}

{$F-}
{ ADDRESS: MAIN 0x000d313e }
procedure Proc13_313E(P: Pointer);
begin
end;
{$F+}

{$F-}
{ ADDRESS: MAIN 0x000d3244 }
procedure Proc13_3244(P: Pointer);
begin
end;
{$F+}

{ ADDRESS: MAIN 0x000d32b5 }
procedure Proc13_32B5(P: Pointer);
begin
  Proc13_313E(P);
  Proc13_2E05(P);
  Proc13_2EBC(P);
  Proc13_304F(P);
  Proc13_2D49;
end;

{ ADDRESS: MAIN 0x000d32df }
procedure Proc13_32DF(P: Pointer);
begin
  Proc13_3244(P);
  Proc13_2F73(P);
  Proc13_2FE1(P);
  Proc13_30D0(P);
end;

{ ADDRESS: MAIN 0x000d1613 }
procedure TSchlussform.BildMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
end;

{ ADDRESS: MAIN 0x000d16e0 }
procedure TSchlussform.BildMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
end;

{ ADDRESS: MAIN 0x000d187f }
procedure TSchlussform.Timer1Timer(Sender: TObject);
begin
end;

{ ADDRESS: MAIN 0x000d198a }
procedure TSchlussform.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
end;

{ ADDRESS: MAIN 0x000d199b }
procedure TSchlussform.Panel1Click(Sender: TObject);
begin
end;
procedure CallersInit13;
var
  Slot13: PNode13;
  Item13: Pointer;
  Head13: PNode13;
  Ptr13: PSlot13;
  Box13E: TRec0E1A;
begin
  Slot13 := nil;
  Item13 := nil;
  Proc13_1DA5(Slot13, Item13);
  Proc13_1E09(Slot13, Item13);
  Head13 := nil;
  Ptr13 := @Head13;
  Proc13_19E2(Ptr13);
  Proc13_19F5(Ptr13);
  Proc13_1D05(Slot13, Item13);
  Proc13_1D55(Slot13, Item13);
  Proc13_2501(Slot13);
  Proc13_2549(Slot13);
  Proc13_2243(Slot13, Item13);
  Proc13_233C(Slot13, Item13);
  Proc13_023A(0, Item13, 1);
  Proc13_32B5(Item13);
  Proc13_32DF(Item13);
  Proc13_199B(0, 0, Item13);
  Proc13_198A(0, 0, 0, 0, 0, Item13);
  Proc13_0E1A(Box13E);
end;

begin
  CallersInit13;
end.
