object LadenForm: TLadenForm
  Left = 200
  Top = 98
  BorderStyle = bsNone
  Caption = 'LadenForm'
  ClientHeight = 273
  ClientWidth = 427
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  PixelsPerInch = 96
  OnClose = FormClose
  TextHeight = 16
  object Bild: TImage
    Left = 84
    Top = 44
    Width = 277
    Height = 177
    OnMouseDown = BildMouseDown
    OnMouseUp = BildMouseUp
  end

end
