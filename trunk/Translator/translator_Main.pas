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

// Main unit for the translator

unit translator_Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TntClasses, TntForms, TntSysUtils, TntSystem, ComCtrls, TntComCtrls,
  ToolWin, ImgList, TntDialogs, StdCtrls, TntStdCtrls;

const
  INT_AFTERCREATION = WM_USER +6572;

type
  Tform_Translator = class(TTntForm)
    pc_Main: TTntPageControl;
    tb_main: TTntToolBar;
    sb_Main: TTntStatusBar;
    tab_Interface: TTntTabSheet;
    tab_Messages: TTntTabSheet;
    lv_Interface: TTntListView;
    lv_Messages: TTntListView;
    i_Main: TImageList;
    i_MainD: TImageList;
    b_New: TTntToolButton;
    b_Open: TTntToolButton;
    b_Save: TTntToolButton;
    b_Sep001: TTntToolButton;
    b_Search: TTntToolButton;
    b_Font: TTntToolButton;
    b_OpenFolder: TTntToolButton;
    b_Check: TTntToolButton;
    b_Readme: TTntToolButton;
    m_Sep002: TTntToolButton;
    b_About: TTntToolButton;
    b_Sep004: TTntToolButton;
    l_Warning: TTntLabel;
    d_Fonts: TFontDialog;
    i_Tabs: TImageList;
    b_SearchNext: TTntToolButton;
    procedure b_SearchNextClick(Sender: TObject);
    procedure b_ReadmeClick(Sender: TObject);
    procedure b_CheckClick(Sender: TObject);
    procedure b_OpenFolderClick(Sender: TObject);
    procedure b_FontClick(Sender: TObject);
    procedure b_SearchClick(Sender: TObject);
    procedure b_SaveClick(Sender: TObject);
    procedure lv_MessagesEditing(Sender: TObject; Item: TListItem;
      var AllowEdit: Boolean);
    procedure lv_InterfaceEditing(Sender: TObject; Item: TListItem;
      var AllowEdit: Boolean);
    procedure b_AboutClick(Sender: TObject);
    procedure lv_MessagesEdited(Sender: TObject; Item: TTntListItem;
      var S: WideString);
    procedure lv_InterfaceEdited(Sender: TObject; Item: TTntListItem;
      var S: WideString);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure b_OpenClick(Sender: TObject);
    procedure pc_MainChange(Sender: TObject);
    procedure b_NewClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FAppPath: WideString;
    FSettingsPath: WideString;
    FLanguagePath: WideString;
    FS: TFormatSettings;
    FFirstTime: boolean;
    FIniFile: WideString;
    FLanguage: WideString;
    FMsgFileE: WideString;
    FUIFileE: WideString;
    FUI: WideString;
    FMsg: WideString;
    FSearchString: WideString;
    FSearchIndex: Integer;
    procedure Initialize();
    procedure LoadSettings();
    procedure WriteSettings();
    procedure CheckUI();
    procedure LoadEnglish();
    function CheckLanguages(): boolean;
    procedure SaveAll();
    procedure LoadLanguage();
    procedure CheckStatus();
    function CheckItem(const Sender: TTntListView; const Item:TTntListItem;
                       const S: WideString): boolean;
    procedure FindString();
    procedure SearchNext();
  protected
    procedure AfterCreate(var msg: TMessage); message INT_AFTERCREATION;
  public
    { Public declarations }
  end;

var
  form_Translator: Tform_Translator;

implementation

uses bmCommon, bmConstants, translator_Constants, CobCommonW, bmCustomize,
     CobDialogsW, translator_Languages, translator_Search, ShellApi,
  translator_About;

{$R *.dfm}

procedure Tform_Translator.AfterCreate(var msg: TMessage);
begin
  if (FFirstTime) then
  begin
    CheckLanguages();
    LoadEnglish();
    CheckUI();
    FFirstTime:= false;
  end;
end;

procedure Tform_Translator.SearchNext();
begin
  if FSearchString = WS_NIL then
    b_SearchClick(self)
  else
  begin
    inc(FSearchIndex);
    FindString;
  end;
end;

procedure Tform_Translator.b_AboutClick(Sender: TObject);
var
  form_About: Tform_About;
