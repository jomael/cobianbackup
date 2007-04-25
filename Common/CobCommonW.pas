{*******************************************************************************
***                                                                          ***
***                       © 2000-2006 by Luis Cobian                         ***
***                           All rights reserved                            ***
***                                                                          ***
***                           cobian@educ.umu.se                             ***
***                                                                          ***
***                                                                          ***
***                                Common rutines                            ***
***                           for all Cobian's projects                      ***
***                                                                          ***
***                                                                          ***
***                                                                          ***
*******************************************************************************}
unit CobCommonW;

interface

uses Windows, TntSysUtils, SysUtils, TntSystem,Classes, TntClasses;

{$WARN SYMBOL_PLATFORM OFF}

type
  TCobCRCCallbackW = function (const FileName: WideString;
                                    const Progress: integer): boolean of object;
  TCobBytes = array of Byte;
  
  TCobWideIO = class(TObject)    //incomplete. Only write methods done
  private
    FFile: TTntFileStream;
    FOpen: boolean;
    procedure WriteBOM();
    procedure SetPosition(const Value: Int64);
    function GetPosition(): Int64;
    function GetSize(): Int64;
  public
    property Position: Int64 read GetPosition write SetPosition;
    property Size: Int64 read GetSize;
    constructor Create(const FileName: WideString; const AppendIfExists,OpenExclusive:boolean);
    destructor Destroy();override;
    function IsOpen(): boolean;
    procedure Write(const Line:WideString);
    procedure WriteLn(const Line: WideString);
  end;

  TCobDirectoryW = (cobWindows,cobSystem,cobPersonal,cobTemporary,cobDeskTop,
                    cobStartMenu, cobStartUp, cobFavorites, cobProgramLinks,
                    cobAppData, cobLocalAppdata, cobCommonDesktop, cobCommonStartUp,
                    cobCommonProgramLinks, cobCommonStartMenu);
  TCobAutostartW = (cobNoAS, cobLocalAS, cobGlobalAS, cobBothAS);

/// File utilities
function CobGetAppPathW(): WideString;
function CobSetBackSlashW(const FileName:WideString): WideString;
function CobSetDotExtensionW(const Ext: WideString): WideString;
function CobSetLeadingBackSlashW(const FileName:WideString): WideString;
function CobSetForwardSlashW(const FileName:WideString): WideString;
function CobSetLeadingForwardSlashW(const FileName:WideString): WideString;
function CobCreateEmptyTextFileW(const FileName: WideString): boolean;
function CobGetComputerNameW(): WideString;
function CobSysErrorMessageW(const ErrorCode: cardinal): WideString;
function CobGetLegalFileNameW(const FileName: WideString): WideString;

function CobMaskMatchW(const Source, Mask: WideString;
        const CaseSensitive: boolean = false;
        const Propagate: boolean = false): boolean;

function CobDeleteDirectoryW(const Directory: WideString): boolean;

function CobSetQuotesW(const Str: WideString): WideString;

function CobGetShortDirectoryNameW(const Dir: WideString): WideString;
function CobGetShortDirectoryNameFW(const Dir: WideString): WideString;

function CobNormalizeFileNameW(const FileName: WideString): WideString;

function CobExecuteW(const FileName, Param: WideString;
                            const Hide, Wait: boolean): cardinal;

function CobExecuteAndWaitW(const FileName, Param: WideString;
                                    Hide: boolean = false): cardinal;

function CobGetUniqueNameW(): WideString;
function CobIsAdminW(): boolean;

function CobGetVersionW(const FileName: WideString): WideString;
function CobGetCurrentUserNameW(): WideString;

function CobGetPasswordQuality(const Password: WideString): integer;
function CobWideToStrByCodePage(const AValue : WideString; const ACodePage : integer): AnsiString;

function CobWideToAnsiSpecial(const Value: WideString): AnsiString;

function CobGetSpecialDirW(const Kind: TCobDirectoryW): WideString;

// Datetime to string and reverse
function CobDoubleToBinW(Value: double): WideString;
function CobBinToDoubleW(Value: WideString; var OK: boolean): double;

function CobIsNTBasedW(StopIt: boolean): boolean;
function CobIs2000orBetterW(): boolean;
function CobIsXPorBetterW(): boolean;
function CobIsVistaOrBetterW(): boolean;

function CobCountFilesW(const Source, Exclussions, Inclussions: WideString;
                        const SubDirs: boolean;  var Size: Int64): Int64;
function CobGetFileSize(const Source: WideString): Int64;
function CobFormatSizeW(const Size: Int64): WideString;

/// other
function CobBoolToStrW(const Value: boolean): WideString;
function CobStrToBoolW(const Value:WideString): boolean;
function CobIntToStrW(const Value: integer): WideString; overload;
function CobIntToStrW(const Value: Int64): WideString; overload;
function CobStrToIntW(const Value: WideString; const Default: integer): integer;
function CobStrToInt64W(const Value: WideString; const Default: integer): Int64;
function CobIsIntW(const Value: WideString): boolean;
function CobIsInt64W(const Value: WideString): boolean;

procedure CobSecondsToHMSW(const Seconds: integer; var hh,mm,ss: integer);

/// Disable the Windows ghosting feature
procedure CobDisableProcessWindowsGhostingW();


/// Returns the ACTUAL length of the widestring without #0#0
function CobStrLenW(Str: PWideChar): Cardinal;

// Security
function CobGetNullDaclAttributesW(var pSecurityDesc: PSECURITY_DESCRIPTOR): TSECURITYATTRIBUTES;
procedure CobFreeNullDaclAttributesW(var pSecurityDesc: PSECURITY_DESCRIPTOR);
//function CobCanEncryptW(): boolean;

// Autostart
function CobAutostartW(const Global: boolean; const ValueName, AppExe, Param: WideString): boolean;
function CobDeleteAutostartW(const Global: boolean; const ValueName: WideString): boolean;
function CobIsAutostartingW(const ValueName: WideString): TCobAutostartW;

function CobExpandFileNameW(const FileName: WideString): WideString;
function CobExpandUNCFileNameW(const FileName: WideString): WideString;
function CobGetUniversalNameW(const FileName: WideString): WideString;

function CobPosW(const Substring,Input: WideString; const CaseSensitive: boolean): integer;
function CobStringReplaceW(const Input, OldStr, NewString: WideString;
        const All, CaseSensitive: boolean): WideString;

function CobCalculateCRCW(const FileName: WideString;
                                      CallBack: TCobCRCCallbackW): longword;

procedure CobWideStringToArray(Dest: PWideChar; const Source: WideString);
procedure CobWideStringToBytesW(var Buffer:TCobBytes; const Str: WideString);
function CobBytesToIntegerW(const Buffer: TCobBytes): longint;
function CobBytesToWideStringW(const Buffer: TCobBytes): WideString;
procedure CobIntegerToBytesW(var Buffer: TCobBytes; const Value: longint);

implementation

uses CobRegistryW, ShlObj;

