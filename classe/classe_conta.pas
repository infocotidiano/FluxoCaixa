unit classe_conta;

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

  { Tconta }

  Tconta = class

  private
    Fagencia: string;
    Fbanco: string;
    Fconta: string;
    Fdescricao: string;
    Fid_conta: integer;

    function retornaAI: integer;
  public
    procedure incluir;
    function localiza(codigo: integer): boolean;
    procedure altera(codigo: integer);
    procedure exclui(codigo: integer);
  published
    property id_conta: integer read Fid_conta write Fid_conta;
    property descricao: string read Fdescricao write Fdescricao;
    property banco: string read Fbanco write Fbanco;
    property agencia: string read Fagencia write Fagencia;
    property conta: string read Fconta write Fconta;
  end;


implementation

{ Tconta }

function Tconta.retornaAI: integer;
var
  qrAI: TZQuery;
begin
  qrAI := TZQuery.Create(nil);
  try
    qrAI.Connection := TabGlobal.conexao;
    qrAI.sql.Add('select coalesce(max(id_conta),0)+1 codigo ');
    qrAI.sql.Add('from contas');
    qrAI.Open;
    Result := qrAI.FieldByName('codigo').Value;
  finally
    FreeAndNil(qrAI);
  end;

end;

procedure Tconta.incluir;
var
  qrINC: TZQuery;
  cSQL: string;
begin
  cSQL := 'insert into contas' + '  (id_conta, descricao, banco, agencia, conta) ' +
    'values ' + '  (:id_conta, :descricao, :banco, :agencia, :conta)';
  qrINC := TZQuery.Create(nil);
  try

    qrINC.Connection := TabGlobal.conexao;
    qrINC.sql.Text := cSQL;
    qrINC.ParamByName('id_conta').AsInteger := retornaAI;
    qrINC.ParamByName('descricao').AsString := descricao;
    qrINC.ParamByName('banco').AsString := banco;
    qrINC.ParamByName('agencia').AsString := agencia;
    qrINC.ParamByName('conta').AsString := conta;
    try
      TabGlobal.conexao.StartTransaction;
      qrINC.ExecSQL;
      TabGlobal.conexao.Commit;
    except
      on e: Exception do
      begin
        TabGlobal.conexao.Rollback;
        raise Exception.Create('Erro ao incluir a conta' + sLineBreak +
          e.ClassName + sLineBreak + e.Message);
      end;
    end;

  finally
    FreeAndNil(qrINC);
  end;

end;

function Tconta.localiza(codigo: integer): boolean;
var
  qrPESQUISA: TZQuery;
begin
  qrPESQUISA := TZQuery.Create(nil);
  try
    qrPESQUISA.Connection := TabGlobal.conexao;
    qrPESQUISA.sql.Add('select * from contas ');
    qrPESQUISA.sql.Add('where id_conta = :ncodigo');
    qrPESQUISA.ParamByName('ncodigo').AsInteger := codigo;
    qrPESQUISA.Open;
    if qrPESQUISA.RecordCount >= 1 then
    begin
      self.id_conta := qrPESQUISA.FieldByName('id_conta').AsInteger;
      self.descricao := qrPESQUISA.FieldByName('descricao').AsString;
      self.banco := qrPESQUISA.FieldByName('banco').AsString;
      self.agencia := qrPESQUISA.FieldByName('agencia').AsString;
      self.conta := qrPESQUISA.FieldByName('conta').AsString;
      Result := True;
    end
    else
      Result := False;
  finally
    FreeAndNil(qrPESQUISA);
  end;

end;

procedure Tconta.altera(codigo: integer);
var
  qrALT: TZQuery;
  cSQL: string;
begin
  cSQL := 'update contas set ' + '  descricao = :descricao, ' +
    '  banco   = :banco, ' + '  agencia = :agencia, ' + '  conta   = :conta ' +
    'where ' + '  contas.id_conta = :old_id_conta';
  qrALT := TZQuery.Create(nil);
  try

    qrALT.Connection := TabGlobal.conexao;
    qrALT.sql.Text := cSQL;
    qrALT.ParamByName('old_id_conta').AsInteger := codigo;
    qrALT.ParamByName('descricao').AsString := descricao;
    qrALT.ParamByName('banco').AsString := banco;
    qrALT.ParamByName('agencia').AsString := agencia;
    qrALT.ParamByName('conta').AsString := conta;

    try
      TabGlobal.conexao.StartTransaction;
      qrALT.ExecSQL;
      TabGlobal.conexao.Commit;
    except
      on e: Exception do
      begin
        TabGlobal.conexao.Rollback;
        raise Exception.Create('Erro ao atualizar a conta' + sLineBreak +
          e.ClassName + sLineBreak + e.Message);
      end;
    end;
  finally
    FreeAndNil(qrALT);
  end;
end;

procedure Tconta.exclui(codigo: integer);
var
  qrEXC: TZQuery;
  cSQL: string;
begin
  cSQL := 'delete from contas ' + 'where ' + '  contas.id_conta = :old_id_conta';
  qrEXC := TZQuery.Create(nil);
  try

    qrEXC.Connection := TabGlobal.conexao;
    qrEXC.sql.Text := cSQL;
    qrEXC.ParamByName('old_id_conta').AsInteger := codigo;
    try
      TabGlobal.conexao.StartTransaction;
      qrEXC.ExecSQL;
      TabGlobal.conexao.Commit;
    except
      on e: Exception do
      begin
        raise Exception.Create('Erro ao excluir a conta' + sLineBreak +
          e.ClassName + sLineBreak + e.Message);
      end;
    end;
  finally
    FreeAndNil(qrEXC)
  end;

end;

end.
