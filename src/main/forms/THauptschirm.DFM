object Hauptschirm: THauptschirm
  Left = 99
  Top = 107
  BorderStyle = bsNone
  Caption = 'Hauptschirm'
  ClientHeight = 345
  ClientWidth = 643
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'System'
  Font.Style = []
  PixelsPerInch = 96
  Scaled = False
  OnClose = FormClose
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  TextHeight = 16
  object NSScrollbild: TImage
    Left = 627
    Top = -13
    Width = 15
    Height = 364
    OnMouseDown = NSScrollbildMouseDown
    OnMouseMove = NSScrollbildMouseMove
    OnMouseUp = NSScrollbildMouseUp
  end

  object Kleinbild: TImage
    Left = 620
    Top = 8
    Width = 21
    Height = 17
    OnMouseDown = KleinbildMouseDown
    OnMouseUp = KleinbildMouseUp
  end

  object CloseBild: TImage
    Left = 4
    Top = 8
    Width = 17
    Height = 21
    OnMouseDown = CloseBildMouseDown
    OnMouseUp = CloseBildMouseUp
  end

  object Hauptbild: TImage
    Left = -5
    Top = 56
    Width = 624
    Height = 404
    OnMouseDown = HauptbildMouseDown
    OnMouseMove = HauptbildMouseMove
    OnMouseUp = HauptbildMouseUp
  end

  object Ueberschriftbild: TImage
    Left = 20
    Top = 0
    Width = 608
    Height = 16
    OnMouseDown = UeberschriftbildMouseDown
    OnMouseMove = UeberschriftbildMouseMove
    OnMouseUp = UeberschriftbildMouseUp
  end

  object ButtonImage: TImage
    Left = -1
    Top = 34
    Width = 640
    Height = 25
    OnClick = ButtonImageClick
    OnMouseMove = ButtonImageMouseMove
  end

  object WOScrollbild: TImage
    Left = 216
    Top = 327
    Width = 367
    Height = 16
    OnMouseDown = WOScrollbildMouseDown
    OnMouseMove = WOScrollbildMouseMove
    OnMouseUp = WOScrollbildMouseUp
  end

  object InfoImage: TImage
    Left = 0
    Top = 18
    Width = 640
    Height = 18
  end

  object Statusimage: TImage
    Left = 1
    Top = 464
    Width = 235
    Height = 16
  end

  object eckimage: TImage
    Left = 626
    Top = 464
    Width = 23
    Height = 16
    OnMouseDown = eckimageMouseDown
  end

  object AnimationsTimer: TTimer
    Enabled = False
    Interval = 100
    OnTimer = AnimationsTimerTimer
    Left = 462
    Top = 52
  end

end
