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

// This is the Scheduler. This thread checks the actual time and date and
// adds the tasks that need to be executed to the queue. The tasks are then
// extracted and executed by the Executor thread


unit engine_Scheduler;

interface

uses
  Classes, SysUtils, Windows, TntClasses, bmCommon;

type
  TScheduler = class(TThread)
  public
    constructor Create(const AppPath:WideString);
    destructor Destroy();override;
  private
    { Private declarations }
    FAppPath: WideString;
    FS: TFormatSettings;
    FBUALL: boolean;
    FBUItems: WideString;
    FHours: word;
    FMinutes: word;
    //FSeconds: word;
    Counter: cardinal;
    FSl: TTntStringList;
    FActualDate: TdateTime;
    FLog: boolean;
    FMailLog: boolean;
    FMailSchedule: boolean;
    FMailHours: word;
    FMailMinutes: word;
    procedure LoadLocalSettings();
    function CheckBUAll(): boolean;
    function CheckBUSelected(): WideString;
    procedure CheckTasks();
    procedure MailLog();
    function NeedToReload(): boolean;
    procedure AddAlltasks();
    procedure AddATask(Task: TTask);
    procedure AddSelectedTasks(const Tasks: WideString);
    procedure CheckEveryTask();
    function NeedToAdd(const Task: TTask): boolean;
    function IsRightDayOfWeek(const Days: WideString): boolean;
    function IsRightDayOfMonth(const Days: WideString): boolean;
  protected
    procedure Execute(); override;
  end;

var
  Scheduler: TScheduler;

implementation

uses bmConstants, engine_Mailer, CobCommonW, DateUtils;

{ TScheduler }

procedure TScheduler.AddAlltasks();
var
  Task, PTask: TTask;
  i: integer;
begin
  /// I create a new task and copy the settings
  ///  Do not use a pointer becasuse the task
  ///  could be deleted or modified by some other thread
  ///  or by the interface
  with Settings.TaskList.LockList() do
  try
    for i:= 0 to Count - 1 do
    begin
      Task:= TTask.Create();
      PTask:= Items[i];
      PTask.CloneTo(Task);
      AddATask(Task);
    end;
  finally
    Settings.TaskList.UnlockList();
  end;
end;

procedure TScheduler.AddATask(Task: TTask);
begin
  with BackupQueue.LockList() do
  try
    Task.ApplyParameters(); //Parametrize!!!!
    Add(Task);
  finally
    BackupQueue.UnlockList();
  end;
end;

procedure TScheduler.AddSelectedTasks(const Tasks: WideString);
var
  Sl: TTntStringList;
  i: integer;
  Task, PTask: TTask;
begin
  Sl:= TTntStringList.Create();
  try
    Sl.CommaText:= Tasks;
    for i:=0 to Sl.Count-1 do
    begin
      Settings.GetTaskPointer(Sl[i],PTask);
      if (PTask <> nil) then
      begin
        Task:= TTask.Create();
        PTask.CloneTo(Task);
        AddATask(Task);
      end;
    end;
  finally
    FreeAndNil(Sl);
  end;
end;

function TScheduler.CheckBUAll(): boolean;
begin
  CS_Semaphore.Enter();
  try
    Result:= Flag_Sem_BU_All;
    if (Result) then
      Flag_Sem_BU_All:= BOOL_NO_NEED_TO_BACKUP;
  finally
    CS_Semaphore.Release();
  end;
end;

function TScheduler.CheckBUSelected(): WideString;
begin
  CS_Semaphore.Enter();
  try
    Result:= Flag_Sem_BU_Some;
    if (Result <> WS_NIL) then
      Flag_Sem_BU_Some:= WS_NIL
  finally
    CS_Semaphore.Release();
  end;
end;

procedure TScheduler.CheckEveryTask();
var
  Task, ToAdd: TTask;
  i: integer;
begin
  with Settings.TaskList.LockList() do
  try
    for i:= 0 to Count -1 do
    begin
      Task:= Items[i];
      if (NeedToAdd(Task)) then
      begin
        ToAdd:= TTask.Create();
        Task.CloneTo(ToAdd);
        AddATask(ToAdd);
      end;
    end;
  finally
    Settings.TaskList.UnlockList();
  end;
end;

procedure TScheduler.CheckTasks();
var
  ws: WideString;
begin
  // First check the FBUAll and FBUItems flags
  if FBUAll then
  begin
    FBUALL:= false;
    AddAllTasks();
    Exit;
  end;

  if FBUItems <> WS_NIL then
  begin
    ws := FBUItems;
    // Reset the flag
    FBUItems := WS_NIL;
    AddSelectedTasks(ws);
    Exit;
  end;

  // if we are here now, then check every task
  CheckEveryTask();
end;

constructor TScheduler.Create(const AppPath:WideString);
begin
  inherited Create(true);
  FAppPath:= AppPath;
  LoadLocalSettings();
  GetLocaleFormatSettings(LOCALE_SYSTEM_DEFAULT, FS);
  FBUAll := false;
  FBUItems := WS_NIL;
  FHours := INT_NIL;
  FMinutes := INT_NIL;
  Counter := INT_NIL;
  FSl:= TTntStringList.Create();
