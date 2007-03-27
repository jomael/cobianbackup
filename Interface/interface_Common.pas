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

// Common functions and constants used by all units in the Interface

unit interface_Common;

interface

uses Messages, Windows, SysUtils, TntClasses, SyncObjs, TntStdCtrls, bmCommon;

const
  WM_SYSTRAYICON = WM_USER + 780;
  WM_CLOSECBUMAINFORM = WM_USER + 790;
  WS_RECREATETRAYMSG: PWideChar = 'TaskbarCreated';
  INT_CLOSEDMUTEX = 9090;

type
  TCobHotKey=(ckNone,ckWinC,ckWinZ,ckCtrlAltC,ckCtrlAltB,ckCtrlShiftC,ckCtrlShiftF12);

  //Settings for the user interface only. User dependient
  TUISettings = class(TObject)   
  public
    //Settings
    ShowWelcomeScreen: boolean;
    ShowHints: boolean;
    FontName: WideString;
    FontSize: integer;
    FontCharset: integer;
    FontNameLog: WideString;
    FontSizeLog: integer;
    FontCharsetLog: integer;
    ConfirmClose: boolean;
    HotlKey: integer;
    WordWrap: boolean;
    ShowIcons: boolean;
    SaveAdvancedSettings: boolean;
    DeferenceLinks: boolean;
    ConvertToUNC: boolean;
    HintColor: integer;
    HintHide: integer;
    CalculateSize: boolean;
    ShowBackupHints: boolean;
    ShowDialogEnd: boolean;
    PlaySound: boolean;
    FileToPlay: WideString;
    ShowPercent: boolean;
    ClearLogTab: boolean;
    ConfirmRun: boolean;
    ConfirmAbort: boolean;
    ForceInternalHelp: boolean;
    NavigateInternally: boolean;
    AutoShowLog: boolean;
    ShowGrid: boolean;

    // Position
    Width: integer;
    Height: integer;
    Top: integer;
    Left: integer;
    VSplitter: integer;
    MainLVView: integer;
    MainLVColumn0: integer;
    MainLVColumn1: integer;
    MainLVColumn2: integer;
    PropertyColumn0: integer;
    PropertyColumn1: integer;
    HistoryColumn0: integer;
    HistoryColumn1: integer;
    HistoryColumn2: integer;
    BackupLeft: integer;
    BackupTop: integer;
    BackupWidth: integer;
    BackupHeight: integer;
    BackupColumn0: integer;
    BackupColumn1: integer;
    ServiceWidth: integer;
    ServiceHeight: integer;
    ServiceLeft: integer;
    ServiceTop: integer;
    ServiceColumn0: integer;
    ServiceColumn1: integer;
    ServiceColumn2: integer;
    
    constructor Create(const PSec:PSecurityAttributes ;
                       const SWidth, SHeight: integer;
                       const AppPath, SettingsPath: WideString);
    destructor Destroy();override;
    procedure SaveSettings(const Std: boolean);
    procedure SavePositions(const Std: boolean);
    procedure LoadSettings();
    procedure LoadPositions();
  private
    FAppPath: WideString;
    FSettingsPath: WideString;
    FMutex: THandle;
    FSGlobal: TFormatSettings;
    FNameSettings: WideString;
    FNamePositions: WideString;
    FSHeight: integer;
    FSWidth: integer;
    FTools: TCobTools;
  end;

var
  UISettings: TUISettings;
  IPCMasterCS: TCriticalSection;
  CommandList: TTntStringList;

procedure CheckHorizontalBar(Sender: TTntListBox);
function InputQueryW(const ACaption, Prompt: WideString; const Password: boolean;
                  var Input: WideString): boolean;
function MessageDlgSpecial(const ACaption, Prompt,Condition, AHint: WideString;
                          var Checked: boolean): boolean;

implementation

uses CobCommonW, bmCustomize, bmConstants, TntSysUtils, interface_InputBox,
  interface_SpecialDialog;

{ TUISettings }

function MessageDlgSpecial(const ACaption, Prompt, Condition, AHint: WideString;
                          var Checked: boolean): boolean;
var
  Dialog: Tform_SpecialDialog;
