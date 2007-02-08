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

// Working unit for the decryptor dll. Implement decryption for all methods

unit decryptor_Decryptor;

interface

uses
  Classes, LbRSA, bmCommon, SysUtils, LbAsym;

type
  TDecryptorRec = record
    AInput: WideString;
    AOutput: WideString;
    APassPhrase: WideString;
    APrivateKey: WideString;
    AUnencrypted: boolean;
    AUseLanguage: boolean;
    ANewMethod: boolean;
    AIndex: integer;
    ASize: integer;
  end;

  TDecryptor = class(TThread)
  public
    Errors: cardinal;
    FCurrent: Int64;
    constructor Create(const Rec: TDecryptorRec);
    destructor Destroy();override;
  private
    { Private declarations }
    FInput: WideString;
    FOutput: WideString;
    FPhrase: WideString;
    FPrivateKey: WideString;
    FUnencrypted: boolean;
    FNewMethod: boolean;
    FIndex: integer;
    FSize: integer;
    FKeySize: TLbAsymKeySize;
    // to synchronize
    FMsg: WideString;
    FError: boolean;
    FPartial: integer;
    FTotal: integer;
    //
    FTool: TCobTools;
    FUseLanguages: boolean;
    FFiles: Int64;
    FS: TFormatSettings;
    FKey: TLbRSAKey;
    FirstFile: boolean;
    FOriginalSource: WideString;
    procedure Log(const Msg: WideString; const Error: boolean);
    procedure LogSync();
    procedure ShowPercentSync();
    procedure ShowPercent(const Partial: integer);
    procedure DecryptFile(const FileName, Destination: WideString);
    procedure DecryptDir(const Directory, Destination: WideString);
    function DecryptRSA(const Source, Destination: WideString): boolean;
    function DecryptRijndael(const Source, Destination: WideString; const Old: boolean): boolean;
    function DecryptDES(const Source, Destination: WideString; const Old: boolean): boolean;
    function DecryptBlowfish(const Source, Destination: WideString; const Old: boolean): boolean;
    function DoAbort(): boolean;
    function LoadKey(const FileName: WideString): boolean;
  protected
    procedure Execute(); override;
  end;

implementation

uses decryptor_Main, TntSysUtils, decryptor_Strings, CobCommonW, bmConstants,
      Windows, TntClasses, CobEncrypt, LbClass, LbCipher;

{ TRSADecryptor }

constructor TDecryptor.Create(const Rec: TDecryptorRec);
begin
  inherited Create(true);
  GetLocaleFormatSettings(LOCALE_SYSTEM_DEFAULT, FS);
  FInput:= Rec.AInput;
  FOutput:= Rec.AOutput;
  FPhrase:= Rec.APassPhrase;
  FPrivateKey:= Rec.APrivateKey;
  FUnencrypted:= Rec.AUnencrypted;
  FUseLanguages:= Rec.AUseLanguage;
  FNewMethod:= Rec.ANewMethod;
  FIndex:= Rec.AIndex;
  FSize:= Rec.ASize;
  Errors:= 0;
  FFiles:= 0;
  FCurrent:= 0;
  FirstFile:= true;
  {case FSize of
    INT_1024: FKeySize:= aks1024;
    INT_768: FKeySize:= aks768;
    INT_512: FKeySize:= aks512;
    INT_256: FKeySize:= aks256;
    else
      FKeySize:= aks128;
  end;  }
  FKeySize:= aks1024;
  FTool:= TCobTools.Create();
  FKey:= TLbRSAKey.Create(FKeySize);
end;

function TDecryptor.DecryptBlowfish(const Source, Destination: WideString;
  const Old: boolean): boolean;
var
  Key: TKey128;
  InStream, OutStream: TTntFileStream;
  Msg: WideString;
  Context : TBFContext;
  BFBlock : TBFBlock;
  Percent, LastPercent: integer;
  BytesToDecrypt, BytesToWrite, FullSize, CurrentSize: int64;
  Check: longint;
