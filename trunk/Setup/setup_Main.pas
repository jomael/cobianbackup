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

// Main setup form

unit setup_Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TntForms, ComCtrls, TntComCtrls, ExtCtrls, TntExtCtrls, StdCtrls,
  TntStdCtrls, bmTranslator, jpeg;

const
  INT_POSTMAINSHOW = WM_USER + 5491;
  INT_POSTCREATED = WM_USER + 5493;
  INT_AUTOCLICK = WM_USER + 5492;

type
  Tform_Main = class(TTntForm)
    p_Button: TTntPanel;
    p_Top: TTntPanel;
    pc_Main: TTntPageControl;
    tab_License: TTntTabSheet;
    tab_Directories: TTntTabSheet;
    tab_Settings: TTntTabSheet;
    tab_Install: TTntTabSheet;
    b_Back: TTntButton;
    b_Cancel: TTntButton;
    b_Next: TTntButton;
    m_License: TTntMemo;
    cb_Agree: TTntCheckBox;
    i_Main: TTntImage;
    l_Welcome: TTntLabel;
    l_Directory: TTntLabel;
    e_Directory: TTntEdit;
    b_Dir: TTntButton;
    cb_CreateIcons: TTntCheckBox;
    l_InstallType: TTntLabel;
    cb_App_All: TTntRadioButton;
    cb_App_Current: TTntRadioButton;
    cb_App_NoAuto: TTntRadioButton;
    cb_Service: TTntRadioButton;
    gb_Service: TTntGroupBox;
    cb_LocalSystem: TTntRadioButton;
    cb_AsUser: TTntRadioButton;
    l_ID: TTntLabel;
    l_Password: TTntLabel;
    e_ID: TTntEdit;
    e_Password: TTntEdit;
    l_Warning: TTntLabel;
    cb_AutostartUI: TTntCheckBox;
    b_Auto: TTntButton;
    m_Log: TTntRichEdit;
    m_Warning: TTntRichEdit;
    procedure TntFormClose(Sender: TObject; var Action: TCloseAction);
    procedure b_AutoClick(Sender: TObject);
    procedure b_DirClick(Sender: TObject);
    procedure b_CancelClick(Sender: TObject);
    procedure TntFormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure cb_App_AllClick(Sender: TObject);
    procedure b_BackClick(Sender: TObject);
    procedure b_NextClick(Sender: TObject);
    procedure TntFormShow(Sender: TObject);
    procedure TntFormDestroy(Sender: TObject);
    procedure cb_AgreeClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FAppPath: WideString;
    FLanguagePath: WideString;
    FDistro: WideString;
    FZippedFiles: WideString;
    FStLanguage: WideString;
    FStdDir: WideString;
    FKey: WideString;
    FS: TFormatSettings;
    pSec: PSECURITY_DESCRIPTOR;
    FSec: TSecurityAttributes;
    FFirstTime: boolean;
    FAuto: boolean;
    FIsAdmin: boolean;
    FWorking: boolean;
    FRName: WideString;
    FROrganization: WideString;
    FRSerial: WideString;
    FAutoFile: WideString;
    FErrors: integer;
    FOldInstalled: boolean;
    FFilesCopied: integer;
    function GetSerial(): boolean;
    procedure ExtractResources();
    procedure CheckUI();
    procedure GetStdSettings();
    procedure GetInterfaceText();
    function CheckLogon(): boolean;
    procedure GetStdValues();
    procedure GetAutoValues();
    function GetProgramDirectory(): WideString;
    function GetBackupType(): integer;
    function GetLogonType(): integer;
    procedure Log(const Msg: WideString; const Error: boolean);
    procedure Go();
    procedure SelectLanguage();
    procedure CopyFiles(const Source, Destination: WideString);
    procedure PostInstall();
    procedure InstallService();
    function AssignSpecialPrivilege(const ID: WideString): boolean;
    procedure StartPrograms();
    procedure AddAutostartKeys();
    procedure AddAppKey(const Global: boolean);
    procedure AddUIKey();
    procedure CreateIcons();
    function GetStartMenu(): WideString;
    procedure RegisterUninstall();
    procedure AddProgramFlag();
    procedure ShowResults();
    procedure SetLanguage();
    procedure CopySpecialLibrary(const Source, DestDir: WideString);
    procedure GetFullAccess(const Obj: WideString);
  public
    { Public declarations }
  protected
    procedure PostShow(var Msg: Tmessage); message INT_POSTMAINSHOW;
    procedure AutoClick(var Msg: Tmessage); message INT_AUTOCLICK;
    procedure PostCreated(var Msg: Tmessage); message INT_POSTCREATED;
  end;

var
  form_Main: Tform_Main;

implementation

{$R *.dfm}

uses CobCommonW, bmCustomize, setup_Serial, bmConstants, setup_Constants,
  setup_Extractor, CobRegistryW, TntSysUtils, CobDialogsW, TntClasses,
  CobEncrypt, setup_Languages, bmCommon, ShellApi, ShlObj, ActiveX, ComObj;

procedure Tform_Main.AddAppKey(const Global: boolean);
begin
  Log(Translator.GetMessage('575'), false);
  CobAutostartW(Global, WS_PROGRAMNAMESHORT, e_Directory.Text + WS_APPEXENAME, WS_NIL);
end;

procedure Tform_Main.AddAutostartKeys();
begin
  if (cb_App_All.Checked) then
    AddAppKey(true) else
    if (cb_App_Current.Checked) then
    AddAppKey(false) else
    if (cb_Service.Checked) and (cb_AutostartUI.Checked) then
      AddUIKey();
