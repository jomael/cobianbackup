{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~                                                            ~~~~~~~~~~
~~~~~~~~~~                Cobian Backup Black Moon                    ~~~~~~~~~~
~~~~~~~~~~            Copyright 200-2006 by Luis Cobian               ~~~~~~~~~~
~~~~~~~~~~                     cobian@educ.umu.se                     ~~~~~~~~~~
~~~~~~~~~~                    All rights reserved                     ~~~~~~~~~~
~~~~~~~~~~                                                            ~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

// Ths option dialog box


unit interface_Options;

interface

uses
  Messages, SysUtils, Classes, Graphics, Controls, Forms, TntClasses,
  Dialogs, TntForms, StdCtrls, TntStdCtrls, ExtCtrls, TntExtCtrls, jpeg, ImgList,
  ComCtrls, TntComCtrls, Types, Windows, TntDialogs, bmCommon;

type
  Tform_Options = class(TTntForm)
    p_Bottom: TTntPanel;
    b_OK: TTntButton;
    b_Cancel: TTntButton;
    p_Center: TTntPanel;
    p_Left: TTntPanel;
    lb_Options: TTntListBox;
    il_Options: TImageList;
    pc_Options: TTntPageControl;
    tab_General: TTntTabSheet;
    tab_Log: TTntTabSheet;
    tab_SMTP: TTntTabSheet;
    tab_FTP: TTntTabSheet;
    tab_Security: TTntTabSheet;
    tab_Visuals: TTntTabSheet;
    tab_Functionality: TTntTabSheet;
    tab_Engine: TTntTabSheet;
    tab_Advanced: TTntTabSheet;
    tab_Zip: TTntTabSheet;
    gb_Autostart: TTntGroupBox;
    l_AutostartApp: TTntLabel;
    cb_Autostart: TTntComboBox;
    cb_WarnInstances: TTntCheckBox;
    l_Language: TTntLabel;
    cb_Languages: TTntComboBox;
    cb_Log: TTntCheckBox;
    cb_LogErrorsOnly: TTntCheckBox;
    cb_LogVerbose: TTntCheckBox;
    cb_LogRealTime: TTntCheckBox;
    l_Password: TTntLabel;
    e_Password: TTntEdit;
    l_PasswordRe: TTntLabel;
    e_PasswordRe: TTntEdit;
    cb_ProtectUI: TTntCheckBox;
    cb_ProtectMainWindow: TTntCheckBox;
    cb_ClearPasswordCache: TTntCheckBox;
    cb_ShowWelcome: TTntCheckBox;
    cb_ShowHints: TTntCheckBox;
    cb_XPStyles: TTntCheckBox;
    p_FontUI: TTntPanel;
    p_FontLog: TTntPanel;
    dlg_Font: TFontDialog;
    cb_ConfrmClose: TTntCheckBox;
    l_HotKey: TTntLabel;
    cb_HotKey: TTntComboBox;
    cb_ShowIcons: TTntCheckBox;
    cb_SaveAdvanced: TTntCheckBox;
    cb_DeferenceLinks: TTntCheckBox;
    cb_UNC: TTntCheckBox;
    pb_HintColor: TTntPaintBox;
    l_HintPause: TTntLabel;
    e_HintPause: TTntEdit;
    dlg_Color: TColorDialog;
    cb_Calculate: TTntCheckBox;
    cb_MailLog: TTntCheckBox;
    cb_MailAfterBackup: TTntCheckBox;
    cb_MailAsAttachment: TTntCheckBox;
    cb_MailIfErrors: TTntCheckBox;
    cb_DeleteOnMail: TTntCheckBox;
    l_TimeToMail: TTntLabel;
    dt_TimeToMail: TTntDateTimePicker;
    l_CheckSMTP: TTntLabel;
    l_SMTPSenderName: TTntLabel;
    e_SMTPSenderName: TTntEdit;
    l_SMTPSenderAddress: TTntLabel;
    e_SMTPSendersAddress: TTntEdit;
    l_SMTPServerHost: TTntLabel;
    e_SMTPServerHost: TTntEdit;
    l_SMTPPort: TTntLabel;
    e_SMTPPort: TTntEdit;
    l_SMTPSubject: TTntLabel;
    e_SMTPSubject: TTntEdit;
    l_SMTPTo: TTntLabel;
    lb_SMTPTo: TTntListBox;
    cb_SMTPLogOn: TTntCheckBox;
    b_SMTPAdd: TTntButton;
    b_SMTPEdit: TTntButton;
    b_SMTPDelete: TTntButton;
    l_SMTPID: TTntLabel;
    e_SMTPID: TTntEdit;
    l_SMTPPasssword: TTntLabel;
    e_SMTPPassword: TTntEdit;
    cb_SMTPPipeLine: TTntCheckBox;
    cb_SMTPUseEhlo: TTntCheckBox;
    l_SMTPHeloName: TTntLabel;
    e_SMTPHeloName: TTntEdit;
    b_SMTPTest: TTntButton;
    l_SMTPActivate: TTntLabel;
    l_TCPRead: TTntLabel;
    e_TCPRead: TTntEdit;
    e_TCPConnection: TTntEdit;
    l_TCPConnection: TTntLabel;
    l_Temp: TTntLabel;
    e_Temp: TTntEdit;
    b_Browse: TTntButton;
    cb_ShowBackupHint: TTntCheckBox;
    cb_ShowDialogEnd: TTntCheckBox;
    cb_PlaySound: TTntCheckBox;
    l_Sound: TTntLabel;
    e_Sound: TTntEdit;
    b_BrowseSound: TTntButton;
    dlg_Open: TTntOpenDialog;
    cb_ShowPercent: TTntCheckBox;
    cb_ShowExactPercent: TTntCheckBox;
    cb_UseCurrentDesktop: TTntCheckBox;
    cb_ForceFirstFull: TTntCheckBox;
    l_DTFormat: TTntLabel;
    e_DTFormat: TTntEdit;
    cb_DoNotSeparateDate: TTntCheckBox;
    cb_DoNotUseSpaces: TTntCheckBox;
    cb_UseAlternativeMethods: TTntCheckBox;
    cb_UseShell: TTntCheckBox;
    cb_LowPriority: TTntCheckBox;
    l_CopyBuffer: TTntLabel;
    e_CopyBuffer: TTntEdit;
    cb_CheckCRCNoComp: TTntCheckBox;
    cb_CopyAttributes: TTntCheckBox;
    cb_CopyTimeStamps: TTntCheckBox;
    cb_CopyNTFS: TTntCheckBox;
    cb_ParkFirst: TTntCheckBox;
    cb_DeleteEmpty: TTntCheckBox;
    cb_AlwaysCreate: TTntCheckBox;
    cb_ClearLogTab: TTntCheckBox;
    gb_Compression: TTntGroupBox;
    cb_CompressionAbsolute: TTntCheckBox;
    gb_Zip: TTntGroupBox;
    l_ZipLevel: TTntLabel;
    tb_ZipLevel: TTntTrackBar;
    cb_CompTaskName: TTntCheckBox;
    cb_CompCRC: TTntCheckBox;
    cb_ZipAdvancedNaming: TTntCheckBox;
    cb_CompOEM: TTntCheckBox;
    l_Zip64: TTntLabel;
    cb_Zip64: TTntComboBox;
    lb_Uncompressed: TTntListBox;
    l_NonCompressed: TTntLabel;
    gb_Sqx: TTntGroupBox;
    l_SQXDictionary: TTntLabel;
    cb_SQXDictionary: TTntComboBox;
    l_SQXCompression: TTntLabel;
    cb_SQXLevel: TTntComboBox;
    cb_SQXSolidArchives: TTntCheckBox;
    cb_SQXExe: TTntCheckBox;
    cb_SQXExternal: TTntCheckBox;
    cb_SQXMultimedia: TTntCheckBox;
    l_SQLRecovery: TTntLabel;
    tb_SQXRecoveryData: TTntTrackBar;
    cb_Limit: TTntCheckBox;
    l_Speed: TTntLabel;
    e_Speed: TTntEdit;
    l_ASCII: TTntLabel;
    lb_ASCII: TTntListBox;
    cb_ForceInternalHelp: TTntCheckBox;
    cb_NavigateInternally: TTntCheckBox;
    b_ASCIIAdd: TTntButton;
    b_ASCIIEdit: TTntButton;
    b_ASCIIDelete: TTntButton;
    b_UncompressedAdd: TTntButton;
    b_UncompressedEdit: TTntButton;
    b_UncompressedDelete: TTntButton;
    cb_ShutdownKill: TTntCheckBox;
    cb_Autocheck: TTntCheckBox;
    cb_RunOld: TTntCheckBox;
    cb_RunDontAsk: TTntCheckBox;
    gb_Service: TTntGroupBox;
    cb_AutostartInterface: TTntCheckBox;
    b_SStart: TTntButton;
    b_SStop: TTntButton;
    b_SUninstall: TTntButton;
    b_SLogon: TTntButton;
    b_SInstall: TTntButton;
    cb_ConfirmRun: TTntCheckBox;
    cb_ConfirmAbort: TTntCheckBox;
    cb_AutoLog: TTntCheckBox;
    cb_MailScheduled: TTntCheckBox;
    cb_PropagateMasks: TTntCheckBox;
    cb_ShowGrid: TTntCheckBox;
    procedure cb_MailScheduledClick(Sender: TObject);
    procedure b_SLogonClick(Sender: TObject);
    procedure b_SInstallClick(Sender: TObject);
    procedure b_SUninstallClick(Sender: TObject);
    procedure b_SStopClick(Sender: TObject);
    procedure b_SStartClick(Sender: TObject);
    procedure cb_RunOldClick(Sender: TObject);
    procedure lb_UncompressedClick(Sender: TObject);
    procedure b_UncompressedDeleteClick(Sender: TObject);
    procedure b_UncompressedEditClick(Sender: TObject);
    procedure b_UncompressedAddClick(Sender: TObject);
    procedure lb_SMTPToClick(Sender: TObject);
    procedure lb_ASCIIClick(Sender: TObject);
    procedure b_ASCIIDeleteClick(Sender: TObject);
    procedure b_ASCIIEditClick(Sender: TObject);
    procedure b_ASCIIAddClick(Sender: TObject);
    procedure b_SMTPTestClick(Sender: TObject);
    procedure cb_LimitClick(Sender: TObject);
    procedure tb_SQXRecoveryDataChange(Sender: TObject);
    procedure tb_ZipLevelChange(Sender: TObject);
    procedure TntFormDestroy(Sender: TObject);
    procedure cb_PlaySoundClick(Sender: TObject);
    procedure b_BrowseSoundClick(Sender: TObject);
    procedure b_BrowseClick(Sender: TObject);
    procedure b_SMTPDeleteClick(Sender: TObject);
    procedure b_SMTPEditClick(Sender: TObject);
    procedure b_SMTPAddClick(Sender: TObject);
    procedure cb_ProtectUIClick(Sender: TObject);
    procedure cb_LogClick(Sender: TObject);
    procedure pb_HintColorClick(Sender: TObject);
    procedure pb_HintColorPaint(Sender: TObject);
    procedure p_FontLogClick(Sender: TObject);
    procedure p_FontUIClick(Sender: TObject);
    procedure lb_OptionsClick(Sender: TObject);
    procedure lb_OptionsDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure TntFormShow(Sender: TObject);
    procedure b_OKClick(Sender: TObject);
    procedure b_CancelClick(Sender: TObject);
    procedure TntFormCreate(Sender: TObject);
  private
    { Private declarations }
    FFirstTime: boolean;
    FSGlobal: TFormatSettings;
    FIsService: boolean;
    FAutostart: integer;
    FAutostartI: boolean;
    FWarningFlag: boolean;
    FXPStyle: boolean;
    FShowIcons: boolean;
    FHintColor: integer;
    FTools: TCobTools;
    procedure GetInterfaceText();
    procedure LoadSettings();
    procedure SaveSettings();
    function ValidateInput(): boolean;
    procedure CheckUI();
    procedure CheckUILog();
    procedure CheckUISMTP();
    procedure CheckUISecurity();
    procedure CheckUIAutostart();
    procedure CheckUISound();
    procedure CheckUICompression();
    procedure CheckUIFunctionality();
    procedure CheckUIFTP();
    procedure ApplyAutoStart();
    procedure PopulateLanguages();
    procedure CheckAutoStart();
    function IsXPStyle(): boolean;
    procedure SetXPStyle();
    procedure SetWarningFlag();
    procedure SetPage(const Index: integer);
    procedure LoadWarningFlag();
    function IsServiceInstalled(): boolean;
    function IsServiceRunning(): boolean;
    function StartService(): boolean;
    function StopService(): boolean;
    function UninstallService(): boolean;
    function InstallService(const ID, Password: PWideChar): boolean;
    function IsAppRuning(): cardinal;
    function AssignSpecialPrivilege(const ID: WideString): boolean;
  public
    { Public declarations }
  end;

var
  form_Options: Tform_Options;

implementation

uses bmConstants, bmTranslator, CobCommonW, bmCustomize, tntSysUtils,
  interface_Common, CobDialogsW, interface_InputBox, interface_Tester,
  interface_Logon, ShellApi;

{$R *.dfm}

procedure Tform_Options.ApplyAutoStart();
var
  UIStr: WideString;
begin
  if (FAutostart = cb_Autostart.ItemIndex) and
     (FAutostartI = cb_AutostartInterface.Checked) then
     Exit;

  UIStr := WideFormat(WS_UIAUTOSTARTVALUE, [WS_PROGRAMNAMESHORT], FSGlobal);
  CobDeleteAutostartW(true,UIStr);
  CobDeleteAutostartW(false,UIStr);
  CobDeleteAutostartW(true,WS_PROGRAMNAMESHORT);
  CobDeleteAutostartW(false,WS_PROGRAMNAMESHORT);

  if (FIsService) then
    if (cb_AutostartInterface.Checked) then
    begin
      CobAutostartW(true,UIStr,Globals.AppPath + WS_GUIEXENAME, WS_SERVICEPARAM);
      Exit;
    end;


  case cb_Autostart.ItemIndex of
    INT_AUTOSTARTCURRENT: CobAutostartW(false, WS_PROGRAMNAMESHORT, Globals.AppPath + WS_APPEXENAME, WS_NIL);
    INT_AUTOSTARTALL: CobAutostartW(true, WS_PROGRAMNAMESHORT, Globals.AppPath + WS_APPEXENAME, WS_NIL);
    else
      begin
        // do nothing
      end;
  end;

end;

function Tform_Options.IsAppRuning(): cardinal;
var
  ClassName: WideString;
begin
  ClassName:= WideFormat(WS_SERVERCLASSNAME,[WS_PROGRAMNAMELONG],FSGlobal);
  Result:= FindWindowW(PWideChar(ClassName), nil);
end;

function Tform_Options.AssignSpecialPrivilege(const ID: WideString): boolean;
var
  AHandle: Thandle;
  Dll: WideString;
  Privilege: function (const ID: PWideChar): cardinal; stdcall;
  Error: cardinal;
begin
  Result:= false;
  Dll:= Globals.AppPath + WS_COBNTW;
  if (WideFileExists(Dll)) then
  begin
    AHandle:= LoadLibraryW(PWideChar(Dll));
    if (AHandle <> 0) then
    begin
      @Privilege:= GetProcAddress(AHandle, PAnsiChar(S_ASSIGNPRIVILEGE));
      if (@Privilege <> nil) then
      begin
        Error:= Privilege(PWideChar(ID));
        if (Error = INT_PRIVILEGEASSIGNED) then
          Result:= true else
          begin
            CobShowMessageW(self.Handle, WideFormat(Translator.GetMessage('520'),
                            [ID,CobSysErrorMessageW(Error)],FSGlobal),WS_PROGRAMNAMESHORT);
          end;
      end;
      FreeLibrary(AHandle);
    end;
  end;
end;

procedure Tform_Options.b_ASCIIAddClick(Sender: TObject);
var
  Ext: WideString;
begin
  if (InputQueryW(WS_PROGRAMNAMESHORT, Translator.GetMessage('493'),false,Ext)) then
    if (Trim(Ext) <> WS_NIL) then
    begin
      lb_ASCII.Items.Add(Ext);
      CheckUIFTP();
    end;
end;

procedure Tform_Options.b_ASCIIDeleteClick(Sender: TObject);
var
  i: integer;
begin
  if (lb_ASCII.SelCount > 0) then
    if (CobMessageBoxW(self.Handle, Translator.GetMessage('495'),
        WS_PROGRAMNAMESHORT, MB_YESNO) = MRYES) then
    begin
      for i:= lb_ASCII.Items.Count-1 downto 0 do
        if (lb_ASCII.Selected[i]) then
          lb_ASCII.Items.Delete(i);
      CheckUIFTP();
    end;
end;

procedure Tform_Options.b_ASCIIEditClick(Sender: TObject);
var
  i: integer;
  Ext: WideString;
begin
  if (lb_ASCII.SelCount > 0) then
  begin
    for i:= 0 to lb_ASCII.Items.Count - 1 do
      if (lb_ASCII.Selected[i]) then
      begin
        Ext:= lb_ASCII.Items[i];
        if (InputQueryW(WS_PROGRAMNAMESHORT, Translator.GetMessage('494'),false, Ext)) then
          if (Trim(Ext) <> WS_NIL) then
            lb_ASCII.Items[i]:= Ext;
      end;
    CheckUIFTP();
  end;
end;

procedure Tform_Options.b_BrowseClick(Sender: TObject);
var
  Dir: WideString;
begin
  Dir:= e_Temp.Text;
  if (CobSelectDirectoryW(Translator.GetMessage('150'),WS_NIL,Dir,
                    [csdNewFolder, csdNewUI], self)) then
    e_Temp.Text:= Dir;  
end;

procedure Tform_Options.b_BrowseSoundClick(Sender: TObject);
begin
  dlg_Open.DefaultExt:= WS_DEFWAVEXT;
  dlg_Open.Filter:= WideFormat(WS_WAVFILTER,
          [Translator.GetMessage('160'), Translator.GetMessage('27')],FSGlobal);
  dlg_Open.Options:= dlg_Open.Options - [ofAllowMultiSelect];
  dlg_Open.Title:= Translator.GetMessage('161');
  if (dlg_Open.Execute) then
    e_Sound.Text:= dlg_Open.FileName;
end;

procedure Tform_Options.b_CancelClick(Sender: TObject);
begin
  Close();
end;

procedure Tform_Options.b_OKClick(Sender: TObject);
begin
  if (ValidateInput()) then
  begin
    SaveSettings();
    Tag:= INT_MODALRESULTOK;
    Close();
  end;
end;

procedure Tform_Options.b_SInstallClick(Sender: TObject);
var
  ID, Password: WideString;
  Logon: Tform_Logon;
  Work, ASystem: boolean;
  PId, PPassword: PWideChar;
  AppHandle: THandle;
begin
  if (not CobIsAdminW()) then
  begin
    CobShowMessageW(Self.Handle, Translator.GetMessage('511'),WS_PROGRAMNAMESHORT);
    Exit;
  end;

  PID:= nil;
  PPassword:= nil;
  Work:= false;

  Logon:= Tform_Logon.Create(nil);
  try
    Logon.ShowModal();
    if (Logon.Tag = INT_MODALRESULTOK) then
    begin
      Work:= true;
      ID:= Logon.e_ID.Text;
      Password:= Logon.e_Password.Text;
      ASystem:= Logon.rb_System.Checked;

      if (ASystem) then
      begin
        PID:= nil;
        PPassword:= nil;
      end else
      begin
        if (Length(ID) > 0) then
          if (CobPosW(WC_BACKSLASH,ID, true) = INT_NIL) then
            ID:= WS_DOMAINPRE + ID;
        PID:= PWideChar(ID);
        PPassword:= PWideChar(Password);
        AssignSpecialPrivilege(ID);
      end;
    end;
  finally
    Logon.Release();
  end;
  
  if (not Work) then
    Exit;

  Screen.Cursor:= crHourGlass;
  try
    // Close the application if running
    AppHandle:= IsAppRuning();
    if (AppHandle <> 0) then
    begin
        if (CobMessageBoxW(Self.Handle, Translator.GetMessage('517'),
                         WS_PROGRAMNAMESHORT, MB_YESNO) = mrNo) then
        Exit else
        begin
          PostMessageW(AppHandle, WM_CLOSE, 0, 0);
          // give it some sleep
          Sleep(INT_SERVICEOP);
        end;
    end;
    InstallService(PID, PPassword);
    // give it some sleep
    Sleep(INT_SERVICEOP);
    if (not IsServiceRunning()) then
    begin
      StartService();
      // give it some sleep
      Sleep(INT_SERVICEOP);
    end;

    cb_Autostart.ItemIndex:= 0;
    cb_AutostartInterface.Checked:= true;
    ApplyAutoStart();
  finally
    Screen.Cursor:= crDefault;
    CheckUIAutostart();
  end;
end;

procedure Tform_Options.b_SLogonClick(Sender: TObject);
var
  Logon: Tform_Logon;
  ID, Password: WideString;
  Work, ASystem: boolean;
  PID, PPassword: PWideChar;
begin
  if (not CobIsAdminW()) then
  begin
    CobShowMessageW(Self.Handle, Translator.GetMessage('511'),WS_PROGRAMNAMESHORT);
    Exit;
  end;

  Work:= false;
  PID:= nil;
  PPassword:= nil;

  Logon:= Tform_Logon.Create(nil);
  try
    Logon.ShowModal();
    if (Logon.Tag = INT_MODALRESULTOK) then
    begin
      Work:= true;
      ID:= Logon.e_ID.Text;
      Password:= Logon.e_Password.Text;
      ASystem:= Logon.rb_System.Checked;

      if (ASystem) then
      begin
        PID:= nil;
        PPassword:= nil;
      end else
      begin
        if (Length(ID) > 0) then
          if (CobPosW(WC_BACKSLASH,ID, true) = INT_NIL) then
            ID:= WS_DOMAINPRE + ID;
        PID:= PWideChar(ID);
        PPassword:= PWideChar(Password);
        AssignSpecialPrivilege(ID);
      end;
    end;
  finally
    Logon.Release();
  end;

  if (not Work) then
    Exit;

  Screen.Cursor:= crHourGlass;
  try
    if (IsServiceRunning()) then
    begin
      StopService();
      // give it some sleep
      Sleep(INT_SERVICEOP);
    end;
    UninstallService();
    // give it some sleep
    Sleep(INT_SERVICEOP);
    InstallService(PID, PPassword);
    // give it some sleep
    Sleep(INT_SERVICEOP);
    if (not IsServiceRunning()) then
    begin
      StartService();
      // give it some sleep
      Sleep(INT_SERVICEOP);
    end;
  finally
    Screen.Cursor:= crDefault;
    CheckUIAutostart();
  end;
end;

procedure Tform_Options.b_SMTPAddClick(Sender: TObject);
var
  Address: WideString;
begin
  if (InputQueryW(WS_PROGRAMNAMESHORT, Translator.GetMessage('143'),false,Address)) then
    if (Trim(Address) <> WS_NIL) then
    begin
      lb_SMTPTo.Items.Add(Address);
      CheckUISMTP();
    end;
end;

procedure Tform_Options.b_SMTPDeleteClick(Sender: TObject);
var
  i: integer;
begin
  if (lb_SMTPTo.SelCount > 0) then
    if (CobMessageBoxW(self.Handle, Translator.GetMessage('144'),
        WS_PROGRAMNAMESHORT, MB_YESNO) = MRYES) then
    begin
      for i:= lb_SMTPTo.Items.Count-1 downto 0 do
        if (lb_SMTPTo.Selected[i]) then
          lb_SMTPTo.Items.Delete(i);
      CheckUISMTP();
    end;
end;

procedure Tform_Options.b_SMTPEditClick(Sender: TObject);
var
  i: integer;
  Address: WideString;
begin
  if (lb_SMTPTo.SelCount > 0) then
  begin
    for i:= 0 to lb_SMTPTo.Items.Count - 1 do
      if (lb_SMTPTo.Selected[i]) then
      begin
        Address:= lb_SMTPTo.Items[i];
        if (InputQueryW(WS_PROGRAMNAMESHORT, Translator.GetMessage('143'),false,Address)) then
          if (Trim(Address) <> WS_NIL) then
            lb_SMTPTo.Items[i]:= Address;
      end;
    CheckUISMTP();
  end;
end;

procedure Tform_Options.b_SMTPTestClick(Sender: TObject);
var
  Sl: TTntStringList;
  Tester: Tform_Tester;
begin
  Sl:= TTntStringList.Create();
  Tester:= Tform_Tester.Create(nil);
  try
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INISMTPSENDER,e_SMTPSenderName.Text],FSGlobal));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INISMTPSENDERADDRESS,e_SMTPSendersAddress.Text],FSGlobal));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INISMTPHOST, e_SMTPServerHost.Text], FSGlobal));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INISMTPPORT, e_SMTPPort.Text], FSGlobal));  // Send it as TEXT
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INISMTPDESTINATION,lb_SMTPTo.Items.CommaText],FSGlobal));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INISMTPAUTHENTICATION, CobBoolToStrW(cb_SMTPLogOn.Checked)],FSGlobal));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INISMTPID, e_SMTPID.Text],FSGlobal));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INISMTPPASSWORD, e_SMTPPassword.Text],FSGlobal));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INISMTPPIPELINE,CobBoolToStrW(cb_SMTPPipeLine.Checked)], FSGlobal));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INISMTPEHLO,CobBoolToStrW(cb_SMTPUseEhlo.Checked)],FSGlobal));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INISMTPHELONAME, e_SMTPHeloName.Text],FSGlobal));
    Tester.Operation:= INT_OPTESTSMTP;
    Tester.STMPSettings:= Sl.CommaText;
    Tester.ShowModal();
  finally
    Tester.Release();
    FreeAndNil(Sl);
  end;
