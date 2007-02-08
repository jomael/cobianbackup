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

// Common code shared by all projects in Cobian Backup

unit bmCommon;

interface

uses Windows, SysUtils, SyncObjs, Classes, TntClasses, CobCommonW;

type
  TEntryPoint = procedure(const Service: byte;
                    const AppPathParam, Params:PWideChar); stdcall;
  TExitPoint = procedure(); stdcall;
  TNTCopySecurity = function (Source, Destination: PWideChar): cardinal; stdcall;
  TNTSecCreate = procedure (); stdcall;
  TNTSecDestroy = procedure (); stdcall;

  //Events
  TCobLogEvent = procedure (const Msg: WideString; const Error, Verbose: boolean) of object;
  TCobAbort = function () :boolean of object;
  TCobObjectFileBegin = procedure (const FileName, DestFile: WideString; const Single: boolean) of object;
  TCobObjectFileEnd = procedure (const FileName, DestFile: WideString; const Single, Success: boolean) of object;
  TCobEncryptFileEnd = procedure (const FileName, DestFile: WideString; const Single, Success, Secundary: boolean) of object;
  TCobObjectProgress = procedure (const FileName: WideString; const PercentDone: integer) of object;
  TCobCopyCRCProgress = procedure (const FileName: WideString; const PercentDone: integer) of object;
  TCobNTFSPermissionsCopy = function (const Source, Destination: WideString): cardinal of object;
  TCobCompressFileBeginEnd = procedure (const FileName: WideString; const Checking: boolean) of object;
  TCobCompressPercentDone = procedure (const FileName: WideString; const Percent: integer; const Checking: boolean) of object;
  TCobDeleteCallbackW = function (const FileName: WideString): boolean of object;
  TCobUIDelete = procedure (const FileName: WideString) of object;
  TCobFTPFileBegin = procedure (const FileName, Destination: WideString; const Single, Downloading: boolean) of object;
  TCobFTPFileEnd = procedure (const FileName, Destination: WideString; const Single, Success, Downloading: boolean) of object;
  TCobFTPProgress = procedure (const FileName: WideString; const Percent: integer; const Dowloading: boolean) of object;

  //Decryptor
  TDecryptorMainEntry = function (const pAppPath, pLanguage: PWideChar;
                   const bShowErrorsOnly: LongBool;
                   const iParentHandle: cardinal): cardinal; stdcall;
  
  TFindWindowStructW = record //To EnumerateWindows
    Caption: WideString;
    ClassName: WideString;
    WindowHandle: THandle;
  end;
  PFindWindowStructW = ^TFindWindowStructW;

  //Use this class only from the main thread
  // and pass the values as parameters
  TGlobalUtils = class(TObject)
  private
    FAppPath: WideString;
    FDBPath: WideString;
    FHelpPath: WideString;
    FTutorialPath: WideString;
    FSettingsPath: WideString;
    FLanguagePath: WideString;
    pSecurityDesc: PSECURITY_DESCRIPTOR;
    FIsService: boolean;
    function GetAppPath():WideString;
    function GetDBPath():WideString;
    function GetHelpPath():WideString;
    function GetSettigsPath():WideString;
    function GetLanguagePath():WideString;
    function GetTutorialPath(): WideString;
    function GetIsService(): boolean;
    procedure GetAllAccess(const DirName: WideString);
  public
    Sec: TSECURITYATTRIBUTES;
    property AppPath: WideString read GetAppPath;
    property DBPath: WideString read GetDBPath;
    property HelpPath: WideString read GetHelpPath;
    property SettingsPath: WideString read GetSettigsPath;
    property LanguagesPath: WideString read GetLanguagePath;
    property TutorialPath: WideString read GetTutorialPath;
    property IsService: boolean read GetIsService;
    constructor Create(const AppPath: WideString; const Service: boolean);
    destructor Destroy();override;
    procedure CheckDirectories();
  end;

  TBackup = class(TObject)
  private
  public
    FBackupID: WideString;
    FTaskID: WideString; // the owner of the backup
    FParentID: WideString; // WS_NIL for full backup else the ID of the last FULL backup
    //I store a copy of the some tasks properties here because the task can be changed
    //after the backup
    FSource: WideString;
    FDestination: WideString; // THIS WILL STORE THE FINAL FOLDER
    FBackupType: integer;
    FScheduleType: integer;
    FCompressed: integer;
    FEncrypted: integer;
    FSplit: integer;
    FParked: boolean;
    FFiles: WideString;//These are the files AND folders taht are copied to the destination
    FDateTime: TDateTime;
    FNextDateTime: TDateTime; // the date and time of the next backup
    constructor Create(const ID: WideString);
    destructor Destroy();override;
    procedure StrToBackupW(const Value: WideString);
    function BackupToStrW(): WideString;
  end;

  TBackupList = class(TObject)
  private
    FList: Tlist;
  public
    constructor Create();
    destructor Destroy();override;
    procedure LoadBackups(const ID: WideString);
    procedure SaveBackups(const ID: WideString);
    procedure GetBackupPointer(const ID: WideString; var Backup: TBackup);
    procedure GetBackupPointerIndex(const Index: integer; var Backup: TBackup);
    function GetCount(): integer;
    function GetLastBackupIndex(const Destination: WideString): integer;
    procedure DeleteBackup(const ID: WideString);
    procedure DeleteBackupIndex(const Index:integer);
    procedure AddBackup(const Backup: TBackup);
    function GetParentBackupID(const Destination: WideString): WideString;
    procedure ClearList();
  end;

  TTask = class(TObject)
  private
    FS: TFormatSettings;
  public
    Name: WideString;
    ID: WideString;
    Disabled: boolean;
    IncludeSubdirectories: boolean;
    SeparateBackups: boolean;      // THIS has changed from older versions!!!!
    UseAttributes: boolean;
    ResetAttributes: boolean;
    BackupType: integer;
    FullCopiesToKeep: integer;
    Source: WideString;
    Destination: WideString;
    ScheduleType: integer;
    DateTime: TDateTime; //The date + the Time (2 controls in one field)
    DayWeek: WideString; //Comma separated days: 1-Monday, 7-Sunday
    DayMonth: WideString; //Comma separated days 1..31
    Month: integer; //0-January 11-december
    Timer: cardinal;
    MakeFullBackup: integer;
    Compress: integer;
    ArchiveProtect: boolean;
    Password: WideString;
    Split: integer;
    SplitCustom: int64;
    ArchiveComment: WideString;
    Encryption: integer;
    Passphrase: WideString;
    PublicKey: WideString;
    IncludeMasks: WideString; // only masks are allowed
    ExcludeItems: WideString;
    BeforeEvents: WideString;
    AfterEvents: WideString;
    Impersonate: boolean;
    ImpersonateCancel: boolean;
    ImpersonateID: WideString;
    ImpersonateDomain: WideString;
    ImpersonatePassword: WideString;
    function TaskToStrW(): WideString;
    procedure StrToTaskW(const Str: WideString);
    procedure CloneTo(var Task: TTask);
    procedure ApplyParameters();
    constructor Create();
  end;

  PTask=^TTask;

  TSettings = class(TObject)
  public
    TaskList: TThreadList;
    constructor Create(const Sec: PSECURITYATTRIBUTES;
                       const AppPath, DBPath, SettingsPath: WideString);
    destructor Destroy();override;
    procedure LoadSettings();
    procedure SaveSettings(const Std: boolean);
    procedure LoadList();
    procedure SaveList();
    function CheckTemporaryDir(const DBDir: WideString): boolean;
    // Getters & setters
    procedure SetList(const Value: WideString);
    function GetList(): WideString;
    procedure SetLanguage(const Value: WideString);
    function GetLanguage(): WideString;
    procedure SetLog(const Value: boolean);
    function GetLog(): boolean;
    procedure SetLogErrorsOnly(const Value: boolean);
    function GetLogErrorsOnly(): boolean;
    procedure SetLogVerbose(const Value: boolean);
    function GetLogVerbose(): boolean;
    procedure SetLogRealTime(const Value: boolean);
    function GetLogRealTime(): boolean;
    function GetPassword(): WideString;
    procedure SetPassword(const Value: WideString);
    function GetProtectUI(): boolean;
    procedure SetProtectUI(const Value: boolean);
    function GetProtectMainWindow(): boolean;
    procedure SetProtectMainWindow(const Value: boolean);
    function GetClearPasswordCache(): boolean;
    procedure SetClearPasswordCache(const Value: boolean);
    function GetMailLog(): boolean;
    procedure SetMailLog(const Value: boolean);
    function GetMailAfterBackup(): boolean;
    procedure SetMailAfterBackup(const Value: boolean);
    function GetMailScheduled(): boolean;
    procedure SetMailScheduled(const Value: boolean);
    function GetMailAsAttachment(): boolean;
    procedure SetMailAsAttachment(const Value: boolean);
    function GetMailIfErrorsOnly(): boolean;
    procedure SetMailIfErrorsonly(const Value: boolean);
    function GetMailDelete(): boolean;
    procedure SetMailDelete(const Value: boolean);
    function GetMailDateTime(): TDateTime;
    procedure SetMailDateTime(const Value: TDateTime);
    function GetSMTPSender(): WideString;
    procedure SetSMTPSender(const Value: WideString);
    function GetSMTPSenderAddress(): WideString;
    procedure SetSMTPSenderAddress(const Value: WideString);
    function GetSMTPDestination(): WideString;
    procedure SetSMTPDestination(const Value: WideString);
    function GetSMTPHost(): WideString;
    procedure SetSMTPHost(const Value: WideString);
    function GetSMTPPort(): integer;
    procedure SetSMTPPort(const Value: integer);
    function GetSMTPSubject(): WideString;
    procedure SetSMTPSubject(const Value: WideString);
    function GetSMTPAuthentication(): integer;
    procedure SetSMTPAuthentication(const Value: integer);
    function GetSMTPID(): WideString;
    procedure SetSMTPID(const Value: WideString);
    function GetSMTPPassword(): WideString;
    procedure SetSMTPPassword(const Value: WideString);
    function GetSMTPHelo(): WideString;
    procedure SetSMTPHelo(const Value: WideString);
    function GetSMTPPipeLine(): boolean;
    procedure SetSMTPPipeLine(const Value: boolean);
    function GetSMTPEhlo(): boolean;
    procedure SetSMTPEhlo(const Value: boolean);
    function GetTCPConnectionTimeOut(): integer;
    procedure  SetTCPConnectionTimeOut(const Value: integer);
    function GetTCPReadTimeOut(): integer;
    procedure  SetTCPReadTimeOut(const Value: integer);
    function GetTemp(): WideString;
    procedure SetTemp(const Value: WideString);
    function GetShowExactPercent(): boolean;
    procedure SetShowExactPercent(const Value: boolean);
    function GetUseCurrentDesktop(): boolean;
    procedure SetUseCurrentDesktop(const Value: boolean);
    function GetForceFirstFull(): boolean;
    procedure SetForceFirstFull(const Value:boolean);
    function GetDateTimeFormat(): WideString;
    procedure SetDateTimeFormat(const Value: WideString);
    function GetDoNotSeparateDate(): boolean;
    procedure SetDoNotSeparateDate(const Value: boolean);
    function GetDoNotUseSpaces(): boolean;
    procedure SetDoNotUseSpaces(const Value:boolean);
    function GetUseShellFunctionOnly(): boolean;
    procedure SetUseShellFunctionOnly(const Value: boolean);
    function GetUseAlternativeMethods(): boolean;
    procedure SetUseAlternativeMethods(const Value: boolean);
    function GetLowPriority(): boolean;
    procedure SetLowPriority(const Value: boolean);
    function GetCopyBuffer(): integer;
    procedure SetCopyBuffer(const Value: integer);
    function GetCheckCRCNoComp(): boolean;
    procedure SetCheckCRCNoComp(const Value: boolean);
    function GetCopyTimeStamps(): boolean;
    procedure SetCopyTimeStamps(const Value: boolean);
    function GetCopyAttributes(): boolean;
    procedure SetCopyAttributes(const Value: boolean);
    function GetCopyNTFSPermissions(): boolean;
    procedure SetCopyNTFSPermissions(const Value: boolean);
    function GetParkFirstBackup(): boolean;
    procedure SetParkFirstBackup(const Value: boolean);
    function GetDeleteEmptyFolders(): boolean;
    procedure SetDeleteEmptyFolders(const Value: boolean);
    function GetAlwaysCreateFolder(): boolean;
    procedure SetAlwaysCreateFolder(const Value: boolean);
    function GetCompAbsolute(): boolean;
    procedure SetCompAbsolute(const Value: boolean);
    function GetZipLevel(): integer;
    procedure SetZipLevel(const Value: integer);
    function GetCompUseTaskName(): boolean;
    procedure SetCompUseTaskName(const Value: boolean);
    function GetCompCRC(): boolean;
    procedure SetCompCRC(const Value: boolean);
    function GetZipAdvancedNaming(): boolean;
    procedure SetZipAdvancedNaming(const Value: boolean);
    function GetCompOEM(): boolean;
    procedure SetCompOEM(const Value: boolean);
    function GetZip64(): integer;
    procedure SetZip64(const Value: integer);
    function GetUncompressed(): WideString;
    procedure SetUncompressed(const Value: WideString);
    function GetSQXDictionary(): integer;
    procedure SetSQXDictionary(const Value: integer);
    function GetSQXLevel(): integer;
    procedure SetSQXLevel(const Value: integer);
    function GetSQXRecovery(): integer;
    procedure SetSQXRecovery(const Value: integer);
    function GetSQXSolid(): boolean;
    procedure SetSQXSolid(const Value: boolean);
    function GetSQXMultimedia(): boolean;
    procedure SetSQXMultimedia(const Value: boolean);
    function GetSQXExe(): boolean;
    procedure SetSQXExe(const Value: boolean);
    function GetSQXExternal(): boolean;
    procedure SetSQXExternal(const Value: boolean);
    function GetFTPSpeedLimit(): boolean;
    procedure SetFTPSpeedLimit(const Value: boolean);
    function GetFTPSpeed(): integer;
    procedure SetFTPSpeed(const Value: integer);
    function GetFTPASCII(): WideString;
    procedure SetFTPASCII(const Value: WideString);
    function GetShutdownKill(): boolean;
    procedure SetShutdownKill(const Value: boolean);
    function GetAutoUpdate(): boolean;
    procedure SetAutoUpdate(const Value: boolean);
    function GetRunOldBackups(): boolean;
    procedure SetRunOldBackups(const Value: boolean);
    function GetRunOldDontAsk(): boolean;
    procedure SetRunOldDontAsk(const Value: boolean);
    function GetPropagateMasks(): boolean;
    procedure SetPropagateMasks(const Value: boolean);
    function TaskNameExists(const TaskName: WideString; var ID: WideString): integer;
    function TaskIDExists(const TaskName: WideString): integer;
    procedure CopyTask(const Index: integer; var DestTask: TTask);overload;
    procedure CopyTask(const ID: WideString; var DestTask: TTAsk);overload;
    procedure GetTaskPointer(const Index: integer; var DestTask: TTask); overload;
    procedure GetTaskPointer(const ID: WideString; var DestTask: TTask); overload;
    procedure AddTask(const Task: TTask);
    procedure CloneTask(const ID, NewNameTemplate: WideString);
    procedure UpdateTask(const ID: WideString; const Task: TTask); overload;
    procedure UpdateTask(const Index: integer; const Task: TTask); overload;
    procedure CheckHistoryFile(const ID: WideString);
    function GetHistoryFile(const ID: WideString): WideString;
    function UpdateHistoryFile(const ID, History: WideString): boolean;
    procedure DeleteHistoryFile(const ID: WideString);
    procedure DeleteTask(const ID: WideString);
    function GetTaskCount(): integer;
    procedure RenameTasksID();
    function GetTasksIDList(): WideString;
    procedure ClearListNotFree();
  private
    FCritical: TCriticalSection;
    FMutexIni: THandle;
    FMutexList: THandle;
    FIniFileName: WideString;
    FSettingsPath: WideString;
    FDBPath: WideString;
    FAppPath: WideString;
    FS: TFormatSettings;
    //Settings
    // FWarnMultipleInstances: boolean;
    FCurrentList: WideString;
    FLanguage: WideString;
    FLog: boolean;
    FLogErrorsOnly: boolean;
    FLogVerbose: boolean;
    FLogRealTime: boolean;
    FPassword: WideString;
    FProtectUI: boolean;
    FProtectMainWindow: boolean;
    FClearPasswordCache: boolean;
    FMailLog: boolean;
    FMailAfterBackup: boolean;
    FMailScheduled: boolean;
    FMailAsAttachment: boolean;
    FMailIfErrorsonly: boolean;
    FMailDelete: boolean;
    FMailDateTime: TDateTime;
    FSMTPSender: WideString;
    FSMTPSenderAddress: WideString;
    FSMTPDestination: WideString;
    FSMTPHost: WideString;
    FSMTPPort: integer;
    FSMTPSubject: WideString;
    FSMTPAuhentification: integer;
    FSMTPID: WideString;
    FSMTPPassword: WideString;
    FSMTPHeloName: WideString;
    FSMTPPipeLine: boolean;
    FSMTPUseEhlo: boolean;
    FTCPConnectTimeOut: integer;
    FTCPReadTimeOut: integer;
    FTemp: WideString;
    FShowExactPercent: boolean;
    FUseCurrentDesktop: boolean;
    FForceFirstFull: boolean;
    FDateTimeFormat: WideString;
    FDontSeparateDate: boolean;
    FDoNotUseSpaces: boolean;
    FUseShellFunctionOnly: boolean;
    FUseAlternativeMethods: boolean;
    FLowPriority: boolean;
    FCopyBuffer: integer;
    FCheckCRCNoComp: boolean;
    FCopyTimeStamps: boolean;
    FCopyAttributes: boolean;
    FCopyNTFSPermissions: boolean;
    FParkFirstBackup: boolean;
    FDeleteEmptyFolders: boolean;
    FAlwaysCreateFolder: boolean;
    FCompAbsolute: boolean;
    FZipLevel: integer;
    FCompUseTaskName: boolean;
    FCompCRC: boolean;
    FZipAdvancedNaming: boolean;
    FCompOEM: boolean;
    FZip64: integer;
    FUncompressed: WideString;
    FSQXDictionary: integer;
    FSQXLevel: integer;
    FSQXRecovery: integer;
    FSQXSolid: boolean;
    FSQXMultimedia: boolean;
    FSQXExe: boolean;
    FSQXExternal: boolean;
    FFTPSpeedLimit: boolean;
    FFTPSpeed: integer;
    FFTPASCII: WideString;
    FShutDownKill: boolean;
    FAutoCheck: boolean;
    FRunOldBackups: boolean;
    FRunDontAsk: boolean;
    FPropagateMasks: boolean;
    procedure ClearList();
    function GetDefaultListName(): WideString;
    procedure GetFullAccess(const FileName: WideString);
  end;

  TFTPAddress = class(TObject)
  private
    FSl: TTntStringList;
    FS: TFormatSettings;
  public
    // WARNING , in this class the password is ALWAYS
    // Encrypted. It is your responsability to manipulate it
    //OUTSIDE this class
    Host: WideString;
    ID: WideString;
    Password: WideString;
    Port: Integer;
    WorkingDir: WideString;
    // Auth
    TLS: integer;
    AuthType: integer;
    DataProtection: integer;
    ProxyType: integer;
    ProxyHost: WideString;
    ProxyPort: integer;
    ProxyID: WideString;
    ProxyPassword: WideString;
    //Advanced
    DataPort: integer;
    MinPort: integer;
    MaxPort: integer;
    ExternalIP: WideString;
    Passive: boolean;
    TransferTimeOut: integer;
    ConnectionTimeout: integer;
    UseMLIS: boolean;
    UseIPv6: boolean;
    UseCCC: boolean;
    NATFastTrack: boolean;
    //SSLOptions
    SSLMethod: integer;
    SSLMode: integer;
    UseNagle: boolean;
    VerifyDepth: integer;
    Peer: boolean;
    FailIfNoPeer: boolean;
    ClientOnce: boolean;
    // files
    CertificateFile: WideString;
    CipherList: WideString;
    KeyFile: WideString;
    RootCertificate: WideString;
    VerifyDirectories: WideString;
    // These 2 values are used to store the result of a backup
    FBUObjects: WideString;
    constructor Create();
    destructor Destroy();override;
    function EncodeAddress(): WideString;
    function EncodeAddressDisplay(): WideString;
    function DecodeAddress(const Encoded: WideString): boolean;
    procedure SetDefaultValues();
  end;

  TCobTools = class (TObject)
  public
    OnCRCProgress: TCobCRCCallbackW;
    OnAbort: TCobAbort;
    OnFileProcess: TCobUIDelete;
    constructor Create();
    destructor Destroy(); override;
    function ValidateFileName(const FileName: WideString): boolean;
    function EncodeSD(const Kind: integer; const Path: WideString): WideString;
    function DecodeSD(const Encoded: WideString; var Kind: integer): WideString;
    function ReplaceTemplate(const Input, TaskName{
                    , CleanSource, CleanDestination}: WideString): WideString;
    function GetCompNameW(): WideString;
    function NormalizeFileName(const FileName:WideString): WideString;
    function GetGoodFileNameW(const Input: WideString): WideString;
    function ExecuteW(const FileName, Param: WideString): cardinal;
    function ExecuteAndWaitW(const FileName, Param: WideString;
                            Hide: boolean=false): cardinal;
    function CloseAWindowW(const ACaption: WideString; const Kill: boolean): cardinal;
    function StartServiceW(const LibraryName, ServiceName, Param: WideString): cardinal;
    function StopService(const LibraryName, ServiceName: WideString): cardinal;
    function RestartShutdownW(const Restart,Kill: boolean): cardinal;
    function DeleteDirectoryW(const Dir: WideString): boolean;
    function GetArchiveAttributeW(const FileName: WideString): boolean;
    function GetReadOnlyAttributeW(const FileName: WideString): boolean;
    function NeedToCopyByTimeStamp(const FileName, FileNameDest: WideString): boolean;
    function SetArchiveAttributeW(const FileName: WideString; const SetIt: boolean): boolean;
    function SetReadOnlyAttributeW(const FileName: WideString; const SetIt: boolean): boolean;
    function GetFileNameSeparatedW(const FileName, AFormat: WideString;
                      const Separate: boolean; const DT: TDateTime): WideString;
    function DeleteFileWSpecial(const FileName: WideString): boolean;
    function GetDirNameSeparatedW(const Dir, AFormat: WideString;
                      const Separate: boolean; const DT: TDateTime): WideString;
    function DeleteSpacesW(const FileName: WideString): WideString;
    function IsFileLocked(const FileName: WideString): boolean;
    function IsTheSameFile(const File1, File2: WideString;
                        const UseSizes: boolean): boolean;
    function CopyTimeStamps(const Source, Destination: WideString): boolean;
    function CopyAttributes(const Source, Destination: WideString): boolean;
    function CopyAttributesDir(const Source, Destination: WideString): boolean;
    function IsDirEmpty(const Directory: WideString): boolean;
    function IsInTheMask(const AName, AMask: WideString; const Propagate: boolean): boolean;
    function GetParentDirectory(const Dir: WideString): WideString;
    function GetCleanSD(const SD: WideString): WideString;
    function IsRoot(const Dir: WideString): boolean;
  private
    Sl: TTntStringList;
    FS: TFormatSettings;
    function DoAbort(): boolean;
    procedure FileToProcess(const FileName: WideString);
    function FindAWindow(TheCaption: WideString; TheClassName: WideString): THandle;
    function GetDateTimeFormat(const AFormat: WideString; const DT: TDateTime): WideString;
    function KillSpaces(const Input: WideString): WideString;
  end;

