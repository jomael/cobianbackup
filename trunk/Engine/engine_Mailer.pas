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

// This unit sends the log by e-mail

unit engine_Mailer;

interface

uses
  Classes, bmCommon, IdMessage, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdExplicitTLSClientServerBase, IdMessageClient, IdSMTPBase,
  IdSMTP, IdAttachmentFile, SysUtils, ZipForge;

type
  TMailer = class(TThread)
  private
    { Private declarations }
    FAppPath: WideString;
    FDeleteOnMail: boolean;
    FMailAsAttachment: boolean;
    FMailIfErrosOnly: boolean;
    FSendersName: WideString;
    FSendersAddress: WideString;
    FRecipients: WideString;
    FHost: WideString;
    FPort: integer;
    FSubject: WideString;
    FAuthentication: integer;
    FID: WideString;
    FPassword: WideString;
    FPipeLine: boolean;
    FUseEhlo: boolean;
    FHeloName: WideString;
    FConnectTimeOut: integer;
    FReadTimeOut: integer;
    FTools: TCobTools;
    FClient: TIdSMTP;
    FMessage: TIdMessage;
    FS: TFormatSettings;
    FTemp: WideString;
    function CompressLogFile(const FileName: WideString): WideString;
    procedure AttachFile(const FileName: WideString);
    procedure LoadMessage(const FileName: WideString);
    function NeedToSend(const FileName: WideString): boolean;
  public
    constructor Create(const AppPath: WideString);
    destructor Destroy();override;
  protected
    procedure Execute(); override;
  end;

implementation

uses bmConstants, engine_Logger, bmTranslator, Windows, bmCustomize, 
  TntClasses, TntSysUtils, IdMessageParts, CobCommonW;

{ TMailer }

function TMailer.CompressLogFile(const FileName: WideString): WideString;
var
  Zipper: TZipForge;
begin
  //TODO: Change this
  Result:= WideChangeFileExt(FileName, WS_ZIPEXT);
  try
    Zipper:= TZipForge.Create(nil);
    try
      Zipper.FileMasks.Clear();
      Zipper.ExclusionMasks.Clear();
      Zipper.NoCompressionMasks.Clear();
      Zipper.BaseDir := AnsiString(FTemp);
      Zipper.CompressionMode := 6;
      Zipper.ExtractCorruptedFiles := true;
      Zipper.FileName := AnsiString(Result);
      Zipper.InMemory := false;
      Zipper.Options.CreateDirs := false;
      Zipper.Options.FlushBuffers := true;
      Zipper.Options.OEMFileNames := true;
      Zipper.Options.OverwriteMode := omAlways;
      Zipper.Options.Recurse := false;
      Zipper.Options.SearchAttr := 10431;
      Zipper.Options.SetAttributes := true;
      Zipper.Options.ShareMode := smShareExclusive;
      Zipper.Options.StorePath := spRelativePath;
      Zipper.Password := AnsiString(WS_NIL);
      Zipper.SpanningMode := smNone;
      Zipper.Zip64Mode := zmDisabled;
      Zipper.FileMasks.Add(WideString(FileName));
      Zipper.OpenArchive(fmCreate or fmShareExclusive);
      Zipper.AddFiles();
    finally
      Zipper.CloseArchive();
      FreeAndNil(Zipper);
    end;
  except
    on E:Exception do
    begin
      Logger.Log(WideFormat(Translator.GetMessage('153'),
                                      [WideString(E.Message)],FS), true, false);
      Result:= WS_NIL;
    end;
  end;
end;

constructor TMailer.Create(const AppPath: WideString);
begin
  inherited Create(true);
  FAppPath:= AppPath;
  GetLocaleFormatSettings(LOCALE_SYSTEM_DEFAULT, FS);
  FTools:= TCobTools.Create();
  FDeleteOnMail:= Settings.GetMailDelete();
  FMailAsAttachment:= Settings.GetMailAsAttachment();
  FMailIfErrosOnly:= Settings.GetMailIfErrorsOnly();
  FSendersName:= FTools.ReplaceTemplate(Settings.GetSMTPSender(),WS_NIL);
  FSendersAddress:= Settings.GetSMTPSenderAddress();
  FRecipients:= Settings.GetSMTPDestination();
  FHost:= Settings.GetSMTPHost();
  FPort:= Settings.GetSMTPPort();
  FSubject:=  FTools.ReplaceTemplate(Settings.GetSMTPSubject(),WS_NIL);
  FAuthentication:= Settings.GetSMTPAuthentication();
  FID:= Settings.GetSMTPID();
  FPassword:= Settings.GetSMTPPassword();
  FPipeLine:= Settings.GetSMTPPipeLine();
  FUseEhlo:= Settings.GetSMTPEhlo();
  FReadTimeOut:= Settings.GetTCPReadTimeOut();
  FConnectTimeOut:= Settings.GetTCPConnectionTimeOut();
  FHeloName:= FTools.ReplaceTemplate(Settings.GetSMTPHelo(), WS_NIL);
  FMessage:= TIdMessage.Create(nil);
  FClient:= TIdSMTP.Create(nil);
  FTemp:= CobSetBackSlashW(Settings.GetTemp());
