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
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 722
    Height = 372
    ActivePage = tbsControleFinanceiro
    Align = alClient
    TabOrder = 0
    object tbsControleFinanceiro: TTabSheet
      Caption = 'Controle Financeiro'
      ImageIndex = 1
      object Label3: TLabel
        Left = 106
        Top = 279
        Width = 125
        Height = 16
        Caption = 'Resumo Financeiro:'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object lblSoma: TLabel
        Left = 237
        Top = 279
        Width = 4
        Height = 16
        Caption = '.'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Tahoma'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object dbGridControleFinanceiro: TDBGrid
        Left = 0
        Top = 107
        Width = 714
        Height = 166
        Align = alTop
        DataSource = datControleFinanceiro
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        OnDrawColumnCell = dbGridControleFinanceiroDrawColumnCell
        OnKeyDown = dbGridControleFinanceiroKeyDown
        OnKeyPress = dbGridControleFinanceiroKeyPress
        OnTitleClick = dbGridControleFinanceiroTitleClick
        Columns = <
          item
            Expanded = False
            FieldName = 'DESCRICAO'
            Width = 276
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'VALOR'
            Width = 91
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'DATA'
            Width = 94
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'TIPO'
            PickList.Strings = (
              'D'
              'R')
            ReadOnly = True
            Width = 62
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'DATA_INC'
            ReadOnly = True
            Width = 119
            Visible = True
          end>
      end
      object GroupBox3: TGroupBox
        Left = 0
        Top = 0
        Width = 714
        Height = 57
        Align = alTop
        Caption = 'Filtros'
        TabOrder = 1
        object Label1: TLabel
          Left = 8
          Top = 17
          Width = 77
          Height = 16
          Caption = 'Data Inicial:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object Label2: TLabel
          Left = 211
          Top = 17
          Width = 68
          Height = 16
          Caption = 'Data Final:'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Tahoma'
          Font.Style = [fsBold]
          ParentFont = False
        end
        object dtpickerDataInicial: TDateTimePicker
          Left = 91
          Top = 15
          Width = 97
          Height = 21
          Date = 43863.000000000000000000
          Time = 0.118750497684232000
          TabOrder = 0
        end
        object dtpickerDataFinal: TDateTimePicker
          Left = 285
          Top = 15
          Width = 100
          Height = 21
          Date = 43863.000000000000000000
          Time = 0.118750497684232000
          TabOrder = 1
        end
        object btnFiltrar: TButton
          Left = 577
          Top = 16
          Width = 75
          Height = 25
          Caption = 'Filtrar'
          TabOrder = 2
          OnClick = btnFiltrarClick
        end
        object chkFiltraDespesa: TCheckBox
          Left = 414
          Top = 10
          Width = 137
          Height = 17
          Caption = 'Filtrar Apenas Despesas'
          TabOrder = 3
        end
        object chkFiltraReceita: TCheckBox
          Left = 414
          Top = 33
          Width = 137
          Height = 17
          Caption = 'Filtrar Apenas Receitas'
          TabOrder = 4
        end
      end
      object btnExcluir: TButton
        Left = 328
        Top = 316
        Width = 75
        Height = 25
        Caption = 'Excluir'
        TabOrder = 2
        OnClick = btnExcluirClick
      end
      object btnIncluir: TButton
        Left = 3
        Top = 316
        Width = 75
        Height = 25
        Caption = 'Incluir'
        TabOrder = 4
        OnClick = btnIncluirClick
      end
      object btnAlterar: TButton
        Left = 84
        Top = 316
        Width = 75
        Height = 25
        Caption = 'Alterar'
        TabOrder = 5
        OnClick = btnAlterarClick
      end
      object btnCancelar: TButton
        Left = 166
        Top = 316
        Width = 75
        Height = 25
        Caption = 'Cancelar'
        TabOrder = 6
        OnClick = btnCancelarClick
      end
      object btnSalvar: TButton
        Left = 247
        Top = 316
        Width = 75
        Height = 25
        Caption = 'Salvar'
        TabOrder = 3
        OnClick = btnSalvarClick
      end
      object GroupBox1: TGroupBox
        Left = 0
        Top = 57
        Width = 714
        Height = 50
        Align = alTop
        Caption = 'Inserir  Movimento'
        TabOrder = 7
        object Label4: TLabel
          Left = 12
          Top = 22
          Width = 50
          Height = 13
          Caption = 'Descri'#231#227'o:'
        end
        object Label5: TLabel
          Left = 202
          Top = 21
          Width = 28
          Height = 13
          Caption = 'Valor:'
        end
        object Label6: TLabel
          Left = 372
          Top = 21
          Width = 82
          Height = 13
          Caption = 'Data do Evento: '
        end
        object DBEdit1: TDBEdit
          Left = 68
          Top = 18
          Width = 121
          Height = 21
          CharCase = ecUpperCase
          DataField = 'DESCRICAO'
          DataSource = datControleFinanceiro
          TabOrder = 0
        end
        object DBEdit2: TDBEdit
          Left = 237
          Top = 18
          Width = 121
          Height = 21
          DataField = 'VALOR'
          DataSource = datControleFinanceiro
          TabOrder = 1
        end
        object DBEdit3: TDBEdit
          Left = 457
          Top = 18
          Width = 121
          Height = 21
          DataField = 'DATA'
          DataSource = datControleFinanceiro
          TabOrder = 2
        end
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 372
    Width = 722
    Height = 41
    Align = alBottom
    Color = clMoneyGreen
    ParentBackground = False
    TabOrder = 1
    object btnAtualizar: TButton
      Left = 620
      Top = 2
      Width = 98
      Height = 39
      Caption = 'Atualizar'
      TabOrder = 0
      OnClick = btnAtualizarClick
    end
  end
  object datControleFinanceiro: TDataSource
    AutoEdit = False
    DataSet = DmPrincipal.cdsControleFinanceiro
    Left = 256
    Top = 65524
  end
end
