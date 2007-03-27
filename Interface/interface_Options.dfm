object form_Options: Tform_Options
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Options'
  ClientHeight = 462
  ClientWidth = 594
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  Scaled = False
  ShowHint = True
  OnCreate = TntFormCreate
  OnDestroy = TntFormDestroy
  OnShow = TntFormShow
  PixelsPerInch = 96
  TextHeight = 16
  object p_Bottom: TTntPanel
    Left = 0
    Top = 421
    Width = 594
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object b_OK: TTntButton
      Left = 110
      Top = 9
      Width = 110
      Height = 25
      Caption = '&OK'
      Default = True
      TabOrder = 0
      OnClick = b_OKClick
    end
    object b_Cancel: TTntButton
      Left = 374
      Top = 9
      Width = 110
      Height = 25
      Cancel = True
      Caption = '&Cancel'
      TabOrder = 1
      OnClick = b_CancelClick
    end
  end
  object p_Center: TTntPanel
    Left = 0
    Top = 0
    Width = 594
    Height = 421
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object p_Left: TTntPanel
      Left = 0
      Top = 0
      Width = 150
      Height = 421
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object lb_Options: TTntListBox
        Left = 0
        Top = 0
        Width = 150
        Height = 421
        Style = lbOwnerDrawFixed
        Align = alClient
        ItemHeight = 24
        TabOrder = 0
        OnClick = lb_OptionsClick
        OnDrawItem = lb_OptionsDrawItem
      end
    end
    object pc_Options: TTntPageControl
      Left = 150
      Top = 0
      Width = 444
      Height = 421
      ActivePage = tab_General
      Align = alClient
      MultiLine = True
      Style = tsFlatButtons
      TabOrder = 1
      object tab_General: TTntTabSheet
        TabVisible = False
        object l_Language: TTntLabel
          Left = 3
          Top = 239
          Width = 55
          Height = 16
          Caption = 'Language'
        end
        object l_HotKey: TTntLabel
          Left = 3
          Top = 285
          Width = 42
          Height = 16
          Caption = 'Hot key'
        end
        object l_Temp: TTntLabel
          Left = 3
          Top = 334
          Width = 63
          Height = 16
          Caption = 'Temporary'
        end
        object gb_Autostart: TTntGroupBox
          Left = 3
          Top = 3
          Width = 424
          Height = 83
          Caption = 'Autostart'
          TabOrder = 0
          object l_AutostartApp: TTntLabel
            Left = 9
            Top = 26
            Width = 184
            Height = 16
            Caption = 'When installed as an application'
          end
          object cb_Autostart: TTntComboBox
            Left = 9
            Top = 45
            Width = 405
            Height = 24
            Style = csDropDownList
            ItemHeight = 16
            TabOrder = 0
          end
        end
        object cb_Languages: TTntComboBox
          Left = 3
          Top = 257
          Width = 424
          Height = 24
          Style = csDropDownList
          ItemHeight = 16
          TabOrder = 2
        end
        object cb_HotKey: TTntComboBox
          Left = 3
          Top = 302
          Width = 166
          Height = 24
          Style = csDropDownList
          ItemHeight = 16
          TabOrder = 3
          Items.Strings = (
            'No shortcut'
            'Windows + C'
            'Windows + Z'
            'Ctrl + Alt + C'
            'Ctrl + Alt + B'
            'Ctrl + Shift +C'
            'Ctrl + Shift + F12')
        end
        object e_Temp: TTntEdit
          Left = 3
          Top = 351
          Width = 399
          Height = 24
          TabOrder = 4
        end
        object b_Browse: TTntButton
          Left = 402
          Top = 351
          Width = 25
          Height = 25
          Caption = '...'
          TabOrder = 5
          OnClick = b_BrowseClick
        end
        object cb_Autocheck: TTntCheckBox
          Left = 3
          Top = 386
          Width = 430
          Height = 17
          Caption = 'Automatically check'
          TabOrder = 6
        end
        object gb_Service: TTntGroupBox
          Left = 3
          Top = 92
          Width = 424
          Height = 138
          Caption = 'Service'
          TabOrder = 1
          object cb_AutostartInterface: TTntCheckBox
            Left = 9
            Top = 29
            Width = 392
            Height = 17
            Caption = 'Autostart interface'
            TabOrder = 0
          end
          object b_SStart: TTntButton
            Left = 13
            Top = 59
            Width = 110
            Height = 25
            Caption = '&Start'
            TabOrder = 1
            OnClick = b_SStartClick
          end
          object b_SStop: TTntButton
            Left = 13
            Top = 96
            Width = 110
            Height = 25
            Caption = '&Stop'
            TabOrder = 2
            OnClick = b_SStopClick
          end
          object b_SUninstall: TTntButton
            Left = 157
            Top = 96
            Width = 110
            Height = 25
            Caption = '&Uninstall'
            TabOrder = 4
            OnClick = b_SUninstallClick
          end
          object b_SLogon: TTntButton
            Left = 301
            Top = 59
            Width = 110
            Height = 25
            Caption = '&Change logon'
            TabOrder = 5
            OnClick = b_SLogonClick
          end
          object b_SInstall: TTntButton
            Left = 157
            Top = 59
            Width = 110
            Height = 25
            Caption = '&Install'
            TabOrder = 3
            OnClick = b_SInstallClick
          end
        end
      end
      object tab_Log: TTntTabSheet
        TabVisible = False
        object l_TimeToMail: TTntLabel
          Left = 27
          Top = 222
          Width = 72
          Height = 16
          Caption = 'Time to mail'
        end
        object l_CheckSMTP: TTntLabel
          Left = 27
          Top = 145
          Width = 121
          Height = 16
          Caption = 'Check SMTP Settings'
        end
        object cb_Log: TTntCheckBox
          Left = 5
          Top = 10
          Width = 408
          Height = 17
          Caption = 'Log'
          TabOrder = 0
          OnClick = cb_LogClick
        end
        object cb_LogErrorsOnly: TTntCheckBox
          Left = 5
          Top = 37
          Width = 408
          Height = 17
          Caption = 'Log Erros Only'
          TabOrder = 1
        end
        object cb_LogVerbose: TTntCheckBox
          Left = 5
          Top = 65
          Width = 408
          Height = 17
          Caption = 'Log verbose'
          TabOrder = 2
        end
        object cb_LogRealTime: TTntCheckBox
          Left = 5
          Top = 92
          Width = 408
          Height = 17
          Caption = 'Log in real time'
          TabOrder = 3
        end
        object cb_MailLog: TTntCheckBox
          Left = 5
          Top = 120
          Width = 404
          Height = 17
          Caption = 'Mail log file'
          TabOrder = 4
          OnClick = cb_LogClick
        end
        object cb_MailAfterBackup: TTntCheckBox
          Left = 5
          Top = 172
          Width = 420
          Height = 17
          Caption = 'Mail after backup'
          TabOrder = 5
        end
        object cb_MailAsAttachment: TTntCheckBox
          Left = 5
          Top = 275
          Width = 412
          Height = 17
          Caption = 'Mail as attachment'
          TabOrder = 8
        end
        object cb_MailIfErrors: TTntCheckBox
          Left = 5
          Top = 305
          Width = 412
          Height = 17
          Caption = 'Mail if errors'
          TabOrder = 9
        end
        object cb_DeleteOnMail: TTntCheckBox
          Left = 5
          Top = 335
          Width = 412
          Height = 17
          Caption = 'Delete on mail'
          TabOrder = 10
        end
        object dt_TimeToMail: TTntDateTimePicker
          Left = 27
          Top = 239
          Width = 124
          Height = 24
          Date = 38796.534040254630000000
          Time = 38796.534040254630000000
          Kind = dtkTime
          TabOrder = 7
        end
        object cb_MailScheduled: TTntCheckBox
          Left = 5
          Top = 200
          Width = 420
          Height = 17
          Caption = 'Mail schedulled'
          TabOrder = 6
          OnClick = cb_MailScheduledClick
        end
      end
      object tab_SMTP: TTntTabSheet
        TabVisible = False
        object l_SMTPSenderName: TTntLabel
          Left = 5
          Top = 23
          Width = 86
          Height = 16
          Caption = 'Sender'#39's name'
        end
        object l_SMTPSenderAddress: TTntLabel
          Left = 223
          Top = 23
          Width = 99
          Height = 16
          Caption = 'Sender'#39's address'
        end
        object l_SMTPServerHost: TTntLabel
          Left = 5
          Top = 69
          Width = 66
          Height = 16
          Caption = 'Server host'
        end
        object l_SMTPPort: TTntLabel
          Left = 324
          Top = 69
          Width = 60
          Height = 16
          Caption = 'SMTP Port'
        end
        object l_SMTPSubject: TTntLabel
          Left = 5
          Top = 114
          Width = 43
          Height = 16
          Caption = 'Subject'
        end
        object l_SMTPTo: TTntLabel
          Left = 3
          Top = 163
          Width = 132
          Height = 16
          Caption = 'To: (E-mail addresses)'
        end
        object l_SMTPID: TTntLabel
          Left = 3
          Top = 287
          Width = 12
          Height = 16
          Caption = 'ID'
        end
        object l_SMTPPasssword: TTntLabel
          Left = 223
          Top = 286
          Width = 55
          Height = 16
          Caption = 'Password'
        end
        object l_SMTPHeloName: TTntLabel
          Left = 223
          Top = 334
          Width = 61
          Height = 16
          Caption = 'Helo name'
        end
        object l_SMTPActivate: TTntLabel
          Left = 5
          Top = 1
          Width = 63
          Height = 16
          Caption = 'To activate'
        end
        object e_SMTPSenderName: TTntEdit
          Left = 7
          Top = 40
          Width = 210
          Height = 24
          TabOrder = 0
        end
        object e_SMTPSendersAddress: TTntEdit
          Left = 223
          Top = 40
          Width = 210
          Height = 24
          TabOrder = 1
        end
        object e_SMTPServerHost: TTntEdit
          Left = 5
          Top = 84
          Width = 312
          Height = 24
          TabOrder = 2
        end
        object e_SMTPPort: TTntEdit
          Left = 324
          Top = 84
          Width = 109
          Height = 24
          TabOrder = 3
        end
        object e_SMTPSubject: TTntEdit
          Left = 5
          Top = 131
          Width = 428
          Height = 24
          TabOrder = 4
        end
        object lb_SMTPTo: TTntListBox
          Left = 5
          Top = 180
          Width = 318
          Height = 76
          Style = lbOwnerDrawFixed
          ItemHeight = 25
          MultiSelect = True
          TabOrder = 5
          OnClick = lb_SMTPToClick
          OnDblClick = b_SMTPEditClick
          OnDrawItem = lb_OptionsDrawItem
        end
        object cb_SMTPLogOn: TTntCheckBox
          Left = 3
          Top = 266
          Width = 430
          Height = 17
          Caption = 'Logon'
          TabOrder = 9
          OnClick = cb_LogClick
        end
        object b_SMTPAdd: TTntButton
          Left = 323
          Top = 180
          Width = 110
          Height = 25
          Caption = '&Add'
          TabOrder = 6
          OnClick = b_SMTPAddClick
        end
        object b_SMTPEdit: TTntButton
          Left = 323
          Top = 206
          Width = 110
          Height = 25
          Caption = '&Edit'
          TabOrder = 7
          OnClick = b_SMTPEditClick
        end
        object b_SMTPDelete: TTntButton
          Left = 323
          Top = 231
          Width = 110
          Height = 25
          Caption = '&Delete'
          TabOrder = 8
          OnClick = b_SMTPDeleteClick
        end
        object e_SMTPID: TTntEdit
          Left = 3
          Top = 303
          Width = 212
          Height = 24
          TabOrder = 10
        end
        object e_SMTPPassword: TTntEdit
          Left = 223
          Top = 303
          Width = 210
          Height = 24
          PasswordChar = '*'
          TabOrder = 11
        end
        object cb_SMTPPipeLine: TTntCheckBox
          Left = 3
          Top = 337
          Width = 212
          Height = 17
          Caption = 'Pipeline'
          TabOrder = 12
        end
        object cb_SMTPUseEhlo: TTntCheckBox
          Left = 3
          Top = 361
          Width = 212
          Height = 17
          Caption = 'Use Ehlo'
          TabOrder = 13
        end
        object e_SMTPHeloName: TTntEdit
          Left = 223
          Top = 351
          Width = 210
          Height = 24
          TabOrder = 14
        end
        object b_SMTPTest: TTntButton
          Left = 3
          Top = 384
          Width = 430
          Height = 25
          Caption = '&Test'
          TabOrder = 15
          OnClick = b_SMTPTestClick
        end
      end
      object tab_FTP: TTntTabSheet
        TabVisible = False
        object l_Speed: TTntLabel
          Left = 5
          Top = 35
          Width = 36
          Height = 16
          Caption = 'Speed'
        end
        object l_ASCII: TTntLabel
          Left = 5
          Top = 99
          Width = 96
          Height = 16
          Caption = 'ASCII extensions'
        end
        object cb_Limit: TTntCheckBox
          Left = 5
          Top = 7
          Width = 402
          Height = 17
          Caption = 'Limit the speed'
          TabOrder = 0
          OnClick = cb_LimitClick
        end
        object e_Speed: TTntEdit
          Left = 5
          Top = 53
          Width = 172
          Height = 24
          TabOrder = 1
        end
        object lb_ASCII: TTntListBox
          Left = 5
          Top = 118
          Width = 172
          Height = 291
          ItemHeight = 16
          MultiSelect = True
          TabOrder = 2
          OnClick = lb_ASCIIClick
          OnDblClick = b_ASCIIEditClick
        end
        object b_ASCIIAdd: TTntButton
          Left = 177
          Top = 118
          Width = 110
          Height = 25
          Caption = '&Add'
          TabOrder = 3
          OnClick = b_ASCIIAddClick
        end
        object b_ASCIIEdit: TTntButton
          Left = 177
          Top = 144
          Width = 110
          Height = 25
          Caption = '&Edit'
          TabOrder = 4
          OnClick = b_ASCIIEditClick
        end
        object b_ASCIIDelete: TTntButton
          Left = 177
          Top = 170
          Width = 110
          Height = 25
          Caption = '&Delete'
          TabOrder = 5
          OnClick = b_ASCIIDeleteClick
        end
      end
      object tab_Security: TTntTabSheet
        TabVisible = False
        object l_Password: TTntLabel
          Left = 9
          Top = 36
          Width = 55
          Height = 16
          Caption = 'Password'
        end
        object l_PasswordRe: TTntLabel
          Left = 9
          Top = 85
          Width = 108
          Height = 16
          Caption = 'Password (Retype)'
        end
        object e_Password: TTntEdit
          Left = 9
          Top = 52
          Width = 415
          Height = 24
          PasswordChar = '*'
          TabOrder = 1
        end
        object e_PasswordRe: TTntEdit
          Left = 9
          Top = 102
          Width = 415
          Height = 24
          PasswordChar = '*'
          TabOrder = 2
        end
        object cb_ProtectUI: TTntCheckBox
          Left = 9
          Top = 6
          Width = 415
          Height = 17
          Caption = 'Protect user interface'
          TabOrder = 0
          OnClick = cb_ProtectUIClick
        end
        object cb_ProtectMainWindow: TTntCheckBox
          Left = 9
          Top = 146
          Width = 415
          Height = 17
          Caption = 'Protect main window'
          TabOrder = 3
        end
        object cb_ClearPasswordCache: TTntCheckBox
          Left = 9
          Top = 179
          Width = 415
          Height = 17
          Caption = 'Clear password cache'
          TabOrder = 4
        end
      end
      object tab_Visuals: TTntTabSheet
        TabVisible = False
        object pb_HintColor: TTntPaintBox
          Left = 10
          Top = 234
          Width = 183
          Height = 27
          OnClick = pb_HintColorClick
          OnPaint = pb_HintColorPaint
        end
        object l_HintPause: TTntLabel
          Left = 234
          Top = 219
          Width = 60
          Height = 16
          Caption = 'Hint pause'
        end
        object cb_WarnInstances: TTntCheckBox
          Left = 10
          Top = 9
          Width = 401
          Height = 17
          Caption = 'Warn multiple instances'
          TabOrder = 0
        end
        object cb_ShowWelcome: TTntCheckBox
          Left = 10
          Top = 34
          Width = 401
          Height = 17
          Caption = 'Show welcome screen'
          TabOrder = 1
        end
        object cb_ShowHints: TTntCheckBox
          Left = 10
          Top = 60
          Width = 401
          Height = 17
          Caption = 'Show hints'
          TabOrder = 2
        end
        object cb_XPStyles: TTntCheckBox
          Left = 10
          Top = 86
          Width = 407
          Height = 17
          Caption = 'Use XP styles'
          TabOrder = 3
        end
        object p_FontUI: TTntPanel
          Left = 10
          Top = 112
          Width = 183
          Height = 29
          Caption = 'Font UI'
          TabOrder = 4
          OnClick = p_FontUIClick
        end
        object p_FontLog: TTntPanel
          Left = 234
          Top = 110
          Width = 183
          Height = 29
          Caption = 'Font log'
          TabOrder = 5
          OnClick = p_FontLogClick
        end
        object cb_ConfrmClose: TTntCheckBox
          Left = 10
          Top = 150
          Width = 407
          Height = 17
          Caption = 'Confirm close'
          TabOrder = 6
        end
        object cb_ShowIcons: TTntCheckBox
          Left = 10
          Top = 174
          Width = 407
          Height = 17
          Caption = 'Show icons'
          TabOrder = 7
        end
        object e_HintPause: TTntEdit
          Left = 234
          Top = 237
          Width = 183
          Height = 24
          TabOrder = 9
        end
        object cb_ShowPercent: TTntCheckBox
          Left = 10
          Top = 197
          Width = 407
          Height = 17
          Caption = 'Show percent'
          TabOrder = 8
        end
        object cb_ClearLogTab: TTntCheckBox
          Left = 10
          Top = 271
          Width = 407
          Height = 17
          Caption = 'Clear the log tab if bu begins'
          TabOrder = 10
        end
        object cb_ForceInternalHelp: TTntCheckBox
          Left = 10
          Top = 326
          Width = 407
          Height = 17
          Caption = 'Force internal help'
          TabOrder = 12
        end
        object cb_NavigateInternally: TTntCheckBox
          Left = 10
          Top = 353
          Width = 407
          Height = 17
          Caption = 'Navigate internally'
          TabOrder = 13
        end
        object cb_AutoLog: TTntCheckBox
          Left = 10
          Top = 298
          Width = 407
          Height = 17
          Caption = 'Auto show log'
          TabOrder = 11
        end
        object cb_ShowGrid: TTntCheckBox
          Left = 10
          Top = 380
          Width = 407
          Height = 17
          Caption = 'Show grid'
          TabOrder = 14
        end
      end
      object tab_Functionality: TTntTabSheet
        TabVisible = False
        object l_Sound: TTntLabel
          Left = 5
          Top = 211
          Width = 78
          Height = 16
          Caption = 'Sound to play'
        end
        object cb_SaveAdvanced: TTntCheckBox
          Left = 5
          Top = 7
          Width = 428
          Height = 17
          Caption = 'Save advanced'
          TabOrder = 0
        end
        object cb_DeferenceLinks: TTntCheckBox
          Left = 5
          Top = 36
          Width = 428
          Height = 17
          Caption = 'Deference links'
          TabOrder = 1
        end
        object cb_UNC: TTntCheckBox
          Left = 5
          Top = 65
          Width = 428
          Height = 17
          Caption = 'Use UNC Paths'
          TabOrder = 2
        end
        object cb_Calculate: TTntCheckBox
          Left = 5
          Top = 94
          Width = 420
          Height = 17
          Caption = 'Calculate'
          TabOrder = 3
        end
        object cb_ShowBackupHint: TTntCheckBox
          Left = 5
          Top = 123
          Width = 407
          Height = 17
          Caption = 'Show Backup hints'
          TabOrder = 4
        end
        object cb_ShowDialogEnd: TTntCheckBox
          Left = 5
          Top = 152
          Width = 407
          Height = 17
          Caption = 'Show dialog if backup ends'
          TabOrder = 5
        end
        object cb_PlaySound: TTntCheckBox
          Left = 5
          Top = 182
          Width = 412
          Height = 17
          Caption = 'Play sound'
          TabOrder = 6
          OnClick = cb_PlaySoundClick
        end
        object e_Sound: TTntEdit
          Left = 5
          Top = 228
          Width = 396
          Height = 24
          TabOrder = 7
        end
        object b_BrowseSound: TTntButton
          Left = 402
          Top = 227
          Width = 25
          Height = 25
          Caption = '...'
          TabOrder = 8
          OnClick = b_BrowseSoundClick
        end
        object cb_ShutdownKill: TTntCheckBox
          Left = 5
          Top = 267
          Width = 428
          Height = 17
          Caption = 'Kill if restart'
          TabOrder = 9
        end
        object cb_RunOld: TTntCheckBox
          Left = 5
          Top = 295
          Width = 428
          Height = 17
          Caption = 'Run old backups'
          TabOrder = 10
          OnClick = cb_RunOldClick
        end
        object cb_RunDontAsk: TTntCheckBox
          Left = 24
          Top = 323
          Width = 409
          Height = 17
          Caption = 'Run without asking'
          TabOrder = 11
        end
        object cb_ConfirmRun: TTntCheckBox
          Left = 3
          Top = 356
          Width = 407
          Height = 17
          Caption = 'Confirm run'
          TabOrder = 12
        end
        object cb_ConfirmAbort: TTntCheckBox
          Left = 3
          Top = 383
          Width = 407
          Height = 17
          Caption = 'Confirm abort'
          TabOrder = 13
        end
      end
      object tab_Engine: TTntTabSheet
        TabVisible = False
        object cb_ShowExactPercent: TTntCheckBox
          Left = 5
          Top = 6
          Width = 412
          Height = 17
          Caption = 'Show exact percent'
          TabOrder = 0
        end
        object cb_UseCurrentDesktop: TTntCheckBox
          Left = 5
          Top = 34
          Width = 412
          Height = 17
          Caption = 'Close and open in the current desktop'
          TabOrder = 1
        end
        object cb_ForceFirstFull: TTntCheckBox
          Left = 5
          Top = 63
          Width = 412
          Height = 17
          Caption = 'Force first full'
          TabOrder = 2
        end
        object cb_UseAlternativeMethods: TTntCheckBox
          Left = 5
          Top = 92
          Width = 412
          Height = 17
          Caption = 'Use alternative methods'
          TabOrder = 3
        end
        object cb_UseShell: TTntCheckBox
          Left = 5
          Top = 121
          Width = 412
          Height = 17
          Caption = 'Use shell'
          TabOrder = 4
        end
        object cb_LowPriority: TTntCheckBox
          Left = 5
          Top = 150
          Width = 412
          Height = 17
          Caption = 'Low priority'
          TabOrder = 5
        end
        object cb_CheckCRCNoComp: TTntCheckBox
          Left = 5
          Top = 179
          Width = 412
          Height = 17
          Caption = 'Check CRC'
          TabOrder = 6
        end
        object cb_CopyAttributes: TTntCheckBox
          Left = 5
          Top = 207
          Width = 412
          Height = 17
          Caption = 'Copy attributes'
          TabOrder = 7
        end
        object cb_CopyTimeStamps: TTntCheckBox
          Left = 5
          Top = 236
          Width = 412
          Height = 17
          Caption = 'Copy timestamps'
          TabOrder = 8
        end
        object cb_CopyNTFS: TTntCheckBox
          Left = 5
          Top = 265
          Width = 412
          Height = 17
          Caption = 'Copy NTFS'
          TabOrder = 9
        end
        object cb_ParkFirst: TTntCheckBox
          Left = 5
          Top = 294
          Width = 412
          Height = 17
          Caption = 'Park first backup'
          TabOrder = 10
        end
        object cb_DeleteEmpty: TTntCheckBox
          Left = 5
          Top = 323
          Width = 412
          Height = 17
          Caption = 'Delete empty folders'
          TabOrder = 11
        end
        object cb_AlwaysCreate: TTntCheckBox
          Left = 5
          Top = 352
          Width = 412
          Height = 17
          Caption = 'Always create folder'
          TabOrder = 12
        end
        object cb_PropagateMasks: TTntCheckBox
          Left = 5
          Top = 379
          Width = 412
          Height = 17
          Caption = 'Propagate masks'
          TabOrder = 13
        end
      end
      object tab_Advanced: TTntTabSheet
        TabVisible = False
        object l_TCPRead: TTntLabel
          Left = 5
          Top = 2
          Width = 53
          Height = 16
          Caption = 'TCP read'
        end
        object l_TCPConnection: TTntLabel
          Left = 3
          Top = 55
          Width = 90
          Height = 16
          Caption = 'TCP Connection'
        end
        object l_DTFormat: TTntLabel
          Left = 5
          Top = 108
          Width = 102
          Height = 16
          Caption = 'Date/Time format'
        end
        object l_CopyBuffer: TTntLabel
          Left = 5
          Top = 236
          Width = 60
          Height = 16
          Caption = 'Buffer size'
        end
        object l_Warning: TTntLabel
          Left = 24
          Top = 318
          Width = 108
          Height = 16
          Caption = '(*) Need to restart'
        end
        object e_TCPRead: TTntEdit
          Left = 5
          Top = 20
          Width = 210
          Height = 24
          TabOrder = 0
        end
        object e_TCPConnection: TTntEdit
          Left = 3
          Top = 72
          Width = 210
          Height = 24
          TabOrder = 1
        end
        object e_DTFormat: TTntEdit
          Left = 5
          Top = 128
          Width = 210
          Height = 24
          TabOrder = 2
        end
        object cb_DoNotSeparateDate: TTntCheckBox
          Left = 5
          Top = 170
          Width = 412
          Height = 17
          Caption = 'Don'#39't separate timestamp'
          TabOrder = 3
        end
        object cb_DoNotUseSpaces: TTntCheckBox
          Left = 5
          Top = 206
          Width = 426
          Height = 17
          Caption = 'Do not use spaces'
          TabOrder = 4
        end
        object e_CopyBuffer: TTntEdit
          Left = 5
          Top = 256
          Width = 210
          Height = 24
          TabOrder = 5
        end
        object cb_Pipes: TTntCheckBox
          Left = 5
          Top = 296
          Width = 414
          Height = 17
          Caption = 'Use pipes'
          TabOrder = 6
        end
      end
      object tab_Zip: TTntTabSheet
        TabVisible = False
        object l_NonCompressed: TTntLabel
          Left = 228
          Top = 3
          Width = 96
          Height = 16
          Caption = 'Non-compressed'
        end
        object gb_Compression: TTntGroupBox
          Left = 3
          Top = 0
          Width = 218
          Height = 129
          Caption = 'Compression'
          TabOrder = 0
          object cb_CompressionAbsolute: TTntCheckBox
            Left = 7
            Top = 25
            Width = 200
            Height = 17
            Caption = 'Absolute paths'
            TabOrder = 0
          end
          object cb_CompTaskName: TTntCheckBox
            Left = 7
            Top = 49
            Width = 200
            Height = 17
            Caption = 'Use task names'
            TabOrder = 1
          end
          object cb_CompCRC: TTntCheckBox
            Left = 7
            Top = 73
            Width = 200
            Height = 17
            Caption = 'Check CRC'
            TabOrder = 2
          end
          object cb_CompOEM: TTntCheckBox
            Left = 7
            Top = 97
            Width = 200
            Height = 17
            Caption = 'OEM file names'
            TabOrder = 3
          end
        end
        object gb_Zip: TTntGroupBox
          Left = 3
          Top = 131
          Width = 429
          Height = 110
          Caption = 'Zip'
          TabOrder = 5
          object l_ZipLevel: TTntLabel
            Left = 7
            Top = 24
            Width = 80
            Height = 16
            Caption = 'Zip level (%d)'
          end
          object l_Zip64: TTntLabel
            Left = 230
            Top = 23
            Width = 56
            Height = 16
            Caption = 'Use Zip64'
          end
          object tb_ZipLevel: TTntTrackBar
            Left = 4
            Top = 41
            Width = 182
            Height = 45
            Max = 9
            Position = 1
            TabOrder = 0
            OnChange = tb_ZipLevelChange
          end
          object cb_ZipAdvancedNaming: TTntCheckBox
            Left = 10
            Top = 82
            Width = 407
            Height = 23
            Caption = 'Advanced naming'
            TabOrder = 1
          end
          object cb_Zip64: TTntComboBox
            Left = 230
            Top = 41
            Width = 187
            Height = 24
            Style = csDropDownList
            ItemHeight = 16
            TabOrder = 2
          end
        end
        object lb_Uncompressed: TTntListBox
          Left = 228
          Top = 25
          Width = 93
          Height = 104
          ItemHeight = 16
          MultiSelect = True
          TabOrder = 1
          OnClick = lb_UncompressedClick
          OnDblClick = b_UncompressedEditClick
        end
        object gb_Sqx: TTntGroupBox
          Left = 2
          Top = 243
          Width = 430
          Height = 165
          Caption = 'SQX'
          TabOrder = 6
          object l_SQXDictionary: TTntLabel
            Left = 10
            Top = 19
            Width = 56
            Height = 16
            Caption = 'Dictionary'
          end
          object l_SQXCompression: TTntLabel
            Left = 10
            Top = 72
            Width = 87
            Height = 16
            Caption = 'SQX level (%s)'
          end
          object l_SQLRecovery: TTntLabel
            Left = 208
            Top = 19
            Width = 142
            Height = 16
            Caption = 'Recovery data (%d %%)'
          end
          object cb_SQXDictionary: TTntComboBox
            Left = 10
            Top = 37
            Width = 177
            Height = 24
            Style = csDropDownList
            ItemHeight = 16
            TabOrder = 0
            Items.Strings = (
              '32 KB'
              '64 KB'
              '128 KB'
              '256 KB'
              '512 KB'
              '1024 KB'
              '2048 KB'
              '4096 KB')
          end
          object cb_SQXLevel: TTntComboBox
            Left = 10
            Top = 89
            Width = 177
            Height = 24
            Style = csDropDownList
            ItemHeight = 16
            TabOrder = 2
            Items.Strings = (
              '32 KB'
              '64 KB'
              '128 KB'
              '256 KB'
              '512 KB'
              '1024 KB'
              '2048 KB'
              '4096 KB')
          end
          object cb_SQXSolidArchives: TTntCheckBox
            Left = 11
            Top = 131
            Width = 197
            Height = 17
            Caption = 'Solid archives'
            TabOrder = 3
          end
          object cb_SQXExe: TTntCheckBox
            Left = 208
            Top = 110
            Width = 210
            Height = 17
            Caption = 'Exe compression'
            TabOrder = 5
          end
          object cb_SQXExternal: TTntCheckBox
            Left = 208
            Top = 85
            Width = 210
            Height = 17
            Caption = 'External recovery'
            TabOrder = 4
          end
          object cb_SQXMultimedia: TTntCheckBox
            Left = 208
            Top = 136
            Width = 210
            Height = 17
            Caption = 'Multimedia compression'
            TabOrder = 6
          end
          object tb_SQXRecoveryData: TTntTrackBar
            Left = 197
            Top = 38
            Width = 230
            Height = 45
            Max = 5
            TabOrder = 1
            OnChange = tb_SQXRecoveryDataChange
          end
        end
        object b_UncompressedAdd: TTntButton
          Left = 322
          Top = 25
          Width = 110
          Height = 25
          Caption = '&Add'
          TabOrder = 2
          OnClick = b_UncompressedAddClick
        end
        object b_UncompressedEdit: TTntButton
          Left = 322
          Top = 51
          Width = 110
          Height = 25
          Caption = '&Edit'
          TabOrder = 3
          OnClick = b_UncompressedEditClick
        end
        object b_UncompressedDelete: TTntButton
          Left = 322
          Top = 78
          Width = 110
          Height = 25
          Caption = '&Delete'
          TabOrder = 4
          OnClick = b_UncompressedDeleteClick
        end
      end
    end
  end
  object il_Options: TImageList
    Left = 56
    Top = 16
    Bitmap = {
      494C01010B000E00040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000004000000001002000000000000040
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF00F7F7
      F700EFEFEF00DEDEDE00BDBDBD00737B7B00525A6300737373009C9C9C00B5B5
      B500C6C6C600D6D6D600E7E7E700EFEFEF000000000000000000BDBDBD00635A
      5A005A525200524A4A004A4242004242420042424200424242004A424200524A
      4A005252520063636300C6C6C6000000000000000000000000008C6B6B007B4A
      4A005A3939005A4A4A008C848400C6C6C600EFEFEF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000F7F7F700E7E7E700CECE
      CE009C9C9C00636B73006384940094CEDE009CE7EF005A9CAD00395A6B004A52
      5A007373730094949400B5B5B500CECECE00000000000000000063392900A573
      6300AD7B6B00AD8473008C7373007B6B73007B73730084736B00A5847300AD7B
      6B00AD7B6B0073422900524A4A000000000000000000D6C6C600BD848400FFE7
      D600EFC6B500D69C9400A56B6B007B4A4A005A3131005A4242007B7B7B00B5B5
      B500EFEFEF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000D6DEDE007B8494005A73
      8C0094BDD600CEF7FF00C6FFFF00B5F7FF00ADFFFF009CFFFF009CFFFF007BD6
      E7004A8CA500395263004A525A007B7B7B000000000000000000B5947B00FFEF
      E700DED6D600DED6CE00DED6D600DEC6BD00DEBDAD00DED6CE00DED6CE00DED6
      D600F7EFE700D6B59C00524A42000000000000000000AD8C8C00DEADA500FFDE
      C600FFD6C600FFDECE00FFE7D600FFDED600F7CEBD00DEA59C00AD7373008442
      42005A29290052393900736B6B00CECECE000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000638CB500C6EFFF00E7FF
      FF00E7FFFF00C6F7FF009CEFFF0094E7FF009CF7FF0084F7FF0094FFFF009CFF
      FF00A5FFFF009CFFFF005AA5C6005A5A63000000000000000000AD9C8400EFBD
      A500C6947B00BD8C7300C69C8400CE8C6300C6845200C6A58C00BD8C7300C69C
      8400E7AD9400CEAD94005A524A0000000000000000009C6B6B00F7CEC600FFDE
      CE00FFD6CE00FFDED600FFDED600FFDED600FFE7DE00FFE7DE00FFEFDE00FFDE
      D600FFCEC600E7ADA500A55A5200634A4A000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000007BADCE00EFFFFF00D6FF
      FF00BDF7FF00A5EFFF008CE7FF007BDEFF008CEFFF0073EFFF0084F7FF008CF7
      FF0094FFFF009CFFFF0073CEE7005A5A63000000000000000000AD948400F7BD
      9C00E7945200E79C5A00DE9C6300CE9C7300CE9C7300DE945A00DE945200DE8C
      4A00F7AD8400C6AD94005A524A0000000000E7DEDE00B5737300FFE7DE00FFE7
      DE00FFE7DE00FFE7E700FFE7E700FFE7E700FFE7E700FFE7E700FFDEDE00FFDE
      D600FFDED600FFEFDE00C6847B00736363000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000007BADCE00E7FFFF00C6F7
      FF00A5EFFF008CE7FF0073DEFF006BD6FF007BE7FF0063E7FF0073EFFF007BEF
      FF007BF7FF008CFFFF0063C6DE005A6363000000000000000000AD8C7B00F7C6
      AD00EFD6D600E7DEEF00DECEDE00D6C6D600D6C6CE00C6BDCE00C6C6D600D6CE
      DE00EFBDA500C6A584005A524A0000000000B5A5A500CE9C9C00FFEFEF00FFE7
      EF00FFEFEF00FFF7F700FFFFFF00FFF7F700FFF7F700FFEFEF00FFEFEF00FFE7
      E700FFE7E700FFD6CE008C424200B5B5B5000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000073ADCE00CEFFFF00ADEF
      FF0094E7FF0073DEFF005ACEFF0052CEFF006BDEFF0052DEFF0063E7FF006BE7
      FF006BEFFF007BF7FF005ABDDE0063636B000000000000000000B5947B00E7C6
      A500A5D6AD0094DEC6008CD6B5008CCEAD008CC6A5008CBD9C008CBD940094BD
      8C00DEBD8C00CEA594005A524A00000000009C737300F7CECE00FFFFFF000000
      0000FFFFFF00F7E7E700E7BDBD00DE9C9400EFD6D60000000000FFF7F700FFF7
      EF00FFF7F700F7BDBD0063313100EFEFEF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000006BA5CE00B5F7FF0094E7
      FF007BDEFF0063D6FF0042C6FF0042C6FF005AD6FF0042D6FF0052DEFF005ADE
      FF005AE7FF006BEFFF004ABDE700636B6B000000000000000000BD948C00D6CE
      A50029CE730008D67B0008D6730000CE6B0000C6520008BD420010B52900189C
      0000B5B56300DEADA5005A524A0000000000AD737300FFE7E700FFEFE700E7C6
      BD00D69C9400CE7B7B00CE7B7B00CE7B7300D6847B00F7DEDE0000000000FFFF
      FF0000000000D69494006B4A4A00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000005AA5D6009CEFFF007BDE
      FF0063D6FF004ACEFF0029BDFF0029BDFF0052D6FF0031CEFF0042D6FF004AD6
      FF0052DEFF005AE7FF0042B5E7006B6B73000000000000000000C69C8C00DECE
      AD004AD6840029DE940029D6840010D67B0000CE730000C65A0008BD420018AD
      2100B5BD7300DEB5A5005A524A0000000000C68C8400DE9C9C00B5635A00A54A
      4A00A5525200B5635A00BD6B6B00BD737300C66B6B00CE7B7300F7DEDE000000
      0000FFF7F700A55A52009C949400000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000052A5D60084E7FF0063D6
      FF0042C6FF0031BDFF0029BDFF0052C6FF007BDEFF004ACEFF0031CEFF0031CE
      FF0039CEFF004ADEFF0039B5E7006B7373000000000000000000C6A59400E7CE
      AD0063D694004AE79C0042DE940029DE8C0010D67B0000CE6B0000C6520010B5
      3100B5BD7B00DEB5AD006352520000000000C6949400E7B5B500E7A5A500CE84
      8C00BD737300AD636300A5525200A5525200AD5A5A00AD525200CE7B7300FFEF
      EF00FFE7DE007B393100D6D6D600000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000429CD6006BD6FF0052CE
      FF0063D6FF0073D6FF0084DEFF006BD6FF0063CEFF008CE7FF0084DEFF006BD6
      FF004ACEFF0039D6FF0029ADE70073737B000000000000000000CEA59400E7D6
      B5007BDEA50063E7AD0052DEA50039DE940029D6840008D67B0000CE630008B5
      3900ADC68400E7BDAD006352520000000000F7E7E700CE9C9C00FFE7EF00FFD6
      D600FFCECE00F7BDC600E7A5AD00D68C8C00BD737300B5636300A54A4A00D68C
      8C00EFA59C006342390000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000429CD60094E7FF009CE7
      FF008CDEFF007BD6FF007BDEFF005ABDFF005ABDFF0073D6FF0073D6FF008CDE
      FF009CE7FF009CEFFF004ABDEF008C8C94000000000000000000CEAD9C00EFD6
      BD0094E7B5007BEFBD006BE7AD004AE79C0031DE8C0018DE840000D6730000BD
      4A00ADC68C00E7BDB500635A52000000000000000000D6B5B500DEBDBD00FFEF
      EF00FFDEDE00FFDEDE00FFDEDE00FFD6DE00FFCED600FFC6C600EFBDBD00E79C
      9C00A54A4A00A594940000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000007BB5D60052A5D60063BD
      EF008CD6FF0094DEFF008CD6F7005AADE7005AA5E7007BC6F7008CD6F7008CD6
      F7006BBDEF004A9CD6005284A500CED6D6000000000000000000CEB5A500E7D6
      BD0094D6B50084E7BD0063DEA5004AD69C0029D68C0010CE7B0000CE630000B5
      420094BD8400EFC6B500635A5200000000000000000000000000C6949400F7EF
      EF00FFF7FF00FFE7EF00FFE7E700FFE7E700FFEFF700FFE7E700CEA5A500946B
      6B00CEBDBD000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000F7FFFF00BDD6
      EF0073ADDE0063B5DE009CDEF700B5EFF700B5EFF700A5EFFF006BBDE7005A9C
      CE008CB5D600D6E7EF00FFFFFF00000000000000000000000000D6BDAD00F7E7
      CE00BDB59400B5BD9C00ADBD9400A5B594009CB58C0094B5840084B5840084AD
      7300D6D6B500EFD6C600635A5200000000000000000000000000F7E7E700C69C
      9C00000000000000000000000000FFF7F700D6B5B500946B6B00CEBDBD000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000E7F7FF0094C6E7005AADDE0052A5D60073ADD600C6DEE700FFFF
      FF00000000000000000000000000000000000000000000000000AD9C9400DECE
      C600D6CEC600D6C6C600DECEC600DECEC600DECEC600DECEC600DECEC600DECE
      C600E7D6CE00B59C8C00A59C9C0000000000000000000000000000000000D6B5
      B500DEC6C60000000000DEC6C60094737300BDADAD0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C6949400A57B7B00B5A5A500FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000FFFFFF00EFEFEF00DEDE
      DE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDEDE00DEDE
      DE00DEDEDE00EFEFEF00FFFFFF00000000000000000000000000000000000000
      000000000000000000000000000073738C0063636B00EFEFEF00000000000000
      0000000000000000000000000000000000000000000000000000FFFFFF009484
      84008C7B7300A58C84007B6B6B008C8C8C00B5B5B500C6C6C600D6D6D600DEDE
      DE00EFEFEF00F7F7F700FFFFFF0000000000000000000000000000000000BDBD
      BD00636363004A4A4A00424242005A5A5A00A5A5A500FFFFFF00000000000000
      00000000000000000000000000000000000000000000E7E7E700B5B5B5009C9C
      9C009C9C9C009C9C9C009C9C9C009C9C9C009C9C9C009C9C9C009C9C9C009C9C
      9C009C9C9C00BDBDBD00EFEFEF00000000000000000000000000000000000000
      000000000000FFFFFF0042426B002929C60018189C0039394200E7E7E7000000
      0000000000000000000000000000000000000000000000000000F7F7F7009C63
      3900DE7B2900BD734A00AD847B007B737300737373007B7B7B0094949400ADAD
      AD00B5B5B500CECECE00E7E7E700F7F7F70000000000F7F7F7005A5A5A003939
      39005252520063636300636363004A4A4A002929290042424200E7E7E7000000
      00000000000000000000000000000000000000000000315A84002173A5002173
      9C0021739C0021739C0021739C0021739C0021739C0021739C0021739C002173
      9C00213952009C9C9C00DEDEDE00000000000000000000000000000000000000
      0000EFEFEF0031316B003131D6003131F7003131F7002121AD0021214200CECE
      CE00000000000000000000000000000000000000000000000000F7F7F700BDBD
      BD00AD947B00BDADAD00BDB5BD00EFE7E700F7EFEF00E7DEDE00CEC6C6009C94
      9400736B6B008C8C8C00CECECE00F7F7F700FFFFFF004A4A4A004A4A4A006B6B
      6B0063636300636363006363630063636300636363003131310039393900EFEF
      EF000000000000000000000000000000000000000000319CD60031EFFF0031EF
      FF0031EFFF0031EFFF0031EFFF0031EFFF0031EFFF0031EFFF0031EFFF0039EF
      FF00216394009C9C9C00DEDEDE0000000000000000000000000000000000DEDE
      DE0029296B003131E7002121EF000000C6000000CE003131F7002929C6001818
      3900B5B5B5000000000000000000000000000000000000000000C6BDBD009C8C
      8C00BDADAD00D6BDBD00E7D6D600F7E7DE00EFDED600E7CECE00E7CECE00EFE7
      DE00FFF7F700948C8C00D6D6D600F7F7F7008484840039393900525252004A4A
      4A004A4A4A004A4A4A004A4A4A004A4A4A004A4A4A0052525200212121007373
      73000000000000000000000000000000000000000000299CD60021DEFF0021DE
      FF0018DEFF0018DEFF0018E7FF0018E7FF0018DEFF0018DEFF0018DEFF0029DE
      FF0021638C009C9C9C00DEDEDE00000000000000000000000000CECECE002121
      73003131EF001818EF000000CE000000D6000000D6000000D6002121F7002929
      CE00101042009C9C9C0000000000000000000000000000000000B5A5A500BDAD
      AD00BDA5A500D6C6BD00EFDED600F7E7D600FFEFDE00FFE7D600FFDEC600EFCE
      BD00B5A5A500A5A5A500F7F7F700000000003131310031313100313131003131
      3100313131003131310031313100313131003131310039393900292929002929
      2900F7F7F700000000000000000000000000000000003194D60063DEFF005AD6
      FF0052D6FF0021B5FF00109CDE00109CDE0010BDFF0010CEFF0010CEFF0021D6
      FF0021638C009C9C9C00DEDEDE000000000000000000B5B5B50018187B002929
      EF000808E7000000D6000000DE000000DE000000DE000000DE000000D6001818
      F7002929E700101052008C8C8C00000000000000000000000000BDB5B500C6BD
      BD00D6CECE00CEC6C600BDB5B500AD9C9C007B737300AD9C9C00B5A59C00ADA5
      A500DED6D600F7F7F70000000000000000001010100018181800212121003131
      3100292929001818180018181800181818001818180018181800181818001818
      1800DEDEDE00000000000000000000000000000000003194D6007BDEFF0073D6
      FF0063D6FF004AB5EF003131390021314A0010B5FF0000BDFF0000BDFF0010C6
      FF0021638C009C9C9C00DEDEDE0000000000CECECE00181884003131FF003131
      FF002121E7000808E7000000E7000000E7000000E7000000E7000000DE000000
      D6001010EF002929E70010105200ADADAD000000000000000000D6C6C600DED6
      D600C6BDBD00BDB5B500ADA5A500635A5A009C9C9C00B5B5B500C6C6C600CECE
      CE00D6D6D600E7E7E700F7F7F700000000000000000029292900636363006363
      63004A4A4A003939390010101000000000000000000000000000000000001010
      1000DEDEDE00000000000000000000000000000000003194D60084DEFF007BD6
      FF006BD6FF006BC6F70039424200314A5A0018BDFF0000B5FF0000B5FF0010BD
      FF0021638C009C9C9C00DEDEDE00000000004A4A84003131EF005252FF005A5A
      FF005A5AFF005252FF002929F7000000EF000000EF000000EF000000E7000000
      E7000000D6001010F7002121C60039394A000000000000000000E7DEDE00B5A5
      A500D6CECE00CEC6CE00C6BDBD00949494007B737B00736B6B007B737B00847B
      840094949400BDBDBD00EFEFEF000000000018181800737373009C9C9C008484
      8400737373005A5A5A0039393900080808000000000000000000000000002121
      2100F7F7F70000000000000000000000000000000000399CD60094E7FF008CDE
      FF007BDEFF0084BDD60031292100211818004AB5EF0010B5FF0010B5FF0021BD
      FF00216394009C9C9C00DEDEDE00000000002929A5005A5AFF007373FF006B6B
      FF006B6BFF007373FF007373FF005A5AFF001818F7000000F7000000EF000000
      E7000000DE000000DE001818EF0021216300000000000000000000000000B5A5
      A500DED6D600AD5A2100C6844200CE9C6B00C6A57B00CEAD9C00D6BDB500CEBD
      BD00A5949400A5A5A500E7E7E70000000000525252008C8C8C00CECECE00ADAD
      AD00949494007B7B7B005A5A5A00212121000000000000000000000000007373
      73000000000000000000000000000000000000000000429CD600ADEFFF00A5E7
      FF0094E7FF009CDEFF008C949C00849CAD005ACEFF0029BDFF0031C6FF0039CE
      FF0029639400ADADAD00E7E7E700000000003131BD008484FF008C8CFF008484
      FF008484FF008484FF008484FF008C8CFF008484FF004242FF000000F7000000
      E7000000E7000000DE001010EF00212173000000000000000000F7F7F700BDAD
      B500D6B5A500AD310000C6520000CE630000D66B0800CE6B0800C65A0000BD73
      3900ADA5A500ADADAD00EFEFEF0000000000D6D6D6004A4A4A00DEDEDE00E7E7
      E700B5B5B5009C9C9C006B6B6B0018181800000000000000000010101000E7E7
      E7000000000000000000F7F7F700EFEFEF00000000003994CE0084D6FF0073CE
      F7006BCEF70073D6FF007BDEFF0073D6FF0052C6FF0042BDF70042BDF70052CE
      FF0029638C00CECECE00F7F7F700000000003939AD009C9CFF00A5A5FF009C9C
      FF009C9CFF009C9CFF009C9CFF009C9CFF00A5A5FF00A5A5FF008484FF003131
      EF000000E7000000DE000808F700212173000000000000000000DEDEDE00CEC6
      CE00BD847300A5290000BD420000C6520000C65A0000C65A0000BD4A0000BD6B
      3900948C8C00C6C6C600EFEFEF000000000000000000BDBDBD004A4A4A009C9C
      9C00A5A5A5007B7B7B002929290010101000313139001818180029292100CECE
      CE00DEDEE700526B9400184A8C00737B8C00000000009CBDD6005A7B940084A5
      BD007B9CB50021395200426B9400527BA5005A738C008CA5BD007B9CB500314A
      63009CADBD00F7F7F7000000000000000000424294009C9CF700C6C6FF00B5B5
      FF00B5B5FF00B5B5FF00B5B5FF00BDBDFF00B5B5FF00B5B5FF00BDBDFF00B5B5
      FF008C8CF7006B6BF7004242E700393963000000000000000000BDBDBD00DEDE
      DE00A55A4200AD310000C65A0000DE6B0000DE6B0000C6520000AD310000BD7B
      5A00847B8400CECECE00F7F7F700000000000000000000000000E7E7E7006363
      63002121210010101000101010003131310052525200737B8C0042426B00CECE
      CE006B94BD001073C6004A84D600C6CED6000000000000000000C6C6C600B5AD
      AD00E7DEDE00524A4A007B7B7B0084848400847B7300EFE7DE009C9494008C8C
      8C00E7E7E7000000000000000000000000009C9CBD005A5AB500D6D6FF00DEDE
      FF00D6D6FF00D6D6FF00DEDEFF00CECEFF00D6D6FF00DEDEFF00D6D6FF00D6D6
      FF00EFEFFF00CECEFF0039398C00B5B5B5000000000000000000A5A5A500DEDE
      DE009C391800BD420000CE5A0000DE6B0000E7730000DE6B0000BD420000BD8C
      7B007B7B7B00D6D6D600F7F7F700000000000000000000000000000000000000
      0000FFFFFF00E7E7E700EFEFEF0000000000C6C6C60094949C009C9CE7008C8C
      B5004A739C00214A7B00949CAD00F7F7F7000000000000000000FFFFFF008484
      8400DED6D600D6D6D600847B7B008C848400DEDEDE00D6CECE0052525200D6D6
      D600F7F7F700000000000000000000000000000000006B6B9C005A5AB500BDBD
      F700DEDEFF00D6D6FF00A5A5FF004242CE005A5AD600BDBDFF00DEDEFF00D6D6
      FF00A5A5EF004242940084849400000000000000000000000000A59C9C00D6C6
      CE008C100000AD290000BD420000C6520000CE520000C6520000AD310000BD94
      940084848400DEDEDE00FFFFFF00000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000EFF7FF003173
      CE0029527B00218CDE00084AAD009C9CA500000000000000000000000000CECE
      CE0094949400D6D6D600EFEFEF00EFEFEF00CECECE0084848400BDBDBD00F7F7
      F700000000000000000000000000000000000000000000000000A5A5B5004242
      840039399C003939A5003131840073738C0063639400313194003939A5003939
      940042427300B5B5BD0000000000000000000000000000000000B5ADAD00D6CE
      CE008C4A42009C4A4200A5523900A5523100A5523100A54A29009C4A3100B5A5
      A500A5A5A500EFEFEF0000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000000000000219C
      FF0018396300E7EFF700A5C6F700E7E7E7000000000000000000000000000000
      0000CECECE00848484009C9C9C009C949400847B7B00D6D6D600F7F7F7000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000000000000000000094949400ADAD
      AD00B5B5B500B5B5B500B5B5B500B5B5BD00BDB5BD00BDB5BD00C6BDBD00AD9C
      9C00DEDEDE00FFFFFF0000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000000000000073B5
      FF003163AD00EFEFEF0000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000000000000000000000008C6B6B007B4A
      4A005A3939005A4A4A008C848400C6C6C600EFEFEF0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000B55A3100C65A2100BD521000BD52
      1000BD521000BD520800BD520800BD520800BD4A0000C64A0000C64A0000C64A
      0000C64A0000C64A0000C64A0000B5521800000000000000000000000000ADB5
      CE00297BB5003973AD005A7BA5008C94AD00B5B5BD00DEDEDE00F7F7F7000000
      00000000000000000000000000000000000000000000D6C6C600BD848400FFE7
      D600EFC6B500D69C9400A56B6B007B4A4A005A3131005A4242007B7B7B00B5B5
      B500EFEFEF000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000C66B3100EFA56B00EFB58400EFAD
      8400EFAD7B00EFAD7B00EFA57B00EFA57300EFA57300EFA57300EF9C6B00EF9C
      6B00E79C6300E79C6B00EF8C4200CE520800000000000000000000000000427B
      C60063F7FF005AEFFF004ADEFF0039C6FF0029A5EF002184D6002973BD00426B
      AD006B7BA5009C9CB500EFEFEF000000000000000000AD8C8C00DEADA500FFDE
      C600FFD6C600FFDECE00FFE7D600FFDED600F7CEBD00DEA59C00AD7373008442
      42005A29290052393900736B6B00CECECE000000000000000000000000000000
      0000D6CECE00ADA5A500B5ADAD00CECECE00EFEFEF000000000000000000A5A5
      A50000000000B5B5B5000000000000000000BD632900EFC6AD00000000000000
      000000000000F7FFFF00F7FFFF000000000000000000F7FFFF00F7F7FF00F7F7
      FF00EFEFF700E7EFFF00E7BDAD00C64A10000000000000000000D6D6EF00319C
      DE006BD6F7008494A5008C94A5007BADC6006BBDE7006BD6FF0063DEFF0052D6
      FF0042C6FF0031A5FF005A73A50000000000000000009C6B6B00F7CEC600FFDE
      CE00FFD6CE00FFDED600FFDED600FFDED600FFE7DE00FFE7DE00FFEFDE00FFDE
      D600FFCEC600E7ADA500A55A5200634A4A00000000000000000000000000B5AD
      AD007B7B7B00ADADAD008C7B7B007B6B6B0084737300C6BDBD0000000000E7E7
      E70031313100101010000000000000000000BD632900F7CEB500C6CECE008484
      8400BDB5B50000000000DEDEDE00948C8C008C848C00948C8C008C8C8C008C84
      8400847B7B00ADADB500EFC6A500C64A10000000000000000000848CCE004ACE
      FF0084A5B500FFC6AD00FFD6BD00EFB59C00D69C8C00BD8C8400A58C8C008C94
      A50084A5BD0073D6F7003973CE0000000000E7DEDE00B5737300FFE7DE00FFE7
      DE00FFE7DE00FFE7E700FFE7E700FFE7E700FFE7E700FFE7E700FFDEDE00FFDE
      D600FFDED600FFEFDE00C6847B00736363000000000000000000DEDEE7007B73
      6300C6C6BD00ADADA500CEC6C600B5949400B59C9C0094848400B5ADAD000000
      00008C8C8C00000000000000000000000000BD633100F7CEAD00E7EFEF00CECE
      CE00E7DEDE0000000000EFEFEF00CECECE00CECECE00CEC6C600CEC6C600CEC6
      C600C6BDBD00D6D6DE00EFBDA500BD4A10000000000000000000396BC60063D6
      FF00B59C9400FFF7E700FFF7EF00FFF7E700FFF7DE00FFEFD600FFDEBD00FFCE
      AD00F7A57B006B7BA500738CB50000000000B5A5A500CE9C9C00FFEFEF00FFE7
      EF00FFEFEF00FFF7F700FFFFFF00FFF7F700FFF7F700FFEFEF00FFEFEF00FFE7
      E700FFE7E700FFD6CE008C424200B5B5B500D6EFFF008C8CCE004A4A84007B73
      9C006B6B9C0052527B00ADADAD00C6B5B500B5A5A500C6B5B50094848400DEDE
      DE0073737300000000000000000000000000B55A3100EFCEAD00000000000000
      000000000000FFFFFF0000000000000000000000000000000000000000000000
      000000000000FFFFFF00EFBDA500BD4A100000000000D6D6E700298CE70084C6
      DE00E7BDA500FFFFF700FFF7E700FFF7E700FFEFDE00FFEFD600FFEFD600FFF7
      D600E7BD9C00316BB500E7E7E700000000009C737300F7CECE00FFFFFF000000
      0000FFFFFF00F7E7E700E7BDBD00DE9C9400EFD6D60000000000FFF7F700FFF7
      EF00FFF7F700F7BDBD0063313100EFEFEF004AB5FF0018ADF70010A5FF00008C
      F7000084FF001863D6009C949400CEC6C600C6B5B500CEBDBD00CEBDBD00524A
      4A00000000007B7B7B000000000000000000B5633900F7CEB500D6D6D600A59C
      9C00CEC6C60000000000EFE7E700ADA5A500ADA5A500ADA5A500A5A5A500A59C
      9C009C949400C6C6CE00F7CEAD00BD4A1000000000007B8CCE0052BDFF00A5B5
      B500FFE7D60000000000FFF7EF00FFF7E700FFF7E700FFEFDE00FFEFDE00FFE7
      BD00848CA500738CBD000000000000000000AD737300FFE7E700FFEFE700E7C6
      BD00D69C9400CE7B7B00CE7B7B00CE7B7300D6847B00F7DEDE0000000000FFFF
      FF0000000000D69494006B4A4A000000000042BDFF0052DEFF0031B5CE0039BD
      E70029ADDE006394AD009C948C00CEC6C600D6CECE00D6C6C600E7D6D600635A
      5A0073737300FFFFFF000000000000000000B55A3900F7CEB500DEE7E700BDB5
      B500DED6D60000000000EFEFEF00C6BDBD00BDBDBD00BDBDBD00BDBDBD00BDBD
      BD00B5B5B500CED6DE00F7CEAD00B54A1000FFFFFF003163D60084D6FF00C6B5
      9C000000000000000000FFFFF700FFF7EF00FFF7E700FFF7E700FFF7E700E7B5
      9C00397BCE00DEDEE7000000000000000000C68C8400DE9C9C00B5635A00A54A
      4A00A5525200B5635A00BD6B6B00BD737300C66B6B00CE7B7300F7DEDE000000
      0000FFF7F700A55A52009C94940000000000DEF7FF009CB5DE004A3963008C7B
      9C0073638C006B6B840094949400CEC6C600E7DEDE00E7DEDE00EFE7E700948C
      8C0000000000000000000000000000000000B55A3900F7CEB500000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000F7C6AD00B54A1000C6C6E700297BF700A5CEDE00E7C6
      B500000000000000000000000000FFFFF700FFF7EF00FFF7EF00FFE7CE00949C
      AD006B84BD00000000000000000000000000C6949400E7B5B500E7A5A500CE84
      8C00BD737300AD636300A5525200A5525200AD5A5A00AD525200CE7B7300FFEF
      EF00FFE7DE007B393100D6D6D6000000000084C6FF002194E700188CE700108C
      EF00087BEF001863DE009C9CA500D6CEC600F7EFEF00F7EFEF00F7EFEF008C84
      840000000000000000000000000000000000AD5A4200F7D6BD00DEDEDE00B5B5
      B500D6D6D60000000000EFEFEF00BDBDBD00BDBDBD00BDBDBD00BDBDBD00BDBD
      BD00BDB5B500D6D6DE00F7CEB500B54A18006373D60063B5FF00BDBDB500FFEF
      DE0000000000000000000000000000000000FFFFF700FFFFF700E7BDA500528C
      DE00D6D6DE00000000000000000000000000F7E7E700CE9C9C00FFE7EF00FFD6
      D600FFCECE00F7BDC600E7A5AD00D68C8C00BD737300B5636300A54A4A00D68C
      8C00EFA59C0063423900000000000000000039B5FF0031DEFF0018C6EF0021BD
      F70010ADFF0063A5E700C6B5B500DECECE00FFFFFF0000000000C6C6C600948C
      8C0000000000000000000000000000000000AD5A4200F7D6BD00D6D6DE00A59C
      A500CECECE0000000000EFEFEF00ADADAD00ADA5AD00ADADAD00ADADAD00ADAD
      AD00A5A5A500CECED600FFD6B500B54A18001052E70094D6FF00D6BDA5000000
      0000FFF7F700DEE7DE00EFEFEF000000000000000000FFEFDE00ADB5BD006B8C
      C6000000000000000000000000000000000000000000D6B5B500DEBDBD00FFEF
      EF00FFDEDE00FFDEDE00FFDEDE00FFD6DE00FFCED600FFC6C600EFBDBD00E79C
      9C00A54A4A00A59494000000000000000000D6EFFF00D6F7FF007B9CB500736B
      6B00D6D6DE00DEDEDE00C6BDBD00EFEFEF0000000000EFEFEF00635A5A00E7E7
      E70000000000000000000000000000000000AD5A4A00EFC6AD00FFF7EF00FFF7
      EF00F7F7EF00F7F7EF00FFF7EF00FFF7EF00FFF7EF00FFF7EF00FFF7EF00FFF7
      EF00F7F7EF00F7F7F700F7C6AD00B54A18004A73E700C6EFEF00EFC69C00E7D6
      BD004A9C420018941000218418008CA57300FFEFE700EFCEB5006BA5E700CED6
      DE00000000000000000000000000000000000000000000000000C6949400F7EF
      EF00FFF7FF00FFE7EF00FFE7E700FFE7E700FFEFF700FFE7E700CEA5A500946B
      6B00CEBDBD000000000000000000000000000000000000000000F7F7F7004231
      3100C6BDB500EFE7DE00E7DEDE0000000000BDBDBD005A5A5A00CECECE000000
      000000000000000000000000000000000000AD6B5A00EF9C6300E78C5200E78C
      5200E78C5200E78C5200E78C5200E78C5200E78C4A00E78C4A00E78C4A00E78C
      4A00E78C4A00E78C4A00EF8C4200B5522100BDC6F7007B94EF007B8CE700638C
      730063DE5A005AE75A0042CE390042846300ADADC6008CB5E7007B9CF7000000
      0000000000000000000000000000000000000000000000000000F7E7E700C69C
      9C00000000000000000000000000FFF7F700D6B5B500946B6B00CEBDBD000000
      000000000000000000000000000000000000000000000000000000000000D6D6
      D60042424200525252006B636300525252006B6B6B00DEDEDE00000000000000
      000000000000000000000000000000000000AD736B00FFE7A500FFC68400FFC6
      7B00FFC67B00FFBD7300FFBD6B00FFB56300FFB56300FFAD5A00FFAD5200FFA5
      4A00FFA54200FF9C3900FFAD4200B55A3100000000000000000000000000CEDE
      C60094CE8C009CE79C008CB58400B5BDEF009CB5FF00ADC6FF00000000000000
      000000000000000000000000000000000000000000000000000000000000D6B5
      B500DEC6C60000000000DEC6C60094737300BDADAD0000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000008C4A42009C5A52009C5A52009C52
      4A009C524A009C5242009C5242009C5239009C5239009C4A39009C4A31009C4A
      31009C4A29009C4229009C4221008C3929000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000C6949400A57B7B00B5A5A500FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000400000000100010000000000000200000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      00000000000000000000000000000000C000C001C07F00008000C00180070000
      8000C001800000008000C001800000008000C001000000008000C00100000000
      8000C001104000008000C001002900008000C001001100008000C00100010000
      8000C001000300008000C001800300008000C001C0070000C001C001CE1F0000
      F80FC001E47F0000FFFFFFFFF0FF00008001FE3FC001E03F8001F81FC000801F
      8001F00FC000000F8001E007C000000F8001C003C001000780018001C0030007
      80010000C001000780010000C001000780010000E001000F80010000C001000C
      80010000C001800080030000C001C000C0070000C001F100C0078001C001FFC0
      E00FC003C003FFE0F01FFFFFC003FFE3FFFFFFFFC07FFFFF0000E01F8007FFFF
      0000E0018000F0633980C0018000E0230400C0010000C0130400C00100000003
      3BF8800110400003040084030029000304000C030011000F3FFC0E070001000F
      04000F070003004F0400118F8003008F0000000FC007C11F0000001FCE1FE03F
      0000E03FE47FFFFF0000FFFFF0FFFFFF00000000000000000000000000000000
      000000000000}
  end
  object dlg_Font: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Tahoma'
    Font.Style = []
    Left = 40
    Top = 112
  end
  object dlg_Color: TColorDialog
    Left = 56
    Top = 72
  end
  object dlg_Open: TTntOpenDialog
    Options = [ofHideReadOnly, ofEnableSizing, ofForceShowHidden]
    Left = 40
    Top = 152
  end
end