var
  Settings: TSettings;
  Globals: TGlobalUtils;
  CS_LOG: TCriticalSection;
  Flag_Log: boolean;
  BackupQueue: TThreadList;
  {CS_BU: TCriticalSection;
  Flag_BU: boolean;   }
  CS_AutoClose: TCriticalSection;
  Flag_Autoclose: boolean;
  CS_Executor: TCriticalSection;
  Flag_Executor: boolean;
  CS_Scheduler: TCriticalSection;
  Flag_Scheduler: boolean;
  CS_Semaphore: TCriticalSection;
  Flag_Sem_BU_All: boolean;
  Flag_Sem_BU_Some: WideString;
  CS_Abort: TCriticalSection;
  Flag_Abort: boolean;
  CS_UIResponse: TCriticalSection;
  Flag_UI_Response: cardinal;


procedure ClearBUList();

implementation

{ TGlobalUtils }
uses bmConstants, TntSysUtils, bmCustomize, CobEncrypt, ShellAPI, 
  Messages, WideStrings;

procedure ClearBUList();
var
  i: integer;
  Task: TTask;
begin
  with BackupQueue.LockList() do
    try
      for i:=Count-1 downto 0 do
        begin
          Task:= Items[i];
          if (Task <> nil) then
            FreeAndNil(Task);
        end;
      Clear();
    finally
      BackupQueue.UnlockList();
    end;
end;

procedure TGlobalUtils.CheckDirectories();
begin
  if (not WideDirectoryExists(FDBPath)) then
  begin
    WideCreateDir(FDBPath);
    // Give full control to any user
    GetAllAccess(FDBPath);
  end;
  if (not WideDirectoryExists(FHelpPath)) then
  begin
    WideCreateDir(FHelpPath);
    GetAllAccess(FHelpPath);
  end;
  if (not WideDirectoryExists(FSettingsPath)) then
  begin
    WideCreateDir(FSettingsPath);
    GetAllAccess(FSettingsPath);
  end;
  if (not WideDirectoryExists(FLanguagePath)) then
  begin
    WideCreateDir(FLanguagePath);
    GetAllAccess(FLanguagePath);
  end;
end;

constructor TGlobalUtils.Create(const AppPath: WideString;const Service: boolean);
begin
  inherited Create();
  FAppPath:= CobSetBackSlashW(AppPath);
  FDBPath:= CobSetBackSlashW(FAppPath + WS_DIRDB);
  FHelpPath:= CobSetBackSlashW(FAppPath + WS_DIRHELP);
  FSettingsPath:= CobSetBackSlashW(FAppPath + WS_DIRSETTINGS);
  FLanguagePath:= CobSetBackSlashW(FAppPath + WS_DIRLANG);
  FTutorialPath:= CobSetBackSlashW(FHelpPath + WS_DIRTUTORIAL);
  FIsService:= Service;
  Sec:= CobGetNullDaclAttributesW(pSecurityDesc);
end;



destructor TGlobalUtils.Destroy();
begin
  CobFreeNullDaclAttributesW(pSecurityDesc);
  inherited Destroy();
end;

procedure TGlobalUtils.GetAllAccess(const DirName: WideString);
var
  h: THandle;
  Ext: function (const ObjectName: PWideChar): cardinal; stdcall;
begin
  h:= LoadLibraryW(PWideChar(FAppPath + WS_COBNTSEC));
    if (h> 0) then
    begin
      @Ext:= GetProcAddress(h, PAnsiChar(S_LIBGRANTACCESS));
      if (@Ext <> nil) then
        Ext(PWideChar(DirName));
      FreeLibrary(h);
    end;
end;

function TGlobalUtils.GetAppPath(): WideString;
begin
  Result:= FAppPath;
end;

function TGlobalUtils.GetDBPath(): WideString;
begin
  Result:= FDBPath;
end;

function TGlobalUtils.GetHelpPath(): WideString;
begin
  Result:= FHelpPath;
end;

function TGlobalUtils.GetIsService(): boolean;
begin
  Result:= FIsService;
end;

function TGlobalUtils.GetLanguagePath(): WideString;
begin
  Result:= FLanguagePath;
end;

function TGlobalUtils.GetSettigsPath(): WideString;
begin
  Result:= FSettingsPath;
end;

function TGlobalUtils.GetTutorialPath(): WideString;
begin
  Result:= FTutorialPath;
end;

{ TSettings }

procedure TSettings.AddTask(const Task: TTask);
begin
  with TaskList.LockList() do
  try
    TaskList.Add(Task);
    CheckHistoryFile(Task.ID);
  finally
    TaskList.UnlockList();
  end;
end;

procedure TSettings.CheckHistoryFile(const ID: WideString);
var
  fn: WideString;
begin
  fn:= FDBPath + ID + WS_HISTORYEXT;
  if (WaitForSingleObject(FMutexList, INFINITE) = WAIT_OBJECT_0) then
  try
    if (not WideFileExists(fn)) then
    begin
      CobCreateEmptyTextFileW(fn);  //<--- this function has an except handler
      GetFullAccess(fn);
    end;
  finally
    ReleaseMutex(FMutexList);
  end;
end;

function TSettings.CheckTemporaryDir(const DBDir: WideString): boolean;
// 2006-11-16 by Luis Cobian
// check the permissions to the temporary directory, and
// if the user doesn't have the rights, then, change it
//  and warn the user. This is necessary because the INI file
// could have been created by some user and then the program
// could be run by some other user, resulting in permission
// problems for the temporary directory
// Returns true, if it was OK. returns FALSE if the dir was changed
var
  FileName: WideString;
begin
  Result:= true;
  FileName:= CobSetBackSlashW(GetTemp()) + WS_TEMPFILENAME;

  if (CobCreateEmptyTextFileW(FileName)) then
  begin
    DeleteFileW(PWideChar(FileName));
    Exit;
  end else
  begin
    Result:= false;   // Changed
    SetTemp(CobSetBackSlashW(CobGetSpecialDirW(cobTemporary)));  // try with the new user's dir
    FileName:= CobSetBackSlashW(GetTemp()) + WS_TEMPFILENAME;
    if (not CobCreateEmptyTextFileW(FileName)) then
      SetTemp(CobSetBackSlashW(DBDir)) else   
      DeleteFileW(PWideChar(FileName));
  end;
end;

procedure TSettings.ClearList();
var
  i: integer;
  Task: TTask;
begin
  //Clear the list and free all tasks
  with TaskList.LockList() do
  try
    for i := Count - 1 downto 0 do
    begin
      Task := Items[i];
      FreeAndNil(Task);
    end;
    Clear();
  finally
    TaskList.UnlockList();
  end;
end;

procedure TSettings.ClearListNotFree();
begin
  // Clear the list but don't free the elements
  // usefull when re-ordering the items
  with TaskList.LockList() do
  try
    Clear();
  finally
    TaskList.UnlockList();
  end;
end;

procedure TSettings.CloneTask(const ID, NewNameTemplate: WideString);
var
  i, Counter: integer;
  Task, Clone: TTask;
  Found: boolean;
  AName, AID: WideString;
begin
  Found:= false;
  with TaskList.LockList() do
  try
    for i:= 0 to Count -1 do
    begin
      Task:= Items[i];
      if (Task.ID = ID) then
      begin
        Found:= true;
        AName:= Task.Name;
        Clone:= TTask.Create();
        Task.CloneTo(Clone);
        Break;
      end;
    end;  
  finally
    TaskList.UnlockList();
  end;

  if (Found) and (Clone <> nil) then
  begin
    Clone.ID:= CobGetUniqueNameW(); // This will have a new ID, of course
    Clone.Name:= WideFormat(NewNameTemplate, [AName], FS);
    if (TaskNameExists(Clone.Name, AID) <> INT_TASKNOTFOUND) then
    begin
      Counter:= INT_NIL;
      repeat
        inc(Counter);
        Clone.Name:= WideFormat(NewNameTemplate, [AName], FS) +
                     WideFormat(WS_CLONEOF, [Counter], FS);
      until (TaskNameExists(Clone.Name, AID) = INT_TASKNOTFOUND);
    end;

    Settings.AddTask(Clone);
  end;
end;

procedure TSettings.CopyTask(const Index: integer; var DestTask: TTask);
var
  Task: TTask;
begin
  //Copies the value of an existing task into
  // the task that is passed as an argument.
  // This is the oposite of UpdateTask
  
  with TaskList.LockList() do
  try
    if (Index>=0) and (Index < Count) then
    begin
      Task:= Items[Index];
      Task.CloneTo(DestTask);
    end;
  finally
    TaskList.UnlockList();
  end;
end;

procedure TSettings.CopyTask(const ID: WideString; var DestTask: TTAsk);
var
  i: integer;
  Task: TTask;
begin
  // Copy the ID task into the DestTask
  with TaskList.LockList() do
  try
    for i:=0 to Count - 1 do
    begin
      Task:= Items[i];
      if (Task.ID = ID) then
      begin
        Task.CloneTo(DestTask);
        Break;
      end;
    end;
  finally
    TaskList.UnlockList();
  end;
end;

constructor TSettings.Create(const Sec: PSECURITYATTRIBUTES;
                            const AppPath, DBPath, SettingsPath: WideString);
var
  MNIni, MNList: WideString;
begin
  inherited Create();

  GetLocaleFormatSettings(LOCALE_SYSTEM_DEFAULT, FS);

  FCritical:= TCriticalSection.Create();
  // The ini file could be accesed by several processes at the same time
  if CobIs2000orBetterW() then
  begin
    MNIni := WideFormat(WS_INIMUTEXNAME, [WS_PROGRAMNAMELONG],FS);
    MNList:= WideFormat(WS_LISTMUTEXNAME, [WS_PROGRAMNAMELONG],FS);
  end
  else
  begin
    MNIni := WideFormat(WS_INIMUTEXNAMEOLD, [WS_PROGRAMNAMELONG],FS);
    MNList:= WideFormat(WS_LISTMUTEXNAMEOLD, [WS_PROGRAMNAMELONG],FS);
  end;

  FMutexIni := CreateMutexW(Sec, False, PWideChar(MNIni));
  FMutexList:= CreateMutexW(Sec, False, PWideChar(MNList));

  FAppPath:= AppPath;

  FSettingsPath:= SettingsPath;

  FDBPath:= DBPath;

  FIniFileName:= FSettingsPath + WideChangeFileExt(WS_ENGINEEXENAME,WS_INIEXT);

  //This will hold the active list
  TaskList:= TThreadList.Create();
  TaskList.Duplicates:= dupAccept;

  if (not WideFileExists(FIniFileName)) then
    SaveSettings(true);
end;


procedure TSettings.DeleteHistoryFile(const ID: WideString);
var
  fn: WideString;
begin
  // Deletes the history file
  // no backup files are deleted
begin
  fn:= FDBPath + ID + WS_HISTORYEXT;
  if (WaitForSingleObject(FMutexList, INFINITE) = WAIT_OBJECT_0) then
  begin
    try
      if (WideFileExists(fn)) then
        DeleteFileW(PWideChar(fn));
    finally
      ReleaseMutex(FMutexList);
    end;
  end;
end;
end;

procedure TSettings.DeleteTask(const ID: WideString);
var
  i: integer;
  Task: TTask;
begin
  with TaskList.LockList() do
  try
    for i:= Count-1 downto 0 do
    begin
      Task:= Items[i];
      if (Task.ID = ID) then
      begin
        Delete(i);
        // Delete the history file. No backup files are deleted
        // so if you need to delete backups do it before calling
        // DeleteTask
        DeleteHistoryFile(ID);
        Break;
      end;
    end;
  finally
    TaskList.UnlockList();
  end;
end;

destructor TSettings.Destroy();
begin
  ClearList();

  FreeAndNil(TaskList);

  if (FMutexList <> 0) then
  begin
    CloseHandle(FMutexList);
    FMutexList:= 0;
  end;

  if (FMutexIni <> 0) then
  begin
    CloseHandle(FMutexIni);
    FMutexIni:= 0;
  end;

  FreeAndNil(FCritical);
  inherited Destroy();
end;

function TSettings.GetDateTimeFormat(): WideString;
begin
  FCritical.Enter();
  try
    Result := FDateTimeFormat;
  finally
    FCritical.Leave();
  end;
end;

function TSettings.GetDefaultListName(): WideString;
begin
  Result:= CobSetBackSlashW(FAppPath + WS_DIRDB) + WS_MAINLIST;
end;

function TSettings.GetDeleteEmptyFolders(): boolean;
begin
  FCritical.Enter();
  try
    Result := FDeleteEmptyFolders;
  finally
    FCritical.Leave();
  end;
end;

function TSettings.GetDoNotSeparateDate(): boolean;
begin
  FCritical.Enter();
  try
    Result := FDontSeparateDate;
  finally
    FCritical.Leave();
  end;
