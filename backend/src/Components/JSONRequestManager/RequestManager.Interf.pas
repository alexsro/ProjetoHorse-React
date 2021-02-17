unit RequestManager.Interf;

interface

uses REST.Client, REST.Response.Adapter, REST.Types, System.SysUtils, System.JSON, System.Classes, Data.DB,
  RESTRequest4D.Request, Models.Pagination;

type
  IRequestManager = interface
    ['{0F16AA1B-E6E3-43C9-97B4-6F3100CC200F}']
    function BaseURL(const Value: string): IRequestManager; overload;
    function BaseURL: string; overload;
    function Resource(const Value: string): IRequestManager; overload;
    function Resource: string; overload;
    function ResourceSuffix(const Value: string): IRequestManager; overload;
    function ResourceSuffix: string; overload;
    function Pagination(const Value: TPagination): IRequestManager; overload;
    function Pagination: TPagination; overload;
    function DataSetAdapter(const Value: TDataSet; ClearFields: boolean = true): IRequestManager; overload;
    function DataSetAdapter: TDataSet; overload;
    function FullRequestURL(const IncluirParametros: Boolean = True): string;
    function AddHeader(const Name, Value: string; const Options: TRESTRequestParameterOptions = []): IRequestManager;
    function AddParam(const Name, Value: string; const Kind: TRESTRequestParameterKind = TRESTRequestParameterKind.pkGETorPOST): IRequestManager;
    function Get: IResponse;
    function GetPaginate: IResponse;
  end;

implementation

end.
