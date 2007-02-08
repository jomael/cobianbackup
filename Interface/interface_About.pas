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

// The about box

unit interface_About;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TntForms, jpeg, ExtCtrls, TntExtCtrls, StdCtrls, TntStdCtrls;

type
  Tform_About = class(TTntForm)
    img_About: TTntImage;
    l_ProgramName: TTntLabel;
    l_CodeName: TTntLabel;
    l_Version: TTntLabel;
    l_Copyright: TTntLabel;
    l_Mail: TTntLabel;
    l_Web: TTntLabel;
    l_BasedOn: TTntLabel;
    l_Language: TTntLabel;
    l_TranslatorName: TTntLabel;
    l_TranslatorMail: TTntLabel;
    bevel_Horizontal: TTntBevel;
    procedure l_TranslatorMailClick(Sender: TObject);
    procedure l_WebClick(Sender: TObject);
    procedure l_MailClick(Sender: TObject);
    procedure TntFormShow(Sender: TObject);
    procedure TntFormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure TntFormCreate(Sender: TObject);
  private
    { Private declarations }
    FS: TFormatSettings;
    FFirstTime: boolean;
    FTranslatorMail: WideString;
    procedure LoadStrings();
    procedure CheckVisibility();
  public
    { Public declarations }
  end;

var
  form_About: Tform_About;

implementation

uses bmCustomize, CobCommonW, bmTranslator, bmCommon, ShellApi, bmConstants;

{$R *.dfm}

procedure Tform_About.CheckVisibility();
begin
  l_CodeName.Visible:= not BOOL_CUSTOMIZED;
  l_BasedOn.Visible:= BOOL_CUSTOMIZED and BOOL_SHOWBASEDON;
end;

procedure Tform_About.LoadStrings();
begin
  Caption:= WideFormat(Translator.GetMessage('23'),[WS_PROGRAMNAMESHORT],FS);
  l_ProgramName.Caption:= WS_PROGRAMNAMEGENERIC;
  l_CodeName.Caption:= WS_CODENAME;
  l_Version.Caption:= CobGetVersionW(WS_NIL);
  l_Copyright.Caption:= WideFormat(WS_COPYRIGHT,[WS_AUTHORLONG],FS);
  l_Web.Caption:= WS_AUTHORWEB;
  l_Mail.Caption:= WS_AUTHORMAIL;
  l_BasedOn.Caption:= WideFormat(Translator.GetMessage('19'),[WS_PROGRAMNAMESHORT], FS);
  l_Language.Caption:= WideFormat(Translator.GetMessage('20'),[Settings.GetLanguage],FS);
  l_TranslatorName.Caption:= WideFormat(Translator.GetMessage('21'),
                            [Translator.GetInterfaceText('S_TRANSLATOR')], FS);
  FTranslatorMail:= Translator.GetInterfaceText('S_TRANSLATORMAIL');
  l_TranslatorMail.Caption:= WideFormat(Translator.GetMessage('22'),
                            [FTranslatorMail], FS);
end;

procedure Tform_About.l_MailClick(Sender: TObject);
begin
  ShellExecuteW(handle,'open',PWideChar(WideFormat(WS_MAILTO,[WS_AUTHORMAIL],FS)),
                nil, nil, SW_SHOWNORMAL);
end;

procedure Tform_About.l_TranslatorMailClick(Sender: TObject);
begin
  ShellExecuteW(handle,'open',PWideChar(WideFormat(WS_MAILTO,[FTranslatorMail],FS)),
                nil, nil, SW_SHOWNORMAL);
end;

procedure Tform_About.l_WebClick(Sender: TObject);
begin
  ShellExecuteW(handle,'open',PWideChar(WS_AUTHORWEB),
                nil, nil, SW_SHOWNORMAL);
end;

procedure Tform_About.TntFormCreate(Sender: TObject);
begin
  // Do not change the fonts on this form
  GetLocaleFormatSettings(LOCALE_USER_DEFAULT, FS);
  FFirstTime:= true;
  LoadStrings();
end;

procedure Tform_About.TntFormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_ESCAPE) or (Key = VK_RETURN) then
    Close();
end;

procedure Tform_About.TntFormShow(Sender: TObject);
begin
  if (FFirstTime) then
  begin
    CheckVisibility();
    FFirstTime:= false;
  end;
end;

end.
