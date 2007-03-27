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

// Main form for the decryptor dll

unit decryptor_Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TntForms, bmTranslator, bmConstants, ComCtrls, TntComCtrls, jpeg,
  ExtCtrls, TntExtCtrls, StdCtrls, TntStdCtrls, CobBarW, TntDialogs, Menus,
  TntMenus, bmCommon, SyncObjs, ImgList;

const
  WMCOB_AFTERCREATE = WM_USER + INT_AFTERCREATE;

type
  Tform_MainForm = class(TTntForm)
    pc_Main: TTntPageControl;
    tab_Files: TTntTabSheet;
    tab_Keys: TTntTabSheet;
    tab_Log: TTntTabSheet;
    im_Keys: TTntImage;
    l_KeysGenerate: TTntLabel;
    l_KeysPassphrase: TTntLabel;
    e_KeysPassphrase: TTntEdit;
    l_KeysQuality: TTntLabel;
    l_KeysPassphraseRe: TTntLabel;
    e_KeysPassphraseRe: TTntEdit;
    pb_Quality: TCobBarW;
    l_KeysStatus: TTntLabel;
    b_KeysGenerate: TTntButton;
    cb_KeysUnencrypted: TTntCheckBox;
    dlg_Save: TTntSaveDialog;
    timer_Percent: TTimer;
    l_DecryptSource: TTntLabel;
    e_DecryptSource: TTntEdit;
    b_DecryptSource: TTntButton;
    l_DecryptDestination: TTntLabel;
    e_DecryptDestination: TTntEdit;
    b_DecryptBrowse: TTntButton;
    pop_Source: TTntPopupMenu;
    m_File: TTntMenuItem;
    m_Directory: TTntMenuItem;
    dlg_Open: TTntOpenDialog;
    cb_NewMethods: TTntComboBox;
    rb_NewMethods: TTntRadioButton;
    rb_OldMethods: TTntRadioButton;
    l_DecryptPrivateKey: TTntLabel;
    e_DecryptPrivateKey: TTntEdit;
    b_DecryptPrivate: TTntButton;
    cb_DecryptUnencrypted: TTntCheckBox;
    l_DecryptPassphrase: TTntLabel;
    e_DecryptPassphrase: TTntEdit;
    b_Decrypt: TTntButton;
    cb_OldMethods: TTntComboBox;
    p_Bottom: TTntPanel;
    p_Top: TTntPanel;
    re_Log: TTntRichEdit;
    pb_Partial: TCobBarW;
    pb_Total: TCobBarW;
    b_Cancel: TTntButton;
    pop_Log: TTntPopupMenu;
    m_SelectAll: TTntMenuItem;
    m_Sep: TTntMenuItem;
    m_Copy: TTntMenuItem;
    m_Sep2: TTntMenuItem;
    m_Wordwrap: TTntMenuItem;
    l_KeysExplain: TTntLabel;
    tab_About: TTntTabSheet;
    l_Decryptor: TTntLabel;
    l_Program: TTntLabel;
    l_Version: TTntLabel;
    l_Copyright: TTntLabel;
    l_AllRights: TTntLabel;
    l_Web: TTntLabel;
    i_Tabs: TImageList;
    procedure m_WordwrapClick(Sender: TObject);
    procedure m_CopyClick(Sender: TObject);
    procedure m_SelectAllClick(Sender: TObject);
    procedure pop_LogPopup(Sender: TObject);
    procedure b_CancelClick(Sender: TObject);
    procedure cb_DecryptUnencryptedClick(Sender: TObject);
    procedure cb_OldMethodsChange(Sender: TObject);
    procedure rb_OldMethodsClick(Sender: TObject);
    procedure cb_NewMethodsChange(Sender: TObject);
    procedure rb_NewMethodsClick(Sender: TObject);
    procedure TntFormClose(Sender: TObject; var Action: TCloseAction);
    procedure b_DecryptClick(Sender: TObject);
    procedure b_DecryptPrivateClick(Sender: TObject);
    procedure m_FileClick(Sender: TObject);
    procedure m_DirectoryClick(Sender: TObject);
    procedure b_DecryptBrowseClick(Sender: TObject);
    procedure b_DecryptSourceClick(Sender: TObject);
    procedure timer_PercentTimer(Sender: TObject);
    procedure b_KeysGenerateClick(Sender: TObject);
    procedure TntFormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure cb_KeysUnencryptedClick(Sender: TObject);
    procedure e_KeysPassphraseKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TntFormDestroy(Sender: TObject);
    procedure TntFormCreate(Sender: TObject);
  private
    { Private declarations }
    FUseLanguages: boolean;
    FSec: TSecurityAttributes;
    p: PSECURITY_DESCRIPTOR;
    FS: TFormatSettings;
    FGenerating: Boolean;
    FCounter: cardinal;
    FStatus: WideString;
    FSettingsDir: WideString;
    FIniName: WideString;
    FWorking: boolean;
    procedure AfterCreate(var Msg: TMessage); message WMCOB_AFTERCREATE;
    procedure LoadInterfaceText();
    procedure GetQualityVisually();
    procedure CheckUI();
    function ValidateFormKeys(): boolean;
    procedure EnableControls(const Enable: boolean);
    procedure ShowContextMenu(Sender: TObject);
    procedure DecryptNow();
    procedure LoadSettings();
    procedure LoadSettingsStd();
    procedure LoadSettingsFromFile();
    procedure SaveSettings();
    function ValidateFormDecrypt(): boolean;
    procedure CenterAbout();
  public
    { Public declarations }
    Errors: cardinal;
    AppPath: WideString;
    Language: WideString;
    ShowErrorsOnly: boolean;
    procedure OnGenerationTerminated(Sender: TObject);
    procedure OnWorkingThreadDone(Sender: TObject);
    procedure Log(const Msg: WideString; const Error: boolean);
    procedure ShowPercent(const Partial, Total: integer);
  end;

