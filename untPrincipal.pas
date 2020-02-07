unit untPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,DateUtils, Datasnap.DBClient,
  Vcl.Mask, Vcl.DBCtrls, System.IniFiles;

type
  TfrmPrincipal = class(TForm)
    datControleFinanceiro: TDataSource;
    PageControl1: TPageControl;
    tbsControleFinanceiro: TTabSheet;
    Panel1: TPanel;
    dbGridControleFinanceiro: TDBGrid;
    btnAtualizar: TButton;
    GroupBox3: TGroupBox;
    dtpickerDataInicial: TDateTimePicker;
    dtpickerDataFinal: TDateTimePicker;
    Label1: TLabel;
    Label2: TLabel;
    btnExcluir: TButton;
    btnIncluir: TButton;
    btnAlterar: TButton;
    btnCancelar: TButton;
    btnSalvar: TButton;
    btnFiltrar: TButton;
    Label3: TLabel;
    lblSoma: TLabel;
    GroupBox1: TGroupBox;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    chkFiltraDespesa: TCheckBox;
    chkFiltraReceita: TCheckBox;
    procedure btnIncluirClick(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure btnSalvarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure dbGridControleFinanceiroDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure btnAtualizarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure btnFiltrarClick(Sender: TObject);
    procedure dbGridControleFinanceiroKeyPress(Sender: TObject; var Key: Char);
    procedure dbGridControleFinanceiroKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure dbGridControleFinanceiroTitleClick(Column: TColumn);
  private
    { Private declarations }
    procedure controlaBotoes;
    procedure filtraCds;
    procedure pintaFonte(soma : Float64);
    function soma : Float64;
  public
    { Public declarations }
    user,porta,ip,banco,senha : String;
    procedure lerIni();
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.dfm}

uses untDmPrincipal;

procedure TfrmPrincipal.lerIni;
var
  arquivoIni : TIniFile;
begin
   {
  arquivoIni := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'gestaoinvestimentos.ini');
  ip := arquivoIni.ReadString('CONEXAO','IP',ip);
  porta := arquivoIni.ReadString('CONEXAO','PORTA',porta);
  banco := arquivoIni.ReadString('CONEXAO','BANCO',banco);
  user := arquivoIni.ReadString('CONEXAO','USUARIO',user);
  senha := arquivoIni.ReadString('CONEXAO','SENHA',senha);
  arquivoIni.Free;
  }
end;

procedure TfrmPrincipal.filtraCds;
begin
  with  DmPrincipal do
  begin
    cdsControleFinanceiro.Close;
    cdsControleFinanceiro.Params[0].AsString := DateToStr(dtpickerDataInicial.DateTime);
    cdsControleFinanceiro.Params[1].AsString := DateToStr(dtpickerDataFinal.DateTime);

    if (chkFiltraReceita.Checked and chkFiltraDespesa.Checked) or ( not chkFiltraReceita.Checked and not chkFiltraDespesa.Checked) then
    begin
      cdsControleFinanceiro.Filtered := False;
    end
    else
    begin
  
      if chkFiltraReceita.Checked then
      begin
        cdsControleFinanceiro.Filtered := False;
        cdsControleFinanceiro.Filter := 'TIPO = ''R'' ';
        cdsControleFinanceiro.Filtered := True;
      end;
    
      if chkFiltraDespesa.Checked then
      begin
        cdsControleFinanceiro.Filtered := False;
        cdsControleFinanceiro.Filter := 'TIPO = ''D'' ';
        cdsControleFinanceiro.Filtered := True;
      end;
    end;

    
    cdsControleFinanceiro.Open;
  end;
end;

function TfrmPrincipal.soma : Float64;
var Vsoma : Double;
begin
  with DmPrincipal do
  begin
    cdsControleFinanceiro.First;
    Vsoma := 0;
    while not cdsControleFinanceiro.Eof do
    begin
      Vsoma := Vsoma + StrToFloat(cdsControleFinanceiroVALOR.AsString);
      cdsControleFinanceiro.Next;
    end;
  end;

   result := Vsoma;

end;

procedure TfrmPrincipal.pintaFonte(soma : Float64);
begin
  if soma >1 then
    lblSoma.Font.Color := clGreen
  else
    lblSoma.Font.Color := clRed;
end;

procedure TfrmPrincipal.btnAlterarClick(Sender: TObject);
begin
  DmPrincipal.cdsControleFinanceiro.Edit;
  controlaBotoes;
  DBEdit1.SetFocus;
end;

procedure TfrmPrincipal.btnAtualizarClick(Sender: TObject);
begin
  DmPrincipal.cdsControleFinanceiro.Refresh;
  btnFiltrarClick(Sender);
end;

