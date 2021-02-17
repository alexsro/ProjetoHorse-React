unit Utils.Strings;

interface

uses
  System.SysUtils, System.StrUtils, System.RegularExpressions;

type
  TStringUtils = class
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    class function RemoveAcentos(const Texto: string): string;
    class function RemoveCaracterEspeciais(const Texto: string): string;
    class function GetNumeros(const Valor: string; RemoverEspacos: boolean = true; FazerTrim: boolean = true): string;
    class function IsEquals(const ValueA, ValueB: string; CaseSensitive: boolean = false): boolean;
    class function IsEqualsAnd(const Value: string; Values: array of string; CaseSensitive: boolean = false): boolean;
    class function IsEqualsOr(const Value: string; Values: array of string; CaseSensitive: boolean = false): boolean;
    class function ToBoolean(const Value: string): boolean;
    class function IsTimestamp(const Value: string): boolean;
    class function IsTimesTampDB(const Value: string): boolean;
    class function IsDate(const Value: string): boolean;
    class function IsDateDB(const Value: string): boolean;
    class function UpperCase(const Value: string): string;
    class function UpperCaseQuoted(const Value: string): string;
    class function LowerCase(const Value: string): string;
    class function LowerCaseQuoted(const Value: string): string;
    class function Like(const Text, Search: string): boolean;
    class function DateJSONToDateTime(const Value: string): TDateTime;
    class function IsMatchRegex(const Value, Regex: string): boolean;
  end;

implementation

{ TStringUtils }

class function TStringUtils.DateJSONToDateTime(const Value: string): TDateTime;
var
  Dia, Mes, Ano, MudaData: string;
  rgxDataInvertidaHifen: TRegEx;
begin

  if not Trim(Value).IsEmpty then
  begin
    rgxDataInvertidaHifen.Create('^\d{4}-\d{2}-\d{2}$');

    if rgxDataInvertidaHifen.IsMatch(Value) then
    begin
      Ano := Copy(Value, 1, 4);
      Mes := Copy(Value, 6, 2);
      Dia := Copy(Value, 9, 2);

      if StrToIntDef(Mes, 0) > 12 then
      begin
        MudaData := Mes;
        Mes := Dia;
        Dia := MudaData;
      end;

      Result := StrToDate(Format('%s/%s/%s', [Dia, Mes, Ano]));
    end;

  end
  else
    raise EArgumentException.Create('Data JSON não pode ser vazia.');

end;

class function TStringUtils.IsEquals(const ValueA, ValueB: string; CaseSensitive: boolean): boolean;
begin
  // Favor NÃO usar Trim!
  // Pois podem existir casos de que é necessário comparar espaços
  // Se não quiser comparar espaços, passe a string sem espaços como parâmetro.
  if CaseSensitive then
  begin
    Result := ValueA = ValueB;
  end
  else
  begin
    Result := AnsiLowerCase(ValueA) = AnsiLowerCase(ValueB);
  end;
end;

class function TStringUtils.IsEqualsAnd(const Value: string; Values: array of string; CaseSensitive: boolean): boolean;
var
  ValueComparison: string;
begin
  Result := false;
  for ValueComparison in Values do
  begin
    Result := TStringUtils.IsEquals(Value, ValueComparison, CaseSensitive);
    if not Result then
      break;
  end;
end;

class function TStringUtils.IsEqualsOr(const Value: string; Values: array of string; CaseSensitive: boolean): boolean;
var
  ValueComparison: string;
begin
  Result := false;
  for ValueComparison in Values do
  begin
    Result := TStringUtils.IsEquals(Value, ValueComparison, CaseSensitive);
    if Result then
      break;
  end;
end;

class function TStringUtils.GetNumeros(const Valor: string; RemoverEspacos, FazerTrim: boolean): string;
var
  rgxSoNumeros: TRegEx;
begin

  rgxSoNumeros.Create('\D');

  Result := Valor;

  if RemoverEspacos then
    Result := rgxSoNumeros.Replace(Result, '')
  else
    Result := rgxSoNumeros.Replace(Result, ' ');

  if FazerTrim then
    Result := Result.Trim;

end;

class function TStringUtils.IsDate(const Value: string): boolean;
var
  rgxDate: TRegEx;
begin
  rgxDate.Create('^\d{2}\/\d{2}\/\d{4}$');

  Result := rgxDate.IsMatch(Value);
end;

class function TStringUtils.IsDateDB(const Value: string): boolean;
var
  rgxDateDB: TRegEx;
begin
  rgxDateDB.Create('^\d{2}\.\d{2}\.\d{4}$');

  Result := rgxDateDB.IsMatch(Value);
end;

class function TStringUtils.IsTimestamp(const Value: string): boolean;
var
  rgxTimestamp: TRegEx;
begin
  rgxTimestamp.Create('^\d{2}\/\d{2}\/\d{4}\s\d{2}:\d{2}:\d{2}$');

  Result := rgxTimestamp.IsMatch(Value);
end;

class function TStringUtils.IsTimesTampDB(const Value: string): boolean;
var
  rgxTimestampDB: TRegEx;
begin
  rgxTimestampDB.Create('^\d{2}\.\d{2}\.\d{4}\s\d{2}:\d{2}:\d{2}$');

  Result := rgxTimestampDB.IsMatch(Value);
end;

class function TStringUtils.Like(const Text, Search: string): boolean;
var
  rgxSearch: TRegEx;
begin
  Result := false;
  if (not Trim(Text).IsEmpty) and (not Trim(Search).IsEmpty) then
  begin
    rgxSearch.Create(Search);
    Result := rgxSearch.IsMatch(Text);
  end;
end;

class function TStringUtils.LowerCase(const Value: string): string;
begin
  Result := AnsiLowerCase(Value);
end;

class function TStringUtils.LowerCaseQuoted(const Value: string): string;
begin
  Result := QuotedStr(TStringUtils.LowerCase(Value));
end;

class function TStringUtils.IsMatchRegex(const Value, Regex: string): boolean;
var
 Rgx: TRegEx;
begin
  Result := false;

  if (Trim(Value).IsEmpty) or (Trim(Regex).IsEmpty) then
   raise EArgumentNilException.Create('Value e Regex não podem ser vazios.');

  Rgx.Create(Regex);

  Result := Rgx.IsMatch(Value);
end;

class function TStringUtils.RemoveAcentos(const Texto: string): string;
type
  USAscii20127 = type AnsiString(20127);
begin
  Result := string(USAscii20127(Texto));
end;

class function TStringUtils.RemoveCaracterEspeciais(const Texto: string): string;
const
  Especiais = '$@!?%&*ªº/\';
var
  I: integer;
begin
  Result := TStringUtils.RemoveAcentos(Texto.Trim);

  for I := 1 to Length(Especiais) do
  begin
    if CharInSet(Especiais[I], ['$']) then
      Result := Result.Replace(Especiais[I], 'S')
    else
      Result := Result.Replace(Especiais[I], '');
  end;

  Result := Result.Replace(' ', '_');
end;

class function TStringUtils.ToBoolean(const Value: string): boolean;
begin
  Result := false;
  if not Value.Trim.IsEmpty then
    Result := TStringUtils.IsEqualsOr(Value.Trim, ['s', 'sim', 'true', 't', 'yes', 'y']);
end;

class function TStringUtils.UpperCase(const Value: string): string;
begin
  Result := AnsiUpperCase(Value);
end;

class function TStringUtils.UpperCaseQuoted(const Value: string): string;
begin
  Result := QuotedStr(TStringUtils.UpperCase(Value));
end;

end.
