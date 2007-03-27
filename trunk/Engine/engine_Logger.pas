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

// The logging class

unit engine_Logger;

interface

uses Classes, SyncObjs, SysUtils, TntClasses, Windows, CobCommonW, bmCommon, CobPipesW;

type
  TLogger = class (TObject)
  public
    constructor Create(const AppPath, DBPath: WideString; const Sec: PSecurityAttributes);
    destructor Destroy();override;
    procedure DeletelogFile();
    function CopyTo(FinalName: WideString): boolean;
    procedure Log(const Msg: WideString;const Error, Verbose: boolean); overload;
    procedure Log(const Msg: WideString;const Error: boolean); overload;
  private
    FAppPath: WideString;
    FDBPath: WideString;
    FLogFileName: WideString;
    FCritical: TCriticalSection;
    FS: TFormatSettings;
    FFileOpen: boolean;
    PhFile: TCobWideIO;
    FLog : boolean;
    FLogErrorsOnly: boolean;
    FVerbose: boolean;
    FRealTime: boolean;
    FSenderPointer: PWideChar;
    FIPCHandle: THandle;
    FIPCMutex: THandle;
    FLogList: TTntStringList;
    FTools: TCobTools;
    FUsePipes: boolean;
    FPipeClient: TCobPipeClientW;
    procedure LoadLogSettings();
    function OpenLogFile(): boolean;
    procedure CloseLogFile();
    function NeedToReload(): boolean;
    procedure CreateIPCSender(const Sec: PSecurityAttributes);
    procedure DestroyIPCSender();
    procedure IPCLog(const Msg: WideString);
  end;

var
  Logger: TLogger;

implementation

uses bmConstants, bmCustomize, TntSysUtils;

{ TLogger }

procedure TLogger.CloseLogFile();
begin
  FFileOpen:= false;
  FreeAndNil(PhFile);
end;

function TLogger.CopyTo(FinalName: WideString): boolean;
begin
  //Copies the log file to another destination
  //this is useful when the interface
  //sends the View Log command. A copy is created
  //and send to the interface
  FCritical.Enter();
  try
    CloseLogFile();
    Result := CopyFileW(PWideChar(FLogFileName), PWideChar(FinalName), false);
    if (Result) then
      FTools.GetFullAccess(FAppPath, FinalName);
    FFileOpen:= OpenLogFile();
  finally
    FCritical.Leave();
  end;
end;

constructor TLogger.Create(const AppPath, DBPath: WideString; const Sec: PSecurityAttributes);
begin
  inherited Create();
  FAppPath:= AppPath;
  FDBPath:= DBPath;
  FLogFileName:= FDBPath + WS_LOGFILENAME;
  FCritical:= TCriticalSection.Create();
  FTools:= TCobTools.Create();
  GetLocaleFormatSettings(LOCALE_SYSTEM_DEFAULT, FS);
  LoadLogSettings();
  FLogList:= TTntStringList.Create();
  FUsePipes:= Settings.GetUsePipes();
  CreateIPCSender(Sec);
  FFileOpen:= OpenLogFile();
end;

procedure TLogger.CreateIPCSender(const Sec: PSecurityAttributes);
var
  FName, MName, PName: WideString;
begin
  if (FUsePipes) then
  begin
    PName:= WideFormat(WS_LOGTOLOGPIPE,[WS_PROGRAMNAMESHORTNOISPACES],FS);
    FPipeClient:= TCobPipeClientW.Create(PName, Sec);
    FPipeClient.Connect();
  end else
  begin
    // Create the MMF which will send the log strings to
    // the client in "real time"

    if (CobIs2000orBetterW) then
      begin
        FName:= WideFormat(WS_MMFLOG,[WS_PROGRAMNAMELONG],FS);
        MName:= WideFormat(WS_MMFLOGMUTEX,[WS_PROGRAMNAMELONG],FS);
      end else
      begin
        FName:= WideFormat(WS_MMFLOGOLD,[WS_PROGRAMNAMELONG],FS);
        MName:= WideFormat(WS_MMFLOGMUTEXOLD,[WS_PROGRAMNAMELONG],FS);
      end;

    FIPCMutex:= CreateMutexW(sec, False, PWideChar(MName));

    FIPCHandle := CreateFileMappingW(INVALID_HANDLE_VALUE,
                                      sec,
                                      PAGE_READWRITE,
                                      INT_NIL,
                                      INT_MAXFILESIZE,
                                      PWideChar(FName));

    FSenderPointer := MapViewOfFile(FIPCHandle, FILE_MAP_ALL_ACCESS, 0, 0, 0);
  end;
