unit unit_ServerWorker;

interface

uses
  Classes, SysUtils, Windows, IdBaseComponent, IdComponent, IdCustomTCPServer, IdTCPServer,
  IdContext, Registry, SyncObjs;

type
 TLogger = class(TObject)
  private
    FCS: TCriticalSection;
    FAppPath: string;
    FLogName: string;
    FLog: TextFile;
    FS: TFormatSettings;
    procedure ResetFile();
    function GetGoodFileName(const Original: string): string;
  public
    constructor Create();
    destructor Destroy(); override;
    procedure Log(const IP, App, Version: string);
  end;


  TWorker = class(TThread)
  public
    constructor Create();
    destructor Destroy();override;
  private
    { Private declarations }
    FCounter: integer;
    FBlob: TStringList;
    FMutex: THandle;
    FS: TFormatSettings;
    FSec: TSecurityAttributes;
    p: PSECURITY_DESCRIPTOR;
    FAppPath: string;
    FListName: string;
    FFlag: string;
    FServer: TidTCPServer;
    FLog: TLogger;
    FCS: TCriticalSection;
    procedure ServerExecute(AThread: TIdContext);
    procedure OnListenException(AThread: TIdListenerThread; AException: Exception);
    procedure OnException(AThread: TIdContext; AException: Exception);
    procedure LoadList();
    function GetVersion(const AName: string; var Home,Info: string): string;
  protected
    procedure Execute(); override;
  end;

implementation

{ TWorker }
uses CobCommon, unit_Common;

constructor TWorker.Create();
var
  MutexName: string;
begin
  inherited Create(true);
  FCounter:= 0;
  GetLocaleFormatSettings(LOCALE_SYSTEM_DEFAULT, FS);
  FAppPath:= CobGetAppPath();
  FListName:= CobSetBackSlash(FAppPath) + Format(S_VERSIONSFILE,[S_APPNAME],FS);
  FFlag:= CobSetBackSlash(FAppPath) + Format(S_FLAG,[S_APPNAME],FS);
  FLog:= TLogger.Create();
  FBlob:= TStringList.Create();
  if (CobIs2000orBetter) then
    MutexName:= Format(S_MUTEXNAME,[S_APPNAME],FS) else
    MutexName:= Format(S_MUTEXNAMEOLD,[S_APPNAME],FS);
  FSec:= CobGetNullDaclAttributes(p);
  FMutex:= CreateMutex(@FSec,false,PChar(MutexName));

  FCS:= TCriticalSection.Create();

  LoadList();

  FServer:= TIdTCPServer.Create(nil);
  FServer.DefaultPort:= INT_DEFPORT;
  FServer.OnExecute:= ServerExecute;
  FServer.OnListenException:= OnListenException;
  FServer.OnException:= OnException;
  FServer.Active:= true;
end;

destructor TWorker.Destroy();
begin
  FServer.Active:= false;
  FreeAndNil(FServer);
  FreeAndNil(FCS);
  if (FMutex <> 0) then
    CloseHandle(FMutex);
  CobFreeNullDaclAttributes(p);
  FreeAndNil(FBlob);
  FreeAndNil(FLog);
  inherited Destroy();
end;

procedure TWorker.Execute();
begin
  while not Terminated do
  begin
    inc(FCounter);
    if FCounter >= INT_30 then
    begin
      if (FileExists(FFlag)) then
      begin
        LoadList();
        DeleteFile(PChar(FFlag));
      end;
      FCounter:= 0;
    end;
    Sleep(INT_SLEEP);
  end;
end;

function TWorker.GetVersion(const AName: string; var Home,Info: string): string;
var
  i: integer;
  Element: TAVElement;
  ANameUp: string;
begin
  FCS.Enter();
  Element:= TAVElement.Create();
  try
    Result:= S_NIL;
    Home:= S_NIL;
    Info:= S_NIL;
    ANameUp:= UpperCase(AName);
    for i:= 0 to FBlob.Count - 1 do
    begin
      Element.StrToElement(FBlob[i]);
      if (ANameUp = UpperCase(Element.App)) then
      begin
        Result:= Element.Ver;
        Home:= Element.Home;
        Info:= Element.Info;
        Break;
      end;
    end;
  finally
    FreeAndNil(Element);
    FCS.Leave();
  end;
end;

procedure TWorker.LoadList();
begin
  FCS.Enter();
  if (WaitForSingleObject(FMutex, INFINITE) = WAIT_OBJECT_0) then
  try
    if (not FileExists(FListName)) then
      CobCreateEmptyTextFile(FListName);
    FBlob.LoadFromFile(FListName);
  finally
    ReleaseMutex(FMutex);
    FCS.Leave();
  end;
end;

procedure TWorker.OnException(AThread: TIdContext; AException: Exception);
begin
  if Pos(S_DISCONNECTED ,AException.Message) = 0 then
    FLog.Log(S_ERROR, AException.Message, S_NIL);
