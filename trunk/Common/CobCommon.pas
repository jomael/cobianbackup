{*******************************************************************************
***                                                                          ***
***                       © 2000-2004 by Luis Cobian                         ***
***                           All rights reserved                            ***
***                                                                          ***
***                           cobian@educ.umu.se                             ***
***                                                                          ***
***                                                                          ***
***                  These are the common functions for my programs          ***
***                                                                          ***
***                                                                          ***
***                                                                          ***
***                                                                          ***
*******************************************************************************}

unit CobCommon;

{$WARN SYMBOL_PLATFORM OFF}

{© 2000-2002 by Luis Cobian
cobian@educ.umu.se
Common rutines}

interface

uses SysUtils, Classes, Registry, Windows, ShlObj, Masks, Graphics;

const
  SECURITY_NT_AUTHORITY: TSIDIdentifierAuthority =
  (Value: (0, 0, 0, 0, 0, 5));
  SECURITY_BUILTIN_DOMAIN_RID = $00000020;
  DOMAIN_ALIAS_RID_ADMINS = $00000220;
  COB_EMPTYLITE = ' ';
  COB_SNIL = '';

type
  TCobSpecialFolders = (
    cDeskTop,
    cFonts,
    cPersonal,
    cRecents,
    cSendTo,
    cStartMenu,
    cStartUp,
    cTemplates,
    cFavorites,
    cCookies,
    cInternetCache,
    cInternetHistory,
    cProgramLinks,
    cCommonDesktop,
    cCommonProgramLinks,
    cCommonStartUp,
    cCommonStartMenu,
    cAppData,
    cWindows,
    cSystem,
    cTemp);

  TWindowsVersion = (wvObsolete, wvWin95, wvWin98, wvWinMe, wvWinNT4,
    wvWin2000, wvWinXP, wvOther);

  // File rutines
function CobGetSpecialFolder(Folder: TCobSpecialFolders): string;
function CobGetAppPathOld: string;
function CobGetAppPath: string;
function CobCreateEmptyTextFile(FileName: string): boolean;
function CobSetBackSlash(s: string): string;
function CobRemoveBackSlash(s: string): string;
function CobRemoveFirstSlash(s: string): string;
function CobSetForwardSlash(s: string): string;
function CobGetVersion: string;
function CobIsNt(var Build, Version: string): boolean;
function CobIsAdmin: Boolean;
function CobGetParentDir(s: string): string;
function CobGetShortDirName(s: string): string;
function CobFileCount(Folder: string; Sub: boolean; var Size: Int64; MaskI:
  string = ''; MaskE: string = ''): cardinal;
function CobGetFileSize(s: string): Int64;
function CobGetIEVersion: string;
function CobGetWindowsVersion: TWindowsVersion;
function CobGetFileAttributes(FileName: string): string;
function CobGetFileDates(FileName: string; var CreationDate, ModifiedDate,
  AccessDate: TDateTime): boolean;
function CobSetQuotes(s: string): string;
function CobSetQuotesIfNeeded(s: string): string;
function CobGetComputerName(): string;
function CobFileExists(FileName: string): boolean;
function CobSetDotExtension(const Ext: string): string;

//Other rutines
procedure DisableProcessWindowsGhosting();
function CobStrToInt(Str: string; Default: integer): integer;
function CobStrToInt64(Str: string; Default: int64): int64;
function CobBoolToStr(Bool: boolean): string;
function CobStrToBool(Str: string): boolean;
function CobIsInteger(Str: string): boolean;
function CobIsInteger64(Str: string): boolean;
function CobDoubleToBin(Value: double): string;
function CobBinToDouble(Value: string; var OK: boolean): double;
function CobDeCryptText(TheText, ThePass: string): string;
function CobDeCryptTextEx(TheText, ThePass: string; var OK: boolean): string;
function CobEnCryptText(TheText, ThePass: string): string;
function CobFormatSize(Size: Int64): string;
function CobDeFormatSize(s: string): Int64;
function CobIsIP(s: string): boolean;
function CobCompToI64(c: comp): int64;
function CobExecuteAndWait(App, Param: string; Hide: boolean= false): longbool;


function CobIsNTBased(): boolean;
function CobIs2000orBetter(): boolean;
function CobIsXPorBetter(): boolean;

function CobGenerateID(): string;
function CobGetFragment(const AText, Terminator, NoText: string; const MaxChar: integer): string;


//Registry
procedure CobAutoStart(Name, FileName: string; Delete, Global: boolean; Param:
  string = ''; Service: boolean = false);

//fonts
function FontToStr(Font: TFont): string;
procedure StrToFont(str: string; font: TFont);

// Security
function CobGetNullDaclAttributes(var pSecurityDesc: PSECURITY_DESCRIPTOR): TSECURITYATTRIBUTES;
procedure CobFreeNullDaclAttributes(var pSecurityDesc: PSECURITY_DESCRIPTOR);

implementation

