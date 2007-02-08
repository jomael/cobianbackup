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

// An unicode input box

unit interface_InputBox;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TntForms, StdCtrls, TntStdCtrls;

type
  Tform_InputBox = class(TTntForm)
    l_Prompt: TTntLabel;
    e_Input: TTntEdit;
    b_OK: TTntButton;
    b_Cancel: TTntButton;
    procedure FormCreate(Sender: TObject);
    procedure b_OKClick(Sender: TObject);
    procedure b_CancelClick(Sender: TObject);
  private
    { Private declarations }
    procedure LoadInterfaceText();
  public
    { Public declarations }
  end;

var
  form_Password: Tform_InputBox;

implementation

uses bmConstants, bmTranslator, interface_Common;

{$R *.dfm}

procedure Tform_InputBox.b_CancelClick(Sender: TObject);
begin
  Tag:= INT_MODALRESULTCANCEL;
  Close();
end;

procedure Tform_InputBox.b_OKClick(Sender: TObject);
begin
  Tag:= INT_MODALRESULTOK;
  Close();
end;

procedure Tform_InputBox.FormCreate(Sender: TObject);
begin
  Tag:= INT_MODALRESULTCANCEL;
  ShowHint:= UISettings.ShowHints;
  Font.Size:= UISettings.FontSize;
  Font.Name:= UISettings.FontName;
  Font.Charset:= UISettings.FontCharset;
  LoadInterfaceText();
end;

procedure Tform_InputBox.LoadInterfaceText();
begin
  b_OK.Caption:= Translator.GetInterfaceText('B_OK');
  b_Cancel.Caption:= Translator.GetInterfaceText('B_CANCEL');
end;

end.
