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

// Imports all lists

unit interface_Importer;

interface

uses Classes, TntClasses, SysUtils, bmCommon;

type
  TImporter = class (TObject)
  private
    FFileName: WideString;
    FSl: TTntStringList;
    FTools: TCobTools;
    function GetListVersion(): integer;
    procedure Import6();
    procedure Import7();
    procedure Import8();
    procedure Convert7to8(Task: TTask; const Sl: TStringList);
    procedure Convert6to8(Task: TTask; const Sl: TStringList);
    function SourceDestination6to8(const SD: AnsiString): WideString;
    function SourceDestination7to8(const Value: AnsiString): WideString;
    function Ftp7to8(const Value: AnsiString): WideString;
    function Ftp6to8(const Value: WideString): WideString;
  public
    constructor Create();
    destructor Destroy(); override;
    function Import(const FileName: WideString): integer;
  end;


  /// A FTP source/destination place is encapsulated into
  /// this class in version 7
  TFTPAccount7 = class
  private
    FSl: TStringList;
  public
    FFTPID: AnsiString;
    FFTPPassword: AnsiString;
    FFTPPort: integer;
    FFTPHost: AnsiString;
    FFTPWorkingDirectory: AnsiString;
    //SSL and security stuff
    FTSL: integer; //Transfer securiry level
    FAuthType: integer;
    FDataProtection: integer;
    FProxyType: integer;
    FProxyHost: AnsiString;
    FProxyPort: integer;
    FProxyID: AnsiString;
    FProxyPassword: AnsiString;
    FDataPort: integer;
    FDataPortMin: integer;
    FDataPortMax: integer;
    FExternalIP: AnsiString;
    FPassive: boolean;
    FTransferTimeOut: integer;
    FConnectionTimeOut: integer;
    FUseMLIS: boolean;
    FUseExtensionDataPort: boolean;
    FUseCCC: boolean;
    FTryNAT: boolean;
    FCertificateFile: AnsiString;
    FCipherList: AnsiString;
    FKeyFile: AnsiString;
    FRootCertificate: AnsiString;
    FSSLMethod: integer;
    FSSLMode: integer;
    FVerifyDirs: AnsiString; //not used
    FVerifyDepth: integer;
    FVerify_Peer: boolean;
    FVerify_Fail: boolean;
    FVerify_Client: boolean;
    FNagle: boolean;
    /// these 2 properties are used to indicate the stored files or dirs
    /// in the backup
    FBUKind: integer;
    FBUObjects: AnsiString;
    constructor Create();
    destructor Destroy(); override;

    ///  The Address is a commaseparated value
    procedure DecodeAddress(Address: AnsiString);
  end;

implementation

uses bmConstants, CobCommonW, CobEncrypt, CobCommon;

{ TImporter }

procedure TImporter.Convert6to8(Task: TTask; const Sl: TStringList);
var
  ID: WideString;
  TempInt: integer;
  OK: boolean;
