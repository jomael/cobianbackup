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

// Reads the MMF and interprets the info send by the engine

unit interface_InfoReader;

interface

uses
  Classes, SysUtils, Windows , TntClasses;

type
  TInfoReader = class(TThread)
  public
    constructor Create(const Sec: PSecurityAttributes);
    destructor Destroy();override;
  private
    { Private declarations }
    FN: WideString;
    FS: TFormatSettings;
    FIPCInfoMutex: THandle;
    FIPCInfoHandle: Thandle;
    FInfo: TTntStringList;
    FDisplayer: TTntStringList;
    FConnected: boolean;
    FFirstTime: boolean;
    FBackingUp: boolean;
    FID: WideString;
    FFileName: WideString;
    FOperation: integer;
    FPartial: integer;
    FTotal: integer;
    procedure OnConnect();
    procedure OnDisconnect();
    procedure DisplayInfo();
    procedure DisplayStatus();
    procedure ExecuteFile();
    procedure ExecuteFileAndWait();
    procedure CloseAWindow();
  protected
    procedure Execute(); override;
  end;

implementation

uses CobCommonW, bmCommon, bmConstants, bmCustomize, interface_Main;

procedure TInfoReader.CloseAWindow;
begin
  form_CB8_Main.CloseAWindow(FID, CobStrToBoolW(FFileName));
end;

constructor TInfoReader.Create(const Sec: PSecurityAttributes);
var
  MN: WideString;
begin
  inherited Create(true);
  GetLocaleFormatSettings(LOCALE_SYSTEM_DEFAULT, FS);
  //Creates the IPC tthat receives commands from the interface
  if (CobIs2000orBetterW()) then
    begin
      FN:= WideFormat(WS_MMFCURRENTOPNAME,[WS_PROGRAMNAMELONG],FS);
      MN:= WideFormat(WS_MMFMUTEXCURRENTOPNAME,[WS_PROGRAMNAMELONG], FS);
    end else
    begin
      FN:= WideFormat(WS_MMFCURRENTOPNAMEOLD,[WS_PROGRAMNAMELONG], FS);
      MN:= WideFormat(WS_MMFMUTEXCURRENTOPNAMEOLD,[WS_PROGRAMNAMELONG], FS);
    end;

  FIPCInfoMutex:= CreateMutexW(sec, False, PWideChar(MN));
  FInfo:= TTntStringList.Create();
  FDisplayer:= TTntStringList.Create();
  FConnected:= false;
  FBackingUp:= false;
  FFirstTime:= true;
  FID:= WS_NIL;
  FFileName:= WS_NIL;
  FOperation:= INT_NOOPERATION;
  FPartial:= INT_NIL;
  FTotal:= INT_NIL;
end;

destructor TInfoReader.Destroy();
begin
  FreeAndNil(FDisplayer);
  FreeAndNil(FInfo);

  if (FIPCInfoMutex <> 0) then
  begin
    CloseHandle(FIPCInfoMutex);
    FIPCInfoMutex:= 0;
  end;
  inherited Destroy();
end;

procedure TInfoReader.DisplayInfo();
var
  i: integer;
begin
  for i := 0 to FInfo.Count - 1 do
    begin
      FDisplayer.CommaText:= FInfo[i];
      if (FDisplayer.Count = INT_PROGRESSINFO) then
      begin
        FID:= FDisplayer[0];
        FFileName:= FDisplayer[1];
        FOperation:= CobStrToIntW(FDisplayer[2], INT_OPCOPY);
        FPartial:= CobStrToIntW(FDisplayer[3], INT_NIL);
        FTotal:= CobStrToIntW(FDisplayer[4], INT_NIL);
        case FOperation of
          INT_OPCLOSEUI:
                      begin
                        Synchronize(form_CB8_Main.CloseInterface);
                      end;
          INT_OPEXECUTE:
                      begin
                        Synchronize(ExecuteFile);
                      end;
          INT_OPEXECUTEANDWAIT:
                      begin
                        Synchronize(ExecuteFileAndWait);
                      end;
          INT_OPCLOSE:
                      begin
                        Synchronize(CloseAWindow);
                      end;
          INT_OPIDLE: begin
                        if  FBackingUp then
                        begin
                          Synchronize(form_CB8_Main.EndBackup);
                          FBackingUp:= false;
                        end;
                      end;
          else
                      begin      // A backup is going on
                        if (not FBackingUp) then
                        begin
                          Synchronize(form_CB8_Main.BeginBackup);
                          FBackingUp:= true;
                        end;
                        if (FOperation <> INT_OPBUBEGIN) then
                          Synchronize(DisplayStatus);
                      end;
        end;
      end;
    end;
end;

procedure TInfoReader.DisplayStatus();
begin
  form_CB8_Main.DisplayStatus(FID, FFileName, FOperation, FPartial, FTotal);
end;

procedure TInfoReader.Execute();
var
  FileStr: PWideChar;
begin
  while (not Terminated) do
  begin
    if WaitForSingleObject(FIPCInfoMutex, INFINITE) = WAIT_OBJECT_0 then
        try
          //The MMF should have been created by the engine
          //try to open it
          FIPCInfoHandle:=  OpenFileMappingW(FILE_MAP_ALL_ACCESS, False, PWideChar(FN));
          if (FIPCInfoHandle <> 0) then
            begin
              if (FFirstTime) or (FConnected= false) then
                Synchronize(OnConnect);

              FConnected:= true;

              FileStr:=  PWideChar(MapViewOfFile( FIPCInfoHandle,
                                        File_Map_All_Access,
                                        0, 0, 0));

              if (FileStr <> nil) then
                begin
                  FInfo.CommaText:= FileStr;
                  if (FInfo.Count > 0) then
                    DisplayInfo();

                  FInfo.Clear();
                  lstrcpyW(FileStr,PWideChar(WS_NIL));
                  UnMapViewOfFile(FileStr);
                end;

              CloseHandle(FIPCInfoHandle);
              FIPCInfoHandle:= 0;
            end else
            begin
              if (FFirstTime) or (FConnected) then
                Synchronize(OnDisconnect);
              FConnected:= false;
            end;
        finally
          ReleaseMutex(FIPCInfoMutex);
        end;

    FFirstTime:= false;
    Sleep(INT_INFOREADERSLEEP);
  end;
end;

procedure TInfoReader.ExecuteFile();
begin
  form_CB8_Main.ExecuteFile(FID, FFileName);
end;

procedure TInfoReader.ExecuteFileAndWait();
begin
  form_CB8_Main.ExecuteFileAndWait(FID, FFileName);
end;

procedure TInfoReader.OnConnect();
begin
  form_CB8_Main.OnConnect();
end;

procedure TInfoReader.OnDisconnect();
begin
  form_CB8_Main.OnDisconnect();
end;

end.
