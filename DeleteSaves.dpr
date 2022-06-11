program DeleteSaves;

uses
  Vcl.Forms,
  UnitMain in 'UnitMain.pas' {frmMain},
  Backend in 'Backend.pas',
  Functional.FuncFactory in 'imported\Functional.FuncFactory.pas',
  Functional.Sequence in 'imported\Functional.Sequence.pas',
  Functional.Value in 'imported\Functional.Value.pas',
  Functions.Strings in 'lib\Functions.Strings.pas',
  Functions.DB in 'lib\Functions.DB.pas',
  Functions.Graphics in 'lib\Functions.Graphics.pas',
  Functions.Math in 'lib\Functions.Math.pas',
  Functions.Regex in 'lib\Functions.Regex.pas',
  Functions.UI in 'lib\Functions.UI.pas',
  Functions.Utils in 'lib\Functions.Utils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
