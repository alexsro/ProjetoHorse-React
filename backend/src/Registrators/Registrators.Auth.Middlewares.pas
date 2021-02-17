unit Registrators.Auth.Middlewares;

interface

uses
  Horse;

procedure RegisterMiddlewares;
//procedure SwaggerConfig;

implementation

uses
  Horse.Jhonson, Horse.HandleException, Horse.CORS;

procedure RegisterMiddlewares;
begin
  THorse.Use(CORS);
  THorse.Use(Jhonson);
  THorse.Use(HandleException);
  //SwaggerConfig;
end;

//procedure SwaggerConfig;
//begin
//  Swagger
//    {Esta configura��o deve ser preenchida ao colocar a aplica��o no iis
//    .Config
//      .ModuleName('"nome da aplica��o"/"nome da dll"')
//    .&End}
//    .Info
//      .Title('API Projeto horse/react')
//      .Description('Documenta��o da API horse/react ')
//      .Contact
//        .Name('alex000sander@gmail.com')
//        //.URL('http://www.fiorilli.com.br')
//      .&End
//    .&End;
//    {Esta configura��o deve ser preenchida ao colocar a aplica��o no iis
//    .BasePath('"nome da aplica��o"/"nome da dll"');}
//end;



end.