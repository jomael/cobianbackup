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

// Unit implementing raw copy operations without compression or encryption


unit engine_Copier;

interface

uses Classes, TntClasses, SysUtils, bmCommon;

type
  // Records to pass parameters to the copy object
  TCopyPar = record
    Temp: WideString;
    AppPath: WideString;
    BackupType: integer;
    UseAttributes: boolean;
    Separated: boolean;
    DTFormat: WideString;
    DoNotSeparate: boolean;                               
    DoNotUseSpaces: boolean;
    UseShell: boolean;
    Alternative: boolean;
    Slow: boolean;
    BufferSize: integer;
    CheckCRC: boolean;
    CopyTimeStamps: boolean;
    CopyAttributes: boolean;
    CopyNTFS: boolean;
    ClearAttributes: boolean;
    DeleteEmptyFolders: boolean;
    AlwaysCreateDirs: boolean;
    Subdirs: boolean;
    Excludemask: WideString;
    IncludeMask: WideString;
    Propagate: boolean;
  end;

  TCopier = class(TObject)
  private
    FAppPath: WideString;
    FTemp: WideString;
    FS: TFormatSettings;
    FTools: TCobTools;
    FBackupType: integer;
    FUseAttributes: boolean;
    FSeparated: boolean;
    FDTFormat: WideString;
    FDoNotSeparate: boolean;
    FDoNotUseSpaces: boolean;
    FUseShellOnly: boolean;
    FAlternative: boolean;
    FSourceOriginal: WideString;
    FLastPercent: integer;
    FSlow: boolean;
    FBufferSize: integer;
    FCheckCRC: boolean;
    FCopyTimeStamps: boolean;
    FCopyAttributes: boolean;
    FCopyNTFS: boolean;
    FClearAttributes: boolean;
    FDeleteEmptyFolders: boolean;
    FAlwaysCreateDir: boolean;
    FSourceDirOriginal: WideString;
    FSubdirs: boolean;
    FIncludeMask: WideString;
    FExcludeMask: WideString;
    FCount: int64;
    FPropagate: boolean;
    procedure Log(const Msg: WideString; const Error, Verbose: boolean);
    procedure FileBegin(const FileName, DestFile: WideString; const Single: boolean);
    procedure FileEnd(const FileName, DestFile: WideString; const Single, Success: boolean);
    function DoAbort(): boolean;
    procedure ShowProgress(const FileName: WideString;const Percent: integer);
    procedure CRCProgress(const FileName: WideString;const Percent: integer);
    function NeedToCopy(const FileName, FileNameDest: WideString): boolean;
    function NeedToCopyMasks(const FileName: WideString): boolean;
    function CopyEx(const Source,Destination: WideString): boolean;
    function CopyShell(const Source,Destination: WideString): boolean;
    function CopyStream(const Source, Destination: WideString): boolean;
    function CheckCRC(const File1,File2: WideString; const Single: boolean): boolean;
    function CRCProgressCallback(const FileName: WideString;
                                              const Percent: integer): boolean;
    function CopySecurity(const Source, Destination: WideString): cardinal;
    function GetFinalDirectory(const Source, Destination: WideString): WideString;
    procedure CopyDirIteraction(const Source, Destination: WideString;
                                                    const LastElement: boolean);
  public
    //Events
    OnLog: TCobLogEvent;
    OnAbort: TCobAbort;
    OnFileBegin: TCobObjectFileBegin;
    OnFileEnd: TCobObjectFileEnd;
    OnFileProgress: TCobObjectProgress;
    OnCRCProgress: TCobCopyCRCProgress;
    OnNTFSPermissionsCopy: TCobNTFSPermissionsCopy;
    DestinationOriginal: WideString;
    DestinationDirOriginal: WideString;
    constructor Create(const Par:TCopyPar);
    destructor Destroy();override;
    function CopyFile(const Source, Destination: WideString ; Single, LastElement:
      boolean): cardinal;
    function CopyDirectory(const Source, Destination: WideString;
              const LastElement: boolean): int64;
  end;

implementation

