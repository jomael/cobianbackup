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

// Unit for compression using SQX

unit engine_SQX;

interface

uses Classes, bmCommon, TntClasses, SysUtils, TntSysUtils, Windows,
    uSQX_Ctrl, uSQX_Errors;

type
  TSQXRec = record
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
    DoNotCompress: WideString;
    UseTaskName: boolean;
    TaskName: WideString;
    CheckArchives: boolean;
    WillBeFTPed: boolean;
    Protect: boolean;
    OEM: boolean;
    Password: WideString;
    Split: integer;
    CustomSize: int64;
    Comment: WideString;
    SqxLevel: integer;
    SqxDictionary: integer;
    SqxRecovery: integer;
    SqxExternal: boolean;
    SqxSolid: boolean;
    SqxExe: boolean;
    SqxMultimedia: boolean;
    Propagate: boolean;
  end;

  TSQX = class(TObject)
  public
    OnAbort: TCobAbort;
    OnLog: TCobLogEvent;
    OnFileBegin: TCobCompressFileBeginEnd;
    OnFileEnd: TCobCompressFileBeginEnd;
    OnPercentDone: TCobCompressPercentDone;
    constructor Create(const Rec: TSQXRec);
    destructor Destroy();override;
    function SQX(const Source, Destination: WideString; const LastElement:boolean): WideString;
  private
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
    FDoNotCompress: WideString;
    FUseTaskName: boolean;
    FTaskName: WideString;
    FCheckArchives: boolean;
    FOEM: boolean;
    FWillBeFTPed: boolean;
    FProtect: boolean;
    FPassword: WideString;
    FSplit: integer;
    FCustomSize: int64;
    FComment: WideString;
    FSqxLevel: integer;
    FSqxDictionary: integer;
    FSqxRecovery: integer;
    FSqxExternal: boolean;
    FSqxSolid: boolean;
    FSqxExe: boolean;
    FSqxMultimedia: boolean;
    FLastElement: boolean;
    FPropagate: boolean;

    FFilesResult: TTntStringList;
    FTools: TCobTools;
    FS: TFormatSettings;
    FFileName: WideString;
    FFileList: TTntStringList;
    FUsingBaseDir: boolean;

    /// This handle is initalized by the SDK wrapper and it is required by all
    /// other functions you are going to call.
    FHandle: SQX_ARCER_HANDLE;
    /// Used to control the settings of the SQX library
    CompressSettings: SQX_COMPRESS_SETTINGS;

    FList: FILE_LIST;
    FCheckingCRC: boolean;
    FRootDir: WideString;
    FLastPercent: integer;
    FCounter: int64;
    FCountFilesArchive: int64;

    function DoAbort(): boolean;
    procedure Log(const Msg: WideString; const Error, Verbose: boolean);
    procedure FileBegin(const FileName: AnsiString; const Checking: boolean);
    procedure FileEnd(const FileName: AnsiString; const Checking: boolean);
    procedure Progress(const FileName: AnsiString; const Percent: integer; const Checking: boolean);
    function GetBaseArchiveName(const Source: WideString): WideString;
    function GetArchiveName(const BaseName: WideString): WideString;
    function LoadSQX(): boolean;
    procedure PrepareCompressSettings();
    function GetRootDirectory(const Source: WideString): WideString;
    function GetBaseDir(const Source: WideString): WideString;
    function GetParentDir(const Dir: WideString): WideString;
    procedure PopulateFileList(const Source: WideString);
    procedure AddFile(const FileName: WideString);
    procedure AddDirectory(const Source: WideString);
    // procedure PopulateListIncludeMask();
    procedure CheckRelativePaths();
    function OnlyParents(): boolean;
    function GetRelativePath(const FileName: WideString): WideString;
    function Compress(): boolean;
    /// This function will be used as a callback for the DLL
    /// Must return 0 if there is need to cancel
    function Callback(var SqxCallbackStruct: SQX_CALLBACK_STRUCT): longint;
    function GetSQXError(const Error: longint): WideString;
    procedure AddAllResultParts();
    procedure AddPartsSplit();
    procedure AddArchiveComment();
    procedure ClearAttributes();
    function GetFilesCount(): int64;
    procedure CheckArchive();
  end;

implementation

uses bmConstants, bmTranslator, CobCommonW;

///**************************************************
///Callback

function SqxCallBackProc(lpVoid: pointer;
  var CallBackStruct: SQX_CALLBACK_STRUCT): SLONG32; stdcall;
begin
  Result := TSqx(lpvoid).Callback(CallBackStruct);
end;
///*****************************************************

{ TSQX }

procedure TSQX.AddAllResultParts();
var
  Ext: WideString;