const
  WS_NIL: WideString = '';
  WS_SPACE: WideString = ' ';
  WS_NOTNT: WideString = 'This application needs a Windows NT based system in order to run. Exiting';
  WS_ERROR: WideString = 'Critical error';
  WS_TRUE: WideString = 'TRUE';
  WS_FALSE: WideString = 'FALSE';
  WS_CRYPTLIB1: WideString = 'Advapi32.dll';
  WS_CRYPTLIB2: WideString = 'Crypt32.dll';
  WS_CRYPTLIB3: WideString = 'Softpub.dll';
  WS_CONTAINER: PWideChar = '{0841D599-157D-4972-8934-841F31E4A8B8}';
  COB_MAX_PATH = 1024;
  BOM_SIZE = 2;
  USERLENGTH = 255;
  WS_QUOTE: WideChar = '"';
  WS_AUTOSTART: WideString = '\SOFTWARE\Microsoft\Windows\CurrentVersion\Run';
  INT_DOUBLELENGHT = 64;
  WS_ZERO: AnsiChar = '0';
  WS_SPACECHAR: WideChar = ' ';
  WS_ALLFILES: WideString = '*.*';
  WC_ASTERISC: WideChar = '*';
  WC_QUESTION: WideChar = '?';
  WC_JOCKER: WideChar = '|';
  WS_UNICODEHEADER: WideString = '\\?\';
  WS_UNCHEADER: WideString = '\\';
  WS_UNC: WideString = 'UNC';
  WC_DOT: WideChar = '.';
  WC_BACKSLASH: WideChar = '\';
  WC_BACKSLASHSUBST: WideChar = '¯';
  WC_COLON: WideChar = ':';
  WC_COLONSUBST: WideChar = '°';
  WC_SLASH: WideChar = '/';
  WC_SLASHSUBST: WideChar = '±';
  SECURITY_NT_AUTHORITY: TSIDIdentifierAuthority =
  (Value: (0, 0, 0, 0, 0, 5));
  SECURITY_BUILTIN_DOMAIN_RID = $00000020;
  DOMAIN_ALIAS_RID_ADMINS = $00000220;
  INT_SECONDSINHOUR = 3600;
  INT_SECONDSINMINUTE = 60;


  CRC32Table: array [0..255] of Longword =
   ($00000000, $77073096, $ee0e612c, $990951ba,
    $076dc419, $706af48f, $e963a535, $9e6495a3,
    $0edb8832, $79dcb8a4, $e0d5e91e, $97d2d988,
    $09b64c2b, $7eb17cbd, $e7b82d07, $90bf1d91,
    $1db71064, $6ab020f2, $f3b97148, $84be41de,
    $1adad47d, $6ddde4eb, $f4d4b551, $83d385c7,
    $136c9856, $646ba8c0, $fd62f97a, $8a65c9ec,
    $14015c4f, $63066cd9, $fa0f3d63, $8d080df5,
    $3b6e20c8, $4c69105e, $d56041e4, $a2677172,
    $3c03e4d1, $4b04d447, $d20d85fd, $a50ab56b,
    $35b5a8fa, $42b2986c, $dbbbc9d6, $acbcf940,
    $32d86ce3, $45df5c75, $dcd60dcf, $abd13d59,
    $26d930ac, $51de003a, $c8d75180, $bfd06116,
    $21b4f4b5, $56b3c423, $cfba9599, $b8bda50f,
    $2802b89e, $5f058808, $c60cd9b2, $b10be924,
    $2f6f7c87, $58684c11, $c1611dab, $b6662d3d,
    $76dc4190, $01db7106, $98d220bc, $efd5102a,
    $71b18589, $06b6b51f, $9fbfe4a5, $e8b8d433,
    $7807c9a2, $0f00f934, $9609a88e, $e10e9818,
    $7f6a0dbb, $086d3d2d, $91646c97, $e6635c01,
    $6b6b51f4, $1c6c6162, $856530d8, $f262004e,
    $6c0695ed, $1b01a57b, $8208f4c1, $f50fc457,
    $65b0d9c6, $12b7e950, $8bbeb8ea, $fcb9887c,
    $62dd1ddf, $15da2d49, $8cd37cf3, $fbd44c65,
    $4db26158, $3ab551ce, $a3bc0074, $d4bb30e2,
    $4adfa541, $3dd895d7, $a4d1c46d, $d3d6f4fb,
    $4369e96a, $346ed9fc, $ad678846, $da60b8d0,
    $44042d73, $33031de5, $aa0a4c5f, $dd0d7cc9,
    $5005713c, $270241aa, $be0b1010, $c90c2086,
    $5768b525, $206f85b3, $b966d409, $ce61e49f,
    $5edef90e, $29d9c998, $b0d09822, $c7d7a8b4,
    $59b33d17, $2eb40d81, $b7bd5c3b, $c0ba6cad,
    $edb88320, $9abfb3b6, $03b6e20c, $74b1d29a,
    $ead54739, $9dd277af, $04db2615, $73dc1683,
    $e3630b12, $94643b84, $0d6d6a3e, $7a6a5aa8,
    $e40ecf0b, $9309ff9d, $0a00ae27, $7d079eb1,
    $f00f9344, $8708a3d2, $1e01f268, $6906c2fe,
    $f762575d, $806567cb, $196c3671, $6e6b06e7,
    $fed41b76, $89d32be0, $10da7a5a, $67dd4acc,
    $f9b9df6f, $8ebeeff9, $17b7be43, $60b08ed5,
    $d6d6a3e8, $a1d1937e, $38d8c2c4, $4fdff252,
    $d1bb67f1, $a6bc5767, $3fb506dd, $48b2364b,
    $d80d2bda, $af0a1b4c, $36034af6, $41047a60,
    $df60efc3, $a867df55, $316e8eef, $4669be79,
    $cb61b38c, $bc66831a, $256fd2a0, $5268e236,
    $cc0c7795, $bb0b4703, $220216b9, $5505262f,
    $c5ba3bbe, $b2bd0b28, $2bb45a92, $5cb36a04,
    $c2d7ffa7, $b5d0cf31, $2cd99e8b, $5bdeae1d,
    $9b64c2b0, $ec63f226, $756aa39c, $026d930a,
    $9c0906a9, $eb0e363f, $72076785, $05005713,
    $95bf4a82, $e2b87a14, $7bb12bae, $0cb61b38,
    $92d28e9b, $e5d5be0d, $7cdcefb7, $0bdbdf21,
    $86d3d2d4, $f1d4e242, $68ddb3f8, $1fda836e,
    $81be16cd, $f6b9265b, $6fb077e1, $18b74777,
    $88085ae6, $ff0f6a70, $66063bca, $11010b5c,
    $8f659eff, $f862ae69, $616bffd3, $166ccf45,
    $a00ae278, $d70dd2ee, $4e048354, $3903b3c2,
    $a7672661, $d06016f7, $4969474d, $3e6e77db,
    $aed16a4a, $d9d65adc, $40df0b66, $37d83bf0,
    $a9bcae53, $debb9ec5, $47b2cf7f, $30b5ffe9,
    $bdbdf21c, $cabac28a, $53b39330, $24b4a3a6,
    $bad03605, $cdd70693, $54de5729, $23d967bf,
    $b3667a2e, $c4614ab8, $5d681b02, $2a6f2b94,
    $b40bbe37, $c30c8ea1, $5a05df1b, $2d02ef8d);


function CobCalculateCRCW(const FileName: WideString;
                           CallBack: TCobCRCCallbackW): longword;
var
  FileStream: TTntFileStream;
  Buffer: array[1..8192] of Byte;
  i, ReadCount: Integer;
  TempResult: Longword;
  Percent, LastPercent: integer;
  Abort: boolean;
begin
  Result:= $FFFFFFFF;
  try
    FileStream:= TTntFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite);
    try
      TempResult := $FFFFFFFF;
      FileStream.Position:= 0;
      LastPercent:= -1;
      Abort:= false;
      while (FileStream.Position <> FileStream.Size) do
        begin
          ReadCount := FileStream.Read(Buffer, SizeOf(Buffer));
          for i := 1 to ReadCount do
            TempResult := ((TempResult shr 8) and $FFFFFF)
                  xor CRC32Table[(TempResult xor Longword(Buffer[I])) and $FF];

          Percent:= Trunc((FileStream.Position/FileStream.Size)* 100);

          if (@CallBack <> nil) then
            if (Percent <> LastPercent) then
            begin
              LastPercent:= Percent;
              if (CallBack(FileName, Percent) = false) then
              begin
                Abort:= true;
                Break;
              end;
            end;
        end;
      if (not Abort) then
        Result:= not TempResult;
    finally
      FreeAndNil(FileStream);
    end;
  except
    Result:= $FFFFFFFF;
  end;
end;

function CobWideToAnsiSpecial(const Value: WideString): AnsiString;
begin
  // This is a LITERAL byte for byte translation of a WideString to Ansi
  // for example if Value = 'a' the result = #0#$61 (2 characters)
  // This can be useful if you want to use a WideString exactly without
  // conversions

  Result:= WS_NIL;

  if (Length(Value) = 0) then
    Exit;

  SetLength(Result, SizeOf(Value) * SizeOf(WideChar));

