unit Manager;

interface

uses
  Horse, System.SysUtils, System.Generics.Collections,
  Models.FirebirdBaseConnections, System.StrUtils, System.Hash;

type
  TManager = class
  private
    { private declarations }
  protected
    { protected declarations }
    class var FFirebirdBaseConnections: TFirebirdBaseConnections;
    class var FInstanceManager: TManager;
    constructor Create; overload;
    destructor Destroy; override;
  public
    { public declarations }
    class property FirebirdBaseConnections: TFirebirdBaseConnections read FFirebirdBaseConnections;

    class destructor UnInitialize;

    class function AddRoutes(const RegisterRoutes: TProc): TManager;
    class function AddMiddlewares(const RegisterMiddlewares: TProc): TManager;

    class function GetServerPath: string;
    class function GetTempPath: string;
    class function GetNewTempFolder: string;
    class function IsDebugging: boolean;

    class function GetInstance: TManager;
    class procedure FreeInstance;
    class function ReleaseAPIDocumentation:boolean;
  end;

implementation

uses
  System.IOUtils;

{ TManager }

class function TManager.AddMiddlewares(const RegisterMiddlewares: TProc): TManager;
begin
  Result := TManager.GetInstance;
  if Assigned(RegisterMiddlewares) then
    RegisterMiddlewares();
end;

class function TManager.AddRoutes(const RegisterRoutes: TProc): TManager;
begin
  Result := TManager.GetInstance;
  if Assigned(RegisterRoutes) then
    RegisterRoutes();
end;

constructor TManager.Create;
begin
  if FFirebirdBaseConnections = nil then
    FFirebirdBaseConnections := TFirebirdBaseConnections.Create;
end;

destructor TManager.Destroy;
begin
  if Assigned(FFirebirdBaseConnections) then
    FFirebirdBaseConnections.Free;
  FFirebirdBaseConnections := nil;
  inherited;
end;

class function TManager.GetInstance: TManager;
begin
  if FInstanceManager = nil then
    FInstanceManager := TManager.Create;
  Result := FInstanceManager;
end;

class function TManager.GetNewTempFolder: string;
begin
  Result := IncludeTrailingPathDelimiter(
    Self.GetTempPath +
    THashBobJenkins.GetHashString(FormatDateTime('YYYYMMDDHHNNSSZZZ', Now))
    );
  if not DirectoryExists(Result) then
    ForceDirectories(Result);
end;

class function TManager.GetServerPath: string;
begin
  Result := '';
{$IFDEF MSWINDOWS}
  Result := GetModuleName(HInstance).Replace('\\?\', '');
  if not Trim(Result).IsEmpty then
    Result := IncludeTrailingPathDelimiter(ExtractFilePath(Result));
{$ELSE}
  raise EHorseException.Create('Recuperação do caminho do servidor não definido para essa plataforma.');
{$ENDIF}
end;

class function TManager.GetTempPath: string;
begin
  Result := IncludeTrailingPathDelimiter(Self.GetServerPath + 'temp');
  if not DirectoryExists(Result) then
    ForceDirectories(Result);
end;

class function TManager.IsDebugging: boolean;
begin
{$IFDEF MSWINDOWS}
{$WARNINGS Off}
  Result := (DebugHook = 1);
{$WARNINGS On}
{$ELSE}
  Result := false;
  raise EHorseException.Create('Verificação de depuração não definida para essa plataforma.');
{$ENDIF}
end;

class function TManager.ReleaseAPIDocumentation: boolean;
begin
 result := IsDebugging;
end;

class destructor TManager.UnInitialize;
begin
  TManager.FreeInstance;
end;


class procedure TManager.FreeInstance;
begin
  if Assigned(FInstanceManager) then
    FInstanceManager.Free;
  FInstanceManager := nil;
end;

end.