begin
  form_About:= Tform_About.Create(nil);
  try
    form_About.ShowModal();
  finally
    form_About.Release();
  end;
end;

procedure Tform_Translator.b_CheckClick(Sender: TObject);
var
  i: integer;
  Error: boolean;
begin
  if FLanguage = WS_NIL then
    Exit;

  Error := false;
  
  Screen.Cursor := crHourGlass;
  try
    pc_Main.ActivePage:= tab_Interface;
    for i := 0 to lv_Interface.Items.Count - 1 do
      if CheckItem(lv_Interface,lv_Interface.Items[i], lv_Interface.Items[i].Caption) = false then
      begin
        Error := true;
        Break;
      end;

    if (Error) then
      Exit;

    pc_Main.ActivePage:= tab_Messages;
    for i := 0 to lv_Messages.Items.Count - 1 do
      if CheckItem(lv_Messages,lv_Messages.Items[i], lv_Messages.Items[i].Caption) = false then
      begin
        Error := true;
        Break;
      end;

    if not Error then
      CobShowMessageW(self.Handle, TS_NOERRORS, WS_PROGRAMNAMESHORT);
      
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure Tform_Translator.b_FontClick(Sender: TObject);
begin
  d_Fonts.Font:= lv_Interface.Font;
  if (d_Fonts.Execute()) then
  begin
    lv_Interface.Font:= d_Fonts.Font;
    lv_Messages.Font:= d_Fonts.Font;
  end;
end;

procedure Tform_Translator.b_NewClick(Sender: TObject);
var
  LanguageForm: Tform_Languages;
begin
  LanguageForm:= Tform_Languages.Create(nil);
  try
    LanguageForm.IsNew:= true;
    LanguageForm.LanguagePath:= FLanguagePath;
    LanguageForm.ShowModal();
    if (LanguageForm.Tag = INT_MODALRESULTOK) then
    begin
      SaveAll();
      FLanguage:= LanguageForm.e_New.Text;
      FUI:= FLanguagePath + FLanguage + WS_UIEXTENSION;
      FMsg:= FLanguagePath + FLanguage + WS_MSGEXTENSION;
      LoadLanguage();
      CheckUI();
    end;
  finally
    LanguageForm.Release();
  end; 
end;

procedure Tform_Translator.b_OpenClick(Sender: TObject);
var
  LanguageForm: Tform_Languages;
begin
  LanguageForm:= Tform_Languages.Create(nil);
  try
    LanguageForm.IsNew:= false;
    LanguageForm.LanguagePath:= FLanguagePath;
    LanguageForm.ShowModal();
    if (LanguageForm.Tag = INT_MODALRESULTOK) then
    begin
      SaveAll();
      FLanguage:= LanguageForm.cb_Old.Items[LanguageForm.cb_Old.ItemIndex];
      FUI:= FLanguagePath + FLanguage + WS_UIEXTENSION;
      FMsg:= FLanguagePath + FLanguage + WS_MSGEXTENSION;
      LoadLanguage();
      CheckUI();
    end;
  finally
    LanguageForm.Release();
  end; 
end;

procedure Tform_Translator.b_OpenFolderClick(Sender: TObject);
begin
  ShellExecuteW(0,'open',PwideChar(FLanguagePath), nil, nil, SW_SHOWNORMAL);
end;

procedure Tform_Translator.b_ReadmeClick(Sender: TObject);
begin
  ShellExecuteW(0,'open',PwideChar(FAppPath + WS_TREADME), nil, nil, SW_SHOWNORMAL);
end;

procedure Tform_Translator.b_SaveClick(Sender: TObject);
begin
  SaveAll();
end;

procedure Tform_Translator.b_SearchClick(Sender: TObject);
var
  form_Search: Tform_Search;
begin
  FSearchIndex:= 0;
  form_Search:= Tform_Search.Create(nil);
  try
    form_Search.e_Search.Text:= FSearchString;
    form_Search.ShowModal();
    if (form_Search.Tag = INT_MODALRESULTOK) then
    begin
      FSearchString:= form_Search.e_Search.Text;
      FindString();
    end;
  finally
    form_Search.Release();
  end;
end;

procedure Tform_Translator.b_SearchNextClick(Sender: TObject);
begin
  SearchNext();
end;

