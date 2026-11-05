object Geldmenuform: TGeldmenuform
  Left = 200
  Top = 96
  BorderStyle = bsNone
  Caption = 'Geldmenuform'
  ClientHeight = 273
  ClientWidth = 427
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  PixelsPerInch = 96
  OnKeyDown = FormKeyDown
  TextHeight = 16
  object UeberschriftImage: TImage
    Left = 12
    Top = 4
    Width = 409
    Height = 21
    OnMouseDown = UeberschriftImageMouseDown
    OnMouseMove = UeberschriftImageMouseMove
    OnMouseUp = UeberschriftImageMouseUp
  end

  object BildImage: TImage
    Left = 12
    Top = 36
    Width = 409
    Height = 189
    OnMouseDown = BildImageMouseDown
    OnMouseUp = BildImageMouseUp
  end

  object MenuImage: TImage
    Left = 8
    Top = 240
    Width = 413
    Height = 25
    OnMouseDown = MenuImageMouseDown
    OnMouseMove = MenuImageMouseMove
    OnMouseUp = MenuImageMouseUp
  end

end
