object form_Canceler: Tform_Canceler
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsDialog
  ClientHeight = 72
  ClientWidth = 428
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
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 120
  TextHeight = 16
  object l_Caption: TTntLabel
    Left = 9
    Top = 10
    Width = 400
    Height = 16
    AutoSize = False
    Caption = '...'
  end
  object b_Cancel: TTntButton
    Left = 159
    Top = 42
    Width = 110
    Height = 25
    Cancel = True
    Caption = 'Cancel'
    TabOrder = 0
    OnClick = b_CancelClick
  end
end
