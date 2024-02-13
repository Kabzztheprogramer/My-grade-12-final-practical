unit Signup_U;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, pngimage, StdCtrls, ExtCtrls, ComCtrls, jpeg, Buttons,DMEFB_U,
  ConnectDB_U,db,ADODB,Math;

type
  Tfrmsignup = class(TForm)
    Image1: TImage;
    Edtname: TEdit;
    Rgbgender: TRadioGroup;
    Cbxposition: TComboBox;
    edtphonenum: TEdit;
    edtpassword: TEdit;
    Image2: TImage;
    Label1: TLabel;
    Image6: TImage;
    Image3: TImage;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Image4: TImage;
    Image5: TImage;
    Button1: TButton;
    Image7: TImage;
    DTPDOB: TDateTimePicker;
    BitBtn1: TBitBtn;
    bbtnExit: TBitBtn;
    edtsurname: TEdit;
    LblNmessage: TLabel;
    LblSmessage: TLabel;
    llbdmessage: TLabel;
    LblPosmessage: TLabel;
    LblPNmessage: TLabel;
    lblPmessage: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure RgbgenderClick(Sender: TObject);
    procedure EdtnameChange(Sender: TObject);   
    procedure edtsurnameChange(Sender: TObject);
    procedure DTPDOBChange(Sender: TObject);
    procedure CbxpositionChange(Sender: TObject);
    procedure edtphonenumChange(Sender: TObject);
    procedure edtpasswordChange(Sender: TObject);

  private
    { Private declarations }
    var
    dbCONN : Tconnection;
    tblusers : TAdotable;
    dscebf : TDataSource;
  public
    { Public declarations }
    function userIDcreate  : string ;
  end;

var
  frmsignup: Tfrmsignup;
  bname,Bsurname,bdate,bgender, Bpostion,Bphonenum,Bpassword: boolean;
implementation
uses
EFB_U;

{$R *.dfm}

procedure Tfrmsignup.Button1Click(Sender: TObject);
var
suserid,scheck,sdusers,sdpassword : string ;
icode : integer;
begin
//validation later
 if (Bdate = True) and (Bsurname = True ) and  (Bname= true) and
  (Bpassword = True) and (Bgender = True) and (Bpostion= true)and 
  (Bphonenum = true)  then
  begin
   // checking OTP
    repeat
  icode:=  RandomRange(1000,10000);
  showmessage('Your OTP is : ' + IntToStr(icode));
  scheck:= InputBox('OTP' ,'Please enter the OTP given to you ', '' );
  if scheck <> IntToStr(icode)  then
  showmessage('Incorrect OTP please try again ');
  until scheck = IntToStr(icode) ;
  end else
  begin
   ShowMessage('Please enter your details correctly' );
   exit
  end;
  //Database manger aprovel
  sdusers := InputBox('Database Manger details','Enter Usersname','') ;
  //checking if a database manger;
  if Copy(sdusers,1,1)<> 'D' then
  begin
    MessageDlg('Only Database mangers can give application rights to new users '
    , mtWarning, [mbOK], 0);
    exit;
  end;
  
  sdpassword := InputBox('Database Manger details','Enter Password','');
   tblusers.Filtered:= false;
   tblusers.Filter := 'UserID ='+ QuotedStr(sdusers);
   tblusers.Filtered:= true;
   if tblusers['password'] =  sdpassword  then
   showmessage('Aproved')
   else
   begin
     showmessage('Incorrect Detilas') ;
     exit;
   end;
   tblusers.Filtered:= false;
// entering name in the data base
suserid  := userIDcreate;
tblusers.Open;
tblusers.Last;
tblusers.Insert;
tblusers['Name']:= Edtname.Text;
tblusers['Surname']:= edtsurname.Text;
tblusers['PhoneNo']:= StrToInt(edtphonenum.Text);
tblusers['Gender'] := Rgbgender.Items[Rgbgender.ItemIndex];
tblusers['DateofBirth'] := DTPDOB.Date ;
tblusers['Position'] := Cbxposition.Text;
tblusers['Password'] := edtpassword.Text;
tblusers['UserID'] := suserid;
ShowMessage('Your userID is ' + suserid );
tblusers.Post;
EFB_U.frmloing.Visible:= true  ;
frmsignup.Close;
ShowMessage('This is your users ID : ' + ' '+suserid);
ShowMessage('Select on the Combo Box and login in : ' );




end;


procedure Tfrmsignup.CbxpositionChange(Sender: TObject);
begin
 if Cbxposition.text = '' then
 begin
 Cbxposition.SetFocus;
 LblPosmessage.Caption:= 'Please select your postion';
 exit
 end else
 begin
 LblPosmessage.Caption:= '';
 Bpostion:= true;
 end;
end;

