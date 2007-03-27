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

// Main form for the decompressor

unit decompressor_Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TntForms, bmCommon, bmTranslator, ComCtrls, TntComCtrls, ToolWin,
  ExtCtrls, TntExtCtrls, ImgList, StdCtrls, TntStdCtrls, CobBarW, ZipForge,
  uSQX_Ctrl, uSQX_Errors, TntDialogs;

const
  INT_AFTERBACKUP = WM_USER + 4563;
type
  Tform_Main = class(TTntForm)
    p_Bottom: TTntPanel;
    tb_Main: TTntToolBar;
    pc_Main: TTntPageControl;
    tab_Files: TTntTabSheet;
    tab_Log: TTntTabSheet;
    lv_Main: TTntListView;
    b_Open: TTntToolButton;
    b_Sep001: TTntToolButton;
    b_ExtractAll: TTntToolButton;
    b_Sep002: TTntToolButton;
    b_Test: TTntToolButton;
    b_Sep003: TTntToolButton;
    b_Abort: TTntToolButton;
    b_Sep004: TTntToolButton;
    b_About: TTntToolButton;
    b_Sep005: TTntToolButton;
    cb_Errors: TTntCheckBox;
    i_Main: TImageList;
    i_MainD: TImageList;
    pb_Main: TCobBarW;
    i_List: TImageList;
    Zip: TZipForge;
    re_Log: TTntRichEdit;
    d_Open: TTntOpenDialog;
    procedure b_AboutClick(Sender: TObject);
    procedure TntFormClose(Sender: TObject; var Action: TCloseAction);
    procedure b_TestClick(Sender: TObject);
    procedure b_AbortClick(Sender: TObject);
    procedure ZipRequestMiddleVolume(Sender: TObject; VolumeNumber: Integer;
      var VolumeFileName: string; var Cancel: Boolean);
    procedure ZipRequestLastVolume(Sender: TObject; var VolumeFileName: string;
      var Cancel: Boolean);
    procedure ZipRequestFirstVolume(Sender: TObject; var VolumeFileName: string;
      var Cancel: Boolean);
    procedure ZipProcessFileFailure(Sender: TObject; FileName: string;
      Operation: TZFProcessOperation; NativeError, ErrorCode: Integer;
      ErrorMessage: string; var Action: TZFAction);
    procedure ZipPassword(Sender: TObject; FileName: string;
      var NewPassword: string; var SkipFile: Boolean);
    procedure ZipOverallProgress(Sender: TObject; Progress: Double;
      Operation: TZFProcessOperation; ProgressPhase: TZFProgressPhase;
      var Cancel: Boolean);
    procedure ZipFileProgress(Sender: TObject; FileName: string;
      Progress: Double; Operation: TZFProcessOperation;
      ProgressPhase: TZFProgressPhase; var Cancel: Boolean);
    procedure ZipConfirmProcessFile(Sender: TObject; FileName: string;
      Operation: TZFProcessOperation; var Confirm: Boolean);
    procedure ZipConfirmOverwrite(Sender: TObject; SourceFileName: string;
      var DestFileName: string; var Confirm: Boolean);
    procedure b_ExtractAllClick(Sender: TObject);
    procedure b_OpenClick(Sender: TObject);
    procedure TntFormDestroy(Sender: TObject);
    procedure TntFormCreate(Sender: TObject);
  private
    { Private declarations }
    FFirstTime: boolean;
    FAppPath: WideString;
    FLanguagePath: WideString;
    FSettingsPath: WideString;
    FUSeLanguage: boolean;
    Fp:PSECURITY_DESCRIPTOR;
    FSec: TSecurityAttributes;
    FS: TFormatSettings;
    FIniFile: WideString;
    FWorking: boolean;
    FOpen: boolean;
    FArchive: WideString;
    FZip: boolean;
    FTotal: integer;
    FSqxInfo: SQX_INFO_STRUCT;
    FHandle: SQX_ARCER_HANDLE;
    FExtractSettings: SQX_EXTRACT_SETTINGS;
    AFL: ARC_FILE_LIST;
    FL: FILE_LIST;
    FTesting: boolean;
    FAbort : boolean;
    FReplace : integer;
    FCounter : integer;
    FBadPassword: boolean;
    FPassword : WideString;
    FErrors: integer;
    FCurrentFile: WideString;
    FDefDirectory: WideString;
    procedure GetInterfaceText();
    procedure CheckUI();
    procedure LoadProperties();
    function GetArchiveName(): WideString;
    function GetArchiveType(): WideString;
    function GetArchiveDate(const Creation: boolean): WideString;
    function FileTimeToDateTime(const ft: TFileTime): WideString;
    function GetNumberOfFiles(): WideString;
    function GetTotalSize(Compressed: boolean): WideString;
    function RecoveryDataPresent(): WideString;
    function GetSolidArchive(): WideString;
    procedure Initialize();
    procedure Log(const Msg: WideString; Error: boolean; Important: boolean = false);
    procedure CloseArchive();
    procedure CloseZip();
    procedure CloseSQX();
    function OpenArchive(): boolean;
    function OpenZip(): boolean;
    function OpenSqx(): boolean;
    /// The callback function
    function Callback(var SqxCallbackStruct: SQX_CALLBACK_STRUCT): longint;
    /// Extract the zip archive
    procedure ExtractZip(Destination: WideString);
    procedure ExtractSQX(Destination: WideString);
    procedure TestZip();
    procedure TestSQX();
    function SpecialDialog(const Prompt,Caption: WideString): integer;
    /// Enter the password
    procedure GetPassword(FileName: WideString);
    function GetPart(var VolumeFileName: AnsiString): boolean;
    procedure LoadSettings();
    procedure WriteSettings();
  protected
    procedure AfterCreate(var Msg: Tmessage); message INT_AFTERBACKUP;
  public
    { Public declarations }
  end;

