unit Utils.Stream;

interface

uses
  System.Classes, IdGlobal, IdCoder, IdCoderMIME;

type
  TStreamUtils = class
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    class function ToBase64(const Stream: TStream): string;
  end;

implementation

{ TStreamUtils }

class function TStreamUtils.ToBase64(const Stream: TStream): string;
var
  Bytes: TIdBytes;
begin
  Result := '';
  if (not Assigned(Stream)) then
    Exit;

  Stream.Position := 0;
  SetLength(Bytes, Stream.Size);
  Stream.Read(Bytes[0], Stream.Size);
  Result := TIdEncoderMIME.EncodeBytes(Bytes);
end;

end.
