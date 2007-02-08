{*******************************************************************************
***                                                                          ***
***                       © 2000-2006 by Luis Cobian                         ***
***                           All rights reserved                            ***
***                                                                          ***
***                           cobian@educ.umu.se                             ***
***                                                                          ***
***                                                                          ***
***              Adaptation of the TRegistry to work with Unicode ONLY       ***
***                          Adaptation by Luis Cobian                       ***
***                                                                          ***
***                                                                          ***
***                                                                          ***
*******************************************************************************}
unit CobRegistryW;

interface

uses Windows, Classes, SysUtils, TntClasses;

type
  // ECobRegistryExceptionW = class(Exception);

  T_CobRegKeyInfoW = record
    NumSubKeys: Integer;
    MaxSubKeyLen: Integer;
    NumValues: Integer;
    MaxValueLen: Integer;
    MaxDataLen: Integer;
    FileTime: TFileTime;
  end;

  T_CobRegDataTypeW = (rdUnknown, rdString, rdExpandString, rdInteger, rdBinary);

  T_CobRegDataInfoW = record
    RegData: T_CobRegDataTypeW;
    DataSize: Integer;
  end;

  TCobRegistryW = class(Tobject)
  private
    FRootKey: HKEY;
    FCurrentKey: HKEY;
    FLazyWrite: Boolean;
    FCloseRootKey: Boolean;
    FAccess: LongWord;
    FCurrentPath: WideString;
    procedure SetRootKey(Value: HKEY);
    function IsRelative(const Value: WideString): boolean;
  protected
    procedure ChangeKey(Value: HKey; const Path: WideString);
    function GetBaseKey(Relative: Boolean): HKey;
    function GetData(const Name: WideString; Buffer: Pointer;
      BufSize: Integer; var RegData: T_CobRegDataTypeW): Integer;
    function GetKey(const Key: WideString): HKEY;
    function DataTypeToRegData(Value: Integer): T_CobRegDataTypeW;
    function PutData(const Name: WideString; Buffer: Pointer; BufSize: Integer;
              RegData: T_CobRegDataTypeW): boolean;
    function RegDataToDataType(Value: T_CobRegDataTypeW): Integer;
    procedure SetCurrentKey(Value: HKEY);
  public
    constructor Create(); overload;
    constructor Create(AAccess: LongWord); overload;
    destructor Destroy(); override;
    procedure CloseKey();
    function CreateKey(const Key: WideString): Boolean;
    function DeleteKey(const Key: WideString): Boolean;
    function DeleteValue(const Name: WideString): Boolean;
    function GetDataInfo(const ValueName: WideString; var Value: T_CobRegDataInfoW): Boolean;
    function GetDataSize(const ValueName: WideString): Integer;
    function GetDataType(const ValueName: WideString): T_CobRegDataTypeW;
    function GetKeyInfo(var Value: T_CobRegKeyInfoW): Boolean;
    procedure GetKeyNames(Strings: TTntStrings);
    procedure GetValueNames(Strings: TTntStrings);
    function HasSubKeys(): Boolean;
    function KeyExists(const Key: WideString): Boolean;
    function LoadKey(const Key, FileName: WideString): Boolean;
    // procedure MoveKey(const OldName, NewName: WideString; Delete: Boolean);
    function OpenKey(const Key: WideString; CanCreate: Boolean): Boolean;
    function OpenKeyReadOnly(const Key: WideString): Boolean;
    function ReadCurrency(const Name: WideString; out Success: boolean): Currency;
    function ReadBinaryData(const Name: WideString; var Buffer; BufSize: Integer; out Success: boolean): Integer;
    function ReadBool(const Name: WideString; out Success: boolean): Boolean;
    function ReadDate(const Name: WideString; out Success: boolean): TDateTime;
    function ReadDateTime(const Name: WideString; out Success: boolean): TDateTime;
    function ReadFloat(const Name: WideString; out Success: boolean): Double;
    function ReadInteger(const Name: WideString; out Success: boolean): Integer;
    function ReadStringWide(const Name: WideString; out Success: boolean): WideString;
    function ReadTime(const Name: WideString; out Success: boolean): TDateTime;
    function RegistryConnect(const UNCName: WideString): Boolean;
    //procedure RenameValue(const OldName, NewName: WideString);
    function ReplaceKey(const Key, FileName, BackUpFileName: WideString): Boolean;
    function SaveKey(const Key, FileName: WideString): Boolean;
    function UnLoadKey(const Key: WideString): Boolean;
    function WriteCurrency(const Name: WideString; Value: Currency): boolean;
    function WriteBinaryData(const Name: WideString; var Buffer; BufSize: Integer): boolean;function ValueExists(const Name: WideString): Boolean;
    function WriteBool(const Name: WideString; Value: Boolean): boolean;
    function WriteDate(const Name: WideString; Value: TDateTime): boolean;
    function WriteDateTime(const Name: WideString; Value: TDateTime): boolean;
    function WriteFloat(const Name: WideString; Value: Double): boolean;
    function WriteInteger(const Name: WideString; Value: Integer): boolean;
    function WriteStringWide(const Name, Value: WideString): boolean;
    function WriteExpandString(const Name, Value: WideString): boolean;
    function WriteTime(const Name: WideString; Value: TDateTime): boolean;
    property CurrentKey: HKEY read FCurrentKey;
    property CurrentPath: WideString read FCurrentPath;
    property LazyWrite: Boolean read FLazyWrite write FLazyWrite;
    property RootKey: HKEY read FRootKey write SetRootKey;
    property Access: LongWord read FAccess write FAccess;
  end;

