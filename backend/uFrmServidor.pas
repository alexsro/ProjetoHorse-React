unit uFrmServidor;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls,
  Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Horse, Manager, Registrators.Server.Routes,
  Registrators.Server.Middlewares, Database.LoadConnections, System.IniFiles, System.StrUtils, Winapi.UrlMon, Vcl.Menus,
  Vcl.AppEvnts, DataSet.Serialize, DataSet.Serialize.Config, FireDAC.Phys.PGDef, FireDAC.Stan.Intf, FireDAC.Phys,
  FireDAC.Phys.PG;

type
  TfrmServidor = class(TForm)
    edtPorta: TLabeledEdit;
    btnIniciar: TButton;
    btnParar: TButton;
    AppEvents: TApplicationEvents;
    PopupTrayIcon: TPopupMenu;
    mitIniciar: TMenuItem;
    mitParar: TMenuItem;
    N1: TMenuItem;
    mitFechar: TMenuItem;
    TrayIcon: TTrayIcon;
    btnFechar: TButton;
    FDPhysPgDriverLink1: TFDPhysPgDriverLink;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure mitIniciarClick(Sender: TObject);
    procedure mitPararClick(Sender: TObject);
    procedure mitFecharClick(Sender: TObject);
    procedure AppEventsMinimize(Sender: TObject);
    procedure TrayIconDblClick(Sender: TObject);
  private
    procedure IniciarServidor;
    procedure ShowTrayMessage(const Msg: string; IconFlag: TBalloonFlags; Title: string);
    procedure SalvarPorta;
    procedure AtivarOpcoes(const Value: boolean);
    procedure CarregarPorta;
    procedure FinalizarServidor;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmServidor: TfrmServidor;

implementation

uses
  System.IOUtils;

{$R *.dfm}

procedure TfrmServidor.FormCreate(Sender: TObject);
begin
  Application.ShowMainForm := false;

  TrayIcon.Hint := 'Servidor Horse VCL - ' + TPath.GetFileNameWithoutExtension(Application.ExeName);
  CarregarPorta;

  AtivarOpcoes(True);
  mitIniciarClick(mitIniciar);
end;

procedure TfrmServidor.FormDestroy(Sender: TObject);
begin
  FinalizarServidor;
end;

procedure TfrmServidor.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SalvarPorta;
end;

procedure TFrmServidor.mitIniciarClick(Sender: TObject);
begin
  if Trim(edtPorta.Text).IsEmpty then
  begin
    ShowMessage('Informe a porta.');
    edtPorta.SetFocus;
    Exit;
  end;

  IniciarServidor;
  AtivarOpcoes(False);
end;

procedure TFrmServidor.mitPararClick(Sender: TObject);
begin
  FinalizarServidor;
  AtivarOpcoes(True);
end;

procedure TFrmServidor.mitFecharClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmServidor.AppEventsMinimize(Sender: TObject);
begin
  Self.Hide();
  Self.WindowState := wsMinimized;
end;

procedure TfrmServidor.TrayIconDblClick(Sender: TObject);
begin
  Self.Show();
  WindowState := wsNormal;
  Application.BringToFront();
end;

procedure TFrmServidor.IniciarServidor;
begin
  TManager.AddMiddlewares(RegisterMiddlewares);

  if not LoadDatabaseConnections then
    showmessage('Nenhuma conex�o foi encontrada! Verifique a configura��o do arquivo servidor.ini');

  TManager.AddRoutes(RegisterRoutes);

  THorse.Listen(StrToIntDef(edtPorta.Text, 9000));
end;

procedure TFrmServidor.ShowTrayMessage(const Msg: string; IconFlag: TBalloonFlags; Title: string);
begin
  TrayIcon.BalloonHint := Msg;
  TrayIcon.BalloonFlags := IconFlag;
  TrayIcon.BalloonTitle := Title;
  if Trim(TrayIcon.BalloonTitle).IsEmpty then
    TrayIcon.BalloonTitle := TPath.GetFileNameWithoutExtension(Application.ExeName);

  TrayIcon.ShowBalloonHint();
end;

procedure TFrmServidor.SalvarPorta;
var
  Ini: TIniFile;
begin

  Ini := TIniFile.Create(IncludeTrailingPathDelimiter(TDirectory.GetCurrentDirectory) + 'servidorVCL.ini');
  try
    Ini.WriteString('CONFIGURACAO', 'PORTA', ifThen(not Trim(edtPorta.Text).IsEmpty, edtPorta.Text, '7000'));
  finally
    Ini.Free;
  end;

end;

procedure TFrmServidor.AtivarOpcoes(const Value: boolean);
begin
  edtPorta.Enabled := Value;

  btnIniciar.Enabled := Value;
  mitIniciar.Enabled := Value;

  btnParar.Enabled := not Value;
  mitParar.Enabled := not Value;
end;

procedure TFrmServidor.CarregarPorta;
var
  Ini: TIniFile;
begin

  Ini := TIniFile.Create(IncludeTrailingPathDelimiter(TDirectory.GetCurrentDirectory) + 'servidorVCL.ini');
  try
    edtPorta.Text := Ini.ReadString('CONFIGURACAO', 'PORTA', '9000');
  finally
    Ini.Free;
  end;

end;

procedure TFrmServidor.FinalizarServidor;
begin
  THorse.StopListen;
  TManager.FreeInstance;
end;


end.
