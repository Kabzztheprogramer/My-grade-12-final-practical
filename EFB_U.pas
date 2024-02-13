unit EFB_U;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, jpeg, ExtCtrls, StdCtrls, pngimage,signup_U,manger_u,records_u,Mainmenu_u,
  Buttons , ConnectDB_U,db,ADODB,Spin, users_u ;

type
  Tfrmloing = class(TForm)
    Cbxusername: TComboBox;
    edtpassword: TEdit;
    btnlogin: TButton;
    btnsignup: TButton;
    Imbackground2: TImage;
    lblheading: TLabel;
    Imgbackground: TImage;
    Imgbatter: TImage;
    imgefb: TImage;
    Lblusername: TLabel;
    Lblloning: TLabel;
    Lblusername2: TLabel;
    lblpassword: TLabel;
    imgtringale: TImage;
    imgsolar: TImage;
    imgwind: TImage;
    Imgefb2: TImage;
    procedure btnsignupClick(Sender: TObject);
    procedure btnloginClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    var
  public
    { Public declarations }
    var
    objuser : Tuser ;
  end;

var
    frmloing: Tfrmloing;
    dbCONN : Tconnection;
    tblusers : TAdotable;
    tblproduct : TADOTable;
    dscebf : TDataSource;
    susers :string;
implementation

uses Items_U;

{$R *.dfm}

procedure Tfrmloing.btnloginClick(Sender: TObject);
var
sline : string;
begin
if Cbxusername.Text  ='' then
begin
showmessage('Enter your detials');
exit;
end;
//cheacking if log in detials are correct
objuser.searchbyusersID(Cbxusername.Text);
objuser.loadItems;
if edtpassword.Text= objuser.getpassword then
begin
 Mainmenu_u.frmMainMenu.Visible:= true;
 //adding the audit trails
if FileExists('Audittrail.txt')<> true then
begin
  showmessage('file does not exist');
  Exit;
end;
 AssignFile(Myfile,'Audittrail.txt');
 sline:= objuser.getuserID +'#'+ DateToStr(now)+'#'+ TimeToStr(now);
 Append(myfile);
 Writeln(myfile,sline);
 closefile(myfile);
 susers:= Cbxusername.Text;

end else
showmessage('Incorrect Password!!'+#13 +
'Please enter your correct password or please contact '+
'your database manger to change your password');

end;

procedure Tfrmloing.btnsignupClick(Sender: TObject);
begin
signup_U.frmsignup.Visible:= true
end;


procedure Tfrmloing.FormActivate(Sender: TObject);
begin
//create the object
objuser := tuser.Create;
//conneceting the tables to the from
dbCONN := Tconnection.Create;
dbCONN.dbconnect;
tblusers:= dbCONN.tblusers;
tblproduct := dbCONN.tblproducts;
tblusers.First;
while not tblusers.Eof do
begin
  Cbxusername.Items.add(tblusers['userID']);
  tblusers.Next;
end;
end;

procedure Tfrmloing.FormClose(Sender: TObject; var Action: TCloseAction);
begin
//disconnecting the database
dbCONN.dbdisconnect;
end;

end.
