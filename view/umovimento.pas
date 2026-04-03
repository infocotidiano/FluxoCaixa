unit umovimento;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  EditBtn, Buttons, DBGrids, ZDataset, rxcurredit, PReport, LR_Class, LR_DBSet, DB, LCLType, ComCtrls,
  ACBrEnterTab, utabela, ucad_lcto,
  classe_conta,  upesquisa, uEstatistica_Despesa, upesquisa_lcto, importa, urel_movimento,
  ACBrUtil.Base, classe_lancamento;

type

  { Tfrmmovimento }

  Tfrmmovimento = class(TForm)
    ACBrEnterTab1: TACBrEnterTab;
    btnImportaExtrato: TSpeedButton;
    btnPesquisa: TBitBtn;
    btnINCLUI: TSpeedButton;
    btnOK: TButton;
    dsFuturo: TDataSource;
    dbgMvto: TDBGrid;
    dbgFuturo: TDBGrid;
    dsEstatistica: TDataSource;
    dsMvto: TDataSource;
    dtFIM: TDateEdit;
    dtINICIO: TDateEdit;
    edtCOD: TEdit;
    edtDESC: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    nSaldoAnterior: TCurrencyEdit;
    nSaldoFuturo: TCurrencyEdit;
    nSaldoPeriodo: TCurrencyEdit;
    PageControl1: TPageControl;
    Panel1: TPanel;
    Panel10: TPanel;
    Panel11: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    pnpTITULO: TPanel;
    qrEstatisticaDescricao: TStringField;
    qrEstatisticaPercentual: TFloatField;
    qrEstatisticaPlano: TLongintField;
    qrEstatisticaSubTotal: TFloatField;
    qrFuturodata_mvto: TDateField;
    qrFuturodescricao: TStringField;
    qrFuturodescricao_1: TStringField;
    qrFuturoid_lcto: TLongintField;
    qrFuturoplano: TLongintField;
    qrFuturovalor: TFloatField;
    qrMvto: TZQuery;
    qrMvtodata_mvto: TDateField;
    qrMvtodescricao: TStringField;
    qrMvtoid_lcto: TLongintField;
    qrMvtoplano: TStringField;
    qrMvtosaldoatual: TFloatField;
    qrMvtovalor: TFloatField;
    btnImprime: TSpeedButton;
    btnEstatisticaDespesas: TSpeedButton;
    qrEstatistica: TZQuery;
    tbMvto: TTabSheet;
    tbFuturo: TTabSheet;
    qrFuturo: TZQuery;
    procedure btnEstatisticaDespesasClick(Sender: TObject);
    procedure btnImportaExtratoClick(Sender: TObject);
    procedure btnImprimeClick(Sender: TObject);
    procedure btnINCLUIClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnPesquisaClick(Sender: TObject);
    procedure dtFIMExit(Sender: TObject);
    procedure edtCODExit(Sender: TObject);
    procedure edtCODKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure frReport1GetValue(const ParName: String; var ParValue: Variant);
  private
    procedure Movimento(nCOD:integer;dIncio, dFinal:TDate);
    procedure Futuro(nCOD:integer;dIncio:TDate);
    procedure Estatistica(nCOD:integer;dIncio, dFinal:TDate);
    procedure AtivaMovimento;
    procedure AtualizaSaldos;
    procedure fechaMovimento;
  public

  end;

var
  frmmovimento: Tfrmmovimento;
  conta : Tconta;


implementation

{$R *.lfm}

{ Tfrmmovimento }

procedure Tfrmmovimento.btnINCLUIClick(Sender: TObject);
begin
  frmcad_lcto := Tfrmcad_lcto.Create(self);
  try
    frmcad_lcto.edtConta.Text:=edtCOD.Text;
    frmcad_lcto.edtDescConta.Text:=edtDESC.Text;
    frmcad_lcto.ShowModal;
  finally
    FreeAndNil(frmcad_lcto);
  end;
  AtualizaSaldos;
end;

procedure Tfrmmovimento.btnOKClick(Sender: TObject);
begin
  AtivaMovimento;
end;

