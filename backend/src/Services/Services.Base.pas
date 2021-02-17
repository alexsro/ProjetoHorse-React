unit Services.Base;

interface

uses
  Interfaces.Services, FireDAC.Comp.Client, Horse, Helpers.HorseRequest, System.Classes, System.SysUtils, Manager;

Type
  TServicesBase = class(TInterfacedObject, IServices)
    private

    protected
      FReq: THorseRequest;
      FRes: THorseResponse;
      FConnection: TFDConnection;
      procedure PageQuery(const Query: TFDQuery);
      function SaveQuery(const Querys: array of TFDQuery): boolean;
    public
      constructor Create(const ConnectionName: string; AOwner: TComponent = nil); reintroduce; overload;
      constructor Create(const Req: THorseRequest; Res: THorseResponse; const ConnectionName: string; AOwner: TComponent = nil);
        reintroduce; overload;
      destructor Destroy; override;
  end;

implementation

uses
  FireDAC.Stan.Error, FireDAC.Comp.DataSet;

{ TServicesBase }

constructor TServicesBase.Create(const ConnectionName: string; AOwner: TComponent);
begin
  TManager.FirebirdBaseConnections.GetFiredacConnection(ConnectionName, FConnection);
  FReq := nil;
  FRes := nil;
end;

constructor TServicesBase.Create(const Req: THorseRequest; Res: THorseResponse; const ConnectionName: string;
  AOwner: TComponent);
begin
  Self.Create(ConnectionName, AOwner);
  FReq := Req;
  FRes := Res;
end;

destructor TServicesBase.Destroy;
begin
  FReq := nil;
  FRes := nil;
  //FreeAndNil(FConnection);
  inherited;
end;

procedure TServicesBase.PageQuery(const Query: TFDQuery);
begin
  if FReq.IsPaged then
  begin
    Query.FetchOptions.RecsMax := StrToIntDef(FReq.GetLimit, 25);
    Query.FetchOptions.RowsetSize := StrToIntDef(FReq.GetLimit, 25);
    Query.FetchOptions.RecsSkip := StrToIntDef(FReq.GetSkip, 0);
  end;
end;

function TServicesBase.SaveQuery(const Querys: array of TFDQuery): boolean;
var
  i, ErrosApply: integer;
  oErr: EFDException;
begin
  result := false;
  if not FConnection.InTransaction then
  begin
    FConnection.StartTransaction;
  end;
  try
    ErrosApply := 0;
    for i := 0 to Length(Querys) - 1 do
    begin
      if Querys[i].ChangeCount > 0 then
      begin
        ErrosApply := ErrosApply + Querys[i].ApplyUpdates(-1);

        if ErrosApply > 0 then
        begin
          Querys[i].FilterChanges := [rtModified, rtInserted, rtDeleted, rtHasErrors];
          try
            Querys[i].First;
            while not Querys[i].Eof do
            begin
              oErr := Querys[i].RowError;
              if oErr <> nil then
                raise Exception.Create(oErr.Message);
              Querys[i].Next;
            end;
          finally
            Querys[i].FilterChanges := [rtUnmodified, rtModified, rtInserted];
          end;

          Break;
        end;

      end;
    end;

    if ErrosApply = 0 then
    begin
      FConnection.Commit;
      for i := 0 to Length(Querys) - 1 do
      begin
        if Querys[i].ChangeCount > 0 then
          Querys[i].CommitUpdates;
      end;
      result := true;
    end
    else
      FConnection.Rollback;

  Except
    on e: Exception do
    begin
      IF FConnection.InTransaction THEN
        FConnection.Rollback;

      raise Exception.Create('<b>Lugar</b>: Classe %s ' + #13 + '<b>Método:</b> %s' + #13 + '<b>Descrição do Erro:</b> ' + #13 +
        e.Message);
    end;
  end;
end;

end.
