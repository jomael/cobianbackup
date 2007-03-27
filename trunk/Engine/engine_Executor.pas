{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~                                                            ~~~~~~~~~~
~~~~~~~~~~               Cobian Backup Black Moon                     ~~~~~~~~~~
~~~~~~~~~~           Copyright 2000-2006 by Luis Cobian               ~~~~~~~~~~
~~~~~~~~~~                     cobian@educ.umu.se                     ~~~~~~~~~~
~~~~~~~~~~                    All rights reserved                     ~~~~~~~~~~
~~~~~~~~~~                                                            ~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

// This is the main WORKING thread of the engine. It processes the queue of
// tasks that are waiting to be executed 

unit engine_Executor;

interface

uses
  Classes, SysUtils, Windows, TntClasses, bmCommon, CobPipesW;

type
  TResultFile = record
    AObject: WideString;
    Destination: integer;
    end;
  PResultFile = ^TResultFile;

  TExecutor = class(TThread)
  public
    constructor Create(const AppPath: WideString;
                      const IsService:boolean; const Sec: PSecurityAttributes);
    destructor Destroy();override;
  private
    { Private declarations }
    FAppPath: WideString;
    FS: TFormatSettings;
    FTemp: WideString;
    FIPCHandle: THandle;
    FIPCMutex: Thandle;
    FSenderPointer: PWideChar;
    FMsg: TTntStringList;
    FWriter: TTntStringList;
    FTask: TTask;
    FFirstBackupTerminated: boolean;
    FTools: TCobTools;
    FAbort: boolean;
    FBackupBegin: cardinal;
    FBackupEnd: cardinal;
    FIsService: boolean;
    FSec: PSecurityAttributes;
    FParam1W: WideString;
    FParam2W: WideString;
    FToken: THandle;
    FResultFiles: TList;
    FDestinationIndex: integer;
    FLastElement: boolean;
    FTaskFiles: int64; // holds all the  files backed up on a task
    FDoNotSeparateDate: boolean;
    FDoNotUseSpaces: boolean;
    FDTFormat: WideString;
    FSlow: boolean;
    FBufferSize: integer;
    FCheckCRC: boolean;
    FCopyTimeStamps: boolean;
    FCopyAttributes: boolean;
    FCopyNTFS: boolean;
    FHistoryList: TBackupList;
    // Vars
    FTotalTasks: integer;
    FCurrentTaskCount: integer;
    FTotalFiles: int64;
    FCurrentFileCount: int64;
    FCurrentFileName : WideString;
    FPartialPercent : integer;
    FTotalPercent : integer;
    {FOldTotalPercent: integer;
    FOldPartialPercent: integer;
    FOldCurrentFileName: WideString;}

    // Settings
    FShowExactPercent: boolean;
    FMailOnBackup: boolean;
    FLog: boolean;
    FMailLog: boolean;
    FImpersonated: boolean;
    FUseVisibleDesktop: boolean;
    FForceFirstFull: boolean;
    FUseShell: boolean;
    FAlternative: boolean;
    FErrors: cardinal;
    FNTFSHandle: THandle;
    FCopyNTFSFunction: TNTCopySecurity;
    FNTSecCreate: TNTSecCreate;
    FNTSecDestroy: TNTSecDestroy;
    FParkFirstBackup: boolean;
    FDeleteEmptyFolders: boolean;
    FAlwaysCreateDirs: boolean;
    FCompAbsolute: boolean;
    FZipLevel: integer;
    FUseTaskNames: boolean;
    FCompCRC: boolean;
    FZipAdvancedNaming: boolean;
    FCompOEM: boolean;
    FZip64: integer;
    FUncompressed: WideString;
    FSqxLevel: integer;
    FSqxDictionary: integer;
    FSqxRecovery: integer;
    FSqxExternal: boolean;
    FSqxSolid: boolean;
    FSqxExe: boolean;
    FSqxMultimedia: boolean;
    FFTPSpeedLimit: boolean;
    FFTPSpeed: integer;
    FFTPASCII: WideString;
    FPropagate: boolean;
    FPipeClient: TCobPipeClientW;
    FUsePipes: boolean;
    FOldPipeTime: cardinal;
    procedure SetInitialValues();
    procedure LoadLocalSettings();
    function NeedToReload(): boolean;
    procedure CreateIPCSender(const Sec: PSecurityAttributes);
    procedure DestroyIPCSender();
    procedure SendStatus(const Operation: integer; const Std: boolean = true);
    function DoAbort(): boolean;
    function ExtractBackup(): boolean;
    procedure QueueNoItems();
    procedure MailLog();
    function AutoClose(): boolean;
    procedure CloseProgram();
    function CountFiles(const ATask: TTask): int64;
    procedure Backup();
    procedure Action();
    procedure Start();
    procedure ExecuteBeforeAfterEvents(const Before: boolean);
    procedure ExecuteEvent(const Event: WideString; const Before: boolean);
    procedure ClearUIResponseFlag();
    function GetUIResponse(): cardinal;
    //Events
    procedure EvDoPause(const Pause: integer; const Before: boolean);
    procedure EvExecute(const FileName, Param: WideString; const Before: boolean);
    procedure EvExecuteAndWait(const FileName, Param: WideString; const Before: boolean);
    procedure EvClose(const ACaption: WideString; const Kill, Before: boolean);
    procedure EvStartService(const ServiceName, Param: WideString;
                              const Before: boolean);
    procedure EvStopService(const ServiceName: WideString;
                              const Before: boolean);
    procedure EvRestart(const Restart, Kill, Before: boolean);
    function Impersonate(): boolean;
    procedure StopImpersonation();
    function IsUIPresent(): boolean;
    procedure ExecuteBackup();
    procedure CheckBackupType();
    procedure UpdateTaskHistory();
    procedure DeleteOldBackups();
    procedure DeleteBackup(const Backup: TBackup);
    procedure DeleteFTP(const Backup: TBackup);
    procedure DeleteLocal(const Backup: TBackup);
    procedure DeleteChildrenBackup(const Parents: TTntStringList);
    function GetNextBackupTime(const dt: TDateTime): TDateTime;
    procedure DoBackup();
    procedure BackupNoCompress();
    procedure BackupZip();
    procedure BackupSQX();
    procedure Zip(const Source, Destination: WideString);
    procedure Sqx(const Source, Destination: WideString);
    procedure AddBackupResult(const Obj: WideString);
    function DownloadFTPSource(const Source: WideString): WideString;
    procedure CopyADirectory(const Source: WideString);
    procedure CopyAFile(const Source: WideString);
    procedure CopyFileLocal(const Source, Destination: WideString);
    procedure CopyFileFTP(const Source, Destination: WideString);
    procedure CopyDirLocal(const Source, Destination: WideString);
    procedure CopyDirFTP(const Source, Destination: WideString);
    procedure CopyFileLocalNoEnc(const Source, Destination: WideString);
    procedure CopyFileLocalEnc(const Source, Destination: WideString);
    procedure EncryptZipFiles(const Files: WideString);
    procedure CopyDirLocalNoEnc(const Source, Destination: WideString);
    procedure CopyDirLocalEnc(const Source, Destination: WideString);
    procedure ClearResultFiles();
    procedure ProcessLocalCompressedFiles(const Files: WideString);
    procedure ProcessFTPCompressedFiles(const Files, Destination: WideString);
    //**********   Events (common)  **********
    procedure OnObjectLog(const Msg: WideString; const Error, Verbose: boolean);
    function OnObjectAbort(): boolean;
    //*********    Events copier    ***********
    procedure OnCopyFileBegin(const FileName, DestFile: WideString; const Single: boolean);
    procedure OnCopyFileEnd(const FileName, DestFile: WideString; const Single, Success: boolean);
    procedure OnCopyProgressDone(const FileName: WideString;const PercentDone: integer);
    procedure OnCopyCRCProgress(const FileName: WideString; const PercentDone: integer);
    function OnNTFSPermissionsCopy(const Source, Destination: WideString): cardinal;
    function OnDeleteProgress(const FileName: WideString): boolean;
    //*********  Events encryption ************
    procedure OnEncryptionBegin(const FileName, DestFile: WideString; const Single: boolean);
    procedure OnEncryptionEnd(const FileName, DestFile: WideString; const Single, Success, Secundary: boolean);
    procedure OnEncryptionProgressDone(const FileName: WideString;const PercentDone: integer);
    // Events zip
    procedure OnCompressFileBegin(const FileName: WideString; const Checking: boolean);
    procedure OnCompressFileEnd(const FileName: WideString; const Checking: boolean);
    procedure OnCompressProgress(const FileName: WideString; const Percent: integer;
                                                        const Checking:boolean);
    //Events FTP
    procedure OnFTPFileBegin(const FileName, Destination: WideString; const Single, Downloading: boolean);
    procedure OnFTPFileEnd(const FileName, Destination: WideString; const Single, Success, Downloading: boolean);
    procedure OnFTPProgress(const FileName: WideString; const Percent: integer; const Downloading: boolean);
  protected
    procedure Execute(); override;
  end;

var
  Executor: TExecutor;

implementation

uses bmConstants, bmCustomize, CobCommonW, engine_Logger, Messages,
  engine_Mailer, bmTranslator, TntSysUtils, engine_Copier, DateUtils,
  bmEncryptor, engine_Zipper, engine_SQX, bmFTP;

{ TExecutor }

function TExecutor.DoAbort(): boolean;
begin
  Result:= Terminated or FAbort;

  if (not Result) then
  begin
    CS_Abort.Enter();
    try
      Result:= Flag_Abort;
      if (Result) then
      begin
        FAbort:= BOOL_DOABORT;
        Flag_Abort:= BOOL_CONTINUE;
      end;
    finally
      CS_Abort.Leave();
    end;
  end;
end;

procedure TExecutor.DoBackup();
begin
  case FTask.Compress of
    INT_COMPZIP: BackupZip();
    INT_COMP7ZIP: BackupSQX();
    else
    BackupNoCompress();
  end;
end;

function TExecutor.DownloadFTPSource(const Source: WideString): WideString;
var
  FTP: TFTP;
  Rec: TFTPrec;
begin
  // This downloads a FTP source into the temporary directory
  // and returns the name of teh directory
  Result:= WS_NIL;

  Rec.AppPath:= FAppPath;
  Rec.Temp:= FTemp;
  Rec.IncludeSubDirs:= FTask.IncludeSubdirectories;
  Rec.IncludeMask:= FTask.IncludeMasks;
  Rec.ExcludeMask:= FTask.ExcludeItems;
  Rec.Slow:= FSlow;
  Rec.SpeedLimit:= FFTPSpeedLimit;
  Rec.Speed:= FFTPSpeed;
  Rec.ASCII:= FFTPASCII;
  Rec.UseAttributes:= FTask.UseAttributes;
  Rec.Separated:= FTask.SeparateBackups;
  Rec.DTFormat:= FDTFormat;
  Rec.DoNotSeparate:= FDoNotSeparateDate;
  Rec.DoNotUseSpaces:= FDoNotUseSpaces;
  Rec.BackupType:= FTask.BackupType;
  Rec.EncBufferSize:= FBufferSize;
  Rec.EncCopyTimeStamps:= FCopyTimeStamps;
  Rec.EncCopyAttributes:= FCopyAttributes;
  Rec.EncCopyNTFS:= FCopyNTFS;
  Rec.ClearAttributes:= FTask.ResetAttributes;
  Rec.DeleteEmptyFolders:= FDeleteEmptyFolders;
  Rec.AlwaysCreateDirs:= FAlwaysCreateDirs;
  Rec.EncPublicKey:= Ftask.PublicKey;
  Rec.EncMethod:= FTask.Encryption;
  Rec.EncPassPhrase:= FTask.Passphrase;
  Rec.Propagate:= FPropagate;

  FTP:= TFTP.Create(Rec);
  try
    FTP.OnAbort:= OnObjectAbort;
    FTP.OnLog:= OnObjectLog;
    FTP.OnProgress:= OnFTPProgress;
    FTP.OnFileBegin:= OnFTPFileBegin;
    FTP.OnFileEnd:= OnFTPFileEnd;
    FTP.OnFileBeginEnc:= OnEncryptionBegin;
    FTP.OnFileEndEnc:= OnEncryptionEnd;
    FTP.OnFileProgressEnc:= OnEncryptionProgressDone;
    FTP.OnNTFSPermissionsCopyEnc:= OnNTFSPermissionsCopy;
    FTP.OnDelete:= OnDeleteProgress;
    if FTP.Download(Source, FTemp) <> INT_FTPFAILED then
      Result:= FTP.DDirectory;
  finally
    FreeAndNil(FTP);
  end;
end;

procedure TExecutor.Action();
var
  Seconds: cardinal;
  ToFormat: WideString;
  hh,mm,ss: integer;
begin
  Logger.Log(WideFormat(Translator.GetMessage('172'),[FTask.Name],FS), false, false);

  // Usefull to send the "begin backup signal" to the ui
  SendStatus(INT_OPBUBEGIN);

  // Take a little pause here, because if the backup is disabled, the interface
  // dont have time to show the "Begin backup" window
  Sleep(INT_PAUSEBB);

  FBackupBegin:= GetTickCount();
  FTaskFiles:= 0;
  FErrors:= 0;
  ClearResultFiles();

  // try to logon if needed
  FToken:= 0;
  FImpersonated:= false;
  if (FTask.Impersonate) then
  begin
    FImpersonated:= Impersonate();
    if (FTask.ImpersonateCancel) and (not FImpersonated) then
    begin
      Logger.Log(WideFormat(Translator.GetMessage('218'),[FTask.ImpersonateID],
                            FS), true, false);
      Inc(FErrors);
      Exit;
    end;
  end;

  ExecuteBeforeAfterEvents(BOOL_EV_BEFORE);

  try
    ExecuteBackup();

    if (DoAbort) then
      Exit;

    if (FTask.BackupType <> INT_BUDUMMY) then
      UpdateTaskHistory();

  finally
    // Execute the events
    ExecuteBeforeAfterEvents(BOOL_EV_AFTER);
    if (FTask.Impersonate) then
      StopImpersonation();
  end;

  // This will NOT get executed if Aborted
  FBackupEnd:=  GetTickCount();
  Seconds:= (FBackupEnd - FBackupBegin) div INT_MS;

  // 2006-11-16 by Luis Cobian
  // Change the presentation of the elapsed time
  CobSecondsToHMSW(Seconds, hh, mm, ss);
  ToFormat:= WideFormat(Translator.GetMessage('631'),[FTask.Name, FTaskFiles, hh, mm, ss],FS);

  Logger.Log(ToFormat, false, false);
end;

procedure TExecutor.AddBackupResult(const Obj: WideString);
var
  rf: PResultFile;
begin
  New(rf);
  rf^.AObject:= Obj;
  rf^.Destination:= FDestinationIndex;
  FResultFiles.Add(rf);
end;

function TExecutor.AutoClose(): boolean;
begin
  CS_AutoClose.Enter();
  try
    Result:= Flag_Autoclose;
    if (Result) then
      Flag_Autoclose:= false;
  finally
    CS_AutoClose.Leave();
  end;
end;

procedure TExecutor.Backup();
var
  ATask: TTask;
  Found: boolean;
begin
  Found:= false;

  with BackupQueue.LockList() do
  try
    if (Count > 0) then
    begin
      ATask:= Items[0];
      ATask.CloneTo(FTask);
      FreeAndNil(ATask);
      Delete(0);
      Found:= true;
    end;
  finally
    BackupQueue.UnlockList();
  end;

  if (Found) then
    Start();
end;

procedure TExecutor.BackupSQX();
var
  SourcesToDelete, Sources, Sl: TTntStringList;
  i, KindS: integer;
  Source: WideString;
begin
  SourcesToDelete:= TTntStringList.Create();
  Sources:= TTntStringList.Create();
  Sl:= TTntStringList.Create();
  try
    //First download the sources if needed
    { If the source contains, FTP sources, download them
    first into the temporary directory, substitute them
    by the created local directory and work locally}
    Sources.CommaText := FTask.Source;
    for i := 0 to Sources.Count - 1 do
    begin
      Source := FTools.DecodeSD(Sources[i], KindS);

      if KindS = INT_SDFTP then
      begin
        Source := DownloadFTPSource(Source);
        FTask.BackupType := INT_BUFULL; // must be full if downloading
        SourcesToDelete.Add(Source);
        Sources[i] := FTools.EncodeSD(INT_SDDIR, Source);
      end;

      if (FSlow) then
        Sleep(INT_SLOW);

      if (DoAbort) then
        Break;
    end;

    if (DoAbort) then
      Exit;

    Sl.CommaText:= FTask.Destination;

    for i:= 0 to Sl.Count-1 do
    begin
      FDestinationIndex:= i;  // This is used to mark the result in the list

      FLastElement:= (i = Sl.Count - 1);

      Sqx(Sources.CommaText, Sl[i]);

      if (FSlow) then
        Sleep(INT_SLOW);

      if (DoAbort()) then
        Break;
    end;


    for i:= 0 to SourcesToDelete.Count - 1 do
    begin
      FTools.DeleteDirectoryW(SourcesToDelete[i]);
      if (DoAbort()) then
        Break;
    end;
  finally
    FreeAndNil(Sl);
    FreeAndNil(Sources);
    FreeAndNil(SourcesToDelete);
  end;
end;

procedure TExecutor.BackupNoCompress();
var
  SS: TTntStringList;
  i: integer;
  KindS, OldBUType: integer;
  Source: WideString;
  DeleteSource: boolean;
begin
  OldBUType := INT_BUFULL;
  SS := TTntStringList.Create();
  try
    SS.CommaText := FTask.Source;

    for i := 0 to SS.Count - 1 do
    begin
      DeleteSource := false;
      Source := FTools.DecodeSD(SS[i], KindS);

      if (KindS = INT_SDMANUAL) then
      begin
        // This was parametrized when the task was added on engine_Scheduler
        // If after the transformation the source is not found
        // then go away
        Logger.Log(WideFormat(Translator.GetMessage('231'),[Source],FS),true,false);
        Inc(FErrors);
        Continue;
      end;


      // Analize the source type, if there are FTP sources, download then
      { If the source contains, FTP sources, download them
      first into the temporary directory, substitute them
      by the created local directory and work locally}

      if KindS = INT_SDFTP then
      begin
        Source := DownloadFTPSource(Source);
        KindS := INT_SDDIR;
        OldBUType := FTask.BackupType;
        FTask.BackupType := INT_BUFULL; //Only full backups are supported
        DeleteSource := true;
      end;

      if DoAbort() then
        Break;

      if KindS = INT_SDDIR then
        CopyADirectory(Source)
      else
        CopyAFile(Source);

      if DoAbort() then
        Break;

      if DeleteSource then // if downloaded
      begin
        FTask.BackupType := OldBUType;
        FTools.DeleteDirectoryW(Source);
      end;
    end;

  finally
    FreeAndNil(SS);
  end;
end;


procedure TExecutor.BackupZip();
var
  SourcesToDelete, Sources, Sl: TTntStringList;
  i, KindS: integer;
  Source: WideString;
begin
  SourcesToDelete:= TTntStringList.Create();
  Sources:= TTntStringList.Create();
  Sl:= TTntStringList.Create();
  try
    //First download the sources if needed
    { If the source contains, FTP sources, download them
    first into the temporary directory, substitute them
    by the created local directory and work locally}
    Sources.CommaText := FTask.Source;
    for i := 0 to Sources.Count - 1 do
    begin
      Source := FTools.DecodeSD(Sources[i], KindS);

      if KindS = INT_SDFTP then
      begin
        Source := DownloadFTPSource(Source);
        FTask.BackupType := INT_BUFULL; // must be full if downloading
        SourcesToDelete.Add(Source);
        Sources[i] := FTools.EncodeSD(INT_SDDIR, Source);
      end;

      if (FSlow) then
        Sleep(INT_SLOW);

      if (DoAbort) then
        Break;
    end;

    if (DoAbort) then
      Exit;

    Sl.CommaText:= FTask.Destination;

    for i:= 0 to Sl.Count-1 do
    begin
      FDestinationIndex:= i;  // This is used to mark the result in the list

      FLastElement:= (i = Sl.Count - 1);

      Zip(Sources.CommaText, Sl[i]);

      if (FSlow) then
        Sleep(INT_SLOW);

      if (DoAbort()) then
        Break;
    end;


    for i:= 0 to SourcesToDelete.Count - 1 do
    begin
      FTools.DeleteDirectoryW(SourcesToDelete[i]);
      if (DoAbort()) then
        Break;
    end;
  finally
    FreeAndNil(Sl);
    FreeAndNil(Sources);
    FreeAndNil(SourcesToDelete);
  end;
end;

procedure TExecutor.CheckBackupType();
var
  Sl: TTntStringList;
  FPos, i: integer;
  Backup: TBackup;
begin
  // Sometimes the backup type needs to be changed
  // before the real backup begins

  if (FTask.BackupType = INT_BUFULL) or (FTask.BackupType = INT_BUDUMMY) then
    Exit;

  if (not FTask.UseAttributes) then
  begin
    if (FTask.BackupType = INT_BUDIFFERENTIAL) then
    begin
      Logger.Log(WideFormat(Translator.GetMessage('227'),[FTask.Name],FS),false,false);
      FTask.BackupType:= INT_BUFULL;
      Exit;
    end;

    if (FTask.BackupType = INT_BUINCREMENTAL) and (FTask.SeparateBackups) then
    begin
      Logger.Log(WideFormat(Translator.GetMessage('227'),[FTask.Name],FS),false,false);
      FTask.BackupType:= INT_BUFULL;
      Exit;
    end;
  end;

  // if we are OVERWRITING backups, compressing AND encrypting
    // a full backup must be done because its iumpossible to
    // refresh an encrypted archive
  if (FTask.SeparateBackups = false) and (FTask.Compress <> INT_COMPNOCOMP) and
      (FTask.Encryption <> INT_ENCNOENC) then
  begin
    Logger.Log(WideFormat(Translator.GetMessage('228'),[FTask.Name],FS),false,false);
    FTask.BackupType:= INT_BUFULL;
    Exit;
  end;

  // no need to to change the backup here
  if (FTask.MakeFullBackup = 0) then
    Exit;

  // Force first backup full?
  Backup:= TBackup.Create(WS_NIL);
  Sl:= TTntStringList.Create();
  try
    Sl.CommaText:= Settings.GetHistoryFile(FTask.ID);
    if (Sl.Count = 0) and (FForceFirstFull) then
    begin
      Logger.Log(WideFormat(Translator.GetMessage('229'),[FTask.Name],FS),false,false);
      FTask.BackupType:= INT_BUFULL;
      Exit;
    end;

    // Now here we have an incremental or differential backup
    // with a FFUllBackup <>0. If this backup if the FFUllBackup Nr. one
    // then the BackupType must be changed to FULL

    FPos := -1;
    for i := Sl.Count - 1 downto 0 do
    begin
      Backup.StrToBackupW(Sl[i]);
      if Backup.FBackupType = INT_BUFULL then
      begin
        FPos := i;
        Break;
      end;
    end;

    if (FTask.MakeFullBackup <= (Sl.Count - 1 - FPos)) then
    begin
      Logger.Log(WideFormat(Translator.GetMessage('230'), [FTask.Name,
        Sl.Count + 1], FS), false, false);
      FTask.BackupType := INT_BUFULL;
      Exit;
    end;

  finally
    FreeAndNil(Sl);
    FreeAndNil(Backup);
  end;
end;

procedure TExecutor.ClearResultFiles();
var
  i: integer;
  rf: PResultFile;
begin
  for i:= FResultFiles.Count-1 downto 0 do
  begin
    rf:= PResultFile(FResultFiles[i]);
    Dispose(PresultFile(rf));
  end;

  FResultFiles.Clear();
end;

procedure TExecutor.ClearUIResponseFlag();
begin
  CS_UIResponse.Enter();
  try
    Flag_UI_Response:= INT_UINORESULT;
  finally
    CS_UIResponse.Leave();
  end;
end;

procedure TExecutor.CloseProgram();
var
  AppHandle: HWND;
begin
  AppHandle := FindWindowW(PWideChar
                (WideFormat(WS_SERVERCLASSNAME, [WS_PROGRAMNAMELONG], FS)), nil);
  if AppHandle <> 0 then
    PostMessageW(AppHandle, WM_CLOSE, 0, 0);
end;

procedure TExecutor.CopyADirectory(const Source: WideString);
var
  Sl: TTntStringList;
  i, KindD: integer;
  Destination: WideString;
begin
  Sl:= TTntStringList.Create();
  try
    Sl.CommaText:= FTask.Destination;
    for i:= 0 to Sl.Count - 1 do
    begin
      // This is used to mark the result in the list
      // That way I can separate the final backup in the backup list
      FDestinationIndex:= i;
      FLastElement:= (i = Sl.Count-1);
      Destination:= FTools.DecodeSD(Sl[i],KindD);

      // In a destination, only directories can have the INT_SDMANUAL type
      // The directory doesn't necessarely needs to exist
      if (KindD = INT_SDMANUAL) then
        KindD:= INT_SDDIR;

      if (KindD = INT_SDDIR) then
        CopyDirLocal(Source,Destination) else
        CopyDirFTP(Source,Destination);

      if (DoAbort()) then
        Break;
    end;
  finally
    FreeAndNil(Sl);
  end;
end;

procedure TExecutor.CopyAFile(const Source: WideString);
var
  Sl: TTntStringList;
  i, KindD: integer;
  Destination: WideString;
begin
  Sl:= TTntStringList.Create();
  try
    Sl.CommaText:= FTask.Destination;
    for i:= 0 to Sl.Count - 1 do
    begin
      // This is used to mark the result in the list
      // That way I can separate the final backup in the backup list
      FDestinationIndex:= i;
      FLastElement:= (i = Sl.Count-1);
      Destination:= FTools.DecodeSD(Sl[i],KindD);

      // In a destination, only directories can have the INT_SDMANUAL type
      // The directory doesn't necessarely needs to exist
      if (KindD = INT_SDMANUAL) then
        KindD:= INT_SDDIR;

      if (KindD = INT_SDDIR) then
        CopyFileLocal(Source,Destination) else
        CopyFileFTP(Source,Destination);

      if (DoAbort()) then
        Break;
    end;
  finally
    FreeAndNil(Sl);
  end;
end;

procedure TExecutor.CopyDirFTP(const Source, Destination: WideString);
var
  Rec: TFTPrec;
  FTP: TFTP;
begin
  Rec.Temp:= FTemp;
  Rec.AppPath:= FAppPath;
  Rec.IncludeSubDirs:= FTask.IncludeSubdirectories;
  Rec.IncludeMask:= FTask.IncludeMasks;
  Rec.ExcludeMask:= FTask.ExcludeItems;
  Rec.Slow:= FSlow;
  Rec.SpeedLimit:= FFTPSpeedLimit;
  Rec.Speed:= FFTPSpeed;
  Rec.ASCII:= FFTPASCII;
  Rec.UseAttributes:= FTask.UseAttributes;
  Rec.Separated:= FTask.SeparateBackups;
  Rec.DTFormat:= FDTFormat;
  Rec.DoNotSeparate:= FDoNotSeparateDate;
  Rec.DoNotUseSpaces:= FDoNotUseSpaces;
  Rec.BackupType:= FTask.BackupType;
  Rec.EncBufferSize:= FBufferSize;
  Rec.EncCopyTimeStamps:= FCopyTimeStamps;
  Rec.EncCopyAttributes:= FCopyAttributes;
  Rec.EncCopyNTFS:= FCopyNTFS;
  Rec.ClearAttributes:= FTask.ResetAttributes;
  Rec.DeleteEmptyFolders:= FDeleteEmptyFolders;
  Rec.AlwaysCreateDirs:= FAlwaysCreateDirs;
  Rec.EncPublicKey:= Ftask.PublicKey;
  Rec.EncMethod:= FTask.Encryption;
  Rec.EncPassPhrase:= FTask.Passphrase;
  Rec.Propagate:= FPropagate;

  FTP:= TFTP.Create(Rec);
  try
    FTP.OnAbort:= OnObjectAbort;
    FTP.OnLog:= OnObjectLog;
    FTP.OnProgress:= OnFTPProgress;
    FTP.OnFileBegin:= OnFTPFileBegin;
    FTP.OnFileEnd:= OnFTPFileEnd;
    FTP.OnFileBeginEnc:= OnEncryptionBegin;
    FTP.OnFileEndEnc:= OnEncryptionEnd;
    FTP.OnFileProgressEnc:= OnEncryptionProgressDone;
    FTP.OnNTFSPermissionsCopyEnc:= OnNTFSPermissionsCopy;
    FTP.OnDelete:= OnDeleteProgress;
    if (FTP.UploadDirectory(Source, Destination,FLastElement, false) <> INT_NOFTPFILES) then
      AddBackupResult(FTP.FFinalAdress);   // Do not encode
  finally
    FreeAndNil(FTP);
  end;
end;

procedure TExecutor.CopyDirLocal(const Source, Destination: WideString);
begin
  if (FTask.Encryption = INT_ENCNOENC) then
    CopyDirLocalNoEnc(Source, Destination) else
    CopyDirLocalEnc(Source, Destination);
end;

procedure TExecutor.CopyDirLocalEnc(const Source, Destination: WideString);
var
  Encryptor: TEncryptor;
  Par: TEncryptPar;
  Files: int64;
begin
  Par.Temp:= FTemp;
  Par.AppPath:= FAppPath;
  Par.BackupType:= FTask.BackupType;
  Par.UseAttributes:= FTask.UseAttributes;
  Par.Separated:= FTask.SeparateBackups;
  Par.DTFormat:= FDTFormat;
  Par.DoNotSeparate:= FDoNotSeparateDate;
  Par.DoNotUseSpaces:= FDoNotUseSpaces;
  Par.Slow:= FSlow;
  Par.BufferSize:= FBufferSize;
  Par.CopyTimeStamps:= FCopyTimeStamps;
  Par.CopyAttributes:= FCopyAttributes;
  Par.CopyNTFS:= FCopyNTFS;
  Par.ClearAttributes:= FTask.ResetAttributes;
  Par.DeleteEmptyFolders:= FDeleteEmptyFolders;
  Par.AlwaysCreateDirs:= FAlwaysCreateDirs;
  Par.Subdirs:= FTask.IncludeSubdirectories;
  Par.IncludeMask:= FTask.IncludeMasks;
  Par.Excludemask:= Ftask.ExcludeItems;
  Par.PublicKey:= FTask.PublicKey;
  Par.EncMethod:= FTask.Encryption;
  Par.PassPhrase:= FTask.Passphrase;
  Par.Propagate:= FPropagate;

  Encryptor:= TEncryptor.Create(Par, BOOL_ENCPRIMARY);
  try
    Encryptor.OnLog:= OnObjectLog;
    Encryptor.OnAbort:= OnObjectAbort;
    Encryptor.OnFileBegin:= OnEncryptionBegin;
    Encryptor.OnFileEnd:= OnEncryptionEnd;
    Encryptor.OnFileProgress:= OnEncryptionProgressDone;
    Encryptor.OnNTFSPermissionsCopy:= OnNTFSPermissionsCopy;
    Files:= Encryptor.EncryptDirectory(Source, Destination,FLastElement);
    if (DoAbort) then
      Exit;
    if (Files <> 0) then
      AddBackupResult(FTools.EncodeSD(INT_SDDIR, Encryptor.DestinationDirOriginal));
    Logger.Log(WideFormat(Translator.GetMessage('304'),[Source,
                Encryptor.DestinationDirOriginal, Files],FS), false, false);
  finally
    FreeAndNil(Encryptor);
  end;
end;

procedure TExecutor.CopyDirLocalNoEnc(const Source, Destination: WideString);
var
  Copier: TCopier;
  Par: TCopyPar;
  Files: int64;
begin
  Par.Temp:= FTemp;
  Par.AppPath:= FAppPath;
  Par.BackupType:= FTask.BackupType;
  Par.UseAttributes:= FTask.UseAttributes;
  Par.Separated:= FTask.SeparateBackups;
  Par.DTFormat:= FDTFormat;
  Par.DoNotSeparate:= FDoNotSeparateDate;
  Par.DoNotUseSpaces:= FDoNotUseSpaces;
  Par.UseShell:= FUseShell;
  Par.Alternative:= FAlternative;
  Par.Slow:= FSlow;
  Par.BufferSize:= FBufferSize;
  Par.CheckCRC:= FCheckCRC;
  Par.CopyTimeStamps:= FCopyTimeStamps;
  Par.CopyAttributes:= FCopyAttributes;
  Par.CopyNTFS:= FCopyNTFS;
  Par.ClearAttributes:= FTask.ResetAttributes;
  Par.DeleteEmptyFolders:= FDeleteEmptyFolders;
  Par.AlwaysCreateDirs:= FAlwaysCreateDirs;
  Par.Subdirs:= FTask.IncludeSubdirectories;
  Par.IncludeMask:= FTask.IncludeMasks;
  Par.Excludemask:= FTask.ExcludeItems;
  Par.Propagate:= FPropagate;

  Copier:= TCopier.Create(Par);
  try
    Copier.OnLog:= OnObjectLog;
    Copier.OnAbort:= OnObjectAbort;
    Copier.OnFileBegin:= OnCopyFileBegin;
    Copier.OnFileEnd:= OnCopyFileEnd;
    Copier.OnFileProgress:= OnCopyProgressDone;
    Copier.OnCRCProgress:= OnCopyCRCProgress;
    Copier.OnNTFSPermissionsCopy:= OnNTFSPermissionsCopy;
    Files:= Copier.CopyDirectory(Source, Destination, FLastElement);
    if (DoAbort) then
      Exit;
    if (Files <> 0) then
      AddBackupResult(FTools.EncodeSD(INT_SDDIR, Copier.DestinationDirOriginal));
    Logger.Log(WideFormat(Translator.GetMessage('281'),[Source,
                Copier.DestinationDirOriginal, Files],FS), false, false);
  finally
    FreeAndNil(Copier);
  end;
end;

procedure TExecutor.CopyFileFTP(const Source, Destination: WideString);
var
  Rec: TFTPrec;
  FTP: TFTP;
begin
  Rec.Temp:= FTemp;
  Rec.AppPath:= FAppPath;
  Rec.IncludeSubDirs:= FTask.IncludeSubdirectories;
  Rec.IncludeMask:= FTask.IncludeMasks;
  Rec.ExcludeMask:= FTask.ExcludeItems;
  Rec.Slow:= FSlow;
  Rec.SpeedLimit:= FFTPSpeedLimit;
  Rec.Speed:= FFTPSpeed;
  Rec.ASCII:= FFTPASCII;
  Rec.UseAttributes:= FTask.UseAttributes;
  Rec.Separated:= FTask.SeparateBackups;
  Rec.DTFormat:= FDTFormat;
  Rec.DoNotSeparate:= FDoNotSeparateDate;
  Rec.DoNotUseSpaces:= FDoNotUseSpaces;
  Rec.BackupType:= FTask.BackupType;
  Rec.EncBufferSize:= FBufferSize;
  Rec.EncCopyTimeStamps:= FCopyTimeStamps;
  Rec.EncCopyAttributes:= FCopyAttributes;
  Rec.EncCopyNTFS:= FCopyNTFS;
  Rec.ClearAttributes:= FTask.ResetAttributes;
  Rec.DeleteEmptyFolders:= FDeleteEmptyFolders;
  Rec.AlwaysCreateDirs:= FAlwaysCreateDirs;
  Rec.EncPublicKey:= Ftask.PublicKey;
  Rec.EncMethod:= FTask.Encryption;
  Rec.EncPassPhrase:= FTask.Passphrase;
  Rec.Propagate:= FPropagate;

  FTP:= TFTP.Create(Rec);
  try
    FTP.OnAbort:= OnObjectAbort;
    FTP.OnLog:= OnObjectLog;
    FTP.OnProgress:= OnFTPProgress;
    FTP.OnFileBegin:= OnFTPFileBegin;
    FTP.OnFileEnd:= OnFTPFileEnd;
    FTP.OnFileBeginEnc:= OnEncryptionBegin;
    FTP.OnFileEndEnc:= OnEncryptionEnd;
    FTP.OnFileProgressEnc:= OnEncryptionProgressDone;
    FTP.OnNTFSPermissionsCopyEnc:= OnNTFSPermissionsCopy;
    FTP.OnDelete:= OnDeleteProgress;
    if (FTP.UploadFile(Source, Destination, true, FLastElement,
                              false, false) = INT_FILETRANSFERED) then
      AddBackupResult(FTP.FFinalAdress);  // No need to encode here
  finally
    FreeAndNil(FTP);
  end;
end;

procedure TExecutor.CopyFileLocal(const Source, Destination: WideString);
begin
  if (FTask.Encryption = INT_ENCNOENC) then
    CopyFileLocalNoEnc(Source, Destination) else
    CopyFileLocalEnc(Source, Destination);
end;

procedure TExecutor.CopyFileLocalEnc(const Source, Destination: WideString);
var
  Encryptor: TEncryptor;
  Par: TEncryptPar;
begin
  Par.Temp:= FTemp;
  Par.AppPath:= FAppPath;
  Par.BackupType:= FTask.BackupType;
  Par.UseAttributes:= FTask.UseAttributes;
  Par.Separated:= FTask.SeparateBackups;
  Par.DTFormat:= FDTFormat;
  Par.DoNotSeparate:= FDoNotSeparateDate;
  Par.DoNotUseSpaces:= FDoNotUseSpaces;
  Par.Slow:= FSlow;
  Par.BufferSize:= FBufferSize;
  Par.CopyTimeStamps:= FCopyTimeStamps;
  Par.CopyAttributes:= FCopyAttributes;
  Par.CopyNTFS:= FCopyNTFS;
  Par.ClearAttributes:= FTask.ResetAttributes;
  Par.DeleteEmptyFolders:= FDeleteEmptyFolders;
  Par.AlwaysCreateDirs:= FAlwaysCreateDirs;
  Par.Subdirs:= FTask.IncludeSubdirectories;
  Par.IncludeMask:= FTask.IncludeMasks;
  Par.Excludemask:= Ftask.ExcludeItems;
  Par.PublicKey:= FTask.PublicKey;
  Par.EncMethod:= FTask.Encryption;
  Par.PassPhrase:= FTask.Passphrase;
  Par.Propagate:= FPropagate;

  Encryptor:= TEncryptor.Create(Par, BOOL_ENCPRIMARY);
  try
    Encryptor.OnLog:= OnObjectLog;
    Encryptor.OnAbort:= OnObjectAbort;
    Encryptor.OnFileBegin:= OnEncryptionBegin;
    Encryptor.OnFileEnd:= OnEncryptionEnd;
    Encryptor.OnFileProgress:= OnEncryptionProgressDone;
    Encryptor.OnNTFSPermissionsCopy:= OnNTFSPermissionsCopy;
    if Encryptor.EncryptFile(Source, Destination, true, FLastElement)= INT_FILESUCCESFULLYENCRYPTED then
      AddBackupResult(FTools.EncodeSD(INT_SDFILE, Encryptor.DestinationOriginal));
  finally
    FreeAndNil(Encryptor);
  end;
end;

procedure TExecutor.CopyFileLocalNoEnc(const Source, Destination: WideString);
var
  Copier: TCopier;
  Par: TCopyPar;
begin
  Par.Temp:= FTemp;
  Par.AppPath:= FAppPath;
  Par.BackupType:= FTask.BackupType;
  Par.UseAttributes:= FTask.UseAttributes;
  Par.Separated:= FTask.SeparateBackups;
  Par.DTFormat:= FDTFormat;
  Par.DoNotSeparate:= FDoNotSeparateDate;
  Par.DoNotUseSpaces:= FDoNotUseSpaces;
  Par.UseShell:= FUseShell;
  Par.Alternative:= FAlternative;
  Par.Slow:= FSlow;
  Par.BufferSize:= FBufferSize;
  Par.CheckCRC:= FCheckCRC;
  Par.CopyTimeStamps:= FCopyTimeStamps;
  Par.CopyAttributes:= FCopyAttributes;
  Par.CopyNTFS:= FCopyNTFS;
  Par.ClearAttributes:= FTask.ResetAttributes;
  Par.DeleteEmptyFolders:= FDeleteEmptyFolders;
  Par.AlwaysCreateDirs:= FAlwaysCreateDirs;
  Par.Subdirs:= FTask.IncludeSubdirectories;
  Par.IncludeMask:= FTask.IncludeMasks;
  Par.Excludemask:= Ftask.ExcludeItems;
  Par.Propagate:= FPropagate;

  Copier:= TCopier.Create(Par);
  try
    Copier.OnLog:= OnObjectLog;
    Copier.OnAbort:= OnObjectAbort;
    Copier.OnFileBegin:= OnCopyFileBegin;
    Copier.OnFileEnd:= OnCopyFileEnd;
    Copier.OnFileProgress:= OnCopyProgressDone;
    Copier.OnCRCProgress:= OnCopyCRCProgress;
    Copier.OnNTFSPermissionsCopy:= OnNTFSPermissionsCopy;
    if Copier.CopyFile(Source, Destination, true, FLastElement)= INT_FILESUCCESFULLYCOPIED then
      AddBackupResult(FTools.EncodeSD(INT_SDFILE, Copier.DestinationOriginal));
  finally
    FreeAndNil(Copier);
  end;
end;

function TExecutor.CountFiles(const ATask: TTask): int64;
var
  i: integer;
  Sl, Sr: TTntStringList;
  Source: WideString;
  Kind: integer;
  ASize: int64;
begin
  Result:= 0;

  if (ATask.Disabled) then
    Exit;

  Sl:= TTntStringList.Create();
  Sr:= TTntStringList.Create();
  try
    Sl.CommaText:= ATask.Source;
    Sr.CommaText:= ATask.Destination;
    for i:= 0 to Sl.Count- 1 do
    begin
      Source:= FTools.DecodeSD(Sl[i], Kind);
      if (Kind <> INT_SDFTP) then
      begin
        Result:= Result + CobCountFilesW(Source, ATask.ExcludeItems,ATask.IncludeMasks,
                  ATask.IncludeSubdirectories, ASize);
        if (DoAbort) then
          Break;
      end;
    end;

    // This is the number of non - ftp files inthe source.
    // we must multiply this value by the
    // number of destinations

    Result:= Result * Sr.Count;
  finally
    FreeAndNil(Sr);
    FreeAndNil(Sl);
  end;
end;

constructor TExecutor.Create(const AppPath: WideString;
                      const IsService:boolean; const Sec: PSecurityAttributes);
var
  SecLibraryName: WideString;
begin
  inherited Create(true);
  Randomize();
  FSec:= Sec;
  FAppPath:= AppPath;
  FAbort:= false;
  FIsService:= IsService;
  FFirstBackupTerminated:= true;
  GetLocaleFormatSettings(LOCALE_SYSTEM_DEFAULT, FS);
  LoadLocalSettings();
  FUsePipes:= Settings.GetUsePipes();   // this should not be changed
  FTask:= TTask.Create();
  FMsg:= TTntStringList.Create();
  FResultFiles:= TList.Create();
  FWriter:= TTntStringList.Create();
  FTools:= TCobTools.Create();
  CreateIPCSender(Sec);
  SecLibraryName:= FAppPath + WS_COBNTSEC;
  FNTFSHandle:= LoadLibraryW(PWideChar(SecLibraryName));
  FHistoryList:= TBackupList.Create();

  if (FNTFSHandle <> 0) then
  begin
    Logger.Log(Translator.GetMessage('260'),false,true);
    FNTSecCreate:= GetProcAddress(FNTFSHandle, S_COPYNTCREATE);
    if (@FNTSecCreate <> nil) then
    begin
      FNTSecCreate();
      Logger.Log(Translator.GetMessage('263'),false, true);
      FCopyNTFSFunction:= GetProcAddress(FNTFSHandle, S_COPYNTFSNAME);
      if (@FCopyNTFSFunction <> nil) then
        Logger.Log(Translator.GetMessage('261'),false,true) else
        Logger.Log(Translator.GetMessage('262'),true, false);
    end else
      Logger.Log(Translator.GetMessage('264'),true, false);

    
  end else
  Logger.Log(Translator.GetMessage('259'),true, false);
end;

procedure TExecutor.CreateIPCSender(const Sec: PSecurityAttributes);
var
  FName, MName, PName: WideString;
begin
  // Creates the IPC that will send the info about the current operation
  if (FUsePipes) then
  begin
    PName:= WideFormat(WS_IENGINETOINTPIPE,[WS_PROGRAMNAMESHORTNOISPACES],FS);
    FPipeClient:=TCobPipeClientW.Create(PName,FSec);
    FPipeClient.Connect();
  end else
  begin
    if (CobIs2000orBetterW) then
      begin
        FName:= WideFormat(WS_MMFCURRENTOPNAME,[WS_PROGRAMNAMELONG],FS);
        MName:= WideFormat(WS_MMFMUTEXCURRENTOPNAME,[WS_PROGRAMNAMELONG],FS);
      end else
      begin
        FName:= WideFormat(WS_MMFCURRENTOPNAMEOLD,[WS_PROGRAMNAMELONG],FS);
        MName:= WideFormat(WS_MMFMUTEXCURRENTOPNAMEOLD,[WS_PROGRAMNAMELONG],FS);
      end;

    FIPCMutex:= CreateMutexW(sec, False, PWideChar(MName));

    FIPCHandle := CreateFileMappingW(INVALID_HANDLE_VALUE,
                                      sec,
                                      PAGE_READWRITE,
                                      INT_NIL,
                                      INT_MAXFILESIZE,
                                      PWideChar(FName));

    FSenderPointer := MapViewOfFile(FIPCHandle, FILE_MAP_ALL_ACCESS, 0, 0, 0);
  end;
end;

procedure TExecutor.DestroyIPCSender();
begin
  //Destroy the IPC
  if (FUsePipes) then
  begin
    if (FPipeClient <> nil) then
    begin
      FPipeClient.Disconnect();
      FreeAndNil(FPipeClient);
    end;
  end else
  begin
    if (FSenderPointer <> nil) then
    begin
      UnmapViewOfFile(FSenderPointer);
      FSenderPointer:= nil;
    end;

    if (FIPCHandle <> 0) then
      begin
        CloseHandle(FIPCHandle);
        FIPCHandle:= 0;
      end;

    if (FIPCMutex <> 0) then
      begin
        CloseHandle(FIPCMutex);
        FIPCMutex:= 0;
      end;
  end;
end;

procedure TExecutor.DeleteBackup(const Backup: TBackup);
var
  Destination: WideString;
  Kind: integer;
begin
  Destination:= FTools.DecodeSD(Backup.FDestination, Kind);
  if (Kind = INT_SDFTP) then
    DeleteFTP(Backup) else
    DeleteLocal(Backup);
end;

procedure TExecutor.DeleteChildrenBackup(const Parents: TTntStringList);
var
  j, k, Count: integer;
  ABackup: TBackup;
  IsIn: boolean;
begin
  if Parents.Count = 0 then
    Exit;

  Count:= FHistoryList.GetCount();

  for j := Count- 1 downto 0  do
  begin
    FHistoryList.GetBackupPointerIndex(j, ABackup);

    if ABackup = nil then
      Continue;

    if ABackup.FParked then
      Continue;

    if ABackup.FBackupType = INT_BUFULL then
      Continue;

    IsIn := false;
    for k := 0 to Parents.Count - 1 do
    begin
      if ABackup.FParentID = Parents[k] then
      begin
        IsIn := true;
        Break;
      end;
    end;

    if IsIN then
    begin
      Logger.Log(WideFormat(Translator.GetMessage('270'),
        [ABackup.FParentID, FTask.FullCopiesToKeep], FS), false, false);

      DeleteBackup(ABackup);

      FHistoryList.DeleteBackupIndex(j);
    end;

    if DoAbort() then
      Break;
  end;    
end;

procedure TExecutor.DeleteFTP(const Backup: TBackup);
var
  Rec: TFTPrec;
  FTP: TFTP;
  Destination: WideString;
  Kind: integer;
begin
  Destination:= FTools.DecodeSD(Backup.FDestination, Kind);
  if (not Kind = INT_SDFTP) then
  begin
    Logger.Log(WideFormat(Translator.GetMessage('431'),[Destination],FS), true, false);
    Exit;
  end;

  Rec.Temp:= FTemp;
  Rec.AppPath:= FAppPath;
  Rec.IncludeSubDirs:= FTask.IncludeSubdirectories;
  Rec.IncludeMask:= FTask.IncludeMasks;
  Rec.ExcludeMask:= FTask.ExcludeItems;
  Rec.Slow:= FSlow;
  Rec.SpeedLimit:= FFTPSpeedLimit;
  Rec.Speed:= FFTPSpeed;
  Rec.ASCII:= FFTPASCII;
  Rec.UseAttributes:= FTask.UseAttributes;
  Rec.Separated:= FTask.SeparateBackups;
  Rec.DTFormat:= FDTFormat;
  Rec.DoNotSeparate:= FDoNotSeparateDate;
  Rec.DoNotUseSpaces:= FDoNotUseSpaces;
  Rec.BackupType:= FTask.BackupType;
  Rec.EncBufferSize:= FBufferSize;
  Rec.EncCopyTimeStamps:= FCopyTimeStamps;
  Rec.EncCopyAttributes:= FCopyAttributes;
  Rec.EncCopyNTFS:= FCopyNTFS;
  Rec.ClearAttributes:= FTask.ResetAttributes;
  Rec.DeleteEmptyFolders:= FDeleteEmptyFolders;
  Rec.AlwaysCreateDirs:= FAlwaysCreateDirs;
  Rec.EncPublicKey:= Ftask.PublicKey;
  Rec.EncMethod:= FTask.Encryption;
  Rec.EncPassPhrase:= FTask.Passphrase;
  Rec.Propagate:= FPropagate;

  FTP:= TFTP.Create(Rec);
  try
    FTP.OnAbort:= OnObjectAbort;
    FTP.OnLog:= OnObjectLog;
    FTP.OnProgress:= OnFTPProgress;
    FTP.OnFileBegin:= OnFTPFileBegin;
    FTP.OnFileEnd:= OnFTPFileEnd;
    FTP.OnFileBeginEnc:= OnEncryptionBegin;
    FTP.OnFileEndEnc:= OnEncryptionEnd;
    FTP.OnFileProgressEnc:= OnEncryptionProgressDone;
    FTP.OnNTFSPermissionsCopyEnc:= OnNTFSPermissionsCopy;
    FTP.OnDelete:= OnDeleteProgress;
    FTP.DeleteItems(Destination, Backup.FFiles);
  finally
    FreeAndNil(FTP);
  end;
end;

procedure TExecutor.DeleteLocal(const Backup: TBackup);
var
  Sl: TTntStringList;
  i, Kind: integer;
  Source, DirtySource: WideString;
begin
  Sl:= TTntStringList.Create();
  try
    Sl.CommaText:= Backup.FFiles;
    for i:= 0 to Sl.Count - 1 do
    begin
      Source:= FTools.DecodeSD(Sl[i], Kind);
      DirtySource:= FTools.NormalizeFileName(Source);
      OnDeleteProgress(Source);
      if (Kind = INT_SDFILE) then
      begin
        if (FTools.DeleteFileWSpecial(DirtySource)) then
          Logger.Log(WideFormat(Translator.GetMessage('271'),[Source],FS), false, false) else
          Logger.Log(WideFormat(Translator.GetMessage('428'),[Source],FS), true, false);
      end else
      begin
        if (FTools.DeleteDirectoryW(DirtySource)) then
          Logger.Log(WideFormat(Translator.GetMessage('429'),[Source],FS), false, false) else
          Logger.Log(WideFormat(Translator.GetMessage('430'),[Source],FS), true, false);
      end;
    end;
  finally
    FreeAndNil(Sl);
  end;
end;

procedure TExecutor.DeleteOldBackups();
var
  i: integer;
  FullCount, FullParked, TotalCount, CopiesToDelete: integer;
  CurrentFullID: WideString;
  FullBackups: TTntStringList;
  Backup: TBackup;
begin
  if (FTask.SeparateBackups = false) or (FTask.FullCopiesToKeep = 0) then
    Exit;

  // Check how many FULL BACKUP copies there are in the list
  // This version will delete the full copies and it's associated backups
  FullCount := 0;
  FullParked := 0;
  CurrentFullID := WS_NIL;
  TotalCount := FHistoryList.GetCount();
  FullBackups := TTntStringList.Create();
  try
    for i := 0 to TotalCount - 1 do
    begin
      FHistoryList.GetBackupPointerIndex(i, Backup);
      if Backup.FBackupType = INT_BUFULL then
      begin
        Inc(FullCount);
        if Backup.FParked then
          Inc(FullParked);
      end;
    end;

    CopiesToDelete := (FullCount - FullParked) - FTask.FullCopiesToKeep;

    if CopiesToDelete < 1 then
      Exit;

    //Now CAREFULLY delete all the redundant FULL backups

    for i := 0 to TotalCount- 1 do
    begin

      FHistoryList.GetBackupPointerIndex(i, Backup);

      if Backup = nil then
        Continue;

      if Backup.FParked then
        Continue;

      if CopiesToDelete < 1 then
        Break;

      if Backup.FBackupType = INT_BUFULL then
      begin
        CurrentFullID := Backup.FBackupID;

        Logger.Log(WideFormat(Translator.GetMessage('269'),
          [Backup.FBackupID, FTask.FullCopiesToKeep], FS), false, false);

        DeleteBackup(Backup);

        // Add the ID of the backup to delete their children later
        FullBackups.Add(CurrentFullID);

        Dec(CopiesToDelete);
      end; //if

      if DoAbort() then
        Break;

    end; // for

    // moved out because it is not a good idea to delete the backup in the loop
    for i:=0 to FullBackups.Count - 1 do
      FHistoryList.DeleteBackup(FullBackups[i]);

    if DoAbort() then
      Exit;

    DeleteChildrenBackup(FullBackups);

  finally
    FreeAndNil(FullBackups);
  end;
end;

destructor TExecutor.Destroy();
begin
  FreeAndNil(FHistoryList);
  if (FNTFSHandle <> 0) then
  begin
    FNTSecDestroy:= GetProcAddress(FNTFSHandle, S_COPYNTDESTROY);
    if (@FNTSecDestroy <> nil) and (@FNTSecCreate <> nil) then
    begin
      FNTSecDestroy();
      Logger.Log(Translator.GetMessage('265'),false, true);
    end else
      Logger.Log(Translator.GetMessage('266'),true, false);
    FreeLibrary(FNTFSHandle);
  end;
  FNTFSHandle:= 0;
  DestroyIPCSender();
  FreeAndNil(FTools);
  FreeAndNil(FWriter);
  ClearResultFiles();
  FreeAndNil(FResultFiles);
  FreeAndNil(FMsg);
  FreeAndNil(FTask);
  inherited Destroy();
end;

procedure TExecutor.EncryptZipFiles(const Files: WideString);
var
  Encryptor: TEncryptor;
  Par: TEncryptPar;
  ZipResult: TTntStringList;
  i: integer;
begin
  Par.Temp:= FTemp;
  Par.AppPath:= FAppPath;
  Par.BackupType:= FTask.BackupType;
  Par.UseAttributes:= FTask.UseAttributes;
  Par.Separated:= FTask.SeparateBackups;
  Par.DTFormat:= FDTFormat;
  Par.DoNotSeparate:= FDoNotSeparateDate;
  Par.DoNotUseSpaces:= FDoNotUseSpaces;
  Par.Slow:= FSlow;
  Par.BufferSize:= FBufferSize;
  Par.CopyTimeStamps:= FCopyTimeStamps;
  Par.CopyAttributes:= FCopyAttributes;
  Par.CopyNTFS:= FCopyNTFS;
  Par.ClearAttributes:= FTask.ResetAttributes;
  Par.DeleteEmptyFolders:= FDeleteEmptyFolders;
  Par.AlwaysCreateDirs:= FAlwaysCreateDirs;
  Par.Subdirs:= FTask.IncludeSubdirectories;
  Par.IncludeMask:= FTask.IncludeMasks;
  Par.Excludemask:= Ftask.ExcludeItems;
  Par.PublicKey:= FTask.PublicKey;
  Par.EncMethod:= FTask.Encryption;
  Par.PassPhrase:= FTask.Passphrase;
  Par.Propagate:= FPropagate;

  ZipResult:= TTntStringList.Create();
  Encryptor:= TEncryptor.Create(Par, BOOL_ENCSECUNDARY);
  try
    ZipResult.CommaText:= Files;
    Encryptor.OnLog:= OnObjectLog;
    Encryptor.OnAbort:= OnObjectAbort;
    Encryptor.OnFileBegin:= OnEncryptionBegin;
    Encryptor.OnFileEnd:= OnEncryptionEnd;
    Encryptor.OnFileProgress:= OnEncryptionProgressDone;
    Encryptor.OnNTFSPermissionsCopy:= OnNTFSPermissionsCopy;
    for i:=0 to ZipResult.Count-1 do
    begin
      if Encryptor.EncryptFile(ZipResult[i], WideExtractFilePath(ZipResult[i]), true, false)= INT_FILESUCCESFULLYENCRYPTED then
        AddBackupResult(FTools.EncodeSD(INT_SDFILE, Encryptor.DestinationOriginal));
      if (WideFileExists(ZipResult[i])) then
        DeleteFileW(PWideChar(ZipResult[i]));
    end;
  finally
    FreeAndNil(Encryptor);
    FreeAndNil(ZipResult);
  end;
end;

procedure TExecutor.EvClose(const ACaption: WideString; const Kill,
  Before: boolean);
var
  Event, Error: WideString;
  UI: boolean;
  Result: cardinal;
begin
  /// if the program is running as a service, an executed program will be
  ///  invisible for the user, so the interface should run it instead.

  Event:= WideFormat(Translator.GetMessage('199'),[ACaption], FS);
  if (Before) then
    Logger.Log(WideFormat(Translator.GetMessage('176'),[Event],FS),false, false) else
    Logger.Log(WideFormat(Translator.GetMessage('177'),[Event],FS),false, false);

  UI:= false;
  if (FIsService and FUseVisibleDesktop) then
    UI:= IsUIPresent();

  if (UI) then
  begin
    // This will be passed to the UI
    FParam1W:= ACaption;
    FParam2W:= CobBoolToStrW(Kill);
    SendStatus(INT_OPCLOSE, false);
  end else
  begin
    Result:= FTools.CloseAWindowW(ACaption,Kill);
    if (Result = INT_CW_CLOSED) then
      Logger.Log(WideFormat(Translator.GetMessage('200'),[ACaption],FS),false,false) else
      begin
        if (Result = INT_CW_NOFOUND) then
          Error:= Translator.GetMessage('202') else
          Error:= Translator.GetMessage('203');
        Logger.Log(WideFormat(Translator.GetMessage('201'),[ACaption, Error],FS),true,false);
        Inc(FErrors);
      end;
  end;
end;

procedure TExecutor.EvDoPause(const Pause: integer; const Before: boolean);
var
  APause: integer;
  Event: WideString;
begin
  if (Pause = 0) then
    APause:= Random(60) else
    APause:= Pause;

  Event:= WideFormat(Translator.GetMessage('178'),[APause], FS);

  if (Before) then
    Logger.Log(WideFormat(Translator.GetMessage('176'),[Event],FS),false, false) else
    Logger.Log(WideFormat(Translator.GetMessage('177'),[Event],FS),false, false);

  Sleep(APause * INT_MS);
end;

procedure TExecutor.EvExecute(const FileName, Param: WideString; const Before: boolean);
var
  UI: boolean;
  Result: cardinal;
  Event: WideString;
begin
  /// if the program is running as a service, an executed program will be
  ///  invisible for the user, so the interface should run it instead.

  Event:= WideFormat(Translator.GetMessage('179'),[FileName], FS);
  if (Before) then
    Logger.Log(WideFormat(Translator.GetMessage('176'),[Event],FS),false, false) else
    Logger.Log(WideFormat(Translator.GetMessage('177'),[Event],FS),false, false);

  UI:= false;
  if (FIsService and FUseVisibleDesktop) then
    UI:= IsUIPresent();

  if (UI) then
  begin
    // This will be passed to the UI
    FParam1W:= FileName;
    FParam2W:= Param;
    SendStatus(INT_OPEXECUTE, false);
  end else
  begin
    Result:= FTools.ExecuteW(FileName,Param);
    if (Result > 32) then
      Logger.Log(WideFormat(Translator.GetMessage('180'),[FileName],FS),false,false) else
      begin
        Logger.Log(WideFormat(Translator.GetMessage('181'),[FileName,
                                      Translator.GetShellError(Result)],FS),true,false);
        Inc(FErrors);
      end;
  end;
end;

procedure TExecutor.EvExecuteAndWait(const FileName, Param: WideString;
  const Before: boolean);
var
  UI: boolean;
  Result: cardinal;
  Event: WideString;
  UIResult: cardinal;
begin
  /// if the program is running as a service, an executed program will be
  ///  invisible for the user, so the interface should run it instead.

  Event:= WideFormat(Translator.GetMessage('198'),[FileName], FS);
  if (Before) then
    Logger.Log(WideFormat(Translator.GetMessage('176'),[Event],FS),false, false) else
    Logger.Log(WideFormat(Translator.GetMessage('177'),[Event],FS),false, false);

  UI:= false;
  if (FIsService and FUseVisibleDesktop) then
    UI:= IsUIPresent();

  if (UI) then
  begin
    // This will be passed to the UI
    FParam1W:= FileName;
    FParam2W:= Param;
    SendStatus(INT_OPEXECUTEANDWAIT, false);
    UIResult:= INT_UINORESULT;
    ClearUIResponseFlag();
    repeat
      if (DoAbort()) then
        Break;

      UIResult:= GetUIResponse();

      Sleep(INT_UIRESPONSESLEEP);
      
    until (UIResult <> INT_UINORESULT);
  end else
  begin                         
    Result:= FTools.ExecuteAndWaitW(FileName,Param);
    if Result = 0 then
      Logger.Log(WideFormat(Translator.GetMessage('183'),[FileName],FS),false,false) else
      begin
        Logger.Log(WideFormat(Translator.GetMessage('184'),[FileName,
                                      CobSysErrorMessageW(Result)],FS),true,false);
        Inc(FErrors);
      end;
  end;
end;

procedure TExecutor.EvRestart(const Restart, Kill, Before: boolean);
var
  Result: cardinal;
  Msg: WideString;
begin
  if (Restart) then
    Msg:= Translator.GetMessage('214') else
    Msg:= Translator.GetMessage('215');
  if (Before) then
    Logger.Log(WideFormat(Translator.GetMessage('176'),[Msg],FS),false, false) else
    Logger.Log(WideFormat(Translator.GetMessage('177'),[Msg],FS),false, false);

  Result:= FTools.RestartShutdownW(Restart, Kill);

  if (Result <> 0) then
  begin
    if (Restart) then
      Msg:= Translator.GetMessage('216') else
      Msg:= Translator.GetMessage('217');
    Logger.Log(WideFormat(Msg,[CobSysErrorMessageW(Result)],FS),true, false);
    Inc(FErrors);
  end;
end;

procedure TExecutor.EvStartService(const ServiceName, Param: WideString;
          const Before: boolean);
var
  Result: cardinal;
  Event, Error, LibraryName: WideString;
begin
  LibraryName:= FAppPath + WS_COBNTW;

  Event:= WideFormat(Translator.GetMessage('204'),[ServiceName], FS);
  if (Before) then
    Logger.Log(WideFormat(Translator.GetMessage('176'),[Event],FS),false, false) else
    Logger.Log(WideFormat(Translator.GetMessage('177'),[Event],FS),false, false);

  Result:= FTools.StartServiceW(LibraryName, ServiceName, Param);
  if (Result = INT_LIBOK) then
    Logger.Log(WideFormat(Translator.GetMessage('205'),[ServiceName],FS), false, false) else
    begin
      case Result of
        INT_LIBCOULDNOTLOAD: Error:= Translator.GetMessage('207');
        INT_LIBNOPROCEDURE: Error:= Translator.GetMessage('208');
        INT_LIBOTHERERROR: Error:= Translator.GetMessage('209');
        else
          Error:= CobSysErrorMessageW(Result);
      end;
      Logger.Log(WideFormat(Translator.GetMessage('206'),[ServiceName, Error],FS), true, false);
      Inc(FErrors);
    end;
end;

procedure TExecutor.EvStopService(const ServiceName: WideString;
  const Before: boolean);
var
  Result: cardinal;
  Event, Error, LibraryName: WideString;
begin
  LibraryName:= FAppPath + WS_COBNTW;

  Event:= WideFormat(Translator.GetMessage('210'),[ServiceName], FS);
  if (Before) then
    Logger.Log(WideFormat(Translator.GetMessage('176'),[Event],FS),false, false) else
    Logger.Log(WideFormat(Translator.GetMessage('177'),[Event],FS),false, false);

  Result:= FTools.StopService(LibraryName, ServiceName);
  if (Result = INT_LIBOK) then
    Logger.Log(WideFormat(Translator.GetMessage('211'),[ServiceName],FS), false, false) else
    begin
      case Result of
        INT_LIBCOULDNOTLOAD: Error:= Translator.GetMessage('207');
        INT_LIBNOPROCEDURE: Error:= Translator.GetMessage('208');
        INT_LIBOTHERERROR: Error:= Translator.GetMessage('209');
        else
          Error:= CobSysErrorMessageW(Result);
      end;
      Logger.Log(WideFormat(Translator.GetMessage('213'),[ServiceName, Error],FS), true, false);
      Inc(FErrors);
    end;
end;

procedure TExecutor.Execute();
var
  bu: boolean;
begin
  SetInitialValues();
  SendStatus(INT_OPIDLE);

  while not Terminated do
  begin
    if (NeedToReload()) then
      LoadLocalSettings();

    bu:= ExtractBackup();

    if (bu) then
      Backup();

    if (DoAbort()) then
    begin
      FAbort:= false; // Restore the flag
      SetInitialValues();
      ClearBUList();
      Logger.Log(Translator.GetMessage('170'), false, false);
      SendStatus(INT_OPIDLE);
    end;

    Sleep(INT_EXECUTORSLEEP);
  end;
end;

procedure TExecutor.ExecuteBackup();
begin
  // This is the main backup without events and impersonation
  CheckBackupType();

  if (FTask.BackupType <> INT_BUDUMMY) then
    DoBackup();
    
end;

procedure TExecutor.ExecuteBeforeAfterEvents(const Before: boolean);
var
  BAString: WideString;
  Sl: TTntStringList;
  i: integer;
begin
  if (Before = BOOL_EV_BEFORE) then
  begin
    BAString:= FTask.BeforeEvents;
    if (BAString = WS_NIL) then
      Exit;
    Logger.Log(Translator.GetMessage('174'),false,false);
  end else
  begin
    BAString:= FTask.AfterEvents;
    if (BAString = WS_NIL) then
      Exit;
    Logger.Log(Translator.GetMessage('175'),false,false);
  end;

  Sl:= TTntStringList.Create();
  try
    Sl.CommaText:= FTools.ReplaceTemplate(BAString, FTask.Name); 
    for i:=0 to Sl.Count-1 do
    begin
      ExecuteEvent(Sl[i], Before);

      if (DoAbort) then
        Break;
    end;
  finally
    FreeAndNil(Sl);
  end;
end;

procedure TExecutor.ExecuteEvent(const Event: WideString;
  const Before: boolean);
var
  Sl: TTntStringList;
begin
  Sl:= TTntStringList.Create();
  try
    Sl.CommaText:= Event;
    if (Sl.Count = INT_EVCOUNT) then
    begin
      if (Sl[0] = WS_EVPAUSE) then
      begin
        EvDoPause(CobStrToIntW(Sl[1], INT_NIL), Before);
        Exit;
      end;

      if (Sl[0] = WS_EVEXECUTE) then
      begin
        EvExecute(Sl[1], Sl[2],Before);
        Exit;
      end;

      if (Sl[0] = WS_EVEXECUTEANDWAIT) then
      begin
        EvExecuteAndWait(Sl[1], Sl[2],Before);

        Exit;
      end;

      if (Sl[0] = WS_EVCLOSE) then
      begin
        EvClose(Sl[1], CobStrToBoolW(Sl[2]) ,Before);
        Exit;
      end;

      if (Sl[0] = WS_EVSTARTSERVICE) then
      begin
        EvStartService(Sl[1], Sl[2] ,Before);
        Exit;
      end;

      if (Sl[0] = WS_EVSTOPSERVICE) then
      begin
        EvStopService(Sl[1],Before);
        Exit;
      end;

      if (Sl[0] = WS_EVRESTART) then
      begin
        EvRestart(true, CobStrToBoolW(Sl[1]),Before);
        Exit;
      end;

      if (Sl[0] = WS_EVSHUTDOWN) then
      begin
        EvRestart(false, CobStrToBoolW(Sl[1]),Before);
        Exit;
      end;
    end;
  finally
    FreeAndNil(Sl);
  end;
end;

function TExecutor.ExtractBackup(): boolean;
var
  ATask: TTask;
  i: integer;
begin
  with BackupQueue.LockList() do
  try
    if (Count > 0) then  // There are tasks waiting
    begin
      Result:= true;
      if (FTotalTasks = 0) then // This is a NEW backup
      begin
        SetInitialValues();
        FTotalTasks := Count;
        // The total percent will be calculate
        // by dividing FCurrentFileCount/FTotalFiles
        // so start a thread and count the total number
        // of files in the whole list
        // if FCountFiles= false then the total percent
        // will be calculated as
        // FCurrentTaskCount/FTotalTasks

        for i:=0 to Count - 1 do
        begin
          ATask:= Items[i];
          FTotalFiles:= FTotalFiles + CountFiles(ATask);
          if (DoAbort()) then
            Break;
        end;

      end else
      begin
        // The current backup continues
        // check if new tasks have arrived to the queue
        // I do NOT re-calculate the file count
        if Count + FCurrentTaskCount > FTotalTasks then
          FTotalTasks := Count + FCurrentTaskCount;

        // here I may add some code to recalculate the files but
        // it will be difficult to synchronize the whole thing

      end;
    end else
    begin
      Result:= false;
      QueueNoItems();
    end;
  finally
    BackupQueue.UnlockList();
  end;
end;

function TExecutor.GetNextBackupTime(const dt: TDateTime): TDateTime;
var
  OfToday, DaysOfThisMonth: word;
  Sl: TTntStringList;
  j: integer;
  //****************************************************************************
  function FoundValue(AValue: integer): boolean;
  var
    i, Value: integer;
  begin
    Result := false;
    for i := 0 to Sl.Count - 1 do
    begin
      Value := CobStrToIntW(Sl[i], -1);
      if Value = AValue then
      begin
        Result := true;
        Exit;
      end;
    end;
  end;
  //****************************************************************************
  function GetDateYearly(ADate: TDateTime; Month,Year: word ): TDateTime;
  var
    i, Value: integer;
    y,m,d,h,mm,s,ms: word;
    TheDate: TDateTime;
  begin
    Result:= 0.0;
    DecodeDateTime(FTask.DateTime,y,m,d,h,mm,s,ms);
    for i:= 0 to Sl.Count-1 do
    begin
      Value:= CobStrToIntW(Sl[i], -1);
      TheDate:=EncodeDateTime(Year, Month, Value, h, mm, s, ms);
      if (ADate < TheDate) then
      begin
        Result:= TheDate;
        Break;
      end;
    end;
  end;
  //****************************************************************************
begin
  Result := 00;

  case FTask.ScheduleType of
    INT_SCDAILY:
      begin
        //Daily
        Result := dt + 1;
      end;
    INT_SCWEEKLY:
      begin
        //Weekly
        Sl := TTntStringList.Create();
        try
          Sl.CommaText := FTask.DayWeek;
          OfToday := DayOfTheWeek(dt);
          for j := 1 to 7 do
          begin
            inc(OfToday);
            if OfToday > 7 then
              OfToday := 1;
            if FoundValue(OfToday) then
              Break;
          end;
          Result := dt + j;
        finally
          FreeAndNil(Sl);
        end;
      end;
    INT_SCMONTHLY:
      begin
        //Monthly
        Sl := TTntStringList.Create();
        try
          Sl.CommaText := FTask.DayMonth;
          OfToday := DayOfTheMonth(dt);
          DaysOfThisMonth := DaysInMonth(dt);
          for j := 1 to DaysOfThisMonth do
          begin
            inc(OfToday);
            if OfToday > DaysOfThisMonth then
              OfToday := 1;
            if FoundValue(OfToday) then
              Break;
          end;
          Result := dt + j;
        finally
          FreeAndNil(Sl);
        end;
      end;
    INT_SCYEARLY:
      begin
        Sl:= TTntStringList.Create();
        try
          Sl.CommaText:= FTask.DayMonth;
          Result:= GetDateYearly(dt, FTask.Month + 1 ,YearOf(FTask.DateTime));
          if (Result= 0) then
            Result:= GetDateYearly(dt,FTask.Month + 1 ,YearOf(FTask.DateTime) +1);
        finally
          FreeAndNil(Sl);
        end;
      end
  else
    //do nothing
  end;
end;


function TExecutor.GetUIResponse(): cardinal;
begin
  CS_UIResponse.Enter();
  try
    Result:= Flag_UI_Response;
    if (Result <> INT_UINORESULT) then
      Flag_UI_Response:= INT_UINORESULT;
  finally
    CS_UIResponse.Leave();
  end;
end;

function TExecutor.Impersonate(): boolean;
var
  Error: cardinal;
begin
  Result:= false;
  if (LogonUserW(PWideChar(FTask.ImpersonateID),
                 PWideChar(FTask.ImpersonateDomain),
                 PWideChar(FTask.ImpersonatePassword),
                 LOGON32_LOGON_INTERACTIVE,
                 LOGON32_PROVIDER_DEFAULT,
                 FToken)) then
    begin
       Logger.Log(WideFormat(Translator.GetMessage('220'),[FTask.ImpersonateID,
                  FTask.ImpersonateDomain],FS),false, false);
      if (ImpersonateLoggedOnUser(FToken)) then
      begin
        Result:= true;
        Logger.Log(WideFormat(Translator.GetMessage('221'),[FTask.ImpersonateID],
                    FS),false, false);
      end else
      begin
        Error:= Windows.GetLastError();
        Logger.Log(WideFormat(Translator.GetMessage('222'),[FTask.ImpersonateID,
                  CobSysErrorMessageW(Error)],FS), true , false);
      end;
    end else
    begin
      FToken:= 0;
      Error:= Windows.GetLastError();
      Logger.Log(WideFormat(Translator.GetMessage('219'),[FTask.ImpersonateID,
                  FTask.ImpersonateDomain, CobSysErrorMessageW(Error)],FS),true, false);
    end;
end;

function TExecutor.IsUIPresent(): boolean;
var
  MN: WideString;
  AHandle: THandle;
begin
  // is the ui running? Check the mutex
  Result:= false;

  if (CobIs2000orBetterW()) then
    MN:= WideFormat(WS_UIMUTEXFLAG,[WS_PROGRAMNAMELONG],FS) else
    MN:= WideFormat(WS_UIMUTEXFLAGOLD,[WS_PROGRAMNAMELONG],FS);

  AHandle:= CreateMutexW(FSec, false, PWideChar(MN));

  if (AHandle <> 0) then
  begin
    Result:=  (GetLastError() = ERROR_ALREADY_EXISTS);
    
    CloseHandle(AHandle);
  end;
end;

procedure TExecutor.LoadLocalSettings();
begin
  FTemp:= CobSetBackSlashW(Settings.GetTemp());
  FShowExactPercent:= Settings.GetShowExactPercent();
  FMailOnBackup:= Settings.GetMailAfterBackup();
  FLog:= Settings.GetLog();
  FMailLog:= Settings.GetMailLog();
  FUseVisibleDesktop:= Settings.GetUseCurrentDesktop();
  FForceFirstFull:= Settings.GetForceFirstFull();
  FDoNotSeparateDate:= Settings.GetDoNotSeparateDate();
  FDoNotUseSpaces:= Settings.GetDoNotUseSpaces();
  FDTFormat:= Settings.GetDateTimeFormat();
  FUseShell:= Settings.GetUseShellFunctionOnly();
  FAlternative:= Settings.GetUseAlternativeMethods();
  FSlow:= Settings.GetLowPriority();
  FBufferSize:= Settings.GetCopyBuffer();
  FCheckCRC:= Settings.GetCheckCRCNoComp();
  FCopyTimeStamps:= Settings.GetCopyTimeStamps();
  FCopyAttributes:= Settings.GetCopyAttributes();
  FCopyNTFS:= Settings.GetCopyNTFSPermissions();
  FParkFirstBackup:= Settings.GetParkFirstBackup();
  FDeleteEmptyFolders:= Settings.GetDeleteEmptyFolders();
  FAlwaysCreateDirs:= Settings.GetAlwaysCreateFolder();
  FCompAbsolute:= Settings.GetCompAbsolute();
  FZipLevel:= Settings.GetZipLevel();
  FUseTaskNames:= Settings.GetCompUseTaskName();
  FCompCRC:= Settings.GetCompCRC();
  FZipAdvancedNaming:= Settings.GetZipAdvancedNaming();
  FCompOEM:= Settings.GetCompOEM();
  FZip64:= Settings.GetZip64();
  FUncompressed:= Settings.GetUncompressed();
  FSqxLevel:= Settings.GetSQXLevel();
  FSqxDictionary:= Settings.GetSQXDictionary();
  FSqxRecovery:= Settings.GetSQXRecovery();
  FSqxExternal:= Settings.GetSQXExternal();
  FSqxSolid:= Settings.GetSQXSolid();
  FSqxExe:= Settings.GetSQXExe();
  FSqxMultimedia:= Settings.GetSQXMultimedia();
  FFTPSpeedLimit:= Settings.GetFTPSpeedLimit();
  FFTPSpeed:= Settings.GetFTPSpeed();
  FFTPASCII:= Settings.GetFTPASCII();
  FPropagate:= Settings.GetPropagateMasks();
end;

procedure TExecutor.MailLog();
var
  Mailer: TMailer;
begin
  Mailer:= TMailer.Create(FAppPath);
  Mailer.FreeOnTerminate:= true;
  Mailer.Resume();
end;


function TExecutor.NeedToReload(): boolean;
begin
  CS_Executor.Enter();
  try
    Result:= Flag_Executor;
    if (Result) then
      Flag_Executor:= BOOL_NO_NEED_TO_RELOAD;
  finally
    CS_Executor.Leave();
  end;
end;

procedure TExecutor.OnObjectLog(const Msg: WideString; const Error,
  Verbose: boolean);
begin
  Logger.Log(Msg, Error, Verbose);
  if (Error) and (not Verbose) then
    Inc(FErrors);
end;

procedure TExecutor.OnCompressFileBegin(const FileName: WideString;
  const Checking: boolean);
begin
  Logger.Log(WideFormat(Translator.GetMessage('334'), [FileName], FS), false, true);
  FCurrentFileName := FileName;
  // FPartialPercent := INT_NIL; DO NOT RESET because the % is per archive and not per file
  if (Checking) then
    SendStatus(INT_OPCRC) else
    SendStatus(INT_OPCOMPRESS);
end;

procedure TExecutor.OnCompressFileEnd(const FileName: WideString;
  const Checking: boolean);
begin
  Logger.Log(WideFormat(Translator.GetMessage('335'), [FileName], FS), false, true);

  FCurrentFileName := FileName;
  // FPartialPercent := INT_100; % per archive

  if (not Checking) then
  begin
    Inc(FTaskFiles); // This is to log the tasks files
    Inc(FCurrentFileCount); //inc anyway , this is to calculate %
  end;

  if (Checking) then
    SendStatus(INT_OPCRC) else
    SendStatus(INT_OPCOMPRESS);
end;

procedure TExecutor.OnCompressProgress(const FileName: WideString;
  const Percent: integer; const Checking: boolean);
begin
  FCurrentFileName := FileName;
  FPartialPercent := Percent;
  if (Checking) then
    SendStatus(INT_OPCRC) else
    SendStatus(INT_OPCOMPRESS);
end;

procedure TExecutor.ProcessFTPCompressedFiles(const Files,
  Destination: WideString);
var
  Rec: TFTPrec;
  FTP: TFTP;
  Sl: TTntStringList;
  i: integer;
begin
  Rec.Temp:= FTemp;
  Rec.AppPath:= FAppPath;
  Rec.IncludeSubDirs:= FTask.IncludeSubdirectories;
  Rec.IncludeMask:= WS_NIL; // Do not use masks
  Rec.ExcludeMask:= WS_NIL;
  Rec.Slow:= FSlow;
  Rec.SpeedLimit:= FFTPSpeedLimit;
  Rec.Speed:= FFTPSpeed;
  Rec.ASCII:= FFTPASCII;
  Rec.UseAttributes:= FTask.UseAttributes;
  Rec.Separated:= FTask.SeparateBackups;    
  Rec.DTFormat:= FDTFormat;
  Rec.DoNotSeparate:= FDoNotSeparateDate;
  Rec.DoNotUseSpaces:= FDoNotUseSpaces;
  Rec.BackupType:= INT_BUFULL;   // Copy ALL files
  Rec.EncBufferSize:= FBufferSize;
  Rec.EncCopyTimeStamps:= FCopyTimeStamps;
  Rec.EncCopyAttributes:= FCopyAttributes;
  Rec.EncCopyNTFS:= FCopyNTFS;
  Rec.ClearAttributes:= FTask.ResetAttributes;
  Rec.DeleteEmptyFolders:= FDeleteEmptyFolders;
  Rec.AlwaysCreateDirs:= FAlwaysCreateDirs;
  Rec.EncPublicKey:= Ftask.PublicKey;
  Rec.EncMethod:= FTask.Encryption;
  Rec.EncPassPhrase:= FTask.Passphrase;
  Rec.Propagate:= FPropagate;

  Sl:= TTntStringList.Create();
  FTP:= TFTP.Create(Rec);
  try
    FTP.OnAbort:= OnObjectAbort;
    FTP.OnLog:= OnObjectLog;
    FTP.OnProgress:= OnFTPProgress;
    FTP.OnFileBegin:= OnFTPFileBegin;
    FTP.OnFileEnd:= OnFTPFileEnd;
    FTP.OnFileBeginEnc:= OnEncryptionBegin;
    FTP.OnFileEndEnc:= OnEncryptionEnd;
    FTP.OnFileProgressEnc:= OnEncryptionProgressDone;
    FTP.OnNTFSPermissionsCopyEnc:= OnNTFSPermissionsCopy;
    FTP.OnDelete:= OnDeleteProgress;
    if (FTP.UploadBunch(Files, Destination, FLastElement) > INT_FAILTRANSFERFAILED) then
      AddBackupResult(FTP.FFinalAdress); // Do not encode

    // Delete the compressed files
    Sl.CommaText:= Files;
    for i:= 0 to Sl.Count - 1 do
      if (WideFileExists(Sl[i])) then
        DeleteFileW(PWideChar(Sl[i]));
  finally
    FreeAndNil(FTP);
    FreeAndNil(Sl);
  end;
end;

procedure TExecutor.ProcessLocalCompressedFiles(const Files: WideString);
var
  ZipResult: TTntStringList;
  i: integer;
begin
  ZipResult:= TTntStringList.Create();
  try
    ZipResult.CommaText:= Files;

    if (ZipResult.Count = 0) then
      Exit;

    if (FTask.Encryption = INT_ENCNOENC) then
    begin
      for i:=0 to ZipResult.Count-1 do
        AddBackupResult(FTools.EncodeSD(INT_SDFILE,ZipResult[i]));
      Exit;
    end;

   // if we are here, the there is a need to encrypt
   EncryptZipFiles(Files);

  finally
    FreeAndNil(ZipResult);
  end;
end;

function TExecutor.OnObjectAbort(): boolean;
begin
  Result:= DoAbort();
end;

procedure TExecutor.OnCopyCRCProgress(const FileName: WideString;
                                                    const PercentDone: integer);
begin
  FCurrentFileName := FileName;
  FPartialPercent := PercentDone;
  SendStatus(INT_OPCRC);
end;

procedure TExecutor.OnEncryptionBegin(const FileName, DestFile: WideString;
  const Single: boolean);
begin
  Logger.Log(WideFormat(Translator.GetMessage('284'), [FileName, DestFile], FS), false,
    not Single);
  FCurrentFileName := FileName;
  FPartialPercent := INT_NIL;
  SendStatus(INT_OPENCRYPT);
end;

procedure TExecutor.OnEncryptionProgressDone(const FileName: WideString;
  const PercentDone: integer);
begin
  FCurrentFileName := FileName;
  FPartialPercent := PercentDone;
  SendStatus(INT_OPENCRYPT);
end;

procedure TExecutor.OnFTPFileBegin(const FileName, Destination: WideString; const Single,
  Downloading: boolean);
begin
  if (Downloading) then
    Logger.Log(WideFormat(Translator.GetMessage('395'), [FileName, Destination], FS), false,
    not Single) else
    Logger.Log(WideFormat(Translator.GetMessage('396'), [FileName, Destination], FS), false,
    not Single);
  FCurrentFileName := FileName;
  FPartialPercent := INT_NIL;
  if (Downloading) then
    SendStatus(INT_OPFTPDOWN) else
    SendStatus(INT_OPFTPUP);
end;

procedure TExecutor.OnFTPFileEnd(const FileName, Destination: WideString; const Single,
  Success, Downloading: boolean);
begin
  if Success then
    if (Downloading) then
      Logger.Log(WideFormat(Translator.GetMessage('397'), [FileName, Destination], FS), false,
        not Single) else
      Logger.Log(WideFormat(Translator.GetMessage('398'), [FileName, Destination], FS), false,
        not Single);

  FCurrentFileName := FileName;
  FPartialPercent := INT_100;
  if Success then
    Inc(FTaskFiles); // This is to log the tasks files
  Inc(FCurrentFileCount); //inc anyway , this is to calculate %
  if (Downloading) then
    SendStatus(INT_OPFTPDOWN) else
    SendStatus(INT_OPFTPUP);
end;

procedure TExecutor.OnFTPProgress(const FileName: WideString;
  const Percent: integer; const Downloading: boolean);
begin
  FCurrentFileName := FileName;
  FPartialPercent := Percent;
  if (Downloading) then
    SendStatus(INT_OPFTPDOWN) else
    SendStatus(INT_OPFTPUP);
end;

procedure TExecutor.OnEncryptionEnd(const FileName, DestFile: WideString;
  const Single, Success, Secundary: boolean);
begin
  if Success then
    Logger.Log(WideFormat(Translator.GetMessage('285'), [FileName, DestFile], FS), false,
      not Single);

  FCurrentFileName := FileName;
  FPartialPercent := INT_100;

  // Secundary= true if encryption is part of another oprration
  //for example, ZIP + Encrypt or
  //encrypt + FTP. In this case so NOT count the encrypting in
  // the percent thing

  if Success and (Secundary = BOOL_ENCPRIMARY) then
    Inc(FTaskFiles); // This is to log the tasks files
  if (Secundary = BOOL_ENCPRIMARY) then
    Inc(FCurrentFileCount); //inc anyway , this is to calculate %
  SendStatus(INT_OPENCRYPT);
end;

procedure TExecutor.OnCopyFileBegin(const FileName, DestFile: WideString;
  const Single: boolean);
begin
  Logger.Log(WideFormat(Translator.GetMessage('232'), [FileName, DestFile], FS), false,
    not Single);
  FCurrentFileName := FileName;
  FPartialPercent := INT_NIL;
  SendStatus(INT_OPCOPY);
end;

procedure TExecutor.OnCopyFileEnd(const FileName, DestFile: WideString; const Single,
  Success: boolean);
begin
  if Success then
    Logger.Log(WideFormat(Translator.GetMessage('233'), [FileName, DestFile], FS), false,
      not Single);

  FCurrentFileName := FileName;
  FPartialPercent := INT_100;
  if Success then
    Inc(FTaskFiles); // This is to log the tasks files
  Inc(FCurrentFileCount); //inc anyway , this is to calculate %
  SendStatus(INT_OPCOPY);
end;

procedure TExecutor.OnCopyProgressDone(const FileName: WideString;
  const PercentDone: integer);
begin
  FCurrentFileName := FileName;
  FPartialPercent := PercentDone;
  SendStatus(INT_OPCOPY);
end;

function TExecutor.OnDeleteProgress(const FileName: WideString): boolean;
begin
  // This was planned to be used with other TCobTools from the beginning
  // but the plans changed

  FCurrentFileName:= FileName;
  SendStatus(INT_OPDELETING,true);
  Result:= DoAbort();
end;

function TExecutor.OnNTFSPermissionsCopy(const Source,
  Destination: WideString): cardinal;
begin
  Result:= ERROR_FILE_NOT_FOUND;
  if (@FCopyNTFSFunction <> nil) then
    Result:= FCopyNTFSFunction(PWideChar(Source), PWideChar(Destination));
end;

procedure TExecutor.QueueNoItems();
var
  CloseUI: boolean;
begin
  // This is executed if the queue dowesn't have tasks waiting
  if FTotalTasks > 0 then //The backup has been ended
  begin
    if (FErrors > 0) then
      Logger.Log(WideFormat(Translator.GetMessage('282'),[FErrors],FS),true, false);
    SetInitialValues();
    SendStatus(INT_OPIDLE);
    if FLog and FMailLog and FMailOnBackup then
      MailLog();
    /// I dont need to check this constantly because
    /// the Flag_AutoClose will only set once, at startup time
    if FFirstBackupTerminated then
    begin
      CloseUI:= AutoClose();

      if CloseUI then
      begin
        SendStatus(INT_OPCLOSEUI); // Send the command to the UI
        Sleep(2 * INT_EXECUTORSLEEP);
        CloseProgram();
      end;
    end;

    FFirstBackupTerminated := false;
  end;

  SetInitialValues();
  SendStatus(INT_OPIDLE);
end;

procedure TExecutor.SendStatus(const Operation: integer; const Std: boolean = true);
var
  PipeTime: cardinal;
begin
  FMsg.Clear();

  if (Std) then
  begin
    FMsg.Add(FTask.ID);    // The id of the task
    FMsg.Add(FCurrentFileName);    // The file name
  end else
  begin
    FMsg.Add(FParam1W);    // The id of the task
    FMsg.Add(FParam2W);    // The file name
  end;
  
  FMsg.Add(CobIntToStrW(Operation)); // Current operation
  FMsg.Add(CobIntToStrW(FPartialPercent));  // Partial percent

  if (FShowExactPercent) then
  begin
    if (FTotalFiles <> 0) then
      FTotalPercent:= Trunc((FCurrentFileCount / FTotalFiles) * 100) else
      FTotalPercent:= 0;
  end else
  begin
     if FTotalTasks <> 0 then
      FTotalPercent := Trunc((FCurrentTaskCount / FTotalTasks) * 100)
    else
      FTotalPercent := 0;
  end;

  FMsg.Add(CobIntToStrW(FTotalPercent));

  if (FUsePipes) then
  begin
    // This will slow down the process A LOT because of some critical sections
    // in the IPC pipe , so send only when 1000 ms have gone as a minimum
    // this is non-critical anyway
    PipeTime:= GetTickCount();
    if  (Operation < INT_OPCOPY) or (Operation > INT_OPDELETING) or
       ((PipeTime - FOldPipeTime) > INT_1000MS) then
      FOldPipeTime:= PipeTime else
      Exit;
    FWriter.Add(FMsg.CommaText);
    FPipeClient.SendStringW(FWriter.CommaText, INT_NORMALMESSAGEFROMENGINE);
    FWriter.Clear();
  end else
  begin
    if WaitForSingleObject(FIPCMutex, INFINITE) = WAIT_OBJECT_0 then
      try
        if FSenderPointer <> nil then
        begin
          FWriter.CommaText:= FSenderPointer;
          FWriter.Add(FMsg.CommaText);
          if (Length(FWriter.CommaText) < (INT_MAXFILESIZE div SizeOf(WideChar)) - 4) then
            lstrcpyW(FSenderPointer,PWideChar(FWriter.CommaText));
          FWriter.Clear();
        end;
      finally
        ReleaseMutex(FIPCMutex);
      end;
  end;
end;

procedure TExecutor.SetInitialValues();
begin
  FTotalTasks := INT_NIL;
  FCurrentTaskCount := INT_NIL;
  FTotalFiles := INT_NIL;
  FCurrentFileCount := INT_NIL;
  FCurrentFileName := WS_NIL;
  FPartialPercent := INT_NIL;
  FTotalPercent := INT_NIL;
  FOldPipeTime:= INT_NIL;
end;

procedure TExecutor.Sqx(const Source, Destination: WideString);
var
  ADestination: WideString;
  SqxResult: TTntStringList;
  Kind: integer;
  SQX: TSQX;
  SQXRec: TSQXRec;
begin
  ADestination:= FTools.DecodeSD(Destination, Kind);
  if (Kind = INT_SDFTP) then
    ADestination:= FTemp;

  SQXResult:= TTntStringList.Create();

  SQXRec.Temp:= FTemp;
  SQXRec.AppPath:= FAppPath;
  SQXRec.BackupType:= FTask.BackupType;
  SQXRec.UseAttributes:= FTask.UseAttributes;
  SQXRec.Separated:= FTask.SeparateBackups;
  SQXRec.DTFormat:= FDTFormat;
  SQXRec.DoNotSeparate:= FDoNotSeparateDate;
  SQXRec.DoNotUseSpaces:= FDoNotUseSpaces;
  SQXRec.Slow:= FSlow;
  SQXRec.ClearAttributes:= FTask.ResetAttributes;
  SQXRec.DeleteEmptyFolders:= FDeleteEmptyFolders;
  SQXRec.AbsolutePaths:= FCompAbsolute;
  SQXRec.Subdirs:= FTask.IncludeSubdirectories;
  SQXRec.ExcludeMask:= FTask.ExcludeItems;
  SQXRec.IncludeMask:= FTask.IncludeMasks;
  SQXRec.DoNotCompress:= FUncompressed;
  SQXRec.UseTaskName:= FUseTaskNames;
  SQXRec.TaskName:= FTask.Name;
  SQXRec.CheckArchives:= FCompCRC;
  SQXRec.WillBeFTPed:= (Kind = INT_SDFTP);
  SQXRec.OEM:= FCompOEM;
  SQXRec.Protect:= FTask.ArchiveProtect;
  SQXRec.Password:= FTask.Password;
  SQXRec.Split:= FTask.Split;
  SQXRec.CustomSize:= FTask.SplitCustom;
  SQXRec.Comment:= FTask.ArchiveComment;
  SQXRec.SqxLevel:= FSqxLevel;
  SQXRec.SqxDictionary:= FSqxDictionary;
  SQXRec.SqxRecovery:= FSqxRecovery;
  SQXRec.SqxExternal:= FSqxExternal;
  SQXRec.SqxSolid:= FSqxSolid;
  SQXRec.SqxExe:= FSqxExe;
  SQXRec.SqxMultimedia:= FSqxMultimedia;
  SQXRec.Propagate:= FPropagate;

  SQX:= TSQX.Create(SQXRec);
  try
    SQX.OnLog:= OnObjectLog;
    SQX.OnAbort:= OnObjectAbort;
    SQX.OnFileBegin:= OnCompressFileBegin;
    SQX.OnFileEnd:= OnCompressFileEnd;
    SQX.OnPercentDone:= OnCompressProgress;
    SqxResult.CommaText:= SQX.SQX(Source, ADestination, FLastElement);

    if (DoAbort()) then
      Exit;

    if (Kind = INT_SDDIR) then
      ProcessLocalCompressedFiles(SqxResult.CommaText) else
      ProcessFTPCompressedFiles(SqxResult.CommaText, FTools.DecodeSD(Destination, Kind));
  finally
    FreeAndNil(SQX);
    FreeAndNil(SQXResult);
  end;
end;

procedure TExecutor.Start();
begin
  // Here begins the backup of the current task.
  FCurrentFileName:= WS_NIL;
  FPartialPercent := INT_NIL;

  if (not FTask.Disabled) then
    Action() else
    Logger.Log(WideFormat(Translator.GetMessage('171'),[FTask.Name],FS), false, false);

  // A task is done
  inc(FCurrentTaskCount);
  FCurrentFileName:= WS_NIL;
  FPartialPercent := INT_NIL;
end;

procedure TExecutor.StopImpersonation();
var
  Error: cardinal;
begin
  if (FImpersonated) then
    if RevertToSelf() then
    begin
      FImpersonated:= false;
      Logger.Log(Translator.GetMessage('223'),false,false);
    end else
    begin
      Error:= Windows.GetLastError();
      Logger.Log(WideFormat(Translator.GetMessage('224'),
                                  [CobSysErrorMessageW(Error)],FS),true,false);
      Inc(FErrors);
    end;

  if (FToken <> 0) then
  begin
    if CloseHandle(FToken) then
    begin
      FToken:= 0;
      Logger.Log(WideFormat(Translator.GetMessage('225'),
            [FTask.ImpersonateID, FTask.ImpersonateDomain],FS),false,false);
    end else
    begin
      Error:= Windows.GetLastError();
      Logger.Log(WideFormat(Translator.GetMessage('226'),
          [FTask.ImpersonateID,FTask.ImpersonateDomain,CobSysErrorMessageW(Error)],
          FS),true,false);
      Inc(FErrors);
    end;
  end;
end;

procedure TExecutor.UpdateTaskHistory();
var
  Sl, Sll: TTntStringList;
  Backup, BackupToDelete: TBackup;
  rf: PResultFile;
  i,j, LastID, Count: integer;
begin
  // Here we'll need to load the backup history
  // of the task, and update it

  Sl:= TTntStringList.Create();
  Sll:= TTntStringList.Create();
  try
    FHistoryList.LoadBackups(FTask.ID);
    Count:= FHistoryList.GetCount();

    // Add the current backup to the list

    Sl.CommaText:= FTask.Destination;
    for i:= 0 to Sl.Count - 1 do
    begin
      Sll.Clear();
      //Populate the strings with the values that belong to the current destination
      for j:= 0 to FResultFiles.Count-1 do
      begin
        rf:= PResultFile(FResultFiles[j]);
        if (rf^.Destination = i) then
          Sll.Add(rf^.AObject);
      end;

      if (Sll.Count = 0) then
        Continue;

      //Add a backup item per destination
      Backup := TBackup.Create(WS_NIL);   // will be deleted on FHistory.Clear()
      Backup.FTaskID := FTask.ID;
      if FTask.BackupType = INT_BUFULL  then
        Backup.FParentID := WS_NIL else
        Backup.FParentID := FHistoryList.GetParentBackupID(Sl[i]);
      Backup.FSource := FTask.Source;
      Backup.FDestination := Sl[i];
      Backup.FScheduleType := FTask.ScheduleType;
      Backup.FBackupType:= FTask.BackupType;
      Backup.FCompressed := FTask.Compress;
      Backup.FSplit := FTask.Split;
      Backup.FEncrypted := FTask.Encryption;
      Backup.FFiles := Sll.CommaText;
      if FParkFirstBackup and (Count = 0) and (FTask.BackupType = INT_BUFULL) then
          Backup.FParked := true
        else
          Backup.FParked := false;
      Backup.FDateTime := Now();
      Backup.FNextDateTime := GetNextBackupTime(Backup.FDateTime);

      if (not FTask.SeparateBackups) then
        if (Count > 0) then
        begin
          LastID:= FHistoryList.GetLastBackupIndex(Sl[i]);
          if (LastID > -1) then
          begin
            /// Copy the parked field of the task to replace
            FHistoryList.GetBackupPointerIndex(LastID, BackupToDelete);
            Backup.FParked:= BackupToDelete.FParked;
            FHistoryList.DeleteBackupIndex(LastID);
          end;
        end;

      FHistoryList.AddBackup(Backup);
    end;

    // Now CAREFULLY delete the old backups if necessary
    DeleteOldBackups();
    // Save the updated files
    FHistoryList.SaveBackups(FTask.ID);
  finally
    FreeAndNil(Sl);
    FreeAndNil(Sll);
  end;
end;

procedure TExecutor.Zip(const Source, Destination: WideString);
var
  ADestination: WideString;
  ZipResult: TTntStringList;
  Kind: integer;
  Zipper: TZipper;
  ZipperRec: TZipperRec;
begin
  ADestination:= FTools.DecodeSD(Destination, Kind);
  if (Kind = INT_SDFTP) then
    ADestination:= FTemp;

  ZipResult:= TTntStringList.Create();

  ZipperRec.Temp:= FTemp;
  ZipperRec.AppPath:= FAppPath;
  ZipperRec.BackupType:= FTask.BackupType;
  ZipperRec.UseAttributes:= FTask.UseAttributes;
  ZipperRec.Separated:= FTask.SeparateBackups;
  ZipperRec.DTFormat:= FDTFormat;
  ZipperRec.DoNotSeparate:= FDoNotSeparateDate;
  ZipperRec.DoNotUseSpaces:= FDoNotUseSpaces;
  ZipperRec.Slow:= FSlow;
  ZipperRec.ClearAttributes:= FTask.ResetAttributes;
  ZipperRec.DeleteEmptyFolders:= FDeleteEmptyFolders;
  ZipperRec.AbsolutePaths:= FCompAbsolute;
  ZipperRec.Subdirs:= FTask.IncludeSubdirectories;
  ZipperRec.ExcludeMask:= FTask.ExcludeItems;
  ZipperRec.IncludeMask:= FTask.IncludeMasks;
  ZipperRec.CompressionLevel:= FZipLevel;
  ZipperRec.UseTaskName:= FUseTaskNames;
  ZipperRec.TaskName:= FTask.Name;
  ZipperRec.CheckArchives:= FCompCRC;
  ZipperRec.AdvancedNaming:= FZipAdvancedNaming;
  ZipperRec.OEM:= FCompOEM;
  ZipperRec.Zip64:= FZip64;
  ZipperRec.DoNotCompress:= FUncompressed;
  ZipperRec.WillBeFTPded:= (Kind = INT_SDFTP);
  ZipperRec.Protect:= FTask.ArchiveProtect;
  ZipperRec.Password:= FTask.Password;
  ZipperRec.Split:= FTask.Split;
  ZipperRec.CustomSize:= FTask.SplitCustom;
  ZipperRec.Comment:= FTask.ArchiveComment;
  ZipperRec.Propagate:= FPropagate;

  Zipper:= TZipper.Create(ZipperRec);
  try
    Zipper.OnLog:= OnObjectLog;
    Zipper.OnAbort:= OnObjectAbort;
    Zipper.OnFileBegin:= OnCompressFileBegin;
    Zipper.OnFileEnd:= OnCompressFileEnd;
    Zipper.OnPercentDone:= OnCompressProgress;
    ZipResult.CommaText:= Zipper.Zip(Source, ADestination, FLastElement);

    if (DoAbort()) then
      Exit;

    if (Kind = INT_SDDIR) then
      ProcessLocalCompressedFiles(ZipResult.CommaText) else
      ProcessFTPCompressedFiles(ZipResult.CommaText, FTools.DecodeSD(Destination, Kind));
  finally
    FreeAndNil(Zipper);
    FreeAndNil(ZipResult);
  end;
end;

end.
