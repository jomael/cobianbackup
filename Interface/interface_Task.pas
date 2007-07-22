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

// Shows and edits a task

unit interface_Task;

interface

{$INCLUDE CobianCompilers.inc}

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TntForms, ComCtrls, TntComCtrls, StdCtrls, TntStdCtrls, ExtCtrls,
  TntExtCtrls, ImgList, jpeg, Buttons, TntButtons, Menus, TntMenus, TntClasses,
  bmCommon, TntDialogs, CobBarW;                                            

type
  TSDData = class(TObject)
  private
    FFullPath: WideString;
    FToShow: WideString;
    FKind: integer;
    FFtp: TFTPAddress;
  public
    constructor Create(const Kind: integer; const Path: WideString);
    destructor Destroy(); override;
    function GetFullPath(): WideString;
    function GetToShow(): WideString;
    function GetKind(): integer;
  end;

  Tform_Task = class(TTntForm)
    p_Bottom: TTntPanel;
    b_OK: TTntButton;
    b_Cancel: TTntButton;
    p_Left: TTntPanel;
    p_Right: TTntPanel;
    pc_Task: TTntPageControl;
    tab_General: TTntTabSheet;
    tab_Files: TTntTabSheet;
    tab_Sechedule: TTntTabSheet;
    tab_Archive: TTntTabSheet;
    tab_Special: TTntTabSheet;
    tab_Events: TTntTabSheet;
    lb_Menu: TTntListBox;
    il_Task: TImageList;
    im_Task: TTntImage;
    l_Name: TTntLabel;
    l_Id: TTntLabel;
    le_Name: TTntLabel;
    e_Name: TTntEdit;
    cb_Disabled: TTntCheckBox;
    cb_IncludeSubdirs: TTntCheckBox;
    cb_Separated: TTntCheckBox;
    cb_Attributes: TTntCheckBox;
    gb_BackupType: TTntGroupBox;
    rb_Full: TTntRadioButton;
    rb_Incremental: TTntRadioButton;
    rb_Differential: TTntRadioButton;
    rb_Dummy: TTntRadioButton;
    l_FullCopies: TTntLabel;
    e_FullCopies: TTntEdit;
    l_MakeFull: TTntLabel;
    e_MakeFull: TTntEdit;
    l_Source: TTntLabel;
    l_Explorer: TTntLabel;
    lb_Source: TTntListBox;
    b_SourceAdd: TTntBitBtn;
    b_SourceEdit: TTntBitBtn;
    b_SourceDelete: TTntBitBtn;
    l_Destination: TTntLabel;
    lb_Destination: TTntListBox;
    b_DestinationAdd: TTntBitBtn;
    b_DestinationEdit: TTntBitBtn;
    b_DestinationDelete: TTntBitBtn;
    l_ScheduleType: TTntLabel;
    cb_ScheduleType: TTntComboBox;
    gb_DaysWeek: TTntGroupBox;
    cb_Monday: TTntCheckBox;
    cb_Tuesday: TTntCheckBox;
    cb_Wednesday: TTntCheckBox;
    cb_Thursday: TTntCheckBox;
    cb_Friday: TTntCheckBox;
    cb_Saturday: TTntCheckBox;
    cb_Sunday: TTntCheckBox;
    gb_DateTime: TTntGroupBox;
    l_Date: TTntLabel;
    dt_Date: TTntDateTimePicker;
    l_Time: TTntLabel;
    dt_Time: TTntDateTimePicker;
    l_DaysMonth: TTntLabel;
    e_DaysMonth: TTntEdit;
    l_Timer: TTntLabel;
    e_Timer: TTntEdit;
    gb_Compression: TTntGroupBox;
    gb_Encryption: TTntGroupBox;
    l_CompressionMethod: TTntLabel;
    cb_Compression: TTntComboBox;
    l_Split: TTntLabel;
    cb_Split: TTntComboBox;
    l_Custom: TTntLabel;
    e_Custom: TTntEdit;
    cb_Protect: TTntCheckBox;
    e_Password: TTntEdit;
    l_Password: TTntLabel;
    l_PasswordRe: TTntLabel;
    e_PasswordRe: TTntEdit;
    l_Comment: TTntLabel;
    e_Comment: TTntEdit;
    l_Encryption: TTntLabel;
    cb_Encryption: TTntComboBox;
    l_Passphrase: TTntLabel;
    e_Passphrase: TTntEdit;
    e_PassphraseRe: TTntEdit;
    l_PassphraseRe: TTntLabel;
    l_Quality: TTntLabel;
    l_Key: TTntLabel;
    e_Key: TTntEdit;
    b_SelectKey: TTntButton;
    l_Include: TTntLabel;
    lb_Include: TTntListBox;
    b_IncludeAdd: TTntBitBtn;
    b_IncludeEdit: TTntBitBtn;
    b_IncludeDelete: TTntBitBtn;
    l_Exclude: TTntLabel;
    lb_Exclude: TTntListBox;
    b_ExcludeAdd: TTntBitBtn;
    b_ExcludeEdit: TTntBitBtn;
    b_ExcludeDelete: TTntBitBtn;
    l_Before: TTntLabel;
    lb_BeforeBackup: TTntListBox;
    b_BeforeAdd: TTntBitBtn;
    b_BeforeDelete: TTntBitBtn;
    l_AfterBackup: TTntLabel;
    lb_AfterBackup: TTntListBox;
    b_AfterAdd: TTntBitBtn;
    b_AfterDelete: TTntBitBtn;
    l_Month: TTntLabel;
    cb_Month: TTntComboBox;
    tab_Advanced: TTntTabSheet;
    cb_Impersonate: TTntCheckBox;
    l_ImpersonateID: TTntLabel;
    e_ImpersonateID: TTntEdit;
    l_ImpersonateDomain: TTntLabel;
    e_ImpersonateDomain: TTntEdit;
    l_ImpersonatePassword: TTntLabel;
    e_ImpersonatePassword: TTntEdit;
    cb_ImpersonateCancel: TTntCheckBox;
    b_BeforeEdit: TTntBitBtn;
    b_AfterEdit: TTntBitBtn;
    dlg_Open: TTntOpenDialog;
    pop_ExcludeIncludeAdd: TTntPopupMenu;
    m_ExcludeFile: TTntMenuItem;
    m_ExcludeDir: TTntMenuItem;
    m_ExcludeMask: TTntMenuItem;
    pop_Events: TTntPopupMenu;
    m_Pause: TTntMenuItem;
    m_Execute: TTntMenuItem;
    m_ExecuteAndWait: TTntMenuItem;
    m_CloseProgram: TTntMenuItem;
    m_StartService: TTntMenuItem;
    m_StopService: TTntMenuItem;
    m_Restart: TTntMenuItem;
    m_Shutdown: TTntMenuItem;
    m_Synchronize: TTntMenuItem;
    pop_SourceDestination: TTntPopupMenu;
    m_SDFile: TTntMenuItem;
    m_SDDirectory: TTntMenuItem;
    m_SDFTP: TTntMenuItem;
    m_SDManually: TTntMenuItem;
    cb_ResetArchive: TTntCheckBox;
    pb_Quality: TCobBarW;
    b_SourceOrder: TTntBitBtn;
    b_DestinationOrder: TTntBitBtn;
    pop_Order: TTntPopupMenu;
    m_ByType: TTntMenuItem;
    m_Alpha: TTntMenuItem;
    pop_MoveEvents: TTntPopupMenu;
    m_Up: TTntMenuItem;
    m_Down: TTntMenuItem;
    procedure m_DownClick(Sender: TObject);
    procedure m_UpClick(Sender: TObject);
    procedure pop_MoveEventsPopup(Sender: TObject);
    procedure m_ByTypeClick(Sender: TObject);
    procedure m_AlphaClick(Sender: TObject);
    procedure b_DestinationOrderClick(Sender: TObject);
    procedure b_SourceOrderClick(Sender: TObject);
    procedure l_ExplorerClick(Sender: TObject);
    procedure b_DestinationEditClick(Sender: TObject);
    procedure b_SourceEditClick(Sender: TObject);
    procedure b_DestinationDeleteClick(Sender: TObject);
    procedure b_SourceDeleteClick(Sender: TObject);
    procedure m_SDFTPClick(Sender: TObject);
    procedure m_SDManuallyClick(Sender: TObject);
    procedure m_SDDirectoryClick(Sender: TObject);
    procedure lb_DestinationClick(Sender: TObject);
    procedure lb_SourceClick(Sender: TObject);
    procedure m_SDFileClick(Sender: TObject);
    procedure b_SourceAddClick(Sender: TObject);
    procedure m_SynchronizeClick(Sender: TObject);
    procedure m_ShutdownClick(Sender: TObject);
    procedure m_RestartClick(Sender: TObject);
    procedure lb_ExcludeDblClick(Sender: TObject);
    procedure lb_IncludeDblClick(Sender: TObject);
    procedure lb_AfterBackupDblClick(Sender: TObject);
    procedure lb_BeforeBackupDblClick(Sender: TObject);
    procedure m_StartServiceClick(Sender: TObject);
    procedure m_CloseProgramClick(Sender: TObject);
    procedure m_ExecuteAndWaitClick(Sender: TObject);
    procedure m_ExecuteClick(Sender: TObject);
    procedure lb_BeforeBackupClick(Sender: TObject);
    procedure m_PauseClick(Sender: TObject);
    procedure b_AfterAddClick(Sender: TObject);
    procedure b_BeforeAddClick(Sender: TObject);
    procedure b_AfterEditClick(Sender: TObject);
    procedure b_BeforeEditClick(Sender: TObject);
    procedure b_AfterDeleteClick(Sender: TObject);
    procedure b_BeforeDeleteClick(Sender: TObject);
    procedure b_ExcludeDeleteClick(Sender: TObject);
    procedure b_IncludeDeleteClick(Sender: TObject);
    procedure b_ExcludeEditClick(Sender: TObject);
    procedure b_IncludeEditClick(Sender: TObject);
    procedure m_ExcludeFileClick(Sender: TObject);
    procedure m_ExcludeDirClick(Sender: TObject);
    procedure m_ExcludeMaskClick(Sender: TObject);
    procedure b_ExcludeAddClick(Sender: TObject);
    procedure lb_IncludeClick(Sender: TObject);
    procedure b_IncludeAddClick(Sender: TObject);
    procedure b_SelectKeyClick(Sender: TObject);
    procedure cb_SeparatedClick(Sender: TObject);
    procedure cb_ImpersonateClick(Sender: TObject);
    procedure cb_EncryptionChange(Sender: TObject);
    procedure cb_CompressionChange(Sender: TObject);
    procedure cb_ScheduleTypeChange(Sender: TObject);
    procedure e_PassphraseKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TntFormDestroy(Sender: TObject);
    procedure TntFormClose(Sender: TObject; var Action: TCloseAction);
    procedure e_NameKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure lb_MenuClick(Sender: TObject);
    procedure lb_MenuDrawItem(Control: TWinControl; Index: Integer; Rect: TRect;
      State: TOwnerDrawState);
    procedure b_OKClick(Sender: TObject);
    procedure b_CancelClick(Sender: TObject);
    procedure TntFormShow(Sender: TObject);
    procedure TntFormCreate(Sender: TObject);
  private
    { Private declarations }
    FFirstTime: boolean;
    FS: TFormatSettings;
    FSettings: WideString;
    FTools: TCobTools;
    FEvSender: integer;
    FSDSender: integer;
    FShowIcons: boolean;
    FNewTask: boolean;
    FLastUsedFTP: WideString;
    FMenuExclude: boolean;
    FEvList: TTntListBox;
    FLastDirectory: WideString;
    procedure GetInterfaceText();
    function GenerateTaskName(): WideString;
    function GenerateTaskID(): WideString;
    procedure ShowEventMenu(Sender: TObject);
    procedure ShowSDMenu(Sender: TObject);
    procedure ShowSpecialMenu();
    procedure SetNameLabels();
    procedure AlignExplorerLabel();
    procedure SimpleListEdit(Sender: TObject);
    procedure SimpleListDelete(Sender: TObject);
    procedure LoadTask();
    procedure LoadStdTask();
    function GetSettingsFileName(): WideString;
    procedure SetBackupType(const Backup: integer);
    function GetBackupType(): integer;
    procedure GetLastUsedSingleSettings();
    procedure AddSDItem(const Path: WideString; const Kind: integer;
                        const List: TTntListBox);
    procedure DeleteSDItem(const Index: integer; const List: TTntListBox);
    procedure ClearSDList(const List: TTntListBox);
    procedure SetWeekDays(const Days: WideString);
    function GetWeekDays(): WideString;
    procedure SetAWeekDay(const Day: integer);
    function GetSDEncoded(const List: TTntListBox): WideString;
    procedure DecodeSD(const Encoded: WideString; const List: TTntListBox);
    procedure SaveStdTask();
    function ValidateForm(): boolean;
    function CheckDaysMonth(const Value: WideString): boolean;
    function EncodeDateTime(): TDateTime;
    procedure GetBitmap(Bitmap: TBitMap; Control: TWinControl;Index:integer);
    function EncodeEvent(const Event, Param1, Param2: WideString): WideString;
    procedure DeleteSelectedSDItems(Sender: TTntListBox);
    procedure EditSelectedSDItems(Sender: TTntListBox);
    function EditSDNormal(const Original: WideString; var ToShow: WideString): WideString;
    function EditSDFTP(const Original: WideString; var ToShow: WideString): WideString;
    procedure CheckUI();
    procedure CheckUISource();
    procedure CheckUIDestination();
    procedure CheckUIScheduler();
    procedure CheckUIArchive();
    procedure CheckUIEncryption();
    procedure CheckUIAdvanced();
    procedure CheckUIEvents();
    procedure CheckUISpecial();
    procedure CheckUIGeneral();
    procedure SetIndex(const Index: integer);
    procedure AddUpdateTask();
    function GetUNCPath(const FileName: WideString): WideString;
    procedure GetQualityVisually();
    ///Get  the list box where the files have been doped
    procedure GetDropListBox(var ListBox: TTntListBox);
    procedure ShowOrderMenu(const Sender: TObject);
  public
    { Public declarations }
    InitialSource: WideString;
  protected
    /// Handles the drag and drop stuff
    procedure WMDropFiles(var Msg: TMessage); message WM_DROPFILES;
  end;

