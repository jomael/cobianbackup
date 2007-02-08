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

// This unit implementes compression using the Zip method

unit engine_Zipper;

interface

uses Classes, TntClasses, SysUtils, bmCommon, Windows, TntSysUtils, ZipForge;

type
  TZipperRec = record
    Temp: WideString;
    AppPath: WideString;
    BackupType: integer;
    UseAttributes: boolean;
    Separated: boolean;
    DTFormat: WideString;
    DoNotSeparate: boolean;
    DoNotUseSpaces: boolean;
    Slow: boolean;
    ClearAttributes: boolean;
    DeleteEmptyFolders: boolean;
    AbsolutePaths: boolean;
    Subdirs: boolean;
    ExcludeMask: WideString;
    IncludeMask: WideString;
    CompressionLevel: integer;
    DoNotCompress: WideString;
    UseTaskName: boolean;
    TaskName: WideString;
    CheckArchives: boolean;
    AdvancedNaming: boolean;
    OEM: boolean;
    Zip64: integer;
    WillBeFTPded: boolean;
    Protect: boolean;
    Password: WideString;
    Split: integer;
    CustomSize: int64;
    Comment: WideString;
    Propagate: boolean;
  end;

  TZipper = class (TObject)
  public
    OnLog: TCobLogEvent;
    OnAbort: TCobAbort;
    OnFileBegin: TCobCompressFileBeginEnd;
    OnFileEnd: TCobCompressFileBeginEnd;
    OnPercentDone: TCobCompressPercentDone;
    constructor Create(const Rec: TZipperRec);
    destructor Destroy(); override;
    function Zip(const Source, Destination: WideString; const LastElement:boolean): WideString;
  private
    FZip: TZipForge;
    FFileResults: TTntStringList;
    FFileName: WideString;
    FS: TFormatSettings;
    FTool: TCobTools;
    FTemp: WideString;
    FAppPath: WideString;
    FBackupType: integer;
    FUseAttributes: boolean;
    FSeparated: boolean;
    FDTFormat: WideString;
    FDoNotSeparate: boolean;
    FDoNotUseSpaces: boolean;
    FSlow: boolean;
    FClearAttributes: boolean;
    FDeleteEmptyFolders: boolean;
    FAbsolutePaths: boolean;
    FSubdirs: boolean;
    FExcludeMask: WideString;
    FIncludeMask: WideString;
    FCompressionLevel: integer;
    FDoNotCompress: WideString;
    FUseTaskName: boolean;
    FTaskName: WideString;
    FCheckArchives: boolean;
    FAdvancedNaming: boolean;
    FOEM: boolean;
    FZip64: integer;
    FWillBeFTPed: boolean;
    FTotalFiles: int64;
    FCurrentFiles: int64;
    FProtect: boolean;
    FPassword: WideString;
    FSplit: integer;
    FCustomSize: int64;
    FCheckingCRC: boolean;
    FComment: WideString;
    FCurrentFile: WideString;
    FLastPercent: integer;
    FLastElement: boolean;
    FPropagate: boolean;
    function GetBaseArchiveName(const Source: WideString): WideString;
    procedure Log(const Msg: WideString; const Error, Verbose: boolean);
    function GetArchiveName(const BaseName: WideString): WideString;
    procedure PopulateZip(const Source: WideString);
    function DoAbort(): boolean;
    procedure FileBegin(const FileName: WideString; const Checking: boolean);
    procedure FileEnd(const FileName: WideString; const Checking: boolean);
    procedure PercentDone (const FileName: WideString; const Percent: integer; const Checking: boolean);
    procedure ApplySettings(const Source: WideString);
    function GetRoot(const Source: WideString): WideString;
    function GetBaseDir(const Source: WideString): WideString;
    function GetParentDir(const Dir: WideString): WideString;
    //procedure AddIncludeMasks();
    procedure AddFile(const FileName: WideString);
    procedure AddDirectory(const Directory: WideString);
    procedure AddNormalMasks(const Source: WideString);
    procedure CheckEvents();
    procedure CheckCRC();
    function AddMasks(const Masks: WideString): WideString;
    // Events
    procedure OnAfterOpen(Sender: TObject);
    procedure OnConfirmOverwrite(Sender: TObject;
              SourceFileName: string; var DestFileName: string; var Confirm: Boolean);
    procedure OnConfirmProcessFile(Sender: TObject; FileName: string;
                Operation: TZFProcessOperation; var Confirm: Boolean);
    procedure OnCopyTempFileProgress(Sender: TObject; Progress: Double;
            ProgressPhase: TZFProgressPhase; var Cancel: Boolean);
    procedure OnFileProgress(Sender: TObject; FileName: string;
            Progress: Double; Operation: TZFProcessOperation;
            ProgressPhase: TZFProgressPhase; var Cancel: Boolean);
    procedure OnOverallProgress(Sender: TObject; Progress: Double;
              Operation: TZFProcessOperation; ProgressPhase: TZFProgressPhase;
              var Cancel: Boolean);
    procedure OnPassword(Sender: TObject; FileName: string;
                        var NewPassword: string; var SkipFile: Boolean);
    procedure OnProcessFileFailure(Sender: TObject; FileName: string;
            Operation: TZFProcessOperation; NativeError, ErrorCode: Integer;
              ErrorMessage: string; var Action: TZFAction);
    procedure OnRequestBlankVolume(Sender: TObject;
            VolumeNumber: Integer; var VolumeFileName: string; var Cancel: Boolean);
    procedure ClearAttributes();
  end;