end;

procedure Tform_Main.AddProgramFlag();
var
  Reg: TCobRegistryW;
begin
  Log(Translator.GetMessage('588'), false);
  Reg := TCobRegistryW.Create(KEY_WRITE);
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKey(WideFormat(WS_PROGRAMKEY, [WS_AUTHORSHORT, WS_PROGRAMNAMESHORT], FS), true) then
    begin
      Reg.WriteStringWide(SS_REGSTDDIR, e_Directory.Text);
      Reg.WriteStringWide(WS_REGSTDLANGUAGE, FStLanguage);
      Reg.CloseKey();
    end;
  finally
    Reg.Free();
  end;

  Application.ProcessMessages();
end;

procedure Tform_Main.AddUIKey;
var
  UIStr: WideString;
begin
  Log(Translator.GetMessage('575'), false);
  UIStr := WideFormat(WS_UIAUTOSTARTVALUE, [WS_PROGRAMNAMESHORT], FS);
  CobAutostartW(true,UIStr,e_Directory.Text + WS_GUIEXENAME, WS_SERVICEPARAM);
end;

function Tform_Main.AssignSpecialPrivilege(const ID: WideString): boolean;
var
  AHandle: Thandle;
  Dll: WideString;
  Privilege: function (const ID: PWideChar): cardinal; stdcall;
  Error: cardinal;
begin
  Result:= false;
  Log(WideFormat(Translator.GetMessage('563'),[ID],FS), false);
  Dll:= e_Directory.Text + WS_COBNTW;
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
          begin
            Result:= true;
            Log(WideFormat(Translator.GetMessage('564'),
                            [ID],FS),false);
          end else
          begin
            Log(WideFormat(Translator.GetMessage('520'),
                            [ID,CobSysErrorMessageW(Error)],FS),true);
          end;
      end;
      FreeLibrary(AHandle);
    end;
  end;
end;

procedure Tform_Main.AutoClick(var Msg: Tmessage);
begin
  if (b_Next.Enabled) then
    b_Next.Click();
end;

procedure Tform_Main.b_AutoClick(Sender: TObject);
var
  Sl: TTntStringList;
  Encrypted, Dir: WideString;
begin
  if (CobSelectDirectoryW(Translator.GetMessage('552'), WS_NIL, Dir, [csdNewFolder, csdNewUI], self)) then
  begin
    Sl:= TTntStringList.Create();
    try
      Dir:= CobSetBackSlashW(Dir) + WideExtractFileName(FAutoFile);
      Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIAUTOSETUPNAME,FRName],FS));
      Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIAUTOSETUPORGANIZATION, FROrganization],FS));
      Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIAUTOSETUPSERIAL, FRSerial],FS));
      Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIAUTOSETUPACCEPT, CobBoolToStrW(cb_Agree.Checked)],FS));
      Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIAUTOSETUPDIRECTORY, e_Directory.Text],FS));
      Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIAUTOINSTALLATIONTYPE, CobIntToStrW(GetBackupType())],FS));
      Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIAUTOLOGON, CobIntToStrW(GetLogonType())],FS));
      Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIAUTOID, e_ID.Text],FS));
      CobEncryptStringW(e_Password.Text,WS_LLAVE,Encrypted);
      Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIAUTOPASSWORD, Encrypted],FS));
      Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIAUTOUI, CobBoolToStrW(cb_AutostartUI.Checked)],FS));
      Sl.SaveToFile(Dir);
      CobShowMessageW(self.Handle, WideFormat(Translator.GetMessage('551'),
                    [Dir],FS), WS_PROGRAMNAMESHORT);
    finally
      FreeAndNil(Sl);
    end;
  end;
end;

procedure Tform_Main.b_BackClick(Sender: TObject);
begin
  if (pc_Main.ActivePage = tab_License) then
    Exit;

  if (pc_Main.ActivePage =  tab_Directories) then
  begin
    pc_Main.ActivePage:=  tab_License;
    cb_Agree.SetFocus();
    CheckUI();
    Exit;
  end;

  if (pc_Main.ActivePage = tab_Settings) then
  begin
    pc_Main.ActivePage:= tab_Directories;
    e_Directory.SelectAll();
    e_Directory.SetFocus();
    CheckUI();
    Exit;
  end;

  if (pc_Main.ActivePage = tab_Install) then
    Exit;
end;

procedure Tform_Main.b_CancelClick(Sender: TObject);
begin
  if (FWorking) then
    FWorking:= false else
    Close();
end;

procedure Tform_Main.b_DirClick(Sender: TObject);
var
  Dir: WideString;
begin
  if (CobSelectDirectoryW(Translator.GetMessage('550'),WS_NIL, Dir,[csdNewFolder, csdNewUI], self)) then
    e_Directory.Text:= Dir;
end;

