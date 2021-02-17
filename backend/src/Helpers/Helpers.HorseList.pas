unit Helpers.HorseList;

interface

uses
  Horse.HTTP, Parameters.Interf, System.Generics.Collections;

type
  THorseListHelper = class helper for THorseList
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    function ToParametros: IParameters;
  end;

implementation

uses
  Parameters.Default;

{ THorseListHelper }

function THorseListHelper.ToParametros: IParameters;
var
 Param: TPair<string, string>;
begin
  Result := TParameters.Create;
  for Param in Self do
    Result.Add(Param.Key, Param.Value);
end;

end.