procedure Tfrmsignup.DTPDOBChange(Sender: TObject);
begin
//verifing the date
 bdate := false  ;
 if DTPDOB.DateTime >= now() then
 begin
   bdate := false;
   llbdmessage.Caption:= 'Enter your correct date of birth';
 end else
 begin
 bdate := true ;
    llbdmessage.Caption:= ' ';
 end;
end;



procedure Tfrmsignup.EdtnameChange(Sender: TObject);
begin
  //cheacking if name was enetered
Bname:= False;
 if edtName.Text= '' then
 begin
 edtName.SetFocus;
 LblNmessage.Caption:= 'Please enter your name';
 end else
 begin
 LblNmessage.Caption:= ' ';
 Bname:= True  ;
end; 
end; 

procedure Tfrmsignup.edtpasswordChange(Sender: TObject);
var
spassword : string;
i,icap,inum,ichar: integer;
Ddob: TDatetime;
begin
Bpassword:= false;
spassword:= edtPassword.Text;
i:= 0;
icap:= 0;
inum:= 0;
ichar:= 0  ;
 // verifying password
 begin
 for i := 1 to length(spassword) do
 begin
   if (spassword[i] in ['0'..'9']) then
    inc(inum);
   if spassword[i] in ['A'..'Z'] then
    inc(icap);
   if  spassword[i] in  ['@','#','$','*','.','!','<','>'] then
   begin
    inc(ichar);
   end;
 end;
 //Cap
 if not (icap >= 1) then
 begin
  lblPmessage.Caption := 'Your password should have a captial letter' ;
  edtPassword.SetFocus;
  exit
 end else
  lblPmessage.Caption:= '';
 end;
//num
if not (inum >= 2) then
 begin
  lblPmessage.Caption := 'Your password should have atleast 2 numbers ' ;
  edtPassword.SetFocus;
  exit
 end else
  lblPmessage.Caption:= '';
 //char
 if not (ichar >= 1) then
 begin
  lblPmessage.Caption :=
  'Your password should have one of these Symblos @ # $ * . ! < > ' ;
  edtPassword.SetFocus;
  exit
 end else
  lblPmessage.Caption:= '';
  // length
 if not (Length(spassword) >= 7 ) then
 begin
  lblPmessage.Caption := 'Your password should be at least 7 characters  ' ;
  edtPassword.SetFocus;
  exit
 end else
  lblPmessage.Caption:= '';

 Bpassword:= true;

end;

procedure Tfrmsignup.edtphonenumChange(Sender: TObject);
begin
//checking phone number
Bphonenum:= False;
 if (edtphonenum.Text = '') and (Length(edtphonenum.Text)<>10) then
 begin
 edtphonenum.SetFocus;
 LblPNmessage.Caption:= 'Invalid phone number';
 end else
 if Length(edtphonenum.Text) =10  then
 begin
 Bphonenum:= True;
 LblPNmessage.Caption:= ' ';
end else
  LblPNmessage.Caption:= 'Invalid phone number';
end;

procedure Tfrmsignup.edtsurnameChange(Sender: TObject);
begin
//checking surname
Bsurname:= False;
 if edtSurname.Text = '' then
 begin
 edtSurname.SetFocus;
 LblSmessage.Caption:= 'Please enter your Surname';
 end else
 begin
 Bsurname:= True;
 LblSmessage.Caption:= ' ';
end;
end;

procedure Tfrmsignup.FormActivate(Sender: TObject);
begin
//seting up connection
dbCONN := Tconnection.Create;
dbCONN.dbconnect;
tblusers:= dbCONN.tblusers;
end;

procedure Tfrmsignup.FormClose(Sender: TObject; var Action: TCloseAction);
begin
dbCONN.dbdisconnect;
end;
 procedure Tfrmsignup.RgbgenderClick(Sender: TObject);
begin
bgender := true ;
end;

//create the Users ID
function Tfrmsignup.userIDcreate: string;
var
icount,inum: integer;
snum,sposion,sgender,spassword,sdate : string;
begin
//Positions first letter “K,D,A,M” + Initials + @ if a male or # if female +
//year+ position number
//Eg : MMK@001
//adding the gender key
//getting the code that will be add to the users ID
icount:= 0;
inum:= 0;
tblusers.first;
while not tblusers.Eof do
begin
icount:= strtoint(copy(tblusers['UserID'],7,length(tblusers['UserID'])-6));
if icount > inum  then
begin
  inum:= icount;
end;
 tblusers.Next
end;
tblusers.first;
sdate:= Copy(DateToStr(now),3,2);
snum:= sdate+inttostr(inum +1);
if Rgbgender.Items[Rgbgender.ItemIndex]='M' then
sgender := '@'
else
sgender := '#';
//creating the ID and giving it as a result
Result:= UpperCase(copy(Cbxposition.text,1,1))+ Copy(Edtname.Text,1,1)+
Copy(edtsurname.Text,1,1)+sgender + snum ;
end;

end.
