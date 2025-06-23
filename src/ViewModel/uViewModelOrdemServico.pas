unit uViewModelOrdemServico;

interface

uses
  uServiceOrdemServico, uDTOOrdemServico, uModelOrdemServico,
  System.Generics.Collections;

type
  TViewModelOrdemServico = class
  private
    FService: TServiceOrdemServico;

    function DTOParaModel(ADTO: TDTOOrdemServico): TModelOrdemServico;
    function ModelParaDTO(AModel: TModelOrdemServico): TDTOOrdemServico;
  public
    constructor Create(AService: TServiceOrdemServico);

    function SalvarOS(ADTO: TDTOOrdemServico): Integer;
    function BuscarOS(ANumero: Integer): TDTOOrdemServico;
    function CancelarOS(ANumero: Integer; AJustificativa: string): Boolean;
    function FinalizarOS(ANumero: Integer): Boolean;
    function ListarOS: TObjectList<TDTOOrdemServico>;
  end;

implementation

{ TViewModelOrdemServico }

function TViewModelOrdemServico.BuscarOS(ANumero: Integer): TDTOOrdemServico;
var
  OS: TModelOrdemServico;
begin
  OS := FService.Repository.ObterPorNumero(ANumero);
  try
    if not Assigned(OS) then
      Exit(nil);

    Result := ModelParaDTO(OS);
  finally
    OS.Free;
  end;
end;

function TViewModelOrdemServico.CancelarOS(ANumero: Integer;
  AJustificativa: string): Boolean;
begin
  Result := FService.Cancelar(ANumero, AJustificativa);
end;

constructor TViewModelOrdemServico.Create(AService: TServiceOrdemServico);
begin
  FService := AService;
end;

function TViewModelOrdemServico.DTOParaModel(
  ADTO: TDTOOrdemServico): TModelOrdemServico;
var
  ItemDTO: TDTOOrdemServicoItem;
  ItemModel: TModelOrdemServicoItem;
begin
  Result := TModelOrdemServico.Create;

  Result.Numero := ADTO.Numero;
  Result.DataAbertura := ADTO.DataAbertura;
  Result.DataConclusao := ADTO.DataConclusao;
  Result.ClienteNome := ADTO.ClienteNome;
  Result.ClienteDocumento := ADTO.ClienteDocumento;
  Result.CEP := ADTO.CEP;
  Result.Logradouro := ADTO.Logradouro;
  Result.Bairro := ADTO.Bairro;
  Result.Cidade := ADTO.Cidade;
  Result.UF := ADTO.UF;
  Result.TecnicoResponsavel := ADTO.TecnicoResponsavel;
  Result.DescricaoProblema := ADTO.DescricaoProblema;
  Result.Status := ADTO.Status;
  Result.JustificativaCancelamento := ADTO.JustificativaCancelamento;
  Result.HorasTrabalhadas := ADTO.HorasTrabalhadas;

  for ItemDTO in ADTO.Itens do
  begin
    ItemModel := TModelOrdemServicoItem.Create;
    ItemModel.Id := ItemDTO.Id;
    ItemModel.NumeroItem := ItemDTO.NumeroItem;
    ItemModel.NomePeca := ItemDTO.NomePeca;
    ItemModel.Quantidade := ItemDTO.Quantidade;
    ItemModel.ValorUnitario := ItemDTO.ValorUnitario;
    Result.Itens.Add(ItemModel);
  end;
end;

function TViewModelOrdemServico.FinalizarOS(ANumero: Integer): Boolean;
begin
  Result := FService.Finalizar(ANumero);
end;

function TViewModelOrdemServico.ListarOS: TObjectList<TDTOOrdemServico>;
var
  ListaModel: TArray<TModelOrdemServico>;
  ListaDTO: TObjectList<TDTOOrdemServico>;
  OS: TModelOrdemServico;
begin
  ListaModel := FService.Repository.ListarTodos;
  ListaDTO := TObjectList<TDTOOrdemServico>.Create(True);
  for OS in ListaModel do
    ListaDTO.Add(ModelParaDTO(OS));

  Result := ListaDTO;
end;

function TViewModelOrdemServico.ModelParaDTO(
  AModel: TModelOrdemServico): TDTOOrdemServico;
var
  ItemModel: TModelOrdemServicoItem;
  ItemDTO: TDTOOrdemServicoItem;
begin
  Result := TDTOOrdemServico.Create;

  Result.Numero := AModel.Numero;
  Result.DataAbertura := AModel.DataAbertura;
  Result.DataConclusao := AModel.DataConclusao;
  Result.ClienteNome := AModel.ClienteNome;
  Result.ClienteDocumento := AModel.ClienteDocumento;
  Result.CEP := AModel.CEP;
  Result.Logradouro := AModel.Logradouro;
  Result.Bairro := AModel.Bairro;
  Result.Cidade := AModel.Cidade;
  Result.UF := AModel.UF;
  Result.TecnicoResponsavel := AModel.TecnicoResponsavel;
  Result.DescricaoProblema := AModel.DescricaoProblema;
  Result.Status := AModel.Status;
  Result.JustificativaCancelamento := AModel.JustificativaCancelamento;
  Result.HorasTrabalhadas := AModel.HorasTrabalhadas;

  Result.ValorTotal := FService.CalcularValorTotal(AModel);

  for ItemModel in AModel.Itens do
  begin
    ItemDTO := TDTOOrdemServicoItem.Create;
    ItemDTO.Id := ItemModel.Id;
    ItemDTO.NumeroItem := ItemModel.NumeroItem;
    ItemDTO.NomePeca := ItemModel.NomePeca;
    ItemDTO.Quantidade := ItemModel.Quantidade;
    ItemDTO.ValorUnitario := ItemModel.ValorUnitario;
    Result.Itens.Add(ItemDTO);
  end;
end;

function TViewModelOrdemServico.SalvarOS(ADTO: TDTOOrdemServico): Integer;
var
  Model: TModelOrdemServico;
begin
  Model := DTOParaModel(ADTO);
  try
    if Model.Numero = 0 then
      Result := FService.Criar(Model)
    else
    begin
      FService.Atualizar(Model);
      Result := Model.Numero;
    end;
  finally
    Model.Free;
  end;
end;

end.