uses bmConstants, TntSysUtils, bmTranslator, Windows, CobCommonW, ShellApi,
  bmCustomize;

{ TCopier }

function TCopier.DoAbort: boolean;
begin
  Result:= false;
  if (Assigned(OnAbort)) then
    Result:= OnAbort();
end;


// This is a callback function for the CopyFileEx
// function
//*********************************************************
function CopyCallbackNT(TotalFileSize, TotalBytesTransferred,
  StreamSize, StreamBytesTransferred: int64;
  dwStreamNumber, dwCallbackReason: DWORD;
  hSourceFile, hDestinationFile: THandle;
  FCopy: TCopier): DWORD; stdcall;
var
  Percent: Integer;
begin
  Result := PROGRESS_CONTINUE;
  if dwCallbackReason = CALLBACK_CHUNK_FINISHED then
  begin
    if TotalFileSize <> 0 then
      Percent := Round(TotalBytesTransferred / TotalFileSize * 100)
    else
      Percent := 100;

    if FCopy.FLastPercent <> Percent then
    begin
      FCopy.FLastPercent := Percent;
      FCopy.ShowProgress(FCopy.FSourceOriginal, Percent);
      if FCopy.FSlow then
        if Percent mod INT_FIVEMULTIPLE = INT_NIL then
          Sleep(INT_SLOW);
    end;

    if FCopy.DoAbort() then
      Result := PROGRESS_CANCEL;

  end;    
end; { CopyCallback }
//************************End of the callback*********************************


function TCopier.CheckCRC(const File1, File2: WideString; const Single: boolean): boolean;
begin
  Log(WideFormat(Translator.GetMessage('250'),[FSourceOriginal,
                                DestinationOriginal], FS), false, not Single);
  Result:= FTools.IsTheSameFile(File1, File2, true);
  if (Result) then         //the error will be logget outside this procedure
    Log(WideFormat(Translator.GetMessage('251'),[FSourceOriginal,
                                DestinationOriginal], FS), false, not Single);
end;

function TCopier.CopyDirectory(const Source, Destination: WideString;
  const LastElement: boolean): int64;
var
  ASourceDir, ADestinationDir: WideString;
  Err: cardinal;
  DirCreated: boolean;
begin
  Result:= 0;

  DirCreated:= false;
  FSourceDirOriginal:= Source;
  DestinationDirOriginal:= GetFinalDirectory(Source, Destination);
  // Check if the
  ASourceDir:= FTools.NormalizeFileName(FSourceDirOriginal);
  ADestinationDir:= FTools.NormalizeFileName(DestinationDirOriginal);

  if (not WideDirectoryExists(ASourceDir)) then
  begin
    Log(WideFormat(Translator.GetMessage('272'),[FSourceDirOriginal],FS),true, false);
    Exit;
  end;

  if (not WideDirectoryExists(ADestinationDir)) then
  begin
    Log(WideFormat(Translator.GetMessage('273'),[DestinationDirOriginal],FS),false, false);  // not an error yet
    if (not WideForceDirectories(ADestinationDir)) then
    begin
      Log(WideFormat(Translator.GetMessage('274'),[DestinationDirOriginal],FS),true, false);
      Exit;
    end else
    begin
      Log(WideFormat(Translator.GetMessage('275'),[DestinationDirOriginal],FS),false, false);

      DirCreated:= true;
    end;
  end;

  FCount:= 0;
  // begin the iteraction

  Log(WideFormat(Translator.GetMessage('280'),[FSourceDirOriginal,
                            DestinationDirOriginal], FS), false, false);

  CopyDirIteraction(FSourceDirOriginal, DestinationDirOriginal, LastElement); // Pass the orininal and NOT the normalized cause the rest is done in CopyFile

  if (DirCreated) then
  begin
   //2006
    if (FCopyAttributes) and not (FTools.IsRoot(FSourceDirOriginal)) then
      if FTools.CopyAttributesDir(ASourceDir, ADestinationDir) then
        Log(WideFormat(Translator.GetMessage('255'),[FSourceDirOriginal,
                    DestinationDirOriginal], FS), false, true) else
        Log(WideFormat(Translator.GetMessage('256'),[FSourceDirOriginal,
                    DestinationDirOriginal], FS), true, true) ;

    if (FCopyNTFS) then
    begin
      Err:= CopySecurity(ASourceDir, ADestinationDir);
      if (Err = 0) then
        Log(WideFormat(Translator.GetMessage('257'),[FSourceDirOriginal,
                    DestinationDirOriginal], FS), false, true) else
        Log(WideFormat(Translator.GetMessage('258'),[FSourceDirOriginal,
                    DestinationDirOriginal, CobSysErrorMessageW(Err)], FS), true, true);
    end;
  end;
  Result:= FCount;