var
  form_MainForm: Tform_MainForm;
  Critical_Decryptor: TCriticalSection;
  Flag_AbortDecryption: boolean;
  FTranslator: TTranslator;
  
implementation

{$R *.dfm}
{$R ICONRES.RES}

uses CobCommonW, TntSysUtils, bmCustomize, decryptor_Strings,
  decryptor_Keysgenerator, CobDialogsW, TntClasses,
  decryptor_Decryptor;

procedure Tform_MainForm.AfterCreate(var Msg: TMessage);
var
  MLanguage, UILanguage, AMessage: WideString;
begin
  Critical_Decryptor:= TCriticalSection.Create();

  MLanguage:= CobSetBackSlashW(AppPath + WS_DIRLANG) + Language + WS_MSGEXTENSION;
  UILanguage:= CobSetBackSlashW(AppPath + WS_DIRLANG) + Language + WS_UIEXTENSION;

  FUseLanguages:= (WideFileExists(MLanguage)  and WideFileExists(UILanguage));

  FSec:= CobGetNullDaclAttributesW(p);

  if (FUseLanguages) then
  begin
    FTranslator:= TTranslator.Create(@FSec, AppPath,
                      CobSetBackSlashW(AppPath) + CobSetBackSlashW(WS_DIRLANG));
    FTranslator.LoadLanguage(Language);
  end;

  LoadInterfaceText();

  CenterAbout();

  FSettingsDir:= CobSetBackSlashW(AppPath + WS_DIRSETTINGS);
  FIniName:= WideFormat(FSettingsDir + WS_DECRYPTORINI,[CobGetCurrentUserNameW()],FS);

  LoadSettings();

  if (FUseLanguages) then
    AMessage:= WideFormat(FTranslator.GetMessage('306'),[WS_PROGRAMNAMESHORT],FS) else
    AMessage:= WideFormat(WSD_WELCOME,[WS_PROGRAMNAMESHORT],FS);

  Log(AMessage, false);
end;

procedure Tform_MainForm.b_CancelClick(Sender: TObject);
begin
  Critical_Decryptor.Enter();
  try
    Flag_AbortDecryption:= true;
  finally
    Critical_Decryptor.Leave();
  end;
end;

procedure Tform_MainForm.b_DecryptBrowseClick(Sender: TObject);
var
  Dir, ACaption: WideString;
begin
  if (FUseLanguages) then
    ACaption:= FTranslator.GetMessage('296') else
    ACaption:= WSD_SELECTDESTINATION;
  CobSelectDirectoryW(ACaption, WS_NIL, Dir, [csdNewFolder, csdNewUI], self);
  if (Dir <> WS_NIL) then
    e_DecryptDestination.Text:= Dir;
end;

procedure Tform_MainForm.b_DecryptClick(Sender: TObject);
begin
  if (not ValidateFormDecrypt()) then
    Exit;

  pb_Partial.Position:= 0;
  pb_Total.Position:= 0;
  FWorking:= true;
  Critical_Decryptor.Enter();
  try
    Flag_AbortDecryption:= false;
  finally
    Critical_Decryptor.Leave();
  end;
  
  CheckUI();

  pc_Main.ActivePage:= tab_Log;

  DecryptNow();
end;

procedure Tform_MainForm.b_KeysGenerateClick(Sender: TObject);
var
  Generator: TKeysGenerator;
  PrivKey, PubKey, ACaption, Msg: WideString;
  Rec: TGeneratorRec;
