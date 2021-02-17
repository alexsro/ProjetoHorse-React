unit Parameters.Default;

interface

uses
  SysUtils, StrUtils, System.Generics.Collections, Parameters.Interf;

type
  IParameters = Parameters.Interf.IParameters;

  TParameters = class(TInterfacedObject, IParameters)
  private
    { private declarations }
    FParameters: TDictionary<string, string>;
  protected
    { protected declarations }
    function StrToBoolean(Value: string): boolean;

    procedure Copy(const OthersParameters: IParameters);
    function Count: integer;
    function Exists(const Nome: string): boolean;

    function GetParameters: TList<string>;

    function GetAsString(const NameParameter: string): string;
    function GetAsInteger(const NameParameter: string): integer;
    function GetAsBoolean(const NameParameter: string): boolean;
    function GetAsCurrency(const NameParameter: string): Currency;

    function Add(const NameParameter: string; const ValueParameter: string): IParameters; overload;
    function Add(const NameParameter: string; const ValueParameter: integer): IParameters; overload;
    function Add(const NameParameter: string; const ValueParameter: boolean): IParameters; overload;
    function Add(const NameParameter: string; const ValueParameter: Currency): IParameters; overload;
    function Add(const Parameters: TDictionary<string,string>): IParameters; overload;

    function SetValue(const NameParameter: string; const ValueParameter: string): IParameters; overload;
    function SetValue(const NameParameter: string; const ValueParameter: integer): IParameters; overload;
    function SetValue(const NameParameter: string; const ValueParameter: boolean): IParameters; overload;
    function SetValue(const NameParameter: string; const ValueParameter: Currency): IParameters; overload;
  public
    { public declarations }
    constructor Create;
    destructor Destroy; override;
  end;

implementation

{ TParameters }

function TParameters.Add(const NameParameter, ValueParameter: string): IParameters;
begin
  FParameters.AddOrSetValue(NameParameter.ToLower, ValueParameter);
  Result := Self;
end;

function TParameters.Add(const NameParameter: string; const ValueParameter: integer): IParameters;
begin
  Result := Self.Add(NameParameter, ValueParameter.ToString);
end;

function TParameters.Add(const NameParameter: string; const ValueParameter: boolean): IParameters;
begin
  Result := Self.Add(NameParameter, ifThen(ValueParameter, 'S', 'N'));
end;

function TParameters.Add(const NameParameter: string; const ValueParameter: Currency): IParameters;
begin
  Result := Self.Add(NameParameter, CurrToStr(ValueParameter));
end;

function TParameters.Add(const Parameters: TDictionary<string, string>): IParameters;
var
 Pair: TPair<string, string>;
begin
  Result := Self;
  for Pair in Parameters do
    Self.Add(Pair.Key, Pair.Value);
end;

procedure TParameters.Copy(const OthersParameters: IParameters);
var
  Parametro: string;
begin
  FParameters.Clear;

  for Parametro in OthersParameters.GetParameters do
    FParameters.Add(Parametro, OthersParameters.GetAsString(Parametro));
end;

function TParameters.Count: integer;
begin
  Result := FParameters.Count;
end;

constructor TParameters.Create;
begin
  FParameters := TDictionary<string, string>.Create;
end;

destructor TParameters.Destroy;
begin
  FParameters.Free;
  FParameters := nil;
  inherited;
end;

function TParameters.Exists(const Nome: string): boolean;
begin
  Result := Self.FParameters.ContainsKey(Nome.ToLower);
end;

function TParameters.GetAsBoolean(const NameParameter: string): boolean;
begin
  Result := Self.StrToBoolean(Self.GetAsString(NameParameter));
end;

function TParameters.GetAsCurrency(const NameParameter: string): Currency;
begin
  Result := StrToCurrDef(GetAsString(NameParameter), -1);
end;

function TParameters.GetAsInteger(const NameParameter: string): integer;
begin
  Result := StrToIntDef(GetAsString(NameParameter), -1);
end;

function TParameters.GetAsString(const NameParameter: string): string;
var
  Value: string;
begin
  if FParameters.TryGetValue(NameParameter.ToLower, value) then
    result := value
  else
    result := '';
end;

function TParameters.GetParameters: TList<string>;
begin
  Result := TList<string>.Create(FParameters.Keys);
end;

function TParameters.SetValue(const NameParameter: string; const ValueParameter: Currency): IParameters;
begin
  Result := Self.SetValue(NameParameter, CurrToStr(ValueParameter));
end;

function TParameters.StrToBoolean(Value: string): boolean;
begin
  Value := Trim(AnsiLowerCase(Value));
  Result := (Value = 'true') or (Value = 's') or (Value = 'sim');
end;

function TParameters.SetValue(const NameParameter, ValueParameter: string): IParameters;
begin
  if FParameters.ContainsKey(NameParameter) then
    Self.Add(NameParameter, ValueParameter);
  Result := Self;
end;

function TParameters.SetValue(const NameParameter: string; const ValueParameter: integer): IParameters;
begin
  Result := Self.SetValue(NameParameter, ValueParameter.ToString);
end;

function TParameters.SetValue(const NameParameter: string; const ValueParameter: boolean): IParameters;
begin
  Result := Self.SetValue(NameParameter, ifThen(ValueParameter, 'S', 'N'));
end;

end.
