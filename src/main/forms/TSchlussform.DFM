object Schlussform: TSchlussform
  Left = 223
  Top = 74
  BorderStyle = bsNone
  Caption = 'Schlußform'
  ClientHeight = 78
  ClientWidth = 285
  Color = clBlack
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  PixelsPerInch = 96
  OnKeyDown = FormKeyDown
  TextHeight = 16
  object Bild: TImage
    Left = 0
    Top = 0
    Width = 9
    Height = 13
    Visible = False
    OnMouseDown = BildMouseDown
    OnMouseUp = BildMouseUp
  end

  object Image1: TImage
    Left = 83
    Top = 6
    Width = 78
    Height = 8
  end

  object Panel1: TPanel
    Left = 28
    Top = 8
    Width = 21
    Height = 13
    BevelOuter = bvNone
    Caption = 'Panel1'
    Color = clBlack
    TabOrder = 0
    Visible = False
    OnClick = Panel1Click
  end

  object Filmplayer: TMediaPlayer
    Left = 44
    Top = 20
    Width = 253
    Height = 21
    Display = Panel1
    Visible = False
    TabOrder = 1
  end

  object MusikPlayer: TMediaPlayer
    Left = 44
    Top = 40
    Width = 253
    Height = 20
    Visible = False
    TabOrder = 2
  end

  object Timer1: TTimer
    Enabled = False
    OnTimer = Timer1Timer
    Left = 16
    Top = 44
  end

end