procedure Tform_Main.b_NextClick(Sender: TObject);
begin
  if (pc_Main.ActivePage = tab_License) then
  begin
    if (cb_Agree.Checked) then
    begin
      pc_Main.ActivePage := tab_Directories;
      e_Directory.SelectAll();
      e_Directory.SetFocus();
      CheckUI();
      if (FAuto) then
        PostMessageW(self.Handle, INT_AUTOCLICK, 0, 0);
    end else
      CobShowMessageW(self.Handle, Translator.GetMessage('544'),WS_PROGRAMNAMESHORT);
    Exit;  
  end;

  if (pc_Main.ActivePage =  tab_Directories) then
  begin
    if (not WideDirectoryExists(e_Directory.Text)) then
      if (not WideCreateDir(e_Directory.Text)) then
      begin
        CobShowMessageW(self.Handle, Translator.GetMessage('545'), WS_PROGRAMNAMESHORT);
        Exit;
      end;

    e_Directory.Text:= CobSetBackSlashW(e_Directory.Text);
    pc_Main.ActivePage:=  tab_Settings;
    CheckUI();
    if (FAuto) then
      PostMessageW(self.Handle, INT_AUTOCLICK, 0, 0);
    Exit;
  end;

  if (pc_Main.ActivePage = tab_Settings) then
  begin
    if (CheckLogon()) then
    begin
      pc_Main.ActivePage:= tab_Install;
      CheckUI();
      Go();
    end;
    Exit;
  end;

  if (pc_Main.ActivePage = tab_Install) then
    Close();
end;

procedure Tform_Main.cb_AgreeClick(Sender: TObject);
begin
  CheckUI();
end;

procedure Tform_Main.cb_App_AllClick(Sender: TObject);
begin
  CheckUI();
end;

function Tform_Main.CheckLogon(): boolean;
begin
  Result:= true;

  if (cb_Service.Checked) and (cb_AsUser.Checked) then
    if (Trim(e_ID.Text) = WS_NIL) then
    begin
      CobShowMessageW(self.Handle, Translator.GetMessage('546'), WS_PROGRAMNAMESHORT);
      Result:= false;
      Exit;
    end else
    if (CobPosW(WC_BACKSLASH,e_ID.Text, true) = INT_NIL) then
            e_ID.Text:= WS_DOMAINPRE + e_ID.Text;

  if (cb_Service.Checked) and (cb_AsUser.Checked) then
    if (Trim(e_Password.Text) = WS_NIL) then
      if (not FAuto) then
        if (CobMessageBoxW(self.Handle, Translator.GetMessage('547'),
           WS_PROGRAMNAMESHORT, MB_YESNO) = mrNo) then
        begin
          Result:= false;
          Exit;
        end;

  if (cb_Service.Checked) and (cb_LocalSystem.Checked) then
    if (not FAuto) then
      if (CobMessageBoxW(self.Handle, Translator.GetMessage('548'),
          WS_PROGRAMNAMESHORT, MB_YESNO) = mrNo) then
      begin
        Result:= false;
        Exit;
      end;
end;

procedure Tform_Main.CheckUI();
begin
  b_Cancel.Enabled:= true; // always
  b_Back.Enabled:= (pc_Main.ActivePage <> tab_License) and (pc_Main.ActivePage <> tab_Install);
  b_Next.Enabled:= (pc_Main.ActivePage <> tab_Install) and (cb_Agree.Checked);
  cb_Service.Enabled:= FIsAdmin;
  cb_App_All.Enabled:= FIsAdmin;
  gb_Service.Enabled:= cb_Service.Checked and FIsAdmin;
  cb_LocalSystem.Enabled:= cb_Service.Checked and FIsAdmin;
  cb_AsUser.Enabled:= cb_Service.Checked and FIsAdmin;
  l_ID.Enabled:= cb_Service.Checked and cb_AsUser.Checked and FIsAdmin;
  l_Password.Enabled:= cb_Service.Checked and cb_AsUser.Checked and FIsAdmin;
  e_ID.Enabled:= cb_Service.Checked and cb_AsUser.Checked and FIsAdmin;
  e_Password.Enabled:= cb_Service.Checked and cb_AsUser.Checked and FIsAdmin;
  cb_AutostartUI.Enabled:= cb_Service.Checked and FIsAdmin;
  b_Auto.Visible:= (pc_Main.ActivePage = tab_Install) and not FWorking;
end;

procedure Tform_Main.CopyFiles(const Source, Destination: WideString);
var
  SR: TSearchRecW;
  ASource, ADestination: WideString;
  //****************************************************************************
  procedure Process();
  var
    Attr: cardinal;
  begin
    if (SR.Name <> WS_CURRENTDIR) and (SR.Name <> WS_PARENTDIR) then
    begin
      if (faDirectory and SR.Attr)> 0 then
        CopyFiles(ASource + SR.Name, ADestination + SR.Name) else
        begin
          if (WideUpperCase(SR.Name) = WideUppercase(WS_FAKELIB)) then
          begin
            // This is a VERY special case
            CopySpecialLibrary(ASource + SR.Name, ADestination);
            Exit;
          end;
          
          Log(WideFormat(Translator.GetMessage('557'),
                            [ASource + SR.Name, ADestination + SR.Name], FS), false);
          // 2007-02-04 If the destination exists, be sure to remove some eventual
          // read only attribute

          if (WideFileExists(ADestination + SR.Name)) then
          begin
            Attr:= WideFileGetAttr(ADestination + SR.Name);
            if ((Attr and faReadOnly) <>0 ) then
              WideFileSetAttr(ADestination + SR.Name, Attr and not faReadOnly);
          end;

          if (CopyFileW(PWideChar(ASource + SR.Name),PWideChar(ADestination + SR.Name), false)) then
          begin
            Log(WideFormat(Translator.GetMessage('558'),
                            [ASource + SR.Name, ADestination + SR.Name], FS), false);
            inc(FFilesCopied);
          end else
            Log(WideFormat(Translator.GetMessage('559'),
                            [ASource + SR.Name, ADestination + SR.Name,
                            CobSysErrorMessageW(Windows.GetLastError())], FS), true);
        end;
    end;
  end;
  //****************************************************************************
