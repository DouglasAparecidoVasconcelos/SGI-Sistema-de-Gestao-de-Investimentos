program GestaoInvestimentos;

uses
  Vcl.Forms,
  untPrincipal in 'untPrincipal.pas' {frmPrincipal},
  untDmPrincipal in 'untDmPrincipal.pas' {DmPrincipal: TDataModule},
  untDmCadFluxoFinanceiro in 'untDmCadFluxoFinanceiro.pas' {DmCadFluxoFinanceiro: TDataModule},
  untCadFluxoFinanceiro in 'untCadFluxoFinanceiro.pas' {frmCadFluxoFinanceiro},
  untLogin in 'untLogin.pas' {frmLogin};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.CreateForm(TDmPrincipal, DmPrincipal);
  Application.Run;
end.
