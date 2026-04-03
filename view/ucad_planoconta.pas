unit ucad_planoconta;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, DBGrids,
  ACBrEnterTab, ZDataset,  DB, ucad_padrao, classe_plano;

type

  { Tfrmcad_planoconta }

  Tfrmcad_planoconta = class(Tfrmcad_padrao)
    ACBrEnterTab1: TACBrEnterTab;
    cmbTIPO: TComboBox;
    DBGrid1: TDBGrid;
    dsPESQ: TDataSource;
    edtCODIGO: TEdit;
    edtDESCRICAO: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    qrPESQ: TZQuery;
    qrPESQdescricao: TStringField;
    qrPESQid_plano: TLongintField;
    qrPESQtipo: TStringField;
    procedure btnALTERAClick(Sender: TObject);
    procedure btnAPAGAClick(Sender: TObject);
    procedure btnPESQUISAClick(Sender: TObject);
    procedure btnSALVAClick(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public

  end;

var
  frmcad_planoconta: Tfrmcad_planoconta;
  oPlano : Tplano;

implementation

{$R *.lfm}

{ Tfrmcad_planoconta }

procedure Tfrmcad_planoconta.FormCreate(Sender: TObject);
begin
  oPlano := TPlano.Create;
end;

procedure Tfrmcad_planoconta.FormShow(Sender: TObject);
begin
  inherited;
  if not qrPESQ.Active then
     qrPESQ.Open;

end;

procedure Tfrmcad_planoconta.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  if Assigned(oPlano) then
     FreeAndNil(oPlano);

end;

procedure Tfrmcad_planoconta.DBGrid1DblClick(Sender: TObject);
begin
  if oPlano.localiza(qrPESQid_Plano.Value) then
     begin
       PageControl1.PageIndex := 1;
       edtCODIGO.Text         := inttostr(oPlano.id_plano);
       edtDESCRICAO.Text      := oPlano.descricao;
       cmbTIPO.Text           := oPlano.tipo;
     end;
end;

procedure Tfrmcad_planoconta.btnALTERAClick(Sender: TObject);
begin
  if strtointdef(edtCODIGO.Text,0) = 0 then
     begin
       ShowMessage('nenhum registro selecionado');
       CliqueBotao := cbNone;
       Abort;
     end;
  inherited;
end;

procedure Tfrmcad_planoconta.btnAPAGAClick(Sender: TObject);
begin
  if strtointdef(edtCODIGO.Text,0) = 0 then
     begin
       ShowMessage('nenhum registro selecionado');
       cliqueBotao := cbNone;
       Abort;
     end;

  if QuestionDlg('Confirmação','Excluir o registro',mtConfirmation,
    [mrYes,'Sim', mrNo,'Não'],0) = mrYes then
       oPlano.exclui(oPlano.id_plano);
  inherited;
  cliqueBotao := cbNone;
  qrPESQ.Refresh;
  PageControl1.PageIndex := 0;
end;

procedure Tfrmcad_planoconta.btnPESQUISAClick(Sender: TObject);
begin
  if qrPESQ.Active then qrPESQ.Close;
  qrPESQ.SQL.Clear;
  qrPESQ.sql.Add('select * from planos');
  qrPESQ.sql.add('where descricao like :cPESQ');
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

procedure Tfrmcad_planoconta.btnSALVAClick(Sender: TObject);
begin
  inherited;
  oPlano.id_plano  := StrToIntDef(edtCODIGO.Text,0);
  oPlano.descricao := edtDESCRICAO.Text;
  oPlano.tipo      := cmbTIPO.Text;
  if cliqueBotao = cbAlterar then
     oPlano.altera(oPlano.id_plano)
  else if cliqueBotao = cbIncluir then
     oPlano.incluir;
  cliqueBotao:=cbNone;
  qrPESQ.Refresh;
  PageControl1.PageIndex:=0;

end;

end.