begin
  FFilesCopied:= INT_NIL;
  ASource:= CobSetBackSlashW(Source);
  ADestination:= CobSetBackSlashW(Destination);
  if (not WideDirectoryExists(ADestination)) then
    if (not WideCreateDir(ADestination)) then
    begin
      Log(WideFormat(Translator.GetMessage('555'),[ADestination],FS), true);
      Exit;
    end else
      Log(WideFormat(Translator.GetMessage('556'),[ADestination],FS), false);

    if (WideFindFirst(ASource + WS_ALLFILES, faAnyFile, SR) = 0) then
    begin
      Process();
      while WideFindNext(SR) = 0 do
      begin
        Process();
        if (not FWorking) then
          Break;
      end;
      WideFindClose(SR);
    end;
end;

procedure Tform_Main.CopySpecialLibrary(const Source, DestDir: WideString);
begin
  /// The toolbar uses the function  GradientFill from
  /// the library MSImg32. This function is NOT present in
  ///  NT 4, so to make  it compatible with NT4 I deploy a
  ///  fake MSImg32 that can be deployed with NT.
  /// ATTENTION: THIS SHOULD ONLY BE DEPLOYED ON NT

  if (CobIsNTBasedW(false) and not CobIs2000orBetterW()) then
  begin
    Log(Translator.GetMessage('626'), false);
    if (CopyFileW(PWideChar(Source), PWideChar(DestDir + WS_FAKELIBG), false)) then
      Log(WideFormat(Translator.GetMessage('627'),[DestDir + WS_FAKELIBG],FS), false) else
      Log(WideFormat(Translator.GetMessage('628'),[DestDir + WS_FAKELIBG, CobSysErrorMessageW(Windows.GetLastError())], FS),true);
  end;
end;

procedure Tform_Main.CreateIcons();
var
  MyObject: IUnknown;
  MySLink: IShellLinkW;
  MyPFile: IPersistFile;
  Directory, WFileName: WideString;
  //****************************************************************************
  procedure CreateAIcon(const AFileName, LinkName: WideString);
  begin
    with MySLink do
    begin
      SetArguments(PWideChar(WS_NIL));
      SetPath(PWideChar(AFileName));
      SetWorkingDirectory(PWideChar(e_Directory.Text));
    end;

    WFileName := Directory + LinkName + WS_LINKEXT;
    MyPFile.Save(PWideChar(WFileName), False);
  end;
begin
  if (cb_CreateIcons.Checked) then
  begin
    Log(Translator.GetMessage('576'), false);
    Directory := GetStartMenu();

    if (Directory = WS_NIL) then
    begin
      Log(Translator.GetMessage('577'), true);
      Exit;
    end;

    Directory:= CobSetBackSlashW(Directory);

    Directory := CobSetBackSlashW(Directory + WS_PROGRAMNAMESHORT);

    if (not WideDirectoryExists(Directory)) then
      if (not WideCreateDir(Directory)) then
      begin
        Log(Translator.GetMessage('578'), true);
        Exit;
      end;

    MyObject := CreateComObject(CLSID_ShellLink);
    MySLink := MyObject as IShellLinkW;
    MyPFile := MyObject as IPersistFile;

    CreateAIcon(e_Directory.Text + WS_README, Translator.GetMessage('579'));
    CreateAIcon(e_Directory.Text + WS_HISTORY, Translator.GetMessage('580'));
    CreateAIcon(e_Directory.Text + WS_LICENSE, Translator.GetMessage('581'));
    CreateAIcon(e_Directory.Text + WS_UNINSTALLEXENAME, Translator.GetMessage('582'));
    CreateAIcon(e_Directory.Text + WS_DECOMPRESSOREXENAME, Translator.GetMessage('583'));
    CreateAIcon(e_Directory.Text + WS_TRANSLATIONEXENAME, Translator.GetMessage('584'));
    CreateAIcon(e_Directory.Text + WS_COBDECRYPTORSTANDALONEEXENAME, Translator.GetMessage('585'));
    if (cb_Service.Checked) then
      CreateAIcon(e_Directory.Text + WS_GUIEXENAME, WideFormat(Translator.GetMessage('586'),[WS_PROGRAMNAMESHORT], FS)) else
      CreateAIcon(e_Directory.Text + WS_APPEXENAME, WS_PROGRAMNAMESHORT);
  end;
end;

procedure Tform_Main.ExtractResources();
var
  form_Extractor: Tform_Extractor;
begin
  form_Extractor:= Tform_Extractor.Create(nil);
  try
    form_Extractor.ShowModal();
    if (form_Extractor.Tag = INT_MODALRESULTOK) then
    begin
      FDistro:= form_Extractor.DistroDir;
      FZippedFiles:= form_Extractor.ZippedFiles;
    end;
  finally
    form_Extractor.Release();
  end;
end;

procedure Tform_Main.FormCreate(Sender: TObject);
begin
  FFirstTime:= false;
  PostMessageW(self.Handle, INT_POSTCREATED, 0, 0);
end;

procedure Tform_Main.GetAutoValues();
var
  Sl: TTntStringList;
  Decrypted: WideString;