procedure Tfrmmovimento.btnPesquisaClick(Sender: TObject);
begin
  Frmpesquisa_lcto := TFrmpesquisa_lcto.Create(self);
  try
    Frmpesquisa_lcto.ShowModal;
  finally
    FreeAndNil(Frmpesquisa_lcto);
  end;
end;

procedure Tfrmmovimento.dtFIMExit(Sender: TObject);
begin
  // Evita reentrada de foco no GTK/Linux.
end;

procedure Tfrmmovimento.btnEstatisticaDespesasClick(Sender: TObject);
begin
  frmEstatistica_Despesa := TfrmEstatistica_Despesa.Create(self);
  try
    Estatistica( StrToIntDef(edtCOD.Text,0),
                 dtINICIO.Date,
                 dtFIM.Date);
    frmEstatistica_Despesa.ShowModal;
  finally
    FreeAndNil(frmEstatistica_Despesa);
    if qrEstatistica.Active then
       qrEstatistica.Close;
  end;

end;

procedure Tfrmmovimento.btnImportaExtratoClick(Sender: TObject);
begin
  if not Assigned(conta) then
     begin
       ShowMessage('Conta nao foi inicializada.');
       Abort;
     end;

  if not conta.localiza(StrToIntDef(edtCOD.Text,0)) then
     begin
        ShowMessage('Inicie o movimento e clique OK');
        abort;
     end;
  frmImporta := TfrmImporta.Create(self);
  try
    frmImporta.edtCodConta.Text:=edtCOD.Text;
    frmImporta.edtAgencia.Text:=conta.agencia;
    frmImporta.edtNumConta.Text:=conta.conta;
    frmImporta.edtNumBanco.Text:=conta.banco;
    frmImporta.ShowModal;
  finally
    FreeAndNil(frmImporta);
  end;
  AtualizaSaldos;
end;

procedure Tfrmmovimento.btnImprimeClick(Sender: TObject);
begin
  frmrel_movimento := Tfrmrel_movimento.Create(self);
  try
    frmrel_movimento.lSaldoAnterior.Caption   :='Saldo Anterior: R$ '+FormatFloatBr(msk13x2 ,nSaldoAnterior.Value);
    frmrel_movimento.lSaldoAtual.Caption      :='Saldo Atual Período: R$ '+FormatFloatBr(msk13x2 ,nSaldoPeriodo.Value);
    frmrel_movimento.lPeriodo.Caption:='Período de '+dtINICIO.Text+' até '+dtFIM.Text;
    frmrel_movimento.lCONTA.Caption  :='Conta: '+edtCOD.Text+' - '+edtDESC.Text;
    frmrel_movimento.RLReport1.PreviewModal;
  finally
    FreeAndNil(frmrel_movimento);
  end;
end;



procedure Tfrmmovimento.edtCODExit(Sender: TObject);
begin
   if not Assigned(conta) then
      conta := Tconta.Create;

   if conta.localiza(StrToIntDef(edtCOD.Text,0)) then
      edtDESC.Text:=conta.descricao
   else
      edtDESC.Text:='';

end;

procedure Tfrmmovimento.edtCODKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  If key = VK_F4 then
     begin
        frmPesquisa := TfrmPesquisa.
        Create(self,['ID_CONTA','DESCRICAO','BANCO','CONTA'],
                                                 'CONTAS',
                                                 'ID_CONTA');
        TRY
          frmPesquisa.ShowModal;
          edtCOD.text:= frmPesquisa.edtResultado.Text;
        finally
          if Assigned(frmPesquisa) then
             FreeAndNil(frmPesquisa);
        end;
     end;
end;

procedure Tfrmmovimento.FormClose(Sender: TObject; var CloseAction: TCloseAction
  );
begin
  fechaMovimento;
  if Assigned(conta) then
      FreeAndNil(conta);
end;

procedure Tfrmmovimento.FormCreate(Sender: TObject);
begin
  conta := Tconta.Create;
end;

procedure Tfrmmovimento.FormShow(Sender: TObject);
begin
  dtINICIO.Date:=date -30;
  dtFIM.Date   :=date;
  edtCOD.SetFocus;
end;

