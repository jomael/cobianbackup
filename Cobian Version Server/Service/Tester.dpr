program Tester;

uses
  Forms,
  unit_Tester in 'unit_Tester.pas' {Form12},
  unit_ServerWorker in 'unit_ServerWorker.pas',
  unit_Common in 'unit_Common.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm12, Form12);
  Application.Run;
end.
