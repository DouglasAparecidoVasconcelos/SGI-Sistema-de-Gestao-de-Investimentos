object frmPrincipal: TfrmPrincipal
  Left = 0
  Top = 0
  Caption = 'Sistema de Gest'#227'o de investimentos'
  ClientHeight = 413
  ClientWidth = 722
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIForm
  Menu = MainMenu
  OldCreateOrder = False
  Position = poDesktopCenter
  WindowState = wsMaximized
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 0
    Top = 0
    Width = 722
    Height = 413
    Align = alClient
    ExplicitLeft = 32
    ExplicitTop = 16
    ExplicitWidth = 105
    ExplicitHeight = 105
  end
  object MainMenu: TMainMenu
    Left = 640
    Top = 32
    object mmFluxoFinanceiro: TMenuItem
      Caption = 'Fluxo Financeiro'
      OnClick = mmFluxoFinanceiroClick
    end
  end
end
