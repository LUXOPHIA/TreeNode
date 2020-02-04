program TreeNode;

uses
  System.StartUpCopy,
  FMX.Forms,
  Main in 'Main.pas' {Form1},
  Core in 'Core.pas',
  LUX.Data.Tree.core in '_LIBRARY\LUXOPHIA\LUX\Data\Tree\LUX.Data.Tree.core.pas',
  LUX.Data.Tree.Node in '_LIBRARY\LUXOPHIA\LUX\Data\Tree\LUX.Data.Tree.Node.pas',
  LUX.Data.Tree in '_LIBRARY\LUXOPHIA\LUX\Data\Tree\LUX.Data.Tree.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
