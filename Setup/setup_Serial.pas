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

// Dialog to introduce the serial number, if needed

unit setup_Serial;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, TntForms, StdCtrls, TntStdCtrls, LbCipher, LbClass, TntClasses;

const
  INT_POSTSHOW= WM_USER + 6712;

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
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure b_OKClick(Sender: TObject);
    procedure b_CancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    MD5: TLbMD5;
    FSl: TTntStringList;
    FAppPath: WideString;
    FAutoIni: WideString;
    FFirstTime: Boolean;
    function CheckSerialNumber(): integer;
    /// Generate a key
    function GenerateKey(const AName, AOrg: WideString): WideString;
    procedure CheckAutoFill();
  public
    { Public declarations }
  protected
    procedure PostShow(var Msg: Tmessage); message INT_POSTSHOW;
  end;


implementation

uses bmConstants, CobDialogsW, setup_Constants, bmCustomize, TntSysUtils,
      CobCommonW;

{$R *.dfm}

procedure Tform_Serial.b_CancelClick(Sender: TObject);
begin
  Tag:= INT_MODALRESULTCANCEL;
  Close();
end;

procedure Tform_Serial.b_OKClick(Sender: TObject);
begin
  Tag:= CheckSerialNumber();
  if (Tag =  INT_MODALRESULTCANCEL) then
  begin
    CobShowMessageW(self.Handle, SS_BADSERIAL, WS_PROGRAMNAMESHORT);
    Exit;
  end;

  Close();
end;

procedure Tform_Serial.CheckAutoFill();
begin
  if (WideFileExists(FAutoIni)) then
  begin
    FSl.LoadFromFile(FAutoIni);
    e_Name.Text:= FSl.Values[WS_INIAUTOSETUPNAME];
    e_Organization.Text:= FSl.Values[WS_INIAUTOSETUPORGANIZATION];
    e_Serial.Text:= FSl.Values[WS_INIAUTOSETUPSERIAL];
    b_OKClick(self);
  end;
end;

function Tform_Serial.CheckSerialNumber(): integer;
begin
  Result:= INT_MODALRESULTCANCEL;
  if (WideUpperCase(e_Serial.Text) = GenerateKey(e_Name.Text, e_Organization.Text)) then
    Result:= INT_MODALRESULTOK;  
end;

procedure Tform_Serial.FormCreate(Sender: TObject);
begin
  Tag:= INT_MODALRESULTCANCEL;
  FAppPath:= CobSetBackSlashW(CobGetAppPathW());
  FAutoIni:= FAppPath + WideChangeFileExt(WS_SETUPEXENAME, WS_DATAEXT);
  MD5:= TLbMD5.Create(nil);
  FSl:= TTntStringList.Create();
  FFirstTime:= true;
end;

procedure Tform_Serial.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FSl);
  FreeAndNil(MD5);
end;

procedure Tform_Serial.FormShow(Sender: TObject);
begin
  if (FFirstTime) then
  begin
    PostMessageW(self.Handle,INT_POSTSHOW, 0, 0);
    FFirstTime:= false;
  end;
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

procedure Tform_Serial.PostShow(var Msg: Tmessage);
begin
  CheckAutoFill();
end;

end.
