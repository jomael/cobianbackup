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

// Dialog that shows the installed services and their status

unit interface_Services;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TntForms, StdCtrls, TntStdCtrls, ExtCtrls, TntExtCtrls, ComCtrls,
  TntComCtrls, ImgList, bmConstants;

type
  Tform_Services = class(TTntForm)
    p_Bottom: TTntPanel;
    p_Top: TTntPanel;
    b_OK: TTntButton;
    b_Cancel: TTntButton;
    lv_Services: TTntListView;
    img_List: TImageList;
    procedure TntFormClose(Sender: TObject; var Action: TCloseAction);
    procedure TntFormResize(Sender: TObject);
    procedure lv_ServicesDblClick(Sender: TObject);
    procedure b_OKClick(Sender: TObject);
    procedure lv_ServicesClick(Sender: TObject);
    procedure b_CancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FirstTime: boolean;
    FShowIcons: boolean;
    procedure LoadInterfaceText();
    procedure PopulateList();
    procedure DecodeList(const TheList: WideString);
    procedure GetPosition();
    procedure SetPosition();
  public
    { Public declarations }
    FSName: WideString;
    FToStart: boolean;
  end;

implementation

uses bmTranslator, bmCustomize, bmCommon, TntClasses,
  interface_Common;

{$R *.dfm}


procedure Tform_Services.b_CancelClick(Sender: TObject);
begin
  FSName:= WS_NIL;
  Tag:= INT_MODALRESULTCANCEL;
  Close;
end;

procedure Tform_Services.b_OKClick(Sender: TObject);
begin
  if (lv_Services.Selected <> nil) then
  begin
    FSName:= lv_Services.Selected.Caption;
    Tag:= INT_MODALRESULTOK;
    Close;
  end;
end;

procedure Tform_Services.DecodeList(const TheList: WideString);
var
  Sl, Sll: TTntStringList;
  i: integer;
  Item: TTntListItem;
  Status: WideString;
begin
  if (FShowIcons) then
    lv_Services.SmallImages:= img_List else
    lv_Services.SmallImages:= nil;

  Sl:= TTntStringList.Create();
  Sll:= TTntStringList.Create();
  try
    Sl.CommaText:= TheList;
    for i:=0 to Sl.Count-1 do
      begin
        Sll.CommaText:= Sl[i];
        if (Sll.Count = 3) then
        begin
          Item:= lv_Services.Items.Add();
          Item.Caption:= Sll[0];
          Item.SubItems.Add(Sll[1]);
          if (Sll[2] = WS_RUNNING) then
            begin
              Status:= Translator.GetMessage('43');
              Item.ImageIndex:= INT_INDEXRUNNING;
            end else
          if (Sll[2] = WS_STOPPED) then
            begin
              Status:= Translator.GetMessage('44');
              Item.ImageIndex:= INT_INDEXSTOPPED;
            end else
          if (Sll[2] = WS_PAUSED) then
            begin
              Status:= Translator.GetMessage('45');
              Item.ImageIndex:= INT_INDEXPAUSED;
            end else
            begin
              Status:= Translator.GetMessage('46');
              Item.ImageIndex:= INT_INDEXUNKNOWN;
            end;
          Item.SubItems.Add(Status);
        end;
      end;
  finally
    FreeAndNil(Sll);
    FreeAndNil(Sl);
  end;
end;

procedure Tform_Services.FormCreate(Sender: TObject);
begin
  Tag:= INT_MODALRESULTCANCEL;
  FirstTime:= true;
  ShowHint:= UISettings.ShowHints;
  Font.Name:= UISettings.FontName;
  Font.Size:= UISettings.FontSize;
  Font.Charset:= UISettings.FontCharset;
  FShowIcons:= UISettings.ShowIcons;
  lv_Services.GridLines:= UISettings.ShowGrid;
end;

procedure Tform_Services.FormShow(Sender: TObject);
begin
  if (FirstTime) then
  begin
    LoadInterfaceText();
    b_OK.Enabled:= false;
    PopulateList();
    GetPosition();
    FirstTime:= false;
  end;
end;

procedure Tform_Services.GetPosition();
begin
  Width:= UISettings.ServiceWidth;
  Height:= UISettings.ServiceHeight;
  Left:= UISettings.ServiceLeft;
  Top:= UISettings.ServiceTop;
  lv_Services.Columns[0].Width:= UISettings.ServiceColumn0;
  lv_Services.Columns[1].Width:= UISettings.ServiceColumn1;
  lv_Services.Columns[2].Width:= UISettings.ServiceColumn2;
end;

procedure Tform_Services.LoadInterfaceText();
begin
  if (FToStart) then
    Caption:= Translator.GetInterfaceText('241') else
    Caption:= Translator.GetInterfaceText('245');
  lv_Services.Columns[0].Caption:= Translator.GetInterfaceText('242');
  lv_Services.Columns[1].Caption:= Translator.GetInterfaceText('243');
  lv_Services.Columns[2].Caption:= Translator.GetInterfaceText('244');
  b_OK.Caption:= Translator.GetInterfaceText('B_OK');
  b_Cancel.Caption:= Translator.GetInterfaceText('B_CANCEL');
end;

procedure Tform_Services.lv_ServicesClick(Sender: TObject);
begin
  b_OK.Enabled:= lv_Services.SelCount > 0;
end;

procedure Tform_Services.lv_ServicesDblClick(Sender: TObject);
begin
  b_OKClick(lv_Services);
end;

procedure Tform_Services.PopulateList();
var
  dll: THandle;
  GetList: function (const ServiceL: PWideChar; var Size: longint): longint; stdcall;
  ASize: longint;
  TheList: WideString;
begin
  dll:= LoadLibraryW(PWideChar(Globals.AppPath + WS_COBNTW));
  if (dll <> 0) then
  begin
    @GetList:= GetProcAddress(dll,S_GETSERVICELIST);
    if (@GetList <> nil) then
    begin
      GetList(nil,ASize);
      SetLength(TheList, ASize + 1);
      if (GetList(PWideChar(TheList),ASize) = 0) then
        TheList:= WS_NIL;
    end;
    FreeLibrary(dll);
  end;

  if (TheList <> WS_NIL) then
    DecodeList(TheList);
end;

procedure Tform_Services.SetPosition();
begin
  UISettings.ServiceWidth:= Width;
  UISettings.ServiceHeight:= Height;
  UISettings.ServiceLeft:= Left;
  UISettings.ServiceTop:= Top;
  UISettings.ServiceColumn0:= lv_Services.Columns[0].Width;
  UISettings.ServiceColumn1:= lv_Services.Columns[1].Width;
  UISettings.ServiceColumn2:= lv_Services.Columns[2].Width;
end;

procedure Tform_Services.TntFormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SetPosition();
end;

procedure Tform_Services.TntFormResize(Sender: TObject);
begin
  b_Cancel.Left:= (Width div 2) + 50;
  b_OK.Left:= (Width div 2) - (b_OK.Width) - 50;
end;

end.
