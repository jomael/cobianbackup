object form_Serial: Tform_Serial
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Enter your serial number'
  ClientHeight = 187
  ClientWidth = 394
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  ShowHint = True
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 120
  TextHeight = 16
  object l_Serial: TTntLabel
    Left = 8
    Top = 110
    Width = 89
    Height = 16
    Caption = 'Serial number'
  end
  object l_Name: TTntLabel
    Left = 8
    Top = 6
    Width = 42
    Height = 16
    Caption = 'Name:'
  end
  object l_Organization: TTntLabel
    Left = 8
    Top = 58
    Width = 82
    Height = 16
    Caption = 'Organization'
  end
  object e_Serial: TTntEdit
    Left = 8
    Top = 128
    Width = 379
    Height = 24
    TabOrder = 2
  end
  object b_OK: TTntButton
    Left = 75
    Top = 157
    Width = 100
    Height = 25
    Caption = '&OK'
    Default = True
    TabOrder = 3
    OnClick = b_OKClick
  end
  object b_Cancel: TTntButton
    Left = 219
    Top = 157
    Width = 100
    Height = 25
    Caption = '&Cancel'
    TabOrder = 4
    OnClick = b_CancelClick
  end
  object e_Name: TTntEdit
    Left = 7
    Top = 28
    Width = 379
    Height = 24
    TabOrder = 0
  end
  object e_Organization: TTntEdit
    Left = 8
    Top = 80
    Width = 379
    Height = 24
    TabOrder = 1
  end
end
