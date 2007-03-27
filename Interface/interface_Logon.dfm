object form_Logon: Tform_Logon
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  ClientHeight = 233
  ClientWidth = 387
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
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object l_Logon: TTntLabel
    Left = 8
    Top = 8
    Width = 39
    Height = 16
    Caption = 'Logon'
  end
  object l_Warning: TTntLabel
    Left = 31
    Top = 56
    Width = 126
    Height = 16
    Caption = 'No network access'
  end
  object l_ID: TTntLabel
    Left = 31
    Top = 109
    Width = 148
    Height = 16
    Caption = 'Username (Domain\ID)'
  end
  object l_Password: TTntLabel
    Left = 31
    Top = 155
    Width = 62
    Height = 16
    Caption = 'Password'
  end
  object rb_System: TTntRadioButton
    Left = 8
    Top = 36
    Width = 369
    Height = 17
    Caption = 'System'
    TabOrder = 0
    OnClick = rb_SystemClick
  end
  object rb_Account: TTntRadioButton
    Left = 8
    Top = 84
    Width = 369
    Height = 17
    Caption = 'Account'
    TabOrder = 1
    OnClick = rb_AccountClick
  end
  object e_ID: TTntEdit
    Left = 31
    Top = 127
    Width = 346
    Height = 24
    TabOrder = 2
    OnChange = e_IDChange
  end
  object e_Password: TTntEdit
    Left = 31
    Top = 171
    Width = 346
    Height = 24
    PasswordChar = '*'
    TabOrder = 3
  end
  object b_OK: TTntButton
    Left = 49
    Top = 203
    Width = 110
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 4
    OnClick = b_OKClick
  end
  object b_Cancel: TTntButton
    Left = 228
    Top = 203
    Width = 110
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 5
    OnClick = b_CancelClick
  end
end