begin
  if FSplit = INT_SPLITNOSPLIT then
  begin
    if WideFileExists(FFileName) then
      FFilesResult.Add(FFileName);

    if FSqxExternal then
    begin
      Ext := FFileName + WS_SQXRECEXT;
      if WideFileExists(Ext) then
        FFilesResult.Add(Ext);
    end;
  end
  else
    AddPartsSplit();
end;


procedure TSQX.AddArchiveComment();
var
  lRes: longint;
begin
  // Add the comment
  if FSplit = INT_SPLITNOSPLIT then // cannot add comment to split files
    if FComment <> WS_NIL then
    begin
      lRes := SqxAddArchiveComment(FHandle, AnsiString(FFileName), AnsiString(FComment),
            SqxCallBackProc, self);
      if lRes <> SQX_EC_OK then
        Log(WideFormat(Translator.GetMessage('392'),[FFileName, GetSQXError(lRes)],FS), true, false);
    end;
end;

procedure TSQX.AddDirectory(const Source: WideString);
var
  SR: TSearchRecW;
  ASource: WideString;
  //***********************************
  procedure AnalyzeFile();
  begin
    if (SR.Name <> WS_CURRENTDIR) and (SR.Name <> WS_PARENTDIR) then
      if (SR.Attr and faDirectory > 0) then
      begin
        if FSubdirs then
          AddDirectory(CobSetBackSlashW(Source) + SR.Name);
      end else
        AddFile(CobSetBackSlashW(Source) + SR.Name);
  end;
  //***********************************
begin
  ASource := CobSetBackSlashW(FTools.NormalizeFileName(Source));
  if WideFindFirst(ASource + WS_ALLFILES, faAnyFile, SR) = 0 then
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

procedure TSQX.AddFile(const FileName: WideString);
begin
  // if the file is not in the Exclude list then add it

  if (FIncludeMask <> WS_NIL) then
    if (not FTools.IsInTheMask(FileName, FIncludeMask, FPropagate)) then
    begin
      Log(WideFormat(Translator.GetMessage('328'),[FileName],FS), false, true);
      Exit;
    end;

  if (FExcludeMask <> WS_NIL) then
    if FTools.IsInTheMask(FileName, FExcludeMask, FPropagate) then
    begin
      Log(WideFormat(Translator.GetMessage('328'),[FileName],FS), false, true);
      Exit;
    end;

  if (FUseAttributes) then
    if (FBackupType <> INT_BUFULL) then
      if FTools.GetArchiveAttributeW(FileName) = false then
      begin
        Log(WideFormat(Translator.GetMessage('344'),[FileName],FS),false,true);
        Exit;
      end;

  // 2005-07-07 by Luis Cobian
  // If the list contains 2 files of type
  // A long file name.doc
  // and other with the name
  // Alongf~1.doc, then Windows will think that the second file
  // is the same than the first one, and when extracting
  // the second will overwrite the first one. Adding the file
  // with the short name first solves the problem.

  if CobPosW(WS_TILDE, FileName, true) = 0 then
    FFileList.Add(FileName) else
    FFileList.Insert(0, FileName);
end;

procedure TSQX.AddPartsSplit();
var
  SR: TSearchRecW;
  MaskName, Dir, Ext: WideString;
  //***********************************************
  procedure AddPart();
  begin
    if (SR.Attr and faDirectory) > 0 then
      Exit;
    /// This will be added later, but do not add them twice.
    /// Only if FMakeExternalRecovery = true
    if WideExtractFileExt(SR.Name) = WS_SQXRECEXT then
      Exit;
    FFilesResult.Add(Dir + SR.Name);
    if FSqxExternal then
    begin
      Ext := Dir + SR.Name + WS_SQXRECEXT;
      if WideFileExists(Ext) then
        FFilesResult.Add(Ext);
    end;
  end;
begin
  MaskName := WideChangeFileExt(FFileName, WS_JOCKERDOT);
  Dir := CobSetbackSlashW(WideExtractFilePath(FFileName));
  if WideFindFirst(MaskName, faAnyFile, SR) = 0 then
  begin
    AddPart();
    while WideFindNext(SR) = 0 do
    begin
      AddPart();
      if DoAbort() then
        Break;
    end;
    WideFindClose(SR);
  end;
end;

function TSQX.Callback(var SqxCallbackStruct: SQX_CALLBACK_STRUCT): longint;
var
  Percent: integer;
  FileReplaced, FileName, Password: AnsiString;
