unit importa;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Buttons, ActnList, rxmemds, RxDBGrid, LCLType, classe_plano,
  upesquisa, Grids, DBGrids, ACBrEnterTab, ACBrOFX, classe_lancamento;

type

  { TfrmImporta }

  TfrmImporta = class(TForm)
    ACBrEnterTab1: TACBrEnterTab;
    btnFiltro: TButton;
    DsTMP: TDataSource;
    edtFiltro: TEdit;
    edtCodConta: TEdit;
    edtAgencia: TEdit;
    edtNumConta: TEdit;
    edtARQUIVO: TEdit;
    edtNumBanco: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    OpenDialog1: TOpenDialog;
    Panel1: TPanel;
    pnpImporta: TPanel;
    pnpTITULO: TPanel;
    qrTMP: TRxMemoryData;
    qrTMPCodPlano: TLongintField;
    qrTMPData: TDateField;
    qrTMPDescPlano: TStringField;
    qrTMPDescricao: TStringField;
    qrTMPDocumento: TStringField;
    qrTMPIDbanco: TStringField;
    qrTMPSelcionado: TBooleanField;
    qrTMPTipoMovimento: TStringField;
    qrTMPValor: TCurrencyField;
    RxDBGrid1: TRxDBGrid;
    btnLerArquivo: TSpeedButton;
    btnImporta: TSpeedButton;
    btnAbrirArquivo: TSpeedButton;
    procedure btnAbrirArquivoClick(Sender: TObject);
    procedure btnFiltroClick(Sender: TObject);
    procedure btnImportaClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
    procedure btnLerArquivoClick(Sender: TObject);
  private
    function AddItem(dData: TDate; cDesc, cDocto, cTipo, cIDBanco: string;
      nValor: currency): boolean;
  public

  end;

var
  frmImporta: TfrmImporta;
  FACBrOFX: TACBrOFX;

implementation

{$R *.lfm}

{ TfrmImporta }

procedure TfrmImporta.btnLerArquivoClick(Sender: TObject);
var
  nX: integer;
begin
  if edtARQUIVO.Text <> EmptyStr then
  begin
    if FileExists(edtARQUIVO.Text) then
    begin
      FACBrOFX.FileOFX := edtARQUIVO.Text;
      FACBrOFX.Import;
    end
    else
    begin
      ShowMessage('Arquivo inexistente !');
      abort;
    end;
  end
  else
  begin
    ShowMessage('Favor informar o arquivo');
    abort;
  end;
  if (FACBrOFX.AccountID <> edtNumConta.Text) or
    (FACBrOFX.BranchID <> edtAgencia.Text) then
  begin
    ShowMessage('Este arquivo não pertence a esta conta' + sLineBreak +
      'OFX Agencia/Conta: ' + FACBrOFX.BranchID + ' / ' +
      FACBrOFX.AccountID + sLineBreak + 'Agencia/Conta: ' +
      edtAgencia.Text + ' / ' + edtNumConta.Text
      );
    abort;
  end;
  for nX := 0 to (FACBrOFX.Count - 1) do
  begin
    AddItem(
      FACBrOFX.get(nX).MovDate,
      FACBrOFX.get(nX).Description,
      FACBrOFX.get(nX).Document,
      FACBrOFX.get(nX).MovType,
      FACBrOFX.get(nX).ID,
      FACBrOFX.get(nX).Value);
  end;
end;

procedure TfrmImporta.FormKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
var
  nCODPLANO: integer;
  cDESCPLANO: string;
  Plano: Tplano;