begin
  if (not ValidateFormKeys()) then
    Exit;
    
  if (FUseLanguages) then
  begin
    ACaption:= FTranslator.GetInterfaceText('492');
    dlg_Save.Filter:= WideFormat(WS_PUBLICKEYFILTER,
                    [FTranslator.GetMessage('26'), FTranslator.GetMessage('27')],FS);
  end else
  begin
    ACaption:= WSD_FOLDERTOSAVE;
    dlg_Save.Filter:= WideFormat(WS_PUBLICKEYFILTER,
                    [WSD_PUBLICKEYS, WSD_ALLFILES],FS);
  end;

  dlg_Save.DefaultExt:= WS_PUBLICKEYEXT;
  
  dlg_Save.Title:= ACaption;
  dlg_Save.FilterIndex:= 1;

  if (dlg_Save.Execute) then
  begin
    if (FUseLanguages) then
      Msg:= FTranslator.GetMessage('307') else
      Msg:= WSD_PLEASEWAIT;
    Log(Msg, false);
    PubKey:= dlg_Save.FileName;
    PrivKey:= WideChangeFileExt(PubKey, WS_PRIVATEKEYEXTDOT);
    b_KeysGenerate.Enabled:= false;
    FGenerating:= true;
    FCounter:= 0;
    EnableControls(false);

    Rec.APublicKey:= PubKey;
    Rec.APrivateKey:= PrivKey;
    Rec.APassphrase:= e_KeysPassphrase.Text;
    Rec.Encrypted:= not cb_KeysUnencrypted.Checked;
    Rec.Size:= INT_512;
    Generator:= TKeysGenerator.Create(Rec);
    Generator.FreeOnTerminate:= true;
    Generator.OnTerminate:= OnGenerationTerminated;
    Generator.Resume();
  end;
end;

procedure Tform_MainForm.b_DecryptPrivateClick(Sender: TObject);
begin
  if (FUseLanguages) then
    dlg_Open.Title:= FTranslator.GetMessage('299') else
    dlg_Open.Title:= WSD_DELECTKEY;
  if (FUseLanguages) then
    dlg_Open.Filter:= WideFormat(WS_PRIVATEKEYFILTER,
            [FTranslator.GetMessage('300'), FTranslator.GetMessage('27')],FS) else
    dlg_Open.Filter:= WideFormat(WS_PRIVATEKEYFILTER,
            [WSD_PRIVATEKEYS,WSD_ALLFILES],FS);
  dlg_Open.FilterIndex:= 0;
  dlg_Open.DefaultExt:= WS_PRIVATEKEYEXT;
  dlg_Open.FileName:= WS_NIL;
  if (dlg_Open.Execute) then
    e_DecryptPrivateKey.Text:= dlg_Open.FileName;
end;

procedure Tform_MainForm.b_DecryptSourceClick(Sender: TObject);
begin
  ShowContextMenu(Sender);
end;

procedure Tform_MainForm.cb_DecryptUnencryptedClick(Sender: TObject);
begin
  CheckUI();
end;

procedure Tform_MainForm.cb_KeysUnencryptedClick(Sender: TObject);
begin
  CheckUI();
end;

procedure Tform_MainForm.cb_NewMethodsChange(Sender: TObject);
begin
  CheckUI();
end;

procedure Tform_MainForm.cb_OldMethodsChange(Sender: TObject);
begin
  CheckUI();
end;

procedure Tform_MainForm.CenterAbout();
begin
  l_Decryptor.Left:= (tab_About.Width div 2) - (l_Decryptor.Width div 2);
  l_Program.Left:= (tab_About.Width div 2) - (l_Program.Width div 2);
  l_Version.Left:= (tab_About.Width div 2) - (l_Version.Width div 2);
  l_Copyright.Left:= (tab_About.Width div 2) - (l_Copyright.Width div 2);
  l_AllRights.Left:= (tab_About.Width div 2) - (l_AllRights.Width div 2);
  l_Web.Left:= (tab_About.Width div 2) - (l_Web.Width div 2);
end;

procedure Tform_MainForm.CheckUI();
begin
  if (cb_KeysUnencrypted.Checked) then
  begin
    e_KeysPassphrase.Text:= WS_NIL;
    e_KeysPassphraseRe.Text:= WS_NIL;
  end;

  GetQualityVisually();

  e_KeysPassphrase.Enabled:= not cb_KeysUnencrypted.Checked;
  e_KeysPassphraseRe.Enabled:= not cb_KeysUnencrypted.Checked;
  l_KeysPassphrase.Enabled:= not cb_KeysUnencrypted.Checked;
  l_KeysPassphraseRe.Enabled:= not cb_KeysUnencrypted.Checked;
  l_KeysQuality.Enabled:= not cb_KeysUnencrypted.Checked;
  pb_Quality.Enabled:= not cb_KeysUnencrypted.Checked;

  cb_NewMethods.Enabled:= rb_NewMethods.Checked;
  cb_OldMethods.Enabled:= rb_OldMethods.Checked;
  l_DecryptPrivateKey.Enabled:= (rb_NewMethods.Checked) and
                                (cb_NewMethods.ItemIndex = INT_DECRSA);
  e_DecryptPrivateKey.Enabled:= (rb_NewMethods.Checked) and
                                (cb_NewMethods.ItemIndex = INT_DECRSA);
  b_DecryptPrivate.Enabled:= (rb_NewMethods.Checked) and
                                (cb_NewMethods.ItemIndex = INT_DECRSA);
  cb_DecryptUnencrypted.Enabled:= (rb_NewMethods.Checked) and
                                (cb_NewMethods.ItemIndex = INT_DECRSA);
  l_DecryptPassphrase.Enabled:= not ((rb_NewMethods.Checked) and
                                    (cb_NewMethods.ItemIndex = INT_DECRSA)
                                    and cb_DecryptUnencrypted.Checked);
  e_DecryptPassphrase.Enabled:= l_DecryptPassphrase.Enabled;
  b_Decrypt.Enabled:= not FWorking;
  b_Cancel.Enabled:= FWorking;
