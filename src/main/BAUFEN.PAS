unit BAUFEN;
{ Reconstructed scaffold, holiday.exe code segment 3 (16053 bytes).
  This is form unit for TBaumenue; the original kept its forms inside the segment's own  unit
  (docs/tree.md).
  Evidence: form TBaumenue, 1 components.
  `uses` comes from this segment's relocation records, the class members
  from RTTI and form streams. Known close-handler bodies are recovered;
  other method bodies remain stubs. }
{$F+}
interface

uses MPlayer, ExtCtrls, Graphics, Controls, Forms, Classes, SysUtils;

type
  { shortcut: byte-index view; table bounds remain to be recovered from callers. }
  TKeyTable3 = array[0..255] of Byte;
  PKeyTable3 = ^TKeyTable3;
procedure Proc3_015F(A0, A1, A2, A3, A4: Word);
procedure Proc3_0208(A0, A1, A2, A3, A4, A5, A6, A7: Word);
procedure Proc3_0461(A0, A1, A2, A3, A4, A5, A6: Word);
procedure Proc3_04E7(A0, A1, A2, A3, A4, A5, A6, A7: Word);
procedure Proc3_080F(A0, A1: Word);
procedure Proc3_0E4D(A0, A1: Word);
procedure Proc3_10A9(A0, A1: Word);
procedure Proc3_11CE(A0, A1, A2: Word);
procedure Proc3_1374(A0, A1: Word);
procedure Proc3_1468(A0, A1, A2, A3, A4, A5: Word);
procedure Proc3_1502(A0, A1, A2, A3, A4, A5, A6: Word);
procedure Proc3_15E1(A0, A1, A2, A3, A4: Word);
procedure Proc3_16C8(A0, A1: Word);
procedure Proc3_1917(A0, A1, A2, A3, A4, A5: Word);
procedure Proc3_1A43(A0, A1: Word);
procedure Proc3_1B5E(A0, A1: Word);
procedure Proc3_1CFF(A0, A1: Word);
procedure Proc3_1D12(A0, A1: Word);
procedure Proc3_1D23(A0, A1: Word);
procedure Proc3_1D50(A0, A1: Word);
procedure Proc3_1D7D(A0, A1: Word);
procedure Proc3_1E6D(A0, A1: Word);
procedure Proc3_1F61(A0, A1: Word);
procedure Proc3_2069(A0, A1: Word);
procedure Proc3_2171(A0, A1: Word);
procedure Proc3_2265(A0, A1: Word);
procedure Proc3_2278(A0, A1: Word);
procedure Proc3_236C(A0, A1: Word);
procedure Proc3_237F(A0, A1, A2: Word);
procedure Proc3_23F8(A0, A1, A2: Word);
procedure Proc3_26B9(A0: Word; var A1);
procedure Proc3_29F7(A0, A1: Word);
procedure Proc3_2A17(A0, A1: Word);
procedure Proc3_2B01(A0, A1: Word);
procedure Proc3_2C71(A0, A1: Word);
procedure Proc3_2D12(A0, A1, A2, A3: Word);
procedure Proc3_2FA2(A0, A1: Word);
procedure Proc3_3175(A0, A1, A2, A3: Word);
procedure Proc3_3203(A0, A1: Word);
procedure Proc3_3290(A0, A1, A2, A3, A4, A5, A6: Word);
procedure Proc3_3350(A0, A1, A2, A3: Word);
procedure Proc3_34A0(A0, A1, A2, A3: Word);
procedure Proc3_35F0(A0, A1: Word);
procedure Proc3_367E;
procedure Proc3_37DE;
procedure Proc3_3814;
procedure Proc3_3850;
procedure Proc3_38C5;
procedure Proc3_38F6(A0, A1: Word);
procedure Proc3_38FD(A0, A1: Word);
procedure Proc3_3904;
procedure Proc3_394E;
procedure Proc3_399A;
procedure Proc3_39B3;
procedure Proc3_3D8D(var A0);
procedure Proc3_3DAD(var A0);
procedure Proc3_3DD6(A0, A1: Word);
procedure Proc3_3E46(A0, A1: Word);


