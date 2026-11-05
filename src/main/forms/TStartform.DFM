object Startform: TStartform
  Left = 154
  Top = 33
  BorderStyle = bsNone
  Caption = 'Start'
  ClientHeight = 352
  ClientWidth = 424
  Color = clSilver
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
    Width = 425
    Height = 353
    OnMouseDown = BildMouseDown
    OnMouseMove = BildMouseMove
    OnMouseUp = BildMouseUp
  end

end