implementation

uses CobCommonW;

const
  WS_NIL: WideString ='';
  WS_BACKSLASH: WideString = '\';
  WS_BACKSLASHCHAR: WideChar = '\';
  S_NIL: AnsiString = '';

constructor TCobRegistryW.Create();
begin
  RootKey := HKEY_CURRENT_USER;
  FAccess := KEY_ALL_ACCESS;
  LazyWrite := True;
end;

procedure TCobRegistryW.CloseKey();
begin
  if CurrentKey <> 0 then
  begin
    if not LazyWrite then
      RegFlushKey(CurrentKey);
    RegCloseKey(CurrentKey);
    FCurrentKey := 0;
    FCurrentPath := WideString('');
  end;
end;

constructor TCobRegistryW.Create(AAccess: LongWord);
begin
  Create();
  FAccess := AAccess;
end;

destructor TCobRegistryW.Destroy();
begin
  CloseKey();
  inherited Destroy();
end;

procedure TCobRegistryW.SetRootKey(Value: HKEY);
begin
  if RootKey <> Value then
  begin
    if FCloseRootKey then
    begin
      RegCloseKey(RootKey);
      FCloseRootKey := False;
    end;
    FRootKey := Value;
    CloseKey();
  end;
end;

function TCobRegistryW.OpenKey(const Key: WideString;
  CanCreate: Boolean): Boolean;
var
  TempKey: HKey;
  S: WideString;
  Disposition: Integer;
  Relative: Boolean;
begin
  S := Key;
  Relative := IsRelative(S);

  if not Relative then Delete(S, 1, 1);
  TempKey := 0;
  if not CanCreate or (S = WS_NIL) then
  begin
    Result := RegOpenKeyExW(GetBaseKey(Relative), PWideChar(S), 0,
      FAccess, TempKey) = ERROR_SUCCESS;
  end else
    Result := RegCreateKeyExW(GetBaseKey(Relative), PWideChar(S), 0, nil,
      REG_OPTION_NON_VOLATILE, FAccess, nil, TempKey, @Disposition) = ERROR_SUCCESS;
  if Result then
  begin
    if (CurrentKey <> 0) and Relative then S := CurrentPath + WS_BACKSLASH + S;
    ChangeKey(TempKey, S);
  end;
end;

function TCobRegistryW.IsRelative(const Value: WideString): boolean;
begin
  Result := not ((Value <> WS_NIL) and (Value[1] = WS_BACKSLASHCHAR));
end;

function TCobRegistryW.GetBaseKey(Relative: Boolean): HKey;
begin
  if (CurrentKey = 0) or not Relative then
    Result := RootKey else
    Result := CurrentKey;
end;

procedure TCobRegistryW.ChangeKey(Value: HKey; const Path: WideString);
begin
  CloseKey();
  FCurrentKey := Value;
  FCurrentPath := Path;
end;

function TCobRegistryW.ValueExists(const Name: WideString): Boolean;
var
  Info: T_CobRegDataInfoW;
begin
  Result := GetDataInfo(Name, Info);
end;

