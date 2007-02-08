unit unit_Tester;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, unit_ServerWorker, IdBaseComponent, IdComponent, IdTCPConnection,
  IdTCPClient, StdCtrls;

type
  TForm12 = class(TForm)
    Button1: TButton;
    cli: TIdTCPClient;
    procedure Button1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    p: TWorker;
  public
    { Public declarations }
  end;

var
  Form12: TForm12;

implementation

uses unit_Common;

{$R *.dfm}

procedure TForm12.Button1Click(Sender: TObject);
var
s: string;
begin
  cli.Port:= INT_DEFPORT;
  cli.Host:= 'localhost';
  try
    cli.Connect();
    cli.IOHandler.WriteLn(S_COBIANHEADER + 'cobian backuP');
    s:= cli.IOHandler.ReadLn();
    showMessage(s);
  finally
    cli.Disconnect();
  end;
end;

procedure TForm12.FormCreate(Sender: TObject);
begin
  p:= TWorker.Create();
  p.FreeOnTerminate:= false;
  p.Resume();
end;

procedure TForm12.FormDestroy(Sender: TObject);
begin
  p.Terminate;
  p.WaitFor;
  FreeAndNil(p);
end;

end.
