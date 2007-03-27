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

// unit that shows the property of the selected backups

unit interface_Backup;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TntForms, ComCtrls, TntComCtrls, bmCommon, ImgList, TntClasses,
  Menus, TntMenus;

type
  Tform_Backup = class(TTntForm)
    lv_Backup: TTntListView;
    il_Backup: TImageList;
    pop_Backup: TTntPopupMenu;
    m_Open: TTntMenuItem;
    m_Open_Directory: TTntMenuItem;
    procedure TntFormClose(Sender: TObject; var Action: TCloseAction);
    procedure lv_BackupKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure m_Open_DirectoryClick(Sender: TObject);
    procedure m_OpenClick(Sender: TObject);
    procedure pop_BackupPopup(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FFirstTime: boolean;
    FTools: TCobTools;
    FS: TFormatSettings;
    procedure GetInterfaceText();
    procedure PopulateList();
    procedure GetPosition();
    procedure SetPosition();
    function BackupTypeToHuman(const Kind: integer): WideString;
    function ScheduleTypeToHuman(const Kind: integer): WideString;
    function CompressionToHuman(const Value: integer): WideString;
    function EncryptionToHuman(const Value: integer): WideString;
    function SplitToHuman(const Value: integer): WideString;
    function BoolToHuman(const Bool: boolean): WideString;
  public
    { Public declarations }
    Backup: TBackup;
  end;

implementation

uses bmConstants, bmTranslator, interface_Common, ShellApi, TntSysUtils;

{$R *.dfm}

function Tform_Backup.BackupTypeToHuman(const Kind: integer): WideString;
begin
  case Kind of
    INT_BUINCREMENTAL: Result:= Translator.GetMessage('93');
    INT_BUDIFFERENTIAL: Result:= Translator.GetMessage('94');
    INT_BUDUMMY: Result:= Translator.GetMessage('95');
  else
    Result:= Translator.GetMessage('92');
  end;
end;

function Tform_Backup.BoolToHuman(const Bool: boolean): WideString;
begin
  Result:= Translator.GetMessage('S_NO');
  if (Bool) then
    Result:= Translator.GetMessage('S_YES');
end;

function Tform_Backup.CompressionToHuman(const Value: integer): WideString;
begin
  case Value of
    INT_COMPZIP: Result:= Translator.GetInterfaceText('148');
    INT_COMP7ZIP: Result:= Translator.GetInterfaceText('149');
    else
    Result:= Translator.GetInterfaceText('147');
  end;
end;

function Tform_Backup.EncryptionToHuman(const Value: integer): WideString;
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

procedure Tform_Backup.FormCreate(Sender: TObject);
begin
  FFirstTime:= true;
  Font.Name:= UISettings.FontName;
  Font.Size:= UISettings.FontSize;
  Font.Charset:= UISettings.FontCharset;
  ShowHint:= UISettings.ShowHints;
  FTools:= TCobTools.Create();
  lv_Backup.GridLines:= UISettings.ShowGrid;
  GetLocaleFormatSettings(LOCALE_USER_DEFAULT, FS);
end;

procedure Tform_Backup.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FTools);
end;

procedure Tform_Backup.FormShow(Sender: TObject);
begin
  if (FFirstTime) then
  begin
    GetInterfaceText();
    GetPosition();
    PopulateList();
    FFirstTime:= false;
  end;
end;

procedure Tform_Backup.GetInterfaceText();
begin
  Caption:= Translator.GetInterfaceText('598');
  lv_Backup.Columns[0].Caption:= Translator.GetInterfaceText('367');
  lv_Backup.Columns[1].Caption:= Translator.GetInterfaceText('368');
  m_Open.Caption:= Translator.GetInterfaceText('608');
  m_Open_Directory.Caption:= Translator.GetInterfaceText('609');
end;

