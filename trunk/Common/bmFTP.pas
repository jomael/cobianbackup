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

// Unit for FTP transfers. This unit is both used in the engine and
// in the interface. Downloads and uploads are implemented 

unit bmFTP;

interface

uses Classes, TntClasses, SysUtils, TntSysUtils, Windows, bmCommon, idFTP,
      idSSLOpenSSL, IdExplicitTLSClientServerBase, idFTPCommon, idFTPList,
      IdAllFTPListParsers, IdTCPConnection, IdInterceptThrottler, idComponent;

type
  TFTPrec = record
    Temp: WideString;
    AppPath: WideString;
    IncludeSubDirs: boolean;
    IncludeMask: WideString;                           
    ExcludeMask: WideString;
    Slow: boolean;
    SpeedLimit: boolean;
    Speed: integer;
    ASCII: WideString;
    UseAttributes: boolean;
    Separated: boolean;
    DTFormat: WideString;
    DoNotSeparate: boolean;
    DoNotUseSpaces: boolean;
    BackupType: integer;
    EncBufferSize: integer;
    EncCopyTimeStamps: boolean;
    EncCopyAttributes: boolean;
    EncCopyNTFS: boolean;
    ClearAttributes: boolean;
    DeleteEmptyFolders: boolean;
    AlwaysCreateDirs: boolean;
    EncPublicKey: WideString;
    EncMethod: integer;
    EncPassPhrase: WideString;
    Propagate: boolean;
  end;

  TFTP = class ( TObject)
  private
    FTemp: WideString;
    FAppPath: WideString;
    FSubDirs: boolean;
    FIncludeMask: WideString;
    FExcludeMask: WideString;
    FSlow: boolean;
    FSpeedLimit: boolean;
    FSpeed: integer;
    FASCII: WideString;
    FUseAttributes: boolean;
    FSeparated: boolean;
    FDTFormat: WideString;
    FDoNotSeparate: boolean;
    FDoNotUseSpaces: boolean;
    FBackupType: integer;
    FEncBufferSize: integer;
    FEncCopyTimeStamps: boolean;
    FEncCopyAttributes: boolean;
    FEncCopyNTFS: boolean;
    FClearAttributes: boolean;
    FDeleteEmptyFolders: boolean;
    FAlwaysCreateDirs: boolean;
    FEncPublicKey: WideString;
    FEncMethod: integer;
    FEncPassPhrase: WideString;
    FPropagate: boolean;

    FDownloading: boolean;
    FAccount: TFTPAddress;
    FTools: TCobTools;
    FS: TFormatSettings;
    Worker: TidFTP;
    FSSLHandler: TIdSSLIOHandlerSocketOpenSSL;
    FTotalTransfered: int64;
    FCurrentFileSize: int64;
    FAsciiList: TTntStringList;
    FLastPercent: integer;
    FSingle: boolean;
    FCurrentFile: WideString;
    FSnapshot: TDateTime;
    procedure Log(const Msg: WideString; const Error, Verbose: boolean);
    function DoAbort(): boolean;
    procedure FileDeleteBegin(const FileName: WideString);
    procedure FileBeginEnc(const FileName, DestFile: WideString; const Single: boolean);
    procedure FileEndEnc(const FileName, DestFile: WideString; const Single, Success, Secundary: boolean);
    procedure FileProgressEnc(const FileName: WideString; const PercentDone: integer);
    procedure FileProgress(const FileName: WideString; const Percent: integer; const Downloading: boolean);
    function NTFSCopy(const Source, Destination: WideString): cardinal;
    procedure FileBegin(const FileName, Destination: WideString; const Single: boolean);
    procedure FileEnd(const FileName, Destination: WideString; const Single, Success: boolean);
    function GetDownloadDirectory(const Directory, Working: WideString): WideString;
    function DownloadFile(const Source, DestinationDir: WideString; const Single: boolean): integer;
    function DoConnect(): boolean;
    procedure DoDisconnect();
    function NeedToCopyMask(const FileName: WideString): boolean;
    function DownloadDirectory(const Destination: WideString): int64;
    function ChangeRemDir(const Directory: WideString; const Silent, ReportError: boolean): boolean;
    function CreateRemDir(const ADirectory: WideString; const Silent: boolean): boolean;
    procedure CheckTimeOut();
    function IsASCII(const FileName: WideString): boolean;
    function NeedToCopy(const FileName: WideString): boolean;
    function GetFinalFileName(const FileName: WideString; const AfterZip, UseSnapshot: boolean): WideString;
    function EncryptFile(const Source: WideString; const Single: boolean): WideString;
    function GetRemoteDir(const Source,Destination: WideString): WideString;
    procedure UploadDirectoryRecursive(const Source,Destination: WideString;
                        const LastElement, ZipUpload: boolean);
    function DeleteAFile(const Directory, FileName: WideString; const Single: boolean): boolean;
    function DeleteADirectory(const Directory: WideString): boolean;
    function RemoveRemoteDirectory(const Directory: WideString): boolean;
    //FTP events
    procedure OnDisconnect(Sender: TObject);
    procedure OnAfterLogin(Sender: TObject);
    procedure OnTLSNotAvailable(Asender: TObject; var VContinue: Boolean);
    procedure OnDataChannelCreate(ASender: TObject; ADataChannel: TIdTCPConnection);
    procedure OnDataChannelDestroy(ASender: TObject; ADataChannel: TIdTCPConnection);
    procedure OnWork(ASender: TObject; AWorkMode: TWorkMode; AWorkCount: int64);
  public
    OnAbort: TCobAbort;
    OnLog: TCobLogEvent;
    OnProgress: TCobFTPProgress;
    OnFileBegin: TCobFTPFileBegin;
    OnFileEnd: TCobFTPFileEnd;
    OnFileBeginEnc: TCobObjectFileBegin;
    OnFileEndEnc: TCobEncryptFileEnd;
    OnFileProgressEnc: TCobObjectProgress;
    OnNTFSPermissionsCopyEnc: TCobNTFSPermissionsCopy;
    OnDelete: TCobDeleteCallbackW;
    DDirectory: WideString;
    FFinalAdress: WideString;
    constructor Create(const Rec: TFTPrec);
    destructor Destroy();override;
    function Download(const Source, Destination: WideString): int64;
    function UploadFile(const Source, Destination: WideString;
                        const Single, LastElement, ZipUpload, UseSnapshot: boolean): integer;
    // USed to upload a bunch of SINGLE files at once, for example, zipped split files
    function UploadBunch(const Source, Destination: WideString;
                         const LastElement: boolean): integer;
    function UploadDirectory(const Source,Destination: WideString;
                        const LastElement, ZipUpload: boolean): int64;
    procedure DeleteItems(const ConnectionString, Items: WideString);
  end;

