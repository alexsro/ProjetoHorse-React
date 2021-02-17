program Auth;

{$APPTYPE CONSOLE}

uses
  Horse,
  System.SysUtils,
  System.JSON,
  FireDAC.Phys.PGDef,
  FireDAC.Stan.Intf,
  FireDAC.Phys,
  FireDAC.Phys.PG,
  Factorys.Connection.Intf in 'src\Components\Factorys\Factorys.Connection.Intf.pas',
  Factorys.Connection in 'src\Components\Factorys\Factorys.Connection.pas',
  Factorys.DataSet.Intf in 'src\Components\Factorys\Factorys.DataSet.Intf.pas',
  Factorys.DataSet in 'src\Components\Factorys\Factorys.DataSet.pas',
  Parameters.Default in 'src\Components\Parameters\Parameters.Default.pas',
  Parameters.Interf in 'src\Components\Parameters\Parameters.Interf.pas',
  Utils.DataSet in 'src\Components\Utils\Utils.DataSet.pas',
  Utils.Stream in 'src\Components\Utils\Utils.Stream.pas',
  Utils.Strings in 'src\Components\Utils\Utils.Strings.pas',
  Database.LoadConnections in 'src\Database\Database.LoadConnections.pas',
  Manager in 'src\Manager\Manager.pas',
  Models.FirebirdBaseConnections in 'src\Models\Models.FirebirdBaseConnections.pas',
  Models.FirebirdConnection in 'src\Models\Models.FirebirdConnection.pas',
  Models.FirebirdConnectionData in 'src\Models\Models.FirebirdConnectionData.pas',
  Registrators.Auth.Middlewares in 'src\Registrators\Registrators.Auth.Middlewares.pas',
  Registrators.Auth.Routes in 'src\Registrators\Registrators.Auth.Routes.pas',
  Interfaces.Services in 'src\Interfaces\Interfaces.Services.pas',
  Services.Base in 'src\Services\Services.Base.pas',
  Helpers.HorseList in 'src\Helpers\Helpers.HorseList.pas',
  Helpers.HorseRequest in 'src\Helpers\Helpers.HorseRequest.pas',
  Controllers.Auth.UserAuthentication in 'src\Controllers\Controllers.Auth.UserAuthentication.pas',
  Services.Auth.UserAuthentication in 'src\Services\Services.Auth.UserAuthentication.pas',
  SQL.Base in 'src\SQL\SQL.Base.pas',
  SQL.Auth.UserAuthentication in 'src\SQL\SQL.Auth.UserAuthentication.pas',
  Utils.Json in 'src\Components\Utils\Utils.Json.pas';

{$R *.res}


var
  driverPostgree : TFDPhysPgDriverLink;

begin
  driverPostgree := TFDPhysPgDriverLink.Create(nil);
  driverPostgree.DriverID := 'PG_DRIVER';
  driverPostgree.VendorLib := 'F:\Arquivos Desenvolvimento Geral\Reposit'#243'rios GitHub\Aprendizad' +
    'os-Geral\ProjetoHorse-React\backend\lib\libpq.dll';
  TManager.AddMiddlewares(RegisterMiddlewares);
  LoadDatabaseConnections;
  TManager.AddRoutes(RegisterRoutes);

  THorse.Listen(9001);
end.
