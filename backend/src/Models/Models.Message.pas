unit Models.Message;

interface

uses Enum.Message.Types;

type
  TMessage = class
  private
    FType: TMessageTypes;
    FText: String;
    FTitle: String;
  public
    property Typee: TMessageTypes read FType write FType;
    property Text: String read FText write FText;
    property Title: String read FTitle write FTitle;
  end;

implementation

end.
