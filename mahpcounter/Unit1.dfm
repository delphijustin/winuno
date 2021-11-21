object Form1: TForm1
  Left = 201
  Top = 142
  Width = 233
  Height = 140
  Caption = 'Demo THPCounter'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 72
    Width = 72
    Height = 13
    Caption = 'Measured time:'
  end
  object Label2: TLabel
    Left = 176
    Top = 72
    Width = 23
    Height = 13
    Caption = 'µsec'
  end
  object Button1: TButton
    Left = 24
    Top = 24
    Width = 89
    Height = 25
    Caption = 'Start measure'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Edit1: TEdit
    Left = 104
    Top = 64
    Width = 65
    Height = 21
    TabOrder = 1
  end
  object HPCounter1: THPCounter
    Copyright = 'Copyright (c) 2000, MAs Prod. / Mats Asplund'
    Left = 152
    Top = 16
  end
end
