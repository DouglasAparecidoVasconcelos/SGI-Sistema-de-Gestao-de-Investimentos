Unit untLib;

Interface

Uses Windows, Classes, SysUtils, Forms, Graphics, Registry, Messages, Menus, ComCtrls, Controls, Dialogs,
  StdCtrls, Buttons, Grids, DBGrids, DBCtrls, ExtCtrls, ShellApi, TypInfo, WinSock, Variants, ActnList,
  StrUtils, dbClient, Provider, DB, SqlExpr, Math, Mask;

  Type
  TAppConfig = Packed Record
    gsSystem: String;
    gsCompany: String;
    gbUpperCase: boolean;
    gsForms: String;
    gsOptions: String;
    gsDatabase: String;
    gsDBUserName: String;
    gbAppReadOnly: boolean;
    { App Server }
    gsServerIP: String;
    gsServerPort: String;
    { RPT Server }
    gsReportServerIP: String;
    gsReportServerPort: String;
    gsReportServerPath: String;
    { Actions Print/Export }
    gbActionImpressao: boolean;
    gbActionExportacao: boolean;
  End;

Type
  TAppSQL = Packed Record
    gsDSPName: String;
    gsSQLText: String;
  End;

Const
  cStop_Ok: integer = MB_ICONSTOP + MB_OK;
  cQuestion_YesNo: integer = MB_ICONQUESTION + MB_YESNO;
  cQuestion_YesNoCancel: integer = MB_ICONQUESTION + MB_YESNOCANCEL;
  cInfo_Ok: integer = MB_ICONINFORMATION + MB_OK;
  cWarn_Ok: integer = MB_ICONWARNING + MB_OK;
  cWarn_OkCancel: integer = MB_ICONWARNING + MB_OKCANCEL;
  cError_Ok: integer = MB_ICONERROR + MB_OK;

  ciSim: integer = 1;
  ciNao: integer = 0;

  csSim: String = 'S';
  csNao: String = 'N';

  cMsgFixEDT: String = #13 + 'Registro padr�o para o sistema! N�o pode ser alterado...';
  cMsgFixDEL: String = #13 + 'Registro padr�o para o sistema! N�o pode ser exclu�do...';

  { Seguran�a }
  ciPassLength: integer = 4;
  ciPassTimes: integer = 3;

  cFloatTolerance: extended = 0.00000001;

var
  vLookupResult: variant;

  { DBExpress }
  TD: TTransactionDesc;
  pSQLCnn: TSQLConnection;

  { Conex�o DB }
  gsConnectionFile: String;

  { Configura��es da aplica��o }
  gAppConfig: TAppConfig;

  { SQLs da aplica��o }
  gAppSQL: Array Of TAppSQL;

  { Guarda o usu�rio autorizado no form de Libera��o de acesso - frmLibera_Senha}
  xUserAut: OleVariant;

  { variaveis para guardar o crm e o nome do m�dico / enfermeiro}
  xID_USER, xCRM, xCoren : Integer;
  xNM_USER : string;

  { variavel para usar como complemento para o messagebox}
  msn : string;

  { variavel que armazena o numero do atendimento passado como parametro do atendimento medico}
  xID_AT : Integer;

  {variavel q serve como passagem de parametro para localizar registros do paciente - 16/11/2008 - Panegassi}
  xId_Paciente : integer;

  { variavel para guardar o tipo de atendimento medico}
  xTipo_At_Med : integer;
  {
    0 : CLINICA
    1 : PEDIATRIA
    2 : GERAL
    3 : OUTROS
  }
   {vari�veis para controlar fluxo no cadastro de acessos}
  xTipo_Tela_Colaborador2 : String;


Function IIf(bCondition: boolean; vRet1, vRet2: variant): variant;
Function NullStrToInt(sStr: String): integer;
Function StrZero(iNumber: integer; iLen: integer): String;
Function FloatIsZero(nVal: extended): boolean;

Function MsgBox(iStyle: integer; sMessage: String): integer;
Function ErrorMsg(E: Exception): String;

Function RegistryRead(sPath: String; sKey: String; sData: String = ''): String;
Procedure RegistrySave(sPath: String; sKey: String; sData: String);
Function GetWindowsTempDir: String;
Function GetWindowsVersion: String;
Function IsWinNT: boolean;

Function LogUser: String;
Function GetMachineIP: String;
Function GetMachineHost: String;
Function CtrlDown: Boolean;
Function ShiftDown: Boolean;
Function AltDown: Boolean;
Function IsDebugged: Boolean;

Function FormReadParam(Var Sender: TObject; sRegPath: String): boolean;
Procedure FormSaveParam(Var Sender: TObject; sRegPath: String);
Function FormCreated(Const MDIChildForm: TForm): boolean;

Function FindNextControl(Sender: TObject; CurControl: TWinControl; GoForward, CheckTabStop, CheckParent: boolean): TWinControl;
Procedure NextCtrl(Sender: TObject; Var KeyPress: Char);

Procedure CheckRequired(DataSet: TClientDataSet);
Procedure SetFieldFocus(Sender: TObject);
Procedure SetUpperCase(Sender: TObject);

Function HasProperty(Sender: TObject; sProperty: String): PPropInfo;
Function HasParam(aParam: Array Of Const; i: integer): boolean;

Function SQLFormat(sData: String; cDataType: Char; sDatabaseType: String = ''; bAllowNull: boolean = False): String;

Function ServerDateTime(SQLCnn: TSQLConnection; sDatabaseType: String = ''): TDateTime; overload;

Procedure CDSOpen(DataSet: TClientDataSet);
Procedure CDSClose(DataSet: TClientDataSet);

Function CDSInsert(DataSet: TClientDataSet): boolean;
Function CDSUpdate(DataSet: TClientDataSet): boolean;
Function CDSDelete(DataSet: TClientDataSet; Confirm: boolean = True; AutoCommit: boolean = True): boolean;
Function CDSPost(DataSet: TClientDataSet): boolean;
Function CDSCancel(DataSet: TClientDataSet): boolean;

Function CDSUpdated(DataSet: TCustomClientDataSet; UpdateKind: TUpdateKind): boolean;
Procedure CDSTOStringList(DataSet: TClientDataSet; Var StringList: TStringList);

{ Gera��o de IDs utilizando MAX }
function NewKEY(sTableName, sKeyField, sCondition: String; SQLCnn: TSQLConnection): String; overload;

{ Gera��o de IDs utilizando ID TABLE }
function NewID(sTableName, sKeyField, sCondition: String; SQLCnn: TSQLConnection; iInc: integer = 1): String; overload;

{ Gera��o de IDs utilizando SEQUENCEs, GENERATORs }
Function NewGEN(sGenOBJ: String; SQLCnn: TSQLConnection; iInc: integer = 1): String; overload;

{fun��es / procedures - Unimed Amparo}

{ panegassi - 31/03/2006 - seleciona o ultimo campo da tabela CONTADORES}
function SelecMax(sTableName, sKeyField : String; SQLCnn: TSQLConnection): String; Overload;

{panegassi - 31/03/2006 - para gerar incrementa��o no coidgo do cartao(usuarios / medicos outra unimed)}
function NewKEY_Cartao(sTableName, sKeyField : String; SQLCnn: TSQLConnection): String; Overload;
function ColocaVirgula(S : String) : Real;
function ColocaVirgula_18(S : String) : Real;
function AbreviaNome(Nome: String): string;
function AjustaStr(str:String; tam:Integer) : String;
function RetiraPontoDecimal(ValorStr : String) : String;

{panegassi - 16/11/2006 - rotina para montar o master-detail}
procedure Master_Detail(cds : TClientDataSet; id : Integer);

{panegassi - 26/05/2006 - coloca zeros a esquerda de uma string num�rica}
function StrZero_(str_number : string; tam : integer) : string;

{panegassi - 30/05/2006 - clonar os dados de um cds para outro}
procedure CloneRecord(Cds: TClientDataSet);

{rotina pra controle do vencimento do cart�o de cr�dito}
function DiaUtel(Data: TDate): TDate;

{panegassi - 11/12/2006 - rotina para retornar o numero de dias �teis num periodo de datas}
function DifDateUtil(dataini, datafim: Tdatetime): integer;

{panegassi  - 28/12/2006 - para arredondamento de valores monet�rios}
Function Arredondar(value: Double; casas : Integer): Double;

{panegassi  - 07/08/2008 - Calculo da idade}
function CalculaIdade(Dt_Nasc, Dt_Atual : TDateTime) : double;

{ Panegassi - 24/01/2007 -  Esta fun��o faz arredondamento de valores reais para "n" casas
  decimais ap�s o separador decimal, seguindo os crit�rios das
  calculadoras financeiras e dos bancos de dados InterBase e FireBird. }
function TBRound(Value: Extended; Decimals: integer): Extended;

{ Panegassi - 18/08/2008 - Fun��o para v�lidar os campos de obrigat�rios}
function CamposValidados(cds : TClientDataSet) : Boolean;

procedure dbeKeyChange(dbeLkp: TDBEdit); overload;
procedure dbeKeyChange(dbeLkp: TEdit); overload;
procedure dbeKeyChange(dbeLkp1, dbeLkp2: TDBEdit); overload;

procedure dbeKeyExit(dbeKey, dbeLkp: TDBEdit; sTableName, sLookupFields, sCondition: String; SQLCnn: TSQLConnection); overload;
procedure dbeKeyExit(dbeKey, dbeLkp: TEdit; sTableName, sLookupFields, sCondition: String; SQLCnn: TSQLConnection); overload;
procedure dbeKeyExit(dbeKey, dbeLkp1, dbeLkp2: TDBEdit; sTableName, sLookupFields, sCondition: String; SQLCnn: TSQLConnection); overload;

function DoLookup(sTableName, sLookupFields, sCondition: String; SQLCnn: TSQLConnection): Variant; overload;

procedure RefreshLookupTables(DataSet: TClientDataSet);

function ExecDynSQL(iRecords: Integer; sCommandText: WideString;
  Var cdsGeral: TClientDataSet; SQLCnn: TSQLConnection): integer; overload;

procedure GridIndex(Column: TColumn);

function PesqGetSQL(DataSet: TClientDataSet): String;
function PesqExecute(DataSet: TClientDataSet; sChave: string; sTexto : String): String;

function VariantIsEmpty(v: variant): boolean;
function MakeStr(Const Arg: TVarRec): String;
function GetValue(Field: TField): String;

function IsValidChar(sDado: String): boolean;
function IsValidNumber(sDado: String): boolean;
function IsValidDigit(sDado: String): boolean;
function ExtractChar(sDado: String): String;
function ExtractNumber(sDado: String): String;
function InArray(sItem: String; aArray: Array Of String): boolean;

function FormataCGCCPF(sDado, sTipoPessoa: String): String;
function VerificaCGCCPF(sDado, sTipoPessoa: String): boolean;
function FormataIE(sDado, sTipoPessoa: String): String;

function FormataCEP(sDado: String): String;

function DiaSemana(Data: TDateTime): String;

function ExecQuery(sSQL: WideString; SQLCnn: TSQLConnection): Boolean;

function IsNumeric(S : String) : Boolean;
procedure Valida_Mascara_Producao_Especial(campo: TMaskEdit);

Procedure Desconecta_Conecta_SqlConnection;