begin
  Result:= true;

  try
    InStream:= TTntFileStream.Create(Source, fmOpenRead or fmShareDenyWrite);
    try
      OutStream:= TTntFileStream.Create(Destination, fmCreate or fmShareExclusive);
      try
        InStream.Position:= 0;
        OutStream.Position:= 0;
        LastPercent:= -1;
        CurrentSize:= 0;

        //Generate A Key
        if (Old) then
           GenerateMD5Key(Key, AnsiString(FPhrase)) else
           CobGenerateMD5KeyW(Key, FPhrase);

        InitEncryptBF(Key, Context);

        if (not Old) then
          InStream.Read(BytesToDecrypt, Sizeof(BytestoDecrypt));

        InStream.ReadBuffer(BFBlock, sizeof(BFBlock));
        EncryptBF(Context, BFBlock, False);
        Check:= BFBlock[1];

        if (Old) then
          if (Check >= 0) then
            BytesToDecrypt:= Check else
            BytesToDecrypt:= InStream.Size - SizeOf(BFBlock);

        FullSize:= BytesToDecrypt;

        if (not Old) then
          if (Check <> INT_ENCBLOWFISH128) then
          begin
            if (FUseLanguages) then
              Msg:= FTranslator.GetMessage('322') else
              Msg:= WSD_WRONGPASSPHRASEMETHOD;
            Log(Msg, true);
            Result:= false;
            Exit;
          end;

        while (BytesToDecrypt <> 0) do
        begin
          InStream.ReadBuffer(BFBlock, sizeof(BFBlock));
          EncryptBF(Context, BFBlock, False);
          if (BytesToDecrypt > sizeof(BFBlock)) then
            BytesToWrite := sizeof(BFBlock) else
            BytesToWrite := BytesToDecrypt;

          dec(BytesToDecrypt, BytesToWrite);
          OutStream.WriteBuffer(BFBlock, BytesToWrite);
          CurrentSize:= CurrentSize + BytesToWrite;

          if (FullSize <> 0) then
            Percent := Trunc((CurrentSize / FullSize)*100) else
            Percent:= INT_100;

          if (LastPercent <> Percent) then
          begin
            ShowPercent(Percent);
            LastPercent:= Percent;
          end;

          if (DoAbort()) then
          begin
            Result:= false;
            Break;
          end;
            
        end;

      finally
        FreeAndNil(OutStream);
      end;
    finally
      FreeAndNil(InStream);
    end;
  except
    on E:Exception do
    begin
      if (FUseLanguages) then
        Msg:= WideFormat(FTranslator.GetMessage('320'),
                          [FOriginalSource, AnsiString(E.Message)],FS) else
        Msg:= WideFormat(WSD_EXCEPTION, [FOriginalSource, AnsiString(E.Message)],FS);
      inc(Errors);
      Log(Msg, true);
      Result:= false;
    end;
  end;
end;

function TDecryptor.DecryptDES(const Source, Destination: WideString;
  const Old: boolean): boolean;
type
  TMyDESBlock = array[0..1] of LongInt;
var
  InStream, OutStream: TTntFileStream;
  FullSize, CurrentSize, BytesToDecrypt, BytesToWrite: int64;
  Msg: WideString;
  Percent, LastPercent: integer;
  Key       : TKey128;
  DESKey    : TKey64;
  Context   : TDESContext;
  DESBlock  : TDESBlock;
  Check: longint;