var
  form_Task: Tform_Task;

implementation

uses bmConstants, bmTranslator, interface_Common, CobCommonW,
  {$IFDEF COMPILER_9_UP} WideStrings, {$ENDIF}
  CobEncrypt, bmCustomize, CobDialogsW, TntSysUtils,
  interface_Services, interface_FTP, ShellApi;

{$R *.dfm}

procedure Tform_Task.AddSDItem(const Path: WideString; const Kind: integer;
                               const List: TTntListBox);
var
  Data: TSDData;
begin
  Data:= TSDData.Create(Kind,Path);
  List.AddItem(Data.GetToShow(),Data);
end;

procedure Tform_Task.AlignExplorerLabel();
begin
  l_Explorer.Left:= (tab_Files.Width div 2) - (l_Explorer.Width div 2);
end;

procedure Tform_Task.b_AfterAddClick(Sender: TObject);
begin
  ShowEventMenu(b_AfterAdd);
  FEvSender:= INT_SENDERAFTER;
end;

procedure Tform_Task.b_AfterDeleteClick(Sender: TObject);
begin
  SimpleListDelete(lb_AfterBackup);
end;

procedure Tform_Task.b_AfterEditClick(Sender: TObject);
begin
  SimpleListEdit(lb_AfterBackup);
end;


procedure Tform_Task.m_AlphaClick(Sender: TObject);
var
  ListBox: TTntListBox;
  List: TTntStringList;
  i: integer;
  Ob, ObOrig: TSDData;
begin
  if (FSDSender = INT_SENDERSOURCE) then
    ListBox:= lb_Source else
    ListBox:= lb_Destination;

  // I could use assign but there is a problem when
  // assigned objects. There is some kind of memory leak in the VCL

  List:= TTntStringList.Create();
  try
    List.Sorted:= true;
    for i:=0 to ListBox.Items.Count - 1 do
    begin
      ObOrig:= TSDData(ListBox.Items.Objects[i]);
      Ob:= TSDData.Create(ObOrig.FKind, ObOrig.FFullPath);
      List.AddObject(ListBox.Items[i], Ob);
    end;

    ClearSDList(ListBox);

   for i:= 0 to List.Count - 1  do
   begin
     Ob:= TSDData(List.Objects[i]);
     AddSDItem(Ob.FFullPath,Ob.FKind, ListBox);
     FreeAndNil(Ob);
   end;

   List.Clear();
  finally
    FreeAndNil(List);
  end;

  if (FSDSender = INT_SENDERSOURCE) then
    CheckUISource() else
    CheckUIDestination();
end;

procedure Tform_Task.b_BeforeAddClick(Sender: TObject);
begin
  ShowEventMenu(b_BeforeAdd);
  FEvSender:= INT_SENDERBEFORE;
end;

procedure Tform_Task.b_BeforeDeleteClick(Sender: TObject);
begin
  SimpleListDelete(lb_BeforeBackup);
end;

procedure Tform_Task.b_BeforeEditClick(Sender: TObject);
begin
  SimpleListEdit(lb_BeforeBackup);
end;

procedure Tform_Task.b_CancelClick(Sender: TObject);
begin
  Tag:= INT_MODALRESULTCANCEL;
  Close();
end;

procedure Tform_Task.b_DestinationDeleteClick(Sender: TObject);
begin
  DeleteSelectedSDItems(lb_Destination);
end;

procedure Tform_Task.b_DestinationEditClick(Sender: TObject);
begin
  EditSelectedSDItems(lb_Destination);
end;

procedure Tform_Task.b_DestinationOrderClick(Sender: TObject);
begin
  ShowOrderMenu(Sender);
end;

procedure Tform_Task.b_ExcludeAddClick(Sender: TObject);
begin
  FMenuExclude:= true;
  ShowSpecialMenu();
end;

procedure Tform_Task.b_ExcludeDeleteClick(Sender: TObject);
begin
  SimpleListDelete(lb_Exclude);
end;

procedure Tform_Task.b_ExcludeEditClick(Sender: TObject);
begin
  SimpleListEdit(lb_Exclude);
end;

procedure Tform_Task.b_IncludeAddClick(Sender: TObject);
begin
  FMenuExclude:= false;
  ShowSpecialMenu();
end;

procedure Tform_Task.b_IncludeDeleteClick(Sender: TObject);
begin
  SimpleListDelete(lb_Include);
end;

procedure Tform_Task.b_IncludeEditClick(Sender: TObject);
begin
  SimpleListEdit(lb_Include);
end;

procedure Tform_Task.SimpleListDelete(Sender: TObject);
var
  i: integer;
  lb: TTntListBox;
begin
  if not (Sender is TTntListBox) then
    Exit;

  lb:= Sender as TTntListBox;

  if (lb.SelCount > 0) then
    if (CobMessageBoxW(self.Handle,Translator.GetMessage('34'),
          WS_PROGRAMNAMESHORT, MB_YESNO) = IDYES) then
      begin
        for i:= lb.Items.Count - 1 downto 0 do
          if (lb.Selected[i]) then
            lb.Items.Delete(i);
        CheckUISpecial();
        CheckUIEvents();
      end;
end;

procedure Tform_Task.SimpleListEdit(Sender: TObject);
var
  i: integer;
  Text: WideString;
  lb: TTntListBox;
begin
  if not (Sender is TTntListBox) then
    Exit;

  lb:= Sender as TTntListBox;

  if (lb.SelCount > 0) then
  begin
    for i:=0 to lb.Items.Count-1 do
      if (lb.Selected[i]) then
        begin
        Text:= lb.Items[i];
        if (InputQueryW(WS_PROGRAMNAMESHORT, Translator.GetMessage('33'), false, Text)) then
          if (Text <> WS_NIL) then
            lb.Items[i]:= Text;
        end;
    CheckUISpecial();
    CheckUIEvents();
  end;
end;

procedure Tform_Task.b_OKClick(Sender: TObject);
begin
  if (ValidateForm()) then
  begin
    Tag:= INT_MODALRESULTOK;
    SaveStdTask();
    AddUpdateTask();        
    Close();
  end;
end;

procedure Tform_Task.b_SelectKeyClick(Sender: TObject);
begin
  dlg_Open.Title:= Translator.GetMessage('28');
  dlg_Open.DefaultExt:= WS_DEFPUBLICKEYEXTDLG;
  dlg_Open.Filter:= WideFormat(WS_PUBLICKEYFILTER,
                    [Translator.GetMessage('26'), Translator.GetMessage('27')],FS);
  dlg_Open.FilterIndex:= 1;
  // dlg_Open.InitialDir:= CobGetSpecialDirW(cobPersonal);
  dlg_Open.Options:= dlg_Open.Options - [ofAllowMultiSelect];
  if (dlg_Open.Execute) then
    e_Key.Text:= dlg_Open.FileName;
end;

procedure Tform_Task.b_SourceAddClick(Sender: TObject);
begin
  ShowSDMenu(Sender);
end;

procedure Tform_Task.b_SourceDeleteClick(Sender: TObject);
begin
  DeleteSelectedSDItems(lb_Source);
end;

procedure Tform_Task.b_SourceEditClick(Sender: TObject);
begin
  EditSelectedSDItems(lb_Source);
end;

procedure Tform_Task.b_SourceOrderClick(Sender: TObject);
begin
  ShowOrderMenu(Sender);
end;

procedure Tform_Task.cb_CompressionChange(Sender: TObject);
begin
  CheckUIArchive();
end;

procedure Tform_Task.cb_EncryptionChange(Sender: TObject);
begin
  CheckUIEncryption();
end;

procedure Tform_Task.cb_ImpersonateClick(Sender: TObject);
begin
  CheckUIAdvanced();
end;

procedure Tform_Task.cb_ScheduleTypeChange(Sender: TObject);
begin
  CheckUIScheduler();
end;

procedure Tform_Task.cb_SeparatedClick(Sender: TObject);
begin
  CheckUIGeneral();
end;

function Tform_Task.CheckDaysMonth(const Value: WideString): boolean;
var
  i: integer;
  Sl: TTntStringList;
begin
  Result:= true;
  Sl:= TTntStringList.Create();
  try
    Sl.CommaText:= Value;
    for i:= 0 to Sl.Count - 1 do
      if (not CobIsIntW(Sl[i])) then
        begin
          Result:= false;
          Break;
        end;
  finally
    FreeAndNil(Sl);
  end;
end;

procedure Tform_Task.CheckUI();
begin
  CheckUIGeneral();

  CheckUISource();

  CheckUIDestination();

  CheckUIScheduler();

  CheckUIArchive();

  CheckUIEncryption();

  CheckUIAdvanced();

  CheckUIEvents();

  CheckUISpecial();

  CheckHorizontalBar(lb_Menu);
end;

procedure Tform_Task.CheckUIAdvanced();
begin
  cb_ImpersonateCancel.Enabled:= cb_Impersonate.Checked;
  l_ImpersonateID.Enabled:= cb_Impersonate.Checked;;
  e_ImpersonateID.Enabled:= cb_Impersonate.Checked;
  l_ImpersonateDomain.Enabled:= cb_Impersonate.Checked;
  e_ImpersonateDomain.Enabled:= cb_Impersonate.Checked;
  l_ImpersonatePassword.Enabled:= cb_Impersonate.Checked;
  e_ImpersonatePassword.Enabled:= cb_Impersonate.Checked;
end;

procedure Tform_Task.CheckUIArchive();
begin
  l_Split.Enabled:= (cb_Compression.ItemIndex <> INT_COMPNOCOMP);
  cb_Split.Enabled:= l_Split.Enabled;

  l_Custom.Enabled:= (cb_Compression.ItemIndex <> INT_COMPNOCOMP) and
                     (cb_Split.ItemIndex = INT_SPLITCUSTOM);
  e_Custom.Enabled:= l_Custom.Enabled;

  cb_Protect.Enabled:= (cb_Compression.ItemIndex <> INT_COMPNOCOMP);
  l_Password.Enabled:= (cb_Compression.ItemIndex <> INT_COMPNOCOMP) and
                       (cb_Protect.Checked);
  e_Password.Enabled:= l_Password.Enabled;
  l_PasswordRe.Enabled:= l_Password.Enabled;
  e_PasswordRe.Enabled:= l_Password.Enabled;

  l_Comment.Enabled:= (cb_Compression.ItemIndex <> INT_COMPNOCOMP);
  e_Comment.Enabled:= l_Comment.Enabled;
end;

procedure Tform_Task.CheckUISource();
begin
  b_SourceEdit.Enabled := (lb_Source.SelCount > 0);
  b_SourceDelete.Enabled := (lb_Source.SelCount > 0);
  b_SourceOrder.Enabled:= (lb_Source.Items.Count > 0);

  CheckHorizontalBar(lb_Source);
end;

procedure Tform_Task.CheckUISpecial();
begin
  b_IncludeEdit.Enabled:= (lb_Include.SelCount > 0);
  b_IncludeDelete.Enabled:= (lb_Include.SelCount > 0);

  b_ExcludeEdit.Enabled:= (lb_Exclude.SelCount > 0);
  b_ExcludeDelete.Enabled:= (lb_Exclude.SelCount > 0);

  CheckHorizontalBar(lb_Include);
  CheckHorizontalBar(lb_Exclude);
end;

procedure Tform_Task.CheckUIDestination();
begin
  b_DestinationEdit.Enabled := (lb_Destination.SelCount > 0);
  b_DestinationDelete.Enabled := (lb_Destination.SelCount > 0);
  b_DestinationOrder.Enabled:= (lb_Destination.Items.Count > 0);

  CheckHorizontalBar(lb_Destination);
end;

procedure Tform_Task.CheckUIEncryption();
begin
  l_Passphrase.Enabled:= (cb_Encryption.ItemIndex <> INT_ENCNOENC) and
                         (cb_Encryption.ItemIndex <> INT_ENCRSA);
  e_Passphrase.Enabled:= l_Passphrase.Enabled;
  l_PassphraseRe.Enabled:= l_Passphrase.Enabled;
  e_PassphraseRe.Enabled:= l_Passphrase.Enabled;
  l_Quality.Enabled:= l_Passphrase.Enabled;
  pb_Quality.Enabled:= l_Passphrase.Enabled;
  l_Key.Enabled:= (cb_Encryption.ItemIndex <> INT_ENCNOENC) and
                  (cb_Encryption.ItemIndex = INT_ENCRSA);
  e_Key.Enabled:= l_Key.Enabled;
  b_SelectKey.Enabled:= l_Key.Enabled;
end;

procedure Tform_Task.CheckUIEvents();
begin
  b_BeforeEdit.Enabled:= (lb_BeforeBackup.SelCount > 0);
  b_BeforeDelete.Enabled:= (lb_BeforeBackup.SelCount > 0);

  b_AfterEdit.Enabled:= (lb_AfterBackup.SelCount > 0);
  b_AfterDelete.Enabled:= (lb_AfterBackup.SelCount > 0);

  CheckHorizontalBar(lb_BeforeBackup);
  CheckHorizontalBar(lb_AfterBackup);
