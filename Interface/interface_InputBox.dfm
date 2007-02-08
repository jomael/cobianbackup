object form_InputBox: Tform_InputBox
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  ClientHeight = 86
  ClientWidth = 394
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
    Left = 10
    Top = 6
    Width = 41
    Height = 16
    Caption = 'Prompt'
  end
  object e_Input: TTntEdit
    Left = 10
    Top = 25
    Width = 375
    Height = 24
    TabOrder = 0
  end
  object b_OK: TTntButton
    Left = 58
    Top = 57
    Width = 110
    Height = 25
    Caption = '&OK'
    Default = True
    TabOrder = 1
    OnClick = b_OKClick
  end
  object b_Cancel: TTntButton
    Left = 226
    Top = 55
    Width = 110
    Height = 25
    Cancel = True
    Caption = '&Cancel'
    TabOrder = 2
    OnClick = b_CancelClick
  end
end
