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

// The service for Cobian Backup 8

program cbService;

{$INCLUDE TntCompilers.inc}

uses
  SvcMgr,
  service_Main in 'service_Main.pas' {CobBMService: TService},
  bmConstants in '..\Common\bmConstants.pas',
  bmCustomize in '..\Common\bmCustomize.pas',
  bmCommon in '..\Common\bmCommon.pas';

{$R *.RES}

begin
{$IFDEF COMPILER_9_UP}
  if not Application.DelayInitialize or Application.Installing then
{$ENDIF}  
    Application.Initialize;
  Application.CreateForm(TCobBMService, CobBMService);
  Application.Run;
end.
