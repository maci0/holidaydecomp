object Infobox2: TInfobox2
  Left = 200
  Top = 99
  BorderStyle = bsNone
  Caption = 'Infobox2'
  ClientHeight = 273
  ClientWidth = 427
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  FormStyle = fsStayOnTop
  PixelsPerInch = 96
  Position = poDefault
  OnKeyDown = FormKeyDown
  TextHeight = 16
  object Infoimage: TImage
    Left = 12
    Top = 12
    Width = 393
    Height = 241
    OnMouseDown = InfoimageMouseDown
    OnMouseUp = InfoimageMouseUp
  end

end
