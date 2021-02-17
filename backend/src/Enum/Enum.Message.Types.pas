unit Enum.Message.Types;

interface

Type
  {$SCOPEDENUMS ON}
  TMessageTypes = (None, YesNo, Ok);
  {$SCOPEDENUMS OFF}

const
  typesMesageText: array [TMessageTypes] of string = ('Nenhuma mensagem', 'Mensagem Sim/Não', 'Mensagem Ok');

implementation

end.