end;

procedure Tform_Task.CheckUIGeneral();
begin
  rb_Differential.Enabled:= cb_Attributes.Checked;
  if (cb_Attributes.Checked) then
    rb_Incremental.Enabled:= true else
    rb_Incremental.Enabled:= not cb_Separated.Checked;

  if (not cb_Attributes.Checked) then
  begin
    if (rb_Differential.Checked) then
      rb_Full.Checked:= true;

    if (rb_Incremental.Checked and cb_Separated.Checked) then
      rb_Full.Checked:= true;    
  end;

  l_FullCopies.Enabled:= cb_Separated.Checked;
  e_FullCopies.Enabled:= l_FullCopies.Enabled;
  l_MakeFull.Enabled:= (rb_Incremental.Checked or rb_Differential.Checked);
  e_MakeFull.Enabled:= l_MakeFull.Enabled;
end;

procedure Tform_Task.CheckUIScheduler();
begin
  gb_DaysWeek.Enabled := (cb_ScheduleType.ItemIndex = INT_SCWEEKLY);
  cb_Monday.Enabled := (cb_ScheduleType.ItemIndex = INT_SCWEEKLY);
  cb_Tuesday.Enabled := (cb_ScheduleType.ItemIndex = INT_SCWEEKLY);
  cb_Wednesday.Enabled := (cb_ScheduleType.ItemIndex = INT_SCWEEKLY);
  cb_Thursday.Enabled := (cb_ScheduleType.ItemIndex = INT_SCWEEKLY);
  cb_Friday.Enabled := (cb_ScheduleType.ItemIndex = INT_SCWEEKLY);
  cb_Saturday.Enabled := (cb_ScheduleType.ItemIndex = INT_SCWEEKLY);
  cb_Sunday.Enabled := (cb_ScheduleType.ItemIndex = INT_SCWEEKLY);

  dt_Date.Enabled:= (cb_ScheduleType.ItemIndex = INT_SCONCE);
  l_Date.Enabled:= dt_date.Enabled;

  dt_Time.Enabled:= (cb_ScheduleType.ItemIndex = INT_SCDAILY) or
                    (cb_ScheduleType.ItemIndex = INT_SCONCE) or
                    (cb_ScheduleType.ItemIndex = INT_SCWEEKLY) or
                    (cb_ScheduleType.ItemIndex = INT_SCMONTHLY) or
                    (cb_ScheduleType.ItemIndex = INT_SCYEARLY);
  l_Time.Enabled:= dt_Time.Enabled;

  e_DaysMonth.Enabled:= (cb_ScheduleType.ItemIndex = INT_SCMONTHLY) or
                        (cb_ScheduleType.ItemIndex = INT_SCYEARLY);
  l_DaysMonth.Enabled:= e_DaysMonth.Enabled;

  cb_Month.Enabled:= (cb_ScheduleType.ItemIndex = INT_SCYEARLY);
  l_Month.Enabled:= cb_Month.Enabled;

  e_Timer.Enabled:= (cb_ScheduleType.ItemIndex = INT_SCTIMER);
  l_Timer.Enabled:= e_Timer.Enabled;

  gb_DateTime.Enabled:= (cb_ScheduleType.ItemIndex <> INT_SCMANUALLY);
end;

procedure Tform_Task.ClearSDList(const List: TTntListBox);
var
  i: integer;
begin
  for i:= List.Items.Count-1 downto 0 do
    DeleteSDItem(i,List);
  List.Clear();
end;

procedure Tform_Task.DeleteSDItem(const Index: integer; const List: TTntListBox);
var
  Data: TSDData;
begin
  //Deletes an item from the source or
  //destination list. It frees the data object
  if Index > List.Count - 1 then
    Exit;

  Data:= TSDData(List.Items.Objects[Index]);
  if (Data <> nil) then
  begin
    FreeAndNil(Data);
    List.Items.Delete(Index);
  end;
end;

procedure Tform_Task.DeleteSelectedSDItems(Sender: TTntListBox);
var
  i: integer;
  Prompt: WideString;
begin
  if (Sender = lb_Source) then
    Prompt:= Translator.GetMessage('63') else
    Prompt:= Translator.GetMessage('64');
  if (CobMessageBoxW(self.Handle, Prompt,
                      WS_PROGRAMNAMESHORT,MB_YESNO) = mrYes) then
  begin
    for i:=Sender.Items.Count-1 downto 0 do
      if (Sender.Selected[i]) then
        DeleteSDItem(i, Sender);
    if (Sender = lb_Source) then
      CheckUISource() else
      CheckUIDestination();
  end;
end;

function Tform_Task.EditSDFTP(const Original: WideString; var ToShow: WideString): WideString;
var
  form_FTP: Tform_FTP;
  Temp: WideString;
begin
  Result:= Original;
  Temp:= Original;
  form_FTP:= Tform_FTP.Create(nil);
  try
    form_FTP.FTP.DecodeAddress(Original);
    form_FTP.ShowModal();
    if (form_FTP.Tag = INT_MODALRESULTOK) then
    begin
      Result:= form_FTP.FTP.EncodeAddress();
      ToShow:= form_FTP.FTP.EncodeAddressDisplay();
      FLastUsedFTP:= form_FTP.FTP.EncodeAddress();
    end;
  finally
    form_FTP.Release();
  end;
end;

function Tform_Task.EditSDNormal(const Original: WideString; var ToShow: WideString): WideString;
var
  Temp: WideString;
begin
  Result:= Original;
  Temp:= Original;
  if (InputQueryW(WS_PROGRAMNAMESHORT, Translator.GetMessage('33'), false, Temp)) then
  begin
    if (WideFileExists(Temp)) or (WideDirectoryExists(Temp)) then
      Temp:= GetUNCPath(Temp);
    Result:= Temp;
    ToShow:= Temp;
  end;
end;

procedure Tform_Task.EditSelectedSDItems(Sender: TTntListBox);
var
  i: integer;
  Data: TSDData;
begin
  for i:= 0 to Sender.Items.Count-1 do
    if (Sender.Selected[i]) then
      begin
        Data:= TSDData(Sender.Items.Objects[i]);
        if (Data.FKind = INT_SDFTP) then
          Data.FFullPath:= EditSDFTP(Data.FFullPath, Data.FToShow) else
          begin
            Data.FFullPath:= EditSDNormal(Data.FFullPath, Data.FToShow);
            if (WideFileExists(Data.FFullPath)) then
              Data.FKind:= INT_SDFILE else
              if (WideDirectoryExists(Data.FFullPath)) then
              Data.FKind:= INT_SDDIR else
              Data.FKind:= INT_SDMANUAL;
          end;
        Sender.Items[i]:= Data.FToShow;
      end;

  if (Sender = lb_Source) then
    CheckUISource() else
    CheckUIDestination();
end;

function Tform_Task.EncodeDateTime(): TDateTime;
begin
  Result:= Trunc(dt_Date.DateTime) + Frac(dt_Time.DateTime);
end;

function Tform_Task.EncodeEvent(const Event, Param1,
  Param2: WideString): WideString;
var
  Sl: TTntStringList;
begin
  Sl:= TTntStringList.Create();
  try
    Sl.Add(Event);
    Sl.Add(Param1);
    Sl.Add(Param2);
    Result:= Sl.CommaText;
  finally
    FreeAndNil(Sl);
  end;
end;

procedure Tform_Task.DecodeSD(const Encoded: WideString;
  const List: TTntListBox);
var
  i: integer;
  Sl: TTntStringList;
  Path: WideString;
  Kind: integer;
begin
  Sl:= TTntStringList.Create();
  try
    Sl.CommaText:= Encoded;
    for i:=0 to Sl.Count-1 do
    begin
      Path:= FTools.DecodeSD(Sl[i],Kind);
      AddSDItem(Path,Kind,List);
    end;
  finally
    FreeAndNil(Sl);
  end;
end;

procedure Tform_Task.e_NameKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  SetNameLabels();
end;

procedure Tform_Task.e_PassphraseKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  GetQualityVisually();
end;

function Tform_Task.GenerateTaskID(): WideString;
var
  GUID: TGUID;
begin
  CreateGUID(GUID);
  Result:= WideString(GUIDToString(GUID));
end;

function Tform_Task.GenerateTaskName(): WideString;
var
  i: integer;
  ID: WideString;
begin
  i:= 0;
  repeat
    inc(i);
    Result:= WideFormat(Translator.GetMessage('25'),[i],FS);
  until (Settings.TaskNameExists(Result, ID) = INT_TASKNOTFOUND);
end;

function Tform_Task.GetBackupType(): integer;
begin
  if (rb_Incremental.Checked) then
  begin
    Result:= INT_BUINCREMENTAL;
    Exit;
  end;
  if (rb_Differential.Checked) then
  begin
    Result:= INT_BUDIFFERENTIAL;
    Exit;
  end;
  if (rb_Dummy.Checked) then
  begin
    Result:= INT_BUDUMMY;
    Exit;
  end;
  Result:= INT_BUFULL;
end;

procedure Tform_Task.GetBitmap(Bitmap: TBitMap; Control: TWinControl;
  Index: integer);
var
  lb: TTntListBox;
  Data: TSDData;
begin
  if not (Control is TTntListBox) then
    Exit;

  lb:= Control as TTntListBox;

  if (lb = lb_Menu) then
    begin
      il_Task.GetBitmap(Index, Bitmap);
      Exit;
    end;

  if (lb = lb_Include) or (lb = lb_Exclude) then
  begin
    if (WideFileExists(lb.Items[Index])) then
      il_Task.GetBitmap(INT_INDEXFILEICON, Bitmap) else
      if (WideDirectoryExists(WideExtractFilePath(lb.Items[Index]))) then
        il_Task.GetBitmap(INT_INDEXDIRICON, Bitmap) else
        il_Task.GetBitmap(INT_INDEXUMASKICON, Bitmap);
    Exit;
  end;

  if (lb = lb_BeforeBackup) or (lb = lb_AfterBackup) then
    begin
      il_Task.GetBitmap(INT_INDEXEVENTICON, Bitmap);
      Exit;
    end;

  if (lb = lb_Source) or (lb = lb_Destination) then
  begin
    Data:= TSDData(lb.Items.Objects[Index]);
    case Data.FKind of
      INT_SDFILE: il_Task.GetBitmap(INT_INDEXFILEICON, Bitmap);
      INT_SDDIR: il_Task.GetBitmap(INT_INDEXDIRICON, Bitmap);
      INT_SDFTP: il_Task.GetBitmap(INT_INDEXFTPICON, Bitmap);
      else
        il_Task.GetBitmap(INT_INDEXUMASKICON, Bitmap);
    end;
    Exit;
  end;
end;

procedure Tform_Task.GetDropListBox(var ListBox: TTntListBox);
var
  Control: TWinControl;
  ScrMousePosn: TPoint;
begin
  ListBox := nil;
  GetCursorPos(ScrMousePosn);
  //ScrMousePosn:=ScreenToClient(ScrMousePosn);
  Control := FindVCLWindow(ScrMousePosn);
  if Control <> nil then
    if Control is TTntListBox then
      ListBox := Control as TTntListBox;
end;

