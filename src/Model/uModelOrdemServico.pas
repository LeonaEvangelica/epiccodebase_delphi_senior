unit uModelOrdemServico;

interface

uses
  System.Generics.Collections;

type
  TModelOrdemServicoItem = class
  private
    FId: Integer;                 // ID único (gerado pelo banco)
    FNumeroOS: Integer;           // FK para Ordem de Serviço
    FNumeroItem: Integer;         // Sequencial por OS
    FNomePeca: string;
    FQuantidade: Integer;
    FValorUnitario: Currency;
  public
    property Id: Integer read FId write FId;
    property NumeroOS: Integer read FNumeroOS write FNumeroOS;
    property NumeroItem: Integer read FNumeroItem write FNumeroItem;
    property NomePeca: string read FNomePeca write FNomePeca;
    property Quantidade: Integer read FQuantidade write FQuantidade;
    property ValorUnitario: Currency read FValorUnitario write FValorUnitario;
  end;

type
  TModelOrdemServico = class
  private
    FNumero: Integer; // ID principal da OS
    FDataAbertura: TDateTime;
    FDataConclusao: TDateTime;
    FClienteNome: string;
    FClienteDocumento: string;
    FCEP: string;
    FLogradouro: string;
    FBairro: string;
    FCidade: string;
    FUF: string;
    FTecnicoResponsavel: string;
    FDescricaoProblema: string;
    FStatus: string;
    FJustificativaCancelamento: string;
    FHorasTrabalhadas: Double;
    FItens: TObjectList<TModelOrdemServicoItem>;
  public
    constructor Create;
    destructor Destroy; override;

    property Numero: Integer read FNumero write FNumero;
    property DataAbertura: TDateTime read FDataAbertura write FDataAbertura;
    property DataConclusao: TDateTime read FDataConclusao write FDataConclusao;
    property ClienteNome: string read FClienteNome write FClienteNome;
    property ClienteDocumento: string read FClienteDocumento write FClienteDocumento;
    property CEP: string read FCEP write FCEP;
    property Logradouro: string read FLogradouro write FLogradouro;
    property Bairro: string read FBairro write FBairro;
    property Cidade: string read FCidade write FCidade;
    property UF: string read FUF write FUF;
    property TecnicoResponsavel: string read FTecnicoResponsavel write FTecnicoResponsavel;
    property DescricaoProblema: string read FDescricaoProblema write FDescricaoProblema;
    property Status: string read FStatus write FStatus;
    property JustificativaCancelamento: string read FJustificativaCancelamento write FJustificativaCancelamento;
    property HorasTrabalhadas: Double read FHorasTrabalhadas write FHorasTrabalhadas;
    property Itens: TObjectList<TModelOrdemServicoItem> read FItens write FItens;
  end;

implementation

{ TOrdemServico }

constructor TModelOrdemServico.Create;
begin
  inherited;
  FItens := TObjectList<TModelOrdemServicoItem>.Create(True);
end;

destructor TModelOrdemServico.Destroy;
begin
  FItens.Free;
  inherited;
end;

end.