end;


procedure Tform_MainForm.DecryptNow();
var
  Decryptor: TDecryptor;
  Rec: TDecryptorRec;
  Index: integer;
begin
  if (rb_NewMethods.Checked) then
    Index:= cb_NewMethods.ItemIndex else
    Index:= cb_OldMethods.ItemIndex;
  Rec.AInput:= e_DecryptSource.Text;
  Rec.AOutput:= e_DecryptDestination.Text;
  Rec.APassPhrase:= e_DecryptPassphrase.Text;
  Rec.APrivateKey:= e_DecryptPrivateKey.Text;
  Rec.AUnencrypted:=  cb_DecryptUnencrypted.Checked;
  Rec.AUseLanguage:= FUseLanguages;
  Rec.ANewMethod:= rb_NewMethods.Checked;
  rec.AIndex:= Index;
  Rec.ASize:= INT_512;
  Decryptor:= TDecryptor.Create(Rec);
  Decryptor.FreeOnTerminate:= false;
  Decryptor.OnTerminate:= OnWorkingThreadDone;
  Decryptor.Resume();
end;

procedure Tform_MainForm.EnableControls(const Enable: boolean);
begin
  l_KeysPassphrase.Enabled:= Enable;
  e_KeysPassphrase.Enabled:= Enable;
  l_KeysPassphraseRe.Enabled:= Enable;
  e_KeysPassphraseRe.Enabled:= Enable;
  cb_KeysUnencrypted.Enabled:= Enable;
  cb_KeysUnencrypted.Enabled:= Enable;
  l_KeysStatus.Visible:= not Enable;
  timer_Percent.Enabled:= not Enable;
  CheckUI();
end;

procedure Tform_MainForm.e_KeysPassphraseKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GetQualityVisually();
end;

procedure Tform_MainForm.GetQualityVisually();
begin
  pb_Quality.Position:= CobGetPasswordQuality(e_KeysPassphrase.Text);
  if (pb_Quality.Position < 33) then
    pb_Quality.ColorScheme:= ccwRed else
    if (pb_Quality.Position > 66) then
      pb_Quality.ColorScheme:= ccwGreen else
      pb_Quality.ColorScheme:= ccwYellow;
end;