var
  form_Main: Tform_Main;
  Translator: TTranslator;

implementation

{$R *.dfm}
uses TntSystem, CobCommonW, bmConstants, TntSysUtils, bmCustomize,
  decompressor_Constants, TntClasses,CobDialogsW, decompressor_MessageBoxEx,
  decompressor_Password, decompressor_About;


//******************************************************************************
// The callback procedure for SQX

function SqxCallBackProc(lpVoid: pointer;
  var CallBackStruct: SQX_CALLBACK_STRUCT): SLONG32; stdcall;
begin
  Result := Tform_Main(lpvoid).Callback(CallBackStruct);
end;

procedure Tform_Main.AfterCreate(var Msg: Tmessage);
begin
  if (FFirstTime) then
  begin
    GetInterfaceText();
    CheckUI();
    LoadProperties();
    FFirstTime:= false;
  end;
end;

procedure Tform_Main.b_AbortClick(Sender: TObject);
var
  Msg: WideString;
begin
  if (FUSeLanguage) then
    Msg:= Translator.GetMessage('534') else
    Msg:= DS_ABORTOP;
  if (CobMessageBoxW( self.Handle,Msg, WS_PROGRAMNAMESHORT, MB_YESNO) = mrYes) then
    FAbort:= true;
end;

procedure Tform_Main.b_AboutClick(Sender: TObject);
var
  About: Tform_About;
begin
  About:= Tform_About.Create(nil);
  try
    if (FUSeLanguage) then
    begin
      About.Caption:= Translator.GetMessage('543');
      About.l_Tool.Caption:= Translator.GetMessage('541');
      About.l_Rights.Caption:= Translator.GetMessage('542');
    end else
    begin
      About.Caption:= DS_ABOUTDEC;
      About.l_Tool.Caption:= DS_DECOMPRESSION;
      About.l_Rights.Caption:= DS_ALLRIGHTS;
    end;

    About.l_Name.Caption:= WS_PROGRAMNAMESHORT;
    About.l_Version.Caption:= CobGetVersionW(WS_NIL);
    About.l_Copyright.Caption:= WideFormat(DS_COPYRIGHT,[WS_AUTHORLONG],FS);
    About.l_Web.Caption:= WS_AUTHORWEB;
    About.ShowModal();
  finally
    About.Release();
  end;
end;

procedure Tform_Main.b_ExtractAllClick(Sender: TObject);
var
  ACaption, Dir: WideString;
begin
  if not FOpen then
    Exit;

  if FWorking then
    Exit;

  if FUseLanguage then
    ACaption := Translator.GetMessage('524')
  else
    ACaption := DS_SELECTDIR;

  Dir:= FDefDirectory;

  if CobSelectDirectoryW(ACaption, WS_NIL, Dir, [csdNewFolder, csdNewUI]) then
    if Dir <> S_NIL then
    begin
      FDefDirectory:= Dir;
      re_Log.Clear();
      FTesting := false;
      if FZip then
        ExtractZip(Dir)
      else
        ExtractSQX(Dir);
    end;
end;

procedure Tform_Main.b_OpenClick(Sender: TObject);
begin
  if (FOpen) then
    CloseArchive();

  d_Open.FilterIndex:= 1;

  if (d_Open.Execute) then
  begin
    FArchive := d_Open.FileName;
    FZip := true;
    if WideLowerCase(WideExtractFileExt(FArchive)) = WS_SQXEXT then
      FZip := false;
    FOpen := OpenArchive();
    FWorking:= false;
    LoadProperties();
    CheckUI();
    pc_Main.ActivePage:= tab_Files;
  end; 
end;

procedure Tform_Main.b_TestClick(Sender: TObject);
begin
  if not FOpen then
    Exit;

  if FWorking then
    Exit;

  FTesting := true;

  re_Log.Clear();
  if FZip then
    TestZip()
  else
    TestSQX();
end;

function Tform_Main.Callback(
  var SqxCallbackStruct: SQX_CALLBACK_STRUCT): longint;
var
  Msg: WideString;
  Percent: integer;