function Tform_Translator.CheckItem(const Sender: TTntListView;
  const Item: TTntListItem;  const S: WideString): boolean;
var
  Original, Derivated: WideString;
  d1, s1, d2, s2, j, tpo, tpd: integer;
begin
  Result := true;
  Original := Item.SubItems[0];
  Derivated := S;
  d1 := 0;
  s1 := 0;
  d2 := 0;
  s2 := 0;
  tpo := 0;
  tpd := 0;
  if Original <> WS_NIL then
  begin
    for j := 1 to Length(Original) do
    begin
      if Original[j] = TS_PARAM then
        begin
          inc(tpo);
          if j <> Length(Original) then
          begin
            if Original[j + 1] = TS_STRING then
              Inc(s1);
            if Original[j + 1] = TS_INTEGER then
              Inc(d1);
          end;
        end;
    end;

    for j := 1 to Length(Derivated) do
    begin
      if Derivated[j] = TS_PARAM then
        begin
          inc(tpd);
          if j <> Length(Derivated) then
          begin
            if Derivated[j + 1] = TS_STRING then
              Inc(s2);
            if Derivated[j + 1] = TS_INTEGER then
              Inc(d2);
          end;
        end;
    end;

    if (s1 <> s2) or (d1 <> d2) or (tpo <> tpd) then
    begin
      CobShowMessageW(self.Handle, TS_BADPARAMS, WS_PROGRAMNAMESHORT);
      Result := false;
      Sender.Selected := Item;
      Item.MakeVisible(false);
      Sender.SetFocus;
    end;

  end;
end;


function Tform_Translator.CheckLanguages(): boolean;
begin
  Result:= true;

  if (not WideDirectoryExists(FLanguagePath)) then
  begin
    CobShowMessageW(self.Handle, TS_LANGUAGEDIRNOTFOUND, WS_PROGRAMNAMESHORT);
    Result:= false;
    Application.Terminate();
    Exit;
  end;

 if (not WideFileExists(FMsgFileE)) or (not WideFileExists(FUIFileE)) then
  begin
    CobShowMessageW(self.Handle, TS_ENGLISHNOTFOUND, WS_PROGRAMNAMESHORT);
    Result:= false;
    Application.Terminate();
    Exit;
  end;
end;

procedure Tform_Translator.CheckStatus();
begin
  if (pc_Main.ActivePage = tab_Interface) then
  begin
    sb_Main.SimpleText:= FUI;
    l_Warning.Visible:= true;
  end else
  begin
    sb_Main.SimpleText:= FMsg;
    l_Warning.Visible:= false;
  end;
end;

procedure Tform_Translator.CheckUI();
begin
  // lv_Interface.ReadOnly:= FLanguage = WS_NIL;
  // lv_Messages.ReadOnly:= FLanguage = WS_NIL;
  /// There is a bug in TTntListView. If adding an item
  ///  and the listbox is hidden  and the ReadOnly property changes
  ///  The count of the list is set to ZERO
  ///  So NEVER use ReadOnly

  b_Save.Enabled:= FLanguage <> WS_NIL;
  b_Check.Enabled:= FLanguage <> WS_NIL;

  if (FLanguage <> WS_NIL) then
  begin
    lv_Interface.Columns[0].Caption:= TS_EDIT;
    lv_Messages.Columns[0].Caption:= TS_EDIT;
  end else
  begin
    lv_Interface.Columns[0].Caption:= TS_NOLANGUAGE;
    lv_Messages.Columns[0].Caption:= TS_NOLANGUAGE;
  end;

  CheckStatus();
end;

procedure Tform_Translator.FindString();
var
  List: TTntListView;
  Found: boolean;
  i: integer;
  lv: TTntListItem;
begin
  if (pc_Main.ActivePage = tab_Interface) then
    List:= lv_Interface else
    List:= lv_Messages;

  Found:= false;
  for i:= FSearchIndex to List.Items.Count-1 do
  begin
    lv:= List.Items[i];
    if lv <> nil then
    begin
      if (CobPosW(FSearchString, lv.Caption, false) > 0) or
         (CobPosW(FSearchString, lv.SubItems[0], false) > 0) then
      begin
        List.Selected:= lv;
        lv.MakeVisible(false);
        FSearchIndex:= i;
        List.SetFocus();
        Found:= true;
        Break;
      end;
    end;
  end;

  if not Found then
  begin
    FSearchIndex:= 0;
    CobShowMessageW(self.Handle, WideFormat(TS_TEXTNOFOUND,[FSearchString],FS), WS_PROGRAMNAMESHORT);
  end;
