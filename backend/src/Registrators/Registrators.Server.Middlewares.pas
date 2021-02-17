unit Registrators.Server.Middlewares;

interface

uses
  Horse;

procedure RegisterMiddlewares;
procedure SwaggerConfig;

implementation

uses
  Horse.Jhonson, Horse.HandleException, Horse.CORS, Horse.OctetStream, Horse.GBSwagger, Horse.ETag,
  Horse.JWT, GBSwagger.Model.Types;

procedure RegisterMiddlewares;
begin
  THorse.Use(HorseJWT('TokenJWT'));
  THorse.Use(CORS);
  THorse.Use(OctetStream);
  THorse.Use(HorseSwagger);
  THorse.Use(Jhonson);
  THorse.Use(HandleException);
  THorse.Use(ETag);
  SwaggerConfig;
end;

procedure SwaggerConfig;
begin
  Swagger
    {Esta configuração deve ser preenchida ao colocar a aplicação no iis
    .Config
      .ModuleName('"nome da aplicação"/"nome da dll"')
    .&End}
    .Info
      .Title('API Projeto horse/react')
      .Description('Documentação da API horse/react ')
      .Contact
        .Name('alex000sander@gmail.com')
        //.URL('http://www.fiorilli.com.br')
      .&End
    .&End
    {Esta configuração deve ser preenchida ao colocar a aplicação no iis
    .BasePath('"nome da aplicação"/"nome da dll"');}
end;



end.