implementation

uses bmConstants, CobCommonW, bmTranslator;

{ TZipper }

procedure TZipper.AddDirectory(const Directory: WideString);
var
  SR: TSearchRecW;
  Dir: WideString;
  procedure AnalyzeFile();
  begin
    if (SR.Name <> WS_CURRENTDIR) and (SR.Name <> WS_PARENTDIR) then
      if (SR.Attr and faDirectory > 0) then
      begin
        if FSubdirs then
          AddDirectory(Dir + SR.Name);
      end else
        AddFile(Dir + SR.Name)
  end;
begin
  Dir := CobSetBackSlashW(Directory);

  if WideFindFirst(Dir + WS_ALLFILES, faAnyFile, SR) = 0 then
  begin
    AnalyzeFile();
    while WideFindNext(SR) = 0 do
    begin
      AnalyzeFile();
      if DoAbort() then
        Break;
    end;
    WideFindClose(SR);
  end;
end;



procedure TZipper.AddFile(const FileName: WideString);
begin
  //2005-10-12, by Luis Cobian
  // The except masks are now added manually because the
  // integrated in the component Except list doesn't work allright
  // if the file is not in the Exclude list then add it

  //2006-06-27 Mergin exclude cases with Include
  if (FIncludeMask <> WS_NIL) then
    if (not FTool.IsInTheMask(FileName, FIncludeMask, FPropagate)) then
    begin
      Log(WideFormat(Translator.GetMessage('328'),[FileName],FS), false, true);
      Exit;
    end;

  if (FExcludeMask <> WS_NIL) then
    if (FTool.IsInTheMask(FileName,FExcludeMask, FPropagate)) then
    begin
      Log(WideFormat(Translator.GetMessage('328'),[FileName],FS), false, true);
      Exit;
    end;

  if FBackupType <> INT_BUFULL then
    if (FUseAttributes) then
      if FTool.GetArchiveAttributeW(FileName)= false then
      begin
        Log(WideFormat(Translator.GetMessage('329'),[FileName],FS), false, true);
        Exit;
      end;

  // If not using the archive attribute the file will be added anyway and handled internally

  // 2005-07-07 by Luis Cobian
  // If the list contains 2 files of type
  // A long file name.doc
  // and other with the name
  // Alongf~1.doc, then Windows will think that the second file
  // is the same than the first one, and when extracting
  // the second will overwrite the first one. Adding the file
  // with the short name first fixes the problem.

  if CobPosW(WS_TILDE,  FileName, true) = 0 then
    FZip.FileMasks.Add(AnsiString(FileName)) else
    FZip.FileMasks.Insert(0, AnsiString(FileName));
end;

{procedure TZipper.AddIncludeMasks();
var
  Include: TTntStringList;
  i: integer;
  Dir, Mask: WideString;
begin
  Include:= TTntStringList.Create();
  try
    Include.CommaText:= FIncludeMask;
    for i:=0 to Include.Count-1 do
    begin
      if (WideFileExists(Include[i])) then
      begin
        AddFile(Include[i]);
        Continue;
      end;

      Dir:= WideExtractFilePath(Include[i]);
      if (Dir = WS_NIL) then
        Dir:= WideString(FZip.BaseDir);

      Mask:= WideExtractFileName(Include[i]);

      AddDirectory(Dir, Mask);

      if (DoAbort) then
        Break;
    end;
  finally
    FreeAndNil(Include);
  end;
end;   }

