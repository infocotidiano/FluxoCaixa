unit classe_registrofinanceiro;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, LMessages, Dialogs;

type

  { TRegistroFinanceiro }

  TRegistroFinanceiro = class
  private
    FDescricao: string;
    FDtLancamento: TDate;
    FId_Registro: integer;
    FPlano: integer;
    FSituacao: string;
    FValor: Real;
    FValorPago: Real;
    FDtVencimento: TDate;
    FDtPagamento: TDate;
    FCodConta : integer;

    procedure SetDescricao(AValue: string);
    procedure SetSituacao(AValue: string);
    procedure SetValor(AValue: Real);
    procedure SetValorPago(AValue: Real);
    procedure setPlano(AValue : integer); overload;
    procedure setPlano(AValue : string); overload;
    function getPlano:integer;

    procedure setDtLancamento(AValue: TDate); overload;
    procedure setDtLancamento(AValue: string); overload;
    function getDtLancamento:TDate;

    procedure setDtPagamento(AValue: TDate); overload;
    procedure setDtPagamento(AValue: string); overload;
    function getDtpagamento:TDate;


  public
    function incluir:Boolean; virtual;
    function localiza(codigo:Integer):Boolean;  virtual;
    function altera(codigo:integer):Boolean;  virtual;
    function exclui(codigo:integer):Boolean; virtual;
    function fixacodigoCredito:Boolean; virtual;
    function fixacodigoDebito: Boolean; virtual;
  published
    property Id_Registro : integer read FId_Registro write FId_Registro;
    property Descricao: string read FDescricao write SetDescricao;
    property DtLancamento : TDate read getDtLancamento write setDtLancamento;
    property Valor : Real read FValor write SetValor;
    property DtVencimento : TDate read FDtVencimento write FDtVencimento;
    property ValorPago : Real read FValorPago write SetValorPago;
    property Situacao : string read FSituacao write SetSituacao;
    property Plano : integer read GetPlano write SetPlano;
    property DtPagamento: TDate read getDtpagamento write setDtPagamento;
    property CodConta: integer read FCodConta write FCodConta;
  end;

implementation

{ TRegistroFinanceiro }

procedure TRegistroFinanceiro.SetDescricao(AValue: string);
begin
  if AValue = EmptyStr then
     raise Exception.Create('Descrição é obrigatório !');
  if FDescricao=AValue then Exit;
  FDescricao:=AValue;
end;

procedure TRegistroFinanceiro.SetSituacao(AValue: string);
begin
  if (AValue <> 'P') and (AValue <> 'B') then
     raise Exception.Create('Situação obritória:'+sLineBreak+
           'P-Pendente ou B-Baixado!');

  if FSituacao=AValue then Exit;
  FSituacao:=AValue;
end;

procedure TRegistroFinanceiro.SetValor(AValue: Real);
begin
  if AValue <= 0 then
     raise Exception.Create('Valor obritório ser maior que zero!');
  if FValor=AValue then Exit;
  FValor:=AValue;
end;

procedure TRegistroFinanceiro.SetValorPago(AValue: Real);
begin
  if FValorPago=AValue then Exit;
  FValorPago:=AValue;
end;

function TRegistroFinanceiro.incluir: Boolean;
begin
  // realizado nas classes de receber a pagar
end;

function TRegistroFinanceiro.localiza(codigo: Integer): Boolean;
begin
   // realizado nas classes de receber a pagar
end;

function TRegistroFinanceiro.altera(codigo: integer): Boolean;
begin
   // realizado nas classes de receber a pagar
end;

function TRegistroFinanceiro.exclui(codigo: integer): Boolean;
begin
    // realizado nas classes de receber a pagar
end;

function TRegistroFinanceiro.fixacodigoCredito: Boolean;
begin
     // realizado nas classes de receber a pagar
end;

function TRegistroFinanceiro.fixacodigoDebito: Boolean;
begin
     // realizado nas classes de receber a pagar
end;

procedure TRegistroFinanceiro.setPlano(AValue: integer);
begin
  FPlano:=AValue;
end;

procedure TRegistroFinanceiro.setPlano(AValue: string);
begin
  FPlano := StrToIntDef(AValue,0);
end;

function TRegistroFinanceiro.getPlano: integer;
begin
  result := FPlano;
end;

procedure TRegistroFinanceiro.setDtLancamento(AValue: TDate);
begin
  FDtLancamento:=AValue;
end;

procedure TRegistroFinanceiro.setDtLancamento(AValue: string);
begin
  try
    FDtLancamento:=StrToDate(AValue);
  except
    ShowMessage('Data inválida');
  end;
end;

function TRegistroFinanceiro.getDtLancamento: TDate;
begin
  result := FDtLancamento;
end;

procedure TRegistroFinanceiro.setDtPagamento(AValue: TDate);
begin
 FDtPagamento:=AValue;
end;

procedure TRegistroFinanceiro.setDtPagamento(AValue: string);
begin
  try
    FDtPagamento:=StrToDate(AValue);
  except
    ShowMessage('Data inválida');
  end;
end;

function TRegistroFinanceiro.getDtpagamento: TDate;
begin
  result := FDtPagamento;
end;

end.

