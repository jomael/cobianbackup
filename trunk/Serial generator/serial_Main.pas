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

// Main form and unit for the serial number generator

unit serial_Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TntForms, StdCtrls, TntStdCtrls, LbCipher, LbClass;

const
  WSS_SERIALTITLE: WideString = 'S/N generator for %s';

type
  Tform_Serial = class(TTntForm)
    l_Serial: TTntLabel;
    e_Serial: TTntEdit;
    b_OK: TTntButton;
    b_Cancel: TTntButton;
    l_Name: TTntLabel;
    e_Name: TTntEdit;
    l_Organization: TTntLabel;
    e_Organization: TTntEdit;
    procedure FormDestroy(Sender: TObject);
    procedure b_OKClick(Sender: TObject);
    procedure b_CancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    MD5: TLbMD5;
    /// Generate a key
    function GenerateKey(const AName, AOrg: WideString): WideString;
  public
    { Public declarations }
  end;

var
  form_Main: Tform_Serial;

implementation

{$R *.dfm}

uses bmConstants, CobDialogsW,bmCustomize;

procedure Tform_Serial.b_CancelClick(Sender: TObject);
begin
  Close();
end;

procedure Tform_Serial.b_OKClick(Sender: TObject);
begin
  e_Serial.Text:= GenerateKey(e_Name.Text, e_Organization.Text);
end;

procedure Tform_Serial.FormCreate(Sender: TObject);
begin
  MD5:= TLbMD5.Create(nil);
  Caption:= WideFormat(WSS_SERIALTITLE,[WS_PROGRAMNAMESHORT]);
  TntApplication.Title:= Caption;
end;

procedure Tform_Serial.FormDestroy(Sender: TObject);
begin
  FreeAndNil(MD5);
end;

function Tform_Serial.GenerateKey(const AName, AOrg: WideString): WideString;
var
  s, ANameUp, AOrgUp: WideString;
  Digest: TMD5Digest;
  DigestI: array[0..3] of cardinal;
  i: integer;
begin
  Result := WS_NIL;
  ANameUp := WideUpperCase(Trim(AName));
  AOrgUp := WideUpperCase(Trim(AOrg));
  s := WS_PROGRAMNAMELONG + WS_SEP + ANameUp + WS_SEP + AOrgUp;
  MD5.HashBuffer(s[1],Length(s)* SizeOf(WideChar));
  //MD5.HashString(AnsiString(s));
  MD5.GetDigest(Digest);
  for i := 0 to 3 do
    DigestI[i] := 0;

  for i := 0 to 3 do
  begin
    DigestI[0] := DigestI[0] + Digest[i];
    DigestI[0] := DigestI[0] shl 8;
  end;

  for i := 4 to 7 do
  begin
    DigestI[1] := DigestI[1] + Digest[i];
    DigestI[1] := DigestI[1] shl 8;
  end;

  for i := 8 to 11 do
  begin
    DigestI[2] := DigestI[2] + Digest[i];
    DigestI[2] := DigestI[2] shl 8;
  end;

  for i := 12 to 15 do
  begin
    DigestI[3] := DigestI[3] + Digest[i];
    DigestI[3] := DigestI[3] shl 8;
  end;

  Result := WideUpperCase(WideString(IntToHex(DigestI[0], 8) + WC_SLASDASH +
    IntToHex(DigestI[1], 8) + WC_SLASDASH +
    IntToHex(DigestI[2], 8) + WC_SLASDASH +
    IntToHex(DigestI[3], 8)));
end;

end.
