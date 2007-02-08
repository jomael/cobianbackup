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

// The main code for the engine

library  cbEngine;

uses
  SysUtils,
  CobCommonW,
  SyncObjs,
  TntSysUtils,
  Classes,
  TntClasses,
  Windows,
  ShellApi,
  bmCustomize in '..\Common\bmCustomize.pas',
  bmCommon in '..\Common\bmCommon.pas',
  bmConstants in '..\Common\bmConstants.pas',
  bmTranslator in '..\Common\bmTranslator.pas',
  engine_Logger in 'engine_Logger.pas',
  engine_Slave in 'engine_Slave.pas',
  engine_Scheduler in 'engine_Scheduler.pas',
  engine_Executor in 'engine_Executor.pas',
  engine_Mailer in 'engine_Mailer.pas',
  engine_Copier in 'engine_Copier.pas',
  bmEncryptor in '..\Common\bmEncryptor.pas',
  engine_Zipper in 'engine_Zipper.pas',
  engine_SQX in 'engine_SQX.pas',
  bmFTP in '..\Common\bmFTP.pas';

{$R *.res}


procedure CreateCriticalSections();
begin
  // These flags tell to all the threads if is time to reload
  // the settings, abort the current operation, etc
  Flag_Log:= BOOL_NO_NEED_TO_RELOAD;
  CS_LOG:= TCriticalSection.Create();
  // Flag_BU:= BOOL_NO_NEED_TO_BACKUP;
  // CS_BU:= TCriticalSection.Create();
  Flag_Autoclose:= BOOL_NO_AUTOCLOSE;
  CS_AutoClose:= TCriticalSection.Create();
  Flag_Executor:= BOOL_NO_NEED_TO_RELOAD;
  CS_Executor:= TCriticalSection.Create();
  Flag_Scheduler:= BOOL_NO_NEED_TO_RELOAD;
  CS_Scheduler:= TCriticalSection.Create();
  Flag_Sem_BU_All:= BOOL_NO_NEED_TO_BACKUP;
  Flag_Sem_BU_Some:= WS_NIL;
  CS_Semaphore:= TCriticalSection.Create();
  Flag_Abort:= BOOL_CONTINUE;
  CS_Abort:= TCriticalSection.Create();
  CS_UIResponse:= TCriticalSection.Create();
  Flag_UI_Response:= INT_UINORESULT;
end;

procedure DestroyCriticalSections();
begin
  FreeAndNil(CS_UIResponse);
  FreeAndNil(CS_Abort);
  FreeAndNil(CS_Semaphore);
  FreeAndNil(CS_Scheduler);
  FreeAndNil(CS_Executor);
  FreeAndNil(CS_AutoClose);
  // FreeAndNil(CS_BU);
  FreeAndNil(CS_LOG);
end;

function GetSystemInfo(const Serv: boolean): WideString;
var
  Ver, Service, OS: WideString;
begin
  //This method gets the OS build number and engine version
  Result := WS_NIL;
  OS := WideFormat(WS_OSBUILD, [Win32MajorVersion, Win32MinorVersion,
    Win32BuildNumber]);
  if Serv then
    Service := Translator.GetMessage('S_YES')
  else
    Service := Translator.GetMessage('S_NO');
  Ver := CobGetVersionW(WS_NIL);
  Result := WideFormat(Translator.GetMessage('2'), [Ver, OS, Service]);
end;

procedure CreateSlaveIPC();
begin
  // This thread will receive the commands from the UI
  // in previous versions, this was implemented as TCP/IP
  // It uses now MMF
  Slave:= TSlave.Create(@Globals.Sec); 
  Slave.FreeOnTerminate:= false;
  Slave.Resume();   
end;

procedure DestroySlaveIPC();
begin
  if (Slave <> nil) then
    begin
      Slave.Terminate();
      Slave.WaitFor();
      FreeAndNil(Slave);
    end;
end;


procedure CreateBackupQueue();
begin
  // The queue with the tasks to execute
  BackupQueue:= TThreadList.Create();
  BackupQueue.Duplicates:= dupAccept;
end;

procedure DestroyBackupQueue();
begin
  if (BackupQueue <> nil) then
    begin
      ClearBUList();
      FreeAndNil(BackupQueue);
    end;
end;

procedure LogHello(const Serv: boolean);
begin
  Logger.Log(WideFormat(Translator.GetMessage('1'),[WS_PROGRAMNAMELONG]),false,false);
  Logger.Log(GetSystemInfo(Serv),false,false);
end;

procedure LogTempWarning();
begin
  Logger.Log(WideFormat(Translator.GetMessage('632'),[Settings.GetTemp()]),true,false);
end;

procedure CreateScheduler();
begin
  Scheduler:= TScheduler.Create(Globals.AppPath);
  Scheduler.FreeOnTerminate:= false;
  Scheduler.Resume();
end;

procedure DestroyScheduler();
begin
  if (Scheduler <> nil) then
    begin
      Scheduler.Terminate();
      Scheduler.WaitFor();
      FreeAndNil(Scheduler);
    end;
end;

procedure CreateExecutor(const IsService: boolean);
begin
  Executor:= TExecutor.Create(Globals.AppPath, IsService, @Globals.Sec);
  Executor.FreeOnTerminate:= false;
  Executor.Resume();
end;

procedure DestroyExecutor();
begin
  if (Executor <> nil) then
    begin
      Executor.Terminate();
      Executor.WaitFor();
      FreeAndNil(Executor);
    end;
end;