implementation

uses bmConstants, CobCommonW, bmTranslator, CobEncrypt, WideStrings,
  bmEncryptor;

{ TFTP }

function TFTP.ChangeRemDir(const Directory: WideString; const Silent,
  ReportError: boolean): boolean;
begin
  Result := false;

  if Directory = WS_NIL then
    Exit;

  try
    Worker.ChangeDir(AnsiString(Directory));
    Log(WideFormat(Translator.GetMessage('408'), [Directory], FS), false, Silent);
    Result := true;
  except
    on E: Exception do
    begin
      Result := false;
      Log(WideFormat(Translator.GetMessage('409'), [Directory, WideString(E.Message)], FS), ReportError, Silent);
    end;
  end;

end;

procedure TFTP.CheckTimeOut();
begin
  //sometimes it will show Connected but anyway you can be in a TimeOut
  //because some other operations may be longer than the server TimeOut
  //Check this
  try
    if Worker.Connected then
    begin
      Worker.Noop();
      {if not ChangeRemDir(S_CURRENTDIR, true, false) then //can be done better?
        Connect(FConnectionString);}
    end
    else
      DoConnect();
  except
    DoDisconnect();
    DoConnect();
  end;
end;

constructor TFTP.Create(const Rec: TFTPrec);
begin
  inherited Create();
  FTemp:= Rec.Temp;
  FAppPath:= Rec.AppPath;
  FSubDirs:= Rec.IncludeSubDirs;
  FIncludeMask:= Rec.IncludeMask;
  FExcludeMask:= Rec.ExcludeMask;
  FSlow:= Rec.Slow;
  FSpeedLimit:= Rec.SpeedLimit;
  FSpeed:= Rec.Speed;
  FASCII:= Rec.ASCII;
  FUseAttributes:= Rec.UseAttributes;
  FSeparated:= Rec.Separated;
  FDTFormat:= Rec.DTFormat;
  FDoNotSeparate:= Rec.DoNotSeparate;
  FDoNotUseSpaces:= Rec.DoNotUseSpaces;
  FBackupType:= Rec.BackupType;
  FEncBufferSize:= Rec.EncBufferSize;
  FEncCopyTimeStamps:= Rec.EncCopyTimeStamps;
  FEncCopyAttributes:= Rec.EncCopyAttributes;
  FEncCopyNTFS:= Rec.EncCopyNTFS;
  FClearAttributes:= Rec.ClearAttributes;
  FDeleteEmptyFolders:= Rec.DeleteEmptyFolders;
  FAlwaysCreateDirs:= Rec.DeleteEmptyFolders;
  FEncPublicKey:= Rec.EncPublicKey;
  FEncMethod:= Rec.EncMethod;
  FEncPassPhrase:= Rec.EncPassPhrase;
  FPropagate:= Rec.Propagate;

  FSnapshot:= Now();

  GetLocaleFormatSettings(LOCALE_SYSTEM_DEFAULT, FS);
  FTools:= TCobTools.Create();
  FAccount:= TFTPAddress.Create();
  FSSLHandler:= TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  Worker:= TIdFTP.Create(nil);
  FAsciiList:= TTntStringList.Create();
  FAsciiList.CommaText:= WideUpperCase(FASCII);
  Worker.OnDisconnected:=  OnDisconnect;
  Worker.OnAfterClientLogin := OnAfterLogin;
  Worker.OnTLSNotAvailable := OnTLSNotAvailable;
  Worker.OnDataChannelCreate := OnDataChannelCreate;
  Worker.OnDataChannelDestroy := OnDataChannelDestroy;
  Worker.OnWork:= OnWork;
end;

function TFTP.CreateRemDir(const ADirectory: WideString;
  const Silent: boolean): boolean;
var
  i: Integer;
  Directory, OriginalDir, Previous, Tmp: AnsiString;
begin
  Result := true;
  Directory := AnsiString(ADirectory);
  OriginalDir:= Directory;

  if Directory = S_NIL then
  begin
    Result := false;
    Log(Translator.GetMessage('421'), true, false);
    Exit;
  end;

  try
    Previous := Worker.RetrieveCurrentDir();

    if (Directory[1] = S_SLASH) then
    begin
      Delete(Directory, 1, 1);
      Worker.ChangeDir(S_SLASH);
    end;

    repeat
      i := CobPosW(S_SLASH, Directory, true);

      if i = 0 then
      begin
        Tmp := Directory;
        Directory := S_NIL;
      end
      else
      begin
        Tmp := Copy(Directory, 1, i - 1);
        Directory := Copy(Directory, i + 1, Length(Directory) - i);
      end;
      //try to change dir
      if not ChangeRemDir(Tmp, Silent, false) then
        if Tmp <> S_NIL then
        begin
          Worker.MakeDir(Tmp);
          Worker.ChangeDir(Tmp);
          //I use this and not ChangeRemDir to catch the exceptions
        end;
    until i = 0;

    Log(WideFormat(Translator.GetMessage('422'),[WideString(OriginalDir)],FS), false, Silent);
  except
    on E: Exception do
    begin
      Result := False;
      Log(WideFormat(Translator.GetMessage('423'),[WideString(OriginalDir),
                                      WideString(E.Message)],FS), true, false);
    end;
  end;
end;

