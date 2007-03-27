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

// Application for the decompressor

program cbDecompressor;

uses
  Forms,
  decompressor_Main in 'decompressor_Main.pas' {form_Main},
  bmCustomize in '..\Common\bmCustomize.pas',
  bmCommon in '..\Common\bmCommon.pas',
  bmConstants in '..\Common\bmConstants.pas',
  bmTranslator in '..\Common\bmTranslator.pas',
  decompressor_Constants in 'decompressor_Constants.pas',
  decompressor_MessageBoxEx in 'decompressor_MessageBoxEx.pas' {form_MessageBoxEx},
  decompressor_Password in 'decompressor_Password.pas' {form_Password},
  decompressor_About in 'decompressor_About.pas' {form_About};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(Tform_Main, form_Main);
  Application.Run;
end.