end;

destructor TMailer.Destroy();
begin
  try
    if (FClient.Connected) then
      FClient.Disconnect();
  except
    //Do nothing
  end;
  FreeAndNil(FClient);
  FreeAndNil(FMessage);
  FreeAndNil(FTools);
  inherited Destroy();
end;

procedure TMailer.Execute();
var
  FileName, Attachment: WideString;
begin
  // Stop the log file
  Logger.Log(WideFormat(Translator.GetMessage('145'), [FRecipients], FS),false, false);
  FileName:= FTemp + WideFormat(WS_LOGTOMAIL,
            [WS_PROGRAMNAMESHORT,
            FTools.GetGoodFileNameW(WideString(DateToStr(Now(),FS)))],FS);
  if Logger.CopyTo(FileName) then
  begin

    if (not NeedToSend(FileName)) then
      Exit;

    try
      FClient.Host:= AnsiString(FHost);
      FClient.Port:= FPort;
      if (FAuthentication = INT_SMTPNOLOGON) then
      begin
        FClient.Username:= S_NIL;
        FClient.Password:= S_NIL;
        FClient.AuthType:= atNone;
      end else
      begin
        FClient.Username:= AnsiString(FID);
        FClient.Password:= AnsiString(FPassword);
        FClient.AuthType:= atDefault; // I don't support SSL
      end;
      FClient.ConnectTimeout:= FConnectTimeOut;
      FClient.UseEhlo:= FUseEhlo;
      FClient.PipeLine:= FPipeLine;
      FClient.HeloName:= AnsiString(FHeloName);
      FClient.ReadTimeout:= FReadTimeOut;
      FClient.MailAgent:= AnsiString(WS_PROGRAMNAMESHORT);
      FMessage.Subject:= AnsiString(FSubject);
      FMessage.Recipients.EMailAddresses:= AnsiString(FRecipients);
      FMessage.From.Name:= AnsiString(FSendersName);
      FMessage.From.Address:= AnsiString(FSendersAddress);

      if (FMailAsAttachment) then
      begin
        Attachment := CompressLogFile(FileName);
        AttachFile(Attachment);
      end else
        LoadMessage(FileName);

      FClient.Connect();
      if (FClient.Connected) then
        FClient.Send(FMessage);

      //if it was OK, then delete the log file
      if (FDeleteOnMail) then
      begin
        Logger.DeletelogFile();
        Logger.Log(Translator.GetMessage('149'),false, false);
      end;

      if (WideFileExists(FileName)) then
        WideDeleteFile(FileName);

      if (WideFileExists(Attachment)) then
        WideDeleteFile(Attachment);
    except
      on E:Exception do
        Logger.Log(WideFormat(Translator.GetMessage('147'),
                    [WideString(E.Message)],FS),true,false);
    end;
  end else
    Logger.Log(Translator.GetMessage('146'),true, false);
end;

procedure TMailer.LoadMessage(const FileName: WideString);
var
  i: integer;
  Sl: TTntStringList;
begin
  // Load the message . Indy only acceps ANSI
  Sl := TTntStringList.Create;
  try
    Sl.LoadFromFile(FileName);
    // Indy only acceps ANSI, so don't do this
    //  FMessage.Body.Assign(Sl);
    for i := 0 to Sl.Count - 1 do
      FMessage.Body.Add(AnsiString(Sl[i]));
  finally
    FreeAndNil(Sl);
  end;
end;

function TMailer.NeedToSend(const FileName: WideString): boolean;
var
  Sl: TTntStringList;
  i: integer;
  ErrorsFound: boolean;
begin
  Result:= false;
  Sl:= TTntStringList.Create();
  try
    if (WideFileExists(FileName)) then
    begin
      Sl.LoadFromFile(FileName);
      // Do not send empty logs
      if (Sl.Count = 0) then
        Exit;

      ErrorsFound:= false;

      if (FMailIfErrosOnly) then
      begin
        for i:= 0 to Sl.Count - 1 do
        begin
          if (CobPosW(WS_ERROR, Sl[i], true) = 1) then
          begin
            ErrorsFound:= true;
            Break;
          end;
        end;

        if (not ErrorsFound) then
          Exit;
      end;

      Result:= true;
    end;
  finally
    FreeAndNil(Sl);
  end;
end;

procedure TMailer.AttachFile(const FileName: WideString);
begin
  FMessage.Body.Add(AnsiString(Translator.GetMessage('152')));
  if (FileName <> WS_NIL) then
    with TIdAttachmentFile.Create(FMessage.MessageParts, AnsiString(FileName)) do
      ContentType := S_ZIPTYPE;
end;

end.