function TFTP.DeleteADirectory(const Directory: WideString): boolean;
  //***************************************************************************
  procedure ProcessList(const ADirectory: WideString);
  var
    Sl: TTntStringList;
    i, Kind: integer;
    CurrentDirectory, Obj: WideString;
  begin
    Sl := TTntStringList.Create();
    try
      try
        CurrentDirectory := CobSetForwardSlashW(ADirectory);
        Worker.List();
        for i := 0 to Worker.DirectoryListing.Count - 1 do
        begin
          if Worker.DirectoryListing[i].ItemType in [ditDirectory] then
            Sl.Add(FTools.EncodeSD(INT_SDDIR,WideString(Worker.DirectoryListing[i].FileName)))
          else
            Sl.Add(FTools.EncodeSD(INT_SDFILE,WideString(Worker.DirectoryListing[i].FileName)));
        end;

        for i := 0 to Sl.Count - 1 do
        begin
          if DoAbort() then
            Break;

          Obj:= FTools.DecodeSD(Sl[i], Kind);

          if Kind = INT_SDDIR then
          begin
            if (Obj = WS_CURRENTDIR) or (Obj = WS_PARENTDIR) then
              Continue;

            // This is a dir, recurse
            Obj := CurrentDirectory + Obj;

            if ChangeRemDir(Obj, true, true) then
            begin
              //Recurse
              ProcessList(Obj);
              // go back again
              if not ChangeRemDir(CurrentDirectory, true, true) then
                Break;
            end else
              Continue;

          end else // file
          begin
            //Delete the file
            DeleteAFile(CurrentDirectory, Obj, false);
          end;

          if DoAbort then
            Break;

          if FSlow then
            if i mod INT_FIFTYMULTIPLE = INT_NIL then
              Sleep(INT_SLOW);
        end;

        //Now delete the empty directory
        Result:= RemoveRemoteDirectory(CurrentDirectory);
      finally
        FreeAndNil(Sl);
      end;
    except
      on E:Exception do
      begin
        Log(WideFormat(Translator.GetMessage('436'),[ADirectory, WideString(E.Message)],FS),true,false);
      end;
    end;
  end;
  //***************************************************************************
begin
  Result:= false;

  if (not ChangeRemDir(Directory, true, true)) then
    Exit;

  if (DoAbort()) then
    Exit;

  ProcessList(Directory);
end;

function TFTP.DeleteAFile(const Directory, FileName: WideString;const Single:boolean): boolean;
begin
  Result:= false;

  Log(WideFormat(Translator.GetMessage('432'),[FileName],FS), false, true);

  if (not ChangeRemDir(Directory, true, true)) then
    Exit;

  try
    FileDeleteBegin(FileName);
    Worker.Delete(AnsiString(FileName));
    Result:= true;
    Log(WideFormat(Translator.GetMessage('434'),[FileName],FS), false, not Single);
    inc(FTotalTransfered);
  except
    on E: Exception do
    begin
      Result:= false;
      Log(WideFormat(Translator.GetMessage('433'),[FileName, WideString(E.Message)],FS), true, false);
    end;
  end;
end;

procedure TFTP.DeleteItems(const ConnectionString, Items: WideString);
var
  Source: WideString;
  Kind, i, j: integer;
  Sl, Sll: TTntStringList;
begin
  FTotalTransfered:= INT_NIL;
  FAccount.DecodeAddress(ConnectionString);

  if (not DoConnect()) then
    Exit;

  Sl:= TTntStringList.Create();
  Sll:= TTntStringList.Create();
  try
    Sl.CommaText:= Items;
    for i:= 0 to Sl.Count - 1 do
    begin
      Sll.CommaText:= Sl[i];
      for j:=0 to Sll.Count-1 do
      begin
        Source:= FTools.DecodeSD(Sll[j], Kind);
        if (Kind = INT_SDFILE) then
          DeleteAFile(FAccount.WorkingDir, Source, true) else
          begin
            Log(WideFormat(Translator.GetMessage('435'),[Source],FS), false, false);
            if DeleteADirectory(Source) then
              Log(WideFormat(Translator.GetMessage('438'),[Source],FS), false, false);
          end;
        if (DoAbort()) then
          Break;
      end;
      if (DoAbort) then
        Break;
    end;

    Log(WideFormat(Translator.GetMessage('437'),[FTotalTransfered], FS), false, false);

  finally
    DoDisconnect();
    FreeAndNil(Sll);
    FreeAndNil(Sl);
  end;
end;

destructor TFTP.Destroy();
begin
  DoDisconnect();
  FreeAndNil(FAsciiList);
  FreeAndNil(Worker);
  FreeAndNil(FSSLHandler);
  FreeAndNil(FAccount);
  FreeAndNil(FTools);
  inherited Destroy();
end;

function TFTP.DoAbort(): boolean;
begin
  Result:= false;
  if (Assigned(OnAbort)) then
    Result:= OnAbort();
end;

function TFTP.DoConnect(): boolean;
var
  APassword, AProxyPassword: WideString;
