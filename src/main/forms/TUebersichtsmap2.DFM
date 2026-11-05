object Uebersichtsmap2: TUebersichtsmap2
  Left = 24
  Top = 112
  BorderStyle = bsNone
  Caption = 'Uebersichtsmap2'
  ClientHeight = 273
  ClientWidth = 427
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  PixelsPerInch = 96
  OnKeyDown = FormKeyDown
  TextHeight = 16
  object Ueberschriftbild: TImage
    Left = 8
    Top = 4
    Width = 393
    Height = 13
    OnMouseDown = UeberschriftbildMouseDown
    OnMouseMove = UeberschriftbildMouseMove
    OnMouseUp = UeberschriftbildMouseUp
  end

  object Umschaltbild: TImage
    Left = 412
    Top = 4
    Width = 13
    Height = 13
    OnMouseDown = UmschaltbildMouseDown
    OnMouseUp = UmschaltbildMouseUp
  end

  object NSScrollbild: TImage
    Left = 412
    Top = 24
    Width = 13
    Height = 201
    OnMouseDown = NSScrollbildMouseDown
    OnMouseMove = NSScrollbildMouseMove
    OnMouseUp = NSScrollbildMouseUp
  end

  object Menubild: TImage
    Left = 4
    Top = 232
    Width = 417
    Height = 37
    OnMouseDown = MenubildMouseDown
    OnMouseMove = MenubildMouseMove
    OnMouseUp = MenubildMouseUp
  end

  object MapBild: TImage
    Left = 4
    Top = 24
    Width = 401
    Height = 201
    OnMouseDown = MapBildMouseDown
    OnMouseMove = MapBildMouseMove
    OnMouseUp = MapBildMouseUp
  end

  object NSScrolltimer: TTimer
    Enabled = False
    Interval = 25
    OnTimer = NSScrolltimerTimer
    Left = 396
    Top = 104
  end

  object WOScrolltimer: TTimer
    Enabled = False
    Interval = 25
    OnTimer = WOScrolltimerTimer
    Left = 192
    Top = 220
  end

end
