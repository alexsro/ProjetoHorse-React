unit DataSetToPDF;

interface

uses
  Data.DB, System.Generics.Collections,
  ppCache, ppDB, ppComm, ppRelatv,
  ppProd, ppClass, ppReport, ppEndUsr, ppBands, ppPrnabl, ppCtrls,
  ppStrtch, ppMemo, ppVar, ppDBPipe,
  ppTypes, ppViewr, ppDesignLayer, ppParameter,
  ppPDFDevice, Vcl.Graphics, System.Classes;

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

  TDataSetToPDF = class
  private
    { private declarations }
    FDataSet: TDataSet;
    FPDF: string;
    FEntidadeNome: string;
    FExercicio: string;
    FRelatorio: TppReport;
    FCampos: TObjectList<TRelatorioCampo>;
  protected
    { protected declarations }
    procedure GetCamposDataSet;
    procedure DestruirCampos;
    procedure GetNovoRelatorio;
    procedure DestruirRelatorio;
    procedure MontarRelatorio;
    procedure AddTotalizadores;
    procedure AddCabecalho;
    procedure AddRodape;
    procedure AddDetalhes;
    procedure GerarPDF;

  const
    Fonte = 'Arial';
    FonteTamanho = 8;
  public
    { public declarations }
    constructor Create(const PDF: string; const DataSet: TDataSet; const EntidadeNome, Exercicio: string);
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

{ TDataSetToPDF }

constructor TDataSetToPDF.Create(const PDF: string; const DataSet: TDataSet; const EntidadeNome, Exercicio: string);
begin
  FDataSet := DataSet;
  FPDF := PDF;
  FEntidadeNome := EntidadeNome;
  FExercicio := Exercicio;
  FRelatorio := nil;
  FCampos := nil;
end;

destructor TDataSetToPDF.Destroy;
begin
  DestruirRelatorio;
  DestruirCampos;
  FDataSet := nil;
  inherited;
end;

procedure TDataSetToPDF.Exportar;
begin
  if not FDataSet.IsEmpty then
    FDataSet.First;
  FDataSet.DisableControls;

  GetCamposDataSet;
  GetNovoRelatorio;
  MontarRelatorio;
  GerarPDF;

  FDataSet.EnableControls;
  if not FDataSet.IsEmpty then
    FDataSet.First;
end;

procedure TDataSetToPDF.GetCamposDataSet;
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

procedure TDataSetToPDF.DestruirCampos;
begin
  if Assigned(FCampos) then
    FCampos.Free;
  FCampos := nil;
end;

procedure TDataSetToPDF.GetNovoRelatorio;
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
  Header.Height := 30;

  Detail := TppDetailBand.Create(FRelatorio);
  Detail.Report := FRelatorio;
  Detail.Height := 5;
  Detail.PrintHeight := phDynamic;

  Footer := TppFooterBand.Create(FRelatorio);
  Footer.Report := FRelatorio;
  Footer.Height := 10;

  Summary := TppSummaryBand.Create(FRelatorio);
  Summary.Report := FRelatorio;
  Summary.Height := 10;

  DataSource := TDataSource.Create(FRelatorio);
  DataSource.DataSet := FDataSet;

  DataPipeline := TppDBPipeline.Create(FRelatorio);
  DataPipeline.DataSource := DataSource;
  DataPipeline.SkipWhenNoRecords := false;
  FRelatorio.DataPipeline := DataPipeline;
end;

procedure TDataSetToPDF.DestruirRelatorio;
begin
  if Assigned(FRelatorio) then
    FRelatorio.Free;
  FRelatorio := nil;
end;

procedure TDataSetToPDF.MontarRelatorio;
begin
  if FCampos.Count = 0 then
   Exit;
  AddTotalizadores;
  AddCabecalho;
  AddRodape;
  AddDetalhes;
end;

procedure TDataSetToPDF.AddTotalizadores;
var
  LinhaSeparacao: TppLine;
  CampoValor: TppDBCalc;
  CampoLabel: TppLabel;
  Coluna: Real;
  Linha: Real;
  Campo: TRelatorioCampo;
