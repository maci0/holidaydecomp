object Dateimenue: TDateimenue
  Left = 305
  Top = 139
  BorderStyle = bsNone
  Caption = 'Dateimenue'
  ClientHeight = 200
  ClientWidth = 297
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
  object Dateimenuebild: TImage
    Left = 0
    Top = 0
    Width = 297
    Height = 200
    OnMouseDown = DateimenuebildMouseDown
    OnMouseMove = DateimenuebildMouseMove
    OnMouseUp = DateimenuebildMouseUp
  end

end
