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



unit interface_Master_Pipes;

interface

uses
  Classes, Windows, SysUtils, TntClasses, CobPipesW;

type
  TIPCMasterPipe = class(TThread)
  private
    FSec: PSecurityAttributes;
    FClient: TCobPipeClientW;
    FS: TFormatSettings;
    FCommands: TTntStringList;
  public
    constructor Create(const Sec: PSecurityAttributes);
    destructor Destroy();override;
  protected
    procedure Execute(); override;
  end;

implementation

uses bmConstants, bmCustomize, interface_Common;

{ TIPCMasterPipe }


constructor TIPCMasterPipe.Create(const Sec: PSecurityAttributes);
var
  PipeName: WideString;
begin
  inherited Create(true);
  FSec:= Sec;
  GetLocaleFormatSettings(LOCALE_SYSTEM_DEFAULT, FS);
  PipeName:= WideFormat(WS_INTTOENGINEPIPE,[WS_PROGRAMNAMESHORTNOISPACES],FS);
  FCommands:= TTntStringList.Create();
  FClient:= TCobPipeClientW.Create(PipeName,FSec);
end;

destructor TIPCMasterPipe.Destroy();
begin
  FreeAndNil(FClient);
  FreeAndNil(FCommands);
  inherited Destroy();
end;

procedure TIPCMasterPipe.Execute();
begin
  while not Terminated do
  begin
    IPCMasterCS.Enter();
      try
        if (CommandList.Count > 0) then
          begin
            FCommands.Assign(CommandList);
            CommandList.Clear();
          end;
      finally
        IPCMasterCS.Leave();
      end;

    if (FCommands.Count > 0) then
    begin
      FClient.SendStringW(FCommands.CommaText,INT_NORMALMESSAGETOENGINE);

      FCommands.Clear();
    end;

    Sleep(INT_MMFSLAVESLEEP);
  end;
end;

end.
