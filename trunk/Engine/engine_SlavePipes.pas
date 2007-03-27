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

unit engine_SlavePipes;

interface

uses Classes, Windows, SysUtils, CobPipesW, TntClasses;

type

TSlavePipe = class(TTHread)
private
  FS: TFormatSettings;
  FServer: TCobPipeServerW;
  FCommandList: TTntStringList;
  FParams: TTntStringList;
  procedure OnReceive(const Msg: WideString; const Kind: byte);
  procedure Process(const Cmd, Param1,Param2,Param3: WideString);
  procedure SetLogFlag();
  procedure SetExecutorFlag();
  procedure SetSchedulerFlag();
  procedure SetSemaphoreAll();
  procedure SetSemaphoreSelected(const Param: WideString);
  procedure SetAbortFlag();
  procedure SetUIResponseFlag(const Value:cardinal);
  procedure LogCleanInfo(const Info: WideString);
public
  constructor Create(const Sec: PSecurityAttributes);
  destructor Destroy();override;
protected
  procedure Execute();override;
end;

var
  SlavePipe: TSlavePipe;

implementation

uses bmCustomize, bmConstants, bmCommon, bmTranslator, engine_Logger, CobCommonW;

{ TSlavePipe }

constructor TSlavePipe.Create(const Sec: PSecurityAttributes);
var
  AName: WideString;
begin
  inherited Create(true);
  GetLocaleFormatSettings(LOCALE_SYSTEM_DEFAULT, FS);
  AName:= WideFormat(WS_INTTOENGINEPIPE,[WS_PROGRAMNAMESHORTNOISPACES],FS);
  FCommandList:= TTntStringList.Create();
  FParams:= TTntStringList.Create();
  FServer:= TCobPipeServerW.Create(AName, Sec);
  FServer.OnReceive:= OnReceive;
end;

destructor TSlavePipe.Destroy();
begin
  FreeAndNil(FServer);
  FreeAndNil(FParams);
  FreeAndNil(FCommandList);
  inherited Destroy();
end;

procedure TSlavePipe.Execute();
begin
  while not Terminated do
  begin
    Sleep(INT_MMFSLAVESLEEP);
  end;
end;

procedure TSlavePipe.LogCleanInfo(const Info: WideString);
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

procedure TSlavePipe.OnReceive(const Msg: WideString; const Kind: byte);
var
  i: integer;
begin
  if (Msg <> WS_NIL) then
  begin
    FCommandList.CommaText:= Msg;
    for i:= 0 to FCommandList.Count - 1 do
    begin
       FParams.CommaText:= FCommandList[i];
       if (FParams.Count = INT_FOURPARAMS) then
        Process(FParams[0], FParams[1], FParams[2], FParams[3]);
    end;
    FCommandList.Clear();
  end;
end;

procedure TSlavePipe.Process(const Cmd, Param1, Param2, Param3: WideString);
var
  OldLanguage, NewLanguage: WideString;
begin
  // Because this class is a quick fix for the program to work
  // fine in Vista, I simply copy and paste this procedure from
  // the old MMF class. To make it better, I would need to create
  // a common class containing this method and just derive both classes
  // from it.... but I'm lazy...  It's only one method anyway :-)

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

procedure TSlavePipe.SetAbortFlag();
begin
  //Set the abort flag
  CS_Abort.Enter();
  try
    Flag_Abort := BOOL_DOABORT;
  finally
    CS_Abort.Leave();
  end;
end;

procedure TSlavePipe.SetExecutorFlag();
begin
  CS_Executor.Enter();
  try
    Flag_Executor:= BOOL_NEED_TO_RELOAD;
  finally
    CS_Executor.Leave();
  end;
end;

procedure TSlavePipe.SetLogFlag();
begin
  CS_LOG.Enter();
  try
    Flag_Log:= BOOL_NEED_TO_RELOAD;
  finally
    CS_LOG.Leave();
  end;
end;

procedure TSlavePipe.SetSchedulerFlag();
begin
  CS_Scheduler.Enter();
  try
    Flag_Scheduler:= BOOL_NEED_TO_RELOAD;
  finally
    CS_Scheduler.Leave();
  end;
end;

procedure TSlavePipe.SetSemaphoreAll();
begin
  CS_Semaphore.Enter();
  try
    Flag_Sem_BU_All:= BOOL_BACKUP_ALL_NOW;
  finally
    CS_Semaphore.Leave();
  end;
end;

procedure TSlavePipe.SetSemaphoreSelected(const Param: WideString);
begin
  CS_Semaphore.Enter();
  try
    Flag_Sem_BU_Some:= Param;
  finally
    CS_Semaphore.Leave();
  end;
end;

procedure TSlavePipe.SetUIResponseFlag(const Value: cardinal);
begin
  CS_UIResponse.Enter();
  try
    Flag_UI_Response:= Value;
  finally
    CS_UIResponse.Leave();
  end;
end;

end.
