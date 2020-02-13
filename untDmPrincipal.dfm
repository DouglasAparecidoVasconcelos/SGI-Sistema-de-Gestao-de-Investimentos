object DmPrincipal: TDmPrincipal
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 441
  Width = 538
  object FDConnection1: TFDConnection
    ConnectionName = 'mssqlconnection'
    Params.Strings = (
      'DriverID=MSSQL'
      'Address=localhost\SQLEXPRESS'
      'Database=DBDELPHI-PROTOTIPO'
      'Password=masterkey'
      'User_Name=teste'
      'OSAuthent=No')
    Connected = True
    LoginPrompt = False
    Left = 32
    Top = 8
  end
  object cdsLocUsuario: TClientDataSet
    Aggregates = <>
    Params = <
      item
        DataType = ftString
        Name = 'DATA_INI'
        ParamType = ptInput
      end
      item
        DataType = ftString
        Name = 'DATA_FIN'
        ParamType = ptInput
      end>
    ProviderName = 'dspLocUsuario'
    Left = 160
    Top = 160
    object cdsLocUsuarioID_USUARIO: TAutoIncField
      FieldName = 'ID_USUARIO'
      ProviderFlags = [pfInUpdate, pfInKey]
      ReadOnly = True
    end
    object cdsLocUsuarioNOME_COMPLETO: TStringField
      FieldName = 'NOME_COMPLETO'
      ProviderFlags = [pfInUpdate]
      Size = 1000
    end
    object cdsLocUsuarioDATA_NASC: TDateField
      FieldName = 'DATA_NASC'
      ProviderFlags = [pfInUpdate]
    end
    object cdsLocUsuarioCPF: TStringField
      FieldName = 'CPF'
      ProviderFlags = [pfInUpdate]
      Size = 11
    end
    object cdsLocUsuarioID_CONTATO: TIntegerField
      FieldName = 'ID_CONTATO'
      ProviderFlags = [pfInUpdate]
    end
    object cdsLocUsuarioLOGIN: TStringField
      FieldName = 'LOGIN'
      ProviderFlags = [pfInUpdate]
      Size = 100
    end
  end
  object dspLocUsuario: TDataSetProvider
    DataSet = sqlLocUsuario
    Options = [poIncFieldProps, poAutoRefresh, poPropogateChanges, poAllowCommandText, poUseQuoteChar]
    UpdateMode = upWhereKeyOnly
    Left = 160
    Top = 96
  end
  object sqlLocUsuario: TFDQuery
    Connection = FDConnection1
    SQL.Strings = (
      'SELECT * '
      'FROM USUARIO'
      'ORDER BY NOME_COMPLETO')
    Left = 160
    Top = 40
    ParamData = <
      item
        Position = 1
        Name = 'DATA_INI'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Position = 2
        Name = 'DATA_FIN'
        DataType = ftString
        ParamType = ptInput
      end>
    object sqlLocUsuarioID_USUARIO: TFDAutoIncField
      FieldName = 'ID_USUARIO'
      Origin = 'ID_USUARIO'
      ProviderFlags = [pfInUpdate, pfInKey]
      ReadOnly = True
    end
    object sqlLocUsuarioNOME_COMPLETO: TStringField
      FieldName = 'NOME_COMPLETO'
      Origin = 'NOME_COMPLETO'
      ProviderFlags = [pfInUpdate]
      Size = 1000
    end
    object sqlLocUsuarioDATA_NASC: TDateField
      FieldName = 'DATA_NASC'
      Origin = 'DATA_NASC'
      ProviderFlags = [pfInUpdate]
    end
    object sqlLocUsuarioCPF: TStringField
      FieldName = 'CPF'
      Origin = 'CPF'
      ProviderFlags = [pfInUpdate]
      Size = 11
    end
    object sqlLocUsuarioID_CONTATO: TIntegerField
      FieldName = 'ID_CONTATO'
      Origin = 'ID_CONTATO'
      ProviderFlags = [pfInUpdate]
    end
    object sqlLocUsuarioLOGIN: TStringField
      FieldName = 'LOGIN'
      Origin = 'LOGIN'
      ProviderFlags = [pfInUpdate]
      Size = 100
    end
  end
end
