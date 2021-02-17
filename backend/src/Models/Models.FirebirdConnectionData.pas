unit Models.FirebirdConnectionData;

interface

uses
  System.SysUtils, System.StrUtils;

type
  TFirebirdConnectionData = class
  private
    FServer: string;
    FPort: string;
    FDatabase: string;
    FUser: string;
    FPassword: string;
    FCharSet: string;
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    constructor Create; overload;
    constructor Create(const Server, Port, Database, User, Password: string; CharSet: string = 'WIN1252'); overload;
    destructor Destroy; override;

    property Server: string read FServer write FServer;
    property Port: string read FPort write FPort;
    property Database: string read FDatabase write FDatabase;
    property User: string read FUser write FUser;
    property Password: string read FPassword write FPassword;
    property CharSet: string read FCharSet write FCharSet;

    function GetStringConnection: string;
  end;

implementation

{ TConexaoFirebird }

constructor TFirebirdConnectionData.Create;
begin

end;

constructor TFirebirdConnectionData.Create(const Server, Port, Database, User, Password: string; CharSet: string);
begin
  FServer := Server;
  FPort := Port;
  FDatabase := Database;
  FUser := User;
  FPassword := Password;
  FCharSet := CharSet;
end;

destructor TFirebirdConnectionData.Destroy;
begin

  inherited;
end;

function TFirebirdConnectionData.GetStringConnection: string;
begin
  Result := Format('%s/%s:%s', [FServer, FPort, FDatabase]);
end;

end.