end;

procedure Tform_Options.b_SStartClick(Sender: TObject);
begin
  if (not CobIsAdminW()) then
  begin
    CobShowMessageW(Self.Handle, Translator.GetMessage('511'),WS_PROGRAMNAMESHORT);
    Exit;
  end;

  Screen.Cursor:= crHourGlass;
  try
    StartService();
    // give it some sleep
    Sleep(INT_SERVICEOP);
  finally
    Screen.Cursor:= crDefault;
    CheckUIAutostart();
  end;
end;

procedure Tform_Options.b_SStopClick(Sender: TObject);
begin
  if (not CobIsAdminW()) then
  begin
    CobShowMessageW(Self.Handle, Translator.GetMessage('511'),WS_PROGRAMNAMESHORT);
    Exit;
  end;

  Screen.Cursor:= crHourGlass;
  try
    StopService();
    // give it some sleep
    Sleep(INT_SERVICEOP);
  finally
    Screen.Cursor:= crDefault;
    CheckUIAutostart();
  end;
end;

procedure Tform_Options.b_SUninstallClick(Sender: TObject);
begin
  if (not CobIsAdminW()) then
  begin
    CobShowMessageW(Self.Handle, Translator.GetMessage('511'),WS_PROGRAMNAMESHORT);
    Exit;
  end;

  if (CobMessageBoxW(self.Handle, Translator.GetMessage('518'),
                    WS_PROGRAMNAMESHORT, MB_YESNO) <> mrYes) then

    Exit;

  Screen.Cursor:= crHourGlass;
  try
    if (IsServiceRunning()) then
    begin
      StopService();
      // give it some sleep
      Sleep(INT_SERVICEOP);
    end;
    UninstallService();
    // give it some sleep
    Sleep(INT_SERVICEOP);
    cb_AutostartInterface.Checked:= false;
    cb_Autostart.ItemIndex:= INT_AUTOSTARTALL;
    ApplyAutoStart();

    if (CobMessageBoxW(self.Handle, Translator.GetMessage('519'),
                    WS_PROGRAMNAMESHORT, MB_YESNO) = mrYes) then
    begin
      ShellExecuteW(0,'open', PWideChar(Globals.AppPath + WS_APPEXENAME),
                    PWideChar(WS_NOGUIALT),nil,SW_SHOWNORMAL);
    end;
  finally
    Screen.Cursor:= crDefault;
    CheckUIAutostart();
  end;
