unit Interfaces.Services;

interface

uses
  System.Generics.Collections, FireDAC.Comp.Client;

Type
  IServices = interface
    procedure PageQuery(const Query: TFDQuery);
  end;

implementation

end.