function CopiaArquivo(Origem: String; Destino: String): Boolean;

{$WRITEABLECONST ON}

Implementation

uses untDmPrincipal;

function ExecQuery(sSQL: WideString;
  SQLCnn: TSQLConnection): Boolean;
var
  qry: TSQLQuery;
begin
  qry := TSQLQuery.Create(nil);
  try
     try
       qry.SQLConnection := SQLCnn;
       qry.SQL.Add(sSQL);
       Result := (qry.ExecSQL(true) > 0);

     Except
       On E: Exception do
       begin
         Result := False;
         Raise Exception.Create(ErrorMsg(E));
       end;
     end;
  finally
     FreeAndNil(qry);
  end;
end;

function CamposValidados(cds : TClientDataSet) : Boolean;
var
  i :Integer;
  Campos :TStrings;
begin
  try
    Campos := TStringList.Create;
    for i := 0 to cds.Fields.Count - 1 do
      begin
        if (cds.Fields[i].Origin = 'V') then
          if (cds.Fields[i].AsString = EmptyStr) then
            Campos.Add('- ' + cds.Fields[i].DisplayName);
      end;

    if (Campos.Text <> EmptyStr) then
      begin
        Campos.Insert(0, '<< Preencha os Campos Obrigat�rios >>');
        Campos.Insert(1, EmptyStr);
        ShowMessage(Campos.Text);
        Result := False;
      end
    else
      Result := True;
  finally
    Campos.Free;
  end;
end;

{arredonda valores}
function TBRound(Value: Extended; Decimals: integer): Extended;
var
  Factor, Fraction: Extended;
begin
  Factor := IntPower(10, Decimals);
  { A convers�o para string e depois para float evita
    erros de arredondamentos indesej�veis. }
  Value := StrToFloat(FloatToStr(Value * Factor));
  Result := Int(Value);
  Fraction := Frac(Value);
{  if Fraction >= 0.55 then
    Result := Result + 1
  else if Fraction <= -0.55 then
    Result := Result - 1;}
  Result := Result / Factor;
end;

procedure Master_Detail(cds : TClientDataSet; id : Integer);
begin
  cds.Close;
  cds.Params[0].AsInteger := id;
  cds.Open;
end;

function DifDateUtil(dataini, datafim : Tdatetime) : integer;
var
  i, count : integer;
  dt : Tdatetime;
begin
  result:= 0;
  if dataini > datafim then
    exit;
  count:= 0;
  dt:= dataini;
  for i := Trunc(dataini) to Trunc(datafim) do
    begin
      if DayOfWeek(dt) in [2..6] then
        Inc(count);
      dt:= dt + 1;
    end;
  result:= count;
end;

function DiaUtel(Data: TDate): TDate;
var
 Feriados: TStringList;
 N1, N2, N3, N4 , N5, N6, N7, N8: Integer;
 N9, N10, N11, N12, Ano, Mes, Dia: Integer;
begin
 // Carrega Feriados Nacionais Fixos;
 Feriados := TStringList.Create;
 try
  Feriados.Add('01/01'); // Confraterniza��o Universal;
  Feriados.Add('21/04'); // Tiradentes;
  Feriados.Add('01/05'); // Dia do Trabalho;
  Feriados.Add('07/09'); // Independ�ncia do Brasil;
  Feriados.Add('12/10'); // N. Sr�. Aparecida;
  Feriados.Add('02/11'); // Finados;
  Feriados.Add('15/11'); // Proclama��o da Rep�blica;
  Feriados.Add('25/12'); // Natal;
  //
  // Verifica se � Feriado Nacional Fixo;
  if (Feriados.IndexOf(FormatDateTime('dd', Data) + '/' + FormatDateTime('mm', Data)) <> -1) then
   Data := Data + 1;
  //
  // Feriados Nacionais M�veis;
  Ano := StrToInt(FormatDateTime('yyyy', Data));
  N1  := Ano mod 19;
  N2  := Ano div 100;
  N3  := Ano mod 100;
  N4  := N2 div 4;
  N5  := N2 mod 4;
  N6  := (N2 + 8) div 25;
  N7  := (N2 - N6 + 1) div 3;
  N8  := (19 * N1 + N2 - N4 - N7 + 15) mod 30;
  N9  := N3 div 4;
  N10 := N3 mod 4;
  N11 := (32 + 2 * N5 + 2 * N9 - N8 - N10) mod 7;
  N12 := (N1 + 11 * N8 + 22 * N11) div 451;
  Mes := (N8 + N11 - 7 * N12 + 114) div 31;
  Dia := (N8 + N11 - 7 * N12 + 114) mod 31;
  //
  if Data = EncodeDate(Ano, Mes, Dia + 1) - 47 then // Carnaval;
    Data := Data + 1;
  //
  if Data = EncodeDate(Ano, Mes, (Dia - 1)) then // Sexta-Feira Santa;
    Data := Data + 1;
  //
  if Data = EncodeDate(Ano, Mes, (Dia + 1)) then // P�scoa;
   Data := Data + 1;
  //
  if Data = EncodeDate(Ano, Mes, Dia + 1) + 60 then // Corpus Crist;
   Data := Data + 1;
  //
  // Feriado Municipal Fixo;
  if FormatDateTime('dd/mm', Data) = '08/09' then
   Data := Data + 1;
  //

 if (DayOfWeek(Data) = 7) then // S�bado;
   Data := Data + 1;

  if (DayOfWeek(Data) = 1) then // Domingo;
   Data := Data + 1;
 finally
  FreeAndNil(Feriados);
 end;
  Result := Data;
end;

{coloca virgula numa string com 18 casas}
function ColocaVirgula_18(S : String) : Real;
var
  i   : Byte;
  Aux : String[18];
begin
  Aux   := '';
  for i := 1 to Length(S) do
    if S[i] in ['0'..'9'] then
      Aux    := Aux + S[i];
      Result := StrToFloat(Aux) / 100;
end;

{clonar dados de um cds para outro}
procedure CloneRecord(Cds: TClientDataSet);
var
  CdsClone : TClientDataSet;
  i        : integer;
begin
  CdsClone := TClientDataSet.Create(Application);
  try
    CdsClone.CloneCursor(Cds, True);
    Cds.Append;
    for i := 0 to Cds.FieldCount - 1 do
      Cds.Fields[i].Value := CdsClone.Fields[i].Value;
    CdsClone.Close;
  finally
    CdsClone.Free;
  end;
end;

function StrZero_(str_number : string; tam : integer) : string;
var
  x          : string;
  a, b, c, d : integer;
begin
    a := Length(str_number);
    b := tam;
    c := b - a;
    x := '';
    for d := 1 to c -1 do
     begin
      x := x + '0'
     end ;
  Result := x + str_number;
end;

function RetiraPontoDecimal(ValorStr : String) : String;
var
  Posicao : Integer;
begin
 { Posicao := pos(' ', ValorStr);
  while Posicao <> 0 do
    begin
      Posicao := pos(' ', ValorStr);
      delete(ValorStr, Posicao, 1);         // elimina espacos...
    end;
  Posicao := pos(ThousandSeparator, ValorStr);
  while Posicao <> 0 do
    begin
      Posicao := pos(ThousandSeparator, ValorStr);
      delete(ValorStr, Posicao, 1);         // elimina separador das centenas...
    end;
  Posicao := pos(DecimalSeparator, ValorStr);
  if Posicao <> 0 then
    begin
      delete(ValorStr, Posicao, 1);
    end;
  RetiraPontoDecimal := ValorStr;   }
end;

function AjustaStr(str : String; tam : Integer) : String;
begin
  while Length (str) < tam do
    str := str + ' ';
    if Length (str) > tam then
      str := Copy (str, 1, tam);
    Result := str;
end;

function tbStrZero(const I: Int64; const Casas: byte): string;
var
  Ch: Char;
begin
  Result := IntToStr(I);
  if Length(Result) > Casas then
    begin
      Ch := '*';
      Result := '';
    end
else
  Ch := '0';
  while Length(Result) < Casas do
    Result := Ch + Result;
end;

function AbreviaNome(Nome: String): String;
var
  Nomes : array[1..25] of string;
  i, TotalNomes: Integer;
