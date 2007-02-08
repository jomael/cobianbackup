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

// This thread checks all the tasks and their backup lists and
// finds out if there are missed backups

unit interface_BackupForcer;

interface

uses
  Classes, TntClasses, Windows, SysUtils, bmCommon;

type
  TBackupForcer = class(TThread)
  public
    MissedTasks: WideString;
    constructor Create();
    destructor Destroy(); override;
  private
    { Private declarations }
    FTaskList: TTntStringList;
    FSl: TTntStringList;
    FBackups: TBackupList;
  protected
    procedure Execute; override;
  end;

implementation

uses bmConstants;


{ TBackupForcer }

constructor TBackupForcer.Create();
begin
  inherited Create(true);
  FTaskList:= TTntStringList.Create();
  FBackups:= TBackupList.Create();
  FSl:= TTntStringList.Create();
  MissedTasks:= WS_NIL;
end;

destructor TBackupForcer.Destroy();
begin
  FreeAndNil(FSl);
  FreeAndNil(FBackups);
  FreeAndNil(FTaskList);
  inherited Destroy();
end;

procedure TBackupForcer.Execute();
var
  i: integer;
  Task: TTask;
  Backup: TBackup;
  ACount: integer;
  Day: TDateTime;
begin
  FTaskList.CommaText:= Settings.GetTasksIDList();
  for i:= 0 to FTaskList.Count - 1 do
  begin
    Settings.GetTaskPointer(FTaskList[i], Task);
    if (Task <> nil) then
    begin
      if (Task.Disabled) then
        Continue;

      FBackups.ClearList();

      FBackups.LoadBackups(Task.ID);

      ACount:= FBackups.GetCount();
      if (ACount = 0) then
        Continue;

      if (Task.ScheduleType = INT_SCDAILY) or (Task.ScheduleType = INT_SCWEEKLY)
      or (Task.ScheduleType = INT_SCMONTHLY) or (Task.ScheduleType = INT_SCYEARLY) then
      begin
        FBackups.GetBackupPointerIndex(ACount - 1, Backup);
        if (Backup <> nil) then
        begin
          Day:= Now();
          if (Day > Backup.FNextDateTime) then
            FSl.Add(Task.ID);
        end;
      end;
    end;
  end;

  MissedTasks:= FSl.CommaText;
end;

end.