begin
  Result:= true;

  try
    InStream:= TTntFileStream.Create(Source, fmOpenRead or fmShareDenyWrite);
    try
      OutStream:= TTntFileStream.Create(Destination, fmCreate or fmShareExclusive);
      try
        InStream.Position:= 0;
        OutStream.Position:= 0;
        LastPercent:= -1;
        CurrentSize:= 0;

        if (Old) then
          GenerateMD5Key(Key, AnsiString(FPhrase)) else
          CobGenerateMD5KeyW(Key, FPhrase);

        Move(Key, DESKey, sizeof(DESKey));

        InitEncryptDES(DESKey, Context, False);

        if (not Old) then       // The new method has the size as the first 8 bytes
          InStream.Read(BytesToDecrypt, Sizeof(BytesToDecrypt));

        InStream.ReadBuffer(DESBlock, sizeof(DESBlock));
        EncryptDES(Context, DESBlock);

        // The old method had some problems

        Check:= TMyDesBlock(DESBlock)[1];
        if (Old) then
          if (Check >= 0) then
            BytesToDecrypt:= Check else
            BytesToDecrypt := InStream.Size - SizeOf(DESBlock);

        FullSize:= BytesToDecrypt;

        if (not Old) then
          if (Check <> INT_ENCDES64) then
          begin
            if (FUseLanguages) then
              Msg:= FTranslator.GetMessage('322') else
              Msg:= WSD_WRONGPASSPHRASEMETHOD;
            Log(Msg, true);
            Result:= false;
            Exit;
          end;

        while (BytesToDecrypt <> 0) do
        begin
          InStream.ReadBuffer(DESBlock, sizeof(DESBlock));
          EncryptDES(Context, DESBlock);

          if (BytesToDecrypt > sizeof(DESBlock)) then
            BytesToWrite := sizeof(DESBlock) else
            BytesToWrite := BytesToDecrypt;
          dec(BytesToDecrypt, BytesToWrite);
          OutStream.WriteBuffer(DESBlock, BytesToWrite);

          CurrentSize:= CurrentSize + BytesToWrite;

          if (FullSize <> 0) then
            Percent := Trunc((CurrentSize / FullSize)*100) else
            Percent:= INT_100;

          if (LastPercent <> Percent) then
          begin
            ShowPercent(Percent);
            LastPercent:= Percent;
          end;

          if (DoAbort()) then
          begin
            Result:= false;
            Break;
          end;
        end;
      finally
        FreeAndNil(OutStream);
      end;
    finally
      FreeAndNil(InStream);
    end;
  except
    on E:Exception do
    begin
      if (FUseLanguages) then
        Msg:= WideFormat(FTranslator.GetMessage('320'),
                          [FOriginalSource, AnsiString(E.Message)],FS) else
        Msg:= WideFormat(WSD_EXCEPTION, [FOriginalSource, AnsiString(E.Message)],FS);
      inc(Errors);
      Log(Msg, true);
      Result:= false;
    end;
  end;
end;

procedure TDecryptor.DecryptDir(const Directory, Destination: WideString);
var
  SR: TSearchRecW;
  Dir, Dest, Msg: WideString;
  procedure Analyze();
  begin
    if (SR.Name <> WS_CURRENTDIR) and (SR.Name <> WS_PARENTDIR) then
    begin
      if (faDirectory and SR.Attr)> 0 then
        DecryptDir(CobSetBackSlashW(Directory)+SR.Name,
                   CobSetBackSlashW(Destination) + SR.Name) else
        DecryptFile(CobSetBackSlashW(Directory)+SR.Name,
                    CobSetBackSlashW(Destination) + WideChangeFileExt(SR.Name, WS_NIL));
    end;
  end;
begin
  Dir:= CobSetBackSlashW(Directory) + WS_ALLFILES;
  Dir:= FTool.NormalizeFileName(Dir);
  Dest:= FTool.NormalizeFileName(CobSetBackSlashW(Destination));
  if (not WideDirectoryExists(Dest)) then
    if (WideForceDirectories(Dest)) then
    begin
      if (FUseLanguages) then
        Msg:= WideFormat(FTranslator.GetMessage('312'),[Destination],FS) else
        Msg:= WideFormat(WSD_CREATEDDIR,[Destination],FS);
      Log(Msg, false);
    end else
    begin
      if (FUseLanguages) then
        Msg:= WideFormat(FTranslator.GetMessage('313'),[Destination],FS) else
        Msg:= WideFormat(WSD_CREATEDDIRFAILED,[Destination],FS);
      Log(Msg, false);
    end;

  if (WideFindFirst(Dir, faAnyFile, SR) = 0) then
  begin
    Analyze();

    while WideFindNext(SR) = 0 do
    begin
      Analyze();

      if (DoAbort()) then
        Break;
    end;
    
    WideFindClose(SR);
  end; 
end;

procedure TDecryptor.DecryptFile(const FileName, Destination: WideString);
var
  Msg, ASource, ADestination: WideString;
  Result: boolean;