end;

procedure TLogger.DeletelogFile();
begin
  FCritical.Enter();
  try
    CloseLogFile();
    DeleteFileW(PWideChar(FLogFileName));
    FFileOpen:= OpenLogFile();
  finally
    FCritical.Leave();
  end;
end;

destructor TLogger.Destroy();
begin
  CloseLogFile();
  DestroyIPCSender();
  FreeAndNil(FLogList);
  FreeAndNil(FTools);
  FreeAndNil(FCritical);
  inherited Destroy();
end;

procedure TLogger.DestroyIPCSender();
begin
  if (FUsePipes) then
  begin
    if (FPipeClient <> nil) then
    begin
      FPipeClient.Disconnect();
      FreeAndNil(FPipeClient);
    end;
  end else
  begin
    if (FSenderPointer <> nil) then
    begin
      UnmapViewOfFile(FSenderPointer);
      FSenderPointer:= nil;
    end;

    if (FIPCHandle <> 0) then
      begin
        CloseHandle(FIPCHandle);
        FIPCHandle:= 0;
      end;

    if (FIPCMutex <> 0) then
      begin
        CloseHandle(FIPCMutex);
        FIPCMutex:= 0;
      end;
  end;
end;

procedure TLogger.IPCLog(const Msg: WideString);
begin
  if (FUsePipes) then
  begin
    FLogList.Clear();
    FLogList.Add(Msg);
    FPipeClient.SendStringW(FLogList.CommaText, INT_LOGINFO);
  end else
  begin
    if WaitForSingleObject(FIPCMutex, INFINITE) = WAIT_OBJECT_0 then
      try
        if FSenderPointer <> nil then
          begin
           FLogList.CommaText:= FSenderPointer;
           FLogList.Add(Msg);
           if (Length(FLogList.CommaText) < (INT_MAXFILESIZE div SizeOf(WideChar)) - 4) then
            lstrcpyW(FSenderPointer,PWideChar(FLogList.CommaText));
          end;
      finally
        ReleaseMutex(FIPCMutex);
      end;
  end;
end;

procedure TLogger.LoadLogSettings();
begin
  FLog := Settings.GetLog();
  FLogErrorsOnly := Settings.GetLogErrorsOnly();
  FVerbose := Settings.GetLogVerbose();
  FRealTime := Settings.GetLogRealTime();
end;


procedure TLogger.Log(const Msg: WideString; const Error, Verbose: boolean);
var
  FullMsg: WideString;
begin
  //Log the Msg if needed
  FCritical.Enter();
  try
    // First, check if the settings have been changed
    if NeedToReload() then
      LoadLogSettings();

    if not FFileOpen then
      Exit;

    if not FLog then
      Exit;

    if FLogErrorsOnly and not Error then
      Exit;

    if Verbose and not FVerbose then
      Exit;

    FullMsg := WS_NIL;
    if Error then
      FullMsg := WS_ERROR
    else
      FullMsg := WS_NOERROR;

    FullMsg := WideFormat(WS_LOGSTRING,
                            [FullMsg,WideString(DateTimeToStr(Now(),FS)),Msg],FS);

    PhFile.WriteLn(FullMsg);

    //If RealTime=true then, send the line to the InputQueue
    //as a message command
    if FRealTime then
      IPCLog(FullMsg);
  finally
    FCritical.Leave();
  end;

end;

procedure TLogger.Log(const Msg: WideString; const Error: boolean);
begin
  Log(Msg, Error, false);
end;

function TLogger.NeedToReload: boolean;
begin
  CS_LOG.Enter;
  try
    Result:= Flag_Log;
    if (Result) then
      Flag_Log:= BOOL_NO_NEED_TO_RELOAD;
  finally
    CS_LOG.Leave();
  end;
end;

function TLogger.OpenLogFile(): boolean;
begin
  PhFile:= TCobWideIO.Create(FLogFileName, true, false);

  FTools.GetFullAccess(FAppPath, FLogFileName);

  Result:= PhFile.IsOpen;
end;

end.