end;

procedure Tform_Options.b_UncompressedAddClick(Sender: TObject);
var
  Ext: WideString;
begin
  if (InputQueryW(WS_PROGRAMNAMESHORT, Translator.GetMessage('493'),false,Ext)) then
    if (Trim(Ext) <> WS_NIL) then
    begin
      lb_Uncompressed.Items.Add(Ext);
      CheckUICompression();
    end;
end;

procedure Tform_Options.b_UncompressedDeleteClick(Sender: TObject);
var
  i: integer;
begin
  if (lb_Uncompressed.SelCount > 0) then
    if (CobMessageBoxW(self.Handle, Translator.GetMessage('495'),
        WS_PROGRAMNAMESHORT, MB_YESNO) = MRYES) then
    begin
      for i:= lb_Uncompressed.Items.Count-1 downto 0 do
        if (lb_Uncompressed.Selected[i]) then
          lb_Uncompressed.Items.Delete(i);
      CheckUICompression();
    end;
end;

procedure Tform_Options.b_UncompressedEditClick(Sender: TObject);
var
  i: integer;
  Ext: WideString;
begin
  if (lb_Uncompressed.SelCount > 0) then
  begin
    for i:= 0 to lb_Uncompressed.Items.Count - 1 do
      if (lb_Uncompressed.Selected[i]) then
      begin
        Ext:= lb_Uncompressed.Items[i];
        if (InputQueryW(WS_PROGRAMNAMESHORT, Translator.GetMessage('494'),false, Ext)) then
          if (Trim(Ext) <> WS_NIL) then
            lb_Uncompressed.Items[i]:= Ext;
      end;
    CheckUICompression();
  end;
end;

procedure Tform_Options.cb_LimitClick(Sender: TObject);
begin
  CheckUIFTP();
end;

procedure Tform_Options.cb_LogClick(Sender: TObject);
begin
  CheckUILog();
end;

procedure Tform_Options.cb_MailScheduledClick(Sender: TObject);
begin
  CheckUILog();
end;

procedure Tform_Options.cb_PlaySoundClick(Sender: TObject);
begin
  CheckUISound();
end;

procedure Tform_Options.cb_ProtectUIClick(Sender: TObject);
begin
  CheckUISecurity();
end;

procedure Tform_Options.cb_RunOldClick(Sender: TObject);
begin
  CheckUIFunctionality();
end;

procedure Tform_Options.CheckUI();
begin
  CheckUIAutostart();

  CheckUISecurity();

  CheckUILog();

  CheckUISMTP();

  CheckUIFTP();

  CheckUISound();

  CheckUICompression();

  CheckUIFunctionality();

  CheckHorizontalBar(lb_Options);
end;

procedure Tform_Options.CheckUIAutostart();
var
  IsRunning: boolean;
begin
  // to be sure, because the service can be stopped
  FIsService:= IsServiceInstalled();
  if (FIsService) then
    IsRunning:= IsServiceRunning() else
    IsRunning:= false;
  l_AutostartApp.Enabled:= not FIsService;
  cb_Autostart.Enabled:= not FIsService;
  //gb_Service.Enabled:= FIsService;
  cb_AutostartInterface.Enabled:= FIsService;
  b_SStart.Enabled:= FIsService and not IsRunning;
  b_SStop.Enabled:= FIsService and IsRunning;
  b_SInstall.Enabled:= not FIsService;
  b_SUninstall.Enabled:= FIsService;
  b_SLogon.Enabled:= FIsService;
  if (FIsService) then
    cb_Autostart.ItemIndex:= INT_AUTOSTARTNONE else
    cb_AutostartInterface.Checked:= false;
end;

procedure Tform_Options.CheckUICompression();
begin
  cb_SQXExternal.Enabled:= tb_SQXRecoveryData.Position > 0;
  b_UncompressedEdit.Enabled:= lb_Uncompressed.SelCount > 0;
  b_UncompressedDelete.Enabled:= lb_Uncompressed.SelCount > 0;

  CheckHorizontalBar(lb_Uncompressed);
end;

procedure Tform_Options.CheckUIFTP();
begin
  l_Speed.Enabled:= cb_Limit.Checked;
  e_Speed.Enabled:= cb_Limit.Checked;
  b_ASCIIEdit.Enabled:= (lb_ASCII.SelCount > 0);
  b_ASCIIDelete.Enabled:= (lb_ASCII.SelCount > 0);

  CheckHorizontalBar(lb_ASCII);
end;

procedure Tform_Options.CheckUIFunctionality();
begin
  cb_RunDontAsk.Enabled:= cb_RunOld.Checked;
end;

procedure Tform_Options.CheckUILog();
begin
  cb_LogErrorsOnly.Enabled:= cb_Log.Checked;
  cb_LogVerbose.Enabled:= cb_Log.Checked;
  cb_LogRealTime.Enabled:= cb_Log.Checked;
  cb_MailLog.Enabled:= cb_Log.Checked;
  cb_MailAfterBackup.Enabled:= cb_Log.Checked and cb_MailLog.Checked;
  cb_MailScheduled.Enabled:= cb_Log.Checked and cb_MailLog.Checked;
  cb_MailAsAttachment.Enabled:= cb_Log.Checked and cb_MailLog.Checked;
  cb_MailIfErrors.Enabled:= cb_Log.Checked and cb_MailLog.Checked;
  cb_DeleteOnMail.Enabled:= cb_Log.Checked and cb_MailLog.Checked;
  l_TimeToMail.Enabled:= cb_Log.Checked and cb_MailLog.Checked and cb_MailScheduled.Checked;
  dt_TimeToMail.Enabled:= cb_Log.Checked and cb_MailLog.Checked and cb_MailScheduled.Checked;
  l_CheckSMTP.Enabled:= cb_Log.Checked and cb_MailLog.Checked;
  l_SMTPActivate.Enabled:= not cb_MailLog.Checked;
  l_SMTPSenderName.Enabled:= cb_Log.Checked and cb_MailLog.Checked;
  e_SMTPSenderName.Enabled:= cb_Log.Checked and cb_MailLog.Checked;
  l_SMTPSenderAddress.Enabled:= cb_Log.Checked and cb_MailLog.Checked;
  e_SMTPSendersAddress.Enabled:= cb_Log.Checked and cb_MailLog.Checked;
  l_SMTPServerHost.Enabled:= cb_Log.Checked and cb_MailLog.Checked;
  e_SMTPServerHost.Enabled:= cb_Log.Checked and cb_MailLog.Checked;
  l_SMTPPort.Enabled:= cb_Log.Checked and cb_MailLog.Checked;
  e_SMTPPort.Enabled:= cb_Log.Checked and cb_MailLog.Checked;
  l_SMTPTo.Enabled:= cb_Log.Checked and cb_MailLog.Checked;
  lb_SMTPTo.Enabled:= cb_Log.Checked and cb_MailLog.Checked;
  l_SMTPSubject.Enabled:= cb_Log.Checked and cb_MailLog.Checked;
  e_SMTPSubject.Enabled:= cb_Log.Checked and cb_MailLog.Checked;
  b_SMTPAdd.Enabled:= cb_Log.Checked and cb_MailLog.Checked;
  b_SMTPEdit.Enabled:= cb_Log.Checked and cb_MailLog.Checked;
  b_SMTPDelete.Enabled:= cb_Log.Checked and cb_MailLog.Checked;
  cb_SMTPLogOn.Enabled:= cb_Log.Checked and cb_MailLog.Checked;
  l_SMTPID.Enabled:= cb_Log.Checked and cb_MailLog.Checked and cb_SMTPLogOn.Checked;
  e_SMTPID.Enabled:= cb_Log.Checked and cb_MailLog.Checked and cb_SMTPLogOn.Checked;
  l_SMTPPasssword.Enabled:= cb_Log.Checked and cb_MailLog.Checked and cb_SMTPLogOn.Checked;
  e_SMTPPassword.Enabled:= cb_Log.Checked and cb_MailLog.Checked and cb_SMTPLogOn.Checked;
  cb_SMTPPipeLine.Enabled:= cb_Log.Checked and cb_MailLog.Checked;
  cb_SMTPUseEhlo.Enabled:= cb_Log.Checked and cb_MailLog.Checked;
  l_SMTPHeloName.Enabled:= cb_Log.Checked and cb_MailLog.Checked;
  e_SMTPHeloName.Enabled:= cb_Log.Checked and cb_MailLog.Checked;
  b_SMTPTest.Enabled:= cb_Log.Checked and cb_MailLog.Checked;

  CheckHorizontalBar(lb_SMTPTo);