begin
  Nome   := Trim(Nome);
  Result := Nome;
  {Insere um espa�o para garantir que todas as letras sejam testadas}
  Nome := Nome + #32;
  {Pega a posi�ao do primeiro espa�o}
  i := Pos(#32, Nome);
  if i > 0 then
    begin
      TotalNomes := 0;
      {Separa todos os nomes}
      while i > 0 do
        begin
          Inc(TotalNomes);
          Nomes[TotalNomes] := Copy(Nome, 1, i - 1);
          Delete(Nome, 1, i);
          i := Pos(#32, Nome);
        end;
      if TotalNomes > 2 then
        begin
          {Abreviar a partir do segundo nome, exceto o �ltimo.}
          for i := 3 to TotalNomes - 1 do
            begin
              {Cont�m mais de 3 letras? (ignorar de, da, das, do, dos, etc.)}
              if Length(Nomes[i]) > 3 then
              {Pega apenas a primeira letra do nome e coloca um ponto ap�s.}
              Nomes[i] := Nomes[i][1] + '.';
            end;
          Result := '';
          for i  := 1 to TotalNomes do
            Result := Result + Trim(Nomes[i]) + #32;
            Result := Trim(Result);
       end;
    end;
end;

function ColocaVirgula(S : String) : Real;
var
  i   : Byte;
  Aux : String[8];
begin
  Aux   := '';
  for i := 1 to Length(S) do
    if S[i] in ['0'..'9'] then
      Aux    := Aux + S[i];
      Result := StrToFloat(Aux) / 100;
end;

{calcula a idade real}
function CalculaIdade(Dt_Nasc, Dt_Atual : TDateTime) : double;
var
  Idade : String;
  Resto : Integer;
  iDia, iMes, iAno, fDia, fMes, fAno : Word;
  nDia, nMes, nAno, DiaBissexto : Double;
begin

  DecodeDate(Dt_Nasc, iAno, iMes, iDia);
  DecodeDate(Dt_Atual, fAno, fMes, fDia);

  nAno := fAno - iAno;
  if nAno > 0 then
    if fMes < iMes then
      nAno := nAno - 1
    else
      if(fMes = iMes)and(fDia < iDia)then
        nAno := nAno - 1;

  if fMes < iMes then
    begin
      nMes := 12 - (iMes-fMes);
      if fDia < iDia then
        nMes := nMes - 1;
    end
  else
    if fMes = iMes then
      begin
        nMes := 0;
        if fDia < iDia then
          nMes := 11;
      end
    else
      if fMes > iMes then
        begin
          nMes := fMes - iMes;
          if fDia < iDia then
            nMes := nMes - 1;
        end;
      nDia := 0;

      if fDia > iDia then
        nDia := fDia - iDia;

      if fDia < iDia then
        nDia := (Dt_Nasc - IncMonth(Dt_Atual, -1)) - (iDia - fDia);

      Result := 0;
      Result := StrToFloat(FormatFloat('##00', nAno) + ',' + FormatFloat('##00', nMes));
end;

Function Arredondar(value: Double; casas : Integer): Double;
Var
  fracao, Total: Real;
  decimal: string;
begin
  try
    fracao := Frac(value); //Retorna a parte fracion�ria de um n�mero
    decimal := (RightStr(FloatToStr(fracao), Length(FloatToStr(fracao)) - 2)); //decimal recebe a parte decimal
    //enquanto o tamanho da variavel decimal for maior que o n�mero de casas fa�a
    while Length(decimal) > casas do
      begin
      //Verifica se o �ltimo digito da vari�vel decimal � maior que 5
        if StrToInt(RightStr(decimal, 1)) > 5 then
          begin
           //Descarta o �ltimo digito da vari�vel Decimal
           decimal := LeftStr(decimal, Length(decimal) - 1);
           //Soma o valor n�mero da variavel decimal + 1
           decimal := FloatToStr(StrToFloat(decimal) + 1);
          end
        else
          decimal:=LeftStr(decimal, Length(decimal) - 1); //Descarta o �ltimo digito da vari�vel Decimal
      end;
    result:=(Int(value) + (StrToFloat(decimal) / 100)); //devolve o resultado para a fun��o
  except
    Raise Exception.Create('Erro no arredondamento');
  end;
end;

Function IIf(bCondition: boolean; vRet1, vRet2: variant): variant;
Begin
  If bCondition Then
    IIf := vRet1
  Else
    IIf := vRet2;
End;

Function NullStrToInt(sStr: String): integer;
Const
  Digitos = ('0123456789');
Var
  i: integer;
  s: String;
Begin
  For i := 1 To Length(sStr) Do
    If Pos(Copy(sStr, i, 1), Digitos) > 0 Then
      s := s + Copy(sStr, i, 1);
  If Trim(s) <> '' Then
    Result := StrToInt(s)
  Else
    Result := 0;
End;

Function StrZero(iNumber: integer; iLen: integer): String;
Var
  i: integer;
Begin
  Result := '';
  For i := 1 To (iLen - Length(Trim(IntToStr(iNumber)))) Do
    Result := Result + '0';

  Result := Result + Trim(IntToStr(iNumber));
End;

Function FloatIsZero(nVal: extended): boolean;
Begin
  Result := abs(nVal) < cFloatTolerance;
End;

Function MsgBox(iStyle: integer; sMessage: String): integer;
Var
  sCaption: String;
Begin
  If iStyle = cStop_Ok Then
    sCaption := 'Interrup��o'
  Else
    If (iStyle = cQuestion_YesNo) Or (iStyle = cQuestion_YesNoCancel) Then
      sCaption := 'Quest�o'
    Else
      If iStyle = cInfo_Ok Then
        sCaption := 'Informa��o'
      Else
        If iStyle = cWarn_Ok Then
          sCaption := 'Aviso'
        Else
          If iStyle = cWarn_OkCancel Then
            sCaption := 'Aviso'
          Else
            If iStyle = cError_Ok Then
              sCaption := 'Erro';

  Result := Application.MessageBox(pChar(sMessage), PChar(sCaption), iStyle);
End;

Function ErrorMsg(E: Exception): String;
Begin
  If Pos('Esta instru��o provocou', E.Message) > 0 Then
    Result := E.Message
  Else
    Result := 'Esta instru��o provocou o seguinte erro:' + #13#10 + E.Message;
End;

Function RegistryRead(sPath: String; sKey: String; sData: String = ''): String;
Var
  Reg: TRegistry;
  s: String;
Begin
  Reg := TRegistry.Create;
  Try
    Reg.RootKey := HKEY_CURRENT_USER;
    Reg.OpenKey(sPath, False);
    s := Reg.ReadString(sKey);

    If s = '' Then
      Result := sData
    Else
      Result := s;
  Finally
    Reg.Free;
  End;
End;

Procedure RegistrySave(sPath: String; sKey: String; sData: String);
Var
  Reg: TRegistry;
Begin
  Reg := TRegistry.Create;
  Try
    Reg.RootKey := HKEY_CURRENT_USER;
    Reg.OpenKey(sPath, True);

    Reg.WriteString(sKey, sData);
  Finally
    Reg.Free;
  End;
End;

Function GetWindowsTempDir: String;
Var
  TempDir: Array[0..MAX_PATH] Of Char;
Begin
  GetTempPath(MAX_PATH, @TempDir);
  Result := TempDir;
End;

Function GetWindowsVersion: String;
Var
  Registry: TRegistry;
  TOsv: TOsVersionInfo;
Begin
  Result := '';

  TOsv.dwOSVersionInfoSize := SizeOf(TOsv);
  GetVersionEx(TOsv);

  If (TOsv.dwPlatformId = VER_PLATFORM_WIN32_NT) Then Begin
    Result := 'Windows NT ' + IntToStr(TOsv.dwMajorVersion) + '.' + IntToStr(TOsv.dwMinorVersion) +
      ' (Build ' + IntToStr(TOsv.dwBuildNumber) + ') - ' + TOsv.szCSDVersion;
  End
  Else Begin
    Registry := TRegistry.Create;
    Registry.RootKey := HKEY_LOCAL_MACHINE;
    Registry.OpenKey('\Software\Microsoft\Windows\CurrentVersion', False);
    Result := Registry.ReadString('Version') + ' (Build ' + Registry.ReadString('VersionNumber') + ')';
    Registry.Free;
  End;
End;

Function IsWinNT: boolean;
Var
  TOsv: TOsVersionInfo;
Begin
  TOsv.dwOSVersionInfoSize := SizeOf(TOsv);
  GetVersionEx(TOsv);
  Result := (TOsv.dwPlatformId = VER_PLATFORM_WIN32_NT)
End;

Function LogUser: String;
Const
  Buff_Size = MAX_COMPUTERNAME_LENGTH + 1;
Var
  lpBuffer: PChar;
  nSize: DWord;
Begin
  nSize := Buff_Size;
  lpBuffer := StrAlloc(Buff_Size);
  GetUserName(lpBuffer, nSize);
  Result := String(lpBuffer);
  StrDispose(lpBuffer);
End;

Function GetMachineIP: String;
Var
  wsaData: TWSAData;
Begin
  Result := '';
  WSAStartup(257, wsaData);
  Result := iNet_ntoa(PInAddr(GetHostByName(Nil)^.h_addr_list^)^);
  WSACleanup;
End;

Function GetMachineHost: String;
Var
  wsaData: TWSAData;
Begin
  Result := '';
  WSAStartup(257, wsaData);
  Result := GetHostByName(Nil)^.h_name;
  WSACleanup;
End;

Function CtrlDown: Boolean;
Var
  State: TKeyboardState;
Begin
  GetKeyboardState(State);
  Result := ((State[vk_Control] And 128) <> 0);
End;

Function ShiftDown: Boolean;
Var
  State: TKeyboardState;
Begin
  GetKeyboardState(State);
  Result := ((State[vk_Shift] And 128) <> 0);
End;

Function AltDown: Boolean;
Var
  State: TKeyboardState;
Begin
  GetKeyboardState(State);
  Result := ((State[vk_Menu] And 128) <> 0);
End;

Function IsDebugged: Boolean;
Var
  IsDebuggerPresent: Function: boolean; stdcall;
  KernelHandle: THandle;
  P: Pointer;
Begin
  KernelHandle := GetModuleHandle(kernel32);
  @IsDebuggerPresent := GetProcAddress(KernelHandle, 'IsDebuggerPresent');
  If Assigned(IsDebuggerPresent) Then
    Result := IsDebuggerPresent
  Else Begin
    P := GetProcAddress(KernelHandle, 'GetProcAddress');
    Result := (DWORD(P) < KernelHandle);
  End;
End;

Function FormReadParam(Var Sender: TObject; sRegPath: String): boolean;
Var
  Registry: TRegistry;
Begin
  Registry := TRegistry.Create;
  Try
    Registry.RootKey := HKEY_CURRENT_USER;
    If Registry.OpenKey(sRegPath + '\' + TForm(Sender).Name, False) Then Begin
      TForm(Sender).Top := NullStrToInt(Registry.ReadString('Top'));
      TForm(Sender).Left := NullStrToInt(Registry.ReadString('Left'));
      If TForm(Sender).BorderStyle <> bsDialog Then Begin
        TForm(Sender).Width := NullStrToInt(Registry.ReadString('Width'));
        TForm(Sender).Height := NullStrToInt(Registry.ReadString('Height'));
        TForm(Sender).WindowState := iif(Registry.ReadString('WindowState') = '1', wsMaximized, wsNormal);
      End;
      Result := True
    End
    Else
      Result := False;
  Finally
    FreeAndNil(Registry);
  End;
End;

Procedure FormSaveParam(Var Sender: TObject; sRegPath: String);
Var
  Registry: TRegistry;
Begin
  Registry := TRegistry.Create;
  Try
    Registry.RootKey := HKEY_CURRENT_USER;
    If Registry.OpenKey(sRegPath + '\' + TForm(Sender).Name, True) Then Begin
      If TForm(Sender).WindowState = wsMaximized Then
        Registry.WriteString('WindowState', '1')
      Else Begin
        Registry.WriteString('Top', IntToStr(TForm(Sender).Top));
        Registry.WriteString('Left', IntToStr(TForm(Sender).Left));
        If TForm(Sender).BorderStyle <> bsDialog Then Begin
          Registry.WriteString('Width', IntToStr(TForm(Sender).Width));
          Registry.WriteString('Height', IntToStr(TForm(Sender).Height));
          Registry.WriteString('WindowState', '0');
        End;
      End;
    End;
  Finally
    FreeAndNil(Registry);
  End;
End;

Function FormCreated(Const MDIChildForm: TForm): boolean;
Begin
  If MDIChildForm <> Nil Then Begin
    MDIChildForm.Show;
    Result := True;
  End
  Else
    Result := False;
End;

Procedure CheckRequired(DataSet: TClientDataSet);
Var
  i: integer;
Begin
  { Verificando nulo e vazio devido IS NULL no update }
  If DataSet.State = dsEdit Then
    For i := 0 To DataSet.FieldCount - 1 Do
      If Not VarIsNull(DataSet.Fields[i].Value) Then { n�o est� nulo }
        If VarToStr(DataSet.Fields[i].Value) = '' Then { est� em branco }
          If DataSet.Fields[i].ProviderFlags <> [] Then { ser� atualizado }
            DataSet.Fields[i].Value := Null;

  { Verificando campos requeridos na opera��o de edi��o }
  For i := 0 To DataSet.FieldCount - 1 Do
    If DataSet.Fields[i].Required Then
      If Trim(VarToStr(DataSet.Fields[i].Value)) = '' Then
        Raise Exception.Create('Campo ''' + DataSet.Fields[i].DisplayLabel + ''' deve conter um valor!');
End;

Function FindNextControl(Sender: TObject; CurControl: TWinControl; GoForward, CheckTabStop, CheckParent: boolean): TWinControl;
Var
  i, StartIndex: Integer;
  List: TList;
Begin
  Result := Nil;
  List := TList.Create;
  Try
    TWinControl(Sender).GetTabOrderList(List);
    If List.Count > 0 Then Begin
      StartIndex := List.IndexOf(CurControl);
      If StartIndex = -1 Then
        If GoForward Then
          StartIndex := List.Count - 1
        Else
          StartIndex := 0;
      i := StartIndex;
      Repeat
        If GoForward Then Begin
          Inc(i);
          If i = List.Count Then
            i := 0;
        End
        Else Begin
          If i = 0 Then
            i := List.Count;
          Dec(i);
        End;
        CurControl := List[i];
        If CurControl.CanFocus And
          (Not CheckTabStop Or CurControl.TabStop) And
          (Not CheckParent Or (CurControl.Parent = CurControl)) Then
          Result := CurControl;
      Until (Result <> Nil) Or (i = StartIndex);
    End;
  Finally
    FreeAndNil(List);
  End;
End;

Procedure SetFieldFocus(Sender: TObject);
Var
  i, j: integer;
  wControl: TWinControl;
  bFieldRO, bCompRO: boolean;
Begin
  If Sender Is TForm Then
    For i := 0 To TForm(Sender).ComponentCount - 1 Do
      If TForm(Sender).Components[i] Is TWinControl Then
        If TWinControl(TForm(Sender).Components[i]).Tag = 99 Then Begin
          wControl := TWinControl(TForm(Sender).Components[i]);

          j := 0;
          While True Do Begin
            bFieldRO := False;
            If GetPropInfo(wControl.ClassInfo, 'DataField') <> Nil Then
              bFieldRO := TDataSource(GetObjectProp(wControl, 'DataSource')).DataSet.FieldByName(GetStrProp(wControl, GetPropInfo(wControl.ClassInfo, 'DataField'))).ReadOnly;

            bCompRO := False;
            If GetPropInfo(wControl.ClassInfo, 'ReadOnly') <> Nil Then
              bCompRO := (GetOrdProp(wControl, GetPropInfo(wControl.ClassInfo, 'ReadOnly')) = 1);

            If Not bFieldRO And Not bCompRO Then Begin
              wControl.SetFocus;
              exit;
            End;

            wControl := FindNextControl(TForm(Sender), wControl, True, True, False);
            Inc(j);

            If TForm(Sender).ComponentCount < j Then
              break;
          End;
        End;
End;

Procedure SetUpperCase(Sender: TObject);
Var
  i: integer;
Begin
  If Sender Is TForm Then
    For i := 0 To (Sender As TForm).ComponentCount - 1 Do Begin
      If ((Sender As TForm).Components[i] Is TDBEdit) Then
        ((Sender As TForm).Components[i] As TDBEdit).CharCase := ecUpperCase;
      If ((Sender As TForm).Components[i] Is TEdit) Then
        ((Sender As TForm).Components[i] As TEdit).CharCase := ecUpperCase;
    End;
End;

Function HasProperty(Sender: TObject; sProperty: String): PPropInfo;
Begin
  If Sender <> Nil Then
    Result := GetPropInfo(Sender.ClassInfo, sProperty)
  Else
    Result := Nil;
End;

Function HasParam(aParam: Array Of Const; i: integer): boolean;
Begin
  Result := False;
  If Length(aParam) > i Then
    If aParam[i].VAnsiString <> Nil Then
      Result := String(aParam[i].VAnsiString) <> '';
End;

Procedure NextCtrl(Sender: TObject; Var KeyPress: Char);
Var
  fDataSet: TDataSet;
  fFieldName: String;
  fFieldType: TFieldType;
Begin
  {If KeyPress = #13 Then Begin
    If Not (TForm(Sender).ActiveControl Is TDBGrid) And
      Not (TForm(Sender).ActiveControl Is TBitBtn) And
      Not (TForm(Sender).ActiveControl Is TButton) And
      Not (TForm(Sender).ActiveControl Is TComboBox) And
      Not (TForm(Sender).ActiveControl Is TDBComboBox) And
      Not (TForm(Sender).ActiveControl Is TDBLookupComboBox) And
      Not (TForm(Sender).ActiveControl Is TDBMemo) And
      Not (TForm(Sender).ActiveControl Is TStringGrid) Then Begin
      KeyPress := #0;
      TForm(Sender).Perform(wm_NextDlgCtl, 0, 0);
    End;
  End
  Else
    If KeyPress = #10 Then Begin
      If (TForm(Sender).ActiveControl Is TDBGrid) Then Begin
        KeyPress := #0;
        TForm(Sender).Perform(wm_NextDlgCtl, 0, 0);
      End;
    End
    Else Begin
      If HasProperty(TForm(Sender).ActiveControl, 'DataField') <> Nil Then
        If UpperCase(TForm(Sender).ActiveControl.ClassName) = 'TDBEDIT' Then Begin
          fDataSet := TDBEdit(TForm(Sender).ActiveControl).DataSource.DataSet;
          fFieldName := TDBEdit(TForm(Sender).ActiveControl).DataField;
          fFieldType := fDataSet.FieldByName(fFieldName).DataType;

          If KeyPress = #32 Then
            If (fFieldType = ftDate) Or (fFieldType = ftTime) Or (fFieldType = ftDateTime) Then
              If fDataSet.State In [dsInsert, dsEdit] Then Begin
                fDataSet.FieldByName(fFieldName).Text := '';
                KeyPress := #0;
              End;

          If (KeyPress = '.') Or (KeyPress = ',') Then
            If (fFieldType = ftFloat) Or (fFieldType = ftCurrency) Or (fFieldType = ftBCD) Then
              KeyPress := DecimalSeparator;
        End;
    End     }
End;

Function SQLFormat(sData: String; cDataType: Char; sDatabaseType: String = ''; bAllowNull: boolean = False): String;
Const
  sTrue = 'TRUE;VERDADEIRO;SIM;1';
  sFalse = 'FALSE;FALSO;NAO;N�O;0';
Begin
  Result := 'Null';

  If sDatabaseType = '' Then
    sDatabaseType := gAppConfig.gsDatabase;

  If sData = '' Then
    If Not bAllowNull Then
      exit;

  { Caracter }
  If cDataType = 'C' Then Begin
    Result := iif(Copy(sData, 1, 1) <> #39, #39, '') + sData +
      iif(Copy(sData, Length(sData), 1) <> #39, #39, '');
  End

    { Data }
  Else
    If cDataType = 'D' Then Begin
      If sData <> '  /  /    ' Then Begin
        sData := DateToStr(StrToDateTime(sData));

        { Oracle }
        If sDatabaseType = 'ORACLE' Then
          Result := iif(Copy(UpperCase(sData), 1, 8) = 'TO_DATE(', sData,
            'TO_DATE(' + #39 + sData + #39 + ', ' + #39 + 'DD/MM/YYYY' + #39 + ')')

          { Interbase }
        Else
          If sDatabaseType = 'IB' Then
            Result := 'CAST(' + #39 + FormatDateTime('mm/dd/yyyy', StrToDate(sData)) + #39 + ' AS DATE)'

            { Access e SQLServer }
          Else
            If (sDatabaseType = 'MSACCESS') Or (sDatabaseType = 'SQLSERVER') Then
              Result := 'FORMAT(' + #39 + sData + #39 + ', ' + #39 + 'DD/MM/YYYY' + #39 + ')'

            Else
              Result := iif(Copy(sData, 1, 1) <> #39, #39, '') + sData +
                iif(Copy(sData, Length(sData), 1) <> #39, #39, '');
      End;
    End

      { Data/Hora }
    Else
      If cDataType = 'T' Then Begin
        If sData <> '  /  /       :  :  ' Then Begin
          sData := DateTimeToStr(StrToDateTime(sData));

          { Oracle }
          If sDatabaseType = 'ORACLE' Then
            Result := iif(Copy(UpperCase(sData), 1, 8) = 'TO_DATE(', sData,
              'TO_DATE(' + #39 + sData + #39 + ', ' + #39 + 'DD/MM/YYYY HH24:MI:SS' + #39 + ')')

            { Interbase }
          Else
            If sDatabaseType = 'IB' Then
              Result := 'CAST(' + #39 + FormatDateTime('mm/dd/yyyy hh:nn:ss', StrToDateTime(sData)) + #39 + ' AS TIMESTAMP)'

              { MSAccess }
            Else
              If sDatabaseType = 'MSACCESS' Then
                Result := 'FORMAT(' + #39 + sData + #39 + ', ' + #39 + 'DD/MM/YYYY HH:NN:SS' + #39 + ')'

              Else
                Result := iif(Copy(sData, 1, 1) <> #39, #39, '') + sData +
                  iif(Copy(sData, Length(sData), 1) <> #39, #39, '');
        End;
      End

        { L�gico }
      Else
        If cDataType = 'L' Then Begin
          If Pos(Trim(UpperCase(sData)), sTrue) > 0 Then
            Result := '1';
          If Pos(Trim(UpperCase(sData)), sFalse) > 0 Then
            Result := '0';
        End

          { Num�rico }
        Else
          If (cDataType = 'N') Or (cDataType = 'I') Then Begin
            If (sData = '') Or (sData = '0') Then
              Result := '0'
            Else Begin
              Result := StringReplace(sData, ' ', '', [rfReplaceAll, rfIgnoreCase]);
              Result := StringReplace(Result, '.', '', [rfReplaceAll, rfIgnoreCase]);
              Result := StringReplace(Result, ',', '.', [rfReplaceAll, rfIgnoreCase]);
            End;
          End;
End;

Function ServerDateTime(SQLCnn: TSQLConnection; sDatabaseType: String = ''): TDateTime; Overload;
Var
  sqlQuery: TSQLQuery;
Begin
  If sDatabaseType = '' Then
    sDatabaseType := gAppConfig.gsDatabase;

  sqlQuery := TSQLQuery.Create(Nil);
  sqlQuery.SQLConnection := SQLCnn;
  Try
    Try
      { Oracle }
      If sDatabaseType = 'ORACLE' Then
        sqlQuery.SQL.Add('SELECT SYSDATE AS DATAHORA FROM DUAL')

        { Interbase }
      Else
        If sDatabaseType = 'IB' Then
          sqlQuery.SQL.Add('SELECT CAST(''NOW'' AS TIMESTAMP) AS DATAHORA FROM RDB$DATABASE')

          { Access e SQLServer }
        Else
          If (sDatabaseType = 'MSACCESS') Or (sDatabaseType = 'SQLSERVER') Then
            sqlQuery.SQL.Add('');

      { Ativando }
      sqlQuery.Prepared := True;
      sqlQuery.Open;

      Result := sqlQuery.FieldByName('DATAHORA').AsDateTime;
    Except
      Result := Now;
    End;
  Finally
    FreeAndNil(sqlQuery);
  End;
End;

Procedure CDSOpen(DataSet: TClientDataSet);
Begin
  Try
    If DataSet.Active Then
      DataSet.Active := False;

    If (DataSet.ProviderName <> '') Then
      DataSet.Data := Null;

    DataSet.Active := True;
  Except
    On E: Exception Do
      Application.MessageBox(PChar('Esta opera��o provocou o seguinte erro: ' + #13#10 + E.Message), 'Erro', cError_Ok);
  End;
End;

Procedure CDSClose(DataSet: TClientDataSet);
Begin
  If DataSet.Active Then
    DataSet.Active := False;

  If (DataSet.ProviderName <> '') Then
    DataSet.Data := Null;
End;

Function CDSInsert(DataSet: TClientDataSet): boolean;
Begin
  Result := False;

  If DataSet.State In [dsInsert, dsEdit] Then Begin
    Application.MessageBox('Processo de inclus�o em andamento!', 'Aten��o', cInfo_Ok);
    exit;
  End;

  Try
    DataSet.Insert;
    Result := True;
  Except
    On E: Exception Do Begin
      If DataSet.State In [dsInsert, dsEdit] Then
        DataSet.Cancel;
      Application.MessageBox(PChar('Esta opera��o provocou o seguinte erro: ' + #13#10 + E.Message), 'Erro', cError_Ok);
    End;
  End;
End;

Function CDSUpdate(DataSet: TClientDataSet): boolean;
Begin
  Result := False;

  if DataSet.State in [dsInsert, dsEdit] then
    begin
      Application.MessageBox('Processo de altera��o em andamento!', 'Informa��o', cInfo_Ok);
      exit;
    end;

  if DataSet.IsEmpty then
    exit;
  try
    DataSet.Edit;
    Result := True;
  except
    on E: Exception do
      begin
        if DataSet.State <> dsBrowse then
          DataSet.Cancel;
        Application.MessageBox(PChar('Esta opera��o provocou o seguinte erro: ' + #13#10 + E.Message), 'Erro', cError_Ok);
      end;
  end;
end;

Function CDSDelete(DataSet: TClientDataSet; Confirm: boolean = True; AutoCommit: boolean = True): boolean;
Begin
  Result := True;

  If DataSet.IsEmpty Then
    exit;

  If Confirm Then
    If Application.MessageBox('Confirma realmente esta exclus�o?', 'Quest�o', cQuestion_YesNo) = IDNO Then
      exit;

  Try
    DataSet.Delete;

    If (AutoCommit) Then
      If DataSet.ApplyUpdates(0) > 0 Then
        Result := False;
  Except
    On E: Exception Do Begin
      If Not Assigned(DataSet.OnPostError) Then
        Application.MessageBox(PChar('Esta opera��o provocou o seguinte erro: ' + #13#10 + E.Message), 'Erro', cError_Ok);
      DataSet.CancelUpdates;
      Result := False;
    End;
  End;
End;

Function CDSPost(DataSet: TClientDataSet): boolean;
Begin
  //Douglas Ap Vasconcelos - Toda vez que grava o registro desconecta e conecta do banco de dados.
  try
    DmPrincipal.FDConnection1.Connected := False;
    DmPrincipal.FDConnection1.Connected := True;
  except
    on E: Exception do
    begin
      ShowMessage('ATEN��O... ERRO DE REDE, REINICIE O SISTEMA.');
      //
      Result := False;
      //
      Exit;
    end;
  end;
  //Fim Teste

  Result := True;
  Try
    If DataSet.State In [dsEdit, dsInsert] Then
      DataSet.Post;
  Except
    On E: Exception Do Begin
      If Not Assigned(DataSet.OnPostError) Then
        Application.MessageBox(PChar('Esta opera��o provocou o seguinte erro: ' + #13#10 + E.Message), 'Erro', cError_Ok);
      Result := False;
      exit;
    End;
  End;

  Try
    If DataSet.ChangeCount > 0 Then
      If DataSet.ApplyUpdates(0) > 0 Then
        begin
          Result := False;
          raise Exception.Create('Falha na grava��o.');
        end;
  Except
    On E: Exception Do Begin
      Result := False;
      If Not Assigned(DataSet.OnReconcileError) Then
        Application.MessageBox(PChar('Esta opera��o provocou o seguinte erro: ' + #13#10 + E.Message), 'Erro', cError_Ok);
    End;
  End;
End;

Function CDSCancel(DataSet: TClientDataSet): boolean;
Begin
  try
    if DataSet.State in [dsEdit, dsInsert] then
      begin
        DataSet.Cancel;
      end
    else
      begin
        If DataSet.ChangeCount > 0 Then
           begin
             DataSet.CancelUpdates;
           end;
      end;
    Result := True;
  except
    on E: Exception do
      begin
        Result := False;
        Application.MessageBox(PChar('Esta opera��o provocou o seguinte erro: ' + #13#10 + E.Message), 'Erro', cError_Ok);
      end
  end;
end;

Function CDSUpdated(DataSet: TCustomClientDataSet; UpdateKind: TUpdateKind): boolean;
var
  i: integer;
begin
  Result := False;

  for i := 0 to DataSet.Fields.Count - 1 do
    if (DataSet.Fields[i].ProviderFlags <> []) and
      (DataSet.Fields[i].FieldKind = fkData) Then
      if (UpdateKind = ukInsert) or ((DataSet.Fields[i].Value <> Null) and
        (DataSet.Fields[i].OldValue <> DataSet.Fields[i].Value)) then
        begin
          Result := True;
          break;
       end;
end;

Procedure CDSTOStringList(DataSet: TClientDataSet; Var StringList: TStringList);
Var
  i: integer;
Begin
  If Not Assigned(StringList) Then
    StringList := TStringList.Create
  Else
    StringList.Clear;

  For i := 0 To DataSet.Fields.Count - 1 Do
    StringList.Add(DataSet.Fields[i].FieldName + '=' + DataSet.Fields[i].AsString);
End;

function NewKEY(sTableName, sKeyField, sCondition: String; SQLCnn: TSQLConnection): String; Overload;
var
  sSql: String;
  qryNewKey: TSQLQuery;
begin
  qryNewKey := TSQLQuery.Create(Nil);
  qryNewKey.SQLConnection := SQLCnn;

  Try
    sSql := 'SELECT MAX(' + sKeyField + ') AS ULTIMOCODIGO';
    sSql := sSql + ' FROM ' + (sTableName);
    If (sCondition <> '') Then
      sSql := sSql + ' WHERE ' + (sCondition);
    qryNewKey.Sql.Add(sSql);

    Try
      qryNewKey.Prepared := True;
      qryNewKey.Open;

      If qryNewKey.IsEmpty Then
        Result := ''
      Else
        If qryNewKey.FieldByName('ULTIMOCODIGO').asString = '' Then
          Result := '1'
        Else
          Result := FloatToStr(qryNewKey.FieldByName('ULTIMOCODIGO').AsFloat + 1);
    Except
      On E: Exception Do Begin
        Result := '';
        Raise Exception.Create(ErrorMsg(E));
      End;
    End;
  Finally
    FreeAndNil(qryNewKey);
  End;
End;

function SelecMax(sTableName, sKeyField : string; SQLCnn: TSQLConnection): String; Overload;
var
  sSql      : String;
  qryNewKey : TSQLQuery;
begin
  qryNewKey := TSQLQuery.Create(nil);
  qryNewKey.SQLConnection := SQLCnn;
  try
    sSql := 'SELECT MAX(' + sKeyField + ') AS ULTIMOCODIGO';
    sSql := sSql + ' FROM ' + (sTableName);
    qryNewKey.Sql.Add(sSql);
    try
      qryNewKey.Prepared := True;
      qryNewKey.Open;

      if qryNewKey.IsEmpty then
        Result := ''
      else
        if qryNewKey.FieldByName('ULTIMOCODIGO').asString = '' then
          Result := '1'
        else
          Result := FloatToStr(qryNewKey.FieldByName('ULTIMOCODIGO').AsFloat);
    except
      on E: Exception do
        begin
          Result := '';
      raise Exception.Create(ErrorMsg(E));
      end;
    end;
  finally
    FreeAndNil(qryNewKey);
  end;
end;     

function NewKEY_Cartao(sTableName, sKeyField : String; SQLCnn: TSQLConnection): String; Overload;
var
  sSql: String;
  qryNewKey: TSQLQuery;
  cartao : Int64;
Begin
  qryNewKey := TSQLQuery.Create(Nil);
  qryNewKey.SQLConnection := SQLCnn;

  Try
    sSql := 'select ' + sKeyField + ' as CARTAO';
    sSql := sSql + ' from ' + (sTableName);
    qryNewKey.Sql.Add(sSql);

    Try
      qryNewKey.Prepared := True;
      qryNewKey.Open;

      If qryNewKey.IsEmpty Then
        Result := ''
      Else
        If qryNewKey.FieldByName('CARTAO').AsString = '' Then
          Result := '1'
        Else
          cartao := StrToInt64(qryNewKey.FieldByName('CARTAO').AsString);
          Result := IntToStr(cartao)
    Except
      On E: Exception Do Begin
        Result := '';
        Raise Exception.Create(ErrorMsg(E));
      End;
    End;
  Finally
    FreeAndNil(qryNewKey);
  End;
End;


Function NewID(sTableName, sKeyField, sCondition: String; SQLCnn: TSQLConnection; iInc: integer = 1): String; Overload;
Var
  sTmp: String;
  i, iNewID: integer;
  stlTmp: TStringList;
  LocalTD: TTransactionDesc;
  qryTmp, qryNewID: TSQLQuery;
Const
  cIDTransaction: integer = 99;
Begin
  Inc(cIDTransaction);
  If cIDTransaction > 999 Then
    cIDTransaction := 100;

  LocalTD.GlobalID       := StrToInt(IntToStr(TD.GlobalID) + IntToStr(cIDTransaction));
  LocalTD.TransactionID  := StrToInt(IntToStr(TD.TransactionID) + IntToStr(cIDTransaction));
  LocalTD.IsolationLevel := xilREADCOMMITTED;

  qryTmp := TSQLQuery.Create(Nil);
  qryNewID := TSQLQuery.Create(Nil);

  If Not SQLCnn.MultipleTransactionsSupported Then Begin
    qryTmp.SQLConnection   := SQLCnn.CloneConnection;
    qryNewID.SQLConnection := SQLCnn.CloneConnection;
  End
  Else Begin
    qryTmp.SQLConnection   := SQLCnn;
    qryNewID.SQLConnection := SQLCnn;
  End;

  stlTmp := TStringList.Create;
  Try
    Try
      { Preparando Condi��o }

      sTmp := Trim(sCondition);
      While sTmp <> '' Do Begin
        If Pos(';', sTmp) > 0 Then Begin
          stlTmp.Add(Copy(sTmp, 1, Pos(';', sTmp) - 1));
          Delete(sTmp, 1, Pos(';', sTmp));
        End
        Else Begin
          stlTmp.Add(Copy(sTmp, 1, Length(sTmp)));
          sTmp := '';
        End;
      End;

      { Localizando sequ�ncia }

      qryTmp.SQL.Clear;
      qryTmp.SQL.Add('SELECT SEQUENCIA,');
      If stlTmp.Count > 0 Then
        qryTmp.SQL.Add('       VALOR' + StrZero(stlTmp.Count + 1, 2))
      Else
        qryTmp.SQL.Add('       VALOR01');
      qryTmp.SQL.Add('  FROM ID');
      qryTmp.SQL.Add(' WHERE TABELA = ' + SQLFormat(sTableName, 'C'));

      If stlTmp.Count > 0 Then Begin
        For i := 0 To stlTmp.Count - 1 Do Begin
          qryTmp.SQL.Add('AND CAMPO' + StrZero(i + 1, 2) + ' = ' + SQLFormat(Trim(stlTmp.Names[i]), 'C'));
          qryTmp.SQL.Add('AND VALOR' + StrZero(i + 1, 2) + ' = ' + SQLFormat(Trim(stlTmp.Values[stlTmp.Names[i]]), 'C'));
        End;
        qryTmp.SQL.Add('AND CAMPO' + StrZero(stlTmp.Count + 1, 2) + ' = ' + SQLFormat(sKeyField, 'C'));
      End
      Else
        qryTmp.SQL.Add('AND CAMPO01 = ' + SQLFormat(sKeyField, 'C'));

      qryTmp.Prepared := True;
      qryTmp.Open;

      If qryTmp.IsEmpty Then Begin

        { Criando sequ�ncia caso n�o exista }

        qryNewID.SQL.Clear;
        qryNewID.SQL.Add('INSERT INTO ID (');
        qryNewID.SQL.Add('            SEQUENCIA, ');
        qryNewID.SQL.Add('            TABELA, ');
        If stlTmp.Count > 0 Then Begin
          For i := 0 To stlTmp.Count - 1 Do Begin
            qryNewID.SQL.Add('CAMPO' + StrZero(i + 1, 2) + ', ');
            qryNewID.SQL.Add('VALOR' + StrZero(i + 1, 2) + ', ');
          End;
          qryNewID.SQL.Add('CAMPO' + StrZero(stlTmp.Count + 1, 2) + ', ');
          qryNewID.SQL.Add('VALOR' + StrZero(stlTmp.Count + 1, 2));
        End
        Else Begin
          qryNewID.SQL.Add('CAMPO01, ');
          qryNewID.SQL.Add('VALOR01');
        End;
        qryNewID.SQL.Add(') VALUES (');
        qryNewID.SQL.Add(NewKey('ID', 'SEQUENCIA', '', SQLCnn) + ', ');
        qryNewID.SQL.Add(SQLFormat(sTableName, 'C') + ', ');
        For i := 0 To stlTmp.Count - 1 Do Begin
          qryNewID.SQL.Add(SQLFormat(Trim(stlTmp.Names[i]), 'C') + ', ');
          qryNewID.SQL.Add(SQLFormat(Trim(stlTmp.Values[stlTmp.Names[i]]), 'C') + ', ');
        End;
        qryNewID.SQL.Add(SQLFormat(sKeyField, 'C') + ', ');
        qryNewID.SQL.Add(SQLFormat(IntToStr(iInc), 'C') + ')');

        iNewID := (iInc);
      End
      Else Begin

        { Atualizando sequ�ncia caso exista }

        qryNewID.SQL.Clear;
        qryNewID.SQL.Add('UPDATE ID SET');
        If stlTmp.Count > 0 Then
          qryNewID.SQL.Add('    VALOR' + StrZero(stlTmp.Count + 1, 2) + ' = CAST(VALOR' + StrZero(stlTmp.Count + 1, 2) + ' AS INTEGER) + ' + IntToStr(iInc))
        Else
          qryNewID.SQL.Add('    VALOR01 = ' + IntToStr(qryTmp.FieldByName('VALOR' + StrZero(stlTmp.Count + 1, 2)).AsInteger + (iInc)));
        qryNewID.SQL.Add(' WHERE SEQUENCIA = ' + qryTmp.FieldByName('Sequencia').AsString);
        If stlTmp.Count > 0 Then
          qryNewID.SQL.Add('   AND VALOR' + StrZero(stlTmp.Count + 1, 2) + ' = ' + SQLFormat(qryTmp.FieldByName('VALOR' + StrZero(stlTmp.Count + 1, 2)).AsString, 'C'))
        Else
          qryNewID.SQL.Add('   AND VALOR01 = ' + SQLFormat(qryTmp.FieldByName('VALOR01').AsString, 'C'));

        iNewID := qryTmp.FieldByName('VALOR' + StrZero(stlTmp.Count + 1, 2)).AsInteger + (iInc);
      End;

      { Efetivando a atualiza��o }

      qryTmp.SQLConnection.StartTransaction(LocalTD);
      qryNewID.ExecSQL;
      If qryNewID.RowsAffected <> 1 Then
        Raise Exception.Create('Falha gerando nova chave! Nenhum registro foi criado ou atualizado...');
      qryTmp.SQLConnection.Commit(LocalTD);

      { Retornando nova chave }

      Result := iif(iInc = 1, IntToStr(iNewID), IntToStr(iNewID - iInc + 1));
    Except
      On E: Exception Do Begin
        Result := '';
        If qryTmp.SQLConnection.InTransaction Then
          qryTmp.SQLConnection.Rollback(LocalTD);
        Raise Exception.Create(ErrorMsg(E));
      End;
    End;
  Finally
    FreeAndNil(stlTmp);
    FreeAndNil(qryTmp);
    FreeAndNil(qryNewID);
  End;
End;

Function NewGEN(sGenOBJ: String; SQLCnn: TSQLConnection; iInc: integer = 1): String;
Var
  qryGenOBJ: TSQLQuery;
Begin
  qryGenOBJ := TSQLQuery.Create(Nil);
  qryGenOBJ.SQLConnection := SQLCnn;
  Try
    If gAppConfig.gsDatabase = 'IB' Then Begin
      qryGenOBJ.SQL.Add('SELECT GEN_ID(' + sGenOBJ + ', ' + IntToStr(iInc) + ') AS ULTIMOCODIGO');
      qryGenOBJ.SQL.Add('  FROM RDB$DATABASE');
    End;

    If gAppConfig.gsDatabase = 'ORACLE' Then Begin
      qryGenOBJ.SQL.Add('SELECT ' + sGenOBJ + '.NEXTVAL AS ULTIMOCODIGO');
      qryGenOBJ.SQL.Add('  FROM DUAL');
    End;

    Try
      qryGenOBJ.Prepared := True;
      qryGenOBJ.Open;

      If (qryGenOBJ.IsEmpty) Or (qryGenOBJ.FieldByName('UltimoCodigo').AsString = '') Then
        Result := '1'
      Else
        Result := qryGenOBJ.FieldByName('UltimoCodigo').AsString;
    Except
      On E: Exception Do Begin
        Result := '';
        Raise Exception.Create(ErrorMsg(E));
      End;
    End;
  Finally
    FreeAndNil(qryGenOBJ);
  End;
End;

Procedure dbeKeyChange(dbeLkp: TDBEdit); Overload;
Begin
  If dbeLkp.DataSource.DataSet <> Nil Then
    If dbeLkp.DataSource.DataSet.State In [dsEdit, dsInsert] Then
      If Not VarIsNull((dbeLkp.DataSource.DataSet).FieldByName(dbeLkp.DataField).Value) Then { n�o est� nulo }
        If VarToStr((dbeLkp.DataSource.DataSet).FieldByName(dbeLkp.DataField).Value) <> '' Then { est� em branco }
          dbeLkp.DataSource.DataSet.FieldByName(dbeLkp.DataField).Clear;
End;

Procedure dbeKeyChange(dbeLkp: TEdit); Overload;
Begin
  If Trim(dbeLkp.Text) <> '' Then
    dbeLkp.Clear;
End;

Procedure dbeKeyChange(dbeLkp1, dbeLkp2: TDBEdit); Overload;
Begin
  If dbeLkp1.DataSource.DataSet <> Nil Then
    If dbeLkp1.DataSource.DataSet.State In [dsEdit, dsInsert] Then Begin
      If Not VarIsNull((dbeLkp1.DataSource.DataSet).FieldByName(dbeLkp1.DataField).Value) Then { n�o est� nulo }
        If VarToStr((dbeLkp1.DataSource.DataSet).FieldByName(dbeLkp1.DataField).Value) <> '' Then { est� em branco }
          dbeLkp1.DataSource.DataSet.FieldByName(dbeLkp1.DataField).AsString := '';
      If Not VarIsNull((dbeLkp2.DataSource.DataSet).FieldByName(dbeLkp2.DataField).Value) Then { n�o est� nulo }
        If VarToStr((dbeLkp2.DataSource.DataSet).FieldByName(dbeLkp2.DataField).Value) <> '' Then { est� em branco }
          dbeLkp2.DataSource.DataSet.FieldByName(dbeLkp2.DataField).AsString := '';
    End;
End;

Function DoLookup(sTableName, sLookupFields, sCondition: String; SQLCnn: TSQLConnection): Variant; Overload;
Var
  aResult: Array Of Variant;
  aFields: Array Of TVarRec;
  sTmp1, sTmp2: String;
  qryQuery: TSQLQuery;
  i: integer;
Begin
  i := 1;
  sTmp1 := '';
  sTmp2 := Trim(sLookupFields);

  qryQuery := TSQLQuery.Create(Nil);
  qryQuery.SQLConnection := SQLCnn;
  Try
    Try
      While True Do Begin
        If (Copy(sTmp2, i, 1) <> ';') And (i <= Length(sTmp2)) Then Begin
          sTmp1 := sTmp1 + Copy(sTmp2, i, 1);
          Inc(i);
        End
        Else
          If (Copy(sTmp2, i, 1) = ';') Or (i >= Length(sTmp2)) Then Begin
            SetLength(aFields, Length(aFields) + 1);
            String(aFields[Length(aFields) - 1].VAnsiString) := sTmp1;

            Delete(sTmp2, 1, i);
            i := 1;
            sTmp1 := '';
          End;
        If Trim(sTmp2) = '' Then
          break;
      End;

      qryQuery.Sql.Add('  SELECT ');

      For i := 0 To Length(aFields) - 1 Do
        If i < Length(aFields) - 1 Then
          qryQuery.Sql.Add(UpperCase(String(aFields[i].VAnsiString) + ', '))
        Else
          qryQuery.Sql.Add(UpperCase(String(aFields[i].VAnsiString)));

      qryQuery.Sql.Add('    FROM ' + UpperCase(sTableName));

      If sCondition <> '' Then
        qryQuery.Sql.Add('   WHERE ' + sCondition);

      qryQuery.Prepared := True;
      qryQuery.Open;

      If Length(aFields) > 1 Then Begin
        SetLength(aResult, Length(aFields));
        For i := 0 To Length(aResult) - 1 Do
          aResult[i] := qryQuery.FieldByName(iif(Pos('.', String(aFields[i].VAnsiString)) > 0,
            Copy(String(aFields[i].VAnsiString), Pos('.', String(aFields[i].VAnsiString)) + 1, Length(String(aFields[i].VAnsiString))),
            String(aFields[i].VAnsiString))).AsString;
        Result := aResult;
      End
      Else
        Result := qryQuery.FieldByName(iif(Pos('.', String(aFields[0].VAnsiString)) > 0,
          Copy(String(aFields[0].VAnsiString), Pos('.', String(aFields[0].VAnsiString)) + 1, Length(String(aFields[0].VAnsiString))),
          String(aFields[0].VAnsiString))).AsString;
    Except
      On E: Exception Do Begin
        Raise Exception.Create(ErrorMsg(E));
        Result := null;
        exit;
      End;
    End;
  Finally
    FreeAndNil(qryQuery);
  End;
End;

Procedure RefreshLookupTables(DataSet: TClientDataSet);
Var
  i: integer;
Begin
  DataSet.DisableControls;
  Screen.Cursor := crHourGlass;
  Try
    For i := 0 To DataSet.Fields.Count - 1 Do
      If DataSet.Fields[i].FieldKind = fkLookup Then
        If DataSet.Fields[i].LookupDataSet <> Nil Then
          If (TClientDataSet(DataSet.Fields[i].LookupDataSet).HasAppServer) Or
            (TClientDataSet(DataSet.Fields[i].LookupDataSet).ProviderName <> '') Then Begin
            CDSClose(TClientDataSet(DataSet.Fields[i].LookupDataSet));
            CDSOpen(TClientDataSet(DataSet.Fields[i].LookupDataSet));
          End;
  Finally
    DataSet.EnableControls;
    Screen.Cursor := crDefault;
  End;
End;

Procedure dbeKeyExit(dbeKey, dbeLkp: TDBEdit; sTableName, sLookupFields, sCondition: String; SQLCnn: TSQLConnection); Overload;
Var
  i: integer;
  sTmp: String;
Begin
  sTmp := '';

  If Trim(dbeLkp.Text) <> '' Then
    exit
  Else
    If dbeLkp.DataSource.DataSet <> Nil Then
      If dbeLkp.DataSource.DataSet.State In [dsEdit, dsInsert] Then
        If Trim(dbeKey.Text) <> '' Then Begin
          vLookupResult := DoLookup(sTableName, sLookupFields, sCondition, SQLCnn);
          If Not VariantIsEmpty(vLookupResult) Then Begin
            If Not VarIsArray(vLookupResult) Then
              dbeLkp.DataSource.DataSet.FieldByName(dbeLkp.DataField).AsString := VarToStr(vLookupResult)
            Else Begin
              For i := 0 To VarArrayHighBound(vLookupResult, 1) Do Begin
                If sTmp <> '' Then
                  sTmp := sTmp + ' - ';
                sTmp := sTmp + vLookupResult[i];
              End;
              dbeLkp.DataSource.DataSet.FieldByName(dbeLkp.DataField).AsString := (sTmp);
            End;
          End
          Else Begin
            dbeKey.DataSource.DataSet.FieldByName(dbeKey.DataField).AsString := '';
            dbeLkp.DataSource.DataSet.FieldByName(dbeLkp.DataField).AsString := '';
            dbeKey.SetFocus;
          End;
        End;
End;

Procedure dbeKeyExit(dbeKey, dbeLkp: TEdit; sTableName, sLookupFields, sCondition: String; SQLCnn: TSQLConnection); Overload;
Var
  i: integer;
  sTmp: String;
Begin
  sTmp := '';

  If Trim(dbeLkp.Text) <> '' Then
    exit
  Else
    If Trim(dbeKey.Text) <> '' Then Begin
      vLookupResult := DoLookup(sTableName, sLookupFields, sCondition, SQLCnn);
      If Not VariantIsEmpty(vLookupResult) Then Begin
        If Not VarIsArray(vLookupResult) Then
          dbeLkp.Text := VarToStr(vLookupResult)
        Else Begin
          For i := 0 To VarArrayHighBound(vLookupResult, 1) Do Begin
            If sTmp <> '' Then
              sTmp := sTmp + ' - ';
            sTmp := sTmp + vLookupResult[i];
          End;
          dbeLkp.Text := (sTmp);
        End;
      End
      Else Begin
        dbeKey.Text := '';
        dbeLkp.Text := '';
        dbeKey.SetFocus;
      End;
    End;
End;

Procedure dbeKeyExit(dbeKey, dbeLkp1, dbeLkp2: TDBEdit; sTableName, sLookupFields, sCondition: String; SQLCnn: TSQLConnection); Overload;
Begin
  If (Trim(dbeLkp1.Text) <> '') And (Trim(dbeLkp2.Text) <> '') Then
    exit
  Else
    If dbeLkp1.DataSource.DataSet <> Nil Then
      If dbeLkp1.DataSource.DataSet.State In [dsEdit, dsInsert] Then
        If Trim(dbeKey.Text) <> '' Then Begin
          vLookupResult := DoLookup(sTableName, sLookupFields, sCondition, SQLCnn);
          If Trim(VarToStr(vLookupResult[0])) <> '' Then Begin
            dbeLkp1.DataSource.DataSet.FieldByName(dbeLkp1.DataField).AsString := VarToStr(vLookupResult[0]);
            dbeLkp2.DataSource.DataSet.FieldByName(dbeLkp2.DataField).AsString := VarToStr(vLookupResult[1]);
          End
          Else Begin
            dbeKey.DataSource.DataSet.FieldByName(dbeKey.DataField).AsString := '';
            dbeLkp1.DataSource.DataSet.FieldByName(dbeLkp1.DataField).AsString := '';
            dbeLkp2.DataSource.DataSet.FieldByName(dbeLkp2.DataField).AsString := '';
            dbeKey.SetFocus;
          End;
        End;
End;

Function ExecDynSQL(iRecords: Integer; sCommandText: WideString;
  Var cdsGeral: TClientDataSet; SQLCnn: TSQLConnection): integer; Overload;
Var
  sqlResult: TSQLQuery;
  dspResult: TDataSetProvider;
  cdsResult: TClientDataSet;
Begin
  {
  * Par�metros:
    iRecords = n� de registro a retornar
    sCommandText = instru��o SQL a ser executada
    cdsGeral = ClientDataSet para receber o DataPacket

  * Retorno:
    -1   = erro na execu��o
    0    = consulta n�o retornou registros
    1..n = n�mero de registros retornados pela consulta
  }

  Result := -1;
  Screen.Cursor := crHourGlass;
  Try
    sqlResult := TSQLQuery.Create(Nil);
    dspResult := TDataSetProvider.Create(Nil);
    cdsResult := TClientDataSet.Create(Nil);
    Try
      { Executando SQL }
      dspResult.DataSet := sqlResult;
      cdsResult.SetProvider(dspResult);

      sqlResult.SQLConnection := SQLCnn;
      sqlResult.SQL.Text := sCommandText;

      cdsResult.PacketRecords := (iRecords);
      cdsResult.Open;

      { Testando se cdsGeral est� criado }
      If Not Assigned(cdsGeral) Then
        cdsGeral := TClientDataSet.Create(Nil);

      { Testando se cdsGeral est� ativo }
      If cdsGeral.Active Then
        CDSClose(cdsGeral);

      { Atribuindo e ativando }
      Result := cdsResult.RecordCount;
      cdsGeral.Data := cdsResult.Data;
    Except
      On E: Exception Do
        ShowMessage(E.Message);
    End;
  Finally
    Screen.Cursor := crDefault;
  End;
End;

Procedure GridIndex(Column: TColumn);
Var
  strName: String;
  intIndex: integer;
  IndexDef: TIndexDef;
  blnDescending: boolean;
Begin
  If Column.Field.FieldKind <> fkLookup Then Begin
    blnDescending := False;
    strName := 'TEMP' + Column.Field.FieldName;
    intIndex := TClientDataSet(Column.Field.DataSet).IndexDefs.IndexOf(strName);

    If TClientDataSet(Column.Field.DataSet).IndexName = strName Then Begin
      IndexDef := TClientDataSet(Column.Field.DataSet).IndexDefs.Find(strName);
      blnDescending := IndexDef.DescFields = '';
    End;

    If intIndex >= 0 Then Begin
      TClientDataSet(Column.Field.DataSet).DeleteIndex(strName);
      TClientDataSet(Column.Field.DataSet).IndexDefs.Delete(intIndex);
    End;

    IndexDef := TClientDataSet(Column.Field.DataSet).IndexDefs.AddIndexDef;
    IndexDef.Name := strName;
    IndexDef.Fields := Column.Field.FieldName;

    If blnDescending Then
      IndexDef.DescFields := Column.Field.FieldName;

    TClientDataSet(Column.Field.DataSet).IndexName := strName;
  End;
End;

Function PesqGetSQL(DataSet: TClientDataSet): String;
var
  dsp : TDataSetProvider;
  i   : integer;
begin
  Result := '';
  { Caso tenha um provider }

  for i := 0 to Length(gAppSQL) - 1 do
    begin
      ShowMessage('gsDSPName: ' + gAppSQL[i].gsDSPName);
      ShowMessage('gsSQLText: ' + gAppSQL[i].gsSQLText);
    end;

  if DataSet.ProviderName <> '' then
    begin
      { Caso j� tenha sido capturado nesta inst�ncia }
      for i := 0 to Length(gAppSQL) - 1 do
        if gAppSQL[i].gsDSPName = DataSet.ProviderName then
          begin
            Result := gAppSQL[i].gsSQLText;
            break;
          end;

      ShowMessage('Result: ' + Result);
      { Caso primeira captura para a inst�ncia }
      if Result = '' then
        begin
          { Localizando no formul�rio corrente }
          dsp := TDataSetProvider(Screen.ActiveForm.FindComponent(DataSet.ProviderName));
          { Caso n�o encontrado, localizando nos data modules }
          if dsp = nil then
            for i := 0 to Screen.DataModuleCount - 1 do
              begin
                dsp := TDataSetProvider(Screen.DataModules[i].FindComponent(DataSet.ProviderName));
                if dsp <> nil then
                  break;
              end;
          { Capturando SQL }
          if dsp <> nil then
            begin
              if HasProperty(dsp.DataSet, 'SQL') <> nil then
                begin
                  Result := TStringList(GetObjectProp(dsp.DataSet, 'SQL')).Text;
                  { Armazenando original }
                  SetLength(gAppSQL, Length(gAppSQL) + 1);
                  gAppSQL[Length(gAppSQL) - 1].gsDSPName := dsp.Name;
                  gAppSQL[Length(gAppSQL) - 1].gsSQLText := Result;
                end;
              if HasProperty(dsp.DataSet, 'CommandText') <> nil then
                begin
                  Result := GetPropValue(dsp.DataSet, 'CommandText', True);
                  { Armazenando original }
                  SetLength(gAppSQL, Length(gAppSQL) + 1);
                  gAppSQL[Length(gAppSQL) - 1].gsDSPName := dsp.Name;
                  gAppSQL[Length(gAppSQL) - 1].gsSQLText := Result;
                end;
            end;
        end;
    end;
end;

Function PesqExecute(DataSet: TClientDataSet; sChave: string; sTexto : String): String;
var
  sSQL: String;
begin
  Screen.Cursor := crHourGlass;
  try
    { Recuperando SQL }
    sSQL := PesqGetSQL(DataSet);

    { Removendo anula��o padr�o }
    sSQL := StringReplace(sSQL, '(1 = 2)', '', [rfReplaceAll, rfIgnoreCase]);

    { Adicionando WHERE caso n�o exista }
    if Pos(' where', sSQL) = 0 then
      sSQL := sSQL + ' where';
    { Adicionando chave de pesquisa }
    sSQL := sSQL + ' ' + sChave + ' ' + ' ' + 'like ''' + sTexto + '%''' + ' order by ' + sChave;
    { Ativando DataSet }
    CDSClose(DataSet);
    DataSet.CommandText := sSQL;
    CDSOpen(DataSet);
  finally
    Screen.Cursor := crDefault;
  end;
end;

Function VariantIsEmpty(v: variant): boolean;
Begin
  If VarIsArray(v) Then
    Result := Trim(VarToStr(v[0])) = ''
  Else
    Result := Trim(VarToStr(v)) = '';
End;

Function MakeStr(Const Arg: TVarRec): String;
Const
  BoolChars: Array[Boolean] Of Char = ('F', 'T');
Begin
  Result := '';
  Case Arg.VType Of
    vtInteger: Result := Result + IntToStr(Arg.VInteger);
    vtBoolean: Result := Result + BoolChars[Arg.VBoolean];
    vtChar: Result := Result + Arg.VChar;
    vtExtended: Result := Result + FloatToStr(Arg.VExtended^);
    vtString: Result := Result + Arg.VString^;
    vtPChar: Result := Result + Arg.VPChar;
    vtObject: Result := Result + Arg.VObject.ClassName;
    vtClass: Result := Result + Arg.VClass.ClassName;
    vtAnsiString: Result := Result + String(Arg.VAnsiString);
    vtCurrency: Result := Result + CurrToStr(Arg.VCurrency^);
    vtVariant: Result := Result + String(Arg.VVariant^);
    vtInt64: Result := Result + IntToStr(Arg.VInt64^);
  End;
End;

Function GetValue(Field: TField): String;
Begin
  If Field.Value = null Then
    Result := VarToStr(Field.OldValue)
  Else
    Result := VarToStr(Field.Value);
End;

Function IsValidChar(sDado: String): boolean;
Const
  Valido = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
Var
  i: integer;
Begin
  Result := False;

  If Trim(sDado) = '' Then
    exit;

  For i := 1 To Length(sDado) Do
    If Pos(Copy(sDado, i, 1), Valido) = 0 Then
      exit;

  Result := True;
End;

Function IsValidNumber(sDado: String): boolean;
Const
  Valido = '0123456789,.+-';
Var
  i: integer;
Begin
  Result := False;

  If Trim(sDado) = '' Then
    exit;

  For i := 1 To Length(sDado) Do
    If Pos(Copy(sDado, i, 1), Valido) = 0 Then
      exit;

  Result := True;
End;

Function IsValidDigit(sDado: String): boolean;
Const
  Valido = '0123456789';
Var
  i: integer;
Begin
  Result := False;

  If Trim(sDado) = '' Then
    exit;

  For i := 1 To Length(sDado) Do
    If Pos(Copy(sDado, i, 1), Valido) = 0 Then
      exit;

  Result := True;
End;

Function ExtractChar(sDado: String): String;
Const
  Valido = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
Var
  i: integer;
Begin
  Result := '';
  For i := 1 To Length(sDado) Do
    If Pos(Copy(sDado, i, 1), Valido) > 0 Then
      Result := Result + Copy(sDado, i, 1);
End;

Function ExtractNumber(sDado: String): String;
Const
  Valido = '0123456789,.+-';
Var
  i: integer;
Begin
  Result := '';
  For i := 1 To Length(sDado) Do
    If Pos(Copy(sDado, i, 1), Valido) > 0 Then
      Result := Result + Copy(sDado, i, 1);
End;

Function FormataCGCCPF(sDado, sTipoPessoa: String): String;

Function ZeroE(s: String; d: integer): String;
  Var
    st: String;
  Begin
    st := trim(s);
    While Length(st) < d Do
      st := '0' + st;
    ZeroE := st;
  End;
Begin
  If sTipoPessoa = 'F' Then Begin
    sDado := ZeroE(sDado, 11);
    Insert('.', sDado, 4);
    Insert('.', sDado, 8);
    Insert('-', sDado, 12);
  End
  Else Begin
    sDado := ZeroE(sDado, 14);
    Insert('.', sDado, 3);
    Insert('.', sDado, 7);
    Insert('/', sDado, 11);
    Insert('-', sDado, 16);
  End;
  Result := sDado;
End;

Function VerificaCGCCPF(sDado, sTipoPessoa: String): boolean;
Var
  i: integer;
  sTmp: String;
  D1: Array[1..12] Of byte;
  DF1, DF2, DF3, DF4, DF5, DF6: integer;
  iResto1, iResto2, iPrimeiroDigito, iSegundoDigito: integer;
Const
  cJuridica = 'J';
  cFisica = 'F';
Begin
  Result := True;

  If sTipoPessoa = cJuridica Then Begin
    sTmp := '';
    For i := 1 To Length(sDado) Do
      If IsValidNumber(sDado[i]) Then
        sTmp := sTmp + sDado[i];
    sDado := sDado;

    If sDado = '' Then
      exit;

    If (Length(sDado) > 0) And (Length(sDado) <> 14) Then Begin
      Result := False;
      exit;
    End;

    For i := 1 To 12 Do
      If sDado[i] In ['0'..'9'] Then
        D1[i] := StrToInt(sDado[i]);

    DF1 := 5 * D1[1] + 4 * D1[2] + 3 * D1[3] + 2 * D1[4] + 9 * D1[5] + 8 * D1[6] +
      7 * D1[7] + 6 * D1[8] + 5 * D1[9] + 4 * D1[10] + 3 * D1[11] + 2 * D1[12];
    DF2 := DF1 Div 11;
    DF3 := DF2 * 11;

    iResto1 := DF1 - DF3;

    If (iResto1 = 0) Or (iResto1 = 1) Then
      iPrimeiroDigito := 0
    Else
      iPrimeiroDigito := 11 - iResto1;

    DF4 := 6 * D1[1] + 5 * D1[2] + 4 * D1[3] + 3 * D1[4] + 2 * D1[5] + 9 * D1[6] +
      8 * D1[7] + 7 * D1[8] + 6 * D1[9] + 5 * D1[10] + 4 * D1[11] + 3 * D1[12] +
      2 * iPrimeiroDigito;
    DF5 := DF4 Div 11;
    DF6 := DF5 * 11;

    iResto2 := DF4 - DF6;

    If (iResto2 = 0) Or (iResto2 = 1) Then
      iSegundoDigito := 0
    Else
      iSegundoDigito := 11 - iResto2;

    If (iPrimeiroDigito <> StrToInt(sDado[13])) Or (iSegundoDigito <> StrToInt(sDado[14])) Then
      Result := False;
  End;

  If sTipoPessoa = cFisica Then Begin
    sTmp := '';

    For i := 1 To Length(sDado) Do
      If IsValidNumber(sDado[i]) Then sTmp := sTmp + sDado[i];
    sDado := sTmp;

    If sDado = '' Then
      exit;

    If (Length(sDado) > 0) And (Length(sDado) <> 11) Then Begin
      Result := False;
      exit;
    End;

    For i := 1 To 9 Do
      If sDado[i] In ['0'..'9'] Then
        D1[i] := StrToInt(sDado[i]);

    DF1 := 10 * D1[1] + 9 * D1[2] + 8 * D1[3] + 7 * D1[4] + 6 * D1[5] + 5 * D1[6] +
      4 * D1[7] + 3 * D1[8] + 2 * D1[9];
    DF2 := DF1 Div 11;
    DF3 := DF2 * 11;

    iResto1 := DF1 - DF3;

    If (iResto1 = 0) Or (iResto1 = 1) Then
      iPrimeiroDigito := 0
    Else
      iPrimeiroDigito := 11 - iResto1;

    DF4 := 11 * D1[1] + 10 * D1[2] + 9 * D1[3] + 8 * D1[4] + 7 * D1[5] + 6 * D1[6] +
      5 * D1[7] + 4 * D1[8] + 3 * D1[9] +
      2 * iPrimeiroDigito;
    DF5 := DF4 Div 11;
    DF6 := DF5 * 11;

    iResto2 := DF4 - DF6;

    If (iResto2 = 0) Or (iResto2 = 1) Then
      iSegundoDigito := 0
    Else
      iSegundoDigito := 11 - iResto2;

    If (iPrimeiroDigito <> StrToInt(sDado[10])) Or (iSegundoDigito <> StrToInt(sDado[11])) Then
      Result := false;
  End;
End;

Function FormataIE(sDado, sTipoPessoa: String): String;

Function ZeroE(s: String; d: integer): String;
  Var
    st: String;
  Begin
    st := trim(s);
    While Length(st) < d Do
      st := '0' + st;
    ZeroE := st;
  End;
Begin
  If sTipoPessoa = 'J' Then Begin
    sDado := ZeroE(sDado, 12);
    Insert('.', sDado, 4);
    Insert('.', sDado, 8);
    Insert('.', sDado, 12);
  End;
  Result := sDado;
End;

Function DiaSemana(Data: TDateTime): String;
Const
  Dias: Array[1..7] Of String[07] = ('DOMINGO', 'SEGUNDA', 'TERCA', 'QUARTA', 'QUINTA', 'SEXTA', 'SABADO');
Begin
  Result := Dias[DayOfWeek(Data)];
End;

Function InArray(sItem: String; aArray: Array Of String): boolean;
Var
  i: integer;
Begin
  Result := False;
  For i := 0 To Length(aArray) - 1 Do
    If AnsiSameText(aArray[i], sItem) Then Begin
      Result := True;
      break;
    End;
End;

Function FormataCEP(sDado: String): String;
Begin
  If (Trim(sDado) <> '') Then Begin
    sDado := StrZero(StrToInt(sDado), 8);
    Insert('-', sDado, 6);
  End;
  Result := sDado;
End;

function IsNumeric(S : String) : Boolean;
var
  i: integer;
begin
  Result := TryStrToInt(s, i);
end;

procedure Valida_Mascara_Producao_Especial(campo: TMaskEdit);
var
  vUnderline : Integer;
  vNumero    : Integer;
  I          : Integer;
begin
  vUnderline := 0;
  vNumero    := 0;

  for I := 1 to Length(campo.Text) do
  begin
   if  campo.Text[I] = ' ' then
   begin
     vUnderline := vUnderline + 1;
   end
   else
   if IsNumeric(campo.Text[I])  then
   begin
     vNumero := vNumero + 1;
   end;
  end;

  if ((vNumero > 0) AND (vUnderline <> 0)) then
  begin
    ShowMessage('Entrada incorreta.');
    campo.SetFocus;
  end;

end;

Procedure Desconecta_Conecta_SqlConnection;
begin
  try
    DmPrincipal.FDConnection1.Connected := False;
    DmPrincipal.FDConnection1.Connected := True;
  except
    on E: Exception do
    begin
      ShowMessage('ATEN��O... ERRO DE REDE, REINICIE O SISTEMA.');
      //
      Exit;
    end;
  end;
end;

function CopiaArquivo(Origem: String; Destino: String): Boolean;
const
  TamanhoBuffer = 5000000;
var
  ArqOrigem, ArqDestino: TFileStream;
  pBuf: Pointer;
  cnt: Integer;
  totCnt, TamanhoOrigem: Int64;
begin
  Result := True;
  totCnt := 0;
  //
  try
    ArqOrigem := TFileStream.Create(Origem, fmOpenRead and fmShareExclusive);
  except
    on E: Exception do
      begin
        Result := False;
        Exit;
      end;
  end;
  //
  TamanhoOrigem := ArqOrigem.size;
  //
  try
    try
      ArqDestino := TFileStream.Create(Destino, fmCreate or fmShareExclusive);
    except
      on E: Exception do
        begin
          Result := False;
          Exit;
        end;
    end;
    //
    try
      GetMem(pBuf, TamanhoOrigem);
        try
          cnt    := ArqOrigem.Read(pBuf^, TamanhoOrigem);
          cnt    := ArqDestino.Write(pBuf^, cnt);
          totCnt := totCnt + cnt;
          //
          Application.ProcessMessages;
          //
          while (cnt > 0) do
          begin
            cnt := ArqOrigem.Read(pBuf^, TamanhoOrigem);
            cnt := ArqDestino.Write(pBuf^, cnt);
            totcnt := totcnt + cnt;
            //
            Application.ProcessMessages;
          end;
        finally
          FreeMem(pBuf, TamanhoOrigem);
        end;
    finally
      ArqDestino.Free;
    end;
  finally
    ArqOrigem.Free;
  end;
end;

End.