begin
  FOriginalSource:= FileName;
  ASource:= FTool.NormalizeFileName(FileName);
  ADestination:= FTool.NormalizeFileName(Destination);

  if (FUseLanguages) then
    Msg:= WideFormat(FTranslator.GetMessage('321'),[FOriginalSource],FS) else
    Msg:= WideFormat(WSD_DECRYPTING,[FOriginalSource], FS);
  Log(Msg, false);
  
  if (FNewMethod) then
  begin
    case FIndex of
      INT_DECRSA: Result:= DecryptRSA(ASource, ADestination);
      INT_DECBLOWFISH: Result:= DecryptBlowfish(ASource, ADestination, false);
      INT_DECRIJNDAEL: Result:= DecryptRijndael(ASource, ADestination, false);
      INT_DECDES: Result:= DecryptDES(ASource, ADestination, false);
      else
        Result:= false;
    end;
  end else
  begin
    case FIndex of
      INT_DECOLDBLOWFISH128: Result:= DecryptBlowfish(ASource, ADestination, true);
      INT_DECOLDRIJNDAEL: Result:= DecryptRijndael(ASource, ADestination, true);
      INT_DECOLDDES: Result:= DecryptDES(ASource, ADestination, true);
      else
        Result:= false;
    end;
  end;

  if (Result) then
  begin
    if (FUseLanguages) then
      Msg:= WideFormat(FTranslator.GetMessage('315'),[FileName],FS) else
      Msg:= WideFormat(WSD_DECRYPTEDOK, [FileName],FS);
      Log(Msg, false);

      //2006-06-22 A quick fix
      FTool.CopyTimeStamps(ASource, ADestination);
      FTool.CopyAttributes(ASource, ADestination);
  end else
  begin
    if (FUseLanguages) then
      Msg:= WideFormat(FTranslator.GetMessage('316'),[FileName],FS) else
      Msg:= WideFormat(WSD_DECRYPTEDFAILED, [FileName],FS);
      Log(Msg, true);
  end;

  inc(FCurrent);

  ShowPercent(INT_NIL);

  FirstFile:= false; // used to create the key only when the first file is run
end;

function TDecryptor.DecryptRijndael(const Source, Destination: WideString;
  const Old: boolean): boolean;
type
  TMyRDLBlock = array[0..3] of LongInt;
var
  InStream, OutStream: TTntFileStream;
  LastPercent, Percent: integer;
  FullSize, CurrentSize, BytesToDecrypt, BytesToWrite: int64;
  Key       : TKey128;
  RDLBlock  : TRDLBlock;
  Check: longint;
  Context   : TRDLContext;
  Msg: WideString;
begin
  Result:= true;

  try
    InStream:= TTntFileStream.Create(Source, fmOpenRead or fmShareDenyWrite);
    try
      OutStream:= TTntFileStream.Create(Destination, fmCreate or fmShareExclusive);
      try
        InStream.Position:= 0;
        OutStream.Position:= 0;
        LastPercent:= -1;
        CurrentSize:= 0;

        if (Old) then
          GenerateMD5Key(Key, AnsiString(FPhrase)) else
          CobGenerateMD5KeyW(Key, FPhrase);

        InitEncryptRDL(Key, sizeof(Key), Context, False);

        if (not Old) then
          InStream.Read(BytesToDecrypt, SizeOf(BytesToDecrypt));

        InStream.ReadBuffer(RDLBlock, sizeof(RDLBlock));
        EncryptRDL(Context, RDLBlock);

        Check:= TMyRDLBlock(RDLBlock)[1];

        if (Old) then
          if (Check >= 0) then
            BytesToDecrypt:= Check else
            BytesToDecrypt := InStream.Size - SizeOf(RDLBlock);

        FullSize:= BytesToDecrypt;

        if (not Old) then
          if (Check <> INT_ENCRIJNDAEL128) then
          begin
            if (FUseLanguages) then
              Msg:= FTranslator.GetMessage('322') else
              Msg:= WSD_WRONGPASSPHRASEMETHOD;
            Log(Msg, true);
            Result:= false;
            Exit;
          end;

        {while there is still data to decrypt, do so}
        while (BytesToDecrypt <> 0) do
        begin
          InStream.ReadBuffer(RDLBlock, sizeof(RDLBlock));
          EncryptRDL(Context, RDLBlock);
          if (BytesToDecrypt > sizeof(RDLBlock)) then
            BytesToWrite := sizeof(RDLBlock) else
            BytesToWrite := BytesToDecrypt;

          CurrentSize:= CurrentSize + BytesToWrite;

          dec(BytesToDecrypt, BytesToWrite);
          OutStream.WriteBuffer(RDLBlock, BytesToWrite);

          if (FullSize <> 0) then
            Percent := Trunc((CurrentSize / FullSize)*100) else
            Percent:= INT_100;

          if (LastPercent <> Percent) then
          begin
            ShowPercent(Percent);
            LastPercent:= Percent;
          end;

          if (DoAbort()) then
          begin
            Result:= false;
            Break;
          end;
        end;

      finally
        FreeAndNil(OutStream);
      end;
    finally
      FreeAndNil(InStream);
    end;
  except
    on E:Exception do
    begin
      if (FUseLanguages) then
        Msg:= WideFormat(FTranslator.GetMessage('320'),
                          [FOriginalSource, AnsiString(E.Message)],FS) else
        Msg:= WideFormat(WSD_EXCEPTION, [FOriginalSource, AnsiString(E.Message)],FS);
      inc(Errors);
      Log(Msg, true);
      Result:= false;
    end;
  end;