end;

procedure TWorker.OnListenException(AThread: TIdListenerThread;
  AException: Exception);
begin
  if Pos(S_DISCONNECTED ,AException.Message) = 0 then
    FLog.Log(S_ERROR, AException.Message, S_NIL);
end;

procedure TWorker.ServerExecute(AThread: TIdContext);
var
  s, Ver, Home, Info: string;
  FSl: TStringList;
begin
  s:=AThread.Connection.IOHandler.ReadLn();
  if (Pos(S_COBIANHEADER,s) = 1) then
  begin
    Delete(s,1,Length(S_COBIANHEADER));
    Ver:= GetVersion(s,Home,Info);
    FSl:= TStringList.Create();
    try
      FSl.Add(Ver);
      FSl.Add(Home);
      FSl.Add(Info);
      AThread.Connection.IOHandler.WriteLn(FSl.CommaText);
    finally
      FreeAndNil(FSl);
    end;
  end else
  begin
    // old method
    FLog.Log(AThread.Connection.Socket.Binding.PeerIP,s,S_NIL);
    Ver:= GetVersion(s,Home,Info);
    AThread.Connection.IOHandler.WriteLn(Ver);
  end;
end;

{ TLogger }

constructor TLogger.Create();
begin
  inherited Create();
  GetLocaleFormatSettings(LOCALE_SYSTEM_DEFAULT,FS);
  FAppPath:= CobGetAppPath();
  FCS:= TCriticalSection.Create();
  FLogName:= CobSetBackSlash(FAppPath) + Format(S_LOG,[S_APPNAME], FS);
  if (not FileExists(FLogName)) then
    CobCreateEmptyTextFile(FLogName);
  AssignFile(FLog, FLogName);
  Append(FLog);
end;

destructor TLogger.Destroy();
begin
  CloseFile(FLog);
  FreeAndNil(FCS);
  inherited Destroy();
end;

function TLogger.GetGoodFileName(const Original: string): string;
begin
  Result:= Original;
  // Some file names could have a date-time that contains : or /
  if (Pos(C_COLON, Result) > 0) then
    Result:= StringReplace(Result, C_COLON, C_SEMICOLON, [rfReplaceAll, rfIgnoreCase]);

  if (Pos(C_SLASH, Result) > 0) then
    Result:= StringReplace(Result, C_SLASH, C_SLASDASH,  [rfReplaceAll, rfIgnoreCase]);

  if (Pos(C_BACKSLASH, Result) > 0) then
    Result:= StringReplace(Result, C_BACKSLASH, C_SLASDASH, [rfReplaceAll, rfIgnoreCase]);

  if (Pos(C_ASTERISC, Result) > 0) then
    Result:= StringReplace(Result, C_ASTERISC, C_SLASDASH, [rfReplaceAll, rfIgnoreCase]);

  if (Pos(C_QUESTION, Result) > 0) then
    Result:= StringReplace(Result, C_QUESTION, C_SLASDASH, [rfReplaceAll, rfIgnoreCase]);

  if (Pos(C_MORETHAN, Result) > 0) then
    Result:= StringReplace(Result, C_MORETHAN, C_SLASDASH, [rfReplaceAll, rfIgnoreCase]);

  if (Pos(C_LESSTHAN, Result) > 0) then
    Result:= StringReplace(Result, C_LESSTHAN, C_SLASDASH,[rfReplaceAll, rfIgnoreCase]);

  if (Pos(C_PIPE, Result) > 0) then
    Result:= StringReplace(Result, C_PIPE, C_SLASDASH, [rfReplaceAll, rfIgnoreCase]);
end;

procedure TLogger.Log(const IP, App, Version: string);
var
  NeedToReset: boolean;
begin
  FCS.Enter();
  try
    NeedToReset:= false;
    WriteLn(FLog, Format(S_LOGSTRING,[DateTimeToStr(Now(),FS),IP, App, Version],FS));
    Flush(Flog);
    // 2007-03-07 by Luis Cobian
    // The service used to hang when the file got too big
    if (FileSize(FLog) > INT_FILELIMIT) then
      NeedToReset:= true;
  finally
    FCS.Leave();
  end;

  if NeedToReset then
    ResetFile();
end;

procedure TLogger.ResetFile();
var
  NewName: string;
begin
  FCS.Enter();
  try
    CloseFile(FLog);
    NewName:= CobSetBackSlash(FAppPath) +
              Format(S_LOG,[S_APPNAME +  S_SPACE +
              GetGoodFileName(DateTimeToStr(Now(),FS))], FS);
    RenameFile(FLogName, Newname);
    DeleteFile(PChar(FLogName));
    if (not FileExists(FLogName)) then
      CobCreateEmptyTextFile(FLogName);
    AssignFile(FLog, FLogName);
    Append(FLog);
  finally
    FCS.Leave();
  end;
end;

end.
