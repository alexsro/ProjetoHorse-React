unit JSONResponseManager.Interf;

interface

uses
  System.JSON, System.SysUtils, Data.DB, System.Generics.Collections;

type
{$SCOPEDENUMS ON}
TJSONType = (JSONArray, JSONObject, JSONVariosArrays);
{$SCOPEDENUMS OFF}
  IJSONResponseManager = interface
    ['{9A423683-AE36-4087-A12E-3D3C8BCF5411}']
    function SetData(const Value: TJSONValue): IJSONResponseManager; overload;
    function SetData(const Func: TFunc<TList<TJSONObject>>; const JSONType: TJSONType): IJSONResponseManager; overload;
    function SetRecords(const Func: TFunc<Integer>): IJSONResponseManager;
    function GetJSON: TJSONValue;
    procedure Send;
  end;

implementation

end.