begin
  Result := 1;

  if FAbort then
  begin
    Result := 0;
    Exit;
  end;

  if (SqxCallbackStruct.uAction = SQX_ACTION_PREPARE_EXTRACT) then
  begin
    // A file is about to be tested or extracted

    FCurrentFile := WideString(SqxCallbackStruct.szString);

    if FUseLanguage then
    begin
      if FTesting then
        Msg := WideFormat(Translator.GetMessage('528'), [FCurrentFile], FS)
      else
        Msg := WideFormat(Translator.GetMessage('529'), [FCurrentFile],FS);
    end
    else
    begin
      if FTesting then
        Msg := WideFormat(DS_TESTING, [FCurrentFile],FS)
      else
        Msg := WideFormat(DS_UNZIPPING, [FCurrentFile], FS);
    end;

    Log(Msg, false);

    inc(FCounter);

    Exit;
  end;

  if (SqxCallbackStruct.uAction = SQX_ACTION_NEED_NEXT_VOLUME) then
  begin
    //could not find the next part

    if FUseLanguage then
      d_Open.Title := WideFormat(Translator.GetMessage('533'),
        [WideExtractFileName(WideString(SqxCallbackStruct.szString2))])
    else
      d_Open.Title := WideFormat(DS_SELECTPART,
        [WideExtractFileName(WideString(SqxCallbackStruct.szString2))],FS);

    d_Open.FilterIndex := 2;
    d_Open.FileName := WideString(SqxCallbackStruct.szString2);

    if d_Open.Execute() then
      StrPCopy(SqxCallbackStruct.szString2, AnsiString(d_Open.FileName))
    else
    begin
      FAbort := true;
      Result := INT_NIL;
    end;

    Log(SqxCallbackStruct.szString2, false);
    Exit;
  end;

  if (SqxCallbackStruct.uAction = SQX_ACTION_FINISH_EXTRACT) then
  begin
    // A file has been  extracted  or tested
    Exit;
  end;

  if (SqxCallbackStruct.uAction = SQX_ACTION_NEED_CRYPT_KEY) then
  begin
    if FUseLanguage then
      Msg := WideFormat(Translator.GetMessage('530'), [WideString(SqxCallbackStruct.szString)])
    else
      Msg := WideFormat(DS_BADPASSWORD, [WideString(SqxCallbackStruct.szString)]);

    if FBadPassword then
    begin
      Result := INT_NIL;
      FAbort := true;
      Log(Msg, true);
      Inc(FErrors);
      Exit;
    end;

    if FPassword = WS_NIL then
      GetPassword(WideString(SqxCallbackStruct.szString));

    if FPassword = WS_NIL then
    begin
      Result := INT_NIL;
      FAbort := true;
      FBadPassword := true;
      Log(Msg, true);
      Inc(FErrors);
      Exit;
    end;

    StrPCopy(SqxCallbackStruct.szString2, AnsiString(FPassword));

    Exit;
  end;

  if (SqxCallbackStruct.uAction = SQX_ACTION_FILE_SKIP) then
  begin
    // A file couldn't be copied

    Inc(FErrors);

    if FUseLanguage then
      Msg := WideFormat(Translator.GetMessage('538'), [WideString(SqxCallbackStruct.szString)],FS)
    else
      Msg := WideFormat(DS_ERRORSQX, [WideString(SqxCallbackStruct.szString)],FS);
    Log(Msg, true);

    Exit;
  end;

  if (SqxCallbackStruct.uAction = SQX_ACTION_PROGRESS) then
  begin
    // A percent on the file, not on the total

    FCurrentFile := WideString(SqxCallbackStruct.szString);

    if FTotal > 0 then
      Percent := Trunc((FCounter / FTotal) * 100)
    else
      Percent := INT_NIL;

    pb_Main.Position := Percent;

    Application.ProcessMessages();

    Exit;
  end;

  if (SqxCallbackStruct.uAction = SQX_ACTION_FILE_REPLACE) then
  begin
    // A file his about to replace an existing one
    if FUseLanguage then
      Msg := WideFormat(Translator.GetMessage('527'),
                          [WideExtractFileName(WideString(SqxCallbackStruct.szString2))],FS)
    else
      Msg := WideFormat(DS_OVERWRITE,
                          [WideExtractFileName(WideString(SqxCallbackStruct.szString2))],FS);

    if FReplace = mrYesToAll then
    begin
      Result := 2;
      Exit;
    end;

    if (FReplace = mrNoToAll) or (FReplace = mrCancel) then
    begin
      Result := 1;
      Exit;
    end;

    FReplace := SpecialDialog(Msg, WS_PROGRAMNAMESHORT);

    if (FReplace = mrYesToAll) or (FReplace = mrYes) then
    begin
      Result := 2;
      Exit;
    end;

    if (FReplace = mrNoToAll) or (FReplace = mrNo) then
    begin
      Result := 1;
      Exit;
    end;

    if (FReplace = mrCancel) then
    begin
      Result := 0;
      FAbort := true;
      Exit;
    end;

    Exit;
  end;

end;


procedure Tform_Main.CheckUI();
begin
  b_Open.Enabled:= not FWorking;
  b_ExtractAll.Enabled:= FOpen and not FWorking;
  b_Test.Enabled:= FOpen and not FWorking;
  b_Abort.Enabled:= FOpen and FWorking;
end;

procedure Tform_Main.CloseArchive();
begin
  if FZip then
    CloseZip()
  else
    CloseSQX();
end;

procedure Tform_Main.CloseSQX();
begin
  FOpen := false;
  FArchive := S_NIL;
  LoadProperties();
  CheckUI();
  SqxDoneArcFileList(FHandle, AFL);
  SqxDoneFileList(FHandle, FL);
  SqxFree(FHandle);
end;

procedure Tform_Main.CloseZip();
begin
  FOpen := false;
  FArchive := WS_NIL;
  LoadProperties();
  CheckUI();
  Zip.CloseArchive();
end;

procedure Tform_Main.ExtractSQX(Destination: WideString);
var
  Msg: WideString;
  ADestination: AnsiString;
  lRes: integer;
begin
  FAbort := false;
  FReplace := INT_NIL;
  FCounter := INT_NIL;
  FPassword := S_NIL;
  FWorking := true;
  pc_Main.ActivePage := tab_Log;
  FBadPassword := false;
  FErrors := INT_NIL;
  ADestination:= AnsiString(Destination);
  StrPCopy(FExtractSettings.szOutPutPath, ADestination);
  CheckUI();

  lRes := SqxExtractFiles(FHandle, AnsiString(FArchive), FL, FExtractSettings,
    SqxCallBackProc, Self);

  if (lRes <> SQX_EC_OK) then
    inc(FErrors);

  if FUseLanguage then
    Msg := WideFormat(Translator.GetMessage('525'), [FCounter], FS) else
    Msg := WideFormat(DS_EXTRACTEDFILES, [FCounter], FS);

  Log(Msg, false, true);

  if FUseLanguage then
    Msg := WideFormat(Translator.GetMessage('526'), [FErrors], FS) else
    Msg := WideFormat(DS_ERRORS, [FErrors], FS);

  Log(Msg, FErrors <> INT_NIL, true);

  if (lRes <> SQX_EC_OK) then
    if FUseLanguage then
      Log(Translator.GetMessage('536'), true)
    else
      Log(DS_SQXERROR, true);

  FWorking := false;
  pb_Main.Position:= 0;
  CheckUI();
end;

procedure Tform_Main.ExtractZip(Destination: WideString);
var
  Msg: string;