begin
  Task.Name:= WideString(Sl.Values[S_6NAME]);
  if (Settings.TaskNameExists(Task.Name, ID) <> INT_TASKNOTFOUND ) then
    Task.Name:= CobGetUniqueNameW();
  Task.ID:= CobGetUniqueNameW();
  Task.Disabled:= CobCommon.CobStrToBool(Sl.Values[S_6DISABLED]);
  Task.IncludeSubdirectories:= CobCommon.CobStrToBool(Sl.Values[S_6SUBDIRS]);
  Task.SeparateBackups:= not CobCommon.CobStrToBool(Sl.Values[S_6OVERWRITE]); // ATTENTION
  Task.UseAttributes:= true;
  Task.ResetAttributes:= true; // ATTENTION
  if (CobCommon.CobStrToBool(Sl.Values[S_6INCREMENTAL])) then
    Task.BackupType:= INT_BUINCREMENTAL else
    Task.BackupType:= INT_BUFULL;
  Task.FullCopiesToKeep:= CobCommon.CobStrToInt(Sl.Values[S_6KEEP], INT_NIL);
  Task.Source:= SourceDestination6to8(Sl.Values[S_6SOURCE]);
  Task.Destination:= SourceDestination6to8(Sl.Values[S_6DESTINATION]);
  TempInt:= CobCommon.CobStrToInt(Sl.Values[S_6BACKUPTYPE], INT_SCDAILY);
  if (TempInt <= INT_SCMONTHLY) then  // ATTENTION, Yearly backups have ben added
    Task.ScheduleType:= TempInt else
    Task.ScheduleType:= TempInt + 1;
  Task.DateTime:= CobCommon.CobBinToDouble(Sl.Values[S_6DATETIME], OK);
  if (not OK) then
    Task.DateTime:= Now() - 1;
  Task.DayWeek:= WideString(Sl.Values[S_6DAYWEEK]);
  Task.DayMonth:= WideString(Sl.Values[S_6DAYMONTH]);
  Task.Month:= INT_MJANUARY;   // New feature
  Task.Timer:= CobCommon.CobStrToInt(Sl.Values[S_6TIMER], INT_DEFTIMER);
  Task.MakeFullBackup:= INT_NIL;
  if (CobCommon.CobStrToBool(Sl.Values[S_6COMPRESS])) then
    Task.Compress:= INT_COMPZIP else
    Task.Compress:= INT_COMPNOCOMP;
  Task.ArchiveProtect:= false;     // Was done in the options
  Task.Password:= WS_NIL;          // Was done in the options
  if (CobCommon.CobStrToBool(Sl.Values[S_6SPLIT])) then
  begin
    Task.Split:= CobCommon.CobStrToInt(Sl.Values[S_6SPLITBLOCKS],INT_SPLITNOSPLIT);
  end else
    Task.Split:= INT_SPLITNOSPLIT;
  Task.SplitCustom:= CobCommon.CobStrToInt64(Sl.Values[S_6CHUNKS], INT_DEFCUSTOM);
  Task.ArchiveComment:= WideString(Sl.Values[S_6COMMENT]);
  Task.Encryption:= INT_ENCNOENC;     // The password was stored on the options, so...
  Task.Passphrase:= WS_NIL;
  Task.PublicKey:= WS_NIL;   // new feature
  Task.IncludeMasks:= WideString(Sl.Values[S_6INCLUDEFILES]);
  Task.ExcludeItems:= WideString(Sl.Values[S_6EXCLUDEFILES]);
  Task.BeforeEvents:= WS_NIL;   
  Task.AfterEvents:= WS_NIL;
  Task.Impersonate:= false;
  Task.ImpersonateCancel:= false;
  Task.ImpersonateID:= WS_NIL;
  Task.ImpersonateDomain:= WS_NIL;
  Task.ImpersonatePassword:= WS_NIL;
end;

procedure TImporter.Convert7to8(Task: TTask; const Sl: TStringList);
var
  ID: WideString;
  TempInt: integer;
  OK: boolean;
  Password: AnsiString;
