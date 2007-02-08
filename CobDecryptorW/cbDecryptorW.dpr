
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

// This dll implements decryption and key operations. It can be called from
// the user interface OR from the stand-alone decryptor

library cbDecryptorW;

uses
  SysUtils,
  Classes,
  Forms,
  TntForms,
  Windows,
  decryptor_Main in 'decryptor_Main.pas' {form_MainForm},
  bmTranslator in '..\Common\bmTranslator.pas',
  bmConstants in '..\Common\bmConstants.pas',
  bmCustomize in '..\Common\bmCustomize.pas',
  decryptor_Strings in 'decryptor_Strings.pas',
  decryptor_KeysGenerator in 'decryptor_KeysGenerator.pas',
  decryptor_Decryptor in 'decryptor_Decryptor.pas',
  bmCommon in '..\Common\bmCommon.pas';

{$R *.res}
function MainEntry(const pAppPath, pLanguage: PWideChar;
                   const bShowErrorsOnly: LongBool;
                   const iParentHandle: cardinal): cardinal; stdcall;
var
  AParentHandle: cardinal;
begin
  AParentHandle:= iParentHandle;

  if AParentHandle = 0 then
    AParentHandle := GetActiveWindow();

  Application.Handle := AParentHandle;
 
  try
    form_MainForm := Tform_MainForm.Create(Application);
    try
      if (pAppPath <> nil) then
        form_MainForm.AppPath:= WideString(pAppPath);

      if (pLanguage <> nil) then
        form_MainForm.Language:= WideString(pLanguage);

      form_MainForm.ShowModal();

      Result := form_MainForm.Errors;
    finally
      Application.Handle := 0; //There is a problem on XP with the Z position
      FreeAndNil(form_MainForm);
    end;
  except
    on E: Exception do
    begin
      Result := INT_MODALRESULTEXCEPTION;
      Application.HandleException(E);
    end;
  end;
end;

exports MainEntry;

begin
end.
