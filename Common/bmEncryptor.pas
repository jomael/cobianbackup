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

/// Unit for encryption using strong methods.

unit bmEncryptor;

interface

uses Classes, bmCommon, SysUtils, Windows;

type
  // Record to pass parameters to the encryption object
  TEncryptPar = record
    Temp: WideString;
    AppPath: WideString;
    BackupType: integer;
    UseAttributes: boolean;
    Separated: boolean;
    DTFormat: WideString;
    DoNotSeparate: boolean;
    DoNotUseSpaces: boolean;
    Slow: boolean;
    BufferSize: integer;
    CopyTimeStamps: boolean;
    CopyAttributes: boolean;
    CopyNTFS: boolean;
    ClearAttributes: boolean;
    DeleteEmptyFolders: boolean;
    AlwaysCreateDirs: boolean;
    Subdirs: boolean;
    Excludemask: WideString;
    IncludeMask: WideString;
    PublicKey: WideString;
    EncMethod: integer;
    PassPhrase: WideString;
    Propagate: boolean;
  end;

  TEncryptor = class(TObject)
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
    FBufferSize: integer;
    FCopyTimeStamps: boolean;
    FCopyAttributes: boolean;
    FCopyNTFS: boolean;
    FClearAttributes: boolean;
    FDeleteEmptyFolders: boolean;
    FAlwaysCreateDirs: boolean;
    FSubdirs: boolean;
    FExcludemask: WideString;
    FIncludeMask: WideString;
    FPublicKey: WideString;
    FEncMethod: integer;
    FPassPhrase: WideString;
    FPropagate: boolean;
    //
    FTools: TCobTools;
    FS: TFormatSettings;
    FSourceOriginal: WideString;
    FSourceDirOriginal: WideString;
    FCount: int64;
    FSecundaryOperation: boolean;
    procedure Log(const Msg: WideString; const Error, Verbose: boolean);
    function DoAbort(): boolean;
    procedure FileBegin(const FileName, DestFile: WideString; const Single: boolean);
    procedure FileEnd(const FileName, DestFile: WideString; const Single, Success, Secundary: boolean);
    procedure ShowProgress(const FileName: WideString;const Percent: integer);
    function CopySecurity(const Source, Destination: WideString): cardinal;
    function NeedToCopy(const FileName, FileNameDest: WideString): boolean;
    function NeedToCopyMasks(const FileName: WideString): boolean;
    function EncryptFileRSA(const Source, Destination: WideString): boolean;
    function EncryptFileDES64(const Source, Destination: WideString): boolean;
    function EncryptFileBlowfish128(const Source, Destination: WideString): boolean;
    function EncryptRijndael128(const Source, Destination: WideString): boolean;
    function GetFinalDirectory(const Source, Destination: WideString): WideString;
    procedure EncryptDirIteraction(const Source, Destination: WideString;
                                                    const LastElement: boolean);
  public
    OnLog: TCobLogEvent;
    OnAbort: TCobAbort;
    OnFileBegin: TCobObjectFileBegin;
    OnFileEnd: TCobEncryptFileEnd;
    OnFileProgress: TCobObjectProgress;
    OnNTFSPermissionsCopy: TCobNTFSPermissionsCopy;
    DestinationOriginal: WideString;
    DestinationDirOriginal: WideString;
    FLastPercent: integer;
    constructor Create(const Par: TEncryptPar; const SecundaryOperation: boolean);
    destructor Destroy(); override;
    function EncryptFile(const Source, Destination: WideString ; Single, LastElement:
      boolean): cardinal;
    function EncryptDirectory(const Source, Destination: WideString;
              const LastElement: boolean): int64;
  end;

implementation

uses bmConstants, TntSysUtils, bmTranslator, CobCommonW, TntClasses,
      LbRSA, LbAsym, LbCipher, CobEncrypt;

{ TEncryptor }

