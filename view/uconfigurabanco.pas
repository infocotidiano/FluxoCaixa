unit uconfigurabanco;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  Buttons, IniFiles;

type

  { Tfrmconfigurabanco }

  Tfrmconfigurabanco = class(TForm)
    btnCANCEL: TSpeedButton;
    edtBANCO: TEdit;
    edtDLLMariaDB: TEdit;
    edtUSER: TEdit;
    edtServer: TEdit;
    edtPORTA: TEdit;
    edtSenha: TEdit;
    edtODBC: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Shape1: TShape;
    btnSALVA: TSpeedButton;
    procedure btnCANCELClick(Sender: TObject);
    procedure btnSALVAClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
     procedure salva_ini;
     procedure ler_ini;
  public

  end;

var
  frmconfigurabanco: Tfrmconfigurabanco;

implementation
 uses uprincipal;

{$R *.lfm}

{ Tfrmconfigurabanco }

procedure Tfrmconfigurabanco.btnSALVAClick(Sender: TObject);
begin
  salva_ini;
  close;
end;

procedure Tfrmconfigurabanco.btnCANCELClick(Sender: TObject);
begin
  close;
end;

procedure Tfrmconfigurabanco.FormShow(Sender: TObject);
begin
  ler_ini;
end;

procedure Tfrmconfigurabanco.salva_ini;
var
  ArqINI : TIniFile;
begin
  ArqINI := TIniFile.Create(cfg_arqINI);
  try
    ArqINI.WriteString('ConexaoDB','Banco',edtBANCO.Text);
    ArqINI.WriteString('ConexaoDB','Server',edtServer.Text);
    ArqINI.WriteInteger('ConexaoDB','Porta', StrToIntDef(edtPORTA.Text,3306));
    ArqINI.WriteString('ConexaoDB','User',edtUSER.Text);
    ArqINI.WriteString('ConexaoDB','Senha',edtSenha.Text);
    ArqINI.WriteString('ConexaoDB','ODBC',edtODBC.Text);
    ArqINI.WriteString('ConexaoDB','DLL',edtDLLMariaDB.Text);
  finally
    ArqINI.Free;
  end;


end;

procedure Tfrmconfigurabanco.ler_ini;
var
ArqIni : TIniFile;
begin
    ArqIni := TIniFile.Create(cfg_arqINI);
    try
      edtBANCO.Text  := ArqIni.ReadString('ConexaoDB','Banco','fluxo_caixa');
      edtServer.Text := ArqIni.ReadString('ConexaoDB','Server','localhost');
      edtPORTA.Text  := InttoStr( ArqIni.ReadInteger('ConexaoDB','Porta',3306));
      edtUSER.Text   := ArqIni.ReadString('ConexaoDB','User','suporte');
      edtSenha.Text  := ArqIni.ReadString('ConexaoDB','Senha','Info@1234');
      edtODBC.Text  := ArqIni.ReadString('ConexaoDB','ODBC','mariadb ODBC 3.1 Driver');
      edtDLLMariaDB.Text  := ArqIni.ReadString('ConexaoDB','DLL','libmariadb.dll');
    finally
      ArqINI.Free;
    end;

end;


end.

