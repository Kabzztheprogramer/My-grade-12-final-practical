program EFB_P;

uses
  Forms,
  EFB_U in 'EFB_U.pas' {frmloing},
  Mainmenu_U in 'Mainmenu_U.pas' {frmMainMenu},
  Manger_U in 'Manger_U.pas' {frmDataM},
  Signup_U in 'Signup_U.pas' {frmsignup},
  Records_U in 'Records_U.pas' {FrmReports},
  DMEFB_U in 'DMEFB_U.pas' {DMEFB: TDataModule},
  ConnectDB_U in 'ConnectDB_U.pas',
  Smanagement_U in 'Smanagement_U.pas' {frmmanagement},
  storecatalogue_U in 'storecatalogue_U.pas' {frmcatalogeP1},
  sproduct_u in 'sproduct_u.pas',
  POS_u in 'POS_u.pas' {FrmPOS},
  Account_u in 'Account_u.pas' {frmaccount},
  users_u in 'users_u.pas',
  help_U in 'help_U.pas' {Frmhelp};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(Tfrmloing, frmloing);
  Application.CreateForm(TfrmMainMenu, frmMainMenu);
  Application.CreateForm(TfrmDataM, frmDataM);
  Application.CreateForm(Tfrmsignup, frmsignup);
  Application.CreateForm(TfrmReports, frmReports);
  Application.CreateForm(TDMEFB, DMEFB);
  Application.CreateForm(Tfrmmanagement, frmmanagement);
  Application.CreateForm(TfrmcatalogeP1, frmcatalogeP1);
  Application.CreateForm(TFrmPOS, FrmPOS);
  Application.CreateForm(Tfrmaccount, frmaccount);
  Application.CreateForm(TFrmhelp, Frmhelp);
  Application.Run;
end.
