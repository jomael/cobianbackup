object form_Main: Tform_Main
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  ClientHeight = 362
  ClientWidth = 494
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Verdana'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 120
  TextHeight = 16
  object re_Memo: TTntRichEdit
    Left = 0
    Top = 0
    Width = 494
    Height = 297
    Align = alTop
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object cb_DeleteAll: TTntCheckBox
    Left = 56
    Top = 307
    Width = 393
    Height = 17
    Caption = 'Delete all my settings and lists'
    TabOrder = 1
  end
  object b_OK: TTntButton
    Left = 116
    Top = 332
    Width = 110
    Height = 25
    Caption = '&OK'
    Default = True
    TabOrder = 2
    OnClick = b_OKClick
  end
  object b_Cancel: TTntButton
    Left = 268
    Top = 332
    Width = 110
    Height = 25
    Cancel = True
    Caption = '&Cancel'
    TabOrder = 3
    OnClick = b_CancelClick
  end
end