procedure Tform_Backup.GetPosition();
begin
  Left:= UISettings.BackupLeft;
  Top:= UISettings.BackupTop;
  Width:= UISettings.BackupWidth;
  Height:= UISettings.BackupHeight;
  lv_Backup.Columns[0].Width:= UISettings.BackupColumn0;
  lv_Backup.Columns[1].Width:= UISettings.BackupColumn1;
end;

procedure Tform_Backup.lv_BackupKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_RETURN) then
    m_OpenClick(self);
end;

procedure Tform_Backup.m_OpenClick(Sender: TObject);
begin
  if (lv_Backup.Selected <> nil) then
    if (lv_Backup.Selected.ImageIndex < 2) then
       ShellExecuteW(0,'open',PWideChar(lv_Backup.Selected.SubItems[0]),nil, nil, SW_SHOWNORMAL);
end;

procedure Tform_Backup.m_Open_DirectoryClick(Sender: TObject);
begin
  if (lv_Backup.Selected <> nil) then
    if (lv_Backup.Selected.ImageIndex < 2) then
      ShellExecuteW(0,'open',
          PWideChar(WideExtractFilePath(lv_Backup.Selected.SubItems[0])),
          nil, nil, SW_SHOWNORMAL);
end;

procedure Tform_Backup.PopulateList();
var
  Item: TTntListItem;
  Sl, Sll: TTntStringList;
  i, j, Kind: integer;
  AItem: WideString;
  FTP: TFTPAddress;
