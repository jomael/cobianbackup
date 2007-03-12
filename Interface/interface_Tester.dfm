object form_Tester: Tform_Tester
  Left = 0
  Top = 0
  ClientHeight = 360
  ClientWidth = 492
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
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object m_Log: TTntRichEdit
    Left = 0
    Top = 0
    Width = 492
    Height = 360
    Align = alClient
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 0
    WordWrap = False
  end
  object FTP: TIdFTP
    OnDisconnected = FTPDisconnected
    AutoLogin = True
    ProxySettings.ProxyType = fpcmNone
    ProxySettings.Port = 0
    OnBannerBeforeLogin = FTPBannerBeforeLogin
    OnBannerAfterLogin = FTPBannerAfterLogin
    OnAfterClientLogin = FTPAfterClientLogin
    Left = 352
    Top = 96
  end
  object AntiFreeze: TIdAntiFreeze
    Left = 360
    Top = 208
  end
  object SSL: TIdSSLIOHandlerSocketOpenSSL
    MaxLineAction = maException
    Port = 0
    DefaultPort = 0
    SSLOptions.Method = sslvSSLv2
    SSLOptions.Mode = sslmUnassigned
    SSLOptions.VerifyMode = []
    SSLOptions.VerifyDepth = 0
    Left = 320
    Top = 152
  end
  object SMTP: TIdSMTP
    SASLMechanisms = <>
    Left = 360
    Top = 272
  end
  object Msg: TIdMessage
    AttachmentEncoding = 'UUE'
    BccList = <>
    CCList = <>
    Encoding = meDefault
    FromList = <
      item
      end>
    Recipients = <>
    ReplyTo = <>
    ConvertPreamble = True
    Left = 408
    Top = 272
  end
end
