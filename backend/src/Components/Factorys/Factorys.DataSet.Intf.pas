unit Factorys.DataSet.Intf;

interface

uses FireDAC.Comp.Client, Data.DB;

type
  /// <summary>
  /// F�brica de dataset do FireDAC.
  /// </summary>
  IFactoryDataSet = interface
    ['{44317276-D197-41F8-ADA5-37875D7BF41E}']
    /// <summary>
    /// Define uma conex�o para o dataset.
    /// </summary>
    /// <param name="AFDConnection">
    /// Conex�o que vai ser atribuida ao dataset.
    /// </param>
    /// <returns>
    /// Retorna a pr�pria inst�ncia da interface seguindo o padr�o fluent API;
    /// </returns>
    function SetConnection(const AFDConnection: TFDConnection): IFactoryDataSet;
    /// <summary>
    /// Pega a conex�o atribuida ao dataset.
    /// </summary>
    /// <returns>
    /// Retorna a conex�o do dataset com o banco de dados.
    /// </returns>
    /// <remarks>
    /// Retorna nil se a conex�o n�o foi atribuida.
    /// </remarks>
    function GetConnection: TFDConnection;
    /// <summary>
    /// Factory method que apenas inicializa a FDQuery.
    /// </summary>
    /// <param name="AOwns">
    /// Por default � <b>True</b>, ou seja, a query vai ser destru�da sozinha.
    /// Coloque <b>False</b> para controlar a destrui��o.
    /// </param>
    function CreateQuery(const AOwns: Boolean = True): TFDQuery; overload;
    /// <summary>
    /// Factory method que devolve a FDQuery j� aberta.
    /// </summary>
    /// <remarks>
    /// Utiliza o m�todo FDQuery.Open(SQL);
    /// </remarks>
    /// <param name="AOwns">
    /// Por default � <b>True</b>, ou seja, a query vai ser destru�da sozinha.
    /// Coloque <b>False</b> para controlar a destrui��o.
    /// </param>
    function CreateQuery(const ASQL: string; const AOwns: Boolean = True): TFDQuery; overload;
    /// <summary>
    /// Factory method que inicializa a FDQuery pronta para ser utilizada como Array DML.
    /// </summary>
    function CreateQueryToArrayDML(const ASQL: string): TFDQuery;
    /// <summary>
    /// Factory method que executa um comando SQL e retorna se ouve sucesso ou n�o na execu��o do comando.
    /// </summary>
    function ExecuteSQL(const ASQL: string): Boolean;
  end;

implementation

end.
