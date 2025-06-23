unit uDTOOrdemServico;

interface

uses
  System.Generics.Collections;

type
  TDTOOrdemServicoItem = class
  public
    Id: Integer;
    NumeroItem: Integer;
    NomePeca: string;
    Quantidade: Integer;
    ValorUnitario: Currency;
  end;

type
  TDTOOrdemServico = class
  public
    Numero: Integer;
    DataAbertura: TDateTime;
    DataConclusao: TDateTime;
    ClienteNome: string;
    ClienteDocumento: string;
    CEP: string;
    Logradouro: string;
    Bairro: string;
    Cidade: string;
    UF: string;
    TecnicoResponsavel: string;
    DescricaoProblema: string;
    Status: string;
    JustificativaCancelamento: string;
    HorasTrabalhadas: Double;
    ValorTotal: Currency;
    Itens: TObjectList<TDTOOrdemServicoItem>;

    constructor Create;
    destructor Destroy; override;
  end;

implementation

{ TDTOOrdemServico }

constructor TDTOOrdemServico.Create;
begin
  inherited;
  Itens := TObjectList<TDTOOrdemServicoItem>.Create(True);
end;

destructor TDTOOrdemServico.Destroy;
begin
  Itens.Free;
  inherited;
end;

end.
