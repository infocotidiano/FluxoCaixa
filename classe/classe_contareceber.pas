unit classe_contareceber;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, classe_registrofinanceiro,
  Controls, ExtCtrls, Dialogs,utabela ,ZDataset;
type

  { TContaReceber }

  TContaReceber = class(TRegistroFinanceiro)
  private
    function retornaAI:integer;
  public
    function incluir:Boolean; override;
    function localiza(codigo:Integer):Boolean; override;
    function altera(codigo:integer):Boolean; override;
    function exclui(codigo:integer):Boolean; override;
  end;

implementation

{ TContaReceber }

function TContaReceber.retornaAI: integer;
var
  qrAI : TZQuery;
begin
  qrAI := TZQuery.Create(nil);
  qrAI.Connection := TabGlobal.conexao;
  qrAI.sql.Add('select coalesce(max(id_receber),0)+1 codigo ');
  qrAI.sql.Add('from receber');
  qrAI.Open;
  result := qrAI.FieldByName('codigo').Value;
  if Assigned(qrAI) then
     FreeAndNil(qrAI);

end;

function TContaReceber.incluir: Boolean;
var
  qrINC : TZQuery;
  cSQL : string;
begin
  cSQL:= 'INSERT INTO receber'+
          '  (id_receber, Descricao, DtLancamento, Valor, ' +
              'DtVencimento, ValorRecebido, Situacao, Plano, dtrecebimento, CodConta) '+
          'VALUES '+
          '  (:Id_Registro, :Descricao, :DtLancamento, :Valor, '+
             ':DtVencimento, :ValorPago, :Situacao, :Plano, :DtPagamento, :CodConta)';
  qrINC := TZQuery.Create(nil);
  qrINC.Connection := TabGlobal.conexao;
  qrINC.sql.Text:=cSQL;
  qrINC.ParamByName('Id_Registro').AsInteger := retornaAI;
  qrINC.ParamByName('Descricao').AsString    := Descricao;
  qrINC.ParamByName('DtLancamento').AsDate   := DtLancamento;
  qrINC.ParamByName('Valor').AsFloat         := valor;
  qrINC.ParamByName('DtVencimento').AsDate   := DtVencimento;
  qrINC.ParamByName('ValorPago').AsFloat     := ValorPago;
  qrINC.ParamByName('Situacao').AsString     := Situacao;
  qrINC.ParamByName('Plano').AsInteger       := Plano;
  qrINC.ParamByName('DtPagamento').AsDate    := DtPagamento;
  qrINC.ParamByName('CodConta').AsInteger    := CodConta;
  try
    qrINC.ExecSQL;
    Result := true;
  Except
    on e: exception do
       begin
         result := false;
         ShowMessage('Erro ao incluir a contas receber'+sLineBreak+
         e.ClassName+sLineBreak+e.Message);
       end;
  end;

  if Assigned(qrINC) then
     FreeAndNil(qrINC);
end;

function TContaReceber.localiza(codigo: Integer): Boolean;
var
  qrPESQUISA : TZQuery;
begin
  qrPESQUISA := TZQuery.Create(nil);
  qrPESQUISA.Connection := TabGlobal.conexao;
  qrPESQUISA.sql.Add('select * from receber ');
  qrPESQUISA.sql.Add('where id_receber = :Id_registro');
  qrPESQUISA.ParamByName('Id_registro').AsInteger:=codigo;
  qrPESQUISA.Open;
  if qrPESQUISA.RecordCount >= 1 then
     begin
       self.Id_Registro  := qrPESQUISA.FieldByName('id_receber').AsInteger;
       self.Descricao    := qrPESQUISA.FieldByName('descricao').AsString;
       self.DtLancamento := qrPESQUISA.FieldByName('Dtlancamento').AsDateTime;
       self.Valor        := qrPESQUISA.FieldByName('valor').AsCurrency;
       self.DtVencimento := qrPESQUISA.FieldByName('DtVencimento').AsDateTime;
       self.ValorPago    := qrPESQUISA.FieldByName('ValorRecebido').AsCurrency;
       self.Situacao     := qrPESQUISA.FieldByName('Situacao').AsString;
       Self.Plano        := qrPESQUISA.FieldByName('Plano').AsInteger;
       Self.DtPagamento  := qrPESQUISA.FieldByName('dtrecebimento').AsDateTime;
       Self.CodConta     := qrPESQUISA.FieldByName('CodConta').AsInteger;
       Result := true;
     end
  else
     result := false;

  if Assigned(qrPESQUISA) then
     FreeAndNil(qrPESQUISA);

end;

function TContaReceber.altera(codigo: integer): Boolean;
var
  qrALT : TZQuery;
  cSQL : string;
begin
  cSQL:=  'UPDATE receber '+
          'SET '+
          'descricao=:descricao, '+
          'dtlancamento=:dtlancamento, '+
          'valor=:valor, '+
          'dtvencimento=:dtvencimento, '+
          'valorrecebido=:ValorPago, '+
          'situacao=:situacao, '+
          'plano=:plano, '+
          'dtrecebimento=:DtPagamento, '+
          'CodConta=:CodConta '+
          'WHERE '+
          'id_receber = :Id_registro';

  qrALT := TZQuery.Create(nil);
  qrALT.Connection := TabGlobal.conexao;
  qrALT.sql.Text:=cSQL;
  qrALT.ParamByName('Id_Registro').AsInteger := Id_Registro;
  qrALT.ParamByName('Descricao').AsString    := Descricao;
  qrALT.ParamByName('DtLancamento').AsDate   := DtLancamento;
  qrALT.ParamByName('Valor').AsFloat         := valor;
  qrALT.ParamByName('DtVencimento').AsDate   := DtVencimento;
  qrALT.ParamByName('ValorPago').AsFloat     := ValorPago;
  qrALT.ParamByName('Situacao').AsString     := Situacao;
  qrALT.ParamByName('Plano').AsInteger       := Plano;
  qrALT.ParamByName('DtPagamento').AsDate    := DtPagamento;
  qrALT.ParamByName('CodConta').AsInteger    := CodConta;
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

function TContaReceber.exclui(codigo: integer): Boolean;
var
  qrEXC : TZQuery;
  cSQL : string;
begin
  cSQL:=  'DELETE FROM receber '+
          'WHERE '+
          'id_receber = :Id_registro';
  qrEXC := TZQuery.Create(nil);
  qrEXC.Connection := TabGlobal.conexao;
  qrEXC.sql.Text:=cSQL;
  qrEXC.ParamByName('Id_registro').AsInteger:=codigo;
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

