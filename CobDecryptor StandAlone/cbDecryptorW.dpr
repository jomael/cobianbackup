

{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~                                                            ~~~~~~~~~~
~~~~~~~~~~               Cobian Backup Black Moon                     ~~~~~~~~~~
~~~~~~~~~~           Copyright 2000-2006 by Luis Cobian               ~~~~~~~~~~
~~~~~~~~~~                     cobian@educ.umu.se                     ~~~~~~~~~~
~~~~~~~~~~                    All rights reserved                     ~~~~~~~~~~
~~~~~~~~~~                                                            ~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

{The application of the stand alone decryptor}

program cbDecryptorW;
uses
  Forms,
  TntForms,
  bmCommon in '..\Common\bmCommon.pas',
  bmCustomize in '..\Common\bmCustomize.pas',
  bmConstants in '..\Common\bmConstants.pas',
  unit_MainForm in 'unit_MainForm.pas' {form_Main};

{$R *.res}

begin
  Application.Initialize;
  TntApplication.Title := WS_PROGRAMNAMELONG;
  Application.ShowMainForm:= false;
  Application.CreateForm(Tform_Main, form_Main);
  Application.Run;
end.


