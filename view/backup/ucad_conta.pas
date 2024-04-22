unit ucad_conta;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, DBGrids,
  ACBrEnterTab, ZDataset, ucad_padrao, classe_conta, DB;
type

  { Tfrmcad_conta }

  Tfrmcad_conta = class(Tfrmcad_padrao)
    DBGrid1: TDBGrid;
    dsPESQ: TDataSource;
    edtAGENCIA: TEdit;
    edtBANCO: TEdit;
    edtCODIGO: TEdit;
    edtCONTA: TEdit;
    edtDESCRICAO: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    qrPESQ: TZQuery;
    qrPESQagencia: TStringField;
    qrPESQbanco: TStringField;
    qrPESQconta: TStringField;
    qrPESQdescricao: TStringField;
    qrPESQid_conta: TLongintField;
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
  frmcad_conta: Tfrmcad_conta;
  conta : Tconta;

implementation

{$R *.lfm}

{ Tfrmcad_conta }

procedure Tfrmcad_conta.FormClose(Sender: TObject; var CloseAction: TCloseAction
  );
begin
  if Assigned(conta) then
     FreeAndNil(conta);

end;

procedure Tfrmcad_conta.btnPESQUISAClick(Sender: TObject);
begin
  if qrPESQ.Active then qrPESQ.Close;
  qrPESQ.SQL.Clear;
  qrPESQ.sql.Add('select * from contas');
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
  cliqueBotao:=cbNone;

end;

procedure Tfrmcad_conta.btnSALVAClick(Sender: TObject);
begin
  inherited;
  conta.id_conta :=StrToIntDef(edtCODIGO.Text,0);
  conta.descricao:=edtDESCRICAO.Text;
  conta.banco    :=edtBANCO.Text;
  conta.agencia  :=edtAGENCIA.Text;
  conta.conta    :=edtCONTA.Text;
  if cliqueBotao = cbAlterar then
     conta.altera(conta.id_conta)
  else if cliqueBotao = cbIncluir then
     conta.incluir;
  cliqueBotao:=cbNone;
  qrPESQ.Refresh;
  PageControl1.PageIndex:=0;

end;

procedure Tfrmcad_conta.btnALTERAClick(Sender: TObject);
begin
    if strtointdef(edtCODIGO.Text,0) = 0 then
       begin
         ShowMessage('nenhum registro selecionado');
         cliqueBotao:=cbNone;
         Abort;
       end;
    inherited;
    edtDESCRICAO.SetFocus;

end;

procedure Tfrmcad_conta.btnAPAGAClick(Sender: TObject);
begin
    if strtointdef(edtCODIGO.Text,0) = 0 then
       begin
         ShowMessage('nenhum registro selecionado');
         cliqueBotao:=cbNone;
         Abort;
       end;
    if QuestionDlg('Confirmação','Excluir o registro',mtConfirmation,
      [mrYes,'Sim', mrNo,'Não'],0) = mrYes then
         conta.exclui(conta.id_conta);
    inherited;

    qrPESQ.Refresh;

    PageControl1.PageIndex:=0;
    cliqueBotao:=cbNone;

end;

procedure Tfrmcad_conta.DBGrid1DblClick(Sender: TObject);
begin
    if conta.localiza(qrPESQid_conta.Value) then
     begin
       PageControl1.PageIndex:=1;
       edtCODIGO.Text   :=inttostr(conta.id_conta);
       edtDESCRICAO.Text:=conta.descricao;
       edtBANCO.Text    :=conta.banco;
       edtAGENCIA.Text  :=conta.agencia;
       edtCONTA.Text    :=conta.conta;
     end;

end;

procedure Tfrmcad_conta.FormCreate(Sender: TObject);
begin
  conta := Tconta.Create;
end;

procedure Tfrmcad_conta.FormShow(Sender: TObject);
begin
  inherited;
  if not qrPESQ.Active then
     qrPESQ.Open;
end;

end.

