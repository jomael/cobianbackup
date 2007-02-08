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

// Calculates the size of a given source

unit interface_Calculator;

interface

uses
  Classes, CobCommonW, bmCommon;

type
  TResult = record
    ID: WideString;
    Size: Int64;
  end;
  PResult = ^TResult;

  TCalculator = class(TThread)
  private
    { Private declarations }
    FList: TList;
    procedure ClearLists();
    function GetSourceSize(const Source: WideString; Task: TTask): Int64;
    function GetTaskSize(const Task: TTask): Int64;
  public
    TotalFiles: Int64;
    TotalSize: Int64;
    Sizes: TList;
    FTools: TCobTools;
    constructor Create();
    destructor Destroy(); override;
  protected
    procedure Execute; override;
  end;

implementation

uses SysUtils, TntClasses, WideStrings, bmConstants, TntSysUtils;

{ TCalculator }

procedure TCalculator.ClearLists();
var
  i: integer;
  Task: TTask;
  Res: PResult;
begin
  for i:= 0 to FList.Count - 1 do
  begin
    Task:= FList[i];
    if (Task <> nil) then
      FreeAndNil(Task);
  end;
  FList.Clear();

  for i:=0 to Sizes.Count-1 do
  begin
    Res:= PResult(Sizes[i]);
    Dispose(PResult(Res));
  end;
  Sizes.Clear();
end;

constructor TCalculator.Create();
var
  i: integer;
  Task: TTask;
begin
  inherited Create(true);
  TotalFiles:= 0;
  TotalSize:= 0;
  FList:= TList.Create();
  Sizes:= TList.Create();
  FTools:= TCobTools.Create();
  // Create a local working list
  with Settings.TaskList.LockList() do
  try
    for i:=0 to Count-1 do
    begin
      Task:= TTask.Create();
      TTask(Items[i]).CloneTo(Task);
      FList.Add(Task);
    end;  
  finally
    Settings.TaskList.UnlockList();
  end;
end;

destructor TCalculator.Destroy();
begin
  FreeAndNil(FTools);
  ClearLists();
  FreeAndNil(Sizes);
  FreeAndNil(FList);
  inherited Destroy();
end;

procedure TCalculator.Execute();
var
  i: integer;
  Res: PResult;
  Task: TTask;
begin
  { Place thread code here }
  for i:=0 to FList.Count - 1 do
  begin
    Task:= FList[i];
    New(Res);
    Res^.ID:= Task.ID;
    Res^.Size:= GetTaskSize(Task);
    Sizes.Add(Res);
  end;
end;


function TCalculator.GetSourceSize(const Source: WideString; Task: TTask): Int64;
var
  Kind: integer;
  ASource: WideString;
  Files: Int64;
begin
  ASource:= FTools.DecodeSD(Source, Kind);
  Result:= 0;
  case Kind of
    INT_SDMANUAL:  ASource:= FTools.ReplaceTemplate(ASource,Task.Name);
    INT_SDFTP: Exit;
    else
    // Do nothing
  end;
  Files:= CobCountFilesW(ASource, Task.ExcludeItems, Task.IncludeMasks,
          Task.IncludeSubdirectories, Result);
  TotalFiles:= TotalFiles + Files;
  TotalSize:= TotalSize + Result;
end;

function TCalculator.GetTaskSize(const Task: TTask): Int64;
var
  Sl: TTntStringList;
  i: integer;
begin
  Result:= 0;
  Sl:= TTntStringList.Create();
  try
    Sl.CommaText:= Task.Source;
    for i:= 0 to Sl.Count-1 do
      Result:= Result + GetSourceSize(Sl[i], Task);
  finally
    FreeAndNil(Sl);
  end;
end;

end.
