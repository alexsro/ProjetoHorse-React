unit Registrators.Server.Routes;

interface

procedure RegisterRoutes;

implementation

uses
  Horse.GBSWAGGER, Controllers.Server.BarberShopTypeContact;

procedure RegisterRoutes;
begin
  THorseGBSwaggerRegister.RegisterPath(TControllersBarberShopTypeContact);
end;


end.
