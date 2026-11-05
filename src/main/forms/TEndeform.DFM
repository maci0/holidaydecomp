object Endeform: TEndeform
  Left = 200
  Top = 96
  BorderStyle = bsNone
  Caption = 'Endeform'
  ClientHeight = 273
  ClientWidth = 427
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  FormStyle = fsStayOnTop
  PixelsPerInch = 96
  OnHide = FormHide
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  TextHeight = 16
  object EndeImage: TImage
    Left = 72
    Top = 48
    Width = 261
    Height = 125
    OnMouseDown = EndeImageMouseDown
    OnMouseMove = EndeImageMouseMove
    OnMouseUp = EndeImageMouseUp
  end

end
