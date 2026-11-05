object Creditform: TCreditform
  Left = 200
  Top = 112
  BorderStyle = bsNone
  Caption = 'Creditform'
  ClientHeight = 214
  ClientWidth = 342
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'System'
  Font.Style = []
  FormStyle = fsStayOnTop
  PixelsPerInch = 96
  OnClose = FormClose
  TextHeight = 16
  object Bild: TImage
    Left = 13
    Top = 19
    Width = 308
    Height = 174
    OnMouseDown = BildMouseDown
    OnMouseUp = BildMouseUp
  end

end
