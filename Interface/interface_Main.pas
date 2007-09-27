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

// Main form of the user interface

unit interface_Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, TntClasses, TntForms,ShellApi, ImgList, interface_Common,
  Menus, TntMenus, ComCtrls, TntComCtrls, bmCommon, ExtCtrls, TntExtCtrls,
  ToolWin, interface_Logreader, interface_Master, interface_InfoReader, CobBarW,
  TntDialogs, SHDocVw, bmConstants, ActiveX, interface_Master_Pipes,
  interface_InfoReader_Pipes;

type
  /// This is the class for the main form. If you are customizing
  /// the program, you would like to change the class name too
  /// because it's name is using in the uninstaller to close the interface
  /// if it is open

  Tform_CB8_Main = class(TTntForm)
    imgs_Tray: TImageList;
    pop_Tray: TTntPopupMenu;
    m_Exit: TTntMenuItem;
    menu_Main: TTntMainMenu;
    m_List: TTntMenuItem;
    panel_Left: TTntPanel;
    splitter_Main: TTntSplitter;
    panel_Right: TTntPanel;
    lv_List: TTntListView;
    pop_Main: TTntPopupMenu;
    m_Style: TTntMenuItem;
    m_StyleIcon: TTntMenuItem;
    m_StyleList: TTntMenuItem;
    m_StyleReport: TTntMenuItem;
    m_StyleSmallIcons: TTntMenuItem;
    pc_Main: TTntPageControl;
    tab_Properties: TTntTabSheet;
    tab_History: TTntTabSheet;
    tab_Log: TTntTabSheet;
    m_List_View: TTntMenuItem;
    m_List_ViewIcon: TTntMenuItem;
    m_List_ViewList: TTntMenuItem;
    m_List_ViewReport: TTntMenuItem;
    m_List_ViewSmallIcon: TTntMenuItem;
    re_Log: TTntRichEdit;
    m_Log: TTntMenuItem;
    m_Log_WordWrap: TTntMenuItem;
    m_Tools: TTntMenuItem;
    m_Tools_Options: TTntMenuItem;
    il_Tabs: TImageList;
    m_Help: TTntMenuItem;
    m_Help_About: TTntMenuItem;
    m_Task: TTntMenuItem;
    m_Task_New: TTntMenuItem;
    img_LVSmall: TImageList;
    img_LVLarge: TImageList;
    lv_Properties: TTntListView;
    lv_History: TTntListView;
    m_Task_Edit: TTntMenuItem;
    m_Task_Delete: TTntMenuItem;
    status_Main: TTntPanel;
    status_Right: TTntPanel;
    status_Left: TTntPanel;
    timer_Animated: TTimer;
    pb_Partial: TCobBarW;
    pb_Total: TCobBarW;
    m_Task_RunAll: TTntMenuItem;
    m_Task_Abort: TTntMenuItem;
    sep_Sep1: TTntMenuItem;
    m_Tools_Decryptor: TTntMenuItem;                                         
    m_pop_About: TTntMenuItem;
    m_Sep001: TTntMenuItem;
    m_Pop_RunAll: TTntMenuItem;
    m_Sep002: TTntMenuItem;
    m_Sep003: TTntMenuItem;
    m_pop_Open: TTntMenuItem;
    m_List_New: TTntMenuItem;
    dlg_Save: TTntSaveDialog;
    m_List_Open: TTntMenuItem;
    m_Sep004: TTntMenuItem;
    dlg_Open: TTntOpenDialog;
    m_List_Save: TTntMenuItem;
    m_Sep005: TTntMenuItem;
    m_List_Import: TTntMenuItem;
    m_Task_RunSelected: TTntMenuItem;
    m_Sep006: TTntMenuItem;
    m_Sep007: TTntMenuItem;
    m_Task_Clone: TTntMenuItem;
    m_Sep008: TTntMenuItem;
    m_Task_Attributes: TTntMenuItem;
    m_Log_Clear: TTntMenuItem;
    m_Log_SelectAll: TTntMenuItem;
    m_Log_Copy: TTntMenuItem;
    m_Log_Print: TTntMenuItem;
    dlg_Print: TPrintDialog;
    m_Log_Open: TTntMenuItem;
    m_Log_Delete: TTntMenuItem;
    m_Sep009: TTntMenuItem;
    m_Sep010: TTntMenuItem;
    m_History: TTntMenuItem;
    m_History_Delete: TTntMenuItem;
    m_History_Properties: TTntMenuItem;
    m_History_Park: TTntMenuItem;
    m_Help_Index: TTntMenuItem;
    m_Sep011: TTntMenuItem;
    m_Sep012: TTntMenuItem;
    m_Help_Web: TTntMenuItem;
    m_Help_Support: TTntMenuItem;
    m_Help_Donate: TTntMenuItem;
    tab_Help: TTntTabSheet;
    tb_Help: TTntToolBar;
    sb_Back: TTntToolButton;
    sb_Forward: TTntToolButton;
    sb_Index: TTntToolButton;
    sb_Web: TTntToolButton;
    sb_Forum: TTntToolButton;
    sb_Tutorial: TTntToolButton;
    sb_Help: TTntStatusBar;
    il_Browser: TImageList;
    m_Help_Tutorial: TTntMenuItem;
    sb_Print: TTntToolButton;
    tim_UI: TTimer;
    sb_Refresh: TTntToolButton;
    sep_001: TTntToolButton;
    sep_002: TTntToolButton;
    sb_Stop: TTntToolButton;
    m_Task_ShutDown: TTntMenuItem;
    il_Menus: TImageList;
    m_Pop_New: TTntMenuItem;
    m_Pop_Edit: TTntMenuItem;
    m_Pop_Disable: TTntMenuItem;
    m_Pop_Reset: TTntMenuItem;
    m_Pop_RunSelected: TTntMenuItem;
    m_Pop_Clone: TTntMenuItem;
    m_Pop_Delete: TTntMenuItem;
    m_Sep013: TTntMenuItem;
    m_Sep0014: TTntMenuItem;
    tb_Main: TTntToolBar;
    b_RunAll: TTntToolButton;
    b_Sep001: TTntToolButton;
    b_RunSelected: TTntToolButton;
    b_New: TTntToolButton;
    b_Sep002: TTntToolButton;
    b_Options: TTntToolButton;
    b_Update: TTntToolButton;
    b_Sep003: TTntToolButton;
    b_About: TTntToolButton;
    b_Help: TTntToolButton;
    il_ToolBarD: TImageList;
    b_Abort: TTntToolButton;
    pop_History: TTntPopupMenu;
    m_Pop_HProperties: TTntMenuItem;
    m_Pop_HDelete: TTntMenuItem;
    m_Pop_HPark: TTntMenuItem;
    pop_Log: TTntPopupMenu;
    m_Pop_SelectAll: TTntMenuItem;
    m_Pop_Copy: TTntMenuItem;
    m_Pop_Clear: TTntMenuItem;
    m_Tools_Update: TTntMenuItem;
    m_Pop_Wrap: TTntMenuItem;
    tim_AutoLU: TTimer;
    m_Tools_Decompressor: TTntMenuItem;
    m_Tools_Translator: TTntMenuItem;
    m_List_Refresh: TTntMenuItem;
    m_Sep015: TTntMenuItem;
    i_ToolBar: TImageList;
    procedure lv_HistoryKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lv_ListKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure lv_ListKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lv_ListDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure lv_ListDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure lv_ListCompare(Sender: TObject; Item1, Item2: TListItem;
      Data: Integer; var Compare: Integer);
    procedure lv_ListColumnClick(Sender: TObject; Column: TListColumn);
    procedure lv_HistoryDblClick(Sender: TObject);
    procedure m_List_RefreshClick(Sender: TObject);
    procedure m_Tools_TranslatorClick(Sender: TObject);
    procedure m_Tools_DecompressorClick(Sender: TObject);
    procedure tim_AutoLUTimer(Sender: TObject);
    procedure m_Tools_UpdateClick(Sender: TObject);
    procedure m_ToolsClick(Sender: TObject);
    procedure m_HelpClick(Sender: TObject);
    procedure pop_LogPopup(Sender: TObject);
    procedure pop_HistoryPopup(Sender: TObject);
    procedure tim_UITimer(Sender: TObject);
    procedure m_Pop_DisableClick(Sender: TObject);
    procedure m_Task_ShutDownClick(Sender: TObject);
    procedure m_History_PropertiesClick(Sender: TObject);
    procedure m_History_DeleteClick(Sender: TObject);
    procedure m_History_ParkClick(Sender: TObject);
    procedure m_HistoryClick(Sender: TObject);
    procedure sb_StopClick(Sender: TObject);
    procedure sb_BackClick(Sender: TObject);
    procedure sb_ForwardClick(Sender: TObject);
    procedure sb_RefreshClick(Sender: TObject);
    procedure sb_PrintClick(Sender: TObject);
    procedure sb_TutorialClick(Sender: TObject);
    procedure sb_ForumClick(Sender: TObject);
    procedure sb_WebClick(Sender: TObject);
    procedure sb_IndexClick(Sender: TObject);
    procedure m_Help_TutorialClick(Sender: TObject);
    procedure m_Help_IndexClick(Sender: TObject);
    procedure m_Help_DonateClick(Sender: TObject);
    procedure m_Help_SupportClick(Sender: TObject);
    procedure m_Help_WebClick(Sender: TObject);
    procedure m_Log_DeleteClick(Sender: TObject);
    procedure m_Log_OpenClick(Sender: TObject);
    procedure m_Log_PrintClick(Sender: TObject);
    procedure m_Log_CopyClick(Sender: TObject);
    procedure m_Log_SelectAllClick(Sender: TObject);
    procedure m_Log_ClearClick(Sender: TObject);
    procedure m_Task_AttributesClick(Sender: TObject);
    procedure m_Task_CloneClick(Sender: TObject);
    procedure m_Task_RunSelectedClick(Sender: TObject);
    procedure m_List_ImportClick(Sender: TObject);
    procedure m_List_SaveClick(Sender: TObject);
    procedure m_List_OpenClick(Sender: TObject);
    procedure m_List_NewClick(Sender: TObject);
    procedure m_pop_OpenClick(Sender: TObject);
    procedure m_Tools_DecryptorClick(Sender: TObject);
    procedure m_Task_AbortClick(Sender: TObject);
    procedure m_Task_RunAllClick(Sender: TObject);
    procedure timer_AnimatedTimer(Sender: TObject);
    procedure TntFormResize(Sender: TObject);
    procedure status_LeftDblClick(Sender: TObject);
    procedure m_Task_DeleteClick(Sender: TObject);
    procedure m_TaskClick(Sender: TObject);
    procedure m_Task_EditClick(Sender: TObject);
    procedure lv_PropertiesDblClick(Sender: TObject);
    procedure lv_ListClick(Sender: TObject);
    procedure m_Task_NewClick(Sender: TObject);
    procedure m_Help_AboutClick(Sender: TObject);
    procedure m_Tools_OptionsClick(Sender: TObject);
    procedure m_Log_WordWrapClick(Sender: TObject);
    procedure m_LogClick(Sender: TObject);
    procedure m_ListClick(Sender: TObject);
    procedure m_StyleSmallIconsClick(Sender: TObject);
    procedure m_StyleReportClick(Sender: TObject);
    procedure m_StyleListClick(Sender: TObject);
    procedure m_StyleIconClick(Sender: TObject);
    procedure pop_MainPopup(Sender: TObject);
    procedure TntFormShow(Sender: TObject);
    procedure TntFormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure m_ExitClick(Sender: TObject);
    procedure TntFormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FLastTimeQuered: TDateTime;
    FSGlobal: TFormatSettings;
    FSLocal: TFormatSettings;
    FirstTime: boolean;
    FIcon: TIcon;
    FCurrentKey: TCobHotKey;
    FHotKey: word;
    FAtomName: WideString;
    FLogReaderThread: TLogReader;
    FMaster: TIPCMaster;
    FMasterPipes: TIPCMasterPipe;
    FEncoder: TTntStringList;
    FTool: TCobTools;
    FBackingUp: boolean;
    FInfoReader: TInfoReader;
    FInfoReaderPipes: TInfoReaderPipe;
    FConnected: boolean;
    FAnimated: boolean;
    FFullDestroy: boolean;
    FCurrentTaskName: WideString;
     /// FOneInstance is the handle of the mutex used to allow only one instance
    /// of the interface. The instance must be unique per desktop  but not Global
    FOneInstance: THandle;
    // FSysTrayIcon is the TNotifyIconData used for the tray
    FSysTrayIcon: TNotifyIconDataW;
    /// WM_TASKBAR_CREATED is used for RegisterWindowMessage('TaskbarCreated');
    WM_TASKBAR_CREATED: Cardinal;
    FIconIndex: Integer;
    FOriginalStatus: WideString;
    FOldImageIndex: integer;
    FOldName: WideString;
    FUIMutex: THandle;
    FCanUseIE: boolean;
    FBrowser: TWebBrowser;
    FCancelDelete: boolean;
    FShutDown: boolean;
    FLUDateOnceADay: TDateTime;
    FReversed: boolean;
    FColumnToSort: integer;
    FOleInPlaceActiveObject: IOleInPlaceActiveObject;
    iOIPAO: IOleInPlaceActiveObject;
    Dispatch: IDispatch;
    FPipes: boolean;
    procedure CloseEngine();
    procedure CreateTray();
    procedure DestroyTray();
    procedure SetApplicationHint(Operation, Partial, Total: integer;
                                 const TaskID: WideString);
    procedure ShowMainWindow();
    procedure Init();
    procedure DeInit();
    procedure EditTask();
    procedure DeleteTask();
    procedure CreateMaster();
    procedure DestroyMaster();
    procedure CreateUISettings();
    procedure DestroyUISettings();
    procedure ApplyWindowSettings();
    procedure SavePosition();
    procedure SaveUISettings();
    procedure ApplyPositions();
    procedure CreateHintScreen();
    procedure CreateInfoReader();
    procedure DestroyInfoReader();
    procedure DestroyHintScreen();
    procedure DestroyInstanceMutex();
    procedure CloneTasks();
    procedure ResetAttributes();
    procedure ResetAttributesSource(const Source: WideString; const SubDirs: boolean);
    procedure ResetDirectoryAttributes(const Source: WideString; const Subdirs: boolean);
    procedure ShowBallon(const Msg: WideString; const TimeMS: cardinal);
    procedure DisableTrayMenu();
    procedure EnableTrayMenu();
    procedure GetInterfaceText();
    function CheckPassword(): boolean;
    procedure SetHotKey(const Key: TCobHotKey);
    procedure UnsetHotKey();
    procedure CreateLogReader();
    procedure DestroyLogReader();
    function CheckInstance(): boolean;
    function GetMultipleInstancesWarn(): boolean;
    procedure PostEngineMessage(const Cmd,Param1,Param2,Param3: WideString);
    procedure DisplayTasks(const Selected: WideString);
    procedure ModifyTask(const TaskID, InitialSource: WideString);
    procedure DisplaySelectedTask();
    procedure DisplayProperties();
    procedure DisplayHistory();
    procedure DisplayTask(const TaskID, Size: WideString);
    function CompressionToHuman(const Value: integer): WideString;
    function BoolToHuman(const Bool: boolean): WideString;
    function BackupTypeToHuman(const Kind: integer): WideString;
    function ScheduleTypeToHuman(const Kind: integer): WideString;
    function DaysOfWeekToHuman(const Days: WideString): WideString;
    function IntegerToDay(const Day: integer): WideString;
    procedure AddProperty(const Caption, Value: WideString; const Icon: integer);
    procedure AddSourcesDestinations(const Value: WideString;
                                      const Kind, Source: integer);
    function MonthToHuman(const Index: integer): WideString;
    function SplitToHuman(const Value: integer): WideString;
    function EncryptionToHuman(const Value: integer): WideString;
    procedure DisplayHistoryItem(const ID: WideString);
    procedure DeleteATask(const ID: WideString; const DeleteFiles: boolean);
    function BackupToHuman(const Backup: TBackup): WideString;
    procedure TrayActive();
    procedure TrayInactive();
    procedure GetItem(const IName: WideString; var Item: TTntListItem);
    procedure CreateUIMutex();
    procedure DestroyUIMutex();
    procedure ImportList(const ListName: WideString);
    procedure RunSelected();
    procedure RunAll();
    procedure ShowHelp(const InitialSite: WideString; const ForceInternal, Local: boolean);
    procedure ShowHelpInternal(const InitialSite: WideString; const ChangeTab, Local: boolean);
    procedure ShowHelpExternal(const InitialSite: WideString);
    function IsExplorerInstalled(): boolean;
    procedure ShowHideBrowser();
    procedure ShowIntroHelpPage();
    procedure OnDocumetComplete(Sender: TObject; const pDisp: IDispatch; var URL: OleVariant);
    function AreBackupParked(): boolean;
    procedure ChangeParkingStatus(const Checked:boolean);
    procedure DeleteBackups(const DeleteFiles: boolean);
    procedure DeleteBackupFiles(const Backup: TBackup);
    procedure DeleteFTP(const Backup: TBackup);
    procedure DeleteLocal(const Backup: TBackup);
    procedure DeleteAssociatedBackups(const ID: WideString);
    procedure ShowBackupProperties();
    procedure CheckUpdates(const UI: boolean);
    procedure OnUpdateDone(Sender: TObject);
    function NeedToCheckUpdates(): boolean;
    procedure SetLastUpdate();
    procedure CheckOldBackups();
    procedure NeedToAutoBackup();
    procedure ArrangeList();
    procedure LogCleanInfo(const Info: WideString);
  public
    procedure Log(const Msg: WideString; const Error: boolean; EMessage:boolean = false);
    procedure CalculationDone(Sender: TObject);
    procedure BeginBackup();
    procedure CloseInterface();
    procedure EndBackup();
    procedure OnConnect();
    procedure OnDisconnect();
    procedure ClearProgress();
    procedure TrayAnimateBegin();
    procedure TrayAnimateEnd();
    procedure DisplayStatus(const IName, FileName: WideString;
                            const Operation, Partial, Total: integer);
    procedure ExecuteFile(const FileName, Param: WideString);
    procedure ExecuteFileAndWait(const FileName, Param: WideString);
    procedure CloseAWindow(const ACaption: WideString; Kill: boolean);
    procedure OnForcedTerminated(Sender: TObject);
  protected
    /// This method is fired when there is a mouse event on the system tray icon
    procedure OnSysTrayIcon(var rMsg: TMessage); message WM_SYSTRAYICON;
    /// The windows procedure. Processes all messages
    procedure WndProc(var Msg: TMessage); override;
    /// The application message queue  handler
    procedure OnApplicationMessage(var Msg: TMsg; var Handled: Boolean);
    /// This is a message method used to close the main form
    /// and terminate the program
    procedure WMCloseMainForm(var Msg: TMessage); message WM_CLOSECBUMAINFORM;
    // called from Cancel form
    procedure DoCancelDelete(var Msg: TMessage); message INT_CANCELDELETE;
    /// Handles the drag and drop stuff
    procedure WMDropFiles(var Msg: TMessage); message WM_DROPFILES;
    //Log if exception
    procedure OnException(Sender: TObject; E:Exception);
  end;

