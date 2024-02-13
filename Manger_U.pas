unit Manger_U;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, DBGrids, pngimage, jpeg, ExtCtrls, ComCtrls, Buttons ,
  ConnectDB_U,db,ADODB,Spin,sproduct_u,help_u ;

type
  TFrmDataM = class(TForm)
    DBGEFB: TDBGrid;
    Image4: TImage;
    btndisplay: TButton;
    Edtsearch: TEdit;
    Button3: TButton;
    Label6: TLabel;
    Edtname: TEdit;
    edtSurCod: TEdit;
    DTPDOB: TDateTimePicker;
    Image3: TImage;
    Image2: TImage;
    lblchage1: TLabel;
    lblchange2: TLabel;
    lblname: TLabel;
    Label2: TLabel;
    Label1: TLabel;
    Image6: TImage;
    Image5: TImage;
    Image1: TImage;
    Rgbgender: TRadioGroup;
    CbxCatPos: TComboBox;
    edtpasscust: TEdit;
    Lblchange3: TLabel;
    Lblchange4: TLabel;
    lblgenqu: TLabel;
    Button4: TButton;
    BitBtn1: TBitBtn;
    Button5: TButton;
    BitBtn2: TBitBtn;
    rgbtables: TRadioGroup;
    Label10: TLabel;
    CBXsold: TCheckBox;
    Sedtquantity: TSpinEdit;
    lblphonenum: TLabel;
    edtphonenum: TEdit;
    BitBtn3: TBitBtn;
    Imgproduct: TImage;
    lblPmessage: TLabel;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure rgbtablesClick(Sender: TObject);
    procedure FormchangeU ;
    procedure FormchangeP ;
    procedure Button3Click(Sender: TObject);
    procedure btndisplayClick(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure edtpasscustChange(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
     var
    objproduct : Tproduct;
    dbCONN : Tconnection;
    tblusers : TAdotable;
    tblproduct : TADOTable;
    dscebf : TDataSource;
    bpassword : boolean;

  end;

var
  FrmDataM: TFrmDataM;



implementation
 uses
 Mainmenu_U;

{$R *.dfm}

procedure TFrmDataM.BitBtn2Click(Sender: TObject);
begin
Mainmenu_U.frmMainMenu.Visible:= true ;
FrmDataM.Close;
end;

procedure TFrmDataM.BitBtn3Click(Sender: TObject);
begin
help_u.Frmhelp.Visible:= true;
help_u.Frmhelp.redout.Lines.Clear;
help_u.Frmhelp.redout.Lines.Add('MANGER HELP!!');
help_u.Frmhelp.redout.Lines.Add('------------------------------------------------------------');
help_u.Frmhelp.redout.Lines.Add('NAVIGATION HELP!'+#13);
help_u.Frmhelp.redout.Lines.Add('First select the table where you would like to'+
' edit the record , selct it from the radio group that has the two tables names'+
 '"TBLPRODUCTS" OR "TBLUSERS"'+#13);
 help_u.Frmhelp.redout.Lines.Add('Now enter the record name in the edit box'+
 ' press the search button !'+#13);
 help_u.Frmhelp.redout.Lines.Add('Now dislpay the record by pressing the dislpay button'+
 'the record will be displayed in it respective componets on the from'+ #13
 +'Press the UPDATE BUTTON onces edits are done OR DELETE BUTTON to delete the'
 + 'record from the database  ');





end;

procedure TFrmDataM.btndisplayClick(Sender: TObject);
begin
case rgbtables.ItemIndex of
0: Begin
//displaying the record information on the form items
Edtname.Text:=  tblusers['Name'];
edtSurCod.Text := tblusers['Surname'] ;
edtphonenum.Text := '0'+ Inttostr(tblusers['PhoneNo']) ;
if tblusers['Gender']= 'M' then
Rgbgender.ItemIndex:= 0
else
 Rgbgender.ItemIndex := 1 ;
 DTPDOB.Date :=  tblusers['DateofBirth'] ;
 CbxCatPos.Text  := tblusers['Position'] ;
 edtpasscust.Text := tblusers['Password'];
End;
1: Begin
//displaying the record information on the form items
objproduct.tblloaditems;
Edtname.Text:=  objproduct.getname;
edtSurCod.Text := objproduct.getcode;
CbxCatPos.Text  :=objproduct.getcategory ;
edtphonenum.Text := floatToStr(objproduct.getPrice)  ;
Sedtquantity.Value:= objproduct.getQuantity;
objproduct.readfile;
Imgproduct.Picture.LoadFromFile(objproduct.getpath);
End;
end;
end;

procedure TFrmDataM.Button3Click(Sender: TObject);
var
bfound: boolean;
begin

if rgbtables.ItemIndex = 0 then
begin
//searching in table users
tblusers.First;
while not tblusers.Eof do
begin
  tblusers.Filtered := false ;
  tblusers.Filter := 'Name ='+ QuotedStr( Edtsearch.Text);
  tblusers.Filtered:= true ;
  tblusers.Next;
end;
end else
begin
//searching  in table product
Bfound:= objproduct.searchtable(Edtsearch.Text) ;
end;

end;

procedure TFrmDataM.Button4Click(Sender: TObject);
begin
//deleting a record from the data base
case rgbtables.ItemIndex of
  0:  If(MessageDlg('Are you sure you want to delete record for:' +
    tblusers['name'] +' ' + tblusers['Surname'] + '?',mtWarning,
    [mbok,mbCancel],0)=mrOk)then tblusers.Delete;
    1:  If(MessageDlg('Are you sure you want to delete record for:'+
    tblproduct['name'] +' ' + inttostr(tblproduct['Code'] )+ '?',mtWarning,
    [mbok,mbCancel],0)=mrOk)then tblproduct.Delete;
  end;
end;
procedure TFrmDataM.Button5Click(Sender: TObject);
var
bsold:boolean;
begin
// Updating the changes made on the form to the database
case rgbtables.ItemIndex of
0: Begin
//verifing
 if (DTPDOB.Date >= now ) or (edtSurCod.Text = '' ) or (Edtname.text = '') or
 (Bpassword = false) or (CbxCatPos.text = '')or (edtphonenum.text = '')then
 begin
 ShowMessage('Please eneter all correct detials updated');
exit;
 end else
 begin
//Updating changes made on table users
tblusers.Edit;
tblusers['Name']:=  Edtname.Text ;
tblusers['Surname']  := edtSurCod.Text ;
tblusers['PhoneNo']:= edtphonenum.text ;
tblusers['Gender'] := Rgbgender.Items[Rgbgender.ItemIndex];
tblusers['DateofBirth'] :=  DTPDOB.Date ;
tblusers['Position']  := CbxCatPos.Text  ;
tblusers['Password'] :=edtpasscust.Text  ;
tblusers.Post;
showmessage('Record update')
 end;
End;

1: Begin
 if (edtSurCod.Text = '' ) or (Edtname.text = '') or(CbxCatPos.text = '')
 or (edtphonenum.Text ='') then
Begin
showmessage('Please eneter all correct detials updated');
exit;
End;
//Updating changes made on table product;
if CBXsold.Checked then
begin
bsold:= true
end else
bsold:= false;
objproduct.loaditmes(objproduct.getcode,Edtname.Text,CbxCatPos.Text,
objproduct.getpath,edtpasscust.Text,strtofloat(edtphonenum.Text),
Sedtquantity.Value,bsold );
objproduct.editrecored;
ShowMessage('Product detials updated');
End;
end;

end;

procedure TFrmDataM.edtpasscustChange(Sender: TObject);
var
spassword : string;
i,icap,inum,ichar: integer;
Ddob: TDatetime;
begin
Bpassword:= false;
spassword:= edtpasscust.Text;
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
  edtpasscust.SetFocus;
  exit
 end else
  lblPmessage.Caption:= '';
 end;
//num
if not (inum >= 2) then
 begin
  lblPmessage.Caption := 'Your password should have atleast 2 numbers ' ;
  edtpasscust.SetFocus;
  exit
 end else
  lblPmessage.Caption:= '';
 //char
 if not (ichar >= 1) then
 begin
  lblPmessage.Caption :=
  'Your password should have one of these Symblos @ # $ * . ! < > ' ;
  edtpasscust.SetFocus;
  exit
 end else
  lblPmessage.Caption:= '';
  // length
 if not (Length(spassword) >= 7 ) then
 begin
  lblPmessage.Caption := 'Your password should be at least 7 characters  ' ;
  edtpasscust.SetFocus;
  exit
 end else
  lblPmessage.Caption:= '';

 Bpassword:= true;
 showmessage('i')
end;

procedure TFrmDataM.FormActivate(Sender: TObject);
begin
//create the object
objproduct := Tproduct.create;
//conneceting the tables to the from
dbCONN := Tconnection.Create;
dbCONN.dbconnect;
tblusers:= dbCONN.tblusers;
tblproduct := dbCONN.tblproducts;
end;

procedure TFrmDataM.FormClose(Sender: TObject; var Action: TCloseAction);
begin
//disconnecting the database
dbCONN.dbdisconnect;
end;


procedure TFrmDataM.FormchangeP;
//changing the from if the table selceted is the products table
begin
//changing label captions
  lblchage1.Caption:= 'Code';
lblchange2.Caption := 'Sold';
Lblchange3.Caption:= 'Category';
//Lblchange4.Caption:= 'CustomerID' ;
Rgbgender.Visible:= False;
lblgenqu.Caption:= 'Quantity';
//Changing form items Eg edit box /combo box
lblphonenum.Caption:= 'Price';
Sedtquantity.Visible:= true;
DTPDOB.Visible:= false;
//cbxsold.Visible:= true;
edtpasscust.Visible:= false;
CbxCatPos.Items.Clear ;
CbxCatPos.Items.Add('Solar Power');
CbxCatPos.Items.Add('Water Heating');
CbxCatPos.Items.Add('lighting');
CbxCatPos.Items.Add('Energy Efficienciy');
CbxCatPos.Items.Add('Water Saving');
CbxCatPos.Items.Add('Green House');
end;

procedure TFrmDataM.FormchangeU;
//changing the from if the table selceted is the users table
begin
//changing label captions
lblchage1.Caption:= 'Surname';
lblchange2.Caption := 'Date of Birth';
Lblchange3.Caption:= 'Postion';
Lblchange4.Caption:= 'Password' ;
edtpasscust.Visible:= true;
//Changing form items Eg edit box /combo box
lblphonenum.Caption:= 'Phone number';
CbxCatPos.Items.Clear ;
CbxCatPos.Items.Add('Accounted');
CbxCatPos.Items.Add('Keeper');
CbxCatPos.Items.Add('Manger');
CbxCatPos.Items.Add('Database Manger');
Rgbgender.Visible:= true;
lblgenqu.Caption := 'gender';
Sedtquantity.Visible:= false;
DTPDOB.Visible:= true;
cbxsold.Visible:= False;
//CbxCatPos.AddItem
end;


procedure TFrmDataM.rgbtablesClick(Sender: TObject);
//changing the tables on the grid and the form according to the type of table
begin
if rgbtables.ItemIndex=0 then
begin
dbconn.setupGrids(DBGEFB);
FormchangeU
end else
begin
objproduct.setupgrid;
FormchangeP;
end;

end;

end.