procedure TfrmPrincipal.btnExcluirClick(Sender: TObject);
begin
  if Application.MessageBox('Tem certeza de que deseja EXCLUIR o movimento selecionado?','SGI - Sistema de Gest�o de Investientos',MB_YESNOCANCEL+MB_ICONWARNING) = ID_YES then
  begin
    DmPrincipal.cdsControleFinanceiro.Delete;
    DmPrincipal.cdsControleFinanceiro.ApplyUpdates(0);
  end
  else
  begin
    Exit;
  end;

  
end;

procedure TfrmPrincipal.btnFiltrarClick(Sender: TObject);

begin
  filtraCds;
  pintaFonte(soma);
  lblSoma.Caption := FloatToStr(soma);
end;

procedure TfrmPrincipal.btnIncluirClick(Sender: TObject);
begin
  DmPrincipal.cdsControleFinanceiro.insert;
  controlaBotoes;
  DBEdit1.SetFocus;
end;

procedure TfrmPrincipal.btnSalvarClick(Sender: TObject);
begin

  try
    if StrToFloat(DmPrincipal.cdsControleFinanceiro.FieldByName('Valor').AsString) > 1 then
    begin
      DmPrincipal.cdsControleFinanceiroTIPO.AsString := 'R';
    end
    else
    begin
      DmPrincipal.cdsControleFinanceiroTIPO.AsString := 'D';
    end;

    DmPrincipal.cdsControleFinanceiro.Post;
    DmPrincipal.cdsControleFinanceiro.ApplyUpdates(0);
    DmPrincipal.cdsControleFinanceiro.Refresh;
    controlaBotoes;
    btnAtualizarClick(Sender);

    ShowMessage('Movimento cadatrado com Sucesso!');
  except
    ShowMessage('Erro ao cadastrar movimento');
  end;
end;

procedure TfrmPrincipal.btnCancelarClick(Sender: TObject);
begin
  DmPrincipal.cdsControleFinanceiro.Cancel;
  DmPrincipal.cdsControleFinanceiro.CancelUpdates;
  controlaBotoes;
end;

procedure TfrmPrincipal.dbGridControleFinanceiroDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  if DmPrincipal.cdsControleFinanceiroTIPO.AsString = 'D' then
    dbGridControleFinanceiro.Canvas.Brush.Color := clRed
  else
    dbGridControleFinanceiro.Canvas.Brush.Color := clGreen;


  dbGridControleFinanceiro.DefaultDrawDataCell(Rect, Column.Field, State);

end;

procedure TfrmPrincipal.dbGridControleFinanceiroKeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if key = 13 then
    btnSalvar.SetFocus;
end;

procedure TfrmPrincipal.dbGridControleFinanceiroKeyPress(Sender: TObject;
  var Key: Char);
begin
  Key := UpCase(Key);
end;

procedure TfrmPrincipal.dbGridControleFinanceiroTitleClick(Column: TColumn);
var indice: string;
existe: Boolean;
clientdataset_idx: TClientDataSet;
begin
   clientdataset_idx := TClientDataSet(Column.Grid.DataSource.DataSet);

   if clientdataset_idx.IndexFieldNames = Column.FieldName then
   begin
     indice := AnsiUpperCase(Column.FieldName+'_INV');

     try
      clientdataset_idx.IndexDefs.Find(indice);
      existe := True;
     except
      existe := False;
     end;

    if not existe then
      with clientdataset_idx.IndexDefs.AddIndexDef do
      begin
        Name := indice;
        Fields := Column.FieldName;
        Options := [ixDescending];
      end;
    clientdataset_idx.IndexName := indice;
   end
   else
    clientdataset_idx.IndexFieldNames := Column.FieldName;

end;

procedure TfrmPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   //FreeAndNil(DmPrincipal);
  DmPrincipal.cdsControleFinanceiro.Close;
  DmPrincipal.FDConnection1.Close;
  DmPrincipal := Nil;
  Action := caFree;
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
//
end;

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin
 

  dtpickerDataInicial.DateTime := StartOfTheMonth(now);
  dtpickerDataFinal.DateTime := EndOfTheMonth(now);
  btnFiltrarClick(Sender);

end;

procedure TfrmPrincipal.controlaBotoes;
begin
  if DmPrincipal.cdsControleFinanceiro.State in [dsEdit, dsInsert] then
  begin
    btnIncluir.Enabled   := False;
    btnSalvar.Enabled    := True;
    btnAlterar.Enabled   := False;
    btnCancelar.Enabled  := True;
    btnExcluir.Enabled   := False;
  end
  else
  begin
    btnIncluir.Enabled   := True;
    btnSalvar.Enabled    := False;
    btnAlterar.Enabled   := True;
    btnCancelar.Enabled  := False;
    btnExcluir.Enabled   := True;
  end;

end;

end.
