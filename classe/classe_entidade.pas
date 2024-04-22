unit classe_entidade;

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
       function incluir:Boolean;
       function localiza(codigo:Integer):Boolean;
       function altera(codigo:integer):Boolean;
       function exclui(codigo:integer):Boolean;
   end;

implementation

{ TEntidade }

function TEntidade.retornaAI: integer;
var
  qrAI : TZQuery;
begin
  qrAI := TZQuery.Create(nil);
  qrAI.Connection := TabGlobal.conexao;
  qrAI.sql.Add('select coalesce(max(id_entidade),0)+1 codigo ');
  qrAI.sql.Add('from entidades');
  qrAI.Open;
  result := qrAI.FieldByName('codigo').Value;
  if Assigned(qrAI) then
     FreeAndNil(qrAI);
end;

function TEntidade.incluir: Boolean;
var
  qrINC : TZQuery;
  cSQL : string;
begin
  cSQL:= 'INSERT INTO entidades'+
          '  (id_entidade, nome, telefone) '+
          'VALUES '+
          '  (:id_entidade, :nome, :telefone)';
  qrINC := TZQuery.Create(nil);
  qrINC.Connection := TabGlobal.conexao;
  qrINC.sql.Text:=cSQL;
  qrINC.ParamByName('id_entidade').AsInteger :=retornaAI;
  qrINC.ParamByName('nome').AsString         :=Nome;
  qrINC.ParamByName('telefone').AsString     :=Telefone;
  try
    qrINC.ExecSQL;
    Result := true;
  Except
    on e: exception do
       begin
         result := false;
         ShowMessage('Erro ao incluir a entidade'+sLineBreak+
         e.ClassName+sLineBreak+e.Message);
       end;
  end;

  if Assigned(qrINC) then
     FreeAndNil(qrINC);

end;

function TEntidade.localiza(codigo: Integer): Boolean;
var
  qrPESQUISA : TZQuery;
begin
  qrPESQUISA := TZQuery.Create(nil);
  qrPESQUISA.Connection := TabGlobal.conexao;
  qrPESQUISA.sql.Add('select * from entidades ');
  qrPESQUISA.sql.Add('where id_entidade = :nCODIGO');
  qrPESQUISA.ParamByName('nCODIGO').AsInteger:=codigo;
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

  if Assigned(qrPESQUISA) then
     FreeAndNil(qrPESQUISA);
end;

function TEntidade.altera(codigo: integer): Boolean;
var
  qrALT : TZQuery;
  cSQL : string;
begin
  cSQL:=  'UPDATE entidades SET '+
          '  nome = :nome, '+
          '  telefone = :telefone '+
          'WHERE'+
          '  entidades.id_entidade = :OLD_id_entidade';
  qrALT := TZQuery.Create(nil);
  qrALT.Connection := TabGlobal.conexao;
  qrALT.sql.Text:=cSQL;
  qrALT.ParamByName('OLD_id_entidade').AsInteger:=codigo;
  qrALT.ParamByName('nome').AsString            :=Nome;
  qrALT.ParamByName('telefone').AsString        :=Telefone;

  try
    qrALT.ExecSQL;
    Result := true;
  Except
    on e: exception do
       begin
         result := false;
         ShowMessage('Erro ao atualizar a entidade'+sLineBreak+
         e.ClassName+sLineBreak+e.Message);
       end;
  end;

  if Assigned(qrALT) then
     FreeAndNil(qrALT);

end;

function TEntidade.exclui(codigo: integer): Boolean;
var
  qrEXC : TZQuery;
  cSQL : string;
begin
  cSQL:=  'DELETE FROM entidades '+
          'WHERE '+
          '  entidades.id_entidade = :OLD_id_entidade';
  qrEXC := TZQuery.Create(nil);
  qrEXC.Connection := TabGlobal.conexao;
  qrEXC.sql.Text:=cSQL;
  qrEXC.ParamByName('OLD_id_entidade').AsInteger:=codigo;
  try
    qrEXC.ExecSQL;
    Result := true;
  Except
    on e: exception do
       begin
         result := false;
         ShowMessage('Erro ao excluir a entidade'+sLineBreak+
         e.ClassName+sLineBreak+e.Message);
       end;
  end;

  if Assigned(qrEXC) then
     FreeAndNil(qrEXC);

end;

end.

