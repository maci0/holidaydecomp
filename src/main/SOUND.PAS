unit SOUND;
{ Reconstructed scaffold, holiday.exe code segment 20 (12626 bytes).
  This is unit; the original kept its forms inside the segment's own  unit (docs/tree.md).
  Evidence: wav bank (butt*.wav, brandung.wav and more).
  `uses` comes from this segment's relocation records, the class members
  from RTTI and form streams. Recovered free bodies are listed in the
  implementation; the other bodies are not recovered. }
{$F+}
interface

uses SysUtils, MMSystem;

type
  TRec20Slot = packed record
    Kind: Byte;
    W1, W3, W5: Word;
    Used: Byte;
  end;
  TRec20Arr = array[1..3] of TRec20Slot;
  PRec20Arr = ^TRec20Arr;
  TFar4_20 = packed record
    Lo: Word;
    Hi: Word;
  end;
  TCell21 = packed record
    F0, F1, F2, F3, F4, F5, F6: Byte;
  end;
  TCellArr21 = array[0..0] of TCell21;
  PCell21 = ^TCellArr21;
  TMap21 = packed record
    W0, W1, W2, W3, W4: Word;
    W5: Word;
    W6, W7, W8, W9: Word;
  end;
  TMapArr21 = array[0..0] of TMap21;
  PMap21 = ^TMapArr21;
  TWaveState20 = packed record
    Pad: array[0..243] of Byte;
    MixSession: Word;
    Active: Boolean;
    Pad733D: Byte;
    StereoVolume: LongInt;
  end;
  PWaveState20 = ^TWaveState20;
function Equal20(A, B: TFar4_20): Boolean;
function EqualPair20(A, B, C, D: Word): Boolean;
procedure CallSound20;
procedure Empty20A;
procedure Empty20B;
procedure Proc20_02AD(A0: Byte; A1, A2: Word);
procedure Proc20_0346(A0, A1: Word);
procedure Proc20_03CA(A0, A1, A2: Word);
procedure Proc20_0691(A0, A1: Word);
procedure Proc20_074D(A0, A1: Word);
procedure Far185D(A0, A1, A2, A3, A4, A5, A6: Word);
procedure Far2DF2(A0: Word);
procedure Proc20_0915;
procedure Proc20_09EA(A0: Word);
procedure Proc20_0B49;
procedure Far1E7(A0, A1, A2: Word);
procedure Far1419(A0: ShortInt; A1, A2: Word; var A3);
procedure Far2617(var A0);
procedure Proc20_0CCE;
procedure Proc20_0D09;
procedure Proc20_0D1C;
procedure Proc20_0DDC;
procedure Proc20_0E17(A0, A1: Word);
procedure Proc20_0EC8(A0, A1, A2: Word);
procedure Proc20_0F6C;
procedure Far19C(A0, A1, A2: Word);
procedure Proc20_0FEC;
procedure Proc20_117E;
procedure Proc20_1F65(A0, A1, A2, A3: Word);
procedure Proc20_232F(A0, A1: Word);
procedure Proc20_23C9(A0, A1: Word);
procedure Proc20_2453(A0: LongInt);
procedure Proc20_24BC(A0, A1: Word);
procedure Proc20_2518;
procedure Proc20_254F;
procedure Proc20_2577;
procedure Proc20_2F5E;
procedure Proc20_30B6(A0: Word);
procedure Proc20_3145(A0, A1: Word);
procedure Proc20_314C(A0, A1: Word);
procedure ResetGlobals20;
procedure SoundTarget20(A, B, C: Word);
var
  W3DCE: Word;
  Pad3DD0: array[0..82] of Byte;
  B3E23: Byte;
  Pad3E24: array[0..110] of Byte;

implementation

uses THINTERG, TDUMMYFO, ABRECHNE, DATEN, BAUFEN, DATWIN, GFX, HAUS, DARSTELL, SCHLUSS, GELD,
  SEG15, ANIM, BAUEN, UEBERMAP, MAP, DataVal;

