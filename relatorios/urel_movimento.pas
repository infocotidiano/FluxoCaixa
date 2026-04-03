unit urel_movimento;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, RLReport, RLParser;

type

  { Tfrmrel_movimento }

  Tfrmrel_movimento = class(TForm)
    RLBand1: TRLBand;
    RLBand2: TRLBand;
    RLBand3: TRLBand;
    RLDBText1: TRLDBText;
    RLDBText10: TRLDBText;
    RLDBText11: TRLDBText;
    RLDBText12: TRLDBText;
    RLDBText2: TRLDBText;
    RLDBText3: TRLDBText;
    RLDBText4: TRLDBText;
    RLDBText5: TRLDBText;
    RLDBText6: TRLDBText;
    RLDBText7: TRLDBText;
    RLDBText8: TRLDBText;
    RLDBText9: TRLDBText;
    RLDraw1: TRLDraw;
    RLDraw2: TRLDraw;
    RLDraw3: TRLDraw;
    RLLabel1: TRLLabel;
    lPeriodo: TRLLabel;
    lCONTA: TRLLabel;
    lSaldoAnterior: TRLLabel;
    lEmissao: TRLLabel;
    lSaldoAtual: TRLLabel;
    RLLabel2: TRLLabel;
    RLLabel3: TRLLabel;
    RLReport1: TRLReport;
  private

  public

  end;

var
  frmrel_movimento: Tfrmrel_movimento;

implementation

{$R *.lfm}

end.
