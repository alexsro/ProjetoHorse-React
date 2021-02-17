unit Controllers.Auth.UserAuthentication;

interface

uses
  Horse, Manager;

procedure Routes;

procedure Validate(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

uses
  Services.Auth.UserAuthentication;

procedure Routes;
begin
  THorse.
    post('/auth', Validate);
end;

procedure Validate(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  ServicesUserAuthentication: TServicesUserAuthentication;
begin
  ServicesUserAuthentication := TServicesUserAuthentication.Create(Req, Res, 'ProjetoHorseReact');
  try
    ServicesUserAuthentication.GetAutenticateResult;
  finally
    ServicesUserAuthentication.Free;
  end;
end;

end.
