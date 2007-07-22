{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~                                                            ~~~~~~~~~~
~~~~~~~~~~                   Cobian version Server                    ~~~~~~~~~~
~~~~~~~~~~            Copyright 2000-2006 by Luis Cobian              ~~~~~~~~~~
~~~~~~~~~~                     cobian@educ.umu.se                     ~~~~~~~~~~
~~~~~~~~~~                    All rights reserved                     ~~~~~~~~~~
~~~~~~~~~~                                                            ~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

unit unit_UI_Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Menus, unit_Common, ShellApi;

type

  Tform_Main = class(TForm)
    p_Left: TPanel;
    lb_Applications: TListBox;
    p_Client: TPanel;
    l_News: TLabel;
    e_Name: TLabeledEdit;
    e_CurrentVersion: TLabeledEdit;
    e_Home: TLabeledEdit;
    m_News: TMemo;
    p_Bottom: TPanel;
    b_OK: TButton;
    b_Cancel: TButton;
    m_Pop: TPopupMenu;
    m_Add: TMenuItem;
    m_Edit: TMenuItem;
    m_Delete: TMenuItem;
    m_Sep: TMenuItem;
    m_About: TMenuItem;
    l_Manage: TLabel;
    m_Log: TMenuItem;
    m_Sep2: TMenuItem;
    m_Sep3: TMenuItem;
    procedure m_LogClick(Sender: TObject);
    procedure m_AboutClick(Sender: TObject);
    procedure m_DeleteClick(Sender: TObject);
    procedure b_OKClick(Sender: TObject);
    procedure m_EditClick(Sender: TObject);
    procedure m_AddClick(Sender: TObject);
    procedure m_PopPopup(Sender: TObject);
    procedure b_CancelClick(Sender: TObject);
    procedure lb_ApplicationsClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FAppPath: string;
    FMutex: Thandle;
    FSec: TSecurityAttributes;
    p: PSECURITY_DESCRIPTOR;
    FirstTime: boolean;
    FBlob: TStringList;
    FFileName: string;
    FFlag: string;
    FLogName: string;
    FElement: TAVElement;
    FEditing: boolean;
    FS: TFormatSettings;
    procedure LoadList();
    procedure SaveList();
    procedure DisplayList();
    procedure ClearUI();
    procedure CheckUI();
    procedure DisplayItem(const Index: integer);
    function GetElementByName(const AName: string): string;
    function NameExists(const AName: string): integer;
    procedure AddAnItem(const AName, AVersion, AHome, AInfo: string);
    procedure SelectApplication(const AName: string);
    procedure SetFlag();
  public
    { Public declarations }
  end;

var
  form_Main: Tform_Main;

implementation

{$R *.dfm}
uses CobCommon, CobDialogsW;

procedure Tform_Main.AddAnItem(const AName, AVersion, AHome, AInfo: string);
begin
  FElement.App:= AName;
  FElement.Ver:= AVersion;
  FElement.Home:= AHome;
  FElement.Info:= AInfo;
  FBlob.Add(FElement.ElementToStr());
end;

procedure Tform_Main.b_CancelClick(Sender: TObject);
begin
  if (FEditing) then
  begin
    FEditing:= false;
    CheckUI();
  end else
  Close();
end;

procedure Tform_Main.b_OKClick(Sender: TObject);
var
  Exists, OldIndex: integer;
begin
  if (FEditing) then
  begin
    if (e_Name.Name <> S_NIL) then
    begin
      OldIndex:= lb_Applications.ItemIndex;
      Exists:= NameExists(e_Name.Text);
      if (Exists > -1) and (Exists = OldIndex) then
      begin
        FElement.App:= e_Name.Text;
        FElement.Ver:= e_CurrentVersion.Text;
        FElement.Home:= e_Home.Text;
        FElement.Info:= m_News.Lines.CommaText;
        FBlob[OldIndex]:= FElement.ElementToStr();
        SaveList();
        ClearUI();
        DisplayList();
        lb_Applications.Selected[OldIndex]:= true;
        lb_Applications.ItemIndex:= OldIndex;
        DisplayItem(OldIndex);
        FEditing:= false;
        CheckUI();
        SetFlag();
      end else
      ShowMessage(S_APPNAMEUNIQUE);
    end else
    ShowMessage(S_APPNAMEEMPTY);
  end else
  Close();
end;

procedure Tform_Main.CheckUI;
begin
  e_Name.Enabled:= FEditing;
  e_CurrentVersion.Enabled:= FEditing;
  e_Home.Enabled:= FEditing;
  l_News.Enabled:= FEditing;
  m_News.Enabled:= FEditing;
  l_Manage.Enabled:= not FEditing;
  lb_Applications.Enabled:= not FEditing;
  if (FEditing) then
    begin
      e_Name.Color:=  RGB(255,200,200);
      e_CurrentVersion.Color:= RGB(255,200,200);
      e_Home.Color:= RGB(255,200,200);
      m_News.Color:= RGB(255,200,200);
    end else
    begin
      e_Name.Color:= clWindow;
      e_CurrentVersion.Color:= clWindow;
      e_Home.Color:= clWindow;
      m_News.Color:= clWindow;
    end;
end;

procedure Tform_Main.ClearUI();
begin
  lb_Applications.Clear();
  e_Name.Clear();
  e_CurrentVersion.Clear();
  e_Home.Clear();
  m_News.Clear();
end;

procedure Tform_Main.DisplayItem(const Index: integer);
var
  Full: string;
begin
  e_Name.Clear();
  e_CurrentVersion.Clear();
  e_Home.Clear();
  m_News.Clear();

  if (Index >= 0) and (Index < lb_Applications.Items.Count) then
  begin
    Full:= GetElementByName(lb_Applications.Items[Index]);
    if (Full <> S_NIL) then
    begin
      FElement.StrToElement(Full);
      e_Name.Text:= FElement.App;
      e_CurrentVersion.Text:= FElement.Ver;
      e_Home.Text:= FElement.Home;
      m_News.Lines.CommaText:= FElement.Info;
    end;
  end;
end;

procedure Tform_Main.DisplayList();
var
  i: integer;
begin
  ClearUI();

  for i:=0 to FBlob.Count - 1 do
  begin
    if (FElement.StrToElement(FBlob[i])) then
      lb_Applications.Items.Add(FElement.App);
  end;

  CheckUI();
end;

procedure Tform_Main.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose:= not FEditing;
end;

procedure Tform_Main.FormCreate(Sender: TObject);
begin
  FAppPath:= CobGetAppPath();
  GetLocaleFormatSettings(LOCALE_SYSTEM_DEFAULT, FS);
  FFileName:= CobSetBackSlash(FAppPath) + Format(S_VERSIONSFILE,[S_APPNAME],FS);
  FFlag:= CobSetBackSlash(FAppPath) + Format(S_FLAG,[S_APPNAME],FS);
  FLogName:= CobSetBackSlash(FAppPath) + Format(S_LOG,[S_APPNAME], FS);
  FSec:= CobGetNullDaclAttributes(p);
  if (CobIs2000orBetter()) then
    FMutex:= CreateMutex(@FSec, false, PChar(Format(S_MUTEXNAME,[S_APPNAME],FS))) else
    FMutex:= CreateMutex(@FSec, false, PChar(Format(S_MUTEXNAMEOLD,[S_APPNAME],FS)));
  FBlob:= TStringList.Create();
  FElement:= TAVElement.Create();
  FirstTime:= true;
  FEditing:= false;
end;

procedure Tform_Main.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FElement);
  FreeAndNil(FBlob);
  if (FMutex <> 0) then
    CloseHandle(FMutex);
  CobFreeNullDaclAttributes(p);
