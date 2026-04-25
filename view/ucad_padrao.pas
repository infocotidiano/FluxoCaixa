unit ucad_padrao;
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
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Buttons,
  ComCtrls, StdCtrls, db, ZDataset, DBGrids, rxcurredit, DateTimePicker, utabela;


Type
   TCliqueBotao = (cbIncluir, cbAlterar, cbNone);

  { Tfrmcad_padrao }

  Tfrmcad_padrao = class(TForm)
    btnALTERA: TSpeedButton;
    btnAPAGA: TSpeedButton;
    btNCANCELA: TSpeedButton;
    btnINCLUI: TSpeedButton;
    btnPESQUISA: TSpeedButton;
    btnSALVA: TSpeedButton;
    edtPESQUISA: TEdit;
    PageControl1: TPageControl;
    Panel1: TPanel;
    pnpRODAPE: TPanel;
    pnpTITULO: TPanel;
    tsPESQUISA: TTabSheet;
    tsCADASTRO: TTabSheet;
    procedure btnALTERAClick(Sender: TObject);
    procedure btnAPAGAClick(Sender: TObject);
    procedure btNCANCELAClick(Sender: TObject);
    procedure btnINCLUIClick(Sender: TObject);
    procedure btnSALVAClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    procedure botao_edicao(lFLAG:boolean);
    procedure limpa_campos;
    procedure habilita_edicao(lFLAG:Boolean);
  public
    CliqueBotao : TCliqueBotao;

  end;

var
  frmcad_padrao: Tfrmcad_padrao;


implementation


{$R *.lfm}

{ Tfrmcad_padrao }

procedure Tfrmcad_padrao.FormShow(Sender: TObject);
begin
  botao_edicao(false);
end;

procedure Tfrmcad_padrao.btnINCLUIClick(Sender: TObject);
begin
  limpa_campos;
  botao_edicao(true);
  cliqueBotao:=cbIncluir;
end;

procedure Tfrmcad_padrao.btnSALVAClick(Sender: TObject);
begin
  botao_edicao(false);
end;

procedure Tfrmcad_padrao.btnALTERAClick(Sender: TObject);
begin
  botao_edicao(true);
  cliqueBotao:=cbAlterar;
end;

procedure Tfrmcad_padrao.btnAPAGAClick(Sender: TObject);
begin
  limpa_campos;
  botao_edicao(false);
end;

procedure Tfrmcad_padrao.btNCANCELAClick(Sender: TObject);
begin
  botao_edicao(false);
  cliqueBotao:=cbNone;
end;

procedure Tfrmcad_padrao.botao_edicao(lFLAG: boolean);
begin
  btnINCLUI.Visible :=not lFLAG;
  btnALTERA.Visible :=not lFLAG;
  btnAPAGA.Visible  :=not lFLAG;
  btnSALVA.Visible  := lFLAG;
  btNCANCELA.Visible:= lFLAG;
  habilita_edicao(lFLAG);
end;

procedure Tfrmcad_padrao.limpa_campos;
var
  nX : integer;
begin
  for nX := 0 to ComponentCount -1 do
     begin
        if Components[nX] is TEdit then
           (Components[nX] as TEdit).Clear;
     end;
end;

procedure Tfrmcad_padrao.habilita_edicao(lFLAG: Boolean);
var
  nX : integer;
begin
  for nX := 0 to ComponentCount -1 do
     begin
        if Components[nX] is TEdit then
           begin
             if (Components[nX] as TEdit).Tag <> 99 then
                (Components[nX] as TEdit).Enabled:=lFLAG;
           end
        else if Components[nX] is TDateTimePicker then
           begin
             if (Components[nX] as TDateTimePicker).Tag <> 99 then
                (Components[nX] as TDateTimePicker).Enabled:=lFLAG;
           end
        else if Components[nX] is TCurrencyEdit then
           begin
             if (Components[nX] as TCurrencyEdit).Tag <> 99 then
                (Components[nX] as TCurrencyEdit).Enabled:=lFLAG;
           end
        else if Components[nX] is TButton then
           begin
             if (Components[nX] as TButton).Tag <> 99 then
                (Components[nX] as TButton).Enabled:=lFLAG;
           end
        else if Components[nX] is TComboBox then
           if (Components[nX] as TComboBox).Tag <> 99 then
              (Components[nX] as TComboBox).Enabled:=lFLAG;

     end;
end;




end.