end;

procedure Tform_Options.CheckUISecurity();
begin
  cb_ProtectMainWindow.Enabled:= cb_ProtectUI.Checked;
  cb_ClearPasswordCache.Enabled:= cb_ProtectUI.Checked;
  l_Password.Enabled:= cb_ProtectUI.Checked;
  l_PasswordRe.Enabled:= cb_ProtectUI.Checked;
  e_Password.Enabled:= cb_ProtectUI.Checked;
  e_PasswordRe.Enabled:= cb_ProtectUI.Checked;
end;

procedure Tform_Options.CheckUISMTP;
begin
  b_SMTPEdit.Enabled:= lb_SMTPTo.SelCount > 0;
  b_SMTPDelete.Enabled:= lb_SMTPTo.SelCount > 0;

  CheckHorizontalBar(lb_SMTPTo);
end;

procedure Tform_Options.CheckUISound;
begin
  l_Sound.Enabled:= cb_PlaySound.Checked;
  e_Sound.Enabled:= cb_PlaySound.Checked;
  b_BrowseSound.Enabled:= cb_PlaySound.Checked;
end;

procedure Tform_Options.GetInterfaceText();
begin
  Caption:= Translator.GetInterfaceText('16');
  b_OK.Caption:= Translator.GetInterfaceText('B_OK');
  b_Cancel.Caption:= Translator.GetInterfaceText('B_CANCEL');
  lb_Options.Clear();
  lb_Options.Items.Add(Translator.GetInterfaceText('17'));
  lb_Options.Items.Add(Translator.GetInterfaceText('18'));
  lb_Options.Items.Add(Translator.GetInterfaceText('19'));
  lb_Options.Items.Add(Translator.GetInterfaceText('20'));
  lb_Options.Items.Add(Translator.GetInterfaceText('21'));
  lb_Options.Items.Add(Translator.GetInterfaceText('22'));
  lb_Options.Items.Add(Translator.GetInterfaceText('23'));
  lb_Options.Items.Add(Translator.GetInterfaceText('24'));
  lb_Options.Items.Add(Translator.GetInterfaceText('25'));
  lb_Options.Items.Add(Translator.GetInterfaceText('26'));
  gb_Autostart.Caption:= Translator.GetInterfaceText('27');
  l_AutostartApp.Caption:= Translator.GetInterfaceText('28');
  cb_Autostart.Hint:= Translator.GetInterfaceText('38');
  cb_Autostart.Items.Clear();
  cb_Autostart.Items.Add(Translator.GetInterfaceText('29'));
  cb_Autostart.Items.Add(Translator.GetInterfaceText('30'));
  cb_Autostart.Items.Add(Translator.GetInterfaceText('31'));
  cb_AutostartInterface.Caption:= Translator.GetInterfaceText('32');
  cb_AutostartInterface.Hint:= Translator.GetInterfaceText('39');
  cb_WarnInstances.Caption:= Translator.GetInterfaceText('33');
  cb_WarnInstances.Hint:= Translator.GetInterfaceText('40');
  l_Language.Caption:= Translator.GetInterfaceText('34');
  cb_Languages.Hint:= Translator.GetInterfaceText('41');
  cb_Log.Caption:= Translator.GetInterfaceText('35');
  cb_Log.Hint:= Translator.GetInterfaceText('42');
  cb_LogErrorsOnly.Caption:= Translator.GetInterfaceText('36');
  cb_LogErrorsOnly.Hint:= Translator.GetInterfaceText('43');
  cb_LogVerbose.Caption:= Translator.GetInterfaceText('37');
  cb_LogVerbose.Hint:= Translator.GetInterfaceText('44');
  cb_LogRealTime.Caption:= Translator.GetInterfaceText('45');
  cb_LogRealTime.Hint:= Translator.GetInterfaceText('46');
  l_Password.Caption:= Translator.GetInterfaceText('47');
  e_Password.Hint:= Translator.GetInterfaceText('48');
  l_PasswordRe.Caption:= Translator.GetInterfaceText('49');
  e_PasswordRe.Hint:= Translator.GetInterfaceText('50');
  cb_ProtectUI.Caption:= Translator.GetInterfaceText('51');
  cb_ProtectUI.Hint:= Translator.GetInterfaceText('52');
  cb_ProtectMainWindow.Caption:= Translator.GetInterfaceText('53');
  cb_ProtectMainWindow.Hint:= Translator.GetInterfaceText('54');
  cb_ClearPasswordCache.Caption:= Translator.GetInterfaceText('55');
  cb_ClearPasswordCache.Hint:= Translator.GetInterfaceText('56');
  cb_ShowWelcome.Caption:= Translator.GetInterfaceText('57');
  cb_ShowWelcome.Hint:= Translator.GetInterfaceText('58');
  cb_ShowHints.Caption:= Translator.GetInterfaceText('59');
  cb_ShowHints.Hint:= Translator.GetInterfaceText('60');
  cb_XPStyles.Caption:= Translator.GetInterfaceText('61');
  cb_XPStyles.Hint:= Translator.GetInterfaceText('62');
  p_FontUI.Caption:= Translator.GetInterfaceText('63');
  p_FontUI.Hint:= Translator.GetInterfaceText('64');
  p_FontLog.Caption:= Translator.GetInterfaceText('65');
  p_FontLog.Hint:= Translator.GetInterfaceText('66');
  cb_ConfrmClose.Caption:= Translator.GetInterfaceText('67');
  cb_ConfrmClose.Hint:= Translator.GetInterfaceText('68');
  l_HotKey.Caption:= Translator.GetInterfaceText('69');
  cb_HotKey.Items[0]:= Translator.GetInterfaceText('70'); //only the first item is translated
  cb_HotKey.Hint:= Translator.GetInterfaceText('71');
  cb_ShowIcons.Caption:= Translator.GetInterfaceText('72');
  cb_ShowIcons.Hint:= Translator.GetInterfaceText('73');
  cb_SaveAdvanced.Caption:= Translator.GetInterfaceText('202');
  cb_SaveAdvanced.Hint:= Translator.GetInterfaceText('203');
  cb_DeferenceLinks.Caption:= Translator.GetInterfaceText('249');
  cb_DeferenceLinks.Hint:= Translator.GetInterfaceText('250');
  cb_UNC.Caption:= Translator.GetInterfaceText('360');
  cb_UNC.Hint:= Translator.GetInterfaceText('361');
  pb_HintColor.Hint:= Translator.GetInterfaceText('375');
  l_HintPause.Caption:= Translator.GetInterfaceText('376');
  e_HintPause.Hint:= Translator.GetInterfaceText('377');
  cb_Calculate.Caption:= Translator.GetInterfaceText('378');
  cb_Calculate.Hint:= Translator.GetInterfaceText('379');
  cb_MailLog.Caption:= Translator.GetInterfaceText('380');
  cb_MailLog.Hint:= Translator.GetInterfaceText('381');
  cb_MailAfterbackup.Caption:= Translator.GetInterfaceText('382');
  cb_MailAfterbackup.Hint:= Translator.GetInterfaceText('383');
  cb_MailAsAttachment.Caption:= Translator.GetInterfaceText('384');
  cb_MailAsAttachment.Hint:= Translator.GetInterfaceText('385');
  cb_MailIfErrors.Caption:= Translator.GetInterfaceText('386');
  cb_MailIfErrors.Hint:= Translator.GetInterfaceText('387');
  cb_DeleteOnMail.Caption:= Translator.GetInterfaceText('388');
  cb_DeleteOnMail.Hint:= Translator.GetInterfaceText('389');
  l_TimeToMail.Caption:= Translator.GetInterfaceText('390');
  dt_TimeToMail.Hint:= Translator.GetInterfaceText('391');
  l_CheckSMTP.Caption:= Translator.GetInterfaceText('392');
  l_SMTPSenderName.Caption:= Translator.GetInterfaceText('393');
  e_SMTPSenderName.Hint:= Translator.GetInterfaceText('394');
  l_SMTPSenderAddress.Caption:= Translator.GetInterfaceText('395');
  e_SMTPSendersAddress.Hint:= Translator.GetInterfaceText('396');
  l_SMTPServerHost.Caption:= Translator.GetInterfaceText('397');
  e_SMTPServerHost.Hint:= Translator.GetInterfaceText('398');
  l_SMTPPort.Caption:= Translator.GetInterfaceText('399');
  e_SMTPPort.Hint:= Translator.GetInterfaceText('400');
  l_SMTPSubject.Caption:= Translator.GetInterfaceText('401');
  e_SMTPSubject.Hint:= Translator.GetInterfaceText('402');
  l_SMTPTo.Caption:= Translator.GetInterfaceText('403');
  lb_SMTPTo.Hint:= Translator.GetInterfaceText('404');
  cb_SMTPLogOn.Caption:= Translator.GetInterfaceText('405');
  cb_SMTPLogOn.Hint:= Translator.GetInterfaceText('406');
  b_SMTPAdd.Caption:= Translator.GetInterfaceText('407');
  b_SMTPAdd.Hint:= Translator.GetInterfaceText('408');
  b_SMTPEdit.Caption:= Translator.GetInterfaceText('409');
  b_SMTPEdit.Hint:= Translator.GetInterfaceText('410');
  b_SMTPDelete.Caption:= Translator.GetInterfaceText('411');
  b_SMTPDelete.Hint:= Translator.GetInterfaceText('412');
  l_SMTPID.Caption:= Translator.GetInterfaceText('413');
  e_SMTPID.Hint:= Translator.GetInterfaceText('414');
  l_SMTPPasssword.Caption:= Translator.GetInterfaceText('415');
  e_SMTPPassword.Hint:= Translator.GetInterfaceText('416');
  cb_SMTPPipeLine.Caption:= Translator.GetInterfaceText('417');
  cb_SMTPPipeLine.Hint:= Translator.GetInterfaceText('418');
  cb_SMTPUseEhlo.Caption:= Translator.GetInterfaceText('419');
  cb_SMTPUseEhlo.Hint:= Translator.GetInterfaceText('420');
  l_SMTPHeloName.Caption:= Translator.GetInterfaceText('421');
  e_SMTPHeloName.Hint:= Translator.GetInterfaceText('422');
  b_SMTPTest.Caption:= Translator.GetInterfaceText('423');
  b_SMTPTest.Hint:= Translator.GetInterfaceText('424');
  l_SMTPActivate.Caption:= Translator.GetInterfaceText('425');
  l_TCPRead.Caption:= Translator.GetInterfaceText('426');
  e_TCPRead.Hint:= Translator.GetInterfaceText('427');
  l_TCPConnection.Caption:= Translator.GetInterfaceText('428');
  e_TCPConnection.Hint:= Translator.GetInterfaceText('429');
  l_Temp.Caption:= Translator.GetInterfaceText('430');
  e_Temp.Hint:= Translator.GetInterfaceText('431');
  b_Browse.Hint:= Translator.GetInterfaceText('182');
  cb_ShowBackupHint.Caption:= Translator.GetInterfaceText('432');
  cb_ShowBackupHint.Hint:= Translator.GetInterfaceText('433');
  cb_ShowDialogEnd.Caption:= Translator.GetInterfaceText('434');
  cb_ShowDialogEnd.Hint:= Translator.GetInterfaceText('435');
  cb_PlaySound.Caption:= Translator.GetInterfaceText('436');
  cb_PlaySound.Hint:= Translator.GetInterfaceText('437');
  l_Sound.Caption:= Translator.GetInterfaceText('438');
  e_Sound.Hint:= Translator.GetInterfaceText('439');
  b_BrowseSound.Hint:= Translator.GetInterfaceText('182');
  cb_ShowPercent.Caption:= Translator.GetInterfaceText('440');
  cb_ShowPercent.Hint:= Translator.GetInterfaceText('441');
  cb_ShowExactPercent.Caption:= Translator.GetInterfaceText('442');
  cb_ShowExactPercent.Hint:= Translator.GetInterfaceText('443');
  cb_UseCurrentDesktop.Caption:= Translator.GetInterfaceText('444');
  cb_UseCurrentDesktop.Hint:= Translator.GetInterfaceText('445');
  cb_ForceFirstFull.Caption:= Translator.GetInterfaceText('447');
  cb_ForceFirstFull.Hint:= Translator.GetInterfaceText('448');
  l_DTFormat.Caption:= Translator.GetInterfaceText('449');
  e_DTFormat.Hint:= Translator.GetInterfaceText('450');
  cb_DoNotSeparateDate.Caption:= Translator.GetInterfaceText('451');
  cb_DoNotSeparateDate.Hint:= Translator.GetInterfaceText('452');
  cb_DoNotUseSpaces.Caption:= Translator.GetInterfaceText('453');
  cb_DoNotUseSpaces.Hint:= Translator.GetInterfaceText('454');
  cb_UseAlternativeMethods.Caption:= Translator.GetInterfaceText('455');
  cb_UseAlternativeMethods.Hint:= Translator.GetInterfaceText('456');
  cb_UseShell.Caption:= Translator.GetInterfaceText('457');
  cb_UseShell.Hint:= Translator.GetInterfaceText('458');
  cb_LowPriority.Caption:= Translator.GetInterfaceText('459');
  cb_LowPriority.Hint:= Translator.GetInterfaceText('460');
  l_CopyBuffer.Caption:= Translator.GetInterfaceText('462');
  e_CopyBuffer.Hint:= Translator.GetInterfaceText('463');
  cb_CheckCRCNoComp.Caption:= Translator.GetInterfaceText('464');
  cb_CheckCRCNoComp.Hint:= Translator.GetInterfaceText('465');
  cb_CopyAttributes.Caption:= Translator.GetInterfaceText('466');
  cb_CopyAttributes.Hint:= Translator.GetInterfaceText('467');
  cb_CopyTimeStamps.Caption:= Translator.GetInterfaceText('468');
  cb_CopyTimeStamps.Hint:= Translator.GetInterfaceText('469');
  cb_CopyNTFS.Caption:= Translator.GetInterfaceText('470');
  cb_CopyNTFS.Hint:= Translator.GetInterfaceText('471');
  cb_ParkFirst.Caption:= Translator.GetInterfaceText('472');
  cb_ParkFirst.Hint:= Translator.GetInterfaceText('473');
  cb_DeleteEmpty.Caption:= Translator.GetInterfaceText('474');
  cb_DeleteEmpty.Hint:= Translator.GetInterfaceText('475');
  cb_AlwaysCreate.Caption:= Translator.GetInterfaceText('476');
  cb_AlwaysCreate.Hint:= Translator.GetInterfaceText('477');
  cb_ClearLogTab.Caption:= Translator.GetInterfaceText('478');
  cb_ClearLogTab.Hint:= Translator.GetInterfaceText('479');
  gb_Compression.Caption:= Translator.GetInterfaceText('511');
  cb_CompressionAbsolute.Caption:= Translator.GetInterfaceText('512');
  cb_CompressionAbsolute.Hint:= Translator.GetInterfaceText('513');
  gb_Zip.Caption:= Translator.GetInterfaceText('514');
  l_ZipLevel.Caption:= WideFormat(Translator.GetInterfaceText('515'),
                                              [tb_ZipLevel.Position],FSGlobal);
  tb_ZipLevel.Hint:= Translator.GetInterfaceText('516');
  cb_CompTaskName.Caption:= Translator.GetInterfaceText('517');
  cb_CompTaskName.Hint:= Translator.GetInterfaceText('518');
  cb_CompCRC.Caption:= Translator.GetInterfaceText('519');
  cb_CompCRC.Hint:= Translator.GetInterfaceText('520');
  cb_ZipAdvancedNaming.Caption:= Translator.GetInterfaceText('521');
  cb_ZipAdvancedNaming.Hint:= Translator.GetInterfaceText('522');
  cb_CompOEM.Caption:= Translator.GetInterfaceText('523');
  cb_CompOEM.Hint:= Translator.GetInterfaceText('524');
  l_Zip64.Caption:= Translator.GetInterfaceText('525');
  cb_Zip64.Clear();
  cb_Zip64.Items.Add(Translator.GetInterfaceText('526'));
  cb_Zip64.Items.Add(Translator.GetInterfaceText('527'));
  cb_Zip64.Items.Add(Translator.GetInterfaceText('528'));
  cb_Zip64.Hint:= Translator.GetInterfaceText('529');
  l_NonCompressed.Caption:= Translator.GetInterfaceText('530');
  lb_Uncompressed.Hint:= Translator.GetInterfaceText('531');
  gb_Sqx.Caption:= Translator.GetInterfaceText('532');
  l_SQXDictionary.Caption:= Translator.GetInterfaceText('533');
  cb_SQXDictionary.Hint:= Translator.GetInterfaceText('534');
  l_SQXCompression.Caption:= Translator.GetInterfaceText('535');
  cb_SQXLevel.Clear();
  cb_SQXLevel.Items.Add(Translator.GetInterfaceText('536'));
  cb_SQXLevel.Items.Add(Translator.GetInterfaceText('537'));
  cb_SQXLevel.Items.Add(Translator.GetInterfaceText('538'));
  cb_SQXLevel.Items.Add(Translator.GetInterfaceText('539'));
  l_SQLRecovery.Caption:= WideFormat(Translator.GetInterfaceText('540'),
                                              [tb_SQXRecoveryData.Position],FSGlobal);
  cb_SQXLevel.Hint:= Translator.GetInterfaceText('541');
  tb_SQXRecoveryData.Hint:= Translator.GetInterfaceText('542');
  cb_SQXSolidArchives.Caption:= Translator.GetInterfaceText('543');
  cb_SQXSolidArchives.Hint:= Translator.GetInterfaceText('544');
  cb_SQXExternal.Caption:= Translator.GetInterfaceText('545');
  cb_SQXExternal.Hint:= Translator.GetInterfaceText('546');
  cb_SQXExe.Caption:= Translator.GetInterfaceText('547');
  cb_SQXExe.Hint:= Translator.GetInterfaceText('548');
  cb_SQXMultimedia.Caption:= Translator.GetInterfaceText('549');
  cb_SQXMultimedia.Hint:= Translator.GetInterfaceText('550');
  cb_Limit.Caption:= Translator.GetInterfaceText('551');
  cb_Limit.Hint:= Translator.GetInterfaceText('552');
  l_Speed.Caption:= Translator.GetInterfaceText('553');
  e_Speed.Hint:= Translator.GetInterfaceText('554');
  l_ASCII.Caption:= Translator.GetInterfaceText('555');
  lb_ASCII.Hint:= Translator.GetInterfaceText('556');
  cb_ConfirmRun.Caption:= Translator.GetInterfaceText('564');
  cb_ConfirmRun.Hint:= Translator.GetInterfaceText('565');
  cb_ConfirmAbort.Caption:= Translator.GetInterfaceText('566');
  cb_ConfirmAbort.Hint:= Translator.GetInterfaceText('567');
  cb_ForceInternalHelp.Caption:= Translator.GetInterfaceText('582');
  cb_ForceInternalHelp.Hint:= Translator.GetInterfaceText('583');
  cb_NavigateInternally.Caption:= Translator.GetInterfaceText('584');
  cb_NavigateInternally.Hint:= Translator.GetInterfaceText('585');
  b_ASCIIAdd.Caption:= Translator.GetInterfaceText('109');
  b_ASCIIAdd.Hint:= Translator.GetInterfaceText('610');
  b_ASCIIEdit.Caption:= Translator.GetInterfaceText('111');
  b_ASCIIEdit.Hint:= Translator.GetInterfaceText('611');
  b_ASCIIDelete.Caption:= Translator.GetInterfaceText('113');
  b_ASCIIDelete.Hint:= Translator.GetInterfaceText('612');
  b_UncompressedAdd.Caption:= Translator.GetInterfaceText('109');
  b_UncompressedAdd.Hint:= Translator.GetInterfaceText('610');
  b_UncompressedEdit.Caption:= Translator.GetInterfaceText('111');
  b_UncompressedEdit.Hint:= Translator.GetInterfaceText('611');
  b_UncompressedDelete.Caption:= Translator.GetInterfaceText('113');
  b_UncompressedDelete.Hint:= Translator.GetInterfaceText('612');
  cb_ShutdownKill.Caption:= Translator.GetInterfaceText('615');
  cb_ShutdownKill.Hint:= Translator.GetInterfaceText('616');
  cb_Autocheck.Caption:= Translator.GetInterfaceText('628');
  cb_Autocheck.Hint:= Translator.GetInterfaceText('629');
  cb_RunOld.Caption:= Translator.GetInterfaceText('630');
  cb_RunOld.Hint:= Translator.GetInterfaceText('631');
  cb_RunDontAsk.Caption:= Translator.GetInterfaceText('632');
  cb_RunDontAsk.Hint:= Translator.GetInterfaceText('633');
  gb_Service.Caption:= Translator.GetInterfaceText('634');
  b_SStart.Caption:= Translator.GetInterfaceText('635');
  b_SStart.Hint:= Translator.GetInterfaceText('636');
  b_SStop.Caption:= Translator.GetInterfaceText('637');
  b_SStop.Hint:= Translator.GetInterfaceText('638');
  b_SInstall.Caption:= Translator.GetInterfaceText('639');
  b_SInstall.Hint:= Translator.GetInterfaceText('640');
  b_SUninstall.Caption:= Translator.GetInterfaceText('641');
  b_SUninstall.Hint:= Translator.GetInterfaceText('642');
  b_SLogon.Caption:= Translator.GetInterfaceText('643');
  b_SLogon.Hint:= Translator.GetInterfaceText('644');
  cb_AutoLog.Caption:= Translator.GetInterfaceText('691');
  cb_AutoLog.Hint:= Translator.GetInterfaceText('692');
  cb_MailScheduled.Caption:= Translator.GetInterfaceText('720');
  cb_MailScheduled.Hint:= Translator.GetInterfaceText('721');
  cb_PropagateMasks.Caption:= Translator.GetInterfaceText('725');
  cb_PropagateMasks.Hint:= Translator.GetInterfaceText('726');
  cb_ShowGrid.Caption:= Translator.GetInterfaceText('728');
  cb_ShowGrid.Hint:= Translator.GetInterfaceText('729');
