unit ucad_lcto;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Buttons, classe_plano, classe_lancamento, rxcurredit, DateTimePicker, LCLType,
  ACBrEnterTab, upesquisa, ucad_planoconta, classe_conta,
  DateUtils,ACBrUtil;

type

  { Tfrmcad_lcto }

  Tfrmcad_lcto = class(TForm)
    ACBrEnterTab1: TACBrEnterTab;
    btnParcela: TBitBtn;
    btnCancela: TBitBtn;
    chkParcela: TCheckBox;
    dINICIAL: TDateTimePicker;
    edtParcelas: TEdit;
    edtCodPlano: TEdit;
    edtConta: TEdit;
    edtContaDestino: TEdit;
    edtData: TDateTimePicker;
    edtDescConta: TEdit;
    edtDescDestino: TEdit;
    edtDescLcto: TEdit;
    edtDescPlano: TEdit;
    edtTipo: TEdit;
    edtValor: TCurrencyEdit;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Panel1: TPanel;
    pnpParcela: TPanel;
    pnpContaTrans: TPanel;
    pnpDescValor: TPanel;
    pnpDadosPrincipal: TPanel;
    pnpTITULO: TPanel;
    btnSALVA: TSpeedButton;
    procedure btnCancelaClick(Sender: TObject);
    procedure btnParcelaClick(Sender: TObject);
    procedure btnSALVAClick(Sender: TObject);
    procedure chkParcelaChange(Sender: TObject);
    procedure edtCodPlanoExit(Sender: TObject);
    procedure edtCodPlanoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtContaDestinoExit(Sender: TObject);
    procedure edtContaDestinoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    FPlano: Tplano;
    FContaDestino: Tconta;
    FLancamento: Tlancamento;
    procedure limpa_campos;
    procedure Parcelamento;
    procedure LancaParcela(cParcela:String; dVencimento:tDate);

  public

  end;

var
  frmcad_lcto: Tfrmcad_lcto;

implementation

{$R *.lfm}

{ Tfrmcad_lcto }

procedure Tfrmcad_lcto.btnSALVAClick(Sender: TObject);
begin
  if pnpParcela.Visible then
     begin
          ShowMessage('fechar janela de parcelamento');
          abort;
     end;
  FLancamento.conta    := StrToIntDef(edtConta.text,0);
  FLancamento.cod_plano:= StrToIntDef(edtCodPlano.text,0);
  FLancamento.data_mvto:= edtData.Date;
  if (StrToIntDef(edtCodPlano.Text,0) = 99990) and
     (StrToIntDef(edtContaDestino.Text,0) > 0) then
     FLancamento.descricao:= 'Destino: '+edtContaDestino.Text+' '+
                             edtDescLcto.text
  else
     FLancamento.descricao:= edtDescLcto.text;


  if FPlano.tipo = 'C' then
     FLancamento.valor    := edtValor.Value
  else
    FLancamento.valor     := (edtValor.Value*-1);
  if FLancamento.inclui then
     begin
       if (StrToIntDef(edtCodPlano.Text,0) = 99990) and
          (StrToIntDef(edtContaDestino.Text,0) > 0) then
           begin
             FLancamento.conta    := StrToIntDef(edtContaDestino.text,0);
             FLancamento.cod_plano:= 99991;
             FLancamento.data_mvto:= edtData.Date;
             FLancamento.descricao:= 'Conta:'+inttostr(FLancamento.conta)+' '+
                                    'Id:'+inttostr(FLancamento.id_lcto)+' '+
                                    edtDescLcto.text;

             FLancamento.valor    := edtValor.Value;
             if not FLancamento.inclui then
                ShowMessage('Erro ao incluir transferência');
           end;
       limpa_campos
     end
  else
     ShowMessage('Erro ao incluir');
end;

procedure Tfrmcad_lcto.btnCancelaClick(Sender: TObject);
begin
  pnpParcela.Visible:=false;
  chkParcela.Checked:=false;
end;

procedure Tfrmcad_lcto.btnParcelaClick(Sender: TObject);
begin
  Parcelamento;
  limpa_campos;
  chkParcela.Checked:=false;
  pnpParcela.Visible:= chkParcela.Checked;
end;

procedure Tfrmcad_lcto.chkParcelaChange(Sender: TObject);
begin
  case StrToIntDef(edtCodPlano.Text,0) of
    99990,99991:
       begin
        ShowMessage('Parcelamento não permitido para este plano');
        chkParcela.Checked := false;
        abort;
       end
    else
       pnpParcela.Visible:= chkParcela.Checked;
  end;
end;


procedure Tfrmcad_lcto.edtCodPlanoExit(Sender: TObject);
begin
  if StrToIntDef(edtCodPlano.Text,0)>0 then
     begin
       if FPlano.localiza(StrToIntDef(edtCodPlano.Text,0)) then
          begin
            edtDescPlano.Text:=FPlano.descricao;
            edtTipo.Text := FPlano.tipo;
            pnpContaTrans.Visible := StrToIntDef(edtCodPlano.Text,0) = 99990;
          end
       else
          begin
            edtDescPlano.Text := '';
            edtTipo.Text := '';
            pnpContaTrans.Visible := False;
            ShowMessage('Plano nao localizado.');
          end;
     end
  else
     begin
       edtDescPlano.Text := '';
       edtTipo.Text := '';
       pnpContaTrans.Visible := False;
       ShowMessage('Codigo invalido !');
     end;
