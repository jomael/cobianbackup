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

// Dialog to enter the password

unit decompressor_Password;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TntForms, StdCtrls, TntStdCtrls;

type
  Tform_Password = class(TTntForm)
    l_Password: TTntLabel;
    e_Password: TTntEdit;
    b_OK: TTntButton;
    b_Cancel: TTntButton;
    l_FileName: TTntLabel;
    procedure b_CancelClick(Sender: TObject);
    procedure b_OKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses bmConstants;

{$R *.dfm}

procedure Tform_Password.b_CancelClick(Sender: TObject);
begin
  Tag:= INT_MODALRESULTCANCEL;
  Close();
end;

procedure Tform_Password.b_OKClick(Sender: TObject);
begin
  Tag:= INT_MODALRESULTOK;
  Close();
end;

procedure Tform_Password.FormCreate(Sender: TObject);
begin
  Tag:= INT_MODALRESULTCANCEL;
end;

end.