end;

function TSettings.GetDoNotUseSpaces(): boolean;
begin
  FCritical.Enter();
  try
    Result := FDoNotUseSpaces;
  finally
    FCritical.Leave();
  end;
end;

function TSettings.GetForceFirstFull(): boolean;
begin
  FCritical.Enter();
  try
    Result := FForceFirstFull;
  finally
    FCritical.Leave();
  end;
end;

function TSettings.GetFTPASCII(): WideString;
begin
  FCritical.Enter();
  try
    Result := FFTPASCII;
  finally
    FCritical.Leave();
  end;
end;

function TSettings.GetFTPSpeed(): integer;
begin
  FCritical.Enter();
  try
    Result := FFTPSpeed;
  finally
    FCritical.Leave();
  end;
end;

function TSettings.GetFTPSpeedLimit(): boolean;
begin
  FCritical.Enter();
  try
    Result := FFTPSpeedLimit;
  finally
    FCritical.Leave();
  end;
end;

function TSettings.GetHistoryFile(const ID: WideString): WideString;
var
  fn: WideString;
  Sl: TTntStringList;
begin
  Result:= WS_NIL;
  fn:= FDBPath + ID + WS_HISTORYEXT;
  if (WaitForSingleObject(FMutexList, INFINITE) = WAIT_OBJECT_0) then
  begin
    Sl:= TTntStringList.Create();
    try
      try
        if (WideFileExists(fn)) then
          Sl.LoadFromFile(fn) else
          begin
            CobCreateEmptyTextFileW(fn); // Create it at once
            GetFullAccess(fn);
          end;
        Result:= Sl.CommaText;
      except       // <- Important because thís will be used in the engine too
        Result:= WS_NIL;
      end;
    finally
      FreeAndNil(Sl);
      ReleaseMutex(FMutexList);
    end;
  end;
end;

procedure TSettings.GetFullAccess(const FileName: WideString);
var
  h: THandle;
  Ext: function (const ObjectName: PWideChar): cardinal; stdcall;
begin
  h:= LoadLibraryW(PWideChar(FAppPath + WS_COBNTSEC));
    if (h> 0) then
    begin
      @Ext:= GetProcAddress(h, PAnsiChar(S_LIBGRANTACCESS));
      if (@Ext <> nil) then
        Ext(PWideChar(FileName));
      FreeLibrary(h);
    end;
end;

function TSettings.GetAlwaysCreateFolder: boolean;
begin
  FCritical.Enter();
  try
    Result := FAlwaysCreateFolder;
  finally
    FCritical.Leave();
  end;
end;

function TSettings.GetAutoUpdate(): boolean;
begin
  FCritical.Enter();
  try
    Result := FAutoCheck;
  finally
    FCritical.Leave();
  end;
end;

function TSettings.GetCheckCRCNoComp(): boolean;
begin
  FCritical.Enter();
  try
    Result := FCheckCRCNoComp;
  finally
    FCritical.Leave();
  end;
end;

function TSettings.GetClearPasswordCache: boolean;
begin
  FCritical.Enter();
  try
    Result := FClearPasswordCache;
  finally
    FCritical.Leave();
  end;
end;

function TSettings.GetCompAbsolute(): boolean;
begin
  FCritical.Enter();
  try
    Result := FCompAbsolute;
  finally
    FCritical.Leave();
  end;
end;

function TSettings.GetCompCRC(): boolean;
begin
  FCritical.Enter();
  try
    Result := FCompCRC;
  finally
    FCritical.Leave();
  end;
end;

function TSettings.GetCompOEM(): boolean;
begin
  FCritical.Enter();
  try
    Result := FCompOEM;
  finally
    FCritical.Leave();
  end;
end;

function TSettings.GetCompUseTaskName(): boolean;
begin
  FCritical.Enter();
  try
    Result := FCompUseTaskName;
  finally
    FCritical.Leave();
  end;
end;

function TSettings.GetCopyAttributes(): boolean;
begin
  FCritical.Enter();
  try
    Result := FCopyAttributes;
  finally
    FCritical.Leave();
  end;
end;

function TSettings.GetCopyBuffer(): integer;
begin
  FCritical.Enter();
  try
    Result := FCopyBuffer;
  finally
    FCritical.Leave();
  end;
end;

function TSettings.GetCopyNTFSPermissions(): boolean;
begin
  FCritical.Enter();
  try
    Result := FCopyNTFSPermissions;
  finally
    FCritical.Leave();
  end;
end;

function TSettings.GetCopyTimeStamps(): boolean;
begin
  FCritical.Enter();
  try
    Result := FCopyTimeStamps;
  finally
    FCritical.Leave();
  end;
end;

function TSettings.GetLanguage(): WideString;
begin
  FCritical.Enter();
  try
    Result := FLanguage;
  finally
    FCritical.Leave();
  end;
end;

function TSettings.GetList(): WideString;
begin
  FCritical.Enter();
  try
    Result := FCurrentList;
  finally
    FCritical.Leave();
  end;
end;

function TSettings.GetLog(): boolean;
begin
  FCritical.Enter();
  try
    Result:= FLog;
  finally
    FCritical.Leave();
  end;
end;

function TSettings.GetLogErrorsOnly(): boolean;
begin
  FCritical.Enter();
  try
    Result:= FLogErrorsOnly;
  finally
    FCritical.Leave();
  end;
end;

function TSettings.GetLogRealTime(): boolean;
begin
  FCritical.Enter();
  try
    Result:= FLogRealTime;
  finally
    FCritical.Leave();
  end;
end;

function TSettings.GetLogVerbose(): boolean;
begin
  FCritical.Enter();
  try
    Result:= FLogVerbose;
  finally
    FCritical.Leave();
  end;
end;

function TSettings.GetLowPriority(): boolean;
begin
  FCritical.Enter();
  try
    Result:= FLowPriority;
  finally
    FCritical.Leave();
  end;
end;

function TSettings.GetMailAfterBackup(): boolean;
begin
  FCritical.Enter();
  try
    Result:= FMailAfterBackup;
  finally
    FCritical.Leave();
  end;
end;

function TSettings.GetMailAsAttachment(): boolean;
begin
  FCritical.Enter();
  try
    Result:= FMailAsAttachment;
  finally
    FCritical.Leave();
  end;
end;

function TSettings.GetMailDateTime(): TDateTime;
begin
  FCritical.Enter();
  try
    Result:= FMailDateTime;
  finally
    FCritical.Leave();
  end;
end;

function TSettings.GetMailDelete(): boolean;
begin
  FCritical.Enter();
  try
    Result:= FMailDelete;
  finally
    FCritical.Leave();
  end;
end;

function TSettings.GetMailIfErrorsOnly(): boolean;
begin
  FCritical.Enter();
  try
    Result:= FMailIfErrorsonly;
  finally
    FCritical.Leave();
  end;
end;

function TSettings.GetMailLog(): boolean;
begin
  FCritical.Enter();
  try
    Result:= FMailLog;
  finally
    FCritical.Leave();
  end;
end;

function TSettings.GetMailScheduled(): boolean;
begin
  FCritical.Enter();
  try
    Result:= FMailScheduled;
  finally
    FCritical.Leave();
  end;
end;

function TSettings.GetParkFirstBackup(): boolean;
begin
  FCritical.Enter();
  try
    Result:= FParkFirstBackup;
  finally
    FCritical.Leave();
  end;
end;

function TSettings.GetPassword(): WideString;
begin
  FCritical.Enter();
  try
    Result:= FPassword;
  finally
    FCritical.Leave();
  end;
end;

function TSettings.GetPropagateMasks(): boolean;
begin
  FCritical.Enter();
  try
    Result:= FPropagateMasks;
  finally
    FCritical.Leave();
  end;
end;

function TSettings.GetProtectMainWindow: boolean;
begin
  FCritical.Enter();
  try
    Result:= FProtectMainWindow;
  finally
    FCritical.Leave();
  end;
end;

function TSettings.GetProtectUI(): boolean;
begin
  FCritical.Enter();
  try
    Result:= FProtectUI;
  finally
    FCritical.Leave();
  end;
end;

function TSettings.GetRunOldDontAsk(): boolean;
begin
  FCritical.Enter();
  try
    Result:= FRunDontAsk;
  finally
    FCritical.Leave();
  end;
end;

function TSettings.GetRunOldBackups(): boolean;
begin
  FCritical.Enter();
  try
    Result:= FRunOldBackups;
  finally
    FCritical.Leave();
  end;
end;

function TSettings.GetShowExactPercent(): boolean;
begin
  FCritical.Enter();
  try
    Result:= FShowExactPercent;
  finally
    FCritical.Leave();
  end;
end;

function TSettings.GetShutdownKill(): boolean;
begin
  FCritical.Enter();
  try
    Result:= FShutDownKill;
  finally
    FCritical.Leave();
  end;
end;

function TSettings.GetSMTPAuthentication(): integer;
begin
  FCritical.Enter();
  try
    Result:= FSMTPAuhentification;
  finally
    FCritical.Leave();
  end;
end;

function TSettings.GetSMTPDestination: WideString;
begin
  FCritical.Enter();
  try
    Result:= FSMTPDestination;
  finally
    FCritical.Leave();
  end;
end;

function TSettings.GetSMTPEhlo(): boolean;
begin
  FCritical.Enter();
  try
    Result:= FSMTPUseEhlo;
  finally
    FCritical.Leave();
  end;
end;

function TSettings.GetSMTPHelo(): WideString;
begin
  FCritical.Enter();
  try
    Result:= FSMTPHeloName;
  finally
    FCritical.Leave();
  end;
end;

function TSettings.GetSMTPHost(): WideString;
begin
  FCritical.Enter();
  try
    Result:= FSMTPHost;
  finally
    FCritical.Leave();
  end;
end;

function TSettings.GetSMTPID(): WideString;
begin
  FCritical.Enter();
  try
    Result:= FSMTPID;
  finally
    FCritical.Leave();
  end;
end;

function TSettings.GetSMTPPassword(): WideString;
begin
  FCritical.Enter();
  try
    Result:= FSMTPPassword;
  finally
    FCritical.Leave();
  end;
end;

function TSettings.GetSMTPPipeLine(): boolean;
begin
  FCritical.Enter();
  try
    Result:= FSMTPPipeLine;
  finally
    FCritical.Leave();
  end;
end;

function TSettings.GetSMTPPort(): integer;
begin
  FCritical.Enter();
  try
    Result:= FSMTPPort;
  finally
    FCritical.Leave();
  end;
end;

function TSettings.GetSMTPSender(): WideString;
begin
  FCritical.Enter();
  try
    Result:= FSMTPSender;
  finally
    FCritical.Leave();
  end;
end;

function TSettings.GetSMTPSenderAddress(): WideString;
begin
  FCritical.Enter();
  try
    Result:= FSMTPSenderAddress;
  finally
    FCritical.Leave();
  end;
end;

function TSettings.GetSMTPSubject(): WideString;
begin
  FCritical.Enter();
  try
    Result:= FSMTPSubject;
  finally
    FCritical.Leave();
  end;
end;

function TSettings.GetSQXDictionary(): integer;
begin
  FCritical.Enter();
  try
    Result:= FSQXDictionary;
  finally
    FCritical.Leave();
  end;
end;

function TSettings.GetSQXExe(): boolean;
begin
  FCritical.Enter();
  try
    Result:= FSQXExe;
  finally
    FCritical.Leave();
  end;
end;

function TSettings.GetSQXExternal(): boolean;
begin
  FCritical.Enter();
  try
    Result:= FSQXExternal;
  finally
    FCritical.Leave();
  end;
end;

function TSettings.GetSQXLevel(): integer;
begin
  FCritical.Enter();
  try
    Result:= FSQXLevel;
  finally
    FCritical.Leave();
  end;
end;

function TSettings.GetSQXMultimedia(): boolean;
begin
  FCritical.Enter();
  try
    Result:= FSQXMultimedia;
  finally
    FCritical.Leave();
  end;
end;

function TSettings.GetSQXRecovery(): integer;
begin
  FCritical.Enter();
  try
    Result:= FSQXRecovery;
  finally
    FCritical.Leave();
  end;
end;

function TSettings.GetSQXSolid(): boolean;
begin
  FCritical.Enter();
  try
    Result:= FSQXSolid;
  finally
    FCritical.Leave();
  end;
end;

procedure TSettings.GetTaskPointer(const Index: integer; var DestTask: TTask);
begin
 // Do NOT use this in a multithreaded case (engine)
  with TaskList.LockList() do
  try
    DestTask:= nil;
    if (Index>=0) and (Index < Count) then
      DestTask:= Items[Index];
  finally
    TaskList.UnlockList();
  end;
end;

function TSettings.GetTaskCount(): integer;
begin
  with TaskList.LockList() do
  try
    Result:= Count;
  finally
    TaskList.UnlockList();
  end;
end;

procedure TSettings.GetTaskPointer(const ID: WideString; var DestTask: TTask);
var
  i: integer;
  Found: boolean;
begin
  // Do NOT use this in a multithreaded case  (engine)
  with TaskList.LockList() do
  try
    Found:= false;
    for i:=0 to Count - 1 do
    begin
      DestTask:= Items[i];
      if (DestTask.ID = ID) then
      begin
        Found:= true;
        Break;
      end;
    end;
    if (Found = false) then
      DestTask:= nil;
  finally
    TaskList.UnlockList();
  end;
end;

function TSettings.GetTasksIDList: WideString;
var
  Sl: TTntStringList;
  i: integer;
  Task: TTask;
begin
  Sl:= TTntStringList.Create();
  with TaskList.LockList() do
  try
    for i:= 0 to Count - 1 do
    begin
      Task:= Items[i];
      Sl.Add(Task.ID);
      Result:= Sl.CommaText;
    end;
  finally
    TaskList.UnlockList();
    FreeAndNil(Sl);
  end;
end;

function TSettings.GetTCPConnectionTimeOut(): integer;
begin
  FCritical.Enter();
  try
    Result:= FTCPConnectTimeOut;
  finally
    FCritical.Leave();
  end;
end;

function TSettings.GetTCPReadTimeOut(): integer;
begin
  FCritical.Enter();
  try
    Result:= FTCPReadTimeOut;
  finally
    FCritical.Leave();
  end;
end;

function TSettings.GetTemp(): WideString;
begin
  FCritical.Enter();
  try
    Result:= FTemp;
  finally
    FCritical.Leave();
  end;
end;

function TSettings.GetUseCurrentDesktop(): boolean;
begin
  FCritical.Enter();
  try
    Result:= FUseCurrentDesktop;
  finally
    FCritical.Leave();
  end;
end;

function TSettings.GetUncompressed(): WideString;
begin
  FCritical.Enter();
  try
    Result:= FUncompressed;
  finally
    FCritical.Leave();
  end;
end;

function TSettings.GetUseAlternativeMethods(): boolean;
begin
  FCritical.Enter();
  try
    Result:= FUseAlternativeMethods;
  finally
    FCritical.Leave();
  end;
end;

function TSettings.GetUseShellFunctionOnly(): boolean;
begin
  FCritical.Enter();
  try
    Result:= FUseShellFunctionOnly;
  finally
    FCritical.Leave();
  end;
end;

function TSettings.GetZip64(): integer;
begin
  FCritical.Enter();
  try
    Result:= FZip64;
  finally
    FCritical.Leave();
  end;
end;

function TSettings.GetZipAdvancedNaming(): boolean;
begin
  FCritical.Enter();
  try
    Result:= FZipAdvancedNaming;
  finally
    FCritical.Leave();
  end;
end;

function TSettings.GetZipLevel(): integer;
begin
  FCritical.Enter();
  try
    Result:= FZipLevel;
  finally
    FCritical.Leave();
  end;
end;

procedure TSettings.LoadList();
var
  i: integer;
  Sl, SlTask: TTntStringList;
  Task: TTask;
begin
  ClearList();
  Sl:= TTntStringList.Create();
  SlTask:= TTntStringList.Create();
  if (WaitForSingleObject(FMutexList, INFINITE) = WAIT_OBJECT_0) then
  begin
    with TaskList.LockList() do
    try
      if (WideFileExists(FCurrentList)) then
        Sl.LoadFromFile(FCurrentList) else
        begin
          CobCreateEmptyTextFileW(FCurrentList);
          GetFullAccess(FCurrentList);
        end;
      for i:= 0 to Sl.Count - 1 do
      begin
        if (Sl[i] = WS_TASKBEGIN) then
        begin
          SlTask.Clear();
          SlTask.Add(Sl[i]);
        end else
        if (Sl[i] = WS_TASKEND) then
        begin
          SlTask.Add(Sl[i]);
          Task:= TTask.Create();
          Task.StrToTaskW(SlTask.CommaText);
          Add(Task);
        end else
        SlTask.Add(Sl[i]);
      end;
    finally
      TaskList.UnlockList();
      ReleaseMutex(FMutexList);
      FreeAndNil(SlTask);
      FreeAndNil(Sl);
    end;
  end;
end;

procedure TSettings.LoadSettings();
var
  Sl: TTntStringList;
  SOut: WideString;
  OK: boolean;
