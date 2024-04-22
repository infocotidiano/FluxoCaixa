unit classe_conta;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Controls, ExtCtrls, Dialogs,utabela ,ZDataset;

  type

    { Tconta }

    Tconta = class

    private
      Fagencia: string;
      Fbanco: string;
      Fconta: string;
      Fdescricao: String;
      Fid_conta: integer;

      function retornaAI:integer;
    public
      function incluir:Boolean;
      function localiza(codigo:Integer):Boolean;
      function altera(codigo:integer):Boolean;
      function exclui(codigo:integer):Boolean;
    published
      property id_conta : integer read Fid_conta write Fid_conta;
      property descricao : String read Fdescricao write Fdescricao;
      property banco : string read Fbanco write Fbanco;
      property agencia : string read Fagencia write Fagencia;
      property conta : string read Fconta write Fconta;
    end;


implementation

{ Tconta }

function Tconta.retornaAI: integer;
var
  qrAI : TZQuery;
begin
  qrAI := TZQuery.Create(nil);
  qrAI.Connection := TabGlobal.conexao;
  qrAI.sql.Add('select coalesce(max(id_conta),0)+1 codigo ');
  qrAI.sql.Add('from contas');
  qrAI.Open;
  result := qrAI.FieldByName('codigo').Value;
  if Assigned(qrAI) then
     FreeAndNil(qrAI);

end;

function Tconta.incluir: Boolean;
var
  qrINC : TZQuery;
  cSQL : string;
begin
  cSQL:= 'INSERT INTO contas'+
          '  (id_conta, descricao, banco, agencia, conta) '+
          'VALUES '+
          '  (:id_conta, :descricao, :banco, :agencia, :conta)';
  qrINC := TZQuery.Create(nil);
  qrINC.Connection := TabGlobal.conexao;
  qrINC.sql.Text:=cSQL;
  qrINC.ParamByName('id_conta').AsInteger :=retornaAI;
  qrINC.ParamByName('descricao').AsString :=descricao;
  qrINC.ParamByName('banco').AsString     :=banco;
  qrINC.ParamByName('agencia').AsString   :=agencia;
  qrINC.ParamByName('conta').AsString     :=conta;
  try
    qrINC.ExecSQL;
    Result := true;
  Except
    on e: exception do
       begin
         result := false;
         ShowMessage('Erro ao incluir a conta'+sLineBreak+
         e.ClassName+sLineBreak+e.Message);
       end;
  end;

  if Assigned(qrINC) then
     FreeAndNil(qrINC);

end;

function Tconta.localiza(codigo: Integer): Boolean;
var
  qrPESQUISA : TZQuery;
begin
  qrPESQUISA := TZQuery.Create(nil);
  qrPESQUISA.Connection := TabGlobal.conexao;
  qrPESQUISA.sql.Add('select * from contas ');
  qrPESQUISA.sql.Add('where id_conta = :nCODIGO');
  qrPESQUISA.ParamByName('nCODIGO').AsInteger:=codigo;
  qrPESQUISA.Open;
  if qrPESQUISA.RecordCount >= 1 then
     begin
       self.id_conta  := qrPESQUISA.FieldByName('id_conta').AsInteger;
       self.descricao := qrPESQUISA.FieldByName('descricao').AsString;
       self.banco     := qrPESQUISA.FieldByName('banco').AsString;
       self.agencia   := qrPESQUISA.FieldByName('agencia').AsString;
       self.conta     := qrPESQUISA.FieldByName('conta').AsString;
       ShowMessage(descricao);
       Result := true;
     end
  else
     result := false;

  if Assigned(qrPESQUISA) then
     FreeAndNil(qrPESQUISA);
end;

function Tconta.altera(codigo: integer): Boolean;
var
  qrALT : TZQuery;
  cSQL : string;
begin
  cSQL:=  'UPDATE contas SET '+
          '  descricao = :descricao, '+
          '  banco   = :banco, '+
          '  agencia = :agencia, '+
          '  conta   = :conta '+
          'WHERE'+
          '  contas.id_conta = :OLD_id_conta';
  qrALT := TZQuery.Create(nil);
  qrALT.Connection := TabGlobal.conexao;
  qrALT.sql.Text:=cSQL;
  qrALT.ParamByName('OLD_id_conta').AsInteger:=codigo;
  qrALT.ParamByName('descricao').AsString    :=descricao;
  qrALT.ParamByName('banco').AsString        :=banco;
  qrALT.ParamByName('agencia').AsString      :=agencia;
  qrALT.ParamByName('conta').AsString        :=conta;

  try
    qrALT.ExecSQL;
    Result := true;
  Except
    on e: exception do
       begin
         result := false;
         ShowMessage('Erro ao atualizar a conta'+sLineBreak+
         e.ClassName+sLineBreak+e.Message);
       end;
  end;

  if Assigned(qrALT) then
     FreeAndNil(qrALT);

end;

function Tconta.exclui(codigo: integer): Boolean;
var
  qrEXC : TZQuery;
  cSQL : string;
begin
  cSQL:=  'DELETE FROM contas '+
          'WHERE '+
          '  contas.id_conta = :OLD_id_conta';
  qrEXC := TZQuery.Create(nil);
  qrEXC.Connection := TabGlobal.conexao;
  qrEXC.sql.Text:=cSQL;
  qrEXC.ParamByName('OLD_id_conta').AsInteger:=codigo;
  try
    qrEXC.ExecSQL;
    Result := true;
  Except
    on e: exception do
       begin
         result := false;
         ShowMessage('Erro ao excluir a conta'+sLineBreak+
         e.ClassName+sLineBreak+e.Message);
       end;
  end;

  if Assigned(qrEXC) then
     FreeAndNil(qrEXC);

end;












end.

