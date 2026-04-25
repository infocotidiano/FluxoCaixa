unit classe_entidade;
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
  Classes, SysUtils, Controls, ExtCtrls, Dialogs,utabela ,ZDataset;
type

   { TEntidade }

   TEntidade = Class
     private
       FId_Entidade: integer;
       FNome: String;
       FTelefone: String;
       function retornaAI:integer;
     published
       property Id_Entidade : integer read FId_Entidade write FId_Entidade;
       property Nome        : String  read FNome        write FNome;
       property Telefone    : String  read FTelefone    write FTelefone;
     public
       procedure incluir;
       function localiza(codigo:Integer):Boolean;
       procedure altera(codigo:integer);
       procedure exclui(codigo:integer);
   end;

implementation

{ TEntidade }

function TEntidade.retornaAI: integer;
var
  qrAI : TZQuery;
begin
  qrAI := TZQuery.Create(nil);
  try
    qrAI.Connection := TabGlobal.conexao;
    qrAI.sql.Add('select coalesce(max(id_entidade),0)+1 codigo ');
    qrAI.sql.Add('from entidades');
    qrAI.Open;
    result := qrAI.FieldByName('codigo').Value;
  finally
    FreeAndNil(qrAI);
  end;
end;

procedure TEntidade.incluir;
var
  qrINC : TZQuery;
  cSQL : string;
begin
  cSQL:= 'insert into entidades'+
          '  (id_entidade, nome, telefone) '+
          'values '+
          '  (:id_entidade, :nome, :telefone)';
  qrINC := TZQuery.Create(nil);
  try
    qrINC.Connection := TabGlobal.conexao;
    qrINC.sql.Text:=cSQL;
    qrINC.ParamByName('id_entidade').AsInteger := retornaAI;
    qrINC.ParamByName('nome').AsString         := Nome;
    qrINC.ParamByName('telefone').AsString     := Telefone;
    try
      TabGlobal.conexao.StartTransaction;
      qrINC.ExecSQL;
      TabGlobal.conexao.Commit;
    except
      on e: Exception do
      begin
        TabGlobal.conexao.Rollback;
        raise Exception.Create('Erro ao incluir a entidade' + sLineBreak +
          e.ClassName + sLineBreak + e.Message);
      end;
    end;
  finally
    FreeAndNil(qrINC);
  end;
end;

function TEntidade.localiza(codigo: Integer): Boolean;
var
  qrPESQUISA : TZQuery;
begin
  qrPESQUISA := TZQuery.Create(nil);
  try
    qrPESQUISA.Connection := TabGlobal.conexao;
    qrPESQUISA.sql.Add('select * from entidades ');
    qrPESQUISA.sql.Add('where id_entidade = :ncodigo');
    qrPESQUISA.ParamByName('ncodigo').AsInteger:=codigo;
    qrPESQUISA.Open;
    if qrPESQUISA.RecordCount >= 1 then
       begin
         self.id_entidade  := qrPESQUISA.FieldByName('id_entidade').AsInteger;
         self.nome         := qrPESQUISA.FieldByName('nome').AsString;
         self.telefone     := qrPESQUISA.FieldByName('telefone').AsString;
         Result := true;
       end
    else
       result := false;
  finally
    FreeAndNil(qrPESQUISA);
  end;
end;

procedure TEntidade.altera(codigo: integer);
var
  qrALT : TZQuery;
  cSQL : string;
begin
  cSQL:=  'update entidades set '+
          '  nome = :nome, '+
          '  telefone = :telefone '+
          'where '+
          '  entidades.id_entidade = :old_id_entidade';
  qrALT := TZQuery.Create(nil);
  try
    qrALT.Connection := TabGlobal.conexao;
    qrALT.sql.Text:=cSQL;
    qrALT.ParamByName('old_id_entidade').AsInteger:=codigo;
    qrALT.ParamByName('nome').AsString            :=Nome;
    qrALT.ParamByName('telefone').AsString        :=Telefone;
    try
      TabGlobal.conexao.StartTransaction;
      qrALT.ExecSQL;
      TabGlobal.conexao.Commit;
    except
      on e: Exception do
      begin
        TabGlobal.conexao.Rollback;
        raise Exception.Create('Erro ao atualizar a entidade' + sLineBreak +
          e.ClassName + sLineBreak + e.Message);
      end;
    end;
  finally
    FreeAndNil(qrALT);
  end;
end;

procedure TEntidade.exclui(codigo: integer);
var
  qrEXC : TZQuery;
  cSQL : string;
begin
  cSQL:=  'delete from entidades '+
          'where '+
          '  entidades.id_entidade = :old_id_entidade';
  qrEXC := TZQuery.Create(nil);
  try
    qrEXC.Connection := TabGlobal.conexao;
    qrEXC.sql.Text:=cSQL;
    qrEXC.ParamByName('old_id_entidade').AsInteger:=codigo;
    try
      TabGlobal.conexao.StartTransaction;
      qrEXC.ExecSQL;
      TabGlobal.conexao.Commit;
    except
      on e: Exception do
      begin
        TabGlobal.conexao.Rollback;
        raise Exception.Create('Erro ao excluir a entidade' + sLineBreak +
          e.ClassName + sLineBreak + e.Message);
      end;
    end;
  finally
    FreeAndNil(qrEXC);
  end;
end;

end.
