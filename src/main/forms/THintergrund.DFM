object Hintergrund: THintergrund
  Left = 415
  Top = 98
  Cursor = crNoDrop
  BorderStyle = bsNone
  Caption = 'Holiday Island'
  ClientHeight = 286
  ClientWidth = 379
  Color = clBlack
  Font.Color = clWindowText
  Font.Height = -7
  Font.Name = 'System'
  Font.Style = []
  PixelsPerInch = 96
  Visible = True
  WindowState = wsMaximized
  OnActivate = FormActivate
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  TextHeight = 16
  object backgroundimage: TImage
    Left = 0
    Top = 0
    Width = 135
    Height = 98
    Enabled = False
    Visible = False
    OnClick = backgroundimageClick
  end

  object FilmMediaPlayer: TMediaPlayer
    Left = 5
    Top = 156
    Width = 253
    Height = 20
    Enabled = False
    AutoEnable = False
    Display = FilmPanel
    Visible = False
    TabOrder = 0
  end

  object MusikMediaPlayer: TMediaPlayer
    Left = 6
    Top = 124
    Width = 253
    Height = 20
    AutoEnable = False
    Visible = False
    TabOrder = 1
  end

  object FilmPanel: TPanel
    Left = 56
    Top = 28
    Width = 281
    Height = 221
    BevelOuter = bvNone
    Color = clBlack
    TabOrder = 2
    Visible = False
    OnClick = FilmPanelClick
  end

  object Timer1: TTimer
    Enabled = False
    Interval = 2000
    OnTimer = Timer1Timer
    Left = 12
    Top = 192
  end

end
