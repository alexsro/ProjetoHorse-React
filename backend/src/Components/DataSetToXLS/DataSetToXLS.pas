unit DataSetToXLS;

interface

uses
  Data.DB, System.Generics.Collections,
  ppCache, ppDB, ppComm, ppRelatv,
  ppProd, ppClass, ppReport, ppEndUsr, ppBands, ppPrnabl, ppCtrls,
  ppStrtch, ppMemo, ppVar, ppDBPipe,
  ppTypes, ppViewr, ppDesignLayer, ppParameter,
  ppXLSDevice, Vcl.Graphics, System.Classes;

type
  TRelatorioCampo = class
  private
    FDisplayLabel: string;
    FFieldName: string;
    FTamanho: integer;
    FTituloTamanho: integer;
    FDataType: TFieldType;
    procedure SetTamanho(const Value: integer);
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    property DisplayLabel: string read FDisplayLabel write FDisplayLabel;
    property FieldName: string read FFieldName write FFieldName;
    property Tamanho: integer read FTamanho write SetTamanho;
    property TituloTamanho: integer read FTituloTamanho write FTituloTamanho;
    property DataType: TFieldType read FDataType write FDataType;
  end;

  TDataSetToXLS = class
  private
    { private declarations }
    FDataSet: TDataSet;
    FXLS: string;
    FRelatorio: TppReport;
    FCampos: TObjectList<TRelatorioCampo>;
  protected
    { protected declarations }
    procedure GetCamposDataSet;
    procedure DestruirCampos;
    procedure GetNovoRelatorio;
    procedure DestruirRelatorio;
    procedure MontarRelatorio;
    procedure AddDetalhes;
    procedure GerarXLS;

  const
    Fonte = 'Arial';
    FonteTamanho = 8;
  public
    { public declarations }
    constructor Create(const XLS: string; const DataSet: TDataSet);
    destructor Destroy; override;

    procedure Exportar;
  end;

implementation

uses
  System.Math;

{ TRelatorioCampo }

procedure TRelatorioCampo.SetTamanho(const Value: integer);
begin
  FTamanho := Value;
  if FTamanho > 40 then
    FTamanho := 40;
end;

{ TDataSetToXLS }

constructor TDataSetToXLS.Create(const XLS: string; const DataSet: TDataSet);
begin
  FDataSet := DataSet;
  FXLS := XLS;
  FRelatorio := nil;
  FCampos := nil;
end;

destructor TDataSetToXLS.Destroy;
begin
  DestruirRelatorio;
  DestruirCampos;
  FDataSet := nil;
  inherited;
end;

procedure TDataSetToXLS.Exportar;
begin
  if not FDataSet.IsEmpty then
    FDataSet.First;
  FDataSet.DisableControls;

  GetCamposDataSet;
  GetNovoRelatorio;
  MontarRelatorio;
  GerarXLS;

  FDataSet.EnableControls;
  if not FDataSet.IsEmpty then
    FDataSet.First;
end;

procedure TDataSetToXLS.GetCamposDataSet;
var
  Campo: TRelatorioCampo;
  Field: TField;
begin
  DestruirCampos;
  FCampos := TObjectList<TRelatorioCampo>.Create;
  for Field in FDataSet.Fields do
  begin
    if not Field.Visible then
     Continue;
    Campo := TRelatorioCampo.Create;
    Campo.DisplayLabel := Field.DisplayLabel;
    Campo.FieldName := Field.FieldName;
    Campo.Tamanho := ifThen(Field.DataType = ftInteger, 8, (Field.DisplayWidth * 2));
    Campo.TituloTamanho := ifThen(Field.DisplayWidth >= Length(Field.DisplayLabel), Campo.Tamanho,
      (Length(Field.DisplayLabel) * 2));
    Campo.FDataType := Field.DataType;
    FCampos.Add(Campo);
  end;
end;

procedure TDataSetToXLS.DestruirCampos;
begin
  if Assigned(FCampos) then
    FCampos.Free;
  FCampos := nil;
end;

procedure TDataSetToXLS.GetNovoRelatorio;
var
  Header: TppHeaderBand;
  Detail: TppDetailBand;
  Footer: TppFooterBand;
  Summary: TppSummaryBand;
  DataSource: TDataSource;
  DataPipeline: TppDBPipeline;
