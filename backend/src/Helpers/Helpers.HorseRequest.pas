unit Helpers.HorseRequest;

interface

uses
  Horse.HTTP, Parameters.Interf, System.Generics.Collections, System.SysUtils,
  System.StrUtils;

type
  THorseRequestHelper = class helper for THorseRequest
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    function IsPaged: boolean;
    function GetLimit: string;
    function GetSkip: string;
  end;

implementation

{ THorseRequestHelper }

function THorseRequestHelper.GetLimit: string;
var
  LLimit: string;
begin
  if not Self.Query.TryGetValue('limit', LLimit) then
    LLimit := '25';
  Result := LLimit;
end;

function THorseRequestHelper.GetSkip: string;
Var
 LSkip: string;
begin
  if not Self.Query.TryGetValue('skip', LSkip) then
    LSkip := '0';
  Result := LSkip;
end;

function THorseRequestHelper.IsPaged: boolean;
begin
  Result := Self.Headers['X-Paginate'] = 'true';
end;

end.
