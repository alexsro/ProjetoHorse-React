unit Factorys.Connection.Intf;

interface

uses FireDAC.Comp.Client, Data.DB;

type
  /// <summary>
  /// Fábrica de connections do FireDAC.
  /// </summary>
  IFactoryConnection = interface
    ['{A8BA6960-66E8-44D6-887B-40463844E6CF}']
    /// <summary>
    /// Factory method que inicializa a FDConnection com driver do postgres.
    /// </summary>
    /// <param name="AOwns">
    /// Por default é <b>True</b>, ou seja, a connection vai ser destruída sozinha.
    /// Coloque <b>False</b> para controlar a destruição.
    /// </param>
    function CreateConnectionPostgres(const AOwns: Boolean = True): TFDConnection;
    /// <summary>
    /// Factory method que inicializa a FDConnection com driver do firebird.
    /// </summary>
    /// <param name="AOwns">
    /// Por default é <b>True</b>, ou seja, a connection vai ser destruída sozinha.
    /// Coloque <b>False</b> para controlar a destruição.
    /// </param>
    function CreateConnectionFirebird(const AOwns: Boolean = True): TFDConnection;
  end;

implementation

end.