begin
  Result := INT_SQXCONTINUE;

  if DoAbort() then
  begin
    Result := INT_SQXCANCEL;
    Exit;
  end;

  // Analize the received info
  if (SqxCallbackStruct.uAction = SQX_ACTION_PREPARE_COMPRESS) then
  begin
    // A file is about to be compressed
    //- The archiver might execute a command in the context of another command:
  //- For example, deleting files from a solid archive results in decompressing
  //- of all files of an archive and re-compressing the files that are *not*
  //- deleted from the archive.
  //-
  //- Adding files to a solid archive reults in decompressing of all files of an
  //- archive and re-compressing these files togehter with the new files.
    {if Assigned(OnFileBegin) then
      if SqxCallbackStruct.uCommand = SQX_COMMAND_COMPRESS then
        OnFileBegin(string(SqxCallbackStruct.szString), FCheckingCRC) else
        OnFileBegin(string(SqxCallbackStruct.szString), true);   }

    //Make it easy
    FileBegin(AnsiString(SqxCallbackStruct.szString2), FCheckingCRC);
    Exit;
  end;

  if (SqxCallbackStruct.uAction = SQX_ACTION_PREPARE_EXTRACT) then
  begin
    // A file is about to be tested

    FileBegin(AnsiString(SqxCallbackStruct.szString), FCheckingCRC);
    Exit;
  end;

  if (SqxCallbackStruct.uAction = SQX_ACTION_FINISH_COMPRESS) then
  begin
    // A file has been  compressed
    inc ( FCounter);
    FileEnd(AnsiString(SqxCallbackStruct.szString2), FCheckingCRC);

    Exit;
  end;

  if (SqxCallbackStruct.uAction = SQX_ACTION_FINISH_EXTRACT) then
  begin
    // A file has been  extracted
    inc ( FCounter);
    FileEnd(AnsiString(SqxCallbackStruct.szString), FCheckingCRC);
    Exit;
  end;

  if (SqxCallbackStruct.uAction = SQX_ACTION_NEED_CRYPT_KEY) then
  begin
    //if SqxCallbackStruct.lpVariable = REASON_NEED_FILE_PASSWORD then
    Password:= AnsiString(FPassword);
    StrPCopy(SqxCallbackStruct.szString2, Password);
    Exit;
  end;

  if (SqxCallbackStruct.uAction = SQX_ACTION_FILE_REPLACE) then
  begin
    // A file is about to replace an existing one

    FileReplaced :=
      StrPas(SQX_REPLACE_STRUCT_PTR(SqxCallbackStruct.lpVariable)^.szFileName);
    Log(WideFormat(Translator.GetMessage('387'),[WideString(FileReplaced), FFileName],FS), false, true);
    Result := INT_SQXREPLACE; //REPLACE THE FILE
    Exit;
  end;

  if (SqxCallbackStruct.uAction = SQX_ACTION_FILE_SKIP) then
  begin
    // A file couldn't be copied

    if (not FCheckingCRC) then
    begin
      FileName:= AnsiString(SqxCallbackStruct.szString2);
      Log(WideFormat(Translator.GetMessage('388'),[WideString(FileName)],FS),true, false);
    end else
    begin
      FileName:= AnsiString(SqxCallbackStruct.szString);
      Log(WideFormat(Translator.GetMessage('389'),[WideString(FileName)],FS),true, false);
    end;
    Exit;
  end;

  if (SqxCallbackStruct.uAction = SQX_ACTION_NEED_NEXT_VOLUME) then
  begin
    //could not find the next part
    if FCheckingCRC then
    begin
      FileName:= AnsiString(SqxCallbackStruct.szString2);
      Log(WideFormat(Translator.GetMessage('390'),[FileName],FS), true, false);
      Result := INT_SQXCANCEL;
      Exit;
    end;
  end;

  if (SqxCallbackStruct.uAction = SQX_ACTION_PROGRESS) then
  begin
    // A percent on the file, not on the total

    if FCheckingCRC then
    begin
      if FCountFilesArchive > 0 then
        Percent := Trunc((FCounter / FCountFilesArchive) * 100)
      else
        Percent := INT_100;
    end
    else
    begin
      if FFileList.Count > 0 then
        Percent := Trunc((FCounter / FFileList.Count) * 100)
      else
        Percent := INT_100;
    end;

    if Percent <> FLastPercent then
    begin
      if FCheckingCRC then
        FileName := AnsiString(SqxCallbackStruct.szString) else
        FileName := AnsiString(SqxCallbackStruct.szString2);
      FLastPercent := Percent;
      Progress(FileName, Percent, FCheckingCRC);
      if FSlow then
        if Percent mod INT_FIVEMULTIPLE = INT_NIL then
          Sleep(INT_SLOW);
      end;
    Exit;
  end;

end;
procedure TSQX.CheckArchive();
var
  lRes: longint;