begin
  Sl := TTntStringList.Create();
  if (WaitForSingleObject(FMutexIni, INFINITE) = WAIT_OBJECT_0) then
  try
    Sl.LoadFromFile(FIniFileName);
    SetList(Sl.Values[WS_INICURRENTLIST]);
    SetLanguage(Sl.Values[WS_INILANGUAGE]);
    SetLog(CobStrToBoolW(Sl.Values[WS_INILOG]));
    SetLogErrorsOnly(CobStrToBoolW(Sl.Values[WS_INILOGERRORSONLY]));
    SetLogVerbose(CobStrToBoolW(Sl.Values[WS_INILOGVERBOSE]));
    SetLogRealTime(CobStrToBoolW(Sl.Values[WS_INILOGREALTIME]));
    if (CobDecryptStringW(Sl.Values[WS_INIPASSWORD],WS_LLAVE,SOut)) then
      SetPassword(SOut) else
      SetPassword(WS_NIL);
    SetProtectUI(CobStrToBoolW(Sl.Values[WS_INIPROTECTUI]));
    SetProtectMainWindow(CobStrToBoolW(Sl.Values[WS_INIPROTECTMAINWINDOW]));
    SetClearPasswordCache(CobStrToBoolW(Sl.Values[WS_INICLEARPASSWORDCACHE]));
    SetMailLog(CobStrToBoolW(Sl.Values[WS_INIMAILLOG]));
    SetMailAfterBackup(CobStrToBoolW(Sl.Values[WS_INIMAILAFTERBACKUP]));
    SetMailScheduled(CobStrToBoolW(Sl.Values[WS_INIMAILSCHEDULED]));
    SetMailAsAttachment(CobStrToBoolW(Sl.Values[WS_INIMAILASATTACMMENT]));
    SetMailIfErrorsonly(CobStrToBoolW(Sl.Values[WS_INIMAILIFERRORSONLY]));
    SetMailDelete(CobStrToBoolW(Sl.Values[WS_INIMAILDELETE]));
    SetMailDateTime(CobBinToDoubleW(Sl.Values[WS_INIMAILDATETIME],OK));
    if (not OK) then
      SetMailDateTime(Now());
    SetSMTPSender(Sl.Values[WS_INISMTPSENDER]);
    SetSMTPSenderAddress(Sl.Values[WS_INISMTPSENDERADDRESS]);
    SetSMTPDestination(Sl.Values[WS_INISMTPDESTINATION]);
    SetSMTPHost(Sl.Values[WS_INISMTPHOST]);
    SetSMTPPort(CobStrToIntW(Sl.Values[WS_INISMTPPORT], INT_SMTPPORT));
    SetSMTPSubject(Sl.Values[WS_INISMTPSUBJECT]);
    SetSMTPAuthentication(CobStrToIntW(Sl.Values[WS_INISMTPAUTHENTICATION],INT_SMTPNOLOGON));
    SetSMTPID(Sl.Values[WS_INISMTPID]);
    if (CobDecryptStringW(Sl.Values[WS_INISMTPPASSWORD],WS_LLAVE,SOut)) then
      SetSMTPPassword(SOut) else
      SetSMTPPassword(WS_NIL);
    SetSMTPHelo(Sl.Values[WS_INISMTPHELONAME]);
    SetSMTPPipeLine(CobStrToBoolW(Sl.Values[WS_INISMTPPIPELINE]));
    SetSMTPEhlo(CobStrToBoolW(Sl.Values[WS_INISMTPEHLO]));
    SetTCPConnectionTimeOut(CobStrToIntW(Sl.Values[WS_INITCPCONNECTION], INT_TCPDEFAULTTIMEOUT));
    SetTCPReadTimeOut(CobStrToIntW(Sl.Values[WS_INITCPREAD], INT_TCPDEFAULTTIMEOUT));
    SetTemp(Sl.Values[WS_INITEMP]);
    SetShowExactPercent(CobStrToBoolW(Sl.Values[WS_INISHOWEXACTPERCENT]));
    SetUseCurrentDesktop(CobStrToBoolW(Sl.Values[WS_INIUSECURRENTDESKTOP]));
    SetForceFirstFull(CobStrToBoolW(Sl.Values[WS_INIFORCEFIRSTFULL]));
    SetDateTimeFormat(Sl.Values[WS_INIDATETIMEFORMAT]);
    SetDoNotSeparateDate(CobStrToBoolW(Sl.Values[WS_INIDONOTSEPARATEDATE]));
    SetDoNotUseSpaces(CobStrToBoolW(Sl.Values[WS_INIDONOTUSESPACES]));
    SetUseShellFunctionOnly(CobStrToBoolW(Sl.Values[WS_INIUSESHELL]));
    SetUseAlternativeMethods(CobStrToBoolW(Sl.Values[WS_INIUSEALTERNATIVEMETHODS]));
    SetLowPriority(CobStrToBoolW(Sl.Values[WS_INILOWPRIORITY]));
    SetCopyBuffer(CobStrToIntW(Sl.Values[WS_INICOPYBUFFER],INT_COPYBUFFER));
    SetCheckCRCNoComp(CobStrToBoolW(Sl.Values[WS_INICHECKCRCNOCOMP]));
    SetCopyAttributes(CobStrToBoolW(Sl.Values[WS_INICOPYATTRIBUTES]));
    SetCopyTimeStamps(CobStrToBoolW(Sl.Values[WS_INICOPYTOMESTAMPS]));
    SetCopyNTFSPermissions(CobStrToBoolW(Sl.Values[WS_INICOPYNTFS]));
    SetParkFirstBackup(CobStrToBoolW(Sl.Values[WS_INIPARKFIRSTBACKUP]));
    SetDeleteEmptyFolders(CobStrToBoolW(Sl.Values[WS_INIDELETEEMPTYFOLDERS]));
    SetAlwaysCreateFolder(CobStrToBoolW(Sl.Values[WS_INIALWAYSCREATEFOLDER]));
    SetCompAbsolute(CobStrToBoolW(Sl.Values[WS_INICOMPRESIONABSOLUTE]));
    SetZipLevel(CobStrToIntW(Sl.Values[WS_INIZIPLEVEL],INT_DEFZIPCOMPRESSION));
    SetCompUseTaskName(CobStrToBoolW(Sl.Values[WS_INICOMPUSETASKNAME]));
    SetCompCRC(CobStrToBoolW(Sl.Values[WS_INICOMPCRC]));
    SetZipAdvancedNaming(CobStrToBoolW(Sl.Values[WS_INIZIPADVANCEDNAMING]));
    SetCompOEM(CobStrToBoolW(Sl.Values[WS_INICOMPOEM]));
    SetZip64(CobStrToIntW(Sl.Values[WS_INIZIP64], INT_ZIP64AUTO));
    SetUncompressed(Sl.Values[WS_INICOMPUNCOMPRESSED]);
    SetSQXDictionary(CobStrToIntW(Sl.Values[WS_INISQXDICTIONARY], INT_SQXDEFDICTIONARY));
    SetSQXLevel(CobStrToIntW(Sl.Values[WS_INISQXLEVEL],INT_SQXDEFLEVEL));
    SetSQXRecovery(CobStrToIntW(Sl.Values[WS_INISQXRECOVERY], INT_SQXDEFRECOVERY));
    SetSQXSolid(CobStrToBoolW(Sl.Values[WS_INISQXSOLID]));
    SetSQXMultimedia(CobStrToBoolW(Sl.Values[WS_INISQXMULTIMEDIA]));
    SetSQXExe(CobStrToBoolW(Sl.Values[WS_INISQXEXE]));
    SetSQXExternal(CobStrToBoolW(Sl.Values[WS_INISQXEXTERNAL]));
    SetFTPSpeedLimit(CobStrToBoolW(SL.Values[WS_INIFTPLIMIT]));
    SetFTPSpeed(CobStrToIntW(Sl.Values[WS_INIFTPSPEED], INT_FTPDEFSPEED));
    SetFTPASCII(Sl.Values[WS_INIFTPASCII]);
    SetShutdownKill(CobStrToBoolW(Sl.Values[WS_INISHUTDOWNKILL]));
    SetAutoUpdate(CobStrToBoolW(Sl.Values[WS_INIAUTOCHECK]));
    SetRunOldBackups(CobStrToBoolW(Sl.Values[WS_INIRUNOLD]));
    SetRunOldDontAsk(CobStrToBoolW(Sl.Values[WS_INIRUNOLDDONTASK]));
    SetPropagateMasks(CobStrToBoolW(Sl.Values[WS_INIPROPAGATEMASKS]));
  finally
    FreeAndNil(Sl);
    ReleaseMutex(FMutexIni);
  end;
end;


procedure TSettings.RenameTasksID();
var
  Sl: TTntStringList;
  OldID: WideString;
  i, j: integer;
  Task: TTask;
  Backup: TBackup;
begin
  // 2005-11-15, iWhen saving a list As, be sure to
  // change the ID of the tasks because this can mess
  // the history
  Sl:= TTntStringList.Create();
  Backup:= TBackup.Create(WS_NIL);
  with TaskList.LockList() do
  try
    for i:= 0 to Count - 1 do
    begin
      Task:= Items[i];
      OldID:= Task.ID;
      // set the new ID
      Task.ID:= CobGetUniqueNameW();
      // Copy the history
      Sl.Clear();
      if (WideFileExists(FDBPath + OldID + WS_HISTORYEXT)) then
      begin
        Sl.LoadFromFile(FDBPath + OldID + WS_HISTORYEXT);
        for j:= 0 to Sl.Count - 1 do
        begin
          Backup.StrToBackupW(Sl[j]);
          Backup.FTaskID:= Task.ID;
          Sl[j]:= Backup.BackupToStrW();
        end;
        Sl.SaveToFile(FDBPath + Task.ID + WS_HISTORYEXT);
        GetFullAccess(FDBPath + Task.ID + WS_HISTORYEXT);
      end;
    end;
  finally
    TaskList.UnlockList();
    FreeAndNil(Backup);
    FreeAndNil(Sl);
  end;
end;

procedure TSettings.SaveList();
var
  Sl, SlTask: TTntStringList;
  i: integer;
  Task: TTask;
begin
  Sl:= TTntStringList.Create();
  SlTask:= TTntStringList.Create();
  if (WaitForSingleObject(FMutexList, INFINITE) = WAIT_OBJECT_0) then
  begin
    with TaskList.LockList() do
    try
      for i:=0 to Count - 1 do
        begin
          Task:= Items[i];
          if (Task <> nil) then
            begin
              SlTask.CommaText:= Task.TaskToStrW();
              Sl.AddStrings(SlTask);
            end;
        end;
      Sl.SaveToFile(FCurrentList);
      GetFullAccess(FCurrentList);
    finally
      TaskList.UnlockList();
      ReleaseMutex(FMutexList);
      FreeAndNil(SlTask);
      FreeAndNil(Sl);
    end;
  end;
end;

procedure TSettings.SaveSettings(const Std: boolean);
var
  Sl: TTntStringList;
  SOut: WideString;
begin
  Sl := TTntStringList.Create();
  if (WaitForSingleObject(FMutexIni, INFINITE) = WAIT_OBJECT_0) then
  try
    if (Std) then
      begin
        // Set the default values
        SetList(GetDefaultListName());
        SetLanguage(WS_DEFAULTLANGUAGE);
        SetLog(true);
        SetLogErrorsOnly(false);
        SetLogVerbose(false);
        SetLogRealTime(true);
        SetPassword(WS_NIL);
        SetProtectUI(false);
        SetProtectMainWindow(false);
        SetClearPasswordCache(true);
        SetMailLog(false);
        SetMailAfterbackup(false);
        SetMailScheduled(true);
        SetMailAsAttachment(true);
        SetMailIfErrorsonly(false);
        SetMailDelete(true);
        SetMailDateTime(Now());
        SetSMTPSender(WideFormat(WS_DEFSENDER,[WS_PROGRAMNAMESHORT,WS_PARCOMPUTERNAME],FS));
        SetSMTPSenderAddress(WS_NIL);
        SetSMTPDestination(WS_NIL);
        SetSMTPHost(WS_NIL);
        SetSMTPPort(INT_SMTPPORT);
        SetSMTPSubject(WideFormat(WS_DEFSUBJECT,[WS_PROGRAMNAMESHORT,
                      WS_PARCOMPUTERNAME,WS_PARAMDATE],FS));
        SetSMTPAuthentication(INT_SMTPNOLOGON);
        SetSMTPID(WS_NIL);
        SetSMTPPassword(WS_NIL);
        SetSMTPHelo(WS_NIL);
        SetSMTPPipeLine(true);
        SetSMTPEhlo(true);
        SetTCPConnectionTimeOut(INT_TCPDEFAULTTIMEOUT);
        SetTCPReadTimeOut(INT_TCPDEFAULTTIMEOUT);
        SetTemp(CobGetSpecialDirW(cobTemporary));
        SetShowExactPercent(true);
        SetUseCurrentDesktop(true);
        SetForceFirstFull(true);
        SetDateTimeFormat(WS_STDDATETIMEFORMAT);
        SetDoNotSeparateDate(false);
        SetDoNotUseSpaces(false);
        SetUseShellFunctionOnly(false);
        SetUseAlternativeMethods(true);
        SetLowPriority(false);
        SetCopyBuffer(INT_COPYBUFFER);
        SetCheckCRCNoComp(false);
        SetCopyAttributes(true);
        SetCopyTimeStamps(true);
        SetCopyNTFSPermissions(false);   // It could give some problems for newbies
        SetParkFirstBackup(true);
        SetDeleteEmptyFolders(false);
        SetAlwaysCreateFolder(true);
        SetCompAbsolute(false);
        SetZipLevel(INT_DEFZIPCOMPRESSION);
        SetCompUseTaskName(false);
        SetCompCRC(true);
        SetZipAdvancedNaming(false);
        SetCompOEM(true);
        SetZip64(INT_ZIP64AUTO);
        SetUncompressed(WS_DEFUNCOMPRESSED);
        SetSQXDictionary(INT_SQXDEFDICTIONARY);
        SetSQXLevel(INT_SQXDEFLEVEL);
        SetSQXRecovery(INT_SQXDEFRECOVERY);
        SetSQXSolid(false);
        SetSQXMultimedia(true);
        SetSQXExe(true);
        SetSQXExternal(false);
        SetFTPSpeedLimit(false);
        SetFTPSpeed(INT_FTPDEFSPEED);
        SetFTPASCII(WS_ASCIIDEF);
        SetShutdownKill(false);
        SetAutoUpdate(true);
        SetRunOldBackups(false);
        SetRunOldDontAsk(false);
        SetPropagateMasks(false);
      end;;
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INICURRENTLIST,GetList()],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INILANGUAGE,GetLanguage()],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INILOG, CobBoolToStrW(GetLog())],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INILOGERRORSONLY, CobBoolToStrW(GetLogErrorsOnly())],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INILOGVERBOSE, CobBoolToStrW(GetLogVerbose())],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INILOGREALTIME, CobBoolToStrW(GetLogRealTime())],FS));
    if CobEncryptStringW(GetPassword(),WS_LLAVE,SOut) then
      Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIPASSWORD,SOut],FS)) else
      Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIPASSWORD,WS_NIL],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIPROTECTUI, CobBoolToStrW(GetProtectUI())],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIPROTECTMAINWINDOW, CobBoolToStrW(GetProtectMainWindow())],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INICLEARPASSWORDCACHE,
                              CobBoolToStrW(GetClearPasswordCache())],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIMAILLOG, CobBoolToStrW(GetMailLog())],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIMAILAFTERBACKUP, CobBoolToStrW(GetMailAfterBackup())],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIMAILSCHEDULED, CobBoolToStrW(GetMailScheduled())],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIMAILASATTACMMENT, CobBoolToStrW(GetMailAsAttachment())],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIMAILIFERRORSONLY, CobBoolToStrW(GetMailIfErrorsOnly())],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIMAILDELETE, CobBoolToStrW(GetMailDelete())],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIMAILDATETIME, CobDoubleToBinW(GetMailDateTime())],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INISMTPSENDER,GetSMTPSender()],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INISMTPSENDERADDRESS,GetSMTPSenderAddress()],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INISMTPDESTINATION,GetSMTPDestination()],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INISMTPHOST,GetSMTPHost()],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INISMTPPORT,CobIntToStrW(GetSMTPPort())],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INISMTPSUBJECT,GetSMTPSubject()],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INISMTPAUTHENTICATION,CobIntToStrW(GetSMTPAuthentication())],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INISMTPID,GetSMTPID()],FS));
    if CobEncryptStringW(GetSMTPPassword(),WS_LLAVE,SOut) then
      Sl.Add(WideFormat(WS_INIFORMAT,[WS_INISMTPPASSWORD,SOut],FS)) else
      Sl.Add(WideFormat(WS_INIFORMAT,[WS_INISMTPPASSWORD,WS_NIL],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INISMTPHELONAME,GetSMTPHelo()],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INISMTPPIPELINE,CobBoolToStrW(GetSMTPPipeLine())],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INISMTPEHLO,CobBoolToStrW(GetSMTPEhlo())],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INITCPREAD,CobIntToStrW(GetTCPReadTimeOut())],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INITCPCONNECTION,CobIntToStrW(GetTCPConnectionTimeOut())],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INITEMP,GetTemp()],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INISHOWEXACTPERCENT,
                                      CobBoolToStrW(GetShowExactPercent())],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIUSECURRENTDESKTOP,
                                      CobBoolToStrW(GetUseCurrentDesktop())], FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIFORCEFIRSTFULL,
                                    CobBoolToStrW(GetForceFirstFull())],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIDATETIMEFORMAT, GetDateTimeFormat()],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIDONOTSEPARATEDATE,CobBoolToStrW(GetDoNotSeparateDate())],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIDONOTUSESPACES,CobBoolToStrW(GetDoNotUseSpaces())],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIUSESHELL, CobBoolToStrW(GetUseShellFunctionOnly())],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIUSEALTERNATIVEMETHODS, CobBoolToStrW(GetUseAlternativeMethods())],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INILOWPRIORITY, CobBoolToStrW(GetLowPriority())],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INICOPYBUFFER,CobIntToStrW(GetCopyBuffer())],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INICHECKCRCNOCOMP,CobBoolToStrW(GetCheckCRCNoComp())],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INICOPYATTRIBUTES,CobBoolToStrW(GetCopyAttributes())],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INICOPYTOMESTAMPS,CobBoolToStrW(GetCopyTimeStamps())],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INICOPYNTFS,CobBoolToStrW(GetCopyNTFSPermissions())],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIPARKFIRSTBACKUP,CobBoolToStrW(GetParkFirstBackup())],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIDELETEEMPTYFOLDERS,CobBoolToStrW(GetDeleteEmptyFolders())],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIALWAYSCREATEFOLDER,CobBoolToStrW(GetAlwaysCreateFolder())],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INICOMPRESIONABSOLUTE, CobBoolToStrW(GetCompAbsolute())],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIZIPLEVEL, CobIntToStrW(GetZipLevel())],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INICOMPUSETASKNAME,CobBoolToStrW(GetCompUseTaskName())],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INICOMPCRC,CobBoolToStrW(GetCompCRC())],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIZIPADVANCEDNAMING,CobBoolToStrW(GetZipAdvancedNaming())],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INICOMPOEM,CobBoolToStrW(GetCompOEM())],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIZIP64, CobIntToStrW(GetZip64())],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INICOMPUNCOMPRESSED,GetUncompressed()],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INISQXLEVEL,CobIntToStrW(GetSQXLevel())],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INISQXDICTIONARY,CobIntToStrW(GetSQXDictionary())],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INISQXRECOVERY,CobIntToStrW(GetSQXRecovery())],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INISQXEXTERNAL,CobBoolToStrW(GetSQXExternal())],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INISQXEXE,CobBoolToStrW(GetSQXExe())],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INISQXMULTIMEDIA,CobBoolToStrW(GetSQXMultimedia())],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INISQXSOLID,CobBoolToStrW(GetSQXSolid())],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIFTPLIMIT,CobBoolToStrW(GetFTPSpeedLimit())],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIFTPSPEED,CobIntToStrW(GetFTPSpeed())],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIFTPASCII,GetFTPASCII()],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INISHUTDOWNKILL,CobBoolToStrW(GetShutdownKill())],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIAUTOCHECK, CobBoolToStrW(GetAutoUpdate())],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIRUNOLD, CobBoolToStrW(GetRunOldBackups())],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIRUNOLDDONTASK, CobBoolToStrW(GetRunOldDontAsk())],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIPROPAGATEMASKS,CobBoolToStrW(GetPropagateMasks())],FS));
    Sl.SaveToFile(FIniFileName);
    GetFullAccess(FIniFileName);
  finally
    FreeAndNil(Sl);
    ReleaseMutex(FMutexIni);
  end;
