unit Enum.Message.Types;

interface

Type
  {$SCOPEDENUMS ON}
  TMessageTypes = (None, YesNo, Ok);
  {$SCOPEDENUMS OFF}

const
  typesMesageText: array [TMessageTypes] of string = ('Nenhuma mensagem', 'Mensagem Sim/N�o', 'Mensagem Ok');

implementation

end.