end;

function Tform_Options.InstallService(const ID, Password: PWideChar): boolean;
var
  AHandle: THandle;
  Dll: WideString;
  DisplayName: WideString;
  Error: cardinal;
  Install: function (const ServiceName, DisplayName, Binary, ID, Password: PWideChar): cardinal; stdcall;
begin
  Result:= false;
  Dll:= Globals.AppPath + WS_COBNTW;
  if (WideFileExists(Dll)) then
  begin
    AHandle:= LoadLibraryW(PWideChar(Dll));
    if (AHandle <> 0) then
    begin
      @Install:= GetProcAddress(AHandle, PAnsiChar(S_SERVICEINSTALLFN));
      if (@Install <> nil) then
      begin
        DisplayName:= WideFormat(Translator.GetMessage('515'),[WS_PROGRAMNAMESHORT],FSGlobal);
        Error:=  Install(PWideChar(WS_SERVICENAME),
                    PWideChar(DisplayName),
                    PWideChar(Globals.AppPath + WS_SERVICEEXENAME),
                    ID, Password);
        if (Error = INT_SERVICEINSTALLED) then
          Result:= true else
          begin
            CobShowMessageW(self.Handle, WideFormat(Translator.GetMessage('516'),
                            [CobSysErrorMessageW(Error)],FSGlobal),WS_PROGRAMNAMESHORT);
          end;
        
      end;
      FreeLibrary(AHandle);
    end;
  end;
