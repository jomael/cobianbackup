{*******************************************************************************
***                                                                          ***
***                       © 2000-2006 by Luis Cobian                         ***
***                           All rights reserved                            ***
***                                                                          ***
***                           cobian@educ.umu.se                             ***
***                                                                          ***
***                                                                          ***
***                         Encryption rutines                               ***
***                       for all Cobian's projects                          ***
***                                                                          ***
***                                                                          ***
***                                                                          ***
*******************************************************************************}

// Some code modified from TurboPower LockBox2
// UUse the blowfish method

unit CobEncrypt;

interface

uses LbCipher, LbProc, LbString, LbClass, Classes;

type
  TCobBlowfish = class (TLbBlowfish)
  public
    procedure GenerateKeyW(const Passphrase: WideString);
  end;

function CobEncryptString(const StringIn, PassPhrase: AnsiString;
                          out StringOut: AnsiString): boolean;
function CobDecryptString(const StringIn, PassPhrase: AnsiString;
                          out StringOut: AnsiString): boolean;
function CobEncryptStringW(const StringInW, PassPhraseW: WideString;
                          out StringOutW: WideString): boolean;
function CobDecryptStringW(const StringInW, PassPhraseW: WideString;
                          out StringOutW: WideString): boolean;

procedure CobGenerateMD5KeyW(var Key : TKey128; const Str : WideString);
procedure CobGenerateLMDKeyW(var Key; KeySize : Integer; const Str : WideString);

implementation

const
  AS_CHECKING: AnsiString = '{D7B831B4-9386-4FDD-A72E-6FBE928CA140}';
  WS_CHECKING: WideString = '{3439FCD1-60F9-40E8-98DF-9425FC7F5ADC}';


procedure CobGenerateMD5KeyW(var Key : TKey128; const Str : WideString);
var
  D : TMD5Digest;
begin
  HashMD5(D, Str[1], Length(Str) * SizeOf(WideChar));
  Key := TKey128(D);
end;

procedure CobGenerateLMDKeyW(var Key; KeySize : Integer; const Str : WideString);
begin
  HashLMD(Key, KeySize, Str[1], Length(Str) * SizeOf(WideChar));
end;

// ************************ANSI***********************************************//
function EncryptDecryptString(const StringIn: AnsiString; const Key128:TKey128;
                              out StringOut:AnsiString; Encrypt: boolean): boolean;
var
  InStream  : TMemoryStream;
  OutStream : TMemoryStream;
  WorkStream : TMemoryStream;
begin
  Result:= true;
  try
    InStream := TMemoryStream.Create();
    OutStream := TMemoryStream.Create();
    WorkStream := TMemoryStream.Create();
    try
      InStream.Write(StringIn[1], Length(StringIn));
      InStream.Position := 0;

      if Encrypt then
        begin
          BFEncryptStream(InStream, WorkStream, Key128, True);
          WorkStream.Position := 0;
          LbEncodeBase64(WorkStream, OutStream);
        end else
        begin
          LbDecodeBase64(InStream, WorkStream);
          WorkStream.Position := 0;
          BFEncryptStream(WorkStream, OutStream, Key128, False);
        end;
      OutStream.Position := 0;
      SetLength(StringOut, OutStream.Size);
      OutStream.Read(StringOut[1], OutStream.Size);
    finally
      InStream.Free;
      OutStream.Free;
      WorkStream.Free;
    end;
  except
    Result:= false;
  end;
end;

function CobEncryptString(const StringIn, PassPhrase: AnsiString;
                          out StringOut: AnsiString): boolean;
var
  Key128: TKey128;
  StringInEx: AnsiString;
begin
  GenerateLMDKey(Key128, SizeOf(Key128), PassPhrase);
  StringOut:= '';

  // Add a known checking string in the begining
  // to check if the string is OK when decrypting

  StringInEx:=  AS_CHECKING + StringIn;
  Result:= EncryptDecryptString(StringInEx, Key128, StringOut, true);
end;

function CobDecryptString(const StringIn, PassPhrase: AnsiString;
                          out StringOut: AnsiString): boolean;
var
  Key128: TKey128;
  StringOutEx: AnsiString;