begin
  lv_Backup.Clear();

  Item:= lv_Backup.Items.Add();
  Item.Caption:= Translator.GetInterfaceText('599');
  Item.SubItems.Add(Backup.FBackupID);
  Item.ImageIndex:= 3;

  Item:= lv_Backup.Items.Add();
  Item.Caption:= Translator.GetInterfaceText('600');
  Item.SubItems.Add(Backup.FTaskID);
  Item.ImageIndex:= 3;

  Item:= lv_Backup.Items.Add();
  Item.Caption:= Translator.GetInterfaceText('601');
  Item.SubItems.Add(Backup.FParentID);
  Item.ImageIndex:= 3;

  Sl:= TTntStringList.Create();
  try
    Sl.CommaText:= Backup.FSource;
    for i:=0 to Sl.Count-1 do
    begin
      AItem:= FTools.DecodeSD(Sl[i], Kind);
      Item:= lv_Backup.Items.Add();
      Item.Caption:= Translator.GetInterfaceText('602');
      Item.SubItems.Add(AItem);
      Item.ImageIndex:= Kind;

      if (Kind = INT_SDFTP) then
      begin
        FTP:= TFTPAddress.Create();
        try
          FTP.DecodeAddress(AItem);
          Item.SubItems[0]:= FTP.EncodeAddressDisplay();
        finally
          FreeAndNil(FTP);
        end;
      end;
    end;
  finally
    
    FreeAndNil(Sl);
  end;

  //Only one destination is posible
  AItem:= FTools.DecodeSD(Backup.FDestination, Kind);
  Item:= lv_Backup.Items.Add();
  Item.Caption:= Translator.GetInterfaceText('603');
  Item.SubItems.Add(AItem);
  Item.ImageIndex:= Kind;

  if (Kind = INT_SDFTP) then
  begin
    FTP:= TFTPAddress.Create();
    try
      FTP.DecodeAddress(AItem);
      Item.SubItems[0]:= FTP.EncodeAddressDisplay();
    finally
      FreeAndNil(FTP);
    end;
  end;


  Item:= lv_Backup.Items.Add();
  Item.Caption:= Translator.GetMessage('91');
  Item.SubItems.Add(BackupTypeToHuman(Backup.FBackupType));
  Item.ImageIndex:= 3;

  Item:= lv_Backup.Items.Add();
  Item.Caption:= Translator.GetMessage('100');
  Item.SubItems.Add(ScheduleTypeToHuman(Backup.FScheduleType));
  Item.ImageIndex:= 3;

  Item:= lv_Backup.Items.Add();
  Item.Caption:= Translator.GetMessage('114');
  Item.SubItems.Add(CompressionToHuman(Backup.FCompressed));
  Item.ImageIndex:= 3;

  Item:= lv_Backup.Items.Add();
  Item.Caption:= Translator.GetMessage('119');
  Item.SubItems.Add(EncryptionToHuman(Backup.FEncrypted));
  Item.ImageIndex:= 3;

  if (Backup.FCompressed <> INT_COMPNOCOMP) then
  begin
    Item:= lv_Backup.Items.Add();
    Item.Caption:= Translator.GetMessage('116');
    Item.SubItems.Add(SplitToHuman(Backup.FSplit));
    Item.ImageIndex:= 3;
    if (True) then
    
  end;

  Item:= lv_Backup.Items.Add();
  Item.Caption:= Translator.GetInterfaceText('604');
  Item.SubItems.Add(BoolToHuman(Backup.FParked));
  Item.ImageIndex:= 3;

  Item:= lv_Backup.Items.Add();
  Item.Caption:= Translator.GetInterfaceText('605');
  Item.SubItems.Add(WideString(DateTimeToStr(Backup.FDateTime, FS)));
  Item.ImageIndex:= 3;

  Item:= lv_Backup.Items.Add();
  Item.Caption:= Translator.GetInterfaceText('606');
  Item.SubItems.Add(WideString(DateTimeToStr(Backup.FNextDateTime, FS)));
  Item.ImageIndex:= 3;

  if (Kind = INT_SDFTP) then
  begin
    // This is a special case because the files are double
    // comma separated
    Sl:= TTntStringList.Create();
    Sll:= TTntStringList.Create();
    try
      Sl.CommaText:= Backup.FFiles;
      for i:= 0 to Sl.Count - 1 do
      begin
        Sll.CommaText:= Sl[i];
        for j:=0 to Sll.Count - 1 do
        begin
          AItem:= FTools.DecodeSD(Sll[j], Kind);
          Item:= lv_Backup.Items.Add();
          Item.Caption:= Translator.GetInterfaceText('607');
          Item.SubItems.Add(AItem);
          Item.ImageIndex:= 2; // FTP icon
        end;
      end;
    finally
      FreeAndNil(Sll);
      FreeAndNil(Sl);
    end;
  end else
  begin
    Sl:= TTntStringList.Create();
    try
      Sl.CommaText:= Backup.FFiles;
      for i:= 0 to Sl.Count - 1 do
      begin
        AItem:= FTools.DecodeSD(Sl[i], Kind);
        Item:= lv_Backup.Items.Add();
        Item.Caption:= Translator.GetInterfaceText('607');
        Item.SubItems.Add(AItem);
        Item.ImageIndex:= Kind;
      end;
    finally
      FreeAndNil(Sl);
    end;
  end;
end;

procedure Tform_Backup.pop_BackupPopup(Sender: TObject);
begin
  m_Open.Enabled:= (lv_Backup.SelCount > 0) and (lv_Backup.Selected.ImageIndex < 2);
  m_Open_Directory.Enabled:= (lv_Backup.SelCount > 0) and (lv_Backup.Selected.ImageIndex < 2);
end;

function Tform_Backup.ScheduleTypeToHuman(const Kind: integer): WideString;
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

procedure Tform_Backup.SetPosition();
begin
  UISettings.BackupLeft:= Left;
  UISettings.BackupTop:= Top;
  UISettings.BackupWidth:= Width;
  UISettings.BackupHeight:= Height;
  UISettings.BackupColumn0:= lv_Backup.Columns[0].Width;
  UISettings.BackupColumn1:= lv_Backup.Columns[1].Width;
end;

function Tform_Backup.SplitToHuman(const Value: integer): WideString;
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

procedure Tform_Backup.TntFormClose(Sender: TObject; var Action: TCloseAction);
begin
  SetPosition();
end;

end.