procedure Tform_MainForm.LoadInterfaceText();
begin
  if (FUseLanguages) then
  begin
    Caption:= WideFormat(FTranslator.GetInterfaceText('481'),[WS_PROGRAMNAMESHORT], FS);
    tab_Files.Caption:= FTranslator.GetInterfaceText('482');
    tab_Keys.Caption:= FTranslator.GetInterfaceText('483');
    tab_Log.Caption:= FTranslator.GetInterfaceText('11');
    l_KeysGenerate.Caption:= FTranslator.GetInterfaceText('484');
    l_KeysPassphrase.Caption:= FTranslator.GetInterfaceText('485');
    l_KeysQuality.Caption:= FTranslator.GetInterfaceText('179');
    l_KeysPassphraseRe.Caption:= FTranslator.GetInterfaceText('486');
    l_KeysStatus.Caption:= WideFormat(FTranslator.GetInterfaceText('487'),[FCounter],FS);
    FStatus:= FTranslator.GetInterfaceText('487');
    b_KeysGenerate.Caption:= FTranslator.GetInterfaceText('489');
    cb_KeysUnencrypted.Caption:= FTranslator.GetInterfaceText('490');
    cb_KeysUnencrypted.Hint:=  FTranslator.GetInterfaceText('491');
    l_DecryptSource.Caption:= FTranslator.GetInterfaceText('495');
    b_DecryptSource.Caption:= FTranslator.GetInterfaceText('496');
    l_DecryptDestination.Caption:= FTranslator.GetInterfaceText('497');
    b_DecryptBrowse.Caption:= FTranslator.GetInterfaceText('498');
    m_File.Caption:= FTranslator.GetInterfaceText('499');
    m_Directory.Caption:= FTranslator.GetInterfaceText('500');
    rb_NewMethods.Caption:= FTranslator.GetInterfaceText('501');
    rb_NewMethods.Hint:= WideFormat(FTranslator.GetInterfaceText('507'),[WS_PROGRAMNAMEGENERIC],FS);
    rb_OldMethods.Caption:= FTranslator.GetInterfaceText('502');
    rb_OldMethods.Hint:= WideFormat(FTranslator.GetInterfaceText('506'),[WS_PROGRAMNAMEGENERIC],FS);
    cb_NewMethods.Clear();
    cb_NewMethods.Items.Add(FTranslator.GetInterfaceText('172'));
    cb_NewMethods.Items.Add(FTranslator.GetInterfaceText('175'));
    cb_NewMethods.Items.Add(FTranslator.GetInterfaceText('174'));
    cb_NewMethods.Items.Add(FTranslator.GetInterfaceText('176'));
    cb_OldMethods.Clear();
    cb_OldMethods.Items.Add(FTranslator.GetInterfaceText('175'));
    cb_OldMethods.Items.Add(FTranslator.GetInterfaceText('174'));
    cb_OldMethods.Items.Add(FTranslator.GetInterfaceText('176'));
    l_DecryptPrivateKey.Caption:= FTranslator.GetInterfaceText('503');
    b_DecryptPrivate.Caption:= FTranslator.GetInterfaceText('498');
    cb_DecryptUnencrypted.Caption:= FTranslator.GetInterfaceText('504');
    l_DecryptPassphrase.Caption:= FTranslator.GetInterfaceText('177');
    b_Decrypt.Caption:= FTranslator.GetInterfaceText('505');
    b_Cancel.Caption:= FTranslator.GetInterfaceText('B_CANCEL');
    m_SelectAll.Caption:= FTranslator.GetInterfaceText('508');
    m_Copy.Caption:= FTranslator.GetInterfaceText('509');
    m_Wordwrap.Caption:= FTranslator.GetInterfaceText('13');
    l_KeysExplain.Caption:= FTranslator.GetInterfaceText('510');
    tab_About.Caption:= FTranslator.GetInterfaceText('688');
    l_Decryptor.Caption:= FTranslator.GetInterfaceText('689');
    l_AllRights.Caption:= FTranslator.GetMessage('542');
  end else
  begin
    Caption:= WideFormat(WSD_CAPTION,[WS_PROGRAMNAMESHORT], FS);
    tab_Files.Caption:= WSD_DECRYPT;
    tab_Keys.Caption:= WSD_KEYS;
    tab_Log.Caption:= WSD_LOG;
    l_KeysGenerate.Caption:= WSD_GENERATEPAIR;
    l_KeysPassphrase.Caption:= WSD_PASSPHRASE;
    l_KeysQuality.Caption:= WSD_QUALITY;
    l_KeysPassphraseRe.Caption:= WSD_RETYPE;
    l_KeysStatus.Caption:= WideFormat(WSD_MINUTES, [FCounter] , FS);
    FStatus:= WSD_MINUTES;
    b_KeysGenerate.Caption:= WSD_GENERATE;
    cb_KeysUnencrypted.Caption:= WSD_DONOTENCRYPT;
    cb_KeysUnencrypted.Hint:= WSD_DONOTENCRYPTHINT;
    l_DecryptSource.Caption:= WSD_SOURCE;
    b_DecryptSource.Caption:= WSD_SOURCEBUTTON;
    l_DecryptDestination.Caption:= WSD_DESTINATIONFOLDER;
    b_DecryptBrowse.Caption:= WSD_BROWSE;
    m_File.Caption:= WSD_FILE;
    m_Directory.Caption:= WSD_DIRECTORY;
    rb_NewMethods.Caption:= WSD_METHOD;
    rb_NewMethods.Hint:= WideFormat(WSD_NEWER,[WS_PROGRAMNAMEGENERIC],FS);
    rb_OldMethods.Caption:= WSD_METHODOLD;
    rb_OldMethods.Hint:= WideFormat(WSD_EARLIER,[WS_PROGRAMNAMEGENERIC],FS);
    cb_NewMethods.Clear();
    cb_NewMethods.Items.Add(WSD_RSAMETHOD);
    cb_NewMethods.Items.Add(WSD_BLOWFISHMETHOD);
    cb_NewMethods.Items.Add(WSD_RIJNDAELMETHOD);
    cb_NewMethods.Items.Add(WSD_DESMETHOD);
    cb_OldMethods.Clear();
    cb_OldMethods.Items.Add(WSD_BLOWFISHMETHOD);
    cb_OldMethods.Items.Add(WSD_RIJNDAELMETHOD);
    cb_OldMethods.Items.Add(WSD_DESMETHOD);
    l_DecryptPrivateKey.Caption:= WSD_PRIVATE;
    b_DecryptPrivate.Caption:= WSD_BROWSE;
    cb_DecryptUnencrypted.Caption:= WSD_UNENCRYPTEDKEY;
    l_DecryptPassphrase.Caption:= WSD_PASSPHRASEGENERAL;
    b_Decrypt.Caption:= WSD_DECRYPTNOW;
    b_Cancel.Caption:= WSD_CANCEL;
    m_SelectAll.Caption:= WSD_SELECTALL;
    m_Copy.Caption:= WSD_COPY;
    m_Wordwrap.Caption:= WSD_WORDWRAP;
    l_KeysExplain.Caption:= WSD_EXPLAIN;
    tab_About.Caption:= WSD_ABOUT;
    l_DecryptSource.Caption:= WSD_DECRYPTOR;
    l_AllRights.Caption:= WSD_ALLRIGHTS;
  end;

  l_Program.Caption:= WS_PROGRAMNAMESHORT;
  l_Version.Caption:= CobGetVersionW(WS_NIL);
  l_Copyright.Caption:= WideFormat(WSD_COPYRIGHT,[WS_AUTHORLONG], FS);
  l_Web.Caption:= WS_AUTHORWEB;
