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

// This tread connects to the server to check for new versions

unit interface_Update;

interface

uses
  Classes, idTCPClient, IdTCPConnection, IdIOHandler, SysUtils, Windows, TntClasses;

type
  TUpdater = class(TThread)
  private
    FClient: TIdTCPClient;
    FS: TFormatSettings;
  public
    NewVersionAvailable: boolean;
    Version: WideString;
    Home: WideString;
    Info: WideString;
    Error: boolean;
    ErrorStr: WideString;
    FromUI: boolean;
    constructor Create(const UI: boolean);
    destructor Destroy();override;
  protected
    procedure Execute(); override;
  end;

implementation

uses IdBaseComponent, bmCustomize, bmCommon, bmConstants, bmTranslator, CobCommonW;

{ TUpdater }

constructor TUpdater.Create(const UI: boolean);
begin
  inherited Create(true);
  FClient:= TIdTCPClient.Create(nil);
  GetLocaleFormatSettings(LOCALE_SYSTEM_DEFAULT, FS);
  NewVersionAvailable:= false;
  Error:= false;
  ErrorStr:= WS_NIL;
  FromUI:= UI;
end;

destructor TUpdater.Destroy();
begin
  try
    if (FClient.Connected) then
      FClient.Disconnect();
  except
    // do not log some error here
  end;
  FreeAndNil(FClient);
  inherited Destroy();
end;

procedure TUpdater.Execute();
var
  Ver: AnsiString;
  Sl: TTntStringList;
begin
  FClient.Host:= WS_UPDATEHOST;
  FClient.Port:= INT_UPDATEPORT;
  FClient.ConnectTimeout:= INT_UPDATECONNEACTTO;
  FClient.ReadTimeout:= INT_UPDATEREADTO;
  try
    FClient.Connect();
    if (FClient.Connected) then
    begin
      // 2006-04-13, add S_COBHEADER to use version 2 of the server
      FClient.IOHandler.WriteLn(S_COBHEADER + S_LIVEUPDATESTRING);
      Ver := FClient.IOHandler.ReadLn(S_NIL, INT_UPDATEREADTO, INT_MAXLINELENGTH);

      if (Ver <> S_NIL) then
      //A new version is available
      //if the version of the program stored
      //in the ID resource file is different from Ver.
      begin
        Sl:= TTntStringList.Create();
        try
          Sl.CommaText:= WideString(Ver);
          if (Sl.Count = 3) then
          begin
            Version:= Sl[0];
            Home:= Sl[1];
            Info:= Sl[2];
            NewVersionAvailable:= (Version <> CobGetVersionW(WS_NIL));
          end;
        finally
          FreeAndNil(Sl);
        end;
      end;
    end;
  except
    on E:Exception do
    begin
      Error:= true;
      ErrorStr:= WideString(E.Message);
    end;
  end;
end;

end.
