program Server_exe;

uses
  Vcl.Forms,
  uFrmServidor in 'uFrmServidor.pas' {frmServidor},
  Factorys.Connection.Intf in 'src\Components\Factorys\Factorys.Connection.Intf.pas',
  Factorys.Connection in 'src\Components\Factorys\Factorys.Connection.pas',
  Factorys.DataSet.Intf in 'src\Components\Factorys\Factorys.DataSet.Intf.pas',
  Factorys.DataSet in 'src\Components\Factorys\Factorys.DataSet.pas',
  JSONResponseManager.Interf in 'src\Components\JSONResponseManager\JSONResponseManager.Interf.pas',
  JSONResponseManager in 'src\Components\JSONResponseManager\JSONResponseManager.pas',
  Parameters.Default in 'src\Components\Parameters\Parameters.Default.pas',
  Parameters.Interf in 'src\Components\Parameters\Parameters.Interf.pas',
  Utils.DataSet in 'src\Components\Utils\Utils.DataSet.pas',
  Utils.Stream in 'src\Components\Utils\Utils.Stream.pas',
  Utils.Strings in 'src\Components\Utils\Utils.Strings.pas',
  Utils.Json in 'src\Components\Utils\Utils.Json.pas',
  Database.LoadConnections in 'src\Database\Database.LoadConnections.pas',
  Manager in 'src\Manager\Manager.pas',
  Models.FirebirdBaseConnections in 'src\Models\Models.FirebirdBaseConnections.pas',
  Models.FirebirdConnection in 'src\Models\Models.FirebirdConnection.pas',
  Models.FirebirdConnectionData in 'src\Models\Models.FirebirdConnectionData.pas',
  Registrators.Server.Middlewares in 'src\Registrators\Registrators.Server.Middlewares.pas',
  Registrators.Server.Routes in 'src\Registrators\Registrators.Server.Routes.pas',
  Interfaces.Controllers in 'src\Interfaces\Interfaces.Controllers.pas',
  Interfaces.Services in 'src\Interfaces\Interfaces.Services.pas',
  Services.Base in 'src\Services\Services.Base.pas',
  Helpers.HorseRequest in 'src\Helpers\Helpers.HorseRequest.pas',
  Controllers.Server.BarberShopTypeContact in 'src\Controllers\Controllers.Server.BarberShopTypeContact.pas',
  Services.Server.BarberShopTypeContact in 'src\Services\Services.Server.BarberShopTypeContact.pas',
  Helpers.HorseList in 'src\Helpers\Helpers.HorseList.pas',
  Models.Server.BarberShopTypeContact in 'src\Models\Models.Server.BarberShopTypeContact.pas',
  SQL.Server.BarberShopTypeContact in 'src\SQL\SQL.Server.BarberShopTypeContact.pas',
  SQL.Base in 'src\SQL\SQL.Base.pas',
  Validators.Server.BarberShopTypeContact in 'src\Validators\Validators.Server.BarberShopTypeContact.pas',
  Enum.BarberShopTypeContact in 'src\Enum\Enum.BarberShopTypeContact.pas',
  Enum.Message.Types in 'src\Enum\Enum.Message.Types.pas',
  Models.Message in 'src\Models\Models.Message.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := (DebugHook = 1);
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmServidor, FrmServidor);
  Application.Run;
end.