function TCobRegistryW.GetDataInfo(const ValueName: WideString;
  var Value: T_CobRegDataInfoW): Boolean;
var
  DataType: Integer;
begin
  FillChar(Value, SizeOf(T_CobRegDataInfoW), 0);
  Result := RegQueryValueExW(CurrentKey, PWideChar(ValueName), nil, @DataType, nil,
    @Value.DataSize) = ERROR_SUCCESS;
  Value.RegData := DataTypeToRegData(DataType);
end;

function TCobRegistryW.DataTypeToRegData(Value: Integer): T_CobRegDataTypeW;
begin
  if Value = REG_SZ then Result := rdString
  else if Value = REG_EXPAND_SZ then Result := rdExpandString
  else if Value = REG_DWORD then Result := rdInteger
  else if Value = REG_BINARY then Result := rdBinary
  else Result := rdUnknown;
end;

function TCobRegistryW.OpenKeyReadOnly(const Key: WideString): Boolean;
var
  TempKey: HKey;
  S: WideString;
  Relative: Boolean;
begin
  S := Key;
  Relative := IsRelative(S);

  if not Relative then Delete(S, 1, 1);
  TempKey := 0;
  Result := RegOpenKeyExW(GetBaseKey(Relative), PWideChar(S), 0,
      KEY_READ, TempKey) = ERROR_SUCCESS;
  if Result then
  begin
    FAccess := KEY_READ;
    if (CurrentKey <> 0) and Relative then S := CurrentPath + WS_BACKSLASH + S;
    ChangeKey(TempKey, S);
  end
  else
  begin
    Result := RegOpenKeyExW(GetBaseKey(Relative), PWideChar(S), 0,
        STANDARD_RIGHTS_READ or KEY_QUERY_VALUE or KEY_ENUMERATE_SUB_KEYS,
        TempKey) = ERROR_SUCCESS;
    if Result then
    begin
      FAccess := STANDARD_RIGHTS_READ or KEY_QUERY_VALUE or KEY_ENUMERATE_SUB_KEYS;
      if (CurrentKey <> 0) and Relative then S := CurrentPath + WS_BACKSLASH + S;
      ChangeKey(TempKey, S);
    end
    else
    begin
      Result := RegOpenKeyExW(GetBaseKey(Relative), PWideChar(S), 0,
          KEY_QUERY_VALUE, TempKey) = ERROR_SUCCESS;
      if Result then
      begin
        FAccess := KEY_QUERY_VALUE;
        if (CurrentKey <> 0) and Relative then S := CurrentPath + WS_BACKSLASH+ S;
        ChangeKey(TempKey, S);
      end
    end;
  end;
end;

function TCobRegistryW.ReadCurrency(const Name: WideString; out Success: boolean): Currency;
var
  Len: Integer;
  RegData: T_CobRegDataTypeW;
begin
  Success:= true;
  Len := GetData(Name, @Result, SizeOf(Currency), RegData);
  if (RegData <> rdBinary) or (Len <> SizeOf(Currency)) then
    Success:= false;;
end;

function TCobRegistryW.GetData(const Name: WideString; Buffer: Pointer;
  BufSize: Integer; var RegData: T_CobRegDataTypeW): Integer;
var
  DataType: Integer;
begin
  Result:= 0;
  DataType := REG_NONE;
  if RegQueryValueExW(CurrentKey, PWideChar(Name), nil, @DataType, PByte(Buffer),
    @BufSize) <> ERROR_SUCCESS then
    Exit;
    //raise ECobRegistryExceptionW.CreateResFmt(@SRegGetDataFailed, [Name]);
  Result := BufSize;
  RegData := DataTypeToRegData(DataType);
end;

function TCobRegistryW.ReadBinaryData(const Name: WideString; var Buffer;
  BufSize: Integer; out Success: boolean): Integer;
var
  RegData: T_CobRegDataTypeW;
  Info: T_CobRegDataInfoW;
begin
  Success:= true;
  if GetDataInfo(Name, Info) then
  begin
    Result := Info.DataSize;
    RegData := Info.RegData;
    if ((RegData = rdBinary) or (RegData = rdUnknown)) and (Result <= BufSize) then
      GetData(Name, @Buffer, Result, RegData)
    else Success:= false;
  end else
    Result := 0;
end;

function TCobRegistryW.ReadBool(const Name: WideString; out Success: boolean): Boolean;
begin
  Result := ReadInteger(Name, Success) <> 0;
