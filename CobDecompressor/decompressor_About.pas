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

// About box for the decompressor

unit decompressor_About;

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
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure CenterLabels();
  public
    { Public declarations }
  protected

  end;

implementation

{$R *.dfm}

procedure Tform_About.CenterLabels();
begin
  l_Tool.Left:= (Width div 2) - (l_Tool.Width div 2);
  l_Name.Left:= (Width div 2) - (l_Name.Width div 2);
  l_Version.Left:= (Width div 2) - (l_Version.Width div 2);
  l_Copyright.Left:= (Width div 2) - (l_Copyright.Width div 2);
  l_Rights.Left:= (Width div 2) - (l_Rights.Width div 2);
  l_Web.Left:= (Width div 2) - (l_Web.Width div 2);
end;

procedure Tform_About.FormShow(Sender: TObject);
begin
  CenterLabels();
end;

end.