var
  form_CB8_Main: Tform_CB8_Main;
  IsService: boolean;
  Maxi : boolean;
  BackupAll: boolean;
  ListToLoad: WideString;

implementation

uses  bmCustomize, CobCommonW, bmTranslator, interface_Balloon,
      DateUtils, TntSysUtils, interface_Options,
      SyncObjs, interface_About, interface_Task, CobDialogsW,
      interface_InputBox, interface_Calculator, MMSystem, interface_Importer,
      interface_Canceler, interface_Backup, interface_Update,
      interface_BackupForcer;

{$R *.dfm}
{$R ..\Common\vista.RES}

procedure Tform_CB8_Main.FormCreate(Sender: TObject);
begin
  Caption := WS_PROGRAMNAMELONG;
  TntApplication.Title:= WS_PROGRAMNAMELONG;
  Tag:= INT_MODALRESULTCANCEL;
  Application.OnMessage:= OnApplicationMessage;
  pc_Main.ActivePage:= tab_Properties;
  FirstTime:= true;
  FLastTimeQuered:= DOUBLE_NIL;
  FCurrentKey:= ckNone;
  FBackingUp:= false;
  FConnected:= true;
  FAnimated:= false;
  FOriginalStatus:= WS_NIL;
  FOldImageIndex:= INT_INDEXNOICON;
  FOldName:= WS_NIL;
  FCurrentTaskName:= WS_NIL;
  FFullDestroy:= true;
  FCanUseIE:= false;
  FBrowser:= nil;
  FShutDown:= false;
  FLUDateOnceADay:= F_NIL;
  tab_Help.TabVisible:= false;
  FReversed:= true;
  FColumnToSort:= -1;

  timer_Animated.Enabled:= false;

  // Initialize drag'n'drop
  DragAcceptFiles(Handle, True);

  OleInitialize(nil);

  Init();
end;

procedure Tform_CB8_Main.FormDestroy(Sender: TObject);
begin
  DeInit();
  OleUninitialize();
  // Finalize drag'n'drop
  DragAcceptFiles(Handle, False);
  timer_Animated.Enabled:= false;
end;

procedure Tform_CB8_Main.GetInterfaceText();
begin
  m_List.Caption:= Translator.GetInterfaceText('1');
  m_Exit.Caption:= Translator.GetInterfaceText('2');
  m_List_View.Caption := Translator.GetInterfaceText('4');
  m_Style.Caption:= Translator.GetInterfaceText('4');
  m_List_ViewIcon.Caption:= Translator.GetInterfaceText('5');
  m_StyleIcon.Caption:= Translator.GetInterfaceText('5');
  m_List_ViewList.Caption:= Translator.GetInterfaceText('6');
  m_StyleList.Caption:= Translator.GetInterfaceText('6');
  m_List_ViewReport.Caption:= Translator.GetInterfaceText('7');
  m_StyleReport.Caption:= Translator.GetInterfaceText('7');
  m_List_ViewSmallIcon.Caption:= Translator.GetInterfaceText('8');
  m_StyleSmallIcons.Caption:= Translator.GetInterfaceText('8');
  tab_Properties.Caption:= Translator.GetInterfaceText('9');
  tab_History.Caption:= Translator.GetInterfaceText('10');
  tab_Log.Caption:= Translator.GetInterfaceText('11');
  tab_Help.Caption:= Translator.GetInterfaceText('586');
  m_Log.Caption:= Translator.GetInterfaceText('12');
  m_Log_WordWrap.Caption:= Translator.GetInterfaceText('13');
  m_Tools.Caption:= Translator.GetInterfaceText('14');
  m_Tools_Options.Caption:= Translator.GetInterfaceText('15');
  m_Help.Caption:= Translator.GetInterfaceText('74');
  m_Help_About.Caption:= WideFormat(Translator.GetInterfaceText('75'),[WS_PROGRAMNAMESHORT], FSLocal);
  m_Task.Caption:= Translator.GetInterfaceText('76');
  m_Task_New.Caption:= Translator.GetInterfaceText('77');
  lv_List.Columns[0].Caption:= Translator.GetInterfaceText('364');
  lv_List.Columns[1].Caption:= Translator.GetInterfaceText('365');
  lv_List.Columns[2].Caption:= Translator.GetInterfaceText('366');
  lv_Properties.Columns[0].Caption:= Translator.GetInterfaceText('367');
  lv_Properties.Columns[1].Caption:= Translator.GetInterfaceText('368');
  lv_History.Columns[0].Caption:= Translator.GetInterfaceText('369');
  lv_History.Columns[1].Caption:= Translator.GetInterfaceText('370');
  lv_History.Columns[2].Caption:= Translator.GetInterfaceText('371');
  m_Task_Edit.Caption:= Translator.GetInterfaceText('372');
  m_Task_Delete.Caption:= Translator.GetInterfaceText('373');
  m_Task_RunAll.Caption:= Translator.GetInterfaceText('446');
  m_Task_Abort.Caption:= Translator.GetInterfaceText('461');
  m_Tools_Decryptor.Caption:= Translator.GetInterfaceText('480');
  m_pop_About.Caption:= WideFormat(Translator.GetInterfaceText('75'),[WS_PROGRAMNAMESHORT],FSLocal);
  m_Pop_RunAll.Caption:= Translator.GetInterfaceText('446');
  m_pop_Open.Caption:= Translator.GetInterfaceText('558');
  m_List_New.Caption:= Translator.GetInterfaceText('559');
  m_List_Open.Caption:= Translator.GetInterfaceText('560');
  m_List_Save.Caption:= Translator.GetInterfaceText('561');
  m_List_Import.Caption:= Translator.GetInterfaceText('562');
  m_Task_RunSelected.Caption:= Translator.GetInterfaceText('563');
  m_Task_Attributes.Caption:= Translator.GetInterfaceText('568');
  m_Log_Clear.Caption:= Translator.GetInterfaceText('569');
  m_Log_SelectAll.Caption:= Translator.GetInterfaceText('570');
  m_Log_Copy.Caption:= Translator.GetInterfaceText('571');
  m_Log_Print.Caption:= Translator.GetInterfaceText('572');
  m_Log_Open.Caption:= Translator.GetInterfaceText('573');
  m_Log_Delete.Caption:= Translator.GetInterfaceText('574');
  m_History.Caption:= Translator.GetInterfaceText('575');
  m_History_Delete.Caption:= Translator.GetInterfaceText('576');
  m_History_Properties.Caption:= Translator.GetInterfaceText('577');
  m_History_Park.Caption:= Translator.GetInterfaceText('578');
  m_Help_Index.Caption:= Translator.GetInterfaceText('557');
  m_Help_Web.Caption:= Translator.GetInterfaceText('579');
  m_Help_Support.Caption:= Translator.GetInterfaceText('580');
  m_Help_Donate.Caption:= Translator.GetInterfaceText('581');
  m_Help_Tutorial.Caption:= Translator.GetInterfaceText('587');
  sb_Back.Hint:= Translator.GetInterfaceText('588');
  sb_Forward.Hint:= Translator.GetInterfaceText('589');
  sb_Index.Hint:= Translator.GetInterfaceText('590');
  sb_Web.Hint:= Translator.GetInterfaceText('591');
  sb_Forum.Hint:= Translator.GetInterfaceText('592');
  sb_Tutorial.Hint:= Translator.GetInterfaceText('593');
  sb_Print.Hint:= Translator.GetInterfaceText('594');
  sb_Refresh.Hint:= Translator.GetInterfaceText('595');
  sb_Stop.Hint:= Translator.GetInterfaceText('596');
  m_Task_ShutDown.Caption:= Translator.GetInterfaceText('613');
  m_Pop_New.Caption:= Translator.GetInterfaceText('77');
  m_Pop_Edit.Caption:= Translator.GetInterfaceText('372');
  m_Pop_Disable.Caption:= Translator.GetInterfaceText('617');
  m_Pop_Reset.Caption:= Translator.GetInterfaceText('568');
  m_Pop_RunSelected.Caption:= Translator.GetInterfaceText('563');
  m_Task_Clone.Caption:= Translator.GetInterfaceText('618');
  m_Pop_Clone.Caption:= Translator.GetInterfaceText('618');
  m_Pop_Delete.Caption:= Translator.GetInterfaceText('373');
  b_RunAll.Hint:=Translator.GetInterfaceText('619');
  b_RunSelected.Hint:=Translator.GetInterfaceText('620');
  b_New.Hint:=Translator.GetInterfaceText('621');
  b_Options.Hint:=Translator.GetInterfaceText('622');
  b_Update.Hint:=Translator.GetInterfaceText('623');
  b_About.Hint:= WideFormat(Translator.GetInterfaceText('624'),[WS_PROGRAMNAMESHORT],FSLocal);
  b_Help.Hint:=Translator.GetInterfaceText('625');
  b_Abort.Hint:=Translator.GetInterfaceText('626');
  m_Pop_HDelete.Caption:= Translator.GetInterfaceText('576');
  m_Pop_HProperties.Caption:= Translator.GetInterfaceText('577');
  m_Pop_HPark.Caption:= Translator.GetInterfaceText('578');
  m_Tools_Update.Caption:= Translator.GetInterfaceText('627');
  m_Pop_SelectAll.Caption:= Translator.GetInterfaceText('570');
  m_Pop_Copy.Caption:= Translator.GetInterfaceText('571');
  m_Pop_Clear.Caption:= Translator.GetInterfaceText('569');
  m_Pop_Wrap.Caption:= Translator.GetInterfaceText('13');
  m_Tools_Decompressor.Caption:= Translator.GetInterfaceText('686');
  m_Tools_Translator.Caption:= Translator.GetInterfaceText('687');
  m_List_Refresh.Caption:= Translator.GetInterfaceText('690');
end;

procedure Tform_CB8_Main.GetItem(const IName: WideString; var Item: TTntListItem);
var
  i: integer;
begin
  Item:= nil;
  for i:= 0 to lv_List.Items.Count - 1 do
  begin
    if (lv_List.Items[i].SubItems[0] = IName) then
    begin
      Item:= lv_List.Items[i];
      FCurrentTaskName:= lv_List.Items[i].Caption;
      Break;
    end;
  end;

end;

function Tform_CB8_Main.GetMultipleInstancesWarn(): boolean;
var
  Flag: WideString;
begin
  Flag:= Globals.SettingsPath + WS_FLAGWARN;
  Result:= not WideFileExists(Flag);
end;

procedure Tform_CB8_Main.ImportList(const ListName: WideString);
var
  Importer: TImporter;
  Version: integer;
  Msg: WideString;
begin
  Log(WideFormat(Translator.GetMessage('447'),[ListName], FSLocal), false, false);
  Importer:= TImporter.Create();
  try
    Version:= Importer.Import(ListName);
    if (Version = INT_VER0) then
    begin
      Msg:= WideFormat(Translator.GetMessage('448'),[ListName], FSLocal);
      Log(Msg, true, false);
      CobShowMessageW(self.Handle, Msg, WS_PROGRAMNAMESHORT);
    end else
    begin
      Settings.SaveList();
      Msg:= WideFormat(Translator.GetMessage('449'),[ListName, Version], FSLocal);
      Log(Msg, false, false);
      CobShowMessageW(self.Handle, Msg, WS_PROGRAMNAMESHORT);
    end;
  finally
    FreeAndNil(Importer);
  end;
end;

procedure Tform_CB8_Main.Init();
begin
  GetLocaleFormatSettings(LOCALE_SYSTEM_DEFAULT, FSGlobal);
  GetLocaleFormatSettings(LOCALE_USER_DEFAULT, FSLocal);

  FAtomName:= WideFormat(WS_HOTKEYATOM,[WS_PROGRAMNAMELONG],FSGlobal);
  FHotKey := AddAtomW(PWideChar(FAtomName));

  Globals:= TGlobalUtils.Create(CobGetAppPathW(), IsService);
  Globals.CheckDirectories();

  Settings:= TSettings.Create(@Globals.Sec,Globals.AppPath,Globals.DBPath,Globals.SettingsPath);
  Settings.LoadSettings();
  Settings.LoadList();

  Translator:= TTranslator.Create(@Globals.Sec, Globals.AppPath, Globals.LanguagesPath);
  Translator.LoadLanguage(Settings.GetLanguage());

  CreateUISettings();

  CreateUIMutex();

  if (CheckInstance()) then
  begin
    if (GetMultipleInstancesWarn()) then
      CobShowMessageW(handle, Translator.GetMessage('16'),WS_PROGRAMNAMESHORT);

    // This flag tells the DeInit procedure not to try to destroy
    // things that were not created (I'll exit here)
    FFullDestroy:= false;
     //I could use Close here, but I use a message to myself
    //to close gracefully
    PostMessageW(Handle, WM_CLOSECBUMAINFORM, 0, 0);

    Exit;
  end;

  FCanUseIE:= IsExplorerInstalled();

  ShowHideBrowser();

  tim_UI.Enabled:= true;

  ShowIntroHelpPage();

  // Try icon
  FIcon:= TIcon.Create();
  if (not Maxi) then
    CreateTray();

  CreateHintScreen();

  if (UISettings.ShowWelcomeScreen) then
    ShowBallon(WideFormat(Translator.GetMessage('11'),
                [WS_PROGRAMNAMESHORT],FSLocal),INT_SHOWWINDOWHINT);

  FTool:= TCobTools.Create();

  GetInterfaceText();

  FPipes:= Settings.GetUsePipes();

  CreateLogReader();

  CreateMaster();

  // Set the default disconnected look
  OnDisconnect();

  CreateInfoReader();

  DisplayTasks(WS_NIL);

  Log(Translator.GetMessage('14'),false);

  Application.OnException:= OnException;

  CheckOldBackups();

  if (not Settings.CheckTemporaryDir(Globals.DBPath)) then
    Log(WideFormat(Translator.GetMessage('633'),[Settings.GetTemp],FSLocal),true, false);
end;

function Tform_CB8_Main.IntegerToDay(const Day: integer): WideString;
begin
  case Day of
    INT_DMONDAY: Result:= Translator.GetInterfaceText('127');
    INT_DTUESDAY: Result:= Translator.GetInterfaceText('128');
    INT_DWEDNESDAY: Result:= Translator.GetInterfaceText('129');
    INT_DTHURSDAY: Result:= Translator.GetInterfaceText('130');
    INT_DFRIDAY: Result:= Translator.GetInterfaceText('131');
    INT_DSATURDAY: Result:= Translator.GetInterfaceText('132');
    else
      Result:= Translator.GetInterfaceText('133');
  end;
end;

function Tform_CB8_Main.IsExplorerInstalled(): boolean;
begin
  try
    // Remove the OleInitialize and OleUninitialize  from the constructor
    // and destructor if you remove the whole webbrowser thingy
    FBrowser:= TWebBrowser.Create(self);
    TControl(FBrowser).Parent:= tab_Help;
    FBrowser.Align:= alClient;
    FBrowser.OnDocumentComplete:= OnDocumetComplete;
    Result:= true;
  except
    Result:= false;
    sb_Back.Enabled:= false;
    sb_Forward.Enabled:= false;
    FBrowser:= nil;
  end;
end;

procedure Tform_CB8_Main.Log(const Msg: WideString; const Error: boolean;
  EMessage: boolean);
var
  St: WideString;
begin
 if Error then
    re_Log.SelAttributes.Color := clRed
  else
    re_Log.SelAttributes.Color := clBlack;

  St := WS_NIL;

  if (not EMessage) then
    //If the message comes from the engine, it is already formatted
  begin
    if Error then
      St := WS_ERROR
    else
      St := WS_NOERROR;

    St:= WideFormat(WS_LOGSTRING,[St,WideString(DateTimeToStr(Now(),FSLocal)), Msg],FSLocal);
  end
  else
    St := Msg;

  re_Log.Lines.Add(St);
  re_Log.Perform(EM_LineScroll, 0, re_Log.Lines.Count - 5);
  Application.ProcessMessages();
end;