end;

function TCobRegistryW.ReadInteger(const Name: WideString; out Success: boolean): Integer;
var
  RegData: T_CobRegDataTypeW;
begin
  Success:= true;
  GetData(Name, @Result, SizeOf(Integer), RegData);
  if RegData <> rdInteger then Success:= false;
end;

function TCobRegistryW.ReadDate(const Name: WideString;
  out Success: boolean): TDateTime;
begin
  Result := ReadDateTime(Name, Success);
end;

function TCobRegistryW.ReadDateTime(const Name: WideString;
  out Success: boolean): TDateTime;
var
  Len: Integer;
  RegData: T_CobRegDataTypeW;
begin
  Success:= true;
  Len := GetData(Name, @Result, SizeOf(TDateTime), RegData);
  if (RegData <> rdBinary) or (Len <> SizeOf(TDateTime)) then
    Success:= false;
end;

function TCobRegistryW.ReadFloat(const Name: WideString; out Success: boolean): Double;
var
  Len: Integer;
  RegData: T_CobRegDataTypeW;
begin
  Success:= true;
  Len := GetData(Name, @Result, SizeOf(Double), RegData);
  if (RegData <> rdBinary) or (Len <> SizeOf(Double)) then
    Success:= false;
end;

function TCobRegistryW.ReadTime(const Name: WideString;
  out Success: boolean): TDateTime;
begin
  Result := ReadDateTime(Name, Success);
end;


function TCobRegistryW.ReadStringWide(const Name: WideString;
  out Success: boolean): WideString;
var
  Len: Integer;
  RegData: T_CobRegDataTypeW;
begin
  Success:= true;
  Len := GetDataSize(Name);
  if Len > 0 then
  begin
    // SetString(Result, nil, Len div SizeOf(WideChar));
    SetLength(Result, Len div SizeOf(WideChar));
    GetData(Name, PWideChar(Result), Len, RegData);
    if (RegData = rdString) or (RegData = rdExpandString) then
      SetLength(Result, CobStrLenW(PWideChar(Result)))
    else Success:= false;
  end
  else Result := WS_NIL;
end;

function TCobRegistryW.GetDataSize(const ValueName: WideString): Integer;
var
  Info: T_CobRegDataInfoW;
begin
  if GetDataInfo(ValueName, Info) then
    Result := Info.DataSize else
    Result := -1;
end;

function TCobRegistryW.WriteCurrency(const Name: WideString; Value: Currency): boolean;
begin
  Result:= PutData(Name, @Value, SizeOf(Currency), rdBinary);
end;

function TCobRegistryW.PutData(const Name: WideString; Buffer: Pointer;
  BufSize: Integer; RegData: T_CobRegDataTypeW): boolean;
var
  DataType: Integer;
begin
  Result:= true;
  DataType := RegDataToDataType(RegData);
  if RegSetValueExW(CurrentKey, PWideChar(Name), 0, DataType, Buffer,
    BufSize) <> ERROR_SUCCESS then
    Result:= false;
end;

function TCobRegistryW.RegDataToDataType(Value: T_CobRegDataTypeW): Integer;
begin
  case Value of
    rdString: Result := REG_SZ;
    rdExpandString: Result := REG_EXPAND_SZ;
    rdInteger: Result := REG_DWORD;
    rdBinary: Result := REG_BINARY;
  else
    Result := REG_NONE;
  end;
end;

function TCobRegistryW.WriteBinaryData(const Name: WideString; var Buffer;
  BufSize: Integer): boolean;
begin
  Result:=   PutData(Name, @Buffer, BufSize, rdBinary);
end;

function TCobRegistryW.WriteBool(const Name: WideString;
  Value: Boolean): boolean;
begin
  Result:=  WriteInteger(Name, Ord(Value));
end;

function TCobRegistryW.WriteInteger(const Name: WideString;
  Value: Integer): boolean;
begin
  Result:=   PutData(Name, @Value, SizeOf(Integer), rdInteger);
end;

function TCobRegistryW.WriteDateTime(const Name: WideString;
  Value: TDateTime): boolean;
begin
    Result:=   PutData(Name, @Value, SizeOf(TDateTime), rdBinary);
end;

function TCobRegistryW.WriteDate(const Name: WideString;
  Value: TDateTime): boolean;