begin
  // Disconnect always if necessary
  DoDisconnect();
  try
    Worker.Username:= AnsiString(FAccount.ID);
    CobDecryptStringW(FAccount.Password, WS_LLAVE, APassword);
    Worker.Password:= AnsiString(APassword);
    Worker.Port:= FAccount.Port;
    Worker.Host:= AnsiString(FAccount.Host);

    case FAccount.ProxyType of
      INT_PROXY_NOPROXY: Worker.ProxySettings.ProxyType:= fpcmNone;
      INT_PROXY_HTTPWITHFTP: Worker.ProxySettings.ProxyType:= fpcmHttpProxyWithFtp;
      INT_PROXY_OPEN: Worker.ProxySettings.ProxyType:= fpcmOpen;
      INT_PROXY_SITE: Worker.ProxySettings.ProxyType:= fpcmSite;
      INT_PROXY_TRANSPARENT: Worker.ProxySettings.ProxyType:= fpcmTransparent;
      INT_PROXY_USERPASS: Worker.ProxySettings.ProxyType:= fpcmUserPass;
      INT_PROXY_USERSITE: Worker.ProxySettings.ProxyType:= fpcmUserSite;
      INT_PROXY_CUSTOM: Worker.ProxySettings.ProxyType:= fpcmCustomProxy;
      INT_PROXY_NOVELLBORDER: Worker.ProxySettings.ProxyType:= fpcmNovellBorder;
      INT_PROXY_USERHOSTFIREWALLID: Worker.ProxySettings.ProxyType:= fpcmUserHostFireWallID;
      else
         Worker.ProxySettings.ProxyType:= fpcmNone;
    end;

    Worker.ProxySettings.Host := AnsiString(FAccount.ProxyHost);
    Worker.ProxySettings.UserName := AnsiString(FAccount.ProxyID);
    Worker.ProxySettings.Port := FAccount.ProxyPort;
    CobDecryptStringW(FAccount.ProxyPassword, WS_LLAVE, AProxyPassword);
    Worker.ProxySettings.Password := AnsiString(AProxyPassword);

    Worker.DataPort := FAccount.DataPort;
    Worker.DataPortMin := FAccount.MinPort;
    Worker.DataPortMax := FAccount.MaxPort;
    Worker.ExternalIP := FAccount.ExternalIP;
    Worker.Passive := FAccount.Passive;
    Worker.TransferTimeout := FAccount.TransferTimeOut;
    Worker.ConnectTimeout := FAccount.ConnectionTimeout;
    Worker.UseMLIS := FAccount.UseMLIS;
    Worker.UseExtensionDataPort := FAccount.UseIPv6;
    Worker.TryNATFastTrack := FAccount.NATFastTrack;

    // the handlers properties
    FSSLHandler.SSLOptions.CertFile := AnsiString(FAccount.CertificateFile);
    FSSLHandler.SSLOptions.CipherList := AnsiString(FAccount.CipherList);
    FSSLHandler.SSLOptions.KeyFile := AnsiString(FAccount.KeyFile);
    FSSLHandler.SSLOptions.RootCertFile := AnsiString(FAccount.RootCertificate);
    case FAccount.SSLMethod of
      INT_SSLV23: FSSLHandler.SSLOptions.Method := sslvSSLv23;
      INT_SSLV3: FSSLHandler.SSLOptions.Method := sslvSSLv3;
      INT_SSLTLSV1: FSSLHandler.SSLOptions.Method := sslvTLSv1;
    else
      FSSLHandler.SSLOptions.Method := sslvSSLv2;
    end;

    case FAccount.SSLMode of
      INT_SSL_MODEBOTH: FSSLHandler.SSLOptions.Mode := sslmBoth;
      INT_SSL_MODECLIENT: FSSLHandler.SSLOptions.Mode := sslmClient;
      INT_SSL_MODESERVER: FSSLHandler.SSLOptions.Mode := sslmServer;
    else
      FSSLHandler.SSLOptions.Mode := sslmUnassigned;
    end;

    FSSLHandler.SSLOptions.VerifyDirs := AnsiString(FAccount.VerifyDirectories);
    FSSLHandler.SSLOptions.VerifyDepth := FAccount.VerifyDepth;
    FSSLHandler.SSLOptions.VerifyMode := [];

    if FAccount.Peer then
      FSSLHandler.SSLOptions.VerifyMode := FSSLHandler.SSLOptions.VerifyMode +
        [sslvrfPeer];
    if FAccount.FailIfNoPeer then
      FSSLHandler.SSLOptions.VerifyMode := FSSLHandler.SSLOptions.VerifyMode +
        [sslvrfFailIfNoPeerCert];
    if FAccount.ClientOnce then
      FSSLHandler.SSLOptions.VerifyMode := FSSLHandler.SSLOptions.VerifyMode +
        [sslvrfClientOnce];
    FSSLHandler.UseNagle := FAccount.UseNagle;

    if FAccount.TLS = INT_TLS_NONE then
    begin
      //No ssl
      Worker.IOHandler := nil;
      // Worker.UseCCC := false;  Bug in indy, Access Violation
      Worker.UseTLS := utNoTLSSupport;
      Worker.AUTHCmd := tAuto;
      Worker.DataPortProtection := ftpdpsClear;
    end
    else
    begin
      Worker.IOHandler := TIdSSLIOHandlerSocketOpenSSL(FSSLHandler);

      case FAccount.TLS of
        INT_TLS_EXPLICIT: Worker.UseTLS := utUseExplicitTLS;
        INT_TLS_IMPLICIT: Worker.UseTLS := utUseImplicitTLS;
        INT_TLS_REQUIRE: Worker.UseTLS := utUseRequireTLS;
      else
        Worker.UseTLS := utNoTLSSupport;
      end;
      
      case FAccount.AuthType of
        INT_AUTH_SSL: Worker.AUTHCmd := tAuthSSL;
        INT_AUTH_TLS: Worker.AUTHCmd := tAuthTLS;
        INT_AUTH_TLSC: Worker.AUTHCmd := tAuthTLSC;
        INT_AUTH_TLSP: Worker.AUTHCmd := tAuthTLSP;
      else
        Worker.AUTHCmd := tAuto;
      end;

      Worker.UseCCC := FAccount.UseCCC;
      if FAccount.DataProtection = INT_DATACLEAR then
        Worker.DataPortProtection := ftpdpsClear
      else
        Worker.DataPortProtection := ftpdpsPrivate;
    end;

    Log(WideFormat(Translator.GetMessage('402'),[FAccount.Host, FAccount.Port], FS), false, true);

    Worker.Connect();

    Log(WideFormat(Translator.GetMessage('403'),[FAccount.Host, FAccount.Port], FS), false, false);

    Result:= true;
  except
    on E:Exception do
    begin
      Result:= false;
      Log(WideFormat(Translator.GetMessage('404'),[FAccount.Host, FAccount.Port,
                                                    WideString(E.Message)], FS), true, false);
    end;
  end;
end;

procedure TFTP.DoDisconnect();
begin
  try
    if (Worker.Connected) then
    begin
      Worker.Disconnect();
      // logged in OnDisconnect
    end;
  except
    on E:Exception do
      Log(WideFormat(Translator.GetMessage('401'),[WideString(E.Message)],FS), true, true); // not so important, so make it verbose
  end;
end;

function TFTP.Download(const Source, Destination: WideString): int64;
begin
  // Downloads the DIRECTORY Source to the DIRECTORY Destination
  // This is only used for temporary downloads so you should always
  // create a subdirectory in the destination directory. This created
  // subdirectory will always be deleted afterward
  Result:= INT_FTPFAILED;
  FDownloading:= true;
  FTotalTransfered:= INT_NIL;

  FAccount.DecodeAddress(Source);

  DDirectory:= GetDownloadDirectory(Destination, FAccount.WorkingDir);

  if (WideCreateDir(DDirectory)) then
    Log(WideFormat(Translator.GetMessage('399'),[DDirectory],FS),false, false) else
    begin
      Log(WideFormat(Translator.GetMessage('400'),[DDirectory],FS),true, false);
      Exit;
    end;

  Result:= DownloadDirectory(DDirectory);

  if (Result <> INT_FTPFAILED) then
    Log(WideFormat(Translator.GetMessage('411'),[FTotalTransfered],FS), false, false);
end;

