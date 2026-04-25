unit utabela;
{***************************************************************************}
{                                                                           }
{   Autor:        Daniel de Morais                                          }
{   Projeto:      Fluxo de Caixa                                            }
{                                                                           }
{   Informações:  Código Fonte da Playlist do YouTube sobre aprendizagem    }
{                 de como criar um Fluxo de Caixa.                          }
{                                                                           }
{   Aviso Legal:  Este código é fornecido exclusivamente para fins de       }
{                 estudo e aprendizagem. Não há qualquer garantia,          }
{                 explícita ou implícita, de funcionamento, adequação       }
{                 ou ausência de erros.                                     }
{                                                                           }
{                 O autor não se responsabiliza por danos diretos,          }
{                 indiretos, incidentais ou consequenciais decorrentes      }
{                 do uso deste código em ambientes de produção.             }
{                                                                           }
{                 Ao utilizar este código, você concorda que qualquer       }
{                 modificação, adaptação ou uso será de sua inteira         }
{                 responsabilidade.                                         }
{                                                                           }
{***************************************************************************}


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
