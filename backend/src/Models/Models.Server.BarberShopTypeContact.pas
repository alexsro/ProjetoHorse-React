unit Models.Server.BarberShopTypeContact;

interface

uses System.Generics.Collections, REST.JSON.Types, GBSwagger.Model.Attributes, GBSwagger.Validator.Attributes;

type
  TBarberShopTypeContact = class
  private
    // [JsonMarshalled(False)] //..n�o gerar no JSON
    Fid_btc: Integer;
    Fdescr_btc: String;
  public
    {$IFDEF SERVERAPI}
    [SwagRequired]
    {$ENDIF}
    property id_btc: Integer read Fid_btc write Fid_btc;
    {$IFDEF SERVERAPI}
    [SwagString(60)]
    {$ENDIF}
    property descr_btc: string read Fdescr_btc write Fdescr_btc;
  end;

implementation

{ TMedico }

end.
