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

// Generates a pair of RSA keys

unit decryptor_KeysGenerator;

interface

uses
  Classes, LbAsym, LbRSA, TntClasses, CobEncrypt;

type
  TGeneratorRec = record
      APublicKey: WideString;
      APrivateKey: WideString;
      APassphrase: WideString;
      Encrypted: boolean;
      Size: integer;
  end;

  TKeysGenerator = class(TThread)
  public
    PublicKey: WideString;
    PrivateKey: WideString;
    Errors: cardinal;
    constructor Create(const Rec: TGeneratorRec);
    destructor Destroy();override;
  private
    { Private declarations }
    FPhrase: WideString;
    FEncrypt: boolean;
    FPrivateKey: TLbRSAKey;
    FPublicKey: TLbRSAKey;
    FSize: integer;
    KeySize: TLbAsymKeySize;
    procedure EncryptIt(TempStream, PrivateStream: TTntMemoryStream);
  protected
    procedure Execute; override;
  end;

implementation

uses bmConstants, SysUtils, LbCipher, LbClass;


{ TKeysGenerator }

constructor TKeysGenerator.Create(const Rec: TGeneratorRec);
begin
  inherited Create(true);
  Errors:= 0;
  PrivateKey:= Rec.APrivateKey;
  PublicKey:= Rec.APublicKey;
  FEncrypt:= Rec.Encrypted;
  FPhrase:= Rec.APassphrase;
  FSize:= Rec.Size;
  {case FSize of
    INT_1024: KeySize:= aks1024;
    INT_768:  KeySize:= aks768;
    INT_512:  KeySize:= aks512;
    INT_256: KeySize:= aks256;
    else KeySize:= aks128;
  end;     }
  KeySize:= aks1024;

  FPrivateKey:= TLbRSAKey.Create(KeySize);
  FPublicKey:= TLbRSAKey.Create(KeySize);
  
  FPrivateKey.Passphrase:= '';
  FPublicKey.Passphrase:= '';
end;

destructor TKeysGenerator.Destroy();
begin
  FreeAndNil(FPrivateKey);
  FreeAndNil(FPublicKey);
  inherited Destroy();
end;

procedure TKeysGenerator.EncryptIt(TempStream, PrivateStream: TTntMemoryStream);
var
  BlowFish: TCobBlowfish;
begin
  BlowFish:= TCobBlowfish.Create(nil);
  try
    BlowFish.GenerateKeyW(FPhrase);
    BlowFish.CipherMode:= cmCBC;
    TempStream.Position:= 0;
    PrivateStream.Position:= 0;
    BlowFish.EncryptStream(TempStream, PrivateStream);
  finally
    FreeAndNil(BlowFish);
  end;
end;

procedure TKeysGenerator.Execute();
var
  FPrivStream,FTempStream,FPubStream: TTnTMemoryStream;
begin
  try
    FPrivStream:= TTntMemoryStream.Create();
    FPubStream:= TTntMemoryStream.Create();
    FTempStream:= TTntMemoryStream.Create();
    try
      GenerateRSAKeysEx(FPrivateKey, FPublicKey, KeySize, INT_DEFITERACTIONS, nil);
      FPublicKey.StoreToStream(FPubStream);
      if (FEncrypt) then
        begin
          FPrivateKey.StoreToStream(FTempStream);
          EncryptIt(FTempStream, FPrivStream);
        end else
        FPrivateKey.StoreToStream(FPrivStream);
      FPubStream.SaveToFile(PublicKey);
      FPrivStream.SaveToFile(PrivateKey);
    finally
      FreeAndNil(FTempStream);
      FreeAndNil(FPubStream);
      FreeAndNil(FPrivStream);
    end;
  except
    inc(Errors);
  end;
end;

end.
