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

// Class to get the needed translated strings

/// An object of this class is created by the interface or
/// the engine. This class contains 2 lists: the list with ENGLISH
/// messages and a list with the current language (if different than english)


unit bmTranslator;

interface

uses TntClasses, SyncObjs, Windows;

type
  TTranslator = class (TObject)
  public
    constructor Create(const Sec: PSECURITYATTRIBUTES;
                       const AppPath, LanguagePath: WideString);
    destructor Destroy(); override;

    /// Loads the list with the current language
    /// if the language is different than english
    procedure LoadLanguage(const Language: WideString);

    /// Get a string (non User Interface related)
    function GetMessage(Index: WideString): WideString;

    /// Get  a string used for the user interface (the label of a control, etc)
    function GetInterfaceText(Index: WideString): WideString;

    // The shell fucntions don't use SetLastError
    function GetShellError(ErrorCode: cardinal): WideString;

  private
    FAppPath: WideString;
    FLanguagePath: WideString;
    FEnglishUI: TTntStringList;
    FEnglishMsg: TTntStringList;
    FCurrentUI: TTntStringList;
    FCurrentMsg: TTntStringList;
    FLanguage: WideString;
    FCritical: TCriticalSection;
    Mutex_Translator: THandle;
    /// Load the english files. Always do that.
    procedure LoadEnglishFiles();

  end;

var
  Translator: TTranslator;

implementation

{ TTranslator }
uses CobCommonW, SysUtils, bmConstants, bmCustomize, TntSysUtils, ShellApi;

constructor TTranslator.Create(const Sec: PSECURITYATTRIBUTES;
                               const AppPath, LanguagePath: WideString);
var
  MN: WideString;
begin
  inherited Create();
  FAppPath := AppPath;
  FLanguagePath := LanguagePath;

  FCritical := TCriticalSection.Create();

  {Create the Mutex
  The user interface and the engine could try to read the
  files at the same time.
  Different threads could try to extract some text at the same time
  so a mutex is necessary}
  if (CobIs2000orBetterW()) then
    MN := WideFormat(WS_TRANSLATORMUTEXNAME, [WS_PROGRAMNAMELONG])
  else
    MN := WideFormat(WS_TRANSLATORMUTEXNAMEOLD, [WS_PROGRAMNAMELONG]);

  Mutex_Translator := CreateMutexW(sec, False, PWideChar(MN));

  //Create the string lists
  FEnglishUI := TTntStringList.Create();
  FEnglishMsg := TTntStringList.Create();
  FCurrentUI := TTntStringList.Create();
  FCurrentMsg := TTntStringList.Create();

  {The english file will always be loaded. This
  is because I may be adding features and I will be
  releasing new versions before the translators adds their strings}

  LoadEnglishFiles();
end;

destructor TTranslator.Destroy();
begin
  FreeAndNil(FCurrentMsg);
  FreeAndNil(FCurrentUI);
  FreeAndNil(FEnglishMsg);
  FreeAndNil(FEnglishUI);

  //close the mutex
  if Mutex_Translator <> 0 then
    CloseHandle(Mutex_Translator);

  Mutex_Translator := 0;

  FreeAndNil(FCritical);

  inherited Destroy();
end;

function TTranslator.GetInterfaceText(Index: WideString): WideString;
begin
  //IMPORTANT. I don't use the critical section here
  //because this part is only used on the Interface
  //for the controls, so only that thread will access
  //this method. When reading the control the form often
  //needs to call this method several times, so it is faster so  (???)

  Result := FCurrentUI.Values[Index];
  if Result = WS_NIL then
    Result := FEnglishUI.Values[Index];
  if Result = WS_NIL then
    Result := WS_STRINGNOFOUND;
end;

function TTranslator.GetMessage(Index: WideString): WideString;
begin
  //This CAN be accesed by several threads at the same time, so protect it!!
  FCritical.Enter();
  try
    Result := FCurrentMsg.Values[Index];
    if Result = WS_NIL then
      Result := FEnglishMsg.Values[Index];
    if Result = WS_NIL then
      Result := WS_STRINGNOFOUND;
  finally
    FCritical.Leave();
  end;

end;

function TTranslator.GetShellError(ErrorCode: cardinal): WideString;
begin
  case ErrorCode of
    0: Result:= GetMessage('182');
    ERROR_BAD_FORMAT    : Result:= GetMessage('185');
    SE_ERR_ACCESSDENIED : Result:= GetMessage('186');
    SE_ERR_ASSOCINCOMPLETE : Result:= GetMessage('187');
    SE_ERR_DDEBUSY       : Result:= GetMessage('188');
    SE_ERR_DDEFAIL       : Result:= GetMessage('189');
    SE_ERR_DDETIMEOUT    : Result:= GetMessage('190');
    SE_ERR_DLLNOTFOUND   : Result:= GetMessage('191');
    SE_ERR_FNF           : Result:= GetMessage('192');
    SE_ERR_NOASSOC       : Result:= GetMessage('193');
    SE_ERR_OOM           : Result:= GetMessage('194');
    SE_ERR_PNF           : Result:= GetMessage('195');
    SE_ERR_SHARE         : Result:= GetMessage('196');
    else
                           Result:= GetMessage('197');
  end;
end;

procedure TTranslator.LoadEnglishFiles();
begin
  if WaitForSingleObject(Mutex_Translator, INFINITE) = WAIT_OBJECT_0 then
  begin
    FCritical.Enter();
    try
      FEnglishUI.Clear;
      FEnglishMsg.Clear;

      if WideFileExists(FLanguagePath + WS_ENGLISH + WS_UIEXTENSION) then
        FEnglishUI.LoadFromFile(FLanguagePath + WS_ENGLISH + WS_UIEXTENSION);

      if WideFileExists(FLanguagePath + WS_ENGLISH + WS_MSGEXTENSION) then
        FEnglishMsg.LoadFromFile(FLanguagePath + WS_ENGLISH + WS_MSGEXTENSION);

    finally
      FCritical.Leave();
      ReleaseMutex(Mutex_Translator);
    end;
  end;
end;

procedure TTranslator.LoadLanguage(const Language: WideString);
begin
  FLanguage := Language;
  if WaitForSingleObject(Mutex_Translator, INFINITE) = WAIT_OBJECT_0 then
  begin
    FCritical.Enter();
    try
      FCurrentUI.Clear;
      FCurrentMsg.Clear;

      // If the language is equal to english then
      // don't load it
      if WideUpperCase(Language) = WideUpperCase(WS_ENGLISH) then
        Exit;

      if WideFileExists(FLanguagePath + FLanguage + WS_UIEXTENSION) then
        FCurrentUI.LoadFromFile(FLanguagePath + FLanguage + WS_UIEXTENSION);

      if WideFileExists(FLanguagePath + FLanguage + WS_MSGEXTENSION) then
        FCurrentMsg.LoadFromFile(FLanguagePath + FLanguage + WS_MSGEXTENSION);

    finally
      FCritical.Leave();
      ReleaseMutex(Mutex_Translator);
    end;
  end;
end;

end.
