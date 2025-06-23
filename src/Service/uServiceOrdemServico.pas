unit uServiceOrdemServico;

interface

uses
  uInterfaceOrdemServicoRepository, uModelOrdemServico;

type
  TServiceOrdemServico = class
  private
    FRepository: IOrdemServicoRepository;
  public
    constructor Create(ARepository: IOrdemServicoRepository);

    function Validar(AOrdem: TModelOrdemServico): Boolean;
    function CalcularValorTotal(AOrdem: TModelOrdemServico): Currency;
    function Criar(AOrdem: TModelOrdemServico): Integer;
    function Atualizar(AOrdem: TModelOrdemServico): Boolean;
    function Finalizar(ANumero: Integer): Boolean;
    function Cancelar(ANumero: Integer; Justificativa: string): Boolean;

    property Repository: IOrdemServicoRepository read FRepository;
  end;

implementation

uses
  System.SysUtils;

{ TServiceOrdemServico }

function TServiceOrdemServico.Atualizar(AOrdem: TModelOrdemServico): Boolean;
begin
  if not Validar(AOrdem) then
    raise Exception.Create('Ordem de Serviço inválida.');

  Result := FRepository.Atualizar(AOrdem);
end;

function TServiceOrdemServico.CalcularValorTotal(
  AOrdem: TModelOrdemServico): Currency;
var
  Item: TModelOrdemServicoItem;
begin
  Result := 0;
  for Item in AOrdem.Itens do
    Result := Result + (Item.Quantidade * Item.ValorUnitario);

  Result := Result + (AOrdem.HorasTrabalhadas * 120.00);
end;

function TServiceOrdemServico.Cancelar(ANumero: Integer;
  Justificativa: string): Boolean;
var
  OS: TModelOrdemServico;
begin
  OS := FRepository.ObterPorNumero(ANumero);
  try
    if not Assigned(OS) then
      raise Exception.Create('Ordem de Serviço não encontrada.');

    OS.Status := 'Cancelada';
    OS.JustificativaCancelamento := Justificativa;

    if not Validar(OS) then
      raise Exception.Create('Justificativa obrigatória ao cancelar.');

    Result := FRepository.Atualizar(OS);
  finally
    OS.Free;
  end;
end;

constructor TServiceOrdemServico.Create(ARepository: IOrdemServicoRepository);
begin
  FRepository := ARepository;
end;

function TServiceOrdemServico.Criar(AOrdem: TModelOrdemServico): Integer;
begin
  if not Validar(AOrdem) then
    raise Exception.Create('Ordem de Serviço inválida.');

  Result := FRepository.Inserir(AOrdem);
end;

function TServiceOrdemServico.Finalizar(ANumero: Integer): Boolean;
var
  OS: TModelOrdemServico;
begin
  OS := FRepository.ObterPorNumero(ANumero);
  try
    if not Assigned(OS) then
      raise Exception.Create('Ordem de Serviço não encontrada.');

    OS.Status := 'Finalizada';
    OS.DataConclusao := Now;

    if not Validar(OS) then
      raise Exception.Create('Não é possível finalizar sem itens ou horas.');

    Result := FRepository.Atualizar(OS);
  finally
    OS.Free;
  end;
end;

function TServiceOrdemServico.Validar(AOrdem: TModelOrdemServico): Boolean;
begin
  if AOrdem.Status = 'Cancelada' then
    Result := AOrdem.JustificativaCancelamento.Trim <> EmptyStr
  else if AOrdem.Status = 'Finalizada' then
    Result := (AOrdem.Itens.Count > 0) or (AOrdem.HorasTrabalhadas > 0)
  else
    Result := True;
end;

end.