begin
  DestruirRelatorio;
  FRelatorio := TppReport.Create(nil);
  FRelatorio.PassSetting := psTwoPass;
  FRelatorio.AllowPrintToFile := true;
  FRelatorio.Units := utMillimeters;
  FRelatorio.OutlineSettings.CreatePageNodes := false;
  FRelatorio.OutlineSettings.Visible := false;
  FRelatorio.OutlineSettings.Enabled := false;
  FRelatorio.OutlineSettings.CreateNode := false;
  FRelatorio.ShowAutoSearchDialog := false;
  FRelatorio.TextSearchSettings.Enabled := false;
  FRelatorio.PrinterSetup.Orientation := poLandscape;

  Header := TppHeaderBand.Create(FRelatorio);
  Header.Report := FRelatorio;
  Header.Height := 0;

  Detail := TppDetailBand.Create(FRelatorio);
  Detail.Report := FRelatorio;
  Detail.Height := 5;
  Detail.PrintHeight := phDynamic;

  Footer := TppFooterBand.Create(FRelatorio);
  Footer.Report := FRelatorio;
  Footer.Height := 0;

  Summary := TppSummaryBand.Create(FRelatorio);
  Summary.Report := FRelatorio;
  Summary.Height := 0;

  DataSource := TDataSource.Create(FRelatorio);
  DataSource.DataSet := FDataSet;

  DataPipeline := TppDBPipeline.Create(FRelatorio);
  DataPipeline.DataSource := DataSource;
  DataPipeline.SkipWhenNoRecords := false;
  FRelatorio.DataPipeline := DataPipeline;
end;

procedure TDataSetToXLS.DestruirRelatorio;
begin
  if Assigned(FRelatorio) then
    FRelatorio.Free;
  FRelatorio := nil;
end;

procedure TDataSetToXLS.MontarRelatorio;
begin
  if FCampos.Count = 0 then
   Exit;
  AddDetalhes;
end;

procedure TDataSetToXLS.AddDetalhes;
var
  CampoMemo: TppDBMemo;
  CampoText: TppDBText;
  CampoLabel: TppLabel;
  Coluna: Real;
  Linha: Real;
  Campo: TRelatorioCampo;
  EspacoDisponivel: Real;
begin
  // Definição do Detalhe
  Coluna := 0;
  Linha := 0.5;
  for Campo in FCampos do
  begin

    if (Campo.DataType = ftMemo) then
    begin
      CampoMemo := TppDBMemo.Create(FRelatorio);
      CampoMemo.Band := FRelatorio.Detail;
      CampoMemo.DataPipeline := FRelatorio.DataPipeline;
      CampoMemo.DataField := Campo.FieldName;
      CampoMemo.CharWrap := True;
      Linha := Linha + 5;
      Coluna := 0;
      CampoMemo.Font.Name := Fonte;
      CampoMemo.Font.Size := FonteTamanho;

      CampoMemo.Top := Linha;
      CampoMemo.Left := Coluna;
      CampoMemo.Height := 15;

      CampoMemo.Width := FRelatorio.PrinterSetup.PaperWidth - 15;
      Linha := Linha + 16;
      FRelatorio.Detail.Height := FRelatorio.Detail.Height + 21;
    end
    else
    begin
      if ((Coluna + Campo.TituloTamanho) > (FRelatorio.PrinterSetup.PaperWidth - 15)) then
      begin
        FRelatorio.Detail.Height := FRelatorio.Detail.Height + 5;
        Linha := Linha + 5;
        Coluna := 0;
      end;

      CampoText := TppDBText.Create(FRelatorio);
      CampoText.Band := FRelatorio.Detail;
      CampoText.DataPipeline := FRelatorio.DataPipeline;
      CampoText.DataField := Campo.FieldName;
      CampoText.Top := Linha;
      CampoText.Left := Coluna;
      CampoText.Font.Name := Fonte;
      CampoText.font.Size := FonteTamanho;

      if Campo.TituloTamanho > FRelatorio.PrinterSetup.PaperWidth - 15 then
      begin
        EspacoDisponivel := Campo.TituloTamanho;
        while EspacoDisponivel > 0 do
        begin
          CampoText.Height := CampoText.Height + 5;
          EspacoDisponivel := EspacoDisponivel - FRelatorio.PrinterSetup.PaperWidth - 15;
          FRelatorio.Detail.Height := FRelatorio.Detail.Height + 5;
          Linha := Linha + 5;
        end;
        CampoText.WordWrap := True;
        CampoText.Width := FRelatorio.PrinterSetup.PaperWidth - 15;
      end
      else
        CampoText.Width := Campo.Tamanho;

      if (Campo.DataType = ftCurrency) or
        (Campo.DataType = ftFloat) or
        (Campo.DataType = ftInteger) then
      begin
        CampoText.Alignment := taRightJustify;
        if (Campo.DataType <> ftInteger) then
          CampoText.DisplayFormat := ',0.00';
      end;

      Coluna := Coluna + Campo.TituloTamanho + 3;
    end;
  end;
end;

procedure TDataSetToXLS.GerarXLS;
begin
  try
    FRelatorio.AllowPrintToFile := True;
    FRelatorio.DeviceType := dtXLSReport;
    FRelatorio.ShowPrintDialog := false;
    FRelatorio.NoDataBehaviors := [ndBlankReport];
    FRelatorio.TextFileName := FXLS;

    FRelatorio.Print;
  finally
  end;
end;

end.