end;

function Tform_Options.IsServiceInstalled(): boolean;
var
  AHandle: THandle;
  Dll: WideString;
  ServiceInstalled: function (const ServiceName: PWideChar): cardinal; stdcall;
begin
  Result:= false;
  Dll:= Globals.AppPath + WS_COBNTW;
  if (WideFileExists(Dll)) then
  begin
    AHandle:= LoadLibraryW(PWideChar(Dll));
    if (AHandle <> 0) then
    begin
      @ServiceInstalled:= GetProcAddress(AHandle, PAnsiChar(S_SERVICEINSTALLEDFN));
      if (@ServiceInstalled <> nil) then
      begin
        if (ServiceInstalled(PWideChar(WS_SERVICENAME)) = INT_SERVICEINSTALLED) then
          Result:= true;
      end;
      FreeLibrary(AHandle);
    end;
  end;
end;

function Tform_Options.IsServiceRunning(): boolean;
var
  AHandle: THandle;
  Dll: WideString;
  ServiceRunning: function (const ServiceName: PWideChar): cardinal; stdcall;
begin
  Result:= false;
  Dll:= Globals.AppPath + WS_COBNTW;
  if (WideFileExists(Dll)) then
  begin
    AHandle:= LoadLibraryW(PWideChar(Dll));
    if (AHandle <> 0) then
    begin
      @ServiceRunning:= GetProcAddress(AHandle, PAnsiChar(S_SERVICERUNNINGFN));
      if (@ServiceRunning <> nil) then
      begin
        if (ServiceRunning(PWideChar(WS_SERVICENAME)) = INT_SERVICERUNNING) then
          Result:= true;
      end;
      FreeLibrary(AHandle);
    end;
  end;
end;

function Tform_Options.IsXPStyle: boolean;
var
  Manifest: WideString;
begin
  Manifest:= WS_GUIEXENAME + WS_MANIFESTEXT;
  FXPStyle:=  WideFileExists(Globals.AppPath + Manifest);
  Result:= FXPStyle;
end;

procedure Tform_Options.lb_ASCIIClick(Sender: TObject);
begin
  CheckUIFTP();
end;

procedure Tform_Options.lb_OptionsClick(Sender: TObject);
begin
  if (lb_Options.ItemIndex <> -1) then
    pc_Options.ActivePageIndex:= lb_Options.ItemIndex;
end;

procedure Tform_Options.lb_OptionsDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  Bitmap: Graphics.TBitmap;
  Offset: Integer;
begin
  with (Control as TTntListBox).Canvas do
  begin
    Brush.Style := bsSolid;
    if odSelected in State then
      Brush.Color := RGB(INT_R, INT_G, INT_B)
    else
      Brush.Color := clWindow;

    FillRect(Rect);
    Offset := INT_ICONOFFSET;

    if (FShowIcons) then
    begin
      BitMap := Graphics.TBitmap.Create();
      try
        Bitmap.Width := INT_LBHEIGHT;
        Bitmap.Height := INT_LBHEIGHT;

        if (Control = lb_SMTPTo) then
          il_Options.GetBitmap(INT_INDEXMAIL, Bitmap) else
          il_Options.GetBitmap(Index, Bitmap);
      
        if Bitmap <> nil then
        begin
          BrushCopy(Bounds(Rect.Left + INT_ICONOFFSET,
                            Rect.Top + INT_ICONOFFSET,
                            Bitmap.Width,
                            Bitmap.Height),
                    Bitmap,
                    Bounds(0, 0, Bitmap.Width, Bitmap.Height), clWhite);
          Offset := Bitmap.Width + 2 * INT_ICONOFFSET;
        end;
      finally
        Bitmap.Free;
      end;
    end;
    Font.Color := clWindowText;
    Rect.Left:= OffSet;
    DrawTextW(Handle,PWideChar((Control as TTntListBox).Items[Index]),
            Length((Control as TTntListBox).Items[Index]),
            Rect, DT_VCENTER or DT_LEFT or DT_SINGLELINE );
  end;
end;


procedure Tform_Options.lb_SMTPToClick(Sender: TObject);
begin
  CheckUILog
end;

procedure Tform_Options.lb_UncompressedClick(Sender: TObject);
begin
  CheckUICompression();
end;

procedure Tform_Options.LoadSettings();
begin
  CheckAutoStart();

  LoadWarningFlag();

  PopulateLanguages();

  // Global settings

  cb_Log.Checked:= Settings.GetLog();
  cb_LogErrorsOnly.Checked:= Settings.GetLogErrorsOnly();
  cb_LogVerbose.Checked:= Settings.GetLogVerbose();
  cb_LogRealTime.Checked:= Settings.GetLogRealTime();
  e_Password.Text:= Settings.GetPassword();
  e_PasswordRe.Text:= e_Password.Text;
  cb_ProtectUI.Checked:= Settings.GetProtectUI();
  cb_ProtectMainWindow.Checked:= Settings.GetProtectMainWindow();
  cb_ClearPasswordCache.Checked:= Settings.GetClearPasswordCache();
  cb_MailLog.Checked:= Settings.GetMailLog();
  cb_MailAfterBackup.Checked:= Settings.GetMailAfterBackup();
  cb_MailAsAttachment.Checked:= Settings.GetMailAsAttachment();
  cb_MailIfErrors.Checked:= Settings.GetMailIfErrorsOnly();
  cb_DeleteOnMail.Checked:= Settings.GetMailDelete();
  dt_TimeToMail.DateTime:= Settings.GetMailDateTime();
  e_SMTPSenderName.Text:= Settings.GetSMTPSender();
  e_SMTPSendersAddress.Text:= Settings.GetSMTPSenderAddress();
  e_SMTPServerHost.Text:= Settings.GetSMTPHost();
  e_SMTPPort.Text:= CobIntToStrW(Settings.GetSMTPPort());
  e_SMTPSubject.Text:= Settings.GetSMTPSubject();
  lb_SMTPTo.Items.CommaText:= Settings.GetSMTPDestination();
  cb_SMTPLogOn.Checked:= (Settings.GetSMTPAuthentication() <> INT_SMTPNOLOGON);
  e_SMTPID.Text:= Settings.GetSMTPID();
  e_SMTPPassword.Text:= Settings.GetSMTPPassword();
  e_SMTPHeloName.Text:= Settings.GetSMTPHelo();
  cb_SMTPPipeLine.Checked:= Settings.GetSMTPPipeLine();
  cb_SMTPUseEhlo.Checked:= Settings.GetSMTPEhlo();
  e_TCPRead.Text:= CobIntToStrW(Settings.GetTCPReadTimeOut());
  e_TCPConnection.Text:= CobIntToStrW(Settings.GetTCPConnectionTimeOut());
  e_Temp.Text:= Settings.GetTemp();
  cb_ShowExactPercent.Checked:= Settings.GetShowExactPercent();
  cb_UseCurrentDesktop.Checked:= Settings.GetUseCurrentDesktop();
  cb_ForceFirstFull.Checked:= Settings.GetForceFirstFull();
  e_DTFormat.Text:= Settings.GetDateTimeFormat();
  cb_DoNotSeparateDate.Checked:= Settings.GetDoNotSeparateDate();
  cb_DoNotUseSpaces.Checked:= Settings.GetDoNotUseSpaces();
  cb_UseShell.Checked:= Settings.GetUseShellFunctionOnly();
  cb_UseAlternativeMethods.Checked:= Settings.GetUseAlternativeMethods();
  cb_LowPriority.Checked:= Settings.GetLowPriority();
  e_CopyBuffer.Text:= CobIntToStrW(Settings.GetCopyBuffer());
  cb_CheckCRCNoComp.Checked:= Settings.GetCheckCRCNoComp();
  cb_CopyAttributes.Checked:= Settings.GetCopyAttributes();
  cb_CopyTimeStamps.Checked:= Settings.GetCopyTimeStamps();
  cb_CopyNTFS.Checked:= Settings.GetCopyNTFSPermissions();
  cb_ParkFirst.Checked:= Settings.GetParkFirstBackup();
  cb_DeleteEmpty.Checked:= Settings.GetDeleteEmptyFolders();
  cb_AlwaysCreate.Checked:= Settings.GetAlwaysCreateFolder();
  cb_CompressionAbsolute.Checked:= Settings.GetCompAbsolute();
  tb_ZipLevel.Position:= Settings.GetZipLevel();
  tb_ZipLevelChange(self);
  cb_CompTaskName.Checked:= Settings.GetCompUseTaskName();
  cb_CompCRC.Checked:= Settings.GetCompCRC();
  cb_ZipAdvancedNaming.Checked:= Settings.GetZipAdvancedNaming();
  cb_CompOEM.Checked:= Settings.GetCompOEM();
  cb_Zip64.ItemIndex:= Settings.GetZip64();
  lb_Uncompressed.Items.CommaText:= Settings.GetUncompressed();
  cb_SQXDictionary.ItemIndex:= Settings.GetSQXDictionary();
  cb_SQXLevel.ItemIndex:= Settings.GetSQXLevel();
  tb_SQXRecoveryData.Position:= Settings.GetSQXRecovery();
  cb_SQXSolidArchives.Checked:= Settings.GetSQXSolid();
  cb_SQXExe.Checked:= Settings.GetSQXExe();
  cb_SQXExternal.Checked:= Settings.GetSQXExternal();
  cb_SQXMultimedia.Checked:= Settings.GetSQXMultimedia();
  cb_Limit.Checked:= Settings.GetFTPSpeedLimit();
  e_Speed.Text:= CobIntToStrW(Settings.GetFTPSpeed());
  lb_ASCII.Items.CommaText:= Settings.GetFTPASCII();
  cb_ShutdownKill.Checked:= Settings.GetShutdownKill();
  cb_Autocheck.Checked:= Settings.GetAutoUpdate();
  cb_RunOld.Checked:= Settings.GetRunOldBackups();
  cb_RunDontAsk.Checked:= Settings.GetRunOldDontAsk();
  cb_MailScheduled.Checked:= Settings.GetMailScheduled();
  cb_PropagateMasks.Checked:= Settings.GetPropagateMasks();

  // User settings
  cb_ShowWelcome.Checked:= UISettings.ShowWelcomeScreen;
  cb_ShowHints.Checked:= UISettings.ShowHints;
  cb_XPStyles.Checked:= IsXPStyle();
  p_FontUI.Font.Name:= UISettings.FontName;
  p_FontUI.Font.Size:= UISettings.FontSize;
  p_FontUI.Font.Charset:= UISettings.FontCharset;
  p_FontLog.Font.Name:= UISettings.FontNameLog;
  p_FontLog.Font.Size:= UISettings.FontSizeLog;
  p_FontLog.Font.Charset:= UISettings.FontCharsetLog;
  cb_ConfrmClose.Checked:= UISettings.ConfirmClose;
  cb_HotKey.ItemIndex:= UISettings.HotlKey;
  cb_ShowIcons.Checked:= UISettings.ShowIcons;
  cb_SaveAdvanced.Checked:= UISettings.SaveAdvancedSettings;
  cb_DeferenceLinks.Checked:= UISettings.DeferenceLinks;
  cb_UNC.Checked:= UISettings.ConvertToUNC;
  FHintColor:= UISettings.HintColor;
  e_HintPause.Text:= CobIntToStrW(UISettings.HintHide);
  cb_Calculate.Checked:= UISettings.CalculateSize;
  cb_ShowBackupHint.Checked:= UISettings.ShowBackupHints;
  cb_ShowDialogEnd.Checked:= UISettings.ShowDialogEnd;
  cb_PlaySound.Checked:= UISettings.PlaySound;
  e_Sound.Text:= UISettings.FileToPlay;
  cb_ShowPercent.Checked:= UISettings.ShowPercent;
  cb_ClearLogTab.Checked:= UISettings.ClearLogTab;
  cb_ConfirmRun.Checked:= UISettings.ConfirmRun;
  cb_ConfirmAbort.Checked:= UISettings.ConfirmAbort;
  cb_ForceInternalHelp.Checked:= UISettings.ForceInternalHelp;
  cb_NavigateInternally.Checked:= UISettings.NavigateInternally;
  cb_AutoLog.Checked:= UISettings.AutoShowLog;
  cb_ShowGrid.Checked:= UISettings.ShowGrid;