procedure Tfrmmovimento.frReport1GetValue(const ParName: String;
  var ParValue: Variant);
begin
  if ParName = 'conta' then
     ParValue:=edtCOD.Text+' - '+edtDESC.Text;
  if ParName = 'periodo' then
     ParValue:= ' de '+DateToStr(dtINICIO.Date)+' até '+DateToStr(dtFIM.Date);
  if ParName = 'saldoinicial' then
     ParValue:= FloatToStr(nSaldoAnterior.Value);
  if ParName = 'saldofinal' then
     ParValue:= FloatToStr(nSaldoPeriodo.Value);

end;


procedure Tfrmmovimento.Movimento(nCOD: integer; dIncio, dFinal: TDate);
var
  cSQL : string;
  nSA  : Real;  // saldo anterior
  oLancamento: Tlancamento;
begin
  //-------------------------------------------->> Definir valor da variavel saldo anteior
  // se a tabela qrMvto estiver aberta. feche
  if qrMvto.Active then qrMvto.Close;
  // limpa os comandos sql da qrmovto
  qrMvto.sql.Clear;
  // nSA (Saldo Anterior) vai receber o saldo anterior da função lancamento.saldoanterior
  oLancamento := Tlancamento.Create;
  try
    nSA:= oLancamento.SaldoAnterior(StrToIntDef(edtCOD.Text,0),
                                    dtINICIO.Date);
  finally
    FreeAndNil(oLancamento);
  end;
  // vamos alimentar a variavel @saldo com o valor da variavel nSA (saldo anterior)
  qrMvto.sql.add('set @saldo := :nSaldoAnt');
  qrMvto.ParamByName('nSaldoAnt').AsFloat:=nSA;
  // executamos a query para definir o Saldo anteior
  qrMvto.ExecSQL;
  //--------------------------------------------> Selecionar registros exibindo calculo saldo anterior
  // se a tabela qrMvto estiver aberta. feche
  if qrMvto.Active then
     qrMvto.Close;
  qrMvto.sql.Clear;
  //Vamos criar a consulta SQL utilizando codigo conta e periodo
  cSQL:='select l.id_lcto, l.data_mvto,p.descricao plano, '+
        'l.descricao , l.valor, '+
        '(@saldo := @saldo + l.valor) SaldoAtual '+
        'from lancamentos l '+
        'join planos p on p.id_plano = l.plano '+
        'where l.conta = :nCOD '+
        'and l.data_mvto between :dINICIO and :dFINAL';
  //alimentamos a query com o cSQL (nossa consulta) e definimos os parametros
  qrMvto.sql.Text:=cSQL;
  qrMvto.ParamByName('nCOD').AsInteger := nCOD;
  qrMvto.ParamByName('dINICIO').AsDate := dIncio;
  qrMvto.ParamByName('dFINAL').AsDate  := dFinal;
  qrMvto.Open;
end;

procedure Tfrmmovimento.Futuro(nCOD: integer; dIncio: TDate);
var
  cSQL : string;
begin
  cSQL := 'select l.id_lcto, l.data_mvto, l.plano, '+
          'p.descricao, l.descricao, l.valor '+
          'from lancamentos l '+
          'join planos p on p.id_plano = l.plano '+
          'where l.conta = :nCOD '+
          'and l.data_mvto > :dINICIO';
  if qrFuturo.Active then
   qrFuturo.Close;
  qrFuturo.sql.Clear;
  qrFuturo.sql.Text:=cSQL;
  qrFuturo.ParamByName('nCOD').AsInteger := nCOD;
  qrFuturo.ParamByName('dINICIO').AsDate := dIncio;
  qrFuturo.Open;
  if qrFuturo.RecordCount <= 0 then
     ShowMessage('Não existem lançamentos futuros !');

end;

procedure Tfrmmovimento.Estatistica(nCOD: integer; dIncio, dFinal: TDate);
var
  cSQL : string;
