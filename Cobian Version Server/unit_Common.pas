{~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~                                                            ~~~~~~~~~~
~~~~~~~~~~                   Cobian version Server                    ~~~~~~~~~~
~~~~~~~~~~            Copyright 200-2006 by Luis Cobian               ~~~~~~~~~~
~~~~~~~~~~                     cobian@educ.umu.se                     ~~~~~~~~~~
~~~~~~~~~~                    All rights reserved                     ~~~~~~~~~~
~~~~~~~~~~                                                            ~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~}

unit unit_Common;

interface

uses Classes, SysUtils;

const
  S_APPNAME = 'Cobian Version Server';
  S_VERSIONSFILE = '%s.vrs';
  S_FLAG = '%s.flg';
  S_MUTEXNAME = 'Global\%s Mutex Name';
  S_MUTEXNAMEOLD = 'Global\%s Mutex Name';
  INT_ENCCOUNT = 4;
  S_NIL = '';
  S_APPNAMEENTER = 'Enter the name of the application';
  S_APPNAMEEMPTY = 'The name of the application cannot be empty';
  S_APPNAMEUNIQUE = 'The application name must be unique';
  S_10 = '1.0';
  S_DELETESELECTED = 'Delete the selected items?';
  S_COPYRIGHT = '©2000-2006 by Luis Cobian.'#10#13'All rights reserved';
  INT_DEFPORT = 2002;
  INT_SLEEP = 1000;
  INT_30 = 30;
  INT_NIL = 0;
  S_LOG = '%s log.txt';
  S_LOGSTRING = '%s %s %s %s';
  S_COBIANHEADER = '*@COBIANHEADER@*';
  S_ERROR = 'ERROR';


type

  TAVElement = class(TObject)
  private
    FApp: string;
    FVer: string;
    FHome: string;
    FInfo: string;
    FSl: TStringList;
  public
    property App: string read FApp write FApp;
    property Ver: string read FVer write FVer;
    property Home: string read FHome write FHome;
    property Info: string read FInfo write FInfo;
    constructor Create();
    destructor Destroy();override;
    function StrToElement(const Encoded: string): boolean;
    function ElementToStr(): string;
  end;

implementation

{ TAVElement }

constructor TAVElement.Create;
begin
  inherited Create();
  FSl:= TStringList.Create();
end;

destructor TAVElement.Destroy();
begin
  FreeAndNil(FSl);
  inherited Destroy();
end;

function TAVElement.ElementToStr: string;
begin
  FSl.Clear();
  FSl.Add(FApp);
  FSl.Add(FVer);
  FSl.Add(FHome);
  FSl.Add(FInfo);
  Result:= FSl.CommaText;
end;

function TAVElement.StrToElement(const Encoded: string): boolean;
begin
  Result:= false;
  FSl.CommaText:= Encoded;
  if (FSl.Count = INT_ENCCOUNT) then
  begin
    FApp:= FSl[0];
    FVer:= FSl[1];
    FHome:= FSl[2];
    FInfo:= FSl[3];
    Result:= true;
  end;
end;

end.
