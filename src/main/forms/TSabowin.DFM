object Sabowin: TSabowin
  Left = 300
  Top = 167
  BorderStyle = bsNone
  Caption = 'Sabotage'
  ClientHeight = 250
  ClientWidth = 392
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  PixelsPerInch = 96
  OnHide = FormHide
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  TextHeight = 16
  object Saboimage: TImage
    Left = 0
    Top = 0
    Width = 411
    Height = 242
    OnMouseDown = SaboimageMouseDown
    OnMouseMove = SaboimageMouseMove
    OnMouseUp = SaboimageMouseUp
  end

end