begin
  Result:= false;
  Dialog:= Tform_SpecialDialog.Create(nil);
  try
    Dialog.Caption:= ACaption;
    Dialog.l_Prompt.Caption:= Prompt;
    Dialog.cb_Condition.Caption:= Condition;
    Dialog.cb_Condition.Checked:= Checked;
    Dialog.cb_Condition.Hint:= AHint;
    Dialog.CenterLabels();
    Dialog.ShowModal();
    if (Dialog.Tag = INT_MODALRESULTOK) then
    begin
      Checked:= Dialog.cb_Condition.Checked;
      Result:= true;
    end;
  finally
    Dialog.Release();
  end;
end;

function InputQueryW(const ACaption, Prompt: WideString; const Password: boolean;
                  var Input: WideString): boolean;
var
  InputBox: Tform_InputBox;
begin
  // Shows an Input box with a "password" property
  Result:= false;
  InputBox:= Tform_InputBox.Create(nil);
  try
    InputBox.Caption:= ACaption;
    InputBox.l_Prompt.Caption:= Prompt;
    InputBox.e_Input.Text:= Input;
    if (Password) then
      InputBox.e_Input.PasswordChar:= WS_PASSWORDCHAR else
      InputBox.e_Input.PasswordChar:= WS_NOPASSWORDCHAR;
    InputBox.ShowModal();
    if (InputBox.Tag = INT_MODALRESULTOK) then
    begin
      Input:= InputBox.e_Input.Text;
      Result:= true;
    end;
  finally
    InputBox.Release();
  end;
end;

procedure CheckHorizontalBar(Sender: TTntListBox);
var
  MaxLen: integer;
  i: integer;
  Size: TSize;
begin
  //This procedure checks if the list box needs
  //a horizontal scroll bar and shows it
  MaxLen := 0;
  for i := 0 to Sender.Items.Count - 1 do
  begin
    GetTextExtentPoint32W(Sender.Canvas.Handle,
                          PWideChar(Sender.Items[i]),
                          Length(Sender.Items[i]),
                          Size);
    if Size.cx > MaxLen then
      MaxLen := Size.cx;
  end;
  Sender.Perform(LB_SETHORIZONTALEXTENT, MaxLen + INT_LBMARGIN, 0);
end;


constructor TUISettings.Create(const PSec:PSecurityAttributes ;
                               const SWidth, SHeight: integer;
                               const AppPath, SettingsPath: WideString);
var
  MN, User: WideString;
begin
  inherited Create();
  FAppPath:= AppPath;
  FSHeight:= SHeight;
  FSWidth:= SWidth;
  FSettingsPath:= SettingsPath;
  GetLocaleFormatSettings(LOCALE_SYSTEM_DEFAULT, FSGlobal);

  if (CobIs2000orBetterW) then
    MN:= WideFormat(WS_UIINIMUTEXNAME,[WS_PROGRAMNAMELONG],FSGlobal) else
    MN:= WideFormat(WS_UIINIMUTEXNAMEOLD,[WS_PROGRAMNAMELONG],FSGlobal);

  FMutex:= CreateMutexW(Psec,false,PWideChar(MN));

  FTools:= TCobTools.Create();

  User:= CobGetCurrentUserNameW();

  if (User = WS_NIL) then
    User:= WS_DEFAULTUSERNAME;

  FNameSettings:= FSettingsPath + WideFormat(WS_UISETTINGSINIFILENAME,[User], FSGlobal);
  FNamePositions:= FSettingsPath + WideFormat(WS_UIPOSITIONSINIFILENAME,[User], FSGlobal);

  if (not WideFileExists(FNameSettings)) then
    SaveSettings(true);

  if (not WideFileExists(FNamePositions)) then
    SavePositions(true);
end;

destructor TUISettings.Destroy();
begin
  FreeAndNil(FTools);
  
  if (FMutex <> 0) then
    begin
      CloseHandle(FMutex);
      FMutex:= 0;
    end;
    
  inherited Destroy;
end;

procedure TUISettings.LoadPositions();
var
  Sl: TTntStringList;
