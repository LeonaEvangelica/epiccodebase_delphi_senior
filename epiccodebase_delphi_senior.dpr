program epiccodebase_delphi_senior;

uses
  Vcl.Forms,
  uModelOrdemServico in 'src\Model\uModelOrdemServico.pas',
  uDTOOrdemServico in 'src\DTO\uDTOOrdemServico.pas',
  uInterfaceOrdemServicoRepository in 'src\Interfaces\uInterfaceOrdemServicoRepository.pas',
  uRepositoryOrdemServico in 'src\Repository\uRepositoryOrdemServico.pas',
  uServiceOrdemServico in 'src\Service\uServiceOrdemServico.pas',
  FrmOrdemServico in 'src\View\FrmOrdemServico.pas' {FormOrdemServico},
  uViewModelOrdemServico in 'src\ViewModel\uViewModelOrdemServico.pas',
  uServiceViaCEP in 'src\Service\uServiceViaCEP.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormOrdemServico, FormOrdemServico);
  Application.Run;
end.
