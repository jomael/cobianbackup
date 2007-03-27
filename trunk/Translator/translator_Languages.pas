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

// Dialog box to show and select the available languages

unit translator_Languages;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TntForms, StdCtrls, TntStdCtrls;

type
  Tform_Languages = class(TTntForm)
    l_New: TTntLabel;
    e_New: TTntEdit;
    l_Old: TTntLabel;
    cb_Old: TTntComboBox;
    b_OK: TTntButton;
    b_Cancel: TTntButton;
    procedure b_OKClick(Sender: TObject);
    procedure b_CancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FS: TFormatSettings;
    procedure CheckUI();
    procedure LoadLanguages();
    function ValidateForm(): boolean;
  public
    { Public declarations }
    IsNew: boolean;
    LanguagePath: WideString;
  end;

implementation

{$R *.dfm}

{ Tform_Languages }
uses TntSysutils, translator_Constants, bmConstants, CobDialogsW, bmCustomize,
     CobCommonW;

procedure Tform_Languages.b_CancelClick(Sender: TObject);
begin
  Tag:= INT_MODALRESULTCANCEL;
  Close();
end;

procedure Tform_Languages.b_OKClick(Sender: TObject);
begin
  if (ValidateForm()) then
  begin
      Tag:= INT_MODALRESULTOK;
      Close();
  end;
end;

procedure Tform_Languages.CheckUI();
begin
  // IsNew is set by the caller
  l_New.Enabled:= IsNew;
  e_New.Enabled:= IsNew;
  LoadLanguages();
  l_Old.Enabled:= not IsNew;
  cb_Old.Enabled:= not IsNew;
end;

procedure Tform_Languages.FormCreate(Sender: TObject);
begin
  Tag:= INT_MODALRESULTCANCEL;
  GetLocaleFormatSettings(LOCALE_SYSTEM_DEFAULT, FS);
end;

procedure Tform_Languages.FormShow(Sender: TObject);
begin
  CheckUI();
  if (IsNew) then
    e_New.SetFocus() else
    cb_Old.SetFocus();
end;

procedure Tform_Languages.LoadLanguages();
var
  SR: TSearchRecW;
  //********************************************************
  procedure AddToList();
  begin
    if (WideLowerCase(SR.Name) <> TS_ENGLISTCUI) then
      cb_Old.Items.Add(WideChangeFileExt(SR.Name, WS_NIL));
  end;
  //********************************************************
begin
  cb_Old.Clear();
  if (WideFindFirst(LanguagePath + TS_ALLCUI, faAnyFile, SR) = 0) then
  begin
    AddToList();
    while (WideFindNext(SR) = 0) do
      AddToList();
    WideFindClose(SR);
  end;

  if (cb_Old.Items.Count > 0) then
    cb_Old.ItemIndex:= 0;
end;

function Tform_Languages.ValidateForm(): boolean;
var
  Cui, Cms: WideString;
begin
  Result:= true;
  if (IsNew) then
  begin
    Cui:= LanguagePath + e_New.Text + WS_UIEXTENSION;
    Cms:= LanguagePath + e_New.Text + WS_MSGEXTENSION;
    if (WideFileExists(Cui) or WideFileExists(Cms)) then
    begin
      if (CobMessageBoxW(self.Handle,
                        WideFormat(TS_LANGUAGEEXISTS,[e_New.Text],FS),
                        WS_PROGRAMNAMESHORT, MB_YESNO) = mrNo) then
      begin
        e_New.SetFocus();
        Result:= false;
        Exit;
      end;
    end;

    if (not CobCreateEmptyTextFileW(Cui)) then
    begin
      CobShowMessageW(self.Handle,
                      WideFormat(TS_CANNOTCREATEFILE,[Cui], FS),
                      WS_PROGRAMNAMESHORT);
      e_New.SetFocus();
      Result:= false;
      Exit;
    end;

    if (not CobCreateEmptyTextFileW(Cms)) then
    begin
      CobShowMessageW(self.Handle,
                      WideFormat(TS_CANNOTCREATEFILE,[Cms], FS),
                      WS_PROGRAMNAMESHORT);
      e_New.SetFocus();
      Result:= false;
      Exit;
    end;
    
  end else
  begin
    if (cb_Old.ItemIndex < 0) then
    begin
      CobShowMessageW(self.Handle, TS_NOTSELECTED, WS_PROGRAMNAMESHORT);
      cb_Old.SetFocus();
      Result:= false;
      Exit;
    end;
  end;
end;

end.
