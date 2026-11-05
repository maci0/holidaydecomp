object Optionenform: TOptionenform
  Left = 68
  Top = 109
  BorderStyle = bsNone
  Caption = 'Optionen'
  ClientHeight = 261
  ClientWidth = 407
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  FormStyle = fsStayOnTop
  PixelsPerInch = 96
  OnClose = FormClose
  OnHide = FormHide
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  TextHeight = 16
  object bild: TImage
    Left = 0
    Top = 0
    Width = 353
    Height = 233
    OnMouseDown = bildMouseDown
    OnMouseMove = bildMouseMove
    OnMouseUp = bildMouseUp
  end

end