function TFTP.DownloadDirectory(const Destination: WideString): int64;
var
  Directory: WideString;
  //****************************************************************************
  procedure ProcessList(const CurrentDirectory, CurrentDestination: WideString);
  var
    Sl: TTntStringList;
    ACurrentSource, ACurrentDestination, AOriginaSource,AOriginalDestination,
                                                          Current: WideString;
    i, Kind: integer;
  begin
    Sl:= TTntStringList.Create();
    try
      AOriginaSource := CobSetForwardSlashW(CurrentDirectory);
      AOriginalDestination := CobSetBackSlashW(CurrentDestination);

      try
        Worker.List();
        for i:= 0 to Worker.DirectoryListing.Count - 1 do
        begin
          if (Worker.DirectoryListing[i].ItemType in [ditDirectory]) then
            Sl.Add(FTools.EncodeSD(INT_SDDIR, WideString(Worker.DirectoryListing[i].FileName))) else
            Sl.Add(FTools.EncodeSD(INT_SDFILE, WideString(Worker.DirectoryListing[i].FileName)));
        end;

        for i:= 0 to Sl.Count -1 do
        begin
          if (DoAbort()) then
            Break;

          Current:= FTools.DecodeSD(Sl[i], Kind);

          if (Current = WS_NIL) then
            Continue;

          if (Kind = INT_SDDIR) then
          begin
            // This is a directory. recurse if needed
            if (Current = WS_CURRENTDIR) or (Current = WS_PARENTDIR) then
              Continue;

            if (FSubDirs) then
            begin
              ACurrentSource:= AOriginaSource + Current;
              ACurrentDestination:= AOriginalDestination + Current;

              if (not WideDirectoryExists(ACurrentDestination)) then
              begin
                Log(WideFormat(Translator.GetMessage('236'),[ACurrentDestination],FS), false, true);
                if (WideCreateDir(ACurrentDestination)) then
                  Log(WideFormat(Translator.GetMessage('235'),[ACurrentDestination],FS), false, true) else
                  begin
                    Log(WideFormat(Translator.GetMessage('237'),[ACurrentDestination],FS), true, false);
                    Continue;
                  end;
              end;

              if (ChangeRemDir(ACurrentSource, true, true)) then
              begin
                // Recurse
                ProcessList(ACurrentSource, ACurrentDestination);
                // Go back again
                if (not ChangeRemDir(AOriginaSource, true, true)) then
                  Break;
              end else
                Continue;
            end;
          end else
          begin
            // this is a file
            Result:= Result + DownloadFile(Current, AOriginalDestination, false);
          end;

          if DoAbort() then
            Break;

          if FSlow then   //Don't sleep too much
            if (i mod INT_FIFTYMULTIPLE) = INT_NIL then
              Sleep(INT_SLOW);
        end;
      except
        on E:Exception do
          Log(WideFormat(Translator.GetMessage('412'),[CurrentDirectory,
                                    WideString(E.Message)],FS), true, false);
      end;
    finally
      FreeAndNil(Sl);
    end;
  end;
begin
  Result:= INT_FTPFAILED;

  Log(WideFormat(Translator.GetMessage('407'),[FAccount.WorkingDir],FS),false, false);

  Directory:= FAccount.WorkingDir;

  if (not DoConnect()) then
    Exit;

  try
    if (not ChangeRemDir(Directory, true, true)) then
    begin
      Log(WideFormat(Translator.GetMessage('410'),[FAccount.WorkingDir]),true,false);
      Exit;
    end;

    if DoAbort() then
      Exit;

    Result:= INT_NIL;

    ProcessList(Directory, Destination);

    Result:= FTotalTransfered;
  finally
    DoDisconnect();
  end;
end;

function TFTP.DownloadFile(const Source, DestinationDir: WideString; const Single: boolean): integer;
var
  Destination: WideString;
begin
  Result:= INT_FAILTRANSFERFAILED;
  FLastPercent:= -1;

  if (not NeedToCopyMask(Source)) then
  begin
    Log(WideFormat(Translator.GetMessage('406'),[Source], FS), false, true);
    Exit;
  end;

  Destination:= CobSetBackSlashW(DestinationDir) + Source;
  FCurrentFile:= Source;

  if (DoAbort()) then
    Exit;

  FileBegin(Source, Destination, Single);
  try
    try
      // Send a noop command
      CheckTimeOut();

      // A BUG (Indy is FUUUUULLLL of them) makes that if the file
      // is larger than 2Gb then we get an Range Check error because OnWork
      // uses integers ands not int64
     { FCurrentFileSize:= Worker.Size(AnsiString(Source));
      if (FCurrentFileSize > INT_LONGINTMAX) then
      begin
        if (Assigned(Worker.OnWork)) then
          Worker.OnWork:= nil;
      end else
      begin
        if (not Assigned(Worker.OnWork)) then
          Worker.OnWork:= OnWork;
      end;   }

      if (IsASCII(Source)) then
        Worker.TransferType:= ftASCII else
        Worker.TransferType:= ftBinary;

      Worker.Get(AnsiString(Source),AnsiString(Destination), true, false);

      if (DoAbort()) then
        Exit;

      Result:= INT_FILETRANSFERED;
    except
      on E:Exception do
      begin
        Log(WideFormat(Translator.GetMessage('417'),[Source, Destination, WideString(E.Message)],FS), true, false);
        Result:= INT_FAILTRANSFERFAILED;
      end;
    end;
  finally
    FileEnd(Source, Destination, Single, Result = INT_FILETRANSFERED);
  end;

  inc (FTotalTransfered);
end;

function TFTP.EncryptFile(const Source: WideString; const Single: boolean): WideString;
var
  Rec: TEncryptPar;
  Encryptor: TEncryptor;
