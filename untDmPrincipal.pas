unit untDmPrincipal;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.MSSQL,
  FireDAC.Phys.MSSQLDef, FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Datasnap.Provider, Datasnap.DBClient, System.IniFiles, Vcl.Dialogs, System.StrUtils, Vcl.Forms;

type
  TDmPrincipal = class(TDataModule)
    FDConnection1: TFDConnection;
    cdsControleFinanceiro: TClientDataSet;
    dspControleFinanceiro: TDataSetProvider;
    sqlControleFinanceiro: TFDQuery;
    sqlControleFinanceiroID_CONTROLE_FINANCEIRO: TFDAutoIncField;
    sqlControleFinanceiroDESCRICAO: TStringField;
    sqlControleFinanceiroDATA: TDateField;
    sqlControleFinanceiroDATA_INC: TSQLTimeStampField;
    sqlControleFinanceiroTIPO: TStringField;
    cdsControleFinanceiroID_CONTROLE_FINANCEIRO: TAutoIncField;
    cdsControleFinanceiroDESCRICAO: TStringField;
    cdsControleFinanceiroDATA: TDateField;
    cdsControleFinanceiroDATA_INC: TSQLTimeStampField;
    cdsControleFinanceiroTIPO: TStringField;
    sqlControleFinanceiroVALOR: TFloatField;
    cdsControleFinanceiroVALOR: TFloatField;
    procedure cdsControleFinanceiroNewRecord(DataSet: TDataSet);
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DmPrincipal: TDmPrincipal;

implementation

uses
  untPrincipal;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TDmPrincipal.cdsControleFinanceiroNewRecord(DataSet: TDataSet);
begin
  cdsControleFinanceiroDATA_INC.AsDateTime := Now;
end;

procedure TDmPrincipal.DataModuleCreate(Sender: TObject);
var
Ini : TIniFile;
begin
  {
  with FDConnection1 do
  begin
    Connected := False;

    Ini.Free;

    Ini := TIniFile.Create(GetCurrentDir+ 'gestaoinvestimentos.ini');
    //Params.Clear;
    Params.Values['DriverID']  := 'MSSQL';
    Params.Values['HostName'] := 'localhost\SQLEXPRESS';//Ini.ReadString('CONEXAO','IP','');
    DmPrincipal.FDConnection1.Params.Values['Server'] := 'localhost\SQLEXPRESS';//Ini.ReadString('CONEXAO','IP','');
    Params.Values['Database'] := 'DBDELPHI';//Ini.ReadString('CONEXAO','BANCO','');
    Params.UserName := 'teste';
    Params.Values['Password']:= 'masterkey';

    try
      Connected := True;
    except
      Connected := False;
      ShowMessage('Não foi possível conectar ao banco de dados!');
      Application.Terminate;
    end;
  end;



  frmPrincipal.lerIni;
  DmPrincipal.FDConnection1.Params.Clear;
  DmPrincipal.FDConnection1.Params.Values['DriverID']  := 'MSSQL';
  DmPrincipal.FDConnection1.Params.Values['Server'] := frmPrincipal.ip;
  DmPrincipal.FDConnection1.Params.Database := frmPrincipal.banco;
  DmPrincipal.FDConnection1.Params.UserName := 'teste';
  DmPrincipal.FDConnection1.Params.Password := 'masterkey';
  DmPrincipal.FDConnection1.Connected := True;  }

  DmPrincipal.FDConnection1.Params.Values['HostName'] := 'localhost\SQLEXPRESS';
  DmPrincipal.FDConnection1.Params.Values['Database'] := 'DBDELPHI';

  try
    FDConnection1.Connected := True;
  except
    ShowMessage('Erro ao conectar no banco de dados!');
  end;
end;

end.
