object form_Password: Tform_Password
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  ClientHeight = 106
  ClientWidth = 388
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object l_Password: TTntLabel
    Left = 8
    Top = 6
    Width = 102
    Height = 16
    Caption = 'Enter password'
  end
  object l_FileName: TTntLabel
    Left = 8
    Top = 25
    Width = 62
    Height = 16
    Caption = 'File name'
  end
  object e_Password: TTntEdit
    Left = 8
    Top = 48
    Width = 371
    Height = 24
    PasswordChar = '*'
    TabOrder = 0
  end
  object b_OK: TTntButton
    Left = 48
    Top = 77
    Width = 110
    Height = 25
    Caption = '&OK'
    Default = True
    TabOrder = 1
    OnClick = b_OKClick
  end
  object b_Cancel: TTntButton
    Left = 231
    Top = 77
    Width = 110
    Height = 25
    Cancel = True
    Caption = '&Cancel'
    TabOrder = 2
    OnClick = b_CancelClick
  end
end