end;

procedure Tform_MainForm.LoadSettings();
begin
  LoadSettingsStd(); // set std values anyway
  if (WideFileExists(FIniName)) then
    LoadSettingsFromFile();

  GetQualityVisually();
  CheckUI();
end;

procedure Tform_MainForm.LoadSettingsFromFile();
var
  Sl: TTntStringList;
begin
  Sl:= TTntStringList.Create();
  try
    Sl.LoadFromFile(FIniName);
    e_DecryptDestination.Text:= Sl.Values[WS_INIDECDESTINATION];
    rb_OldMethods.Checked:= CobStrToBoolW(Sl.Values[WS_INIDECOLDMETHODS]);
    cb_NewMethods.ItemIndex:= CobStrToIntW(Sl.Values[WS_INIDECNEWMETHODINDEX],INT_DECRSA);
    cb_OldMethods.ItemIndex:= CobStrToIntW(Sl.Values[WS_INIDECOLDMETHODINDEX],INT_DECOLDBLOWFISH128);
    e_DecryptPrivateKey.Text:= Sl.Values[WS_INIDECPRIVATEKEY];
    cb_DecryptUnencrypted.Checked:= CobStrToBoolW(Sl.Values[WS_INIDECUNENCRYPTEDKEY]);
    cb_KeysUnencrypted.Checked:= CobStrToBoolW(Sl.Values[WS_INIDECUNENCRYPTEDKEYGEN]);
    re_Log.WordWrap:= CobStrToBoolW(Sl.Values[WS_INIDECWORDWRAP]);
  finally
    FreeAndNil(Sl);
  end;
end;

procedure Tform_MainForm.LoadSettingsStd();
begin
  e_DecryptSource.Text:= WS_NIL;
  e_DecryptDestination.Text:= WS_NIL;
  rb_NewMethods.Checked:= true;
  rb_OldMethods.Checked:= false;
  cb_NewMethods.ItemIndex:= INT_DECRSA;
  cb_OldMethods.ItemIndex:= INT_DECOLDBLOWFISH128;
  e_DecryptPrivateKey.Text:= WS_NIL;
  cb_DecryptUnencrypted.Checked:= false;
  e_DecryptPassphrase.Text:= WS_NIL;
  e_KeysPassphrase.Text:= WS_NIL;
  e_KeysPassphraseRe.Text:= WS_NIL;
  cb_KeysUnencrypted.Checked:= false;
  re_Log.WordWrap:= false;
end;

procedure Tform_MainForm.Log(const Msg: WideString; const Error: boolean);
begin
  if (Error) then
    re_Log.SelAttributes.Color:= clred else
    re_Log.SelAttributes.Color:= clBlack;
  re_Log.Lines.Add(Msg);
  re_Log.Perform(EM_LineScroll, 0, re_Log.Lines.Count - 5);
  Application.ProcessMessages();
end;

procedure Tform_MainForm.m_CopyClick(Sender: TObject);
begin
  if (re_Log.SelLength > 0) then
    re_Log.CopyToClipboard();
end;

procedure Tform_MainForm.m_DirectoryClick(Sender: TObject);
var
  Dir, ACaption: WideString;
begin
  if (FUseLanguages) then
    ACaption:= FTranslator.GetMessage('297') else
    ACaption:= WSD_SELECTSOURCE;

  CobSelectDirectoryW(ACaption, WS_NIL, Dir, [csdNewFolder, csdNewUI], self);
  if (Dir <> WS_NIL) then
    e_DecryptSource.Text:= Dir;
end;

procedure Tform_MainForm.m_FileClick(Sender: TObject);
begin
  if (FUseLanguages) then
    dlg_Open.Title:= FTranslator.GetMessage('298') else
    dlg_Open.Title:= WSD_SELECTFILE;
  if (FUseLanguages) then
    dlg_Open.Filter:= WideFormat(WS_ENCRYPTIONFILTER,
            [FTranslator.GetMessage('295'), FTranslator.GetMessage('27')],FS) else
    dlg_Open.Filter:= WideFormat(WS_ENCRYPTIONFILTER,
            [WSD_ENCRYPTED,WSD_ALLFILES],FS);
  dlg_Open.FilterIndex:= 0;
  dlg_Open.DefaultExt:= WS_ENCRYPTEDEXTNOTDOT;
  dlg_Open.FileName:= WS_NIL;
  if (dlg_Open.Execute) then
    e_DecryptSource.Text:= dlg_Open.FileName;
