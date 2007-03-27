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

// Shows a list with the available languages

unit setup_Languages;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TntForms, StdCtrls, TntStdCtrls, jpeg, ExtCtrls, TntExtCtrls,
  TntSysUtils;


const
  INT_AFTERSHOW = WM_USER + 6729;

type
  Tform_Languages = class(TTntForm)
    i_Flags: TTntImage;
    l_SelectLanguage: TTntLabel;
    l_SelectLanguage2: TTntLabel;
    cb_Languages: TTntComboBox;
    b_OK: TTntButton;
    procedure FormShow(Sender: TObject);
    procedure b_OKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FFirstTime: boolean;
    procedure PopulateLanguages();
  public
    { Public declarations }
    Auto: boolean;
    InitialLanguage: WideString;
    LanguagePath: WideString;
  protected
    procedure AfterShow(var Msg: TMessage); message INT_AFTERSHOW;
  end;

implementation

uses bmCustomize, CobCommonW, bmConstants;

{$R *.dfm}

procedure Tform_Languages.AfterShow(var Msg: TMessage);
begin
  PopulateLanguages();
  if (Auto) then
    b_OK.Click();
end;

procedure Tform_Languages.b_OKClick(Sender: TObject);
begin
  Close();
end;

procedure Tform_Languages.FormCreate(Sender: TObject);
begin
  Caption:= WS_PROGRAMNAMESHORT;
  FFirstTime:= true;
end;

procedure Tform_Languages.FormShow(Sender: TObject);
begin
  if (FFirstTime) then
  begin
    PostMessageW(self.Handle, INT_AFTERSHOW, 0, 0);
    FFirstTime:= false;
  end;
end;

procedure Tform_Languages.PopulateLanguages();
var
  SR: TSearchRecW;
  Mask, Language, Stdlanguage: WideString;
  i, Index: integer;
begin
  Mask:= CobSetBackSlashW(LanguagePath) + WS_LANGUAGEMASK;
  cb_Languages.Clear();
  if (WideFindFirst(Mask, faAnyFile, SR) = 0) then
  begin
    Language:= WideUpperCase(WideChangeFileExt(SR.Name, WS_NIL));
    cb_Languages.Items.Add(Language);
    while WideFindNext(SR) = 0 do
    begin
      Language:= WideUpperCase(WideChangeFileExt(SR.Name, WS_NIL));
      cb_Languages.Items.Add(Language);
    end;
    WideFindClose(SR);
  end;

  StdLanguage:= WideUpperCase(InitialLanguage);
  Index:= -1;
  for i:= 0 to cb_Languages.Items.Count - 1 do
    if (Stdlanguage =  cb_Languages.Items[i] ) then
    begin
      Index:= i;
      Break;
    end;

  if (Index <> -1) then
    cb_Languages.ItemIndex:= Index else
    cb_Languages.ItemIndex:= cb_Languages.Items.IndexOf(WideUpperCase(WS_ENGLISH));
end;

end.