begin
  Result:= WS_NIL;

  Rec.Temp:= FTemp;
  Rec.AppPath:= FAppPath;
  Rec.BackupType:= FBackupType;
  Rec.UseAttributes:= FUseAttributes;
  Rec.Separated:= FSeparated;
  Rec.DTFormat:= FDTFormat;
  Rec.DoNotSeparate:= FDoNotSeparate;
  Rec.DoNotUseSpaces:= FDoNotUseSpaces;
  Rec.Slow:= FSlow;
  Rec.BufferSize:= FEncBufferSize;
  Rec.CopyTimeStamps:= FEncCopyTimeStamps;
  Rec.CopyAttributes:= FEncCopyAttributes;
  Rec.CopyNTFS:= FEncCopyNTFS;
  Rec.ClearAttributes:= FClearAttributes;
  Rec.DeleteEmptyFolders:= FDeleteEmptyFolders;
  Rec.AlwaysCreateDirs:= FAlwaysCreateDirs;
  Rec.Subdirs:= FSubDirs;
  Rec.ExcludeMask:= WS_NIL;
  Rec.IncludeMask:= WS_NIL;
  Rec.PublicKey:= FEncPublicKey;
  Rec.EncMethod:= FEncMethod;
  Rec.PassPhrase:= FEncPassPhrase;
  Rec.Propagate:= FPropagate;

  Encryptor:= TEncryptor.Create(Rec, true);
  try
    Encryptor.OnLog:= Log;
    Encryptor.OnAbort:= DoAbort;
    Encryptor.OnFileBegin:= FileBeginEnc;
    Encryptor.OnFileEnd:= FileEndEnc;
    Encryptor.OnFileProgress:= FileProgressEnc;
    Encryptor.OnNTFSPermissionsCopy:= NTFSCopy;
    if (Encryptor.EncryptFile(Source, FTemp, Single, false) <> INT_NOFILEENCRYPTED) then
      Result:= Encryptor.DestinationOriginal;
  finally
    FreeAndNil(Encryptor);
  end;
end;

procedure TFTP.FileEnd(const FileName, Destination: WideString; const Single,
  Success: boolean);
begin
  if (Assigned(OnFileEnd)) then
    OnFileEnd(FileName, Destination, Single, Success, FDownloading);
end;

procedure TFTP.FileEndEnc(const FileName, DestFile: WideString; const Single,
  Success, Secundary: boolean);
begin
  if (Assigned(OnFileEndEnc)) then
    OnFileEndEnc(FileName,DestFile, Single, Success,Secundary);
end;

procedure TFTP.FileProgress(const FileName: WideString; const Percent: integer;
  const Downloading: boolean);
begin
  if (Assigned(OnProgress)) then
    OnProgress(FileName, Percent, Downloading);
end;

procedure TFTP.FileProgressEnc(const FileName: WideString;
  const PercentDone: integer);
begin
  if (Assigned(OnFileProgressEnc)) then
    OnFileProgressEnc(FileName, PercentDone);
end;

function TFTP.GetDownloadDirectory(const Directory, Working: WideString): WideString;
var
  Count: integer;
  Dir: WideString;
begin
  Result:= CobGetShortDirectoryNameFW(Working);

  if (Result = WS_NIL) or (Result = WC_SLASH) then
    Result:= CobGetUniqueNameW();

  Result:= CobSetBackSlashW(Directory) + Result;

  if (WideDirectoryExists(Result)) then
  begin
    Count:= 1;
    Result:=  Result + WS_NONEXISTINGDIR;
    Dir:= WideFormat(Result,[Count],FS);

    while WideDirectoryExists(Dir) do
    begin
      inc(Count);
      Dir:= WideFormat(Result,[Count],FS);
    end;

    Result:= Dir;
  end;
end;

function TFTP.GetFinalFileName(const FileName: WideString; const AfterZip, UseSnapshot: boolean): WideString;
var
  DT: TDateTime;
begin
  Result:= FileName;

  if (not FSingle) or (not FSeparated) {or (AfterZip)} then     //The compressor doesn't change the name if FTP
    Exit;

  // Because an encrypted file has double extensions, delete the extension first
  if (FEncMethod <> INT_ENCNOENC) then
    Result:= WideChangeFileExt(Result, WS_NIL);

  if (UseSnapshot) then
    DT:= FSnapshot else
    DT:= Now();

  Result:= FTools.GetFileNameSeparatedW(Result, FDTFormat, not FDoNotSeparate, DT);

  if (FEncMethod <> INT_ENCNOENC) then
    Result:= Result + WS_ENCRYPTEDEXT;

  if (FDoNotUseSpaces) then
    Result:= FTools.DeleteSpacesW(Result);
  
end;

function TFTP.GetRemoteDir(const Source, Destination: WideString): WideString;
var
  ShortDir: WideString;
begin
  Result:= CobSetForwardSlashW(Destination);

  /// This brings SERIOUS problems if the user chooses to
  ///  automatically delete old backups
  ///  if the user is uploading to /etc directly (for example)
  ///  then  /etc will be also deleted CATASTROPHICALLY
  {if (not FSeparated) and (not FAlwaysCreateDirs) then
    Exit; }

  ShortDir:= CobGetShortDirectoryNameW(Source);

  if (ShortDir = WS_NIL) or (ShortDir[Length(ShortDir)] = WC_SLASH) then
    ShortDir:= Translator.GetMessage('276');

  if (not FSeparated) then
  begin
    Result:= Result + ShortDir;
    Exit;
  end;

  ShortDir:= FTools.GetDirNameSeparatedW(ShortDir, FDTFormat, not FDoNotSeparate, Now());

  if (FDoNotUseSpaces) then
    ShortDir:= FTools.DeleteSpacesW(ShortDir);

  Result:= Result + ShortDir;
end;

function TFTP.IsASCII(const FileName: WideString): boolean;
var
  i: integer;
  Ext: WideString;
begin
  Result:= false;
  Ext:= WideUpperCase(WideExtractFileExt(FileName));
  // The extensions were already uppercased in the constructor
  for i:= 0 to FAsciiList.Count-1 do
  begin
    if (Ext = FAsciiList[i]) then
    begin
      Result:= true;
      Break;
    end;
  end;
end;

procedure TFTP.FileBegin(const FileName, Destination: WideString; const Single: boolean);
begin
  if (Assigned(OnFileBegin)) then
    OnFileBegin(FileName, Destination, Single, FDownloading);
end;

procedure TFTP.FileBeginEnc(const FileName, DestFile: WideString;
  const Single: boolean);
begin
  if (Assigned(OnFileBeginEnc)) then
    OnFileBeginEnc(FileName, DestFile, Single);
end;

procedure TFTP.FileDeleteBegin(const FileName: WideString);
begin
  if (Assigned(OnDelete)) then
    OnDelete(FileName);
end;

procedure TFTP.Log(const Msg: WideString; const Error, Verbose: boolean);
begin
  if (Assigned(OnLog)) then
    OnLog(Msg, Error, Verbose);
end;

function TFTP.NeedToCopy(const FileName: WideString): boolean;
begin
  Result:= true;
  if (FUseAttributes) and (FBackupType <> INT_BUFULL) then
    Result:= FTools.GetArchiveAttributeW(FileName);