procedure Tform_CB8_Main.LogCleanInfo(const Info: WideString);
var
  SL: TTntStringList;
  i: integer;
begin
  Sl:= TTntStringList.Create();
  try
    Sl.CommaText:= Info;
    for i:= 0 to Sl.Count - 1 do
    begin
      Log(Sl[i], false, true); // true to eliminate date/time
    end;
  finally
    FreeAndNil(Sl);
  end;
end;

procedure Tform_CB8_Main.lv_HistoryDblClick(Sender: TObject);
begin
  if (lv_History.SelCount > 0) then
    m_History_PropertiesClick(self);
end;

procedure Tform_CB8_Main.lv_HistoryKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_DELETE then
    m_History_DeleteClick(self);

  if Key = VK_RETURN then
    m_History_PropertiesClick(self);
end;

procedure Tform_CB8_Main.lv_ListClick(Sender: TObject);
begin
  DisplayProperties();
  DisplayHistory();
end;

procedure Tform_CB8_Main.lv_ListColumnClick(Sender: TObject;
  Column: TListColumn);
var
  i: integer;
begin
  i := Column.Index;
  if i = FColumnToSort then
    FReversed := not FReversed;
  FColumnToSort := i;
  (Sender as TTntListView).AlphaSort();
  ArrangeList();
end;

procedure Tform_CB8_Main.lv_ListCompare(Sender: TObject; Item1,
  Item2: TListItem; Data: Integer; var Compare: Integer);
var
  Comp: integer;
begin
  if FColumnToSort = 0 then
    Comp := WideCompareText((Item1 as TTntListItem).Caption, (Item2 as TTntListItem).Caption)
  else
    Comp := WideCompareText((Item1 as TTntListItem).SubItems[0], (Item2 as TTntListItem).SubItems[0]);

  if FReversed then
    Compare := -Comp
  else
    Compare := Comp;
end;

procedure Tform_CB8_Main.lv_ListDragDrop(Sender, Source: TObject; X,
  Y: Integer);
var
  Pos, Element: TTntListItem;
  Index, OldIndex: integer;
begin
  Pos := lv_List.GetItemAt(x, y) as TTntListItem;

  if Pos <> nil then
  begin
    Index := lv_List.Items.IndexOf(Pos);
    OldIndex := lv_List.ItemIndex;
    if OldIndex <> -1 then
    begin
      if OldIndex = Index then
        Exit;
      Pos := lv_List.Items[OldIndex] as TTntListItem; //Item to drag
      if Index < OldIndex then
        Element := lv_List.Items.Insert(Index)
      else if Index = lv_List.Items.Count - 1 then
        Element := lv_List.Items.Add()
      else
        Element := lv_List.Items.Insert(Index + 1);
      Element.Caption := Pos.Caption;
      Element.SubItems.Add(Pos.SubItems[0]);
      Element.SubItems.Add(Pos.SubItems[1]);
      Element.ImageIndex := Pos.ImageIndex;
      if Index < OldIndex then
        lv_List.Items.Delete(OldIndex + 1)
      else
        lv_List.Items.Delete(OldIndex);
      lv_List.ItemIndex := Element.Index;
      lv_List.Selected := Element;
      m_ListClick(self);
    end;

    ArrangeList();
  end;

end;

procedure Tform_CB8_Main.lv_ListDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
var
  Pos: TTntListItem;
begin
  Pos := lv_List.GetItemAt(x, y) as TTntListItem;
  if Pos <> nil then
    Accept := true
  else
    Accept := false;
end;

procedure Tform_CB8_Main.lv_ListKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_DELETE then
    m_Task_DeleteClick(self);

  if Key = VK_RETURN then
    m_Task_EditClick(self); 
end;

procedure Tform_CB8_Main.lv_ListKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //Refresh backup history and properties
  //when the user press the arrows
  if (Key = VK_UP) or (Key = VK_DOWN) or (Key = VK_LEFT) or (Key = VK_RIGHT)
  or (Key = VK_HOME) or (Key = VK_END) then
    lv_ListClick(self);
end;

procedure Tform_CB8_Main.lv_PropertiesDblClick(Sender: TObject);
begin
  if (lv_List.SelCount > 0) then
    m_Task_EditClick(Sender);
end;

procedure Tform_CB8_Main.ModifyTask(const TaskID, InitialSource: WideString);
begin
  if (form_Task = nil) then
  begin
    DisableTrayMenu();
    form_Task:= Tform_Task.Create(nil);
    try
      form_Task.l_ID.Caption:= TaskID;
      form_Task.InitialSource:= InitialSource;
      form_Task.ShowModal();
      if (form_Task.Tag = INT_MODALRESULTOK) then
      begin
        // First save the new list
        Settings.SaveList();

        // And send the message to the engine to reload the list
        PostEngineMessage(WS_CMDRELOADLIST, WS_NIL, WS_NIL, WS_NIL);

        // now show the list
        DisplayTasks(form_Task.l_Id.Caption);

        //Log
        Log(WideFormat(Translator.GetMessage('82'),
                            [form_Task.e_Name.Text], FSGlobal), false, false);

      end;
    finally
      form_Task.Release();
      form_Task:= nil;
      EnableTrayMenu();
    end;
  end;
end;

function Tform_CB8_Main.MonthToHuman(const Index: integer): WideString;
begin
  case Index of
    INT_MJANUARY: Result:= Translator.GetInterfaceText('205');
    INT_MFEBRUARY: Result:= Translator.GetInterfaceText('206');
    INT_MMARCH: Result:= Translator.GetInterfaceText('207');
    INT_MAPRIL: Result:= Translator.GetInterfaceText('208');
    INT_MMAY: Result:= Translator.GetInterfaceText('209');
    INT_MJUNE: Result:= Translator.GetInterfaceText('210');
    INT_MJULY: Result:= Translator.GetInterfaceText('211');
    INT_MAUGUSTY: Result:= Translator.GetInterfaceText('212');
    INT_MSEPTEMBER: Result:= Translator.GetInterfaceText('213');
    INT_MOCTOBER: Result:= Translator.GetInterfaceText('214');
    INT_MNOVEMBER: Result:= Translator.GetInterfaceText('215');
    else
    Result:= Translator.GetInterfaceText('216');
  end;
end;

function Tform_CB8_Main.DaysOfWeekToHuman(const Days: WideString): WideString;
var
  Sl: TTntStringList;
  i: integer;
begin
  Sl:= TTntStringList.Create();
  try
    Sl.CommaText:= Days;
    for i:=0 to Sl.Count-1 do
      Sl[i]:= IntegerToDay(CobStrToIntW(Sl[i], INT_DMONDAY));
    Result:= Sl.CommaText;
  finally
    FreeAndNil(Sl);
  end;
end;

procedure Tform_CB8_Main.DeInit();
begin
  if (FFullDestroy) then
  begin
    DestroyInfoReader();

    DestroyMaster();

    Log(Translator.GetMessage('15'),false);

    DestroyLogReader();

    FreeAndNil(FTool);

    DestroyHintScreen();

    if (not Maxi) then
      DestroyTray();
  end;

  DestroyInstanceMutex();

  DestroyUIMutex();

  DestroyUISettings();

  if (Translator <> nil) then
    FreeAndNil(Translator);

  if (Settings <> nil) then
    FreeAndNil(Settings);

  if (Globals <> nil) then
    FreeAndNil(Globals);

  UnsetHotKey();
  if (FHotKey <> 0) then
    begin
      DeleteAtom(FHotKey);
      FHotKey:= 0;
    end;
end;

procedure Tform_CB8_Main.DeleteAssociatedBackups(const ID: WideString);
var
  List: TBackupList;
  Backup: TBackup;
  i, Count: integer;
begin
  List:= TBackupList.Create();
  try
    List.LoadBackups(ID);
    Count:= List.GetCount();
    for i:= Count-1 downto 0 do
    begin
      List.GetBackupPointerIndex(i, Backup);
      if (Backup <> nil) then
      begin
        if (not Backup.FParked) then
        begin
          DeleteBackupFiles(Backup);
          List.DeleteBackupIndex(i);
        end;
      end;
      if (FCancelDelete) then
        Break;
    end;
    List.SaveBackups(ID);
  finally
    FreeAndNil(List);
  end;
end;

procedure Tform_CB8_Main.DeleteATask(const ID: WideString;
  const DeleteFiles: boolean);
begin
  if (DeleteFiles) then
    DeleteAssociatedBackups(ID);

  Settings.DeleteTask(ID);
end;

procedure Tform_CB8_Main.DeleteBackupFiles(const Backup: TBackup);
var
  Destination: WideString;
  Kind: integer;
begin
  Destination:= FTool.DecodeSD(Backup.FDestination, Kind);
  if (Kind = INT_SDFTP) then
    DeleteFTP(Backup) else
    DeleteLocal(Backup);
end;

procedure Tform_CB8_Main.DeleteBackups(const DeleteFiles: boolean);
var
  i: integer;
  Backup: TBackup;
  List: TBackupList;
begin
  List:= TBackupList.Create();
  try
    List.LoadBackups(lv_List.Selected.SubItems[0]);
    for i:= lv_History.Items.Count -1 downto 0 do
      if (lv_History.Items[i].Selected) then
      begin
        List.GetBackupPointer(lv_History.Items[i].SubItems[1], Backup);
        if (Backup <> nil) then
        begin
          if (Backup.FParked) then
          begin
            Log(WideFormat(Translator.GetMessage('471'),[Backup.FBackupID],FSLocal),true, false);
            Continue;
          end else
          Log(WideFormat(Translator.GetMessage('470'),[Backup.FBackupID],FSLocal),false, false);

          if (DeleteFiles) then
            DeleteBackupFiles(Backup);
          List.DeleteBackup(Backup.FBackupID);
        end;
      end;
    List.SaveBackups(lv_List.Selected.SubItems[0]);
  finally
    FreeAndNil(List);
  end;    
end;

procedure Tform_CB8_Main.DeleteFTP(const Backup: TBackup);
var
  Destination: WideString;
  Kind: integer;
  Canceler: Tform_Canceler;
begin
  Destination:= FTool.DecodeSD(Backup.FDestination, Kind);
  if (not Kind = INT_SDFTP) then
  begin
    Log(WideFormat(Translator.GetMessage('431'),[Destination],FSLocal), true, false);
    Exit;
  end;

  DisableTrayMenu();
  Canceler:= Tform_Canceler.Create(nil);
  try
    Canceler.Operation:= INT_OPUIFTPDEL;
    Canceler.Backup:= Backup;
    Canceler.ShowModal();
  finally
    Canceler.Release();
    EnableTrayMenu();
  end;
end;

procedure Tform_CB8_Main.DeleteLocal(const Backup: TBackup);
var
  Sl: TTntStringList;
  i, Kind: integer;
  Source, DirtySource: WideString;
  Canceler: Tform_Canceler;
begin
  if (Backup.FParked) then    // this shouldn't happen
  begin
    Log(WideFormat(Translator.GetMessage('471'),[Backup.FBackupID], FSLocal), true, false);
    Exit;
  end;

  Sl:= TTntStringList.Create();
  try
    Sl.CommaText:= Backup.FFiles;
    for i:= 0 to Sl.Count - 1 do
    begin
      Source:= FTool.DecodeSD(Sl[i], Kind);
      DirtySource:= FTool.NormalizeFileName(Source);
      if (Kind = INT_SDFILE) then
      begin
        if (FTool.DeleteFileWSpecial(DirtySource)) then
          Log(WideFormat(Translator.GetMessage('271'),[Source],FSLocal), false, false) else
          Log(WideFormat(Translator.GetMessage('428'),[Source],FSLocal), true, false);
      end else
      begin
        DisableTrayMenu();
        Canceler:= Tform_Canceler.Create(nil);
        try
          Canceler.Operation:= INT_OPUILOCALDEL;
          Canceler.Source:= Source;
          Canceler.ShowModal();
        finally
          Canceler.Release();
          EnableTrayMenu();
        end;
      end;
      if (FCancelDelete) then
        Break;
    end;
  finally
    FreeAndNil(Sl);
  end;
end;

procedure Tform_CB8_Main.DeleteTask();
var
  i: integer;
  Checked: boolean;
begin
  if (lv_List.SelCount > 0) then
  begin
    FCancelDelete:= false;
    Checked:= false;
    if MessageDlgSpecial(WS_PROGRAMNAMESHORT, Translator.GetMessage('129'),
                         Translator.GetMessage('130'),
                         Translator.GetMessage('131'),Checked) then
    begin
      for i:= lv_List.Items.Count - 1 downto 0 do
      begin
        if (lv_List.Items[i].Selected) then
          begin
            DeleteATask(lv_List.Items[i].SubItems[0], Checked);
            //Log
            Log(WideFormat(Translator.GetMessage('132'),
                            [lv_List.Items[i].Caption], FSGlobal), false, false);
          end;
        if (FCancelDelete) then
          Break;
      end;

        // First save the new list
        Settings.SaveList();

        // And send the message to the engine to reload the list
        PostEngineMessage(WS_CMDRELOADLIST, WS_NIL, WS_NIL, WS_NIL);

        // now show the list
        DisplayTasks(WS_NIL);
    end;
  end;
end;

procedure Tform_CB8_Main.AddProperty(const Caption, Value: WideString;
  const Icon: integer);
var
  Item: TTntListItem;
begin
  Item:= lv_Properties.Items.Add();
  Item.Caption:= Caption;
  Item.SubItems.Add(Value);
  Item.ImageIndex:= Icon;
end;

procedure Tform_CB8_Main.AddSourcesDestinations(const Value: WideString;
                                            const Kind, Source: integer);
var
  i, AKind, Icon: integer;
  Sl: TTntStringList;
  ASD, ACaption: WideString;
  Address: TFTPAddress;
begin
  if (Kind <> INT_BUDUMMY) then
  begin
    if (Source = INT_SOURCE) then
      ACaption:= Translator.GetMessage('98') else
      ACaption:= Translator.GetMessage('99');
    Sl:= TTntStringList.Create();
    try
      Sl.CommaText:= Value;
      for i:=0 to Sl.Count-1 do
      begin
        ASD:= FTool.DecodeSD(Sl[i], AKind);
        if (AKind = INT_SDFTP) then
        begin
          Address:= TFTPAddress.Create();
          try
            Address.DecodeAddress(ASD);
            // Get a pretty string
            ASD:= Address.EncodeAddressDisplay();
          finally
            FreeAndNil(Address);
          end;
        end;
        case AKind of
          INT_SDDIR: Icon:= INT_INDEXDIRLIST;
          INT_SDFTP: Icon:= INT_INDEXFTPLIST;
          INT_SDMANUAL: Icon:= INT_INDEXMANUALLIST;
        else
          Icon:= INT_INDEXFILELIST;
        end;
        AddProperty(ACaption ,ASD , Icon);
      end;
    finally
      FreeAndNil(Sl);
    end;
  end;
end;

procedure Tform_CB8_Main.ApplyPositions();
begin
  Width:= UISettings.Width;
  Height:= UISettings.Height;
  Top:= UISettings.Top;
  Left:= UISettings.Left;
  panel_Left.Width := UISettings.VSplitter;
  lv_List.ViewStyle:= TViewStyle(UISettings.MainLVView);
  if (lv_List.ViewStyle = vsIcon) or (lv_List.ViewStyle = vsSmallIcon) then
    lv_List.DragMode:= dmManual else
    lv_List.DragMode:= dmAutomatic;
  lv_List.Columns[0].Width:= UISettings.MainLVColumn0;
  lv_List.Columns[1].Width:= UISettings.MainLVColumn1;
  lv_List.Columns[2].Width:= UISettings.MainLVColumn2;
  lv_Properties.Columns[0].Width:= UISettings.PropertyColumn0;
  lv_Properties.Columns[1].Width:= UISettings.PropertyColumn1;
  lv_History.Columns[0].Width:= UISettings.HistoryColumn0;
  lv_History.Columns[1].Width:= UISettings.HistoryColumn1;
  lv_History.Columns[2].Width:= UISettings.HistoryColumn2;
end;

procedure Tform_CB8_Main.ApplyWindowSettings();
begin
  ShowHint:= UISettings.ShowHints;
  Font.Name:= UISettings.FontName;
  Font.Size:= UISettings.FontSize;
  Font.Charset:= UISettings.FontCharset;
  SetHotKey(TCobHotKey(UISettings.HotlKey));
  re_Log.Font.Name:= UISettings.FontNameLog;
  re_Log.Font.Size:= UISettings.FontSizeLog;
  re_Log.Font.Charset:= UISettings.FontCharsetLog;
  re_Log.WordWrap:= UISettings.WordWrap;
  Application.HintColor:= UISettings.HintColor;
  Application.HintHidePause:= UISettings.HintHide;
  pb_Partial.ShowPercent:= UISettings.ShowPercent;
  pb_Partial.ShowPosition:= UISettings.ShowPercent;
  pb_Total.ShowPercent:= UISettings.ShowPercent;
  pb_Total.ShowPosition:= UISettings.ShowPercent;
  lv_List.GridLines:= UISettings.ShowGrid;
  lv_Properties.GridLines:= UISettings.ShowGrid;
  lv_History.GridLines:= UISettings.ShowGrid;
  if (UISettings.ShowIcons) then
    begin
      pc_Main.Images:= il_Tabs;
      lv_List.SmallImages:= img_LVSmall;
      lv_List.LargeImages:= img_LVLarge;
      lv_Properties.SmallImages:= img_LVSmall;
      lv_Properties.LargeImages:= img_LVLarge;
      lv_History.SmallImages:= img_LVSmall;
      lv_History.LargeImages:= img_LVLarge;
    end else
    begin
      pc_Main.Images:= nil;
      lv_List.SmallImages:= nil;
      lv_List.LargeImages:= nil;
      lv_Properties.SmallImages:= nil;
      lv_Properties.LargeImages:= nil;
      lv_History.SmallImages:= nil;
      lv_History.LargeImages:= nil;
    end;
  //Apply the settings for the balloon
  if (form_Balloon <> nil) then
  begin
    form_Balloon.Font.Name:= UISettings.FontName;
    form_Balloon.Font.Size:= UISettings.FontSize;
    form_Balloon.Font.Charset:= UISettings.FontCharset;
  end;
  if (Settings.GetAutoUpdate() <> tim_AutoLU.Enabled) then
    tim_AutoLU.Enabled:= Settings.GetAutoUpdate();
