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
  conexao.Protocol := 'mariadb';
  conexao.Database := cfg_banco;
  conexao.HostName := cfg_servidor;
  conexao.User := cfg_usuario;
  conexao.Password := cfg_senha;
  conexao.Port := cfg_porta;
  conexao.AutoCommit := True;
  {$IFDEF WINDOWS}
     conexao.LibraryLocation := cfg_dllMariadb;
  {$ENDIF}

end;




end.
