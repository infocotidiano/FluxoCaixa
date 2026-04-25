unit uEstatistica_Despesa;
{***************************************************************************}

{   Autor:        Daniel de Morais                                          }
{   Projeto:      Fluxo de Caixa                                            }

{   Informações:  Código Fonte da Playlist do YouTube sobre aprendizagem    }
{                 de como criar um Fluxo de Caixa.                          }

{   Aviso Legal:  Este código é fornecido exclusivamente para fins de       }
{                 estudo e aprendizagem. Não há qualquer garantia,          }
{                 explícita ou implícita, de funcionamento, adequação       }
{                 ou ausência de erros.                                     }

{                 O autor não se responsabiliza por danos diretos,          }
{                 indiretos, incidentais ou consequenciais decorrentes      }
{                 do uso deste código em ambientes de produção.             }

{                 Ao utilizar este código, você concorda que qualquer       }
{                 modificação, adaptação ou uso será de sua inteira         }
{                 responsabilidade.                                         }

{***************************************************************************}


{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, DBGrids, Grids, Types;

type

  { TfrmEstatistica_Despesa }

  TfrmEstatistica_Despesa = class(TForm)
    DBGrid1: TDBGrid;
    pnpTITULO: TPanel;
    procedure DBGrid1DrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: integer; Column: TColumn; State: TGridDrawState);
  private

  public

  end;

var
  frmEstatistica_Despesa: TfrmEstatistica_Despesa;

implementation

{$R *.lfm}

{ TfrmEstatistica_Despesa }

procedure TfrmEstatistica_Despesa.DBGrid1DrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: integer; Column: TColumn; State: TGridDrawState);
var
  oRect: TRect;
  oGrid: TDBGrid;
  cTexto: string;
  nPercentual: extended;
  nLarguraTexto: TSize;
  nCorAntigaPen, nCorAntigaBrush: integer;
  lSalvaPenStyle: TPenStyle;
  lSalvaBrushStyle: TBrushStyle;
  lCampoPercentual: boolean;
begin
  oGrid := TDBGrid(Sender);
  if [gdSelected, gdFocused] * State <> [] then
    oGrid.Canvas.Brush.Color := clHighlight;

  lCampoPercentual := Column.FieldName.Equals('Percentual');

  if lCampoPercentual then
  begin
    oRect := Rect;
    oGrid.Canvas.Pen.Color := clNone;

    nCorAntigaPen := oGrid.Canvas.Pen.Color;
    nCorAntigaBrush := oGrid.Canvas.Brush.Color;
    lSalvaPenStyle := oGrid.Canvas.Pen.Style;
    lSalvaBrushStyle := oGrid.Canvas.Brush.Style;

    if Column.FieldName.Equals('Percentual') then
    begin
      cTexto := FormatFloat('##0.###', Column.Field.AsFloat) + '%';
      oGrid.Canvas.Brush.Style := bsSolid;
      oGrid.Canvas.FillRect(oRect);
      nPercentual := Column.Field.AsFloat / 100 * oRect.Width;
      oGrid.Canvas.Font.Size := oGrid.Font.Size - 1;

      oGrid.Canvas.Font.Color := clWhite;
      if Column.Field.AsFloat >= 60 then
        oGrid.Canvas.Brush.Color := $00E9782E
      else if (Column.Field.AsFloat > 30) and (Column.Field.AsFloat <= 59) then
        oGrid.Canvas.Brush.Color := $00F4AB22
      else if (Column.Field.AsFloat <= 29) then
        oGrid.Canvas.Brush.Color := $00F9D21E;

      oGrid.Canvas.RoundRect(oRect.Left, oRect.top,
        trunc(oRect.Left + nPercentual),
        oRect.Bottom, 2, 2);

      oRect.Inflate(-1, -1);
      oGrid.Canvas.Pen.Style := psClear;
      oGrid.Canvas.Font.Color := clBlack;
      oGrid.Canvas.Brush.Style := bsClear;

      nLarguraTexto := oGrid.Canvas.TextExtent(cTexto);

      oGrid.Canvas.TextOut(oRect.Left + ((oRect.Width div 2) -
        (nLarguraTexto.cx div 2)),
        oRect.Top + ((oRect.Height div 2) - (nLarguraTexto.cy div 2)), cTexto);
    end
    else
      oGrid.DefaultDrawColumnCell(Rect, DataCol, Column, State);
  end;
  if lCampoPercentual then
  begin
    oGrid.Canvas.Pen.Color := nCorAntigaPen;
    oGrid.Canvas.Brush.Color := nCorAntigaBrush;
    oGrid.Canvas.pen.Style := lSalvaPenStyle;
    oGrid.Canvas.Brush.Style := lSalvaBrushStyle;
  end;

end;




end.