end;

procedure TSettings.SetAlwaysCreateFolder(const Value: boolean);
begin
  FCritical.Enter();
  try
    if (Value <> FAlwaysCreateFolder) then
      FAlwaysCreateFolder := Value;
  finally
    FCritical.Leave();
  end;
end;

procedure TSettings.SetAutoUpdate(const Value: boolean);
begin
  FCritical.Enter();
  try
    if (Value <> FAutoCheck) then
      FAutoCheck := Value;
  finally
    FCritical.Leave();
  end;
end;

procedure TSettings.SetCheckCRCNoComp(const Value: boolean);
begin
  FCritical.Enter();
  try
    if (Value <> FCheckCRCNoComp) then
      FCheckCRCNoComp := Value;
  finally
    FCritical.Leave();
  end;
end;

procedure TSettings.SetClearPasswordCache(const Value: boolean);
begin
  FCritical.Enter();
  try
    if (Value <> FClearPasswordCache) then
      FClearPasswordCache := Value;
  finally
    FCritical.Leave();
  end;
end;

procedure TSettings.SetCompAbsolute(const Value: boolean);
begin
  FCritical.Enter();
  try
    if (Value <> FCompAbsolute) then
      FCompAbsolute := Value;
  finally
    FCritical.Leave();
  end;
end;

procedure TSettings.SetCompCRC(const Value: boolean);
begin
  FCritical.Enter();
  try
    if (Value <> FCompCRC) then
      FCompCRC := Value;
  finally
    FCritical.Leave();
  end;
end;

procedure TSettings.SetCompOEM(const Value: boolean);
begin
  FCritical.Enter();
  try
    if (Value <> FCompOEM) then
      FCompOEM := Value;
  finally
    FCritical.Leave();
  end;
end;

procedure TSettings.SetCompUseTaskName(const Value: boolean);
begin
  FCritical.Enter();
  try
    if (Value <> FCompUseTaskName) then
      FCompUseTaskName := Value;
  finally
    FCritical.Leave();
  end;
end;

procedure TSettings.SetCopyAttributes(const Value: boolean);
begin
  FCritical.Enter();
  try
    if (Value <> FCopyAttributes) then
      FCopyAttributes := Value;
  finally
    FCritical.Leave();
  end;
end;

procedure TSettings.SetCopyBuffer(const Value: integer);
begin
  FCritical.Enter();
  try
    if (Value <> FCopyBuffer) then
      FCopyBuffer := Value;
  finally
    FCritical.Leave();
  end;
end;

procedure TSettings.SetCopyNTFSPermissions(const Value: boolean);
begin
  FCritical.Enter();
  try
    if (Value <> FCopyNTFSPermissions) then
      FCopyNTFSPermissions := Value;
  finally
    FCritical.Leave();
  end;
end;

procedure TSettings.SetCopyTimeStamps(const Value: boolean);
begin
  FCritical.Enter();
  try
    if (Value <> FCopyTimeStamps) then
      FCopyTimeStamps := Value;
  finally
    FCritical.Leave();
  end;
end;

procedure TSettings.SetDateTimeFormat(const Value: WideString);
begin
  FCritical.Enter();
  try
    if (Value <> FDateTimeFormat) then
      FDateTimeFormat := Value;
  finally
    FCritical.Leave();
  end;
end;

procedure TSettings.SetDeleteEmptyFolders(const Value: boolean);
begin
  FCritical.Enter();
  try
    if (Value <> FDeleteEmptyFolders) then
      FDeleteEmptyFolders := Value;
  finally
    FCritical.Leave();
  end;
end;

procedure TSettings.SetDoNotSeparateDate(const Value: boolean);
begin
  FCritical.Enter();
  try
    if (Value <> FDontSeparateDate) then
      FDontSeparateDate := Value;
  finally
    FCritical.Leave();
  end;
end;

procedure TSettings.SetDoNotUseSpaces(const Value: boolean);
begin
  FCritical.Enter();
  try
    if (Value <> FDoNotUseSpaces) then
      FDoNotUseSpaces := Value;
  finally
    FCritical.Leave();
  end;
end;

procedure TSettings.SetForceFirstFull(const Value: boolean);
begin
  FCritical.Enter();
  try
    if (Value <> FForceFirstFull) then
      FForceFirstFull := Value;
  finally
    FCritical.Leave();
  end;
end;

procedure TSettings.SetFTPASCII(const Value: WideString);
begin
  FCritical.Enter();
  try
    if (Value <> FFTPASCII) then
      FFTPASCII := Value;
  finally
    FCritical.Leave();
  end;
end;

procedure TSettings.SetFTPSpeed(const Value: integer);
begin
  FCritical.Enter();
  try
    if (Value <> FFTPSpeed) then
      FFTPSpeed := Value;
  finally
    FCritical.Leave();
  end;
end;

procedure TSettings.SetFTPSpeedLimit(const Value: boolean);
begin
  FCritical.Enter();
  try
    if (Value <> FFTPSpeedLimit) then
      FFTPSpeedLimit := Value;
  finally
    FCritical.Leave();
  end;
end;

procedure TSettings.SetLanguage(const Value: WideString);
begin
  FCritical.Enter();
  try
    if (Value <> FLanguage) then
      FLanguage := Value;
  finally
    FCritical.Leave();
  end;
end;

procedure TSettings.SetList(const Value: WideString);
begin
  FCritical.Enter();
  try
    if (Value <> FCurrentList) then
      FCurrentList := Value;
  finally
    FCritical.Leave();
  end;
end;

procedure TSettings.SetLog(const Value: boolean);
begin
  FCritical.Enter();
  try
    if (Value <> FLog) then
      FLog:= Value;
  finally
    FCritical.Leave();
  end;
end;

procedure TSettings.SetLogErrorsOnly(const Value: boolean);
begin
  FCritical.Enter();
  try
    if (Value <> FLogErrorsOnly) then
      FLogErrorsOnly:= Value;
  finally
    FCritical.Leave();
  end;
end;

procedure TSettings.SetLogRealTime(const Value: boolean);
begin
  FCritical.Enter();
  try
    if (Value <> FLogRealTime) then
      FLogRealTime:= Value;
  finally
    FCritical.Leave();
  end;
end;

procedure TSettings.SetLogVerbose(const Value: boolean);
begin
  FCritical.Enter();
  try
    if (Value <> FLogVerbose) then
      FLogVerbose:= Value;
  finally
    FCritical.Leave();
  end;
end;

procedure TSettings.SetLowPriority(const Value: boolean);
begin
  FCritical.Enter();
  try
    if (Value <> FLowPriority) then
      FLowPriority:= Value;
  finally
    FCritical.Leave();
  end;
end;

procedure TSettings.SetMailAfterBackup(const Value: boolean);
begin
  FCritical.Enter();
  try
    if (Value <> FMailAfterBackup) then
      FMailAfterBackup:= Value;
  finally
    FCritical.Leave();
  end;
end;

procedure TSettings.SetMailAsAttachment(const Value: boolean);
begin
  FCritical.Enter();
  try
    if (Value <> FMailAsAttachment) then
      FMailAsAttachment:= Value;
  finally
    FCritical.Leave();
  end;
end;

procedure TSettings.SetMailDateTime(const Value: TDateTime);
begin
  FCritical.Enter();
  try
    if (Value <> FMailDateTime) then
      FMailDateTime:= Value;
  finally
    FCritical.Leave();
  end;
end;

procedure TSettings.SetMailDelete(const Value: boolean);
begin
  FCritical.Enter();
  try
    if (Value <> FMailDelete) then
      FMailDelete:= Value;
  finally
    FCritical.Leave();
  end;
end;

procedure TSettings.SetMailIfErrorsonly(const Value: boolean);
begin
  FCritical.Enter();
  try
    if (Value <> FMailIfErrorsonly) then
      FMailIfErrorsonly:= Value;
  finally
    FCritical.Leave();
  end;
end;

procedure TSettings.SetMailLog(const Value: boolean);
begin
  FCritical.Enter();
  try
    if (Value <> FMailLog) then
      FMailLog:= Value;
  finally
    FCritical.Leave();
  end;
end;

procedure TSettings.SetMailScheduled(const Value: boolean);
begin
  FCritical.Enter();
  try
    if (Value <> FMailScheduled) then
      FMailScheduled:= Value;
  finally
    FCritical.Leave();
  end;
end;

procedure TSettings.SetPassword(const Value: WideString);
begin
  FCritical.Enter();
  try
    if (Value <> FPassword) then
      FPassword:= Value;
  finally
    FCritical.Leave();
  end;
end;

procedure TSettings.SetPropagateMasks(const Value: boolean);
begin
  FCritical.Enter();
  try
    if (Value <> FPropagateMasks) then
      FPropagateMasks:= Value;
  finally
    FCritical.Leave();
  end;
end;

procedure TSettings.SetProtectMainWindow(const Value: boolean);
begin
  FCritical.Enter();
  try
    if (Value <> FProtectMainWindow) then
      FProtectMainWindow:= Value;
  finally
    FCritical.Leave();
  end;
end;

procedure TSettings.SetProtectUI(const Value: boolean);
begin
  FCritical.Enter();
  try
    if (Value <> FProtectUI) then
      FProtectUI:= Value;
  finally
    FCritical.Leave();
  end;
end;

procedure TSettings.SetRunOldDontAsk(const Value: boolean);
begin
  FCritical.Enter();
  try
    if (Value <> FRunDontAsk) then
      FRunDontAsk:= Value;
  finally
    FCritical.Leave();
  end;
end;

procedure TSettings.SetRunOldBackups(const Value: boolean);
begin
  FCritical.Enter();
  try
    if (Value <> FRunOldBackups) then
      FRunOldBackups:= Value;
  finally
    FCritical.Leave();
  end;
end;

procedure TSettings.SetShowExactPercent(const Value: boolean);
begin
  FCritical.Enter();
  try
    if (Value <> FShowExactPercent) then
      FShowExactPercent:= Value;
  finally
    FCritical.Leave();
  end;
end;

procedure TSettings.SetShutdownKill(const Value: boolean);
begin
  FCritical.Enter();
  try
    if (Value <> FShutDownKill) then
      FShutDownKill:= Value;
  finally
    FCritical.Leave();
  end;
end;

procedure TSettings.SetSMTPAuthentication(const Value: integer);
begin
  FCritical.Enter();
  try
    if (Value <> FSMTPAuhentification) then
      FSMTPAuhentification:= Value;
  finally
    FCritical.Leave();
  end;
end;

procedure TSettings.SetSMTPDestination(const Value: WideString);
begin
  FCritical.Enter();
  try
    if (Value <> FSMTPDestination) then
      FSMTPDestination:= Value;
  finally
    FCritical.Leave();
  end;
end;

procedure TSettings.SetSMTPEhlo(const Value: boolean);
begin
  FCritical.Enter();
  try
    if (Value <> FSMTPUseEhlo) then
      FSMTPUseEhlo:= Value;
  finally
    FCritical.Leave();
  end;
end;

procedure TSettings.SetSMTPHelo(const Value: WideString);
begin
  FCritical.Enter();
  try
    if (Value <> FSMTPHeloName) then
      FSMTPHeloName:= Value;
  finally
    FCritical.Leave();
  end;
end;

procedure TSettings.SetSMTPHost(const Value: WideString);
begin
  FCritical.Enter();
  try
    if (Value <> FSMTPHost) then
      FSMTPHost:= Value;
  finally
    FCritical.Leave();
  end;
end;

procedure TSettings.SetSMTPID(const Value: WideString);
begin
  FCritical.Enter();
  try
    if (Value <> FSMTPID) then
      FSMTPID:= Value;
  finally
    FCritical.Leave();
  end;
end;

procedure TSettings.SetSMTPPassword(const Value: WideString);
begin
  FCritical.Enter();
  try
    if (Value <> FSMTPPassword) then
      FSMTPPassword:= Value;
  finally
    FCritical.Leave();
  end;
end;

procedure TSettings.SetSMTPPipeLine(const Value: boolean);
begin
  FCritical.Enter();
  try
    if (Value <> FSMTPPipeLine) then
      FSMTPPipeLine:= Value;
  finally
    FCritical.Leave();
  end;
end;

procedure TSettings.SetSMTPPort(const Value: integer);
begin
  FCritical.Enter();
  try
    if (Value <> FSMTPPort) then
      FSMTPPort:= Value;
  finally
    FCritical.Leave();
  end;
end;

procedure TSettings.SetSMTPSender(const Value: WideString);
begin
  FCritical.Enter();
  try
    if (Value <> FSMTPSender) then
      FSMTPSender:= Value;
  finally
    FCritical.Leave();
  end;
end;

procedure TSettings.SetSMTPSenderAddress(const Value: WideString);
begin
  FCritical.Enter();
  try
    if (Value <> FSMTPSenderAddress) then
      FSMTPSenderAddress:= Value;
  finally
    FCritical.Leave();
  end;
end;

procedure TSettings.SetSMTPSubject(const Value: WideString);
begin
  FCritical.Enter();
  try
    if (Value <> FSMTPSubject) then
      FSMTPSubject:= Value;
  finally
    FCritical.Leave();
  end;
end;

procedure TSettings.SetSQXDictionary(const Value: integer);
begin
  FCritical.Enter();
  try
    if (Value <> FSQXDictionary) then
      FSQXDictionary:= Value;
  finally
    FCritical.Leave();
  end;
end;

procedure TSettings.SetSQXExe(const Value: boolean);
begin
  FCritical.Enter();
  try
    if (Value <> FSQXExe) then
      FSQXExe:= Value;
  finally
    FCritical.Leave();
  end;
end;

procedure TSettings.SetSQXExternal(const Value: boolean);
begin
  FCritical.Enter();
  try
    if (Value <> FSQXExternal) then
      FSQXExternal:= Value;
  finally
    FCritical.Leave();
  end;
end;

procedure TSettings.SetSQXLevel(const Value: integer);
begin
  FCritical.Enter();
  try
    if (Value <> FSQXLevel) then
      FSQXLevel:= Value;
  finally
    FCritical.Leave();
  end;
end;

procedure TSettings.SetSQXMultimedia(const Value: boolean);
begin
  FCritical.Enter();
  try
    if (Value <> FSQXMultimedia) then
      FSQXMultimedia:= Value;
  finally
    FCritical.Leave();
  end;
end;

procedure TSettings.SetSQXRecovery(const Value: integer);
begin
  FCritical.Enter();
  try
    if (Value <> FSQXRecovery) then
      FSQXRecovery:= Value;
  finally
    FCritical.Leave();
  end;
end;

procedure TSettings.SetSQXSolid(const Value: boolean);
begin
  FCritical.Enter();
  try
    if (Value <> FSQXSolid) then
      FSQXSolid:= Value;
  finally
    FCritical.Leave();
  end;
end;

procedure TSettings.SetTCPConnectionTimeOut(const Value: integer);
begin
  FCritical.Enter();
  try
    if (Value <> FTCPConnectTimeOut) then
      FTCPConnectTimeOut:= Value;
  finally
    FCritical.Leave();
  end;
end;

procedure TSettings.SetTCPReadTimeOut(const Value: integer);
begin
  FCritical.Enter();
  try
    if (Value <> FTCPReadTimeOut) then
      FTCPReadTimeOut:= Value;
  finally
    FCritical.Leave();
  end;
end;

procedure TSettings.SetTemp(const Value: WideString);
begin
  FCritical.Enter();
  try
    if (Value <> FTemp) then
      FTemp:= Value;
  finally
    FCritical.Leave();
  end;
end;

procedure TSettings.SetParkFirstBackup(const Value: boolean);
begin
  FCritical.Enter();
  try
    if (Value <> FParkFirstBackup) then
      FParkFirstBackup:= Value;
  finally
    FCritical.Leave();
  end;
end;

procedure TSettings.SetUseCurrentDesktop(const Value: boolean);
begin
  FCritical.Enter();
  try
    if (Value <> FUseCurrentDesktop) then
      FUseCurrentDesktop:= Value;
  finally
    FCritical.Leave();
  end;
end;

procedure TSettings.SetUncompressed(const Value: WideString);
begin
  FCritical.Enter();
  try
    if (Value <> FUncompressed) then
      FUncompressed:= Value;
  finally
    FCritical.Leave();
  end;
end;

procedure TSettings.SetUseAlternativeMethods(const Value: boolean);
begin
  FCritical.Enter();
  try
    if (Value <> FUseAlternativeMethods) then
      FUseAlternativeMethods:= Value;
  finally
    FCritical.Leave();
  end;
end;

procedure TSettings.SetUseShellFunctionOnly(const Value: boolean);
begin
  FCritical.Enter();
  try
    if (Value <> FUseShellFunctionOnly) then
      FUseShellFunctionOnly:= Value;
  finally
    FCritical.Leave();
  end;
end;

procedure TSettings.SetZip64(const Value: integer);
begin
  FCritical.Enter();
  try
    if (Value <> FZip64) then
      FZip64:= Value;
  finally
    FCritical.Leave();
  end;
