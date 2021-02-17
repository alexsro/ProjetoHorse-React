unit Validators.Server.BarberShopTypeContact;

interface

uses Models.Server.BarberShopTypeContact, system.SysUtils, Models.Message, system.Generics.Collections;

type

  TValidateBarberShopTypeContact = class
  private
    FBarberShopTypeContact: TBarberShopTypeContact;
    FValidateName: TMessage;
    FValidateNameLength: TMessage;
    function ValidateName: TMessage;
    function ValidateNameLength: TMessage;
    procedure setBarberShopTypeConta(const Value: TBarberShopTypeContact);
  public
    property BarberShopTypeContact: TBarberShopTypeContact write setBarberShopTypeConta;
    function Validate: TObjectList<TMessage>;
    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses Enum.Message.Types;

{ TValidateBarberShopTypeContact }

constructor TValidateBarberShopTypeContact.Create;
begin
  FValidateName := TMessage.Create;
  FValidateNameLength := TMessage.Create;
end;

destructor TValidateBarberShopTypeContact.Destroy;
begin
  FValidateName.Free;
  FValidateNameLength.Free;
  inherited;
end;

procedure TValidateBarberShopTypeContact.setBarberShopTypeConta(const Value: TBarberShopTypeContact);
begin
  FBarberShopTypeContact := Value;
end;

function TValidateBarberShopTypeContact.Validate: TObjectList<TMessage>;
begin
  result := TObjectList<TMessage>.Create;
  if self.ValidateName.Typee <> TMessageTypes.None then
    result.Add(FValidateName)
  else if self.ValidateNameLength.Typee <> TMessageTypes.None then
    result.Add(FValidateNameLength);
end;

function TValidateBarberShopTypeContact.ValidateName: TMessage;
begin
  if Trim(FBarberShopTypeContact.descr_btc) <> '' then
    FValidateName.Typee := TMessageTypes.None
  else
  begin
    FValidateName.Typee := TMessageTypes.Ok;
    FValidateName.Text := 'O campo DESCRIÇÃO é de preenchimento obrigatório';
    FValidateName.Title := 'Erro';
  end;
  result := FValidateName;
end;

function TValidateBarberShopTypeContact.ValidateNameLength: TMessage;
begin
  if FBarberShopTypeContact.descr_btc.Length > 10 then
    FValidateNameLength.Typee := TMessageTypes.None
  else
  begin
    FValidateNameLength.Typee := TMessageTypes.Ok;
    FValidateNameLength.Text := 'O campo DESCRIÇÃO deve possuir no mínimo 10 caracteres';
    FValidateNameLength.Title := 'Erro';
  end;
  result := FValidateNameLength;
end;


end.