end;

function Tform_CB8_Main.AreBackupParked(): boolean;
var
  i,j: integer;
  Backup: TBackup;
  List: TBackupList;
begin
  Result:= false;
  for i:= 0 to lv_List.Items.Count -1 do
    if (lv_List.Items[i].Selected) then
    begin
      List:= TBackupList.Create();
      try
        List.LoadBackups(lv_List.Items[i].SubItems[0]);
        for j:=0 to lv_History.Items.Count - 1 do
        begin
          if (lv_History.Items[j].Selected) then
          begin
            List.GetBackupPointer(lv_History.Items[j].SubItems[1], Backup);
            if (Backup <> nil) then
              Result:= Backup.FParked;
            if (Result) then
              Break;
          end;
        end;
      finally
        FreeAndNil(List);
      end;
      Break;
    end;
end;

procedure Tform_CB8_Main.ArrangeList();
var
  i: integer;
  Item: TTntListItem;
  ID: WideString;
  Temp: TList;
  Task: TTask;
begin
  Temp := TList.Create();
  try
    for i := 0 to lv_List.Items.Count - 1 do
    begin
      Item := lv_List.Items[i];
      ID := Item.SubItems[0];
      Settings.GetTaskPointer(ID, Task);
      if (Task <> nil) then
        Temp.Add(Task);
    end;
    Settings.ClearListNotFree();
    for i := 0 to Temp.Count - 1 do
      Settings.AddTask(Temp[i]);
    Temp.Clear();

    // Firtst save the new list
    Settings.SaveList();

    // And send the message to the engine to reload the list
    PostEngineMessage(WS_CMDRELOADLIST, WS_NIL, WS_NIL, WS_NIL);

    // now show the list
    //ShowTasks(TaskForm.IID);

  finally
    FreeAndNil(Temp);
  end;
end;

function Tform_CB8_Main.BackupToHuman(const Backup: TBackup): WideString;
var
  Sl: TTntStringList;
begin
  Sl:= TTntStringList.Create();
  try
    Sl.Add(BackupTypeToHuman(Backup.FBackupType));
    Sl.Add(CompressionToHuman(Backup.FCompressed));
    Sl.Add(EncryptionToHuman(Backup.FEncrypted));
    Result:= Sl.CommaText;
  finally
    FreeAndnil(Sl);
  end;
end;

function Tform_CB8_Main.BackupTypeToHuman(const Kind: integer): WideString;
begin
  case Kind of
    INT_BUINCREMENTAL: Result:= Translator.GetMessage('93');
    INT_BUDIFFERENTIAL: Result:= Translator.GetMessage('94');
    INT_BUDUMMY: Result:= Translator.GetMessage('95');
  else
    Result:= Translator.GetMessage('92');
  end;
end;

procedure Tform_CB8_Main.BeginBackup();
begin
  if (not FBackingUp) then
  begin
    FBackingUp:= true;
    ClearProgress();
    pb_Total.ColorScheme:= ccwBrown;
    FIconIndex := 2;
    TrayAnimateBegin();
    if (UISettings.ClearLogTab) then
      re_Log.Clear();
    if (UISettings.ShowBackupHints) then    
      ShowBallon(WideFormat(Translator.GetMessage('157'),
      [WS_PROGRAMNAMESHORT], FSLocal),INT_SHOWWINDOWHINT);
    if (UISettings.AutoShowLog) then
      pc_Main.ActivePage:= tab_Log;
  end;
end;

function Tform_CB8_Main.BoolToHuman(const Bool: boolean): WideString;
begin
  Result:= Translator.GetMessage('S_NO');
  if (Bool) then
    Result:= Translator.GetMessage('S_YES');
end;

procedure Tform_CB8_Main.CalculationDone(Sender: TObject);
var
  TTFiles, TTSize: Int64;
  Str: WideString;
  i,j: integer;
  p: PResult;
begin
  if (Sender is TCalculator) then
  begin
    TTFiles:= (Sender as TCalculator).TotalFiles;
    TTSize:= (Sender as TCalculator).TotalSize;
    Str:= WideFormat(Translator.GetMessage('137'),
        [WS_SPACE + WideExtractFileName(Settings.GetList()),
        TTFiles, CobFormatSizeW(TTSize)], FSLocal);
    status_Left.Caption:= Str;
    FOriginalStatus:= Str;

    // Set the sizes in every task
    for i:=0  to (Sender as TCalculator).Sizes.Count-1 do
    begin
      p:= PResult((Sender as TCalculator).Sizes[i]);
      for j:=0 to lv_List.Items.Count-1 do
        if (lv_List.Items[j].SubItems[0] = p^.ID) then
        begin
          lv_List.Items[j].SubItems[1]:= CobFormatSizeW(p^.Size);
          Break;
        end;
    end;

    DisplayProperties();
  end;
end;

procedure Tform_CB8_Main.ChangeParkingStatus(const Checked:boolean);
var
  i, j: integer;
  List: TBackupList;
  Backup: TBackup;
begin
  for i:=0 to lv_List.Items.Count - 1 do
  begin
    if (lv_List.Items[i].Selected) then
    begin
      List:= TBackupList.Create();
      try
        List.LoadBackups(lv_List.Items[i].SubItems[0]);
        for j:= 0 to lv_History.Items.Count - 1 do
        begin
          if (lv_History.Items[j].Selected) then
          begin
            List.GetBackupPointer(lv_History.Items[j].SubItems[1], Backup);
            if (Backup <> nil) then
            begin
              Backup.FParked:= not Checked;
              Log(WideFormat(Translator.GetMessage('468'),
                          [lv_History.Items[j].SubItems[1]], FSLocal), false, false);
            end;
          end;
        end;
        List.SaveBackups(lv_List.Items[i].SubItems[0]);
      finally
        FreeAndNil(List);
      end;
      Break;
    end;
  end;

  DisplayHistory();
end;

function Tform_CB8_Main.CheckInstance(): boolean;
var
  MN: WideString;
begin
  //Only one instance of the UI is allowed per desktop

  MN := WideFormat(WS_UIMUTEX, [WS_PROGRAMNAMELONG], FSGlobal);

  FOneInstance := CreateMutexW(@Globals.Sec, false, PWideChar(MN));

  if FOneInstance = 0 then //failed to create mutex
    Result := true
  else
    Result := (GetLastError = ERROR_ALREADY_EXISTS); //if exists TRUE
end;


procedure Tform_CB8_Main.CheckOldBackups();
begin
  if (Settings.GetRunOldBackups()) then
    NeedToAutoBackup();
end;

function Tform_CB8_Main.CheckPassword(): boolean;
begin
  Result:= true;

  //Check if the dialog box for the password
  //must be displayed

  if (Settings.GetProtectUI() = false) or (Settings.GetPassword() = WS_NIL) then
    Exit;

  if (MinutesBetween(Now(), FLastTimeQuered) <= INT_PASSWORDCACHE) then
    Exit;

  DisableTrayMenu();

  form_Password:= Tform_InputBox.Create(nil);
  try
    form_Password.e_Input.PasswordChar:= WS_PASSWORDCHAR;
    form_Password.Caption:= WS_PROGRAMNAMESHORT;
    form_Password.l_Prompt.Caption:= Translator.GetInterfaceText('3');

    form_Password.ShowModal();

    // Assume the password is wrong
    Result:= false;

    if (form_Password.Tag = INT_MODALRESULTOK) then
      if (form_Password.e_Input.Text = Settings.GetPassword()) then
        begin
          FLastTimeQuered:= Now();
          Result:= true;
        end else
        CobShowMessageW(Handle,Translator.GetMessage('13'),WS_PROGRAMNAMESHORT);
  finally
    form_Password.Release();
    form_Password:= nil;
    EnableTrayMenu();
  end;
end;

procedure Tform_CB8_Main.CheckUpdates(const UI: boolean);
var
  UThread: TUpdater;
begin
  if (BOOL_CUSTOMIZED) then
    Exit;

  pc_Main.ActivePage:= tab_Log;
  Log(Translator.GetMessage('503'), false, false);
  UThread:= TUpdater.Create(UI);
  UThread.FreeOnTerminate:= true;
  UThread.OnTerminate:= OnUpdateDone;
  UThread.Resume();
end;

procedure Tform_CB8_Main.ClearProgress();
var
  Item: TTntListItem;
begin
  pb_Partial.Position:= 0;
  pb_Total.Position:= 0;
  pb_Partial.ColorScheme:= ccwSilver;
  pb_Total.ColorScheme:= ccwSilver;
  // Because no other info will be displayed, display the original
  // status back
  status_Left.Caption:= FOriginalStatus;
  // Unmark the current task
  if (FOldName <> WS_NIL) then
  begin
    GetItem(FOldName, Item);
    if (Item <> nil) then
      Item.ImageIndex:= FOldImageIndex;
    FOldImageIndex:= INT_INDEXNOICON;
    FOldName:= WS_NIL;
    FCurrentTaskName:= WS_NIL;
  end;
end;

procedure Tform_CB8_Main.CloneTasks();
var
  i: integer;
begin
  if (lv_List.SelCount = 0) then
    Exit;

  if (CobMessageBoxW(self.Handle, Translator.GetMessage('455'), WS_PROGRAMNAMESHORT, MB_YESNO) = mrNo) then
    Exit;

  for i:=0 to lv_List.Items.Count - 1 do
    if (lv_List.Items[i].Selected) then
        Settings.CloneTask(lv_List.Items[i].SubItems[0], Translator.GetMessage('456'));

  // First save the new list
  Settings.SaveList();

  // And send the message to the engine to reload the list
  PostEngineMessage(WS_CMDRELOADLIST, WS_NIL, WS_NIL, WS_NIL);

  // now show the list
  DisplayTasks(WS_NIL);
end;

procedure Tform_CB8_Main.CloseAWindow(const ACaption: WideString; Kill: boolean);
var
  Result: cardinal;
  Error: WideString;
begin
  Result:= FTool.CloseAWindowW(ACaption,Kill);
  if (Result = INT_CW_CLOSED) then
    Log(WideFormat(Translator.GetMessage('200'),[ACaption],FSGlobal),false,false) else
    begin
      if (Result = INT_CW_NOFOUND) then
        Error:= Translator.GetMessage('202') else
        Error:= Translator.GetMessage('203');
      Log(WideFormat(Translator.GetMessage('201'),[ACaption, Error],FSGlobal),true,false);
    end;
end;

procedure Tform_CB8_Main.CloseEngine();
var
  ClassName: WideString;
  AHandle: HWnd;
begin
  // If I don't check this the engine get closed after a second
  // instance is closed
  if (not IsService) then
    if (Tag = INT_MODALRESULTOK) then
    begin
      ClassName:= WideFormat(WS_SERVERCLASSNAME,[WS_PROGRAMNAMELONG],FSGlobal);
      AHandle:= FindWindowW(PWideChar(ClassName),nil);
      if (AHandle <> 0) then
        PostMessageW(AHandle, WM_CLOSE ,0,0);
    end;
end;

procedure Tform_CB8_Main.CloseInterface();
begin
  Close();
end;

function Tform_CB8_Main.CompressionToHuman(const Value: integer): WideString;
begin
  case Value of
    INT_COMPZIP: Result:= Translator.GetInterfaceText('148');
    INT_COMP7ZIP: Result:= Translator.GetInterfaceText('149');
    else
    Result:= Translator.GetInterfaceText('147');
  end;
end;

procedure Tform_CB8_Main.CreateHintScreen();
begin
  form_Balloon:= Tform_Balloon.Create(nil);
end;

procedure Tform_CB8_Main.CreateInfoReader();
begin
  if (FPipes) then
  begin
    FInfoReaderPipes:= TInfoReaderPipe.Create(@Globals.Sec);
    FInfoReaderPipes.FreeOnTerminate:= false;
    FInfoReaderPipes.Resume();
  end else
  begin
    FInfoReader:= TInfoReader.Create(@Globals.Sec);
    FInfoReader.FreeOnTerminate:= false;
    FInfoReader.Resume();
  end;
end;

procedure Tform_CB8_Main.CreateLogReader();
begin
  // Creates the thread that received the log file lines
  // from the engine
  FLogReaderThread:= TLogReader.Create(FPipes, @Globals.Sec);
  FLogReaderThread.FreeOnTerminate:= false;
  FLogReaderThread.Resume();
end;

procedure Tform_CB8_Main.CreateMaster();
begin
  /// Creates the MMF that sends the commands to the engine
  IPCMasterCS:= TCriticalSection.Create();
  CommandList:= TTntStringList.Create();
  FEncoder:= TTntStringList.Create();
  if (FPipes) then
  begin
    FMasterPipes:= TIPCMasterPipe.Create(@Globals.Sec);
    FMasterPipes.FreeOnTerminate:= false;
    FMasterPipes.Resume();
  end else
  begin
    FMaster:= TIPCMaster.Create(Globals.AppPath, @Globals.Sec);
    FMaster.FreeOnTerminate:= false;
    FMaster.Resume();
  end;
end;

procedure Tform_CB8_Main.CreateTray();
begin
  with FSysTrayIcon do
  begin
    cbSize := sizeof(TNotifyIconData);
    Wnd := Self.Handle;
    uID := 0;
    uFlags := NIF_MESSAGE or NIF_ICON or NIF_TIP;
    uCallbackMessage := WM_SYSTRAYICON;
    imgs_Tray.GetIcon(1, FIcon);
    hIcon := FIcon.Handle;
    SetApplicationHint(INT_OPIDLE, INT_NIL, INT_NIL, WS_NIL);
      //szTip := CS_PROGRAMNAME;
  end;
  Shell_NotifyIconW(NIM_ADD, @FSysTrayIcon);

  // register a message to handle taskbar re-creation
  WM_TASKBAR_CREATED := RegisterWindowMessageW(WS_RECREATETRAYMSG);
end;

procedure Tform_CB8_Main.CreateUIMutex();
var
  MN: WideString;
begin
  /// This mutex is created to alert the precense of the UI for
  ///  the engine.

  if (CobIs2000orBetterW()) then
    MN:= WideFormat(WS_UIMUTEXFLAG,[WS_PROGRAMNAMELONG],FSGlobal) else
    MN:= WideFormat(WS_UIMUTEXFLAGOLD,[WS_PROGRAMNAMELONG],FSGlobal);

  FUIMutex:= CreateMutexW(@Globals.Sec, false, PWideChar(MN));
end;

procedure Tform_CB8_Main.CreateUISettings();
begin
  UISettings:= TUISettings.Create(@Globals.Sec,
                                  Screen.Width, Screen.Height,
                                  Globals.AppPath,
                                  Globals.SettingsPath);
  UISettings.LoadSettings();
  UISettings.LoadPositions();
  ApplyWindowSettings();
  ApplyPositions();
end;

procedure Tform_CB8_Main.DestroyHintScreen();
begin
  form_Balloon.Release();
  form_Balloon:= nil;
end;

procedure Tform_CB8_Main.DestroyInfoReader();
begin
  if (FPipes) then
  begin
    if (FInfoReaderPipes <> nil) then
    begin
      FInfoReaderPipes.Terminate();
      FInfoReaderPipes.WaitFor();
      FreeAndNil(FInfoReaderPipes);
    end;
  end else
  begin
    if (FInfoReader <> nil) then
    begin
      FInfoReader.Terminate();
      FInfoReader.WaitFor();
      FreeAndNil(FInfoReader);
    end;
  end;
end;

procedure Tform_CB8_Main.DestroyInstanceMutex();
begin
  if (FOneInstance <> 0) then
  begin
    CloseHandle(FOneInstance);
    FOneInstance:= 0;
  end;
end;

procedure Tform_CB8_Main.DestroyLogReader;
begin
  if (FLogReaderThread <> nil) then
    begin
      FLogReaderThread.Terminate();
      FLogReaderThread.WaitFor();
      FreeAndNil(FLogReaderThread);
      FLogReaderThread:= nil;
    end;
end;

procedure Tform_CB8_Main.DestroyMaster();
begin
  if (FPipes) then
  begin
    FMasterPipes.Terminate();
    FMasterPipes.WaitFor();
    FreeAndNil(FMasterPipes);
  end else
  begin
    FMaster.Terminate();
    FMaster.WaitFor();
    FreeAndNil(FMaster);
  end;
  FreeAndNil(FEncoder);
  FreeAndNil(CommandList);
  FreeAndNil(IPCMasterCS);
end;

procedure Tform_CB8_Main.DestroyTray();
begin
  Shell_NotifyIconW(NIM_DELETE, @FSysTrayIcon);
end;

procedure Tform_CB8_Main.DestroyUIMutex;
begin
  if (FUIMutex <> 0) then
  begin
    CloseHandle(FUIMutex);
    FUIMutex:= 0;
  end;
end;

procedure Tform_CB8_Main.DestroyUISettings;
begin
  if (UISettings <> nil) then
    FreeAndNil(UISettings);
