object Pauseform: TPauseform
  Left = 200
  Top = 95
  BorderStyle = bsNone
  Caption = 'Pauseform'
  ClientHeight = 273
  ClientWidth = 427
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'System'
  Font.Style = []
  FormStyle = fsStayOnTop
  PixelsPerInch = 96
  Position = poDefault
  OnClose = FormClose
  OnKeyDown = FormKeyDown
  TextHeight = 16
  object Pausebild: TImage
    Left = 26
    Top = 29
    Width = 362
    Height = 199
    OnClick = PausebildClick
  end

end