begin
  FAuto:= true;
  Sl:= TTntStringList.Create();
  try
    Sl.LoadFromFile(FAutoFile);
    cb_Agree.Checked:= CobStrToBoolW(Sl.Values[WS_INIAUTOSETUPACCEPT]);
    e_Directory.Text:= Sl.Values[WS_INIAUTOSETUPDIRECTORY];
    cb_CreateIcons.Checked:= CobStrToBoolW(Sl.Values[WS_INIAUTOCREATEICONS]);
    case CobStrToIntW(Sl.Values[WS_INIAUTOINSTALLATIONTYPE], INT_INSTALLAPPALL) of
      INT_INSTALLAPPALL: cb_App_All.Checked:= true;
      INT_INSTALLAPPCURRENT: cb_App_Current.Checked:= true;
      INT_INSTALLAPPNONE: cb_App_NoAuto.Checked:= true;
      INT_INSTALLAPPSERVICE: cb_Service.Checked:= true;
      else
        cb_App_NoAuto.Checked:= true;
    end;

    case CobStrToIntW(Sl.Values[WS_INIAUTOLOGON],INT_INSTALLLOGONSYSTEM) of
      INT_INSTALLLOGONUSER: cb_AsUser.Checked:= true;
      else
        cb_LocalSystem.Checked:= true;
    end;

    e_ID.Text:= Sl.Values[WS_INIAUTOID];
    CobDecryptStringW(Sl.Values[WS_INIAUTOPASSWORD], WS_LLAVE, Decrypted);
    e_Password.Text:= Decrypted;
    cb_AutostartUI.Checked:= CobStrToBoolW(Sl.Values[WS_INIAUTOUI]);
  finally
    FreeAndNil(Sl);
  end;
end;

function Tform_Main.GetBackupType(): integer;
begin
  if (cb_App_All.Checked) then
    Result:= INT_INSTALLAPPALL else
    if (cb_App_Current.Checked) then
      Result:= INT_INSTALLAPPCURRENT else
      if (cb_App_NoAuto.Checked) then
        Result:= INT_INSTALLAPPNONE else
        Result:= INT_INSTALLAPPSERVICE;
end;

procedure Tform_Main.GetFullAccess(const Obj: WideString);
var
  h: THandle;
  Ext: function (const ObjectName: PWideChar): cardinal; stdcall;
begin
  h:= LoadLibraryW(PWideChar(CobSetBackSlashW(FZippedFiles) + WS_COBNTSEC));
    if (h> 0) then
    begin
      @Ext:= GetProcAddress(h, PAnsiChar(S_LIBGRANTACCESS));
      if (@Ext <> nil) then
        Ext(PWideChar(Obj));
      FreeLibrary(h);
    end;
end;

procedure Tform_Main.GetInterfaceText;
begin
  b_Next.Caption:= Translator.GetInterfaceText('693');
  b_Cancel.Caption:= Translator.GetInterfaceText('B_CANCEL');
  b_Back.Caption:= Translator.GetInterfaceText('694');
  l_Welcome.Caption:= WideFormat(Translator.GetInterfaceText('695'),[WS_PROGRAMNAMESHORT],FS);
  Caption:= WideFormat(Translator.GetInterfaceText('696'),[WS_PROGRAMNAMESHORT],FS);
  TntApplication.Title:= Caption;
  cb_Agree.Caption:= Translator.GetInterfaceText('697');
  l_Directory.Caption:= Translator.GetInterfaceText('698');
  b_Dir.Hint:= Translator.GetInterfaceText('182');
  cb_CreateIcons.Caption:= Translator.GetInterfaceText('699');
  l_InstallType.Caption:= Translator.GetInterfaceText('700');
  cb_App_All.Caption:= Translator.GetInterfaceText('701');
  cb_App_Current.Caption:= Translator.GetInterfaceText('702');
  cb_App_NoAuto.Caption:= Translator.GetInterfaceText('703');
  cb_Service.Caption:= Translator.GetInterfaceText('704');
  gb_Service.Caption:= Translator.GetInterfaceText('705');
  cb_LocalSystem.Caption:= Translator.GetInterfaceText('706');
  cb_AsUser.Caption:= Translator.GetInterfaceText('707');
  l_ID.Caption:= Translator.GetInterfaceText('708');
  l_Password.Caption:= Translator.GetInterfaceText('709');
  l_Warning.Caption:= Translator.GetInterfaceText('710');
  e_ID.Hint:= Translator.GetInterfaceText('711');
  cb_AutostartUI.Caption:= Translator.GetInterfaceText('712');
  b_Auto.Caption:= Translator.GetInterfaceText('713');
  b_Auto.Hint:= Translator.GetInterfaceText('714');
  m_Warning.Text:= Translator.GetInterfaceText('727');
end;

function Tform_Main.GetLogonType(): integer;
begin
  if (cb_LocalSystem.Checked) then
    Result:= INT_INSTALLLOGONSYSTEM else
    Result:= INT_INSTALLLOGONUSER;
end;

function Tform_Main.GetProgramDirectory(): WideString;
var
  Reg: TCobRegistryW;
  Dir: WideString;
  Success: boolean;
begin
  Reg := TCobRegistryW.Create(KEY_READ);
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKey(SS_REGCURRENTVERSION, False) then
    begin
      if Reg.ValueExists(SS_REGPROGRAMFILESDIR) then
        Dir := Reg.ReadStringWide(SS_REGPROGRAMFILESDIR, Success);
      if (not Success) then
        Dir:= WS_NIL;
      Reg.CloseKey();
    end;

    if Dir = WS_NIL then
      Dir := SS_ROOTC;

    Result := CobSetBackSlashW(Dir) + WS_PROGRAMNAMESHORT;
  finally
    Reg.Free;
  end;
end;

