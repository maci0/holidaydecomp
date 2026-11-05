object Kompassform: TKompassform
  Left = 200
  Top = 102
  BorderStyle = bsNone
  Caption = 'Kompassform'
  ClientHeight = 143
  ClientWidth = 153
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  FormStyle = fsStayOnTop
  PixelsPerInch = 96
  OnKeyDown = FormKeyDown
  TextHeight = 16
  object Bild: TImage
    Left = 20
    Top = 12
    Width = 109
    Height = 109
    OnMouseDown = BildMouseDown
    OnMouseMove = BildMouseMove
    OnMouseUp = BildMouseUp
  end

end
