unit classe_contareceber;
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
  Classes, SysUtils, classe_registrofinanceiro,
  Controls, ExtCtrls, utabela ,ZDataset;
type

  { TContaReceber }

  TContaReceber = class(TRegistroFinanceiro)
  private
    function retornaAI:integer;
  public
    procedure incluir; override;
    function localiza(codigo:Integer):Boolean; override;
    procedure altera(codigo:integer); override;
    procedure exclui(codigo:integer); override;
  end;

implementation

{ TContaReceber }

function TContaReceber.retornaAI: integer;
var
  qrAI : TZQuery;
begin
  qrAI := TZQuery.Create(nil);
  try
    qrAI.Connection := TabGlobal.conexao;
    qrAI.sql.Add('select coalesce(max(id_receber),0)+1 codigo ');
    qrAI.sql.Add('from receber');
    qrAI.Open;
    result := qrAI.FieldByName('codigo').Value;
  finally
    FreeAndNil(qrAI);
  end;
end;

procedure TContaReceber.incluir;
var
  qrINC : TZQuery;
  cSQL : string;
begin
  cSQL:= 'insert into receber'+
          '  (id_receber, descricao, dtlancamento, valor, ' +
              'dtvencimento, valorrecebido, situacao, plano, dtrecebimento, codconta, entidade) '+
          'values '+
          '  (:id_registro, :descricao, :dtlancamento, :valor, '+
             ':dtvencimento, :valorpago, :situacao, :plano, :dtpagamento, :codconta, :entidade)';
  qrINC := TZQuery.Create(nil);
  try
    qrINC.Connection := TabGlobal.conexao;
    qrINC.sql.Text:=cSQL;
    qrINC.ParamByName('id_registro').AsInteger := retornaAI;
    qrINC.ParamByName('descricao').AsString    := Descricao;
    qrINC.ParamByName('dtlancamento').AsDate   := DtLancamento;
    qrINC.ParamByName('valor').AsFloat         := valor;
    qrINC.ParamByName('dtvencimento').AsDate   := DtVencimento;
    qrINC.ParamByName('valorpago').AsFloat     := ValorPago;
    qrINC.ParamByName('situacao').AsString     := Situacao;
    qrINC.ParamByName('plano').AsInteger       := Plano;
    qrINC.ParamByName('dtpagamento').AsDate    := DtPagamento;
    qrINC.ParamByName('codconta').AsInteger    := CodConta;
    qrINC.ParamByName('entidade').AsInteger    := Entidade;
    try
      TabGlobal.conexao.StartTransaction;
      qrINC.ExecSQL;
      TabGlobal.conexao.Commit;
    except
      on e: Exception do
      begin
        TabGlobal.conexao.Rollback;
        raise Exception.Create('Erro ao incluir a conta receber' + sLineBreak +
          e.ClassName + sLineBreak + e.Message);
      end;
    end;
  finally
    FreeAndNil(qrINC);
  end;
end;

function TContaReceber.localiza(codigo: Integer): Boolean;
var
  qrPESQUISA : TZQuery;
begin
  qrPESQUISA := TZQuery.Create(nil);
  try
    qrPESQUISA.Connection := TabGlobal.conexao;
    qrPESQUISA.sql.Add('select * from receber ');
    qrPESQUISA.sql.Add('where id_receber = :id_registro');
    qrPESQUISA.ParamByName('id_registro').AsInteger:=codigo;
    qrPESQUISA.Open;
    if qrPESQUISA.RecordCount >= 1 then
       begin
         self.Id_Registro  := qrPESQUISA.FieldByName('id_receber').AsInteger;
         self.Descricao    := qrPESQUISA.FieldByName('descricao').AsString;
         self.DtLancamento := qrPESQUISA.FieldByName('dtlancamento').AsDateTime;
         self.Valor        := qrPESQUISA.FieldByName('valor').AsCurrency;
         self.DtVencimento := qrPESQUISA.FieldByName('dtvencimento').AsDateTime;
         self.ValorPago    := qrPESQUISA.FieldByName('valorrecebido').AsCurrency;
         self.Situacao     := qrPESQUISA.FieldByName('situacao').AsString;
         Self.Plano        := qrPESQUISA.FieldByName('plano').AsInteger;
         Self.DtPagamento  := qrPESQUISA.FieldByName('dtrecebimento').AsDateTime;
         Self.CodConta     := qrPESQUISA.FieldByName('codconta').AsInteger;
         Self.Entidade     := qrPESQUISA.FieldByName('entidade').AsInteger;
         Result := true;
       end
    else
       result := false;
  finally
    FreeAndNil(qrPESQUISA);
  end;
end;

procedure TContaReceber.altera(codigo: integer);
var
  qrALT : TZQuery;
  cSQL : string;
begin
  cSQL:=  'update receber '+
          'set '+
          'descricao=:descricao, '+
          'dtlancamento=:dtlancamento, '+
          'valor=:valor, '+
          'dtvencimento=:dtvencimento, '+
          'valorrecebido=:valorpago, '+
          'situacao=:situacao, '+
          'plano=:plano, '+
          'dtrecebimento=:dtpagamento, '+
          'codconta=:codconta, '+
          'entidade=:entidade '+
          'where '+
          'id_receber = :id_registro';

  qrALT := TZQuery.Create(nil);
  try
    qrALT.Connection := TabGlobal.conexao;
    qrALT.sql.Text:=cSQL;
    qrALT.ParamByName('id_registro').AsInteger := Id_Registro;
    qrALT.ParamByName('descricao').AsString    := Descricao;
    qrALT.ParamByName('dtlancamento').AsDate   := DtLancamento;
    qrALT.ParamByName('valor').AsFloat         := valor;
    qrALT.ParamByName('dtvencimento').AsDate   := DtVencimento;
    qrALT.ParamByName('valorpago').AsFloat     := ValorPago;
    qrALT.ParamByName('situacao').AsString     := Situacao;
    qrALT.ParamByName('plano').AsInteger       := Plano;
    qrALT.ParamByName('dtpagamento').AsDate    := DtPagamento;
    qrALT.ParamByName('codconta').AsInteger    := CodConta;
    qrALT.ParamByName('entidade').AsInteger    := Entidade;
    try
      TabGlobal.conexao.StartTransaction;
      qrALT.ExecSQL;
      TabGlobal.conexao.Commit;
    except
      on e: Exception do
      begin
        TabGlobal.conexao.Rollback;
        raise Exception.Create('Erro ao atualizar a conta receber' + sLineBreak +
          e.ClassName + sLineBreak + e.Message);
      end;
    end;
  finally
    FreeAndNil(qrALT);
  end;
end;

procedure TContaReceber.exclui(codigo: integer);
var
  qrEXC : TZQuery;
  cSQL : string;
begin
  cSQL:=  'delete from receber '+
          'where '+
          'id_receber = :id_registro';
  qrEXC := TZQuery.Create(nil);
  try
    qrEXC.Connection := TabGlobal.conexao;
    qrEXC.sql.Text:=cSQL;
    qrEXC.ParamByName('id_registro').AsInteger:=codigo;
    try
      TabGlobal.conexao.StartTransaction;
      qrEXC.ExecSQL;
      TabGlobal.conexao.Commit;
    except
      on e: Exception do
      begin
        TabGlobal.conexao.Rollback;
        raise Exception.Create('Erro ao excluir a conta receber' + sLineBreak +
          e.ClassName + sLineBreak + e.Message);
      end;
    end;
  finally
    FreeAndNil(qrEXC);
  end;
end;


end.
