unit Factorys.DataSet;

interface

uses FireDAC.Comp.Client, Factorys.DataSet.Intf, System.Generics.Collections, Data.DB, FireDAC.DApt;

type
  TFactoryDataSet = class(TInterfacedObject, IFactoryDataSet)
  strict private
    FItems: TList<TFDQuery>;
    FConnection: TFDConnection;
  private
    constructor Create;
    function SetConnection(const AFDConnection: TFDConnection): IFactoryDataSet;
    function GetConnection: TFDConnection;
    function CreateQuery(const AOwns: Boolean = True): TFDQuery; overload;
    function CreateQuery(const ASQL: string; const AOwns: Boolean = True): TFDQuery; overload;
    function CreateQueryToArrayDML(const ASQL: string): TFDQuery;
    function ExecuteSQL(const ASQL: string): Boolean;
  public
    class function GetInstance(const AFDConnection: TFDConnection): IFactoryDataSet;
    destructor Destroy; override;
  end;

implementation

uses System.SysUtils, FireDAC.Stan.Option;

function TFactoryDataSet.CreateQuery(const AOwns: Boolean = True): TFDQuery;
begin
  Result := TFDQuery.Create(nil);
  Result.Connection := FConnection;
  Result.FetchOptions.AutoFetchAll := TFDAutoFetchAll.afTruncate;
  Result.ResourceOptions.SilentMode := True;
  if AOwns then
    FItems.Add(Result);
end;

function TFactoryDataSet.CreateQuery(const ASQL: string; const AOwns: Boolean = True): TFDQuery;
begin
  Result := Self.CreateQuery(AOwns);
  Result.Open(ASQL);
end;

function TFactoryDataSet.CreateQueryToArrayDML(const ASQL: string): TFDQuery;
begin
  Result := CreateQuery(False);
  Result.CachedUpdates := True;
  Result.SQL.Text := ASQL;
  Result.Params.ArraySize := 0;
end;

function TFactoryDataSet.ExecuteSQL(const ASQL: string): Boolean;
var
  LQuery: TFDQuery;
begin
  LQuery := Self.CreateQuery(False);
  try
    try
      LQuery.SQL.Text := ASQL;
      LQuery.ExecSQL;
      Result := True;
    except
      Result := False;
    end;
  finally
    LQuery.Free;
  end;
end;

function TFactoryDataSet.GetConnection: TFDConnection;
begin
  Result := FConnection;
end;

class function TFactoryDataSet.GetInstance(const AFDConnection: TFDConnection): IFactoryDataSet;
begin
  if not Assigned(AFDConnection) then
    raise Exception.Create('Connection is not defined');
  Result := TFactoryDataSet.Create;
  Result.SetConnection(AFDConnection);
end;

function TFactoryDataSet.SetConnection(const AFDConnection: TFDConnection): IFactoryDataSet;
begin
  Result := Self;
  if Assigned(AFDConnection) then
    FConnection := AFDConnection;
end;

constructor TFactoryDataSet.Create;
begin
  FItems := TObjectList<TFDQuery>.Create();
end;

destructor TFactoryDataSet.Destroy;
begin
  FreeAndNil(FItems);
  inherited;
end;

end.