begin
  GenerateLMDKey(Key128, SizeOf(Key128), PassPhrase);
  StringOut:= '';
  StringOutEx:= '';
  Result:= EncryptDecryptString(StringIn, Key128, StringOutEx, false);

  // Check if the known cheking string is present
  // if so, the password was OK. Delete the known string and
  // send the output.

  if Result then
    if (Pos(AS_CHECKING,StringOutEx) = 1) then
      StringOut:= Copy(StringOutEx,Length(AS_CHECKING) + 1,
                    Length(StringOutEx)-Length(AS_CHECKING)) else
      Result:= false;
end;


// ************************WIDE***********************************************//

procedure GenerateLMDKeyW(var Key; KeySize : Integer; const WStr : WideString);
begin
  HashLMD(Key, KeySize, WStr[1], Length(WStr) * SizeOf(WideChar));
end;

function EncryptDecryptStringW(const StringInW: WideString; const Key128:TKey128;
                              out StringOutW:WideString; Encrypt: boolean): boolean;
var
  InStream  : TMemoryStream;
  OutStream : TMemoryStream;
  WorkStream : TMemoryStream;
  Temp: AnsiString;
begin
  Result:= true;
  try
    InStream := TMemoryStream.Create();
    OutStream := TMemoryStream.Create();
    WorkStream := TMemoryStream.Create();
    try
      if Encrypt then
        begin
          InStream.Write(StringInW[1], Length(StringInW) * SizeOf(WideChar));
          InStream.Position := 0;
          BFEncryptStream(InStream, WorkStream, Key128, True);
          WorkStream.Position := 0;
          LbEncodeBase64(WorkStream, OutStream);

          // Because the output of the base64 function is an array
          // of Ansi char, assigning it to a WideChar will be weird
          // so output it to a temporary AnsiString

          OutStream.Position := 0;
          SetLength(Temp, OutStream.Size);
          OutStream.Read(Temp[1], OutStream.Size);
          StringOutW:= WideString(Temp);
        end else
        begin
          /// Because assigning the string to a widestring adds bytes,
          /// converit it to ansi first.
          /// A Base64 encoded char can be coverted without problems

          Temp:= AnsiString(StringInW);
          InStream.Write(Temp[1], Length(Temp));
          InStream.Position := 0;
          LbDecodeBase64(InStream, WorkStream);
          WorkStream.Position := 0;
          BFEncryptStream(WorkStream, OutStream, Key128, False);

          OutStream.Position := 0;
          SetLength(StringOutW, OutStream.Size div Sizeof(WideChar));
          OutStream.Read(StringOutW[1], OutStream.Size); 
        end;
    finally
      InStream.Free;
      OutStream.Free;
      WorkStream.Free;
    end;
  except
    Result:= false;
  end;       
end;

function CobEncryptStringW(const StringInW, PassPhraseW: WideString;
                          out StringOutW: WideString): boolean;
var
  Key128: TKey128;
  StringInExW: WideString;
begin
  GenerateLMDKeyW(Key128, SizeOf(Key128), PassPhraseW);
  StringOutW:= '';

  // Add a known checking string in the begining
  // to check if the string is OK when decrypting

  StringInExW:=  WS_CHECKING + StringInW;
  Result:= EncryptDecryptStringW(StringInExW, Key128, StringOutW, true);
end;

function CobDecryptStringW(const StringInW, PassPhraseW: WideString;
                            out StringOutW: WideString): boolean;
var
  Key128: TKey128;
  StringOutExW: WideString;
begin
  GenerateLMDKeyW(Key128, SizeOf(Key128), PassPhraseW);
  StringOutW:= '';
  StringOutExW:= '';
  Result:= EncryptDecryptStringW(StringInW, Key128, StringOutExW, false);

  // Check if the known cheking string is present
  // if so, the password was OK. Delete the known string and
  // send the output.

  if Result then
    if (Pos(WS_CHECKING,StringOutExW) = 1) then
      StringOutW:= Copy(StringOutExW,Length(WS_CHECKING) + 1,
                    Length(StringOutExW)-Length(WS_CHECKING)) else
      Result:= false;
end;

{ TCobBlowfish }

procedure TCobBlowfish.GenerateKeyW(const Passphrase: WideString);
begin
  CobGenerateMD5KeyW(FKey, Passphrase);
end;

end.