end;

function TFTP.NeedToCopyMask(const FileName: WideString): boolean;
var
  IsInExclude, IsInInclude: boolean;
begin
  Result:= true;

  if (FIncludeMask = WS_NIL) and (FExcludeMask = WS_NIL) then
    Exit;

  if (FExcludeMask <> WS_NIL) then
  begin
    IsInExclude:= FTools.IsInTheMask(FileName, FExcludeMask, FPropagate);

    if (IsInExclude) then
    begin
      Result:= false;
      Exit;
    end;
  end;

  if (FIncludeMask <> WS_NIL) then
  begin
    IsInInclude:= FTools.IsInTheMask(FileName, FIncludeMask, FPropagate);

    if (not IsInInclude) then
    begin
      Result:= false;
      Exit;
    end;
  end;
end;

function TFTP.NTFSCopy(const Source, Destination: WideString): cardinal;
begin
  Result:= INT_NIL;
  if (Assigned(OnNTFSPermissionsCopyEnc)) then
    Result:= OnNTFSPermissionsCopyEnc(Source, Destination);
end;

procedure TFTP.OnAfterLogin(Sender: TObject);
begin
  Log(WideFormat(Translator.GetMessage('413'),[FAccount.Host],FS), false, false);
end;

procedure TFTP.OnDataChannelCreate(ASender: TObject;
  ADataChannel: TIdTCPConnection);
var
  Throttle: TIdInterceptThrottler;