end;

procedure Tform_Translator.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveAll();
  WriteSettings();
end;

procedure Tform_Translator.FormCreate(Sender: TObject);
begin
  GetLocaleFormatSettings(LOCALE_SYSTEM_DEFAULT, FS);
  FFirstTime:= true;
  FAppPath:= CobSetBackSlashW(CobGetAppPathW());
  FSettingsPath:= CobSetBackSlashW(FAppPath + WS_DIRSETTINGS);
  FLanguagePath:= CobSetBackSlashW(FAppPath + WS_DIRLANG);
  FIniFile:= FSettingsPath + WideChangeFileExt(WideExtractFileName(WideParamStr(0)), WS_INIEXT);
  FMsgFileE:= FLanguagePath + WS_ENGLISH + WS_MSGEXTENSION;
  FUIFileE:= FLanguagePath + WS_ENGLISH + WS_UIEXTENSION;
  Initialize();
  LoadSettings();
  PostMessageW(self.Handle, INT_AFTERCREATION, 0, 0);
end;

procedure Tform_Translator.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (FLanguage <> WS_NIL) then
  begin
    if (Key = VK_RETURN) or (Key = VK_F2) then
    begin
      if (pc_Main.ActivePage = tab_Interface) then
      begin
        if (lv_Interface.Selected <> nil) then
          if (not lv_Interface.IsEditing) then
            lv_Interface.Selected.EditCaption();
      end else
      begin
        if (lv_Messages.Selected <> nil) then
          if (not lv_Messages.IsEditing) then
            lv_Messages.Selected.EditCaption();
      end;
    end;
  end;

  if (Key = $46) then
    if ssCtrl in Shift then
      b_SearchClick(self);

  if Key = VK_F3 then
    SearchNext();
end;

procedure Tform_Translator.Initialize();
begin
  Caption:= WideFormat(TS_CAPTION,[WS_PROGRAMNAMESHORT],FS);
  TntApplication.Title:= Caption;
  sb_Main.SimpleText:= WS_NIL;
  self.Width:= TS_INT800;
  self.Height:= TS_INT600;
  FLanguage:= WS_NIL;
  FMsg:= WS_NIL;
  FUI:= WS_NIL;
  pc_Main.ActivePage:= tab_Interface;
  lv_Interface.Columns[0].Width:= (Width div 2) - TS_INTMARGIN;
  lv_Interface.Columns[1].Width:= (Width div 2) - TS_INTMARGIN;
  lv_Interface.Columns[2].Width:= TS_INTINDEX;
  lv_Messages.Columns[0].Width:= (Width div 2) - TS_INTMARGIN;
  lv_Messages.Columns[1].Width:= (Width div 2) - TS_INTMARGIN;
  lv_Messages.Columns[2].Width:= TS_INTINDEX;
  lv_Interface.Columns[0].Caption:= TS_NOLANGUAGE;
  lv_Interface.Columns[1].Caption:= TS_ENGLISH;
  lv_Interface.Columns[2].Caption:= TS_INDEX;
  lv_Messages.Columns[0].Caption:= TS_NOLANGUAGE;
  lv_Messages.Columns[1].Caption:= TS_ENGLISH;
  lv_Messages.Columns[2].Caption:= TS_INDEX;
end;

procedure Tform_Translator.LoadEnglish();
var
  Sl: TTntStringList;
  i: integer;
  Item: TTntListItem;
  AName: WideString;
begin
  Screen.Cursor:= crHourGlass;
  Sl:= TTntStringList.Create();
  try
    lv_Interface.Clear();
    Sl.LoadFromFile(FUIFileE);
    for i:= 0 to Sl.Count - 1 do
    begin
      Item:= lv_Interface.Items.Add();
      Item.Caption:= WS_NIL;
      AName:= Sl.Names[i];
      Item.SubItems.Add(Sl.Values[AName]);
      Item.SubItems.Add(AName);
    end;

    lv_Messages.Clear();
    Sl.LoadFromFile(FMsgFileE);
    for i:= 0 to Sl.Count - 1 do
    begin
      Item:= lv_Messages.Items.Add();
      Item.Caption:= WS_NIL;
      AName:= Sl.Names[i];
      Item.SubItems.Add(Sl.Values[AName]);
      Item.SubItems.Add(AName);
    end;
  finally
    FreeAndNil(Sl);
    Screen.Cursor:= crDefault;
  end;

  CheckUI();