end;

procedure TSettings.SetZipAdvancedNaming(const Value: boolean);
begin
  FCritical.Enter();
  try
    if (Value <> FZipAdvancedNaming) then
      FZipAdvancedNaming:= Value;
  finally
    FCritical.Leave();
  end;
end;

procedure TSettings.SetZipLevel(const Value: integer);
begin
  FCritical.Enter();
  try
    if (Value <> FZipLevel) then
      FZipLevel:= Value;
  finally
    FCritical.Leave();
  end;
end;

function TSettings.TaskIDExists(const TaskName: WideString): integer;
var
  i: integer;
  Task: TTask;
begin
  Result:= INT_TASKNOTFOUND;
  with TaskList.LockList() do
  try
    for i:=0 to Count - 1 do
      begin
        Task:= Items[i];
        if (WideUpperCase(TaskName) = WideUpperCase(Task.ID)) then
        begin
          Result:= i;;
          Break;
        end;
      end;
  finally
    TaskList.UnlockList();
  end;
end;

function TSettings.TaskNameExists(const TaskName: WideString; var ID: WideString): integer;
var
  i: integer;
  Task: TTask;
begin
  Result:= INT_TASKNOTFOUND;
  ID:= WS_NIL;
  with TaskList.LockList() do
  try
    for i:=0 to Count - 1 do
      begin
        Task:= Items[i];
        if (WideUpperCase(TaskName) = WideUpperCase(Task.Name)) then
        begin
          Result:= i;;
          ID:= Task.ID;
          Break;
        end;
      end;
  finally
    TaskList.UnlockList();
  end;
end;

function TSettings.UpdateHistoryFile(const ID, History: WideString): boolean;
var
  fn: WideString;
  Sl: TTntStringList;
begin
  Result:= true;
  fn:= FDBPath + ID + WS_HISTORYEXT;
  if (WaitForSingleObject(FMutexList, INFINITE) = WAIT_OBJECT_0) then
  begin
    Sl:= TTntStringList.Create();
    try
      try
        Sl.CommaText:= History;
        Sl.SaveToFile(fn);
        GetFullAccess(fn);
      except    // <- Important because thís will be used in the engine too
        Result:= false;
      end;
    finally
      FreeAndNil(Sl);
      ReleaseMutex(FMutexList);
    end;
  end;
end;

procedure TSettings.UpdateTask(const Index: integer; const Task: TTask);
var
  ExistingTask: TTask;
begin
  /// Updates an existing task with the task
  ///  that is passed as an argument
  ///  This is the oposite of CopyTask

  with TaskList.LockList() do
  try
    if (Index>=0) and (Index < Count) then
    begin
      ExistingTask:= Items[Index];
      Task.CloneTo(ExistingTask);
    end;
  finally
    TaskList.UnlockList();
  end;
end;

procedure TSettings.UpdateTask(const ID: WideString; const Task: TTask);
var
  i: integer;
  ExistingTask: Ttask;
begin
  /// Updates an existing task with the task
  ///  that is passed as an argument
  ///  This is the oposite of CopyTask
  
  with TaskList.LockList() do
  try
    for i:= 0 to Count -1 do
      begin
        ExistingTask:= Items[i];
        if (ExistingTask.ID = ID) then
        begin
          Task.CloneTo(ExistingTask);
          Break;
        end;
      end;
  finally
    TaskList.UnlockList();
  end;
end;

{ TCobTools }

function TCobTools.CloseAWindowW(const ACaption: WideString;
  const Kill: boolean): cardinal;
var
  h: THandle;
  tmpcard: cardinal;
  procId: longword;
  prochandle: integer;
  TheCaption, TheClass: WideString;
begin
  // if the CAption has a class: in it, this is the classname
  if (CobPosW(WS_CLASS, ACaption, false) = 1) then
  begin
    TheCaption:= WS_NIL;
    TheClass:= Copy(ACaption, Length(WS_CLASS)+1, Length(ACaption) - Length(WS_CLASS));
  end else
  begin
    TheCaption:= ACaption;
    TheClass:= WS_NIL;
  end;

  h := FindAWindow(TheCaption, TheClass);

  if h = 0 then
    //Windows no found
    begin
      Result := INT_CW_NOFOUND; //Not found
      Exit;
    end;


  Result:= INT_CW_COULDNOTBECLODED; //Couldn't be closed
  //try to Close the Window
  PostMessageW(h, WM_CLOSE, 0, 0);
  //It can be posible that the window did't close
  //because, for example, it can be waiting for
  //a confirmation . Find out if the window is
  //gone
  Sleep(INT_TIMETOCLOSE); //give time to close
  h := FindAWindow(TheCaption, TheClass);
  if h = 0 then
  begin
    //Success
    Result := INT_CW_CLOSED;
  end
  else
  if Kill then
    begin
      // a dirt quit
      PostMessageW(h, WM_QUIT, 0, 0);
      Sleep(INT_CW_CLOSED); //give time to close
      h := FindAWindow(TheCaption, TheClass);
      if h = 0 then
      begin
        //Success
        Result := INT_CW_CLOSED;
        Exit;
      end;

      //try to close it another way. Can destroy the non-saved data
      if IsWindow(h) then
      begin
        GetWindowThreadProcessID(h, @procid);
        ProcHandle := OpenProcess(PROCESS_ALL_ACCESS, False, procid);
        if GetExitCodeProcess(prochandle, tmpCard) then
          TerminateProcess(prochandle, tmpCard);
      end;
      Sleep(INT_TIMETOCLOSE);
      //try to find again last time
      h := FindAWindow(TheCaption, TheClass);
      if h = 0 then
        Result := INT_CW_CLOSED;
    end;

end;

function TCobTools.CopyAttributes(const Source,
  Destination: WideString): boolean;
var
  Att: cardinal;
begin
  Result:= false;

  if (WideFileExists(Source)) then
    if (WideFileExists(Destination)) then
    begin
      Att:= WideFileGetAttr(Source);
      Result :=WideFileSetAttr(Destination, Att);
    end;
end;

function TCobTools.CopyAttributesDir(const Source,
  Destination: WideString): boolean;
var
  Att: cardinal;
begin
  Result:= false;

  if (WideDirectoryExists(Source)) then
    if (WideDirectoryExists(Destination)) then
    begin
      Att:= WideFileGetAttr(Source);
      Result :=WideFileSetAttr(Destination, Att);
    end;
end;

function TCobTools.CopyTimeStamps(const Source, Destination: WideString): boolean;
var
  sh, dh: THandle;
  ct, lat, lwt: TFileTime;