begin
  {IO:= TIdIOHandlerStack.Create(nil);
  IO.LargeStream:= true; // Support streams > 2 GB    }

  ADataChannel.IOHandler.LargeStream:= true;
  
  if FSpeedLimit then
  begin
    Throttle := TIdInterceptThrottler.Create(nil);
    Throttle.BitsPerSec := FSpeed;
    ADataChannel.IOHandler.Intercept := Throttle;
  end;

end;

procedure TFTP.OnDataChannelDestroy(ASender: TObject;
  ADataChannel: TIdTCPConnection);
var
  Throttle: TIdInterceptThrottler;
begin
  if FSpeedLimit then
  begin
    Throttle := TIdInterceptThrottler(ADataChannel.IOHandler.Intercept);
    FreeAndNil(Throttle);
  end;
end;


procedure TFTP.OnDisconnect(Sender: TObject);
begin
  Log(WideFormat(Translator.GetMessage('405'),[FAccount.Host],FS), false, false);
end;

procedure TFTP.OnTLSNotAvailable(Asender: TObject; var VContinue: Boolean);
begin
  Log(WideFormat(Translator.GetMessage('414'),[FAccount.Host],FS), false, true);
  VContinue:= true;
end;

procedure TFTP.OnWork(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCount: int64);
var
  Percent: integer;
begin
  if (DoAbort) then
  begin
    try
      Worker.Abort();
    except
      DoDisconnect();
    end;
  end;

  if (FCurrentFileSize <> 0) then
    Percent:= Trunc((AWorkCount/FCurrentFileSize) * 100) else
    Percent:= INT_100;

  if (Percent <> FLastPercent) then
  begin
    FLastPercent:= Percent;
    FileProgress(FCurrentFile, Percent, FDownloading);
  end;

  if (FSlow) then
    if Percent mod INT_FIFTYMULTIPLE = INT_NIL then
      Sleep(INT_SLOW);
end;

function TFTP.RemoveRemoteDirectory(const Directory: WideString): boolean;
begin
  try
    Worker.ChangeDirUp();
    Worker.RemoveDir(AnsiString(Directory));
    Log(WideFormat(Translator.GetMessage('438'),[Directory],FS),false, true);
    Result:= true;
  except
    on E: Exception do
    begin
      Result:= false;
      Log(WideFormat(Translator.GetMessage('436'),[Directory,WideString(E.Message)],FS),true, false);
    end;
  end;
end;

function TFTP.UploadBunch(const Source, Destination: WideString;
  const LastElement: boolean): integer;
var
  Sl: TTntStringList;
  i: integer;
begin
  Result:= INT_FAILTRANSFERFAILED;

  FSnapshot:= Now();

  // Used to upload a bunch of SINGLE files at once, for example, split zipped files
  Sl:= TTntStringList.Create();
  try
    Sl.CommaText:= Source;
    if (Sl.Count = 0) then
      Exit;

    FAccount.DecodeAddress(Destination);

    if (not DoConnect) then
      Exit;

    for i:= 0 to Sl.Count - 1 do
    begin
      if (UploadFile(Sl[i], FAccount.WorkingDir, true, LastElement, true, true) = INT_FILETRANSFERED) then
        inc(Result);
      if (DoAbort()) then
        Break;
    end;
  finally
    DoDisconnect();
    FreeAndNil(Sl);
  end;
end;

function TFTP.UploadDirectory(const Source, Destination: WideString;
  const LastElement, ZipUpload: boolean): int64;
var
  ASource, ADestination: WideString;
  Sl: TTntStringList;
begin
  Result:= INT_NOFTPFILES;

  // FTP uses ANSI, so doesn't use \\?\
  ASource:= Source;

  if (not WideDirectoryExists(ASource)) then
  begin
    Log(WideFormat(Translator.GetMessage('425'),[ASource],FS), true, false);
    Exit;
  end;

  FAccount.DecodeAddress(Destination);

  ADestination:= GetRemoteDir(ASource, FAccount.WorkingDir);

  FTotalTransfered:= INT_NIL;

  if (not DoConnect()) then
    Exit;

  UploadDirectoryRecursive(Source, ADestination, LastElement, ZipUpload);

  DoDisconnect();

  if (DoAbort()) then
    Exit;

  Result:= FTotalTransfered;

  Sl:= TTntStringList.Create();
  try
    Sl.CommaText:= FAccount.FBUObjects;
    Sl.Add(FTools.EncodeSD(INT_SDDIR, ADestination));
    FAccount.FBUObjects:= Sl.CommaText;
    FFinalAdress:= FAccount.FBUObjects;
  finally
    FreeAndNil(Sl);
  end;

  Log(WideFormat(Translator.GetMessage('426'), [Source, Result], FS), false, false);

end;

procedure TFTP.UploadDirectoryRecursive(const Source, Destination: WideString;
  const LastElement, ZipUpload: boolean);
var
  ASource, ADestination: WideString;
  SR: TSearchRecW;
  //****************************************************************************
  procedure AnalyzeResults();
  begin
    if (SR.Name <> WS_CURRENTDIR) and (SR.Name <> WS_PARENTDIR) then
    begin
      if (faDirectory and SR.Attr) > 0 then
      begin
        /// If the directory is empty it will not be created
        ///  on the server , so force this here if necesary
        if (not FDeleteEmptyFolders) then
          if (FTools.IsDirEmpty(ASource + SR.Name)) then
            if (not ChangeRemDir(ADestination + SR.Name, true, false)) then
              CreateRemDir(ADestination + SR.Name, true);
            
        if (FSubDirs) then
          self.UploadDirectoryRecursive(ASource + SR.Name , ADestination + SR.Name, LastElement, ZipUpload);
      end else
      begin
        if (UploadFile(ASource + SR.Name, ADestination,  false, LastElement, ZipUpload, false) = INT_FILETRANSFERED) then
          inc(FTotalTransfered);
      end;
    end;
  end;
  //****************************************************************************
begin
  ASource:= CobSetBackSlashW(Source);
  ADestination:= CobSetForwardSlashW(Destination);

  if (not WideDirectoryExists(ASource)) then
  begin
    Log(WideFormat(Translator.GetMessage('427'),[ASource],FS), true, false);
    Exit;
  end;

  if (WideFindFirst(ASource + WS_ALLFILES, faAnyFile, SR) = 0) then
  begin
    AnalyzeResults();

    while WideFindNext(SR) = 0 do
    begin
      AnalyzeResults();

      if (DoAbort()) then
        Break;

      if (FSlow) then
        if ((FTotalTransfered mod INT_FIVEMULTIPLE) = INT_NIL) then
          Sleep(INT_SLOW);
    end;

    WideFindClose(SR);
  end;
end;

function TFTP.UploadFile(const Source, Destination: WideString; const Single,
                LastElement, ZipUpload, UseSnapshot: boolean): integer;
var
  DestDir, FileName, ASource: WideString;
  Sl: TTntStringList;
begin
  Result:= INT_FAILTRANSFERFAILED;
  FSingle:= Single;
  FFinalAdress:= WS_NIL;

  if (Single) and (not ZipUpload) then
  begin
    FAccount.DecodeAddress(Destination);
    DestDir:= FAccount.WorkingDir;
  end else
    DestDir:= Destination;

  ASource:= Source;

  if (not WideFileExists(ASource)) then
  begin
    Log(WideFormat(Translator.GetMessage('416'),[ASource],FS), true, false);
    Exit;
  end;

  if (not NeedToCopy(ASource)) then
  begin
    Log(WideFormat(Translator.GetMessage('418'),[ASource],FS),false,not Single);
    Exit;
  end;

  if (not Single) then
    if (not NeedToCopyMask(ASource)) then
    begin
      Log(WideFormat(Translator.GetMessage('419'),[ASource],FS), false, not Single);
      Exit;
    end;

  if (FEncMethod <> INT_ENCNOENC) then
    ASource:= EncryptFile(ASource, Single);

  if (DoAbort()) then
    Exit;

  FileName:= WideExtractFileName(ASource);
  FileName:= GetFinalFileName(FileName, ZipUpload, UseSnapshot);

  FileBegin(ASource, FileName, Single);

  if (Single) and (not ZipUpload) then
    if (not DoConnect()) then
      Exit;

  try
    try
      // Check it again because FileName could have been changed
      // if encrypting
      if (not WideFileExists(ASource)) then
      begin
        Log(WideFormat(Translator.GetMessage('416'),[ASource],FS), true, false);
        Exit;
      end;

      FCurrentFileSize:= CobGetFileSize(Asource);

      // A BUG (Indy is FUUUUULLLL of them) makes that if the file
      // is larger than 2Gb then we get an Range Check error because OnWork
      // uses integers ands not int64

      {if (FCurrentFileSize > INT_LONGINTMAX) then
      begin
        if (Assigned(Worker.OnWork)) then
          Worker.OnWork:= nil;
      end else
      begin
        if (not Assigned(Worker.OnWork)) then
          Worker.OnWork:= OnWork;
      end;      }
      

      FCurrentFile:= ASource;

      CheckTimeOut();

      if (not ChangeRemDir(DestDir, true, false)) then
      begin
        Log(WideFormat(Translator.GetMessage('420'),[DestDir], FS), false, true); // verbose, but not an error yet
        if (not CreateRemDir(DestDir, true)) then
          Exit else
          if (not ChangeRemDir(DestDir, true, true)) then
            Exit;
      end;

      if (IsASCII(ASource)) then
        Worker.TransferType:= ftASCII else
        Worker.TransferType:= ftBinary;

      Worker.Put(AnsiString(ASource), AnsiString(FileName), false);

      Result:= INT_FILETRANSFERED;

      // Here there is no need to copy attributes or NTFS or timestamps

      // clear always the original and not the eventually encrypted
      if (FClearAttributes) then
        if (FBackupType <> INT_BUDIFFERENTIAL) and (LastElement) then
          if (FTools.SetArchiveAttributeW(Source, false)) then   // The original
            Log(WideFormat(Translator.GetMessage('267'),[Source],FS), false, true) else
            Log(WideFormat(Translator.GetMessage('268'),[Source],FS), true, true);

      if (Single) then
      begin
        Sl:= TTntStringList.Create();
        try
          Sl.CommaText:= FAccount.FBUObjects;
          Sl.Add(FTools.EncodeSD(INT_SDFILE, FileName));
          FAccount.FBUObjects:= Sl.CommaText;
          FFinalAdress:= FAccount.FBUObjects;
        finally
          FreeAndNil(Sl);
        end;
      end;
      
    finally
      if (FEncMethod <> INT_ENCNOENC) then
        if (WideFileExists(ASource)) and (WideUpperCase(ASource) <> WideUpperCase(Source)) then
          DeleteFileW(PWideChar(ASource));

      FileEnd(Asource, FileName, Single, (Result = INT_FILETRANSFERED));
      if (Single) and not ZipUpload then
        DoDisconnect();
    end;
  except
    on E:Exception do
    begin
      Result:= INT_FAILTRANSFERFAILED;
      Log(WideFormat(Translator.GetMessage('424'),[Asource, FileName,
                                      WideString(E.Message)],FS), true, false);
    end;
  end;
end;

end.
