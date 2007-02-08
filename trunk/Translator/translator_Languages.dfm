object form_Languages: Tform_Languages
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Languages'
  ClientHeight = 133
  ClientWidth = 384
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
  PixelsPerInch = 120
  TextHeight = 16
  object l_New: TTntLabel
    Left = 8
    Top = 8
    Width = 152
    Height = 16
    Caption = 'Enter a language name'
  end
  object l_Old: TTntLabel
    Left = 8
    Top = 57
    Width = 182
    Height = 16
    Caption = 'Select an existing language'
  end
  object e_New: TTntEdit
    Left = 8
    Top = 25
    Width = 368
    Height = 24
    Hint = 'Enter the name of the language you want to create'
    TabOrder = 0
  end
  object cb_Old: TTntComboBox
    Left = 8
    Top = 72
    Width = 368
    Height = 24
    Hint = 'Select an existing language'
    Style = csDropDownList
    ItemHeight = 16
    TabOrder = 1
  end
  object b_OK: TTntButton
    Left = 61
    Top = 103
    Width = 110
    Height = 25
    Caption = '&OK'
    Default = True
    TabOrder = 2
    OnClick = b_OKClick
  end
  object b_Cancel: TTntButton
    Left = 213
    Top = 103
    Width = 110
    Height = 25
    Cancel = True
    Caption = '&Cancel'
    TabOrder = 3
    OnClick = b_CancelClick
  end
end
