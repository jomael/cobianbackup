object form_Main: Tform_Main
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Cobian Version Server'
  ClientHeight = 437
  ClientWidth = 584
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
  PixelsPerInch = 96
  TextHeight = 16
  object p_Left: TPanel
    Left = 0
    Top = 0
    Width = 200
    Height = 396
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 0
    object lb_Applications: TListBox
      Left = 0
      Top = 0
      Width = 200
      Height = 396
      Align = alClient
      ItemHeight = 16
      MultiSelect = True
      PopupMenu = m_Pop
      TabOrder = 0
      OnClick = lb_ApplicationsClick
      OnDblClick = m_EditClick
    end
  end
  object p_Client: TPanel
    Left = 200
    Top = 0
    Width = 384
    Height = 396
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object l_News: TLabel
      Left = 6
      Top = 186
      Width = 35
      Height = 16
      Caption = 'News'
    end
    object l_Manage: TLabel
      Left = 6
      Top = 9
      Width = 302
      Height = 16
      Caption = 'Right click on the list to manage it'#39's items'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object e_Name: TLabeledEdit
      Left = 6
      Top = 53
      Width = 371
      Height = 24
      EditLabel.Width = 172
      EditLabel.Height = 16
      EditLabel.Caption = 'Application name (unique)'
      TabOrder = 0
    end
    object e_CurrentVersion: TLabeledEdit
      Left = 6
      Top = 103
      Width = 371
      Height = 24
      EditLabel.Width = 101
      EditLabel.Height = 16
      EditLabel.Caption = 'Current version'
      TabOrder = 1
    end
    object e_Home: TLabeledEdit
      Left = 6
      Top = 151
      Width = 371
      Height = 24
      EditLabel.Width = 65
      EditLabel.Height = 16
      EditLabel.Caption = 'Home site'
      TabOrder = 2
    end
    object m_News: TMemo
      Left = 6
      Top = 208
      Width = 371
      Height = 183
      ScrollBars = ssBoth
      TabOrder = 3
      WordWrap = False
    end
  end
  object p_Bottom: TPanel
    Left = 0
    Top = 396
    Width = 584
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 2
    object b_OK: TButton
      Left = 136
      Top = 10
      Width = 113
      Height = 25
      Caption = '&OK'
      Default = True
      TabOrder = 0
      OnClick = b_OKClick
    end
    object b_Cancel: TButton
      Left = 336
      Top = 10
      Width = 113
      Height = 25
      Cancel = True
      Caption = '&Cancel'
      TabOrder = 1
      OnClick = b_CancelClick
    end
  end
  object m_Pop: TPopupMenu
    OnPopup = m_PopPopup
    Left = 104
    Top = 256
    object m_Add: TMenuItem
      Caption = '&Add'
      ShortCut = 16449
      OnClick = m_AddClick
    end
    object m_Edit: TMenuItem
      Caption = '&Edit'
      ShortCut = 16453
      OnClick = m_EditClick
    end
    object m_Delete: TMenuItem
      Caption = '&Delete'
      ShortCut = 16452
      OnClick = m_DeleteClick
    end
    object m_Sep: TMenuItem
      Caption = '-'
    end
    object m_Log: TMenuItem
      Caption = '&View log'
      ShortCut = 16460
      OnClick = m_LogClick
    end
    object m_Sep3: TMenuItem
      Caption = '-'
    end
    object m_About: TMenuItem
      Caption = '&About ... '
      OnClick = m_AboutClick
    end
    object m_Sep2: TMenuItem
      Caption = '-'
    end
  end
end
