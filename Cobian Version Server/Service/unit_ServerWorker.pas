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
  FLog.Log(S_ERROR, AException.Message, S_NIL);
end;

procedure TWorker.OnListenException(AThread: TIdListenerThread;
  AException: Exception);
begin
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

procedure TLogger.Log(const IP, App, Version: string);
begin
  FCS.Enter();
  try
    WriteLn(FLog, Format(S_LOGSTRING,[DateTimeToStr(Now(),FS),IP, App, Version],FS));
    Flush(Flog);
  finally
    FCS.Leave();
  end;
end;

end.
