unit URelMedicos;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UPadrao, DB, StdCtrls, Buttons, ComCtrls, DBCtrls, ExtCtrls;

type
  TfrmRelMedicos = class(TfrmPadrao)
    rgSelecao: TRadioGroup;
    gbPeriodo: TGroupBox;
    gbIndividual: TGroupBox;
    DBLookupComboBox1: TDBLookupComboBox;
    Label1: TLabel;
    Label2: TLabel;
    DateTimePicker1: TDateTimePicker;
    DateTimePicker2: TDateTimePicker;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    procedure rgSelecaoClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmRelMedicos: TfrmRelMedicos;

implementation

uses UDMPrincipal;

{$R *.dfm}

procedure TfrmRelMedicos.BitBtn1Click(Sender: TObject);
begin
  inherited;
  DMpRINCIPAL.sqlRelMedicos.Close;
  dmPrincipal.sqlRelMedicos.SQL.Clear;
  dmPrincipal.sqlRelMedicos.SQL.Add('SELECT MEDICO.*, NOME_ESPECIALIZACAO, DESCRICAO_ESPECIALIZACAO');
  dmPrincipal.sqlRelMedicos.SQL.Add('FROM ESPECIALIZACOES_MEDICOS, MEDICOS, ESPECIALIZACOES');
  dmPrincipal.sqlRelMedicos.SQL.Add('WHERE ESPECIALIZACOES_MEDICOS.CODIGO_MEDICO = MEDICO.CODIGO_MEDICO');
  dmPrincipal.sqlRelMedicos.SQL.Add('AND ESPECIALIZACOES_MEDICOS.CODIGO_ESPECIALIZACAO=');
  dmPrincipal.sqlRelMedicos.SQL.Add('ESPECIALIZACOES.CODIGO_ESPECIALIZACAO');

  if rgSelecao.ItemIndex = 1 then
  BEGIN
    dmPrincipal.sqlRelMedicos.SQL.Add('AND ESPECIALIZACOES_MEDICOS.CODIGO_MEDICO=' +
      dmPrincipal.cdsMedicosCODIGO_MEDICO.AsString)
  END;

  if rgSelecao.ItemIndex = 2 then
  BEGIN
    dmPrincipal.sqlRelMedicos.SQL.Add('AND DT_CADASTRO_MEDICO BETWEEN ' +
      CHR(39) + DateToStr(DateTimePicker1.Date) + CHR(39));
      DMpRINCIPAL.sqlRelMedicos.SQL.Add('AND ' + CHR(39) + DateToStr(DateTimePicker2.Date) + Chr(39));
  END;

  DMpRINCIPAL.sqlRelMedicos.SQL.Add('ORDER BY NOME_MEDICO');
  dmPrincipal.sqlRelMedicos.Open;

  dmPrincipal.RvPrjConsultorio.ExecuteReport('rptMedicos');
end;

procedure TfrmRelMedicos.FormActivate(Sender: TObject);
begin
  inherited;
  rgSelecao.ItemIndex := 0;
  rgSelecaoClick(self);
  dmPrincipal.CarregarTodos(dmPrincipal.sqlMedicos, dmPrincipal.cdsMedicos,
      'MEDICOS','NOME_MEDICO');
end;

procedure TfrmRelMedicos.rgSelecaoClick(Sender: TObject);
begin
  inherited;
  gbIndividual.Enabled := rgSelecao.ItemIndex = 1;
  gbPeriodo.Enabled := rgSelecao.ItemIndex = 2;
end;

end.