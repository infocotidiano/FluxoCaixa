unit upesquisa_lcto;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, DBGrids,
  StdCtrls, EditBtn, Buttons, ZDataset, upesquisa, classe_plano, DB, rxcurredit,
  LCLType, ACBrEnterTab;

type

  { TFrmpesquisa_lcto }

  TFrmpesquisa_lcto = class(TForm)
    ACBrEnterTab1: TACBrEnterTab;
    btnPESQUISA: TBitBtn;
    chkFiltroValor: TCheckBox;
    chkFiltroPeriodo: TCheckBox;
    dsPESQ: TDataSource;
    DBGrid1: TDBGrid;
    dtFIM: TDateEdit;
    dtINICIO: TDateEdit;
    edtCodPlano: TEdit;
    edtDescLcto: TEdit;
    edtDescPlano: TEdit;
    edtValor: TCurrencyEdit;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Panel1: TPanel;
    pnpTITULO: TPanel;
    qrPESQ: TZQuery;
    qrPESQDATA: TDateField;
    qrPESQDESCRICAO: TStringField;
    qrPESQDESC_PLANO: TStringField;
    qrPESQLCTO: TLongintField;
    qrPESQPLANO: TLongintField;
    qrPESQTIPO: TStringField;
    qrPESQVALOR: TFloatField;
    procedure btnPESQUISAClick(Sender: TObject);
    procedure chkFiltroValorChange(Sender: TObject);
    procedure edtCodPlanoExit(Sender: TObject);
    procedure edtCodPlanoKeyDown(Sender: TObject; var Key: word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    procedure Filtro;
  public

  end;

var
  Frmpesquisa_lcto: TFrmpesquisa_lcto;
  oPLANO: Tplano;

implementation

uses umovimento;

  {$R *.lfm}

  { TFrmpesquisa_lcto }

procedure TFrmpesquisa_lcto.edtCodPlanoKeyDown(Sender: TObject;
  var Key: word; Shift: TShiftState);
begin
  if key = VK_F4 then
  begin
    frmPesquisa := TfrmPesquisa.Create(self, ['ID_PLANO', 'DESCRICAO', 'TIPO'],
      'PLANOS', 'ID_PLANO');
    try
      frmPesquisa.ShowModal;
      edtCodPlano.Text := frmPesquisa.edtResultado.Text;
    finally
      if Assigned(frmPesquisa) then
        FreeAndNil(frmPesquisa);
    end;
  end;
end;

procedure TFrmpesquisa_lcto.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if Assigned(oPLANO) then
    FreeAndNil(oPLANO);
end;

procedure TFrmpesquisa_lcto.FormCreate(Sender: TObject);
begin
  oPLANO := Tplano.Create;
end;

procedure TFrmpesquisa_lcto.Filtro;
begin
  if qrPESQ.Active then
    qrPESQ.Close;
  qrPESQ.sql.Clear;
  qrPESQ.sql.Add('select l.id_lcto LCTO, l.data_mvto DATA, l.plano PLANO,');
  qrPESQ.sql.Add('p.descricao DESC_PLANO, l.descricao DESCRICAO, l.valor VALOR,');
  qrPESQ.sql.Add('p.tipo TIPO');
  qrPESQ.sql.Add('from lancamentos l');
  qrPESQ.sql.Add('join planos p on p.id_plano = l.plano');
  qrPESQ.sql.Add('where  l.conta = :nCONTA');
  qrPESQ.ParamByName('nCONTA').AsInteger := StrToIntDef(frmmovimento.edtCOD.Text, 0);
  // pesquisa por periodo
  if chkFiltroPeriodo.Checked then
  begin
    if dtINICIO.Date <= dtFIM.Date then
    begin
      qrPESQ.sql.Add('and l.data_mvto between :dINI and :dFIM');
      qrPESQ.ParamByName('dINI').AsDate := dtINICIO.Date;
      qrPESQ.ParamByName('dFIM').AsDate := dtFIM.Date;
    end
    else
    begin
      ShowMessage('Data inicial não pode ser maior que a data final');
      abort;
    end;
  end;
  // pesquisa por plano
  if StrToIntDef(edtCodPlano.Text, 0) > 0 then
  begin
    qrPESQ.sql.Add('and l.plano = :nPLANO');
    qrPESQ.ParamByName('nPLANO').AsInteger := StrToIntDef(edtCodPlano.Text, 0);
  end;
  // pesquisa por descricao
  if trim(edtDescLcto.Text) <> EmptyStr then
  begin
    qrPESQ.sql.Add('and l.descricao like :cDESC');
    qrPESQ.ParamByName('cDESC').AsString := '%' + trim(edtDescLcto.Text) + '%';
  end;
  // pesquisa por valor
  if chkFiltroValor.Checked then
  begin
    qrPESQ.sql.Add('and l.valor = :nVALOR');
    qrPESQ.ParamByName('nVALOR').AsFloat := edtValor.Value;
  end;

  try
    qrPESQ.Open;
  except
    on e: Exception do
    begin
      ShowMessage('Erro ao consultar lançamento' +
        sLineBreak + e.ClassName + sLineBreak + e.Message);
    end;
  end;

end;

procedure TFrmpesquisa_lcto.edtCodPlanoExit(Sender: TObject);
begin
  if oPLANO.localiza(StrToIntDef(edtCodPlano.Text, 0)) then
    edtDescPlano.Text := oPLANO.descricao
  else
    edtDescLcto.Text := '';

end;

procedure TFrmpesquisa_lcto.btnPESQUISAClick(Sender: TObject);
begin
  if (edtValor.Value <> 0) and (not chkFiltroValor.Checked) then
    ShowMessage('Para pesquisar por valor, marque opção filtrar valor');

  Filtro;
end;

procedure TFrmpesquisa_lcto.chkFiltroValorChange(Sender: TObject);
begin
  if not chkFiltroValor.Checked then
    edtValor.Value := 0;
end;

end.