function Tform_Main.GetSerial(): boolean;
var
  form_Serial: Tform_Serial;
begin
  form_Serial:= Tform_Serial.Create(nil);
  try
    form_Serial.ShowModal();
    Result:= form_Serial.Tag = INT_MODALRESULTOK;
    if (Result) then
    begin
      FRName:= form_Serial.e_Name.Text;
      FROrganization:= form_Serial.e_Organization.Text;
      FRSerial:= form_Serial.e_Serial.Text;
    end;
  finally
    form_Serial.Release();
  end;
end;

function Tform_Main.GetStartMenu(): WideString;
var
  MyReg: TCobRegistryW;
  OK: boolean;
begin
  Result := WS_NIL;

  MyReg := TCobRegistryW.Create(KEY_READ);
  try

    // 2005-10-18, if the installation is for the current user,
    // create the icons ONLY in the user program dir  
    if cb_App_Current.Checked then
      MyReg.RootKey:= HKEY_CURRENT_USER else
      MyReg.RootKey := HKEY_LOCAL_MACHINE;

    if MyReg.OpenKey(WS_REGSHELLFOLDERS, false) then
    begin
      if (cb_App_Current.Checked) then
        Result := MyReg.ReadStringWide(WS_REGPROGRAMFOLDERS, OK) else
        Result := MyReg.ReadStringWide(WS_REGCOMMONPROGRAMS, OK);

      MyReg.CloseKey();
    end;

    if Result = WS_NIL then //on early systems
    begin
      MyReg.RootKey := HKEY_USERS;
      if MyReg.OpenKey(WS_REGSHELLFOLDERSOLD, False) then
      begin
        Result := MyReg.ReadStringWide(WS_REGPROGRAMFOLDERS, OK);
        MyReg.CloseKey();
      end;
    end;

  finally
    MyReg.Free;
  end;
end;

procedure Tform_Main.GetStdSettings();
var
  Reg: TCobRegistryW;
  Success: boolean;
  St: WideString;
begin
  FOldInstalled:= false;
  Reg:= TCobRegistryW.Create(KEY_READ);
  try
    Reg.RootKey:= HKEY_LOCAL_MACHINE;
    if (Reg.OpenKey(FKey, false)) then
    begin
      St:= Reg.ReadStringWide(SS_REGSTDDIR, Success);
      if (Success) then
      begin
        FStdDir:= CobSetBackSlashW(St);
        FOldInstalled:= true;
      end;
      St:= Reg.ReadStringWide(WS_REGSTDLANGUAGE, Success);
      if (Success) then
        FStLanguage:= St;
    end;
  finally
    FreeAndNil(Reg);
  end;

  m_Warning.Visible:= FOldInstalled;
end;

procedure Tform_Main.GetStdValues();
begin
  if (WideFileExists(FAppPath + WideChangeFileExt(WS_SETUPEXENAME, WS_DATAEXT))) then
    GetAutoValues() else
    begin
      cb_Agree.Checked:= false;
      if (FStdDir <> WS_NIL) then
        e_Directory.Text:= FStdDir else
        e_Directory.Text:= GetProgramDirectory();
      cb_CreateIcons.Checked:= true;
      if (FIsAdmin) then
        cb_Service.Checked:= true else
        cb_App_Current.Checked:= true;
      cb_LocalSystem.Checked:= true;
      e_ID.Text:= WS_NIL;
      e_Password.Text:= WS_NIL;
      cb_AutostartUI.Checked:= true;
    end;
end;

procedure Tform_Main.Go();
begin
  FWorking:= true;
  CheckUI();
  Log(WideFormat(Translator.GetMessage('553'),[WS_PROGRAMNAMESHORT],FS),false);
  if (FOldInstalled) then
  begin
    Log(Translator.GetMessage('554'), false);
    // Uninstall the old version
    CobExecuteAndWaitW(FStdDir + WS_UNINSTALLEXENAME, WS_AUTOUNINSTALL, false);
  end;

  try
    CopyFiles(FZippedFiles, e_Directory.Text);
    if (not FWorking) then
      Exit;
    b_Cancel.Enabled:= false;
    PostInstall();
    ShowResults();
  finally
    FWorking:= false;
    CheckUI();
    b_Cancel.Enabled:= false;
    b_Next.Enabled:= true;
    b_Next.Caption:= Translator.GetInterfaceText('715');
    if (FAuto) then
      Close();
  end;
end;

procedure Tform_Main.InstallService();
var
  Lib: Thandle;
  LibName, DisplayName: WideString;
  Error: cardinal;
  AID, APassword: PWideChar;
  Install: function (const ServiceName, DisplayName, Binary, ID, Password: PWideChar): cardinal; stdcall;
  IsRunning: function (const ServiceName: PWideChar): cardinal; stdcall;
  IsServiceRunning: boolean;
  Start: function (const ServiceName, Parameters: PWideChar): cardinal; stdcall;
