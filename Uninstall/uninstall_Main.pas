{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~                                                            ~~~~~~~~~~
~~~~~~~~~~                Cobian Backup Black Moon                    ~~~~~~~~~~
~~~~~~~~~~            Copyright 2000-2006 by Luis Cobian              ~~~~~~~~~~
~~~~~~~~~~                     cobian@educ.umu.se                     ~~~~~~~~~~
~~~~~~~~~~                    All rights reserved                     ~~~~~~~~~~
~~~~~~~~~~                                                            ~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

// Main unit for the uninstaller

unit uninstall_Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, bmTranslator, StdCtrls, TntStdCtrls, ComCtrls, TntComCtrls, TntForms;

const
  INT_POSTCREATE = WM_USER + 1254;

type
  Tform_Main = class(TTntForm)
    re_Memo: TTntRichEdit;
    cb_DeleteAll: TTntCheckBox;
    b_OK: TTntButton;
    b_Cancel: TTntButton;
    procedure b_OKClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure b_CancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FS: TFormatSettings;
    FWorking: boolean;
    FAppPath: WideString;
    FStdLanguage: WideString;
    FSec: TSecurityAttributes;
    pSec: PSECURITY_DESCRIPTOR;
    FFirstTime: boolean;
    FAuto: boolean;
    FErrors: integer;
    function GetStdlanguage(): WideString;
    procedure GetInterfaceText();
    procedure Go();
    procedure Log(const Msg: WideString; const Error: boolean);
    procedure ClosePrograms();
    procedure UninstallService();
    procedure DeleteFiles();
    procedure DeleteIcons();
    function GetStartMenu(const Global: boolean): WideString;
    procedure DeleteApplicationFlag();
    procedure UnregisterUninstall();
    procedure DeleteAutostart();
    procedure ShowResults();
  public
    { Public declarations }
  protected
    procedure PostShow(var Msg: TMessage); message INT_POSTCREATE;
  end;

var
  form_Main: Tform_Main;

implementation

{$R *.dfm}
{$R ..\Common\vistaAdm.RES}

uses CobCommonW, bmConstants, CobRegistryW, bmCustomize, TntSystem, CobDialogsW,
    TntSysUtils;

procedure Tform_Main.b_CancelClick(Sender: TObject);
begin
  Close();
end;

procedure Tform_Main.b_OKClick(Sender: TObject);
begin
  Go();
end;

procedure Tform_Main.ClosePrograms();
var
  h: Thandle;
begin
  Log(Translator.GetMessage('596'),false);
  h:= FindWindowW(nil,PWideChar(WS_PROGRAMNAMELONG));
  if (h <> 0) then
  begin
    Log(Translator.GetMessage('597'), false);
    PostMessageW(h, WM_CLOSE, 0, 0);
  end else
    Log(Translator.GetMessage('598'), false);

  Sleep(INT_SERVICEOP);

  Log(Translator.GetMessage('599'), false);
  h:= FindWindowW(PWideChar(WideFormat(WS_SERVERCLASSNAME,[WS_PROGRAMNAMELONG],FS)),nil);
  if (h <> 0) then
  begin
    Log(Translator.GetMessage('600'), false);
    PostMessageW(h, WM_CLOSE, 0, 0);
  end else
    Log(Translator.GetMessage('601'), false);

  Sleep(INT_SERVICEOP);
end;

procedure Tform_Main.DeleteApplicationFlag();
var
  Reg: TCobRegistryW;
  Key: WideString;
begin
  Log(Translator.GetMessage('618'), false);
  Reg:= TCobRegistryW.Create(KEY_ALL_ACCESS);
  try
    Reg.RootKey:= HKEY_LOCAL_MACHINE;
    Key:= WideFormat(WS_PROGRAMKEY,[WS_AUTHORSHORT, WS_PROGRAMNAMESHORT],FS);
    if (Reg.KeyExists(Key)) then
      if (reg.DeleteKey(Key)) then
        Log(Translator.GetMessage('619'),false);
  finally
    FreeAndNil(Reg);
  end;
end;

procedure Tform_Main.DeleteAutostart();
begin
  Log(Translator.GetMessage('623'), false);
  CobDeleteAutostartW(true, WS_PROGRAMNAMESHORT);
  CobDeleteAutostartW(false, WS_PROGRAMNAMESHORT);
  CobDeleteAutostartW(true, WideFormat(WS_UIAUTOSTARTVALUE, [WS_PROGRAMNAMESHORT], FS));
end;

procedure Tform_Main.DeleteFiles();
var
  SR: TSearchrecW;
  //****************************************************************************
  procedure Process();
  begin
    if (SR.Name <> WS_CURRENTDIR) and (SR.Name <> WS_PARENTDIR) then
    begin
      if (faDirectory and Sr.Attr) = 0 then
        if (WideUpperCase(SR.Name) <> WideUppercase(WS_UNINSTALLEXENAME)) then  // the uninstall cannot be deleted
          if (DeleteFileW(PWideChar(FAppPath + SR.Name))) then
            Log(WideFormat(Translator.GetMessage('614'),[FAppPath + SR.Name],FS), false) else
            Log(WideFormat(Translator.GetMessage('615'),[FAppPath + SR.Name,
                                CobSysErrorMessageW(Windows.GetLastError())],FS), true);
    end;
  end;
  //****************************************************************************
begin
  //Deleting the database and settings if needed
  if (cb_DeleteAll.Checked) then
  begin
    if (CobDeleteDirectoryW(FAppPath + WS_DIRDB)) then
      Log(WideFormat(Translator.GetMessage('612'),[FAppPath + WS_DIRDB],FS), false) else
      Log(WideFormat(Translator.GetMessage('613'),[FAppPath + WS_DIRDB],FS), true);

    if (CobDeleteDirectoryW(FAppPath + WS_DIRSETTINGS)) then
      Log(WideFormat(Translator.GetMessage('612'),[FAppPath + WS_DIRSETTINGS],FS), false) else
      Log(WideFormat(Translator.GetMessage('613'),[FAppPath + WS_DIRSETTINGS],FS), true);
  end;

  if (CobDeleteDirectoryW(FAppPath + WS_DIRHELP)) then
    Log(WideFormat(Translator.GetMessage('612'),[FAppPath + WS_DIRHELP],FS), false) else
    Log(WideFormat(Translator.GetMessage('613'),[FAppPath + WS_DIRHELP],FS), true);

  if (CobDeleteDirectoryW(FAppPath + WS_DIRLANG)) then
    Log(WideFormat(Translator.GetMessage('612'),[FAppPath + WS_DIRLANG],FS), false) else
    Log(WideFormat(Translator.GetMessage('613'),[FAppPath + WS_DIRLANG],FS), true);

  if (WideFindFirst(FAppPath + WS_ALLFILES, faAnyFile, SR) = 0) then
  begin
    Process();
    while WideFindNext(SR) = 0 do
      Process();
    WideFindClose(SR);
  end;
end;

procedure Tform_Main.DeleteIcons();
var
  Dir: WideString;
begin
  Log(Translator.GetMessage('616'), false);
  Dir:= GetStartMenu(true);
  Dir:= CobSetBackSlashW(Dir) + WS_PROGRAMNAMESHORT;
  if (WideDirectoryExists(Dir)) then
    if CobDeleteDirectoryW(Dir) then
      Log(Translator.GetMessage('617'), false);

  // Sometimes the icons can be installed on the current user menu only
  Dir:= GetStartMenu(false);
  Dir:= CobSetBackSlashW(Dir) + WS_PROGRAMNAMESHORT;
  if (WideDirectoryExists(Dir)) then
    if CobDeleteDirectoryW(Dir) then
      Log(Translator.GetMessage('617'), false);
end;

procedure Tform_Main.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose:= not FWorking;
end;

procedure Tform_Main.FormCreate(Sender: TObject);
var
  LangPath: WideString;
begin
  GetLocaleFormatSettings(LOCALE_SYSTEM_DEFAULT, FS);
  FWorking:= false;
  FSec:= CobGetNullDaclAttributesW(pSec);
  FAppPath:= CobSetBackSlashW(CobGetAppPathW());
  LangPath:= CobSetBackSlashW(FAppPath + WS_DIRLANG);
  Translator:= TTranslator.Create(@FSec, FAppPath, LangPath);
  FStdLanguage:= GetStdlanguage();
  if (FStdLanguage <> WS_NIL) then
    Translator.LoadLanguage(FStdLanguage);
  FFirstTime:= true;
  FAuto:= false;
  FErrors:= INT_NIL;
end;

procedure Tform_Main.FormDestroy(Sender: TObject);
begin
  FreeAndNil(Translator);
  CobFreeNullDaclAttributesW(pSec);
end;

procedure Tform_Main.FormShow(Sender: TObject);
begin
  if (FFirstTime) then
  begin
    GetInterfaceText();
    PostMessageW(self.Handle, INT_POSTCREATE, 0, 0);
    FFirstTime:= false;
  end;
end;

procedure Tform_Main.GetInterfaceText();
begin
  b_Ok.Caption:= Translator.GetInterfaceText('719');
  b_Cancel.Caption:= Translator.GetInterfaceText('716');
  Caption:= WideFormat(Translator.GetInterfaceText('717'),[WS_PROGRAMNAMESHORT],FS);
  TntApplication.Title:= Caption;
  cb_DeleteAll.Caption:= Translator.GetInterfaceText('718');
end;

function Tform_Main.GetStartMenu(const Global: boolean): WideString;
var
  MyReg: TCobRegistryW;
  OK: boolean;
begin
  Result := WS_NIL;

  MyReg := TCobRegistryW.Create(KEY_READ);
  try
    if not Global then
      MyReg.RootKey:= HKEY_CURRENT_USER else
      MyReg.RootKey := HKEY_LOCAL_MACHINE;

    if MyReg.OpenKey(WS_REGSHELLFOLDERS, false) then
    begin
      if (not Global) then
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

function Tform_Main.GetStdlanguage(): WideString;
var
  Reg: TCobRegistryW;
  OK: boolean;
begin
  Result:= WS_NIL;
  Reg:= TCobRegistryW.Create(KEY_READ);
  try
    Reg.RootKey:= HKEY_LOCAL_MACHINE;
    if (Reg.OpenKey(WideFormat(WS_PROGRAMKEY,[WS_AUTHORSHORT, WS_PROGRAMNAMESHORT],FS), false)) then
    begin
      Result:= Reg.ReadStringWide(WS_REGSTDLANGUAGE, OK);
      if (not OK) then
        Result:= WS_NIL;
    end;
  finally
    FreeAndNil(Reg);
  end;
end;

procedure Tform_Main.Go();
begin
  try
    if (not FAuto) then
      if CobMessageBoxW(handle,Translator.GetMessage('594'),WS_PROGRAMNAMESHORT,MB_YESNO) = mrNo then
        Exit;

    FWorking:= true;
    cb_DeleteAll.Enabled:= false;
    b_Cancel.Enabled:= false;
    b_OK.Enabled:= false;

    Log(Translator.GetMessage('595'), false);

    ClosePrograms();

    UninstallService();

    DeleteFiles();

    DeleteIcons();

    DeleteAutostart();

    DeleteApplicationFlag();

    UnregisterUninstall();

    ShowResults();
  finally
    FWorking:= false;
    b_Cancel.Enabled:= true;
  end;
end;

procedure Tform_Main.Log(const Msg: WideString; const Error: boolean);
var
  AMsg: WideString;
begin
  if Error then
  begin
    re_Memo.SelAttributes.Color := clRed;
    AMsg:= WS_ERROR + WS_SPACE + Msg;
    inc(FErrors);
  end else
  begin
    re_Memo.SelAttributes.Color := clWindowText;
    AMsg:= WS_NOERROR + WS_SPACE + Msg;
  end;

  re_Memo.Lines.Add(AMsg);

  re_Memo.Perform(EM_LineScroll, 0, re_Memo.Lines.Count - 5);

  Application.ProcessMessages();
end;

procedure Tform_Main.PostShow(var Msg: TMessage);
begin
  if (WideParamCount > 0) then
    if (WideUppercase(WideParamStr(1)) = WS_AUTOUNINSTALL) then
    begin
      cb_DeleteAll.Checked:= false;
      FAuto:= true;
      b_OK.Click();
    end;
end;

procedure Tform_Main.ShowResults();
begin
  if (FErrors = INT_NIL) then
    Log(Translator.GetMessage('624'), false) else
    Log(WideFormat(Translator.GetMessage('625'),[FErrors],FS), true);
end;

procedure Tform_Main.UninstallService();
var
  Installed: boolean;
  Lib: THandle;
  LibName: WideString;
  IsInstalled: function (const ServiceName: PWideChar): cardinal; stdcall;
  IsRunning: function (const ServiceName: PWideChar): cardinal; stdcall;
  Stop: function (const ServiceName: PWideChar): cardinal; stdcall;
  Uninstall: function (const ServiceName: PWideChar): cardinal; stdcall;
  Running: boolean;
  Error: cardinal;
begin
  Log(Translator.GetMessage('602'), false);
  Installed:= false;
  LibName:= FAppPath + WS_COBNTW;
  Lib:= LoadLibraryW(PWideChar(LibName));
  if (Lib <> 0) then
  begin
    @IsInstalled:= GetProcAddress(Lib, PAnsiChar(S_SERVICEINSTALLEDFN));
    if (@IsInstalled <> nil) then
      Installed:= (IsInstalled(PWideChar(WS_SERVICENAME)) = INT_SERVICEINSTALLED);

    if (Installed) then
    begin
      Log(Translator.GetMessage('605'), false);
      @IsRunning:= GetProcAddress(Lib, PAnsiChar(S_SERVICERUNNINGFN));
      if (@IsRunning <> nil) then
      begin
        Running:= IsRunning(PWideChar(WS_SERVICENAME)) = INT_SERVICERUNNING;
        if (Running) then
        begin
          Log(Translator.GetMessage('606'), false);
          @Stop:= GetProcAddress(Lib, PAnsiChar(S_STOPASERVICE));
          if (@Stop <> nil) then
          begin
            Error:= Stop(PWideChar(WS_SERVICENAME));
            if ( Error = INT_LIBOK) then
              Log(Translator.GetMessage('607'), false) else
              Log(WideFormat(Translator.GetMessage('608'), [CobSysErrorMessageW(Error)],FS), true);
            Sleep(INT_SERVICEOP);
          end;
        end;
      end;

      Log(Translator.GetMessage('609'), false);
      @Uninstall:= GetProcAddress(Lib, PAnsiChar(S_UNINSTALLSERVICE));
      if (@Uninstall <> nil) then
      begin
        Error:= Uninstall(PWideChar(WS_SERVICENAME));
        if (Error = INT_SERVICEDELETED) then
          Log(Translator.GetMessage('610'), false) else
          Log(WideFormat(Translator.GetMessage('611'),[CobSysErrorMessageW(Error)],FS), true);
        Sleep(INT_SERVICEOP);
      end;
    end else
      Log(Translator.GetMessage('604'), false);
    FreeLibrary(Lib);
  end else
    Log(WideFormat(Translator.GetMessage('603'),[LibName],FS), true);
end;

procedure Tform_Main.UnregisterUninstall();
var
  Reg: TCobRegistryW;
  Key: WideString;
begin
  Log(Translator.GetMessage('620'), false);
  Reg:= TCobRegistryW.Create(KEY_WRITE);
  try
    Reg.RootKey:= HKEY_LOCAL_MACHINE;
    Key:= WideFormat(WS_REGUNINSTALL, [WS_UNINSTALLSTR], FS);
    if (Reg.KeyExists(Key)) then
      if (Reg.DeleteKey(Key)) then
        Log(Translator.GetMessage('621'), false) else
        Log(Translator.GetMessage('622'), false) ;
  finally
    FreeAndNil(Reg);
  end;
end;

end.