begin
  Task.Name:= WideString(Sl.Values[S_7NAME]);
  if (Settings.TaskNameExists(Task.Name, ID) <> INT_TASKNOTFOUND ) then
    Task.Name:= CobGetUniqueNameW();
  Task.ID:= CobGetUniqueNameW();
  Task.Disabled:= CobCommon.CobStrToBool(Sl.Values[S_7DISABLED]);
  Task.IncludeSubdirectories:= CobCommon.CobStrToBool(Sl.Values[S_7SUBDIRS]);
  Task.SeparateBackups:= not CobCommon.CobStrToBool(Sl.Values[S_7OVERWRITE]); // ATTENTION
  Task.UseAttributes:= true;
  Task.ResetAttributes:= not CobCommon.CobStrToBool(Sl.Values[S_7DONOTRESETARCHIVE]); // ATTENTION
  Task.BackupType:= CobCommon.CobStrToInt(Sl.Values[S_7BACKUPTYPE], INT_BUFULL);
  Task.FullCopiesToKeep:= CobCommon.CobStrToInt(Sl.Values[S_7COPIESTOKEEP], INT_NIL);
  Task.Source:= SourceDestination7to8(Sl.Values[S_7SOURCE]);
  Task.Destination:= SourceDestination7to8(Sl.Values[S_7DESTINATION]);
  TempInt:= CobCommon.CobStrToInt(Sl.Values[S_7SCHEDULETYPE], INT_SCDAILY);
  if (TempInt <= INT_SCMONTHLY) then  // ATTENTION, Yearly backups have ben added
    Task.ScheduleType:= TempInt else
    Task.ScheduleType:= TempInt + 1;
  Task.DateTime:= CobCommon.CobBinToDouble(Sl.Values[S_7DATETIME], OK);
  if (not OK) then
    Task.DateTime:= Now() - 1;
  Task.DayWeek:= WideString(Sl.Values[S_7DAYWEEK]);
  Task.DayMonth:= WideString(Sl.Values[S_7DAYMONTH]);
  Task.Month:= INT_MJANUARY;   // New feature
  Task.Timer:= CobCommon.CobStrToInt(Sl.Values[S_7TIMER], INT_DEFTIMER);
  Task.MakeFullBackup:= CobCommon.CobStrToInt(Sl.Values[S_7EVERYXFULL], INT_NIL);
  Task.Compress:= CobCommon.CobStrToInt(Sl.Values[S_7COMPRESSION], INT_COMPNOCOMP);
  Task.ArchiveProtect:= CobCommon.CobStrToBool(Sl.Values[S_7ARCHIVEPROTECT]);
  Password:= CobCommon.CobDeCryptTextEx(Sl.Values[S_7PASSWORD],S_V7PASSWORD,OK);
  if (not OK) then
    Password:= S_NIL;
  Task.Password:= WideString(Password);
  Task.Split:= CobCommon.CobStrToInt(Sl.Values[S_7SPLIT],INT_SPLITNOSPLIT);
  Task.SplitCustom:= CobCommon.CobStrToInt64(Sl.Values[S_7SPLITCUSTOM], INT_DEFCUSTOM);
  Task.ArchiveComment:= WideString(Sl.Values[S_7ARCHIVECOMMENT]);
  TempInt:= CobCommon.CobStrToInt(Sl.Values[S_7ENCRYPTION], INT_ENCNOENC);
  if (TempInt = INT_ENCNOENC) then
    Task.Encryption:= TempInt else
    Task.Encryption:= TempInt + 1;     // Attention, new encryption method added
  Password:= CobCommon.CobDeCryptTextEx(Sl.Values[S_7PASSPHRASE], S_V7PASSWORD,OK);
  if (not OK) then
    Password:= S_NIL;
  Task.Passphrase:= WideString(Password);
  Task.PublicKey:= WS_NIL;   // new feature
  Task.IncludeMasks:= WideString(Sl.Values[S_7INCLUDE]);
  Task.ExcludeItems:= WideString(Sl.Values[S_7EXCLUDE]);
  Task.BeforeEvents:= WideString(Sl.Values[S_7BEFOREEVENT]);
  Task.AfterEvents:= WideString(Sl.Values[S_7AFTEREVENT]);
  Task.Impersonate:= false;
  Task.ImpersonateCancel:= false;
  Task.ImpersonateID:= WS_NIL;
  Task.ImpersonateDomain:= WS_NIL;
  Task.ImpersonatePassword:= WS_NIL;
end;

constructor TImporter.Create();
begin
  inherited Create();
  FSl:= TTntStringList.Create();
  FTools:= TCobTools.Create();
end;

destructor TImporter.Destroy();
begin
  FreeAndNil(FTools);
  FreeAndNil(FSl);
  inherited Destroy();
end;

function TImporter.Ftp6to8(const Value: WideString): WideString;
var
  FTP: TFTPAddress;
  Sl: TTntStringList;
  PassA: AnsiString;
  Pass: WideString;
begin
  FTP:= TFTPAddress.Create();
  Sl:= TTntStringList.Create();
  try
    FTP.SetDefaultValues();
    Sl.CommaText:= Value;
    if (Sl.Count = 5) then
    begin
      FTP.ID:= Sl[0];
      PassA:= AnsiString(Sl[1]);
      PassA:= CobDeCryptText(PassA, S_V6PASSWORD);
      CobEncryptStringW(WideString(PassA),WS_LLAVE, Pass);
      FTP.Password:= Pass;
      FTP.Host:= Sl[2];
      FTP.Port:= CobStrToInt(Sl[3], INT_DEFFTPPORT);
      FTP.WorkingDir:= Sl[4];
    end;
    Result:= FTP.EncodeAddress();
  finally
    FreeAndNil(Sl);
    FreeAndNil(FTP);
  end;
end;