begin
  Result := false;

  if WideFileExists(Source) then
    if WideFileExists(Destination) then
      begin
        sh := CreateFileW(PWideChar(Source), GENERIC_READ, FILE_SHARE_READ {or
          FILE_SHARE_WRITE},
          nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
        if sh <> INVALID_HANDLE_VALUE then
        begin
          if GetFileTime(sh, @ct, @lat, @lwt) then
          begin
            dh := CreateFileW(PWideChar(Destination), GENERIC_WRITE, FILE_SHARE_READ or
              FILE_SHARE_WRITE,
              nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
            if dh <> INVALID_HANDLE_VALUE then
            begin
              Result:= SetFileTime(dh, @ct, @lat, @lwt);
              CloseHandle(dh);
            end;
          end;
          CloseHandle(sh);
        end;
      end;
end;


constructor TCobTools.Create();
begin
  inherited Create();
  Sl:= TTntStringList.Create();
  GetLocaleFormatSettings(LOCALE_SYSTEM_DEFAULT, FS);
end;

function TCobTools.DecodeSD(const Encoded: WideString;
  var Kind: integer): WideString;
begin
  Kind:= INT_SDDIR;
  Result:= WS_NIL;
  Sl.CommaText:= Encoded;
  if (Sl.Count = 2) then
  begin
    Kind:= CobStrToIntW(Sl[0], INT_SDDIR);
    Result:= Sl[1];
  end;
end;

function TCobTools.DeleteDirectoryW(const Dir: WideString): boolean;
var
  DirInfo: TSearchRecW;
  ADir: WideString;
  //****************************************************************************
  procedure Proceed();
  begin
    if (DirInfo.Name <> WS_CURRENTDIR) and (DirInfo.Name <> WS_PARENTDIR) then
    begin
      if (faDirectory and DirInfo.Attr) > 0 then
        DeleteDirectoryW(CobSetBackSlashW(Dir)+DirInfo.Name) else
        begin
          FileToProcess(CobSetBackSlashW(ADir)+DirInfo.Name);
          DeleteFileWSpecial(CobSetBackSlashW(ADir)+DirInfo.Name);
        end;
    end;
  end;
  //****************************************************************************
begin
  // 2007-02-03 Fixed! If ADir = '' DO NOT DELETE BECAUSE THERE IS NOTHING TO
  // DELETE (The download failed, because a directory must ALWAYS be created).
  // Ifproceed, in certain circunstances, a service would trash the System32
  // directory
  if (ADir = WS_NIL) then
    Exit;
    
  ADir:= NormalizeFileName(CobSetBackSlashW(Dir));
  if WideFindFirst(ADir + WS_ALLFILES, FaAnyfile, DirInfo) = 0 then
  begin
    Proceed();
    while WideFindNext(DirInfo)=0 do
    begin
      Proceed();
      if (DoAbort()) then
        Break;
    end;
    WideFindClose(DirInfo);
  end;

  // 2006-11-16 by Luis Cobian
  // Remove the Read only attribute of the directories as well.
  if (GetReadOnlyAttributeW(ADir)) then
    SetReadOnlyAttributeW(ADir, false);

  Result:= RemoveDirectoryW(PWideChar(ADir));
end;

function TCobTools.DeleteSpacesW(const FileName: WideString): WideString;
begin
  //Replace all spaces by _ . Useful for uploading to
  // some FTPs that don't accept spaces
  Result:= CobStringReplaceW(FileName, WS_SPACE,WS_UNDER, true, false);
end;

destructor TCobTools.Destroy();
begin
  FreeAndNil(Sl);
  inherited Destroy();
end;

function TCobTools.DeleteFileWSpecial(const FileName: WideString): boolean;
begin
  // Deletes a file even if it is read only
  if (GetReadOnlyAttributeW(FileName)) then
    SetReadOnlyAttributeW(FileName, false);

  Result:= DeleteFileW(PWideChar(FileName));
end;

function TCobTools.DoAbort: boolean;
begin
  Result:= false;
  if (Assigned(OnAbort)) then
    Result:= OnAbort();
end;

function TCobTools.EncodeSD(const Kind: integer;
  const Path: WideString): WideString;
begin
  Sl.Clear();
  Sl.Add(CobIntToStrW(Kind));
  Sl.Add(Path);
  Result:= Sl.CommaText;
end;

function TCobTools.ExecuteW(const FileName, Param: WideString): cardinal;
var
  AParam: PWideChar;
begin
  if (Param = WS_NIL) then
    AParam:= nil else
    AParam:= PWideChar(Param);
  Result:= ShellExecuteW(0,'open',PWideChar(FileName),AParam,nil, SW_SHOWNORMAL);
end;

function TCobTools.ExecuteAndWaitW(const FileName, Param: WideString;
                                    Hide: boolean = false): cardinal;
var
  StartInfo: TStartupInfoW;
  ProcInfo: TProcessInformation;
  ExecStr: WideString;
  Code: longbool;
begin
  { fill with known state }

  FillChar(StartInfo, SizeOf(TStartupInfoW), #0);
  FillChar(ProcInfo, SizeOf(TProcessInformation), #0);
  StartInfo.cb := SizeOf(TStartupInfoW);

  if Hide then
    StartInfo.wShowWindow := SW_HIDE else
    StartInfo.wShowWindow := SW_SHOWNORMAL;

  StartInfo.dwFlags := STARTF_USESHOWWINDOW;

  if Param= WS_NIL then
    ExecStr:= FileName else
    ExecStr:= FileName + WS_SPACE + Param;

  Code := CreateProcessW(nil, PWideChar(ExecStr),
    nil, nil, False,
    CREATE_NEW_PROCESS_GROUP or NORMAL_PRIORITY_CLASS,
    nil, nil, StartInfo, ProcInfo);

  if (Code) then
    Result:= 0 else
    Result:= Windows.GetLastError();

  try
    if (Code) then
      WaitForSingleObject(ProcInfo.hProcess, INFINITE);
    //else
      //raise Exception.Create(CobSysErrorMessageW(System.GetLastError()));

  finally
    CloseHandle(ProcInfo.hProcess);
    CloseHandle(ProcInfo.hThread);
  end;
end;

// Callback function to use with EnumWindows

function EnumWindowsProc(hWindow: hWnd; lParam: Integer): Bool; stdcall;
var
  lpBuffer: PWideChar;
  WindowCaptionFound: bool;
  ClassNameFound: bool;
begin
  GetMem(lpBuffer, 255 * SizeOf(WideChar));
  Result := True;
  WindowCaptionFound := False;
  ClassNameFound := False;

  try
    if PFindWindowStructW(lParam).Caption = '' then
      WindowCaptionFound := True else
    if GetWindowTextW(hWindow, lpBuffer, 255) > 0 then
      if CobPosW(PFindWindowStructW(lParam).Caption, WideString(lpBuffer), true) > 0 then
        WindowCaptionFound := True;

    if PFindWindowStructW(lParam).ClassName = '' then
      ClassNameFound := True
    else if GetClassNameW(hWindow, lpBuffer, 255) > 0 then
      if CobPosW(PFindWindowStructW(lParam).ClassName, WideString(lpBuffer), true) > 0 then
        ClassNameFound := True;

    if (WindowCaptionFound and ClassNameFound) then
    begin
      PFindWindowStructW(lParam).WindowHandle := hWindow;
      Result := False;
    end;                 

  finally
    FreeMem(lpBuffer,  255 * SizeOf(WideChar));
  end;
end;


procedure TCobTools.FileToProcess(const FileName: WideString);
begin
  if (Assigned(OnFileProcess)) then
    OnFileProcess(FileName);
end;

function TCobTools.FindAWindow(TheCaption, TheClassName: WideString): THandle;
var
  WindowInfo: TFindWindowStructW;
begin
  with WindowInfo do
  begin
    Caption := TheCaption;
    ClassName := TheClassName;
    WindowHandle := 0;
    EnumWindows(@EnumWindowsProc, longint(@WindowInfo));
    Result := WindowHandle;
  end;
end;

function TCobTools.GetArchiveAttributeW(const FileName: WideString): boolean;
var
  Attr: cardinal;
begin
  Attr:= WideFileGetAttr(FileName);
  Result:= ((Attr and faArchive) <> 0);
end;

function TCobTools.GetCleanSD(const SD: WideString): WideString;
var
  Sl: TTntStringList;
  i, Kind: integer;
begin
  // returns the sources or directoríes WITHOUT the prefix
  Sl:= TTntStringList.Create();
  try
    Sl.CommaText:= SD;
    for i:= 0 to Sl.Count - 1 do
      Sl[i]:= DecodeSD(Sl[i], Kind);
    Result:= Sl.CommaText;
  finally
    FreeAndNil(Sl);
  end;
end;

function TCobTools.GetCompNameW(): WideString;
begin
  Result:= CobGetComputerNameW();
end;

function TCobTools.GetDateTimeFormat(const AFormat: WideString; const DT: TDateTime): WideString;
var
  DTString: AnsiString;
begin
  if (Trim(AFormat) = WS_NIL) then
    DTString:= DateTimeToStr(DT, FS) else
    try
      DTString:= FormatDateTime(AnsiString(AFormat), DT, FS);
    except
      DTString:= DateTimeToStr(DT,FS)
    end;

  Result:= GetGoodFileNameW(DTString);
end;

function TCobTools.GetDirNameSeparatedW(const Dir, AFormat: WideString;
  const Separate: boolean; const DT: TDateTime): WideString;
var
  Sep: WideString;
begin
  if (Separate) then
    Sep:= WS_SPACE else
    Sep:= WS_UNDER;
  Result:= Dir + Sep + GetDateTimeFormat(AFormat, DT);
end;

function TCobTools.GetFileNameSeparatedW(const FileName,
  AFormat: WideString; const Separate: boolean; const DT: TDateTime): WideString;
var
  Ext, Sep: WideString;
begin
  Ext:= WideExtractFileExt(FileName);
  if (Separate) then
    Sep:= WS_SPACE else
    Sep:= WS_UNDER;
  Result:= WideChangeFileExt(FileName, WS_NIL) + Sep + GetDateTimeFormat(AFormat, DT) + Ext;
end;

function TCobTools.GetGoodFileNameW(const Input: WideString): WideString;
begin
  Result:= Input;
  // Some file names could have a date-time that contains : or /
  if (CobPosW(WC_COLON, Result, true) > 0) then
    Result:= CobStringReplaceW(Result, WC_COLON, WC_SEMICOLON, true, true);

  if (CobPosW(WC_SLASH, Result, true) > 0) then
    Result:= CobStringReplaceW(Result, WC_SLASH, WC_SLASDASH, true, true);

  if (CobPosW(WC_BACKSLASH, Result, true) > 0) then
    Result:= CobStringReplaceW(Result, WC_BACKSLASH, WC_SLASDASH, true, true);

  if (CobPosW(WC_ASTERISC, Result, true) > 0) then
    Result:= CobStringReplaceW(Result, WC_ASTERISC, WC_SLASDASH, true, true);

  if (CobPosW(WC_QUESTION, Result, true) > 0) then
    Result:= CobStringReplaceW(Result, WC_QUESTION, WC_SLASDASH, true, true);

  if (CobPosW(WC_MORETHAN, Result, true) > 0) then
    Result:= CobStringReplaceW(Result, WC_MORETHAN, WC_SLASDASH, true, true);

  if (CobPosW(WC_LESSTHAN, Result, true) > 0) then
    Result:= CobStringReplaceW(Result, WC_LESSTHAN, WC_SLASDASH, true, true);

  if (CobPosW(WC_PIPE, Result, true) > 0) then
    Result:= CobStringReplaceW(Result, WC_PIPE, WC_SLASDASH, true, true);
end;


function TCobTools.GetParentDirectory(const Dir: WideString): WideString;
var
  i,p: integer;
begin
  Result := WS_NIL;
  if Length(Dir) = 0 then
    Exit;
  p := 0;
  for i := Length(Dir) downto 1 do
  begin
    if (Dir[i] = WC_BACKSLASH) and (i <> Length(Dir)) then
    begin
      p := i;
      Break;
    end;
  end;
  if p <> 0 then
    Result := Copy(Dir, 1, p);
end;


function TCobTools.GetReadOnlyAttributeW(const FileName: WideString): boolean;
var
  Attr: cardinal;
begin
  Attr:= WideFileGetAttr(FileName);
  Result:= ((Attr and faReadOnly) <> 0);
end;

function TCobTools.IsDirEmpty(const Directory: WideString): boolean;
var
  SR: TSearchRecW;
  Count: cardinal;
  ADir: WideString;
  //*********************************
  procedure CountObjects();
  begin
    if (SR.Name <> WS_CURRENTDIR) and (SR.Name <> WS_PARENTDIR) then
      Inc(Count);
  end;
  //*********************************
begin
  // here, there is no need to iterate
  Count := 0;
  Result := true;
  ADir:= NormalizeFileName(Directory);

  if not WideDirectoryExists(ADir) then
    Exit;

  ADir := CobSetBackSlashW(ADir);

  if WideFindFirst(ADir + WS_ALLFILES, faAnyFile, SR) = 0 then
  begin
    CountObjects();
    while WideFindNext(SR) = 0 do
    begin
      CountObjects();
      if (Count > 0) then       // no need to go on 
        Break;
    end;
    WideFindClose(SR);
  end;

  Result := (Count = 0);
end;


function TCobTools.IsFileLocked(const FileName: WideString): boolean;
var
  FHandle: THandle;
  ErrorCode: cardinal;
begin
  //try to open an existing file, if
  //there is a sharing violation, return true
  FHandle := CreateFileW(PWideChar(FileName), GENERIC_READ, FILE_SHARE_READ or FILE_SHARE_WRITE, nil, OPEN_EXISTING, 0, 0);
  Result := (FHandle = INVALID_HANDLE_VALUE);
  if (Result = False) then
    CloseHandle(FHandle)
  else
  begin
    ErrorCode := Windows.GetLastError();
    Result := (ErrorCode = ERROR_SHARING_VIOLATION);
  end;
end;


function TCobTools.IsInTheMask(const AName, AMask: WideString; const Propagate: boolean): boolean;
var
  Sl: TTntStringList;
  i: integer;
begin
  Result:= false;
  Sl:= TTntStringList.Create();
  try
    Sl.CommaText:= AMask;
    for i:=0 to Sl.Count - 1 do
      if (CobMaskMatchW(AName, Sl[i], false, Propagate)) then
      begin
        Result:= true;
        Break;
      end;
  finally
    FreeAndnil(Sl);
  end;
end;

function TCobTools.IsRoot(const Dir: WideString): boolean;
var
  ADir: WideString;
begin
  // Is this diurectory a root. For example, C:\ is true
  Result:= false;
  ADir:= CobSetBackSlashW(Dir);
  if (Length(ADir) = 3) then
    if (ADir[Length(ADir)] = WC_BACKSLASH) and ((ADir[Length(ADir)-1] = WC_COLON)) then
      Result:= true;
end;

function TCobTools.IsTheSameFile(const File1, File2: WideString;
          const UseSizes: boolean): boolean;
var
  Crc1, Crc2: longword;
  Size1, Size2: Int64;
begin
  Crc1:= CobCalculateCRCW(File1, OnCRCProgress);
  Crc2:= CobCalculateCRCW(File1, OnCRCProgress);
  Size1:= 0;
  Size2:= 0;
  if UseSizes then
    begin
      Size1:= CobGetFileSize(File1);
      Size2:= CobGetFileSize(File2);
    end;

  Result:= (Crc1 = Crc2) and (Size1 = Size2); 
end;


function TCobTools.KillSpaces(const Input: WideString): WideString;
begin
  Result:= Input;
  if (CobPosW(WS_SPACE, Input, true) > 0) then
    Result:= CobStringReplaceW(Input, WS_SPACE, WS_SPACEHTML, true, true);
end;

function TCobTools.NeedToCopyByTimeStamp(const FileName,
  FileNameDest: WideString): boolean;
var
  SR, DR: TSearchRecW;
  Sd, Dd: TFileTime;
begin
  Result:= true;
  if (not WideFileExists(FileNameDest)) then
    Exit;  //copy anyway

  if (WideFindFirst(FileName, faAnyFile, SR) = 0) then
  begin
    if (WideFindFirst(FileNameDest, faAnyFile, DR) = 0) then
    begin
      Sd:= SR.FindData.ftLastWriteTime;
      Dd:= DR.FindData.ftLastWriteTime;
      Result:= CompareFileTime(Sd, Dd) = 1;
      WideFindClose(DR);
    end;
    WideFindClose(SR);
  end;
end;

function TCobTools.NormalizeFileName(const FileName: WideString): WideString;
begin
  Result:= CobNormalizeFileNameW(FileName);
end;

function TCobTools.ReplaceTemplate(const Input,
  TaskName{, CleanSource, CleanDestination}: WideString): WideString;
begin
  Result:= Input;

  if (CobPosW(WS_PARCOMPUTERNAME, Result, true) > 0) then
    Result:= CobStringReplaceW(Result, WS_PARCOMPUTERNAME, GetCompNameW(),true, true);

  if (CobPosW(WS_PARCOMPUTERNAMENOSPACES, Result, true) > 0) then
    Result:= CobStringReplaceW(Result, WS_PARCOMPUTERNAMENOSPACES, KillSpaces(GetCompNameW()),true, true);

  if (CobPosW(WS_PARAMDATE, Result, true) > 0) then
    Result:= CobStringReplaceW(Result, WS_PARAMDATE, WideString(DateToStr(Now(),FS)),true, true);

  if (CobPosW(WS_PARAMDATETIME, Result, true) > 0) then
    Result:= CobStringReplaceW(Result, WS_PARAMDATETIME, WideString(DateTimeToStr(Now(),FS)),true, true);

  if (CobPosW(WS_PARAMTASKNAME, Result, true) > 0) then
    Result:= CobStringReplaceW(Result, WS_PARAMTASKNAME, TaskName ,true, true);

  if (CobPosW(WS_PARAMTIME, Result, true) > 0) then
    Result:= CobStringReplaceW(Result, WS_PARAMTIME, WideString(TimeToStr(Now())) ,true, true);

  {if (CobPosW(WS_PARAMCLEANSOURCE, Result, true) > 0) then
    Result:= CobStringReplaceW(Result, WS_PARAMCLEANSOURCE, CleanSource ,true, true);

  if (CobPosW(WS_PARAMCLEANDESTINATION, Result, true) > 0) then
    Result:= CobStringReplaceW(Result, WS_PARAMCLEANDESTINATION, CleanDestination ,true, true);  }
end;

function TCobTools.RestartShutdownW(const Restart, Kill: boolean): cardinal;
var
  ExitCode: boolean;
  Token: THandle;
  State, PrevState: TTokenPrivileges;
  RetLen: DWORD;
  Flags: cardinal;
begin
  Result:= 0;
  if OpenProcessToken(GetCurrentProcess, TOKEN_QUERY or
    TOKEN_ADJUST_PRIVILEGES, Token) then
  try
    State.PrivilegeCount := 1;
    if LookupPrivilegeValueW(nil, 'SeShutdownPrivilege',
        State.Privileges[0].LUID) then
    begin
      State.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
      if AdjustTokenPrivileges(Token, False, State, SizeOf(PrevState), PrevState, RetLen) then
      try
        if (Restart) then
          ExitCode:= InitiateSystemShutdownW(nil, nil, 0, Kill, true) else
          begin
            Flags:= EWX_SHUTDOWN or EWX_POWEROFF;
            if (Kill) then
              Flags:= Flags + EWX_FORCE;
            ExitCode := ExitWindowsEx(Flags , 0);
          end;
          if (ExitCode) then
            Result:= Windows.GetLastError();
      finally
        AdjustTokenPrivileges(Token, False, PrevState, SizeOf(State), State, RetLen);
      end; //try
    end; //begin
  finally
    CloseHandle(Token);
  end;
end;

function TCobTools.SetArchiveAttributeW(const FileName: WideString;
  const SetIt: boolean): boolean;
var
  Attr: cardinal;
begin
  Result:= false;

  if (not WideFileExists(FileName)) then
    Exit;

  Attr:= WideFileGetAttr(FileName);
  if (SetIt) then
    Attr:= Attr or faArchive else
    Attr:= Attr and not faArchive;

  Result:= WideFileSetAttr(FileName, Attr);
end;

function TCobTools.SetReadOnlyAttributeW(const FileName: WideString;
  const SetIt: boolean): boolean;
var
  Attr: cardinal;
begin
  { 2006 - 11- 16 by Luis Cobian
  This way this will work with directories as well
  
  if (not WideFileExists(FileName)) then
    Exit;      }

  Attr:= WideFileGetAttr(FileName);
  if (SetIt) then
    Attr:= Attr or faReadOnly else
    Attr:= Attr and not faReadOnly;

  Result:= WideFileSetAttr(FileName, Attr);
end;

function TCobTools.StartServiceW(const LibraryName, ServiceName, Param: WideString): cardinal;
var
  dll: THandle;
  Start: function (const SName, Par: PWideChar): cardinal; stdcall;
begin
  dll:= LoadLibraryW(PWideChar(LibraryName));
  if (dll <> 0) then
  begin
    @Start:= GetProcAddress(dll,S_STARTASERVICE);
    if (@Start <> nil) then
    begin
      Result:= Start(PWideChar(ServiceName),PWideChar(Param));
    end else
      Result:= INT_LIBNOPROCEDURE;

    FreeLibrary(dll);
  end else
  Result:= INT_LIBCOULDNOTLOAD;
end;

function TCobTools.StopService(const LibraryName,
  ServiceName: WideString): cardinal;
var
  dll: THandle;
  Stop: function (const SName: PWideChar): cardinal; stdcall;
begin
  dll:= LoadLibraryW(PWideChar(LibraryName));
  if (dll <> 0) then
  begin
    @Stop:= GetProcAddress(dll, S_STOPASERVICE);
    if (@Stop <> nil) then
    begin
      Result:= Stop(PWideChar(ServiceName));
    end else
      Result:= INT_LIBNOPROCEDURE;

    FreeLibrary(dll);
  end else
  Result:= INT_LIBCOULDNOTLOAD;
end;

function TCobTools.ValidateFileName(const FileName: WideString): boolean;
const
  AMPM: WideString = 'am/pm';
  AMPMD: WideString ='am-pm';
  AP: WideString ='a/p';
  APD: WideString ='a-p';
  Chars: array [1..9] of WideChar =
              ('/', '\', '*', '?', '|', ':', '"', '<', '>');
var
  i, j: integer;
  fn: WideString;
begin
  Result:= true;

  fn:= FileName;

  if fn = WS_NIL then
    begin
      Result:= false;
      Exit;
    end;

  //2005-08-03
  // you can use am/pm or a/p in the format of the date
  // so if those strings exist, then ignore them

  if CobPosW(AMPM, fn, false) >0 then
    fn:= CobStringReplaceW(fn, AMPM, AMPMD, true, false);

  if CobPosW(AP,fn , false )>0 then
    fn:= CobStringReplaceW(fn, AP, APD, true, false);

  for i := 1 to Length(fn) do
    begin
      for j:= 1 to 9 do
        if (fn[i] = Chars[j]) then
          begin
            Result:= false;
            Break;
          end;
      if (not Result) then
        Break;
    end;
end;


{ TFTPAddress }

constructor TFTPAddress.Create();
begin
  inherited Create();
  GetLocaleFormatSettings(LOCALE_SYSTEM_DEFAULT, FS);
  FSl:= TTntStringList.Create();
  SetDefaultValues();
end;

function TFTPAddress.DecodeAddress(const Encoded: WideString): boolean;
begin
  Result:= false;
  FSl.CommaText:= Encoded;

  if (FSl.Count <> INT_FTPFIELDCOUNT) then
    Exit;

  ID:= FSl[0];
  Password:= FSl[1];
  Host:= FSl[2];
  Port:= CobStrToIntW(FSl[3], INT_DEFFTPPORT);
  WorkingDir:= FSl[4];

  TLS:= CobStrToIntW(FSl[5], INT_NOTLSSUPPORT);
  AuthType:= CobStrToIntW(FSl[6], INT_AUTHTYPEAUTO);
  DataProtection:= CobStrToIntW(FSl[7], INT_DATAPROTECTIONCLEAR);
  ProxyType:= CobStrToIntW(FSl[8], INT_NOPROXY);
  ProxyHost:= FSl[9];
  ProxyPort:= CobStrToIntW(FSl[10], INT_STDPROXY);
  ProxyID:= FSl[11];
  ProxyPassword:= FSl[12];

    //Advanced
  DataPort:= CobStrToIntW(FSl[13], INT_STDDATAPORT);
  MinPort:= CobStrToIntW(FSl[14], INT_STDMINPORT);
  MaxPort:= CobStrToIntW(FSl[15], INT_STDMAXPORT);
  ExternalIP:= FSl[16];
  Passive:= CobStrToBoolW(FSl[17]);
  TransferTimeOut:= CobStrToIntW(FSl[18], INT_STDTRANSFERTIMEOUT);
  ConnectionTimeout:= CobStrToIntW(FSl[19], INT_STDCONNECTIONTIMEOUT);
  UseMLIS:= CobStrToBoolW(FSl[20]);
  UseIPv6:= CobStrToBoolW(FSl[21]);
  UseCCC:= CobStrToBoolW(FSl[22]);
  NATFastTrack:= CobStrToBoolW(FSl[23]);

    //SSLOptions
  SSLMethod:= CobStrToIntW(FSl[24], INT_SSLV2);
  SSLMode:= CobStrToIntW(FSl[25], INT_SSLMODEUNASSIGNED);
  UseNagle:= CobStrToBoolW(FSl[26]);
  VerifyDepth:= CobStrToIntW(FSl[27], INT_VERIFYDEPTH);
  Peer:= CobStrToBoolW(FSl[28]);
  FailIfNoPeer:= CobStrToBoolW(FSl[29]);
  ClientOnce:= CobStrToBoolW(FSl[30]);
    // files
  CertificateFile:= FSl[31];
  CipherList:= FSl[32];
  KeyFile:= FSl[33];
  RootCertificate:= FSl[34];
  VerifyDirectories:= FSl[35];
  //Backup
  FBUObjects:= FSl[36];
  
  Result:= true;
end;

destructor TFTPAddress.Destroy();
begin
  FreeAndNil(FSl);
  inherited Destroy();
end;

function TFTPAddress.EncodeAddress(): WideString;
begin
  FSl.Clear();
  FSl.Add(ID);
  FSl.Add(Password);
  FSl.Add(Host);
  FSl.Add(CobIntToStrW(Port));
  if (WorkingDir = WS_NIL) then
    WorkingDir:= WS_FTPROORDIR;
  FSl.Add(WorkingDir);

  FSl.Add(CobIntToStrW(TLS));
  FSl.Add(CobIntToStrW(AuthType));
  FSl.Add(CobIntToStrW(DataProtection));
  FSl.Add(CobIntToStrW(ProxyType));
  FSl.Add(ProxyHost);
  FSl.Add(CobIntToStrW(ProxyPort));
  FSl.Add(ProxyID);
  FSl.Add(ProxyPassword);

    //Advanced
  FSl.Add(CobIntToStrW(DataPort));
  FSl.Add(CobIntToStrW(MinPort));
  FSl.Add(CobIntToStrW(MaxPort));
  FSl.Add(ExternalIP);
  FSl.Add(CobBoolToStrW(Passive));
  FSl.Add(CobIntToStrW(TransferTimeOut));
  FSl.Add(CobIntToStrW(ConnectionTimeout));
  FSl.Add(CobBoolToStrW(UseMLIS));
  FSl.Add(CobBoolToStrW(UseIPv6));
  FSl.Add(CobBoolToStrW(UseCCC));
  FSl.Add(CobBoolToStrW(NATFastTrack));
  
    //SSLOptions
  FSl.Add(CobIntToStrW(SSLMethod));
  FSl.Add(CobIntToStrW(SSLMode));
  FSl.Add(CobBoolToStrW(UseNagle));
  FSl.Add(CobIntToStrW(VerifyDepth));
  FSl.Add(CobBoolToStrW(Peer));
  FSl.Add(CobBoolToStrW(FailIfNoPeer));
  FSl.Add(CobBoolToStrW(ClientOnce));
    // files
  FSl.Add(CertificateFile);
  FSl.Add(CipherList);
  FSl.Add(KeyFile);
  FSl.Add(RootCertificate);
  FSl.Add(VerifyDirectories);
  // Backup
  FSl.Add(FBUObjects);

  Result:= FSL.CommaText;
end;

function TFTPAddress.EncodeAddressDisplay(): WideString;
var
  wd: WideString;
begin
  if (CobPosW(WS_FTPROORDIR, WorkingDir, true)= 1) then
    wd:=Copy(WorkingDir,2,Length(WorkingDir)-1);
  Result:= WideFormat(WS_FTPDISPLAY,[ID,Host,Port,wd],FS);
end;

procedure TFTPAddress.SetDefaultValues();
begin
  ID:= WS_NIL;
  CobEncryptStringW(WS_NIL, WS_LLAVE, Password);
  Host:= WS_NIL;
  Port:= INT_DEFFTPPORT;
  WorkingDir:= WS_FTPROORDIR;

  TLS:= INT_NOTLSSUPPORT;
  AuthType:= INT_AUTHTYPEAUTO;
  DataProtection:= INT_DATAPROTECTIONCLEAR;
  ProxyType:= INT_NOPROXY;
  ProxyHost:= WS_NIL;
  ProxyPort:= INT_STDPROXY;
  ProxyID:= WS_NIL;
  CobEncryptStringW(WS_NIL, WS_LLAVE, ProxyPassword);

  //Advanced
  DataPort:= INT_STDDATAPORT;
  MinPort:= INT_STDMINPORT;
  MaxPort:= INT_STDMAXPORT;
  ExternalIP:= WS_NIL;
  Passive:= false;
  TransferTimeOut:= INT_STDTRANSFERTIMEOUT;
  ConnectionTimeout:= INT_STDCONNECTIONTIMEOUT;
  UseMLIS:= false;
  UseIPv6:= false;
  UseCCC:= false;
  NATFastTrack:= false;
  
    //SSLOptions
  SSLMethod:= INT_SSLV2;
  SSLMode:= INT_SSLMODEUNASSIGNED;
  UseNagle:= true;
  VerifyDepth:= INT_VERIFYDEPTH;
  Peer:= false;
  FailIfNoPeer:= false;
  ClientOnce:= false;
      // files
  CertificateFile:= WS_NIL;
  CipherList:= WS_NIL;
  KeyFile:= WS_NIL;
  RootCertificate:= WS_NIL;
  VerifyDirectories:= WS_NIL;

  // backup values
  FBUObjects:= WS_NIL;
end;

{ TTask }

procedure TTask.ApplyParameters();
  //*****************
  function GetNewSourceDestination(const AString: WideString): WideString;
  var
     Sl: TTntStringList;
     i, Kind: integer;
     ASource: WideString;
    Tool: TCobTools;
  begin
    Sl:= TTntStringList.Create();
    Tool:= TCobTools.Create();
    try
      Sl.CommaText:= AString;
      for i:=0 to Sl.Count - 1 do
      begin
        ASource:= Tool.DecodeSD(Sl[i], Kind);

        if (Kind = INT_SDMANUAL) or (Kind = INT_SDFTP) then
          ASource:= Tool.ReplaceTemplate(ASource, Name);
        if (Kind = INT_SDMANUAL) then
          if (WideFileExists(Tool.NormalizeFileName(ASource))) then
            Kind:= INT_SDFILE else
          if (WideDirectoryExists(Tool.NormalizeFileName(ASource))) then
            Kind:= INT_SDDIR;

        Sl[i]:= Tool.EncodeSD(Kind, ASource);
      end;
      Result:= Sl.CommaText;
    finally
      FreeAndnil(Tool);
      FreeAndNil(Sl);
    end;
  end;
  //*****************
begin
  Source:= GetNewSourceDestination(Source);
  Destination:= GetNewSourceDestination(Destination);
end;

procedure TTask.CloneTo(var Task: TTask);
begin
  // Copies a task to another.
  // Be carefull, cause the ID is also copied
  Task.Name:= Name;
  Task.ID:= ID;
  Task.Disabled:= Disabled;
  Task.IncludeSubdirectories:= IncludeSubdirectories;;
  Task.SeparateBackups:= SeparateBackups;
  Task.UseAttributes:= UseAttributes;
  Task.ResetAttributes:= ResetAttributes;
  Task.BackupType:= BackupType;
  Task.FullCopiesToKeep:= FullCopiesToKeep;
  Task.Source:= Source;
  Task.Destination:= Destination;
  Task.ScheduleType:= ScheduleType;
  Task.DateTime:= DateTime;
  Task.DayWeek:= DayWeek;
  Task.DayMonth:= DayMonth;
  Task.Month:= Month;
  Task.Timer:= Timer;
  Task.MakeFullBackup:= MakeFullBackup;
  Task.Compress:= Compress;
  Task.ArchiveProtect:= ArchiveProtect ;
  Task.Password:= Password;
  Task.Split:= Split;
  Task.SplitCustom:= SplitCustom;
  Task.ArchiveComment:= ArchiveComment;
  Task.Encryption:= Encryption;
  Task.Passphrase:= Passphrase;
  Task.PublicKey:= PublicKey;
  Task.IncludeMasks:= IncludeMasks;
  Task.ExcludeItems:= ExcludeItems;
  Task.BeforeEvents:= BeforeEvents;
  Task.AfterEvents:= AfterEvents;
  Task.Impersonate:= Impersonate;
  Task.ImpersonateCancel:= ImpersonateCancel;
  Task.ImpersonateID:= ImpersonateID;
  Task.ImpersonateDomain:= ImpersonateDomain;
  Task.ImpersonatePassword:= ImpersonatePassword;
end;

constructor TTask.Create();
begin
  inherited Create();
  GetLocaleFormatSettings(LOCALE_SYSTEM_DEFAULT, FS);
end;

procedure TTask.StrToTaskW(const Str: WideString);
var
  Sl: TTntStringList;
  OK: boolean;
  Pwd: WideString;
begin
  // decodes the string into the values of the current task
  Sl:= TTntStringList.Create();
  try
    Sl.CommaText:= Str;
    if (Sl.Count = INT_TASKCOUNT) then
    begin
      //Ignore the first element. This is only a separator
      Name:= Sl.Values[WS_TASK_NAME];
      Id:= Sl.Values[WS_TASK_ID];
      Disabled:= CobStrToBoolW(Sl.Values[WS_TASK_DISABLED]);
      IncludeSubdirectories:= CobStrToBoolW(Sl.Values[WS_TASK_INCLUDESUBDIRS]);
      SeparateBackups:= CobStrToBoolW(Sl.Values[WS_TASK_SEPARATED]);
      UseAttributes:= CobStrToBoolW(Sl.Values[WS_TASK_USEATTRIBUTES]);
      ResetAttributes:= CobStrToBoolW(Sl.Values[WS_TASK_RESETATTRIBUTES]);
      BackupType:= CobStrToIntW(Sl.Values[WS_TASK_BACKUPTYPE], INT_BUFULL);
      FullCopiesToKeep:= CobStrToIntW(Sl.Values[WS_TASK_FULLTOKEEP],INT_NIL);
      Source:= Sl.Values[WS_TASK_SOURCE];
      Destination:= Sl.Values[WS_TASK_DESTINATION];
      ScheduleType:= CobStrToIntW(Sl.Values[WS_TASK_SCHEDULETYPE], INT_SCDAILY);
      DateTime:= CobBinToDoubleW(Sl.Values[WS_TASK_DATETIME],OK);
      if (not OK) then
        DateTime:= Now() - 1;
      DayWeek:= Sl.Values[WS_TASK_DAYWEEK];
      DayMonth:= Sl.Values[WS_TASK_DAYMONTH];
      Month:= CobStrToIntW(Sl.Values[WS_TASK_MONTH],INT_NIL);
      Timer:= CobStrToIntW(Sl.Values[WS_TASK_TIMER], INT_DEFTIMER);
      MakeFullBackup:= CobStrToIntW(Sl.Values[WS_TASK_MAKEFULL], INT_NIL);
      Compress:= CobStrToIntW(Sl.Values[WS_TASK_COMPRESS], INT_COMPNOCOMP);
      ArchiveProtect:= CobStrToBoolW(Sl.Values[WS_TASK_ARCHIVEPROTECT]);
      Pwd:= WS_NIL;
      if CobDecryptStringW(Sl.Values[WS_TASK_PASSWORD], WS_LLAVE, Pwd) then
        Password:= Pwd else
        Pwd:= WS_NIL;
      Split:= CobStrToIntW(Sl.Values[WS_TASK_SPLIT], INT_SPLITNOSPLIT);
      SplitCustom:= CobStrToInt64W(Sl.Values[WS_TASK_SPLITCUSTOM], INT_DEFCUSTOM);
      ArchiveComment := Sl.Values[WS_TASK_COMMENT];
      Encryption:= CobStrToIntW(Sl.Values[WS_TASK_ENCRYPT], INT_ENCNOENC);
      Pwd:= WS_NIL;
      if CobDecryptStringW(Sl.Values[WS_TASK_PASSPHRASE], WS_LLAVE , Pwd) then
        Passphrase:= Pwd else
        Passphrase:= WS_NIL;
      PublicKey:= Sl.Values[WS_TASK_PUBLICKEY];
      IncludeMasks:= Sl.Values[WS_TASK_INCLUDE];
      ExcludeItems:= Sl.Values[WS_TASK_EXCLUDE];
      BeforeEvents:= Sl.Values[WS_TASK_BEFOREEVENTS];
      AfterEvents:= Sl.Values[WS_TASK_AFTEREVENTS];
      Impersonate:= CobStrToBoolW(Sl.Values[WS_TASK_IMPERSONATE]);
      ImpersonateCancel:= CobStrToBoolW(Sl.Values[WS_TASK_IMPERSONATECANCEL]);
      ImpersonateID:= Sl.Values[WS_TASK_IMPERSONATEID];
      ImpersonateDomain:= Sl.Values[WS_TASK_IMPERSONATEDOMAIN];
      Pwd:= WS_NIL;
      if CobDecryptStringW(Sl.Values[WS_TASK_IMPERSONATEPASSWORD], WS_LLAVE, Pwd) then
        ImpersonatePassword:= Pwd else
        ImpersonatePassword:= WS_NIL;
      // Ignore separator
    end;
  finally
    FreeAndNil(Sl);
  end;
end;

function TTask.TaskToStrW(): WideString;
var
  Sl: TTntStringList;
  Pwd: WideString;
begin
  Sl:= TTntStringList.Create();
  try
    Sl.Add(WS_TASKBEGIN);
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_TASK_NAME,Name],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_TASK_ID, ID],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_TASK_DISABLED,CobBoolToStrW(Disabled)],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_TASK_INCLUDESUBDIRS,CobBoolToStrW(IncludeSubdirectories)],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_TASK_SEPARATED,CobBoolToStrW(SeparateBackups)],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_TASK_USEATTRIBUTES,CobBoolToStrW(UseAttributes)],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_TASK_RESETATTRIBUTES,CobBoolToStrW(ResetAttributes)],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_TASK_BACKUPTYPE,CobIntToStrW(BackupType)],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_TASK_FULLTOKEEP,CobIntToStrW(FullCopiesToKeep)],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_TASK_SOURCE,Source],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_TASK_DESTINATION,Destination],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_TASK_SCHEDULETYPE,CobIntToStrW(ScheduleType)],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_TASK_DATETIME,CobDoubleToBinW(DateTime)],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_TASK_DAYWEEK,DayWeek],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_TASK_DAYMONTH,DayMonth],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_TASK_MONTH,CobIntToStrW(Month)],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_TASK_TIMER,CobIntToStrW(Timer)],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_TASK_MAKEFULL,CobIntToStrW(MakeFullBackup)],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_TASK_COMPRESS,CobIntToStrW(Compress)],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_TASK_ARCHIVEPROTECT,CobBoolToStrW(ArchiveProtect)],FS));
    Pwd:= WS_NIL;
    CobEncryptStringW(Password, WS_LLAVE, Pwd);
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_TASK_PASSWORD,Pwd],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_TASK_SPLIT,CobIntToStrW(Split)],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_TASK_SPLITCUSTOM,CobIntToStrW(SplitCustom)],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_TASK_COMMENT,ArchiveComment],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_TASK_ENCRYPT,CobIntToStrW(Encryption)],FS));
    Pwd:= WS_NIL;
    CobEncryptStringW(Passphrase, WS_LLAVE, Pwd);
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_TASK_PASSPHRASE,Pwd],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_TASK_PUBLICKEY,PublicKey],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_TASK_INCLUDE,IncludeMasks],FS)); // only masks are allowed
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_TASK_EXCLUDE,ExcludeItems],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_TASK_BEFOREEVENTS,BeforeEvents],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_TASK_AFTEREVENTS,AfterEvents],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_TASK_IMPERSONATE,CobBoolToStrW(Impersonate)],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_TASK_IMPERSONATECANCEL,CobBoolToStrW(ImpersonateCancel)],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_TASK_IMPERSONATEID,ImpersonateID],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_TASK_IMPERSONATEDOMAIN,ImpersonateDomain],FS));
    Pwd:= WS_NIL;
    CobEncryptStringW(ImpersonatePassword, WS_LLAVE, Pwd);
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_TASK_IMPERSONATEPASSWORD,Pwd],FS));
    Sl.Add(WS_TASKEND);
    Result:= Sl.CommaText;
  finally
    FreeAndnil(Sl);
  end;