procedure Tform_Task.GetInterfaceText();
begin
  lb_Menu.Clear();
  lb_Menu.Items.Add(Translator.GetInterfaceText('78'));
  lb_Menu.Items.Add(Translator.GetInterfaceText('79'));
  lb_Menu.Items.Add(Translator.GetInterfaceText('80'));
  lb_Menu.Items.Add(Translator.GetInterfaceText('81'));
  lb_Menu.Items.Add(Translator.GetInterfaceText('82'));
  lb_Menu.Items.Add(Translator.GetInterfaceText('83'));
  lb_Menu.Items.Add(Translator.GetInterfaceText('217'));
  le_Name.Caption:= Translator.GetInterfaceText('84');
  cb_Disabled.Caption:= Translator.GetInterfaceText('85');
  cb_Disabled.Hint:= Translator.GetInterfaceText('86');
  e_Name.Hint:= Translator.GetInterfaceText('87');
  cb_IncludeSubdirs.Caption:= Translator.GetInterfaceText('88');
  cb_IncludeSubdirs.Hint:= Translator.GetInterfaceText('89');
  cb_Separated.Caption:= Translator.GetInterfaceText('90');
  cb_Separated.Hint:= Translator.GetInterfaceText('91');
  cb_Attributes.Caption:= Translator.GetInterfaceText('92');
  cb_Attributes.Hint:= Translator.GetInterfaceText('93');
  gb_BackupType.Caption:= Translator.GetInterfaceText('94');
  rb_Full.Caption:= Translator.GetInterfaceText('95');
  rb_Full.Hint:= Translator.GetInterfaceText('96');
  rb_Incremental.Caption:= Translator.GetInterfaceText('97');
  rb_Incremental.Hint:= Translator.GetInterfaceText('98');
  rb_Differential.Caption:= Translator.GetInterfaceText('99');
  rb_Differential.Hint:= Translator.GetInterfaceText('100');
  rb_Dummy.Caption:= Translator.GetInterfaceText('101');
  rb_Dummy.Hint:= Translator.GetInterfaceText('102');
  l_FullCopies.Caption:= Translator.GetInterfaceText('103');
  e_FullCopies.Hint:= Translator.GetInterfaceText('104');
  l_MakeFull.Caption:= Translator.GetInterfaceText('105');
  e_MakeFull.Hint := Translator.GetInterfaceText('106');
  l_Source.Caption := Translator.GetInterfaceText('107');
  l_Explorer.Caption:= Translator.GetInterfaceText('108');
  AlignExplorerLabel();
  b_SourceAdd.Caption := Translator.GetInterfaceText('109');
  b_SourceAdd.Hint := Translator.GetInterfaceText('110');
  b_SourceEdit.Caption:= Translator.GetInterfaceText('111');
  b_SourceEdit.Hint:= Translator.GetInterfaceText('112');
  b_SourceDelete.Caption:= Translator.GetInterfaceText('113');
  b_SourceDelete.Hint:= Translator.GetInterfaceText('114');

  l_Destination.Caption:= Translator.GetInterfaceText('115');
  b_DestinationAdd.Caption := Translator.GetInterfaceText('109');
  b_DestinationAdd.Hint := Translator.GetInterfaceText('116');
  b_DestinationEdit.Caption:= Translator.GetInterfaceText('111');
  b_DestinationEdit.Hint:= Translator.GetInterfaceText('117');
  b_DestinationDelete.Caption:= Translator.GetInterfaceText('113');
  b_DestinationDelete.Hint:= Translator.GetInterfaceText('118');

  l_ScheduleType.Caption:= Translator.GetInterfaceText('119');
  cb_ScheduleType.Clear();
  cb_ScheduleType.Items.Add(Translator.GetInterfaceText('120'));
  cb_ScheduleType.Items.Add(Translator.GetInterfaceText('121'));
  cb_ScheduleType.Items.Add(Translator.GetInterfaceText('122'));
  cb_ScheduleType.Items.Add(Translator.GetInterfaceText('123'));
  cb_ScheduleType.Items.Add(Translator.GetInterfaceText('124'));
  cb_ScheduleType.Items.Add(Translator.GetInterfaceText('143'));
  cb_ScheduleType.Items.Add(Translator.GetInterfaceText('125'));

  gb_DaysWeek.Caption:= Translator.GetInterfaceText('126');

  cb_Monday.Caption:= Translator.GetInterfaceText('127');
  cb_Tuesday.Caption:= Translator.GetInterfaceText('128');
  cb_Wednesday.Caption:= Translator.GetInterfaceText('129');
  cb_Thursday.Caption:= Translator.GetInterfaceText('130');
  cb_Friday.Caption:= Translator.GetInterfaceText('131');
  cb_Saturday.Caption:= Translator.GetInterfaceText('132');
  cb_Sunday.Caption:= Translator.GetInterfaceText('133');

  gb_DateTime.Caption:= Translator.GetInterfaceText('134');
  l_Date.Caption:= Translator.GetInterfaceText('135');
  dt_Date.Hint:= Translator.GetInterfaceText('136');
  dt_Time.Hint:= Translator.GetInterfaceText('137');
  l_Time.Caption:= Translator.GetInterfaceText('138');
  l_DaysMonth.Caption:= Translator.GetInterfaceText('139');
  e_DaysMonth.Hint:= Translator.GetInterfaceText('140');
  l_Timer.Caption:= Translator.GetInterfaceText('141');
  e_Timer.Hint:= Translator.GetInterfaceText('142');
  l_Month.Caption:= Translator.GetInterfaceText('204');
  cb_Month.Clear();
  cb_Month.Items.Add(Translator.GetInterfaceText('205'));
  cb_Month.Items.Add(Translator.GetInterfaceText('206'));
  cb_Month.Items.Add(Translator.GetInterfaceText('207'));
  cb_Month.Items.Add(Translator.GetInterfaceText('208'));
  cb_Month.Items.Add(Translator.GetInterfaceText('209'));
  cb_Month.Items.Add(Translator.GetInterfaceText('210'));
  cb_Month.Items.Add(Translator.GetInterfaceText('211'));
  cb_Month.Items.Add(Translator.GetInterfaceText('212'));
  cb_Month.Items.Add(Translator.GetInterfaceText('213'));
  cb_Month.Items.Add(Translator.GetInterfaceText('214'));
  cb_Month.Items.Add(Translator.GetInterfaceText('215'));
  cb_Month.Items.Add(Translator.GetInterfaceText('216'));

  gb_Compression.Caption:= Translator.GetInterfaceText('144');
  gb_Encryption.Caption:= Translator.GetInterfaceText('145');

  l_CompressionMethod.Caption:= Translator.GetInterfaceText('146');
  cb_Compression.Clear();
  cb_Compression.Items.Add(Translator.GetInterfaceText('147'));
  cb_Compression.Items.Add(Translator.GetInterfaceText('148'));
  cb_Compression.Items.Add(Translator.GetInterfaceText('149'));

  l_Split.Caption:= Translator.GetInterfaceText('150');
  cb_Split.Clear();
  cb_Split.Items.Add(Translator.GetInterfaceText('151'));
  cb_Split.Items.Add(Translator.GetInterfaceText('152'));
  cb_Split.Items.Add(Translator.GetInterfaceText('153'));
  cb_Split.Items.Add(Translator.GetInterfaceText('154'));
  cb_Split.Items.Add(Translator.GetInterfaceText('155'));
  cb_Split.Items.Add(Translator.GetInterfaceText('156'));
  cb_Split.Items.Add(Translator.GetInterfaceText('157'));
  cb_Split.Items.Add(Translator.GetInterfaceText('158'));
  cb_Split.Items.Add(Translator.GetInterfaceText('159'));
  cb_Split.Items.Add(Translator.GetInterfaceText('160'));
  cb_Split.Items.Add(Translator.GetInterfaceText('161'));
  cb_Split.Items.Add(Translator.GetInterfaceText('162'));

  l_Custom.Caption:= Translator.GetInterfaceText('163');
  e_Custom.Hint:= Translator.GetInterfaceText('164');

  cb_Protect.Caption:= Translator.GetInterfaceText('165');
  l_Password.Caption := Translator.GetInterfaceText('166');
  l_Passwordre.Caption := Translator.GetInterfaceText('167');
  l_Comment.Caption:= Translator.GetInterfaceText('168');
  e_Comment.Hint:= Translator.GetInterfaceText('169');

  l_Encryption.Caption:= Translator.GetInterfaceText('170');
  cb_Encryption.Clear();
  cb_Encryption.Items.Add(Translator.GetInterfaceText('171'));
  cb_Encryption.Items.Add(Translator.GetInterfaceText('172'));
  // cb_Encryption.Items.Add(Translator.GetInterfaceText('173'));
  cb_Encryption.Items.Add(Translator.GetInterfaceText('175'));
  cb_Encryption.Items.Add(Translator.GetInterfaceText('174'));
  cb_Encryption.Items.Add(Translator.GetInterfaceText('176'));

  l_Passphrase.Caption:= Translator.GetInterfaceText('177');
  l_PassphraseRe.Caption:= Translator.GetInterfaceText('178');
  l_Quality.Caption:= Translator.GetInterfaceText('179');
  l_Key.Caption:= Translator.GetInterfaceText('180');
  e_Key.Hint:= Translator.GetInterfaceText('181');
  b_SelectKey.Hint:= Translator.GetInterfaceText('182');

  l_Include.Caption:= Translator.GetInterfaceText('183');
  b_IncludeAdd.Caption:= Translator.GetInterfaceText('184');
  b_IncludeEdit.Caption:= Translator.GetInterfaceText('185');
  b_IncludeDelete.Caption:= Translator.GetInterfaceText('186');
  b_IncludeAdd.Hint:= Translator.GetInterfaceText('188');
  b_IncludeEdit.Hint:= Translator.GetInterfaceText('189');
  b_IncludeDelete.Hint:= Translator.GetInterfaceText('190');

  l_Exclude.Caption:= Translator.GetInterfaceText('187');
  b_ExcludeAdd.Caption:= Translator.GetInterfaceText('184');
  b_ExcludeEdit.Caption:= Translator.GetInterfaceText('185');
  b_ExcludeDelete.Caption:= Translator.GetInterfaceText('186');
  b_ExcludeAdd.Hint:= Translator.GetInterfaceText('191');
  b_ExcludeEdit.Hint:= Translator.GetInterfaceText('192');
  b_ExcludeDelete.Hint:= Translator.GetInterfaceText('193');

  l_Before.Caption:= Translator.GetInterfaceText('194');
  b_BeforeAdd.Caption:= Translator.GetInterfaceText('184');
  b_BeforeAdd.Hint:= Translator.GetInterfaceText('196');
  b_BeforeDelete.Caption:= Translator.GetInterfaceText('186');
  b_BeforeDelete.Hint:= Translator.GetInterfaceText('198');
  b_BeforeEdit.Caption:= Translator.GetInterfaceText('185');
  b_BeforeEdit.Hint:= Translator.GetInterfaceText('195');

  l_AfterBackup.Caption:= Translator.GetInterfaceText('199');
  b_AfterAdd.Caption:= Translator.GetInterfaceText('184');
  b_AfterDelete.Caption:= Translator.GetInterfaceText('186');
  b_AfterAdd.Hint:= Translator.GetInterfaceText('200');
  b_AfterDelete.Hint:= Translator.GetInterfaceText('201');
  b_AfterEdit.Caption:= Translator.GetInterfaceText('185');
  b_AfterEdit.Hint:= Translator.GetInterfaceText('197');

  cb_Impersonate.Caption:= Translator.GetInterfaceText('218');
  cb_Impersonate.Hint:= Translator.GetInterfaceText('219');
  l_ImpersonateID.Caption:= Translator.GetInterfaceText('220');
  e_ImpersonateID.Hint:= Translator.GetInterfaceText('221');
  l_ImpersonateDomain.Caption:= Translator.GetInterfaceText('222');
  e_ImpersonateDomain.Hint:= Translator.GetInterfaceText('223');
  l_ImpersonatePassword.Caption:= Translator.GetInterfaceText('224');
  e_ImpersonatePassword.Hint:= Translator.GetInterfaceText('225');

  cb_ImpersonateCancel.Caption:= Translator.GetInterfaceText('226');
  cb_ImpersonateCancel.Hint:= Translator.GetInterfaceText('227');

  m_ExcludeFile.Caption:= Translator.GetInterfaceText('230');
  m_ExcludeDir.Caption:= Translator.GetInterfaceText('231');
  m_ExcludeMask.Caption:= Translator.GetInterfaceText('232');
  m_Pause.Caption:= Translator.GetInterfaceText('233');
  m_Execute.Caption:= Translator.GetInterfaceText('234');
  m_ExecuteAndWait.Caption:= Translator.GetInterfaceText('235');
  m_CloseProgram.Caption:= Translator.GetInterfaceText('236');
  m_StartService.Caption:= Translator.GetInterfaceText('237');
  m_StopService.Caption:= Translator.GetInterfaceText('238');
  m_Restart.Caption:= Translator.GetInterfaceText('239');
  m_Shutdown.Caption:= Translator.GetInterfaceText('240');
  m_Synchronize.Caption:=  Translator.GetInterfaceText('246');
  m_SDFile.Caption:=  Translator.GetInterfaceText('230');
  m_SDDirectory.Caption:=  Translator.GetInterfaceText('231');
  m_SDFTP.Caption:=  Translator.GetInterfaceText('247');
  m_SDManually.Caption:=  Translator.GetInterfaceText('248');

  cb_ResetArchive.Caption:=  Translator.GetInterfaceText('362');
  cb_ResetArchive.Hint:=  Translator.GetInterfaceText('363');

  b_SourceOrder.Hint:= Translator.GetInterfaceText('722');
  b_DestinationOrder.Hint:= Translator.GetInterfaceText('722');

  m_Alpha.Caption:= Translator.GetInterfaceText('724');
  m_ByType.Caption:= Translator.GetInterfaceText('723');

  b_OK.Caption:= Translator.GetInterfaceText('B_OK');
  b_Cancel.Caption:= Translator.GetInterfaceText('B_CANCEL');
end;

procedure Tform_Task.GetLastUsedSingleSettings();
var
  Sl: TTntStringList;
begin
  FLastDirectory:= WS_NIL;
  FLastUsedFTP:= WS_NIL;
  Sl:= TTntStringList.Create();
  try
    if (WideFileExists(FSettings)) then
    begin
      Sl.LoadFromFile(FSettings);
      FLastUsedFTP:=  Sl.Values[WS_INILASTUSEDFTP];
      FLastDirectory:= Sl.Values[WS_INILASTUSEDDIRECTORY];
    end;
  finally
    FreeAndNil(Sl);
  end;
end;

function Tform_Task.GetSDEncoded(const List: TTntListBox): WideString;
var
  Data: TSDData;
  i: integer;
  Sl: TTntStringList;
begin
  Result:= WS_NIL;
  Sl:= TTntStringList.Create();
  try
    for i:=0 to List.Items.Count-1 do
      begin
        Data:= TSDData(List.Items.Objects[i]);
        if (Data <> nil) then
          Sl.Add(FTools.EncodeSD(Data.GetKind(), Data.GetFullPath()));
      end;
    Result:= Sl.CommaText;
  finally
    FreeAndNil(Sl);
  end;
end;

function Tform_Task.GetSettingsFileName(): WideString;
var
  SettingsPath, UserName: WideString;
begin
  SettingsPath:= Globals.SettingsPath;
  UserName:= CobGetCurrentUserNameW();
  if (UserName = WS_NIL) then
    UserName:= WS_DEFAULTUSERNAME;
  Result:= SettingsPath + WideFormat(WS_LASTUSERSETTINGS,[UserName], FS);
end;

function Tform_Task.GetUNCPath(const FileName: WideString): WideString;
begin
  Result:= FileName;
  if (UISettings.ConvertToUNC) then
    Result:= CobGetUniversalNameW(FileName);
end;

