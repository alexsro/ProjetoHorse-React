unit SQL.Auth.UserAuthentication;

interface

uses
  SQL.Base, System.SysUtils, System.StrUtils;

type
  TSQLUserAuthentication = class(TSQLBase)
  private
    { private declarations }
  protected
    { protected declarations }
    function GetTables: string;
  public
    { public declarations }
    function GetList: string;
    function GetTotalRecords: string;
    function GetEmptyList: string;
    function GetNextID: String;
  end;

implementation

uses
  Utils.Strings;

{ TSQLBarberShopTypeContact }

function TSQLUserAuthentication.GetList: string;
var
  CamposSP: string;
begin
  FParameters.Add('IncluirOrderBy', true);

  Result := 'SELECT * ' + GetTables;
end;

function TSQLUserAuthentication.GetTotalRecords: string;
begin
  FParameters.Add('IncluirOrderBy', false);

  Result := 'SELECT  ' + '  COUNT(u.id_usu) AS RECORDS ' + Self.GetTables;
end;

function TSQLUserAuthentication.GetTables: string;
var
  FiltroOrderBy: string;
  FiltroUsuario: String;
begin

  Result :=
    'FROM usuarios u ' + ifThen(FParameters.GetAsString('codigo').IsEmpty,
    'WHERE u.id_usu IS NOT NULL ', 'WHERE u.id_usu = ' + FParameters.GetAsString('codigo')+' ') +
    ifThen(FParameters.GetAsString('login').IsEmpty, '', ' AND login_usu = ' + QuotedStr(FParameters.GetAsString('login'))) +
    ifThen(FParameters.GetAsString('password').IsEmpty, '', ' AND senha_usu = ' + QuotedStr(FParameters.GetAsString('password')));

  if FParameters.GetAsBoolean('IncluirOrderBy') then
    Result := Result + 'ORDER BY u.id_usu ';
end;

function TSQLUserAuthentication.GetEmptyList: string;
begin
  result :=
    'SELECT id_usu, nome_usu  ' +
    'FROM usuarios WHERE id_usu = -1 ';
end;

function TSQLUserAuthentication.GetNextID: String;
begin
  result := 'select nextval(''SEQ_USUARIOS'') as codigo';
end;

end.