end;

procedure Tform_MainForm.m_SelectAllClick(Sender: TObject);
begin
  re_Log.SelectAll();
end;

procedure Tform_MainForm.m_WordwrapClick(Sender: TObject);
begin
  re_Log.WordWrap:= not re_Log.WordWrap;
end;

procedure Tform_MainForm.OnGenerationTerminated(Sender: TObject);
var
  Msg: WideString;
begin
  EnableControls(true);
  b_KeysGenerate.Enabled:= true;
  FGenerating:= false;
  if (FUseLanguages) then
    Msg:= FTranslator.GetMessage('292') else
    Msg:= WSD_KEYSGENERATED;
  CobShowMessageW(self.Handle,Msg,WS_PROGRAMNAMESHORT);
  Log(Msg,false);
end;

procedure Tform_MainForm.OnWorkingThreadDone(Sender: TObject);
var
  Msg: WideString;
  Decryptor: TDecryptor;
begin
  pb_Partial.Position:= 0;
  pb_Total.Position:= 0;
  FWorking:= false;
  if (Sender is TDecryptor) then
  begin
    Decryptor:= (Sender as TDecryptor);
    if (FUseLanguages) then
      Msg:= WideFormat(FTranslator.GetMessage('324'),[Decryptor.FCurrent, Decryptor.Errors],FS) else
      Msg:= WideFormat(WSD_SUMMARY,[Decryptor.FCurrent, Decryptor.Errors],FS);
    Log(Msg, Decryptor.Errors <> 0);
  end;
  CheckUI();
end;

procedure Tform_MainForm.pop_LogPopup(Sender: TObject);
begin
  m_Copy.Enabled:= re_Log.SelLength > 0;
  m_Wordwrap.Checked:= re_Log.WordWrap;
end;

procedure Tform_MainForm.rb_NewMethodsClick(Sender: TObject);
begin
  CheckUI();
end;

procedure Tform_MainForm.rb_OldMethodsClick(Sender: TObject);
begin
  CheckUI();
end;

procedure Tform_MainForm.SaveSettings();
var
  Sl: TTntStringList;
begin
  if (not WideDirectoryExists(FSettingsDir)) then
    WideCreateDir(FSettingsDir);
  if (WideDirectoryExists(FSettingsDir)) then
  
    begin
      Sl:= TTntStringList.Create();
      try
        Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIDECDESTINATION,e_DecryptDestination.Text],FS));
        Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIDECOLDMETHODS,CobBoolToStrW(rb_OldMethods.Checked)],FS));
        Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIDECNEWMETHODINDEX,CobIntToStrW(cb_NewMethods.ItemIndex)],FS));
        Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIDECOLDMETHODINDEX,CobIntToStrW(cb_OldMethods.ItemIndex)],FS));
        Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIDECPRIVATEKEY,e_DecryptPrivateKey.Text],FS));
        Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIDECUNENCRYPTEDKEY,CobBoolToStrW(cb_DecryptUnencrypted.Checked)],FS));
        Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIDECUNENCRYPTEDKEYGEN,CobBoolToStrW(cb_KeysUnencrypted.Checked)],FS));
        Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIDECWORDWRAP,CobBoolToStrW(re_Log.WordWrap)],FS));
        Sl.SaveToFile(FIniName);
      finally
        FreeAndNil(Sl);
      end;
    end;
end;

procedure Tform_MainForm.ShowContextMenu(Sender: Tobject);
var
  Button: TTntButton;
  PosXY: TPoint;
begin
  if not (Sender is TTntButton) then
    Exit;

  Button:= Sender as TTntButton;

  PosXY.X:= Button.Left;
  PosXY.Y:= Button.Top + Button.Height;
  PosXY:= Button.Parent.ClientToParent(PosXY, self);
  PosXY:= ClientToScreen(PosXY);
  pop_Source.Popup(PosXY.X,PosXY.Y);
end;

procedure Tform_MainForm.ShowPercent(const Partial, Total: integer);
begin
  pb_Partial.Position:= Partial;
  pb_Total.Position:= Total;
  Application.ProcessMessages();
end;

procedure Tform_MainForm.timer_PercentTimer(Sender: TObject);
begin
  inc(FCounter);
  l_KeysStatus.Caption:= WideFormat(FStatus,[FCounter], FS);
  Application.ProcessMessages();
end;

procedure Tform_MainForm.TntFormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveSettings();
end;

procedure Tform_MainForm.TntFormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose:= (not FGenerating) and (not FWorking);
end;