begin
  cDESCPLANO := '';
  if key = VK_F4 then
  begin
    // filtrar tab. temp mem
    qrTMP.Filtered := False;
    qrTMP.Filter := 'selecionado';
    qrTMP.Filtered := True;

    if qrTMP.RecordCount >= 1 then
    begin
      frmPesquisa := TfrmPesquisa.Create(
        self, ['ID_PLANO', 'DESCRICAO', 'TIPO'], 'PLANOS', 'ID_PLANO');
      try
        frmPesquisa.ShowModal;
        nCODPLANO := strtointdef(frmPesquisa.edtResultado.Text, 0);
      finally
        if Assigned(frmPesquisa) then
          FreeAndNil(frmPesquisa);
      end;

      if nCODPLANO > 0 then
      begin
        Plano := Tplano.Create;
        if plano.localiza(nCODPLANO) then
        begin
          cDESCPLANO := plano.descricao;
          qrTMP.First;
          while not qrTMP.EOF do
          begin
            qrTMP.Edit;
            if plano.tipo = 'D' then
              if qrTMPValor.Value > 0 then
                qrTMPValor.Value := qrTMPValor.Value * -1
              else
              if qrTMPValor.Value < 0 then
                qrTMPValor.Value := qrTMPValor.Value * -1;

            qrTMPCodPlano.Value := nCODPLANO;
            qrTMPDescPlano.Value := cDESCPLANO;
            qrTMPTipoMovimento.Value := plano.tipo;
            qrTMPSelcionado.Value := False;
            qrTMP.Post;
          end;

        end;
        if Assigned(Plano) then
          FreeAndNil(Plano);
        qrTMP.Filtered := False;
      end
      else
        qrTMP.Filtered := False;

    end
    else
      qrTMP.Filtered := False;
  end;
end;

procedure TfrmImporta.btnImportaClick(Sender: TObject);
var
  Lcto: Tlancamento;
begin
  Lcto := Tlancamento.Create;
  try
    qrTMP.First;
    while not qrTMP.EOF do
    begin
      if qrTMPCodPlano.Value > 0 then
      begin
        Lcto.conta := StrToInt(edtCodConta.Text);
        Lcto.cod_plano := qrTMPCodPlano.Value;
        Lcto.data_mvto := qrTMPData.Value;
        Lcto.descricao := qrTMPDescricao.Value;
        Lcto.valor := qrTMPValor.Value;
        Lcto.idbanco := qrTMPIDbanco.Value;
        Lcto.inclui;
        qrTMP.Delete;
      end
      else
      begin
        ShowMessage('Obrigatorio informar o plano de conta');
        qrTMP.Next;
      end;

    end;
  finally
    FreeAndNil(Lcto);
  end;

end;

procedure TfrmImporta.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if Assigned(FACBrOFX) then
    FreeAndNil(FACBrOFX);
end;

procedure TfrmImporta.FormCreate(Sender: TObject);
begin
  FACBrOFX := TACBrOFX.Create(nil);
end;

procedure TfrmImporta.btnAbrirArquivoClick(Sender: TObject);
begin
  OpenDialog1.Execute;
  edtARQUIVO.Text := OpenDialog1.FileName;
end;

procedure TfrmImporta.btnFiltroClick(Sender: TObject);
begin
  if edtFiltro.Text <> EmptyStr then
  begin
    qrTMP.Filtered := False;
    qrTMP.Filter := 'descricao=' + QuotedStr('*' + edtFiltro.Text + '*');
    qrTMP.Filtered := True;
  end
  else
  begin
    qrTMP.Filtered := False;
    qrTMP.Filter := '';
  end;
end;

function TfrmImporta.AddItem(dData: TDate; cDesc, cDocto, cTipo, cIDBanco: string;
  nValor: currency): boolean;
begin
  qrTMP.Insert;
  qrTMPData.Value := dData;
  qrTMPDescricao.Value := cDesc;
  qrTMPDocumento.Value := cDocto;
  qrTMPTipoMovimento.Value := cTipo;
  qrTMPIDbanco.Value := cIDBanco;
  qrTMPValor.Value := nValor;
  qrTMPSelcionado.Value := False;
  qrTMP.Post;
  qrTMP.Refresh;
  Result := True;
end;

end.
