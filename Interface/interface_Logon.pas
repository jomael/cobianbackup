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

// Dialog to change the logon properties of the service

unit interface_Logon;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TntForms, StdCtrls, TntStdCtrls;

type
  Tform_Logon = class(TTntForm)
    l_Logon: TTntLabel;
    rb_System: TTntRadioButton;
    l_Warning: TTntLabel;
    rb_Account: TTntRadioButton;
    l_ID: TTntLabel;
    e_ID: TTntEdit;
    l_Password: TTntLabel;
    e_Password: TTntEdit;
    b_OK: TTntButton;
    b_Cancel: TTntButton;
    procedure e_IDChange(Sender: TObject);
    procedure b_OKClick(Sender: TObject);
    procedure b_CancelClick(Sender: TObject);
    procedure rb_AccountClick(Sender: TObject);
    procedure rb_SystemClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FFirstTime: boolean;
    procedure GetInterfaceText();
    procedure CheckUI();
  public
    { Public declarations }
  end;

implementation

uses interface_Common, bmTranslator, bmConstants;

{$R *.dfm}

procedure Tform_Logon.rb_AccountClick(Sender: TObject);
begin
  CheckUI();
end;

procedure Tform_Logon.b_CancelClick(Sender: TObject);
begin
  Tag:= INT_MODALRESULTCANCEL;
  Close();
end;

procedure Tform_Logon.b_OKClick(Sender: TObject);
begin
  Tag:= INT_MODALRESULTOK;
  Close();
end;

procedure Tform_Logon.CheckUI();
begin
  l_Warning.Enabled:= rb_System.Checked;
  l_ID.Enabled:= rb_Account.Checked;
  e_ID.Enabled:= rb_Account.Checked;
  l_Password.Enabled:= rb_Account.Checked;
  e_Password.Enabled:= rb_Account.Checked;
  b_OK.Enabled:= rb_System.Checked or (rb_Account.Checked and (Trim(e_ID.Text) <> WS_NIL));
end;

procedure Tform_Logon.e_IDChange(Sender: TObject);
begin
  CheckUI();
end;

procedure Tform_Logon.FormCreate(Sender: TObject);
begin
  FFirstTime:= true;
  Tag:= INT_MODALRESULTCANCEL;
  Font.Name:= UISettings.FontName;
  Font.Size:= UISettings.FontSize;
  Font.Charset:= UISettings.FontCharset;
  ShowHint:= UISettings.ShowHints;
  rb_System.Checked:= false;
  rb_Account.Checked:= true;
end;

procedure Tform_Logon.FormShow(Sender: TObject);
begin
  if (FFirstTime) then
  begin
    GetInterfaceText();
    CheckUI();
    FFirstTime:= false;
  end;
end;

procedure Tform_Logon.GetInterfaceText();
begin
  l_Logon.Caption:= Translator.GetInterfaceText('645');
  rb_System.Caption:= Translator.GetInterfaceText('646');
  rb_System.Hint:= Translator.GetInterfaceText('647');
  l_Warning.Caption:= Translator.GetInterfaceText('648');
  rb_Account.Caption:= Translator.GetInterfaceText('649');
  rb_Account.Hint:= Translator.GetInterfaceText('650');
  l_ID.Caption:= Translator.GetInterfaceText('651');
  e_ID.Hint:= Translator.GetInterfaceText('652');
  l_Password.Caption:= Translator.GetInterfaceText('653');
  e_Password.Hint:= Translator.GetInterfaceText('654');
  b_Ok.Caption:= Translator.GetInterfaceText('B_OK');
  b_Cancel.Caption:= Translator.GetInterfaceText('B_CANCEL');
end;

procedure Tform_Logon.rb_SystemClick(Sender: TObject);
begin
  CheckUI();
end;

end.