begin
  FAbort := false;
  FReplace := INT_NIL;
  FCounter := INT_NIL;
  FPassword := WS_NIL;
  FWorking := true;
  pc_Main.ActivePage := tab_Log;
  Zip.FileMasks.Clear();
  Zip.FileMasks.Add(WideString(WS_ALLFILES));
  Zip.BaseDir := AnsiString(Destination);
  FBadPassword := false;
  FErrors := INT_NIL;
  try
    Zip.ExtractFiles();
  finally
    if FUseLanguage then
      Msg := WideFormat(Translator.GetMessage('525'), [FCounter], FS)
    else
      Msg := WideFormat(DS_EXTRACTEDFILES, [FCounter], FS);

    Log(Msg, false, true);

    if FUseLanguage then
      Msg := WideFormat(Translator.GetMessage('526'), [FErrors], FS)
    else
      Msg := WideFormat(DS_ERRORS, [FErrors], FS);

    Log(Msg, FErrors <> INT_NIL, true);

    FWorking := false;
    pb_Main.Position:= 0;
    CheckUI();
  end;
end;

function Tform_Main.FileTimeToDateTime(const ft: TFileTime): WideString;
var
  SysTime: TSystemTime;
begin
  FileTimeToSystemTime(ft, SysTime);
  with SysTime do
    Result := WideString(DateTimeToStr(EncodeDate(wYear, wMonth, wDay)
      + EncodeTime(wHour, wMinute, WSecond, wMilliseconds)));
end;

function Tform_Main.GetArchiveDate(const Creation: boolean): WideString;
var
  SR: TSearchRecW;
begin
  Result := WS_NIL;
  if not FOpen then
    Exit;

  if WideFindFirst(FArchive, faAnyFile, SR) = INT_NIL then
  begin
    if Creation then
      Result := FileTimeToDateTime(SR.FindData.ftCreationTime)
    else
      Result := FileTimeToDateTime(SR.FindData.ftLastWriteTime);
    WideFindClose(SR);
  end;
end;

function Tform_Main.GetArchiveName(): WideString;
begin
  if (FOpen) then
    Result:= FArchive else
    Result:= WS_NIL;
end;

function Tform_Main.GetArchiveType: WideString;
begin
  if (FOpen) then
  begin
    if (FZip) then
      Result:= DS_ZIP else
      Result:= DS_SQX;
  end else
  Result:= WS_NIL;
end;

function Tform_Main.GetNumberOfFiles(): WideString;
begin
  Result := WS_NIL;
  if not FOpen then
    Exit;

  if FZip then
    Result := CobIntToStrW(Zip.FileCount)
  else
  begin
    FTotal := FSqxInfo.lTotalFiles;
    Result := CobIntToStrW(FTotal);
  end;
end;

function Tform_Main.GetPart(var VolumeFileName: AnsiString): boolean;
begin
  Result:= true;
  if WideFileExists(WideString(VolumeFileName)) then
    Exit;

  if FAbort then
  begin
    Result := false;
    Exit;
  end;

  if FUseLanguage then
    d_Open.Title := WideFormat(Translator.GetMessage('533'),
      [WideExtractFileName(WideString(VolumeFileName))])
  else
    d_Open.Title := WideFormat(DS_SELECTPART,
      [WideExtractFileName(WideString(VolumeFileName))]);

  d_Open.FilterIndex := 2;
  d_Open.FileName := WideString(VolumeFileName);

  if d_Open.Execute then
    VolumeFileName := AnsiString(d_Open.FileName)
  else
  begin
    FAbort := true;
    Result := false;
  end;
end;

procedure Tform_Main.GetPassword(FileName: WideString);
var
  form_Password: Tform_Password;
begin
  form_Password := Tform_Password.Create(nil);
  try
    form_Password.Caption := WS_PROGRAMNAMESHORT;
    if FUseLanguage then
    begin
      form_Password.l_Password.Caption := Translator.GetMessage('531');
      form_Password.l_FileName.Caption:= FileName;
      form_Password.b_OK.Caption := Translator.GetInterfaceText('B_OK');
      form_Password.b_Cancel.Caption := Translator.GetInterfaceText('B_CANCEL');
    end
    else
    begin
      form_Password.l_Password.Caption := DS_ENTERPASSWORD;
      form_Password.l_FileName.Caption:= FileName;
      form_Password.b_OK.Caption := DS_OK;
      form_Password.b_Cancel.Caption := DS_CANCEL;
    end;

    form_Password.ShowModal();

    FPassword := WS_NIL;

    if form_Password.Tag = INT_MODALRESULTOK then
      FPassword := form_Password.e_Password.Text;

  finally
    form_Password.Release();
  end;
end;

function Tform_Main.GetSolidArchive(): WideString;
begin
  Result := WS_NIL;
  if not Fopen then
    Exit;

  if FZip then
  begin
    if FUseLanguage then
      Result := Translator.GetInterfaceText('675')
    else
      Result := DS_NOTAVAILBALE;
  end
  else
  begin
    if FSqxInfo.lSolidFlag = OPTION_NONE then
    begin
      if FUseLanguage then
        Result := Translator.GetMessage('S_NO')
      else
        Result := DS_NO;
    end
    else
    begin
      if FUseLanguage then
        Result := Translator.GetMessage('S_YES')
      else
        Result := DS_YES;
    end;
  end;
end;

function Tform_Main.GetTotalSize(Compressed: boolean): WideString;
begin
  Result := WS_NIL;
  if not FOpen then
    Exit;

  if FZip then
  begin
    if Compressed then
      Result := CobFormatSizeW(Zip.Size)
    else if FUseLanguage then
      Result := Translator.GetInterfaceText('672')
    else
      Result := DS_UNKNOWN;
  end
  else
  begin
    if Compressed then
      Result := CobFormatSizeW(FSqxInfo.l64ArcCompressedSize)
    else
      Result := CobFormatSizeW(FSqxInfo.l64ArcUncompressedSize);
  end;