begin
  if (cb_Service.Checked) then
  begin
    Log(Translator.GetMessage('560'), false);
    LibName:= e_Directory.Text + WS_COBNTW;
    Lib:= LoadLibraryW(PWideChar(LibName));
    if (Lib <> 0) then
    begin
      @Install:= GetProcAddress(Lib, PAnsiChar(S_SERVICEINSTALLFN));
      if (@Install <> nil) then
      begin
        if (cb_LocalSystem.Checked) then
        begin
          AID:= nil;
          APassword:= nil;
        end else
        begin
          AID:= PWideChar(e_ID.Text);
          APassword:= PWideChar(e_Password.Text);

          AssignSpecialPrivilege(e_ID.Text);
        end;
        
        DisplayName:= WideFormat(Translator.GetMessage('515'),[WS_PROGRAMNAMESHORT],FS);
        Error:= Install(PWideChar(WS_SERVICENAME), PWideChar(DisplayName),
                        PWideChar(e_Directory.Text + WS_SERVICEEXENAME),
                        AID, APassword);

        if (Error = INT_SERVICEINSTALLED) then
          Log(Translator.GetMessage('565'), false) else
          Log(WideFormat(Translator.GetMessage('566'),[CobSysErrorMessageW(Error)],FS), true);

        Sleep(INT_SERVICEOP);

        IsServiceRunning:= false;
        @IsRunning:= GetProcAddress(Lib, PAnsiChar(S_SERVICERUNNINGFN));
        if (@isRunning <> nil) then
        begin
          Error:= IsRunning(PWideChar(WS_SERVICENAME));
          IsServiceRunning:= (Error = INT_SERVICERUNNING);
        end;

        if (not IsServiceRunning) then
        begin
          Log(Translator.GetMessage('566'),false);
          @Start:= GetProcAddress(Lib, PAnsiChar(S_STARTASERVICE));
          if (@Start <> nil) then
          begin
            Error:= Start(PWideChar(WS_SERVICENAME), PWideChar(WS_NIL));
            if (Error = INT_LIBOK) then
              Log(Translator.GetMessage('567'),false) else
              Log(WideFormat(Translator.GetMessage('568'),[CobSysErrorMessageW(Error)],FS), true);
          end;
        end;
      end else
        Log(Translator.GetMessage('562'), false);
      FreeLibrary(Lib);
    end else
      Log(WideFormat(Translator.GetMessage('561'),[LibName],FS), true);
  end;
end;

procedure Tform_Main.Log(const Msg: WideString; const Error: boolean);
var
  AMsg: WideString;
begin
  if Error then
  begin
    m_Log.SelAttributes.Color := clRed;
    AMsg:= WS_ERROR + WS_SPACE + Msg;
    inc(FErrors);
  end else
  begin
    m_Log.SelAttributes.Color := clWindowText;
    AMsg:= WS_NOERROR + WS_SPACE + Msg;
  end;

  m_Log.Lines.Add(AMsg);

  m_Log.Perform(EM_LineScroll, 0, m_Log.Lines.Count - 5);

  Application.ProcessMessages();
end;

procedure Tform_Main.PostCreated(var Msg: Tmessage);
begin
  if (not CobIsNTBasedW(true)) then
  begin
    Application.Terminate();
    Exit;
  end;

  GetLocaleFormatSettings(LOCALE_SYSTEM_DEFAULT, FS);

  FAppPath:= CobSetBackSlashW(CobGetAppPathW());
  FDistro:= WS_NIL;
  FZippedFiles:= WS_NIL;
  FStLanguage:= WS_NIL;
  FStdDir:= WS_NIL;
  FFirstTime:= true;
  FKey:= WideFormat(WS_PROGRAMKEY,[WS_AUTHORSHORT,WS_PROGRAMNAMESHORT],FS);
  FAuto:= false;
  FIsAdmin:= CobIsAdminW();
  FWorking:= false;
  FRName:= WS_NIL;
  FROrganization:= WS_NIL;
  FRSerial:= WS_NIL;
  FAutoFile:= FAppPath + WideChangeFileExt(WS_SETUPEXENAME, WS_DATAEXT);
  FErrors:= INT_NIL;

  if (BOOL_WANTSSERIAL) then
    if (not GetSerial()) then
    begin
      Application.Terminate();
      Exit;
    end;

  ExtractResources();

  if (FDistro = WS_NIL) then
  begin
    Application.Terminate();
    Exit;
  end;

  cb_Agree.Checked:= false;
  pc_Main.ActivePage:= tab_License;

  GetStdSettings();

  FSec:= CobGetNullDaclAttributesW(pSec);

  FLanguagePath:= CobSetBackSlashW(FZippedFiles + WS_DIRLANG);

  Translator:= TTranslator.Create(@FSec, FAppPath, FLanguagePath);

  GetStdValues();

  SelectLanguage();

  if (FStLanguage <> WS_NIL) then
     Translator.LoadLanguage(FStLanguage);

  CheckUI();

  if (not CobIsNTBasedW(false)) then
  begin
    if CobMessageBoxW(handle, Translator.GetMessage('502'),
                                WS_PROGRAMNAMESHORT, MB_YESNO) = mrYes then
      //Use ansi because you are on 9x
      ShellExecute(0,'open',PAnsiChar(AnsiString(WS_PROGRAMWEB)),nil,nil, SW_SHOWNORMAL);
    Close();
    Exit;
  end;

  Show();
end;

procedure Tform_Main.PostInstall();
begin
  Screen.Cursor:= crHourGlass;
  try
    if (not FWorking) then
      Exit;

    SetLanguage();  

    InstallService();

    StartPrograms();

    AddAutostartKeys();

    CreateIcons();

    RegisterUninstall();

    AddProgramFlag();

  finally
    Screen.Cursor:= crDefault;
  end;
end;

procedure Tform_Main.PostShow(var Msg: Tmessage);
begin
  if (WideFileExists(FZippedFiles + WS_LICENSE)) then
    m_License.Lines.LoadFromFile(FZippedFiles + WS_LICENSE);
  cb_Agree.SetFocus();
  if (not FAuto) and (not FIsAdmin) then
    CobShowMessageW(self.Handle, Translator.GetMessage('549'), WS_PROGRAMNAMESHORT);
  if (FAuto) then
    PostMessageW(self.Handle, INT_AUTOCLICK, 0, 0);
