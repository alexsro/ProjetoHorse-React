unit  Services.Auth.UserAuthentication;

interface

uses
  Services.Base, FireDAC.Comp.Client, System.SysUtils, Parameters.Interf, Parameters.Default, Helpers.HorseList, JSON,
  Firedac.Stan.Async, REST.JSON, SQL.Auth.UserAuthentication, System.Generics.Collections;

Type
  TServicesUserAuthentication = class(TServicesBase)
  private

  public
    procedure GetAutenticateResult;
  end;

implementation

uses
  Horse, DataSet.Serialize, Factorys.DataSet, Data.DB, JOSE.Core.JWT, JOSE.Core.Builder, Utils.Json;

{ TUserAuthentication }

procedure TServicesUserAuthentication.GetAutenticateResult;
var
  SQL: TSQLUserAuthentication;
  Parameters: IParameters;
  RQuery: TFDQuery;
  LToken: TJWT;
  i : integer;
  LJsonResponse: TJSONObject;
  dictionary: TDictionary<string,string>;
begin
  LJsonResponse := TJSONObject.ParseJSONValue(FReq.Body) AS TJSONObject;
  dictionary := TDictionary<string,string>.Create;
  dictionary := TJsonUtils.JObjectToStringsDictionary(LJsonResponse);
  RQuery := TFactoryDataSet.GetInstance(FConnection).CreateQuery();
  Parameters := FReq.Params.ToParametros.Add(dictionary);


  if (not Parameters.Exists('login')) or (not Parameters.Exists('password')) then
    raise EHorseException.Create('Informe um login e senha para validação');

  SQL := TSQLUserAuthentication.Create(Parameters);
  LToken := TJWT.Create;
  try
    RQuery.SQL.Text := SQL.GetList;
    RQuery.Open();
    if RQuery.RecordCount = 0 then
      FRes.Status(401).Send('Usuário e/ou senha incorretos.')
    else
    begin
      LToken.Claims.Issuer := 'Horse';
      LToken.Claims.Subject := 'Projeto Horse React';
      LToken.Claims.Expiration := Now + 1;
      FRes.Status(201).Send(TJSONObject.Create(TJSONPair.Create('token', TJOSE.SHA256CompactToken('TokenJWT', LToken))));
    end;
  finally
    LToken.Free;
    SQL.Free;
    dictionary.Free;
    LJsonResponse.Free;
  end;
end;

end.
