object Fernseher: TFernseher
  Left = 396
  Top = 46
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'Fernseher'
  ClientHeight = 372
  ClientWidth = 367
  Ctl3D = False
  Color = clBtnFace
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  FormStyle = fsStayOnTop
  PixelsPerInch = 96
  OnHide = FormHide
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  TextHeight = 16
  object tvimage: TImage
    Left = 0
    Top = 0
    Width = 352
    Height = 319
    OnMouseDown = tvimageMouseDown
    OnMouseUp = tvimageMouseUp
  end

  object tvleiimage: TImage
    Left = 216
    Top = 24
    Width = 75
    Height = 20
    OnMouseDown = tvleiimageMouseDown
    OnMouseMove = tvleiimageMouseMove
    OnMouseUp = tvleiimageMouseUp
  end

  object MediaPlayer1: TMediaPlayer
    Left = 312
    Top = 0
    Width = 29
    Height = 29
    VisibleButtons = [btPlay]
    Display = Panel1
    Visible = False
    TabOrder = 0
  end

  object Panel1: TPanel
    Left = 72
    Top = 136
    Width = 125
    Height = 81
    BevelOuter = bvNone
    Caption = ' '
    Color = clBlack
    TabOrder = 1
    Visible = False
  end

  object MediaPlayer2: TMediaPlayer
    Left = 312
    Top = 24
    Width = 29
    Height = 25
    VisibleButtons = [btPlay]
    DeviceType = dtWaveAudio
    Visible = False
    TabOrder = 2
  end

end
