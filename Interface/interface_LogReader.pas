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

// This thread reads the Log MMF and shows it in the interface

unit interface_LogReader;

interface

uses
  Classes, SysUtils, TntClasses, Windows, CobPipesW;

type
  TLogReader = class(TThread)
  public
    constructor Create(const UsePipes:boolean; const Sec: PSecurityAttributes);
    destructor Destroy(); override;
  private
    { Private declarations }
    FLogMutex: THandle;
    FLogHandle: Thandle;
    FN: WideString;
    FLogList: TTntStringList;
    FUsePipes: boolean;
    FPipeServer: TCobPipeServerW;
    FS: TFormatSettings;
    procedure SendLogLines();
    procedure OnReceive(const Msg: WideString; const Kind: byte);
  protected
    procedure Execute(); override;
  end;

implementation

uses CobCommonW, bmConstants, bmCustomize, interface_Main;

{ TLogReader }

constructor TLogReader.Create(const UsePipes:boolean; const Sec: PSecurityAttributes);
var
  MN, Pname: WideString;
begin
  inherited Create(true);
  FUsePipes:= UsePipes;
  GetLocaleFormatSettings(LOCALE_SYSTEM_DEFAULT, FS);

  if (FUsePipes) then
  begin
    PName:= WideFormat(WS_LOGTOLOGPIPE,[WS_PROGRAMNAMESHORTNOISPACES],FS);
    FPipeServer:= TCobPipeServerW.Create(PName, Sec);
    FPipeServer.OnReceive:= OnReceive;
  end else
  begin
    //Creates the IPC tthat receives commands from the interface
    if (CobIs2000orBetterW()) then
      begin
        FN:= WideFormat(WS_MMFLOG,[WS_PROGRAMNAMELONG]);
        MN:= WideFormat(WS_MMFLOGMUTEX,[WS_PROGRAMNAMELONG]);
      end else
      begin
        FN:= WideFormat(WS_MMFLOGOLD,[WS_PROGRAMNAMELONG]);
        MN:= WideFormat(WS_MMFLOGMUTEXOLD,[WS_PROGRAMNAMELONG]);
      end;
    FLogMutex:= CreateMutexW(sec, False, PWideChar(MN));
  end;
  FLogList:= TTntStringList.Create();
end;

destructor TLogReader.Destroy();
begin
  FreeAndNil(FLogList);
  if (FUsePipes) then
  begin
    FreeAndNil(FPipeServer);
  end else
  begin
    if (FLogMutex <> 0) then
    begin
      CloseHandle(FLogMutex);
      FLogMutex:= 0;
    end;
  end;

  inherited Destroy();
end;

procedure TLogReader.Execute();
var
  FileStr: PWideChar;
begin
  while not Terminated do
    begin
      if (not FUsePipes) then
      begin
        if WaitForSingleObject(FLogMutex, INFINITE) = WAIT_OBJECT_0 then
        try
          //The MMF should have been created by the engine
          //try to open it
          FLogHandle:=  OpenFileMappingW(FILE_MAP_ALL_ACCESS, False, PWideChar(FN));
          if (FLogHandle <> 0) then
          begin
            FileStr:=  PWideChar(MapViewOfFile(FLogHandle,
                                        File_Map_All_Access,
                                        0, 0, 0));

            if (FileStr <> nil) then
              begin
                FLogList.CommaText:= FileStr;
                if (FLogList.Count > 0) then
                  Synchronize(SendLogLines);
                FLogList.Clear();
                lstrcpyW(FileStr,PWideChar(WS_NIL));
                UnMapViewOfFile(FileStr);
                //FileStr := nil;
              end;

            CloseHandle(FLogHandle);
            FLogHandle:= 0;
          end;
        finally
          ReleaseMutex(FLogMutex);
        end;
      end;

    Sleep(INT_MMFLOGREADERSLEEP);
  end;
end;

procedure TLogReader.OnReceive(const Msg: WideString; const Kind: byte);
begin
  FLogList.CommaText:= Msg;
  if (FLogList.Count > 0) then
    Synchronize(SendLogLines);
  FLogList.Clear();
end;

procedure TLogReader.SendLogLines();
var
  i: integer;
begin
  if (form_CB8_Main <> nil) then
    for i:=0 to FLogList.Count-1 do
      form_CB8_Main.Log(FLogList[i],(CobPosW(WS_ERROR,FLogList[i], true) = 1),true);
end;

end.
