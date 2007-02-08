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

// An extended unicode MessageDialog box


unit decompressor_MessageBoxEx;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TntForms, StdCtrls, TntStdCtrls;

type
  Tform_MessageBoxEx = class(TTntForm)
    l_Prompt: TTntLabel;
    b_Yes: TTntButton;
    b_YesToAll: TTntButton;
    b_No: TTntButton;
    b_NoToAll: TTntButton;
    b_Cancel: TTntButton;
    procedure b_CancelClick(Sender: TObject);
    procedure b_NoToAllClick(Sender: TObject);
    procedure b_NoClick(Sender: TObject);
    procedure b_YesToAllClick(Sender: TObject);
    procedure b_YesClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses bmTranslator;

{$R *.dfm}

procedure Tform_MessageBoxEx.b_CancelClick(Sender: TObject);
begin
  Tag:= mrCancel;
  Close();
end;

procedure Tform_MessageBoxEx.b_NoClick(Sender: TObject);
begin
  Tag:= mrNo;
  Close();
end;

procedure Tform_MessageBoxEx.b_NoToAllClick(Sender: TObject);
begin
  Tag:= mrNoToAll;
  Close();
end;

procedure Tform_MessageBoxEx.b_YesClick(Sender: TObject);
begin
  Tag:= mrYes;
  Close();
end;

procedure Tform_MessageBoxEx.b_YesToAllClick(Sender: TObject);
begin
  Tag:= mrYesToAll;
  Close();
end;

procedure Tform_MessageBoxEx.FormCreate(Sender: TObject);
begin
  Tag:= mrCancel;
end;

end.
