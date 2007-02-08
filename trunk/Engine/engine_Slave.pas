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

// This thread reads the memory mapped file and executed the received commands

unit engine_Slave;

interface

uses
  Classes, SysUtils, Windows, TntClasses;

type
  TSlave = class(TThread)
  public
    constructor Create(const Sec: PSecurityAttributes);
    destructor Destroy(); override;
  private
    { Private declarations }
    FIPCSlaveMutex: THandle;
    FIPCHandle: Thandle;
    FCommandList: TTntStringList;
    FParams: TTntStringList;
    FN: WideString;
    FS: TFormatSettings;
    procedure Process(const Cmd, Param1,Param2,Param3: WideString);
    procedure SetLogFlag();
    procedure SetExecutorFlag();
    procedure SetSchedulerFlag();
    procedure SetSemaphoreAll();
    procedure SetSemaphoreSelected(const Param: WideString);
    procedure SetAbortFlag();
    procedure SetUIResponseFlag(const Value:cardinal);
    procedure LogCleanInfo(const Info: WideString);
  protected
    procedure Execute(); override;
  end;

var
  Slave: TSlave;

implementation

uses CobCommonW, bmConstants, bmCustomize, bmCommon, bmTranslator,
  engine_Logger;

{ TSlave }

constructor TSlave.Create(const Sec: PSecurityAttributes);
var
  MN: WideString;
begin
  inherited Create(true);
  GetLocaleFormatSettings(LOCALE_SYSTEM_DEFAULT, FS);
  //Creates the IPC tthat receives commands from the interface
  if (CobIs2000orBetterW()) then
    begin
      FN:= WideFormat(WS_MMFSLAVE,[WS_PROGRAMNAMELONG], FS);
      MN:= WideFormat(WS_MMFMUTEXSLAVE,[WS_PROGRAMNAMELONG], FS);
    end else
    begin
      FN:= WideFormat(WS_MMFSLAVEOLD,[WS_PROGRAMNAMELONG], FS);
      MN:= WideFormat(WS_MMFMUTEXSLAVEOLD,[WS_PROGRAMNAMELONG], FS);
    end;
    
  FIPCSlaveMutex:= CreateMutexW(sec, False, PWideChar(MN));
  FCommandList:= TTntStringList.Create();
  FParams:= TTntStringList.Create();
end;

destructor TSlave.Destroy();
begin
  FreeAndNil(FParams);
  FreeAndNil(FCommandList);
  if (FIPCSlaveMutex <> 0) then
    begin
      CloseHandle(FIPCSlaveMutex);
      FIPCSlaveMutex:= 0;
    end;
  inherited Destroy();
end;

procedure TSlave.Execute();
var
  FileStr: PWideChar;
  i: integer;
begin
  { Place thread code here }
    while not Terminated do
      begin
        if WaitForSingleObject(FIPCSlaveMutex, INFINITE) = WAIT_OBJECT_0 then
        try
          //The MMF should have been created by the client
          //try to open it
          FIPCHandle:=  OpenFileMappingW(FILE_MAP_ALL_ACCESS, False, PWideChar(FN));
          if (FIPCHandle <> 0) then
            begin
              FileStr:=  PWideChar(MapViewOfFile( FIPCHandle,
                                        File_Map_All_Access,
                                        0, 0, 0));

              if (FileStr <> nil) then
                begin
                  FCommandList.CommaText:= FileStr;
                  if (FCommandList.Count > 0) then
                    for i := 0 to FCommandList.Count - 1 do
                      begin
                        FParams.CommaText:= FCommandList[i];
                        if (FParams.Count = INT_FOURPARAMS) then
                          Process(FParams[0], FParams[1], FParams[2], FParams[3]);
                      end;
                  FCommandList.Clear();
                  lstrcpyW(FileStr,PWideChar(WS_NIL));
                  UnMapViewOfFile(FileStr);
                end;

              CloseHandle(FIPCHandle);
              FIPCHandle:= 0;
            end;
        finally
          ReleaseMutex(FIPCSlaveMutex);
        end;

        Sleep(INT_MMFSLAVESLEEP);
      end;
end;

procedure TSlave.LogCleanInfo(const Info: WideString);
var
  SL: TTntStringList;
  i: integer;
