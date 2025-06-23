unit uRepositoryOrdemServico;

interface

uses
  uInterfaceOrdemServicoRepository, uModelOrdemServico, FireDAC.Comp.Client,
  System.Generics.Collections;

type
  TRepositoryOrdemServico = class(TInterfacedObject, IOrdemServicoRepository)
  private
    FConnection: TFDConnection;
  public
    constructor Create(AConnection: TFDConnection);
    function Inserir(AOrdem: TModelOrdemServico): Integer;
    function Atualizar(AOrdem: TModelOrdemServico): Boolean;
    function ObterPorNumero(ANumero: Integer): TModelOrdemServico;
    function ListarTodos: TArray<TModelOrdemServico>;
    function Remover(ANumero: Integer): Boolean;
  end;

implementation

uses
  FireDAC.Stan.Param;

{ TRepositoryOrdemServico }

function TRepositoryOrdemServico.Atualizar(AOrdem: TModelOrdemServico): Boolean;
var
  Query: TFDQuery;
  Item: TModelOrdemServicoItem;
begin
  Result := False;
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FConnection;

    // Atualiza cabeçalho
    Query.SQL.Text :=
      'UPDATE OrdemServico SET ' +
        'DataConclusao = :DataConclusao, ' +
        'ClienteNome = :ClienteNome, ' +
        'ClienteDocumento = :ClienteDocumento, ' +
        'CEP = :CEP, ' +
        'Logradouro = :Logradouro, ' +
        'Bairro = :Bairro, ' +
        'Cidade = :Cidade, ' +
        'UF = :UF, ' +
        'TecnicoResponsavel = :TecnicoResponsavel, ' +
        'DescricaoProblema = :DescricaoProblema, ' +
        'Status = :Status, ' +
        'JustificativaCancelamento = :JustificativaCancelamento, ' +
        'HorasTrabalhadas = :HorasTrabalhadas ' +
      'WHERE Numero = :Numero';

    Query.ParamByName('DataConclusao').AsDateTime := AOrdem.DataConclusao;
    Query.ParamByName('ClienteNome').AsString := AOrdem.ClienteNome;
    Query.ParamByName('ClienteDocumento').AsString := AOrdem.ClienteDocumento;
    Query.ParamByName('CEP').AsString := AOrdem.CEP;
    Query.ParamByName('Logradouro').AsString := AOrdem.Logradouro;
    Query.ParamByName('Bairro').AsString := AOrdem.Bairro;
    Query.ParamByName('Cidade').AsString := AOrdem.Cidade;
    Query.ParamByName('UF').AsString := AOrdem.UF;
    Query.ParamByName('TecnicoResponsavel').AsString := AOrdem.TecnicoResponsavel;
    Query.ParamByName('DescricaoProblema').AsString := AOrdem.DescricaoProblema;
    Query.ParamByName('Status').AsString := AOrdem.Status;
    Query.ParamByName('JustificativaCancelamento').AsString := AOrdem.JustificativaCancelamento;
    Query.ParamByName('HorasTrabalhadas').AsFloat := AOrdem.HorasTrabalhadas;
    Query.ParamByName('Numero').AsInteger := AOrdem.Numero;
    Query.ExecSQL;

    // Remove itens existentes
    Query.SQL.Text := 'DELETE FROM OrdemServicoItem WHERE NumeroOS = :NumeroOS';
    Query.ParamByName('NumeroOS').AsInteger := AOrdem.Numero;
    Query.ExecSQL;

    // Insere novos itens
    for Item in AOrdem.Itens do
    begin
      Query.SQL.Text :=
        'INSERT INTO OrdemServicoItem (NumeroOS, NumeroItem, NomePeca, Quantidade, ValorUnitario) ' +
        'VALUES (:NumeroOS, :NumeroItem, :NomePeca, :Quantidade, :ValorUnitario)';
      Query.ParamByName('NumeroOS').AsInteger := AOrdem.Numero;
      Query.ParamByName('NumeroItem').AsInteger := Item.NumeroItem;
      Query.ParamByName('NomePeca').AsString := Item.NomePeca;
      Query.ParamByName('Quantidade').AsInteger := Item.Quantidade;
      Query.ParamByName('ValorUnitario').AsFloat := Item.ValorUnitario;
      Query.ExecSQL;
    end;

    Result := True;
  finally
    Query.Free;
  end;
end;

constructor TRepositoryOrdemServico.Create(AConnection: TFDConnection);
begin
  FConnection := AConnection
end;

function TRepositoryOrdemServico.Inserir(AOrdem: TModelOrdemServico): Integer;
var
  Query: TFDQuery;
  Item: TModelOrdemServicoItem;
