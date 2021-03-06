unit SQL.Base;

interface

uses
  Parameters.Interf, System.StrUtils, System.SysUtils,
  System.Generics.Collections;

type
  TSQLBase = class
  private
    { private declarations }
  protected
    { protected declarations }
    FParameters: IParameters;
    FFiltrosPesquisa: TDictionary<string, string>;

    function GetDataInicial: string;
    function GetDataFinal: string;

    function GetCampoTabela(const Nome: string; NomeTabela: string = ''): string; virtual;
    function GetFiltrosPesquisa: string; virtual;
    function FiltrosPesquisaToString(LimparFiltros: boolean = true): string;

    function GetFiltroEmpenhoCovid19(const UF: string): string;
  public
    { public declarations }
    constructor Create(const Parameters: IParameters); virtual;
    destructor Destroy; override;
  end;

implementation

uses
  Utils.Strings;

{ TSQLBase }

constructor TSQLBase.Create(const Parameters: IParameters);
begin
  FParameters := Parameters;
  FFiltrosPesquisa := TDictionary<string, string>.Create;
end;

destructor TSQLBase.Destroy;
begin
  FParameters := nil;

  if Assigned(FFiltrosPesquisa) then
    FFiltrosPesquisa.Free;
  FFiltrosPesquisa := nil;

  inherited;
end;

function TSQLBase.FiltrosPesquisaToString(LimparFiltros: boolean): string;
var
  Filtro: TPair<string, string>;
begin
  Result := '';
  for Filtro in FFiltrosPesquisa do
    Result := Result + Filtro.Value;
  if LimparFiltros then
    FFiltrosPesquisa.Clear;
end;

function TSQLBase.GetCampoTabela(const Nome: string; NomeTabela: string): string;
begin
  Result := '';
  if TStringUtils.IsEquals(Nome, 'EMPRESA') then
    Result := ifThen(Trim(NomeTabela).IsEmpty, 'TABEMPRESA', NomeTabela) + '.EMPRESA'
  else if TStringUtils.IsEquals(Nome, 'CODLO') then
    Result := ifThen(Trim(NomeTabela).IsEmpty, 'TABUNIDADE', NomeTabela) + '.CODLO'
  else if TStringUtils.IsEquals(Nome, 'PKEMP') then
    Result := ifThen(Trim(NomeTabela).IsEmpty, 'DESPES', NomeTabela) + '.PKEMP'
  else if TStringUtils.IsEquals(Nome, 'PKEMPA') then
    Result := ifThen(Trim(NomeTabela).IsEmpty, 'DESPES', NomeTabela) + '.PKEMPA'
  else if TStringUtils.IsEquals(Nome, 'NEMPG') then
    Result := ifThen(Trim(NomeTabela).IsEmpty, 'DESPES', NomeTabela) + '.NEMPG'
  else if TStringUtils.IsEquals(Nome, 'TPEM') then
    Result := ifThen(Trim(NomeTabela).IsEmpty, 'DESPES', NomeTabela) + '.TPEM'
  else if TStringUtils.IsEquals(Nome, 'CODIF') then
    Result := ifThen(Trim(NomeTabela).IsEmpty, 'DESFOR', NomeTabela) + '.CODIF'
  else if TStringUtils.IsEquals(Nome, 'FUNCAO') then
    Result := ifThen(Trim(NomeTabela).IsEmpty, 'TABFUNCAO', NomeTabela) + '.FUNCAO'
  else if TStringUtils.IsEquals(Nome, 'FUNCAONOME') then
    Result := ifThen(Trim(NomeTabela).IsEmpty, 'TABFUNCAO', NomeTabela) + '.NOME'
  else if TStringUtils.IsEquals(Nome, 'SUBFUNCAO') then
    Result := ifThen(Trim(NomeTabela).IsEmpty, 'TABSUBFUNCAO', NomeTabela) + '.SUBFUNCAO'
  else if TStringUtils.IsEquals(Nome, 'SUBFUNCAONOME') then
    Result := ifThen(Trim(NomeTabela).IsEmpty, 'TABSUBFUNCAO', NomeTabela) + '.NOME'
  else if TStringUtils.IsEquals(Nome, 'CATEC') then
    Result := ifThen(Trim(NomeTabela).IsEmpty, 'TABCATEC', NomeTabela) + '.CATEC'
  else if TStringUtils.IsEquals(Nome, 'CATECNOME') then
    Result := ifThen(Trim(NomeTabela).IsEmpty, 'TABCATEC', NomeTabela) + '.NOME'
  else if TStringUtils.IsEquals(Nome, 'FONGRUPO') then
    Result := ifThen(Trim(NomeTabela).IsEmpty, 'FONGRUPO', NomeTabela) + '.FONGRUPO'
  else if TStringUtils.IsEquals(Nome, 'FONGRUPONOME') then
    Result := ifThen(Trim(NomeTabela).IsEmpty, 'FONGRUPO', NomeTabela) + '.FONGRUPODESC'
  else if TStringUtils.IsEquals(Nome, 'FONCODIGO') then
    Result := ifThen(Trim(NomeTabela).IsEmpty, 'FONCODIGO', NomeTabela) + '.FONCODIGO'
  else if TStringUtils.IsEquals(Nome, 'FONCODIGONOME') then
    Result := ifThen(Trim(NomeTabela).IsEmpty, 'FONCODIGO', NomeTabela) + '.FONCODIGODESC';