function TImporter.Ftp7to8(const Value: AnsiString): WideString;
var
  FTP7: TFTPAccount7;
  FTP: TFTPAddress;
  Pass: WideString;
begin
  FTP7:= TFTPAccount7.Create();
  FTP:= TFTPAddress.Create();
  try
    FTP7.DecodeAddress(Value);
    FTP.Host:= WideString(FTP7.FFTPHost);
    FTP.ID:= WideString(FTP7.FFTPID);
    CobEncryptStringW(WideString(FTP7.FFTPPassword), WS_LLAVE, Pass);
    FTP.Password:= Pass ;
    FTP.Port:= FTP7.FFTPPort;
    FTP.WorkingDir:= WideString(FTP7.FFTPWorkingDirectory);
    FTP.TLS:= FTP7.FTSL;
    FTP.AuthType:= FTP7.FAuthType;
    FTP.DataProtection:= FTP7.FDataProtection;
    FTP.ProxyType:= FTP7.FProxyType;
    FTP.ProxyPort:= FTP7.FProxyPort;
    FTP.ProxyHost:= WideString(FTP7.FProxyHost);
    FTP.ProxyID:= WideString(FTP7.FProxyID);
    CobEncryptStringW(WideString(FTP7.FProxyPassword), WS_LLAVE, Pass);
    FTP.ProxyPassword:= Pass;
    FTP.DataPort:= FTP7.FDataPort;
    FTP.MinPort:= FTP7.FDataPortMin;
    FTP.MaxPort:= FTP7.FDataPortMax;
    FTP.ExternalIP:= WideString(FTP7.FExternalIP);
    FTP.Passive:= FTP7.FPassive;
    FTP.TransferTimeOut:= FTP7.FTransferTimeOut;
    FTP.ConnectionTimeout:= FTP7.FConnectionTimeOut;
    FTP.UseMLIS:= FTP7.FUseMLIS;
    FTP.UseIPv6:= FTP7.FUseExtensionDataPort;
    FTP.UseCCC:= FTP7.FUseCCC;
    FTP.NATFastTrack:= FTP7.FTryNAT;
    FTP.SSLMethod:= FTP7.FSSLMethod;
    FTP.SSLMode:= FTP7.FSSLMode;
    FTP.UseNagle:= FTP7.FNagle;
    FTP.VerifyDepth:= FTP7.FVerifyDepth;
    FTP.Peer:= FTP7.FVerify_Peer;
    FTP.FailIfNoPeer:= FTP7.FVerify_Fail;
    FTP.ClientOnce:= FTP7.FVerify_Client;
    FTP.CertificateFile:= WideString(FTP7.FCertificateFile);
    FTP.CipherList:= WideString(FTP7.FCipherList);
    FTP.KeyFile:= WideString(FTP7.FKeyFile);
    FTP.RootCertificate:= WideString(FTP.RootCertificate);
    FTP.VerifyDirectories:= WideString(FTP7.FVerifyDirs);
    Result:= FTP.EncodeAddress();
  finally
    FreeANdNil(FTP);
    FreeAndNil(FTP7);
  end;
end;

function TImporter.GetListVersion(): integer;
begin
  Result:= INT_VER0;

  try
    FSl.LoadFromFile(FFileName);
  except
    Result:= INT_VER0;
    Exit;
  end;

  if (FSl.Count = 0) then
  begin
    // this is an empty list
    // Asume this is v8
    //Resave the list to convert it to unicode
    FSL.SaveToFile(FFileName);
    Result:= INT_VER8;
    Exit;
  end;

  if (FSl[0] = WS_SEPB6) then
  begin
    Result:= INT_VER6;
    Exit;
  end;

  if (FSl[0] = WS_SEPB7) then
  begin
    Result:= INT_VER7;
    Exit;
  end;

  if (FSl[0] = WS_TASKBEGIN) then
  begin
    Result:= INT_VER8;
    Exit;
  end;

end;

function TImporter.Import(const FileName: WideString): integer;
begin
  // This function returns the  version of the imported list
  // or ZERO if the import failed
  FFileName:= FileName;
  Result:= GetListVersion();

  case Result of
    INT_VER6: Import6();

    INT_VER7: Import7();

    INT_VER8: Import8();
    else
      //version 0
      Result:= INT_VER0;
      Exit;
  end;
