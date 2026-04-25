unit classe_lancamento;
{***************************************************************************}
{                                                                           }
{   Autor:        Daniel de Morais                                          }
{   Projeto:      Fluxo de Caixa                                            }
{                                                                           }
{   Informações:  Código Fonte da Playlist do YouTube sobre aprendizagem    }
{                 de como criar um Fluxo de Caixa.                          }
{                                                                           }
{   Aviso Legal:  Este código é fornecido exclusivamente para fins de       }
{                 estudo e aprendizagem. Não há qualquer garantia,          }
{                 explícita ou implícita, de funcionamento, adequação       }
{                 ou ausência de erros.                                     }
{                                                                           }
{                 O autor não se responsabiliza por danos diretos,          }
{                 indiretos, incidentais ou consequenciais decorrentes      }
{                 do uso deste código em ambientes de produção.             }
{                                                                           }
{                 Ao utilizar este código, você concorda que qualquer       }
{                 modificação, adaptação ou uso será de sua inteira         }
{                 responsabilidade.                                         }
{                                                                           }
{***************************************************************************}


{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Controls, ExtCtrls, utabela, ZDataset;

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
  cSQL:= 'insert into lancamentos ' +
         '(conta, id_lcto, data_mvto, plano, descricao, valor, idbanco) ' +
         'values ' +
         '(:conta, :id_lcto, :data_mvto, :plano, :descricao, :valor, :idbanco)';
  qrINC := TZQuery.Create(nil);
  try
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
      TabGlobal.conexao.StartTransaction;
      qrINC.ExecSQL;
      TabGlobal.conexao.Commit;
      Result := true;
    except
      on e: Exception do
      begin
        TabGlobal.conexao.Rollback;
        raise Exception.Create('Erro ao incluir o lançamento' + sLineBreak +
          'Conta ' + IntToStr(conta) + ' Lcto ' + IntToStr(id_lcto) + sLineBreak +
          e.ClassName + sLineBreak + e.Message);
      end;
    end;
  finally
    FreeAndNil(qrINC);
  end;
end;

function Tlancamento.autoinc(nCONTA: integer): integer;
var
  qrAI : TZQuery;
  cSQL : string;
begin
  cSQL:='select coalesce(max(id_lcto),0)+1 idlcto '+
        'from lancamentos where conta = :nCOD';
  qrAI := TZQuery.Create(nil);
  try
    qrAI.Connection := TabGlobal.conexao;
    qrAI.sql.Text:=cSQL;
    qrAI.ParamByName('nCOD').AsInteger:=nCONTA;
    qrAI.Open;
    result := qrAI.FieldByName('idlcto').AsInteger;
  finally
    FreeAndNil(qrAI);
  end;
end;

function Tlancamento.SaldoAnterior(nCONTA: integer; dINICIO: TDate): real;
var
  qrSaldoAnterior : TZQuery;
  cSQL : string;
begin
  cSQL:= 'select coalesce(sum(l.valor),0) saldo_anterior '+
         'from lancamentos l '+
         'where l.conta = :nCOD '+
         'and l.data_mvto < :dINICIO';
  qrSaldoAnterior := TZQuery.Create(nil);
  try
    qrSaldoAnterior.Connection := TabGlobal.conexao;
    qrSaldoAnterior.sql.Text:=cSQL;
    qrSaldoAnterior.ParamByName('nCOD').AsInteger:=nCONTA;
    qrSaldoAnterior.ParamByName('dINICIO').AsDate:=dINICIO;
    qrSaldoAnterior.Open;
    result := qrSaldoAnterior.FieldByName('saldo_anterior').AsFloat;
  finally
    FreeAndNil(qrSaldoAnterior);
  end;
end;

function Tlancamento.SaldoFuturo(nCONTA: integer; dINICIO: TDate): real;
var
  qrSaldoFuturo : TZQuery;
  cSQL : string;
begin
  cSQL:= 'select coalesce(sum(l.valor),0) saldo_futuro '+
         'from lancamentos l '+
         'where l.conta = :nCOD '+
         'and l.data_mvto > :dINICIO';
  qrSaldoFuturo := TZQuery.Create(nil);
  try
    qrSaldoFuturo.Connection := TabGlobal.conexao;
    qrSaldoFuturo.sql.Text:=cSQL;
    qrSaldoFuturo.ParamByName('nCOD').AsInteger:=nCONTA;
    qrSaldoFuturo.ParamByName('dINICIO').AsDate:=dINICIO;
    qrSaldoFuturo.Open;
    result := qrSaldoFuturo.FieldByName('saldo_futuro').AsFloat;
  finally
    FreeAndNil(qrSaldoFuturo);
  end;
end;


function Tlancamento.SaldoPeriodo(nCONTA: integer; dINICIO, dFINAL: TDate
  ): real;
var
  qrSaldoAnterior : TZQuery;
  cSQL : string;
begin
  cSQL:= 'select coalesce(sum(l.valor),0) saldo_periodo '+
         'from lancamentos l '+
         'where l.conta = :nCOD '+
         'and l.data_mvto between :dInicio and :dFinal';
  qrSaldoAnterior := TZQuery.Create(nil);
  try
    qrSaldoAnterior.Connection := TabGlobal.conexao;
    qrSaldoAnterior.sql.Text:=cSQL;
    qrSaldoAnterior.ParamByName('nCOD').AsInteger:=nCONTA;
    qrSaldoAnterior.ParamByName('dInicio').AsDate:=dINICIO;
    qrSaldoAnterior.ParamByName('dFinal').AsDate:=dFINAL;
    qrSaldoAnterior.Open;
    result := qrSaldoAnterior.FieldByName('saldo_periodo').AsFloat;
  finally
    FreeAndNil(qrSaldoAnterior);
  end;
end;


end.
