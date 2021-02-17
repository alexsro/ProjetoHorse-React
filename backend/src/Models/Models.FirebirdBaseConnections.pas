unit Models.FirebirdBaseConnections;

interface

uses
  System.Generics.Collections, Models.FirebirdConnectionData,
  System.SysUtils, Models.FirebirdConnection, System.StrUtils, FireDAC.Comp.Client;

type
  TFirebirdBaseConnections = class
  private
    { private declarations }
  protected
    { protected declarations }
    FConnectionsData: TObjectDictionary<string, TFirebirdConnectionData>;
    FConnections: TObjectDictionary<string, TFirebirdConnection>;
    function ConnectionDataExist(const Name: string): boolean;
    function ConnectionExist(const Name: string): boolean;
  public
    { public declarations }
    constructor Create;
    destructor Destroy; override;

    function Add(const Name, Server, Port, Database, User, Password: string;
      CharSet: string = 'WIN1252'): TFirebirdBaseConnections;
    function ConnectionDataRemove(const Name: string): TFirebirdBaseConnections;
    function GetConnectionData(const Name: string): TFirebirdConnectionData;
    function GetConnectionDataAvailable: TArray<string>; overload;
    function GetConnectionDataAvailable(const Filtro: TFunc<string, boolean>): TArray<string>; overload;
    function GetFiredacConnection(const Name: String; var Connection: TFDConnection): TFirebirdBaseConnections;
    procedure Clear;
    function CountConnectionData: integer;
  end;

implementation

uses
  Utils.Strings;

{ TFirebirdBaseConnections }

function TFirebirdBaseConnections.Add(const Name, Server, Port, Database, User, Password: string; CharSet: string)
  : TFirebirdBaseConnections;
begin
  Result := Self;
  Self.ConnectionDataRemove(Name);
  FConnectionsData.AddOrSetValue(TStringUtils.LowerCase(Name), TFirebirdConnectionData.Create(Server, Port, Database, User, Password, CharSet));
  FConnections.AddOrSetValue(TStringUtils.LowerCase(Name), TFirebirdConnection.Create(GetConnectionData(Name)));
end;

procedure TFirebirdBaseConnections.Clear;
begin
  FConnectionsData.Clear;
end;

function TFirebirdBaseConnections.ConnectionDataExist(const Name: string): boolean;
begin
  Result := false;
  if not FConnectionsData.ContainsKey(TStringUtils.LowerCase(Name)) then
    raise Exception.Create('Dados da conexão "' + Name +  '" não encontrados.');
  Result := true;
end;

function TFirebirdBaseConnections.ConnectionExist(const Name: string): boolean;
begin
  Result := false;
  if not FConnections.ContainsKey(TStringUtils.LowerCase(Name)) then
  begin
    if self.ConnectionDataExist(Name) then
    begin
      Result := true;
      FConnections.AddOrSetValue(TStringUtils.LowerCase(Name), TFirebirdConnection.Create(GetConnectionData(Name)));
    end;
  end
  else
    Result := true;
end;

function TFirebirdBaseConnections.CountConnectionData: integer;
begin
  Result := FConnectionsData.Count;
end;

constructor TFirebirdBaseConnections.Create;
begin
  FConnectionsData := TObjectDictionary<string, TFirebirdConnectionData>.Create([doOwnsValues]);
  FConnections := TObjectDictionary<string, TFirebirdConnection>.Create([doOwnsValues]);
end;

destructor TFirebirdBaseConnections.Destroy;
begin
  if Assigned(FConnectionsData) then
    FConnectionsData.Free;
  if Assigned(FConnections) then
    FConnections.Free;
  inherited;
end;

function TFirebirdBaseConnections.GetConnectionData(const Name: string): TFirebirdConnectionData;
begin
  Result := nil;
  Self.ConnectionDataExist(Name);
  Result := FConnectionsData.Items[TStringUtils.LowerCase(Name)];
end;

function TFirebirdBaseConnections.GetConnectionDataAvailable: TArray<string>;
begin
  Result := FConnectionsData.Keys.ToArray;
end;

function TFirebirdBaseConnections.GetConnectionDataAvailable(const Filtro: TFunc<string, boolean>): TArray<string>;
var
 Connection: string;
begin
  if not Assigned(Filtro) then
  begin
    Result := Self.GetConnectionDataAvailable;
    exit;
  end;

  SetLength(Result, 0);
  for Connection in Self.GetConnectionDataAvailable do
  begin
     if Filtro(Connection) then
     begin
        SetLength(Result, Length(Result)+1);
        Result[High(Result)] := Connection;
     end;
  end;
end;

function TFirebirdBaseConnections.ConnectionDataRemove(const Name: string): TFirebirdBaseConnections;
begin
  Result := Self;
  if FConnectionsData.ContainsKey(TStringUtils.LowerCase(Name)) then
    FConnectionsData.Remove(Name);
end;

function TFirebirdBaseConnections.GetFiredacConnection(const Name: String; var Connection: TFDConnection): TFirebirdBaseConnections;
begin
  if Self.ConnectionExist(Name) then
    Connection := FConnections.Items[TStringUtils.LowerCase(Name)].Connection;
end;

end.