end;

procedure Tform_CB8_Main.DisableTrayMenu();
begin
  m_Exit.Enabled:= false;
  m_pop_About.Enabled:= false;
  m_Pop_RunAll.Enabled:= false;
  m_pop_Open.Enabled:= false;
end;

procedure Tform_CB8_Main.DisplayHistory();
var
  Item: TTntListItem;
begin
  lv_History.Clear();

  if (lv_List.SelCount <> 1) then
  begin
    Item:= lv_History.Items.Add();
    Item.Caption:= Translator.GetMessage('83');
    Item.SubItems.Add(CobIntToStrW(lv_List.SelCount));
    Item.SubItems.Add(WS_NIL);
    Item.ImageIndex:= INT_INDEXNOLOADED;
  end else
  DisplayHistoryItem(lv_List.Selected.SubItems[0]);
end;

procedure Tform_CB8_Main.DisplayHistoryItem(const ID: WideString);
var
  i, Count: integer;
  Backup: TBackup;
  Item: TTntListItem;
  BackupList: TBackupList;
begin
  BackupList:= TBackupList.Create();
  try
    BackupList.LoadBackups(ID);
    Count:= BackupList.GetCount();
    for i:= 0 to  Count - 1 do
    begin
      BackupList.GetBackupPointerIndex(i, Backup);
      if (Backup <> nil) then
      begin
        Item:= lv_History.Items.Add();
        Item.Caption:= BackupToHuman(Backup);
        Item.SubItems.Add(DateTimeToStr(Backup.FDateTime, FSLocal));
        Item.SubItems.Add(Backup.FBackupID);
        if (Backup.FParked) then
          Item.ImageIndex:= INT_INDEXPARKED else
        if (Backup.FBackupType = INT_BUFULL) then
          Item.ImageIndex := INT_INDEXBUFULL else
          Item.ImageIndex:= INT_INDEXBUINCDIF;
      end;
    end;
  finally
    FreeAndNil(BackupList);
  end;
end;

procedure Tform_CB8_Main.DisplayProperties();
var
  Item: TTntListItem;
begin
  lv_Properties.Clear();

  if (lv_List.SelCount <> 1) then
  begin
    Item:= lv_Properties.Items.Add();
    Item.Caption:= Translator.GetMessage('83');
    Item.SubItems.Add(CobIntToStrW(lv_List.SelCount));
    Item.ImageIndex:= INT_INDEXNOLOADED;
  end else
  DisplayTask(lv_List.Selected.SubItems[0],lv_List.Selected.SubItems[1]);
end;

procedure Tform_CB8_Main.DisplaySelectedTask();
begin
  /// Show the task that is selected in the list
  ///  If no task is selected , just clear the controls
  ///  If several tasks are selected, display a message:
  ///  X tasks selected

  DisplayProperties();
  DisplayHistory();  
end;

procedure Tform_CB8_Main.DisplayStatus(const IName, FileName: WideString;
  const Operation, Partial, Total: integer);
var
  Op: WideString;
  Item: TTntListItem;
begin
  pb_Partial.Position:= Partial;
  pb_Total.Position:= Total;

  case Operation of
    INT_OPCOPY:
      begin
        Op:= Translator.GetMessage('162');
        pb_Partial.ColorScheme:= ccwGreen;
      end;
    INT_OPCOMPRESS:
      begin
        Op:= Translator.GetMessage('163');
        pb_Partial.ColorScheme:= ccwBlue;
      end;
    INT_OPENCRYPT:
      begin
        Op:= Translator.GetMessage('164');
        pb_Partial.ColorScheme:= ccwViolet;
      end;
    INT_OPFTPUP:
      begin
        Op:= Translator.GetMessage('165');
        pb_Partial.ColorScheme:= ccwRed;
      end;
    INT_OPFTPDOWN:
      begin
        Op:= Translator.GetMessage('166');
        pb_Partial.ColorScheme:= ccwOrange;
      end;
    INT_OPCRC:
      begin
        Op:= Translator.GetMessage('168');
        pb_Partial.ColorScheme:= ccwYellow;
      end;
    INT_OPDELETING:
      begin
        Op:= Translator.GetMessage('169');
        pb_Partial.ColorScheme:= ccwPink;
      end;
    else
    begin
      Op:= Translator.GetMessage('167');
      pb_Partial.ColorScheme:= ccwBlack;
    end;
  end;

  // Mark the item in the list that is backing up
  if (FOldName <> IName) then
  begin
    if (FOldName <> WS_NIL) then
    begin        // Set the old icon
      GetItem(FOldName, Item);
      if (Item <> nil) then
        Item.ImageIndex:= FOldImageIndex;
    end;

    // Get the new icon
    GetItem(IName, Item);
    if (Item <> nil) then
    begin
      FOldImageIndex:= Item.ImageIndex;
      FOldName:= IName;
      Item.ImageIndex:= INT_INDEXCURRENT;
    end;
  end;

  SetApplicationHint(Operation, Partial, Total, FCurrentTaskName);
  status_Left.Caption:= WideFormat(WS_DISPLAY,[Op,WideExtractFileName(FileName)],FSLocal);

  Application.ProcessMessages();
end;

procedure Tform_CB8_Main.DisplayTask(const TaskID, Size: WideString);
var
  Task: TTask;
  Icon: integer;
begin
  Task:= TTask.Create();
  try
    Settings.CopyTask(TaskID,Task);
    if (Task <> nil) then
    begin
      AddProperty(Translator.GetMessage('84'),Task.Name,INT_INDEXOK);
      AddProperty(Translator.GetMessage('85'),Task.ID,INT_INDEXOK);
      if (Task.Disabled) then
        Icon:= INT_INDEXWARNING else
        Icon:= INT_INDEXOK;
      AddProperty(Translator.GetMessage('86'),BoolToHuman(Task.Disabled),Icon);
      AddProperty(Translator.GetMessage('91'),BackupTypeToHuman(Task.BackupType),
                  INT_INDEXOK);

      AddSourcesDestinations(Task.Source, Task.BackupType, INT_SOURCE);

      AddProperty(Translator.GetMessage('135'), Size ,
                  INT_INDEXOK);

      AddSourcesDestinations(Task.Destination, Task.BackupType, INT_DESTINATION);

      AddProperty(Translator.GetMessage('87'),
                  BoolToHuman(Task.IncludeSubdirectories),INT_INDEXOK);

      AddProperty(Translator.GetMessage('88'),
                  BoolToHuman(Task.SeparateBackups),INT_INDEXOK);

      AddProperty(Translator.GetMessage('89'),
                  BoolToHuman(Task.UseAttributes),INT_INDEXOK);

      AddProperty(Translator.GetMessage('90'),
                  BoolToHuman(Task.ResetAttributes),INT_INDEXOK);

      if (Task.SeparateBackups) then
         AddProperty(Translator.GetMessage('96'),
                  CobIntToStrW(Task.FullCopiesToKeep),INT_INDEXOK);

      if (Task.BackupType = INT_BUINCREMENTAL) or
        (Task.BackupType = INT_BUDIFFERENTIAL) then
        AddProperty(Translator.GetMessage('97'),
                  CobIntToStrW(Task.MakeFullBackup),INT_INDEXOK);

      AddProperty(Translator.GetMessage('100'),
                  ScheduleTypeToHuman(Task.ScheduleType),INT_INDEXOK);

      if (Task.ScheduleType = INT_SCONCE) then
        AddProperty(Translator.GetMessage('108'),
                  DateToStr(Task.DateTime, FSLocal) ,INT_INDEXOK);

      if (Task.ScheduleType <> INT_SCTIMER) or (Task.ScheduleType <> INT_SCMANUALLY) then
        AddProperty(Translator.GetMessage('109'),
                  TimeToStr(Task.DateTime, FSLocal) ,INT_INDEXOK);

      if (Task.ScheduleType = INT_SCWEEKLY) then
        AddProperty(Translator.GetMessage('110'),
                  DaysOfWeekToHuman(Task.DayWeek) ,INT_INDEXOK);

      if (Task.ScheduleType = INT_SCMONTHLY) or (Task.ScheduleType = INT_SCYEARLY) then
        AddProperty(Translator.GetMessage('111'),
                  Task.DayMonth ,INT_INDEXOK);

      if (Task.ScheduleType = INT_SCYEARLY) then
        AddProperty(Translator.GetMessage('112'),
                  MonthToHuman(Task.Month) ,INT_INDEXOK);


      if (Task.ScheduleType = INT_SCTIMER) then
        AddProperty(Translator.GetMessage('113'),
                  CobIntToStrW(Task.Timer) ,INT_INDEXOK);

      AddProperty(Translator.GetMessage('114'),
               CompressionToHuman(Task.Compress) ,INT_INDEXOK);


      if (Task.Compress <> INT_COMPNOCOMP) then
      begin
        AddProperty(Translator.GetMessage('115'),
                  BoolToHuman(Task.ArchiveProtect) ,INT_INDEXOK);

        AddProperty(Translator.GetMessage('116'),
                  SplitToHuman(Task.Split) ,INT_INDEXOK);

        if (Task.Split = INT_SPLITCUSTOM) then
          AddProperty(Translator.GetMessage('117'),
                CobIntToStrW(Task.SplitCustom) ,INT_INDEXOK);

        AddProperty(Translator.GetMessage('118'),
                  Task.ArchiveComment ,INT_INDEXOK);
      end;

      AddProperty(Translator.GetMessage('119'),
                  EncryptionToHuman(Task.Encryption) ,INT_INDEXOK);

      if (Task.Encryption = INT_ENCRSA) then
        AddProperty(Translator.GetMessage('120'),
                  Task.PublicKey ,INT_INDEXOK);

      AddProperty(Translator.GetMessage('121'),
                  Task.IncludeMasks ,INT_INDEXOK);

      AddProperty(Translator.GetMessage('122'),
                  Task.ExcludeItems ,INT_INDEXOK);

      AddProperty(Translator.GetMessage('123'),
                  Task.BeforeEvents ,INT_INDEXOK);

      AddProperty(Translator.GetMessage('124'),
                  Task.AfterEvents ,INT_INDEXOK);

      AddProperty(Translator.GetMessage('125'),
                  BoolToHuman(Task.Impersonate) ,INT_INDEXOK);

      if (Task.Impersonate) then
      begin
        AddProperty(Translator.GetMessage('126'),
                  BoolToHuman(Task.ImpersonateCancel) ,INT_INDEXOK);

        AddProperty(Translator.GetMessage('127'),
                  Task.ImpersonateID ,INT_INDEXOK);

        AddProperty(Translator.GetMessage('128'),
                  Task.ImpersonateDomain ,INT_INDEXOK);
      end;

    end;
  finally
    FreeAndNil(Task);
  end;
end;

procedure Tform_CB8_Main.DisplayTasks(const Selected: WideString);
var
  i: integer;
  Item: TTntListItem;
  Task: TTask;
  Calculator: TCalculator;
begin
  lv_List.Clear();
  lv_Properties.Clear();
  lv_History.Clear();
  status_Left.Caption:= WS_SPACE + WideExtractFileName(Settings.GetList());
  // This is a buffer that will store the caption of the panel
  // because this pannel will display some other info when
  //backing up. Then' the info can be retrieved back from here
  FOriginalStatus:= status_Left.Caption;
  with Settings.TaskList.LockList() do
  try
    for i:= 0 to Count - 1 do
    begin
      Task:= Items[i];
      if (Task <> nil) then
      begin
        Item:= lv_List.Items.Add();
        Item.Caption:= Task.Name;
        Item.SubItems.Add(Task.ID);
        if (UISettings.CalculateSize) then
          Item.SubItems.Add(Translator.GetMessage('134')) else // The size of the sources will be added here later
          Item.SubItems.Add(Translator.GetMessage('136'));     // with a new thread
        if (Task.Disabled) then
          Item.ImageIndex:= INT_INDEXDISABLED else
          Item.ImageIndex:= INT_INDEXENABLED;

        if (Selected <> WS_NIL) then
          if (Selected = Task.ID) then
          begin
            Item.Selected:= true;
            lv_List.ItemIndex:= i;
          end;
      end;
    end;
  finally
    Settings.TaskList.UnlockList();
  end;

  DisplaySelectedTask();

  if (UISettings.CalculateSize) then
  begin
    Calculator:= TCalculator.Create();
    Calculator.FreeOnTerminate:= true;
    Calculator.Priority:= tpLowest;
    Calculator.OnTerminate:= CalculationDone;
    Calculator.Resume();
  end;
end;

procedure Tform_CB8_Main.DoCancelDelete(var Msg: TMessage);
begin
  FCancelDelete:= true;
end;

procedure Tform_CB8_Main.EditTask();
var
  i: integer;
begin
  if (lv_List.SelCount > 0) then
  begin
    for i:= 0 to lv_List.Items.Count - 1 do
      if (lv_List.Items[i].Selected) then
      begin
        ModifyTask(lv_List.Items[i].SubItems[0], WS_NIL);
        Break;
      end;
  end;
end;

procedure Tform_CB8_Main.EnableTrayMenu();
begin
  m_Exit.Enabled:= true;
  m_pop_About.Enabled:= true;
  m_Pop_RunAll.Enabled:= true;
  m_pop_Open.Enabled:= true;
end;

function Tform_CB8_Main.EncryptionToHuman(const Value: integer): WideString;
begin
  case Value of
    INT_ENCRSA: Result:= Translator.GetInterfaceText('172');
    INT_ENCRIJNDAEL128: Result:= Translator.GetInterfaceText('174');
    INT_ENCBLOWFISH128: Result:= Translator.GetInterfaceText('175');
    INT_ENCDES64: Result:= Translator.GetInterfaceText('176');
    else
    Result:= Translator.GetInterfaceText('171');
  end;
end;

procedure Tform_CB8_Main.EndBackup();
var
  Error: cardinal;
begin
  if FBackingUp then
  begin
    FBackingUp := false;
    ClearProgress();
    TrayAnimateEnd();

    if (UISettings.ShowBackupHints) then
      ShowBallon(WideFormat(Translator.GetMessage('158'),
      [WS_PROGRAMNAMESHORT], FSLocal),INT_SHOWWINDOWHINT);

    if (UISettings.PlaySound) then
      if (WideFileExists(UISettings.FileToPlay)) then
        PlaySoundW(PWideChar(UISettings.FileToPlay), 0, SND_ASYNC or SND_FILENAME) else
        MessageBeep(MB_OK);

    DisplayHistory();

    if FShutDown then
    begin
      Error := FTool.RestartShutdownW(false, Settings.GetShutdownKill());
      if Error = 0 then
        Log(Translator.GetMessage('498'), false, false)
      else
        Log(WideFormat(Translator.GetMessage('499'),
                    [CobSysErrorMessageW(Error)], FSLocal), true, false);
    end;

    FShutDown := false;

    if (UISettings.ShowDialogEnd) then
      CobShowMessageW(handle,Translator.GetMessage('159'), WS_PROGRAMNAMESHORT);
  end;
end;

procedure Tform_CB8_Main.ExecuteFile(const FileName, Param: WideString);
var
  Result: cardinal;
begin
  Result:= FTool.ExecuteW(FileName,Param);
  if (Result > 32) then
    Log(WideFormat(Translator.GetMessage('180'),[FileName],FSGlobal),false,false) else
    Log(WideFormat(Translator.GetMessage('181'),[FileName,
                                    Translator.GetShellError(Result)],FSGlobal),true,false);
end;

procedure Tform_CB8_Main.ExecuteFileAndWait(const FileName, Param: WideString);
var
  Result: cardinal;
begin
  Result:= FTool.ExecuteAndWaitW(FileName,Param);
  if Result = 0 then
    Log(WideFormat(Translator.GetMessage('183'),[FileName],FSGlobal),false,false) else
    Log(WideFormat(Translator.GetMessage('184'),[FileName,
                                    CobSysErrorMessageW(Result)],FSGlobal),true,false);
  PostEngineMessage(WS_CMDUIRESPONSE, CobIntToStrW(Result), WS_NIL, WS_NIL);
end;

procedure Tform_CB8_Main.OnApplicationMessage(var Msg: TMsg; var Handled: Boolean);
begin
  if (Msg.message = WM_HOTKEY) then
  begin                                                                            
    ShowMainWindow();
    inherited;
    Exit;
  end
  else Handled := false;

  // The webbrowser does not accept the Enter key
  // in web forms
  if (FBrowser <> nil) then
    if (not Handled) then
    begin
      Handled:=(IsDialogMessageW(FBrowser.Handle, Msg) = True);
      if (Handled) and (not FBrowser.Busy) then
      begin
        if FOleInPlaceActiveObject = nil then
        begin
          Dispatch := FBrowser.Application;
          if Dispatch <> nil then
          begin
            Dispatch.QueryInterface(IOleInPlaceActiveObject, iOIPAO);
            if iOIPAO <> nil then
              FOleInPlaceActiveObject := iOIPAO;
          end;
        end;

        if FOleInPlaceActiveObject <> nil then
          if ((Msg.message = WM_KEYDOWN) or (Msg.message = WM_KEYUP)) and
         ((Msg.wParam = VK_BACK) or (Msg.wParam = VK_LEFT) or (Msg.wParam = VK_RIGHT)) then
        //nothing - do not pass on Left or Right arrows
        else
          FOleInPlaceActiveObject.TranslateAccelerator(Msg);
      end;
    end;
end;

procedure Tform_CB8_Main.OnConnect();
begin
  // This is fired when the engine is found
  if (not FConnected) then
  begin
    TrayActive();
    FConnected:= true;
    FAnimated := false;

    Log(Translator.GetMessage('155'), false, false);
  end;
