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

// A search dialog box


unit translator_Search;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TntForms, StdCtrls, TntStdCtrls;

type
  Tform_Search = class(TTntForm)
    TntLabel1: TTntLabel;
    e_Search: TTntEdit;
    b_OK: TTntButton;
    b_Cancel: TTntButton;
    procedure b_CancelClick(Sender: TObject);
    procedure b_OKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses bmConstants, bmCustomize, CobDialogsW, translator_Constants;

{$R *.dfm}

procedure Tform_Search.b_CancelClick(Sender: TObject);
begin
  Tag:= INT_MODALRESULTCANCEL;
  Close();
end;

procedure Tform_Search.b_OKClick(Sender: TObject);
begin
  if (Trim(e_Search.Text) = WS_NIL) then
  begin
    CobShowMessageW(self.Handle, TS_SEARCHEMPTY, WS_PROGRAMNAMESHORT);
    e_Search.SelectAll();
    e_Search.SetFocus();
    Exit;
  end;

  Tag:= INT_MODALRESULTOK;
  Close();
end;

procedure Tform_Search.FormCreate(Sender: TObject);
begin
  Tag:= INT_MODALRESULTCANCEL;
  Caption:= WS_PROGRAMNAMESHORT;
end;

end.