begin
  Sl:= TTntStringList.Create();
  if (WaitForSingleObject(FMutex, INFINITE) = WAIT_OBJECT_0) then
  try
    Sl.LoadFromFile(FNamePositions);
    Left:= CobStrToIntW(Sl.Values[WS_INILEFT], INT_NIL);
    Top:= CobStrToIntW(Sl.Values[WS_INITOP], INT_NIL);
    Width:= CobStrToIntW(Sl.Values[WS_INIWIDTH], INT_DEFWIDTH);
    Height:= CobStrToIntW(Sl.Values[WS_INIHEIGHT], INT_DEFHEIGHT);
    VSplitter:= CobStrToIntW(Sl.Values[WS_INIVSPLITTER],INT_VDEFSPLITTER);
    MainLVView:= CobStrToIntW(Sl.Values[WS_INIMAINLVTYPE],INT_NIL);
    MainLVColumn0:= CobStrToIntW(Sl.Values[WS_INIMAINLVCOLUMN0],INT_COLUMN0);
    MainLVColumn1:= CobStrToIntW(Sl.Values[WS_INIMAINLVCOLUMN1],INT_COLUMNS);
    MainLVColumn2:= CobStrToIntW(Sl.Values[WS_INIMAINLVCOLUMN2],INT_COLUMNS);
    PropertyColumn0:= CobStrToIntW(Sl.Values[WS_INIPROPERTYLVCOLUMN0],INT_COLUMNPROPERTY);
    PropertyColumn1:= CobStrToIntW(Sl.Values[WS_INIPROPERTYLVCOLUMN1],INT_COLUMNPROPERTY);
    HistoryColumn0:= CobStrToIntW(Sl.Values[WS_INIHISTORYLVCOLUMN0],INT_COLUMNHISTORY);
    HistoryColumn1:= CobStrToIntW(Sl.Values[WS_INIHISTORYLVCOLUMN1],INT_COLUMNHISTORY);
    HistoryColumn2:= CobStrToIntW(Sl.Values[WS_INIHISTORYLVCOLUMN2],INT_COLUMNHISTORY);
    BackupLeft:= CobStrToIntW(Sl.Values[WS_INIBACKUPLEFT], INT_NIL);
    BackupTop:= CobStrToIntW(Sl.Values[WS_INIBACKUPTOP], INT_NIL);
    BackupWidth:= CobStrToIntW(Sl.Values[WS_INIBACKUPWIDTH], INT_DEFWIDTH);
    BackupHeight:= CobStrToIntW(Sl.Values[WS_INIBACKUPHEIGHT], INT_DEFHEIGHT);
    BackupColumn0:= CobStrToIntW(Sl.Values[WS_INIBACKUPCOLUMN0], INT_COLUMN0);
    BackupColumn1:= CobStrToIntW(Sl.Values[WS_INIBACKUPCOLUMN1], INT_COLUMN0);
    ServiceWidth:= CobStrToIntW(Sl.Values[WS_INISWINDOWWIDTH], INT_DEFSWIDTH);
    ServiceHeight:= CobStrToIntW(Sl.Values[WS_INISWINDOWHEIGHT], INT_DEFSHEIGHT);
    ServiceLeft:= CobStrToIntW(Sl.Values[WS_INISWINDOWLEFT], (FSWidth div 2) - (ServiceWidth div 2));
    ServiceTop:= CobStrToIntW(Sl.Values[WS_INISWINDOWTOP], (FSHeight div 2) - (ServiceHeight div 2));
    ServiceColumn0:= CobStrToIntW(Sl.Values[WS_INISWINDOWCOLUMN0],ServiceWidth div 3);
    ServiceColumn1:= CobStrToIntW(Sl.Values[WS_INISWINDOWCOLUMN1],ServiceWidth div 3);
    ServiceColumn2:= CobStrToIntW(Sl.Values[WS_INISWINDOWCOLUMN2],ServiceWidth div 3);
  finally
    ReleaseMutex(FMutex);
    FreeAndNil(Sl);
  end;
end;

procedure TUISettings.LoadSettings();
var
  Sl: TTntStringList;