procedure ParseParams(const Params: WideString; const IsService: boolean);
var
  Sl: TTntStringList;
  NoGUI, BU, AutoClose, Maximize: boolean;
  s, List: WideString;
  p, i: integer;
begin
  //the parameters are passed by the application or the service
  //this procedure parses then and executes some parameters or
  //pass other parameters to the user interface
  Sl:= TTntStringList.Create();
  try
    Sl.CommaText:= Params;
    BU := false;
    NOGUI := false;
    Maximize := false;
    AutoClose := false;
    List := WS_NIL;
    for i := 0 to SL.Count - 1 do
    begin
      s := SL[i];
      if s <> WS_NIL then
      begin
        if WideUpperCase(s) = WS_NOGUI then
        begin
          NOGUI := true;
          Continue;
        end;

        if WideUpperCase(s) = WS_NOGUIALT then
        begin
          NOGUI := true;
          Continue;
        end;

        if WideUpperCase(s) = WS_AUTOCLOSE then
        begin
          AutoClose := true;
          Continue;
        end;

        if WideUpperCase(s) = WS_AUTOCLOSEALT then
        begin
          AutoClose := true;
          Continue;
        end;

        if WideUpperCase(s) = WS_BU then
        begin
          BU := true;
          Continue;
        end;

        if WideUpperCase(s) = WS_BUALT then
        begin
          BU := true;
          Continue;
        end;

        if WideUpperCase(s) = WS_MAX then
        begin
          Maximize := true;
          Continue;
        end;

        if WideUpperCase(s) = WS_MAXALT then
        begin
          Maximize := true;
          Continue;
        end;

        p := Pos(WS_LISTPARAM, WideUpperCase(s));
        if p = 1 then
        begin
          List := Copy(s, Length(WS_LISTPARAM) + 1, Length(s) - Length(WS_LISTPARAM)); //copy the list name
          Continue;
        end;

        p := Pos(WS_LISTPARAMALT, WideUpperCase(s));
        if p = 1 then
        begin
          List := Copy(s, Length(WS_LISTPARAMALT) + 1, Length(s) - Length(WS_LISTPARAMALT)); //copy the list name
          Continue;
        end;
      end;
    end;
  finally
    FreeAndNil(Sl);
  end;

  if List <> WS_NIL then
    if WideFileExists(List) then
    begin
      //Set the new list and save the new settings
      Logger.Log(WideFormat(Translator.GetMessage('3'), [List]), false, false);
      Settings.SetList(List);
      Settings.LoadList();
      Settings.SaveSettings(false);
      //No need to send a message because the UI is not started yet
    end;


 if BU then
  begin
    CS_Semaphore.Enter();
    try
      Logger.Log(Translator.GetMessage('4'), false, false);
      Flag_Sem_BU_All := true; //This flag will be checked by the Scheduler
    finally
      CS_Semaphore.Leave();
    end;
  end;


  if AutoClose then
  begin
    CS_AutoClose.Enter();
    try
      Logger.Log(Translator.GetMessage('5'), false, false);
      Flag_AutoClose := true; //This flag will be checked by the Executer
    finally
      CS_AutoClose.Leave();
    end;
  end;

  if (isService = false) and (NoGUI = false) then
    if WideFileExists(Globals.AppPath + WS_GUIEXENAME) then
      if Maximize then //Execute the interface maximized
        ShellExecuteW(0, 'open', PWideChar(Globals.AppPath + WS_GUIEXENAME), 
                      PWideChar(WS_MAXALT), nil, SW_SHOWNORMAL)
      else
        ShellExecuteW(0, 'open', PWideChar(Globals.AppPath + WS_GUIEXENAME), 
                      nil, nil, SW_SHOWNORMAL); 

end;


procedure Init(const Service: byte; const AppPathParam, Params:PWideChar); stdcall;
var
  IsService: boolean;
  AppPath, Parameters: WideString;
begin
  /// This is the entry point of the dll
  ///  This procedure receive the parameters and span all the threads
  ///

  IsService := (Service = INT_TRUE);
  AppPath:= AppPathParam;
  Parameters:= Params;

  CreateCriticalSections();

  Globals:= TGlobalUtils.Create(AppPath,IsService);
  Globals.CheckDirectories();

  Settings:= TSettings.Create(@Globals.Sec, Globals.AppPath,
                              Globals.DBPath, Globals.SettingsPath);
  Settings.LoadSettings();

  // Create the translator object
  Translator := TTranslator.Create(@Globals.Sec, Globals.AppPath, Globals.LanguagesPath);
  Translator.LoadLanguage(Settings.GetLanguage());

  // Create the log
  Logger:= TLogger.Create(Globals.AppPath, Globals.DBPath ,@Globals.Sec);
  LogHello(IsService);

  if (not Settings.CheckTemporaryDir(Globals.DBPath)) then
    LogTempWarning();

  Settings.LoadList();

  CreateSlaveIPC();

  CreateBackupQueue();

  CreateScheduler();

  CreateExecutor(IsService);

  ParseParams(Parameters, IsService);
end;

procedure DeInit();stdcall;
begin
  DestroyExecutor();
  DestroyScheduler();
  DestroyBackupQueue();
  DestroySlaveIPC();
  // Free the logger
  FreeAndNil(Logger);
  // Free the translator
  FreeAndNil(Translator);
  //Destroy the settings
  FreeAndNil(Settings);
  //Destroy globall obj
  FreeAndNil(Globals);

  DestroyCriticalSections();
end;

exports Init, DeInit;

begin
end.
