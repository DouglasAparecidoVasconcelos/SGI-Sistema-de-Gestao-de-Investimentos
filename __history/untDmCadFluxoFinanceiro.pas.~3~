unit untDmCadFluxoFinanceiro;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Datasnap.Provider, Data.DB, Datasnap.DBClient;

type
  TDmCadFluxoFinanceiro = class(TDataModule)
    cdsControleFinanceiro: TClientDataSet;
    cdsControleFinanceiroID_CONTROLE_FINANCEIRO: TAutoIncField;
    cdsControleFinanceiroDESCRICAO: TStringField;
    cdsControleFinanceiroVALOR: TFloatField;
    cdsControleFinanceiroDATA: TDateField;
    cdsControleFinanceiroDATA_INC: TSQLTimeStampField;
    cdsControleFinanceiroTIPO: TStringField;
    dspControleFinanceiro: TDataSetProvider;
    sqlControleFinanceiro: TFDQuery;
    sqlControleFinanceiroID_CONTROLE_FINANCEIRO: TFDAutoIncField;
    sqlControleFinanceiroDESCRICAO: TStringField;
    sqlControleFinanceiroDATA: TDateField;
    sqlControleFinanceiroVALOR: TFloatField;
    sqlControleFinanceiroDATA_INC: TSQLTimeStampField;
    sqlControleFinanceiroTIPO: TStringField;
    procedure cdsControleFinanceiroNewRecord(DataSet: TDataSet);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DmCadFluxoFinanceiro: TDmCadFluxoFinanceiro;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TDmCadFluxoFinanceiro.cdsControleFinanceiroNewRecord(DataSet: TDataSet);
begin
  cdsControleFinanceiroDATA_INC.AsDateTime := Now;
end;

end.