end;

procedure TCopier.CopyDirIteraction(const Source, Destination: WideString;
                                                const LastElement: boolean);
var
  sd, dd: WideString;
  SR: TSearchRecW;
  Err: cardinal;
  //****************************************************************************
  procedure ProcessResults();
  begin
    if (SR.Name <> WS_CURRENTDIR) and (SR.Name <> WS_PARENTDIR) then
    begin
      // Don't send the normalized name!
      if (faDirectory and SR.Attr) > 0  then
      begin
        if (FSubdirs) then
          self.CopyDirIteraction(CobSetBackSlashW(Source) + SR.Name,
                                 CobSetBackSlashW(Destination) + SR.Name, LastElement);
      end else
      begin
        Self.CopyFile(CobSetBackSlashW(Source) + SR.Name, Destination, false, LastElement);
        inc(Self.FCount);
      end;
    end;
  end;
  //***************************************************************************
begin
  sd:= FTools.NormalizeFileName(Source);
  dd:= FTools.NormalizeFileName(Destination);

  // This is an iteraction, so repeat the directory control
  if (not WideDirectoryExists(sd)) then
  begin
    Log(WideFormat(Translator.GetMessage('272'), [Source], FS),true,false);
    Exit;
  end;

  if (not WideDirectoryExists(dd)) then
  begin
    Log(WideFormat(Translator.GetMessage('273'), [Destination], FS),false, true);
    if (not WideForceDirectories(dd)) then
    begin
      Log(WideFormat(Translator.GetMessage('274'), [Destination], FS),true, false);
      Exit;
    end else
    begin
      Log(WideFormat(Translator.GetMessage('275'), [Destination], FS),false, true);

      if (FCopyAttributes) then
        if FTools.CopyAttributesDir(sd, dd) then
          Log(WideFormat(Translator.GetMessage('255'),[Source,
                      Destination], FS), false, true) else
          Log(WideFormat(Translator.GetMessage('256'),[Source,
                      Destination], FS), true, true) ;

      if (FCopyNTFS) then
      begin
        Err:= CopySecurity(sd, dd);
        if (Err = 0) then
          Log(WideFormat(Translator.GetMessage('257'),[Source,
                      Destination], FS), false, true) else
          Log(WideFormat(Translator.GetMessage('258'),[Source,
                      Destination, CobSysErrorMessageW(Err)], FS), true, true);
      end;
    end;
  end;

  sd:= CobSetBackSlashW(sd) + WS_ALLFILES;

  if (WideFindFirst(sd, faAnyFile, SR) = 0) then
  begin
    ProcessResults();
    while WideFindNext(SR) = 0 do
    begin
      ProcessResults();
      if (DoAbort()) then
        Break;
    end;
    WideFindClose(SR);
  end;

  if (DoAbort()) then
    Exit;

  if (FDeleteEmptyFolders) then
    if (FTools.IsDirEmpty(Destination)) then
    begin
      Log(WideFormat(Translator.GetMessage('277'),[Destination],FS),false, true);
      if FTools.DeleteDirectoryW(Destination)= false then
        Log(WideFormat(Translator.GetMessage('278'),[Destination],FS),true, false) else
        Log(WideFormat(Translator.GetMessage('279'),[Destination],FS),false, true);
    end;
end;

function TCopier.CopyEx(const Source, Destination: WideString): boolean;
var
  Err: cardinal;
