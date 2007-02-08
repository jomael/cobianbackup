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

// User interface


program cbInterface;

uses
  Forms,
  TntForms,
  TntClasses,
  TntSysUtils,
  TntSystem,
  CobCommonW,
  Windows,
  SysUtils,
  interface_Main in 'interface_Main.pas' {form_CB8_Main},
  bmTranslator in '..\Common\bmTranslator.pas',
  bmCommon in '..\Common\bmCommon.pas',
  bmConstants in '..\Common\bmConstants.pas',
  bmCustomize in '..\Common\bmCustomize.pas',
  interface_Common in 'interface_Common.pas',
  interface_Balloon in 'interface_Balloon.pas' {form_Balloon},
  interface_LogReader in 'interface_LogReader.pas',
  interface_Options in 'interface_Options.pas' {form_Options},
  interface_Master in 'interface_Master.pas',
  interface_About in 'interface_About.pas' {form_About},
  interface_Task in 'interface_Task.pas' {form_Task},
  CobDialogsW in '..\..\CobCommons\CobDialogsW.pas',
  interface_InputBox in 'interface_InputBox.pas' {form_InputBox},
  interface_Services in 'interface_Services.pas' {form_Services},
  interface_FTP in 'interface_FTP.pas' {form_FTP},
  interface_SpecialDialog in 'interface_SpecialDialog.pas' {form_SpecialDialog},
  interface_Calculator in 'interface_Calculator.pas',
  interface_InfoReader in 'interface_InfoReader.pas',
  interface_Importer in 'interface_Importer.pas',
  bmFTP in '..\Common\bmFTP.pas',
  bmEncryptor in '..\Common\bmEncryptor.pas',
  interface_Canceler in 'interface_Canceler.pas' {form_Canceler},
  interface_Backup in 'interface_Backup.pas' {form_Backup},
  interface_Tester in 'interface_Tester.pas' {form_Tester},
  interface_Update in 'interface_Update.pas',
  interface_BackupForcer in 'interface_BackupForcer.pas',
  interface_Logon in 'interface_Logon.pas' {form_Logon};

{$R *.res}


procedure DisableProcessWindowsGhosting();
begin
  CobDisableProcessWindowsGhostingW();
end;

procedure AnalizeParams();
var
  Sl: TTntStringList;
  i,p: integer;
begin
  IsService:= false;
  Maxi := false;
  BackupAll:= false;
  ListToLoad:= WS_NIL;

  if (WideParamCount > 0) then
  begin
    Sl:= TTntStringList.Create();
    try
      for i:=1 to WideParamCount do
        Sl.Add(WideParamStr(i));

      for i:=0 to Sl.Count-1 do
        begin
          if (WideUpperCase(Sl[i]) = WS_SERVICE) or
              (WideUpperCase(Sl[i]) = WS_SERVICEALT) then
              begin
                IsService := true;
                Continue;
              end;

          if (WideUpperCase(Sl[i]) = WS_MAX) or
              (WideUpperCase(Sl[i]) = WS_MAXALT) then
              begin
                Maxi := true;
                Continue;
              end;

          if (WideUpperCase(Sl[i]) = WS_BU) or
              (WideUpperCase(Sl[i]) = WS_BUALT) then
              begin
                BackupAll := true;
                Continue;
              end;

          p := Pos(WS_LISTPARAM, WideUpperCase(Sl[i]));
          if p = 1 then
            begin
              ListToLoad := Copy(Sl[i], Length(WS_LISTPARAM) + 1,
                        Length(Sl[i]) - Length(WS_LISTPARAM));
              Continue;
            end;

          p := Pos(WS_LISTPARAMALT, WideUpperCase(Sl[i]));
          if p = 1 then
            begin
              ListToLoad := Copy(Sl[i], Length(WS_LISTPARAMALT) + 1,
                          Length(Sl[i]) - Length(WS_LISTPARAMALT));
              Continue;
            end;
        end;
    finally
      FreeAndNil(Sl);
    end;
  end;
end;

begin
  DisableProcessWindowsGhosting();
  Application.Initialize();
  AnalizeParams();
  if (not Maxi) then
    Application.ShowMainForm:= false;  
  Application.CreateForm(Tform_CB8_Main, form_CB8_Main);
  Application.Run();
end.