end;

function TDecryptor.DecryptRSA(const Source, Destination: WideString): boolean;
type
  TMyRDLBlock = array [0..3] of LongInt;
var
  InStream, OutStream: TTntFileStream;
  PrivateKey, Msg: WideString;
  PlainBuf     : TRSAPlainBlock1024;
  CipherBuf    : TRSACipherBlock1024;
  BytesRead, BytesToDecrypt, BytesToWrite : int64;
  Check: longint;
  Percent, OldPercent: integer;
  TempKey, TempKeyOut: TTntMemoryStream;
  KeySize, FullSize, CurrentSize: int64;
  RKey: TKey256;
  Context   : TRDLContext;
  RDLBlock  : TRDLBlock;
begin
  Result:= true;

  // First, decrypt the key if needed
  PrivateKey:= FTool.NormalizeFileName(FPrivateKey);

  if (not WideFileExists(PrivateKey)) then
  begin
    if (FUseLanguages) then
      Msg:= WideFormat(FTranslator.GetMessage('317'),[FPrivateKey],FS) else
      Msg:= WideFormat(WSD_PRIVATEDNOTFOUND,[FPrivateKey],FS);
    Log(Msg, true);
    inc(Errors);
    Result:= false;
    Exit;
  end;

  if (FirstFile) then
    if (not LoadKey(PrivateKey)) then
    begin
      Result:= false;
      Exit;
    end;

  // Now, decrypt the file. The key is now loaded
  try
    TempKey:= TTntMemoryStream.Create();
    TempKeyOut:= TTntMemoryStream.Create();
    InStream:= TTntFileStream.Create(Source, fmOpenRead or fmShareDenyWrite);
    try
      OutStream:= TTntFileStream.Create(Destination, fmCreate or fmShareExclusive);
      try
        InStream.Read(KeySize, SizeOf(KeySize));
        TempKey.CopyFrom(InStream, KeySize);

        // Now decrypt the random key

        TempKey.Position := 0;
        TempKeyOut.Position:= 0;

        BytesRead:= TempKey.Read(CipherBuf, SizeOf(CipherBuf));
        while (BytesRead = SizeOf(CipherBuf)) do
        begin
          BytesToWrite := DecryptRSA1024(FKey, CipherBuf, PlainBuf);
          TempKeyOut.Write(PlainBuf, BytesToWrite);
          BytesRead := TempKey.Read(CipherBuf, sizeof(CipherBuf));
        end;

        TempKeyOut.Position:= 0;
        TempKeyOut.Read(RKey, SizeOf(RKey));

        // now decrypt the file using Rijndael
        InStream.Read(BytesToDecrypt, Sizeof(BytesToDecrypt));
        FullSize:= BytesToDecrypt;

        OutStream.Position:= 0;
        OldPercent:= -1;
        CurrentSize:= 0;

        InitEncryptRDL(RKey, sizeof(RKey), Context, False);
        InStream.ReadBuffer(RDLBlock, sizeof(RDLBlock));
        EncryptRDL(Context, RDLBlock);
        Check := TMyRDLBlock(RDLBlock)[1];

        if (Check <> INT_ENCRIJNDAEL128) then
        begin
          if (FUseLanguages) then
              Msg:= FTranslator.GetMessage('322') else
              Msg:= WSD_WRONGPASSPHRASEMETHOD;
          Log(Msg, true);
          Result:= false;
          Exit;
        end;

        while (BytesToDecrypt <> 0) do
        begin
          InStream.ReadBuffer(RDLBlock, sizeof(RDLBlock));
          EncryptRDL(Context, RDLBlock);
          if (BytesToDecrypt > sizeof(RDLBlock)) then
            BytesToWrite := sizeof(RDLBlock) else
            BytesToWrite := BytesToDecrypt;
          dec(BytesToDecrypt, BytesToWrite);
          CurrentSize:= CurrentSize + BytesToWrite;
          OutStream.WriteBuffer(RDLBlock, BytesToWrite);

          if (FullSize <> 0) then
            Percent := Trunc((CurrentSize / FullSize)*100) else
            Percent:= INT_100;

          if (OldPercent <> Percent) then
          begin
            ShowPercent(Percent);
            OldPercent:= Percent;
          end;

          if (DoAbort()) then
          begin
            Result:= false;
            Break;
          end;

        end;
        
      finally
        FreeAndNil(OutStream);
      end;
    finally
      FreeAndNil(InStream);
      FreeAndNil(TempKey);
      FreeAndNil(TempKeyOut);
    end;
  except
    on E:Exception do
    begin
      if (FUseLanguages) then
        Msg:= WideFormat(FTranslator.GetMessage('320'),
                          [FOriginalSource, AnsiString(E.Message)],FS) else
        Msg:= WideFormat(WSD_EXCEPTION, [FOriginalSource, AnsiString(E.Message)],FS);
      inc(Errors);
      Log(Msg, true);
      Result:= false;
    end;
  end;