begin
  Result:= false;

  Log(WideFormat(Translator.GetMessage('244'),
                    [FSourceOriginal, DestinationOriginal], FS), false, true);


  if (WideFileExists(Source)) then
    if (FTools.IsFileLocked(Source)) then
    begin
      Log(WideFormat(Translator.GetMessage('246'), [FSourceOriginal], FS), true, false);
      Exit;
    end;

  Result := CopyFileExW(PWideChar(Source), PWideChar(Destination), @CopyCallbackNT,
    Pointer(self), nil, 0);

  if DoAbort() then
    Exit;

  if Result then
  Log(WideFormat(Translator.GetMessage('245'),
                    [FSourceOriginal, DestinationOriginal], FS), false, true) else
  begin
    //failed
    Err := Windows.GetLastError();
    Log(WideFormat(Translator.GetMessage('243'),
    [FSourceOriginal, DestinationOriginal, CobSysErrorMessageW(Err)], FS), true, false);
  end;
end;


function TCopier.CopyFile(const Source, Destination: WideString; Single,
  LastElement: boolean): cardinal;
var
  ASource, ADestination, ShortName: WideString;
  Success: boolean;
  CRC: boolean;
  Err: cardinal;
begin
  Result:= INT_NOFILECOPIED;

  FSourceOriginal:= Source;            // Used in other procedures
  DestinationOriginal:= Destination;  // for cosmetical reasons in the log
                                       // Do not log funny file names like \\?\c:\
                                       // Some functions like ShFileOperation
                                       // don't support this either, so I need 2 copies
  ASource:= FTools.NormalizeFileName(Source);
  ADestination:= FTools.NormalizeFileName(Destination);

  if (not WideFileExists(ASource)) then
  begin
    Log(WideFormat(Translator.GetMessage('234'),[FSourceOriginal],FS), true, false);
    Exit;
  end;
  
  if (not WideDirectoryExists(ADestination)) then
  begin
    Log(WideFormat(Translator.GetMessage('236'),[DestinationOriginal],FS), false, false);
    if (WideForceDirectories(ADestination)) then
      Log(WideFormat(Translator.GetMessage('235'),[DestinationOriginal],FS), false, false) else
      begin
        Log(WideFormat(Translator.GetMessage('237'),[DestinationOriginal],FS), true, false);
        Exit;
      end;
  end;

  // if we get here, begin copying

  ShortName:= WideExtractFileName(FSourceOriginal);

  if (Single and FSeparated) then
    ShortName:= FTools.GetFileNameSeparatedW(ShortName, FDTFormat, not FDoNotSeparate, Now());

  if (FDoNotUseSpaces) then
    ShortName:= FTools.DeleteSpacesW(ShortName);

  ADestination:= CobSetBackSlashW(ADestination) + ShortName;
  DestinationOriginal:= CobSetBackSlashW(DestinationOriginal) + ShortName; // theres no need to log funny names

  if (not NeedToCopy(ASource, ADestination)) then
  begin
    Log(WideFormat(Translator.GetMessage('239'),[FSourceOriginal],FS), false, not Single);
    Exit;
  end;

  if (not Single) then
    if (not NeedToCopyMasks(FSourceOriginal)) then    // Masks. There is not need to send \\?\
    begin
      Log(WideFormat(Translator.GetMessage('240'),[FSourceOriginal],FS), false, true);
      Exit;
    end;

  // If the destination file is readonly, the operation will fail
  if (WideFileExists(ADestination)) then
    if (WideFileIsReadOnly(ADestination)) then
      WideFileSetReadOnly(ADestination, false);

  if (DoAbort()) then
    Exit;

  FileBegin(FSourceOriginal, DestinationOriginal , Single);

  // AT LAST!!! Copy now!
  if (FUseShellOnly) then
    Success:= CopyShell(FSourceOriginal, DestinationOriginal) else   // Does not support \\?\
    begin
      Success:= CopyEx(ASource, ADestination);

      if (DoAbort()) then
        Exit;   

      if (not Success) and  FAlternative then
      begin
        Success:= CopyStream(ASource, ADestination);

        if (DoAbort()) then
          Exit;

        if (not Success) then
          Success:= CopyShell(FSourceOriginal, DestinationOriginal); // Does not support \\?\
      end;
    end;

  if (DoAbort()) then
    Exit;

  // Check the CRC of the file if necessary
  if (Success) and (FCheckCRC) then
  begin
    CRC:= CheckCRC(ASource, ADestination, Single);
    if (not CRC) then
    begin
      Log(WideFormat(Translator.GetMessage('252'),[FSourceOriginal,
                                DestinationOriginal], FS), true, false);
      Exit;
    end;
  end;

  if (DoAbort) then
    Exit;

  // Before applying attributes, timestamps etc, check if the file
  // is readonly. I have done this early, but some methods like
  // ShFileOperation copy the attributes automatically. So do it
  // again
  if (WideFileExists(ADestination)) then
    if (WideFileIsReadOnly(ADestination)) then
      WideFileSetReadOnly(ADestination, false);

  if (Success and FCopyTimeStamps) then
    if (FTools.CopyTimeStamps(ASource, ADestination)) then
      Log(WideFormat(Translator.GetMessage('253'),[FSourceOriginal,
                      DestinationOriginal], FS), false, true) else
      Log(WideFormat(Translator.GetMessage('254'),[FSourceOriginal,
                      DestinationOriginal], FS), true, true);
                      // In a samba enviroment this will fail anyway, so make
                      // it Verbose

  if (Success and FCopyNTFS) then
  begin
    Err:= CopySecurity(ASource, ADestination);
    if (Err = 0) then
      Log(WideFormat(Translator.GetMessage('257'),[FSourceOriginal,
                      DestinationOriginal], FS), false, true) else
      Log(WideFormat(Translator.GetMessage('258'),[FSourceOriginal,
                      DestinationOriginal, CobSysErrorMessageW(Err)], FS), true, true);
  end;


  if (Success and FCopyAttributes) then
    if (FTools.CopyAttributes(ASource, ADestination)) then
      Log(WideFormat(Translator.GetMessage('255'),[FSourceOriginal,
                      DestinationOriginal], FS), false, true) else
      Log(WideFormat(Translator.GetMessage('256'),[FSourceOriginal,
                      DestinationOriginal], FS), true, true) ;

  if (Success and FClearAttributes) then
    if (LastElement) then
      if (FBackupType <> INT_BUDIFFERENTIAL) then  // if differential, the do NOT clear the backup
        if (FTools.SetArchiveAttributeW(ASource, false)) then
          Log(WideFormat(Translator.GetMessage('267'),[FSourceOriginal],FS), false, true) else
          Log(WideFormat(Translator.GetMessage('268'),[FSourceOriginal],FS), true, true);


  if (Success) then
    Result:= INT_FILESUCCESFULLYCOPIED;

  FileEnd(FSourceOriginal, DestinationOriginal, Single, Success);
