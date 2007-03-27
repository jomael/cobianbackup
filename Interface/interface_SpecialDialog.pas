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

// A special dialog box with a check box

unit interface_SpecialDialog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TntForms, StdCtrls, TntStdCtrls;

type
  Tform_SpecialDialog = class(TTntForm)
    l_Prompt: TTntLabel;
    cb_Condition: TTntCheckBox;
    b_OK: TTntButton;
    b_Cancel: TTntButton;
    procedure b_CancelClick(Sender: TObject);
    procedure b_OKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure LoadInterfaceText();
  public
    { Public declarations }
    procedure CenterLabels();
  end;


implementation

uses interface_Common, bmTranslator, bmConstants, Types;

{$R *.dfm}

procedure Tform_SpecialDialog.b_CancelClick(Sender: TObject);
begin
  Tag:= INT_MODALRESULTCANCEL;
  Close();
end;

procedure Tform_SpecialDialog.b_OKClick(Sender: TObject);
begin
  Tag:= INT_MODALRESULTOK;
  Close();
end;

procedure Tform_SpecialDialog.CenterLabels();
var
  Metrics: tagSIZE;
begin
  GetTextExtentPoint32W(Canvas.Handle, PWideChar(cb_Condition.Caption),
                        Length(cb_Condition.Caption), Metrics);
  l_Prompt.Left:= (Width div 2) - (l_Prompt.Width div 2);
  cb_Condition.Left:= (Width div 2) - ((Metrics.cx + INT_CBWIDTH) div 2);
end;

procedure Tform_SpecialDialog.FormCreate(Sender: TObject);
begin
  Font.Name:= UISettings.FontName;
  Font.Size:= UISettings.FontSize;
  Font.Charset:= UISettings.FontCharset;
  ShowHint:= UISettings.ShowHints;
  Tag:= INT_MODALRESULTCANCEL;
  LoadInterfaceText();
end;

procedure Tform_SpecialDialog.LoadInterfaceText();
begin
  b_OK.Caption:= Translator.GetInterfaceText('B_OK');
  b_Cancel.Caption:= Translator.GetInterfaceText('B_CANCEL');
end;

end.