begin
  Result := -1;
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FConnection;
    Query.SQL.Text :=
      'INSERT INTO OrdemServico (DataAbertura, ClienteNome, ClienteDocumento, CEP, Logradouro, Bairro, Cidade, UF, TecnicoResponsavel, DescricaoProblema, Status, JustificativaCancelamento, HorasTrabalhadas) ' +
      'OUTPUT INSERTED.Numero ' +
      'VALUES (:DataAbertura, :ClienteNome, :ClienteDocumento, :CEP, :Logradouro, :Bairro, :Cidade, :UF, :TecnicoResponsavel, :DescricaoProblema, :Status, :JustificativaCancelamento, :HorasTrabalhadas)';

    Query.ParamByName('DataAbertura').AsDateTime := AOrdem.DataAbertura;
    Query.ParamByName('ClienteNome').AsString := AOrdem.ClienteNome;
    Query.ParamByName('ClienteDocumento').AsString := AOrdem.ClienteDocumento;
    Query.ParamByName('CEP').AsString := AOrdem.CEP;
    Query.ParamByName('Logradouro').AsString := AOrdem.Logradouro;
    Query.ParamByName('Bairro').AsString := AOrdem.Bairro;
    Query.ParamByName('Cidade').AsString := AOrdem.Cidade;
    Query.ParamByName('UF').AsString := AOrdem.UF;
    Query.ParamByName('TecnicoResponsavel').AsString := AOrdem.TecnicoResponsavel;
    Query.ParamByName('DescricaoProblema').AsString := AOrdem.DescricaoProblema;
    Query.ParamByName('Status').AsString := AOrdem.Status;
    Query.ParamByName('JustificativaCancelamento').AsString := AOrdem.JustificativaCancelamento;
    Query.ParamByName('HorasTrabalhadas').AsFloat := AOrdem.HorasTrabalhadas;
    Query.Open;
    Result := Query.Fields[0].AsInteger;
    AOrdem.Numero := Result;
    Query.Close;

    // Inserir os itens
    for Item in AOrdem.Itens do
    begin
      Query.SQL.Text :=
        'INSERT INTO OrdemServicoItem (NumeroOS, NumeroItem, NomePeca, Quantidade, ValorUnitario) ' +
        'VALUES (:NumeroOS, :NumeroItem, :NomePeca, :Quantidade, :ValorUnitario)';
      Query.ParamByName('NumeroOS').AsInteger := Result;
      Query.ParamByName('NumeroItem').AsInteger := Item.NumeroItem;
      Query.ParamByName('NomePeca').AsString := Item.NomePeca;
      Query.ParamByName('Quantidade').AsInteger := Item.Quantidade;
      Query.ParamByName('ValorUnitario').AsFloat := Item.ValorUnitario;
      Query.ExecSQL;
    end;

  finally
    Query.Free;
  end;
end;

function TRepositoryOrdemServico.ListarTodos: TArray<TModelOrdemServico>;
var
  Lista: TObjectList<TModelOrdemServico>;
  Query: TFDQuery;
  OS: TModelOrdemServico;
begin
  Lista := TObjectList<TModelOrdemServico>.Create;
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FConnection;
    Query.SQL.Text := 'SELECT Numero FROM OrdemServico ORDER BY DataAbertura DESC';
    Query.Open;

    while not Query.Eof do
    begin
      OS := ObterPorNumero(Query.FieldByName('Numero').AsInteger);
      if Assigned(OS) then
        Lista.Add(OS);
      Query.Next;
    end;

    Result := Lista.ToArray;
  finally
    Query.Free;
    Lista.Free;
  end;
end;

function TRepositoryOrdemServico.ObterPorNumero(
  ANumero: Integer): TModelOrdemServico;
var
  Query: TFDQuery;
  Item: TModelOrdemServicoItem;
begin
  Result := nil;
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FConnection;

    // Buscar cabeçalho
    Query.SQL.Text := 'SELECT * FROM OrdemServico WHERE Numero = :Numero';
    Query.ParamByName('Numero').AsInteger := ANumero;
    Query.Open;

    if Query.IsEmpty then
      Exit;

    Result := TModelOrdemServico.Create;
    with Result do
    begin
      Numero := Query.FieldByName('Numero').AsInteger;
      DataAbertura := Query.FieldByName('DataAbertura').AsDateTime;
      DataConclusao := Query.FieldByName('DataConclusao').AsDateTime;
      ClienteNome := Query.FieldByName('ClienteNome').AsString;
      ClienteDocumento := Query.FieldByName('ClienteDocumento').AsString;
      CEP := Query.FieldByName('CEP').AsString;
      Logradouro := Query.FieldByName('Logradouro').AsString;
      Bairro := Query.FieldByName('Bairro').AsString;
      Cidade := Query.FieldByName('Cidade').AsString;
      UF := Query.FieldByName('UF').AsString;
      TecnicoResponsavel := Query.FieldByName('TecnicoResponsavel').AsString;
      DescricaoProblema := Query.FieldByName('DescricaoProblema').AsString;
      Status := Query.FieldByName('Status').AsString;
      JustificativaCancelamento := Query.FieldByName('JustificativaCancelamento').AsString;
      HorasTrabalhadas := Query.FieldByName('HorasTrabalhadas').AsFloat;
    end;

    // Buscar itens
    Query.Close;
    Query.SQL.Text := 'SELECT * FROM OrdemServicoItem WHERE NumeroOS = :NumeroOS ORDER BY NumeroItem';
    Query.ParamByName('NumeroOS').AsInteger := ANumero;
    Query.Open;

    while not Query.Eof do
    begin
      Item := TModelOrdemServicoItem.Create;
      Item.Id := Query.FieldByName('Id').AsInteger;
      Item.NumeroOS := ANumero;
      Item.NumeroItem := Query.FieldByName('NumeroItem').AsInteger;
      Item.NomePeca := Query.FieldByName('NomePeca').AsString;
      Item.Quantidade := Query.FieldByName('Quantidade').AsInteger;
      Item.ValorUnitario := Query.FieldByName('ValorUnitario').AsFloat;
      Result.Itens.Add(Item);
      Query.Next;
    end;

  finally
    Query.Free;
  end;
end;

function TRepositoryOrdemServico.Remover(ANumero: Integer): Boolean;
var
  Query: TFDQuery;
begin
  Result := False;
  Query := TFDQuery.Create(nil);
  try
    Query.Connection := FConnection;
    Query.SQL.Text := 'DELETE FROM OrdemServico WHERE Numero = :Numero';
    Query.ParamByName('Numero').AsInteger := ANumero;
    Query.ExecSQL;
    Result := Query.RowsAffected > 0;
  finally
    Query.Free;
  end;
end;

end.