end;

procedure Tform_Main.FormShow(Sender: TObject);
begin
  if (FirstTime) then
  begin
    LoadList();
    DisplayList();
    if (lb_Applications.Items.Count > 0) then
    begin
      lb_Applications.ItemIndex := 0;
      lb_Applications.Selected[0]:= true;
      DisplayItem(0);
    end;
    FirstTime:= false;
  end;
end;

function Tform_Main.GetElementByName(const AName: string): string;
var
  i: integer;
  ANameUp: string;
begin
  Result:= S_NIL;

  if (AName = S_NIL) then
    Exit;

  ANameUp:= UpperCase(AName);
  
  for i:= 0 to FBlob.Count - 1 do
    if FElement.StrToElement(FBlob[i]) then
    begin
      if (UpperCase(FElement.App) = ANameUp) then
      begin
        Result:= FBlob[i];
        Break;
      end;
    end;
end;

procedure Tform_Main.lb_ApplicationsClick(Sender: TObject);
begin
  DisplayItem(lb_Applications.ItemIndex);
end;

procedure Tform_Main.LoadList();
begin
  if (WaitForSingleObject(FMutex, INFINITE) = WAIT_OBJECT_0) then
  try
    if (not FileExists(FFileName)) then
      CobCreateEmptyTextFile(FFileName);
    FBlob.Clear();
    FBlob.LoadFromFile(FFileName);
  finally
    ReleaseMutex(FMutex);
  end;
