unit classe_contapagar;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, classe_registrofinanceiro,
  Controls, ExtCtrls, Dialogs,utabela ,ZDataset;
type

  { TContapagar }

  TContapagar = class(TRegistroFinanceiro)
  private
    function retornaAI:integer;
  public
    function incluir:Boolean; override;
    function localiza(codigo:Integer):Boolean; override;
    function altera(codigo:integer):Boolean; override;
    function exclui(codigo:integer):Boolean; override;
  end;

implementation

{ TContapagar }

function TContapagar.retornaAI: integer;
var
  qrAI : TZQuery;
begin
  qrAI := TZQuery.Create(nil);
  qrAI.Connection := TabGlobal.conexao;
  qrAI.sql.Add('select coalesce(max(id_pagar),0)+1 codigo ');
  qrAI.sql.Add('from pagar');
  qrAI.Open;
  result := qrAI.FieldByName('codigo').Value;
  if Assigned(qrAI) then
     FreeAndNil(qrAI);

end;

function TContapagar.incluir: Boolean;
var
  qrINC : TZQuery;
  cSQL : string;
begin
  cSQL:= 'insert into pagar'+
          '  (id_pagar, descricao, dtlancamento, valor, ' +
              'dtvencimento, valorpago, situacao, plano, dtrecebimento, codconta, entidade) '+
          'values '+
          '  (:id_registro, :descricao, :dtlancamento, :valor, '+
             ':dtvencimento, :valorpago, :situacao, :plano, :dtpagamento, :codconta, :entidade)';
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
  qrINC.ParamByName('entidade').AsInteger    := Entidade;
  try
    qrINC.ExecSQL;
    Result := true;
  Except
    on e: exception do
       begin
         result := false;
         ShowMessage('Erro ao incluir a contas pagar'+sLineBreak+
         e.ClassName+sLineBreak+e.Message);
       end;
  end;

  if Assigned(qrINC) then
     FreeAndNil(qrINC);
end;

function TContapagar.localiza(codigo: Integer): Boolean;
var
  qrPESQUISA : TZQuery;
begin
  qrPESQUISA := TZQuery.Create(nil);
  qrPESQUISA.Connection := TabGlobal.conexao;
  qrPESQUISA.sql.Add('select * from pagar ');
  qrPESQUISA.sql.Add('where id_pagar = :id_registro');
  qrPESQUISA.ParamByName('id_registro').AsInteger:=codigo;
  qrPESQUISA.Open;
  if qrPESQUISA.RecordCount >= 1 then
     begin
       self.Id_Registro  := qrPESQUISA.FieldByName('id_pagar').AsInteger;
       self.Descricao    := qrPESQUISA.FieldByName('descricao').AsString;
       self.DtLancamento := qrPESQUISA.FieldByName('dtlancamento').AsDateTime;
       self.Valor        := qrPESQUISA.FieldByName('valor').AsCurrency;
       self.DtVencimento := qrPESQUISA.FieldByName('dtvencimento').AsDateTime;
       self.ValorPago    := qrPESQUISA.FieldByName('valorpago').AsCurrency;
       self.Situacao     := qrPESQUISA.FieldByName('situacao').AsString;
       Self.Plano        := qrPESQUISA.FieldByName('plano').AsInteger;
       Self.DtPagamento  := qrPESQUISA.FieldByName('dtrecebimento').AsDateTime;
       Self.CodConta     := qrPESQUISA.FieldByName('codconta').AsInteger;
       Self.Entidade     := qrPESQUISA.FieldByName('entidade').AsInteger;
       Result := true;
     end
  else
     result := false;

  if Assigned(qrPESQUISA) then
     FreeAndNil(qrPESQUISA);

end;

function TContapagar.altera(codigo: integer): Boolean;
var
  qrALT : TZQuery;
  cSQL : string;
begin
  cSQL:=  'update pagar '+
          'set '+
          'descricao=:descricao, '+
          'dtlancamento=:dtlancamento, '+
          'valor=:valor, '+
          'dtvencimento=:dtvencimento, '+
          'valorpago=:valorpago, '+
          'situacao=:situacao, '+
          'plano=:plano, '+
          'dtrecebimento=:dtpagamento, '+
          'codconta=:codconta, '+
          'entidade=:entidade '+
          'where '+
          'id_pagar = :id_registro';

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
  qrALT.ParamByName('entidade').AsInteger    := Entidade;
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

function TContapagar.exclui(codigo: integer): Boolean;
var
  qrEXC : TZQuery;
  cSQL : string;
begin
  cSQL:=  'delete from pagar '+
          'where '+
          'id_pagar = :id_registro';
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