procedure Tform_MainForm.TntFormCreate(Sender: TObject);
begin
  Icon.Handle := LoadIcon(hInstance, 'AMAINICON');
  GetLocaleFormatSettings(LOCALE_SYSTEM_DEFAULT, FS);
  pc_Main.ActivePage:= tab_Files;
  l_KeysStatus.Visible:= false;
  timer_Percent.Enabled:= false;
  Errors:= 0;
  FGenerating:= false;
  FCounter:= 0;
  FWorking:= false;
  pb_Partial.Position:= 0;
  pb_Total.Position:= 0;
  Flag_AbortDecryption:= false;
  PostMessageW(Handle, WM_USER + INT_AFTERCREATE, 0, 0);
end;

procedure Tform_MainForm.TntFormDestroy(Sender: TObject);
begin
  if (FUseLanguages) then
    FreeAndNil(FTranslator);

  CobFreeNullDaclAttributesW(p);

  FreeAndNil(Critical_Decryptor);
end;

function Tform_MainForm.ValidateFormDecrypt(): boolean;
var
  Msg: WideString;
begin
  Result:= true;
  
  if (not WideFileExists(e_DecryptSource.Text)) and
     (not WideDirectoryExists(e_DecryptSource.Text) ) then
  begin
    if (FUseLanguages) then
      Msg:= FTranslator.GetMessage('308') else
      Msg:= WSD_SOURCENOTEXIST;
    CobShowMessageW(self.Handle,Msg, WS_PROGRAMNAMESHORT);
    pc_Main.ActivePage:= tab_Files;
    e_DecryptSource.SetFocus();
    e_DecryptSource.SelectAll();
    Result:= false;
    Exit;
  end;

  if (not WideDirectoryExists(e_DecryptDestination.Text)) then
    if (not WideForceDirectories(e_DecryptDestination.Text)) then
    begin
      if (FUseLanguages) then
        Msg:= FTranslator.GetMessage('309') else
        Msg:= WSD_DESTINATIONNOTEXIST;
      CobShowMessageW(self.Handle,Msg, WS_PROGRAMNAMESHORT);
      pc_Main.ActivePage:= tab_Files;
      e_DecryptDestination.SetFocus();
      e_DecryptDestination.SelectAll();
      Result:= false;
      Exit;
    end;

  if (rb_NewMethods.Checked) and (cb_NewMethods.ItemIndex = INT_DECRSA) and
     (not WideFileExists(e_DecryptPrivateKey.Text)) then
    begin
      if (FUseLanguages) then
        Msg:= FTranslator.GetMessage('310') else
        Msg:= WSD_PRIVATEKEYNOTEXIST;
      CobShowMessageW(self.Handle,Msg, WS_PROGRAMNAMESHORT);
      pc_Main.ActivePage:= tab_Files;
      e_DecryptPrivateKey.SetFocus();
      e_DecryptPrivateKey.SelectAll();
      Result:= false;
      Exit;
    end;

  if (CobPosW(e_DecryptSource.Text, e_DecryptDestination.Text, false) = 1) then
  begin
    if (FUseLanguages) then
      Msg:= FTranslator.GetMessage('630') else
      Msg:= WSD_DESTSOURCE;
    CobShowMessageW(self.Handle,Msg, WS_PROGRAMNAMESHORT);
    pc_Main.ActivePage:= tab_Files;
    e_DecryptDestination.SetFocus();
    e_DecryptDestination.SelectAll();
    Result:= false;
    Exit;
  end;
end;

function Tform_MainForm.ValidateFormKeys(): boolean;
var
  Msg: WideString;
begin
  Result:= false;

  if (not cb_KeysUnencrypted.Checked) and (e_KeysPassphrase.Text = WS_NIL) then
  begin
    if (FUseLanguages) then
      Msg:= FTranslator.GetInterfaceText('493') else
      Msg:= WSD_ENTERPASSPHRASE;
    CobShowMessageW(self.Handle, Msg, WS_PROGRAMNAMESHORT);
    pc_Main.ActivePage:= tab_Keys;
    e_KeysPassphraseRe.Clear();
    e_KeysPassphrase.SelectAll();
    e_KeysPassphrase.SetFocus();
    Exit;
  end;


  if (not cb_KeysUnencrypted.Checked) and (e_KeysPassphrase.Text <> e_KeysPassphraseRe.Text) then
  begin
    if (FUseLanguages) then
      Msg:= FTranslator.GetInterfaceText('494') else
      Msg:= WSD_DONTMATCH;
    CobShowMessageW(self.Handle, Msg, WS_PROGRAMNAMESHORT);
    pc_Main.ActivePage:= tab_Keys;
    e_KeysPassphraseRe.Clear();
    e_KeysPassphrase.SelectAll();
    e_KeysPassphrase.SetFocus();
    Exit;
  end;

  Result:= true;
end;

end.