end;

procedure Tform_CB8_Main.OnDisconnect();
begin
  //If the engine is not found, set the proper icon
  //And add a log  entry

  if FConnected then
  begin
    TrayInactive();
    FConnected := false;
    FAnimated := false;
    FBackingUp := false;
    Log(Translator.GetMessage('156'), true, false);
    ClearProgress();
  end;
end;

procedure Tform_CB8_Main.OnDocumetComplete(Sender: TObject; const pDisp: IDispatch;
  var URL: OleVariant);
begin
  try
    sb_Help.SimpleText:=WideString(FBrowser.OleObject.Document.Title);
  except
    sb_Help.SimpleText:= WS_NIL;
  end;
end;

procedure Tform_CB8_Main.OnException(Sender: TObject; E: Exception);
begin
  Log(WideFormat(Translator.GetMessage('488'),[WideString(E.Message)],FSLocal), true, false);
  pc_Main.ActivePage:= tab_Log;
end;

procedure Tform_CB8_Main.OnForcedTerminated(Sender: TObject);
begin
  if (Sender is TBackupForcer) then
    with (Sender as TBackupForcer) do
    begin
      if (MissedTasks <> WS_NIL) then
      begin
        if (not Settings.GetRunOldDontAsk()) then
          if (CobMessageBoxW(self.Handle, Translator.GetMessage('507'),WS_PROGRAMNAMESHORT, MB_YESNO) = mrNo) then
             Exit;
        Log(Translator.GetMessage('510'), false, false);
        PostEngineMessage(WS_CMDBACKUPSELECTED, MissedTasks, WS_NIL,WS_NIL);
      end;
    end;
end;

procedure Tform_CB8_Main.OnSysTrayIcon(var rMsg: TMessage);
var
  rCursor: TPoint;
begin
  //Handle the tray icon menu, etc

  case rMsg.lParam of
    WM_RBUTTONDOWN:
      if GetCursorPos(rCursor) then
      begin
        // pop-up menu
        SetForegroundWindow(Application.Handle);
        Application.ProcessMessages();
        pop_Tray.Popup(rCursor.X, rCursor.Y);
      end;
    WM_LBUTTONDBLCLK:
      begin
        ShowMainWindow();
      end;
  end; //case
end;

procedure Tform_CB8_Main.OnUpdateDone(Sender: TObject);
begin
  if (Sender is TUpdater) then
    with (Sender as TUpdater) do
    begin
      if (Error) then
        Log(WideFormat(Translator.GetMessage('504'),[ErrorStr], FSLocal), true, false) else
        begin
          if (NewVersionAvailable) then
          begin
            PostEngineMessage(WS_CMDLUNEWVERSIONWARNING, Info, WS_NIL, WS_NIL);
            if (not FConnected) then
            begin
              Log(Translator.GetMessage('9'),true,false);
              LogCleanInfo(Info);
              if (FromUI) then
                if (CobMessageBoxW(self.Handle, Translator.GetMessage('505'), WS_PROGRAMNAMESHORT, MB_YESNO) = mrYes) then
                    ShowHelp(WS_PROGRAMWEB, UISettings.NavigateInternally, false);
            end;
          end else
          begin
            PostEngineMessage(WS_CMDLUNONEWVERSION, WS_NIL, WS_NIL, WS_NIL);
            if (not FConnected) then
              Log(Translator.GetMessage('8'),false, false);
          end;
          SetLastUpdate();
        end;
    end;
end;

procedure Tform_CB8_Main.pop_HistoryPopup(Sender: TObject);
begin
  m_Pop_HProperties.Enabled:= (lv_List.SelCount = 1) and (lv_History.SelCount > 0);
  m_Pop_HDelete.Enabled := (lv_List.SelCount = 1) and (lv_History.SelCount > 0);
  m_Pop_HPark.Enabled:= (lv_List.SelCount = 1) and (lv_History.SelCount > 0);
  if (m_Pop_HPark.Enabled) then
    m_Pop_HPark.Checked:= AreBackupParked();
end;

procedure Tform_CB8_Main.pop_LogPopup(Sender: TObject);
begin
  m_Pop_Copy.Enabled:= re_Log.SelLength > 0;
  m_Pop_Wrap.Checked:= re_Log.WordWrap;
end;

procedure Tform_CB8_Main.pop_MainPopup(Sender: TObject);
begin
  case lv_List.ViewStyle of
    vsIcon: m_StyleIcon.Checked:= true;
    vsSmallIcon: m_StyleSmallIcons.Checked:= true;
    vsList: m_StyleList.Checked:= true;
    vsReport: m_StyleReport.Checked:= true;
  end;
  m_Pop_Edit.Enabled:= lv_List.SelCount > 0;
  m_Pop_Disable.Enabled:= lv_List.SelCount > 0;
  m_Pop_Reset.Enabled:= lv_List.SelCount > 0;
  m_Pop_RunSelected.Enabled:= (lv_List.SelCount > 0) and not FBackingUp;
  m_Pop_Clone.Enabled:= lv_List.SelCount > 0;
  m_Pop_Delete.Enabled:= lv_List.SelCount > 0;
  m_Pop_New.Enabled:= lv_List.SelCount = 0;
end;

procedure Tform_CB8_Main.m_Task_AbortClick(Sender: TObject);
begin
  if not CheckPassword() then
    Exit;

  if (not FBackingUp) then
  begin
    CobShowMessageW(self.Handle, Translator.GetMessage('451'),WS_PROGRAMNAMESHORT);
    Exit;
  end;

  if (UISettings.ConfirmAbort) then
    if (CobMessageBoxW(self.Handle, Translator.GetMessage('454'),WS_PROGRAMNAMESHORT, MB_YESNO) = mrNo) then
      Exit;

  // 2006-11-16 by Luis Cobian
  // if the shutdown flag is set, just reset it

  FShutDown:= false;

  PostEngineMessage(WS_CMDABORT, WS_NIL, WS_NIL, WS_NIL);
end;

procedure Tform_CB8_Main.m_Task_AttributesClick(Sender: TObject);
begin
  if not CheckPassword() then
    Exit;

  ResetAttributes();
end;

procedure Tform_CB8_Main.m_Task_CloneClick(Sender: TObject);
begin
  if not CheckPassword() then
    Exit;

  CloneTasks();
end;

procedure Tform_CB8_Main.m_HelpClick(Sender: TObject);
begin
  m_Help_Support.Visible:= not BOOL_CUSTOMIZED;
  m_Help_Donate.Visible:= not BOOL_CUSTOMIZED;
end;

procedure Tform_CB8_Main.m_Help_AboutClick(Sender: TObject);
begin
  if (form_About = nil) then
  begin
    DisableTrayMenu();
    form_About:= Tform_About.Create(nil);
    try
      // do not apply the font settings to this window
      form_About.ShowModal();
    finally
      form_About.Release();
      form_About:= nil;
      EnableTrayMenu();
    end;
  end;
end;

procedure Tform_CB8_Main.m_Help_DonateClick(Sender: TObject);
begin
  ShowHelp(Globals.HelpPath + WS_SITEPAYPAL, UISettings.ForceInternalHelp, true);
end;

procedure Tform_CB8_Main.m_Help_IndexClick(Sender: TObject);
begin
  ShowHelp(Globals.HelpPath + WS_SITEINDEX, UISettings.ForceInternalHelp, true);
end;

procedure Tform_CB8_Main.m_Help_SupportClick(Sender: TObject);
begin
  ShowHelp(WS_SUPPORTFORUM, UISettings.NavigateInternally, false);
end;

procedure Tform_CB8_Main.m_Help_TutorialClick(Sender: TObject);
begin
  ShowHelp(Globals.TutorialPath + WS_SITETUTORIAL, UISettings.ForceInternalHelp, true);
end;

procedure Tform_CB8_Main.m_Help_WebClick(Sender: TObject);
begin
  ShowHelp(WS_PROGRAMWEB, UISettings.NavigateInternally, false);
end;

procedure Tform_CB8_Main.m_HistoryClick(Sender: TObject);
begin
  m_History_Delete.Enabled:= (lv_List.SelCount = 1) and (lv_History.SelCount > 0);
  m_History_Properties.Enabled:= (lv_List.SelCount = 1) and (lv_History.SelCount > 0);
  m_History_Park.Enabled:= (lv_List.SelCount = 1) and (lv_History.SelCount > 0);
  if (m_History_Park.Enabled) then
    m_History_Park.Checked:= AreBackupParked();
end;

procedure Tform_CB8_Main.m_History_DeleteClick(Sender: TObject);
var
  Checked: boolean;
begin
  if (not CheckPassword()) then
    Exit;

  if (lv_List.SelCount <> 1) then
    Exit;

  if (lv_History.SelCount = 0) then
    Exit;

  Checked:= false;
  FCancelDelete:= false;

  if (MessageDlgSpecial(WS_PROGRAMNAMESHORT, Translator.GetMessage('469'),
                        Translator.GetMessage('130'), Translator.GetMessage('131'), Checked)) then
  begin
    DeleteBackups(Checked);
    DisplayHistory();
  end;
end;

procedure Tform_CB8_Main.m_History_ParkClick(Sender: TObject);
begin
  if (not CheckPassword()) then
    Exit;

  if (lv_List.SelCount <> 1) then
    Exit;

  if (lv_History.SelCount = 0) then
    Exit;

  ChangeParkingStatus((Sender as TTntMenuItem).Checked);
end;

procedure Tform_CB8_Main.m_History_PropertiesClick(Sender: TObject);
begin
  if (not CheckPassword()) then
    Exit;

  if (lv_List.SelCount <> 1) then
    Exit;

  if (lv_History.SelCount = 0) then
    Exit;

  ShowBackupProperties();
end;

procedure Tform_CB8_Main.m_ToolsClick(Sender: TObject);
begin
  m_Tools_Update.Enabled:= not BOOL_CUSTOMIZED;
  m_Tools_Update.Visible:= not BOOL_CUSTOMIZED;
end;

procedure Tform_CB8_Main.m_Tools_DecryptorClick(Sender: TObject);
var
  AHandle: Thandle;
  MainEntry: TDecryptorMainEntry;
  LName: WideString;
begin
  if not CheckPassword() then
    Exit;

  LName:= Globals.AppPath + WS_COBDECRYPTORDLL;

  if (not WideFileExists(LName)) then
  begin
    Log(WideFormat(Translator.GetMessage('289'),[Lname], FSLocal), true, false);
    Exit;
  end;

  DisableTrayMenu();
  try
    AHandle := LoadLibraryW(PWideChar(LName));
    if AHandle > 0 then
    begin
      @MainEntry:= GetProcAddress(AHandle, S_MAINDECENTRY);

      if (@MainEntry <> nil) then
      begin
        MainEntry(PWideChar(Globals.AppPath),PWideChar(Settings.GetLanguage()),
                  Settings.GetLogErrorsOnly, Application.Handle);
      end else
      Log(Translator.GetMessage('291'), true, false);

      FreeLibrary(AHandle);
    end
    else
      Log(WideFormat(Translator.GetMessage('290'), [LName], FSLocal), true, false);

  finally
    EnableTrayMenu();
  end;

end;

procedure Tform_CB8_Main.m_Task_EditClick(Sender: TObject);
begin
  if not CheckPassword() then
    Exit;

  EditTask();
end;

procedure Tform_CB8_Main.m_Tools_DecompressorClick(Sender: TObject);
var
  Result: cardinal;
begin
  Result:= ShellExecuteW(0,'open',PWideChar(Globals.AppPath + WS_DECOMPRESSOREXENAME),
                        PWideChar(Settings.GetLanguage()),nil,SW_SHOWNORMAL);
  if (Result <= 32) then
  begin
    Log(Translator.GetMessage('539'), true);
    pc_Main.ActivePage:= tab_Log;
  end;
end;

procedure Tform_CB8_Main.m_ExitClick(Sender: TObject);
begin
  if not CheckPassword() then
    Exit;

  Tag := INT_MODALRESULTOK; //Closed by hand
  Close();
end;

procedure Tform_CB8_Main.m_ListClick(Sender: TObject);
begin
  case lv_List.ViewStyle of
    vsIcon: m_List_ViewIcon.Checked:= true;
    vsSmallIcon: m_List_ViewSmallIcon.Checked:= true;
    vsList: m_List_ViewList.Checked:= true;
    vsReport: m_List_ViewReport.Checked:= true;
  end;
end;

procedure Tform_CB8_Main.m_List_ImportClick(Sender: TObject);
begin
  if (not CheckPassword()) then
    Exit;

  // Ask for the name of the list
  dlg_Open.DefaultExt:= WS_LISTEXTNODOT;
  dlg_Open.Filter:= WideFormat(WS_LISTFILTER,[Translator.GetMessage('439'),Translator.GetMessage('27')], FSLocal);
  dlg_Open.FilterIndex:= 1;
  dlg_Open.InitialDir:= Globals.DBPath;
  dlg_Open.Options:= dlg_Open.Options + [ofFileMustExist, ofPathMustExist,
      ofForceShowHidden];
  dlg_Open.Title:= Translator.GetMessage('446');

  DisableTrayMenu();
  try
    if (dlg_Open.Execute) then
    begin
      ImportList(dlg_Open.FileName);
      //Send the message to reload the ini AND the list
      PostEngineMessage(WS_CMDRELOADINI, WS_NIL, WS_NIL, WS_NIL);
      PostEngineMessage(WS_CMDRELOADLIST, WS_NIL, WS_NIL, WS_NIL);
      // Now reload the list
      DisplayTasks(WS_NIL);
      // The log is displayed on ImportList. The new list is saved there al well
    end;
  finally
    EnableTrayMenu();
  end;
end;

procedure Tform_CB8_Main.m_List_NewClick(Sender: TObject);
begin
  if (not CheckPassword()) then
    Exit;

  // Ask for the name of the list
  dlg_Save.DefaultExt:= WS_LISTEXTNODOT;
  dlg_Save.Filter:= WideFormat(WS_LISTFILTER,[Translator.GetMessage('439'),Translator.GetMessage('27')], FSLocal);
  dlg_Save.FilterIndex:= 1;
  dlg_Save.InitialDir:= Globals.DBPath;
  dlg_Save.Options:= dlg_Save.Options + [ofOverwritePrompt, ofPathMustExist,
      ofForceShowHidden];
  dlg_Save.Title:= Translator.GetMessage('440');

  DisableTrayMenu();
  try
    if (dlg_Save.Execute) then
    begin
      // First, create the empty list
      if (CobCreateEmptyTextFileW(dlg_Save.FileName)) then
      begin
        //Load the actual list
        Settings.SetList(dlg_Save.FileName);
        Settings.LoadList();
        // Save the settings
        Settings.SaveSettings(false);
        //Send the message to reload the ini AND the list
        PostEngineMessage(WS_CMDRELOADINI, WS_NIL, WS_NIL, WS_NIL);
        PostEngineMessage(WS_CMDRELOADLIST, WS_NIL, WS_NIL, WS_NIL);
        // Now reload the list
        DisplayTasks(WS_NIL);
        // Log
        Log(WideFormat(Translator.GetMessage('442'),[dlg_Save.FileName],FSGlobal),false, false);
      end else
        CobShowMessageW(self.Handle,
                        WideFormat(Translator.GetMessage('441'),[dlg_Save.FileName],FSLocal),
                        WS_PROGRAMNAMESHORT);
    end;
  finally
    EnableTrayMenu();
  end;
end;

procedure Tform_CB8_Main.m_List_OpenClick(Sender: TObject);
begin
  if (not CheckPassword()) then
    Exit;

  // Ask for the name of the list
  dlg_Open.DefaultExt:= WS_LISTEXTNODOT;
  dlg_Open.Filter:= WideFormat(WS_LISTFILTER,[Translator.GetMessage('439'),Translator.GetMessage('27')], FSLocal);
  dlg_Open.FilterIndex:= 1;
  dlg_Open.InitialDir:= Globals.DBPath;
  dlg_Open.Options:= dlg_Open.Options + [ofFileMustExist, ofPathMustExist,
      ofForceShowHidden];
  dlg_Open.Title:= Translator.GetMessage('443');

  DisableTrayMenu();
  try
    if (dlg_Open.Execute) then
    begin
      //Load the actual list
      Settings.SetList(dlg_Open.FileName);
      Settings.LoadList();
      //Save the settings
      Settings.SaveSettings(false);
      //Send the message to reload the ini AND the list
      PostEngineMessage(WS_CMDRELOADINI, WS_NIL, WS_NIL, WS_NIL);
      PostEngineMessage(WS_CMDRELOADLIST, WS_NIL, WS_NIL, WS_NIL);
      // Now reload the list
      DisplayTasks(WS_NIL);
      // Log
      Log(WideFormat(Translator.GetMessage('444'),[dlg_Open.FileName],FSGlobal),false, false);
    end;
  finally
    EnableTrayMenu();
  end;
end;

procedure Tform_CB8_Main.m_List_RefreshClick(Sender: TObject);
var
  ID: WideString;
begin
  if (not CheckPassword()) then
    Exit;

  if lv_List.Selected = nil then
    ID := WS_NIL
  else
    ID := lv_List.Selected.SubItems[0];

  DisplayTasks(ID);
end;

