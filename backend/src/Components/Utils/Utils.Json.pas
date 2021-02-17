unit Utils.Json;

interface

uses
  System.Classes, IdGlobal, IdCoder, IdCoderMIME, System.Generics.Collections, JSON, System.SysUtils;

type
  TJsonUtils = class
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    class function JObjectToStringsDictionary(const JsonObject: TJsonObject): TDictionary<string, string>;
  end;

implementation

{ TStreamUtils }

class function TJsonUtils.JObjectToStringsDictionary(const JsonObject: TJsonObject): TDictionary<string, string>;
var
  i: integer;
begin
  Result := TDictionary<string,string>.Create;
  for i := 0 to JsonObject.Count -1 do
  begin
    Result.Add(TRIM(Copy(JsonObject.Pairs[i].ToString, 1, pos(':', JsonObject.Pairs[i].ToString) - 1)).Replace('"',''),
      JsonObject.GetValue(TRIM(Copy(JsonObject.Pairs[i].ToString, 1,
      pos(':', JsonObject.Pairs[i].ToString) - 1)).Replace('"',''), ''));
  end;
end;

end.