end;

function TSQLBase.GetFiltroEmpenhoCovid19(const UF: string): string;
begin
  if TStringUtils.IsEquals(UF, 'SP') then
  begin
    Result :=
      ' (DESPES.VINGRUPO = ''312'' OR ' +
      ' COALESCE(VINCODIGO.FILTROPADRAO, '''') = ''COVID19'' OR COALESCE(EVCODIGO.FILTROPADRAO, '''') = ''COVID19'') ';
  end
  else if TStringUtils.IsEquals(UF, 'RS') then
  begin
    Result :=
      ' (COALESCE(DESPES.FONRO, DESDIS.FONRO) IN (3140,3150,3160) OR ' +
      ' COALESCE(EVCODIGO.FILTROPADRAO, '''') = ''COVID19'') ';
  end
  else if TStringUtils.IsEquals(UF, 'MT') then
  begin
    Result :=
      ' (COALESCE(DESPES.FONRO, DESDIS.FONRO) IN (72000, 73000, 74000, 75000, 76000, 77000, 80000) OR ' +
      ' COALESCE(EVCODIGO.FILTROPADRAO, '''') = ''COVID19'') ';
  end
  else if TStringUtils.IsEquals(UF, 'RN') then
  begin
    Result :=
      ' (COALESCE(DESPES.FRC, DESDIS.FONCODIGO) IN (919) OR COALESCE(EVCODIGO.FILTROPADRAO, '''') = ''COVID19'' OR ' +
      ' COALESCE(VINCODIGO.FILTROPADRAO, '''') = ''COVID19'') ';
  end
  else
    Result :=
      ' (COALESCE(VINCODIGO.FILTROPADRAO, '''') = ''COVID19'' OR COALESCE(EVCODIGO.FILTROPADRAO, '''') = ''COVID19'') ';
end;

function TSQLBase.GetFiltrosPesquisa: string;
begin
  Result := '';
end;

function TSQLBase.GetDataInicial: string;
begin
  Result := FParameters.GetAsString('DiaInicial') + '.' + FParameters.GetAsString('MesInicial') + '.' +
    FParameters.GetAsString('Exercicio');
end;

function TSQLBase.GetDataFinal: string;
begin
  Result := FParameters.GetAsString('DiaFinal') + '.' + FParameters.GetAsString('MesFinal') + '.' +
    FParameters.GetAsString('Exercicio');
end;

end.