procedure Tform_Task.GetQualityVisually();
begin
  pb_Quality.Position := CobGetPasswordQuality(e_Passphrase.Text);
  if (pb_Quality.Position < 33) then
    pb_Quality.ColorScheme := ccwRed
  else if (pb_Quality.Position > 66) then
    pb_Quality.ColorScheme := ccwGreen
  else
    pb_Quality.ColorScheme := ccwYellow;
end;

function Tform_Task.GetWeekDays(): WideString;
var
  Sl: TTntStringList;
begin
  Sl:= TTntStringList.Create();
  try
    if (cb_Monday.Checked) then
      Sl.Add(CobIntToStrW(INT_DMONDAY));
    if (cb_Tuesday.Checked) then
      Sl.Add(CobIntToStrW(INT_DTUESDAY));
    if (cb_Wednesday.Checked) then
      Sl.Add(CobIntToStrW(INT_DWEDNESDAY));
    if (cb_Thursday.Checked) then                                                                        
      Sl.Add(CobIntToStrW(INT_DTHURSDAY));
    if (cb_Friday.Checked) then
      Sl.Add(CobIntToStrW(INT_DFRIDAY));
    if (cb_Saturday.Checked) then
      Sl.Add(CobIntToStrW(INT_DSATURDAY));
    if (cb_Sunday.Checked) then
      Sl.Add(CobIntToStrW(INT_DSUNDAY));
    Result:= Sl.CommaText;
  finally
    FreeAndNil(Sl);
  end;
end;

procedure Tform_Task.lb_AfterBackupDblClick(Sender: TObject);
begin
  SimpleListEdit(lb_AfterBackup);
end;

procedure Tform_Task.lb_BeforeBackupClick(Sender: TObject);
begin
  CheckUIEvents();
end;

procedure Tform_Task.lb_BeforeBackupDblClick(Sender: TObject);
begin
  SimpleListEdit(lb_BeforeBackup);
end;

procedure Tform_Task.lb_DestinationClick(Sender: TObject);
begin
  CheckUIDestination();
end;

procedure Tform_Task.lb_ExcludeDblClick(Sender: TObject);
begin
  SimpleListEdit(lb_Exclude);
end;

procedure Tform_Task.lb_IncludeClick(Sender: TObject);
begin
  CheckUISpecial();
end;

procedure Tform_Task.lb_IncludeDblClick(Sender: TObject);
begin
  SimpleListEdit(lb_Include);
end;

procedure Tform_Task.lb_MenuClick(Sender: TObject);
begin
  if (lb_Menu.ItemIndex <> -1) then
    pc_Task.ActivePageIndex:= lb_Menu.ItemIndex;
end;

procedure Tform_Task.lb_MenuDrawItem(Control: TWinControl; Index: Integer;
  Rect: TRect; State: TOwnerDrawState);
var
  Bitmap: TBitmap;
  Offset: Integer;
begin
  with (Control as TTntListBox).Canvas do
  begin
    Brush.Style := bsSolid;
    if odSelected in State then
      Brush.Color := RGB(INT_R, INT_G, INT_B)
    else
      Brush.Color := clWindow;

    FillRect(Rect);
    Offset := INT_ICONOFFSET;

    if (FShowIcons) then
    begin
      BitMap := TBitmap.Create();
      try
        Bitmap.Width := INT_LBHEIGHT;
        Bitmap.Height := INT_LBHEIGHT;

        GetBitmap(Bitmap,Control,Index);
      
        if Bitmap <> nil then
        begin
          BrushCopy(Bounds(Rect.Left + INT_ICONOFFSET,
                            Rect.Top + INT_ICONOFFSET,
                            Bitmap.Width,
                            Bitmap.Height),
                    Bitmap,
                    Bounds(0, 0, Bitmap.Width, Bitmap.Height), clWhite);
          Offset := Bitmap.Width + 2 * INT_ICONOFFSET;
        end;
      finally
        Bitmap.Free;
      end;
    end;
    Font.Color := clWindowText;
    Rect.Left:= OffSet;
    DrawTextW(Handle,PWideChar((Control as TTntListBox).Items[Index]),
            Length((Control as TTntListBox).Items[Index]),
            Rect, DT_VCENTER or DT_LEFT or DT_SINGLELINE );
  end;       
end;

procedure Tform_Task.lb_SourceClick(Sender: TObject);
begin
  CheckUISource();
end;

procedure Tform_Task.LoadStdTask();
var
  Sl: TTntStringList;
  Value, Password: WideString;
  OK: boolean;
  ADate: TDateTime;
begin
  Sl:= TTntStringList.Create();
  try
    if (WideFileExists(FSettings)) then
      Sl.LoadFromFile(FSettings);

    cb_Disabled.Checked:= false;

    Value:= Sl.Values[WS_INILASTINCLUDESUB];
    if (Value = WS_NIL) then
      cb_IncludeSubdirs.Checked:= true else
      cb_IncludeSubdirs.Checked:= CobStrToBoolW(Value);

    Value:= Sl.Values[WS_INISEPARATEBACKUPS];
    if (Value = WS_NIL) then
      cb_Separated.Checked:= true else
      cb_Separated.Checked:= CobStrToBoolW(Value);

    Value:= Sl.Values[WS_INIUSEATTRIBUTES];
    if (Value = WS_NIL) then
      cb_Attributes.Checked:= true else
      cb_Attributes.Checked:= CobStrToBoolW(Value);

    Value:= Sl.Values[WS_INIRESETATTRIBUTES];
    if (Value = WS_NIL) then
      cb_ResetArchive.Checked:= true else
      cb_ResetArchive.Checked:= CobStrToBoolW(Value);

    Value:= Sl.Values[WS_INIBACKUPTYPE];
    if (Value = WS_NIL) then
      SetBackupType(INT_BUFULL) else
      SetBackupType(CobStrToIntW(Value,INT_BUFULL));

    Value:= Sl.Values[WS_INIFULLCOPIES];
    if (Value = WS_NIL) then
      e_FullCopies.Text:= CobIntToStrW(INT_NIL) else
      e_FullCopies.Text:= Value;

    Value:= Sl.Values[WS_INIMAKEFULL];
    if (Value = WS_NIL) then
      e_MakeFull.Text:= CobIntToStrW(INT_NIL) else
      e_MakeFull.Text:= Value;

    ClearSDList(lb_Source);
    ClearSDList(lb_Destination);

    if (InitialSource <> WS_NIL) then
      DecodeSD(InitialSource, lb_Source);

    Value:= Sl.Values[WS_INIDESTINATION];
    if (Value <> WS_NIL) then
      DecodeSD(Value, lb_Destination);

    Value:= Sl.Values[WS_INISCHEDULETYPE];
    if (Value = WS_NIL) then
      cb_ScheduleType.ItemIndex:= INT_SCDAILY else
      cb_ScheduleType.ItemIndex:= CobStrToIntW(Value, INT_SCDAILY);

    Value:= Sl.Values[WS_INIDAYSOFWEEK];
    SetWeekDays(Value);

    Value:= Sl.Values[WS_INIDATETIME];
    dt_Date.DateTime:= Now();
    dt_Time.DateTime:= Now();
    if (Value <> WS_NIL) then
      begin
        ADate:= CobBinToDoubleW(Value,OK);
        if (OK) then
          begin
            dt_Date.DateTime:= ADate;
            dt_Time.DateTime:= ADate;
          end;
      end;

    Value:= Sl.Values[WS_INIDAYSOFMONTH];
    if (Value = WS_NIL) then
      e_DaysMonth.Text:= CobIntToStrW(INT_FIRSTDAY) else
      e_DaysMonth.Text:= Value;

    Value:= Sl.Values[WS_INIMONTH];
    if (Value = WS_NIL) then
      cb_Month.ItemIndex:= INT_MJANUARY else
      cb_Month.ItemIndex:= CobStrToIntW(Value, INT_MJANUARY);

    Value:= Sl.Values[WS_INITIMER];
    if (Value = WS_NIL) then
      e_Timer.Text:= CobIntToStrW(INT_DEFTIMER) else
      e_Timer.Text:= Value;

    Value:= Sl.Values[WS_INICOMPRESSION];
    if (Value = WS_NIL) then
      cb_Compression.ItemIndex:= INT_COMPNOCOMP else
      cb_Compression.ItemIndex:= CobStrToIntW(Value, INT_COMPNOCOMP);

    Value:= Sl.Values[WS_INISPLIT];
    if (Value = WS_NIL) then
      cb_Split.ItemIndex:= INT_SPLITNOSPLIT else
      cb_Split.ItemIndex:= CobStrToIntW(Value, INT_SPLITNOSPLIT);

    Value:= Sl.Values[WS_INICOMPPASSWORD];
    e_Password.Text:= WS_NIL;
    e_PasswordRe.Text:= WS_NIL;
    if (Value <> WS_NIL) then
      if CobDecryptStringW(Value,WS_LLAVE,Password) then
        begin
          e_Password.Text:= Password;
          e_PasswordRe.Text:= Password;
        end;

    Value:= Sl.Values[WS_INISPLITCUSTOM];
    if (Value = WS_NIL) then
      e_Custom.Text:= CobIntToStrW(INT_DEFCUSTOM) else
      e_Custom.Text:= Value;

    Value:= Sl.Values[WS_INIPROTECTARCHIVE];
    if (Value = WS_NIL) then
      cb_Protect.Checked:= false else
      cb_Protect.Checked:= CobStrToBoolW(Value);

    Value:= Sl.Values[WS_INICOMMENT];
    if (Value = WS_NIL) then
      e_Comment.Text:= WideFormat(Translator.GetMessage('629'),[WS_PROGRAMNAMESHORT],FS) else
      e_Comment.Text:= Value;

    Value:= Sl.Values[WS_INIENCRYPTION];
    if (Value = WS_NIL) then
      cb_Encryption.ItemIndex:= INT_ENCNOENC else
      cb_Encryption.ItemIndex:= CobStrToIntW(Value, INT_ENCNOENC);

    Value:= Sl.Values[WS_INIPASSPHRASE];
    e_Passphrase.Text:= WS_NIL;
    e_PassphraseRe.Text:= WS_NIL;
    if (Value <> WS_NIL) then
    if (CobDecryptStringW(Value, WS_LLAVE, Password)) then
    begin
      e_Passphrase.Text:= Password;
      e_PassphraseRe.Text:= Password;
    end;

    GetQualityVisually();

    Value:= Sl.Values[WS_INIPUBLICKEY];
    e_Key.Text:= Value;

    lb_Include.Clear();
    lb_Exclude.Clear();
    lb_BeforeBackup.Clear();
    lb_AfterBackup.Clear();

    if (UISettings.SaveAdvancedSettings) then
    begin
      Value:= Sl.Values[WS_INIINCLUDE];
      lb_Include.Items.CommaText:= Value;

      Value:= Sl.Values[WS_INIEXCLUDE];
      lb_Exclude.Items.CommaText:= Value;

      Value:= Sl.Values[WS_INIBEFORE];
      lb_BeforeBackup.Items.CommaText:= Value;

      Value:= Sl.Values[WS_INIAFTER];
      lb_AfterBackup.Items.CommaText:= Value;
    end;

    Value:= Sl.Values[WS_INIIMPERSONATE];
    if (Value = WS_NIL) then
      cb_Impersonate.Checked:= false else
      cb_Impersonate.Checked:= CobStrToBoolW(Value);

    Value:= Sl.Values[WS_INIIMPERSONATECANCEL];
    if (Value = WS_NIL) then
      cb_ImpersonateCancel.Checked:= false else
      cb_ImpersonateCancel.Checked:= CobStrToBoolW(Value);

    Value:= Sl.Values[WS_INIIMPERSONATIONID];
    e_ImpersonateID.Text:= Value;

    Value:= Sl.Values[WS_INIIMPERSONATIONDOMAIN];
    if (Value = WS_NIL) then
      e_ImpersonateDomain.Text:= WS_LOCALDOMAIN else
      e_ImpersonateDomain.Text:= Value;

    Value:= Sl.Values[WS_INIIMPERSONATIONPASSWORD];
    e_ImpersonatePassword.Text:= WS_NIL;
    if (Value <> WS_NIL) then
      if (CobDecryptStringW(Value,WS_LLAVE,Password)) then
        e_ImpersonatePassword.Text:= Password;

    FLastUsedFTP:= Sl.Values[WS_INILASTUSEDFTP];

    FLastDirectory:= Sl.Values[WS_INILASTUSEDDIRECTORY];
  finally
    FreeAndNil(Sl);
  end;
end;

procedure Tform_Task.LoadTask();
var
  Task: TTask;
