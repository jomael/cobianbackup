
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

// Dummy form to show the DLL....


unit unit_MainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TntForms, CobCommonW, CobDialogsW;

const
  WM_SHOWING = WM_USER + 9878;

type
  Tform_Main = class(TTntForm)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FAppPath: WideString;
    FS: TFormatSettings;
  public
    { Public declarations }
  protected
    procedure AfterCreate(var Msg: TMessage);message WM_SHOWING;
  end;

var
  form_Main: Tform_Main;

implementation

uses bmCommon, bmCustomize, bmConstants;

{$R *.dfm}
{$R ..\Common\vista.RES}

procedure Tform_Main.AfterCreate(var Msg: TMessage);
var
  Dll: THandle;
  Init: TDecryptorMainEntry;
begin
  Dll:= LoadLibraryW(PWideChar(CobSetBackSlashW(FAppPath) + WS_COBDECRYPTORDLL));
  if (Dll <> 0) then
  begin
    @Init:= GetProcAddress(Dll, S_MAINDECENTRY);
    if (@Init <> nil) then
      Init(PWideChar(FAppPath),PWideChar(WS_NIL),false, Application.Handle);
    FreeLibrary(Dll);
  end else
  CobShowMessageW(0,WS_COULDNTLOADDECRYPTORDLL, WS_PROGRAMNAMESHORT);
  Close();
end;

procedure Tform_Main.FormCreate(Sender: TObject);
begin
  GetLocaleFormatSettings(LOCALE_SYSTEM_DEFAULT, FS);
  FAppPath:= CobGetAppPathW();
  PostMessage(handle, WM_SHOWING, 0, 0);
end;

end.
