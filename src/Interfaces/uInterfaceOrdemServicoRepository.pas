unit uInterfaceOrdemServicoRepository;

interface

uses
  System.Generics.Collections, uModelOrdemServico;

type
  IOrdemServicoRepository = interface
    ['{C87103E6-7921-4FE0-94B9-6B65C6231A84}']
    function Inserir(AOrdem: TModelOrdemServico): Integer;
    function Atualizar(AOrdem: TModelOrdemServico): Boolean;
    function ObterPorNumero(ANumero: Integer): TModelOrdemServico;
    function ListarTodos: TArray<TModelOrdemServico>;
    function Remover(ANumero: Integer): Boolean;
  end;

implementation

end.