begin
  Sl:= TTntStringList.Create();
  if (WaitForSingleObject(FMutex, INFINITE) = WAIT_OBJECT_0) then
  try
    Sl.LoadFromFile(FNameSettings);
    ShowWelcomeScreen:= CobStrToBoolW(Sl.Values[WS_INIWELCOMESCREEN]);
    ShowHints:= CobStrToBoolW(Sl.Values[WS_INISHOWHINTS]);
    FontName:= Sl.Values[WS_INIFONTNAME];
    FontSize:= CobStrToIntW(Sl.Values[WS_INIFONTSIZE], INT_DEFAULTFONTSIZE);
    FontCharset:= CobStrToIntW(Sl.Values[WS_INIFONTCHARSET], DEFAULT_CHARSET);
    ConfirmClose:= CobStrToBoolW(Sl.Values[WS_INICONFIRMCLOSE]);
    HotlKey:= CobStrToIntW(Sl.Values[WS_INIHOTKEY],Ord(ckWinC));
    FontNameLog:= Sl.Values[WS_INIFONTNAMELOG];
    FontSizeLog:= CobStrToIntW(Sl.Values[WS_INIFONTSIZELOG], INT_DEFAULTFONTSIZE);
    FontCharsetLog:= CobStrToIntW(Sl.Values[WS_INIFONTCHARSETLOG], DEFAULT_CHARSET);
    WordWrap:= CobStrToBoolW(Sl.Values[WS_INIWORDWRAP]);
    ShowIcons:= CobStrToBoolW(Sl.Values[WS_INISHOWICONS]);
    SaveAdvancedSettings:= CobStrToBoolW(Sl.Values[WS_INISAVEADVANCED]);
    DeferenceLinks:= CobStrToBoolW(Sl.Values[WS_INIDEFERENCELINKS]);
    ConvertToUNC:= CobStrToBoolW(Sl.Values[WS_INICONVERTTOUNC]);
    HintColor:= CobStrToIntW(Sl.Values[WS_INIHINTCOLOR],RGB(INT_RHINT,INT_GHINT,INT_BHINT));
    HintHide:= CobStrToIntW(Sl.Values[WS_INIHINTHIDE],INT_HINTHIDE);
    CalculateSize:= CobStrToBoolW(Sl.Values[WS_INICALCULATESIZE]);
    ShowBackupHints:= CobStrToBoolW(Sl.Values[WS_INISHOWBACKUPHINT]);
    ShowDialogEnd:= CobStrToBoolW(Sl.Values[WS_INISHOWDIALOGEND]);
    PlaySound:= CobStrToBoolW(Sl.Values[WS_INIPLAYSOUND]);
    FileToPlay:= Sl.Values[WS_INIFILETOPLAY];
    ShowPercent:= CobStrToBoolW(Sl.Values[WS_INISHOWPERCENT]);
    ClearLogTab:= CobStrToBoolW(Sl.Values[WS_INICLEARLOGTAB]);
    ConfirmRun:= CobStrToBoolW(Sl.Values[WS_INICONFIRMRUN]);
    ConfirmAbort:= CobStrToBoolW(Sl.Values[WS_INICONFIRMABORT]);
    ForceInternalHelp:= CobStrToBoolW(Sl.Values[WS_INIFORCEINTERNALHELP]);
    NavigateInternally:= CobStrToBoolW(Sl.Values[WS_ININAVIGATEINTERNALLY]);
    AutoShowLog:= CobStrToBoolW(Sl.Values[WS_INIAUTOSHOWLOG]);
    ShowGrid:= CobStrToBoolW(Sl.Values[WS_INISHOWGRID]);
  finally
    ReleaseMutex(FMutex);
    FreeAndNil(Sl);
  end;
end;

procedure TUISettings.SavePositions(const Std: boolean);
var
  Sl: TTntStringList;