function TZipper.AddMasks(const Masks: WideString): WideString;
var
  Sl: TTntStringList;
  i: integer;
begin
  /// Because all extension related functions are added as .ext,
  ///  just add the * here

  Sl := TTntStringList.Create();
  try
    Sl.CommaText := Masks;
    for i := 0 to Sl.Count - 1 do
      Sl[i] := WS_JOCKER + Sl[i];
    Result := Sl.CommaText;
  finally
    FreeAndNil(Sl);
  end;
end;

procedure TZipper.AddNormalMasks(const Source: WideString);
var
  Sl: TTntStringList;
  i, Kind: integer;
  ASource: WideString;
begin
  Sl:= TTntStringList.Create();
  try
    Sl.CommaText:= Source;

    for i:=0 to Sl.Count-1 do
    begin
      ASource:= FTool.DecodeSD(Sl[i],Kind);

      if (ASource = WS_NIL) then
        Continue;

      if (Kind = INT_SDDIR) then
        AddDirectory(ASource) else
        AddFile(ASource);

      if (DoAbort) then
        Break;;
    end;
  finally
    FreeAndNil(Sl);
  end;
end;

procedure TZipper.ApplySettings(const Source: WideString);
begin
  FZip.CompressionMode:= FCompressionLevel;
  FZip.TempDir:= AnsiString(FTemp);
  FZip.ExtractCorruptedFiles:= false;
  FZip.FileName:= AnsiString(FFileName);
  FZip.InMemory:= false;
  FZip.Options.CreateDirs:= true;
  FZip.Options.FlushBuffers:= true;
  FZip.Options.OEMFileNames := FOEM;
  FZip.Options.Recurse := true;
  FZip.Options.SearchAttr := INT_ALLFILES;
  FZip.Options.SetAttributes := true;
  FZip.Options.ShareMode := smShareDenyNone;
  FZip.Options.ReplaceReadOnly:= true;
  if (FAbsolutePaths) then
    FZip.Options.StorePath:= spFullPath else
    FZip.Options.StorePath:= spRelativePath;
  if (FProtect) and (FPassword <> WS_NIL) then
    FZip.Password:= AnsiString(FPassword) else
    FZip.Password:= AnsiString(WS_NIL);

  // if the archive doesn't exists and using
  // time stamps , then, make the backup full
  if (not WideFileExists(FFileName)) then
    if (not FUseAttributes) then
      FBackupType:= INT_BUFULL;

  case FSplit of
    INT_SPLITNOSPLIT: FZip.SpanningMode:= smNone;
    INT_SPLIT360K:
      begin
        if (not FSeparated) then
          FBackupType:= INT_BUFULL;
        FZip.SpanningMode:= smSplitting;
        FZip.SpanningOptions.AdvancedNaming:= FAdvancedNaming;
        FZip.SpanningOptions.FirstVolumeSize:= INT_NIL;
        FZip.SpanningOptions.VolumeSize:= vsCustom;
        FZip.SpanningOptions.CustomVolumeSize:= SIZE360K;
      end;
    INT_SPLIT720K:
      begin
        if not FSeparated then
          FBackupType := INT_BUFULL; // make it full
        FZip.SpanningMode := smSplitting;
        FZip.SpanningOptions.AdvancedNaming := FAdvancedNaming;
        FZip.SpanningOptions.FirstVolumeSize := INT_NIL;
        FZip.SpanningOptions.VolumeSize := vsCustom;
        FZip.SpanningOptions.CustomVolumeSize := SIZE720K;
      end;
    INT_SPLIT12M:
      begin
        if not FSeparated then
          FBackupType := INT_BUFULL; // make it full
        FZip.SpanningMode := smSplitting;
        FZip.SpanningOptions.AdvancedNaming := FAdvancedNaming;
        FZip.SpanningOptions.FirstVolumeSize := INT_NIL;
        FZip.SpanningOptions.VolumeSize := vsCustom;
        FZip.SpanningOptions.CustomVolumeSize := SIZE1C2M;
      end;
    INT_SPLIT14M:
      begin
        if not FSeparated then
          FBackupType := INT_BUFULL; // make it full
        FZip.SpanningMode := smSplitting;
        FZip.SpanningOptions.AdvancedNaming := FAdvancedNaming;
        FZip.SpanningOptions.FirstVolumeSize := INT_NIL;
        FZip.SpanningOptions.VolumeSize := vs1_44MB;
      end;
    INT_SPLIT100M:
      begin
        if not FSeparated then
          FBackupType := INT_BUFULL; // make it full
        FZip.SpanningMode := smSplitting;
        FZip.SpanningOptions.AdvancedNaming := FAdvancedNaming;
        FZip.SpanningOptions.FirstVolumeSize := INT_NIL;
        FZip.SpanningOptions.VolumeSize := vs100MB;
      end;
    INT_SPLIT250M:
      begin
        if not FSeparated then
          FBackupType := INT_BUFULL; // make it full
        FZip.SpanningMode := smSplitting;
        FZip.SpanningOptions.AdvancedNaming := FAdvancedNaming;
        FZip.SpanningOptions.FirstVolumeSize := INT_NIL;
        FZip.SpanningOptions.VolumeSize := vs250MB;
      end;
    INT_SPLIT650M:
      begin
        if not FSeparated then
          FBackupType := INT_BUFULL; // make it full
        FZip.SpanningMode := smSplitting;
        FZip.SpanningOptions.AdvancedNaming := FAdvancedNaming;
        FZip.SpanningOptions.FirstVolumeSize := INT_NIL;
        FZip.SpanningOptions.VolumeSize := vs650MB;
      end;
    INT_SPLIT700M:
      begin
        if not FSeparated then
          FBackupType := INT_BUFULL; // make it full
        FZip.SpanningMode := smSplitting;
        FZip.SpanningOptions.AdvancedNaming := FAdvancedNaming;
        FZip.SpanningOptions.FirstVolumeSize := INT_NIL;
        FZip.SpanningOptions.VolumeSize := vs700MB;
      end;
    INT_SPLIT1G:
      begin
        if not FSeparated then
          FBackupType := INT_BUFULL; // make it full
        FZip.SpanningMode := smSplitting;
        FZip.SpanningOptions.AdvancedNaming := FAdvancedNaming;
        FZip.SpanningOptions.FirstVolumeSize := INT_NIL;
        FZip.SpanningOptions.VolumeSize := vsCustom;
        FZip.SpanningOptions.CustomVolumeSize := SIZE1C0G;
      end;
    INT_SPLIT47G:
      begin
        if not FSeparated then
          FBackupType := INT_BUFULL; // make it full
        FZip.SpanningMode := smSplitting;
        FZip.SpanningOptions.AdvancedNaming := FAdvancedNaming;
        FZip.SpanningOptions.FirstVolumeSize := INT_NIL;
        FZip.SpanningOptions.VolumeSize := vsCustom;
        FZip.SpanningOptions.CustomVolumeSize := SIZE4C7G;
      end;
    INT_SPLITCUSTOM:
      begin
        if not FSeparated then
          FBackupType := INT_BUFULL; // make it full
        FZip.SpanningMode := smSplitting;
        FZip.SpanningOptions.AdvancedNaming := FAdvancedNaming;
        FZip.SpanningOptions.FirstVolumeSize := INT_NIL;
        FZip.SpanningOptions.VolumeSize := vsCustom;
        FZip.SpanningOptions.CustomVolumeSize := FCustomSize;
      end;
    else
      FZip.SpanningMode:= smNone;
  end;

  case FZip64 of
    INT_ZIP64ALWAYS: FZip.Zip64Mode := zmAlways;
    INT_ZIP64NEVER: FZip.Zip64Mode:= zmDisabled;
    else
      FZip.Zip64Mode:= zmAuto;
  end;

  if (not FUseAttributes) and (FBackupType <> INT_BUFULL) then
    FZip.Options.OverwriteMode := omIfNewer else
    FZip.Options.OverwriteMode := omAlways;

  FZip.NoCompressionMasks.CommaText:= AnsiString(AddMasks(FDoNotCompress));
  FZip.BaseDir:= AnsiString(GetRoot(Source));
