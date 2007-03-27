object form_MessageBoxEx: Tform_MessageBoxEx
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsDialog
  ClientHeight = 63
  ClientWidth = 488
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
  object l_Prompt: TTntLabel
    Left = 8
    Top = 8
    Width = 76
    Height = 16
    Caption = 'The prompt'
  end
  object b_Yes: TTntButton
    Left = 7
    Top = 35
    Width = 90
    Height = 25
    Caption = 'Yes'
    TabOrder = 0
    OnClick = b_YesClick
  end
  object b_YesToAll: TTntButton
    Left = 103
    Top = 35
    Width = 90
    Height = 25
    Caption = 'Yes to all'
    TabOrder = 1
    OnClick = b_YesToAllClick
  end
  object b_No: TTntButton
    Left = 199
    Top = 35
    Width = 90
    Height = 25
    Caption = 'No'
    TabOrder = 2
    OnClick = b_NoClick
  end
  object b_NoToAll: TTntButton
    Left = 295
    Top = 35
    Width = 90
    Height = 25
    Caption = 'No to all'
    TabOrder = 3
    OnClick = b_NoToAllClick
  end
  object b_Cancel: TTntButton
    Left = 391
    Top = 35
    Width = 90
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    Default = True
    TabOrder = 4
    OnClick = b_CancelClick
  end
end