procedure Tform_CB8_Main.m_List_SaveClick(Sender: TObject);
begin
  if (not CheckPassword()) then
    Exit;

  // Ask for the name of the list
  dlg_Save.DefaultExt:= WS_LISTEXTNODOT;
  dlg_Save.Filter:= WideFormat(WS_LISTFILTER,[Translator.GetMessage('439'),Translator.GetMessage('27')], FSLocal);
  dlg_Save.FilterIndex:= 1;
  dlg_Save.InitialDir:= Globals.DBPath;
  dlg_Save.Options:= dlg_Save.Options + [ofOverwritePrompt, ofPathMustExist,
      ofForceShowHidden];
  dlg_Save.Title:= Translator.GetMessage('440');

  DisableTrayMenu();
  try
    if (dlg_Save.Execute) then
    begin
      // set the actual list
      Settings.SetList(dlg_Save.FileName);
      // change the IDs of the tasks, because it messes with the history
      Settings.RenameTasksID();
      // Save the actual list with the new file name
      Settings.SaveSettings(false);
      // 2006-06-14 fixed
      Settings.SaveList();
      //Send the message to reload the ini AND the list
      PostEngineMessage(WS_CMDRELOADINI, WS_NIL, WS_NIL, WS_NIL);
      PostEngineMessage(WS_CMDRELOADLIST, WS_NIL, WS_NIL, WS_NIL);
      // Now reload the list
      DisplayTasks(WS_NIL);
      // Log
      Log(WideFormat(Translator.GetMessage('445'),[dlg_Save.FileName],FSGlobal),false, false);
    end;
  finally
    EnableTrayMenu();
  end;
end;

procedure Tform_CB8_Main.m_LogClick(Sender: TObject);
begin
  m_Log_WordWrap.Checked:= re_Log.WordWrap;
  m_Log_Copy.Enabled:= re_Log.SelLength > 0;
end;

procedure Tform_CB8_Main.m_Tools_OptionsClick(Sender: TObject);
var
  OldLanguage: WideString;
  CurrentHotKey: integer;
  OldNavigate, OldForce: boolean;
begin
  if not CheckPassword() then
    Exit;

  DisableTrayMenu();
  form_Options:= Tform_Options.Create(nil);
  try
    OldLanguage:= Settings.GetLanguage();
    CurrentHotKey:= UISettings.HotlKey;
    OldForce:= UISettings.ForceInternalHelp;
    OldNavigate:= UISettings.NavigateInternally;
    form_Options.ShowModal();
    if (form_Options.Tag = INT_MODALRESULTOK) then
    begin
      Settings.SaveSettings(false);
      UISettings.SaveSettings(false);
      PostEngineMessage(WS_CMDRELOADINI, WS_NIL, WS_NIL, WS_NIL);
      ApplyWindowSettings();
      if (WideUpperCase(OldLanguage) <> WideUpperCase(Settings.GetLanguage())) then
        begin
          Translator.LoadLanguage(Settings.GetLanguage());
          GetInterfaceText();
        end;
      if (CurrentHotKey <> UISettings.HotlKey) then
        begin
          UnsetHotKey();
          SetHotKey(TCobHotKey(UISettings.HotlKey));
        end;
      if (UISettings.ForceInternalHelp <> OldForce) or
         (UISettings.NavigateInternally <> OldNavigate) then
            ShowHideBrowser();
      if (UISettings.ForceInternalHelp <> OldForce) then
        ShowIntroHelpPage();
    end;
  finally
   form_Options.Release();
   form_Options:= nil;
   EnableTrayMenu();
  end;
end;

procedure Tform_CB8_Main.m_Tools_TranslatorClick(Sender: TObject);
var
  Result: cardinal;
begin
  Result:= ShellExecuteW(0,'open',PWideChar(Globals.AppPath + WS_TRANSLATIONEXENAME),
                        nil, nil , SW_SHOWNORMAL);
  if (Result <= 32) then
  begin
    Log(Translator.GetMessage('540'), true);
    pc_Main.ActivePage:= tab_Log;
  end;
end;

procedure Tform_CB8_Main.m_Tools_UpdateClick(Sender: TObject);
begin
  CheckUpdates(true);
end;

procedure Tform_CB8_Main.NeedToAutoBackup();
var
  Forcer: TBackupForcer;
begin
  Log(Translator.GetMessage('506'), false, false);
  Forcer:= TBackupForcer.Create();
  Forcer.FreeOnTerminate:= true;
  Forcer.OnTerminate:= OnForcedTerminated;
  Forcer.Resume();  
end;

function Tform_CB8_Main.NeedToCheckUpdates(): boolean;
var
  Sl: TTntStringList;
  FileName: WideString;
  OK: boolean;
  DT, CurrentDate: TDateTime;
begin
  Result:= true;
  Sl:= TTntStringList.Create();
  try
    FileName:= Globals.SettingsPath + WS_LUFLAG;
    if (WideFileExists(FileName)) then
    begin
      Sl.LoadFromFile(FileName);
      if (Sl.Count > 0) then
      begin
        DT:= CobBinToDoubleW(Sl[0],OK);
        if (OK) then
          begin
            CurrentDate:= Now();
            if (Trunc(CurrentDate - DT) >= INT_WEEK) and // check once  a week
               (Trunc(CurrentDate - FLUDateOnceADay) >= 1) then //but only once a day
              FLUDateOnceADay:= CurrentDate else
              Result:= false;
          end;
      end;
    end;
  finally
    FreeAndNil(Sl);
  end;
end;

procedure Tform_CB8_Main.m_Task_RunAllClick(Sender: TObject);
begin
  if not CheckPassword() then
    Exit;

  if (FBackingUp) then
  begin
    CobShowMessageW(self.Handle, Translator.GetMessage('450'),WS_PROGRAMNAMESHORT);
    Exit;
  end;

  if (UISettings.ConfirmRun) then
    if (not MessageDlgSpecial(WS_PROGRAMNAMESHORT, Translator.GetMessage('452'),
      Translator.GetMessage('496'),Translator.GetMessage('497'), FShutDown)) then
        Exit;

  if (not FConnected) then
  begin
    CobShowMessageW(self.Handle, Translator.GetMessage('465'),WS_PROGRAMNAMESHORT);
    Exit;
  end;

  RunAll();
end;

procedure Tform_CB8_Main.m_Task_RunSelectedClick(Sender: TObject);
begin
  if not CheckPassword() then
    Exit;

  if (FBackingUp) then
  begin
    CobShowMessageW(self.Handle, Translator.GetMessage('450'),WS_PROGRAMNAMESHORT);
    Exit;
  end;

  if (UISettings.ConfirmRun) then
    if (not MessageDlgSpecial(WS_PROGRAMNAMESHORT, Translator.GetMessage('453'),
      Translator.GetMessage('496'),Translator.GetMessage('497'), FShutDown)) then
        Exit;

  if (not FConnected) then
  begin
    CobShowMessageW(self.Handle, Translator.GetMessage('465'),WS_PROGRAMNAMESHORT);
    Exit;
  end;

  RunSelected();
end;

procedure Tform_CB8_Main.m_Task_ShutDownClick(Sender: TObject);
begin
  if not FBackingUp then
    Exit;

  if not CheckPassword() then
    Exit;

  // If a backup is going on, the user can now undo the
  // shutdown flag

  FShutDown := not FShutDown;

  Log(Translator.GetMessage('500'), false, false);
end;

procedure Tform_CB8_Main.m_StyleIconClick(Sender: TObject);
begin
  lv_List.ViewStyle:= vsIcon;
  lv_List.DragMode:= dmManual;
end;

procedure Tform_CB8_Main.m_StyleListClick(Sender: TObject);
begin
  lv_List.ViewStyle:= vsList;
  lv_List.DragMode:= dmAutomatic;
end;

procedure Tform_CB8_Main.m_StyleReportClick(Sender: TObject);
begin
  lv_List.ViewStyle:= vsReport;
  lv_List.DragMode:= dmAutomatic;
end;

procedure Tform_CB8_Main.m_StyleSmallIconsClick(Sender: TObject);
begin
  lv_List.ViewStyle:= vsSmallIcon;
  lv_List.DragMode:= dmManual;
end;

procedure Tform_CB8_Main.m_TaskClick(Sender: TObject);
begin
  m_Task_Edit.Enabled:= (lv_List.SelCount > 0);
  m_Task_Delete.Enabled:= (lv_List.SelCount > 0);
  m_Task_Clone.Enabled:= (lv_List.SelCount > 0);
  m_Task_Attributes.Enabled:= (lv_List.SelCount > 0);
  m_Task_RunAll.Enabled:= not FBackingUp;
  m_Task_RunSelected.Enabled:= (lv_List.SelCount > 0) and (not FBackingUp);
  m_Task_Abort.Enabled:= FBackingUp;
  m_Task_ShutDown.Enabled:= FBackingUp;

  if FShutDown then
    m_Task_Shutdown.Caption := Translator.GetInterfaceText('614')
  else
    m_Task_Shutdown.Caption := Translator.GetInterfaceText('613');
end;

procedure Tform_CB8_Main.m_Task_DeleteClick(Sender: TObject);
begin
  if not CheckPassword() then
    Exit;

  DeleteTask();
end;

procedure Tform_CB8_Main.m_Task_NewClick(Sender: TObject);
begin
  if not CheckPassword() then
    Exit;

  ModifyTask(WS_NIL, WS_NIL);
end;

procedure Tform_CB8_Main.m_Log_ClearClick(Sender: TObject);
begin
  if (not CheckPassword()) then
    Exit;
    
  re_Log.Clear();
end;

procedure Tform_CB8_Main.m_Log_CopyClick(Sender: TObject);
begin
  if (re_Log.SelLength > 0) then
    re_Log.CopyToClipboard();
end;

procedure Tform_CB8_Main.m_Log_DeleteClick(Sender: TObject);
begin
  if (not CheckPassword()) then
    Exit;

    {Send a message to delete the log file}
  if CobMessageBoxW(Application.Handle, Translator.GetMessage('463'),WS_PROGRAMNAMESHORT, MB_YESNO) = mrYes then
  begin
    re_Log.Clear();
    PostEngineMessage(WS_CMDDELETELOG, WS_NIL, WS_NIL, WS_NIL);
    Log(Translator.GetMessage('464'), false, false);
  end;
end;

procedure Tform_CB8_Main.m_Log_OpenClick(Sender: TObject);
var
  Error: cardinal;
  LogOld, LogNew, Mes: WideString;
begin
  if (not CheckPassword()) then
    Exit;

  LogOld:= Globals.DBPath + WS_LOGFILENAME;
  LogNew:= Globals.DBPath + WS_LOGFILENAMECOPY;

  if (WideFileExists(LogOld)) then
  begin
    // CopyFileW(PWideChar(LogOld), PWideChar(LogNew), false); The engine must handle this
    PostEngineMessage(WS_CMDCOPYLOG, LogNew, WS_NIL, WS_NIL);
    //Wait...
    Screen.Cursor:= crHourGlass;
    try
      Sleep(INT_WAITLOG);
    finally
      Screen.Cursor:= crDefault;
    end;
    Error:= ShellExecuteW(0,'open',PWideChar(LogNew),nil,nil,SW_SHOWNORMAL);
    if (Error <= 32) then
    begin
      Mes:= WideFormat(Translator.GetMessage('462'), [Translator.GetShellError(Error)], FSLocal);
      CobShowMessageW(self.Handle, Mes, WS_PROGRAMNAMESHORT);
      Log(Mes, true, false);
    end;
  end;
end;

procedure Tform_CB8_Main.m_Log_PrintClick(Sender: TObject);
begin
  DisableTrayMenu();
  try
    if (dlg_Print.Execute) then
      re_Log.Print(AnsiString(WideFormat(Translator.GetMessage('461'),[WS_PROGRAMNAMESHORT],FSLocal)));
  finally
    EnableTrayMenu();
  end;
end;

procedure Tform_CB8_Main.m_Log_SelectAllClick(Sender: TObject);
begin
  pc_Main.ActivePage := tab_Log;
  re_Log.SetFocus();
  re_Log.SelectAll();
end;

procedure Tform_CB8_Main.m_Log_WordWrapClick(Sender: TObject);
begin
  re_Log.WordWrap:= not re_Log.WordWrap;
end;

procedure Tform_CB8_Main.m_Pop_DisableClick(Sender: TObject);
var
  i: integer;
  Task: TTask;
begin
  if (not CheckPassword()) then
    Exit;

  if (lv_List.SelCount > 0) then
  begin
    for i:=0 to lv_List.Items.Count - 1 do
    begin
      if (lv_List.Items[i].Selected) then
      begin
        Settings.GetTaskPointer(lv_List.Items[i].SubItems[0], Task);
        if (Task <> nil) then
          Task.Disabled:= not Task.Disabled;
      end;
    end;
    Settings.SaveList();
    // And send the message to the engine to reload the list
    PostEngineMessage(WS_CMDRELOADLIST, WS_NIL, WS_NIL, WS_NIL);

    // now show the list
    DisplayTasks(WS_NIL);

    //Log
    Log(Translator.GetMessage('501'), false, false);

  end;
end;

procedure Tform_CB8_Main.m_pop_OpenClick(Sender: TObject);
begin
  ShowMainWindow();
end;

procedure Tform_CB8_Main.SavePosition();
begin
  UISettings.Width:= Width;
  UISettings.Height:= Height;
  UISettings.Left:= Left;
  UISettings.Top:= Top;
  UISettings.VSplitter:= panel_Left.Width;
  UISettings.MainLVView:= ord(lv_List.ViewStyle);
  UISettings.MainLVColumn0:= lv_List.Columns[0].Width;
  UISettings.MainLVColumn1:= lv_List.Columns[1].Width;
  UISettings.MainLVColumn2:= lv_List.Columns[2].Width;
  UISettings.PropertyColumn0:= lv_Properties.Columns[0].Width;
  UISettings.PropertyColumn1:= lv_Properties.Columns[1].Width;
  UISettings.HistoryColumn0:= lv_History.Columns[0].Width;
  UISettings.HistoryColumn1:= lv_History.Columns[1].Width;
  UISettings.HistoryColumn2:= lv_History.Columns[2].Width;

  UISettings.SavePositions(false);
end;

procedure Tform_CB8_Main.SaveUISettings();
begin
  // Save some settings that can be changed withou using
  // the options dialog
  UISettings.WordWrap:= re_Log.WordWrap;
  
  UISettings.SaveSettings(false);
end;

procedure Tform_CB8_Main.sb_BackClick(Sender: TObject);
begin
  if (FCanUseIE) and (FBrowser <> nil) then
    try
      FBrowser.GoBack();
    except
      on E: Exception do
        Beep();
    end;
end;

procedure Tform_CB8_Main.sb_ForumClick(Sender: TObject);
begin
  m_Help_SupportClick(self);
end;

procedure Tform_CB8_Main.sb_ForwardClick(Sender: TObject);
begin
  if (FCanUseIE) and (FBrowser <> nil) then
    try
      FBrowser.GoForward();
    except
      on E: Exception do
        Beep();
    end;
end;

procedure Tform_CB8_Main.sb_IndexClick(Sender: TObject);
begin
  m_Help_IndexClick(self);
end;

procedure Tform_CB8_Main.sb_PrintClick(Sender: TObject);
begin
  if (FCanUseIE) and (FBrowser <> nil) then
  begin
    Screen.Cursor:= crHourGlass;
    try
      FBrowser.ExecWB(OLECMDID_PRINT, OLECMDEXECOPT_PROMPTUSER);
    finally
      Screen.Cursor:= crDefault;
    end;
  end;
end;

procedure Tform_CB8_Main.sb_RefreshClick(Sender: TObject);
begin
  if (FCanUseIE) and (FBrowser <> nil) then
    FBrowser.Refresh();
end;

procedure Tform_CB8_Main.sb_StopClick(Sender: TObject);
begin
  if (FCanUseIE) and (FBrowser <> nil) then
    FBrowser.Stop();
end;

procedure Tform_CB8_Main.sb_TutorialClick(Sender: TObject);
begin
  m_Help_TutorialClick(self);
end;

procedure Tform_CB8_Main.sb_WebClick(Sender: TObject);
begin
  m_Help_WebClick(self);
end;

function Tform_CB8_Main.ScheduleTypeToHuman(const Kind: integer): WideString;
begin
  case Kind of
    INT_SCONCE: Result:= Translator.GetMessage('101');
    INT_SCWEEKLY: Result:= Translator.GetMessage('102');
    INT_SCMONTHLY: Result:= Translator.GetMessage('103');
    INT_SCYEARLY: Result:= Translator.GetMessage('104');
    INT_SCTIMER: Result:= Translator.GetMessage('105');
    INT_SCMANUALLY: Result:= Translator.GetMessage('106');
    else
    Result:= Translator.GetMessage('107');
  end;
end;

procedure Tform_CB8_Main.PostEngineMessage(const Cmd, Param1, Param2, Param3: WideString);
begin
  FEncoder.Clear();
  FEncoder.Add(Cmd);
  FEncoder.Add(Param1);
  FEncoder.Add(Param2);
  FEncoder.Add(Param3);
  IPCMasterCS.Enter();
  try
    CommandList.Add(FEncoder.CommaText);
  finally
    IPCMasterCS.Leave();
  end;
end;

procedure Tform_CB8_Main.ResetAttributes();
var
  i: integer;
  Task: TTask;
begin
  if (lv_List.SelCount = 0) then
    Exit;

  if (CobMessageBoxW(self.Handle, Translator.GetMessage('457'), WS_PROGRAMNAMESHORT, MB_YESNO) = mrNO) then
    Exit;

  FCancelDelete:= false;

  for i:=0 to lv_List.Items.Count - 1 do
    if (lv_List.Items[i].Selected) then
    begin
      Settings.GetTaskPointer(lv_List.Items[i].SubItems[0],Task);
      if (Task <> nil) then
        ResetAttributesSource(Task.Source, Task.IncludeSubdirectories);
      if (FCancelDelete) then
        Break;
    end;
    CobShowMessageW(self.Handle, Translator.GetMessage('460'),WS_PROGRAMNAMESHORT);
