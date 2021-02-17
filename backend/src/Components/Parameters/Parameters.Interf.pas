unit Parameters.Interf;

interface

uses
  System.Generics.Collections;

type
  /// <summary>
  /// Representa uma lista de parâmetros que pode ser passada para qualquer componente.
  /// </summary>
  /// <remarks>
  /// <para>Serve para evitar criar propriedades, records e variáveis públicas para passagem de parâmetro.</para>
  /// </remarks>
  IParameters = interface
  ['{E7485F1B-E349-4D57-9C81-5622667D251C}']
     /// <summary>
     /// Copia os parâmetros passado como parâmetro e descarta os parâmetros atuais.
     /// </summary>
     procedure Copy(const OthersParameters: IParameters);
     /// <summary>
     /// Quantidade de parâmetros salvos.
     /// </summary>
     function Count: integer;
     /// <summary>
     /// Verifica se existe o parâmetro.
     /// </summary>
     function Exists(const Name: string): boolean;
     /// <summary>
     /// Obtém uma lista dos parâmetros salvos.
     /// </summary>
     function GetParameters: TList<String>;
     /// <summary>
     /// Retorna '' se o parâmetro não existir.
     /// </summary>
     function GetAsString(const NameParameter: string): string;
     /// <summary>
     /// Retorna -1 se o parâmetro não existir.
     /// </summary>
     function GetAsInteger(const NameParameter: string): integer;
     /// <summary>
     /// Retorna False se o parâmetro não existir.
     /// </summary>
     function GetAsBoolean(const NameParameter: string): boolean;
     /// <summary>
     /// Retorna -1 se o parâmetro não existir.
     /// </summary>
     function GetAsCurrency(const NameParameter: string): currency;
     /// <summary>
     /// Adiciona um parâmetro do tipo string.
     /// </summary>
     /// <remarks>
     /// ATENÇÃO: Se o parâmetro já existir seu valor será alterado.
     /// </remarks>
     function Add(const NameParameter: string; const ValueParameter: string): IParameters; overload;
     /// <summary>
     /// Adiciona um parâmetro do tipo integer.
     /// </summary>
     /// <remarks>
     /// ATENÇÃO: Se o parâmetro já existir seu valor será alterado.
     /// </remarks>
     function Add(const NameParameter: string; const ValueParameter: integer): IParameters; overload;
     /// <summary>
     /// Adiciona um parâmetro do tipo boolean.
     /// </summary>
     /// <remarks>
     /// ATENÇÃO: Se o parâmetro já existir seu valor será alterado.
     /// </remarks>
     function Add(const NameParameter: string; const ValueParameter: boolean): IParameters; overload;
     /// <summary>
     /// Adiciona um parâmetro do tipo currency.
     /// </summary>
     /// <remarks>
     /// ATENÇÃO: Se o parâmetro já existir seu valor será alterado.
     /// </remarks>
     function Add(const NameParameter: string; const ValueParameter: currency): IParameters; overload;
     function Add(const Parameter: TDictionary<string,string>): IParameters; overload;
     /// <summary>
     /// Altera o valor do parâmetro do tipo string.
     /// </summary>
     /// <remarks>
     /// Se o parâmetro não existir, nada será feito.
     /// </remarks>
     function SetValue(const NameParameter: string; const ValueParameter: string): IParameters; overload;
     /// <summary>
     /// Altera o valor do parâmetro do tipo integer.
     /// </summary>
     /// <remarks>
     /// Se o parâmetro não existir, nada será feito.
     /// </remarks>
     function SetValue(const NameParameter: string; const ValueParameter: integer): IParameters; overload;
     /// <summary>
     /// Altera o valor do parâmetro do tipo boolean.
     /// </summary>
     /// <remarks>
     /// Se o parâmetro não existir, nada será feito.
     /// </remarks>
     function SetValue(const NameParameter: string; const ValueParameter: boolean): IParameters; overload;
     /// <summary>
     /// Altera o valor do parâmetro do tipo currency.
     /// </summary>
     /// <remarks>
     /// Se o parâmetro não existir, nada será feito.
     /// </remarks>
     function SetValue(const NameParameter: string; const ValueParameter: currency): IParameters; overload;

  end;


implementation

end.
