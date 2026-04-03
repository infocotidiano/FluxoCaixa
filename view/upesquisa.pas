unit upesquisa;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, DBGrids, StdCtrls,
  ExtCtrls, utabela, ZConnection, ZDataset, LCLType;

type

  { TfrmPesquisa }

  TfrmPesquisa = class(TForm)
    btnPesquisa: TButton;
    cbCampos: TComboBox;
    cbFiltro: TComboBox;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    edtBusca: TEdit;
    edtResultado: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Panel1: TPanel;
    ZQuery1: TZQuery;
    procedure btnPesquisaClick(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure edtBuscaKeyDown(Sender: TObject; var Key: word; Shift: TShiftState);
  private
    cCampos, cCampoRetorno, cTabela: string;
  public
    constructor Create(AOwner: TComponent;
      par_lstCampos: array of string; par_cTabela, par_cCampoResult: string);
  end;

var
  frmPesquisa: TfrmPesquisa;

implementation

{$R *.lfm}

{ TfrmPesquisa }

procedure TfrmPesquisa.btnPesquisaClick(Sender: TObject);
begin
  if ZQuery1.Active then
    ZQuery1.Close;

  with ZQuery1.sql do
  begin
    Clear;
    add('select ' + cCampos);
    add('from ' + cTabela);
    add('where ' + trim(cbCampos.Text) + ' like :cParametro');
  end;
  if trim(cbFiltro.Text) = 'parte' then
    ZQuery1.ParamByName('cParametro').AsString := '%' + trim(edtBusca.Text) + '%'
  else if trim(cbFiltro.Text) = 'igual' then
    ZQuery1.ParamByName('cParametro').AsString := trim(edtBusca.Text)
  else if trim(cbFiltro.Text) = 'inicio' then
    ZQuery1.ParamByName('cParametro').AsString := trim(edtBusca.Text) + '%';
  ZQuery1.Open;
  edtResultado.Text := '';

end;

procedure TfrmPesquisa.DBGrid1DblClick(Sender: TObject);
begin
  edtResultado.Text := ZQuery1.FieldByName(cCampoRetorno).AsVariant;
  ZQuery1.Close;
  frmPesquisa.ModalResult := mrYes;
end;

procedure TfrmPesquisa.edtBuscaKeyDown(Sender: TObject; var Key: word;
  Shift: TShiftState);
begin
  if key = VK_RETURN then
    btnPesquisa.Click;
end;

constructor TfrmPesquisa.Create(AOwner: TComponent; par_lstCampos: array of string;
  par_cTabela, par_cCampoResult: string);
var
  n: integer;
  LCampo: string;
begin
  inherited Create(AOwner);
  cCampoRetorno := LowerCase(Trim(par_cCampoResult));
  cCampos := '';
  cTabela := LowerCase(Trim(par_cTabela));
  for n := 0 to Length(par_lstCampos) - 1 do
  begin
    LCampo := LowerCase(Trim(par_lstCampos[n]));
    cbCampos.Items.Add(LCampo);
    if n = 0 then
      cCampos := LCampo
    else
      cCampos := cCampos + ',' + LCampo;
  end;
  if cbCampos.Items.Count > 1 then
    cbCampos.ItemIndex := 1
  else if cbCampos.Items.Count = 1 then
    cbCampos.ItemIndex := 0;
  if ZQuery1.Active then
    ZQuery1.Close;
  with ZQuery1.sql do
  begin
    Clear;
    add('select ' + cCampos);
    add('from ' + cTabela);
  end;
  ZQuery1.Open;
end;

end.