end;

function TCopier.CopySecurity(const Source, Destination: WideString): cardinal;
begin
  Result:= ERROR_FILE_NOT_FOUND;
  if (Assigned(OnNTFSPermissionsCopy)) then
    Result:= OnNTFSPermissionsCopy(Source, Destination);
end;

function TCopier.CopyShell(const Source, Destination: WideString): boolean;
var
  OpStruc: TSHFileOpStructW;
  frombuf, tobuf: WideString;
  Err: integer;
begin
  Result := true;

  Log(WideFormat(Translator.GetMessage('241'),
                  [FSourceOriginal, DestinationOriginal],FS), false, true); // verbose only

  if (WideFileExists(Source)) then
    if (FTools.IsFileLocked(Source)) then
    begin
      Log(WideFormat(Translator.GetMessage('246'), [FSourceOriginal], FS), true, false);
      Result:= false;
      Exit;
    end;

  ShowProgress(FSourceOriginal, INT_NIL); // you cannot show a percent with this method

  FillChar(OpStruc, SizeOf(OpStruc), 0);

  // double #0, Delphi aready puts one at the end so only one is necesary,
  // but for visuals, I'll add 2

  frombuf:= Source + WideChar(#0)+ WideChar(#0);
  tobuf:= Destination + WideChar(#0)+ WideChar(#0);

  with OpStruc do
  begin
    Wnd := 0;
    wFunc := FO_COPY;
    pFrom := PWideChar(frombuf);
    pTo := PWideChar(tobuf);
    fFlags := FOF_NOCONFIRMATION or FOF_SILENT or FOF_NOCONFIRMMKDIR or
      FOF_NOERRORUI;
    fAnyOperationsAborted := False;
    hNameMappings := nil;
    lpszProgressTitle := nil;
  end;

  Err:= ShFileOperationW(OpStruc);

  if (Err = 0) then
  Log(WideFormat(Translator.GetMessage('242'),[FSourceOriginal,
      DestinationOriginal],FS), false, true) else
  begin
    Result:= false;
    Log(WideFormat(Translator.GetMessage('243'),[FSourceOriginal,
      DestinationOriginal, Translator.GetShellError(Err)],FS), true, false)
  end;

end;

function TCopier.CopyStream(const Source, Destination: WideString): boolean;
var
  SS, DS: TTntFileStream;
  CurrentSize, TotalSize: Int64;
  pBuf: Pointer;
  cnt: integer;
  Percent: integer;
begin
  Result := true;

  Log(WideFormat(Translator.GetMessage('247'),
                    [FSourceOriginal, DestinationOriginal], FS), false, true);

  if (WideFileExists(Source)) then
    if (FTools.IsFileLocked(Source)) then
    begin
      Log(WideFormat(Translator.GetMessage('246'), [FSourceOriginal], FS), true, false);
      Result:= false;
      Exit;
    end;

  CurrentSize := 0;
  FLastPercent:= -1;

  try
    GetMem(pBuf, FBufferSize);
    SS := TTntFileStream.Create(Source, fmOpenRead or fmShareCompat);
    try
      DS := TTntFileStream.Create(Destination, fmCreate or fmShareExclusive);
      try
        //Get the total size of the file
        TotalSize := SS.Size;
        {Read and write first bufSize bytes from source into the buffer}
        cnt := SS.Read(pBuf^, FBufferSize);
        cnt := DS.Write(pBuf^, cnt);
        CurrentSize := CurrentSize + cnt;

        while (cnt > 0) do
        begin

          if DoAbort() then
          begin
            Result := false;
            Break;
          end;

          cnt := SS.Read(pBuf^, FBufferSize);
          cnt := DS.Write(pBuf^, cnt);
          CurrentSize := CurrentSize + cnt;

          if TotalSize <> 0 then
            Percent := Trunc((CurrentSize / TotalSize) * 100)
          else
            Percent := 100;

          if FLastPercent <> Percent then
          begin
            FLastPercent := Percent;
            ShowProgress(FSourceOriginal, Percent);

            if FSlow then
              if Percent mod INT_FIVEMULTIPLE = INT_NIL then
                Sleep(INT_SLOW);
          end;

        end;

      Log(WideFormat(Translator.GetMessage('249'),[FSourceOriginal,
        DestinationOriginal],FS), false, true);
      finally
        FreeAndNil(DS);
      end;
    finally
      FreeAndNil(SS);
      FreeMem(pBuf, FBufferSize);
    end;
  except
    on E: Exception do
    begin
      Log(WideFormat(Translator.GetMessage('243'), [FSourceOriginal,
              DestinationOriginal, WideString(E.Message)], FS), true, false);
      Result := false;
    end;
  end;
end;

procedure TCopier.CRCProgress(const FileName: WideString;const Percent: integer);
begin
  if (Assigned(OnCRCProgress)) then
    OnCRCProgress(FileName, Percent);
end;

function TCopier.CRCProgressCallback(const FileName: WideString;
                                              const Percent: integer): boolean;
begin
  CRCProgress(FSourceOriginal, Percent); // Don't use FileName here because it can contain \\?\

  if (FSlow) then
    if Percent mod INT_FIVEMULTIPLE = INT_NIL then
      Sleep(INT_SLOW);

  Result:= not DoAbort();
end;

constructor TCopier.Create(const Par: TCopyPar);
begin
  inherited Create();
  GetLocaleFormatSettings(LOCALE_SYSTEM_DEFAULT, FS);
  FAppPath:= Par.AppPath;
  FTemp:= Par.Temp;
  FUseAttributes:= Par.UseAttributes;
  FSeparated:= Par.Separated;
  FDTFormat:= Par.DTFormat;
  FDoNotSeparate:= Par.DoNotSeparate;
  FDoNotUseSpaces:= Par.DoNotUseSpaces;
  FBackupType:= Par.BackupType;
  FUseShellOnly:= Par.UseShell;
  FAlternative:= Par.Alternative;
  FSlow:= Par.Slow;
  FBufferSize:= Par.BufferSize;
  FCheckCRC:= Par.CheckCRC;
  FCopyTimeStamps:= Par.CopyTimeStamps;
  FCopyAttributes:= Par.CopyAttributes;
  FCopyNTFS:= Par.CopyNTFS;
  FClearAttributes:= Par.ClearAttributes;
  FDeleteEmptyFolders:= Par.DeleteEmptyFolders;
  FAlwaysCreateDir:= Par.AlwaysCreateDirs;
  FSubdirs:= Par.Subdirs;
  FIncludeMask:= Par.IncludeMask;
  FExcludeMask:= Par.Excludemask;
  FPropagate:= Par.Propagate;

  FTools:= TCobTools.Create();
  FTools.OnCRCProgress:= CRCProgressCallback;
end;

destructor TCopier.Destroy();
begin
  FreeAndNil(FTools);
  inherited Destroy();
end;

procedure TCopier.FileBegin(const FileName, DestFile: WideString; const Single: boolean);
begin
  if (Assigned(OnFileBegin)) then
    OnFileBegin(FileName, DestFile, Single);
end;

procedure TCopier.FileEnd(const FileName, DestFile: WideString; const Single, Success: boolean);
begin
  if (Assigned(OnFileEnd)) then
    OnFileEnd(FileName, DestFile, Single, Success);
end;

function TCopier.GetFinalDirectory(const Source, Destination: WideString): WideString;
var
  ShortName: WideString;
begin
  Result:= Destination;

  ShortName:= CobGetShortDirectoryNameW(Source);

  if (FDoNotUseSpaces) then
    ShortName:= FTools.DeleteSpacesW(ShortName);

  // if the source is a root, (c:\) the result will be the same
  if (Length(ShortName) = 0) then
    ShortName:= Translator.GetMessage('276');

  if (not FSeparated) then
  begin
    if (FAlwaysCreateDir) then
      Result:= CobSetBackSlashW(Result) + ShortName;
  end else
  begin
    ShortName:= FTools.GetDirNameSeparatedW(ShortName, FDTFormat,not FDoNotSeparate, Now());
    if (FDoNotUseSpaces) then
      ShortName:= FTools.DeleteSpacesW(ShortName);
    Result:= CobSetBackSlashW(Destination) + ShortName;
  end;
end;

procedure TCopier.Log(const Msg: WideString; const Error, Verbose: boolean);
begin
  if (Assigned(OnLog)) then
    OnLog(Msg, Error, Verbose);
end;

function TCopier.NeedToCopy(const FileName, FileNameDest: WideString): boolean;
begin
  // Check if there is need to copy the file
  // based on the backup type
  Result:= true;

  if (FBackupType = INT_BUFULL) or (FBackupType = INT_BUDUMMY) then
    Exit;

  //Here are only diff or inc

  if (FUseAttributes) then
    Result:= FTools.GetArchiveAttributeW(FileName) else
    Result:= FTools.NeedToCopyByTimeStamp(FileName, FileNameDest);
end;

function TCopier.NeedToCopyMasks(const FileName: WideString): boolean;
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

procedure TCopier.ShowProgress(const FileName: WideString;const Percent: integer);
begin
  if (Assigned(OnFileProgress)) then
    OnFileProgress(FileName, Percent);
end;

end.