begin
  LinhaSeparacao := TppLine.Create(FRelatorio);
  LinhaSeparacao.Band := FRelatorio.Summary;
  LinhaSeparacao.Height := 0.25;
  LinhaSeparacao.Left := 0;
  LinhaSeparacao.Width := FRelatorio.PrinterSetup.PaperWidth - 15;
  LinhaSeparacao.Top := 0;

  CampoLabel := TppLabel.Create(FRelatorio);
  CampoLabel.Band := FRelatorio.Summary;
  CampoLabel.Font.Name := Fonte;
  CampoLabel.Font.Style := [fsBold];
  CampoLabel.Top := 2;
  CampoLabel.Left := 1;
  CampoLabel.Caption := 'Total Registros: ';

  CampoValor := TppDBCalc.Create(FRelatorio);
  CampoValor.Band := FRelatorio.Summary;
  CampoValor.Font.Name := Fonte;
  CampoValor.Font.size := FonteTamanho;
  CampoValor.Font.Style := [fsBold];
  CampoValor.Top := 2;
  CampoValor.Left := (CampoLabel.Left + CampoLabel.Width + 1);
  CampoValor.DataPipeline := FRelatorio.DataPipeline;
  CampoValor.DataField := FCampos.First.FFieldName;
  CampoValor.Alignment := taRightJustify;
  CampoValor.DBCalcType := dcCount;

  // // Definição dos Totalizadores do FRelatorio
  Coluna := (CampoValor.Left + CampoValor.Width + 5);
  Linha := (CampoValor.Top);
  for Campo in FCampos do
  begin
    if Campo.DataType = ftFloat then
    begin
      if ((Coluna + Campo.TituloTamanho + 3 + 28 + 3) > (LinhaSeparacao.Width)) then
      begin
        FRelatorio.Summary.Height := FRelatorio.Summary.Height + 5;
        Linha := Linha + 5;
        Coluna := 1;
      end;

      CampoLabel := TppLabel.Create(FRelatorio);
      CampoLabel.Band := FRelatorio.Summary;
      CampoLabel.Font.Name := Fonte;
      CampoLabel.Font.Style := [fsBold];
      CampoLabel.Top := Linha;
      CampoLabel.Left := Coluna;
      CampoLabel.Caption := '   Total ' + Campo.DisplayLabel + ': ';

      CampoValor := TppDBCalc.Create(FRelatorio);
      CampoValor.Band := FRelatorio.Summary;
      CampoValor.Font.Name := Fonte;
      CampoValor.Font.size := FonteTamanho;
      CampoValor.Font.Style := [fsBold];
      CampoValor.Top := Linha;
      CampoValor.Left := CampoLabel.Left + CampoLabel.Width + 0.5;
      CampoValor.DataPipeline := FRelatorio.DataPipeline;
      CampoValor.DataField := Campo.FieldName;
      CampoValor.Alignment := taRightJustify;
      CampoValor.DBCalcType := dcSum;
      CampoValor.Width := 28;

      Coluna := CampoValor.Left + CampoValor.Width + 5;
    end;
  end;
end;

procedure TDataSetToPDF.AddCabecalho;
var
  lblEntidade: TppLabel;
  lblExercicio: TppLabel;
  lblNumeracaoPagina: TppSystemVariable;
  lblData: TppSystemVariable;
  LinhaSeparacao: TppLine;
  CampoLabel: TppLabel;
  Coluna: Real;
  Linha: Real;
  Campo: TRelatorioCampo;