begin
  try
    lRes := SqxTestFiles(FHandle, AnsiString(FFileName), SqxCallBackProc, Self);

    if (lRes <> SQX_EC_OK) then
      Log(WideFormat(Translator.GetMessage('393'),[FFileName, GetSQXError(lRes)],FS),true,false);
  except
    on E:Exception do
       Log(WideFormat(Translator.GetMessage('393'),[FFileName, WideString(E.Message)],FS),true,false);
  end;
end;

procedure TSQX.CheckRelativePaths();
var
  i: integer;
  Base: AnsiString;
begin
  FUsingBaseDir := false;

  if FAbsolutePaths then
    Exit;

  if not OnlyParents() then
    Exit;

  //if we get here, we need the relative path and we need to
  // crop it from the file path
  FUsingBaseDir := true;
  Base:= AnsiString(FRootDir);

  StrPCopy(CompressSettings.szInputPath, Base);

  for i := 0 to FFileList.Count - 1 do
    FFileList[i] := GetRelativePath(FFileList[i]);
end;

procedure TSQX.ClearAttributes();
var
  i: integer;
  FileName: WideString;
begin
  /// I could clear the attributes on the callback functions after every
  ///  file is done, but that could cause that if the compression is aborted
  ///  then some files would have their archive attributes reset.
  ///  That is NOT good.

  if not FClearAttributes then
    Exit;

  if not FLastElement then
    Exit;

  if FBackupType = INT_BUDIFFERENTIAL then //Differential
    Exit;

  for i := 0 to FFileList.Count - 1 do
  begin
    if FUsingBaseDir then
      FileName := FRootDir + FFileList[i] else
      FileName := FFileList[i];

    if FTools.SetArchiveAttributeW(FileName, false) then
      Log(WideFormat(Translator.GetMessage('267'),[FileName], FS), false, true) else
      Log(WideFormat(Translator.GetMessage('268'),[FileName], FS), false, true);

    if (DoAbort()) then
      Break;
  end;
end;

function TSQX.Compress(): boolean;
var
  lRes: longint;
  i: integer;
begin
  Result:= true;

  try

    for i := 0 to FFileList.Count - 1 do
    begin
      lRes := SqxAddFileList(FHandle, AnsiString(FFileList[i]), FList);

      if (lRes <> SQX_EC_OK) then
      begin
        Log(WideFormat(Translator.GetMessage('391'),[FFileList[i], GetSQXError(lRes)],FS),true, false);
        Continue;
      end;

      if DoAbort() then
        Break;
    end;

    if (DoAbort()) then
    begin
      Result:= false;
      Exit;
    end;

    if FList.uFileCount <> 0 then
      lRes := SqxAddFiles(FHandle, AnsiString(FFileName),
                          FList, CompressSettings, SqxCallBackProc, self) else
      begin              // no files to compress
        Log(Translator.GetMessage('345'), false, true);
        Result:= false;
        Exit;
      end;

    if (DoAbort) then
    begin
      Result:= false;
      Exit;
    end;

    if (lRes <> SQX_EC_OK) then  // some other error
    begin
      //FSQXResult.Clear();
      //Result := S_NIL;
      // The error here may not be fatal, so return true
      Log(WideFormat(Translator.GetMessage('346'),[FFileName, GetSQXError(lRes)],FS),true, false);
        //Exit;
    end;
  except
    on E:Exception do
    begin
      Result:= false;
      Log(WideFormat(Translator.GetMessage('346'),[FFileName, WideString(E.Message)],FS),true, false);
    end;
  end;
end;