{ Native import is WAVEMIX#4; the function name is descriptive. }
function WaveMixActivate(Session, Active: Word): Word; far;
  external 'WAVEMIX' index 4;

function Equal20(A, B: TFar4_20): Boolean;
begin
  Equal20 := (A.Lo = B.Lo) and (A.Hi = B.Hi);
end;

function EqualPair20(A, B, C, D: Word): Boolean;
begin
  EqualPair20 := (A = B) and (C = D);
end;

procedure CallSound20;
begin
  SoundTarget20($32, 0, 0);
end;

procedure Empty20A;
begin
end;

procedure Empty20B;
begin
end;

{$F-}
{ ADDRESS: MAIN 0x00140002 }
function Proc20_0002(A0, A1, A2, A3: Word): Boolean;
begin
  Proc20_0002 := (A1 = A3) and (A0 = A2);
end;
{$F+}

{$F-}
{ ADDRESS: MAIN 0x00140026 }
procedure Proc20_0026;
begin
end;
{$F+}

{ ADDRESS: MAIN 0x001402ad }
procedure Proc20_02AD(A0: Byte; A1, A2: Word);
label Loop, Body, Next, Done;
var
  I: Integer;
  Flag: Byte;
  P705E: PRec20Arr absolute G705E;
begin
  I := 1;
  Flag := 0;
Loop:
  if I > 3 then goto Done;
  if Flag <> 0 then goto Done;
  with P705E^[I] do
  begin
    if Used <> 0 then goto Next;
    Flag := 1;
    W1 := A1;
    W3 := A2;
    Used := 1;
    case A0 of
      $6F:
      begin
        Kind := 0;
        W5 := $3C;
      end;
      $71, $72, $73, $74:
      begin
        Kind := 1;
        W5 := $3C;
      end;
      $79, $7A:
      begin
        Kind := 2;
        W5 := $1E;
      end;
    end;
  end;
Next:
  Inc(I);
  goto Loop;
Done:
end;

{ ADDRESS: MAIN 0x00140346 }
procedure Proc20_0346;
begin
end;

{ ADDRESS: MAIN 0x001403ca }
procedure Proc20_03CA;
begin
end;

{ ADDRESS: MAIN 0x00140691 }
procedure Proc20_0691;
begin
end;

{ ADDRESS: MAIN 0x0014074d }
procedure Proc20_074D;
begin
end;

procedure Far185D(A0, A1, A2, A3, A4, A5, A6: Word);
begin
end;

procedure Far2DF2(A0: Word);
begin
end;

{ ADDRESS: MAIN 0x00140915 }
procedure Proc20_0915;
label Back, Body, Call2, Tail, Done;
var
  I, N: Word;
begin
  Far185D(G7056, G7058, 0, $32, 0, $1E, 1);
  if G7054 <> 0 then
  begin
    Far1E7(G7052, G7050, 1);
    Far1419($6A, G7052, G7050, G6F04^);
    Far2617(G6F04^);
  end;
  N := HighMark17;
  if $2F > N then goto Done;
  I := $2F;
  goto Body;
Back:
  Inc(I);
Body:
  if Slots^[I].Pad[19] = $2B then goto Call2;
  if Slots^[I].Pad[19] = $2C then goto Call2;
  if Slots^[I].Pad[19] <> $2D then goto Tail;
Call2:
  Far2DF2(I);
  MapTile1^[Slots^[I].W0, Slots^[I].W1] := $FF;
Tail:
  if I <> N then goto Back;
Done:
end;

{ ADDRESS: MAIN 0x001409ea }
procedure Proc20_09EA;
begin
end;

{ ADDRESS: MAIN 0x00140b49 }
procedure Proc20_0B49;
begin
end;

procedure Far1E7(A0, A1, A2: Word);
begin
end;

procedure Far1419(A0: ShortInt; A1, A2: Word; var A3);
begin
end;

procedure Far2617(var A0);
begin
end;

{ ADDRESS: MAIN 0x00140cce }
procedure Proc20_0CCE;
begin
  if G7054 <> 0 then
  begin
    Far1E7(G7052, G7050, 1);
    Far1419($6A, G7052, G7050, G6F04^);
    Far2617(G6F04^);
  end;
end;

{ ADDRESS: MAIN 0x00140d09 }
procedure Proc20_0D09;
begin
end;

{ ADDRESS: MAIN 0x00140d1c }
procedure Proc20_0D1C;
begin
end;

{ ADDRESS: MAIN 0x00140ddc }
procedure Proc20_0DDC;
begin
  if G7054 <> 0 then
  begin
    Far1E7(G7052, G7050, 1);
    Far1419($6A, G7052, G7050, G6F04^);
    Far2617(G6F04^);
  end;
end;

{ ADDRESS: MAIN 0x00140e17 }
procedure Proc20_0E17;
begin
end;

{ ADDRESS: MAIN 0x00140ec8 }
procedure Proc20_0EC8;
begin
end;

{ ADDRESS: MAIN 0x00140f6c }
procedure Proc20_0F6C;
begin
end;

procedure Far19C(A0, A1, A2: Word);
begin
end;

{ ADDRESS: MAIN 0x00140fec }
procedure Proc20_0FEC;
begin
  Far19C(G705C, G705A, $32);
end;

{$F-}
{ ADDRESS: MAIN 0x00141000 }
procedure Proc20_1000;
begin
end;
{$F+}

{$F-}
{ ADDRESS: MAIN 0x001410c6 }
procedure Proc20_10C6;
begin
end;
{$F+}

{ ADDRESS: MAIN 0x0014117e }
procedure Proc20_117E;
begin
end;

{$F-}
{ ADDRESS: MAIN 0x001419d2 }
procedure Proc20_19D2;
begin
end;
{$F+}

{$F-}
{ ADDRESS: MAIN 0x00141b31 }
procedure Proc20_1B31;
begin
end;
{$F+}

{$F-}
{ ADDRESS: MAIN 0x00141d5e }
procedure Proc20_1D5E;
begin
end;
{$F+}

{ ADDRESS: MAIN 0x00141f65 }
procedure Proc20_1F65;
begin
end;

{ ADDRESS: MAIN 0x0014232f }
procedure Proc20_232F;
begin
end;

{ ADDRESS: MAIN 0x001423c9 }
procedure Proc20_23C9;
begin
end;

{ ADDRESS: MAIN 0x00142453 }
procedure Proc20_2453;
var R: Word;
begin
  if DataVal.Pair0060[2] <> 0 then
  begin
    MAP.P6334 := A0;
    PWaveState20(@MAP.TileAnchorB)^.StereoVolume :=
      MAP.P6334 * $28F + (MAP.P6334 * $28F) * $10000;
    R := waveOutSetVolume(0, PWaveState20(@MAP.TileAnchorB)^.StereoVolume);
  end;
end;

{ ADDRESS: MAIN 0x001424bc }
procedure Proc20_24BC;
begin
end;

{ ADDRESS: MAIN 0x00142518 }
procedure Proc20_2518;
begin
end;

{ ADDRESS: MAIN 0x0014254f }
procedure Proc20_254F;
begin
  if (DataVal.Pair0060[2] <> 0) and not PWaveState20(@MAP.TileAnchorB)^.Active then
    PWaveState20(@MAP.TileAnchorB)^.Active :=
      WaveMixActivate(PWaveState20(@MAP.TileAnchorB)^.MixSession, 1) = 0;
end;

{ ADDRESS: MAIN 0x00142577 }
procedure Proc20_2577;
begin
end;

{$F-}
{ ADDRESS: MAIN 0x00142824 }
procedure Proc20_2824;
begin
end;
{$F+}

{ ADDRESS: MAIN 0x00142f5e }
procedure Proc20_2F5E;
begin
end;

{ ADDRESS: MAIN 0x001430b6 }
procedure Proc20_30B6;
begin
end;

{ ADDRESS: MAIN 0x00143145 }
procedure Proc20_3145;
begin
end;

{ ADDRESS: MAIN 0x0014314c }
procedure Proc20_314C;
begin
end;

procedure ResetGlobals20;
begin
  G7050 := 0;
  G7052 := 0;
  G7054 := G7055;
end;

procedure SoundTarget20(A, B, C: Word);
begin
end;
procedure CallersInit20;
const
  PairA20: TFar4_20 = (Lo: 1; Hi: 2);
  PairB20: TFar4_20 = (Lo: 1; Hi: 2);
begin
  CallSound20;
  if Equal20(PairA20, PairB20) then CallSound20;
  if EqualPair20(1, 1, 2, 2) then CallSound20;
  Proc20_0D09;
  Proc20_0CCE;
  Proc20_0DDC;
  Proc20_0FEC;
  Proc20_0915;
  Proc20_02AD(0, 1, 2);
  if Proc20_0002(1, 2, 1, 2) then CallSound20;
end;

begin
  CallersInit20;
end.