end;

destructor TScheduler.Destroy();
begin
  FreeAndNil(FSl);
  inherited Destroy();
end;

procedure TScheduler.Execute();
var
  tHours, tMinutes, tSeconds, tMilliseconds: word;
begin
  //Check every second for the system time.
  //Only hours and minutes are important.
  //if a new minute has arrived, check every event

  while not Terminated do
    begin
      //First check the BUAll and BUItems flags and
      FBUALL:= CheckBUAll();
      FBUItems:= CheckBUSelected();

      if (FBUAll = True) or (FBUITems <> WS_NIL) then
        CheckTasks();

      //Get the actual Date time
      FActualDate := Now();

      //Get the actual system time
      DecodeTime(FActualDate, tHours, tMinutes, tSeconds, tMilliseconds);

      //Check if a new minute has arrived
      if (tHours <> FHours) or (tMinutes <> FMinutes) then
      begin
        FHours := tHours;
        FMinutes := tMinutes;

        CheckTasks();

        //Increment the counter for the timer
        Inc(Counter);

        //Check if is time to send the mail
        if FLog and FMailLog and FMailSchedule then
          if (tHours = FMailHours) and (tMinutes = FMailMinutes) then
            MailLog();
      end;

      if NeedToReload() then
        LoadLocalSettings();

      Sleep(INT_SCHEDULERSLEEP);
    end;
end;

function TScheduler.IsRightDayOfMonth(const Days: WideString): boolean;
var
  Sl: TTntStringList;
  Day: integer;
  i: integer;
begin
  Result:= false;
  Sl:= TTntStringList.Create();
  try
    Sl.CommaText:= Days;
    for i:=0 to Sl.Count-1 do
    begin
      Day:= CobStrToIntW(Sl[i], INT_DNODAY);
      if (Day = DayOfTheMonth(FActualDate)) then
      begin
        Result:= true;
        Break;
      end;
    end;
  finally
    FreeAndNil(Sl);
  end;
end;

function TScheduler.IsRightDayOfWeek(const Days: WideString): boolean;
var
  Sl: TTntStringList;
  Day: integer;
  i: integer;
begin
  Result:= false;
  Sl:= TTntStringList.Create();
  try
    Sl.CommaText:= Days;
    for i:=0 to Sl.Count-1 do
    begin
      Day:= CobStrToIntW(Sl[i], INT_DNODAY);
      if (Day = DayOfTheWeek(FActualDate)) then
      begin
        Result:= true;
        Break;
      end;
    end;
  finally
    FreeAndNil(Sl);
  end;
end;

procedure TScheduler.LoadLocalSettings();
var
  dt: TDateTime;
  s,ms: word;
begin
  FLog := Settings.GetLog();
  FMailLog:= Settings.GetMailLog();
  FMailSchedule:= Settings.GetMailScheduled();
  dt := Settings.GetMailDateTime();
  DecodeTime(dt, FMailHours, FMailMinutes, s, ms);
end;

procedure TScheduler.MailLog();
var
  Mailer: TMailer;
begin
  Mailer:= TMailer.Create(FAppPath);
  Mailer.FreeOnTerminate:= true;
  Mailer.Resume();
end;

function TScheduler.NeedToAdd(const Task: TTask): boolean;
var
  hh, mm, ss, mmss: word;
begin
  Result:= false;

  if (Task = nil) then
    Exit;

  DecodeTime(Task.DateTime, hh, mm, ss, mmss);

  case Task.ScheduleType of
    INT_SCONCE:
      begin
        if (Trunc(Task.DateTime) = Trunc(FActualDate)) then  // The date is the same
          if (hh = FHours) and (mm = FMinutes) then
            Result:= true;
      end;
    INT_SCDAILY:
      begin
        if (hh= FHours) and (mm= FMinutes) then
          Result:= true;
      end;
    INT_SCWEEKLY:
      begin
        if (IsRightDayOfWeek(Task.DayWeek)) then
          if (hh = FHours) and (mm = FMinutes) then
            Result:= true;
      end;
    INT_SCMONTHLY:
      begin
        if (IsRightDayOfMonth(Task.DayMonth)) then
          if (hh = FHours) and (mm = FMinutes) then
            Result:= true;
      end;
    INT_SCYEARLY:
      begin
        if (Task.Month = MonthOfTheYear(FActualDate) - 1) then
          if (IsRightDayOfMonth(Task.DayMonth)) then
            if (hh = FHours) and (mm = FMinutes) then
              Result:= true;
      end;
    INT_SCTIMER:
      begin
        if (Task.Timer > 0) then
        begin
          if (Counter mod Task.Timer) = 0 then
            if Counter <> 0 then
              Result := true;
        end;
      end;
    else
      // manually
      Exit;
  end;
end;

function TScheduler.NeedToReload(): boolean;
begin
  CS_Scheduler.Enter();
  try
    Result:= Flag_Scheduler;
    if (Result) then
      Flag_Scheduler:= BOOL_NO_NEED_TO_RELOAD;
  finally
    CS_Scheduler.Leave();
  end;
end;

end.