end;

procedure Tform_Main.m_AboutClick(Sender: TObject);
begin
  ShowMessage(S_COPYRIGHT);
end;

procedure Tform_Main.m_AddClick(Sender: TObject);
var
  AName: string;
begin
  if (InputQuery(S_APPNAME,S_APPNAMEENTER,AName)) then
    if (AName <> S_NIL) then
    begin
      if (NameExists(AName) = -1) then
      begin
        AddAnItem(AName, S_10, S_NIL, S_NIL);
        SaveList();
        ClearUI();
        DisplayList();
        SelectApplication(AName);
        DisplayItem(lb_Applications.ItemIndex);
      end else
      ShowMessage(S_APPNAMEUNIQUE);
    end else
    ShowMessage(S_APPNAMEEMPTY);
end;

procedure Tform_Main.m_DeleteClick(Sender: TObject);
var
  i: integer;
begin
  if (lb_Applications.SelCount > 0) then
    if (CobMessageDlg(S_DELETESELECTED, mtConfirmation, mbOKCancel, 0, mbCancel) = mrOK) then
    begin
      for i:= lb_Applications.Items.Count-1 downto 0 do
        if (lb_Applications.Selected[i]) then
          FBlob.Delete(i);
      SaveList();
      ClearUI();
      DisplayList();

      if (lb_Applications.Items.Count > 0) then
      begin
        lb_Applications.Selected[0]:= true;
        lb_Applications.ItemIndex:= 0;
        DisplayItem(0);
        CheckUI();
      end;
    end;
end;

procedure Tform_Main.m_EditClick(Sender: TObject);
begin
  if (not FEditing) then
    if (lb_Applications.ItemIndex >= 0) and
       (lb_Applications.ItemIndex < lb_Applications.Items.Count) then
    begin
      FEditing:= true;
      CheckUI();
    end;
end;

procedure Tform_Main.m_LogClick(Sender: TObject);
begin
  if (FileExists(FLogName)) then
    ShellExecute(0,'open',PChar(FLogName),nil,nil,SW_SHOWNORMAL);
end;

procedure Tform_Main.m_PopPopup(Sender: TObject);
begin
  m_Add.Enabled:= not FEditing;
  m_Edit.Enabled:= not FEditing and (lb_Applications.SelCount > 0);
  m_Delete.Enabled:= not FEditing and (lb_Applications.SelCount > 0);
end;

function Tform_Main.NameExists(const AName: string): integer;
var
  i: integer;
  ANameUp: string;
begin
  Result:= -1;
  ANameUp:= UpperCase(AName);
  for i:= 0 to FBlob.Count - 1 do
  begin
    FElement.StrToElement(FBlob[i]);
    if (UpperCase(FElement.App) = ANameUp) then
    begin
      Result:= i;
      Break;
    end;
  end;
end;

procedure Tform_Main.SaveList();
begin
  if (WaitForSingleObject(FMutex, INFINITE) = WAIT_OBJECT_0) then
  try
    FBlob.SaveToFile(FFileName);
  finally
    ReleaseMutex(FMutex);
  end;
end;

procedure Tform_Main.SelectApplication(const AName: string);
var
  i: integer;
  ANameUp: string;
begin
  ANameUp:= UpperCase(AName);
  for i:=0 to lb_Applications.Items.Count -1 do
  begin
    if (UpperCase(lb_Applications.Items[i]) = ANameUp) then
    begin
      lb_Applications.ItemIndex:= i;
      lb_Applications.Selected[i]:= true;
      Break;
    end;
  end;
end;

procedure Tform_Main.SetFlag();
begin
  if (not FileExists(FFlag)) then
    CobCreateEmptyTextFile(FFlag);
end;

end.
