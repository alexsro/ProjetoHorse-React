unit Factorys.Connection;

interface

uses FireDAC.Comp.Client, Factorys.Connection.Intf, System.Generics.Collections, Data.DB, FireDAC.DApt;

  Type TFactoryConnection = class(TInterfacedObject,IFactoryConnection)
  strict private
    FItems: TList<TFDConnection>;
    FConnection: TFDConnection;
  private
    constructor Create;
    function CreateConnectionPostgres(const AOwns: Boolean = True): TFDConnection;
    function CreateConnectionFirebird(const AOwns: Boolean = True): TFDConnection;
  public
    class function GetInstance(): IFactoryConnection;
    destructor Destroy; override;
  end;

{ TFactoryConnection }

implementation

uses System.SysUtils, FireDAC.Stan.Option;

function TFactoryConnection.CreateConnectionFirebird(const AOwns: Boolean): TFDConnection;
begin
  Result := TFDConnection.Create(nil);
  Result.DriverName := 'FB';
  if AOwns then
    FItems.Add(Result);
end;

function TFactoryConnection.CreateConnectionPostgres(const AOwns: Boolean): TFDConnection;
begin
  Result := TFDConnection.Create(nil);
  Result.DriverName := 'PG_DRIVER';
  if AOwns then
    FItems.Add(Result);
end;

class function TFactoryConnection.GetInstance: IFactoryConnection;
begin
  result := TFactoryConnection.Create;
end;

constructor TFactoryConnection.Create;
begin
  FItems := TObjectList<TFDConnection>.Create();
end;

destructor TFactoryConnection.Destroy;
begin
  FreeAndNil(FItems);
  inherited;
end;


end.
