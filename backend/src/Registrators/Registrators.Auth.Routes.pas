unit Registrators.Auth.Routes;

interface

procedure RegisterRoutes;

implementation

uses
  Controllers.Auth.UserAuthentication;

procedure RegisterRoutes();
begin
  Controllers.Auth.UserAuthentication.Routes();
end;

end.