end;

procedure TZipper.CheckCRC();
begin
  if (not WideFileExists(FFileName)) then
    Exit;

  FCurrentFiles:= 0;
  try
    FZip.FileMasks.Clear();
    FZip.ExclusionMasks.Clear();
    FZip.NoCompressionMasks.Clear();
    FZip.Options.Recurse:= true;
    FZip.Options.OverwriteMode:= omAlways;
    FZip.FileMasks.Add(WS_ALLFILES);
    FZip.FileName := FFileName;
    FCheckingCRC:= true;
    FZip.OpenArchive(fmOpenRead or fmShareExclusive);
    try
      FZip.TestFiles();
      Log(WideFormat(Translator.GetMessage('341'),[FCurrentFiles,FFileName],FS),false,false);
    finally
      FZip.CloseArchive();
    end;
  except
    on E:Exception do
    begin
      Log(WideFormat(Translator.GetMessage('340'),[FFileName, WideString(E.Message)],FS),true, false);
    end;
  end;
end;

procedure TZipper.CheckEvents();
begin
  FZip.AfterOpen:= OnAfterOpen;
  FZip.OnConfirmOverwrite:= OnConfirmOverwrite;
  FZip.OnConfirmProcessFile:= OnConfirmProcessFile;
  FZip.OnCopyTempFileProgress:= OnCopyTempFileProgress;
  FZip.OnFileProgress:= OnFileProgress;
  FZip.OnOverallProgress:= OnOverallProgress;
  FZip.OnPassword := OnPassword;
  FZip.OnProcessFileFailure := OnProcessFileFailure;
  FZip.OnRequestBlankVolume := OnRequestBlankVolume;
