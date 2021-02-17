unit Models.FirebirdConnection;

interface

uses
  System.SysUtils, System.StrUtils, Models.FirebirdConnectionData,
  FireDAC.Comp.Client;

type
  TFirebirdConnection = class
  strict private
    FConnection: TFDConnection;
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    constructor Create; overload;
    constructor Create(ConnectionData: TFirebirdConnectionData); overload;
    destructor Destroy; override;
    property Connection: TFDConnection read FConnection;
  end;

implementation

uses
  Factorys.Connection;

{ TConexaoFirebird }

constructor TFirebirdConnection.Create;
begin

end;

constructor TFirebirdConnection.Create(ConnectionData: TFirebirdConnectionData);
begin
  FConnection := TFactoryConnection.GetInstance.CreateConnectionFirebird(false);
  FConnection.Params.Values['DriverID'] := 'PG_DRIVER';
  FConnection.Params.Values['Server'] := ConnectionData.Server;
  FConnection.Params.Values['Port'] := ConnectionData.Port;
  FConnection.Params.Values['Database'] := ConnectionData.DataBase;

  FConnection.Params.Values['User_Name'] := ConnectionData.User;
  FConnection.Params.Values['Password'] := ConnectionData.Password;
  FConnection.Params.Values['CharacterSet'] := ifThen(not Trim(ConnectionData.CharSet).IsEmpty,
    ConnectionData.CharSet, 'NONE');
end;

destructor TFirebirdConnection.Destroy;
begin

  inherited;
end;

end.
