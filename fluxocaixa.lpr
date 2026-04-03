program fluxocaixa;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  sysutils, Forms, utabela, classe_conta, classe_contareceber, classe_entidade,
  classe_lancamento, classe_plano, classe_registrofinanceiro, importa,
  ucad_conta, ucad_entidade, ucad_lcto, ucad_padrao, ucad_planoconta,
  uconfigurabanco, uEstatistica_Despesa, umovimento, upesquisa, upesquisa_lcto,
  uprincipal, urel_movimento, zcomponent, rxnew, pack_powerpdf, datetimectrls,
  ucad_receber, ucad_pagar;

{$R *.res}

begin

    RequireDerivedFormResource:=True;
    Application.Scaled:=True;

    Application.Initialize;
    Application.CreateForm(TTabGlobal, TabGlobal);
    Application.CreateForm(Tfrmprincipal, frmprincipal);
    Application.Run;
end.