end;

procedure TZipper.ClearAttributes();
var
  i: integer;
  FileName: WideString;
begin
  if not FClearAttributes then
    Exit;

  if not FLastElement then
    Exit;

  if FBackupType = INT_BUDIFFERENTIAL then //Differential
    Exit;

  for i := 0 to FZip.FileMasks.Count - 1 do
  begin
    FileName:= FZip.FileMasks[i];
    if FTool.SetArchiveAttributeW(FileName, false) then
      Log(WideFormat(Translator.GetMessage('267'),[FileName], FS), false, true) else
      Log(WideFormat(Translator.GetMessage('268'),[FileName], FS), false, true);  // not an error

    if (DoAbort()) then
      Break;
  end;
end;

constructor TZipper.Create(const Rec: TZipperRec);
begin
  inherited Create();
  FTemp:= Rec.Temp;
  FAppPath:= Rec.AppPath;
  FBackupType:= Rec.BackupType;
  FUseAttributes:= Rec.UseAttributes;
  FSeparated:= Rec.Separated;
  FDTFormat:= Rec.DTFormat;
  FDoNotSeparate:= Rec.DoNotSeparate;
  FDoNotUseSpaces:= Rec.DoNotUseSpaces;
  FSlow:= Rec.Slow;
  FClearAttributes:= Rec.ClearAttributes;
  FDeleteEmptyFolders:= Rec.DeleteEmptyFolders;
  FAbsolutePaths:= Rec.AbsolutePaths;
  FSubdirs:= Rec.Subdirs;
  FExcludeMask:= Rec.ExcludeMask;
  FIncludeMask:= Rec.IncludeMask;
  FCompressionLevel:= Rec.CompressionLevel;
  FDoNotCompress:= rec.DoNotCompress;
  FUseTaskName:= Rec.UseTaskName;
  FTaskName:= Rec.TaskName;
  FCheckArchives:= Rec.CheckArchives;
  FAdvancedNaming:= Rec.AdvancedNaming;
  FOEM:= Rec.OEM;
  FZip64:= Rec.Zip64;
  FWillBeFTPed:= Rec.WillBeFTPded;
  FProtect:= Rec.Protect;
  FPassword:= Rec.Password;
  FSplit:= Rec.Split;
  FCustomSize:= Rec.CustomSize;
  FComment:= Rec.Comment;
  FPropagate:= Rec.Propagate;

  FTotalFiles:= 0;
  FCurrentFiles:= 0;

  FFileResults:= TTntStringList.Create();
  FTool:= TCobTools.Create();
  FZip:= TZipForge.Create(nil);

  GetLocaleFormatSettings(LOCALE_SYSTEM_DEFAULT, FS);
end;

destructor TZipper.Destroy();
begin
  FreeAndNil(FZip);
  FreeAndNil(FTool);
  FreeAndNil(FFileResults);
  inherited Destroy();
end;

function TZipper.DoAbort(): boolean;
begin
  Result:= false;
  if (Assigned(OnAbort)) then
    Result:= OnAbort();
