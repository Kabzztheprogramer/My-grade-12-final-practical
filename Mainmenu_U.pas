unit Mainmenu_U;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ExtCtrls, StdCtrls, pngimage, jpeg,manger_u,records_u,
  Smanagement_u, storecatalogue_U,POS_u ,Account_u,users_u , sproduct_u,help_u;

type
  TfrmMainMenu = class(TForm)
    Image9: TImage;
    Image2: TImage;
    Image3: TImage;
    Image7: TImage;
    Image6: TImage;
    Label1: TLabel;
    btnpos: TButton;
    Shape1: TShape;
    Shape2: TShape;
    Bntaccounted: TButton;
    Shape3: TShape;
    Btnadim: TButton;
    Shape4: TShape;
    Button4: TButton;
    Shape5: TShape;
    btnsmanagement: TButton;
    Shape6: TShape;
    Button6: TButton;
    Image5: TImage;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    Shape7: TShape;
    Image1: TImage;
    procedure BtnadimClick(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure btnsmanagementClick(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure btnposClick(Sender: TObject);
    procedure BntaccountedClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure loadusersname ;
    procedure BitBtn2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMainMenu: TfrmMainMenu;
  objUser :tuser;
  susers : string;

implementation

{$R *.dfm}

procedure TfrmMainMenu.btnposClick(Sender: TObject);
begin
 //checking if the users has access to the button
  loadusersname;
if uppercase(copy(susers,1,1))='K' then
POS_u.FrmPOS.Visible:=true
else
MessageDlg('Your profile can not access this button', mtWarning, [mbOK], 0);
end;

procedure TfrmMainMenu.BitBtn2Click(Sender: TObject);
begin
//help text Main Menu
help_u.Frmhelp.Visible:= true;
help_u.Frmhelp.redout.Lines.Clear;
help_u.Frmhelp.redout.Lines.Add('MAIN MENU HELP!!');
help_u.Frmhelp.redout.Lines.Add('------------------------------------------------------------');
help_u.Frmhelp.redout.Lines.Add('BUTTONS ON THE FORMS!'+#13);
help_u.Frmhelp.redout.Lines.Add('POINT OF SALE {Button can only be accessed by'+
' STOREKEEPER. }'+#13);
help_u.Frmhelp.redout.Lines.Add('STORE ACCOUNTS {Button can only be accessed by'+
'  ACCOUNTENT. }'+#13);
help_u.Frmhelp.redout.Lines.Add('REPORTS {Button can be accessed by ALL '+
' find your different records here. }'+#13);
help_u.Frmhelp.redout.Lines.Add(' STOTRE CATALOGUE {All can access find. '+
' All store products can be seen here. }'+#13);
help_u.Frmhelp.redout.Lines.Add('STORE MANAGEMENT {Button can only be accessed by'+
' STORE MANGER. }'+#13);
help_u.Frmhelp.redout.Lines.Add('CLOSE {Close the app}'+#13);
help_u.Frmhelp.redout.Lines.Add('Log out {Log out of  app}'+#13);


end;

procedure TfrmMainMenu.BntaccountedClick(Sender: TObject);
begin
 //checking if the users has access to the button
   loadusersname;
if uppercase(copy(susers,1,1))='A' then
Account_u.frmaccount.Visible:= true
else
MessageDlg('Your profile can not access this button', mtWarning, [mbOK], 0);

end;

procedure TfrmMainMenu.BtnadimClick(Sender: TObject);
begin
 //checking if the users has access to the button
   loadusersname;
if uppercase(copy(susers,1,1))='D' then
manger_u.FrmDataM.Visible := true
else
MessageDlg('Your profile can not access this button', mtWarning, [mbOK], 0);
end;

procedure TfrmMainMenu.Button4Click(Sender: TObject);
begin
//checking if the users has access to the button
  loadusersname;
records_u.FrmReports.Visible:= true;
 if uppercase(copy(susers,1,1))='K' then
 begin
 records_u.FrmReports.mysales.Visible:= true;
 end;


end;

procedure TfrmMainMenu.btnsmanagementClick(Sender: TObject);
begin
 //checking if the users has access to the button
   loadusersname;
if uppercase(copy(susers,1,1))='M' then
Smanagement_u.frmmanagement.Visible:= true
else
MessageDlg('Your profile can not access this button', mtWarning, [mbOK], 0);
end;

procedure TfrmMainMenu.Button6Click(Sender: TObject);
begin
storecatalogue_U.frmcatalogeP1.Visible:= true;
end;

procedure TfrmMainMenu.FormActivate(Sender: TObject);
begin
//connecting the object
objUser:= tUser.create;

//susers:= objUser.getuserID;
end;

procedure TfrmMainMenu.loadusersname;
begin
 // setting getting the usersname  ;
objUser.setusers;
susers:= objUser.getuserID;
end;

end.