function TEncryptor.EncryptDirectory(const Source, Destination: WideString;
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

  Log(WideFormat(Translator.GetMessage('305'),[FSourceDirOriginal,
                            DestinationDirOriginal], FS), false, false);

  // Pass the orininal and NOT the normalized cause the rest is done in EncryptFile
  EncryptDirIteraction(FSourceDirOriginal, DestinationDirOriginal, LastElement);

  if (DirCreated) then
  begin                                          
    if (FCopyAttributes) and not(FTools.IsRoot(FSourceDirOriginal)) then
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

procedure TEncryptor.EncryptDirIteraction(const Source, Destination: WideString;
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
          self.EncryptDirIteraction(CobSetBackSlashW(Source) + SR.Name,
                                 CobSetBackSlashW(Destination) + SR.Name, LastElement);
      end else
      begin
        if Self.EncryptFile(CobSetBackSlashW(Source) + SR.Name, Destination, false, LastElement) = INT_FILESUCCESFULLYENCRYPTED then
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

function TEncryptor.EncryptFile(const Source, Destination: WideString; Single,
  LastElement: boolean): cardinal;
var
  ASource, ADestination, ShortName: WideString;
  Success: boolean;
  Err: cardinal;         
begin
  Result:= INT_NOFILEENCRYPTED;

  FSourceOriginal:= Source;            // Used in other procedures
  DestinationOriginal:= Destination;  // for cosmetical reasons in the log
                                       // Do not log funny file names like \\?\c:\
  ASource:= FTools.NormalizeFileName(Source);
  ADestination:= FTools.NormalizeFileName(Destination);

  if (not WideFileExists(ASource)) then
  begin
    Log(WideFormat(Translator.GetMessage('283'),[FSourceOriginal],FS), true, false);
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

  ShortName:= WideExtractFileName(FSourceOriginal);

  if (FSecundaryOperation = BOOL_ENCPRIMARY) then
    if (Single and FSeparated) then
      ShortName:= FTools.GetFileNameSeparatedW(ShortName, FDTFormat, not FDoNotSeparate, Now());

  ShortName:= ShortName + WS_ENCRYPTEDEXT;

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
    if (not NeedToCopyMasks(FSourceOriginal)) then    // Masks. Send the original
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

  case FEncMethod of
    INT_ENCRSA: Success:= EncryptFileRSA(ASource, ADestination);
    INT_ENCRIJNDAEL128: Success:= EncryptRijndael128(ASource, ADestination);
    INT_ENCBLOWFISH128: Success:= EncryptFileBlowfish128(ASource, ADestination);
    INT_ENCDES64: Success:= EncryptFileDES64(ASource, ADestination);
    else
      begin
        Log(WideFormat(Translator.GetMessage('286'),[FSourceOriginal],FS), true, false);
        Exit;
      end;
  end;

  if (DoAbort) then
    Exit;

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
    if (LastElement) and (FSecundaryOperation = BOOL_ENCPRIMARY) then
      if (FBackupType <> INT_BUDIFFERENTIAL) then  // if differential, the do NOT clear the backup
        if (FTools.SetArchiveAttributeW(ASource, false)) then
          Log(WideFormat(Translator.GetMessage('267'),[FSourceOriginal],FS), false, true) else
          Log(WideFormat(Translator.GetMessage('268'),[FSourceOriginal],FS), true, true);


  if (Success) then
    Result:= INT_FILESUCCESFULLYENCRYPTED;

  FileEnd(FSourceOriginal, DestinationOriginal, Single, Success, FSecundaryOperation);
end;

function TEncryptor.EncryptFileBlowfish128(const Source,
  Destination: WideString): boolean;
var
  Key: TKey128;
  Context: TBFContext;
  BFBlock: TBFBlock;
  BytesRead: longint;
  Seed: integer;
  aInStream,  aOutStream: TTntFileStream;
  Percent: integer;
  TotalSize, CurrentSize, OriginalSize: Int64;
begin
  Result:= false;

  FLastPercent:= -1;

  Log(WideFormat(Translator.GetMessage('302'),
                    [FSourceOriginal, DestinationOriginal], FS), false, true);

  if (WideFileExists(Source)) then
    if (FTools.IsFileLocked(Source)) then
    begin
      Log(WideFormat(Translator.GetMessage('288'), [FSourceOriginal], FS), true, false);
      Exit;
    end;

  // begin the encryption
  try
    aInStream := TTntFileStream.Create(Source, fmOpenRead or fmShareExclusive);
    try
      aOutStream := TTntFileStream.Create(Destination, fmCreate or fmShareExclusive);
      try
        {reset the streams}
        TotalSize := aInStream.Size;
        CurrentSize:= 0;
        aInStream.Position := 0;
        aOutStream.Position := 0;
        OriginalSize:= aInStream.Size;
        {create a key}
        CobGenerateMD5KeyW(Key, FPassPhrase);
        {initialize the Blowfish context}
        InitEncryptBF(Key, Context);
        // write the original size
        aOutStream.Write(originalsize, Sizeof(OriginalSize));
        {set up the first block to contain the type of
         the encryption, together with random noise}

        BFBlock[1] := INT_ENCBLOWFISH128;
        Seed := INT_SEED;
        BFBlock[0] := Ran03(Seed);
        {encrypt and write this block}
        EncryptBF(Context, BFBlock, True);
        aOutStream.Write(BFBlock, sizeof(BFBlock));
        {read the first block from the stream}
        BytesRead := aInStream.Read(BFBlock, sizeof(BFBlock));
        CurrentSize := CurrentSize + BytesRead;
        {while there is still data to encrypt, do so}
        while (BytesRead <> 0) do
        begin
          EncryptBF(Context, BFBlock, True);
          aOutStream.Write(BFBlock, sizeof(BFBlock));
          BytesRead := aInStream.Read(BFBlock, sizeof(BFBlock));
          CurrentSize := CurrentSize + BytesRead;
          if TotalSize <> 0 then
            Percent := Trunc((CurrentSize / TotalSize) * 100)
          else
            Percent := 100;

          if Percent <> FLastPercent then
            // Dont' send messages in vane if the % has not changed
          begin
            FLastPercent := Percent;
            ShowProgress(FSourceOriginal, Percent);

            if FSlow then
              Sleep(INT_SLOW);
          end;

          if DoAbort() then
            Break;
        end;

        if DoAbort() then
          Exit;

        // if we get here
        Result := true;

      finally
        FreeAndNil(aOutStream);
      end;
    finally
      FreeAndNil(aInStream);
    end;
  except
    on E: Exception do
    begin
      Result := false;
      Log(WideFormat(Translator.GetMessage('294'),
                    [FSourceOriginal, Widestring(E.Message)],FS), true, false);
    end;
  end;

end;

function TEncryptor.EncryptFileDES64(const Source, Destination: WideString): boolean;
type
  TMyDESBlock = array[0..1] of LongInt;
var
  Key: TKey128;
  DESKey: TKey64;
  Context: TDESContext;
  DESBlock: TDESBlock;
  BytesRead: longint;
  Seed: integer;
  aInStream, aOutStream: TTntFileStream;
  Percent: integer;
  TotalSize, CurrentSize, OriginalSize: Int64;
begin
  Result:= false;

  FLastPercent:= -1;

  Log(WideFormat(Translator.GetMessage('301'),
                    [FSourceOriginal, DestinationOriginal], FS), false, true);

  if (WideFileExists(Source)) then
    if (FTools.IsFileLocked(Source)) then
    begin
      Log(WideFormat(Translator.GetMessage('288'), [FSourceOriginal], FS), true, false);
      Exit;
    end;

  // begin the encryption
  try
    aInStream := TTntFileStream.Create(Source, fmOpenRead or fmShareExclusive);
    try
      aOutStream := TTntFileStream.Create(Destination, fmCreate or
        fmShareExclusive);
      try
        {reset the streams}
        TotalSize := aInStream.Size;
        CurrentSize:= 0;
        aInStream.Position := 0;
        aOutStream.Position := 0;
        originalSize:= aInStream.Size;
        {create a key}
        CobGenerateMD5KeyW(Key, FPassPhrase);
        Move(Key, DESKey, sizeof(DESKey));
        {initialize the DES context}
        InitEncryptDES(DESKey, Context, True);
        // First add the original size
        aOutStream.Write(Originalsize, sizeOf(OriginalSize));
        {set up the first block to contain the method used,
        together with random noise}
        TMyDESBlock(DESBlock)[1] := INT_ENCDES64;
        Seed := INT_SEED;
        TMyDESBlock(DESBlock)[0] := Ran03(Seed);
        {encrypt and write this block}
        EncryptDES(Context, DESBlock);
        aOutStream.Write(DESBlock, sizeof(DESBlock));
        {read the first block from the stream}
        BytesRead := aInStream.Read(DESBlock, sizeof(DESBlock));
        CurrentSize := CurrentSize + BytesRead;
        {while there is still data to encrypt, do so}
        while (BytesRead <> 0) do
        begin
          EncryptDES(Context, DESBlock);
          aOutStream.Write(DESBlock, sizeof(DESBlock));
          BytesRead := aInStream.Read(DESBlock, sizeof(DESBlock));
          CurrentSize := CurrentSize + BytesRead;

          if TotalSize <> 0 then
            Percent := Trunc((CurrentSize / TotalSize) * 100)
          else
            Percent := 100;

          if Percent <> FLastPercent then
            // Dont' send messages in vane if the % has not changed
          begin
            FLastPercent := Percent;
            ShowProgress(FSourceOriginal, Percent);

            if (FSlow) then
              Sleep(INT_SLOW);
          end;

          if DoAbort() then
            Break;

        end;

        if DoAbort() then
          Exit;

        Result := true;

      finally
        FreeAndNil(aOutStream);
      end;
    finally
      FreeAndNil(aInStream);
    end;
  except
    on E: Exception do
    begin
      Result := false;
      Log(WideFormat(Translator.GetMessage('294'),
                    [FSourceOriginal, Widestring(E.Message)],FS), true, false);
    end;
  end;

end;

function TEncryptor.EncryptFileRSA(const Source,
  Destination: WideString): boolean;
type
  TMyRDLBlock = array [0..3] of LongInt;
var
  InStream, OutStream: TTntFileStream;
  PlainBuf: TRSAPlainBlock1024;
  CipherBuf: TRSACipherBlock1024;
  BytesRead: int64;
  AKey: TLbRSAKey;
  FullSize, CurrentSize, OriginalSize: Int64;
  Percent: integer;
  KeyStream, TempStream, TempStreamOut: TTntMemoryStream;
  RKey: TKey256;
  EKSize: int64;
  Context   : TRDLContext;
  RDLBlock  : TRDLBlock;
  Seed: integer;
begin
  Result:= false;

  FLastPercent:= -1;

  if (WideFileExists(Source)) then
    if (FTools.IsFileLocked(Source)) then
    begin
      Log(WideFormat(Translator.GetMessage('288'), [FSourceOriginal], FS), true, false);
      Exit;
    end;

  if (not WideFileExists(FPublicKey)) then
  begin
    Log(WideFormat(Translator.GetMessage('293'), [FSourceOriginal, FPublicKey], FS), true, false);
    Exit;
  end;


  ///  This is a hybrid method. First, I generate a RANDOM Rijhndael key
  ///  and encrypt it using RSA. Then I encrypt the file with Rijndael
  ///  using the random key. The RSA encrypted Random key is send in the
  ///  begining of the file
  try
    TempStream:= TTntMemoryStream.Create();
    TempStreamOut:= TTntMemoryStream.Create();
    KeyStream:= TTntMemoryStream.Create();
    AKey:= TLbRSAKey.Create(aks1024);
    try
      Log(Translator.GetMessage('287'), false, true);
      // Generate a random key
      GenerateRandomKey(RKey, SizeOf(RKey));
      // Load the public key
      KeyStream.LoadFromFile(FPublicKey);
      AKey.LoadFromStream(KeyStream);
      //copy the RKey to the temp stream
      TempStream.Position:= 0;
      TempStream.Write(RKey,SizeOf(RKey));

      TempStream.Position:= 0;
      TempStreamOut.Position:= 0;
      BytesRead := TempStream.Read(PlainBuf, sizeof(PlainBuf));
      while (BytesRead <> 0) do
      begin
        EncryptRSA1024(aKey, PlainBuf, CipherBuf);
        TempStreamOut.Write(CipherBuf, sizeof(CipherBuf));
        BytesRead := TempStream.Read(PlainBuf, sizeof(PlainBuf));
      end;

      // Now, the random key is encrypted, so encrypt the rest
      InStream:= TTntFileStream.Create(Source, fmOpenRead or fmShareExclusive);
      try
        OutStream:= TTntFileStream.Create(Destination, fmCreate or fmShareExclusive);
        try
        
          Log(WideFormat(Translator.GetMessage('323'),
                    [FSourceOriginal, DestinationOriginal], FS), false, true);

          EKSize:= TempStreamOut.Size;

          OutStream.Write(EKSize,SizeOf(EKSize));
          TempStreamOut.Position:= 0;
          OutStream.CopyFrom(TempStreamOut,EKSize);

          InStream.Position:= 0;
          CurrentSize:= 0;
          FullSize:= InStream.Size;
          originalSize:= InStream.Size;

          // Write the size of the stream
          OutStream.Write(OriginalSize, SizeOf(OriginalSize));
          // begin encrypting
          InitEncryptRDL(RKey, sizeof(RKey), Context, True);
          TMyRDLBlock(RDLBlock)[1] := INT_ENCRIJNDAEL128;
          Seed:= INT_SEED;
          TMyRDLBlock(RDLBlock)[0] := Ran03(Seed);
          TMyRDLBlock(RDLBlock)[2] := Ran03(Seed);
          TMyRDLBlock(RDLBlock)[3] := Ran03(Seed);

          EncryptRDL(Context, RDLBlock);
          OutStream.Write(RDLBlock, sizeof(RDLBlock));
          {read the first block from the stream}
          BytesRead := InStream.Read(RDLBlock, sizeof(RDLBlock));
          while (BytesRead <> 0) do
          begin
            EncryptRDL(Context, RDLBlock);
            OutStream.Write(RDLBlock, sizeof(RDLBlock));
            CurrentSize:= CurrentSize + BytesRead;

            BytesRead := InStream.Read(RDLBlock, sizeof(RDLBlock));

            if FullSize <> 0 then
              Percent := Trunc((CurrentSize / FullSize) * 100) else
              Percent := 100;

            if Percent <> FLastPercent then
            // Dont' send messages in vane if the % has not changed
            begin
              FLastPercent := Percent;
              ShowProgress(FSourceOriginal, Percent);

              if (FSlow) then
                Sleep(INT_SLOW);
            end;

            if DoAbort() then
              Break;
          end;

          if DoAbort() then
            Exit;

          Result:= true;
        finally
          FreeAndNil(OutStream);
        end;
      finally
        FreeAndNil(inStream);
      end;
    finally
      FreeAndNil(AKey);
      FreeAndNil(KeyStream);
      FreeAndNil(TempStreamOut);
      FreeAndNil(TempStream);
    end;
  except
    on E:Exception do
    begin
      Result:= false;
      Log(WideFormat(Translator.GetMessage('294'),[FSourceOriginal, WideString(E.Message)], FS), true, false);
    end;
  end;
end;

function TEncryptor.EncryptRijndael128(const Source,
  Destination: WideString): boolean;
type
  TMyRDLBlock = array[0..3] of LongInt;
var
  Key: TKey128;
  Context: TRDLContext;
  RDLBlock: TRDLBlock;
  BytesRead: longint;
  Seed: integer;
  aInStream, aOutStream: TTntFileStream;
  Percent: integer;
  TotalSize, CurrentSize, originalSize: Int64;
begin
  Result:= false;

  FLastPercent:= -1;

  Log(WideFormat(Translator.GetMessage('303'),
                    [FSourceOriginal, DestinationOriginal], FS), false, true);

  if (WideFileExists(Source)) then
    if (FTools.IsFileLocked(Source)) then
    begin
      Log(WideFormat(Translator.GetMessage('288'), [FSourceOriginal], FS), true, false);
      Exit;
    end;

  // begin the encryption
  try
    aInStream := TTntFileStream.Create(Source, fmOpenRead or fmShareExclusive);
    try
      aOutStream := TTntFileStream.Create(Destination, fmCreate or fmShareExclusive);
      try
        {reset the streams}
        TotalSize := aInStream.Size;
        CurrentSize:= 0;
        aInStream.Position := 0;
        aOutStream.Position := 0;
        OriginalSize:= aInStream.Size;
        {create a key}
        CobGenerateMD5KeyW(Key, FPassPhrase);
        {initialize the Rijndael context}
        InitEncryptRDL(Key, sizeof(Key), Context, True);
        // Write the orininal size
        aOutStream.Write(OriginalSize, Sizeof(OriginalSize));
        {set up the first block to contain the type of
        the encryption, together with random noise}
        TMyRDLBlock(RDLBlock)[1] := INT_ENCRIJNDAEL128;
        Seed := INT_SEED;
        TMyRDLBlock(RDLBlock)[0] := Ran03(Seed);
        TMyRDLBlock(RDLBlock)[2] := Ran03(Seed);
        TMyRDLBlock(RDLBlock)[3] := Ran03(Seed);
        {encrypt and write this block}
        EncryptRDL(Context, RDLBlock);
        aOutStream.Write(RDLBlock, sizeof(RDLBlock));
        {read the first block from the stream}
        BytesRead := aInStream.Read(RDLBlock, sizeof(RDLBlock));
        CurrentSize := CurrentSize + BytesRead;
        {while there is still data to encrypt, do so}
        while (BytesRead <> 0) do
        begin
          EncryptRDL(Context, RDLBlock);
          aOutStream.Write(RDLBlock, sizeof(RDLBlock));
          BytesRead := aInStream.Read(RDLBlock, sizeof(RDLBlock));
          CurrentSize := CurrentSize + BytesRead;
          if TotalSize <> 0 then
            Percent := Trunc((CurrentSize / TotalSize) * 100)
          else
            Percent := 100;

          if Percent <> FLastPercent then
            // Dont' send messages in vane if the % has not changed
          begin
            FLastPercent := Percent;
            ShowProgress(FSourceOriginal, Percent);

            if FSlow then
              Sleep(INT_SLOW);
          end;

          if DoAbort() then
            Break;

        end;

        if DoAbort() then
          Exit;

        Result := true;
      finally
        FreeAndNil(aOutStream);
      end;
    finally
      FreeAndNil(aInStream);
    end;
  except
    on E: Exception do
    begin
      Result := false;
      Log(WideFormat(Translator.GetMessage('294'),
                    [FSourceOriginal, Widestring(E.Message)],FS), true, false);
    end;
  end;
end;


function TEncryptor.CopySecurity(const Source,
  Destination: WideString): cardinal;
begin
  Result:= ERROR_FILE_NOT_FOUND;
  if (Assigned(OnNTFSPermissionsCopy)) then
    Result:= OnNTFSPermissionsCopy(Source, Destination);
end;

constructor TEncryptor.Create(const Par: TEncryptPar; const SecundaryOperation: boolean);
begin
  inherited Create();
  GetLocaleFormatSettings(LOCALE_SYSTEM_DEFAULT, FS);
  FTemp:= Par.Temp;
  FAppPath:= Par.AppPath;
  FBackupType:= Par.BackupType;
  FUseAttributes:= Par.UseAttributes;
  FSeparated:= Par.Separated;
  FDTFormat:= Par.DTFormat;
  FDoNotSeparate:= Par.DoNotSeparate;
  FDoNotUseSpaces:= Par.DoNotUseSpaces;
  FSlow:= Par.Slow;
  FBufferSize:= Par.BufferSize;
  FCopyTimeStamps:= Par.CopyTimeStamps;
  FCopyAttributes:= Par.CopyAttributes;
  FCopyNTFS:= Par.CopyNTFS;
  FClearAttributes:= Par.ClearAttributes;
  FDeleteEmptyFolders:= Par.DeleteEmptyFolders;
  FAlwaysCreateDirs:= Par.AlwaysCreateDirs;
  FSubdirs:= Par.Subdirs;
  FExcludemask:= Par.Excludemask;
  FIncludeMask:= Par.IncludeMask;
  FEncMethod:= Par.EncMethod;
  FPassPhrase:= Par.PassPhrase;
  FSecundaryOperation:= SecundaryOperation;
  FPropagate:= Par.Propagate;

  FLastPercent:= -1;

  FTools:= TCobTools.Create();

  FPublicKey:= FTools.NormalizeFileName(Par.PublicKey);
end;

destructor TEncryptor.Destroy();
begin
  FreeAndNil(FTools);
  inherited Destroy();
end;

function TEncryptor.DoAbort(): boolean;
begin
  Result:= false;
  if (Assigned(OnAbort)) then
    Result:= OnAbort();
end;

procedure TEncryptor.FileBegin(const FileName, DestFile: WideString;
  const Single: boolean);
begin
  if (Assigned(OnFileBegin)) then
    OnFileBegin(FileName, DestFile, Single);
end;

procedure TEncryptor.FileEnd(const FileName, DestFile: WideString; const Single,
  Success, Secundary: boolean);
begin
  if (Assigned(OnFileEnd)) then
    OnFileEnd(FileName, DestFile, Single, Success, Secundary);
end;

function TEncryptor.GetFinalDirectory(const Source,
  Destination: WideString): WideString;
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
    if (FAlwaysCreateDirs) then
      Result:= CobSetBackSlashW(Result) + ShortName;
  end else
  begin
    ShortName:= FTools.GetDirNameSeparatedW(ShortName, FDTFormat,not FDoNotSeparate, Now());
    if (FDoNotUseSpaces) then
      ShortName:= FTools.DeleteSpacesW(ShortName);
    Result:= CobSetBackSlashW(Destination) + ShortName;
  end;
end;

procedure TEncryptor.Log(const Msg: WideString; const Error, Verbose: boolean);
begin
  if (Assigned(OnLog)) then
    OnLog(Msg, Error, Verbose);
end;

function TEncryptor.NeedToCopy(const FileName,
  FileNameDest: WideString): boolean;
begin
 // Check if there is need to copy the file
  // based on the backup type
  Result:= true;

  // if encrypting a zip file, do it
  if (FSecundaryOperation = BOOL_ENCSECUNDARY) then
    Exit;

  if (FBackupType = INT_BUFULL) or (FBackupType = INT_BUDUMMY) then
    Exit;

  //Here are only diff or inc

  if (FUseAttributes) then
    Result:= FTools.GetArchiveAttributeW(FileName) else
    Result:= FTools.NeedToCopyByTimeStamp(FileName, FileNameDest);
end;

function TEncryptor.NeedToCopyMasks(const FileName: WideString): boolean;
var
  IsInExclude, IsInInclude: boolean;
begin
  Result:= true;

  // if encrypting a zip file, do it
  if (FSecundaryOperation = BOOL_ENCSECUNDARY) then
    Exit;

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

procedure TEncryptor.ShowProgress(const FileName: WideString;
  const Percent: integer);
begin
  if (Assigned(OnFileProgress)) then
    OnFileProgress(FileName, Percent);
end;

end.