end;

procedure TZipper.FileBegin(const FileName: WideString;
  const Checking: boolean);
begin
  if (Assigned(OnFileBegin)) then
    OnFileBegin(FileName, Checking);
end;

procedure TZipper.FileEnd(const FileName: WideString; const Checking: boolean);
begin
  if (Assigned(OnFileEnd)) then
    OnFileEnd(FileName, Checking);
end;

function TZipper.GetArchiveName(const BaseName: WideString): WideString;
begin
  Result:= BaseName;

  if (FWillBeFTPed) then
    Exit; // the FTP object will add the date if necesary

  if (not FSeparated) then
    Exit;

  Result:= FTool.GetFileNameSeparatedW(BaseName, FDTFormat, not FDoNotSeparate, Now());

  if (FDoNotUseSpaces) then
    Result:= FTool.DeleteSpacesW(Result);
end;

function TZipper.GetBaseArchiveName(const Source: WideString): WideString;
var
  Sl: TTntStringList;
  ASource: WideString;
  Kind: integer;
begin
  if (FUseTaskName) then
  begin
    Result:= FTaskName + WS_ZIPEXT;
    Exit;
  end;

  Sl:= TTntStringList.Create();
  try
    Sl.CommaText:= Source;
    if (Sl.Count > 1) then
    begin
      Result:= FTaskName + WS_ZIPEXT;
      Exit;
    end;

    ASource:= FTool.DecodeSD(Sl[0],Kind);
    case Kind of
      INT_SDFILE: Result:= WideChangeFileExt(WideExtractFileName(ASource), WS_ZIPEXT);
      INT_SDDIR: Result:= CobGetShortDirectoryNameW(ASource) + WS_ZIPEXT;
      else
        Result:= Translator.GetMessage('325') + WS_ZIPEXT;
    end;
  finally
    FreeAndNil(Sl);
  end;
end;

function TZipper.GetBaseDir(const Source: WideString): WideString;
var
  Kind: integer;
begin
  Result:= FTool.DecodeSD(Source,Kind);
  if (Kind = INT_SDFILE) then
    Result:= WideExtractFileDir(Result);
end;

function TZipper.GetParentDir(const Dir: WideString): WideString;
begin
  Result:= FTool.GetParentDirectory(Dir);
end;

function TZipper.GetRoot(const Source: WideString): WideString;
var
  Sl: TTntStringList;
begin
  Result:= WS_NIL;
  Sl:= TTntStringList.Create();
  try
    Sl.CommaText:= Source;

    if (Sl.Count = 1) then
      Result:= GetBaseDir(Sl[0]) else
      Result:= GetParentDir(GetBaseDir(Sl[0])); 
  finally
    FreeAndNil(Sl);
  end;
end;

procedure TZipper.Log(const Msg: WideString; const Error, Verbose: boolean);
begin
  if (Assigned(OnLog)) then
    OnLog(msg,Error,Verbose);
end;

procedure TZipper.OnAfterOpen(Sender: TObject);
begin
  Log(WideFormat(Translator.GetMessage('331'),[FFileName],FS),false, true);  
end;

procedure TZipper.OnConfirmOverwrite(Sender: TObject; SourceFileName: string;
  var DestFileName: string; var Confirm: Boolean);
begin
  /// This will never get fired because Overwrite <> omPrompt
  /// but I am just translating from the VCLZip component
  Log(WideFormat(Translator.GetMessage('332'),
      [SourceFileName, FFileName], FS), false, true);
end;

procedure TZipper.OnConfirmProcessFile(Sender: TObject; FileName: string;
  Operation: TZFProcessOperation; var Confirm: Boolean);
begin
  Confirm:= not DoAbort();
end;

procedure TZipper.OnCopyTempFileProgress(Sender: TObject; Progress: Double;
  ProgressPhase: TZFProgressPhase; var Cancel: Boolean);
begin
  Cancel := DoAbort();
  if (ProgressPhase = ppStart) then
    Log(WideFormat(Translator.GetMessage('333'),[FFileName],FS), false, true);
end;

procedure TZipper.OnFileProgress(Sender: TObject; FileName: string;
  Progress: Double; Operation: TZFProcessOperation;
  ProgressPhase: TZFProgressPhase; var Cancel: Boolean);