function CobGetNullDaclAttributes(var pSecurityDesc: PSECURITY_DESCRIPTOR): TSECURITYATTRIBUTES;
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
    pSecurityDesc := nil;
    exit;
  end;
  securityAttribs.nLength := SizeOf(TSECURITYATTRIBUTES);
  securityAttribs.lpSecurityDescriptor := pSecurityDesc;
  securityAttribs.bInheritHandle := True;
  Result := securityAttribs;
end;

procedure CobFreeNullDaclAttributes(var pSecurityDesc: PSECURITY_DESCRIPTOR);
begin
  if pSecurityDesc <> nil then
    FreeMem(pSecurityDesc, SECURITY_DESCRIPTOR_REVISION);
end;


function CobGetFragment(const AText, Terminator, NoText: string; const MaxChar: integer): string;
begin
  if (Length(AText) <= MaxChar) then
    Result:= AText else
    Result:= Copy(AText,1,MAxChar) + Terminator;

  if (Result = '') then
    Result:= NoText;

  if (Pos(#$A, Result) > 0) then
    Result:= StringReplace(Result,#$A,COB_EMPTYLITE,[rfReplaceAll,rfIgnoreCase]);

  if (Pos(#$D, Result) > 0) then
    Result:= StringReplace(Result,#$D,COB_EMPTYLITE,[rfReplaceAll,rfIgnoreCase]);
end;

function CobGenerateID(): string;
var
  GUID: TGUID;
begin
  CreateGUID(GUID);
  Result:= GUIDToString(GUID);
end;

function CobIsNTBased(): boolean;
begin
  Result:= (Win32Platform = VER_PLATFORM_WIN32_NT);;
end;

function CobIs2000orBetter(): boolean;
begin
  Result:= false;
  if CobIsNTBased() then
    if (Win32MajorVersion > 4) then
      Result:= true;
end;

function CobIsXPorBetter(): boolean;
begin
  Result:= false;
  if CobIsNTBased() then
    if (Win32MajorVersion > 4) then
      if (Win32MinorVersion > 0) then
        Result:= true;
end;


function CobFileExists(FileName: string): boolean;
var
  Handle: THandle;
  FindData: TWin32FindData;
begin
  //If a file has a corrupt date the FileExists-Function will fail
  // because it internally calls FileAge. So this is a solution
  Handle := FindFirstFile(PChar(Filename), FindData);
  if Handle <> INVALID_HANDLE_VALUE then
  begin
    Windows.FindClose(Handle);
    if (FindData.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) = 0 then
    begin
      Result := True;
      Exit;
    end;
  end;
  Result := False;
end;

procedure DisableProcessWindowsGhosting();
type 
  TDisableProcessWindowsGhostingProc = procedure; stdcall;
const 
  sUser32 = 'User32.dll';
var 
  ModH: HMODULE; 
  _DisableProcessWindowsGhosting: TDisableProcessWindowsGhostingProc;
begin
  ModH := GetModuleHandle(sUser32); 
  if ModH <> 0 then 
  begin 
    @_DisableProcessWindowsGhosting := nil;
    @_DisableProcessWindowsGhosting := GetProcAddress(ModH,
    'DisableProcessWindowsGhosting');
    if Assigned(_DisableProcessWindowsGhosting) then
      _DisableProcessWindowsGhosting(); 
  end; 
end;



function CobRemoveBackSlash(s: string): string;
begin
  Result:= s;

  if s = '' then
    Exit;

  if Result[Length(Result)]='\' then
    Delete(Result, Length(Result), 1);
end;

function CobRemoveFirstSlash(s: string): string;
begin
  Result:= s;

  if s = '' then
    Exit;

  if Result[1]='\' then
    Delete(Result, 1, 1);
end;

function CobExecuteAndWait(App, Param: string; Hide: boolean = false): longbool;
var
  StartInfo: TStartupInfo;
  ProcInfo: TProcessInformation;
  ExecStr: string;
begin
  { fill with known state }

  FillChar(StartInfo, SizeOf(TStartupInfo), #0);
  FillChar(ProcInfo, SizeOf(TProcessInformation), #0);
  StartInfo.cb := SizeOf(TStartupInfo);

  if Hide then
    StartInfo.wShowWindow := SW_HIDE else
    StartInfo.wShowWindow := SW_SHOWNORMAL;
  StartInfo.dwFlags := STARTF_USESHOWWINDOW;

  if Param= COB_SNIL then
    ExecStr:= App else
    ExecStr:= App + COB_EMPTYLITE + Param;

  Result := CreateProcess(nil, PChar(ExecStr),
    nil, nil, False,
    CREATE_NEW_PROCESS_GROUP or NORMAL_PRIORITY_CLASS,
    nil, nil, StartInfo, ProcInfo);
  try
    if Result then
      WaitForSingleObject(ProcInfo.hProcess, INFINITE);
    //else
      //raise Exception.Create(SysErrorMessage(System.GetLastError()));

  finally
    CloseHandle(ProcInfo.hProcess);
    CloseHandle(ProcInfo.hThread);
  end;
end;


function CobGetComputerName(): string;
var 
  Buffer: array[0..MAX_COMPUTERNAME_LENGTH] of char;
  Length: cardinal; 
begin
  Result:= '';
  Length := SizeOf(Buffer); 
  if Windows.GetComputerName(Buffer, Length) then
    Result := string(Buffer);
end; 


function CobCompToI64(c: comp): int64;
type
  TCvt = record
    case integer of
      0: (c: comp);
      1: (i: int64);
  end;
var
  cvt: tCvt;
begin
  cvt.c := c;
  Result := cvt.i;
end;

function CobGetFileDates(FileName: string; var CreationDate, ModifiedDate,
  AccessDate: TDateTime): boolean;
var
  SR: TSearchRec;
  Cd, Md, Ad: TFileTime;
  CdD, MdD, AdD: DWord;

begin
  Result := true;

  if FileName = '' then
  begin
    Result := false;
    Exit;
  end;

  if DirectoryExists(FileName) then
    if FileName[Length(FileName)] = '\' then
      Delete(FileName, Length(FileName), 1);

  if FindFirst(FileName, faAnyFile, SR) = 0 then
  begin
    //Compensate for time zone
    FileTimeToLocalFileTime(SR.FindData.ftCreationTime, Cd);
    FileTimeToLocalFileTime(SR.FindData.ftLastWriteTime, Md);
    FileTimeToLocalFileTime(Sr.FindData.ftLastAccessTime, Ad);
    FileTimeToDosDateTime(Cd, LongRec(CdD).Hi, LongRec(CdD).Lo);
    FileTimeToDosDateTime(Md, LongRec(MdD).Hi, LongRec(MdD).Lo);
    FileTimeToDosDateTime(Ad, LongRec(AdD).Hi, LongRec(AdD).Lo);
    CreationDate := FileDateToDateTime(CdD);
    ModifiedDate := FileDateToDateTime(MdD);
    AccessDate := FileDateToDateTime(AdD);
    SysUtils.FindClose(SR);
  end
  else
    Result := false;
end;

function CobGetAppPath: string;
begin
  Result := '';
  SetLength(Result, Max_Path);
  SetLength(Result, GetModuleFileName(hInstance, PChar(Result),
    Length(Result)));
  Result := CobSetBackSlash(ExtractFilePath(Result));
end;

function CobGetFileAttributes(FileName: string): string;
var
  Att: integer;
  AttS: string;
begin
  Att := FileGetAttr(FileName);
  if (Att and faArchive) <> 0 then
    AttS := 'A'
  else
    AttS := '-';
  if (Att and faReadOnly) <> 0 then
    AttS := AttS + 'R'
  else
    AttS := AttS + '-';
  if (Att and faHidden) <> 0 then
    AttS := AttS + 'H'
  else
    AttS := AttS + '-';
  if (Att and faSysFile) <> 0 then
    AttS := AttS + 'S'
  else
    AttS := AttS + '-';
  Result := AttS;
end;

function FontToStr(Font: TFont): string;
var
  SL: TStringList;
  s: string;
begin
  SL := TStringList.Create;
  try
    SL.Add(Font.Name);
    SL.Add(IntToStr(Font.Size));
    SL.Add(IntToStr(Font.Color));
    SL.Add(IntToStr(Font.Height));
    SL.Add(IntToStr(Ord(Font.Pitch)));
    SL.Add(IntToStr(Font.Charset));
    s := '* ';
    if fsBold in Font.Style then
      s := s + 'BOLD ';
    if fsItalic in Font.Style then
      s := s + 'ITALIC';
    if fsUnderline in Font.Style then
      s := s + 'UNDERLINE';
    if fsStrikeout in Font.Style then
      s := s + 'STRIKEOUT';
    SL.Add(s);

    Result := SL.CommaText;
  except
    SL.Free;
  end;
end;

//*************************************

procedure StrToFont(str: string; font: TFont);
var
  SL: TStringList;
begin
  SL := TStringList.Create;
  try
    SL.CommaText := Str;
    Font.Name := SL[0];
    Font.Size := StrToInt(SL[1]);
    Font.Color := StrToInt(SL[2]);
    Font.Height := StrToInt(SL[3]);
    Font.Pitch := TFontPitch(StrToInt(SL[4]));
    Font.Charset := StrToInt(SL[5]);
    Font.Style := [];
    if Pos('BOLD', SL[6]) > 0 then
      Font.Style := Font.Style + [fsBold];
    if Pos('ITALIC', SL[6]) > 0 then
      Font.Style := Font.Style + [fsItalic];
    if Pos('UNDERLINE', SL[6]) > 0 then
      Font.Style := Font.Style + [fsUnderline];
    if Pos('STRIKEOUT', SL[6]) > 0 then
      Font.Style := Font.Style + [fsStrikeout];
  finally
    SL.Free;
  end;
end;

//**************************************

function CobGetWindowsVersion: TWindowsVersion;
var
  OSVersionInfo: TOSVersionInfo;
begin
  OSVersionInfo.dwOSVersionInfoSize := SizeOf(OSVersionInfo);
  GetVersionEx(OSVersionInfo);
  case OSVersionInfo.dwPlatformId of
    1: {Win32}
      case OSVersionInfo.dwMajorVersion of
        4: case OSVersionInfo.dwMinorVersion of
            0: Result := wvWin95;
            1..89: Result := wvWin98;
            90: Result := wvWinMe;
          else
            Result := wvOther;
          end;
      else
        Result := wvObsolete;
      end;
    2: {NT}
      case OsVersionInfo.dwMajorVersion of
        0..3: Result := wvObsolete;
        4: Result := wvWinNT4;
        5: case OSVersionInfo.dwMinorVersion of
            0: Result := wvWin2000;
            1: Result := wvWinXP;
          else
            Result := wvOther;
          end;
      else
        Result := wvOther;
      end;
  else
    Result := wvOther;
  end;
end;

//*****************************************

function CobGetSpecialFolder(Folder: TCobSpecialFolders): string;
var
  GDir: string;
  PList: PItemIDList;
  nFolder: integer;
  pDir: array[0..MAX_PATH] of char;
  CSIDL: boolean;
begin
  {This function returns the phisical path
  of some common directories. Because two different
  methods are used, a CSIDL flag is used}
  Result := '';
  CSIDL := true;
  nFolder := 0;

  GDir := StringOfChar(' ', MAX_PATH);
  PList := nil;
  FillChar(pDir, MAX_PATH, 0);

  case Folder of
    cWindows:
      begin
        GetWindowsDirectory(pDir, SizeOf(PDir));
        CSIDL := false;
        Result := string(pDir);
      end;
    cSystem:
      begin
        GetSystemDirectory(pDir, SizeOf(PDir));
        CSIDL := false;
        Result := string(pDir);
      end;
    cTemp:
      begin
        GetTempPath(SizeOf(PDir), pDir);
        CSIDL := false;
        Result := string(pDir);
      end;
    cDeskTop: nFolder := CSIDL_DESKTOPDIRECTORY;
    cFonts: nFolder := CSIDL_FONTS;
    cPersonal: nFolder := CSIDL_PERSONAL;
    cRecents: nFolder := CSIDL_RECENT;
    cSendTo: nFolder := CSIDL_SENDTO;
    cStartMenu: nFolder := CSIDL_STARTMENU;
    cStartUp: nFolder := CSIDL_STARTUP;
    cTemplates: nFolder := CSIDL_TEMPLATES;
    cFavorites: nFolder := CSIDL_FAVORITES;
    cInternetCache: nFolder := CSIDL_INTERNET_CACHE;
    cInternetHistory: nFolder := CSIDL_HISTORY;
    cCookies: nFolder := CSIDL_COOKIES;
    cProgramLinks: nFolder := CSIDL_PROGRAMS;
    cCommonDesktop: nFolder := CSIDL_COMMON_DESKTOPDIRECTORY;
    cCommonStartUp: nFolder := CSIDL_COMMON_STARTUP;
    cCommonProgramLinks: nFolder := CSIDL_COMMON_PROGRAMS;
    cCommonStartMenu: nFolder := CSIDL_COMMON_STARTMENU;
    cAppData: nFolder := CSIDL_APPDATA;
  end;

  if CSIDL then
    if SHGetSpecialFolderLocation(0, nFolder, PList) = NOERROR then
    begin
      SHGetPathFromIDList(Plist, PChar(GDir));
      Setlength(GDir, Pos(#0, Gdir) - 1);
      Result := GDir;
    end
    else
      Result := '';

  if Result <> '' then
    if Result[Length(Result)] <> '\' then
      Result := Result + '\';
end;

//*****************************************

function CobBoolToStr(Bool: boolean): string;
begin
  //Converts a boolean value to a string
  Result := 'FALSE';
  if Bool then
    Result := 'TRUE';
end;

//*****************************************

function CobStrToBool(Str: string): boolean;
begin
  //Converts a string to it's boolean value
  Result := false;
  if UpperCase(Str) = 'TRUE' then
    Result := true;
end;

//*****************************************
// Tries to convert a string to integer
// if it fails, the default value is retiruned
function CobStrToInt(Str: string; Default: integer): integer;
begin
  try
    Result:= StrToInt(Str);
  except
    Result:= Default;
  end;
end;

function CobStrToInt64(Str: string; Default: int64): int64;
begin
  try
    Result:= StrToInt64(Str);
  except
    Result:= Default;
  end;
end;
//*****************************************

function CobIsInteger(Str: string): boolean;
begin
  Result:= true;
  try
    StrToInt(Str);
  except
    Result:= false;
  end;
end;

function CobIsInteger64(Str: string): boolean;
begin
  Result:= true;
  try
    StrToInt64(Str);
  except
    Result:= false;
  end;
end;

//*******************************************

function CobDoubleToBin(Value: double): string;
var
  i64: int64 absolute Value;
  i: integer;
begin
  SetLength(Result, 64);

  for i := 1 to 64 do
  begin
    Result[65 - i] := Char((i64 and 1) + ord('0'));
    i64 := i64 shr 1;
  end;
end;

//*****************************************

function CobBinToDouble(Value: string; var OK: boolean): double;
var
  i: integer;
  i64: int64 absolute Result;
begin
  OK := false;
  Result := 0.0;

  if Length(Value) <> 64 then
    Exit;

  i64 := 0;

  for i := 1 to 64 do
    i64 := (i64 shl 1) or Integer(Value[i] <> '0');

  OK := true;
end;

//******************************************
function CobDeCryptTextEx(TheText, ThePass: string; var OK: boolean): string;
var
  i, j: integer;
  s: string;
  pass, PassD: string;
begin
  {Decrypt a string which was encrypted using
  the function CobEncryptText}
  Result := '';
  OK:= false;

  if Length(TheText)=0 then
    Exit;

  if Length(ThePass) = 0 then
    Exit;

  try
    s := TheText;
    j := StrToInt(Copy(s, 1, 1));
    Delete(s, 1, 1);
    Pass := Copy(s, 1, j + Length(ThePass));
    Delete(s, 1, j + Length(ThePass));
    PassD := Pass;
    for i := 1 to Length(Pass) do
      PassD[i] := Chr(Ord(Pass[i]) - 10);

    if Copy(PassD, Length(PassD) - Length(ThePass) + 1, Length(ThePass)) <>
      ThePass then
      Exit;

    j := 0;
    for i := 1 to Length(s) do
    begin
      Inc(j);
      if j > Length(Pass) then
        j := 1;
      s[i] := Chr(Ord(s[i]) - Ord(Pass[j]));
    end;
    OK:= true;
    Result := s;
  except
    Result := '';
    OK:= false;
  end;
end;

//******************************************

function CobDeCryptText(TheText, ThePass: string): string;
var
  i, j: integer;
  s: string;
  pass, PassD: string;
begin
  {Decrypt a string which was encrypted using
  the function CobEncryptText}
  Result := '';

  if Length(TheText)=0 then
    Exit;

  if Length(ThePass) = 0 then
  begin
    Result := 'CobEncryptError*-*Incorrect password';
    Exit;
  end;

  try
    s := TheText;
    j := StrToInt(Copy(s, 1, 1));
    Delete(s, 1, 1);
    Pass := Copy(s, 1, j + Length(ThePass));
    Delete(s, 1, j + Length(ThePass));
    PassD := Pass;
    for i := 1 to Length(Pass) do
      PassD[i] := Chr(Ord(Pass[i]) - 10);
    if Copy(PassD, Length(PassD) - Length(ThePass) + 1, Length(ThePass)) <>
      ThePass then
    begin
      Result := 'CobEncryptError*-*Incorrect password';
      Exit;
    end;
    j := 0;
    for i := 1 to Length(s) do
    begin
      Inc(j);
      if j > Length(Pass) then
        j := 1;
      s[i] := Chr(Ord(s[i]) - Ord(Pass[j]));
    end;
    Result := s;
  except
    Result := 'CobCryptError*-*String corrupted';
  end;
end;

//*****************************************

function CobEnCryptText(TheText, ThePass: string): string;
var
  Key: integer;
  sKey, sText, s: string;
  i, j: integer;
begin
  {Encrypt a string using my own mutant method}
  Result := '';
  if ThePass = '' then
  begin
    Result := 'CobEncryptError*-*Password can''t be empty';
    Exit;
  end;
  Randomize;
  Key := Random(9999999) + 1;
  Key := Key + 1969;
  sKey := IntToStr(Key) + ThePass;
  for i := 1 to Length(sKey) do
    sKey[i] := Chr(Ord(sKey[i]) + 10);
  //crypt
  sText := TheText;
  j := 0;
  for i := 1 to Length(sText) do
  begin
    Inc(j);
    if j > Length(sKey) then
      j := 1;
    sText[i] := Chr(Ord(sText[i]) + Ord(sKey[j]));
  end;
  s := IntToStr(Key);
  Result := IntToStr(Length(s)) + sKey + sText;
end;

//*****************************************

function CobGetAppPathOld: string;
var
  s: string;
begin
  {Get the path to the executable file}
  s := ExtractFilePath(ParamStr(0));
  if s <> '' then
    if s[Length(s)] <> '\' then
      s := s + '\';
  Result := s;
end;

//*****************************************

function CobCreateEmptyTextFile(FileName: string): boolean;
var
  Text: TStringList;
begin
  Result:= true; //Succesfully created
  {Creates an empty text file}
  Text := TStringList.Create;
  try
    try
      Text.SaveToFile(FileName);
    except
      Result:= false;
    end;
  finally
    Text.Free;
  end;
end;

//*****************************************

procedure CobAutoStart(Name, FileName: string; Delete, Global: boolean; Param:
  string = ''; Service: boolean = false);
var
  Reg: TRegistry;
  Exists: boolean;
  Val: TStringList;
  i: integer;
  TheRoot: Cardinal;
  TheKey: string;
begin
  {Procedure to create an utostart item in the registry.
  Name is the name of the value to create,
  FileName is the file to start, inclusive the path,
  Delete is a flag indicating that this value will be deleted if found,
  Global indicate that the autostart value will be
  created for all users. When global is false, the value will
  be created only for the current user.
  Param is a parameter for the program to start,
  When service is true, the value will be created in the key RunServices}
  if Global then
    TheRoot := HKEY_LOCAL_MACHINE
  else
    TheRoot := HKEY_CURRENT_USER;

  if Service then
    TheKey := '\Software\Microsoft\Windows\CurrentVersion\RunServices'
  else
    TheKey := '\Software\Microsoft\Windows\CurrentVersion\Run';

  Reg := TRegistry.Create(KEY_READ or KEY_WRITE);
  Val := TStringList.Create;
  Exists := false;
  try
    Reg.RootKey := TheRoot;
    if not Delete then
    begin
      if Reg.OpenKey(TheKey, True) then
      begin
        if Pos(' ', FileName) > 0 then //if name contains spaces
          FileName := '"' + FileName + '"';
        if Param <> '' then
          Reg.WriteString(Name, FileName + ' ' + Param)
        else
          Reg.WriteString(Name, FileName);
      end;
    end
    else
    begin //Delete
      if Reg.OpenKey(TheKey, False) then
      begin
        Reg.GetValueNames(Val);
        for i := 0 to Val.Count - 1 do
        begin
          if Val[i] = Name then
            Exists := true;
        end;
        if Exists then
          Reg.DeleteValue(Name);
      end;

    end;
  finally
    Reg.Free;
    Val.Free;
  end; //try
end;

//************************************************

function CobFormatSize(Size: Int64): string;
begin
  // Returns a human readable string for Size (bytes}
  Result := '';
  if Size < 1024 then
    Result := IntToStr(Size) + ' bytes'
  else if (Size >= 1024) and (Size < 1048576) then
    Result := Format('%.2f', [Size / 1024]) + ' KB'
  else if (Size >= 1048576) and (Size < 1073741824) then
    Result := Format('%.2f', [Size / 1048576]) + ' MB'
  else if (Size >= 1073741824) and (Size < 1099511627776) then
    Result := Format('%.2f', [Size / 1073741824]) + ' GB'
  else
    Result := Format('%.2f', [Size / 1099511627776]) + ' TB';

end;

//************************************************

function CobDeFormatSize(s: string): Int64;
var
  S1, S2: string;
  Value: real;
  Position: integer;
begin
  //try to convert a string of type 56 MB into 56000000 (bytes)
  Position := Pos(' ', S);
  if Position = 0 then
  begin
    Result := 0;
  end
  else
  begin
    try
      S1 := Copy(s, 1, Position - 1);
      Delete(s, 1, Position);
      S2 := s;
      Value := StrToFloat(s1);
      if s2 = 'KB' then
        Value := Value * 1024
      else if s2 = 'MB' then
        Value := Value * 1048576
      else if s2 = 'GB' then
        Value := Value * 1073741824
      else if s2 = 'TB' then
        Value := Value * 1099511627776;
      Result := Round(Value);
    except
      Result := 0;
    end;
  end;
end;

//*********************************************

function CobIsIP(s: string): boolean;
var
  Sl: TStringList;
  i: integer;
  Value, Code: integer;
begin
  //Check if the format of the string is
  //xxx.xxx.xxx.xxx where xxx:[0..255]
  Result := true;
  Sl := TStringList.Create;
  try
    Sl.Delimiter := '.';
    Sl.QuoteChar := '"';
    Sl.DelimitedText := s;

    if Sl.Count <> 4 then
    begin
      Result := false;
      Exit;
    end;

    for i := 0 to Sl.Count - 1 do
    begin
      Val(Sl[i], Value, Code);
      if Code <> 0 then
      begin
        Result := false;
        Break;
      end;
      if (Value < 0) or (Value > 255) then
      begin
        Result := false;
        Break;
      end;
    end;
  finally
    FreeAndNil(Sl);
  end;
end;

//*********************************************

function CobSetBackSlash(s: string): string;
begin
  {Set a slash if the last character is not '\'.
  Useful for directories}
  if Length(s) > 0 then
    if s[Length(s)] <> '\' then
      s := s + '\';
  Result := s;
end;

//*************************************************

function CobSetDotExtension(const Ext: string): string;
begin
  Result:= Ext;
  if (Length(Ext) > 0) then
    if (Ext[1] <> '.') then
      Result:= '.' + Ext;
end;

//*************************************************

function CobSetQuotes(s: string): string;
begin
  Result := '""';
  if s <> '' then
  begin
    if (s[1] <> '"') and (s[Length(s)] <> '"') then
      Result := '"' + s + '"' else
      Result:= s;
  end;
end;

//************************************************
function CobSetQuotesIfNeeded(s: string): string;
begin
  Result:= '""';
  if (s <> '') then
    begin
      if (s[1] <> '"') and (s[Length(s)] <> '"') and (Pos(' ', s) >0) then
        Result := '"' + s + '"' else
        Result:= s;
    end;
end;

//*************************************************

function CobSetForwardSlash(s: string): string;
begin
  {Set a back slash if the last character is not '\'.
  Useful for directories}
  if Length(s) > 0 then
    if s[Length(s)] <> '/' then
      s := s + '/';
  Result := s;
end;
//*************************************************

function CobGetVersion: string;
var
  InfoSize: LongWord;
  Wnd: Cardinal;
  VerBuf: Pointer;
  FI: PVSFixedFileInfo;
  VerSize: DWORD;
  chrAppName: PChar;
  strFullVersion: string;
  intMajor, intMinor: Integer;
  intRelease, intBuild: Integer;
begin
  {Gets the version of the executable from the version resource}
  chrAppName := PChar(ParamStr(0));
  InfoSize := GetFileVersionInfoSize(chrAppName, Wnd);
  strFullVersion := '';
  if InfoSize <> 0 then
  begin
    GetMem(VerBuf, InfoSize);
    try
      if GetFileVersionInfo(chrAppName, Wnd, InfoSize, VerBuf) then
        if VerQueryValue(VerBuf, '\', Pointer(FI), VerSize) then
        begin
          intMajor := HiWord(FI.dwFileVersionMS);
          intMinor := LoWord(FI.dwFileVersionMS);
          intRelease := HiWord(FI.dwFileVersionLS);
          intBuild := LoWord(FI.dwFileVersionLS);
          strFullVersion := IntToStr(intMajor) + '.' +
            IntToStr(intMinor) + '.' +
            IntToStr(intRelease) + '.' +
            IntToStr(intBuild);
        end;
    finally
      FreeMem(VerBuf);
    end;
  end;
  Result := strFullVersion;
end;

//*************************************************

function CobIsNt(var Build, Version: string): boolean;
var
  OsVersion: TOSVersionInfo;
begin
  //Return true if NT,2000 or better

  with OSVersion do
  begin
    dwOSVersionInfoSize := sizeof(OSVersion);
    GetVersionEx(OSVersion);
    case dwPlatformId of
      VER_PLATFORM_WIN32s:
        begin
          Result := false;
          Version := 'Win32s on Windows 3.1';
        end;
      VER_PLATFORM_WIN32_WINDOWS:
        begin
          Result := false;
          Version := 'Windows 9x, ME or newer';
        end;
      VER_PLATFORM_WIN32_NT:
        begin
          Result := true;
          Version := 'Windows NT, 2000 or newer';
        end;
    else
      begin
        Result := false;
        Version := 'Unknown Windows version';
      end;
    end; //case

    Build := IntToStr(dwMajorVersion) + '.' + IntToStr(dwMinorVersion) + '.' +
      IntToStr(Lo(dwBuildNumber));
  end //With
end;

//******************************************

function CobIsAdmin: Boolean;
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
  Result := False;
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
      for x := 0 to ptgGroups.GroupCount - 1 do
        if EqualSid(psidAdministrators, ptgGroups.Groups[x].Sid) then
        begin
          Result := True;
          Break;
        end;
{$R+}
      FreeSid(psidAdministrators);
    end;
    FreeMem(ptgGroups);
  end;
end;

//**********************************

function CobGetParentDir(s: string): string;
var
  i: integer;
begin
  {Returns the parent dir of a folder}
  Result := '';
  if Length(s) > 0 then
  begin
    if (s[length(s)] = '\') then
      if (s[length(s) - 1] = ':') then
      begin
        Result := s; //Returns the same.
        Exit;
      end
      else
        Delete(s, Length(s), 1);

    i := length(s);
    while s[i] <> '\' do
      dec(i);
    Delete(s, i + 1, length(s));
    Result := s;

  end;
end;
//**************************

function CobGetShortDirName(s: string): string;
var
  i: integer;
begin
  {Return the relative name of a directory.
  For exemple C:\Programs\Test\ returns only Text}
  Result := '';
  if length(s) > 0 then
  begin
    if (s[length(s)] = '\') then
      if (s[length(s) - 1] = ':') then
      begin
        //Delete(s,2,2);
        Result := s;
        Exit;
      end
      else
        Delete(s, Length(s), 1);

    i := length(s);
    while s[i] <> '\' do
      dec(i);
    Delete(s, 1, i);
    Result := s;
  end;
end;

//****************************

function CobFileCount(Folder: string; Sub: boolean; var Size: Int64; MaskI:
  string = ''; MaskE: string = ''): cardinal;
var
  Total: cardinal;
  TotalSize: Int64;
  TheMaskE, TheMaskI: TStringList;
  //---------------------------------------- subfunction

  function IsTheFileInMask(Dir, FileName: string; Exclusion: boolean): boolean;
  var
    i: integer;
    p, f: string;
    List: TStringList;
  begin
    Result := false;
    //See if the file is in the mask
    if Exclusion then
      List := TheMaskE
    else
      List := TheMaskI;

    for i := 0 to List.Count - 1 do
    begin
      p := ExtractFilePath(List[i]);
      f := ExtractFileName(List[i]);
      //if p <> '' then
      if ((Pos('?', f) > 0) or (Pos('*', f) > 0)) and (p = '') then
      begin
        //is a mask
        if MatchesMask(FileName, f) then
        begin
          Result := true;
          Break;
        end;
      end
      else
      begin
        //its NOT a mask
        if FileExists(List[i]) then
        begin
          //a file
          if Uppercase(CobSetBackSlash(Dir) + FileName) =
            UpperCase(List[i]) then //file
          begin
            Result := true;
            Break;
          end;
        end //file
        else
        begin
          // a dir
          if Pos(Uppercase(p), UpperCase(CobSetBackSlash(Dir))) > 0 then
          begin
            Result := true;
            Break;
          end;
        end;
      end; //not a mask

    end; //For
  end;

  //---------------------------------------- subprocedure
  procedure Count(s: string; sd: boolean);
  var
    SR: TSearchRec;
    IsInMaskE, IsInMaskI: boolean;
    AddIt: boolean;
    converter: packed record
      case Boolean of
        false: (n: int64);
        true: (low, high: DWORD);
    end;

  begin
    if FindFirst(s + '*.*', faAnyFile, SR) = 0 then
    begin
      if (SR.Attr and faDirectory) = faDirectory then
      begin
        if (SR.Name <> '.') and (SR.Name <> '..') then
          if sd then
            Count(CobSetBackSlash(s + SR.Name), sd);
      end
      else
      begin
        AddIt := true;
        if MaskE <> '' then
        begin
          IsInMaskE := IsTheFileInMask(s, SR.Name, true);
          if IsInMaskE then
            AddIt := false;
        end;
        if MaskI <> '' then
        begin
          IsInMaskI := IsTheFileInMask(s, SR.Name, false);
          if not IsInMaskI then
            AddIt := false;
        end;

        if Addit then
        begin
          Inc(Total);
          converter.low := SR.FindData.nFileSizeLow;
          converter.high := SR.FindData.nFileSizeHigh;
          TotalSize := TotalSize + converter.n;
        end;
      end;
      while FindNext(SR) = 0 do
      begin
        if (SR.Attr and faDirectory) = faDirectory then
        begin
          if (SR.Name <> '.') and (SR.Name <> '..') then
            if sd then
              Count(CobSetBackSlash(s + SR.Name), sd);
        end
        else
          //is a file. Apply mask.
        begin
          IsInMaskE := false;
          AddIt := true;
          
          if MaskE <> '' then
          begin
            IsInMaskE := IsTheFileInMask(s, SR.Name, true);
            if IsInMaskE then
              AddIt := false;
          end;

          if not IsInMaskE then //no need to check this if the file is exclude
            if MaskI <> '' then
            begin
              IsInMaskI := IsTheFileInMask(s, SR.Name, false);
              if not IsInMaskI then
                AddIt := false;
            end;

          if AddIt then
          begin
            Inc(Total);
            converter.low := SR.FindData.nFileSizeLow;
            converter.high := SR.FindData.nFileSizeHigh;
            TotalSize := TotalSize + converter.n;
          end;
        end;
      end;
      SysUtils.FindClose(SR);
    end;
  end;
  //---------------------------------------- subprocedure end
begin
  //How many files (no subdirs) are contained on a folder?
  Result := 0;
  Total := 0;
  TotalSize := 0;
  if Folder = '' then
    Exit;
  if FileExists(Folder) then
    //its a file
  begin
    {This is a special case of the procedure.
    The original function was made to get ONLY
    the number of files, now I'm using it
    to get the total size too, so a special case is
    the function CobGetFileSize}
    Result := 1; //one file
    Size := CobGetFileSize(Folder);
    Exit;
  end;

  //If we get here It IS A FOLDER

  Folder := CobSetBackSlash(Folder);

  TheMAskE := TStringList.Create;
  TheMAskI := TStringList.Create;
  try
    TheMaskE.CommaText := MaskE;
    TheMaskI.CommaText := MaskI;
    Count(Folder, Sub);
  finally
    TheMaskI.Free;
    TheMaskE.Free;
  end;
  Size := TotalSize;
  Result := Total;
end;

//***************************************

function CobGetFileSize(s: string): Int64;
var
  SR: TSearchRec;
  converter: packed record
    case Boolean of
      false: (n: int64);
      true: (low, high: DWORD);
  end;

begin
  Result := 0;
  if FindFirst(s, faAnyFile, SR) = 0 then
  begin
    converter.low := SR.FindData.nFileSizeLow;
    converter.high := SR.FindData.nFileSizeHigh;
    Result := converter.n;
    SysUtils.FindClose(SR);
  end;
end;

//*****************************

function CobGetIEVersion: string;
var
  Reg: TRegistry;
  Ver, Build: string;
begin
  {Return the version of the installed IE}
  Result := '';
  Ver := '';
  Build := '';
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKey('\Software\Microsoft\Internet Explorer', false) then
    begin
      Ver := Reg.ReadString('Version');
      Build := Reg.ReadString('Build');
      if Ver <> '' then
        Result := Ver
      else
        Result := Build;
    end;
  finally
    Reg.Free;
  end;
end;

end.