type
  TBaumenue = class(TForm)
    Baumenuebild: TImage;
  private
    { Descriptive name for the native 3:2C71 receiver helper. }
    procedure M2C71;
  private
    { shortcut: opaque private storage; name fields as accesses are recovered. }
    UnrecoveredState: array[0..126] of Byte;
  published
    procedure BaumenuebildMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure BaumenuebildMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure BaumenuebildMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  end;

implementation

uses MAP, DataVal, DATEN, DATWIN, GFX, DARSTELL, SOUND;

{ ADDRESS: MAIN 0x0003015f }
procedure Proc3_015F;
begin
end;

procedure Proc3_0208;
begin
end;

procedure Proc3_0461;
begin
end;

procedure Proc3_04E7;
begin
end;

{ ADDRESS: MAIN 0x0003080f }
procedure Proc3_080F;
begin
end;

{$F-}
{ ADDRESS: MAIN 0x00030b9a }
procedure Proc3_0B9A;
begin
end;
{$F+}

{ ADDRESS: MAIN 0x00030e4d }
procedure Proc3_0E4D;
begin
end;

{ ADDRESS: MAIN 0x000310a9 }
procedure Proc3_10A9;
begin
end;

{ ADDRESS: MAIN 0x000311ce }
procedure Proc3_11CE;
begin
end;

{ ADDRESS: MAIN 0x00031374 }
procedure Proc3_1374;
begin
end;

{ ADDRESS: MAIN 0x00031468 }
procedure Proc3_1468;
begin
end;

{ ADDRESS: MAIN 0x00031502 }
procedure Proc3_1502;
begin
end;

{ ADDRESS: MAIN 0x000315e1 }
procedure Proc3_15E1;
begin
end;

{ ADDRESS: MAIN 0x000316c8 }
procedure Proc3_16C8;
begin
end;

{ ADDRESS: MAIN 0x00031917 }
procedure Proc3_1917;
begin
end;

{ ADDRESS: MAIN 0x00031a43 }
procedure Proc3_1A43;
begin
end;

{ ADDRESS: MAIN 0x00031b5e }
procedure Proc3_1B5E;
begin
end;

{ ADDRESS: MAIN 0x00031cff }
procedure Proc3_1CFF;
begin
end;

{ ADDRESS: MAIN 0x00031d12 }
procedure Proc3_1D12;
begin
end;

{ ADDRESS: MAIN 0x00031d23 }
procedure Proc3_1D23;
begin
end;

{ ADDRESS: MAIN 0x00031d50 }
procedure Proc3_1D50;
begin
end;

{ ADDRESS: MAIN 0x00031d7d }
procedure Proc3_1D7D;
begin
end;

{ ADDRESS: MAIN 0x00031e6d }
procedure Proc3_1E6D;
begin
end;

{ ADDRESS: MAIN 0x00031f61 }
procedure Proc3_1F61;
begin
end;

{ ADDRESS: MAIN 0x00032069 }
procedure Proc3_2069;
begin
end;

{ ADDRESS: MAIN 0x00032171 }
procedure Proc3_2171;
begin
end;

{ ADDRESS: MAIN 0x00032265 }
procedure Proc3_2265;
begin
end;

{ ADDRESS: MAIN 0x00032278 }
procedure Proc3_2278;
begin
end;

{ ADDRESS: MAIN 0x0003236c }
procedure Proc3_236C;
begin
end;

{ ADDRESS: MAIN 0x0003237f }
procedure Proc3_237F;
begin
end;

{ ADDRESS: MAIN 0x000323f8 }
procedure Proc3_23F8;
begin
end;

{ ADDRESS: MAIN 0x000326b9 }
procedure Proc3_26B9(A0: Word; var A1);
begin
end;

{ ADDRESS: MAIN 0x000329f7 }
procedure Proc3_29F7;
begin
end;

{ ADDRESS: MAIN 0x00032a17 }
procedure Proc3_2A17;
begin
end;

{ ADDRESS: MAIN 0x00032b01 }
procedure Proc3_2B01;
begin
end;

