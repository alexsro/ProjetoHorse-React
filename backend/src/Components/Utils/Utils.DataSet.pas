unit Utils.DataSet;

interface

uses
  Data.DB, System.SysUtils, System.StrUtils, System.JSON;

type
  TDataSetUtils = class
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    class function ToCSV(const DataSet: TDataSet): string;
    class procedure SaveToCSV(const Arquivo: string; const DataSet: TDataSet);
//    class procedure SaveToPDF(const PDF: string; const DataSet: TDataSet; const EntidadeNome, Exercicio: string;
//      JSONCampos: string = '');
//    class procedure SaveToXLS(const Arquivo: string; const DataSet: TDataSet);
  end;

implementation

uses
  System.IOUtils;//, DataSetToPDF, DataSetToXLS;

{ TDataSetUtils }

class function TDataSetUtils.ToCSV(const DataSet: TDataSet): string;
var
  Field: TField;
  Linha: string;
begin
  Result := '';
  if (DataSet.IsEmpty) then
    Exit;

  DataSet.First;
  while not DataSet.Eof do
  begin
    Linha := '';
    for Field in DataSet.Fields do
    begin
      if Trim(Linha).IsEmpty then
        Linha := Field.AsString.Replace(';', '')
      else
        Linha := Linha + ';' + Field.AsString.Replace(';', '');
    end;
    Result := Result + Linha + sLineBreak;
    DataSet.Next;
  end;

end;

//class procedure TDataSetUtils.SaveToPDF(const PDF: string; const DataSet: TDataSet; const EntidadeNome, Exercicio: string;
//  JSONCampos: string);
//var
//  Field: TField;
//  JSONObject: TJSONObject;
//  Fields: TJSONArray;
//  FieldJSONValue: TJSONValue;
//  FieldJSONObject: TJSONObject;
//  DataSetToPDF: TDataSetToPDF;
//begin
//  if (not JSONCampos.IsEmpty) then
//  begin
//    for Field in DataSet.Fields do
//      Field.Visible := false;
//    JSONObject := TJSONObject.ParseJSONValue(JSONCampos) as TJSONObject;
//    try
//      if JSONObject.TryGetValue<TJSONArray>('fields', Fields) then
//      begin
//        for FieldJSONValue in Fields do
//        begin
//          FieldJSONObject := FieldJSONValue as TJSONObject;
//
//          Field := DataSet.FindField(FieldJSONObject.GetValue<string>('fieldname'));
//          if Assigned(Field) then
//          begin
//            Field.DisplayLabel := FieldJSONObject.GetValue<string>('displaylabel');
//            Field.Visible := true;
//          end;
//        end;
//      end;
//    finally
//      JSONObject.Free;
//    end;
//  end;
//
//  DataSetToPDF := TDataSetToPDF.Create(PDF, DataSet, EntidadeNome, Exercicio);
//  try
//    DataSetToPDF.Exportar;
//  finally
//    DataSetToPDF.Free;
//  end;
//end;

class procedure TDataSetUtils.SaveToCSV(const Arquivo: string; const DataSet: TDataSet);
var
  CSV: string;
  Arq: TextFile;
begin
  CSV := TDataSetUtils.ToCSV(DataSet);
  TFile.WriteAllText(Arquivo, CSV, TEncoding.UTF8);
end;

//class procedure TDataSetUtils.SaveToXLS(const Arquivo: string; const DataSet: TDataSet);
//var
//  DataSetToXLS: TDataSetToXLS;
//begin
//  DataSetToXLS := TDataSetToXLS.Create(Arquivo, DataSet);
//  try
//    DataSetToXLS.Exportar;
//  finally
//    DataSetToXLS.Free;
//  end;
//end;

end.