begin
  Sl:= TTntStringList.Create();
  try
    Sl.CommaText:= Info;
    for i:= 0 to Sl.Count - 1 do
    begin
      Logger.Log(Sl[i], false, false);
    end;
  finally
    FreeAndNil(Sl);
  end;
end;

procedure TSlave.Process(const Cmd, Param1,Param2,Param3: WideString);
var
  OldLanguage, NewLanguage: WideString;
begin
  if (Cmd = WS_CMDRELOADINI) then
    begin
      // Reload the settings and signalize
      // to other threads that they also need to reload
      OldLanguage:= Settings.GetLanguage();
      Settings.LoadSettings();
      // Reload the language if needed
      NewLanguage:= Settings.GetLanguage();
      if (WideUpperCase(OldLanguage) <> WideUpperCase(NewLanguage)) then
        Translator.LoadLanguage(NewLanguage);
      SetLogFlag();
      SetExecutorFlag();
      SetSchedulerFlag();
      Logger.Log(Translator.GetMessage('6'),false,false);
      Exit;
    end;

  if (Cmd = WS_CMDRELOADLIST) then
    begin
      Settings.LoadList();
      Logger.Log(Translator.GetMessage('7'), false, false);
      Exit;
    end;

  if (Cmd = WS_CMDCOPYLOG) then
    begin
      Logger.CopyTo(Param1);
      Exit;
    end;

  if (Cmd = WS_CMDDELETELOG) then
    begin
      Logger.DeletelogFile();
      Exit;
    end;

  if (Cmd = WS_CMDBACKUPALL) then
    begin
      SetSemaphoreAll();
      Exit;
    end;

  if (Cmd = WS_CMDUIRESPONSE) then
  begin
    SetUIResponseFlag(CobStrToIntW(Param1, INT_UINORESULT));
    Exit;
  end;

  if (Cmd = WS_CMDBACKUPSELECTED) then
    begin
      SetSemaphoreSelected(Param1);
      Exit;
    end;

  if (Cmd = WS_CMDLUNONEWVERSION) then
    begin
      // No new version is available
      Logger.Log(Translator.GetMessage('8'), false, false);
      Exit;
    end;

  if (Cmd = WS_CMDLUNEWVERSIONWARNING) then
    begin
      // No new version is available
      Logger.Log(Translator.GetMessage('9'), true, false);  // Error to give your attention
      LogCleanInfo(Param1);
      Exit;
    end;

  if Cmd = WS_CMDLUERROR then
    begin
      // Error while checking Live Update
      Logger.Log(WideFormat(Translator.GetMessage('10'), [Param1]), true, false);
      Exit;
    end;

    if (Cmd = WS_CMDABORT) then
    begin
      SetAbortFlag();
      Exit;
    end;


end;

procedure TSlave.SetAbortFlag();
begin
  //Set the abort flag
  CS_Abort.Enter();
  try
    Flag_Abort := BOOL_DOABORT;
  finally
    CS_Abort.Leave();
  end;
end;

procedure TSlave.SetExecutorFlag();
begin
  CS_Executor.Enter();
  try
    Flag_Executor:= BOOL_NEED_TO_RELOAD;
  finally
    CS_Executor.Leave();
  end;
end;

procedure TSlave.SetLogFlag();
begin
  CS_LOG.Enter();
  try
    Flag_Log:= BOOL_NEED_TO_RELOAD;
  finally
    CS_LOG.Leave();
  end;
end;

procedure TSlave.SetSchedulerFlag();
begin
  CS_Scheduler.Enter();
  try
    Flag_Scheduler:= BOOL_NEED_TO_RELOAD;
  finally
    CS_Scheduler.Leave();
  end;
end;

procedure TSlave.SetSemaphoreAll();
begin
  CS_Semaphore.Enter();
  try
    Flag_Sem_BU_All:= BOOL_BACKUP_ALL_NOW;
  finally
    CS_Semaphore.Leave();
  end;
end;

procedure TSlave.SetSemaphoreSelected(const Param: WideString);
begin
  CS_Semaphore.Enter();
  try
    Flag_Sem_BU_Some:= Param;
  finally
    CS_Semaphore.Leave();
  end;
end;

procedure TSlave.SetUIResponseFlag(const Value: cardinal);
begin
  CS_UIResponse.Enter();
  try
    Flag_UI_Response:= Value;
  finally
    CS_UIResponse.Leave();
  end;
end;

end.