end;

procedure TImporter.Import6();
var
  Sl: TStringList;
  i: integer;
  Task: TTask;
begin
  //USe ANSI
  Sl:= TStringList.Create();
  try
    for i:= 0 to FSl.Count-1 do
    begin
      if (FSl[i] = WS_SEPB6) then
      begin
        Sl.Clear();
        Sl.Add(AnsiString(FSl[i]));
      end else
      if (FSl[i] = WS_SEPE6) then
      begin
        Sl.Add(AnsiString(FSl[i]));
        Task:= TTask.Create();
        Convert6to8(Task, Sl);
        Settings.AddTask(Task);
      end else
        Sl.Add(AnsiString(FSl[i]));
    end;
  finally
    FreeAndNil(Sl);
  end;
end;

procedure TImporter.Import7();
var
  Sl: TStringList;
  i: integer;
  Task: TTask;
begin
  // Use ANSI
  Sl:= TStringList.Create();
  try
    for i:=0 to FSl.Count -1 do
    begin
      if (FSl[i] = WS_SEPB7) then
      begin
        Sl.Clear();
        Sl.Add(AnsiString(FSl[i]));
      end else
      if (FSl[i] = WS_SEPE7) then
      begin
        Sl.Add(AnsiString(FSl[i]));
        Task:= TTask.Create();
        Convert7to8(Task,Sl);
        Settings.AddTask(Task);
      end else
      Sl.Add(AnsiString(FSl[i]));
    end;
  finally
    FreeAndNil(Sl);
  end;
end;

procedure TImporter.Import8();
var
  Task: TTask;
  i: integer;
  ID: WideString;
  Sl: TTntStringList;
begin
  Sl:= TTntStringList.Create();
  try
    for i:= 0 to FSl.Count - 1 do
    begin
      if (FSl[i] = WS_TASKBEGIN) then
        begin
          Sl.Clear();
          Sl.Add(FSl[i]);
        end else
        if (FSl[i] = WS_TASKEND) then
        begin
          Sl.Add(FSl[i]);

          Task:= TTask.Create();
          Task.StrToTaskW(Sl.CommaText);
          // Change the ID
          Task.ID:= CobGetUniqueNameW();
          // the name also must be unique
          if (Settings.TaskNameExists(Task.Name, ID) <> INT_TASKNOTFOUND) then
            Task.Name:= CobGetUniqueNameW();

          Settings.AddTask(Task);
        end else
          Sl.Add(FSl[i]);      
    end;
  finally
    FreeAndNil(Sl);
  end;
end;

function TImporter.SourceDestination7to8(const Value: AnsiString): WideString;
var
  Sl, Helper: TStringList;
  Sll: TTntStringList;
  i, Kind: integer;
  Source: AnsiString;
  SourceW: WideString;
begin
  Result:= WS_NIL;
  Sl:= TStringList.Create();
  Helper:= TStringList.Create();
  Sll:= TTntStringList.Create();
  try
    Sl.CommaText:= Value;
    for i:= 0 to Sl.Count - 1 do
    begin
      Helper.CommaText:= Sl[i];
      if (Helper.Count <> 2) then
        Continue;
      Source:= Helper[1];
      Kind:= CobStrToIntW(WideString(Helper[0]), INT_SDMANUAL);
      if (Kind <> INT_SDFTP) then
        SourceW:= WideString(Source) else
        SourceW:= Ftp7to8(Source);
      Sll.Add(FTools.EncodeSD(Kind, SourceW));
    end;
    Result:= Sll.CommaText; 
  finally
    FreeAndNil(Sll);
    FreeAndNil(Helper);
    FreeAndNil(Sl);
  end;
end;

function TImporter.SourceDestination6to8(const SD: AnsiString): WideString;
var
  Sl: TTntStringList;
  i, Kind: integer;
  s, KindS: WideString;
begin
  Sl:= TTntStringList.Create();
  try
    Sl.CommaText:= WideString(SD);
    for i:=0 to Sl.Count-1 do
    begin
      s:= Sl[i];
      if Length(s) > 2 then
      begin
        KindS:= Copy(s,1,1);
        Delete(s,1,2);
        Kind:= CobStrToInt(KindS, INT_SDFILE);
        if (Kind = INT_SDFTP) then
          s:= Ftp6to8(s);
        Sl[i]:= FTools.EncodeSD(Kind, s);
      end;
    end;
    Result:= Sl.CommaText;
  finally
    FreeAndNil(Sl);
  end;