{ ADDRESS: MAIN 0x00032c71 }
procedure Proc3_2C71;
begin
end;

procedure Proc3_2D12;
begin
end;

{ ADDRESS: MAIN 0x00032fa2 }
procedure Proc3_2FA2;
begin
end;

procedure Proc3_3175;
begin
end;

{ ADDRESS: MAIN 0x00033203 }
procedure Proc3_3203;
begin
end;

procedure Proc3_3290;
begin
end;

{ ADDRESS: MAIN 0x00033350 }
procedure Proc3_3350;
begin
end;

{ ADDRESS: MAIN 0x000334a0 }
procedure Proc3_34A0;
begin
end;

{ ADDRESS: MAIN 0x000335f0 }
procedure Proc3_35F0;
begin
end;

{ ADDRESS: MAIN 0x0003367e }
procedure Proc3_367E;
begin
end;

{ ADDRESS: MAIN 0x000337de }
procedure Proc3_37DE;
begin
end;

{ ADDRESS: MAIN 0x00033814 }
procedure Proc3_3814;
begin
end;

{ ADDRESS: MAIN 0x00033850 }
procedure Proc3_3850;
begin
end;

{ ADDRESS: MAIN 0x000338c5 }
procedure Proc3_38C5;
begin
end;

{ ADDRESS: MAIN 0x000338f6 }
procedure Proc3_38F6;
begin
end;

{ ADDRESS: MAIN 0x000338fd }
procedure Proc3_38FD;
begin
end;

{ ADDRESS: MAIN 0x00033904 }
procedure Proc3_3904;
begin
end;

{ ADDRESS: MAIN 0x0003394e }
procedure Proc3_394E;
begin
end;

{ ADDRESS: MAIN 0x0003399a }
procedure Proc3_399A;
begin
end;

{ ADDRESS: MAIN 0x000339b3 }
procedure Proc3_39B3;
begin
end;

{$F-}
{ ADDRESS: MAIN 0x000339c2 }
procedure Proc3_39C2;
begin
end;
{$F+}

{ ADDRESS: MAIN 0x00033d8d }
procedure Proc3_3D8D(var A0);
begin
end;

{ ADDRESS: MAIN 0x00033dad }
procedure Proc3_3DAD(var A0);
begin
end;

{ ADDRESS: MAIN 0x00033dd6 }
procedure Proc3_3DD6;
begin
end;

{ ADDRESS: MAIN 0x00033e46 }
procedure Proc3_3E46;
begin
end;

{ ADDRESS: MAIN 0x00030208 }
procedure TBaumenue.BaumenuebildMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
end;

{ ADDRESS: MAIN 0x00030461 }
procedure TBaumenue.BaumenuebildMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
end;

{ ADDRESS: MAIN 0x000304e7 }
procedure TBaumenue.BaumenuebildMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
end;

{ ADDRESS: MAIN 0x00033290 }
procedure TBaumenue.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  case Key of
    $70..$7B, $31..$39, $13:
      DATWIN.Proc4_2E09(Pointer(Sender), @Key, Shift, @MAP.P6532^);
    $27: begin
      MAP.B5FBE := PKeyTable3(@DataVal.Data1400[$D1])^[UnrecoveredState[$2C]];
      DATEN.Proc2_2C8B;
    end;
    $25: begin
      MAP.B5FBE := PKeyTable3(@DataVal.Data1400[$C5])^[UnrecoveredState[$2C]];
      DATEN.Proc2_2C8B;
    end;
    $1B: begin
      DATEN.Proc2_2BC4(UnrecoveredState[$2D]);
      M2C71;
    end;
    $0D: M2C71;
    $20: TControl(MAP.P6532).BringToFront;
  end;
end;

{ ADDRESS: MAIN 0x00032d12 }
procedure TBaumenue.FormCreate;
begin
end;

{ ADDRESS: MAIN 0x00033175 }
procedure TBaumenue.FormDestroy;
begin
end;

procedure TBaumenue.M2C71;
begin
  SOUND.Proc20_30B6($E);
  Height := 0;
  UnrecoveredState[$7E] := 0;
  TControl(MAP.P6532).BringToFront;
end;
end.