end;

procedure Tform_CB8_Main.ResetAttributesSource(const Source: WideString; const SubDirs: boolean);
var
  Sl: TTntStringList;
  i, Kind: integer;
  ASource: WideString;
begin
  Sl:= TTntStringList.Create();
  try
    Sl.CommaText:= Source;
    for i:= 0 to Sl.Count - 1 do
    begin
      ASource:= FTool.DecodeSD(Sl[i],Kind);
      case Kind of
        INT_SDFILE:
          begin
            Log(WideFormat(Translator.GetMessage('458'),[ASource],FSLocal), false, false);
            ASource:= FTool.NormalizeFileName(ASource);
            FTool.SetArchiveAttributeW(ASource, true);
          end;
        INT_SDDIR:
          begin
            Log(WideFormat(Translator.GetMessage('458'),[ASource],FSLocal), false, false);
            ASource:= FTool.NormalizeFileName(ASource);
            ResetDirectoryAttributes(ASource, SubDirs);
          end;
        else
          begin
          // Do nothing because logging a FTP source is a mess
          //Log(WideFormat(Translator.GetMessage('459'),[ASource],FSLocal), false, false);
          end;
        if (FCancelDelete) then
          Break;
      end;

    end;
  finally
    FreeAndnIl(Sl);
  end;
end;

procedure Tform_CB8_Main.ResetDirectoryAttributes(const Source: WideString; const Subdirs: boolean);
var
  Canceler: Tform_Canceler;
begin
  DisableTrayMenu();
  Canceler:= Tform_Canceler.Create(nil);
  try
    Canceler.Source:= Source;
    Canceler.Operation:= INT_OPUIATTRIBUTES;
    Canceler.FSubdirs:= SubDirs;
    Canceler.ShowModal();
  finally
    FreeAndNil(Canceler);
    EnableTrayMenu();
  end;
end;

procedure Tform_CB8_Main.RunAll();
begin
  Log(Translator.GetMessage('508'), false, false);
  PostEngineMessage(WS_CMDBACKUPALL,WS_NIL,WS_NIL,WS_NIL);
end;

procedure Tform_CB8_Main.RunSelected();
var
  Sl: TTntStringList;
  i: integer;
begin
  if (lv_List.SelCount > 0) then
  begin
    Sl:= TTntStringList.Create();
    try
      for i:= 0 to lv_List.Items.Count - 1 do
        if (lv_List.Items[i].Selected) then
          Sl.Add(lv_List.Items[i].SubItems[0]);
      Log(Translator.GetMessage('509'), false, false);
      PostEngineMessage(WS_CMDBACKUPSELECTED,Sl.CommaText,WS_NIL,WS_NIL);
    finally
      FreeAndNil(Sl);
    end;
  end;
end;

procedure Tform_CB8_Main.SetApplicationHint(Operation, Partial, Total: integer;
                                 const TaskID: WideString);
var
  Str: WideString;
begin
  if Partial > INT_100 then
    Partial := INT_100;
  if Partial < INT_NIL then
    Partial := INT_NIL;
  if Total > INT_100 then
    Total := INT_100;
  if Total < INT_NIL then
    Total := INT_NIL;

  case Operation of
    INT_OPCOPY: Str := WideFormat(WS_APPHINT,
      [TaskID, Translator.GetMessage('162') , Partial, Total]);
    INT_OPCOMPRESS: Str := WideFormat(WS_APPHINT,
      [TaskID, Translator.GetMessage('163') , Partial, Total]);
    INT_OPCRC: Str := WideFormat(WS_APPHINT,
      [TaskID, Translator.GetMessage('168') , Partial, Total]);
    INT_OPFTPUP: Str := WideFormat(WS_APPHINT,
      [TaskID, Translator.GetMessage('165') , Partial, Total]);
    INT_OPFTPDOWN: Str := WideFormat(WS_APPHINT,
      [TaskID, Translator.GetMessage('166') , Partial, Total]);
    INT_OPENCRYPT: Str := WideFormat(WS_APPHINT,
      [TaskID, Translator.GetMessage('164') , Partial, Total]);
    INT_OPDELETING: Str := WideFormat(WS_APPHINT,
      [TaskID, Translator.GetMessage('169') , Partial, Total]);
    INT_OPIDLE: Str := WS_PROGRAMNAMESHORT;
  else
    Str := WS_PROGRAMNAMESHORT;
  end;


  lstrcpyW(FSysTrayIcon.szTip,PWideChar(Str));
end;

procedure Tform_CB8_Main.SetHotKey(const Key: TCobHotKey);
var
  Modifiers, VK: cardinal;
begin
  Modifiers:= INT_NIL;
  VK:= INT_NIL;

  if (FCurrentKey = Key) then
    Exit;

  if Key = ckNone then
    begin
      UnsetHotKey();
      Exit;
    end;

  case Key of
    ckWinC:
    begin
      Modifiers:= MOD_WIN ;
      VK:= $43;    //C
    end;
    ckWinZ:
    begin
      Modifiers:= MOD_WIN ;
      VK:= $5A;    //Z
    end;
    ckCtrlAltC:
    begin
      Modifiers:= MOD_ALT + MOD_CONTROL;
      VK:= $43;    //C
    end;
    ckCtrlAltB:
    begin
      Modifiers:= MOD_ALT + MOD_CONTROL;
      VK:= $42;     //B
    end;
    ckCtrlShiftC:
    begin
      Modifiers:= MOD_SHIFT + MOD_CONTROL;
      VK:=  $43;    //C
    end;
    ckCtrlShiftF12:
    begin
      Modifiers:= MOD_SHIFT + MOD_CONTROL;
      VK:= VK_F12;
    end;
    else
      // 0 does nothing
    end;

  RegisterHotKey(self.Handle , FHotKey, Modifiers, VK);
  FCurrentKey:= Key;
end;


procedure Tform_CB8_Main.SetLastUpdate();
var
  Sl: TTntStringList;
  FileName: WideString;
begin
  Sl:= TTntStringList.Create();
  try
    FileName:= Globals.SettingsPath + WS_LUFLAG;
    Sl.Add(CobDoubleToBinW(Now()));
    Sl.SaveToFile(FileName);
    FTool.GetFullAccess(WS_NIL , FileName);
  finally
    FreeAndNil(Sl);
  end;
end;

procedure Tform_CB8_Main.ShowBackupProperties();
var
  i: integer;
  List: TBackupList;
  Backup: TBackup;
  form_Backup: Tform_Backup;
begin
  for i:=0 to lv_History.Items.Count - 1 do
    if (lv_History.Items[i].Selected) then
    begin
      List:= TBackupList.Create();
      try
        List.LoadBackups(lv_List.Selected.SubItems[0]);
        List.GetBackupPointer(lv_History.Items[i].SubItems[1], Backup);
        if (Backup <> nil) then
        begin
          DisableTrayMenu();
          form_Backup:= Tform_Backup.Create(nil);
          try
            form_Backup.Backup:= Backup;
            form_Backup.ShowModal();
          finally
            form_Backup.Release();
            EnableTrayMenu();
          end;
        end;
      finally
        FreeAndNil(List);
      end;
      Break;  // show only the first selected backup
    end;
end;

procedure Tform_CB8_Main.ShowBallon(const Msg: WideString; const TimeMS: cardinal);
begin
  form_Balloon.ShowMsg(Msg, TimeMS);
end;

procedure Tform_CB8_Main.ShowHelp(const InitialSite: WideString; const ForceInternal, Local: boolean);
begin
  if (FCanUseIE) and (ForceInternal) then
    ShowHelpInternal(InitialSite, true, Local) else
    ShowHelpExternal(InitialSite);
end;

procedure Tform_CB8_Main.ShowHelpExternal(const InitialSite: WideString);
var
  Error: cardinal;
  Msg: WideString;
begin
  Error := ShellExecuteW(Application.Handle, 'open', PWideChar(InitialSite),
    nil, nil, SW_SHOWNORMAL);
  if Error <= 32 then
  begin
    Msg:= WideFormat(Translator.GetMessage('466'), [InitialSite, Translator.GetShellError(Error)], FSLocal);
    Log(Msg , true, false);
    CobShowMessageW(self.Handle, Msg, WS_PROGRAMNAMESHORT);
  end;
end;

procedure Tform_CB8_Main.ShowHelpInternal(const InitialSite: WideString; const ChangeTab, Local: boolean);
begin
  if (FBrowser <> nil) then
  begin
    if (Local) then
      if (not WideFileExists(InitialSite)) then
        Exit;

    FBrowser.Navigate(InitialSite);
    if (ChangeTab) then
      pc_Main.ActivePage:= tab_Help;
  end else
  ShowHelpExternal(InitialSite);
end;

procedure Tform_CB8_Main.ShowHideBrowser();
begin
  if (pc_Main.ActivePage = tab_Help) then
    pc_Main.ActivePage:= tab_Properties;
  tab_Help.TabVisible:= (FCanUseIE) and
             (UISettings.ForceInternalHelp or  UISettings.NavigateInternally);
end;

procedure Tform_CB8_Main.ShowIntroHelpPage();
begin
if (FCanUseIE) then
  if (UISettings.ForceInternalHelp) then
    ShowHelpInternal(Globals.HelpPath + WS_SITEWELCOME, false, true) else
    ShowHelpInternal(Globals.HelpPath + WS_SITEEXTERNAL, false, true);
end;

procedure Tform_CB8_Main.ShowMainWindow();
begin
  if Settings.GetProtectMainWindow() then
    begin
      // 2005-08-25 Do not show another password window if there is one open
      if form_Password <> nil then
        Exit;

      if not CheckPassword() then
        Exit;
    end;


  Show();
  Application.BringToFront();
end;

function Tform_CB8_Main.SplitToHuman(const Value: integer): WideString;
begin
  case Value of
    INT_SPLIT360K: Result:= Translator.GetInterfaceText('152');
    INT_SPLIT720K: Result:= Translator.GetInterfaceText('153');
    INT_SPLIT12M: Result:= Translator.GetInterfaceText('154');
    INT_SPLIT14M: Result:= Translator.GetInterfaceText('155');
    INT_SPLIT100M: Result:= Translator.GetInterfaceText('156');
    INT_SPLIT250M: Result:= Translator.GetInterfaceText('157');
    INT_SPLIT650M: Result:= Translator.GetInterfaceText('158');
    INT_SPLIT700M: Result:= Translator.GetInterfaceText('159');
    INT_SPLIT1G:  Result:= Translator.GetInterfaceText('160');
    INT_SPLIT47G: Result:= Translator.GetInterfaceText('161');
    INT_SPLITCUSTOM: Result:= Translator.GetInterfaceText('162');
    else
    Result:= Translator.GetInterfaceText('151');
  end;
end;

procedure Tform_CB8_Main.status_LeftDblClick(Sender: TObject);
begin
  CobShowMessageW(self.Handle,
                  WideFormat(Translator.GetMessage('138'),[Settings.GetList()],FSLocal),
                  WS_PROGRAMNAMESHORT);
end;

procedure Tform_CB8_Main.timer_AnimatedTimer(Sender: TObject);
begin
  FAnimated := true;

  inc(FIconIndex);
  if FIconIndex > 5 then
    FIconIndex := 2;

  imgs_Tray.GetIcon(FIconIndex, FIcon);
  FSysTrayIcon.hIcon := FIcon.Handle;

  Shell_NotifyIconW(NIM_MODIFY, @FSysTrayIcon);
end;

procedure Tform_CB8_Main.tim_AutoLUTimer(Sender: TObject);
begin
  if (Settings.GetAutoUpdate()) then
    if (NeedToCheckUpdates()) then
       CheckUpdates(false);
end;

procedure Tform_CB8_Main.tim_UITimer(Sender: TObject);
begin
  b_Abort.Enabled:= FBackingUp;
  b_RunSelected.Enabled:= (lv_List.SelCount > 0) and not FBackingUp;
  b_RunAll.Enabled:= not FBackingUp;
  b_Update.Enabled:= not BOOL_CUSTOMIZED;
  b_Update.Visible:= not BOOL_CUSTOMIZED;
end;

procedure Tform_CB8_Main.TntFormClose(Sender: TObject; var Action: TCloseAction);
begin
  if (not IsService) then
    CloseEngine();
    
  if (not FirstTime) then
    begin
      SavePosition();
      SaveUISettings();
    end;
end;

procedure Tform_CB8_Main.TntFormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := true;
  if IsService then
    if Tag = INT_MODALRESULTOK then //closed by the menu
    begin
      if UISettings.ConfirmClose then
      begin
        if CobMessageBoxW(Handle, Translator.GetMessage('12'),
                          WS_PROGRAMNAMESHORT, mb_YesNo) <> mrYes then
        begin
          Tag := INT_MODALRESULTCANCEL;
          CanClose := false;
        end; 
      end; // if UISettings
    end; // if TAG

end;

procedure Tform_CB8_Main.TntFormResize(Sender: TObject);
begin
  pb_Partial.Left:= 0;
  pb_Partial.Top:= 0;
  pb_Partial.Width:= (status_Right.Width div 2) - 1;
  pb_Partial.Height:= status_Right.Height;
  pb_Total.Left:= (status_Right.Width div 2) + 1;
  pb_Total.Top:= 0;
  pb_Total.Width:= (status_Right.Width div 2) - 1;
  pb_Total.Height:= status_Right.Height;
end;

procedure Tform_CB8_Main.TntFormShow(Sender: TObject);
begin
  if (FirstTime) then
  begin
    ApplyPositions();
    FirstTime:= false;
  end;
end;

procedure Tform_CB8_Main.TrayActive();
begin
  if timer_Animated.Enabled then
    timer_Animated.Enabled := false;

  FAnimated := false;
  SetApplicationHint(INT_OPIDLE, INT_NIL, INT_NIL, WS_NIL);
  // FSysTrayIcon.szTip := CS_PROGRAMNAME;
  imgs_Tray.GetIcon(0, FIcon);
  FSysTrayIcon.hIcon := FIcon.Handle;

  Shell_NotifyIconW(NIM_MODIFY, @FSysTrayIcon);
end;

procedure Tform_CB8_Main.TrayAnimateBegin();
begin
  timer_Animated.Enabled:= true;
end;

procedure Tform_CB8_Main.TrayAnimateEnd();
begin
  timer_Animated.Enabled:= false;

   if FConnected then
    TrayActive()
  else
    TrayInactive();

end;

procedure Tform_CB8_Main.TrayInactive();
begin
  if timer_Animated.Enabled then
    timer_Animated.Enabled := false;

  FAnimated := false;
  SetApplicationHint(INT_OPIDLE, INT_NIL, INT_NIL, WS_NIL);
  imgs_Tray.GetIcon(1, FIcon);
  FSysTrayIcon.hIcon := FIcon.Handle;

  Shell_NotifyIconW(NIM_MODIFY, @FSysTrayIcon);
end;

procedure Tform_CB8_Main.UnsetHotKey();
begin
  UnregisterHotKey(self.Handle, FHotKey);
  FCurrentKey:= ckNone;
end;

procedure Tform_CB8_Main.WMCloseMainForm(var Msg: TMessage);
begin
  Tag := INT_CLOSEDMUTEX; //closed by the mutex for One Instance  Checking
  Close();
end;

procedure Tform_CB8_Main.WMDropFiles(var Msg: TMessage);
var
  i, Count: integer;
  FileName: array[0..INT_MAX_PATHW] of WideChar;
  Sl: TTntStringList;
  Source: WideString;
begin
  if (not CheckPassword()) then
    Exit;

  Count:= DragQueryFileW(Msg.WParam, $FFFFFFFF, FileName, INT_MAX_PATHW);
  if (Count > 0) then
  begin
    Sl:= TTntStringList.Create();
    try
      for i:= 0 to Count - 1 do
      begin
        DragQueryFileW(Msg.WParam, i, FileName, INT_MAX_PATHW);
        Source:= WideString(FileName);
        if (WideFileExists(FTool.NormalizeFileName(Source))) then
          Source:=  FTool.EncodeSD(INT_SDFILE, Source) else
          if (WideDirectoryExists(FTool.NormalizeFileName(Source))) then
            Source:= FTool.EncodeSD(INT_SDDIR, Source) else
            Continue;
        Sl.Add(Source);
      end;

      ModifyTask(WS_NIL, Sl.CommaText);

    finally
      FreeAndNil(Sl);
    end;
  end;
end;

procedure Tform_CB8_Main.WndProc(var Msg: TMessage);
begin
  if Maxi then
  begin
    if Msg.WParam = SC_CLOSE then
      Tag := INT_MODALRESULTOK;

    inherited WndProc(Msg);
    Exit;
  end;

  if Msg.Msg = WM_TASKBAR_CREATED then
  begin
    // re-create taskbar icon
    Shell_NotifyIconW(NIM_ADD, @FSysTrayIcon);
    Exit;
  end;
  {Capture the minimize and Close message
  and hide the form instead}
  if Msg.Msg = WM_SYSCOMMAND then
  begin
    if (Msg.WParam = SC_CLOSE) or (Msg.WParam = SC_MINIMIZE) then
      begin
        //2005-08-04 Reset the password timer
        //2005-08-05 only if the setting REG_DONOTCLEARPASSWORDCACHE is true
        if (Settings.GetClearPasswordCache()) then
          FLastTimeQuered:= DOUBLE_NIL;
        Visible := false;
      end
    else
      inherited Wndproc(Msg);
  end
  else
    inherited Wndproc(Msg);
end;

end.
