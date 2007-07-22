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

program CobVSrv;

{$INCLUDE TntCompilers.inc}

uses
  SvcMgr,
  unit_Main in 'unit_Main.pas' {CobVrsSrv: TService},
  unit_Common in '..\unit_Common.pas',
  unit_ServerWorker in 'unit_ServerWorker.pas';

{$R *.RES}

begin
{$IFDEF COMPILER_9_UP}
  if not Application.DelayInitialize or Application.Installing then
{$ENDIF}
    Application.Initialize;
  Application.CreateForm(TCobVrsSrv, CobVrsSrv);
  Application.Run;
end.
