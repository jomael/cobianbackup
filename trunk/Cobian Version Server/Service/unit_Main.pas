{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~                                                            ~~~~~~~~~~
~~~~~~~~~~                   Cobian version Server                    ~~~~~~~~~~
~~~~~~~~~~            Copyright 2000-2006 by Luis Cobian              ~~~~~~~~~~
~~~~~~~~~~                     cobian@educ.umu.se                     ~~~~~~~~~~
~~~~~~~~~~                    All rights reserved                     ~~~~~~~~~~
~~~~~~~~~~                                                            ~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

unit unit_Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, SvcMgr, unit_ServerWorker;

type
  TCobVrsSrv = class(TService)
    procedure ServiceExecute(Sender: TService);
    procedure ServiceStop(Sender: TService; var Stopped: Boolean);
    procedure ServiceStart(Sender: TService; var Started: Boolean);
  private
    { Private declarations }
    FWorker: TWorker;
  public
    function GetServiceController: TServiceController; override;
    { Public declarations }
  end;

var
  CobVrsSrv: TCobVrsSrv;

implementation

uses unit_Common;

{$R *.DFM}

procedure ServiceController(CtrlCode: DWord); stdcall;
begin
  CobVrsSrv.Controller(CtrlCode);
end;

function TCobVrsSrv.GetServiceController: TServiceController;
begin
  Result := ServiceController;
end;


procedure TCobVrsSrv.ServiceExecute(Sender: TService);
begin
while not Terminated do
  begin
    ServiceThread.ProcessRequests(False);
    Sleep(INT_SLEEP);
  end;
end;

procedure TCobVrsSrv.ServiceStart(Sender: TService; var Started: Boolean);
begin
  FWorker:= TWorker.Create();
  FWorker.FreeOnTerminate:= false;
  FWorker.Resume();
  Started:= true;
end;

procedure TCobVrsSrv.ServiceStop(Sender: TService; var Stopped: Boolean);
begin
  FWorker.Terminate();
  FWorker.WaitFor();
  FreeANdNil(FWorker);
  Stopped:= true;
end;

end.