begin
  Task:= TTask.Create();
  try
    Settings.CopyTask(l_Id.Caption, Task);
    l_Name.Caption:= Task.Name;
    l_Id.Caption:= Task.ID;     // There ios no nned but what the hell
    e_Name.Text:= Task.Name;
    cb_Disabled.Checked:= Task.Disabled;
    cb_IncludeSubdirs.Checked:= Task.IncludeSubdirectories;
    cb_Separated.Checked:= Task.SeparateBackups;
    cb_Attributes.Checked:= Task.UseAttributes;
    cb_ResetArchive.Checked:= Task.ResetAttributes;
    SetBackupType(Task.BackupType);
    e_FullCopies.Text:= CobIntToStrW(Task.FullCopiesToKeep);
    e_MakeFull.Text:= CobIntToStrW(Task.MakeFullBackup);
    ClearSDList(lb_Source);
    ClearSDList(lb_Destination);
    DecodeSD(Task.Source, lb_Source);
    DecodeSD(Task.Destination, lb_Destination);
    cb_ScheduleType.ItemIndex:= Task.ScheduleType;
    SetWeekDays(Task.DayWeek);
    dt_Date.DateTime:= Task.DateTime;
    dt_Time.DateTime:= Task.DateTime;
    e_DaysMonth.Text:= Task.DayMonth;
    cb_Month.ItemIndex:= Task.Month;
    e_Timer.Text:= CobIntToStrW(Task.Timer);
    cb_Compression.ItemIndex:= Task.Compress;
    cb_Split.ItemIndex:= Task.Split;
    e_Custom.Text:= CobIntToStrW(Task.SplitCustom);
    cb_Protect.Checked:= Task.ArchiveProtect;
    e_Password.Text:= Task.Password;
    e_PasswordRe.Text:= Task.Password;
    e_Comment.Text:= Task.ArchiveComment;
    cb_Encryption.ItemIndex:= Task.Encryption;
    e_Passphrase.Text:= Task.Passphrase;
    e_PassphraseRe.Text:= Task.Passphrase;
    e_Key.Text:= Task.PublicKey;
    lb_Include.Items.CommaText:= Task.IncludeMasks;
    lb_Exclude.Items.CommaText:= Task.ExcludeItems;
    lb_BeforeBackup.Items.CommaText:= Task.BeforeEvents;
    lb_AfterBackup.Items.CommaText:= Task.AfterEvents;
    cb_Impersonate.Checked:= Task.Impersonate;
    cb_ImpersonateCancel.Checked:= Task.ImpersonateCancel;
    e_ImpersonateID.Text:= Task.ImpersonateID;
    e_ImpersonateDomain.Text:= Task.ImpersonateDomain;
    e_ImpersonatePassword.Text:= Task.ImpersonatePassword;
  finally
    FreeAndNil(Task);
  end;
end;

procedure Tform_Task.l_ExplorerClick(Sender: TObject);
begin
  ShellExecuteW(0,'open',PWideChar(WS_EXPLOREREXE),nil, nil, SW_SHOWNORMAL);
end;

procedure Tform_Task.m_CloseProgramClick(Sender: TObject);
var
  Caption, Encoded: WideString;
  Force: boolean;
begin
  Caption:= WS_NIL;
  if (InputQueryW(Translator.GetMessage('35'),Translator.GetMessage('41'),
                  false, Caption)) then
  begin
    Force:= false;
    if (CobMessageBoxW(self.Handle,Translator.GetMessage('42'),
              WS_PROGRAMNAMESHORT,MB_YESNO) = IDYES) then
      Force:= true;

    Encoded:= EncodeEvent(WS_EVCLOSE,Caption,CobBoolToStrW(Force));
    if (FEvSender = INT_SENDERBEFORE) then
      lb_BeforeBackup.Items.Add(Encoded) else
      lb_AfterBackup.Items.Add(Encoded);

    CheckUIEvents();
  end;
end;

procedure Tform_Task.m_DownClick(Sender: TObject);
var
  i: integer;
  Temp: WideString;
begin
  if (FEvList <> nil) then
  begin
    for i:= 0 to FEvList.Items.Count -1 do
      if (FEvList.Selected[i]) and (i < FEvList.Items.Count - 1) then
      begin
        Temp:= FEvList.Items[i + 1];
        FEvList.Items[i + 1]:= FEvList.Items[i];
        FEvList.Items[i]:= Temp;
      end; 
  end;
end;

procedure Tform_Task.m_ExcludeDirClick(Sender: TObject);
var
  Dir, Msg: WideString;
  ListBox: TTntListBox;
begin
  if (FMenuExclude) then
  begin
    Msg:= Translator.GetMessage('31');
    ListBox:= lb_Exclude;
  end else
  begin
    Msg:= Translator.GetMessage('476');
    ListBox:= lb_Include;
  end;

  Dir:= FLastDirectory;
  if (CobSelectDirectoryW(Msg ,WS_NIL,Dir,
                          [csdNewUI,csdNewFolder],self)) then
    if (Dir <> WS_NIL) then
      begin
        FLastDirectory:= Dir;
        Dir:= CobSetBackSlashW(GetUNCPath(Dir)) + WS_ALLFILES;
        ListBox.Items.Add(Dir);
        CheckUISpecial();
      end;
end;

procedure Tform_Task.m_ExcludeFileClick(Sender: TObject);
var
  i: integer;
  ListBox: TTntListBox;
begin
  if (FMenuExclude) then
  begin
    ListBox:= lb_Exclude;
    dlg_Open.Title:= Translator.GetMessage('32');
  end else
  begin
    ListBox:= lb_Include;
    dlg_Open.Title:= Translator.GetMessage('475');
  end;


  dlg_Open.DefaultExt:= WS_NIL;
  dlg_Open.Filter:= WideFormat(WS_ALLFILESFILTER,
                    [Translator.GetMessage('27')],FS);
  dlg_Open.FilterIndex:= 1;
  // dlg_Open.InitialDir:= CobGetSpecialDirW(cobPersonal);
  dlg_Open.Options:= dlg_Open.Options + [ofAllowMultiSelect];
  if (dlg_Open.Execute) then
    begin
      for i:=0 to dlg_Open.Files.Count-1 do
        ListBox.Items.Add(GetUNCPath(dlg_Open.Files[i]));
      CheckUISpecial();
    end;
end;

procedure Tform_Task.m_ExcludeMaskClick(Sender: TObject);
var
  Mask, Msg: WideString;
  ListBox: TTntListBox;
begin
  if (FMenuExclude) then
  begin
    Msg:= Translator.GetMessage('30');
    ListBox:= lb_Exclude;
  end else
  begin
    Msg:= Translator.GetMessage('29');
    ListBox:= lb_Include;
  end;

  if (InputQueryW(WS_PROGRAMNAMESHORT, Msg ,false, Mask)) then
    if (Mask <> WS_NIL) then
      begin
        ListBox.Items.Add(Mask);
        CheckUISpecial();
      end; 
end;

procedure Tform_Task.m_ExecuteAndWaitClick(Sender: TObject);
var
  Exec,Param, Encoded: WideString;
begin
  dlg_Open.Title:= Translator.GetMessage('37');
  dlg_Open.DefaultExt:= WS_DEFEXEEXTDLG;
  dlg_Open.Filter:= WideFormat(WS_EXECKEYFILTER,
                    [Translator.GetMessage('38'), Translator.GetMessage('27')],FS);
  dlg_Open.FilterIndex:= 1;
  // dlg_Open.InitialDir:= CobGetSpecialDirW(cobPersonal);
  dlg_Open.Options:= dlg_Open.Options - [ofAllowMultiSelect];
  if (dlg_Open.Execute) then
  begin
    Exec:= dlg_Open.FileName;
    Param:= WS_NIL;
    InputQueryW(WS_PROGRAMNAMESHORT,Translator.GetMessage('39'),false,Param);
    Encoded:= EncodeEvent(WS_EVEXECUTEANDWAIT,Exec,Param);
    if (FEvSender = INT_SENDERBEFORE) then
      lb_BeforeBackup.Items.Add(Encoded) else
      lb_AfterBackup.Items.Add(Encoded);
    CobShowMessageW(self.Handle,Translator.GetMessage('40'),WS_PROGRAMNAMESHORT);
    CheckUIEvents();
  end;
end;


procedure Tform_Task.m_ExecuteClick(Sender: TObject);
var
  Exec,Param, Encoded: WideString;
begin
  dlg_Open.Title:= Translator.GetMessage('37');
  dlg_Open.DefaultExt:= WS_DEFEXEEXTDLG;
  dlg_Open.Filter:= WideFormat(WS_EXECKEYFILTER,
                    [Translator.GetMessage('38'), Translator.GetMessage('27')],FS);
  dlg_Open.FilterIndex:= 1;
  // dlg_Open.InitialDir:= CobGetSpecialDirW(cobPersonal);
  dlg_Open.Options:= dlg_Open.Options - [ofAllowMultiSelect];
  if (dlg_Open.Execute) then
  begin
    Exec:= dlg_Open.FileName;
    Param:= WS_NIL;
    InputQueryW(WS_PROGRAMNAMESHORT,Translator.GetMessage('39'),false,Param);
    Encoded:= EncodeEvent(WS_EVEXECUTE,Exec,Param);
    if (FEvSender = INT_SENDERBEFORE) then
      lb_BeforeBackup.Items.Add(Encoded) else
      lb_AfterBackup.Items.Add(Encoded);
    CheckUIEvents();
  end;
end;

procedure Tform_Task.m_PauseClick(Sender: TObject);
var
  Pause, Encoded: WideString;
  PauseInt: integer;
begin
  Pause:= WS_NIL;
  if (InputQueryW(Translator.GetMessage('35'),Translator.GetMessage('36'),
                  false,Pause)) then
  begin
    // make sure the entered value is an integer
    PauseInt:= CobStrToIntW(Pause,INT_NIL);
    Encoded:= EncodeEvent(WS_EVPAUSE, CobIntToStrW(PauseInt), WS_NIL);
    if (FEvSender = INT_SENDERBEFORE) then
      lb_BeforeBackup.Items.Add(Encoded) else
      lb_AfterBackup.Items.Add(Encoded);
    CheckUIEvents();
  end;
end;

procedure Tform_Task.m_RestartClick(Sender: TObject);
var
  Force: boolean;
  Encoded: WideString;
begin
  Force:= false;
  if (CobMessageBoxW(self.Handle,Translator.GetMessage('42'),
              WS_PROGRAMNAMESHORT,MB_YESNO) = IDYES) then
      Force:= true;
  Encoded:= EncodeEvent(WS_EVRESTART,CobBoolToStrW(Force),WS_NIL);

  if (FEvSender = INT_SENDERBEFORE) then
    lb_BeforeBackup.Items.Add(Encoded) else
    lb_AfterBackup.Items.Add(Encoded);

  CheckUIEvents();
end;

procedure Tform_Task.m_SDDirectoryClick(Sender: TObject);
var
  lb: TTntListBox;
  Dir, ACaption: WideString;
begin
  if (FSDSender = INT_SENDERSOURCE) then
  begin
    lb:= lb_Source;
    ACaption:= Translator.GetMessage('48');
  end else
  begin
    lb:= lb_Destination;
    ACaption:= Translator.GetMessage('50');
  end;

  // 2006-08-07 Fixed the Caption
  
  Dir:= FLastDirectory;
  if (CobSelectDirectoryW(ACaption,WS_NIL,
                          Dir, [csdNewUI,csdNewFolder],self)) then
    if (Dir <> WS_NIL) then
    begin
      FLastDirectory:= Dir;
      AddSDItem(GetUNCPath(Dir), INT_SDDIR, lb);
      if (FSDSender = INT_SENDERSOURCE) then
        CheckUISource() else
        CheckUIDestination();
    end;
end;

procedure Tform_Task.m_SDFileClick(Sender: TObject);
var
  i: integer;
begin
  if (FSDSender = INT_SENDERSOURCE) then
  begin
    dlg_Open.Title:= Translator.GetMessage('47');
    dlg_Open.DefaultExt:= WS_NIL;
    dlg_Open.Filter:= WideFormat(WS_ALLFILESFILTER,
                    [Translator.GetMessage('27')],FS);
    dlg_Open.FilterIndex:= 1;
    // dlg_Open.InitialDir:= CobGetSpecialDirW(cobPersonal);
    dlg_Open.Options:= dlg_Open.Options + [ofAllowMultiSelect];
    if (dlg_Open.Execute) then
    begin
      for i:=0 to dlg_Open.Files.Count - 1 do
        AddSDItem(GetUNCPath(dlg_Open.Files[i]), INT_SDFILE, lb_Source);
      CheckUISource();
    end;
  end;
end;

procedure Tform_Task.m_SDFTPClick(Sender: TObject);
var
  form_FTP: Tform_FTP;
  lb: TTntListBox;
begin
  if (FSDSender = INT_SENDERSOURCE) then
    lb:= lb_Source else
    lb:= lb_Destination;

  form_FTP:= Tform_FTP.Create(nil);
  try
    form_FTP.FTP.DecodeAddress(FLastUsedFTP);
    form_FTP.ShowModal();
    if (form_FTP.Tag = INT_MODALRESULTOK) then
    begin
      AddSDItem(form_FTP.FTP.EncodeAddress(),INT_SDFTP, lb);
      if (FSDSender = INT_SENDERSOURCE) then
        CheckUISource() else
        CheckUIDestination();
      FLastUsedFTP:= form_FTP.FTP.EncodeAddress();
    end;
  finally
    form_FTP.Release();
  end;
end;

procedure Tform_Task.m_SDManuallyClick(Sender: TObject);
var
  lb: TTntListBox;
  Mask, ACaption, Prompt: WideString;
  Kind: integer;
begin
  if (FSDSender = INT_SENDERSOURCE) then
    begin
      lb:= lb_Source;
      ACaption:= Translator.GetMessage('49');
      Prompt:= Translator.GetMessage('51');
    end else
    begin
      lb:= lb_Destination;
      ACaption:= Translator.GetMessage('50');
      Prompt:= Translator.GetMessage('52');
    end;

  Mask:= WS_NIL;
  if (InputQueryW( ACaption, Prompt, false, Mask)) then
    if (Mask <> WS_NIL) then
    begin

      if (WideFileExists(Mask)) then
      begin
        Mask:= GetUNCPath(Mask);
        Kind:= INT_SDFILE;
      end else
      if (WideDirectoryExists(Mask)) then
      begin
        Mask:= GetUNCPath(Mask);
        Kind:= INT_SDDIR;
      end else
        Kind:= INT_SDMANUAL;

      AddSDItem(Mask, Kind, lb);

      if (FSDSender = INT_SENDERSOURCE) then
        CheckUISource() else
        CheckUIDestination();
    end;
end;