begin
  // Definição do Cabeçalho
  lblEntidade := TppLabel.Create(FRelatorio);
  lblEntidade.Band := FRelatorio.Header;
  lblEntidade.Font.Name := Fonte;
  lblEntidade.Font.Style := [fsBold];
  lblEntidade.Font.Size := 10;
  lblEntidade.Caption := FEntidadeNome;
  lblEntidade.Top := 5;
  lblEntidade.Left := 0;

  lblExercicio := TppLabel.Create(FRelatorio);
  lblExercicio.Band := FRelatorio.Header;
  lblExercicio.Font.Name := Fonte;
  lblExercicio.Font.Style := [fsBold];
  lblExercicio.Font.Size := 10;
  lblExercicio.Caption := FExercicio;
  lblExercicio.Top := 10;
  lblExercicio.Left := 0;

  lblNumeracaoPagina := TppSystemVariable.Create(FRelatorio);
  lblNumeracaoPagina.Band := FRelatorio.Header;
  lblNumeracaoPagina.VarType := vtPageNoDesc;
  lblNumeracaoPagina.Top := 5;
  lblNumeracaoPagina.Left := 260;

  lblData := TppSystemVariable.Create(FRelatorio);
  lblData.Band := FRelatorio.Header;
  lblData.VarType := vtDate;
  lblData.Top := 10;
  lblData.Left := 260;

  LinhaSeparacao := TppLine.Create(FRelatorio);
  LinhaSeparacao.Band := FRelatorio.Header;
  LinhaSeparacao.Height := 0.25;
  LinhaSeparacao.Left := 0;
  LinhaSeparacao.Width := FRelatorio.PrinterSetup.PaperWidth - 15;
  LinhaSeparacao.Top := (FRelatorio.Header.Height - 0.25);

  // Cria no cabecalho os títulos dos FCampos
  Coluna := 0;
  Linha := 20;
  for Campo in FCampos do
  begin
    if ((Coluna + Campo.TituloTamanho) > (LinhaSeparacao.Width)) then
    begin
      FRelatorio.Header.Height := FRelatorio.Header.Height + 5;
      LinhaSeparacao.Top := FRelatorio.Header.Height - 0.25;
      Linha := Linha + 5;
      Coluna := 0;
    end;

    CampoLabel := TppLabel.Create(FRelatorio);
    CampoLabel.Band := FRelatorio.Header;
    CampoLabel.Font.Name := Fonte;
    CampoLabel.font.Size := FonteTamanho;
    CampoLabel.Caption := Campo.DisplayLabel;
    if (Campo.DataType = ftMemo) then
    begin
      FRelatorio.Header.Height := FRelatorio.Header.Height + 5;
      LinhaSeparacao.Top := FRelatorio.Header.Height - 0.25;
      Linha := Linha + 5;
      Coluna := 0;
      CampoLabel.Top := Linha;
      CampoLabel.Left := Coluna;
      FRelatorio.Header.Height := FRelatorio.Header.Height + 5;
      LinhaSeparacao.Top := FRelatorio.Header.Height - 0.25;
      Linha := Linha + 5;
      Coluna := 0;
    end
    else
    begin
      CampoLabel.Top := Linha;
      CampoLabel.Left := Coluna;
      Coluna := Coluna + Campo.TituloTamanho + 3;
    end;
  end;
end;

procedure TDataSetToPDF.AddRodape;
var
  LinhaSeparacao: TppLine;
  lblFiorilli: TppLabel;
begin
  // Definição do Rodapé
  LinhaSeparacao := TppLine.Create(FRelatorio);
  LinhaSeparacao.Band := FRelatorio.Footer;
  LinhaSeparacao.Height := 0.25;
  LinhaSeparacao.Left := 0;
  LinhaSeparacao.Width := FRelatorio.PrinterSetup.PaperWidth - 15;
  LinhaSeparacao.Top := 1;

  lblFiorilli := TppLabel.Create(FRelatorio);
  lblFiorilli.Band := FRelatorio.Footer;
  lblFiorilli.Caption := 'Fiorilli S/C Ltda. Software';
  lblFiorilli.Top := 3;
  lblFiorilli.Left := 5;
end;

procedure TDataSetToPDF.AddDetalhes;
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

procedure TDataSetToPDF.GerarPDF;
var
  PDFDevice: TppPDFDevice;
begin
  PDFDevice := TppPDFDevice.Create(nil);
  try
    FRelatorio.DefaultFileDeviceType := 'PDF';
    FRelatorio.PDFSettings.Author := 'Fiorilli Sociedade Civil Ltda. - Software';
    FRelatorio.PDFSettings.Title := 'Impressão';
    FRelatorio.PDFSettings.PDFA := True;
    FRelatorio.AllowPrintToFile := True;
    if FRelatorio.PrinterSetup.PaperName <> 'Custom' then
      FRelatorio.PrinterSetup.PaperName := 'A4';

    FRelatorio.NoDataBehaviors := [ndBlankReport];

    PDFDevice.PDFSettings := FRelatorio.PDFSettings;
    PDFDevice.FileName := FPDF;
    PDFDevice.Publisher := FRelatorio.Publisher;

    FRelatorio.PrintToDevices;
  finally
    if Assigned(PDFDevice) then
      PDFDevice.Free;
    PDFDevice := nil;
  end;
end;

end.