begin
  Result:=   WriteDateTime(Name, Value);
end;

function TCobRegistryW.WriteFloat(const Name: WideString;
  Value: Double): boolean;
begin
  Result:=   PutData(Name, @Value, SizeOf(Double), rdBinary);
end;

function TCobRegistryW.WriteTime(const Name: WideString;
  Value: TDateTime): boolean;
begin
  Result:=   WriteDateTime(Name, Value);
end;

function TCobRegistryW.WriteStringWide(const Name, Value: WideString): boolean;
begin
  Result:= PutData(Name, PWideChar(Value), (Length(Value)+1)*SizeOf(WideChar), rdString);
end;

function TCobRegistryW.WriteExpandString(const Name,
  Value: WideString): boolean;
begin
  Result:=  PutData(Name, PWideChar(Value), (Length(Value)+1)*SizeOf(WideChar), rdExpandString);
end;

function TCobRegistryW.GetKey(const Key: WideString): HKEY;
var
  S: WideString;
  Relative: Boolean;
begin
  S := Key;
  Relative := IsRelative(S);
  if not Relative then Delete(S, 1, 1);
  Result := 0;
  RegOpenKeyExW(GetBaseKey(Relative), PWideChar(S), 0, FAccess, Result);
end;

procedure TCobRegistryW.SetCurrentKey(Value: HKEY);
begin
  FCurrentKey := Value;
end;

function TCobRegistryW.CreateKey(const Key: WideString): Boolean;
var
  TempKey: HKey;
  S: WideString;
  Disposition: Integer;
  Relative: Boolean;
begin
  TempKey := 0;
  S := Key;
  Relative := IsRelative(S);
  if not Relative then Delete(S, 1, 1);
  Result := RegCreateKeyExW(GetBaseKey(Relative), PWideChar(S), 0, nil,
    REG_OPTION_NON_VOLATILE, KEY_ALL_ACCESS, nil, TempKey, @Disposition) = ERROR_SUCCESS;
  if Result then RegCloseKey(TempKey);
end;

function TCobRegistryW.DeleteKey(const Key: WideString): Boolean;
var
  Len: DWORD;
  I: Integer;
  Relative: Boolean;
  S, KeyName: WideString;
  OldKey, DeleteKey: HKEY;
  Info: T_CobRegKeyInfoW;
begin
  S := Key;
  Relative := IsRelative(S);
  if not Relative then Delete(S, 1, 1);
  OldKey := CurrentKey;
  DeleteKey := GetKey(Key);
  if DeleteKey <> 0 then
  try
    SetCurrentKey(DeleteKey);
    if GetKeyInfo(Info) then
    begin
      //SetString(KeyName, nil, Info.MaxSubKeyLen + 1);   //Len div SizeOf(WideChar)
      SetLength(KeyName, Info.MaxSubKeyLen + 1);
      for I := Info.NumSubKeys - 1 downto 0 do
      begin
        Len := Info.MaxSubKeyLen + 1;
        if RegEnumKeyExW(DeleteKey, DWORD(I), PWideChar(KeyName), Len, nil, nil, nil,
          nil) = ERROR_SUCCESS then
          Self.DeleteKey(PWideChar(KeyName));
      end;
    end;
  finally
    SetCurrentKey(OldKey);
    RegCloseKey(DeleteKey);
  end;
  Result := RegDeleteKeyW(GetBaseKey(Relative), PWideChar(S)) = ERROR_SUCCESS;
end;

function TCobRegistryW.GetKeyInfo(var Value: T_CobRegKeyInfoW): Boolean;
begin
  FillChar(Value, SizeOf(T_CobRegKeyInfoW), 0);
  Result := RegQueryInfoKeyW(CurrentKey, nil, nil, nil, @Value.NumSubKeys,
    @Value.MaxSubKeyLen, nil, @Value.NumValues, @Value.MaxValueLen,
    @Value.MaxDataLen, nil, @Value.FileTime) = ERROR_SUCCESS;
  if SysLocale.FarEast and (Win32Platform = VER_PLATFORM_WIN32_NT) then
    with Value do
    begin
      Inc(MaxSubKeyLen, MaxSubKeyLen);
      Inc(MaxValueLen, MaxValueLen);
    end;
end;

function TCobRegistryW.DeleteValue(const Name: WideString): Boolean;
begin
  Result := RegDeleteValueW(CurrentKey, PWideChar(Name)) = ERROR_SUCCESS;