end;

procedure Tform_Main.Initialize();
begin
  FUSeLanguage := false;
  FWorking := false;
  FOpen := false;
  FFirstTime := true;
  FIniFile := FSettingsPath + WideChangeFileExt(WideExtractFileName(WideParamStr(0)), WS_INIEXT);
  Width:= DS_INT600;
  Height:= DS_INT400;
  lv_Main.Columns[0].Width := (Width div 2) - 15;
  lv_Main.Columns[1].Width := (Width div 2) - 15;
  pb_Main.Position := 0;
  FArchive := WS_NIL;
  cb_Errors.Checked := false;
  pc_Main.ActivePage:= tab_Files;
  FZip:= true;
  FTesting:= false;
end;

procedure Tform_Main.GetInterfaceText();
begin
  if (FUSeLanguage) then
  begin
    Caption:= WideFormat(Translator.GetInterfaceText('655'),[WS_PROGRAMNAMESHORT],FS);
    TntApplication.Title:= Caption;
    tab_Files.Caption:= Translator.GetInterfaceText('656');
    tab_Log.Caption:= Translator.GetInterfaceText('657');
    lv_Main.Columns[0].Caption:= Translator.GetInterfaceText('658');
    lv_Main.Columns[1].Caption:= Translator.GetInterfaceText('659');
    b_Open.Hint:= Translator.GetInterfaceText('660');
    b_ExtractAll.Hint:= Translator.GetInterfaceText('661');
    b_Test.Hint:= Translator.GetInterfaceText('662');
    b_Abort.Hint:= Translator.GetInterfaceText('663');
    b_About.Hint:= WideFormat(Translator.GetInterfaceText('664'),[WS_PROGRAMNAMESHORT],FS);
    cb_Errors.Caption:= Translator.GetInterfaceText('677');
    cb_Errors.Hint:= Translator.GetInterfaceText('665');
    d_Open.Title:= Translator.GetInterfaceText('678');
    d_Open.Filter:= WideFormat(DS_FILTER,[Translator.GetInterfaceText('679'),
                                          Translator.GetInterfaceText('680')],FS);
  end else
  begin
    Caption:= WideFormat(DS_CAPTION,[WS_PROGRAMNAMESHORT],FS);
    tab_Files.Caption:= DS_FILES;
    tab_Log.Caption:= DS_LOG;
    lv_Main.Columns[0].Caption:= DS_PROPERTY;
    lv_Main.Columns[1].Caption:= DS_VALUE;
    b_Open.Hint:= DS_OPENARCHIVE;
    b_ExtractAll.Hint:= DS_EXTRACTALL;
    b_Test.Hint:= DS_TEST;
    b_Abort.Hint:= DS_ABORT;
    b_About.Hint:= WideFormat(DS_ABOUT,[WS_PROGRAMNAMESHORT],FS);
    cb_Errors.Caption:= DS_ERRORSONLY;
    cb_Errors.Hint:= DS_ERRORSONLYHINT;
    d_Open.Title:= DS_OPENARCHIVETITLE;
    d_Open.Filter:= WideFormat(DS_FILTER,[DS_ARCHIVES, DS_ALLFILES],FS);
  end;
end;

procedure Tform_Main.LoadProperties();
var
  Item: TTntListItem;
begin
  lv_Main.Clear();

  Item:= lv_Main.Items.Add();
  if (FUseLanguage) then
    Item.Caption:= Translator.GetInterfaceText('666') else
    Item.Caption:= DS_ARCHIVENAME;
  Item.ImageIndex:= INT_NIL;
  Item.SubItems.Add(GetArchiveName());

  Item:= lv_Main.Items.Add();
  if (FUseLanguage) then
    Item.Caption:= Translator.GetInterfaceText('667') else
    Item.Caption:= DS_ARCHIVETYPE;
  Item.ImageIndex:= INT_NIL;
  Item.SubItems.Add(GetArchiveType());


  Item:= lv_Main.Items.Add();
  if (FUseLanguage) then
    Item.Caption:= Translator.GetInterfaceText('668') else
    Item.Caption:= DS_CREATIONDATE;
  Item.ImageIndex:= INT_NIL;
  Item.SubItems.Add(GetArchiveDate(true));

  Item:= lv_Main.Items.Add();
  if (FUseLanguage) then
    Item.Caption:= Translator.GetInterfaceText('669') else
    Item.Caption:= DS_LASTMODIFIED;
  Item.ImageIndex:= INT_NIL;
  Item.SubItems.Add(GetArchiveDate(false));


  Item:= lv_Main.Items.Add();
  if (FUseLanguage) then
    Item.Caption:= Translator.GetInterfaceText('670') else
    Item.Caption:= DS_NUMBEROFFILES;
  Item.ImageIndex:= INT_NIL;
  Item.SubItems.Add(GetNumberOfFiles());

  Item:= lv_Main.Items.Add();
  if (FUseLanguage) then
    Item.Caption:= Translator.GetInterfaceText('671') else
    Item.Caption:= DS_TOTALCOMPRESSED;
  Item.ImageIndex:= INT_NIL;
  Item.SubItems.Add(GetTotalSize(true));

  Item:= lv_Main.Items.Add();
  if (FUseLanguage) then
    Item.Caption:= Translator.GetInterfaceText('673') else
    Item.Caption:= DS_TOTALUNCOMPRESSED;
  Item.ImageIndex:= INT_NIL;
  Item.SubItems.Add(GetTotalSize(false));

  Item:= lv_Main.Items.Add();
  if (FUseLanguage) then
    Item.Caption:= Translator.GetInterfaceText('674') else
    Item.Caption:= DS_RECOVERYDATAPRESENT;
  Item.ImageIndex:= INT_NIL;
  Item.SubItems.Add(RecoveryDataPresent());

  Item:= lv_Main.Items.Add();
  if (FUseLanguage) then
    Item.Caption:= Translator.GetInterfaceText('676') else
    Item.Caption:= DS_SOLIDARCHIVE;
  Item.ImageIndex:= INT_NIL;
  Item.SubItems.Add(GetSolidArchive());