begin
  Sl:= TTntStringList.Create();
  if (WaitForSingleObject(FMutex, INFINITE) = WAIT_OBJECT_0) then
  try
    if (Std) then
      begin
        Height:= INT_DEFHEIGHT;
        Width:= INT_DEFWIDTH;
        Top:= (FSHeight div 2) - (Height div 2);
        Left:= (FSWidth div 2) - (Width div 2);
        VSplitter:= INT_VDEFSPLITTER;
        MainLVView:= INT_NIL;
        MainLVColumn0:= INT_COLUMN0;
        MainLVColumn1:= INT_COLUMNS;
        MainLVColumn2:= INT_COLUMNS;
        PropertyColumn0:= INT_COLUMNPROPERTY;
        PropertyColumn1:= INT_COLUMNPROPERTY;
        HistoryColumn0:= INT_COLUMNHISTORY;
        HistoryColumn1:= INT_COLUMNHISTORY;
        HistoryColumn2:= INT_COLUMNHISTORY;
        BackupWidth:= INT_DEFWIDTH;
        BackupHeight:= INT_DEFHEIGHT;
        BackupLeft:= (FSWidth div 2) - (Width div 2);
        BackupTop:= (FSHeight div 2) - (Height div 2);
        BackupColumn0:= INT_COLUMN0;
        BackupColumn1:= BackupWidth - INT_COLUMN0;
        ServiceWidth:= INT_DEFSWIDTH;
        ServiceHeight:= INT_DEFSHEIGHT;
        ServiceLeft:= (FSWidth div 2) - (Width div 2);
        ServiceTop:= (FSHeight div 2) - (Height div 2);
        ServiceColumn0:= INT_DEFSWIDTH div 3;
        ServiceColumn1:= INT_DEFSWIDTH div 3;
        ServiceColumn2:= INT_DEFSWIDTH div 3;
      end;

    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INILEFT,CobIntToStrW(Left)],FSGlobal));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INITOP,CobIntToStrW(Top)],FSGlobal));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIWIDTH,CobIntToStrW(Width)],FSGlobal));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIHEIGHT,CobIntToStrW(Height)],FSGlobal));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIVSPLITTER,CobIntToStrW(VSplitter)],FSGlobal));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIMAINLVTYPE,CobIntToStrW(MainLVView)],FSGlobal));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIMAINLVCOLUMN0,CobIntToStrW(MainLVColumn0)],FSGlobal));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIMAINLVCOLUMN1,CobIntToStrW(MainLVColumn1)],FSGlobal));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIMAINLVCOLUMN2,CobIntToStrW(MainLVColumn2)],FSGlobal));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIPROPERTYLVCOLUMN0,CobIntToStrW(PropertyColumn0)],FSGlobal));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIPROPERTYLVCOLUMN1,CobIntToStrW(PropertyColumn1)],FSGlobal));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIHISTORYLVCOLUMN0,CobIntToStrW(HistoryColumn0)],FSGlobal));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIHISTORYLVCOLUMN1,CobIntToStrW(HistoryColumn1)],FSGlobal));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIHISTORYLVCOLUMN2,CobIntToStrW(HistoryColumn2)],FSGlobal));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIBACKUPLEFT, CobIntToStrW(BackupLeft)], FSGlobal));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIBACKUPTOP, CobIntToStrW(BackupTop)], FSGlobal));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIBACKUPWIDTH, CobIntToStrW(BackupWidth)], FSGlobal));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIBACKUPHEIGHT, CobIntToStrW(BackupHeight)], FSGlobal));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIBACKUPCOLUMN0, CobIntToStrW(BackupColumn0)], FSGlobal));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIBACKUPCOLUMN1, CobIntToStrW(BackupColumn1)], FSGlobal));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INISWINDOWWIDTH, CobIntToStrW(ServiceWidth)],FSGlobal));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INISWINDOWHEIGHT, CobIntToStrW(ServiceHeight)],FSGlobal));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INISWINDOWLEFT, CobIntToStrW(ServiceLeft)],FSGlobal));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INISWINDOWTOP, CobIntToStrW(ServiceTop)],FSGlobal));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INISWINDOWCOLUMN0, CobIntToStrW(ServiceColumn0)],FSGlobal));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INISWINDOWCOLUMN1, CobIntToStrW(ServiceColumn1)],FSGlobal));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INISWINDOWCOLUMN2, CobIntToStrW(ServiceColumn2)],FSGlobal));
    Sl.SaveToFile(FNamePositions);
    FTools.GetFullAccess(FAppPath, FNamePositions);
  finally
    ReleaseMutex(FMutex);
    FreeAndNil(Sl);
  end;
end;

procedure TUISettings.SaveSettings(const Std: boolean);
var
  Sl: TTntStringList;