end;

procedure Tform_Options.PopulateLanguages();
var
  sr: TSearchRecW;
  fn, CurrentLanguage: WideString;
  i: integer;
begin
  fn:= Globals.LanguagesPath + WS_LANGUAGEMASK;
  cb_Languages.Clear();
  if (WideFindFirst(fn, faAnyFile , sr) = 0) then
    begin
      cb_Languages.Items.Add(WideUpperCase(WideChangeFileExt(sr.Name,WS_NOEXT)));
      while (WideFindNext(sr) = 0) do
        cb_Languages.Items.Add(WideUpperCase(WideChangeFileExt(sr.Name,WS_NOEXT)));
      WideFindClose(sr);
    end;

  CurrentLanguage:= WideUpperCase(Settings.GetLanguage());
  for i:=0 to cb_Languages.Items.Count - 1 do
    if (WideUppercase(CurrentLanguage) = WideUpperCase(cb_Languages.Items[i])) then
      begin
        cb_Languages.ItemIndex:= i;
        Break;
      end;
end;

procedure Tform_Options.p_FontLogClick(Sender: TObject);
begin
  dlg_Font.Font:= p_FontLog.Font;
  if (dlg_Font.Execute) then
    p_FontLog.Font:= dlg_Font.Font;
end;

procedure Tform_Options.p_FontUIClick(Sender: TObject);
begin
  dlg_Font.Font:= p_FontUI.Font;
  if (dlg_Font.Execute) then
    p_FontUI.Font:= dlg_Font.Font;
end;

procedure Tform_Options.SaveSettings();
begin
  ApplyAutoStart();

  SetWarningFlag();

  Settings.SetLanguage(cb_Languages.Items[cb_Languages.ItemIndex]);

  // Global settings

  Settings.SetLog(cb_Log.Checked);
  Settings.SetLogErrorsOnly(cb_LogErrorsOnly.Checked);
  Settings.SetLogVerbose(cb_LogVerbose.Checked);
  Settings.SetLogRealTime(cb_LogRealTime.Checked);
  Settings.SetPassword(e_Password.Text);
  Settings.SetProtectUI(cb_ProtectUI.Checked);
  Settings.SetProtectMainWindow(cb_ProtectMainWindow.Checked);
  Settings.SetClearPasswordCache(cb_ClearPasswordCache.Checked);
  Settings.SetMailLog(cb_MailLog.Checked);
  Settings.SetMailAfterBackup(cb_MailAfterBackup.Checked);
  Settings.SetMailAsAttachment(cb_MailAsAttachment.Checked);
  Settings.SetMailIfErrorsonly(cb_MailIfErrors.Checked);
  Settings.SetMailDelete(cb_DeleteOnMail.Checked);
  Settings.SetMailDateTime(dt_TimeToMail.DateTime);
  Settings.SetSMTPSender(e_SMTPSenderName.Text);
  Settings.SetSMTPSenderAddress(e_SMTPSendersAddress.Text);
  Settings.SetSMTPDestination(lb_SMTPTo.Items.CommaText);
  Settings.SetSMTPHost(e_SMTPServerHost.Text);
  Settings.SetSMTPPort(CobStrToIntW(e_SMTPPort.Text, INT_DEFFTPPORT));
  Settings.SetSMTPSubject(e_SMTPSubject.Text);
  Settings.SetSMTPAuthentication(Integer(cb_SMTPLogOn.Checked));
  Settings.SetSMTPID(e_SMTPID.Text);
  Settings.SetSMTPPassword(e_SMTPPassword.Text);
  Settings.SetSMTPHelo(e_SMTPHeloName.Text);
  Settings.SetSMTPPipeLine(cb_SMTPPipeLine.Checked);
  Settings.SetSMTPEhlo(cb_SMTPUseEhlo.Checked);
  Settings.SetTCPReadTimeOut(CobStrToIntW(e_TCPRead.Text, INT_TCPDEFAULTTIMEOUT));
  Settings.SetTCPConnectionTimeOut(CobStrToIntW(e_TCPConnection.Text, INT_TCPDEFAULTTIMEOUT));
  Settings.SetTemp(e_Temp.Text);
  Settings.SetShowExactPercent(cb_ShowExactPercent.Checked);
  Settings.SetUseCurrentDesktop(cb_UseCurrentDesktop.Checked);
  Settings.SetForceFirstFull(cb_ForceFirstFull.Checked);
  Settings.SetDateTimeFormat(e_DTFormat.Text);
  Settings.SetDoNotSeparateDate(cb_DoNotSeparateDate.Checked);
  Settings.SetDoNotUseSpaces(cb_DoNotUseSpaces.Checked);
  Settings.SetUseShellFunctionOnly(cb_UseShell.Checked);
  Settings.SetUseAlternativeMethods(cb_UseAlternativeMethods.Checked);
  Settings.SetLowPriority(cb_LowPriority.Checked);
  Settings.SetCopyBuffer(CobStrToIntW(e_CopyBuffer.Text,INT_COPYBUFFER));
  Settings.SetCheckCRCNoComp(cb_CheckCRCNoComp.Checked);
  Settings.SetCopyAttributes(cb_CopyAttributes.Checked);
  Settings.SetCopyTimeStamps(cb_CopyTimeStamps.Checked);
  Settings.SetCopyNTFSPermissions(cb_CopyNTFS.Checked);
  Settings.SetParkFirstBackup(cb_ParkFirst.Checked);
  Settings.SetDeleteEmptyFolders(cb_DeleteEmpty.Checked);
  Settings.SetAlwaysCreateFolder(cb_AlwaysCreate.Checked);
  Settings.SetCompAbsolute(cb_CompressionAbsolute.Checked);
  Settings.SetZipLevel(tb_ZipLevel.Position);
  Settings.SetCompUseTaskName(cb_CompTaskName.Checked);
  Settings.SetCompCRC(cb_CompCRC.Checked);
  Settings.SetZipAdvancedNaming(cb_ZipAdvancedNaming.Checked);
  Settings.SetCompOEM(cb_CompOEM.Checked);
  Settings.SetZip64(cb_Zip64.ItemIndex);
  Settings.SetUncompressed(lb_Uncompressed.Items.CommaText);
  Settings.SetSQXDictionary(cb_SQXDictionary.ItemIndex);
  Settings.SetSQXLevel(cb_SQXLevel.ItemIndex);
  Settings.SetSQXRecovery(tb_SQXRecoveryData.Position);
  Settings.SetSQXSolid(cb_SQXSolidArchives.Checked);
  Settings.SetSQXMultimedia(cb_SQXMultimedia.Checked);
  Settings.SetSQXExe(cb_SQXExe.Checked);
  Settings.SetSQXExternal(cb_SQXExternal.Checked);
  Settings.SetFTPSpeedLimit(cb_Limit.Checked);
  Settings.SetFTPSpeed(CobStrToIntW(e_Speed.Text, INT_FTPDEFSPEED));
  Settings.SetFTPASCII(lb_ASCII.Items.CommaText);
  Settings.SetShutdownKill(cb_ShutdownKill.Checked);
  Settings.SetAutoUpdate(cb_Autocheck.Checked);
  Settings.SetRunOldBackups(cb_RunOld.Checked);
  Settings.SetRunOldDontAsk(cb_RunDontAsk.Checked);
  Settings.SetMailScheduled(cb_MailScheduled.Checked);
  Settings.SetPropagateMasks(cb_PropagateMasks.Checked);

  // User settings
  UISettings.ShowWelcomeScreen:= cb_ShowWelcome.Checked;
  UISettings.ShowHints:= cb_ShowHints.Checked;

  SetXPStyle();

  UISettings.FontName:= p_FontUI.Font.Name;
  UISettings.FontSize:= p_FontUI.Font.Size;
  UISettings.FontCharset:= p_FontUI.Font.Charset;
  UISettings.FontNameLog:= p_FontLog.Font.Name;
  UISettings.FontSizeLog:= p_FontLog.Font.Size;
  UISettings.FontCharsetLog:= p_FontLog.Font.Charset;
  UISettings.ConfirmClose:= cb_ConfrmClose.Checked;
  UISettings.HotlKey:= cb_HotKey.ItemIndex;
  UISettings.ShowIcons:= cb_ShowIcons.Checked;
  UISettings.SaveAdvancedSettings:= cb_SaveAdvanced.Checked;
  UISettings.DeferenceLinks:= cb_DeferenceLinks.Checked;
  UISettings.ConvertToUNC:= cb_UNC.Checked;
  UISettings.HintColor:= FHintColor;
  UISettings.HintHide:= CobStrToIntW(e_HintPause.Text, INT_HINTHIDE);
  UISettings.CalculateSize:= cb_Calculate.Checked;
  UISettings.ShowBackupHints:= cb_ShowBackupHint.Checked;
  UISettings.ShowDialogEnd:= cb_ShowDialogEnd.Checked;
  UISettings.PlaySound:= cb_PlaySound.Checked;
  UISettings.FileToPlay:= e_Sound.Text;
  UISettings.ShowPercent:= cb_ShowPercent.Checked;
  UISettings.ClearLogTab:= cb_ClearLogTab.Checked;
  UISettings.ConfirmRun:= cb_ConfirmRun.Checked;
  UISettings.ConfirmAbort:= cb_ConfirmAbort.Checked;
  UISettings.ForceInternalHelp:= cb_ForceInternalHelp.Checked;
  UISettings.NavigateInternally:= cb_NavigateInternally.Checked;
  UISettings.AutoShowLog:= cb_AutoLog.Checked;
  UISettings.ShowGrid:= cb_ShowGrid.Checked;
end;

procedure Tform_Options.SetPage(const Index: integer);
begin
  if (Index >=0) and (Index < lb_Options.Items.Count) then
  begin
    lb_Options.Selected[Index];
    lb_Options.ItemIndex:= Index;
    pc_Options.ActivePageIndex:= Index;
  end;
end;

procedure Tform_Options.SetWarningFlag();
var
  FN: WideString;
begin
  if (cb_WarnInstances.Checked = FWarningFlag) then
    Exit;

  FN:= Globals.SettingsPath + WS_FLAGWARN;

  if (cb_WarnInstances.Checked) then
    begin
      if (WideFileExists(FN)) then
        WideDeleteFile(FN);
    end else
    begin
      if not (WideFileExists(FN)) then
        CobCreateEmptyTextFileW(FN);
    end;
  cb_WarnInstances.Checked:= not WideFileExists(FN);
end;

procedure Tform_Options.SetXPStyle();
var
  Manifest, notManifest: WideString;
