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
  cSQL:= 'insert into receber'+
          '  (id_receber, descricao, dtlancamento, valor, ' +
              'dtvencimento, valorrecebido, situacao, plano, dtrecebimento, codconta) '+
          'values '+
          '  (:id_registro, :descricao, :dtlancamento, :valor, '+
             ':dtvencimento, :valorpago, :situacao, :plano, :dtpagamento, :codconta)';
  qrINC := TZQuery.Create(nil);
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
          'codconta=:codconta '+
          'where '+
          'id_receber = :id_registro';

  qrALT := TZQuery.Create(nil);
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
  cSQL:=  'delete from receber '+
          'where '+
          'id_receber = :id_registro';
  qrEXC := TZQuery.Create(nil);
  qrEXC.Connection := TabGlobal.conexao;
  qrEXC.sql.Text:=cSQL;
  qrEXC.ParamByName('id_registro').AsInteger:=codigo;
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