end;

procedure Tform_Translator.LoadLanguage();
var
  Sl: TTntStringList;
  i: integer;
  Item: TTntListItem;
begin
  Sl:= TTntStringList.Create();
  try
    Sl.LoadFromFile(FUI);
    for i:=0 to lv_Interface.Items.Count - 1 do
    begin
      Item:= lv_Interface.Items[i];
      Item.Caption:= Sl.Values[Item.Subitems[1]];
    end;

    Sl.LoadFromFile(FMsg);
    for i:=0 to lv_Messages.Items.Count - 1 do
    begin
      Item:= lv_Messages.Items[i];
      Item.Caption:= Sl.Values[Item.Subitems[1]];
    end;
  finally
    FreeAndNil(Sl);
  end;

  pc_Main.ActivePage:= tab_Interface;
end;

procedure Tform_Translator.LoadSettings();
var
  Sl: TTntStringList;
begin
  Sl:= TTntStringList.Create();
  try
    if (WideFileExists(FIniFile)) then
    begin
      Sl.LoadFromFile(FIniFile);
      self.Width:= CobStrToIntW(Sl.Values[TS_INIWIDTH], TS_INT800);
      self.Height:= CobStrToIntW(Sl.Values[TS_INIHEIGHT], TS_INT600);
      self.Left:= CobStrToIntW(Sl.Values[TS_INILEFT], TS_INT10);
      self.Top:= CobStrToIntW(Sl.Values[TS_INITOP], TS_INT10);
      lv_Interface.Columns[0].Width:= CobStrToIntW(Sl.Values[TS_INICOLUMN0], Width div 2 - TS_INTMARGIN);
      lv_Interface.Columns[1].Width:= CobStrToIntW(Sl.Values[TS_INICOLUMN1], Width div 2  - TS_INTMARGIN);
      lv_Interface.Columns[2].Width:= CobStrToIntW(Sl.Values[TS_INICOLUMNI1], TS_INTINDEX);
      lv_Interface.Columns[1].Width:= CobStrToIntW(Sl.Values[TS_INICOLUMN1], Width div 2  - TS_INTMARGIN);
      lv_Messages.Columns[0].Width:= CobStrToIntW(Sl.Values[TS_INICOLUMN2], Width div 2  - TS_INTMARGIN);
      lv_Messages.Columns[1].Width:= CobStrToIntW(Sl.Values[TS_INICOLUMN3], Width div 2 - TS_INTMARGIN);
      lv_Messages.Columns[2].Width:= CobStrToIntW(Sl.Values[TS_INICOLUMNI2], TS_INTINDEX);
      lv_Interface.Font.Name:= WideString(Sl.Values[TS_INIFONTNAME]);
      lv_Interface.Font.Size:= CobStrToIntW(Sl.Values[TS_INIFONTSIZE], INT_DEFFONT);
      lv_Interface.Font.Charset:= CobStrToIntW(Sl.Values[TS_INIFONTCHARSET], DEFAULT_CHARSET);
      lv_Messages.Font.Name:= WideString(Sl.Values[TS_INIFONTNAME]);
      lv_Messages.Font.Size:= CobStrToIntW(Sl.Values[TS_INIFONTSIZE], INT_DEFFONT);
      lv_Messages.Font.Charset:= CobStrToIntW(Sl.Values[TS_INIFONTCHARSET], DEFAULT_CHARSET);
    end else
      self.Position:= poScreenCenter;
  finally
    FreeAndNil(Sl);
  end;
end;

procedure Tform_Translator.lv_InterfaceEdited(Sender: TObject;
  Item: TTntListItem; var S: WideString);
begin
  CheckItem(lv_Interface, Item, S);
end;

procedure Tform_Translator.lv_InterfaceEditing(Sender: TObject; Item: TListItem;
  var AllowEdit: Boolean);
