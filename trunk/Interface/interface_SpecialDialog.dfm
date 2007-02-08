object form_SpecialDialog: Tform_SpecialDialog
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  ClientHeight = 97
  ClientWidth = 444
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object l_Prompt: TTntLabel
    Left = 16
    Top = 10
    Width = 41
    Height = 16
    Caption = 'Prompt'
  end
  object cb_Condition: TTntCheckBox
    Left = 16
    Top = 37
    Width = 409
    Height = 17
    Caption = 'Condition'
    TabOrder = 0
  end
  object b_OK: TTntButton
    Left = 86
    Top = 68
    Width = 110
    Height = 25
    Caption = '&OK'
    Default = True
    TabOrder = 1
    OnClick = b_OKClick
  end
  object b_Cancel: TTntButton
    Left = 249
    Top = 68
    Width = 110
    Height = 25
    Cancel = True
    Caption = '&Cancel'
    TabOrder = 2
    OnClick = b_CancelClick
  end
end