end;

{ TFTPAccount }

constructor TFTPAccount7.Create();
begin
  inherited Create();
  FSl := TStringList.Create();
end;

procedure TFTPAccount7.DecodeAddress(Address: AnsiString);
begin
  //Takes an address in the format
  //ftp://id:password@host:port/initialdir
  //And breaks it down to its components
  FFTPID := S_NIL;
  FFTPPassword := S_NIL;
  FFTPPort := INT_DEFFTPPORT;
  FFTPHost := S_NIL;
  FFTPWorkingDirectory := S_SLASH;

  FSl.CommaText := Address;

  if FSl.Count < 38 then
    Exit;

  FFTPID := FSl[0];

  FFTPPassword := CobDecryptText(FSl[1], S_V7PASSWORD);

  FFTPHost := FSl[2];

  try
    FFTPPort := StrToInt(FSl[3]);
  except
    FFTPPort := INT_DEFFTPPORT;
  end;

  FFTPWorkingDirectory := FSl[4];

  if FFTPWorkingDirectory = S_NIL then
    FFTPWorkingDirectory := S_SLASH;

  if FFTPWorkingDirectory[1] <> S_SLASH then
    FFTPWorkingDirectory := S_SLASH + FFTPWorkingDirectory;

  try
    FTSL := StrToInt(FSl[5]);
  except
    FTSL := 0; //not secure
  end;

  try
    FAuthType := StrToInt(FSl[6]);
  except
    FAuthType := 4; //Auto
  end;

  try
    FDataProtection := StrToInt(FSl[7]);
  except
    FDataProtection := 0;
  end;

  try
    FProxyType := StrToInt(FSl[8]);
  except
    FProxyType := 2; //none
  end;

  FProxyHost := FSL[9];

  try
    FProxyPort := StrToInt(FSL[10]);
  except
    FProxyPort := INT_STDPROXY;
  end;

  FProxyID := FSL[11];
  FProxyPassword := CobDecryptText(FSL[12], S_V7PASSWORD);

  try
    FDataPort := StrToInt(FSL[13]);
  except
    FDataPort := 0;
  end;

  try
    FDataPortMin := StrToInt(FSL[14]);
  except
    FDataPortMin := 0;
  end;

  try
    FDataPortMax := StrToInt(FSL[15]);
  except
    FDataPortMax := 0;
  end;

  FExternalIP := FSL[16];
  FPassive := CobStrToBool(FSL[17]);

  try
    FTransferTimeOut := StrToInt(FSL[18]);
  except
    FTransferTimeOut := INT_TCPDEFAULTTIMEOUT;
  end;

  try
    FConnectionTimeOut := StrToInt(FSL[19]);
  except
    FConnectionTimeOut := INT_TCPDEFAULTTIMEOUT;
  end;

  FUseMLIS := CobStrToBool(FSL[20]);
  FUseExtensionDataPort := CobStrToBool(FSL[21]);
  FUseCCC := CobStrToBool(FSL[22]);
  FTryNAT := CobStrToBool(FSL[23]);
  FCertificateFile := FSL[24];
  FCipherList := FSL[25];
  FKeyFile := FSL[26];
  FRootCertificate := FSL[27];
  try
    FSSLMethod := StrToInt(FSL[28]);
  except
    FSSLMethod := 0;
  end;

  try
    FSSLMode := StrToInt(FSL[29]);
  except
    FSSLMode := 3;
  end;

  FVerifyDirs := FSL[30]; //not used

  try
    FVerifyDepth := StrToInt(FSL[31]);
  except
    FVerifyDepth := 0;
  end;

  FVerify_Peer := CobStrToBool(FSL[32]);

  FVerify_Fail := CobStrToBool(FSL[33]);

  FVerify_Client := CobStrToBool(FSL[34]);

  FNagle := CobStrToBool(FSL[35]);

  FBUKind := CobStrToInt(FSL[36], 0);

  FBUObjects := FSl[37];
end;

destructor TFTPAccount7.Destroy();
begin
  FreeAndNil(FSl);
  inherited Destroy();
end;

end.
