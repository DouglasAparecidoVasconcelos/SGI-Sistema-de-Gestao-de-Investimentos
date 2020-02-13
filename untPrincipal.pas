unit untPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,DateUtils, Datasnap.DBClient,
  Vcl.Mask, Vcl.DBCtrls, System.IniFiles, Vcl.ToolWin, Vcl.ActnMan,
  Vcl.ActnCtrls, Vcl.ActnMenus, Vcl.Menus, Vcl.Imaging.jpeg;

type
  TfrmPrincipal = class(TForm)
    MainMenu: TMainMenu;
    mmFluxoFinanceiro: TMenuItem;
    Image1: TImage;
    mmCadastros: TMenuItem;
    mmUsuario: TMenuItem;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure mmFluxoFinanceiroClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    user,porta,ip,banco,senha : String;
    procedure lerIni();
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.dfm}

uses untDmPrincipal, untCadFluxoFinanceiro, untLogin;

procedure TfrmPrincipal.FormShow(Sender: TObject);
begin
  if frmLogin = nil then
    frmLogin:= TfrmLogin.Create(nil);
  frmLogin.ShowModal;
end;

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



procedure TfrmPrincipal.mmFluxoFinanceiroClick(Sender: TObject);
begin
  if frmCadFluxoFinanceiro = nil then
    frmCadFluxoFinanceiro := TfrmCadFluxoFinanceiro.Create(Self);
end;

procedure TfrmPrincipal.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  DmPrincipal.FDConnection1.Close;
  DmPrincipal := Nil;
  Action := caFree;
end;

end.