end;

procedure Tform_Main.Log(const Msg: WideString; Error: boolean; Important: boolean = false);
var
  AMsg: WideString;
begin
  if cb_Errors.Checked then
    if (not Error) and (not Important) then
      Exit;

  if Error then
    AMsg := WS_ERROR + ' ' +  Msg
  else
    AMsg := WS_NOERROR + ' '+  Msg;

  if Error then
    re_Log.SelAttributes.Color := clred
  else
    re_Log.SelAttributes.Color := clWindowText;
  re_Log.Lines.Add(AMsg);
  re_Log.Perform(EM_LINESCROLL, 0, re_Log.Lines.Count - 5);
  Application.ProcessMessages();
end;

function Tform_Main.OpenArchive(): boolean;
begin
  if FZip then
    Result := OpenZip()
  else
    Result := OpenSQX();
end;

function Tform_Main.OpenSqx(): boolean;
var
  lRes: integer;
  Msg: WideString;
begin

  Result := false;

  // Load the library
  lRes := SqxLoad(FHandle, S_NIL);
  if (lRes <> SQX_EC_OK) then
  begin
    if FUseLanguage then
      Msg := Translator.GetMessage('521')
    else
      Msg := DS_OPENSQXFAILED;

    CobShowMessageW(self.Handle, Msg, WS_PROGRAMNAMESHORT);
    Log(Msg, true);
    Exit;
  end;

  //- init the file list
  SqxInitFileList(FHandle, FL);

  //- we want to list all files
  lRes := SqxAddFileList(FHandle, AnsiString(WS_ALLFILES), FL);
  if (lRes <> SQX_EC_OK) then
  begin
    //- error
    SqxFree(FHandle);
    if FUseLanguage then
      Msg := Translator.GetMessage('522')
    else
      Msg := DS_LISTSQXFAILED;

    CobShowMessageW(self.Handle, Msg, WS_PROGRAMNAMESHORT);
    Log(Msg, true);
    Exit;
  end;

  //- init the arcfile list
  SqxInitArcFileList(FHandle, AFL);

  FillChar(FExtractSettings, SizeOf(SQX_EXTRACT_SETTINGS), #0);
  FExtractSettings.lCreateDirs := OPTION_SET;
  FExtractSettings.uStructSize := SizeOf(SQX_EXTRACT_SETTINGS);

  //- list the files ....
  lRes := SqxListFiles(FHandle, AnsiString(FArchive), FL, AFL, FSqxInfo, FExtractSettings,
    SqxCallBackProc, Self);
  if (lRes <> SQX_EC_OK) then
  begin
    //- error
    SqxDoneArcFileList(FHandle, AFL);
    SqxDoneFileList(FHandle, FL);
    SqxFree(FHandle);
    if FUseLanguage then
      Msg := Translator.GetMessage('522')
    else
      Msg := DS_LISTSQXFAILED;

    CobShowMessageW(self.Handle, Msg, WS_PROGRAMNAMESHORT);
    Log(Msg, true);
    Exit;
  end;

  if (FUSeLanguage) then
    Log(WideFormat(Translator.GetMessage('523'),[FArchive],FS), false) else
    Log(WideFormat(DS_ARCHIVEOPEN,[FArchive],FS), false);
  Result := true;
end;
function Tform_Main.OpenZip(): boolean;
begin
  Result := true;
  try
    Zip.Password := S_NIL;
    Zip.FileName := AnsiString(FArchive);
    Zip.OpenArchive();
    if (FUSeLanguage) then
      Log(WideFormat(Translator.GetMessage('523'),[FArchive],FS),false) else
      Log(WideFormat(DS_ARCHIVEOPEN,[FArchive],FS),false);
  except
    on E: Exception do
    begin
      Result := false;
      CobShowMessageW(self.Handle, WideString(E.Message), WS_PROGRAMNAMESHORT);
      Log(WideString(E.Message), true);
    end;
  end;
end;

procedure Tform_Main.LoadSettings();
var
  Sl: TTntStringList;
begin
  Sl:= TTntStringList.Create();
  try
    if (WideFileExists(FIniFile)) then
    begin
      Sl.LoadFromFile(FIniFile);
      self.Width:= CobStrToIntW(Sl.Values[DS_INIWIDTH], DS_INT600);
      self.Height:= CobStrToIntW(Sl.Values[DS_INIHEIGHT], DS_INT400);
      self.Left:= CobStrToIntW(Sl.Values[DS_INILEFT], DS_INT10);
      self.Top:= CobStrToIntW(Sl.Values[DS_INITOP], DS_INT10);
      lv_Main.Columns[0].Width:= CobStrToIntW(Sl.Values[DS_INICOLUMN0], self.Width div 2 - 10);
      lv_Main.Columns[1].Width:= CobStrToIntW(Sl.Values[DS_INICOLUMN1], self.Width div 2 - 10);
      FDefDirectory:= Sl.Values[DS_INIDEFAULTDIRECTORY];
    end else
    self.Position:= poScreenCenter;
  finally
    FreeAndNil(Sl);
  end;
end;

function Tform_Main.RecoveryDataPresent: WideString;
begin
  Result := WS_NIL;
  if not Fopen then
    Exit;

  if FZip then
  begin
    if FUseLanguage then
      Result := Translator.GetInterfaceText('675')
    else
      Result := DS_NOTAVAILBALE;
  end
  else
  begin
    if FSqxInfo.lRecoveryLevel > 0 then
    begin
      if FUseLanguage then
        Result := Translator.GetMessage('S_YES')
      else
        Result := DS_YES;
    end
    else
    begin
      if FUseLanguage then
        Result := Translator.GetMessage('S_NO')
      else
        Result := DS_NO;
    end;
  end;
end;


function Tform_Main.SpecialDialog(const Prompt, Caption: WideString): integer;
var
  Dlg: Tform_MessageBoxEx;
begin
  // This creates a special dialog containing the Yes to all and No to all buttons
  Dlg:= Tform_MessageBoxEx.Create(nil);
  try
    Dlg.Caption:= Caption;
    Dlg.l_Prompt.Caption:= Prompt;
    if (FUSeLanguage) then
    begin
      Dlg.b_Yes.Caption:= Translator.GetInterfaceText('681');
      Dlg.b_YesToAll.Caption := Translator.GetInterfaceText('683');
      Dlg.b_No.Caption:= Translator.GetInterfaceText('682');
      Dlg.b_NoToAll.Caption:= Translator.GetInterfaceText('684');
      Dlg.b_Cancel.Caption:= Translator.GetInterfaceText('685');
    end else
    begin
      Dlg.b_Yes.Caption:= DS_BYES;
      Dlg.b_YesToAll.Caption := DS_BYESTOALL;
      Dlg.b_No.Caption:= DS_BNO;
      Dlg.b_NoToAll.Caption:= DS_BNOTOALL;
      Dlg.b_Cancel.Caption:= DS_BCANCEL;
    end;
    Dlg.ShowModal();
    Result:= Dlg.Tag;
  finally
    Dlg.Release();
  end;
end;

procedure Tform_Main.TestSQX();
var
  lRes: integer;
  Msg: WideString;
begin
  FAbort := false;
  FReplace := INT_NIL;
  FCounter := INT_NIL;
  FPassword := S_NIL;
  FWorking := true;
  pc_Main.ActivePage := tab_Log;
  FBadPassword := false;
  FErrors := INT_NIL;
  CheckUI();

  lRes := SqxTestFiles(FHandle, AnsiString(FArchive), SqxCallBackProc, Self);

  if (lRes <> SQX_EC_OK) then
    Inc(FErrors);

  if FUseLanguage then
    Msg := WideFormat(Translator.GetMessage('535'), [FCounter], FS) else
    Msg := WideFormat(DS_TESTEDFILES, [FCounter], FS);

  Log(Msg, false, true);

  if FUseLanguage then
    Msg := WideFormat(Translator.GetMessage('526'), [FErrors], FS) else
    Msg := WideFormat(DS_ERRORS, [FErrors], FS);

  Log(Msg, FErrors <> INT_NIL, true);

  if (lRes <> SQX_EC_OK) then
    if FUseLanguage then
      Log(Translator.GetMessage('537'), true)
    else
      Log(DS_SQXCORRUPTED, true);

  FWorking := false;
  pb_Main.Position:= 0;
  CheckUI();
end;

procedure Tform_Main.TestZip();
var
  Msg: WideString;
begin
  FAbort := false;
  FReplace := INT_NIL;
  FCounter := INT_NIL;
  FPassword := WS_NIL;
  FWorking := true;
  pc_Main.ActivePage := tab_Log;
  Zip.FileMasks.Clear();
  Zip.FileMasks.Add(AnsiString(WS_ALLFILES));
  Zip.BaseDir := S_NIL;
  FBadPassword := false;
  FErrors := INT_NIL;
  try
    Zip.TestFiles();
  finally
    if FUseLanguage then
      Msg := WideFormat(Translator.GetMessage('535'), [FCounter], FS)
    else
      Msg := WideFormat(DS_TESTEDFILES, [FCounter], FS);

    Log(Msg, false, true);

    if FUseLanguage then
      Msg := WideFormat(Translator.GetMessage('526'), [FErrors], FS)
    else
      Msg := WideFormat(DS_ERRORS, [FErrors], FS);

    Log(Msg, FErrors <> INT_NIL, true);

    FWorking := false;
    pb_Main.Position:= 0;
    CheckUI();
  end;
end;

procedure Tform_Main.TntFormClose(Sender: TObject; var Action: TCloseAction);
begin
  WriteSettings();
end;

procedure Tform_Main.TntFormCreate(Sender: TObject);
var
  UIName, MSName, Language: WideString;
begin
  FAppPath:= CobSetBackSlashW(CobGetAppPathW());
  FLanguagePath:= CobSetBackSlashW(FAppPath + WS_DIRLANG);
  FSettingsPath:=  CobSetBackSlashW(FAppPath + WS_DIRSETTINGS);
  FSec:= CobGetNullDaclAttributesW(Fp);
  Translator:= TTranslator.Create(@FSec, FAppPath, FLanguagePath);
  Initialize();
  GetLocaleFormatSettings(LOCALE_SYSTEM_DEFAULT, FS);
  if (WideParamCount > 0) then
  begin
    Language:= WideParamStr(1);
    UIName:= FLanguagePath + Language + WS_UIEXTENSION;
    MSName:= FLanguagePath + Language + WS_MSGEXTENSION;
    if (WideFileExists(UIName) and WideFileExists(MSName)) then
    begin
      FUSeLanguage:= true;
      Translator.LoadLanguage(Language);
    end;
  end;

  LoadSettings();

  PostMessageW(self.Handle, INT_AFTERBACKUP, 0, 0);
end;

procedure Tform_Main.TntFormDestroy(Sender: TObject);
begin
  FreeAndNil(Translator);
  CobFreeNullDaclAttributesW(Fp);
end;

procedure Tform_Main.WriteSettings();
var
  Sl: TTntStringList;
begin
  if (not WideDirectoryExists(FSettingsPath)) then
    WideCreateDir(FSettingsPath);

  if (WideDirectoryExists(FSettingsPath)) then
    begin
      Sl:= TTntStringList.Create();
      try
        Sl.Add(WideFormat(WS_INIFORMAT,[DS_INILEFT,CobIntToStrW(self.Left)],FS));
        Sl.Add(WideFormat(WS_INIFORMAT,[DS_INITOP,CobIntToStrW(self.Top)],FS));
        Sl.Add(WideFormat(WS_INIFORMAT,[DS_INIWIDTH,CobIntToStrW(self.Width)],FS));
        Sl.Add(WideFormat(WS_INIFORMAT,[DS_INIHEIGHT,CobIntToStrW(self.Height)],FS));
        Sl.Add(WideFormat(WS_INIFORMAT,[DS_INICOLUMN0,CobIntToStrW(lv_Main.Columns[0].Width)],FS));
        Sl.Add(WideFormat(WS_INIFORMAT,[DS_INICOLUMN1,CobIntToStrW(lv_Main.Columns[1].Width)],FS));
        Sl.Add(WideFormat(WS_INIFORMAT,[DS_INIDEFAULTDIRECTORY,FDefDirectory],FS));
        Sl.SaveToFile(FIniFile);
      finally
        FreeAndNil(Sl);
      end;
    end;
end;

procedure Tform_Main.ZipConfirmOverwrite(Sender: TObject;
  SourceFileName: string; var DestFileName: string; var Confirm: Boolean);
var
  ACaption: WideString;
begin
  if FUseLanguage then
    ACaption := WideFormat(Translator.GetMessage('527'), [WideString(WideExtractFileName(DestFileName))])
  else
    ACaption := WideFormat(DS_OVERWRITE, [WideExtractFileName(WideString(DestFileName))]);

  if FReplace = mrYesToAll then
  begin
    Confirm := true;
    Exit;
  end;

  if (FReplace = mrNoToAll) or (FReplace = mrCancel) then
  begin
    Confirm := false;
    Exit;
  end;

  FReplace := SpecialDialog(ACaption, WS_PROGRAMNAMESHORT);

  if (FReplace = mrYesToAll) or (FReplace = mrYes) then
  begin
    Confirm := true;
    Exit;
  end;

  if (FReplace = mrNoToAll) or (FReplace = mrCancel) or (FReplace = mrNo) then
  begin
    if FReplace = mrCancel then
      FAbort := true;
    Confirm := false;
    Exit;
  end;
end;

procedure Tform_Main.ZipConfirmProcessFile(Sender: TObject; FileName: string;
  Operation: TZFProcessOperation; var Confirm: Boolean);
begin
  CheckUI();
end;

procedure Tform_Main.ZipFileProgress(Sender: TObject; FileName: string;
  Progress: Double; Operation: TZFProcessOperation;
  ProgressPhase: TZFProgressPhase; var Cancel: Boolean);
var
  Msg: WideString;
begin
  if ProgressPhase = ppStart then
  begin
    FCurrentFile := WideString(FileName);
    if FUseLanguage then
    begin
      if FTesting then
        Msg := WideFormat(Translator.GetMessage('528'), [FCurrentFile], FS)
      else
        Msg := WideFormat(Translator.GetMessage('529'), [FCurrentFile], FS);
    end
    else
    begin
      if FTesting then
        Msg := WideFormat(DS_TESTING, [FCurrentFile], FS)
      else
        Msg := WideFormat(DS_UNZIPPING, [FCurrentFile], FS);
    end;

    Log(Msg, false);
  end;

  if ProgressPhase = ppEnd then
    Inc(FCounter);
end;

procedure Tform_Main.ZipOverallProgress(Sender: TObject; Progress: Double;
  Operation: TZFProcessOperation; ProgressPhase: TZFProgressPhase;
  var Cancel: Boolean);
begin
  Cancel := FAbort;
  pb_Main.Position := Trunc(Progress);
  Application.ProcessMessages();
end;

procedure Tform_Main.ZipPassword(Sender: TObject; FileName: string;
  var NewPassword: string; var SkipFile: Boolean);
var
  Msg: WideString;
begin
  if FUseLanguage then
    Msg := WideFormat(Translator.GetMessage('530'), [WideString(FileName)],FS)
  else
    Msg := WideFormat(DS_BADPASSWORD, [WideString(FileName)], FS);

  if FBadPassword then
  begin
    SkipFile := true;
    FAbort := true;
    Log(Msg, true);
    Inc(FErrors);
    Exit;
  end;

  GetPassword(WideString(FileName));

  if FPassword = WS_NIL then
  begin
    SkipFile := true;
    FAbort := true;
    FBadPassword := true;
    Log(Msg, true);
    Inc(FErrors);
    Exit;
  end;

  NewPassword := AnsiString(FPassword);
end;

procedure Tform_Main.ZipProcessFileFailure(Sender: TObject; FileName: string;
  Operation: TZFProcessOperation; NativeError, ErrorCode: Integer;
  ErrorMessage: string; var Action: TZFAction);
begin
  if (FUSeLanguage) then
    Log(WideFormat(Translator.GetMessage('532'), [WideString(FileName),
                                              WideString(ErrorMessage)]), true) else
    Log(WideFormat(DS_ERROREXTRACTING, [WideString(FileName),
                                              WideString(ErrorMessage)]), true);
  Inc(FErrors);
  Action := fxaIgnore;
end;

procedure Tform_Main.ZipRequestFirstVolume(Sender: TObject;
  var VolumeFileName: string; var Cancel: Boolean);
begin
  Cancel:= not GetPart(VolumeFileName);
end;

procedure Tform_Main.ZipRequestLastVolume(Sender: TObject;
  var VolumeFileName: string; var Cancel: Boolean);
begin
  Cancel:= not GetPart(VolumeFileName);
end;

procedure Tform_Main.ZipRequestMiddleVolume(Sender: TObject;
  VolumeNumber: Integer; var VolumeFileName: string; var Cancel: Boolean);
begin
  Cancel:= not GetPart(VolumeFileName);
end;

end.
