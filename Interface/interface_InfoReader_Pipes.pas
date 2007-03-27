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

unit interface_InfoReader_Pipes;

interface

uses Classes, CobPipesW, Windows, SysUtils, TntClasses;

type
 TInfoReaderPipe = class(TThread)
  private
    FSec: PSecurityAttributes;
    FS: TFormatSettings;
    FServer: TCobPipeServerW;
    FFirstTime: boolean;
    FConnected: boolean;
    FInfo: TTntStringList;
    FDisplayer: TTntStringList;
    FID: WideString;
    FFileName: WideString;
    FOperation: integer;
    FPartial: integer;
    FTotal: integer;
    FBackingUp: boolean;
    procedure OnReceived(const Cmd: WideString; const Kind: byte);
    procedure OnConnect();
    procedure OnDisconnect();
    procedure DisplayInfo();
    procedure ExecuteFile();
    procedure ExecuteFileAndWait();
    procedure CloseAWindow();
    procedure DisplayStatus();
  public
    constructor Create(const Sec: PSecurityAttributes);
    destructor Destroy();override;
  protected
    procedure Execute(); override;
  end;

implementation

uses bmConstants, bmCustomize, interface_Main, CobCommonW;

{ TInfoReaderPipe }

procedure TInfoReaderPipe.CloseAWindow();
begin
  form_CB8_Main.CloseAWindow(FID, CobStrToBoolW(FFileName));
end;

constructor TInfoReaderPipe.Create(const Sec: PSecurityAttributes);
var
  PipeName: WideString;
begin
  inherited Create(true);
  FSec:= Sec;
  FConnected:= false;
  FFirstTime:= true;
  FBackingUp:= false;
  FInfo:= TTntStringList.Create();
  FDisplayer:= TTntStringList.Create();
  GetLocaleFormatSettings(LOCALE_SYSTEM_DEFAULT, FS);
  PipeName:= WideFormat(WS_IENGINETOINTPIPE,[WS_PROGRAMNAMESHORTNOISPACES],FS);
  FServer:= TCobPipeServerW.Create(PipeName, FSec);
  FServer.OnReceive:=  OnReceived;
end;

destructor TInfoReaderPipe.Destroy();
begin
  FreeAndNil(FServer);
  FreeAndNil(FDisplayer);
  FreeAndNil(FInfo);
  inherited Destroy();
end;

procedure TInfoReaderPipe.DisplayInfo();
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

procedure TInfoReaderPipe.DisplayStatus();
begin
  form_CB8_Main.DisplayStatus(FID, FFileName, FOperation, FPartial, FTotal);
end;

procedure TInfoReaderPipe.Execute();
begin
  while not Terminated do
  begin
    if (FServer.ClientCount()> 0) then
    begin
      if (FFirstTime) or (FConnected = false) then
        Synchronize(OnConnect);
      FConnected:= true;
    end else
    begin
      if (FFirstTime) or (FConnected) then
        Synchronize(OnDisconnect);
      FConnected:= false;
    end;

    FFirstTime:= false;
    Sleep(INT_INFOREADERSLEEP);
  end;
end;

procedure TInfoReaderPipe.ExecuteFile();
begin
  form_CB8_Main.ExecuteFile(FID, FFileName);
end;

procedure TInfoReaderPipe.ExecuteFileAndWait();
begin
  form_CB8_Main.ExecuteFileAndWait(FID, FFileName);
end;

procedure TInfoReaderPipe.OnConnect();
begin
  form_CB8_Main.OnConnect();
end;

procedure TInfoReaderPipe.OnDisconnect();
begin
  form_CB8_Main.OnDisconnect();
end;

procedure TInfoReaderPipe.OnReceived(const Cmd: WideString; const Kind: byte);
begin
  if (Cmd <> WS_NIL) then
  begin
    FInfo.CommaText:= Cmd;
    if (FInfo.Count > 0) then
      DisplayInfo();

    FInfo.Clear();
  end;


end;

end.
