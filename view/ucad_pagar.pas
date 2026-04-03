unit ucad_pagar;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, DBGrids, StdCtrls,
  DateTimePicker, ucad_padrao, ACBrEnterTab, rxcurredit, DB, ZDataset,
  ZAbstractRODataset, classe_conta, classe_plano, classe_contapagar,
  classe_lancamento, upesquisa, LCLType, ExtCtrls;

type

  { Tfrmcad_pagar }

  Tfrmcad_pagar = class(Tfrmcad_padrao)
    ACBrEnterTab1: TACBrEnterTab;
    btnPAGAR: TButton;
    btnRecCancel: TButton;
    btnRecOK: TButton;
    cbxFiltroStatus: TComboBox;
    DatPAG: TDateTimePicker;
    DBGrid1: TDBGrid;
    dsPESQ: TDataSource;
    edtCodPlano: TEdit;
    edtContaDestinoREC: TEdit;
    edtDataLcto: TDateTimePicker;
    edtDataPagamento: TDateTimePicker;
    edtDataVencimento: TDateTimePicker;
    edtDesc: TEdit;
    edtDescDestinoREC: TEdit;
    edtDescPlano: TEdit;
    edtIdLcto: TEdit;
    edtSituacao: TEdit;
    edtTipo: TEdit;
    edtValor: TCurrencyEdit;
    edtValorPago: TCurrencyEdit;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    nValPAG: TCurrencyEdit;
    Panel3: TPanel;
    pnpPAGAR: TPanel;
    qrPESQ: TZQuery;
    qrPESQcodconta: TZIntegerField;
    qrPESQdescricao: TZRawStringField;
    qrPESQdtlancamento: TZDateField;
    qrPESQdtrecebimento: TZDateField;
    qrPESQdtvencimento: TZDateField;
    qrPESQid_pagar: TZIntegerField;
    qrPESQplano: TZIntegerField;
    qrPESQsituacao: TZRawStringField;
    qrPESQvalor: TZBCDField;
    qrPESQvalorpago: TZBCDField;
    procedure btnALTERAClick(Sender: TObject);
    procedure btnAPAGAClick(Sender: TObject);
    procedure btnINCLUIClick(Sender: TObject);
    procedure btnPAGARClick(Sender: TObject);
    procedure btnPESQUISAClick(Sender: TObject);
    procedure btnRecCancelClick(Sender: TObject);
    procedure btnRecOKClick(Sender: TObject);
    procedure btnSALVAClick(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure edtCodPlanoExit(Sender: TObject);
    procedure edtCodPlanoKeyDown(Sender: TObject; var Key: word;
      Shift: TShiftState);
    procedure edtContaDestinoRECExit(Sender: TObject);
    procedure edtContaDestinoRECKeyDown(Sender: TObject; var Key: word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    FContaPagar: TContapagar;
    FPlano: Tplano;
    FConta: Tconta;
    procedure ExibePainelPagar(lFlag: boolean);
  public

  end;

var
  frmcad_pagar: Tfrmcad_pagar;

implementation

{$R *.lfm}

{ Tfrmcad_pagar }

procedure Tfrmcad_pagar.edtCodPlanoExit(Sender: TObject);
begin
  if StrToIntDef(edtCodPlano.Text, 0) > 0 then
  begin
    if FPlano.localiza(StrToIntDef(edtCodPlano.Text, 0)) then
    begin
      edtDescPlano.Text := FPlano.descricao;
      edtTipo.Text := FPlano.tipo;
      if StrToIntDef(edtCodPlano.Text, 0) = 99990 then
        ShowMessage('Plano invalido !');
    end
    else
    begin
      edtDescPlano.Text := '';
      edtTipo.Text := '';
      ShowMessage('Plano nao localizado.');
    end;
  end
  else
  begin
    edtDescPlano.Text := '';
    edtTipo.Text := '';
    ShowMessage('Codigo invalido !');
  end;
end;

procedure Tfrmcad_pagar.btnINCLUIClick(Sender: TObject);
begin
  inherited;
  edtDataLcto.Date := now;
  edtDataVencimento.Date := now;
end;

procedure Tfrmcad_pagar.btnPAGARClick(Sender: TObject);
begin
  if FContaPagar.Situacao = 'P' then
  begin
    DatPAG.date := now;
    ExibePainelPagar(True);
  end
  else
    ShowMessage('A conta já foi recebida e lançada no movimento');
end;

procedure Tfrmcad_pagar.btnPESQUISAClick(Sender: TObject);
var
  LStatus: string;
begin
  if qrPESQ.Active then qrPESQ.Close;
  qrPESQ.SQL.Clear;
  qrPESQ.sql.Add('select * from pagar');
  qrPESQ.sql.add('where Situacao like :cStatus');
  case cbxFiltroStatus.ItemIndex of
    0: LStatus := '%';
    1: LStatus := 'P';
    2: LStatus := 'B';
  end;
  if trim(edtPESQUISA.Text) <> EmptyStr then
    qrPESQ.sql.add('and Descricao like :cPESQ');

  qrPESQ.ParamByName('cStatus').AsString := LStatus;

  if trim(edtPESQUISA.Text) <> EmptyStr then
    qrPESQ.ParamByName('cPESQ').AsString := '%' + trim(edtPESQUISA.Text + '%');
  try
    qrPESQ.Open;
  except
    on e: Exception do
      ShowMessage('Erro ao realizar a pesquisa' + sLineBreak +
        e.ClassName + sLineBreak + e.Message);
  end;
  if qrPESQ.RecordCount <= 0 then
    ShowMessage('Nenhum registro encontrado !');
  cliqueBotao := cbNone;

end;

procedure Tfrmcad_pagar.btnRecCancelClick(Sender: TObject);
begin
  ExibePainelPagar(False);
end;

procedure Tfrmcad_pagar.btnRecOKClick(Sender: TObject);
var
  LLancamento: Tlancamento;
begin
  LLancamento := Tlancamento.Create;
  try
    LLancamento.conta := StrToIntDef(edtContaDestinoREC.Text, 0);
    LLancamento.data_mvto := DatPAG.Date;
    LLancamento.cod_plano := StrToIntDef(edtCodPlano.Text, 0);
    LLancamento.descricao := edtDesc.Text;
    LLancamento.valor := nValPAG.Value;
    if LLancamento.inclui then
    begin
      FContaPagar.DtPagamento := DatPAG.Date;
      FContaPagar.ValorPago := nValPAG.Value;
      FContaPagar.Situacao := 'B';
      FContaPagar.CodConta := StrToIntDef(edtContaDestinoREC.Text, 0);
      FContaPagar.altera(FContaPagar.Id_Registro);
    end;
  finally
    FreeAndNil(LLancamento);
  end;
  ExibePainelPagar(False);
  if qrPESQ.Active then
    qrPESQ.Refresh;
end;

procedure Tfrmcad_pagar.btnSALVAClick(Sender: TObject);
begin
  inherited;
  FContaPagar.Id_Registro := StrToIntDef(edtIdLcto.Text, 0);
  FContaPagar.Descricao := edtDesc.Text;
  FContaPagar.Plano := edtCodPlano.Text;
  FContaPagar.DtLancamento := edtDataLcto.Date;
  FContaPagar.Valor := edtValor.Value;
  FContaPagar.DtVencimento := edtDataVencimento.Date;
  if cliqueBotao = cbAlterar then
    FContaPagar.altera(FContaPagar.Id_Registro)
  else if cliqueBotao = cbIncluir then
  begin
    FContaPagar.ValorPago := 0;
    FContaPagar.Situacao := 'P';
    FContaPagar.incluir;
  end;
  cliqueBotao := cbNone;
  if qrPESQ.Active then
    qrPESQ.Refresh;
  PageControl1.PageIndex := 0;

end;

procedure Tfrmcad_pagar.DBGrid1DblClick(Sender: TObject);
begin
  if FContaPagar.localiza(qrPESQid_pagar.Value) then
  begin
    PageControl1.PageIndex := 1;
    edtIdLcto.Text := IntToStr(FContaPagar.Id_Registro);
    edtDesc.Text := FContaPagar.descricao;
    edtCodPlano.Text := IntToStr(FContaPagar.Plano);
    edtDataLcto.Date := FContaPagar.DtLancamento;
    edtValor.Value := FContaPagar.Valor;
    edtDataVencimento.Date := FContaPagar.DtVencimento;
    edtValorPago.Value := FContaPagar.ValorPago;
    edtDataPagamento.Date := FContaPagar.DtPagamento;
    edtSituacao.Text := FContaPagar.Situacao;
    if StrToIntDef(edtCodPlano.Text, 0) > 0 then
    begin
      if FPlano.localiza(StrToIntDef(edtCodPlano.Text, 0)) then
      begin
        edtDescPlano.Text := FPlano.descricao;
        edtTipo.Text := FPlano.tipo;
        if StrToInt(edtCodPlano.Text) = 99990 then
        begin
          ShowMessage('Plano inválido !');
          abort;
        end;

      end;
    end;

  end;
end;

procedure Tfrmcad_pagar.btnALTERAClick(Sender: TObject);
begin
  if strtointdef(edtIdLcto.Text, 0) = 0 then
  begin
    ShowMessage('nenhum registro selecionado');
    CliqueBotao := cbNone;
    Abort;
  end;
  inherited;
end;

procedure Tfrmcad_pagar.btnAPAGAClick(Sender: TObject);
begin
  if (strtointdef(edtIdLcto.Text, 0) = 0) or (FContaPagar.Situacao = 'B') then
  begin
    if FContaPagar.Situacao = 'B' then
      ShowMessage('Esta contá foi paga e lançada no movimento' +
        sLineBreak + 'Impossivel excluir !')
    else
      ShowMessage('nenhum registro selecionado');
    cliqueBotao := cbNone;
    Abort;
  end;

  if QuestionDlg('Confirmação', 'Excluir o registro', mtConfirmation,
    [mrYes, 'Sim', mrNo, 'Não'], 0) = mrYes then
    FContaPagar.exclui(FContaPagar.Id_Registro);
  inherited;
  cliqueBotao := cbNone;
  qrPESQ.Refresh;
  PageControl1.PageIndex := 0;
end;

procedure Tfrmcad_pagar.edtCodPlanoKeyDown(Sender: TObject; var Key: word;
  Shift: TShiftState);
begin
  if key = VK_F4 then
  begin
    frmPesquisa := TfrmPesquisa.Create(
      self, ['ID_PLANO', 'DESCRICAO', 'TIPO'], 'PLANOS', 'ID_PLANO');
    try
      frmPesquisa.ShowModal;
      edtCodPlano.Text := frmPesquisa.edtResultado.Text;
    finally
      if Assigned(frmPesquisa) then
        FreeAndNil(frmPesquisa);
    end;
  end;
end;

procedure Tfrmcad_pagar.edtContaDestinoRECExit(Sender: TObject);
begin
  if (StrToIntDef(edtContaDestinoREC.Text, 0) > 0) then
  begin
    if FConta.localiza(StrToIntDef(edtContaDestinoREC.Text, 0)) then
      edtDescDestinoREC.Text := FConta.descricao
    else
    begin
      edtDescDestinoREC.Text := '';
      ShowMessage('Conta destino nao localizada.');
    end;
  end
  else
  begin
    edtDescDestinoREC.Text := '';
    ShowMessage('Codigo destino invalido');
  end;
end;

procedure Tfrmcad_pagar.edtContaDestinoRECKeyDown(Sender: TObject;
  var Key: word; Shift: TShiftState);
begin
  if key = VK_F4 then
  begin
    frmPesquisa := TfrmPesquisa.Create(
      self, ['ID_CONTA', 'DESCRICAO', 'BANCO', 'CONTA'], 'CONTAS', 'ID_CONTA');
    try
      frmPesquisa.ShowModal;
      edtContaDestinoREC.Text := frmPesquisa.edtResultado.Text;
    finally
      if Assigned(frmPesquisa) then
        FreeAndNil(frmPesquisa);
    end;
  end;
end;

procedure Tfrmcad_pagar.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if Assigned(FContaPagar) then
    FreeAndNil(FContaPagar);

  if Assigned(FPlano) then
    FreeAndNil(FPlano);

  if Assigned(FConta) then
    FreeAndNil(FConta);

  if qrPESQ.Active then
    qrPESQ.Close;

end;

procedure Tfrmcad_pagar.FormCreate(Sender: TObject);
begin
  FContaPagar := TContapagar.Create;
  FPlano := Tplano.Create;
  FConta := Tconta.Create;
  ExibePainelPagar(False);
end;

procedure Tfrmcad_pagar.FormShow(Sender: TObject);
begin
  inherited;
  if not qrPESQ.Active then
    qrPESQ.Open;
end;

procedure Tfrmcad_pagar.ExibePainelPagar(lFlag: boolean);
begin
  pnpPAGAR.Visible := lFlag;
  if pnpPAGAR.Visible then
    pnpPAGAR.Left := 0
  else
    pnpPAGAR.Left := 750;
end;

end.
