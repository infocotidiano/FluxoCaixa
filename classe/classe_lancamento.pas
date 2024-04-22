unit classe_lancamento;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Controls, ExtCtrls, Dialogs, utabela, ZDataset;

  type

    { Tlancamento }

    Tlancamento = class
      private
        Tcod_plano: integer;
        Tconta: integer;
        Tdata_mvto: TDate;
        Tdescricao: string;
        Tidbanco: string;
        Tid_lcto: integer;
        Tvalor: Double;
      published
        property conta     : integer read Tconta     write Tconta;
        property id_lcto   : integer read Tid_lcto   write Tid_lcto;
        property data_mvto : TDate   read Tdata_mvto write Tdata_mvto;
        property cod_plano : integer read Tcod_plano write Tcod_plano;
        property descricao : string  read Tdescricao write Tdescricao;
        property valor     : Double  read Tvalor     write Tvalor;
        property idbanco   : string  read Tidbanco   write Tidbanco;
      public
        function inclui:Boolean;
        function autoinc(nCONTA:integer):integer;
        function SaldoAnterior(nCONTA:integer; dINICIO:TDate):real;
        function SaldoPeriodo(nCONTA:integer; dINICIO, dFINAL :TDate):real;
        function SaldoFuturo(nCONTA: integer; dINICIO: TDate): real;
    end;

implementation

{ Tlancamento }

function Tlancamento.inclui: Boolean;
var
  qrINC : TZQuery;
  cSQL : string;
begin
  cSQL:= 'INSERT INTO lancamentos ' +
         '(conta, id_lcto, data_mvto, plano, descricao, valor, idbanco) ' +
         'VALUES ' +
         '(:conta, :id_lcto, :data_mvto, :plano, :descricao, :valor, :idbanco)';
  qrINC := TZQuery.Create(nil);
  qrINC.Connection := TabGlobal.conexao;
  self.id_lcto := autoinc(conta);
  qrINC.sql.Text:=cSQL;
  qrINC.ParamByName('conta').AsInteger     :=conta;
  qrINC.ParamByName('id_lcto').AsInteger   :=id_lcto;
  qrINC.ParamByName('data_mvto').AsDate    :=data_mvto;
  qrINC.ParamByName('plano').AsInteger     :=cod_plano;
  qrINC.ParamByName('descricao').AsString  :=copy(descricao,0,79);
  qrINC.ParamByName('valor').AsFloat       :=valor;
  qrINC.ParamByName('idbanco').AsString    :=idbanco;
  try
    qrINC.ExecSQL;
    Result := true;
  Except
    on e: exception do
       begin
         result := false;
         ShowMessage('Erro ao incluir o lancaçamento'+sLineBreak+
         'Conta '+IntToStr(conta)+' Lcto '+inttostr(id_lcto)+sLineBreak+
         e.ClassName+sLineBreak+e.Message);
       end;
  end;

  if Assigned(qrINC) then
     FreeAndNil(qrINC);

end;

function Tlancamento.autoinc(nCONTA: integer): integer;
var
  qrAI : TZQuery;
  cSQL : string;
begin
  cSQL:='select coalesce(max(id_lcto),0)+1 IdLcto '+
        'from lancamentos where conta = :nCOD';
  qrAI := TZQuery.Create(nil);
  qrAI.Connection := TabGlobal.conexao;
  qrAI.sql.Text:=cSQL;
  qrAI.ParamByName('nCOD').AsInteger:=nCONTA;
  qrAI.Open;
  result := qrAI.FieldByName('IdLcto').AsInteger;
  qrAI.Close;
  if Assigned(qrAI) then
     FreeAndNil(qrAI);
end;

function Tlancamento.SaldoAnterior(nCONTA: integer; dINICIO: TDate): real;
var
  qrSaldoAnterior : TZQuery;
  cSQL : string;
begin
  cSQL:= 'select coalesce(sum(l.valor),0) Saldo_Anterior '+
         'from lancamentos l '+
         'where l.conta = :nCOD '+
         'and l.data_mvto < :dINICIO';
  qrSaldoAnterior := TZQuery.Create(nil);
  qrSaldoAnterior.Connection := TabGlobal.conexao;
  qrSaldoAnterior.sql.Text:=cSQL;
  qrSaldoAnterior.ParamByName('nCOD').AsInteger:=nCONTA;
  qrSaldoAnterior.ParamByName('dINICIO').AsDate:=dINICIO;
  qrSaldoAnterior.Open;
  result := qrSaldoAnterior.FieldByName('Saldo_Anterior').AsFloat;
  qrSaldoAnterior.Close;
  if Assigned(qrSaldoAnterior) then
     FreeAndNil(qrSaldoAnterior);
end;

function Tlancamento.SaldoFuturo(nCONTA: integer; dINICIO: TDate): real;
var
  qrSaldoFuturo : TZQuery;
  cSQL : string;
begin
  cSQL:= 'select coalesce(sum(l.valor),0) Saldo_Futuro '+
         'from lancamentos l '+
         'where l.conta = :nCOD '+
         'and l.data_mvto > :dINICIO';
  qrSaldoFuturo := TZQuery.Create(nil);
  qrSaldoFuturo.Connection := TabGlobal.conexao;
  qrSaldoFuturo.sql.Text:=cSQL;
  qrSaldoFuturo.ParamByName('nCOD').AsInteger:=nCONTA;
  qrSaldoFuturo.ParamByName('dINICIO').AsDate:=dINICIO;
  qrSaldoFuturo.Open;
  result := qrSaldoFuturo.FieldByName('Saldo_Futuro').AsFloat;
  qrSaldoFuturo.Close;
  if Assigned(qrSaldoFuturo) then
     FreeAndNil(qrSaldoFuturo);
end;


function Tlancamento.SaldoPeriodo(nCONTA: integer; dINICIO, dFINAL: TDate
  ): real;
var
  qrSaldoAnterior : TZQuery;
  cSQL : string;
begin
  cSQL:= 'select coalesce(sum(l.valor),0) SaldoPeriodo '+
         'from lancamentos l '+
         'where l.conta = :nCOD '+
         'and l.data_mvto between :dInicio and :dFinal';
  qrSaldoAnterior := TZQuery.Create(nil);
  qrSaldoAnterior.Connection := TabGlobal.conexao;
  qrSaldoAnterior.sql.Text:=cSQL;
  qrSaldoAnterior.ParamByName('nCOD').AsInteger:=nCONTA;
  qrSaldoAnterior.ParamByName('dInicio').AsDate:=dINICIO;
  qrSaldoAnterior.ParamByName('dFinal').AsDate:=dFINAL;
  qrSaldoAnterior.Open;
  result := qrSaldoAnterior.FieldByName('SaldoPeriodo').AsFloat;
  qrSaldoAnterior.Close;
  if Assigned(qrSaldoAnterior) then
     FreeAndNil(qrSaldoAnterior);
end;


end.

