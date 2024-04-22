unit utabela;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ZConnection, Dialogs;

type

  { TTabGlobal }

  TTabGlobal = class(TDataModule)
    conexao: TZConnection;
    procedure conexaoBeforeConnect(Sender: TObject);
  private

  public

  end;

var
  TabGlobal: TTabGlobal;

implementation
   uses uprincipal;

{$R *.lfm}

{ TTabGlobal }

procedure TTabGlobal.conexaoBeforeConnect(Sender: TObject);
begin
  //padrao para linux e windows
  conexao.Protocol  :='MariaDB-10';
  conexao.Database  :=cfg_banco;
  conexao.HostName  :=cfg_servidor;
  conexao.User      :=cfg_usuario;
  conexao.Password  :=cfg_senha;
  conexao.Port      :=cfg_porta;
  conexao.AutoCommit:=true;
  {$IFDEF WINDOWS}
     // para quem usa windows informar
     if cfg_pathDLLMariaDB <> EmptyStr then
        if FileExists(cfg_pathDLLMariaDB) then
           conexao.LibraryLocation := cfg_pathDLLMariaDB
        else
           ShowMessage('Arquivo dll mariaDB não existe'+sLineBreak+
           cfg_pathDLLMariaDB)
     else
        begin
          conexao.Protocol:='ado'; // para banco 64bits
          conexao.Database:='Driver={'+cfg_odbc+'}; server='+cfg_servidor+'; Database='+cfg_banco+'; User='+cfg_usuario+'; password='+cfg_senha+'; option=3;';
          // Driver={mariadb ODBC 3.1 Driver}; server=localhost; Database=fluxo_caixa; User=suporte; password=Info@1234; option=3;
        end;
  {$ENDIF}

end;




















end.

