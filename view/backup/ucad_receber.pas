unit ucad_receber;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, DBGrids, StdCtrls,
  DateTimePicker, ACBrEnterTab, rxtooledit, rxcurredit, DB, ZDataset,
ucad_padrao, classe_plano, classe_contareceber, LCLType, MaskEdit,upesquisa ;

type

  { Tfrmcad_receber }

  Tfrmcad_receber = class(Tfrmcad_padrao)
    ACBrEnterTab1: TACBrEnterTab;
    edtDATATESTE: TEdit;
    edtCodPlano: TEdit;
    edtDataVencimento: TDateTimePicker;
    edtIdLcto: TEdit;
    edtDataLcto: TDateTimePicker;
    edtDesc: TEdit;
    edtDescPlano: TEdit;
    edtDtLancamento1: TRxDateEdit;
    edtRecebido: TEdit;
    DBGrid1: TDBGrid;
    dsPESQ: TDataSource;
    edtTipo: TEdit;
    edtSituacao: TEdit;
    edtValor: TCurrencyEdit;
    edtValorRecebido: TCurrencyEdit;
    Label1: TLabel;
    Label10: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
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
    procedure btNCANCELAClick(Sender: TObject);
    procedure btnINCLUIClick(Sender: TObject);
    procedure btnPESQUISAClick(Sender: TObject);
    procedure btnSALVAClick(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure edtCodPlanoExit(Sender: TObject);
    procedure edtCodPlanoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public

  end;

var
  frmcad_receber: Tfrmcad_receber;
  oContaReceber : TContaReceber;
  oPlano : Tplano;


implementation

{$R *.lfm}

{ Tfrmcad_receber }

procedure Tfrmcad_receber.btnPESQUISAClick(Sender: TObject);
begin
  if qrPESQ.Active then qrPESQ.Close;
  qrPESQ.SQL.Clear;
  qrPESQ.sql.Add('select * from receber');
  qrPESQ.sql.add('where Descricao like :cPESQ');
  qrPESQ.ParamByName('cPESQ').AsString:= '%'+trim(edtPESQUISA.Text+'%');
  try
    qrPESQ.Open;
  except
    on e: exception do
       ShowMessage('Erro ao realizar a pesquisa'+sLineBreak+
       e.ClassName+sLineBreak+ e.Message);
  end;
  if qrPESQ.RecordCount <= 0 then
     ShowMessage('Nenhum registro encontrado !');
  cliqueBotao := cbNone;
end;

procedure Tfrmcad_receber.btnSALVAClick(Sender: TObject);
begin
  inherited;
  oContaReceber.Id_Registro  := StrToIntDef(edtIdLcto.Text,0);
  oContaReceber.Descricao    := edtDesc.Text;
  oContaReceber.Plano        := edtCodPlano.Text;
  oContaReceber.DtLancamento := edtDATATESTE.Text;
  //oContaReceber.DtLancamento := edtDataLcto.Date;
  oContaReceber.Valor        := edtValor.Value;
  oContaReceber.DtVencimento := edtDataVencimento.Date;
  if cliqueBotao = cbAlterar then
     oContaReceber.altera(oContaReceber.Id_Registro)
  else if cliqueBotao = cbIncluir then
     begin
        oContaReceber.ValorPago :=0;
        oContaReceber.Situacao  :='P';
        oContaReceber.incluir;
     end;
  cliqueBotao:=cbNone;
  if qrPESQ.Active then
     qrPESQ.Refresh;
  PageControl1.PageIndex:=0;
end;

procedure Tfrmcad_receber.DBGrid1DblClick(Sender: TObject);
begin
  if oContaReceber.localiza(qrPESQid_receber.Value) then
     begin
       PageControl1.PageIndex := 1;
       edtIdLcto.Text         := inttostr(oContaReceber.Id_Registro);
       edtDesc.Text           := oContaReceber.descricao;
       edtCodPlano.Text       := inttostr(oContaReceber.Plano);
       edtDataLcto.Date       := oContaReceber.DtLancamento;
       edtValor.Value         := oContaReceber.Valor;
       edtDataVencimento.Date := oContaReceber.DtVencimento;
       edtValorRecebido.Value := oContaReceber.ValorPago;
       edtSituacao.Text       := oContaReceber.Situacao;
       if StrToIntDef(edtCodPlano.Text,0)>0 then
          begin
            if oPlano.localiza(StrToIntDef(edtCodPlano.Text,0)) then
               begin
                 edtDescPlano.Text:=oPlano.descricao;
                 edtTipo.Text := oPlano.tipo;
                 if StrToInt(edtCodPlano.Text) = 99990 then
                    begin
                      ShowMessage('Plano inválido !');
                      abort;
                    end

               end;
          end


     end;
end;

procedure Tfrmcad_receber.edtCodPlanoExit(Sender: TObject);
begin
  if StrToIntDef(edtCodPlano.Text,0)>0 then
     begin
       if oPlano.localiza(StrToIntDef(edtCodPlano.Text,0)) then
          begin
            edtDescPlano.Text:=oPlano.descricao;
            edtTipo.Text := oPlano.tipo;
            if StrToInt(edtCodPlano.Text) = 99990 then
               begin
                 ShowMessage('Plano inválido !');
                 abort;
               end

          end;
     end
  else
     begin
       ShowMessage('Código invalido !');
       edtCodPlano.SetFocus;
     end;
end;

procedure Tfrmcad_receber.edtCodPlanoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  If key = VK_F4 then
     begin
        frmPesquisa := TfrmPesquisa.
        Create(self,['ID_PLANO','DESCRICAO','TIPO'],
                                                 'PLANOS',
                                                 'ID_PLANO');
        TRY
          frmPesquisa.ShowModal;
          edtCodPlano.text:= frmPesquisa.edtResultado.Text;
        finally
          if Assigned(frmPesquisa) then
             FreeAndNil(frmPesquisa);
        end;
     end;

end;

procedure Tfrmcad_receber.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  if Assigned(oContaReceber) then
     FreeAndNil(oContaReceber);

  if Assigned(oPlano) then
     FreeAndNil(oPlano);

  if qrPESQ.Active then
     qrPESQ.close;


end;


procedure Tfrmcad_receber.FormCreate(Sender: TObject);
begin
  oContaReceber := TContaReceber.Create;
  oPlano := Tplano.Create;
end;

procedure Tfrmcad_receber.FormShow(Sender: TObject);
begin
 inherited;
 if not qrPESQ.Active then
    qrPESQ.Open;
end;

procedure Tfrmcad_receber.btnINCLUIClick(Sender: TObject);
begin
  inherited;
end;

procedure Tfrmcad_receber.btnALTERAClick(Sender: TObject);
begin
  if strtointdef(edtIdLcto.Text,0) = 0 then
     begin
       ShowMessage('nenhum registro selecionado');
       CliqueBotao := cbNone;
       Abort;
     end;
  inherited;
end;

procedure Tfrmcad_receber.btnAPAGAClick(Sender: TObject);
begin
  if strtointdef(edtIdLcto.Text,0) = 0 then
     begin
       ShowMessage('nenhum registro selecionado');
       cliqueBotao := cbNone;
       Abort;
     end;

  if QuestionDlg('Confirmação','Excluir o registro',mtConfirmation,
    [mrYes,'Sim', mrNo,'Não'],0) = mrYes then
       oContaReceber.exclui(oContaReceber.Id_Registro);
  inherited;
  cliqueBotao := cbNone;
  qrPESQ.Refresh;
  PageControl1.PageIndex := 0;
end;

procedure Tfrmcad_receber.btNCANCELAClick(Sender: TObject);
begin
  inherited;
end;

end.

