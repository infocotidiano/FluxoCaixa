unit classe_plano;
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
  Classes, SysUtils, Controls, ExtCtrls, utabela ,ZDataset;

  type

    { Tplano }

    Tplano = class

    private
      Fdescricao: String;
      Fid_plano: integer;
      Ftipo: string;
      function retornaAI:integer;
    public
      procedure incluir;
      function localiza(codigo:Integer):Boolean;
      procedure altera(codigo:integer);
      procedure exclui(codigo:integer);
      function fixacodigoCredito:Boolean;
      function fixacodigoDebito: Boolean;
    published
      property id_plano : integer read Fid_plano write Fid_plano;
      property descricao : String read Fdescricao write Fdescricao;
      property tipo : string read Ftipo write Ftipo;
    end;


implementation

{ Tplano }

function Tplano.retornaAI: integer;
var
  qrAI : TZQuery;
begin
  qrAI := TZQuery.Create(nil);
  try
    qrAI.Connection := TabGlobal.conexao;
    qrAI.sql.Add('select coalesce(max(id_plano),0)+1 codigo ');
    qrAI.sql.Add('from planos');
    qrAI.sql.Add('where id_plano not in(99990,99991)');
    qrAI.Open;
    if qrAI.FieldByName('codigo').Value = 99989 then
      result := 99995
    else
      result := qrAI.FieldByName('codigo').Value;
  finally
    FreeAndNil(qrAI);
  end;
end;

procedure Tplano.incluir;
var
  qrINC : TZQuery;
  cSQL : string;
begin
  cSQL:= 'insert into planos'+
          '  (id_plano, descricao, tipo) '+
          'values '+
          '  (:id_plano, :descricao, :tipo)';
  qrINC := TZQuery.Create(nil);
  try
    qrINC.Connection := TabGlobal.conexao;
    qrINC.sql.Text:=cSQL;
    qrINC.ParamByName('id_plano').AsInteger:=retornaAI;
    qrINC.ParamByName('descricao').AsString:=descricao;
    qrINC.ParamByName('tipo').AsString     :=tipo;
    try
      TabGlobal.conexao.StartTransaction;
      qrINC.ExecSQL;
      TabGlobal.conexao.Commit;
    except
      on e: Exception do
      begin
        TabGlobal.conexao.Rollback;
        raise Exception.Create('Erro ao incluir o plano' + sLineBreak +
          e.ClassName + sLineBreak + e.Message);
      end;
    end;
  finally
    FreeAndNil(qrINC);
  end;
end;

function Tplano.localiza(codigo: Integer): Boolean;
var
  qrPESQUISA : TZQuery;
begin
  qrPESQUISA := TZQuery.Create(nil);
  try
    qrPESQUISA.Connection := TabGlobal.conexao;
    qrPESQUISA.sql.Add('select * from planos ');
    qrPESQUISA.sql.Add('where id_plano = :ncodigo');
    qrPESQUISA.ParamByName('ncodigo').AsInteger:=codigo;
    qrPESQUISA.Open;
    if qrPESQUISA.RecordCount >= 1 then
       begin
         self.id_plano  := qrPESQUISA.FieldByName('id_plano').AsInteger;
         self.descricao := qrPESQUISA.FieldByName('descricao').AsString;
         self.tipo      := qrPESQUISA.FieldByName('tipo').AsString;
         Result := true;
       end
    else
       result := false;
  finally
    FreeAndNil(qrPESQUISA);
  end;
end;

procedure Tplano.altera(codigo: integer);
var
  qrALT : TZQuery;
  cSQL : string;
