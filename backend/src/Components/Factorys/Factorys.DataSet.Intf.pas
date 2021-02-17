unit Factorys.DataSet.Intf;

interface

uses FireDAC.Comp.Client, Data.DB;

type
  /// <summary>
  /// Fábrica de dataset do FireDAC.
  /// </summary>
  IFactoryDataSet = interface
    ['{44317276-D197-41F8-ADA5-37875D7BF41E}']
    /// <summary>
    /// Define uma conexão para o dataset.
    /// </summary>
    /// <param name="AFDConnection">
    /// Conexão que vai ser atribuida ao dataset.
    /// </param>
    /// <returns>
    /// Retorna a própria instância da interface seguindo o padrão fluent API;
    /// </returns>
    function SetConnection(const AFDConnection: TFDConnection): IFactoryDataSet;
    /// <summary>
    /// Pega a conexão atribuida ao dataset.
    /// </summary>
    /// <returns>
    /// Retorna a conexão do dataset com o banco de dados.
    /// </returns>
    /// <remarks>
    /// Retorna nil se a conexão não foi atribuida.
    /// </remarks>
    function GetConnection: TFDConnection;
    /// <summary>
    /// Factory method que apenas inicializa a FDQuery.
    /// </summary>
    /// <param name="AOwns">
    /// Por default é <b>True</b>, ou seja, a query vai ser destruída sozinha.
    /// Coloque <b>False</b> para controlar a destruição.
    /// </param>
    function CreateQuery(const AOwns: Boolean = True): TFDQuery; overload;
    /// <summary>
    /// Factory method que devolve a FDQuery já aberta.
    /// </summary>
    /// <remarks>
    /// Utiliza o método FDQuery.Open(SQL);
    /// </remarks>
    /// <param name="AOwns">
    /// Por default é <b>True</b>, ou seja, a query vai ser destruída sozinha.
    /// Coloque <b>False</b> para controlar a destruição.
    /// </param>
    function CreateQuery(const ASQL: string; const AOwns: Boolean = True): TFDQuery; overload;
    /// <summary>
    /// Factory method que inicializa a FDQuery pronta para ser utilizada como Array DML.
    /// </summary>
    function CreateQueryToArrayDML(const ASQL: string): TFDQuery;
    /// <summary>
    /// Factory method que executa um comando SQL e retorna se ouve sucesso ou não na execução do comando.
    /// </summary>
    function ExecuteSQL(const ASQL: string): Boolean;
  end;

implementation

end.