end;

destructor TDecryptor.Destroy();
begin
  FreeAndNil(FKey);
  FreeAndNil(FTool);
  inherited Destroy();
end;

function TDecryptor.DoAbort(): boolean;
begin
  Critical_Decryptor.Enter();
  try
    Result:= Flag_AbortDecryption;
  finally
    Critical_Decryptor.Leave();
  end;
end;

procedure TDecryptor.Execute();
var
  Msg, Source, Destination: WideString;
  Size: int64;
begin
  { Place thread code here }
  Source:= FTool.NormalizeFileName(FInput);
  if (WideFileExists(Source)) then
  begin
    FFiles:= 1;
    Destination:= CobSetBackSlashW(FOutput) +
                  WideChangeFileExt(WideExtractFileName(Source),WS_NIL);
    DecryptFile(FInput, Destination);
  end else
  begin
    if (FUseLanguages) then
      Msg:= FTranslator.GetMessage('311') else
      Msg:= WSD_COUNTING;
    Log(Msg, false);
    FFiles:= CobCountFilesW(Source ,WS_NIL, WS_NIL, true, Size);
    DecryptDir(FInput, FOutput);
  end;
end;

function TDecryptor.LoadKey(const FileName: WideString): boolean;
var
  KeyStream: TTntFileStream;
  TempStream: TTntMemoryStream;
  Msg: WideString;
  BlowFish: TCobBlowfish;
begin
  Result:= true;
  try
    KeyStream:= TTntFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
    try
      if (FUnencrypted) then
        FKey.LoadFromStream(KeyStream) else
        begin
          if (FUseLanguages) then
            Msg:= FTranslator.GetMessage('319') else
            Msg:= WSD_DECRYPTINGKEY;
          Log(Msg, false);
          BlowFish:= TCobBlowfish.Create(nil);
          TempStream:= TTntMemoryStream.Create();
          try
            BlowFish.GenerateKeyW(FPhrase);
            BlowFish.CipherMode:= cmCBC;
            TempStream.Position:= 0;
            KeyStream.Position:= 0;
            BlowFish.DecryptStream(KeyStream, TempStream);
            FKey.LoadFromStream(TempStream);
          finally
            FreeAndNil(TempStream);
            FreeAndNil(Blowfish);
          end;
        end;
    finally
      FreeAndNil(KeyStream);
    end;
  except
    on E:Exception do
    begin
      if (FUseLanguages) then
        Msg:= FTranslator.GetMessage('318') else
        Msg:= WSD_ERRORLOADINGKEY;
      Log(Msg, true);
      inc(Errors);
      Result:= false;
    end;
  end;
end;

procedure TDecryptor.Log(const Msg: WideString; const Error: boolean);
begin
  FMsg:= Msg;
  FError:= Error;
  Synchronize(LogSync);
end;

procedure TDecryptor.LogSync;
begin
  form_MainForm.Log(FMsg, FError);
end;

procedure TDecryptor.ShowPercentSync();
begin
  form_MainForm.ShowPercent(FPartial, FTotal);
end;

procedure TDecryptor.ShowPercent(const Partial: integer);
begin
  FPartial:= Partial;
  if (FFiles <> 0) then
    FTotal:= Trunc((FCurrent / FFiles) * 100) else
    FTotal:= INT_100;
  Synchronize(ShowPercentSync);
end;

end.
