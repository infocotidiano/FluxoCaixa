unit ucad_receber;
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
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, DBGrids, StdCtrls,
  DateTimePicker, ACBrEnterTab, rxtooledit, rxcurredit, DB, ZDataset,
  ucad_padrao, classe_plano, classe_contareceber, LCLType, MaskEdit, ExtCtrls,
  upesquisa, classe_conta, classe_lancamento, classe_entidade;

type

  { Tfrmcad_receber }

  Tfrmcad_receber = class(Tfrmcad_padrao)
    ACBrEnterTab1: TACBrEnterTab;
    btnRECEBER: TButton;
    btnRecOK: TButton;
    btnRecCancel: TButton;
    cbxFiltroStatus: TComboBox;
    edtCodEntidade: TEdit;
    edtDescEntidade: TEdit;
    Label16: TLabel;
    Label17: TLabel;
    nValREC: TCurrencyEdit;
    DatREC: TDateTimePicker;
    edtCodPlano: TEdit;
    edtContaDestinoREC: TEdit;
    edtDataRecebimento: TDateTimePicker;
    edtDataVencimento: TDateTimePicker;
    edtDescDestinoREC: TEdit;
    edtIdLcto: TEdit;
    edtDataLcto: TDateTimePicker;
    edtDesc: TEdit;
    edtDescPlano: TEdit;
    edtDtLancamento1: TRxDateEdit;
    edtRecebido: TEdit;
    DBGrid1: TDBGrid;
    dsPESQ: TDataSource;
    edtSituacao: TEdit;
    edtTipo: TEdit;
    edtValor: TCurrencyEdit;
    edtValorRecebido: TCurrencyEdit;
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
    pnpRECEBER: TPanel;
    Panel3: TPanel;
    qrPESQ: TZQuery;
    qrPESQdescricao: TStringField;
    qrPESQdtlancamento: TDateField;
    qrPESQdtvencimento: TDateField;
    qrPESQid_receber: TLongintField;
    qrPESQplano: TLongintField;
    qrPESQsituacao: TStringField;
    qrPESQvalor: TFloatField;
    qrPESQvalorrecebido: TFloatField;
    procedure btnALTERAClick(Sender: TObject);
    procedure btnAPAGAClick(Sender: TObject);
    procedure btnINCLUIClick(Sender: TObject);
    procedure btnPESQUISAClick(Sender: TObject);
    procedure btnRecCancelClick(Sender: TObject);
    procedure btnRECEBERClick(Sender: TObject);
    procedure btnRecOKClick(Sender: TObject);
    procedure btnSALVAClick(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure edtCodEntidadeExit(Sender: TObject);
    procedure edtCodEntidadeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
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
    FContaReceber: TContaReceber;
    FPlano: Tplano;
    FConta: Tconta;
    FEntidade : TEntidade;
    procedure ExibePainelReceber(lFlag: boolean);
    procedure AlimentaCamposFormulario(AIdLancamento:Integer);
  public

  end;

var
  frmcad_receber: Tfrmcad_receber;


implementation

{$R *.lfm}

{ Tfrmcad_receber }

procedure Tfrmcad_receber.btnPESQUISAClick(Sender: TObject);
var
  LStatus: string;
begin
  if qrPESQ.Active then qrPESQ.Close;
  qrPESQ.SQL.Clear;
  qrPESQ.sql.Add('select * from receber');
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

procedure Tfrmcad_receber.btnRecCancelClick(Sender: TObject);
begin
  ExibePainelReceber(False);
end;

procedure Tfrmcad_receber.btnRECEBERClick(Sender: TObject);
begin
  if FContaReceber.Situacao = 'P' then
  begin
    DatREC.date := now;
    ExibePainelReceber(True);
  end
  else
    ShowMessage('A conta já foi recebida e lançada no movimento');
end;

procedure Tfrmcad_receber.btnRecOKClick(Sender: TObject);
var
  LLancamento: Tlancamento;
  LIdLancamento : Integer;
begin
  LLancamento := Tlancamento.Create;
  try
    LLancamento.conta := StrToIntDef(edtContaDestinoREC.Text, 0);
    LLancamento.data_mvto := DatREC.Date;
    LLancamento.cod_plano := StrToIntDef(edtCodPlano.Text, 0);
    LLancamento.descricao := edtDesc.Text;
    LLancamento.valor := nValREC.Value;
    if LLancamento.inclui then
    begin
      FContaReceber.DtPagamento := DatREC.Date;
      FContaReceber.ValorPago := nValREC.Value;
      FContaReceber.Situacao := 'B';
      FContaReceber.CodConta := StrToIntDef(edtContaDestinoREC.Text, 0);
      FContaReceber.altera(FContaReceber.Id_Registro);
    end;
  finally
    FreeAndNil(LLancamento);
  end;
  ExibePainelReceber(False);

  LIdLancamento := StrToIntDef(edtIdLcto.text,0);
  AlimentaCamposFormulario(LIdLancamento);

  if qrPESQ.Active then
    qrPESQ.Refresh;
end;

procedure Tfrmcad_receber.btnSALVAClick(Sender: TObject);
begin
  inherited;
  FContaReceber.Id_Registro := StrToIntDef(edtIdLcto.Text, 0);
  FContaReceber.Descricao := edtDesc.Text;
  FContaReceber.Plano := edtCodPlano.Text;
  FContaReceber.DtLancamento := edtDataLcto.Date;
  FContaReceber.Valor := edtValor.Value;
  FContaReceber.DtVencimento := edtDataVencimento.Date;
  FContaReceber.Entidade:= StrToIntDef(edtCodEntidade.Text,0);
  if cliqueBotao = cbAlterar then
    FContaReceber.altera(FContaReceber.Id_Registro)
  else if cliqueBotao = cbIncluir then
  begin
    FContaReceber.ValorPago := 0;
    FContaReceber.Situacao := 'P';
    FContaReceber.incluir;
  end;
  cliqueBotao := cbNone;
  if qrPESQ.Active then
    qrPESQ.Refresh;
  PageControl1.PageIndex := 0;
end;

procedure Tfrmcad_receber.DBGrid1DblClick(Sender: TObject);
begin

  AlimentaCamposFormulario(qrPESQid_receber.Value);

end;

procedure Tfrmcad_receber.edtCodEntidadeExit(Sender: TObject);
begin
  if StrToIntDef(edtCodEntidade.Text, 0) > 0 then
  begin
    if FEntidade.localiza(StrToIntDef(edtCodEntidade.Text, 0)) then
      edtDescEntidade.Text := FEntidade.Nome
    else
    begin
      edtDescEntidade.Text := '';
      ShowMessage('Entidade não Localizada.');
    end;
  end
  else
  begin
    edtDescEntidade.Text := '';
    ShowMessage('Entidade invalida !');
  end;

end;

procedure Tfrmcad_receber.edtCodEntidadeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key = VK_F4 then
  begin
    frmPesquisa := TfrmPesquisa.Create(self, ['id_entidade', 'nome', 'telefone'],
      'entidades', 'id_entidade');
    try
      frmPesquisa.ShowModal;
      edtCodEntidade.Text := frmPesquisa.edtResultado.Text;
    finally
      if Assigned(frmPesquisa) then
        FreeAndNil(frmPesquisa);
    end;
  end;

end;

procedure Tfrmcad_receber.edtCodPlanoExit(Sender: TObject);
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

procedure Tfrmcad_receber.edtCodPlanoKeyDown(Sender: TObject;
  var Key: word; Shift: TShiftState);
begin
  if key = VK_F4 then
  begin
    frmPesquisa := TfrmPesquisa.Create(self, ['id_plano', 'descricao', 'tipo'],
      'planos', 'id_plano');
    try
      frmPesquisa.ShowModal;
      edtCodPlano.Text := frmPesquisa.edtResultado.Text;
    finally
      if Assigned(frmPesquisa) then
        FreeAndNil(frmPesquisa);
    end;
  end;

end;

procedure Tfrmcad_receber.edtContaDestinoRECExit(Sender: TObject);
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

procedure Tfrmcad_receber.edtContaDestinoRECKeyDown(Sender: TObject;
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

procedure Tfrmcad_receber.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if Assigned(FContaReceber) then
    FreeAndNil(FContaReceber);

  if Assigned(FPlano) then
    FreeAndNil(FPlano);

  if Assigned(FConta) then
    FreeAndNil(FConta);

  if Assigned(FEntidade) then
    FreeAndNil(FEntidade);


  if qrPESQ.Active then
    qrPESQ.Close;

end;


procedure Tfrmcad_receber.FormCreate(Sender: TObject);
begin
  FContaReceber := TContaReceber.Create;
  FPlano := Tplano.Create;
  FConta := Tconta.Create;
  FEntidade := TEntidade.Create;
  ExibePainelReceber(False);
end;

procedure Tfrmcad_receber.FormShow(Sender: TObject);
begin
  inherited;
  if not qrPESQ.Active then
    qrPESQ.Open;

end;

procedure Tfrmcad_receber.ExibePainelReceber(lFlag: boolean);
begin
  pnpRECEBER.Visible := lFlag;
  if pnpRECEBER.Visible then
    pnpRECEBER.Left := 0
  else
    pnpRECEBER.Left := 750;

end;

procedure Tfrmcad_receber.AlimentaCamposFormulario(AIdLancamento: Integer);
begin

  if AIdLancamento <= 0 then
     raise Exception.Create('Id Lançamento não informado');

  if FContaReceber.localiza(AIdLancamento) then
  begin
    PageControl1.PageIndex := 1;
    edtIdLcto.Text := IntToStr(FContaReceber.Id_Registro);
    edtDesc.Text := FContaReceber.descricao;
    edtCodPlano.Text := IntToStr(FContaReceber.Plano);
    edtDataLcto.Date := FContaReceber.DtLancamento;
    edtValor.Value := FContaReceber.Valor;
    edtDataVencimento.Date := FContaReceber.DtVencimento;
    edtDataRecebimento.Date := FContaReceber.DtPagamento;
    edtValorRecebido.Value := FContaReceber.ValorPago;
    edtSituacao.Text := FContaReceber.Situacao;
    edtCodEntidade.Text := IntToStr(FContaReceber.Entidade);
    // localiza descricao plano
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
    //localiza descricao entidade
    if StrToIntDef(edtCodEntidade.Text, 0) > 0 then
    begin
      if FEntidade.localiza(StrToIntDef(edtCodEntidade.Text, 0)) then
        edtDescEntidade.Text := FEntidade.Nome
      else
        edtDescEntidade.Text :='Entidade inválida';
    end
    else
      edtDescEntidade.Text := EmptyStr;

  end;


end;

procedure Tfrmcad_receber.btnINCLUIClick(Sender: TObject);
begin
  inherited;
  edtDataLcto.Date := now;
  edtDataVencimento.Date := now;
end;

procedure Tfrmcad_receber.btnALTERAClick(Sender: TObject);
begin
  if strtointdef(edtIdLcto.Text, 0) = 0 then
  begin
    ShowMessage('nenhum registro selecionado');
    CliqueBotao := cbNone;
    Abort;
  end;
  inherited;
end;

procedure Tfrmcad_receber.btnAPAGAClick(Sender: TObject);
begin
  if (strtointdef(edtIdLcto.Text, 0) = 0) or (FContaReceber.Situacao = 'B') then
  begin
    if FContaReceber.Situacao = 'B' then
      ShowMessage('Esta contá foi recebida e lançada no movimento' +
        sLineBreak + 'Impossivel excluir !')
    else
      ShowMessage('nenhum registro selecionado');
    cliqueBotao := cbNone;
    Abort;
  end;

  if QuestionDlg('Confirmação', 'Excluir o registro', mtConfirmation,
    [mrYes, 'Sim', mrNo, 'Não'], 0) = mrYes then
    FContaReceber.exclui(FContaReceber.Id_Registro);
  inherited;
  cliqueBotao := cbNone;
  qrPESQ.Refresh;
  PageControl1.PageIndex := 0;
end;

end.
