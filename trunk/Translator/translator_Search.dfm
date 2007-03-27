object form_Search: Tform_Search
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  ClientHeight = 82
  ClientWidth = 321
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
  object TntLabel1: TTntLabel
    Left = 8
    Top = 8
    Width = 158
    Height = 16
    Caption = 'Enter a string to search'
  end
  object e_Search: TTntEdit
    Left = 8
    Top = 24
    Width = 305
    Height = 24
    TabOrder = 0
  end
  object b_OK: TTntButton
    Left = 40
    Top = 53
    Width = 110
    Height = 25
    Caption = '&OK'
    Default = True
    TabOrder = 1
    OnClick = b_OKClick
  end
  object b_Cancel: TTntButton
    Left = 171
    Top = 53
    Width = 110
    Height = 25
    Cancel = True
    Caption = '&Cancel'
    TabOrder = 2
    OnClick = b_CancelClick
  end
end