end;

{ TBackup }

function TBackup.BackupToStrW(): WideString;
var
  Sl: TTntStringList;
begin
  Sl:= TTntStringList.Create();
  try
    Sl.Add(FBackupID);
    Sl.Add(FTaskID);
    Sl.Add(FParentID);
    Sl.Add(FSource);
    Sl.Add(FDestination);
    Sl.Add(CobIntToStrW(FBackupType));
    Sl.Add(CobIntToStrW(FScheduleType));
    Sl.Add(CobIntToStrW(FCompressed));
    Sl.Add(CobIntToStrW(FEncrypted));
    Sl.Add(CobIntToStrW(FSplit));
    Sl.Add(CobBoolToStrW(FParked));
    Sl.Add(FFiles);
    Sl.Add(CobDoubleToBinW(FDateTime));
    Sl.Add(CobDoubleToBinW(FNextDateTime));
    Result:= Sl.CommaText;
  finally
    FreeAndNil(Sl);
  end;
end;

constructor TBackup.Create(const ID: WideString);
begin
  inherited Create();
  if (ID = WS_NIL) then
    FBackupID:= CobGetUniqueNameW() else
    FBackupID:= ID;
end;

destructor TBackup.Destroy();
begin

  inherited Destroy();
end;

procedure TBackup.StrToBackupW(const Value: WideString);
var
  Sl: TTntStringList;
  OK: boolean;
begin
  Sl:= TTntStringList.Create();
  try
    Sl.CommaText:= Value;
    if (Sl.Count = INT_BACKUPCOUNT) then
    begin
      FBackupID:= Sl[0];
      FTaskID:= Sl[1];
      FParentID:= Sl[2];
      FSource:= Sl[3];
      FDestination:= Sl[4];
      FBackupType:= CobStrToIntW(Sl[5], INT_BUFULL);
      FScheduleType:= CobStrToIntW(Sl[6], INT_SCDAILY);
      FCompressed:= CobStrToIntW(Sl[7], INT_COMPNOCOMP);
      FEncrypted:= CobStrToIntW(Sl[8], INT_ENCNOENC);
      FSplit:= CobStrToIntW(Sl[9], INT_SPLITNOSPLIT);
      FParked:= CobStrToBoolW(Sl[10]);
      FFiles:= Sl[11];
      FDateTime:= CobBinToDoubleW(Sl[12], OK);
      if (not OK) then
        FDateTime:= Now();
      FNextDateTime:= CobBinToDoubleW(Sl[13], OK);
      if (not OK) then
        FNextDateTime:= Now();
    end;
  finally
    FreeAndNil(Sl);
  end;
end;

{ TBackupList }

procedure TBackupList.AddBackup(const Backup: TBackup);
begin
  FList.Add(Backup);
end;

procedure TBackupList.ClearList();
var
  i: integer;
  Backup: TBackup;
begin
  for i:= 0 to FList.Count - 1 do
  begin
    Backup:= TBackup(FList[i]);
    FreeAndNil(Backup);
  end;
  FList.Clear();
end;

constructor TBackupList.Create();
begin
  inherited Create();
  FList:= TList.Create();
end;

procedure TBackupList.DeleteBackup(const ID: WideString);
var
  Backup: TBackup;
  i: integer;
begin
  for i:= FList.Count - 1 downto 0 do
  begin
    Backup:= FList[i];
    if (Backup.FBackupID = ID) then
    begin
      if (not Backup.FParked) then
      begin
        FreeAndNil(Backup);
        FList.Delete(i);
      end;
      Break;
    end;
  end;
end;

procedure TBackupList.DeleteBackupIndex(const Index: integer);
var
  Backup: TBackup;
begin
  if (Index < -1) or (Index > FList.Count - 1) then
    Exit;

  Backup:= FList[Index];
  if (not Backup.FParked) then
  begin
    FreeAndNil(Backup);
    FList.Delete(Index);
  end;
end;

destructor TBackupList.Destroy;
begin
  ClearList();
  inherited Destroy();
end;

procedure TBackupList.GetBackupPointer(const ID: WideString; var Backup: TBackup);
var
  i: integer;
  Found: boolean;
begin
  Found:= false;
  for i:= 0 to FList.Count - 1  do
  begin
    Backup:= FList[i];
    if (Backup.FBackupID = ID) then
    begin
      Found:= true;
      Break;
    end;
  end;

  if (not Found) then
    Backup:= nil;
end;

procedure TBackupList.GetBackupPointerIndex(const Index: integer;
  var Backup: TBackup);
begin
  if (Index < 0) or (Index > FList.Count-1)  then
  begin
    Backup:= nil;
    Exit;
  end else
  Backup:= FList[Index];
end;

function TBackupList.GetCount(): integer;
begin
  Result:= FList.Count;
end;

function TBackupList.GetLastBackupIndex(const Destination: WideString): integer;
var
  i: integer;
  Backup: TBackup;
begin
  Result:= -1;
  for i:= FList.Count-1 downto 0 do
  begin
    Backup:= TBackup(FList[i]);
    if (Backup.FDestination = Destination) then
    begin
      Result:= i;
      Break;
    end;
  end;
end;

function TBackupList.GetParentBackupID(const Destination: WideString): WideString;
var
  i: integer;
  Backup: TBackup;
begin
  Result:= WS_NIL;
  for i:= FList.Count-1 downto 0 do
  begin
    Backup:= TBackup(FList[i]);
    if (Backup.FBackupType = INT_BUFULL) then
      if (Backup.FDestination = Destination) then
      begin
        Result:= Backup.FBackupID;
        Break;
      end;
  end;
end;

procedure TBackupList.LoadBackups(const ID: WideString);
var
  Sl: TTntStringList;
  i: integer;
  Backup: TBackup;
begin
  ClearList();
  Sl:= TTntStringList.Create();
  try
    Sl.CommaText:= Settings.GetHistoryFile(ID);
    for i:= 0 to Sl.Count - 1 do
    begin
      Backup:= TBackup.Create(WS_NIL);
      Backup.StrToBackupW(Sl[i]);
      FList.Add(Backup);
    end;
  finally
    FreeAndNil(Sl);
  end;
end;

procedure TBackupList.SaveBackups(const ID: WideString);
var
  Sl: TTntStringList;
  i: integer;
  Backup: TBackup;
begin
  Sl:= TTntStringList.Create();
  try
    for i:= 0 to FList.Count - 1 do
    begin
      Backup:= FList[i];
      Sl.Add(Backup.BackupToStrW());
    end;
    Settings.UpdateHistoryFile(ID, Sl.CommaText);
  finally
    FreeAndNil(Sl);
  end;
end;

end.