procedure Tform_Task.m_ShutdownClick(Sender: TObject);
var
  Force: boolean;
  Encoded: WideString;
begin
  Force:= false;
  if (CobMessageBoxW(self.Handle,Translator.GetMessage('42'),
              WS_PROGRAMNAMESHORT,MB_YESNO) = IDYES) then
      Force:= true;
  Encoded:= EncodeEvent(WS_EVSHUTDOWN,CobBoolToStrW(Force),WS_NIL);

  if (FEvSender = INT_SENDERBEFORE) then
    lb_BeforeBackup.Items.Add(Encoded) else
    lb_AfterBackup.Items.Add(Encoded);

  CheckUIEvents();
end;

procedure Tform_Task.m_StartServiceClick(Sender: TObject);
var
  ServiceName, Encoded, Param, Event: WideString;
  fServices: Tform_Services;
  ToStart: boolean;
begin
  ServiceName:= WS_NIL;
  if (Sender = m_StartService) then
    begin
      Event:= WS_EVSTARTSERVICE;
      ToStart:= true;
    end else
    begin
      Event:= WS_EVSTOPSERVICE;
      ToStart:= false;
    end;

  fServices:= Tform_Services.Create(nil);
  try
    fServices.FToStart:= ToStart;  
    fServices.ShowModal();
    if (fServices.Tag = INT_MODALRESULTOK) then
      ServiceName:= fServices.FSName;
  finally
    fServices.Release();
  end;

  if (ServiceName <> WS_NIL) then
  begin
    Param:= WS_NIL;

    if (ToStart) then
      InputQueryW(Translator.GetMessage('35'), Translator.GetMessage('39'),
                    false,Param);

    Encoded:= EncodeEvent(Event, ServiceName, Param);
    if (FEvSender = INT_SENDERBEFORE) then
      lb_BeforeBackup.Items.Add(Encoded) else
      lb_AfterBackup.Items.Add(Encoded);
      
    CheckUIEvents();
  end;
end;

procedure Tform_Task.m_SynchronizeClick(Sender: TObject);
var
  Encoded: WideString;
begin
  Encoded:= EncodeEvent(WS_EVSYNCHRONIZE, WS_NIL,WS_NIL);
  if (FEvSender = INT_SENDERBEFORE) then
    lb_BeforeBackup.Items.Add(Encoded) else
    lb_AfterBackup.Items.Add(Encoded);
  CheckUIEvents();
end;

procedure Tform_Task.m_UpClick(Sender: TObject);
var
  i: integer;
  Temp: WideString;
begin
  if (FEvList <> nil) then
  begin
    for i:= 0 to FEvList.Items.Count -1 do
      if (FEvList.Selected[i]) and (i > 0) then
      begin
        Temp:= FEvList.Items[i-1];
        FEvList.Items[i-1]:= FEvList.Items[i];
        FEvList.Items[i]:= Temp;
      end; 
  end;
end;

procedure Tform_Task.m_ByTypeClick(Sender: TObject);
var
  ListBox: TTntListBox;
  List: TTntStringList;
  i: integer;
  Ob, ObOrig: TSDData;
  function GetIndex(const AKind: integer): integer;
  var
    j: integer;
    Potter: TSDData;
    Found: boolean;
  begin
    Found:= false;
    Result:= 0;
    for j:= 0 to List.Count - 1 do
    begin
      Potter:= TSDData(List.Objects[j]);
      if (Potter.FKind >= AKind) then
      begin
        Found:= true;
        Result:= j;
        Break;
      end;
    end;
   if (not Found) then
    Result:= 0;
  end;
begin
  if (FSDSender = INT_SENDERSOURCE) then
    ListBox:= lb_Source else
    ListBox:= lb_Destination;

  // I could use assign but there is a problem when
  // assigned objects. There is some kind of memory leak in the VCL

  List:= TTntStringList.Create();
  try
    List.Sorted:= false;
    for i:=0 to ListBox.Items.Count - 1 do
    begin
      ObOrig:= TSDData(ListBox.Items.Objects[i]);
      Ob:= TSDData.Create(ObOrig.FKind, ObOrig.FFullPath);
      List.InsertObject(GetIndex(Ob.FKind),ListBox.Items[i], Ob);
    end;

    ClearSDList(ListBox);

   for i:= 0 to List.Count - 1  do
   begin
     Ob:= TSDData(List.Objects[i]);
     AddSDItem(Ob.FFullPath,Ob.FKind, ListBox);
     FreeAndNil(Ob);
   end;

   List.Clear();
  finally
    FreeAndNil(List);
  end;

  if (FSDSender = INT_SENDERSOURCE) then
    CheckUISource() else
    CheckUIDestination();
end;

procedure Tform_Task.pop_MoveEventsPopup(Sender: TObject);
begin
  if (Sender is TTntPopupMenu) then
  begin
    if (Sender as TTntPopupMenu).PopupComponent = lb_BeforeBackup then
      FEvList:= lb_BeforeBackup else
      FEvList:= lb_AfterBackup;

    m_Up.Enabled:= (FEvList.SelCount > 0) and not FEvList.Selected[0];
    m_Down.Enabled:= (FEvList.SelCount > 0) and not FEvList.Selected[FEvList.Count - 1];
  end;
end;

procedure Tform_Task.SaveStdTask();
var
  Sl: TTntStringList;
  Password: WideString;
begin
  Sl:= TTntStringList.Create();
  try
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INILASTINCLUDESUB,
                      CobBoolToStrW(cb_IncludeSubdirs.Checked)],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INISEPARATEBACKUPS,
                      CobBoolToStrW(cb_Separated.Checked)],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIUSEATTRIBUTES,
                      CobBoolToStrW(cb_Attributes.Checked)],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIRESETATTRIBUTES,
                      CobBoolToStrW(cb_ResetArchive.Checked)],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIBACKUPTYPE,
                      CobIntToStrW(GetBackupType())],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIFULLCOPIES,
                      e_FullCopies.Text],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIMAKEFULL,
                      e_MakeFull.Text],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIDESTINATION,
                      GetSDEncoded(lb_Destination)],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INISCHEDULETYPE,
                      CobIntToStrW(cb_ScheduleType.ItemIndex)],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIDAYSOFWEEK,
                      GetWeekDays()],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIDATETIME,
                      CobDoubleToBinW(EncodeDateTime())],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIDAYSOFMONTH,
                      e_DaysMonth.Text],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIMONTH,
                      CobIntToStrW(cb_Month.ItemIndex)],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INITIMER,
                      e_Timer.Text],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INICOMPRESSION,
                      CobIntToStrW(cb_Compression.ItemIndex)],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INISPLIT,
                      CobIntToStrW(cb_Split.ItemIndex)],FS));
    Password:= WS_NIL;
    CobEncryptStringW(e_Password.Text, WS_LLAVE, Password);
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INICOMPPASSWORD,
                      Password],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INISPLITCUSTOM,
                      e_Custom.Text],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIPROTECTARCHIVE,
                      CobBoolToStrW(cb_Protect.Checked)],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INICOMMENT,
                      e_Comment.Text],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIENCRYPTION,
                      CobIntToStrW(cb_Encryption.ItemIndex)],FS));
    Password:= WS_NIL;
    CobEncryptStringW(e_Passphrase.Text, WS_LLAVE, Password);
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIPASSPHRASE,
                      Password],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIPUBLICKEY,
                      e_Key.Text],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIINCLUDE,
                      lb_Include.Items.CommaText],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIEXCLUDE,
                      lb_Exclude.Items.CommaText],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIBEFORE,
                      lb_BeforeBackup.Items.CommaText],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIAFTER,
                      lb_AfterBackup.Items.CommaText],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIIMPERSONATE,
                      CobBoolToStrW(cb_Impersonate.Checked)],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIIMPERSONATECANCEL,
                      CobBoolToStrW(cb_ImpersonateCancel.Checked)],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIIMPERSONATIONID,
                      e_ImpersonateID.Text],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIIMPERSONATIONDOMAIN,
                      e_ImpersonateDomain.Text],FS));
    Password:= WS_NIL;
    CobEncryptStringW(e_ImpersonatePassword.Text, WS_LLAVE, Password);
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INIIMPERSONATIONPASSWORD,
                      Password],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INILASTUSEDFTP, FLastUsedFTP],FS));
    Sl.Add(WideFormat(WS_INIFORMAT,[WS_INILASTUSEDDIRECTORY, FLastDirectory],FS));
    Sl.SaveToFile(FSettings);
    FTools.GetFullAccess(WS_NIL, FSettings);
  finally
    FreeAndNil(Sl);
  end;
end;

procedure Tform_Task.AddUpdateTask();
var
  Task: TTask;
begin
  // Adds the new task to the list or update the existing one
 Task:= TTask.Create();
 Task.Name:= e_Name.Text;
 Task.ID:= l_Id.Caption;
 Task.Disabled:= cb_Disabled.Checked;
 Task.IncludeSubdirectories:= cb_IncludeSubdirs.Checked;
 Task.SeparateBackups:= cb_Separated.Checked;
 Task.UseAttributes:= cb_Attributes.Checked;
 Task.ResetAttributes:= cb_ResetArchive.Checked;
 Task.BackupType:= GetBackupType();
 Task.FullCopiesToKeep:= CobStrToIntW(e_FullCopies.Text, INT_NIL);
 Task.Source:= GetSDEncoded(lb_Source);
 Task.Destination:= GetSDEncoded(lb_Destination);
 Task.ScheduleType:= cb_ScheduleType.ItemIndex;
 Task.DateTime:= EncodeDateTime();
 Task.DayWeek:= GetWeekDays();
 Task.DayMonth:= e_DaysMonth.Text;
 Task.Month:= cb_Month.ItemIndex;
 Task.Timer:= CobStrToIntW(e_Timer.Text, INT_DEFTIMER);
 Task.MakeFullBackup:= CobStrToIntW(e_MakeFull.Text, INT_NIL);
 Task.Compress:= cb_Compression.ItemIndex;
 Task.ArchiveProtect:= cb_Protect.Checked;
 Task.Password:= e_Password.Text;
 Task.Split:= cb_Split.ItemIndex;
 Task.SplitCustom:= CobStrToInt64W(e_Custom.Text, INT_DEFCUSTOM);
 Task.ArchiveComment:= e_Comment.Text;
 Task.Encryption:= cb_Encryption.ItemIndex;
 Task.Passphrase:= e_Passphrase.Text;
 Task.PublicKey:= e_Key.Text;
 Task.IncludeMasks:= lb_Include.Items.CommaText;
 Task.ExcludeItems:= lb_Exclude.Items.CommaText;
 Task.BeforeEvents:= lb_BeforeBackup.Items.CommaText;
 Task.AfterEvents:= lb_AfterBackup.Items.CommaText;
 Task.Impersonate:= cb_Impersonate.Checked;
 Task.ImpersonateCancel:= cb_ImpersonateCancel.Checked;
 Task.ImpersonateID:= e_ImpersonateID.Text;
 Task.ImpersonateDomain:= e_ImpersonateDomain.Text;
 Task.ImpersonatePassword:= e_ImpersonatePassword.Text;

 if (FNewTask) then
  Settings.AddTask(Task) else
  begin
    Settings.UpdateTask(Task.ID, Task);
    // This only updates the values of the fields
    // of the existing task in the list, so
    // free this task after using it
    FreeAndNil(Task);
  end;
end;

procedure Tform_Task.SetAWeekDay(const Day: integer);
begin
  case Day of
    INT_DMONDAY: cb_Monday.Checked:= true;
    INT_DTUESDAY: cb_Tuesday.Checked:= true;
    INT_DWEDNESDAY: cb_Wednesday.Checked:= true;
    INT_DTHURSDAY: cb_Thursday.Checked:= true;
    INT_DFRIDAY: cb_Friday.Checked:= true;
    INT_DSATURDAY: cb_Saturday.Checked:= true;
    INT_DSUNDAY: cb_Sunday.Checked:= true;
    else
      //do nothing
  end;
end;

procedure Tform_Task.SetBackupType(const Backup: integer);
begin
  rb_Full.Checked:= false;
  rb_Incremental.Checked:= false;
  rb_Differential.Checked:= false;
  rb_Dummy.Checked:= false;
  case Backup of
    1: rb_Incremental.Checked:= true;
    2: rb_Differential.Checked:= true;
    3: rb_Dummy.Checked:= true;
    else
      rb_Full.Checked:= true;
  end;
end;

procedure Tform_Task.SetIndex(const Index: integer);
begin
  if (Index>=0) and (Index < lb_Menu.Items.Count) then
  begin
    lb_Menu.ItemIndex:= Index;
    lb_Menu.Selected[Index]:= true;
    pc_Task.ActivePageIndex:= Index;
  end;
end;

procedure Tform_Task.SetWeekDays(const Days: WideString);
var
  Sl: TTntStringList;
  Value: integer;
  i: integer;
begin
  cb_Monday.Checked:= false;
  cb_Tuesday.Checked:= false;
  cb_Wednesday.Checked:= false;
  cb_Thursday.Checked:= false;
  cb_Friday.Checked:= false;
  cb_Saturday.Checked:= false;
  cb_Sunday.Checked:= false;

  Sl:= TTntStringList.Create();
  try
    Sl.CommaText:= Days;
    for i:= 0 to Sl.Count - 1 do
      begin
        Value:= CobStrToIntW(Sl[i], INT_BADVALUE);
        SetAWeekday(Value);
      end;
  finally
    FreeAndNil(Sl);
  end;
end;

procedure Tform_Task.ShowEventMenu(Sender: TObject);
var
  Button: TTntBitBtn;
  PosXY: TPoint;
