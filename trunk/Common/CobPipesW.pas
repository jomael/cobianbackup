{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~                                                            ~~~~~~~~~~
~~~~~~~~~~                  Copian Pipes Components                   ~~~~~~~~~~
~~~~~~~~~~               Copyright 2007 by Luis Cobian                ~~~~~~~~~~
~~~~~~~~~~                     cobian@educ.umu.se                     ~~~~~~~~~~
~~~~~~~~~~                    All rights reserved                     ~~~~~~~~~~
~~~~~~~~~~                                                            ~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

unit CobPipesW;

interface

uses Classes, Windows, SyncObjs, SysUtils;

const
  INT_MAXSTRING = 4000;

type
  TDataW = procedure (const Data: WideString; const MType: Byte) of object;
  TOnDone = procedure (const AHsnle: Thandle) of object;

  TCobPipeMessageW = record
    Size: DWORD;
    Kind: Byte;   // Some flag
    Count: DWORD; // Number of characters to send/receive #0
    Data: array[0..INT_MAXSTRING] of WideChar;
  end;

  TCobPipeToolsW = class
  private
  public
    constructor Create();
    destructor Destroy();override;
    function GetGoodPipeNameW(const AName: WideString): WideString;
    function CalculateMsgSizeW(const AMsg: TCobPipeMessageW): DWORD;
  end;

  TCobPipeClientW = class
  private
    FPipeName: WideString;
    FSec: PSecurityAttributes;
    FTool: TCobPipeToolsW;
    FHandle: THandle;
    FOverlapped: TOverlapped;
    FS: TFormatSettings;
    procedure StartClient();
    procedure StopClient();
    function SendObjMessageW(AMsg: TCobPipeMessageW): boolean;
  public
    constructor Create(const PipeName: WideString; const Sec: PSecurityAttributes);
    destructor Destroy();override;
    function SendStringW(const AMsg: WideString; const MsgType: DWORD): boolean;
    function IsConnected(): boolean;
    function Connect(): boolean;
    procedure Disconnect();
  end;

  TCobReader = class(TThread)
  private
    FHandle: THandle;
    FObject: TObject;
    FReceived: WideString;
    FKind: byte;
    FOverlapped: TOverlapped;
    FSec: PSecurityAttributes;
    FS: TFormatSettings;
    procedure SendData();
  public
    OnDone: TOnDone;
    constructor Create(const pHandle:Thandle;const Obj: TObject;
                        const Sec:PSecurityAttributes);
    destructor Destroy();override;
  protected
    procedure Execute();override;
  end;

  TCobListener = class(TThread)
  private
    FPipeName: WideString;
    FParent: TObject;
    FSec: PSecurityAttributes;
    FClients: TThreadList;
    FOverlapped: TOverlapped;
    FCritical: TCriticalSection;
    FCount: integer;
    FS: TFormatSettings;
    procedure ClearClients();
    procedure OnDone(const AHandle: THandle);
  public
    constructor Create(const PipeName: WideString;
                      const AParent: TObject;
                      const Sec:PSecurityAttributes);
    destructor Destroy();override;
    function ClientCount(): integer;
  protected
    procedure Execute();override;
  end;

  TCobPipeServerW = class
  private
    FPipeName: WideString;
    FSec: PSecurityAttributes;
    FTool: TCobPipeToolsW;
    FCritical: TCriticalSection;
    FListener: TCobListener;
    procedure CreateListener();
    procedure FreeListener();
  public
    OnReceive: TDataW;
    constructor Create(const PipeName: WideString;
                       const Sec: PSecurityAttributes);
    destructor Destroy();override;
    procedure Synchronization(const Data: WideString; const Kind: byte);
    function ClientCount(): integer;
  end;

implementation

uses CobCommonW;

const
  WS_NIL: WideString = '';
  WS_PIPEBNAME: WideString = '\\.\pipe\';
  INT_SLEEP = 200;
  INT_NORMALMESSAGE = 0;
  INT_BUFFEROVERFLOW = 255;
  INT_THREADCLOSE = 254;
  INVALID_SET_FILE_POINTER = DWORD(-1);
  INT_TIMEOUT = 200;
  INT_BUFFERSIZE = 8192;
  WS_COBEVENTLISTENER: WideString = 'Global\%s';
  WS_COBEVENTLISTENEROLD: WideString = '%s';
  WS_COBEVENTREADER: WideString = 'Global\%s';
  WS_COBEVENTREADEROLD: WideString = '%s';
  WS_COBEVENTSENDER: WideString = 'Global\%s';
  WS_COBEVENTSENDEROLD: WideString = '%s';

{ TCobPipeServerW }

function TCobPipeServerW.ClientCount(): integer;
begin
  Result:= FListener.ClientCount();
end;

constructor TCobPipeServerW.Create(const PipeName: WideString;
  const Sec: PSecurityAttributes);
begin
  FCritical:= TCriticalSection.Create();
  FTool:= TCobPipeToolsW.Create();
  FPipeName:= FTool.GetGoodPipeNameW(PipeName);
  FSec:= Sec;
  CreateListener();
end;

procedure TCobPipeServerW.CreateListener();
begin
  FListener:= TCobListener.Create(FPipeName, self, FSec);
  FListener.FreeOnTerminate:= false;
  FListener.Resume();
end;

destructor TCobPipeServerW.Destroy();
begin
  FreeListener();
  FreeAndNil(FTool);
  FreeAndNil(FCritical);
  inherited Destroy();
end;

procedure TCobPipeServerW.FreeListener();
begin
  FListener.Terminate();
  FListener.WaitFor();
  FreeAndNil(FListener);
end;

procedure TCobPipeServerW.Synchronization(const Data: WideString;
  const Kind: byte);
begin
  FCritical.Acquire();
  try
    if (Assigned(OnReceive)) then
      OnReceive(Data, Kind);
  finally
    FCritical.Release();
  end;
end;

{ TCobPipeToolsW }

function TCobPipeToolsW.CalculateMsgSizeW(const AMsg: TCobPipeMessageW): DWORD;
begin
 Result:= SizeOf(AMsg.Size) + Sizeof(AMsg.Kind) + Sizeof(AMsg.Count) +
              AMsg.Count + 1*Sizeof(WideChar);
end;

constructor TCobPipeToolsW.Create();
begin
  inherited Create();
end;

destructor TCobPipeToolsW.Destroy();
begin
  inherited Destroy();
end;

function TCobPipeToolsW.GetGoodPipeNameW(const AName: WideString): WideString;
begin
  // You can pass the name of the pipe completly or only the last part
  Result:= AName;
  if (Pos(WS_PIPEBNAME, Result) = 0) then
    Result:= WS_PIPEBNAME + AName;
end;

{ TCobListener }

procedure TCobListener.ClearClients();
var
  i: integer;
  Client: TCobReader;
begin
  with FClients.LockList() do
  try
    for i := Count -1 downto 0 do
    begin
      Client:= Items[i];
      Client.Terminate();
      Client.WaitFor();
      FreeAndNil(Client);
    end;
    Clear();
  finally
    FClients.UnlockList();
  end;
end;

function TCobListener.ClientCount: integer;
begin
  FCritical.Enter();
  try
    Result:= FCount;
  finally
    FCritical.Leave();
  end;
end;

constructor TCobListener.Create(const PipeName: WideString;
                                const AParent: TObject;
                                const Sec: PSecurityAttributes);
var
  EventName: WideString;
  GUID: TGUID;
begin
  inherited Create(true); // create suspended
  FPipeName:= PipeName;
  FParent:= AParent;
  FCount:= 0;
  FSec:= Sec;
  GetLocaleFormatSettings(LOCALE_SYSTEM_DEFAULT, FS);
  CreateGUID(GUID);
  if (CobIs2000orBetterW()) then
    EventName:= WideFormat(WS_COBEVENTLISTENER,[WideString(GUIDToString(GUID))],FS) else
    EventName:= WideFormat(WS_COBEVENTLISTENEROLD,[WideString(GUIDToString(GUID))],FS);

  FCritical:= TCriticalSection.Create();
  FOverlapped.hEvent:= CreateEventW(FSec, true, false, PWideChar(EventName));
  FClients:= TThreadList.Create();
end;

destructor TCobListener.Destroy();
begin
  ClearClients();
  FreeAndNil(FClients);
  if (FOverlapped.hEvent <> 0) then
    CloseHandle(FOverlapped.hEvent);
  FreeAndNil(FCritical);
  inherited Destroy();
end;

procedure TCobListener.Execute();
var
  hPipe: THandle;
  fConnected: boolean;
  Client: TCobReader;
begin
  while not Terminated do
  begin
    fConnected:= false;
    
    // Create a new pipe for every connection
    hPipe := CreateNamedPipeW(PWideChar(FPipeName),
            PIPE_ACCESS_INBOUND or FILE_FLAG_OVERLAPPED,
            PIPE_TYPE_MESSAGE or PIPE_WAIT or PIPE_READMODE_MESSAGE,
            PIPE_UNLIMITED_INSTANCES,
            INT_BUFFERSIZE,
            INT_BUFFERSIZE,
            INT_TIMEOUT,
            FSec);

    if (hPipe = INVALID_HANDLE_VALUE) then
      Break;

    while not Terminated do     //loop to wait for the connection
    begin
      fConnected := ConnectNamedPipe(hPipe, @FOverlapped) or
                    (GetLastError = ERROR_PIPE_CONNECTED);

      while not (fConnected or Terminated) do
        fConnected := WaitForSingleObject(FOverlapped.hEvent, INT_TIMEOUT) <> WAIT_TIMEOUT;

      if not Terminated then
      begin
        ResetEvent(FOverlapped.hEvent);
        if fConnected then
          begin
            FCritical.Enter();
            try
              inc(Fcount);
            finally
              FCritical.Leave();
            end;
            Client:= TCobReader.Create(hPipe, FParent, FSec);
            Client.FreeOnTerminate:= false;
            Client.OnDone:= OnDone;
            Client.Resume();
            with FClients.LockList() do
            try
              Add(Client);
            finally
              FClients.UnlockList();
            end;
            Break;  // Exit this loop and create a new pipe for the next connection
          end;
      end;  // not terminated
      Sleep(INT_SLEEP);
    end; // Second loop

    if (not fConnected) then    //if connected, the handled will be closed on the next thread
      if (hPipe <> INVALID_HANDLE_VALUE) then
        CloseHandle(hPipe);
    Sleep(INT_SLEEP);
  end; // while
end;

procedure TCobListener.OnDone(const AHandle: THandle);
begin
  FCritical.Acquire();
  try
   Dec(FCount);
  finally
    FCritical.Release();
  end;
end;

{ TCobReader }

constructor TCobReader.Create(const pHandle: Thandle; const Obj: TObject;
                              const Sec:PSecurityAttributes);
var
  EventName: WideString;
  GUID: TGUID;
begin
  inherited Create(true);
  FHandle:= pHandle;
  FObject:= Obj;
  FSec:= Sec;
  GetLocaleFormatSettings(LOCALE_SYSTEM_DEFAULT, FS);

  CreateGUID(GUID);

  if (CobIs2000orBetterW()) then
    EventName:= WideFormat(WS_COBEVENTREADER,[WideString(GUIDToString(GUID))],FS) else
    EventName:= WideFormat(WS_COBEVENTREADEROLD,[WideString(GUIDToString(GUID))],FS);
  
  FOverlapped.hEvent:= CreateEventW(FSec, true, false, PWideChar(EventName));
end;

destructor TCobReader.Destroy();
begin
  FlushFileBuffers(FHandle);
  DisconnectNamedPipe(FHandle);
  if (FOverlapped.hEvent <> 0) then
    CloseHandle(FOverlapped.hEvent);
  CloseHandle(FHandle);
  inherited Destroy();
end;

procedure TCobReader.Execute();
var
  InMsg: TCobPipeMessageW;
  aResult: boolean;
  Received, Err, RWait, ActuallyRead: cardinal;
  //***********************************************
  procedure  GetData();
  begin
    if GetOverlappedResult(FHandle, FOverlapped, ActuallyRead, false) then
    begin
      FReceived:= WideString(InMsg.Data);
      FKind:= InMsg.Kind;
      SendData();
    end;
  end;
    //*********************************************
begin
  while not Terminated do
  begin

    aResult := ReadFile(FHandle, InMsg, SizeOf(TCobPipeMessageW), Received, @FOverlapped);

    if not aResult then      // a problem, but it can be a pending operation
    begin
      Err := GetLastError();

      if Err = ERROR_IO_PENDING then
      begin
        repeat
          RWait:=  WaitForSingleObject(FOverlapped.hEvent, INT_TIMEOUT);
        until (RWait <> WAIT_TIMEOUT) or Terminated;
          // asynchronous i/o is still in progress
          // wait for the operation to end
        if (RWait = WAIT_OBJECT_0) then
          GetData();
      end else
      begin
        {if (Err = ERROR_HANDLE_EOF) then      //We have reached the EOF
        begin
          FReceived:= WideString(InMsg.Data);
          FKind:= InMsg.Kind;
          SendData();
        end; }

        if (Err = ERROR_BROKEN_PIPE) then
          Break;

        if Err <> ERROR_NO_DATA then                            //connection was killed
          Break; 
      end;
    end else
      GetData();

    Sleep(INT_TIMEOUT);
  end;

  // I don't use OnTerminate because it depends on Synchronize, which
  // depends on the message loop
  if (Assigned(OnDone)) then
    OnDone(FHandle);
end;

procedure TCobReader.SendData();
begin
  //No need to synchronize because Syncronizer uses a TCriticalSection
  if FObject <> nil then
    if (FObject is TCobPipeServerW) then
      (FObject as TCobPipeServerW).Synchronization(FReceived, FKind);
end;

{ TCobPipeClientW }

function TCobPipeClientW.Connect(): boolean;
begin
  if (FHandle <> INVALID_HANDLE_VALUE) then
    StopClient();

  StartClient();
  Result:= (FHandle <> INVALID_HANDLE_VALUE);
end;

constructor TCobPipeClientW.Create(const PipeName: WideString;
  const Sec: PSecurityAttributes);
var
  EventName: WideString;
  GUID: TGUID;
begin
  FTool:= TCobPipeToolsW.Create();
  FPipeName:= FTool.GetGoodPipeNameW(PipeName);
  FSec:= Sec;
  GetLocaleFormatSettings(LOCALE_SYSTEM_DEFAULT, FS);
  CreateGUID(GUID);
  
  if (CobIs2000orBetterW()) then
    EventName:= WideFormat(WS_COBEVENTSENDER,[WideString(GUIDToString(GUID))],FS) else
    EventName:= WideFormat(WS_COBEVENTSENDEROLD,[WideString(GUIDToString(GUID))],FS);

  FOverlapped.hEvent:= CreateEventW(FSec, true, false, PWideChar(EventName));

  FHandle:= INVALID_HANDLE_VALUE;
  
  StartClient();
end;

destructor TCobPipeClientW.Destroy();
begin
  StopClient();
  if (FOverlapped.hEvent <> 0) then
    CloseHandle(FOverlapped.hEvent);
  FreeAndNil(FTool);
  inherited Destroy();
end;

procedure TCobPipeClientW.Disconnect();
begin
  StopClient();
end;

function TCobPipeClientW.IsConnected(): boolean;
begin
  Result:= FHandle <> INVALID_HANDLE_VALUE;
end;

function TCobPipeClientW.SendObjMessageW(AMsg: TCobPipeMessageW): boolean;
var                                
  Written, Err, RWait: cardinal;
  aResult: boolean;
begin
  Result:= false;
  AMsg.Size:= FTool.CalculateMsgSizeW(AMsg);
  if FHandle = INVALID_HANDLE_VALUE then
    StartClient(); // try to connect first, again

  if FHandle <> INVALID_HANDLE_VALUE then
  begin
    aResult:= WriteFile(FHandle, AMsg, SizeOf(TCobPipeMessageW), Written, nil);
    if not aResult then
    begin
      Err:= GetLastError();

      if (Err = ERROR_IO_PENDING) then
      begin
        repeat
          RWait:=  WaitForSingleObject(FOverlapped.hEvent, INT_TIMEOUT);
        until (RWait <> WAIT_TIMEOUT);
          // asynchronous i/o is still in progress
          // wait for the operation to end
        if (RWait = WAIT_OBJECT_0) then
          Result:= true;
      end;
    end else
      Result:= true;

    // if failed, the server may be gone
    if not Result then
      StopClient();
  end;
end;

function TCobPipeClientW.SendStringW(const AMsg: WideString;
  const MsgType: DWORD): boolean;
var
  OutMsg: TCobPipeMessageW;
begin
  OutMsg.Kind:= MsgType;
  // Protect for buffer overflow
  OutMsg.Count:= Length(AMsg);
  if (OutMsg.Count > INT_BUFFERSIZE) then
  begin
    OutMsg.Count:= 0;  //Send an error
    OutMsg.Kind:= INT_BUFFEROVERFLOW;
    CobWideStringToArray(OutMsg.Data, WS_NIL);
  end else
    CobWideStringToArray(OutMsg.Data, AMsg);
  Result:= SendObjMessageW(OutMsg);
end;

procedure TCobPipeClientW.StartClient();
var
  Mode: cardinal;
begin
  if WaitNamedPipeW(PWideChar(FPipeName),NMPWAIT_USE_DEFAULT_WAIT) then
  begin
    FHandle:= CreateFileW(PWideChar(FPipeName),
              GENERIC_WRITE, FILE_SHARE_WRITE, FSec,
              CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
    if FHandle <> INVALID_HANDLE_VALUE then
    begin
      Mode:= PIPE_READMODE_MESSAGE or PIPE_WAIT;
      SetNamedPipeHandleState(FHandle, Mode, nil, nil);
    end;
  end;
end;

procedure TCobPipeClientW.StopClient();
begin
  if FHandle <> INVALID_HANDLE_VALUE then
    CloseHandle(FHandle);
  FHandle:= INVALID_HANDLE_VALUE;
end;

end.