end;

function CobSysErrorMessageW(const ErrorCode: cardinal): WideString;
var
  Buffer: array[0..255] of WideChar;
var
  Len: Cardinal;
begin
  Result:= '';
  Len := FormatMessageW(FORMAT_MESSAGE_FROM_SYSTEM or FORMAT_MESSAGE_IGNORE_INSERTS or
    FORMAT_MESSAGE_ARGUMENT_ARRAY, nil, ErrorCode, 0, Buffer,
    SizeOf(Buffer) div 2, nil);
  // while (Len > 0) and (Buffer[Len - 1] in [#0..#32, '.']) do Dec(Len);
  if (Len > 0) then
  begin
    Result:= WideString(Buffer);
    // This function adds a trailing #$A#$D to the end of the message
    if (Result[Length(Result)] = WideChar(#$A)) and
      (Result[Length(Result)-1] = WideChar(#$D)) then
      Delete(Result, Length(Result) - 1, 2);
  end;
end;

function CobGetLegalFileNameW(const FileName: WideString): WideString;
const
  WC_COLON: WideChar = ':';
  WC_SEMICOLON: WideChar = ';';
  WC_SLASH: WideChar = '/';
  WC_SLASDASH: WideChar = '-';
  WC_BACKSLASH: WideChar= '\';
  WC_ASTERISC: WideChar= '*';
  WC_QUESTION: WideChar= '?';
  WC_MORETHAN: WideChar= '>';
  WC_LESSTHAN: WideChar= '<';
  WC_PIPE: WideChar= '|';

begin
  Result:= FileName;
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

function CobExecuteW(const FileName, Param: WideString;
                            const Hide, Wait: boolean): cardinal;
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
    if (Code and Wait) then
      WaitForSingleObject(ProcInfo.hProcess, INFINITE);
    //else
      //raise Exception.Create(CobSysErrorMessageW(System.GetLastError()));

  finally
    CloseHandle(ProcInfo.hProcess);
    CloseHandle(ProcInfo.hThread);
  end;
end;

function CobExecuteAndWaitW(const FileName, Param: WideString;
                                    Hide: boolean = false): cardinal;
begin
  // For compatibility with old programs of mine
  Result:= CobExecuteW(FileName, Param, Hide, true);
end;


function CobWideToStrByCodePage(const AValue : WideString; const ACodePage : integer): AnsiString;
var
  Buf : PChar;
  Size : integer;
begin 
  Result := '';
  Size := WideCharToMultiByte(ACodePage, 0, PWideChar(AValue), -1 , nil, 0, nil, nil);
  if Size = 0 then 
  begin
    Result := AnsiString(AValue);
    Exit; 
  end; 


  GetMem(Buf, Size);
  try 
    Size := WideCharToMultiByte(ACodePage, 0, PWideChar(AValue), -1 , Buf, Size, nil, nil);
    Result := AnsiString(Buf);
  finally 
    FreeMem(Buf, Size);
  end; 
end;

function CobIsAdminW(): boolean;
const
  SECURITY_NT_AUTHORITY: TSIDIdentifierAuthority = (Value: (0, 0, 0, 0, 0, 5));
  SECURITY_BUILTIN_DOMAIN_RID = $00000020;
  DOMAIN_ALIAS_RID_ADMINS = $00000220;
var
  hAccessToken: THandle;
  ptgGroups: PTokenGroups;
  dwInfoBufferSize: DWORD;
  psidAdministrators: PSID;
  x: Integer;
  bSuccess: BOOL;
begin
  Result := False;
 
  bSuccess := OpenThreadToken(GetCurrentThread, TOKEN_QUERY, True, hAccessToken);
 
  if not bSuccess then
    if GetLastError = ERROR_NO_TOKEN then
      bSuccess := OpenProcessToken(GetCurrentProcess, TOKEN_QUERY, hAccessToken);
 
  if bSuccess then
    begin
      { Need to call GetTokenInformation() twice, one to get the buffer
        size needed for the token groups, then another to actually get
        the token groups using the buffer size returned the first time.
        This fixes the ERROR_INSUFFICIENT_BUFFER error some machines get. }
      GetTokenInformation(hAccessToken, TokenGroups, nil, 0, dwInfoBufferSize);
      GetMem(ptgGroups, dwInfoBufferSize);
      try
        bSuccess := GetTokenInformation(hAccessToken, TokenGroups,
          ptgGroups, dwInfoBufferSize, dwInfoBufferSize);
        CloseHandle(hAccessToken);
 
        if bSuccess then
          begin
            AllocateAndInitializeSid(SECURITY_NT_AUTHORITY, 2,
              SECURITY_BUILTIN_DOMAIN_RID, DOMAIN_ALIAS_RID_ADMINS,
              0, 0, 0, 0, 0, 0, psidAdministrators);
            try
              {$R-}
              for x := 0 to ptgGroups.GroupCount - 1 do
                if EqualSid(psidAdministrators, ptgGroups.Groups[x].Sid) then
                  begin
                    Result := True;
                    Break;
                  end;
              {$R+}
            finally
              FreeSid(psidAdministrators);
            end;
          end;
      finally
        FreeMem(ptgGroups);
      end;
    end;
end;

{function CobIsAdminW(): boolean;
var
  hAccessToken: THandle;
  ptgGroups: PTokenGroups;
  dwInfoBufferSize: DWORD;
  psidAdministrators: PSID;
  x: Integer;
  bSuccess: BOOL;
begin
  {Works only in NT based systems. Returns true if the
  current user has administrator rights}
  {Result := False;
  bSuccess := OpenThreadToken(GetCurrentThread, TOKEN_QUERY, True,
    hAccessToken);
  if not bSuccess then
  begin
    if GetLastError = ERROR_NO_TOKEN then
      bSuccess := OpenProcessToken(GetCurrentProcess, TOKEN_QUERY,
        hAccessToken);
  end;
  if bSuccess then
  begin
    GetMem(ptgGroups, 1024);
    bSuccess := GetTokenInformation(hAccessToken, TokenGroups,
      ptgGroups, 1024, dwInfoBufferSize);
    CloseHandle(hAccessToken);
    if bSuccess then
    begin
      AllocateAndInitializeSid(SECURITY_NT_AUTHORITY, 2,
        SECURITY_BUILTIN_DOMAIN_RID, DOMAIN_ALIAS_RID_ADMINS,
        0, 0, 0, 0, 0, 0, psidAdministrators);
{$R-}
 {     for x := 0 to ptgGroups.GroupCount - 1 do
        if EqualSid(psidAdministrators, ptgGroups.Groups[x].Sid) then
        begin
          Result := True;
          Break;
        end;
{$R+}
{      FreeSid(psidAdministrators);
    end;
    FreeMem(ptgGroups);
  end;
end;  }



function CobGetShortDirectoryNameW(const Dir: WideString): WideString;
var
  i, Len: integer;
begin
  {Return the relative name of a directory.
  For example C:\Programs\Test\ returns only Test}
  Result := Dir;
  Len :=  Length(Result);
  if Len > 0 then
  begin
    if (Result[Len] = '\') then
      if (Len > 1) and (Result[Len - 1] = ':') then
      begin
        // 2006-05-31 This was returning c:\
        if (Len = 3) then
          Delete(Result, 2, 2);
        Exit;
      end else
      Delete(Result, Len, 1);

    i := length(Result);
    while (i > 0) do
    begin
      if (Result[i] = '\') then
        Break;
      dec(i);
    end;
    Delete(Result, 1, i);
  end;
end;

function CobGetShortDirectoryNameFW(const Dir: WideString): WideString;
var
  i: integer;
begin
  {Return the relative name of a directory that using UNIX format.
  For example /Programs/Test/ returns only Test}
  Result := Dir;
  if Length(Result) > 0 then
  begin
    if (Result[Length(Result)] = '/') then
      if (Length(Result) = 1) then
      begin
        // Be carefull here because / is not a valid directory name
        // to be used dírectly, so
        // check always after using this function
        Exit;
      end else
      Delete(Result, Length(Result), 1);

    i := length(Result);
    while (i > 0) do
    begin
      if (Result[i] = '/') then
        Break;
      dec(i);
    end;
    Delete(Result, 1, i);
  end;
end;

function CobGetComputerNameW(): WideString;
var 
  Buffer: array[0..MAX_COMPUTERNAME_LENGTH] of WideChar;
  Length: cardinal;
begin
  Result:= WS_NIL;
  Length := SizeOf(Buffer); 
  if Windows.GetComputerNameW(Buffer, Length) then
    Result := WideString(Buffer);
end;


function CobStringReplaceW(const Input, OldStr, NewString: WideString;
        const All, CaseSensitive: boolean): WideString;
var
  SearchStr, Patt, NewStr: WideString;
  Offset: Integer;
begin
  if not CaseSensitive then
  begin
    SearchStr := WideUpperCase(Input);
    Patt := WideUpperCase(OldStr);
  end else
  begin
    SearchStr := Input;
    Patt := OldStr;
  end;
  NewStr := Input;
  Result := WS_NIL;
  while SearchStr <> WS_NIL do
  begin
    Offset := Pos(Patt, SearchStr);
    if Offset = 0 then
    begin
      Result := Result + NewStr;
      Break;
    end;
    Result := Result + Copy(NewStr, 1, Offset - 1) + NewString;
    NewStr := Copy(NewStr, Offset + Length(OldStr), MaxInt);
    if not All then
    begin
      Result := Result + NewStr;
      Break;
    end;
    SearchStr := Copy(SearchStr, Offset + Length(Patt), MaxInt);
  end;
end;

function CobPosW(const Substring,Input: WideString; const CaseSensitive: boolean): integer;
var
  AInput, ASubstring: WideString;
begin
  AInput:= Input;
  ASubstring:= Substring;
  if (not CaseSensitive) then
  begin
    AInput:= WideUpperCase(AInput);
    ASubstring:= WideUpperCase(ASubstring);
  end;
  Result:= Pos(ASubstring, AInput);
end;

function CobGetUniversalNameW(const FileName: WideString): WideString;
var
  Size: LongWord;
  RemoteNameInfo: array[0..1023] of WideChar;
begin
  Result:= FileName;
  Size := SizeOf(RemoteNameInfo);
  if WNetGetUniversalNameW(PWideChar(FileName), UNIVERSAL_NAME_INFO_LEVEL,
      @RemoteNameInfo, Size) <> NO_ERROR then Exit;
  Result := PRemoteNameInfoW(@RemoteNameInfo).lpUniversalName;
end;

//Masks

function ZMatch( Pattern, Str: PWideChar; UnixStyle: Boolean):Integer;
var
  c: WideChar;
  Reverse: Boolean;
  q: PWideChar;
  e: Boolean;
  cc: WideChar;
begin
{****************************************************************
Patternmatch (very fast) (Dos/Unix Style)
Wildcards: * ?
if Unixstyle then the Range is enabled
  Range    : [a-z] or [^a-z] or [!a-z] or [azert] or [a-ey-z] .......
In:
  Pattern  : Pattern see below
  Str      : String to compare
  Unixstyle: Range enabled/disabled
Result:
  0 = No Match
  1 = Match
  2 = Expr Error
*****************************************************************

Adapted from a code originally created by Matthias Zartmann
Adapted to use Unicode by Luis Cobian
}

  c := pattern^;
  inc(pattern);
  // If that was the end of the pattern, match if string empty too
  if (c = #0) then
  begin
    Result :=  Integer(str[0] = #0);
    Exit;
  end;

  // '?'  matches any character (but not an empty string) */

  if (c = '?') then
  begin
    if str^ <> #0 then
      result := ZMatch(pattern, str + 1, UnixStyle)
    else
      result := 0;
    exit;
  end;

  // '*' matches any number of characters, including zero
  if (c = '*') then
  begin
    if (pattern^ = #0) then  //Last char. in the Pattern then match
    begin
      result := 1;
      exit;
    end;

    while str^ <> #0 do
    begin
      result := ZMatch(pattern, str,UnixStyle);
      if (result <> 0) then
        exit;
      inc(str);
    end;
    result := 0;       // 2 means give up--match will return false
    exit;
  end;

  if (UnixStyle) and (c = '[') then
  begin
    if str^ = #0 then
    begin
       Result := 0;
       exit;
    end;
    if (pattern^ ='!') or (pattern^ = '^') then
    begin
      Reverse := TRUE;
      inc(pattern);
    end
    else
      Reverse := FALSE;

    q := pattern;
    e := FALSE;
    while e = FALSE do
    begin
      if e  then
        e := False
      else
      begin
        if q^ = '\' then
          e := TRUE
        else
        begin
          if q^ = ']' then
            break;
        end;
      end;
      inc(q);
    end;

    if (q^ <> ']') then            // nothing matches if bad syntax
    begin
      result := 2;
      exit;
    end;

    c := #0;
    e := ('-' = (Pattern^));

    while (pattern < q) do
    begin
      if (e = FALSE) and (pattern^ = '\') then             // set escape flag if \
         e := TRUE
      else
      begin
        if (e = FALSE) and (pattern^ = '-') then         // set start of range if -
          c := (pattern-1)^
        else
        begin
          cc := str^;
          if ((pattern+1)^ <> '-') then
          begin
             if c = #0 then
               c := pattern^;
             while c <= Pattern^ do
             begin
               if c = cc then
               begin
                 if Reverse then
                   result := 0
                 else
                   result := ZMatch(q + 1, str + 1,UnixStyle);
                 exit;
               end;
               inc(c);
             end;
             c := #0;  // clear range, escape flags
             e := FALSE;
          end;
        end;
      end;
      inc(pattern);
    end;
    if Reverse then
     result := ZMatch(q + 1, str + 1,UnixStyle)
    else
     result := 0;
    exit;
  end;

  if (c = '\') then
  begin
    if ((pattern^ = '*') or
        (pattern^ = '?') or
        (UnixStyle and ((pattern^ = '[')or (pattern^ = '\'))) ) then
    begin
      c := pattern^;
      inc(pattern);
    end;
  end;

  result :=  Integer(c = str^);
  if result = 1 then
  begin
    result := ZMatch(pattern, str + 1,UnixStyle);
  end;
end;


function SMatch(const pattern, str: WideString; UnixStyle: Boolean):Integer;
begin
  Result := ZMatch( PWideChar(Pattern), PWideChar(Str), UnixStyle);
end;

function PrepareForMasks(const Input: WideString): WideString;
begin
  Result:= Input;

  if (CobPosW(WideString(WC_BACKSLASH), Result, false) > 0) then
    Result:= CobStringReplaceW(Result, WideString(WC_BACKSLASH), WideString(WC_BACKSLASHSUBST), true, true);

  if (CobPosW(WideString(WC_COLON), Result, false) > 0) then
    Result:= CobStringReplaceW(Result, WideString(WC_COLON), WideString(WC_COLONSUBST), true, true);

  if (CobPosW(WideString(WC_SLASH), Result, false) > 0) then
    Result:= CobStringReplaceW(Result, WideString(WC_SLASH), WideString(WC_SLASHSUBST), true, true);
end;

function CobMaskMatchW(const Source, Mask: WideString;
                        const CaseSensitive: boolean = false;
                        const Propagate: boolean = false): boolean;
var
  MaskPath, MaskFile, FilePath, FileFile: WideString;
begin  {WildComp}

/// There are 5 different cases

///  PATH             MASK                   COMMENT
///
///  Case 1
///
///  C:\Test\Temp\    somefile.txt          This is a pure file. Check for equality
///
///  Case 2
///
///  C:\Test\Temp\    *.*                   This is a pure directory mask. Check if it propagates to subdirs
///
///  Case 3
///
///  C:\Test\Temp\    *.txt                 A subcase of the case 2
///
///  Case 4
///
///                   *.txt                 A pure mask. Applies to everything
///
///  Case 5
///
///   *\Test\*        *.txt                 This is hell

  MaskPath:= WideExtractFilePath(Mask);
  MaskFile:= WideExtractFileName(Mask);
  if (MaskFile = WS_ALLFILES) then
    MaskFile:= WideString(WC_ASTERISC);
  FilePath:= WideExtractFilePath(Source);
  FileFile:= WideExtractFileName(Source);

  if (not CaseSensitive) then
  begin
    MaskPath:= WideUpperCase(MaskPath);
    MaskFile:= WideUpperCase(MaskFile);
    FilePath:= WideUpperCase(FilePath);
    FileFile:= WideUpperCase(FileFile);
  end;

  Result:= (SMatch(MaskFile, FileFile, false) = 1);

  if (Result) then
  begin
    // Case 1, pure file
    if (MaskPath <> WS_NIL) and (Pos(WC_ASTERISC, MaskPath) = 0) and (Pos(WC_ASTERISC, MaskFile) = 0) then
    begin
      Result:= (MaskPath = FilePath);
      Exit;
    end;

    // case 2, pure directory
    if (MaskPath <> WS_NIL) and (Pos(WC_ASTERISC, MaskPath) = 0) and (MaskFile = WideString(WC_ASTERISC)) then
    begin
      //if (Propagate) then
        Result:= Pos(MaskPath, FilePath) = 1; // else        The guy is excluding a directory for god's sake
       //  Result:= (MaskPath = FilePath);
      Exit;
    end;

    // case 3, pseudo directory
    if (MaskPath <> WS_NIL) and (Pos(WC_ASTERISC, MaskPath) = 0) and
        ((Pos(WC_ASTERISC, MaskFile) > 0) or (Pos(WC_QUESTION, MaskFile) > 0)) then
    begin
      if (Propagate) then
        Result:= Pos(MaskPath, FilePath) = 1 else
        Result:= (MaskPath = FilePath);
      Exit;
    end;

    // Case 4, a pure mask
    if (MaskPath = WS_NIL) then
    begin
      // REsult is already true
      Exit;
    end;

    /// if we are here, then hell broke loss
    ///  so make call SMatch. But because SMatch fails if
    ///  There is \ in the string, just substitute those characters first

    Result:= (SMatch(PrepareForMasks(MaskPath), PrepareForMasks(FilePath), false) = 1);
  end;

  {if (MaskPath <> WS_NIL) then
  begin
    if (Pos(WC_ASTERISC, MaskPath) = 1) then
    begin
      Delete(MaskPath, 1, 1);
      Result:= Result and (Pos(MaskPath,FilePath) = Length(FilePath) - Length(MaskPath) + 1);
    end else
    begin
      if ((MaskFile = WC_ASTERISC) or (MaskFile = WS_ALLFILES)) or
         (((Pos(WC_QUESTION, MaskFile) > 0) or (Pos(WC_ASTERISC, MaskFile) > 0)) and Propagate) then
        Result:= Result and (Pos(MaskPath, FilePath) = 1) else
        Result:= Result and (MaskPath = FilePath);
    end;
  end;  }
end;


function CobExpandFileNameW(const FileName: WideString): WideString;
var
  FName: PWideChar;
  Buffer: array[0..MAX_PATH - 1] of WideChar;
begin
  GetFullPathNameW(PWideChar(FileName),Sizeof(Buffer) div SizeOf(WideChar),Buffer, FName);
  Result:= WideString(Buffer);
end;

function CobExpandUNCFileNameW(const FileName: WideString): WideString;
begin
  { First get the local resource version of the file name }
  Result := CobExpandFileNameW(FileName);
  if (Length(Result) >= 3) then
    if (Result[2] = ':') and (WideUpperCase(Result[1]) >= 'A')
      and (WideUpperCase(Result[1]) <= 'Z') then
        Result:= CobGetUniversalNameW(Result);
end;

function CobNormalizeFileNameW(const FileName: WideString): WideString;
begin
  Result:= FileName;
  if (FileName = WS_NIL) then
    Exit;

  if (Pos(WS_UNICODEHEADER, FileName) <> 1) then
  begin
    if (Pos(WS_UNCHEADER, FileName) = 1) then
    begin
      // This is a SPECIAL case because the address if an UNC path
      Result:= WS_UNICODEHEADER + WS_UNC + Copy(FileName, 2, Length(FileName) - 1);
    end else
      Result:= WS_UNICODEHEADER + FileName;
  end;
end;

function CobFormatSizeW(const Size: Int64): WideString;
begin
  Result := WS_NIL;
  if Size < 1024 then
    Result := CobIntToStrW(Size) + ' bytes'
  else if (Size >= 1024) and (Size < 1048576) then
    Result := WideFormat('%.2f', [Size / 1024]) + ' KB'
  else if (Size >= 1048576) and (Size < 1073741824) then
    Result := WideFormat('%.2f', [Size / 1048576]) + ' MB'
  else if (Size >= 1073741824) and (Size < 1099511627776) then
    Result := WideFormat('%.2f', [Size / 1073741824]) + ' GB'
  else
    Result := WideFormat('%.2f', [Size / 1099511627776]) + ' TB';
end;

function CobGetFileSize(const Source: WideString): Int64;
var
  SR: TSearchRecW;
  ASource: WideString;
  converter: packed record
  case Boolean of
    false: (n: int64);
    true: (low, high: DWORD);
  end;
begin
  Result:= 0;
  ASource:= CobNormalizeFileNameW(Source);
  if (WideFindFirst(ASource,faAnyFile,SR) = 0) then
  begin
    converter.low := SR.FindData.nFileSizeLow;
    converter.high := SR.FindData.nFileSizeHigh;
    Result := converter.n;
    WideFindClose(SR);
  end;
end;

function CobCountFilesW(const Source, Exclussions, Inclussions: WideString;
                        const SubDirs: boolean; var Size: Int64): Int64;
var
  Excl, Incl: TTntStringList;
//******************************************************************************
  function DoCount(const Source: WideString): boolean;
  var
    i: integer;
  begin
    Result:= true;
    if (Incl.Count > 0) then
    begin
      Result:= false;
      for i:= 0 to Incl.Count - 1 do
      begin
        if (CobMaskMatchW(Source,Incl[i])) then
        begin
          Result:= true;
          Break;
        end;
      end;

      if (not Result) then
        Exit;
    end;

    if (Excl.Count > 0) then
    begin
      for i:=0 to Excl.Count - 1 do
      begin
        if (CobMaskMatchW(Source, Excl[i])) then
        begin
          Result:= false;
          Break;
        end;
      end;
    end;
  end;
//******************************************************************************
  procedure GetDirectorySize(const Source: WideString);
  var
    SR: TSearchRecW;
    ASource: WideString;
    //**************************************************************************
    procedure ProcessFile();
    var
      converter: packed record
      case Boolean of
        false: (n: int64);
        true: (low, high: DWORD);
      end;
    begin
      if (SR.Attr and faDirectory = faDirectory) then
      begin
        if (SR.Name <> '.') and (SR.Name <> '..') and SubDirs then
          GetDirectorySize(CobSetBackSlashW(Source) + SR.Name);
      end else
      begin
        if (DoCount(CobSetBackSlashW(Source) + SR.Name)) then
        begin
          inc(Result);
          // Do not use CobGetFileSize because I use anothe FindFirst there
          converter.low := SR.FindData.nFileSizeLow;
          converter.high := SR.FindData.nFileSizeHigh;
          Size := Size + converter.n;
        end;
      end;
    end;
    //**************************************************************************
  begin
    ASource:= CobNormalizeFileNameW(CobSetBackSlashW(Source) + WS_ALLFILES);
    if (WideFindFirst(ASource, faAnyFile, SR) = 0) then
    begin
      ProcessFile();
      while WideFindNext(SR) = 0 do
        ProcessFile();
      WideFindClose(SR);
    end;
  end;
begin
  Result:= 0;
  Size:= 0;

  Excl:= TTntStringList.Create();
  Incl:= TTntStringList.Create();
  try
    Excl.CommaText:= Exclussions;
    Incl.CommaText:= Inclussions;
    if (WideFileExists(Source)) then
    begin
      if (DoCount(Source)) then
      begin
        Result:= 1;
        Size:= CobGetFileSize(Source);
      end;
    end else
    if (WideDirectoryExists(Source)) then
      GetDirectorySize(Source);   // <-------- Both Result and size are set here
  finally
    FreeAndNil(Incl);
    FreeAndNil(Excl);
  end;

end;

function CobGetPasswordQuality(const Password: WideString): integer;
var
  i: integer;
  Numbers, LettersUp, LettersLow, Other: boolean;
begin
  //Calculates the quality of the passphrase
  //The procedure adds points for every special
  //character, black space, upper/lower case, etc

  Result := Length(Password);// * 2; //2 points by every letter

  if Pos(WS_SPACECHAR, Password) > 0 then //is a passphrase and not a password
    Inc(Result, 10);

  Numbers := false;
  Other := false;
  LettersUp := false;
  LettersLow := false;

  for i := 1 to Length(Password) do
  begin
    if (not IsWideCharAlphaNumeric(Password[i])) then //5 points for every special char
    begin
      Inc(Result, 5);
      Other := true;
    end;

    if (IsWideCharDigit(Password[i])) then
      Numbers := true;

    if (IsWideCharUpper(Password[i])) then
      LettersUp := true;

    if (IsWideCharLower(Password[i])) then
      LettersLow := true;
  end;

  if (LettersUp or LettersLow) and Numbers then
    inc(Result, 10); //if there are letters and numbers, 10 pts

  if LettersUp and LettersLow then
    inc(Result, 10); // if mixed case, 10 pts

  if (LettersUp or LettersLow) and Numbers and Other then
    inc(Result, 15); //if  mixed letters, numbers AND special chars +15

  if Result > 100 then //normalize the password to 100
    Result := 100;
end;



function CobDoubleToBinW(Value: double): WideString;
var
  i64: int64 absolute Value;
  i: integer;
  Str: AnsiString;
begin
  SetLength(Str, INT_DOUBLELENGHT);

  for i := 1 to INT_DOUBLELENGHT do
  begin
    Str[INT_DOUBLELENGHT + 1 - i] := Char((i64 and 1) + ord(WS_ZERO));
    i64 := i64 shr 1;
  end;

  Result:= WideString(Str);                                                  
end;


function CobBinToDoubleW(Value: WideString; var OK: boolean): double;
var
  i: integer;
  i64: int64 absolute Result;
  Str: AnsiString;
begin
  OK := false;
  Result := 0.0;
  Str:= AnsiString(Value);

  if Length(Str) <> INT_DOUBLELENGHT then
    Exit;

  i64 := 0;

  for i := 1 to INT_DOUBLELENGHT do
    i64 := (i64 shl 1) or Integer(Str[i] <> WS_ZERO);

  OK := true;
end;


function CobGetCurrentUserNameW(): WideString;
var
  UserName   : array[0..USERLENGTH] of WideChar;
  Len: cardinal;
begin
  Len:= USERLENGTH;
  FillChar(UserName, SizeOf(UserName), #0);
  GetUserNameW(@UserName, Len);
  Result:= WideString(UserName);
end;

function CobGetWindowsDirW(): WideString;
var
  Dir: array [0..COB_MAX_PATH] of WideChar;
begin
   FillChar(Dir, SizeOf(Dir), #0);
   GetWindowsDirectoryW(@Dir, COB_MAX_PATH);
   Result:= CobSetBackSlashW(WideString(Dir));
end;

function CobGetSystemDirW(): WideString;
var
  Dir: array [0..COB_MAX_PATH] of WideChar;
begin
   FillChar(Dir, SizeOf(Dir), #0);
   GetSystemDirectoryW(@Dir, COB_MAX_PATH);
   Result:= CobSetBackSlashW(WideString(Dir));
end;

function CobGetTemporaryDirW(): WideString;
var
  Dir: array [0..COB_MAX_PATH] of WideChar;
begin
   FillChar(Dir, SizeOf(Dir), #0);
   GetTempPathW(COB_MAX_PATH, @Dir);
   Result:= CobSetBackSlashW(WideString(Dir));
end;

function CobGetShellFolderW(const nFolder: integer): WideString;
var
  PList: PItemIDList;
  GDir: WideString;
begin
  SetLength(GDir, COB_MAX_PATH);

 if SHGetSpecialFolderLocation(0, nFolder, PList) = NOERROR then
    begin
      SHGetPathFromIDListW(Plist, PWideChar(GDir));
      SetLength(GDir, Pos(WideString(#0), Gdir) - 1);
      Result := GDir;
    end
    else
      Result := '';

  Result:= CobSetBackSlashW(Result);
end;

function CobGetSpecialDirW(const Kind: TCobDirectoryW): WideString;
begin
  case Kind of
    cobWindows: Result:= CobGetWindowsDirW();
    cobSystem: Result:= CobGetSystemDirW();
    cobPersonal: Result:= CobGetShellFolderW(CSIDL_PERSONAL);
    cobTemporary: Result:= CobGetTemporaryDirW();
    cobDeskTop: Result:= CobGetShellFolderW(CSIDL_DESKTOPDIRECTORY);
    cobStartMenu: Result:= CobGetShellFolderW(CSIDL_STARTMENU);
    cobStartUp: Result:= CobGetShellFolderW(CSIDL_STARTUP);
    cobFavorites: Result:= CobGetShellFolderW(CSIDL_FAVORITES);
    cobProgramLinks: Result:= CobGetShellFolderW(CSIDL_PROGRAMS);
    cobAppData: Result:= CobGetShellFolderW(CSIDL_APPDATA);
    cobLocalAppdata: Result:= CobGetShellFolderW(CSIDL_LOCAL_APPDATA);
    cobCommonDesktop: Result:= CobGetShellFolderW(CSIDL_COMMON_DESKTOPDIRECTORY);
    cobCommonStartUp: Result:= CobGetShellFolderW(CSIDL_COMMON_STARTUP);
    cobCommonProgramLinks: Result:= CobGetShellFolderW(CSIDL_COMMON_PROGRAMS);
    cobCommonStartMenu: Result:= CobGetShellFolderW(CSIDL_COMMON_STARTMENU);
  end;
end;

function CobCanEncryptW(): boolean;
var
  PathW, PathS: WideString;
begin
  PathW:= CobGetWindowsDirW();
  PathS:= CobGetSystemDirW();
  Result:= true;

  if ((WideFileExists(PathW + WS_CRYPTLIB1)= false)
      and (WideFileExists(PathS + WS_CRYPTLIB1) = false)) then
    begin
      Result:= false;
      Exit;
    end;

  if ((WideFileExists(PathW + WS_CRYPTLIB2)= false)
      and (WideFileExists(PathS + WS_CRYPTLIB2)= false)) then
    begin
      Result:= false;
      Exit;
    end;

  if ((WideFileExists(PathW + WS_CRYPTLIB3)= false)
      and (WideFileExists(PathS + WS_CRYPTLIB3)= false)) then
    begin
      Result:= false;
      Exit;
    end;
end;

function CobGetNullDaclAttributesW(var pSecurityDesc: PSECURITY_DESCRIPTOR): TSECURITYATTRIBUTES;
var
  securityAttribs: TSECURITYATTRIBUTES;
begin
  {Get a null DACL attribute to use shared MMF.
  Onlu used on NT based systems}

  FillChar(securityAttribs, sizeof(TSECURITYATTRIBUTES), 0);
  pSecurityDesc := nil;
  pSecurityDesc := AllocMem(SECURITY_DESCRIPTOR_MIN_LENGTH);
  if (pSecurityDesc = nil) then
    exit;
  {if (not (InitializeSecurityDescriptor(pSecurityDesc,
    SECURITY_DESCRIPTOR_REVISION))) then
    exit;
  if (not (SetSecurityDescriptorDACL(pSecurityDesc,
    True, nil, False))) then
    if (pSecurityDesc = nil) then
      exit;  }
  if (not (InitializeSecurityDescriptor(pSecurityDesc,
    SECURITY_DESCRIPTOR_REVISION))) then
    exit;
  if (not (SetSecurityDescriptorDACL(pSecurityDesc,
    True, nil, False))) then
  begin
    FreeMem(pSecurityDesc, SECURITY_DESCRIPTOR_REVISION);
    pSecurityDesc := nil;
    exit;
  end;
  securityAttribs.nLength := SizeOf(TSECURITYATTRIBUTES);
  securityAttribs.lpSecurityDescriptor := pSecurityDesc;
  securityAttribs.bInheritHandle := True;
  Result := securityAttribs;
end;

procedure CobFreeNullDaclAttributesW(var pSecurityDesc: PSECURITY_DESCRIPTOR);
begin
  if pSecurityDesc <> nil then
    FreeMem(pSecurityDesc, SECURITY_DESCRIPTOR_REVISION);
end;

procedure CobDisableProcessWindowsGhostingW();
type
  TDisableProcessWindowsGhostingProc = procedure; stdcall;
const
  sUser32: PWideChar = 'User32.dll';
var
  ModH: HMODULE; 
  _DisableProcessWindowsGhosting: TDisableProcessWindowsGhostingProc;
begin
  ModH := GetModuleHandleW(sUser32);
  if ModH <> 0 then 
  begin 
    @_DisableProcessWindowsGhosting := nil;
    @_DisableProcessWindowsGhosting := GetProcAddress(ModH,
    'DisableProcessWindowsGhosting');
    if Assigned(_DisableProcessWindowsGhosting) then
      _DisableProcessWindowsGhosting(); 
  end; 
end;


function CobStrEndW(Str: PWideChar): PWideChar;
begin
  // returns a pointer to the end of a null terminated string
  Result := Str;
  While Result^ <> #0 do
    Inc(Result);
end;

function CobStrLenW(Str: PWideChar): Cardinal;
begin
  Result := CobStrEndW(Str) - Str;
end;

function CobBoolToStrW(const Value: boolean): WideString;
begin
  Result:= WS_FALSE;
  if Value then
    Result:= WS_TRUE;
end;

function CobStrToBoolW(const Value:WideString): boolean;
begin
  Result:= (WideUpperCase(Value) = WS_TRUE);
end;

function CobIntToStrW(const Value: integer): WideString;
begin
  Result:= WideString(IntToStr(Value));
end;

function CobIntToStrW(const Value: Int64): WideString;
begin
  Result:= WideString(IntToStr(Value));
end;

function CobStrToIntW(const Value: WideString; const Default: integer): integer;
begin
  try
    Result:= StrToInt(string(Value));
  except
    Result:= Default;
  end;
end;

function CobIsIntW(const Value: WideString): boolean;
begin
  try
    Result:= true;
    StrToInt(AnsiString(Value));
  except
    Result:= false;
  end;
end;

function CobIsInt64W(const Value: WideString): boolean;
begin
  try
    Result:= true;
    StrToInt64(AnsiString(Value));
  except
    Result:= false;
  end;
end;

function CobStrToInt64W(const Value: WideString; const Default: integer): Int64;
begin
  try
    Result:= StrToInt64(string(Value));
  except
    Result:= Default;
  end;
end;

function CobGetAppPathW(): WideString;
var
  FileName : array[0..COB_MAX_PATH] of WideChar;
begin
  FillChar(FileName, SizeOf(FileName), #0);
  GetModuleFileNameW(hInstance, FileName ,Length(Filename));
  Result := CobSetBackSlashW(WideExtractFilePath(FileName));
end;

function CobSetBackSlashW(const FileName:WideString): WideString;
begin
  Result:= FileName;
  if Length(Result)> 0 then
    Result := WideIncludeTrailingPathDelimiter(Result);
end;

function CobSetDotExtensionW(const Ext: WideString): WideString;
begin
  Result:= Ext;
  if (Length(Ext) > 0) then
    if (Ext[1] <> WC_DOT) then
      Result:= WC_DOT + Ext;
end;

function CobSetLeadingBackSlashW(const FileName:WideString): WideString;
begin
  Result:= FileName;
  if Length(Result)> 0 then
    begin
      if (FileName[1] <> '\') then
        Result:= '\' + Filename;
    end;
end;

function CobSetLeadingForwardSlashW(const FileName:WideString): WideString;
begin
  Result:= FileName;
  if Length(Result)> 0 then
    begin
      if (FileName[1] <> '/') then
        Result:= '/' + Filename;
    end;
end;

function CobSetForwardSlashW(const FileName:WideString): WideString;
begin
  Result:= FileName;
  if Length(Result)> 0 then
    begin
      if (FileName[Length(FileName)] <> '/') then
        Result:= FileName + '/'; 
    end;
end;

function CobCreateEmptyTextFileW(const FileName: WideString): boolean;
var
  Sl: TTntStringList;
begin
  Result:= true;
  Sl:= TTntStringList.Create();
  try
    try
      Sl.SaveToFile(FileName);
    except
      Result:= false;
    end;
  finally
    FreeAndNil(Sl);
  end;
end;

procedure CobSecondsToHMSW(const Seconds: integer; var hh,mm,ss: integer);
begin
  hh:= Seconds div INT_SECONDSINHOUR;
  mm:= (Seconds - (hh * INT_SECONDSINHOUR)) div INT_SECONDSINMINUTE;
  ss:= Seconds -(hh * INT_SECONDSINHOUR) - (mm * INT_SECONDSINMINUTE);
end;

function CobGetVersionW(const FileName: WideString): WideString;
var
  InfoSize: LongWord;
  Wnd: Cardinal;
  VerBuf: Pointer;
  FI: PVSFixedFileInfo;
  VerSize: DWORD;
  chrAppName: PWideChar;
  strFullVersion: WideString;
  intMajor, intMinor: Integer;
  intRelease, intBuild: Integer;
begin
  {Gets the version of the executable from the version resource}
  if (FileName = WS_NIL) then
    chrAppName := PWideChar(WideParamStr(0)) else
    chrAppName:= PWideChar(FileName);
  InfoSize := GetFileVersionInfoSizeW(chrAppName, Wnd);
  strFullVersion := WS_NIL;
  if InfoSize <> 0 then
  begin
    GetMem(VerBuf, InfoSize);
    try
      if GetFileVersionInfoW(chrAppName, Wnd, InfoSize, VerBuf) then
        if VerQueryValueW(VerBuf, '\', Pointer(FI), VerSize) then
        begin
          intMajor := HiWord(FI.dwFileVersionMS);
          intMinor := LoWord(FI.dwFileVersionMS);
          intRelease := HiWord(FI.dwFileVersionLS);
          intBuild := LoWord(FI.dwFileVersionLS);
          strFullVersion := WideString(IntToStr(intMajor) + '.' +
            IntToStr(intMinor) + '.' +
            IntToStr(intRelease) + '.' +
            IntToStr(intBuild));
        end;
    finally
      FreeMem(VerBuf);
    end;
  end;
  Result := strFullVersion;
end;

function CobIsNTBasedW(StopIt: boolean): boolean;
begin
  Result:= (Win32Platform = VER_PLATFORM_WIN32_NT);
  if StopIt and not Result then
    MessageBoxW(0, PWideChar(WS_NOTNT), PWideChar(WS_ERROR),MB_OK
              or MB_APPLMODAL or MB_ICONINFORMATION);
end;

function CobIs2000orBetterW(): boolean;
begin
  Result:= false;
  if CobIsNTBasedW(false) then
    if (Win32MajorVersion > 4) then
      Result:= true;
end;

function CobIsXPorBetterW(): boolean;
begin
  Result:= false;
  if CobIsNTBasedW(false) then
    if (Win32MajorVersion > 4) then
      if (Win32MinorVersion > 0) then
        Result:= true;
end;

function CobIsVistaOrBetterW(): boolean;
begin
  Result:= false;
  if CobIsNTBasedW(false) then
    if (Win32MajorVersion > 5) then
      Result:= true;
end;

{ TCobWideIO }

constructor TCobWideIO.Create(const FileName: WideString;
  const AppendIfExists, OpenExclusive: boolean);
var
  ModeE, ModeO: word;
begin
  inherited Create();
  FOpen:= false;
  if (OpenExclusive) then
    ModeE:= fmShareExclusive else
    ModeE:= fmShareCompat;

  ModeO:= fmCreate;

  if (WideFileExists(FileName) and AppendIfExists) then
    ModeO:= fmOpenReadWrite;   

  try
    FFile:= TTntFileStream.Create(FileName, ModeO or ModeE);
    FFile.Position:= FFile.Size;
    if (FFile.Position = 0) then
      WriteBOM();
    FOpen:= true;
  except
    FOpen:= false;
  end;
end;

destructor TCobWideIO.Destroy();
begin
  if (FOpen) then
    FreeAndNil(FFile);
  inherited Destroy();
end;

function TCobWideIO.GetPosition(): Int64;
begin
  Result:= FFile.Position - BOM_SIZE;  //the BOM are 2 bytes
end;

function TCobWideIO.GetSize(): Int64;
begin
  Result:= FFile.Size - BOM_SIZE;
end;

function TCobWideIO.IsOpen(): boolean;
begin
  Result:= FOpen;
end;

procedure TCobWideIO.SetPosition(const Value: Int64);
begin
  if (Value <> (FFile.Position - BOM_SIZE)) then
    FFile.Position:= Value + BOM_SIZE;
end;

procedure TCobWideIO.Write(const Line: WideString);
begin
  FFile.Write(PWideChar(Line)^, Length(Line)* SizeOf(WideChar));
end;

procedure TCobWideIO.WriteBOM();
var
  BOM: array [0..1] of byte;
begin
  //Writes the unicode Byte Order Mark to use Little Endian
  BOM[0]:= $FF;
  BOM[1]:= $FE;
  FFile.Write(BOM, BOM_SIZE);
end;

procedure TCobWideIO.WriteLn(const Line: WideString);
begin
  Write(Line + WideString(#$0D#$0A));
end;

function CobGetUniqueNameW(): WideString;
var
  GUID: TGUID;
begin
  CreateGUID(GUID);
  Result:= WideString(GUIDToString(GUID));
end;

function CobSetQuotesW(const Str: WideString): WideString;
begin
  Result:= WS_QUOTE + Str + WS_QUOTE;
end;

function CobAutostartW(const Global: boolean; const ValueName, AppExe, Param: WideString): boolean;
var
  Reg: TCobRegistryW;
  ComdLine: WideString;
begin
  Result:= false;
  Reg:= TCobRegistryW.Create(KEY_ALL_ACCESS);
  try
    if (Global) then
      Reg.RootKey:= HKEY_LOCAL_MACHINE else
      Reg.RootKey:= HKEY_CURRENT_USER;
      ComdLine:= AppExe;

      if (Pos(WideString(' '),ComdLine) > 0) then
        ComdLine:= CobSetQuotesW(ComdLine);

      if (Param <> '') then
        ComdLine:= ComdLine + ' ' + Param;

      if (Reg.OpenKey(WS_AUTOSTART, true)) then
        begin
          Result:= Reg.WriteStringWide(ValueName,ComdLine);
          Reg.CloseKey();
        end;
  finally
    FreeAndNil(Reg);
  end;
end;

function CobDeleteDirectoryW(const Directory: WideString): boolean;
var
  DirInfo: TSearchRecW;
  ADir: WideString;
  //****************************************************************************
  procedure Proceed();
  begin
    if (DirInfo.Name <> '.') and (DirInfo.Name <> '..') then
    begin
      if (faDirectory and DirInfo.Attr) > 0 then
        CobDeleteDirectoryW(CobSetBackSlashW(Directory)+DirInfo.Name) else
        DeleteFileW(PWideChar(CobSetBackSlashW(ADir)+DirInfo.Name));
    end;
  end;
  //****************************************************************************
begin
  ADir:= CobNormalizeFileNameW(CobSetBackSlashW(Directory));
  if WideFindFirst(ADir + WS_ALLFILES, FaAnyfile, DirInfo) = 0 then
  begin
    Proceed();
    while WideFindNext(DirInfo)=0 do
      Proceed();
    WideFindClose(DirInfo);
  end;
    
  Result:= RemoveDirectoryW(PWideChar(ADir));
end;

function CobDeleteAutostartW(const Global: boolean; const ValueName: WideString): boolean;
var
  Reg: TCobRegistryW;
begin
  Reg:= TCobRegistryW.Create(KEY_ALL_ACCESS);
  try
    Result:= false;
    if (Global) then
      Reg.RootKey:= HKEY_LOCAL_MACHINE else
      Reg.RootKey:= HKEY_CURRENT_USER;

    if (Reg.OpenKey(WS_AUTOSTART, true)) then
      begin
        Result:= Reg.dELETEvALUE(ValueName);
        Reg.CloseKey();
      end;

  finally
    FreeAndNil(Reg);
  end;
end;

function CobIsAutostartingW(const ValueName: WideString): TCobAutostartW;
var
  Reg: TCobRegistryW;
  Sl: TTntStringList;
  i: integer;
  Local, Global: boolean;
begin
  Reg:= TCobRegistryW.Create(KEY_READ);
  Sl:= TTntStringList.Create();
  try

    Reg.RootKey:= HKEY_CURRENT_USER;
    Local:= false;

    if (Reg.OpenKey(WS_AUTOSTART, true)) then
      begin
        Reg.GetValueNames(Sl);
        for i:=0 to Sl.Count -1 do
          if (WideUppercase(Sl[i]) = WideUpperCase(ValueName)) then
            begin
              Local:= true;
              Break;
            end;
        Reg.CloseKey();
      end;

    Reg.RootKey:= HKEY_LOCAL_MACHINE;
    Global:= false;

    if (Reg.OpenKey(WS_AUTOSTART, true)) then
      begin
        Reg.GetValueNames(Sl);
        for i:=0 to Sl.Count -1 do
          if (WideUppercase(Sl[i]) = WideUpperCase(ValueName)) then
            begin
              Global:= true;
              Break;
            end;
        Reg.CloseKey();
      end;

    if (Local and Global) then
      begin
        Result:= cobBothAS;
        Exit;
      end;

    if ((not Local) and (not Global)) then
      begin
        Result:= cobNoAS;
        Exit;
      end;

      if (Local) then
        Result:= cobLocalAS else
        Result:= cobGlobalAS;

  finally
    FreeAndNil(Sl);
    FreeAndNil(Reg);
  end;
end;

procedure CobWideStringToArray(Dest: PWideChar; const Source: WideString);
var
  SourceLength: integer;
  // This copies a wide string into an array of WideChars
  // NO LENGHT CHECK IS DONE so the array must have space to
  // copy the widestring plus the final #0
begin
  // The check of the size should be done ouside. It should be place for the last #0
  SourceLength:= Length(Source);
  if SourceLength > 0 then
    Move(Source[1], Dest[0], SourceLength * SizeOf(WideChar));
  Dest[SourceLength] := #0;
end;

procedure CobWideStringToBytesW(var Buffer: TCobBytes; const Str: WideString);
var
  Size: longint;
begin
  Size:= Length(Str) * SizeOf(WideChar);

  SetLength(Buffer, Size);
  FillChar(Buffer[0], Size, #0);

  if (Size > 0) then
    Move(Str[1], Buffer[0], Size);
end;

function CobBytesToIntegerW(const Buffer: TCobBytes): longint;
begin
  Result:= 0;
  if (Length(Buffer) = SizeOf(Longint)) then
    Move(Buffer[0], Result , SizeOf(LongInt));
end;

function CobBytesToWideStringW(const Buffer: TCobBytes): WideString;
begin
  Result:= WS_NIL;
  if (Length(Buffer) = 0) then
    Exit;

  SetLength(Result,Length(Buffer) div 2);
  Move(Buffer[0],Result[1],Length(Buffer));
end;

procedure CobIntegerToBytesW(var Buffer: TCobBytes; const Value: longint);
begin
  SetLength(Buffer,SizeOf(Longint));
  Move(Value, Buffer[0], SizeOf(LongInt));
end;

end.
