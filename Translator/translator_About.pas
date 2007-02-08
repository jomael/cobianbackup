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

// ABout box for the Translator

unit translator_About;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TntForms, StdCtrls, TntStdCtrls;

type
  Tform_About = class(TTntForm)
    l_Tool: TTntLabel;
    l_Name: TTntLabel;
    l_Version: TTntLabel;
    l_Copyright: TTntLabel;
    l_Rights: TTntLabel;
    l_Web: TTntLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure CenterCaptions();
  public
    { Public declarations }
  end;

implementation

uses bmCustomize, translator_Constants, CobCommonW, bmConstants;

{$R *.dfm}

procedure Tform_About.CenterCaptions();
begin
  l_Tool.Left:= (Width div 2) - (l_Tool.Width div 2);
  l_Name.Left:= (Width div 2) - (l_Name.Width div 2);
  l_Version.Left:= (Width div 2) - (l_Version.Width div 2);
  l_Copyright.Left:= (Width div 2) - (l_Copyright.Width div 2);
  l_Rights.Left:= (Width div 2) - (l_Rights.Width div 2);
  l_Web.Left:= (Width div 2) - (l_Web.Width div 2);
end;

procedure Tform_About.FormCreate(Sender: TObject);
begin
  Caption:= TS_ABOUT;
  l_Name.Caption:= WS_PROGRAMNAMESHORT;
  l_Version.Caption:= CobGetVersionW(WS_NIL);
  l_Copyright.Caption:= WideFormat(TS_COPYRIGHT,[WS_AUTHORLONG]);
  l_Rights.Caption:= TS_ALLRIGHTS;
  l_Web.Caption:= WS_AUTHORWEB;
  CenterCaptions();
end;

end.