begin
  AllowEdit:= (FLanguage <> WS_NIL);
end;

procedure Tform_Translator.lv_MessagesEdited(Sender: TObject;
  Item: TTntListItem; var S: WideString);
begin
  CheckItem(lv_Messages, Item, S);
end;

procedure Tform_Translator.lv_MessagesEditing(Sender: TObject; Item: TListItem;
  var AllowEdit: Boolean);
begin
  AllowEdit:= (FLanguage <> WS_NIL);
end;

procedure Tform_Translator.pc_MainChange(Sender: TObject);
begin
  CheckStatus();
  // because both lists can have different numbers of items
  FSearchIndex:= 0;
end;

procedure Tform_Translator.SaveAll();
var
  Sl: TTntStringList;
  i: integer;
  Item: TTntListItem;
begin
  if (FLanguage <> WS_NIL) then
  begin
    Sl:= TTntStringList.Create();
    try
      Sl.Clear();
      for i:=0 to lv_Interface.Items.Count - 1 do
      begin
        Item:= lv_Interface.Items[i];
        Sl.Add(WideFormat(WS_INIFORMAT,[Item.SubItems[1],Item.Caption],FS));
      end;
      Sl.SaveToFile(FUI);

      Sl.Clear();
      for i:=0 to lv_Messages.Items.Count - 1 do
      begin
        Item:= lv_Messages.Items[i];
        Sl.Add(WideFormat(WS_INIFORMAT,[Item.SubItems[1],Item.Caption],FS));
      end;
      Sl.SaveToFile(FMsg);
    finally
      FreeAndNil(Sl);
    end;
  end;
end;

procedure Tform_Translator.WriteSettings();
var
  Sl: TTntStringList;
begin
  if (not WideDirectoryExists(FSettingsPath)) then
    WideCreateDir(FSettingsPath);

  if (WideDirectoryExists(FSettingsPath)) then
    begin
      Sl:= TTntStringList.Create();
      try
        Sl.Add(WideFormat(WS_INIFORMAT,[TS_INILEFT,CobIntToStrW(self.Left)],FS));
        Sl.Add(WideFormat(WS_INIFORMAT,[TS_INITOP,CobIntToStrW(self.Top)],FS));
        Sl.Add(WideFormat(WS_INIFORMAT,[TS_INIWIDTH,CobIntToStrW(self.Width)],FS));
        Sl.Add(WideFormat(WS_INIFORMAT,[TS_INIHEIGHT,CobIntToStrW(self.Height)],FS));
        Sl.Add(WideFormat(WS_INIFORMAT,[TS_INICOLUMN0,
                                  CobIntToStrW(lv_Interface.Columns[0].Width)],FS));
        Sl.Add(WideFormat(WS_INIFORMAT,[TS_INICOLUMN1,
                                  CobIntToStrW(lv_Interface.Columns[1].Width)],FS));
        Sl.Add(WideFormat(WS_INIFORMAT,[TS_INICOLUMNI1,
                                  CobIntToStrW(lv_Interface.Columns[2].Width)],FS));
        Sl.Add(WideFormat(WS_INIFORMAT,[TS_INICOLUMN2,
                                  CobIntToStrW(lv_Messages.Columns[0].Width)],FS));
        Sl.Add(WideFormat(WS_INIFORMAT,[TS_INICOLUMN3,
                                  CobIntToStrW(lv_Messages.Columns[1].Width)],FS));
        Sl.Add(WideFormat(WS_INIFORMAT,[TS_INICOLUMNI2,
                                  CobIntToStrW(lv_Messages.Columns[2].Width)],FS));
        Sl.Add(WideFormat(WS_INIFORMAT,[TS_INIFONTNAME,
                                  WideString(lv_Interface.Font.Name)],FS));
        Sl.Add(WideFormat(WS_INIFORMAT,[TS_INIFONTSIZE,
                                  CobIntToStrW(lv_Interface.Font.Size)],FS));
        Sl.Add(WideFormat(WS_INIFORMAT,[TS_INIFONTCHARSET,
                                  CobIntToStrW(lv_Interface.Font.Charset)],FS));

        Sl.SaveToFile(FIniFile);
      finally
        FreeAndNil(Sl);
      end;
    end;
end;

end.