begin
  cSQL:=  'update planos set '+
          '  descricao = :descricao, '+
          '  tipo = :tipo '+
          'where '+
          '  planos.id_plano = :old_id_plano';
  qrALT := TZQuery.Create(nil);
  try
    qrALT.Connection := TabGlobal.conexao;
    qrALT.sql.Text:=cSQL;
    qrALT.ParamByName('old_id_plano').AsInteger:=codigo;
    qrALT.ParamByName('descricao').AsString    :=descricao;
    qrALT.ParamByName('tipo').AsString         :=tipo;
    try
      TabGlobal.conexao.StartTransaction;
      qrALT.ExecSQL;
      TabGlobal.conexao.Commit;
    except
      on e: Exception do
      begin
        TabGlobal.conexao.Rollback;
        raise Exception.Create('Erro ao atualizar o plano' + sLineBreak +
          e.ClassName + sLineBreak + e.Message);
      end;
    end;
  finally
    FreeAndNil(qrALT);
  end;
end;

procedure Tplano.exclui(codigo: integer);
var
  qrEXC : TZQuery;
  cSQL : string;
begin
  cSQL:=  'delete from planos '+
          'where '+
          '  planos.id_plano = :old_id_plano';
  qrEXC := TZQuery.Create(nil);
  try
    qrEXC.Connection := TabGlobal.conexao;
    qrEXC.sql.Text:=cSQL;
    qrEXC.ParamByName('old_id_plano').AsInteger:=codigo;
    try
      TabGlobal.conexao.StartTransaction;
      qrEXC.ExecSQL;
      TabGlobal.conexao.Commit;
    except
      on e: Exception do
      begin
        TabGlobal.conexao.Rollback;
        raise Exception.Create('Erro ao excluir o plano' + sLineBreak +
          e.ClassName + sLineBreak + e.Message);
      end;
    end;
  finally
    FreeAndNil(qrEXC);
  end;
end;

function Tplano.fixacodigoCredito: Boolean;
var
  qrFIXA : TZQuery;
  cSQL : string;
begin
  // comando SQL
  cSQL:= 'insert into planos (id_plano, descricao,tipo) '+
  'values (99991,'+QuotedStr('TRANSFERENCIA RECEBIDA') +','+QuotedStr('C')+') '+
  'on duplicate key update ' +
  'descricao='+QuotedStr('TRANSFERENCIA RECEBIDA')+', '+
  'tipo='+QuotedStr('C')+' ';
  qrFIXA := TZQuery.Create(nil);
  try
    qrFIXA.Connection := TabGlobal.conexao;
    qrFIXA.sql.Text:=cSQL;
    try
      TabGlobal.conexao.StartTransaction;
      qrFIXA.ExecSQL;
      TabGlobal.conexao.Commit;
      Result := true;
    Except
      on e: exception do
         begin
           result := false;
           TabGlobal.conexao.Commit;
           raise exception.Create('Erro ao fixar código 9991'+sLineBreak+
           e.ClassName+sLineBreak+e.Message);
         end;
    end;

  finally
    FreeAndNil(qrFIXA);
  end;

end;

function Tplano.fixacodigoDebito: Boolean;
var
  qrFIXA : TZQuery;
  cSQL : string;
begin
  // comando SQL
  cSQL:= 'insert into planos (id_plano, descricao,tipo) '+
  'values (99990,'+QuotedStr('TRANSFERENCIA DEBITADA') +','+QuotedStr('D')+') '+
  'on duplicate key update ' +
  'descricao='+QuotedStr('TRANSFERENCIA DEBITADA')+', '+
  'tipo='+QuotedStr('D')+' ';
  qrFIXA := TZQuery.Create(nil);
  try
    qrFIXA.Connection := TabGlobal.conexao;
    qrFIXA.sql.Text:=cSQL;
    try
      TabGlobal.conexao.StartTransaction;
      qrFIXA.ExecSQL;
      TabGlobal.conexao.Commit;
      Result := true;
    Except
      on e: exception do
         begin
           TabGlobal.conexao.Rollback;
           Raise exception.Create('Erro ao fixar código 9990'+sLineBreak+
           e.ClassName+sLineBreak+e.Message);
         end;
    end;
  finally
    FreeAndNil(qrFIXA);
  end;



end;













end.
