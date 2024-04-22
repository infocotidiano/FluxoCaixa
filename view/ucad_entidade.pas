unit ucad_entidade;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, DB, Forms, Controls, Graphics, Dialogs, DBGrids, StdCtrls,
  ZDataset, ucad_padrao, classe_entidade;

type

  { Tfrmcad_entidade }

  Tfrmcad_entidade = class(Tfrmcad_padrao)
    DBGrid1: TDBGrid;
    dsPesq: TDataSource;
    edtTELEFONE: TEdit;
    edtCODIGO: TEdit;
    edtNOME: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    qrPesq: TZQuery;
    qrPesqid_entidade: TLongintField;
    qrPesqnome: TStringField;
    qrPesqtelefone: TStringField;
    procedure btnALTERAClick(Sender: TObject);
    procedure btnAPAGAClick(Sender: TObject);
    procedure btnPESQUISAClick(Sender: TObject);
    procedure btnSALVAClick(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  frmcad_entidade: Tfrmcad_entidade;
  Entidade : TEntidade;

implementation

{$R *.lfm}

{ Tfrmcad_entidade }

procedure Tfrmcad_entidade.btnPESQUISAClick(Sender: TObject);
begin
  if qrPESQ.Active then qrPESQ.Close;
  qrPESQ.SQL.Clear;
  qrPESQ.sql.Add('select * from entidades');
  qrPESQ.sql.add('where nome like :cPESQ');
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

procedure Tfrmcad_entidade.btnSALVAClick(Sender: TObject);
begin
  inherited;
  Entidade.Id_Entidade  := StrToIntDef(edtCODIGO.Text,0);
  Entidade.Nome         := edtNOME.Text;
  Entidade.Telefone     := edtTELEFONE.Text;
  if cliqueBotao = cbAlterar then
     Entidade.altera(Entidade.Id_Entidade)
  else if cliqueBotao = cbIncluir then
     Entidade.incluir;
  cliqueBotao:=cbNone;
  qrPESQ.Refresh;
  PageControl1.PageIndex:=0;
end;

procedure Tfrmcad_entidade.DBGrid1DblClick(Sender: TObject);
begin
  if Entidade.localiza(qrPesqid_entidade.Value) then
     begin
       PageControl1.PageIndex := 1;
       edtCODIGO.Text         := inttostr(Entidade.Id_Entidade);
       edtNOME.Text           := Entidade.Nome;
       edtTELEFONE.Text       := Entidade.Telefone;
     end;

end;

procedure Tfrmcad_entidade.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  if Assigned(Entidade) then
     FreeAndNil(Entidade);
end;

procedure Tfrmcad_entidade.FormCreate(Sender: TObject);
begin
  Entidade := TEntidade.Create;
end;

procedure Tfrmcad_entidade.btnALTERAClick(Sender: TObject);
begin
    if strtointdef(edtCODIGO.Text,0) = 0 then
       begin
         ShowMessage('nenhum registro selecionado');
         CliqueBotao := cbNone;
         Abort;
       end;
  inherited;
end;

procedure Tfrmcad_entidade.btnAPAGAClick(Sender: TObject);
begin
    if strtointdef(edtCODIGO.Text,0) = 0 then
       begin
         ShowMessage('nenhum registro selecionado');
         cliqueBotao := cbNone;
         Abort;
       end;

    if QuestionDlg('Confirmação','Excluir o registro',mtConfirmation,
      [mrYes,'Sim', mrNo,'Não'],0) = mrYes then
         Entidade.exclui(Entidade.Id_Entidade);
    inherited;
    cliqueBotao := cbNone;
    qrPESQ.Refresh;
    PageControl1.PageIndex := 0;

end;

end.

