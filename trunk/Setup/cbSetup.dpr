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

// The installer

program cbSetup;

uses
  Forms,
  setup_Main in 'setup_Main.pas' {form_Main},
  bmCustomize in '..\Common\bmCustomize.pas',
  bmConstants in '..\Common\bmConstants.pas',
  setup_Serial in 'setup_Serial.pas' {form_Serial},
  setup_Constants in 'setup_Constants.pas',
  setup_Extractor in 'setup_Extractor.pas' {form_Extractor},
  bmTranslator in '..\Common\bmTranslator.pas',
  setup_Languages in 'setup_Languages.pas' {form_Languages},
  bmCommon in '..\Common\bmCommon.pas',
  CobCommonW, Windows, ShellApi;

{$R *.res}

begin
  if (not CobIsNTBasedW(false)) then   //hard coded
  begin
    if (MessageBoxA(0,PAnsiChar(SS_NEEDNT),PAnsiChar(SS_CANNOTCONTINUE),MB_YESNO) = idYes) then //USe ansi on 9x
      ShellExecuteA(0, 'open', PAnsiChar(AnsiString(WS_PROGRAMWEB)), nil, nil, SW_SHOWNORMAL);
    Exit;
  end;
  Application.Initialize;
  Application.ShowMainForm:= false;
  Application.CreateForm(Tform_Main, form_Main);
  Application.Run;
end.
