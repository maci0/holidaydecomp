object Auktionsform: TAuktionsform
  Left = 200
  Top = 101
  BorderIcons = []
  BorderStyle = bsNone
  Caption = 'Auktionsform'
  ClientHeight = 273
  ClientWidth = 427
  Enabled = False
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  FormStyle = fsStayOnTop
  PixelsPerInch = 96
  OnKeyDown = FormKeyDown
  TextHeight = 16
  object AuktionsImage: TImage
    Left = 2
    Top = 4
    Width = 66
    Height = 21
  end

  object leiste: TImage
    Left = 201
    Top = 41
    Width = 102
    Height = 12
    OnMouseDown = leisteMouseDown
    OnMouseMove = leisteMouseMove
    OnMouseUp = leisteMouseUp
  end

  object knopfimage: TImage
    Left = 147
    Top = 207
    Width = 118
    Height = 49
    OnMouseDown = knopfimageMouseDown
    OnMouseUp = knopfimageMouseUp
  end

  object Timer1: TTimer
    Enabled = False
    Interval = 3000
    OnTimer = Timer1Timer
    Left = 56
    Top = 52
  end

  object Timer2: TTimer
    Enabled = False
    OnTimer = Timer2Timer
    Left = 91
    Top = 53
  end

  object Timer3: TTimer
    Enabled = False
    Interval = 100
    OnTimer = Timer3Timer
    Left = 128
    Top = 51
  end

end