begin
  cSQL:='select l.plano Plano, p.descricao Descricao, '+
  'sum(l.valor*-1) SubTotal, '+
  'sum((l.valor*-1)/tmp.total*100) Percentual '+
  'from lancamentos l '+
  'join planos p on p.id_plano = l.plano, '+
  '(select sum(valor*-1) Total '+
  'from lancamentos '+
  'where valor < 0 and conta = :nCOD '+
  'and data_mvto between :dINICIO and :dFINAL) tmp '+
  'where p.tipo  = '+QuotedStr('D')+' and l.conta = :nCOD '+
  'and l.data_mvto between :dINICIO and :dFINAL '+
  'group by l.plano, p.descricao '+
  'order by p.descricao';

  if qrEstatistica.Active then
     qrEstatistica.Close;
  qrEstatistica.sql.Clear;
  qrEstatistica.sql.Text:=cSQL;
  qrEstatistica.ParamByName('nCOD').AsInteger := nCOD;
  qrEstatistica.ParamByName('dINICIO').AsDate := dIncio;
  qrEstatistica.ParamByName('dFINAL').AsDate  := dFinal;
  qrEstatistica.Open;

end;

procedure Tfrmmovimento.AtivaMovimento;
var
  oLancamento: Tlancamento;
begin
  if not Assigned(conta) then
     begin
       ShowMessage('Conta nao foi inicializada.');
       Abort;
     end;

  if not conta.localiza(StrToIntDef(edtCOD.Text,0)) then
     begin
       ShowMessage('Conta Inválida !');
       abort;
     end;

  if dtINICIO.Date > dtFIM.Date then
   begin
    ShowMessage('A data inicial não pode ser MAIOR que a data Final!');
    abort;
   end;

  oLancamento := Tlancamento.Create;
  try
    nSaldoAnterior.Value:= oLancamento.SaldoAnterior(StrToIntDef(edtCOD.Text,0),
                                                     dtINICIO.Date);
    nSaldoPeriodo.Value  := oLancamento.SaldoAnterior(StrToIntDef(edtCOD.Text,0),
                                                      dtINICIO.Date)+
                            oLancamento.SaldoPeriodo(StrToIntDef(edtCOD.Text,0),
                                                     dtINICIO.Date,
                                                     dtFIM.Date);
    nSaldoFuturo.Value:= oLancamento.SaldoFuturo(StrToIntDef(edtCOD.Text,0),
                                                 Date);
  finally
    FreeAndNil(oLancamento);
  end;


  Movimento(StrToIntDef(edtCOD.Text,0),dtINICIO.Date, dtFIM.Date);
  Futuro(StrToIntDef(edtCOD.Text,0),Date);

  if qrMvto.RecordCount > 0 then
      begin
         dbgMvto.SetFocus;
         qrMvto.Last;
      end
  else
      begin
        ShowMessage('Não existe lançamentos no período !');
        edtCOD.SetFocus;
      end;

end;

procedure Tfrmmovimento.AtualizaSaldos;
var
  oLancamento: Tlancamento;
begin
  if not Assigned(conta) then
     begin
       ShowMessage('Conta nao foi inicializada.');
       Abort;
     end;

  if not conta.localiza(StrToIntDef(edtCOD.Text,0)) then
     begin
       ShowMessage('Conta Inválida !');
       abort;
     end;

  if dtINICIO.Date > dtFIM.Date then
   begin
    ShowMessage('A data inicial não pode ser MAIOR que a data Final!');
    abort;
   end;

  oLancamento := Tlancamento.Create;
  try
    nSaldoAnterior.Value:= oLancamento.SaldoAnterior(StrToIntDef(edtCOD.Text,0),
                                                     dtINICIO.Date);
    nSaldoPeriodo.Value  := oLancamento.SaldoAnterior(StrToIntDef(edtCOD.Text,0),
                                                      dtINICIO.Date)+
                            oLancamento.SaldoPeriodo(StrToIntDef(edtCOD.Text,0),
                                                     dtINICIO.Date,
                                                     dtFIM.Date);
  finally
    FreeAndNil(oLancamento);
  end;

  qrMvto.Refresh;

end;

procedure Tfrmmovimento.fechaMovimento;
begin
  if qrMvto.Active then
     qrMvto.Close;
  nSaldoAnterior.Value:=0;
  nSaldoPeriodo.Value:=0;
end;

end.