begin
  Sl:= TTntStringList.Create();
  if (WaitForSingleObject(FMutex, INFINITE) = WAIT_OBJECT_0) then
  try
    if (Std) then
      begin
        ShowWelcomeScreen:= true;
        ShowHints:= true;
        FontName:= WS_DEFFONTNAME;
        FontSize:= INT_DEFAULTFONTSIZE;
        FontCharset:= DEFAULT_CHARSET;
        FontNameLog:= WS_DEFFONTNAMELOGO;
        FontSizeLog:= INT_DEFAULTFONTSIZE;
        FontCharset:= DEFAULT_CHARSET;
        ConfirmClose:= true;
        HotlKey:= ord(ckWinC);
        WordWrap:= false;
        ShowIcons:= true;
        SaveAdvancedSettings:= false;
        DeferenceLinks:= false;
        ConvertToUNC:= true;
        HintColor:= RGB(INT_RHINT,INT_GHINT,INT_BHINT);
        HintHide:= INT_HINTHIDE;
        CalculateSize:= true;
        ShowBackupHints:= true;
        ShowDialogEnd:= false;
        PlaySound:= false;
        FileToPlay:= WS_NIL;
        ShowPercent:= false;
        ClearLogTab:= true;
        ConfirmRun:= true;
        ConfirmAbort:= true;
        ForceInternalHelp:= true;
        NavigateInternally:= true;
        AutoShowLog:= true;
        ShowGrid:= false;
      end;
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIWELCOMESCREEN,CobBoolToStrW(ShowWelcomeScreen)],FSGlobal));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INISHOWHINTS,CobBoolToStrW(ShowHints)],FSGlobal));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIFONTNAME,FontName],FSGlobal));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIFONTSIZE,CobIntToStrW(FontSize)],FSGlobal));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIFONTCHARSET,CobIntToStrW(FontCharset)],FSGlobal));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INICONFIRMCLOSE,CobBoolToStrW(ConfirmClose)],FSGlobal));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIHOTKEY,CobIntToStrW(HotlKey)],FSGlobal));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIFONTNAMELOG,FontNameLog],FSGlobal));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIFONTSIZELOG,CobIntToStrW(FontSizeLog)],FSGlobal));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIFONTCHARSETLOG,CobIntToStrW(FontCharsetLog)],FSGlobal));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIWORDWRAP,CobBoolToStrW(WordWrap)],FSGlobal));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INISHOWICONS,CobBoolToStrW(ShowIcons)],FSGlobal));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INISAVEADVANCED, CobBoolToStrW(SaveAdvancedSettings)],FSGlobal));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIDEFERENCELINKS,CobBoolToStrW(DeferenceLinks)],FSGlobal));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INICONVERTTOUNC,CobBoolToStrW(ConvertToUNC)],FSGlobal));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIHINTCOLOR, CobIntToStrW(HintColor)], FSGlobal));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIHINTHIDE, CobIntToStrW(HintHide)], FSGlobal));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INICALCULATESIZE, CobBoolToStrW(CalculateSize)], FSGlobal));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INISHOWBACKUPHINT, CobBoolToStrW(ShowBackupHints)], FSGlobal));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INISHOWDIALOGEND, CobBoolToStrW(ShowDialogEnd)], FSGlobal));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIPLAYSOUND, CobBoolToStrW(PlaySound)], FSGlobal));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIFILETOPLAY, FileToPlay], FSGlobal));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INISHOWPERCENT, CobBoolToStrW(ShowPercent)],FSGlobal));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INICLEARLOGTAB, CobBoolToStrW(ClearLogTab)], FSGlobal));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INICONFIRMRUN, CobBoolToStrW(ConfirmRun)], FSGlobal));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INICONFIRMABORT, CobBoolToStrW(ConfirmAbort)], FSGlobal));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIFORCEINTERNALHELP, CobBoolToStrW(ForceInternalHelp)], FSGlobal));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_ININAVIGATEINTERNALLY,CobBoolToStrW(NavigateInternally)],FSGlobal));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIAUTOSHOWLOG,CobBoolToStrW(AutoShowLog)],FSGlobal));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INISHOWGRID,CobBoolToStrW(ShowGrid)],FSGlobal));
    Sl.SaveToFile(FNameSettings);
    FTools.GetFullAccess(FAppPath, FNameSettings);
  finally
    ReleaseMutex(FMutex);
    FreeAndNil(Sl);
  end;
end;

end.