end;

procedure Tfrmcad_lcto.edtCodPlanoKeyDown(Sender: TObject; var Key: Word;
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

procedure Tfrmcad_lcto.edtContaDestinoExit(Sender: TObject);
begin
  if (StrToIntDef(edtContaDestino.Text,0) > 0) and
     (StrToIntDef(edtContaDestino.Text,0) <> StrToIntDef(edtConta.Text,0)) then
     begin
       if FContaDestino.localiza(StrToIntDef(edtContaDestino.Text,0)) then
          edtDescDestino.Text := FContaDestino.descricao
       else
          begin
            edtDescDestino.Text := '';
            ShowMessage('Conta destino nao localizada.');
          end;
     end
  else
     begin
      edtDescDestino.Text := '';
      ShowMessage('Codigo destino invalido'+sLineBreak+
      'conta destino nao pode ser igual conta de origem');
     end;

end;

procedure Tfrmcad_lcto.edtContaDestinoKeyDown(Sender: TObject; var Key: Word;
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
          edtContaDestino.text:= frmPesquisa.edtResultado.Text;
        finally
          if Assigned(frmPesquisa) then
             FreeAndNil(frmPesquisa);
        end;
     end;

end;

procedure Tfrmcad_lcto.FormClose(Sender: TObject; var CloseAction: TCloseAction
  );
begin
  if Assigned(FPlano) then
     FreeAndNil(FPlano);
  if Assigned(FContaDestino) then
     FreeAndNil(FContaDestino);
  if Assigned(FLancamento) then
     FreeAndNil(FLancamento);
end;

procedure Tfrmcad_lcto.FormCreate(Sender: TObject);
begin
  FPlano := Tplano.Create;
  FContaDestino := Tconta.Create;
  FLancamento := Tlancamento.Create;
  pnpParcela.Visible:=false;
  chkParcela.Checked:=false;

end;

procedure Tfrmcad_lcto.FormShow(Sender: TObject);
begin
  edtData.Date:=date;
  dINICIAL.date := date;

end;

procedure Tfrmcad_lcto.SpeedButton1Click(Sender: TObject);
begin
  frmcad_planoconta := Tfrmcad_planoconta.Create(Self);
  try
    frmcad_planoconta.ShowModal;
  finally
    FreeAndNil(frmcad_planoconta);
  end;
end;

procedure Tfrmcad_lcto.limpa_campos;
var
  nX : integer;
begin
  for nX := 0 to ComponentCount -1 do
     begin
       if (Components[nX] is TEdit) and ((Components[nX] as TEdit).Tag <> 99 )then
          (Components[nX] as TEdit).Clear;
       if Components[nX] is TCurrencyEdit then
          (Components[nX] as TCurrencyEdit).Value:=0;
     end;
end;

procedure Tfrmcad_lcto.Parcelamento;
var
  nX, nTotalParcela, nDiaPadrao : integer;
  dVencimento : TDate;
  nMes, nDIA, nANO : Word;
begin
  // Validamos a quantidade de parcelas
  if StrToIntDef(edtParcelas.Text,0) <= 0 then
     begin
       ShowMessage('Parcela inválida !');
       abort;
     end;
  // validamos o valor
  if edtValor.Value <= 0 then
     begin
       ShowMessage('Valor inválido!');
       abort;
     end;
  // definimos data inicial
  dVencimento:=dINICIAL.Date ;
  // decodificamos a data
  DecodeDate(dVencimento,nANO,nMes, nDIA);
  // achamos o dia padrao
  nDiaPadrao:=nDIA;
  // definimos total de parcelas
  nTotalParcela:=strtoint(edtParcelas.Text);
  // loop para lancamento da parcela
  for nX := 1 to nTotalParcela do
     begin
      // Lancamento
      LancaParcela(
                   (IntToStrZero(nX,3)+'/'+IntToStrZero(nTotalParcela,3)),
                   dVencimento
                   );
      // Incrimentando o mes
      dVencimento:=IncMonth(dVencimento);
      DecodeDate(dVencimento,nANO,nMes, nDIA);
      // verificando se o ano é bissexto
      if ((nMes=02) and (nDIA = 29))
         and (not IsLeapYear(nANO)) then
            begin
              nDIA := 28; // volta para dia 28
              dVencimento:=EncodeDate(nANO,nMES,nDIA);
            end
      else if nDiaPadrao > DaysInMonth(dVencimento) then
         begin
           // se o dia maior que qtde de dia do mes
           // venctimento passar ser o ultimo dia
           nDIA := DaysInMonth(dVencimento);
           dVencimento := EncodeDate(nANO,nMES,nDIA);
         end
      else
         dVencimento:=RecodeDay(dVencimento,nDiaPadrao);
     end;
end;

procedure Tfrmcad_lcto.LancaParcela(cParcela: String; dVencimento: tDate);
begin
  FLancamento.conta    := StrToIntDef(edtConta.text,0);
  FLancamento.cod_plano:= StrToIntDef(edtCodPlano.text,0);
  FLancamento.data_mvto:= dVencimento;
  FLancamento.descricao:= cParcela+' - '+edtDescLcto.text;
  if FPlano.tipo = 'C' then
     FLancamento.valor    := edtValor.Value
  else
    FLancamento.valor     := (edtValor.Value*-1);
  FLancamento.inclui;

end;


end.