begin
  if not (Sender is TTntBitBtn) then
    Exit;

  Button:= Sender as TTntBitBtn;

  m_Synchronize.Visible:= false;

  m_Restart.Visible:= (Button = b_AfterAdd);
  m_Shutdown.Visible:= (Button = b_AfterAdd);

  PosXY.X:= Button.Left;
  PosXY.Y:= Button.Top + Button.Height;
  PosXY:= Button.Parent.ClientToParent(PosXY, self);
  PosXY:= ClientToScreen(PosXY);
  pop_Events.Popup(PosXY.X,PosXY.Y);
end;

procedure Tform_Task.ShowOrderMenu(const Sender: TObject);
var
  Button: TTntBitBtn;
  PosXY: TPoint;
begin
  if not (Sender is TTntBitBtn) then
    Exit;

  Button:= Sender as TTntBitBtn;

  if (Button = b_SourceOrder) then
    FSDSender:= INT_SENDERSOURCE else
    FSDSender:= INT_SENDERDESTINATION;

  PosXY.X:= Button.Left;
  PosXY.Y:= Button.Top + Button.Height;
  PosXY:= Button.Parent.ClientToParent(PosXY, self);
  PosXY:= ClientToScreen(PosXY);
  pop_Order.Popup(PosXY.X,PosXY.Y);
end;

procedure Tform_Task.ShowSDMenu(Sender: TObject);
var
  Button: TTntBitBtn;
  PosXY: TPoint;
begin
  if not (Sender is TTntBitBtn) then
    Exit;

  Button:= Sender as TTntBitBtn;

  if (Button = b_SourceAdd) then
    FSDSender:= INT_SENDERSOURCE else
    FSDSender:= INT_SENDERDESTINATION;

  m_SDFile.Visible:= (Button = b_SourceAdd);

  PosXY.X:= Button.Left;
  PosXY.Y:= Button.Top + Button.Height;
  PosXY:= Button.Parent.ClientToParent(PosXY, self);
  PosXY:= ClientToScreen(PosXY);
  pop_SourceDestination.Popup(PosXY.X,PosXY.Y);
end;

procedure Tform_Task.ShowSpecialMenu();
var
  PosXY: TPoint;
  Button: TTntBitBtn;
begin
  if (FMenuExclude) then
    Button:= b_ExcludeAdd else
    Button:= b_IncludeAdd;
  PosXY.X:= Button.Left;
  PosXY.Y:= Button.Top + Button.Height;
  PosXY:= Button.Parent.ClientToParent(PosXY, self);
  PosXY:= ClientToScreen(PosXY);
  pop_ExcludeIncludeAdd.Popup(PosXY.X,PosXY.Y);
end;

procedure Tform_Task.SetNameLabels();
begin
  l_Name.Caption:= e_Name.Text;
  l_Name.Top:= (im_Task.Height div 2) - (l_Name.Height div 2);
  l_Name.Left:= (im_Task.Width div 2) - (l_Name.Width div 2);
  l_Id.Left:= (p_Right.Width div 2) - (l_Id.Width div 2);
  Caption:= WideFormat(Translator.GetMessage('24'),[e_Name.Text],FS);
end;

procedure Tform_Task.TntFormClose(Sender: TObject; var Action: TCloseAction);
begin
  ClearSDList(lb_Source);
  ClearSDList(lb_Destination);
end;

procedure Tform_Task.TntFormCreate(Sender: TObject);
begin
  FFirstTime:= true;
  Font.Name:= UISettings.FontName;
  Font.Size:= UISettings.FontSize;
  Font.Charset:= UISettings.FontCharset;
  ShowHint:= UISettings.ShowHints;
  FShowIcons:= UISettings.ShowIcons;
  if (UISettings.DeferenceLinks) then
    dlg_Open.Options:= dlg_Open.Options - [ofNoDereferenceLinks] else
    dlg_Open.Options:= dlg_Open.Options + [ofNoDereferenceLinks];
  Tag:= INT_MODALRESULTCANCEL;
  GetLocaleFormatSettings(LOCALE_SYSTEM_DEFAULT, FS);
  GetInterfaceText();
  pc_Task.ActivePage:= tab_General;
  lb_Menu.ItemIndex:= 0;
  lb_Menu.Selected[0]:= true;
  FTools:= TCobTools.Create();

  // Initialize drag'n'drop
  DragAcceptFiles(Handle, True);
end;

procedure Tform_Task.TntFormDestroy(Sender: TObject);
begin
// Finalize drag'n'drop
  DragAcceptFiles(Handle, False);
  FreeAndNil(FTools);
end;

procedure Tform_Task.TntFormShow(Sender: TObject);
begin
  if (FFirstTime) then
  begin
    FSettings:= GetSettingsFilename();

    if (l_ID.Caption = WS_NIL) then
    begin
      FNewTask:= true;
      e_Name.Text:= GenerateTaskName();
      l_ID.Caption:= GenerateTaskID();
      LoadStdTask();
    end else
    begin
        FNewTask:= false;
        LoadTask();
        GetLastUsedSingleSettings();
    end;

    SetNameLabels();

    CheckUI();

    FFirstTime:= false;
  end;
end;

function Tform_Task.ValidateForm(): boolean;
var
  GoodName: boolean;
  ID: WideString;
begin
  Result:= false;

  if (Trim(e_Name.Text) = WS_NIL) then
  begin
    CobShowMessageW(self.Handle, Translator.GetMessage('69'),WS_PROGRAMNAMESHORT);
    SetIndex(0);
    e_Name.SelectAll();
    e_Name.SetFocus();
    Exit;
  end;

  if (not FTools.ValidateFileName(e_Name.Text)) then
  begin
    CobShowMessageW(self.Handle, Translator.GetMessage('71'),WS_PROGRAMNAMESHORT);
    SetIndex(0);
    e_Name.SelectAll();
    e_Name.SetFocus();
    Exit;
  end;

  //Check if the name is UNIQUE in case that you are
  //adding a NEW item.
  //In case you are editing an item, the name
  //CAN  be the same but ONLY if the ID is the same
  GoodName:= true;
  if FNewTask then
    begin
      if (Settings.TaskNameExists(e_Name.Text, ID) <> INT_TASKNOTFOUND) then
        GoodName:= false;
    end else
    begin
      if (Settings.TaskNameExists(e_Name.Text, ID) <> INT_TASKNOTFOUND) and
         (ID <> l_Id.Caption) then
        GoodName:= false;
    end;

  if (not GoodName) then
  begin
    CobShowMessageW(self.Handle, Translator.GetMessage('70'),WS_PROGRAMNAMESHORT);
    SetIndex(0);
    e_Name.SelectAll();
    e_Name.SetFocus();
    Exit;
  end;

  if (not CobIsIntW(e_FullCopies.Text)) then
    if (e_FullCopies.Enabled) then
      begin
        CobShowMessageW(self.Handle, Translator.GetMessage('72'),WS_PROGRAMNAMESHORT);
        SetIndex(0);
        e_FullCopies.SelectAll();
        e_FullCopies.SetFocus();
        Exit;
      end else
        e_FullCopies.Text:= CobIntToStrW(INT_NIL);

  if (not CobIsIntW(e_MakeFull.Text)) then
    if (e_MakeFull.Enabled) then
      begin
        CobShowMessageW(self.Handle, Translator.GetMessage('73'),WS_PROGRAMNAMESHORT);
        SetIndex(0);
        e_MakeFull.SelectAll();
        e_MakeFull.SetFocus();
        Exit;
      end else
        e_MakeFull.Text:= CobIntToStrW(INT_NIL);

  // check the source and destination
  if (lb_Source.Items.Count = 0) and (not rb_Dummy.Checked) then
  begin
    CobShowMessageW(self.Handle, Translator.GetMessage('74'),WS_PROGRAMNAMESHORT);
    SetIndex(1);
    Exit;
  end;

  if (lb_Destination.Items.Count = 0) and (not rb_Dummy.Checked) then
  begin
    CobShowMessageW(self.Handle, Translator.GetMessage('75'),WS_PROGRAMNAMESHORT);
    SetIndex(1);
    Exit;
  end;

  if (not CheckDaysMonth(e_DaysMonth.Text)) then
    if (e_DaysMonth.Enabled) then
    begin
      CobShowMessageW(self.Handle, Translator.GetMessage('76'),WS_PROGRAMNAMESHORT);
      SetIndex(2);
      e_DaysMonth.SelectAll();
      e_DaysMonth.SetFocus();
      Exit;
    end else
      e_DaysMonth.Text:= CobIntToStrW(INT_FIRSTDAY);

  if (not CobIsIntW(e_Timer.Text)) then
    if (e_Timer.Enabled) then
    begin
      CobShowMessageW(self.Handle, Translator.GetMessage('154'),WS_PROGRAMNAMESHORT);
      SetIndex(2);
      e_Timer.SelectAll();
      e_Timer.SetFocus();
      Exit;
    end else
      e_Timer.Text:= CobIntToStrW(INT_DEFTIMER);

  if (CobStrToIntW(e_Timer.Text, INT_DEFTIMER) < INT_NIL) then
    e_Timer.Text:= CobIntToStrW(INT_NIL);

  if (not CobIsInt64W(e_Custom.Text)) then
    if (e_Custom.Enabled) then
    begin
      CobShowMessageW(self.Handle, Translator.GetMessage('77'),WS_PROGRAMNAMESHORT);
      SetIndex(3);
      e_Custom.SelectAll();
      e_Custom.SetFocus();
      Exit;
    end else
      e_Custom.Text:= CobIntToStrW(INT_DEFCUSTOM);

  if (e_Password.Enabled) then
    if (e_Password.Text <> e_PasswordRe.Text) then
    begin
      CobShowMessageW(self.Handle, Translator.GetMessage('78'),WS_PROGRAMNAMESHORT);
      SetIndex(3);
      e_Password.SelectAll();
      e_Password.SetFocus();
      e_PasswordRe.Clear();
      Exit;
    end;

  if (e_Passphrase.Enabled) then
    if (e_Passphrase.Text <> e_PassphraseRe.Text) then
    begin
      CobShowMessageW(self.Handle, Translator.GetMessage('79'),WS_PROGRAMNAMESHORT);
      SetIndex(3);
      e_Passphrase.SelectAll();
      e_Passphrase.SetFocus();
      e_PassphraseRe.Clear();
      Exit;
    end;

  if (cb_Impersonate.Checked) then
    if (Trim(e_ImpersonateID.Text) = WS_NIL) then
    begin
      CobShowMessageW(self.Handle, Translator.GetMessage('80'),WS_PROGRAMNAMESHORT);
      SetIndex(6);
      e_ImpersonateID.SelectAll();
      e_ImpersonateID.SetFocus();
      Exit;
    end;

  if (cb_Encryption.ItemIndex = INT_ENCRSA) then
    if (Trim(e_Key.Text)= WS_NIL) then
      begin
        CobShowMessageW(self.Handle, Translator.GetMessage('81'),WS_PROGRAMNAMESHORT);
        SetIndex(3);
        e_Key.SelectAll();
        e_Key.SetFocus();
        Exit;
      end;

  if (Trim(e_ImpersonateDomain.Text) = WS_NIL) then
    e_ImpersonateDomain.Text:= WS_LOCALDOMAIN;

  Result:= true;
end;

procedure Tform_Task.WMDropFiles(var Msg: TMessage);
var
  ListBox: TTntListBox;
  Count, i, Kind: integer;
  FileName: array [0..INT_MAX_PATHW] of WideChar;
  Source: WideString;
begin
  GetDropListBox(ListBox);
  if (ListBox = nil) then
    Exit;

  if (ListBox = lb_BeforeBackup) or (ListBox = lb_AfterBackup) or (ListBox = lb_Menu) then
    Exit;

  Kind:= INT_SDMANUAL;

  Count := DragQueryFileW(Msg.WParam, $FFFFFFFF, FileName, INT_MAX_PATHW);
  if Count > 0 then
    for i := 0 to Count - 1 do
    begin
      DragQueryFileW(Msg.WParam, i, FileName, INT_MAX_PATHW);
      Source := WideString(FileName);
      if WideFileExists(FTools.NormalizeFileName(Source)) then
      begin
        Kind:= INT_SDFILE;
        //Don't add a file to the destination LB
        if ListBox = lb_Destination then
          Continue;
      end
      else if WideDirectoryExists(FTools.NormalizeFileName(Source)) then
      begin
        if (ListBox = lb_Exclude) or (ListBox = lb_Include) then
          //Fixed 2004-12-08
          Source := CobSetBackSlashW(Source) + WS_ALLFILES;
        Kind:= INT_SDDIR;
      end
      else
        Continue;

      if (ListBox = lb_Exclude) or (ListBox = lb_Include) then
        ListBox.Items.Add(Source)
      else
        AddSDItem(Source, Kind, ListBox); //Add with icons etc...}
    end;
end;

{ TSDData }

constructor TSDData.Create(const Kind: integer; const Path: WideString);
begin
  inherited Create();
  FFtp:= TFTPAddress.Create();

  FKind:= Kind;
  FFullPath:= Path;
  FToShow:= Path;

  if (Kind = INT_SDFTP) then
  begin
    FFtp.DecodeAddress(Path);
    FToShow:= FFtp.EncodeAddressDisplay();
  end;
end;

destructor TSDData.Destroy;
begin
  FreeAndNil(FFtp);
  inherited Destroy();
end;

function TSDData.GetFullPath(): WideString;
begin
  Result:= FFullPath;
end;

function TSDData.GetKind(): integer;
begin
  Result:= FKind;
end;

function TSDData.GetToShow(): WideString;
begin
  Result:= FToShow;
end;

end.
