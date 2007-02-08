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

// Application for the Translator

program cbTranslator;

uses
  Forms,
  translator_Main in 'translator_Main.pas' {form_Translator},
  bmConstants in '..\Common\bmConstants.pas',
  bmCommon in '..\Common\bmCommon.pas',
  translator_Constants in 'translator_Constants.pas',
  bmCustomize in '..\Common\bmCustomize.pas',
  translator_Languages in 'translator_Languages.pas' {form_Languages},
  translator_Search in 'translator_Search.pas' {form_Search},
  translator_About in 'translator_About.pas' {form_About};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(Tform_Translator, form_Translator);
  Application.Run;
end.
