unit uprincipal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Buttons, rxmemds, IniFiles;

type

  { Tfrmprincipal }

  Tfrmprincipal = class(TForm)
    btnCFG: TSpeedButton;
    btnContaPagar: TSpeedButton;
    btnEntidade: TSpeedButton;
    btnContaReceber: TSpeedButton;
    Label1: TLabel;
    pnpEsquerda: TPanel;
    Shape1: TShape;
    btnCONTAS: TSpeedButton;
    btnPLANOS: TSpeedButton;
    btnLCTO: TSpeedButton;
    btnSAIR: TSpeedButton;
    procedure btnCFGClick(Sender: TObject);
    procedure btnContaPagarClick(Sender: TObject);
    procedure btnContaReceberClick(Sender: TObject);
    procedure btnCONTASClick(Sender: TObject);
    procedure btnEntidadeClick(Sender: TObject);
    procedure btnLCTOClick(Sender: TObject);
    procedure btnPLANOSClick(Sender: TObject);
    procedure btnSAIRClick(Sender: TObject);
    procedure btntesteClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure ler_ini;
  public

  end;

var
  frmprincipal: Tfrmprincipal;
  cfg_arqINI, cfg_pathApp: string;
  cfg_banco, cfg_servidor, cfg_usuario, cfg_senha, cfg_odbc, cfg_dllMariadb: string;
  cfg_porta: integer;

implementation

uses utabela, uconfigurabanco, ucad_padrao, ucad_entidade,
  ucad_planoconta, ucad_conta, umovimento,
  classe_plano, ucad_receber, ucad_pagar;

  {$R *.lfm}

function DefaultMariaDbLibrary: string;
begin
  {$IFDEF WINDOWS}
  Result := 'libmariadb.dll';
  {$ELSE}
  Result := 'libmariadb.so';
  {$ENDIF}
end;

{ Tfrmprincipal }

procedure Tfrmprincipal.btnSAIRClick(Sender: TObject);
begin
  ShowMessage('Até Breve !');
  Application.Terminate;
end;

procedure Tfrmprincipal.btntesteClick(Sender: TObject);
//var
//  oReceber : TContaReceber;
begin
  //oReceber := TContaReceber.Create;
  //oReceber.Descricao:='teste';
  //oReceber.DtLancamento:=now;
  //oReceber.Valor:=12;
  //oReceber.DtVencimento:=now+12;
  //oReceber.Plano:=1;
  //oReceber.Situacao:='P';
  //if oReceber.incluir then
  //    ShowMessage('incluido !');
  //if Assigned(oReceber) then
  //   FreeAndNil(oReceber);

end;



procedure Tfrmprincipal.btnCFGClick(Sender: TObject);
begin
  frmconfigurabanco := Tfrmconfigurabanco.Create(self);
  try
    frmconfigurabanco.ShowModal;
  finally
    FreeAndNil(frmconfigurabanco);
  end;
end;

procedure Tfrmprincipal.btnContaPagarClick(Sender: TObject);
begin
  frmcad_pagar := Tfrmcad_pagar.Create(self);
  try
    frmcad_pagar.ShowModal;
  finally
    FreeAndNil(frmcad_pagar);
  end;
end;

procedure Tfrmprincipal.btnContaReceberClick(Sender: TObject);
begin
  frmcad_receber := Tfrmcad_receber.Create(self);
  try
    frmcad_receber.ShowModal;
  finally
    FreeAndNil(frmcad_receber);
  end;
end;

procedure Tfrmprincipal.btnCONTASClick(Sender: TObject);
begin
  frmcad_conta := Tfrmcad_conta.Create(self);
  try
    frmcad_conta.ShowModal;
  finally
    FreeAndNil(frmcad_conta);
  end;
end;

procedure Tfrmprincipal.btnEntidadeClick(Sender: TObject);
begin
  frmcad_entidade := Tfrmcad_entidade.Create(self);
  try
    frmcad_entidade.ShowModal;
  finally
    FreeAndNil(frmcad_entidade);
  end;
end;

procedure Tfrmprincipal.btnLCTOClick(Sender: TObject);
begin
  frmmovimento := Tfrmmovimento.Create(self);
  try
    frmmovimento.ShowModal;
  finally
    FreeAndNil(frmmovimento);
  end;

end;

procedure Tfrmprincipal.btnPLANOSClick(Sender: TObject);
begin
  frmcad_planoconta := Tfrmcad_planoconta.Create(self);
  try
    frmcad_planoconta.ShowModal;
  finally
    FreeAndNil(frmcad_planoconta);
  end;
end;

procedure Tfrmprincipal.FormCreate(Sender: TObject);
begin
  {$ifdef cpu32}
    Caption := Caption + ' (v32bit)';
  {$endif}
  {$ifdef cpu64}
    Caption := Caption + ' (v64bit)';
  {$endif}

  {$IFDEF LINUX}
     // Formatação de moeda
      CurrencyString := 'R$';
      CurrencyFormat := 2;
      DecimalSeparator := ',';
      ThousandSeparator := '.';
     // Formatação de datas
      DateSeparator := '/';
      ShortDateFormat := 'dd/mm/yyyy';
  {$ENDIF}

  cfg_arqINI := ChangeFileExt(ParamStr(0), '.ini');
  cfg_pathApp := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0)));

end;

procedure Tfrmprincipal.FormShow(Sender: TObject);
var
  oPlano: Tplano;
begin
  if not FileExists(cfg_arqINI) then
    btnCFG.Click;

  if not FileExists(cfg_arqINI) then
  begin
    ShowMessage('Arquivo de configuracao nao encontrado: ' + cfg_arqINI);
    Exit;
  end;

  ler_ini;

  if not Assigned(TabGlobal) then
  begin
    ShowMessage('Modulo de conexao nao foi inicializado.');
    Exit;
  end;

  if not Assigned(TabGlobal.conexao) then
  begin
    ShowMessage('Componente de conexao nao foi inicializado.');
    Exit;
  end;

  if not TabGlobal.conexao.Connected then
  begin
    try
      TabGlobal.conexao.Connect;
    except
      on e: Exception do
      begin
        ShowMessage('Erro ao conectar com o banco' + sLineBreak +
          e.ClassName + sLineBreak + e.Message);
        Exit;
      end;
    end;
  end;

  oPlano := Tplano.Create;
  try
    oPlano.fixacodigoCredito;
    oPlano.fixacodigoDebito;
  finally
    FreeAndNil(oPlano);
  end;
end;


procedure Tfrmprincipal.ler_ini;
var
  ArqIni: TIniFile;
begin
  ArqIni := TIniFile.Create(cfg_arqINI);
  try
    cfg_banco := ArqIni.ReadString('ConexaoDB', 'Banco', '');
    cfg_servidor := ArqIni.ReadString('ConexaoDB', 'Server', '');
    cfg_porta := ArqIni.ReadInteger('ConexaoDB', 'Porta', 3306);
    cfg_usuario := ArqIni.ReadString('ConexaoDB', 'User', '');
    cfg_senha := ArqIni.ReadString('ConexaoDB', 'Senha', '');
    cfg_odbc := ArqIni.ReadString('ConexaoDB', 'ODBC', 'mariadb ODBC 3.1 Driver');
    cfg_dllMariadb := ArqIni.ReadString('ConexaoDB', 'DLL', DefaultMariaDbLibrary);
  finally
    ArqINI.Free;
  end;

end;

end.
