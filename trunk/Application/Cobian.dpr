
{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~                                                            ~~~~~~~~~~
~~~~~~~~~~               Cobian Backup Black Moon                     ~~~~~~~~~~
~~~~~~~~~~           Copyright 2000-2006 by Luis Cobian               ~~~~~~~~~~
~~~~~~~~~~                     cobian@educ.umu.se                     ~~~~~~~~~~
~~~~~~~~~~                    All rights reserved                     ~~~~~~~~~~
~~~~~~~~~~                                                            ~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

{The main application}

program Cobian;

{$R *.RES}
{$R ICONRES.RES}

uses
  SysUtils,
  TntSysUtils,
  TntClasses,
  TntSystem,
  CobCommonW,
  CobDialogsW,
  Windows,
  Messages,
  bmCustomize in '..\Common\bmCustomize.pas',
  bmConstants in '..\Common\bmConstants.pas',
  bmCommon in '..\Common\bmCommon.pas';

var
  ClassName, AppPath: WideString;
  WndClass: TWndClassExW;
  hWin: HWND;
  Msg: TMsg;
  MutexHandle: THandle;
  pSecurityDesc: PSECURITY_DESCRIPTOR;
  Sec: TSECURITYATTRIBUTES;
  Engine: THandle;
  EntryPoint: TEntryPoint;
  ExitPoint: TExitPoint;
  FS: TFormatSettings;
  FDestroyFull: boolean;

procedure DoStop();
begin
  PostQuitMessage(INT_NIL);
end;

function StartEngine(const Param: WideString): boolean;
var
  EngineFile: WideString;
begin
  // Open the engine (dll) and pass the parameters

  Result:= false;

  EngineFile:= AppPath + WS_ENGINEEXENAME;

  Engine := LoadLibraryW(PWideChar(EngineFile));

  if Engine <> 0 then
  begin
    @EntryPoint := nil;
    EntryPoint := GetProcAddress(Engine, S_INITPROCEDUREADDRESS);
    if @EntryPoint <> nil then
      begin
        Result:= true;
        EntryPoint(byte(INT_NIL), PWideChar(AppPath), PWideChar(Param));
      end;
  end;
end;

procedure StopEngine();
begin
  // Unload the working dll

  if Engine <> 0 then
    begin
      @ExitPoint := nil;
      ExitPoint := GetProcAddress(Engine, S_DEINITPROCEDUREADDRESS);
      if @ExitPoint <> nil then
        ExitPoint();
      //Free
      FreeLibrary(Engine);
      Engine := 0;
    end;

end;

function GetParameters(const Param: WideString): WideString;
var
  Sl: TTntStringList;
  i: integer;
begin
  Result:= WS_NIL;
  if (WideParamCount > 0) then
    begin
      Sl:= TTntStringList.Create();
      try
        for i:=1 to WideParamCount do
          Sl.Add(WideParamStr(i));

        Result:= Sl.CommaText;
      finally
        FreeAndNil(Sl);
      end;
    end;
end;

function  GetMultipleInstancesWarn(): boolean;
var
  SettingsDir, Flag: WideString;
begin
  // If the file WS_FLAGWARN exists, do not show any message
  // in previous versions this was a registry setting

  SettingsDir:= AppPath + WS_DIRSETTINGS;
  Flag:= CobSetBackSlashW(SettingsDir)+ WS_FLAGWARN;

  Result:= not WideFileExists(Flag);
end;

function CheckInstance(): boolean;
var
  MN: WideString;
begin
  //On windows 2000 or XP the mutex name must have the GLOBAL prefix
  //if you want that all users will see your mutex.
  //This is very important when using the fast switch feature on XP
  if (CobIs2000orBetterW()) then
    MN := WideFormat(WS_APPMUTEXNAME, [WS_PROGRAMNAMELONG],FS) else
    MN := WideFormat(WS_APPMUTEXNAMEOLD, [WS_PROGRAMNAMELONG],FS);

  pSecurityDesc := nil;
  Sec:= CobGetNullDaclAttributesW(pSecurityDesc);

  MutexHandle := CreateMutexW(@sec, False, PWideChar(MN));

  if (MutexHandle = 0) then
    Result := true
  else
    Result := (GetLastError() = ERROR_ALREADY_EXISTS); //if exists TRUE
end;

procedure DestroyInstanceMutex();
begin
  if (MutexHandle <> 0) then
  begin
    CloseHandle(MutexHandle);
    MutexHandle:= 0;
  end;

  if (pSecurityDesc <> nil) then
  begin
    CobFreeNullDaclAttributesW(pSecurityDesc);
    pSecurityDesc:= nil;
  end;
end;

procedure Destroy();
begin
  if (FDestroyFull) then
    StopEngine();

  DestroyInstanceMutex();

  DoStop();
end;

procedure Create();
var
  Param: WideString;
begin
  AppPath:= CobGetAppPathW();

  FDestroyFull:= true;

  Param:= WS_NIL;

  Param:= GetParameters(Param);

  if (CheckInstance()) then
  begin
    if (GetMultipleInstancesWarn()) then
      CobShowMessageW(0, WideFormat(WS_HARDCODDED,[WS_PROGRAMNAMESHORT],FS),
                      WS_PROGRAMNAMESHORT);

    FDestroyFull:= false;
    Destroy();
    DoStop();
  end else   // The first instance
  if (not StartEngine(Param)) then
  begin
    FDestroyFull:= false;
    Destroy();
    DoStop();
  end;
end;

// The window procedure
function WndProc(Window: HWND; AMsg, WParam, LParam: longint): longint;
  stdcall; export;
begin
  case AMsg of
    WM_CREATE:
      begin
        Create();
      end;

    WM_DESTROY:
      begin
        Destroy();
      end;
  end;

  Result := DefWindowProcW(Window, AMsg, WParam, LParam);

end;

begin
  if (not CobIsNTBasedW(true)) then
    Halt(INT_NOTNT);

  GetLocaleFormatSettings(LOCALE_SYSTEM_DEFAULT, FS);

  ClassName := WideFormat(WS_SERVERCLASSNAME, [WS_PROGRAMNAMELONG],FS);

  with WndClass do { fill in TWndClass the structure }
  begin
    cbSize := sizeof(WndClass);
    Style := CS_HREDRAW or CS_VREDRAW;
    lpfnWndProc := @WndProc;
    cbClsExtra := 0;
    cbWndExtra := 0;
    hInstance := SysInit.HInstance;
    hIcon := LoadIcon(0, IDI_APPLICATION);
    hCursor := LoadCursor(0, IDC_ARROW);
    hbrBackground := HBrush(GetStockObject(WHITE_BRUSH));
    lpszMenuName := nil;
    lpszClassName := PWideChar(ClassName);
  end;

  // Register the Window class
  if not (RegisterClassExW(WndClass) <> 0) { class registration } then
    begin
      MessageBoxW(0, PWideChar(WideFormat(WS_CLASSFAILED,[WS_PROGRAMNAMESHORT],FS)),
                                PWideChar(WS_PROGRAMNAMESHORT), MB_OK);
      Halt(INT_NOREG);
    end;

    // Create the window

    hWin := CreateWindowW(PWideChar(ClassName), { application window creation }
                          PWideChar(ClassName), { you don't really need a caption }
                          WS_OVERLAPPEDWINDOW,
                          0, 0, 0, 0,
                          0,
                          0,
                          HInstance,
                          nil);


    if hWin <> 0 then
      begin
        //ShowWindow(hWin, CmdShow);  { this will make a visible app }
        ShowWindow(hWin, SW_HIDE); { this not   }
        //UpdateWindow(hWin);   { useless for invisible     }
      end
      else
      begin
        //2005-11-09 fixed a little bug in the caption
        MessageBoxW(0, PWideChar(WS_WINDOWSHOWFAILED),
                    PWideChar(WS_PROGRAMNAMESHORT), MB_OK);
        Halt(INT_NOCREATION);
      end;

    while GetMessageW(Msg, 0, 0, 0) do { second parameter = 0 denotes   }
      begin { that we want the messages for all windows }
        TranslateMessage(Msg); { for this case could be hWin  }
        DispatchMessageW(Msg);
      end;

    Halt(Msg.wParam);
    
end.
