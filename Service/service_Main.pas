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

// Main unit for the service. This unit starts and stops the engine

unit service_Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, SvcMgr, Dialogs,
  bmCommon;

type
  TCobBMService = class(TService)
    procedure ServiceExecute(Sender: TService);
    procedure ServiceStop(Sender: TService; var Stopped: Boolean);
    procedure ServiceStart(Sender: TService; var Started: Boolean);
  private
    { Private declarations }
    FS: TFormatSettings;
    pSecurityDesc: PSECURITY_DESCRIPTOR;
    Sec: TSecurityAttributes;
    MutexHandle: Thandle;
    FAppPath: WideString;
    Engine: THandle;
    EntryPoint: TEntryPoint;
    ExitPoint: TExitPoint;
    procedure StartEngine();
    procedure StopEngine();
  public
    function GetServiceController: TServiceController; override;
    { Public declarations }
  end;

var
  CobBMService: TCobBMService;

implementation

{$R *.DFM}
{$R ..\Common\vista.RES}

uses CobCommonW, bmConstants, bmCustomize;

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  CobBMService.Controller(CtrlCode);
end;

procedure TCobBMService.StopEngine();
begin
  // Unload the working dll
  if Engine <> 0 then
    begin
      @ExitPoint := nil;
      ExitPoint := GetProcAddress(Engine, S_DEINITPROCEDUREADDRESS);
      if @ExitPoint <> nil then
        ExitPoint();
      //Free
      FreeLibrary(Engine);
      Engine := 0;
    end;
end;

function TCobBMService.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;

procedure TCobBMService.StartEngine();
var
  EngineFile: WideString;
begin
  // Open the engine (dll) and pass the parameters
  EngineFile:= FAppPath + WS_ENGINEEXENAME;

  Engine := LoadLibraryW(PWideChar(EngineFile));

  if Engine <> 0 then
  begin
    @EntryPoint := nil;
    EntryPoint := GetProcAddress(Engine, S_INITPROCEDUREADDRESS);
    if @EntryPoint <> nil then
      EntryPoint(byte(INT_TRUE), PWideChar(FAppPath), PWideChar(WS_NIL));
  end;
end;

procedure TCobBMService.ServiceExecute(Sender: TService);
begin
  //A dummy service. The engine is started on ServiceStart
  while not Terminated do
  begin
    ServiceThread.ProcessRequests(False);
    Sleep(INT_SERVICESLEEP);
  end;
end;

procedure TCobBMService.ServiceStart(Sender: TService; var Started: Boolean);
var
  MN: WideString;
begin
  GetLocaleFormatSettings(LOCALE_SYSTEM_DEFAULT,FS);
  FAppPath:= CobGetAppPathW();
  //On windows 2000 or XP the mutex name must have the GLOBAL prefix
  //if you want that all users will see your mutex.
  //This is very important when using the fast switch feature on XP

  if (CobIs2000orBetterW()) then
    MN := WideFormat(WS_APPMUTEXNAME, [WS_PROGRAMNAMELONG], FS)
  else
    MN := WideFormat(WS_APPMUTEXNAMEOLD,[WS_PROGRAMNAMELONG], FS);

  pSecurityDesc := nil;
  sec := CobGetNullDaclAttributesW(pSecurityDesc);

  MutexHandle := CreateMutexW(@sec, False, PWideChar(MN));

  if GetLastError() <> ERROR_SUCCESS then
  begin
    if MutexHandle <> 0 then
    begin
      CloseHandle(MutexHandle);
      MutexHandle:= 0;
    end;
    Started:= false;
    Self.DoStop();
    Exit;
  end;

  StartEngine();
  Started := True;
end;


procedure TCobBMService.ServiceStop(Sender: TService; var Stopped: Boolean);
begin
  StopEngine();
  if MutexHandle <> 0 then
  begin
    CloseHandle(MutexHandle);
    MutexHandle := 0;
  end;
  CobFreeNullDaclAttributesW(pSecurityDesc);
  Stopped := True;
end;

end.