end;

function TCobRegistryW.GetDataType(const ValueName: WideString): T_CobRegDataTypeW;
var
  Info: T_CobRegDataInfoW;
begin
  if GetDataInfo(ValueName, Info) then
    Result := Info.RegData else
    Result := rdUnknown;
end;

procedure TCobRegistryW.GetKeyNames(Strings: TTntStrings);
var
  Len: DWORD;
  I: Integer;
  Info: T_CobRegKeyInfoW;
  S: WideString;
begin
  Strings.Clear;
  if GetKeyInfo(Info) then
  begin
    //SetString(S, nil, Info.MaxSubKeyLen + 1);
    SetLength(S, Info.MaxSubKeyLen + 1);
    for I := 0 to Info.NumSubKeys - 1 do
    begin
      Len := Info.MaxSubKeyLen + 1;
      RegEnumKeyExW(CurrentKey, I, PWideChar(S), Len, nil, nil, nil, nil);
      Strings.Add(PWideChar(S));
    end;
  end;
end;

procedure TCobRegistryW.GetValueNames(Strings: TTntStrings);
var
  Len: DWORD;
  I: Integer;
  Info: T_CobRegKeyInfoW;
  S: WideString;
begin
  Strings.Clear;
  if GetKeyInfo(Info) then
  begin
    SetLength(S, Info.MaxValueLen + 1);
    for I := 0 to Info.NumValues - 1 do
    begin
      Len := Info.MaxValueLen + 1;
      RegEnumValueW(CurrentKey, I, PWideChar(S), Len, nil, nil, nil, nil);
      Strings.Add(PWideChar(S));
    end;
  end;
end;

function TCobRegistryW.HasSubKeys(): Boolean;
var
  Info: T_CobRegKeyInfoW;
begin
  Result := GetKeyInfo(Info) and (Info.NumSubKeys > 0);
end;

function TCobRegistryW.KeyExists(const Key: WideString): Boolean;
var
  TempKey: HKEY;
  OldAccess: Longword;
begin
  OldAccess := FAccess;
  try
    FAccess := STANDARD_RIGHTS_READ or KEY_QUERY_VALUE or KEY_ENUMERATE_SUB_KEYS;
    TempKey := GetKey(Key);
    if TempKey <> 0 then RegCloseKey(TempKey);
    Result := TempKey <> 0;
  finally
    FAccess := OldAccess;
  end;
end;

function TCobRegistryW.LoadKey(const Key, FileName: WideString): Boolean;
var
  S: WideString;
begin
  S := Key;
  if not IsRelative(S) then Delete(S, 1, 1);
  Result := RegLoadKeyW(RootKey, PWideChar(S), PWideChar(FileName)) = ERROR_SUCCESS;
end;

function TCobRegistryW.RegistryConnect(const UNCName: WideString): Boolean;
var
  TempKey: HKEY;
begin
  Result := RegConnectRegistryW(PWideChar(UNCname), RootKey, TempKey) = ERROR_SUCCESS;
  if Result then
  begin
    RootKey := TempKey;
    FCloseRootKey := True;
  end;
end;

function TCobRegistryW.ReplaceKey(const Key, FileName,
  BackUpFileName: WideString): Boolean;
var
  RestoreKey: HKEY;
begin
  Result := False;
  RestoreKey := GetKey(Key);
  if RestoreKey <> 0 then
  try
    Result := RegRestoreKeyW(RestoreKey, PWideChar(FileName), 0) = ERROR_SUCCESS;
  finally
    RegCloseKey(RestoreKey);
  end;
end;

function TCobRegistryW.SaveKey(const Key, FileName: WideString): Boolean;
var
  SaveKey: HKEY;
begin
  Result := False;
  SaveKey := GetKey(Key);
  if SaveKey <> 0 then
  try
    Result := RegSaveKeyW(SaveKey, PWideChar(FileName), nil) = ERROR_SUCCESS;
  finally
    RegCloseKey(SaveKey);
  end;
end;

function TCobRegistryW.UnLoadKey(const Key: WideString): Boolean;
var
  S: WideString;
begin
  S := Key;
  if not IsRelative(S) then Delete(S, 1, 1);
  Result := RegUnLoadKeyW(RootKey, PWideChar(S)) = ERROR_SUCCESS;
end;

end.