begin
  if (FXPStyle <> cb_XPStyles.Checked) then
    begin
      Manifest:= Globals.AppPath + WS_GUIEXENAME + WS_MANIFESTEXT;
      notManifest:= Globals.AppPath + WS_GUIEXENAME + WS_NOTMANIFESTEXT;
      if (cb_XPStyles.Checked) then
        begin
          if (WideFileExists(notManifest)) then
            if WideCopyFile(notManifest, Manifest, false) then
              WideDeleteFile(notManifest);
        end else
        begin
          if (WideFileExists(Manifest)) then
            if WideCopyFile(Manifest, notManifest, false) then
              WideDeleteFile(Manifest);
        end;
      CobShowMessageW(Handle,Translator.GetMessage('18'),WS_PROGRAMNAMESHORT);
    end;
end;

function Tform_Options.StartService(): boolean;
var
  AHandle: Thandle;
  Dll: WideString;
  Start: function (const ServiceName, Parameters: PWideChar): cardinal; stdcall;
  Error: cardinal;
begin
  Result:= false;
  Dll:= Globals.AppPath + WS_COBNTW;
  if (WideFileExists(Dll)) then
  begin
    AHandle:= LoadLibraryW(PWideChar(Dll));
    if (AHandle <> 0) then
    begin
      @Start:= GetProcAddress(AHandle, PAnsiChar(S_STARTASERVICE));
      if (@Start <> nil) then
      begin
        Error:= Start(PWideChar(WS_SERVICENAME), PWideChar(WS_NIL));
        if (Error = INT_LIBOK) then
          Result:= true else
          begin
            CobShowMessageW(self.Handle, WideFormat(Translator.GetMessage('512'),
                            [CobSysErrorMessageW(Error)],FSGlobal),WS_PROGRAMNAMESHORT);
          end;
      end;
      FreeLibrary(AHandle);
    end;
  end;
end;

function Tform_Options.StopService(): boolean;
var
  AHandle: Thandle;
  Dll: WideString;
  Stop: function (const ServiceName: PWideChar): cardinal; stdcall;
  Error: cardinal;
begin
  Result:= false;
  Dll:= Globals.AppPath + WS_COBNTW;
  if (WideFileExists(Dll)) then
  begin
    AHandle:= LoadLibraryW(PWideChar(Dll));
    if (AHandle <> 0) then
    begin
      @Stop:= GetProcAddress(AHandle, PAnsiChar(S_STOPASERVICE));
      if (@Stop <> nil) then
      begin
        Error:= Stop(PWideChar(WS_SERVICENAME));
        if (Error = INT_LIBOK) then
          Result:= true else
          begin
            CobShowMessageW(self.Handle, WideFormat(Translator.GetMessage('513'),
                            [CobSysErrorMessageW(Error)],FSGlobal),WS_PROGRAMNAMESHORT);
          end;
      end;
      FreeLibrary(AHandle);
    end;
  end;
end;


procedure Tform_Options.tb_SQXRecoveryDataChange(Sender: TObject);
begin
  l_SQLRecovery.Caption:= WideFormat(Translator.GetInterfaceText('540'),
                                              [tb_SQXRecoveryData.Position],FSGlobal);
  CheckUICompression();
end;

procedure Tform_Options.tb_ZipLevelChange(Sender: TObject);
begin
  l_ZipLevel.Caption:= WideFormat(Translator.GetInterfaceText('515'),
                                              [tb_ZipLevel.Position],FSGlobal);
end;

procedure Tform_Options.LoadWarningFlag();
var
  FN: WideString;
begin
  FN := Globals.SettingsPath + WS_FLAGWARN;
  cb_WarnInstances.Checked := not WideFileExists(FN);
  FWarningFlag:= cb_WarnInstances.Checked;
end;

procedure Tform_Options.pb_HintColorClick(Sender: TObject);
begin
  dlg_Color.Color:= FHintColor;
  if (dlg_Color.Execute) then
  begin
    FHintColor:= dlg_Color.Color;
    pb_HintColor.Repaint();
  end;
end;

procedure Tform_Options.pb_HintColorPaint(Sender: TObject);
var
  ACaption: WideString;
  Metrics: tagSIZE;
begin
  // I don't use a panel here because if the program
  // uses the new XP look, a panel ignores the color property
  with pb_HintColor.Canvas do
  begin
    Pen.Color:= clBlack;
    Pen.Style:= psSolid;
    Brush.Color:= FHintColor;
    Brush.Style:= bsSolid;
    Rectangle(0,0, pb_HintColor.Width, pb_HintColor.Height);
  end;
  // Write the caption
  ACaption:= Translator.GetInterfaceText('374');
  GetTextExtentPoint32W(pb_HintColor.Canvas.Handle,
                      PWideChar(ACaption),
                      Length(ACaption), Metrics);
  TextOutW(pb_HintColor.Canvas.Handle, (pb_HintColor.Width div 2) - (Metrics.cx div 2),
          (pb_HintColor.Height div 2) - (Metrics.cy div 2), PWideChar(ACaption),
          Length(ACaption));
end;

procedure Tform_Options.CheckAutoStart();
var
  AuS: TCobAutostartW;
  UIStr: WideString;
begin
  AuS := CobIsAutostartingW(WS_PROGRAMNAMESHORT);
  if (AuS = cobBothAS) then
    AuS := cobGlobalAS;
  cb_Autostart.ItemIndex := ord(AuS);

  UIStr := WideFormat(WS_UIAUTOSTARTVALUE, [WS_PROGRAMNAMESHORT], FSGlobal);
  AuS := CobIsAutostartingW(UIStr);
  cb_AutostartInterface.Checked := (AuS = cobGlobalAS);

  // will be used to compare with the final settings
  FAutostart:= cb_Autostart.ItemIndex;
  FAutostartI:= cb_AutostartInterface.Checked;
end;

procedure Tform_Options.TntFormCreate(Sender: TObject);
begin
  FTools:= TCobTools.Create();

  ShowHint:= UISettings.ShowHints;
  Font.Name:= UISettings.FontName;
  Font.Size:= UISettings.FontSize;
  Font.Charset:= UISettings.FontCharset;
  FShowIcons:= UISettings.ShowIcons;
  GetLocaleFormatSettings(LOCALE_SYSTEM_DEFAULT, FSGlobal);
  FIsService:= IsServiceInstalled();
  Tag:= INT_MODALRESULTCANCEL;
  FFirstTime:= true;
  GetInterfaceText();
  pc_Options.ActivePage:= tab_General;
  lb_Options.ItemIndex:= 0;
  lb_Options.Selected[0]:= true;
end;

procedure Tform_Options.TntFormDestroy(Sender: TObject);
begin
  FreeAndNil(FTools);
end;

procedure Tform_Options.TntFormShow(Sender: TObject);
begin
  if (FFirstTime) then
  begin
    LoadSettings();
    CheckUI();
    FFirstTime:= false;
  end;
end;

function Tform_Options.UninstallService(): boolean;
var
  AHandle: Thandle;
  Dll: WideString;
  Uninstall: function (const ServiceName: PWideChar): cardinal; stdcall;
  Error: cardinal;
begin
  Result:= false;
  Dll:= Globals.AppPath + WS_COBNTW;
  if (WideFileExists(Dll)) then
  begin
    AHandle:= LoadLibraryW(PWideChar(Dll));
    if (AHandle <> 0) then
    begin
      @Uninstall:= GetProcAddress(AHandle, PAnsiChar(S_UNINSTALLSERVICE));
      if (@Uninstall <> nil) then
      begin
        Error:= Uninstall(PWideChar(WS_SERVICENAME));
        if (Error = INT_SERVICEDELETED) then
          Result:= true else
          begin
            CobShowMessageW(self.Handle, WideFormat(Translator.GetMessage('513'),
                            [CobSysErrorMessageW(Error)],FSGlobal),WS_PROGRAMNAMESHORT);
          end;
      end;
      FreeLibrary(AHandle);
    end;
  end;
end;

function Tform_Options.ValidateInput(): boolean;
begin
  Result:= false;

  if (not WideDirectoryExists(e_Temp.Text)) then
    if (not WideForceDirectories(e_Temp.Text)) then
      begin
        CobShowMessageW(handle,WideFormat(Translator.GetMessage('151'),[e_Temp.Text],FSGlobal),
                                    WS_PROGRAMNAMESHORT);
        SetPage(0);
        e_Temp.SelectAll();
        e_Temp.SetFocus();
        Exit;
      end;

  if (cb_MailLog.Checked and cb_Log.Checked) then
  begin
    if (e_SMTPSendersAddress.Text = WS_NIL) then
    begin
      CobShowMessageW(handle,Translator.GetMessage('139'), WS_PROGRAMNAMESHORT);
      SetPage(2);
      e_SMTPSendersAddress.SelectAll();
      e_SMTPSendersAddress.SetFocus();
      Exit;
    end;

    if (e_SMTPServerHost.Text = WS_NIL) then
    begin
      CobShowMessageW(handle,Translator.GetMessage('140'), WS_PROGRAMNAMESHORT);
      SetPage(2);
      e_SMTPServerHost.SelectAll();
      e_SMTPServerHost.SetFocus();
      Exit;
    end;

    if (not CobIsIntW(e_SMTPPort.Text)) then
    begin
      CobShowMessageW(handle,Translator.GetMessage('141'), WS_PROGRAMNAMESHORT);
      SetPage(2);
      e_SMTPPort.SelectAll();
      e_SMTPPort.SetFocus();
      Exit;
    end;

    if (lb_SMTPTo.Items.Count = 0) then
    begin
      CobShowMessageW(handle,Translator.GetMessage('142'), WS_PROGRAMNAMESHORT);
      SetPage(2);
      lb_SMTPTo.SetFocus();
      Exit;
    end;
  end;

  if (cb_ProtectUI.Checked) then
    if (e_Password.Text <> e_PasswordRe.Text) then
    begin
      CobShowMessageW(handle,Translator.GetMessage('17'), WS_PROGRAMNAMESHORT);
      SetPage(4);
      e_Password.SelectAll();
      e_Password.SetFocus();
      Exit;
    end;

  if (not CobIsIntW(e_HintPause.Text)) then
  begin
    CobShowMessageW(handle,Translator.GetMessage('133'), WS_PROGRAMNAMESHORT);
    SetPage(5);
    e_HintPause.SelectAll();
    e_HintPause.SetFocus();
    Exit;
  end;

  if (not CobIsIntW(e_TCPRead.Text)) then
  begin
    CobShowMessageW(handle,Translator.GetMessage('148'), WS_PROGRAMNAMESHORT);
    SetPage(8);
    e_TCPRead.SelectAll();
    e_TCPRead.SetFocus();
    Exit;
  end;

  if (not CobIsIntW(e_TCPConnection.Text)) then
  begin
    CobShowMessageW(handle,Translator.GetMessage('148'), WS_PROGRAMNAMESHORT);
    SetPage(8);
    e_TCPConnection.SelectAll();
    e_TCPConnection.SetFocus();
    Exit;
  end;

  if (not FTools.ValidateFileName(e_DTFormat.Text)) then
  begin
    CobShowMessageW(handle,Translator.GetMessage('238'), WS_PROGRAMNAMESHORT);
    SetPage(8);
    e_DTFormat.SelectAll();
    e_DTFormat.SetFocus();
    Exit;
  end;

  if (not CobIsIntW(e_CopyBuffer.Text)) then
  begin
    CobShowMessageW(handle,Translator.GetMessage('248'), WS_PROGRAMNAMESHORT);
    SetPage(8);
    e_CopyBuffer.SelectAll();
    e_CopyBuffer.SetFocus();
    Exit;
  end;

  if (not CobIsIntW(e_Speed.Text)) then
  begin
    if (e_Speed.Enabled) then
    begin
      CobShowMessageW(handle,Translator.GetMessage('415'), WS_PROGRAMNAMESHORT);
      SetPage(3);
      e_Speed.SelectAll();
      e_Speed.SetFocus();
    end else
      e_Speed.Text:= CobIntToStrW(INT_FTPDEFSPEED);
    Exit;
  end;

  Result:= true;
end;

end.