end;

procedure Tform_Main.RegisterUninstall();
var
  Registry: TCobRegistryW;
begin
  Log(Translator.GetMessage('587'),false);
  Registry := TCobRegistryW.Create(KEY_ALL_ACCESS);
  try
    Registry.RootKey := HKEY_LOCAL_MACHINE;
    if Registry.OpenKey(WideFormat(WS_REGUNINSTALL, [WS_UNINSTALLSTR]), True) then
    begin
      Registry.WriteStringWide(SS_REGUNINSTALLDISPLAYNAME, WS_PROGRAMNAMESHORT);
      Registry.WriteStringWide(SS_REGUNINSTALLSTR, e_Directory.Text + WS_UNINSTALLEXENAME);
      Registry.WriteStringWide(SS_REGUNINSTALLICON,e_Directory.Text + WS_UNINSTALLEXENAME);
      Registry.CloseKey();
    end;
  finally
    Registry.Free();
  end;
end;

procedure Tform_Main.SelectLanguage();
var
  form_Language: Tform_Languages;
begin
  form_Language:= Tform_Languages.Create(nil);
  try
    form_Language.Auto:= FAuto;
    form_Language.InitialLanguage:= FStLanguage;
    form_Language.LanguagePath:= FLanguagePath;
    form_Language.ShowModal();
    FStLanguage:= form_Language.cb_Languages.Items[form_Language.cb_Languages.ItemIndex];
  finally
    form_Language.Release();
  end;
end;

procedure Tform_Main.SetLanguage();
var
  DBPath, SPath: WideString;
begin
  // if this is the first time the user installs the
  // program, just create a std ini file with the selected language

  Log(Translator.GetMessage('592'), false);

  DBPath:= CobSetBackSlashW(e_Directory.Text + WS_DIRDB);

  if (not WideDirectoryExists(DBPath)) then
  begin
    WideCreateDir(DBPath);
    GetFullAccess(DBPath);
  end;

  SPath:= CobSetBackSlashW(e_Directory.Text + WS_DIRSETTINGS);

  if (not WideDirectoryExists(SPath)) then
  begin
    WideCreateDir(SPath);
    GetFullAccess(SPath);
  end;

  {LPath:= CobSetBackSlashW(e_Directory.Text + WS_DIRLANG);
  if (WideDirectoryExists(LPath)) then
    GetFullAccess(LPath);

  HPath:= CobSetBackSlashW(e_Directory.Text + WS_DIRHELP);
  if (WideDirectoryExists(HPath)) then
    GetFullAccess(HPath);  }

  if (not WideFileExists(SPath + WideChangeFileExt(WS_ENGINEEXENAME, WS_INIEXT))) then
  begin
    Settings:= TSettings.Create(@FSec, e_Directory.Text, DBPath, SPath);
    try
      Settings.SetLanguage(FStLanguage);
      Settings.SaveSettings(false);
    finally
      FreeAndNil(Settings);
    end;
  end;
end;

procedure Tform_Main.ShowResults();
begin
  if (FErrors <> INT_NIL) then
  begin
    Log(WideFormat(Translator.GetMessage('590'),[FErrors],FS),true);
    CobShowMessageW(self.Handle, WideFormat(Translator.GetMessage('591'),
            [FErrors],FS), WS_PROGRAMNAMESHORT);
  end else
    Log(Translator.GetMessage('589'), false);
end;

procedure Tform_Main.StartPrograms();
var
  Res: cardinal;
begin
  if (cb_Service.Checked) then
  begin
    Log(Translator.GetMessage('569'), false);
    Res:= ShellExecuteW(0,'open', PWideChar(e_Directory.Text + WS_GUIEXENAME),
                    PWideChar(WS_SERVICEPARAM),nil, SW_SHOWNORMAL);
    if  Res > 32 then
      Log(Translator.GetMessage('570'),false) else
      Log(WideFormat(Translator.GetMessage('571'), [Translator.GetShellError(Error)],FS), true);
  end else
  begin
    Log(Translator.GetMessage('572'), false);
    Res:= ShellExecuteW(0,'open', PWideChar(e_Directory.Text + WS_APPEXENAME),
                    nil , nil, SW_SHOWNORMAL);
    if  Res > 32 then
      Log(Translator.GetMessage('573'),false) else
      Log(WideFormat(Translator.GetMessage('574'), [Translator.GetShellError(Error)],FS), true);
  end;
  Sleep(INT_SERVICEOP);
end;

procedure Tform_Main.TntFormClose(Sender: TObject; var Action: TCloseAction);
begin
  if (WideDirectoryExists(FDistro)) then
    if CobDeleteDirectoryW(FDistro) then
      Translator.GetMessage('593');
end;

procedure Tform_Main.TntFormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose:= not FWorking;
end;

procedure Tform_Main.TntFormDestroy(Sender: TObject);
begin
  FreeAndNil(Translator);
  CobFreeNullDaclAttributesW(pSec);
end;

procedure Tform_Main.TntFormShow(Sender: TObject);
begin
  if (FFirstTime) then
  begin
    GetInterfaceText();
    PostMessageW(self.Handle, INT_POSTMAINSHOW, 0, 0);
    FFirstTime:= false;
  end;
end;

end.
