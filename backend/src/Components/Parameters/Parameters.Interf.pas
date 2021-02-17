unit Parameters.Interf;

interface

uses
  System.Generics.Collections;

type
  /// <summary>
  /// Representa uma lista de par�metros que pode ser passada para qualquer componente.
  /// </summary>
  /// <remarks>
  /// <para>Serve para evitar criar propriedades, records e vari�veis p�blicas para passagem de par�metro.</para>
  /// </remarks>
  IParameters = interface
  ['{E7485F1B-E349-4D57-9C81-5622667D251C}']
     /// <summary>
     /// Copia os par�metros passado como par�metro e descarta os par�metros atuais.
     /// </summary>
     procedure Copy(const OthersParameters: IParameters);
     /// <summary>
     /// Quantidade de par�metros salvos.
     /// </summary>
     function Count: integer;
     /// <summary>
     /// Verifica se existe o par�metro.
     /// </summary>
     function Exists(const Name: string): boolean;
     /// <summary>
     /// Obt�m uma lista dos par�metros salvos.
     /// </summary>
     function GetParameters: TList<String>;
     /// <summary>
     /// Retorna '' se o par�metro n�o existir.
     /// </summary>
     function GetAsString(const NameParameter: string): string;
     /// <summary>
     /// Retorna -1 se o par�metro n�o existir.
     /// </summary>
     function GetAsInteger(const NameParameter: string): integer;
     /// <summary>
     /// Retorna False se o par�metro n�o existir.
     /// </summary>
     function GetAsBoolean(const NameParameter: string): boolean;
     /// <summary>
     /// Retorna -1 se o par�metro n�o existir.
     /// </summary>
     function GetAsCurrency(const NameParameter: string): currency;
     /// <summary>
     /// Adiciona um par�metro do tipo string.
     /// </summary>
     /// <remarks>
     /// ATEN��O: Se o par�metro j� existir seu valor ser� alterado.
     /// </remarks>
     function Add(const NameParameter: string; const ValueParameter: string): IParameters; overload;
     /// <summary>
     /// Adiciona um par�metro do tipo integer.
     /// </summary>
     /// <remarks>
     /// ATEN��O: Se o par�metro j� existir seu valor ser� alterado.
     /// </remarks>
     function Add(const NameParameter: string; const ValueParameter: integer): IParameters; overload;
     /// <summary>
     /// Adiciona um par�metro do tipo boolean.
     /// </summary>
     /// <remarks>
     /// ATEN��O: Se o par�metro j� existir seu valor ser� alterado.
     /// </remarks>
     function Add(const NameParameter: string; const ValueParameter: boolean): IParameters; overload;
     /// <summary>
     /// Adiciona um par�metro do tipo currency.
     /// </summary>
     /// <remarks>
     /// ATEN��O: Se o par�metro j� existir seu valor ser� alterado.
     /// </remarks>
     function Add(const NameParameter: string; const ValueParameter: currency): IParameters; overload;
     function Add(const Parameter: TDictionary<string,string>): IParameters; overload;
     /// <summary>
     /// Altera o valor do par�metro do tipo string.
     /// </summary>
     /// <remarks>
     /// Se o par�metro n�o existir, nada ser� feito.
     /// </remarks>
     function SetValue(const NameParameter: string; const ValueParameter: string): IParameters; overload;
     /// <summary>
     /// Altera o valor do par�metro do tipo integer.
     /// </summary>
     /// <remarks>
     /// Se o par�metro n�o existir, nada ser� feito.
     /// </remarks>
     function SetValue(const NameParameter: string; const ValueParameter: integer): IParameters; overload;
     /// <summary>
     /// Altera o valor do par�metro do tipo boolean.
     /// </summary>
     /// <remarks>
     /// Se o par�metro n�o existir, nada ser� feito.
     /// </remarks>
     function SetValue(const NameParameter: string; const ValueParameter: boolean): IParameters; overload;
     /// <summary>
     /// Altera o valor do par�metro do tipo currency.
     /// </summary>
     /// <remarks>
     /// Se o par�metro n�o existir, nada ser� feito.
     /// </remarks>
     function SetValue(const NameParameter: string; const ValueParameter: currency): IParameters; overload;

  end;


implementation

end.