begin
  Cancel := DoAbort();
  case ProgressPhase of
    ppStart:
      begin
        FCurrentFile := WideString(FileName);
        FileBegin(WideString(FileName), FCheckingCRC);
      end;
    ppEnd:
      begin
        inc(FCurrentFiles);
        FileEnd(WideString(FileName), FCheckingCRC);
        /// I could have this here, but that could cause that if the compression is aborted
        ///  then some files would have their archive attributes reset.
        ///  That is NOT good.
        ///  This has been moved to ClearAttributes()
        {if (FClearAttributes) and (not FCheckingCRC) and (FLastElement) then
          if FTool.SetArchiveAttributeW(WideString(FileName),false) then
            Log(WideFormat(Translator.GetMessage('267'),[WideString(FileName)],FS),false, true) else
            Log(WideFormat(Translator.GetMessage('268'),[WideString(FileName)],FS),false, true); // not an error  }
      end;
    ppProcess: //do nothing;
  end;

end;

procedure TZipper.OnOverallProgress(Sender: TObject; Progress: Double;
  Operation: TZFProcessOperation; ProgressPhase: TZFProgressPhase;
  var Cancel: Boolean);
var
  PercentInt: integer;
begin
  PercentInt := trunc(Progress);
  if (PercentInt <> FLastPercent) then
  begin
    FLastPercent := PercentInt;
    PercentDone(FCurrentFile, PercentInt, FCheckingCRC);

    if FSlow then
      if (PercentInt mod INT_FIVEMULTIPLE) = 0 then
        Sleep(INT_SLOW);
  end;

  Cancel := DoAbort();
end;


procedure TZipper.OnPassword(Sender: TObject; FileName: string;
  var NewPassword: string; var SkipFile: Boolean);
begin
  NewPassword := AnsiString(FPassword);
end;

procedure TZipper.OnProcessFileFailure(Sender: TObject; FileName: string;
  Operation: TZFProcessOperation; NativeError, ErrorCode: Integer;
  ErrorMessage: string; var Action: TZFAction);
begin
  if (not FCheckingCRC) then
    Log(WideFormat(Translator.GetMessage('337'),
                  [WideString(FileName),WideString(ErrorMessage)],FS),true, false) else
    Log(WideFormat(Translator.GetMessage('336'),
                  [WideString(FileName),WideString(ErrorMessage)],FS),true, false);
  Action:= fxaIgnore;
end;

procedure TZipper.OnRequestBlankVolume(Sender: TObject; VolumeNumber: Integer;
  var VolumeFileName: string; var Cancel: Boolean);
begin
  /// Add the parts into the list
  FFileResults.Add(WideString(VolumeFileName));
end;

procedure TZipper.PercentDone(const FileName: WideString;
  const Percent: integer; const Checking: boolean);
begin
  if (Assigned(OnPercentDone)) then
    OnPercentDone(FileName, Percent, Checking);
end;

procedure TZipper.PopulateZip(const Source: WideString);
begin
  FZip.FileMasks.Clear();
  FZip.ExclusionMasks.Clear();
  // FZip.NoCompressionMasks.Clear(); This is added on ApplySettings
  {if (FIncludeMask <> WS_NIL) then   THIS WAS WORKING BAD. This procedure is now merged with AddNormalMasks
    AddIncludeMasks() else   }

  AddNormalMasks(Source);
end;

function TZipper.Zip(const Source, Destination: WideString; const LastElement:boolean): WideString;
var
  Count: integer;
  Adestination: WideString;
begin
  Result:= WS_NIL;
  FFileResults.Clear();
  FLastElement:= LastElement;


  ADestination:=  FTool.NormalizeFileName(Destination);
  // Zip components are not unicode, so do not use the normalized string here

  if (not WideDirectoryExists(ADestination)) then
  begin
    Log(WideFormat(Translator.GetMessage('273'),[Destination],FS),false,true);  // log unnormalized
    if (not WideForceDirectories(ADestination)) then
    begin
      Log(WideFormat(Translator.GetMessage('274'),[Destination],FS),true,false);
      Exit;
    end else
      Log(WideFormat(Translator.GetMessage('275'),[Destination],FS),false,true);
  end;

  ADestination:= CobSetBackSlashW(Destination);  // Back to the unnormalized path

  FFileName:= GetBaseArchiveName(Source);
  FFileName:= ADestination + GetArchiveName(FFileName);

  if (Source = WS_NIL) then
  begin
    Log(Translator.GetMessage('327'),true, false);
    Exit;
  end;

  Log(WideFormat(Translator.GetMessage('326'),[FFileName],FS), false, false);

  CheckEvents();

  ApplySettings(Source);

  // Populate the zip component with the needed files
  PopulateZip(Source);

  FCheckingCRC:= false;
  FLastPercent:= -1;
  FCurrentFiles:= 0;

  try
    {if (FBackupType = INT_BUFULL) then
    begin
      //THIS WAS MAKING A MIRROR! THE HORRORRRRRRR!!!!!!!!
      if (WideFileExists(FFileName)) then
        DeleteFileW(PWideChar(FFileName));
      
      if (WideFileExists(FFileName)) then
        FZip.OpenArchive(fmOpenReadWrite or fmShareExclusive) else
        FZip.OpenArchive(fmCreate or fmShareExclusive);
    end else
    begin
      if (WideFileExists(FFileName)) then
        FZip.OpenArchive(fmOpenReadWrite or fmShareExclusive) else
        FZip.OpenArchive(fmCreate or fmShareExclusive);
    end;  }

    if (WideFileExists(FFileName)) then
    begin
      if (FSplit <> INT_SPLITNOSPLIT) then     // 2006-06-15 if splitting, DELETE
      begin
        DeleteFileW(PWideChar(FFileName));
        FZip.OpenArchive(fmCreate or fmShareExclusive);
      end else
      FZip.OpenArchive(fmOpenReadWrite or fmShareExclusive);
    end else
      FZip.OpenArchive(fmCreate or fmShareExclusive);

    try

      FZip.Comment:= AnsiString(FComment);

      {if (not FUseAttributes) and (FBackupType <> INT_BUFULL) then
          /// in this case, just copy the files that are changed
          /// this is done in UpdateFiles
          FZip.UpdateFiles() else   }
      /// There are problems with UpdateFiles so I use FZip.Options.OverwriteMode := omIfNewer
      ///  in ApplySettings

      FZip.AddFiles();

      if (DoAbort) then
        Exit;

      if FSplit = INT_SPLITNOSPLIT then
        FFileResults.Add(FFileName)
      else {// the las part must be renamed to ZIP}
      if FFileResults.Count > 0 then
      // 2005-06-23 by Luis Cobian
      // I need to rename the file also when the advanced file name  is checked
        if not FAdvancedNaming then
          FFileResults[FFileResults.Count - 1] :=
            WideChangeFileExt(FFileResults[FFileResults.Count - 1], WS_ZIPEXT) else
          FFileResults[FFileResults.Count - 1] := WideString(FZip.FileName);

      Result := FFileResults.CommaText;

      ClearAttributes();

      Log(WideFormat(Translator.GetMessage('338'),[FFileName,FCurrentFiles],FS),false,false);

    finally
      FZip.CloseArchive();
    end;

    Sleep(INT_SLOW);

    if (DoAbort()) then
    begin
      Result:= WS_NIL;
      Exit;
    end;

    // if the created archive is empty, just delete it

    if (FCurrentFiles = 0) then  // if no files were added, check if there were files in the archive from other sessions
      if (WideFileExists(FFileName)) then
      begin
        FZip.FileMasks.Clear();
        FZip.FileMasks.Add(WS_ALLFILES);
        FZip.Options.Recurse:= true;
        FZip.ExclusionMasks.Clear();
        FZip.NoCompressionMasks.Clear();
        FZip.FileName:= AnsiString(FFileName);
        FZip.OpenArchive(fmOpenRead or fmShareExclusive);
        try
          Count:= FZip.FileCount;
        finally
          FZip.CloseArchive();
        end;

        if (Count = 0) then
        begin
          FFileResults.Clear();
          Result:= WS_NIL;
          if (WideFileExists(FFileName)) then
            DeleteFileW(PWideChar(FFileName));
          Log(WideFormat(Translator.GetMessage('339'),[FFileName],FS),false,false);
        end;
      end;
  except
    on E:Exception do
    begin
      Result:= WS_NIL;
      FFileResults.Clear();
      Log(WideFormat(Translator.GetMessage('330'),[WideString(FFileName),WideString(E.Message)],FS), true, false);
      Exit;
    end;
  end;

  if (DoAbort()) then
  begin
    Result:= WS_NIL;
    Exit;
  end;

  if (FCheckArchives) then
    CheckCRC();
end;

end.
