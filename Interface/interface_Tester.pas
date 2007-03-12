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

// Tests a FTP or SMTP connection

unit interface_Tester;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TntForms, StdCtrls, TntStdCtrls, bmCommon, bmConstants,
  IdAntiFreezeBase, IdAntiFreeze, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, IdExplicitTLSClientServerBase, IdFTP, IdIOHandler, IdFTPCommon,
  IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL, ComCtrls,
  TntComCtrls, TntSysUtils, TntClasses, IdMessage, IdMessageClient, IdSMTPBase,
  IdSMTP;

type
  Tform_Tester = class(TTntForm)
    FTP: TIdFTP;
    AntiFreeze: TIdAntiFreeze;
    SSL: TIdSSLIOHandlerSocketOpenSSL;
    m_Log: TTntRichEdit;
    SMTP: TIdSMTP;
    Msg: TIdMessage;
    procedure FormDestroy(Sender: TObject);
    procedure FTPDisconnected(Sender: TObject);
    procedure FTPBannerBeforeLogin(ASender: TObject; const AMsg: string);
    procedure FTPBannerAfterLogin(ASender: TObject; const AMsg: string);
    procedure FTPAfterClientLogin(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FFirstTime: boolean;
    procedure TestFTP(const FTPAddress: WideString);
    procedure TestSMTP(const STMPSettings: WideString);
    procedure Log(const Msg: WideString; const Error: boolean);
    function ChangeRemoteDirectory(const Directory: WideString): boolean;
    function CreateSimpleRemoteDirectory(const ADirectory: WideString): boolean;
    function CreateTestFile(): WideString;
  public
    { Public declarations }
    Operation: integer;
    AFTPAddress: WideString;
    STMPSettings: WideString;
    FS: TFormatSettings;
    FTools: TCobTools;
  protected
    procedure Action(var Msg: TMessage); message INT_AFTERSHOWTEST;
  end;

implementation

uses bmTranslator, CobEncrypt, interface_Common, bmCustomize, CobCommonW;

{$R *.dfm}

{ Tform_Tester }

{ Tform_Tester }

procedure Tform_Tester.Action(var Msg: TMessage);
begin
  case Operation of
    INT_OPTESTFTP: TestFTP(AFTPAddress);
    else
    TestSMTP(STMPSettings);
  end;
end;

procedure Tform_Tester.TestFTP(const FTPAddress: WideString);
var
  FTPSettings: TFTPAddress;
  APassword, AProxyPassword, TestDir, FileName: WideString;
  DirCreated, FileUploaded: boolean;
begin
  m_Log.Clear();
  DirCreated:= false;
  FileUploaded:= false;

  FTPSettings:= TFTPAddress.Create();
  try
    FTPSettings.DecodeAddress(FTPAddress);

    Caption:= WideFormat(Translator.GetMessage('477'),[FTPSettings.Host],FS);
    Log(WideFormat(Translator.GetMessage('478'),[FTPSettings.Host, FTPSettings.Port],FS), false);
    try
      FTP.Username:= AnsiString(FTPSettings.ID);
      CobDecryptStringW(FTPSettings.Password, WS_LLAVE, APassword);
      FTP.Password:= AnsiString(APassword);
      FTP.Port:= FTPSettings.Port;
      FTP.Host:= AnsiString(FTPSettings.Host);

      case FTPSettings.ProxyType of
        INT_PROXY_NOPROXY: FTP.ProxySettings.ProxyType:= fpcmNone;
        INT_PROXY_HTTPWITHFTP: FTP.ProxySettings.ProxyType:= fpcmHttpProxyWithFtp;
        INT_PROXY_OPEN: FTP.ProxySettings.ProxyType:= fpcmOpen;
        INT_PROXY_SITE: FTP.ProxySettings.ProxyType:= fpcmSite;
        INT_PROXY_TRANSPARENT: FTP.ProxySettings.ProxyType:= fpcmTransparent;
        INT_PROXY_USERPASS: FTP.ProxySettings.ProxyType:= fpcmUserPass;
        INT_PROXY_USERSITE: FTP.ProxySettings.ProxyType:= fpcmUserSite;
        INT_PROXY_CUSTOM: FTP.ProxySettings.ProxyType:= fpcmCustomProxy;
        INT_PROXY_NOVELLBORDER: FTP.ProxySettings.ProxyType:= fpcmNovellBorder;
        INT_PROXY_USERHOSTFIREWALLID: FTP.ProxySettings.ProxyType:= fpcmUserHostFireWallID;
      else
         FTP.ProxySettings.ProxyType:= fpcmNone;
    end;

      FTP.ProxySettings.Host := AnsiString(FTPSettings.ProxyHost);
      FTP.ProxySettings.UserName := AnsiString(FTPSettings.ProxyID);
      FTP.ProxySettings.Port := FTPSettings.ProxyPort;
      CobDecryptStringW(FTPSettings.ProxyPassword, WS_LLAVE, AProxyPassword);
      FTP.ProxySettings.Password := AnsiString(AProxyPassword);

      FTP.DataPort := FTPSettings.DataPort;
      FTP.DataPortMin := FTPSettings.MinPort;
      FTP.DataPortMax := FTPSettings.MaxPort;
      FTP.ExternalIP := FTPSettings.ExternalIP;
      FTP.Passive := FTPSettings.Passive;
      FTP.TransferTimeout := FTPSettings.TransferTimeOut;
      FTP.ConnectTimeout := FTPSettings.ConnectionTimeout;
      FTP.UseMLIS := FTPSettings.UseMLIS;
      FTP.UseExtensionDataPort := FTPSettings.UseIPv6;
      FTP.TryNATFastTrack := FTPSettings.NATFastTrack;

      // the handlers properties
      SSL.SSLOptions.CertFile := AnsiString(FTPSettings.CertificateFile);
      SSL.SSLOptions.CipherList := AnsiString(FTPSettings.CipherList);
      SSL.SSLOptions.KeyFile := AnsiString(FTPSettings.KeyFile);
      SSL.SSLOptions.RootCertFile := AnsiString(FTPSettings.RootCertificate);
      case FTPSettings.SSLMethod of
        INT_SSLV23: SSL.SSLOptions.Method := sslvSSLv23;
        INT_SSLV3: SSL.SSLOptions.Method := sslvSSLv3;
        INT_SSLTLSV1: SSL.SSLOptions.Method := sslvTLSv1;
      else
        SSL.SSLOptions.Method := sslvSSLv2;
      end;

    case FTPSettings.SSLMode of
      INT_SSL_MODEBOTH: SSL.SSLOptions.Mode := sslmBoth;
      INT_SSL_MODECLIENT: SSL.SSLOptions.Mode := sslmClient;
      INT_SSL_MODESERVER: SSL.SSLOptions.Mode := sslmServer;
    else
      SSL.SSLOptions.Mode := sslmUnassigned;
    end;

    SSL.SSLOptions.VerifyDirs := AnsiString(FTPSettings.VerifyDirectories);
    SSL.SSLOptions.VerifyDepth := FTPSettings.VerifyDepth;
    SSL.SSLOptions.VerifyMode := [];

    if FTPSettings.Peer then
      SSL.SSLOptions.VerifyMode := SSL.SSLOptions.VerifyMode +
        [sslvrfPeer];
    if FTPSettings.FailIfNoPeer then
      SSL.SSLOptions.VerifyMode := SSL.SSLOptions.VerifyMode +
        [sslvrfFailIfNoPeerCert];
    if FTPSettings.ClientOnce then
      SSL.SSLOptions.VerifyMode := SSL.SSLOptions.VerifyMode +
        [sslvrfClientOnce];
    SSL.UseNagle := FTPSettings.UseNagle;

    if FTPSettings.TLS = INT_TLS_NONE then
    begin
      //No ssl
      FTP.IOHandler := nil;
      // Worker.UseCCC := false;  Bug in indy, Access Violation
      FTP.UseTLS := utNoTLSSupport;
      FTP.AUTHCmd := tAuto;
      FTP.DataPortProtection := ftpdpsClear;
    end
    else
    begin
      FTP.IOHandler := SSL;

      case FTPSettings.TLS of
        INT_TLS_EXPLICIT: FTP.UseTLS := utUseExplicitTLS;
        INT_TLS_IMPLICIT: FTP.UseTLS := utUseImplicitTLS;
        INT_TLS_REQUIRE: FTP.UseTLS := utUseRequireTLS;
      else
        FTP.UseTLS := utNoTLSSupport;
      end;

      case FTPSettings.AuthType of
        INT_AUTH_SSL: FTP.AUTHCmd := tAuthSSL;
        INT_AUTH_TLS: FTP.AUTHCmd := tAuthTLS;
        INT_AUTH_TLSC: FTP.AUTHCmd := tAuthTLSC;
        INT_AUTH_TLSP: FTP.AUTHCmd := tAuthTLSP;
      else
        FTP.AUTHCmd := tAuto;
      end;

      FTP.UseCCC := FTPSettings.UseCCC;
      if FTPSettings.DataProtection = INT_DATACLEAR then
        FTP.DataPortProtection := ftpdpsClear
      else
        FTP.DataPortProtection := ftpdpsPrivate;
    end;

    Log(WideFormat(Translator.GetMessage('402'),[FTPSettings.Host, FTPSettings.Port], FS), false);

    FTP.Connect();

    if (not ChangeRemoteDirectory(FTPSettings.WorkingDir)) then
      Exit;

    TestDir:= WideFormat(Translator.GetMessage('484'),[WS_PROGRAMNAMESHORT,
              FTools.GetGoodFileNameW(WideString(DatetimeToStr(Now())))],FS);
    TestDir:= FTools.DeleteSpacesW(TestDir);

    Log(WideFormat(Translator.GetMessage('483'),[TestDir],FS), false);

    DirCreated:= CreateSimpleRemoteDirectory(TestDir);

    FileName:= CreateTestFile();

    if (FileName <> WS_NIL) then
    begin
      FTP.Put(AnsiString(FileName));
      FileUploaded:= true;
    end;

    FTP.Disconnect();
    finally
      FreeAndnil(FTPSettings);
      if (WideFileExists(FileName)) then
        DeleteFileW(PWideChar(FileName));
    end;
  except
    on E: Exception do
      Log(WideFormat(Translator.GetMessage('479'),[WideString(E.Message)],FS), true);
  end;

  if (DirCreated) and (FileUploaded) then
    Log(Translator.GetMessage('485'), false) else
    Log(Translator.GetMessage('486'), true);
end;

procedure Tform_Tester.TestSMTP(const STMPSettings: WideString);
var
  Sl: TTntStringList;
begin
  Sl:= TTntStringList.Create();    
  try
    try
      Sl.CommaText:= STMPSettings;
      Caption:= WideFormat(Translator.GetMessage('477'),[Sl.Values[WS_INISMTPHOST]],FS);
      SMTP.Host:= AnsiString(Sl.Values[WS_INISMTPHOST]);
      SMTP.Port:= StrToInt(AnsiString(Sl.Values[WS_INISMTPPORT])); // Do not use CobStrToIntW because I want to raise an exception if needed
      if (Integer(CobStrToBoolW(Sl.Values[WS_INISMTPAUTHENTICATION])) = INT_SMTPNOLOGON) then
        SMTP.AuthType:= atNone else
        SMTP.AuthType:= atDefault; // I don't support SSL
      SMTP.Username:= AnsiString(Sl.Values[WS_INISMTPID]);
      SMTP.Password:= AnsiString(Sl.Values[WS_INISMTPPASSWORD]);
      SMTP.ConnectTimeout:= Settings.GetTCPConnectionTimeOut();
      SMTP.UseEhlo:= CobStrToBoolW(Sl.Values[Sl.Values[WS_INISMTPEHLO]]);

      //2007-03-12 by Luis Cobian
      // Fixed a bug that prevented to test against Login servers

      SMTP.PipeLine:=  CobStrToBoolW(Sl.Values[WS_INISMTPPIPELINE]);
      SMTP.HeloName:= AnsiString(Sl.Values[WS_INISMTPHELONAME]);
      SMTP.ReadTimeout:= Settings.GetTCPReadTimeOut();
      SMTP.MailAgent:= AnsiString(WS_PROGRAMNAMESHORT);

      Msg.Subject:= AnsiString(WideFormat(Translator.GetMessage('490'),[WS_PROGRAMNAMESHORT],FS));
      Msg.Recipients.EMailAddresses:= AnsiString(Sl.Values[WS_INISMTPDESTINATION]);
      Msg.From.Name:= AnsiString(WS_PROGRAMNAMESHORT);
      Msg.From.Address:= AnsiString(Sl.Values[WS_INISMTPSENDERADDRESS]);

      Msg.Body.Add(WideFormat(Translator.GetMessage('491'),[WS_PROGRAMNAMESHORT],FS));

      SMTP.Connect();
      if (SMTP.Connected) then
        SMTP.Send(Msg);

      Log(Translator.GetMessage('492'),false);
    finally
      FreeAndNil(Sl);
    end;
  except
    on E:Exception do
      Log(WideFormat(Translator.GetMessage('489'),[WideString(E.Message)],FS),true);
  end;
end;

function Tform_Tester.ChangeRemoteDirectory(const Directory: WideString): boolean;
begin
  Result := false;

  if Directory = WS_NIL then
    Exit;

  try
    FTP.ChangeDir(AnsiString(Directory));
    Log(WideFormat(Translator.GetMessage('408'), [Directory], FS), false);
    Result := true;
  except
    on E: Exception do
    begin
      Result := false;
      Log(WideFormat(Translator.GetMessage('409'), [Directory, WideString(E.Message)], FS), true);
    end;
  end;
end;

function Tform_Tester.CreateSimpleRemoteDirectory(const ADirectory: WideString): boolean;
begin
  Result:= false;

  if (ADirectory = WS_NIL) then
    Exit;

  try
    FTP.MakeDir(AnsiString(ADirectory));
    Log(WideFormat(Translator.GetMessage('422'),[ADirectory]), false);
    Result:= true;
  except
    on E:Exception do
    begin
      Result:= false;
      Log(WideFormat(Translator.GetMessage('423'),[ADirectory,
                                      WideString(E.Message)],FS), true);
    end;
  end;
end;

function Tform_Tester.CreateTestFile(): WideString;
var
  Sl: TTntStringList;
  AName: WideString;
begin
  Sl:= TTntStringList.Create();
  try
    AName:= WideFormat(Translator.GetMessage('487'),[WS_PROGRAMNAMESHORT,
            FTools.GetGoodFileNameW(WideString(DateTimeToStr(Now(),FS)))],FS);
    Sl.Add(AName);
    AName:= AName + WS_TEXTEXT;
    Result:=  CobSetBackSlashW(Settings.GetTemp()) +
              FTools.DeleteSpacesW(AName);
    Sl.SaveToFile(Result);
  finally
    FreeAndNil(Sl);
  end;
end;

procedure Tform_Tester.FormCreate(Sender: TObject);
begin
  FFirstTime:= true;
  GetLocaleFormatSettings(LOCALE_USER_DEFAULT, FS);
  Font.Name:= UISettings.FontName;
  Font.Size:= UISettings.FontSize;
  Font.Charset:= UISettings.FontCharset;
  m_Log.Font.Name:= UISettings.FontNameLog;
  m_Log.Font.Size:= UISettings.FontSizeLog;
  m_Log.Font.Charset:= UISettings.FontCharsetLog;
  ShowHint:= UISettings.ShowHints;
  FTools:= TCobTools.Create();
end;

procedure Tform_Tester.FormDestroy(Sender: TObject);
begin
  FreeAndNil(Ftools);
end;

procedure Tform_Tester.FormShow(Sender: TObject);
begin
  if (FFirstTime) then
  begin
    PostMessageW(self.Handle, INT_AFTERSHOWTEST, INT_NIL, INT_NIL);
    FFirstTime:= false;
  end;
end;

procedure Tform_Tester.FTPAfterClientLogin(Sender: TObject);
begin
  Log(Translator.GetMessage('480'), false);
end;

procedure Tform_Tester.FTPBannerAfterLogin(ASender: TObject;
  const AMsg: string);
begin
  if (AMsg <> S_NIL) then
    Log(WideFormat(Translator.GetMessage('481'),[WideString(Amsg)],FS), false);
end;

procedure Tform_Tester.FTPBannerBeforeLogin(ASender: TObject;
  const AMsg: string);
begin
  if (AMsg <> S_NIL) then
    Log(WideFormat(Translator.GetMessage('481'),[WideString(Amsg)],FS), false);
end;

procedure Tform_Tester.FTPDisconnected(Sender: TObject);
begin
  Log(Translator.GetMessage('482'),false);
end;

procedure Tform_Tester.Log(const Msg: WideString; const Error: boolean);
var
  AMsg: WideString;
begin
  if (Error) then
  begin
    m_Log.SelAttributes.Color := clRed;
    AMsg:= WS_ERROR + WS_SPACE + Msg;
  end else
  begin
    m_Log.SelAttributes.Color := clBlue;
    AMsg:= WS_NOERROR + WS_SPACE + Msg;
  end;

  m_Log.Lines.Add(AMsg);
  m_Log.Perform(EM_LineScroll, 0, m_Log.Lines.Count - 5);
  Application.ProcessMessages();
end;

end.
