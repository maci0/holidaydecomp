object Baumenue: TBaumenue
  Left = 263
  Top = 122
  BorderStyle = bsNone
  Caption = 'Baumenue'
  ClientHeight = 190
  ClientWidth = 410
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  PixelsPerInch = 96
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  TextHeight = 16
  object Baumenuebild: TImage
    Left = 0
    Top = 0
    Width = 410
    Height = 190
    OnMouseDown = BaumenuebildMouseDown
    OnMouseMove = BaumenuebildMouseMove
    OnMouseUp = BaumenuebildMouseUp
  end

end