constructor TSQX.Create(const Rec: TSQXRec);
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
  FDoNotCompress:= Rec.DoNotCompress;
  FUseTaskName:= Rec.UseTaskName;
  FTaskName:= Rec.TaskName;
  FOEM:= Rec.OEM;
  FCheckArchives:= Rec.CheckArchives;
  FWillBeFTPed:= Rec.WillBeFTPed;
  FProtect:= Rec.Protect;
  FPassword:= Rec.Password;
  FSplit:= Rec.Split;
  FCustomSize:= Rec.CustomSize;
  FComment:= Rec.Comment;
  FSqxLevel:= Rec.SqxLevel;
  FSqxDictionary:= Rec.SqxDictionary;
  FSqxRecovery:= Rec.SqxRecovery;
  FSqxExternal:= Rec.SqxExternal;
  FSqxSolid:= Rec.SqxSolid;
  FSqxExe:= Rec.SqxExe;
  FSqxMultimedia:= Rec.SqxMultimedia;
  FPropagate:= Rec.Propagate;

  GetLocaleFormatSettings(LOCALE_SYSTEM_DEFAULT, FS);
  FTools:= TCobTools.Create();
  FFilesResult:= TTntStringList.Create();
  FFileList:= TTntStringList.Create();

  /// Initialize the handle
  FillChar(FHandle, sizeof(SQX_ARCER_HANDLE), #0);
end;

destructor TSQX.Destroy();
begin
  FreeAndNil(FFileList);
  FreeAndNil(FFilesResult);
  FreeAndNil(FTools);
  inherited Destroy;
end;

function TSQX.DoAbort(): boolean;
begin
  Result:= false;
  if (Assigned(OnAbort)) then
    Result:= OnAbort();
end;

procedure TSQX.FileBegin(const FileName: AnsiString; const Checking: boolean);
begin
  if (Assigned(OnFileBegin)) then
    OnFileBegin(WideString(FileName),Checking);
end;

procedure TSQX.FileEnd(const FileName: AnsiString; const Checking: boolean);
begin
  if (Assigned(OnFileEnd)) then
    OnFileEnd(WideString(FileName), Checking);
end;

function TSQX.GetArchiveName(const BaseName: WideString): WideString;
begin
  Result:= BaseName;

  if (FWillBeFTPed) then
    Exit; // the FTP object will add the date if necesary

  if (not FSeparated) then
    Exit;

  Result:= FTools.GetFileNameSeparatedW(BaseName, FDTFormat, not FDoNotSeparate, Now());

  if (FDoNotUseSpaces) then
    Result:= FTools.DeleteSpacesW(Result);
end;

function TSQX.GetBaseArchiveName(const Source: WideString): WideString;
var
  Sl: TTntStringList;
  ASource: WideString;
  Kind: integer;
begin
  if (FUseTaskName) then
  begin
    Result:= FTaskName + WS_SQXEXT;
    Exit;
  end;

  Sl:= TTntStringList.Create();
  try
    Sl.CommaText:= Source;
    if (Sl.Count > 1) then
    begin
      Result:= FTaskName + WS_SQXEXT;
      Exit;
    end;

    ASource:= FTools.DecodeSD(Sl[0],Kind);
    case Kind of
      INT_SDFILE: Result:= WideChangeFileExt(WideExtractFileName(ASource), WS_SQXEXT);
      INT_SDDIR: Result:= CobGetShortDirectoryNameW(ASource) + WS_SQXEXT;
      else
        Result:= Translator.GetMessage('325') + WS_SQXEXT;
    end;
  finally
    FreeAndNil(Sl);
  end;
end;

function TSQX.GetBaseDir(const Source: WideString): WideString;
var
  Kind: integer;
begin
  Result:= FTools.DecodeSD(Source,Kind);
  if (Kind = INT_SDFILE) then
    Result:= WideExtractFileDir(Result);
end;

function TSQX.GetFilesCount(): int64;
var
  SqxInfo: SQX_INFO_STRUCT;
  lRes: longint;
  AFL: ARC_FILE_LIST;
  ExtractSettings: SQX_EXTRACT_SETTINGS;
begin
  Result := 0;

  SqxDoneFileList(FHandle, FList);

  // init the arcfile list
  SqxInitArcFileList(FHandle, AFL);

  ///List all files
  lRes := SqxAddFileList(FHandle, AnsiString(WS_ALLFILES), FList);

  if lRes <> SQX_EC_OK then
    Exit;

  FillChar(ExtractSettings, sizeof(SQX_EXTRACT_SETTINGS), #0);
  ExtractSettings.lCreateDirs := OPTION_SET;
  ExtractSettings.uStructSize := SizeOf(SQX_EXTRACT_SETTINGS);

  lRes := SqxListFiles(FHandle, AnsiString(FFileName), FList, AFL,
    SqxInfo, ExtractSettings, SqxCallBackProc, Self);

  if lRes <> SQX_EC_OK then
    Exit;

  //The file list will be done on the SQX method

  Result := SqxInfo.lTotalFiles;
end;

function TSQX.GetParentDir(const Dir: WideString): WideString;
begin
  Result:= FTools.GetParentDirectory(Dir);
end;

function TSQX.GetRelativePath(const FileName: WideString): WideString;
var
  p: integer;
begin
  Result := FileName;
  p := CobPosW(FRootDir, Result, false);
  if p > 0 then
    Delete(Result, p, Length(FRootDir));

  //Result:= CobRemoveFirstSlash(Result);
end;

function TSQX.GetRootDirectory(const Source: WideString): WideString;
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

function TSQX.GetSQXError(const Error: Integer): WideString;
begin
  case Error of
    SQX_EC_ARCHIVE_OK_RDATA_NOT: Result:= Translator.GetMessage('347');
    SQX_EC_FILE_NOT_FOUND: Result:= Translator.GetMessage('348');
    SQX_EC_PATH_NOT_FOUND: Result:= Translator.GetMessage('349');
    SQX_EC_TOO_MANY_FILES: Result:= Translator.GetMessage('350');
    SQX_EC_ACCESS_DENIED	: Result:= Translator.GetMessage('351');
    SQX_EC_OUT_OF_MEMORY: Result:= Translator.GetMessage('352');
    SQX_EC_DISK_FULL: Result:= Translator.GetMessage('353');
    SQX_EC_WRITE_PROTECTED: Result:= Translator.GetMessage('354');
    SQX_EC_INVALID_DIC_SIZE	: Result:= Translator.GetMessage('355');
    SQX_EC_USER_ABORT: Result:= Translator.GetMessage('356');
    SQX_EC_CANT_ACCESS_TEMP_DIR: Result:= Translator.GetMessage('357');
    SQX_EC_TEMP_DIR_FULL: Result:= Translator.GetMessage('358');
    SQX_EC_CANT_CREATE_ARC_DIR: Result:= Translator.GetMessage('359');
    SQX_EC_INVALID_DIR_NAME: Result:= Translator.GetMessage('360');
    SQX_EC_INVALID_FILENAME: Result:= Translator.GetMessage('361');
    SQX_EC_CANT_COPY_SOURCE_TO_SOURCE: Result:= Translator.GetMessage('362');
    SQX_EC_WRONG_ARCHIVER_VERSION	: Result:= Translator.GetMessage('363');
    SQX_EC_ARCHIVE_VERSION_TOO_HIGH: Result:= Translator.GetMessage('364');
    SQX_EC_EXT_RDATA_DOES_NOT_MATCH: Result:= Translator.GetMessage('365');
    SQX_EC_TOO_MANY_BROKEN_FBLOCKS: Result:= Translator.GetMessage('366');
    SQX_EC_DAMAGED_RDATA: Result:= Translator.GetMessage('367');
    SQX_EC_RDATA_DOES_NOT_MATCH	: Result:= Translator.GetMessage('368');
    SQX_EC_CANT_FIND_RDATA: Result:= Translator.GetMessage('369');
    SQX_EC_VOLUME_LIMIT_REACHED: Result:= Translator.GetMessage('370');
    SQX_EC_CANT_ADD_TO_MV_ARC: Result:= Translator.GetMessage('371');
    SQX_EC_CANT_DELETE_FROM_MV_ARC: Result:= Translator.GetMessage('372');
    SQX_EC_NEED_FIRST_VOLUME: Result:= Translator.GetMessage('373');
    SQX_EC_MISSING_VOLUME: Result:= Translator.GetMessage('374');
    SQX_EC_ARCHIVE_LOCK: Result:= Translator.GetMessage('375');
    SQX_EC_COMMENT_BIGGER_4K: Result:= Translator.GetMessage('376');
    SQX_EC_CANT_UPDATE_ESAWP: Result:= Translator.GetMessage('377');
    SQX_EC_UNKNOWN_METHOD: Result:= Translator.GetMessage('378');
    SQX_EC_FILE_ENCRYPTED	: Result:= Translator.GetMessage('379');
    SQX_EC_BAD_FILE_CRC	: Result:= Translator.GetMessage('380');
    SQX_EC_CANNOT_CREATE: Result:= Translator.GetMessage('381');
    SQX_EC_BAD_FILE_FORMAT: Result:= Translator.GetMessage('382');
    SQX_EC_EMPTY_FILE_LIST: Result:= Translator.GetMessage('383');
    SQX_EC_NOT_A_SQX_FILE: Result:= Translator.GetMessage('384');
    SQX_EC_FUNKTION_NOT_SUPPORTED: Result:= Translator.GetMessage('385');
    SQX_EC_FUNC_NOT_SUPPORTED_BY_ARCHIVE: Result:= Translator.GetMessage('385'); // same error, but slighty different
    else
      // some cases has not been included here
      Result:= Translator.GetMessage('386');
  end;
end;

function TSQX.LoadSQX(): boolean;
var
  lRes: longint;
begin
  // Load the library
  lRes := SqxLoad(FHandle, AnsiString(WS_NIL));
  Result:= lRes = SQX_EC_OK
end;

procedure TSQX.Log(const Msg: WideString; const Error, Verbose: boolean);
begin
  if (Assigned(OnLog)) then
    OnLog(Msg,Error,Verbose);
end;

function TSQX.OnlyParents(): boolean;
var
  i: integer;
begin
  /// The BaseDir thingy works incorrectly if there are files which don't
  /// contain the base directory
  /// Returns true if all the file names contain the BaseDir in the path
  Result := true;
  for i := 0 to FFileList.Count - 1 do
  begin
    if CobPosW(FRootDir, FFileList[i], false) = 0 then
    begin
      Result := false;
      Break;
    end;

    if DoAbort() then
      Break;
  end;
end;

procedure TSQX.PopulateFileList(const Source: WideString);
var
  i, Kind: integer;
  ASource: WideString;
  SourceList: TTntStringList;
begin
  SourceList:= TTntStringList.Create();
  try
    SourceList.CommaText:= Source;
    for i := 0 to SourceList.Count - 1 do
    begin
      ASource := FTools.DecodeSD(SourceList[i], Kind);
      if ASource = WS_NIL then
        Continue;
      if Kind = INT_SDFILE then
        AddFile(ASource) else
        AddDirectory(ASource);

      if DoAbort() then
        Break;
    end;
  finally
    FreeAndNil(SourceList);
  end;
end;

{procedure TSQX.PopulateListIncludeMask();
var
  Include: TTntStringList;
  i: integer;
  Dir, Mask: WideString;
begin
  Include:= TTntStringList.Create();
  try
    Include.CommaText:= FIncludeMask;
    for i := 0 to Include.Count - 1 do
    begin
      if WideFileExists(Include[i]) then
      begin
        AddFile(Include[i]);
        Continue;
      end;

      Dir := WideExtractFilePath(Include[i]);
      if Dir = WS_NIL then
        Dir := FRootDir;
      Mask := WideExtractFileName(Include[i]);

      AddDirectory(Dir, Mask);

      if DoAbort() then
        Break;
  end;
  finally
    FreeAndNil(Include);
  end;
end;    }

procedure TSQX.PrepareCompressSettings();
var
  Password, Temp: AnsiString;
begin
  FillChar(CompressSettings, sizeof(SQX_COMPRESS_SETTINGS), #0);
  CompressSettings.uStructSize := sizeof(SQX_COMPRESS_SETTINGS);
  CompressSettings.lDictionarySizeIndex := FSqxDictionary + SQX_INDEX_DIC_SIZE_32K;
  CompressSettings.lMultimediaCompression := longint(FSqxMultimedia);
  CompressSettings.lExeCompression := longint(FSqxExe);
  CompressSettings.lMethod := FSqxLevel + SQX_C1_NORMAL;
  CompressSettings.lSolidFlag := longint(FSqxSolid);
  CompressSettings.lRecoveryLevel := FSqxRecovery;
  if FSqxRecovery = INT_NIL then
    CompressSettings.lCreateExtRecoveryData := OPTION_NONE
  else
    CompressSettings.lCreateExtRecoveryData := longint(FSqxExternal);
  CompressSettings.lRetainFolders := OPTION_SET;
  CompressSettings.lFileNameFlag := longint(not FOEM); {OPTION_NONE; //}
  if FProtect then
    if FPassword <> WS_NIL then
    begin
      Password:= AnsiString(FPassword);
      StrPCopy(CompressSettings.szFilePassWord, Password);
    end;
  // CompressSettings.szHeaderPassWord
  if FTemp <> WS_NIL then
  begin
    Temp:= AnsiString(FTemp);
    StrPCopy(CompressSettings.szTempDir, Temp);
  end;
  //CompressSettings.szRelPath

  if FSplit <> INT_SPLITNOSPLIT then
    CompressSettings.lCreateSfxOrMVArc := OPTION_SET
  else
    CompressSettings.lCreateSfxOrMVArc := OPTION_NONE;

  CompressSettings.lNoMVSfx := OPTION_SET;

  case FSplit of
    INT_SPLIT360K:
      begin
        if not FSeparated then
          FBackupType := INT_BUFULL; // make it full
        CompressSettings.SfxCommand.lSfxVolumeSize := SQX_VOL_DD360;
      end;
    INT_SPLIT720K:
      begin
        if not FSeparated then
          FBackupType := INT_BUFULL; // make it full
        CompressSettings.SfxCommand.lSfxVolumeSize := SQX_VOL_DD720;
      end;
    INT_SPLIT12M:
      begin
        if not FSeparated then
          FBackupType := INT_BUFULL; // make it full
        CompressSettings.SfxCommand.lSfxVolumeSize := SQX_VOL_HD1200;
      end;
    INT_SPLIT14M:
      begin
        if not FSeparated then
          FBackupType := INT_BUFULL; // make it full
        CompressSettings.SfxCommand.lSfxVolumeSize := SQX_VOL_HD1440;
      end;
    INT_SPLIT100M:
      begin
        if not FSeparated then
          FBackupType := INT_BUFULL; // make it full
        CompressSettings.SfxCommand.lSfxVolumeSize := SQX_VOL_ZIPM_100MB;
      end;
    INT_SPLIT250M:
      begin
        if not FSeparated then
          FBackupType := INT_BUFULL; // make it full
        CompressSettings.SfxCommand.lSfxVolumeSize := SQX_VOL_ZIPM_250MB;
      end;
    INT_SPLIT650M:
      begin
        if not FSeparated then
          FBackupType := INT_BUFULL; // make it full
        CompressSettings.SfxCommand.lSfxVolumeSize := SQX_VOL_CDR_650MB;
      end;
    INT_SPLIT700M:
      begin
        if not FSeparated then
          FBackupType := INT_BUFULL; // make it full
        CompressSettings.SfxCommand.lSfxVolumeSize := SQX_VOL_CDR_700MB;
      end;
    INT_SPLIT1G:
      begin
        if not FSeparated then
          FBackupType := INT_BUFULL; // make it full
        CompressSettings.SfxCommand.lSfxVolumeSize := SIZE1C0G;
      end;
    INT_SPLIT47G:
      begin
        if not FSeparated then
          FBackupType := INT_BUFULL; // make it full
        /// This is idiotic but lSfxVolumeSize is an integer and not an Int64
        CompressSettings.SfxCommand.lSfxVolumeSize := INT_LONGINTMAX;
      end;
    INT_SPLITCUSTOM:
      begin
        if not FSeparated then
          FBackupType := INT_BUFULL; // make it full
        if FCustomSize > INT_LONGINTMAX then
          CompressSettings.SfxCommand.lSfxVolumeSize := INT_LONGINTMAX
        else
          CompressSettings.SfxCommand.lSfxVolumeSize := FCustomSize;
      end;
  else
    //NoSplit, do nothing;
    CompressSettings.SfxCommand.lSfxVolumeSize := INT_NIL;
  end;

  if (not FUseAttributes) then
  begin
    FBackupType:= INT_BUFULL;
    Log(Translator.GetMessage('343'), false, false);
    Exit;
  end;

end;

procedure TSQX.Progress(const FileName: AnsiString; const Percent: integer;
  const Checking: boolean);
begin
  if (Assigned(OnPercentDone)) then
    OnPercentDone(WideString(Filename),Percent, FCheckingCRC);
end;

function TSQX.SQX(const Source, Destination: WideString;
  const LastElement: boolean): WideString;
var
  ADestination: WideString;
begin
  Result:= WS_NIL;
  FLastElement:= LastElement;
  FLastPercent:= -1;
  FCounter:= 0;
  FFilesResult.Clear();

  ADestination:= FTools.NormalizeFileName(Destination);

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

  if (not LoadSQX()) then
  begin
    Log(Translator.GetMessage('342'),true,false);
    Exit;
  end;

  try
    try
      FCheckingCRC:= false;
      FCounter:= 0;

      FRootDir:= GetRootDirectory(Source);

      // Set the settings
      PrepareCompressSettings();

      // Init the file list
      SqxInitFileList(FHandle, FList);

      if DoAbort() then
        Exit;

      // Populate the file List
      PopulateFileList(Source);

      CheckRelativePaths();

      if (DoAbort()) then
        Exit;

      if FBackupType = INT_BUFULL then
        if WideFileExists(FFileName) then
          DeleteFileW(PWideChar(FFileName));
      //if I don't do so, then it fails with multivolume


      if not Compress() then
      begin
        Result:= WS_NIL;
        FFilesResult.Clear();
        // The error is logged on Compress()
        Exit;
      end;

      if (DoAbort()) then
        Exit;

      AddAllResultParts();

      AddArchiveComment();

      if (DoAbort()) then
        Exit;

      Result := FFilesResult.CommaText;

      ClearAttributes();

      Log(WideFormat(Translator.GetMessage('338'),[FFileName,FCounter],FS),false,false);

      if (DoAbort()) then
        Exit;

      if (FCheckArchives) then
      begin
        Sleep(INT_SLOW);
        FCheckingCRC := true;
        FCounter := 0;
        FCountFilesArchive := GetFilesCount();

        CheckArchive();


      end;
    finally
      // Cleanup...
      SqxDoneFileList(FHandle, FList);
      // Free archiver
      SqxFree(FHandle);
    end;
  except
    on E:Exception do
    begin
      Result:= WS_NIL;
      FFilesResult.Clear();
      Log(WideFormat(Translator.GetMessage('394'),[FFileName, WideString(E.Message)],FS), true, false);
    end;
  end;
end;

end.
