unit classe_plano;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Controls, ExtCtrls, Dialogs,utabela ,ZDataset;

  type

    { Tplano }

    Tplano = class

    private
      Fdescricao: String;
      Fid_plano: integer;
      Ftipo: string;
      function retornaAI:integer;
    public
      function incluir:Boolean;
      function localiza(codigo:Integer):Boolean;
      function altera(codigo:integer):Boolean;
      function exclui(codigo:integer):Boolean;
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
  qrAI.Connection := TabGlobal.conexao;
  qrAI.sql.Add('select coalesce(max(id_plano),0)+1 codigo ');
  qrAI.sql.Add('from planos');
  qrAI.sql.Add('where id_plano not in(99990,99991)');
  qrAI.Open;
  if qrAI.FieldByName('codigo').Value = 99989 then
     result := 99995
  else
     result := qrAI.FieldByName('codigo').Value;
  if Assigned(qrAI) then
     FreeAndNil(qrAI);

end;

function Tplano.incluir: Boolean;
var
  qrINC : TZQuery;
  cSQL : string;
begin
  cSQL:= 'INSERT INTO planos'+
          '  (id_plano, descricao, tipo) '+
          'VALUES '+
          '  (:id_plano, :descricao, :tipo)';
  qrINC := TZQuery.Create(nil);
  qrINC.Connection := TabGlobal.conexao;
  qrINC.sql.Text:=cSQL;
  qrINC.ParamByName('id_plano').AsInteger:=retornaAI;
  qrINC.ParamByName('descricao').AsString:=descricao;
  qrINC.ParamByName('tipo').AsString     :=tipo;
  try
    qrINC.ExecSQL;
    Result := true;
  Except
    on e: exception do
       begin
         result := false;
         ShowMessage('Erro ao incluir o plano'+sLineBreak+
         e.ClassName+sLineBreak+e.Message);
       end;
  end;

  if Assigned(qrINC) then
     FreeAndNil(qrINC);

end;

function Tplano.localiza(codigo: Integer): Boolean;
var
  qrPESQUISA : TZQuery;
begin
  qrPESQUISA := TZQuery.Create(nil);
  qrPESQUISA.Connection := TabGlobal.conexao;
  qrPESQUISA.sql.Add('select * from planos ');
  qrPESQUISA.sql.Add('where id_plano = :nCODIGO');
  qrPESQUISA.ParamByName('nCODIGO').AsInteger:=codigo;
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

  if Assigned(qrPESQUISA) then
     FreeAndNil(qrPESQUISA);
end;

function Tplano.altera(codigo: integer): Boolean;
var
  qrALT : TZQuery;
  cSQL : string;
begin
  cSQL:=  'UPDATE planos SET '+
          '  descricao = :descricao, '+
          '  tipo = :tipo '+
          'WHERE'+
          '  planos.id_plano = :OLD_id_plano';
  qrALT := TZQuery.Create(nil);
  qrALT.Connection := TabGlobal.conexao;
  qrALT.sql.Text:=cSQL;
  qrALT.ParamByName('OLD_id_plano').AsInteger:=codigo;
  qrALT.ParamByName('descricao').AsString    :=descricao;
  qrALT.ParamByName('tipo').AsString         :=tipo;
  try
    qrALT.ExecSQL;
    Result := true;
  Except
    on e: exception do
       begin
         result := false;
         ShowMessage('Erro ao atualizar o plano'+sLineBreak+
         e.ClassName+sLineBreak+e.Message);
       end;
  end;

  if Assigned(qrALT) then
     FreeAndNil(qrALT);

end;

function Tplano.exclui(codigo: integer): Boolean;
var
  qrEXC : TZQuery;
  cSQL : string;
begin
  cSQL:=  'DELETE FROM planos '+
          'WHERE '+
          '  planos.id_plano = :OLD_id_plano';
  qrEXC := TZQuery.Create(nil);
  qrEXC.Connection := TabGlobal.conexao;
  qrEXC.sql.Text:=cSQL;
  qrEXC.ParamByName('OLD_id_plano').AsInteger:=codigo;
  try
    qrEXC.ExecSQL;
    Result := true;
  Except
    on e: exception do
       begin
         result := false;
         ShowMessage('Erro ao excluir o plano'+sLineBreak+
         e.ClassName+sLineBreak+e.Message);
       end;
  end;

  if Assigned(qrEXC) then
     FreeAndNil(qrEXC);

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
  qrFIXA.Connection := TabGlobal.conexao;
  qrFIXA.sql.Text:=cSQL;
  try
    qrFIXA.ExecSQL;
    Result := true;
  Except
    on e: exception do
       begin
         result := false;
         ShowMessage('Erro ao fixar código 9991'+sLineBreak+
         e.ClassName+sLineBreak+e.Message);
       end;
  end;

  if Assigned(qrFIXA) then
     FreeAndNil(qrFIXA);
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
  qrFIXA.Connection := TabGlobal.conexao;
  qrFIXA.sql.Text:=cSQL;
  try
    qrFIXA.ExecSQL;
    Result := true;
  Except
    on e: exception do
       begin
         result := false;
         ShowMessage('Erro ao fixar código 9990'+sLineBreak+
         e.ClassName+sLineBreak+e.Message);
       end;
  end;

  if Assigned(qrFIXA) then
     FreeAndNil(qrFIXA);
end;













end.

