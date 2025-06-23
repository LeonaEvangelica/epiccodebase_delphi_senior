unit uServiceViaCEP;

interface

type
  TEnderecoCEP = record
    Logradouro: string;
    Bairro: string;
    Cidade: string;
    UF: string;
  end;

function BuscarEnderecoPorCEP(const ACEP: string): TEnderecoCEP;
function SomenteDigitos(const Texto: string): Boolean;

implementation

uses
  IdHTTP, System.SysUtils, System.JSON, IdSSLOpenSSL, System.Character;

function BuscarEnderecoPorCEP(const ACEP: string): TEnderecoCEP;
var
  Http: TIdHTTP;
  Json: TJSONObject;
  Resp: string;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
  CEPFormatado: string;
begin
  Result.Logradouro := '';
  Result.Bairro := '';
  Result.Cidade := '';
  Result.UF := '';

  // Remove traços, espaços etc.
  CEPFormatado := ACEP.Trim.Replace('-', '').Replace('.', '');
  if Length(CEPFormatado) <> 8 then
    raise Exception.Create('CEP inválido. O CEP precisa ter 8 dígitos!');

  if not SomenteDigitos(CEPFormatado) then
    raise Exception.Create('CEP inválido!');

  Http := TIdHTTP.Create(nil);
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  try
    Http.IOHandler := SSL;
    Http.ReadTimeout := 5000;
    Http.Request.ContentType := 'application/json';

    Resp := Http.Get('https://viacep.com.br/ws/' + ACEP + '/json/');
    Json := TJSONObject.ParseJSONValue(Resp) as TJSONObject;

    if Assigned(Json) and (not Json.TryGetValue('erro', Result.Logradouro)) then
    begin
      Result.Logradouro := Json.GetValue<string>('logradouro');
      Result.Bairro     := Json.GetValue<string>('bairro');
      Result.Cidade     := Json.GetValue<string>('localidade');
      Result.UF         := Json.GetValue<string>('uf');
      Json.Free;
    end else
    begin
      raise Exception.Create('CEP não econtrado!');
      Json.Free;
    end;

  finally
    Http.Free;
    SSL.Free;
  end;
end;

function SomenteDigitos(const Texto: string): Boolean;
var
  C: Char;
begin
  Result := True;
  for C in Texto do
  begin
    if not CharInSet(C, ['0'..'9']) then
    begin
      Result := False;
      Exit;
    end;
  end;
end;

end.
