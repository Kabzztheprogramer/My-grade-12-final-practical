unit Smanagement_U;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DBCtrls, StdCtrls, pngimage, ExtCtrls, jpeg, Buttons, Spin,
  ConnectDB_U,db,ADODB ,sproduct_u , help_u;

type
  Tfrmmanagement = class(TForm)
    btnpicture: TButton;
    Image9: TImage;
    Shape1: TShape;
    imgproduct: TImage;
    Edtname: TEdit;
    edtprice: TEdit;
    Cbxcategory: TComboBox;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    BitBtn2: TBitBtn;
    BitBtn1: TBitBtn;
    BitBtn3: TBitBtn;
    Image7: TImage;
    Shape2: TShape;
    Button2: TButton;
    Button5: TButton;
    Button3: TButton;
    Label1: TLabel;
    Image4: TImage;
    Sedtquanity: TSpinEdit;
    procedure btnpictureClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button3Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure addtofile;
    procedure BitBtn2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }

  end;

var
  objproduct : Tproduct;
  frmmanagement: Tfrmmanagement;
  dbCONN : Tconnection;
    tblproduct : TADOTable;
    dscebf : TDataSource;
    spath,scode:string;
    myfile : TextFile;

implementation

{$R *.dfm}

procedure Tfrmmanagement.addtofile;
begin
//add the picture file path to the text file
if FileExists('picturepath.txt')<> true then
begin
  showmessage('File does not exists');
  Exit;
end;
AssignFile(Myfile,'picturepath.txt');
Append(myfile);
Writeln(myfile,scode+'*'+spath);
CloseFile(myfile);
end;

procedure Tfrmmanagement.BitBtn2Click(Sender: TObject);
begin
//help text
help_u.Frmhelp.Visible:= true;
help_u.Frmhelp.redout.Lines.Clear;
help_u.Frmhelp.redout.Lines.Add('Store Management  HELP!!');
help_u.Frmhelp.redout.Lines.Add('---------------------------------------------'+
'------------------------------------------------------------------');
help_u.Frmhelp.redout.Lines.Add('NAVIGATION HELP!'+#13);
help_u.Frmhelp.redout.Lines.Add('ADD ITEM');
help_u.Frmhelp.redout.Lines.Add('---------------------------------------------'+
'-------------------------------------------------------------------');
help_u.Frmhelp.redout.Lines.Add('Enter Item detials on the from componets '+
'Press the PICTURE Button to add an image of the product'+ #13 );

help_u.Frmhelp.redout.Lines.Add('Once Detials enter on the componts press the '
+ 'ADD Button to insert your product to your store' + #13);
help_u.Frmhelp.redout.Lines.Add('EDIT ITEM');
help_u.Frmhelp.redout.Lines.Add('---------------------------------------------'+
'-------------------------------------------------------------------');
help_u.Frmhelp.redout.Lines.Add('Press the SEARCH button to search for the '+
' product by its name , the product will the display on the Componets of the '+
'from ' + #13);
help_u.Frmhelp.redout.Lines.Add('Onces edits are done PRESS UPDATE to update '+
'the detials '+ #13);

end;

procedure Tfrmmanagement.btnpictureClick(Sender: TObject);
var
  OpenDialog: TOpenDialog;
begin
//Fining the file path of an image
  OpenDialog := TOpenDialog.Create(nil);
  try
    OpenDialog.Filter := 'Image Files|*.bmp;*.jpg;*.jpeg;*.png';
    if OpenDialog.Execute then
    begin
    //adding the image to the image component on the form;
      imgproduct.Picture.LoadFromFile(OpenDialog.FileName);
      spath:= OpenDialog.FileName;
    end;
  finally
    OpenDialog.Free;
  end;
end;

procedure Tfrmmanagement.Button2Click(Sender: TObject);
var
sdescription: string  ;
begin
//checking if a file exixts
 if (spath = '' ) or (Edtname.text = '') or(Cbxcategory.text = '')
 or (edtprice.Text ='')or (Sedtquanity.Value = 0) then
 Begin
   ShowMessage('Enter Detials correct');
   exit;
 End;
if FileExists('picturepath.txt')<> true then
begin
  showmessage('File does not exists');
  Exit;
end;
//add a product to the database
 objproduct.loaditmes(' ',Edtname.Text,Cbxcategory.Text,spath,'',
 strtofloat(edtprice.Text),Sedtquanity.Value,false);
 objproduct.createcode;
 objproduct.addtofile;
 objproduct.addtoDM;
showmessage('Product add to the strore ');
sdescription := InputBox('Product discription','Add a product discription','') ;
//checking if a file exixts
if FileExists('description.txt')<> true then
begin
  showmessage('File does not exists');
  Exit;
end;
objproduct.adddescription(sdescription);
end;

procedure Tfrmmanagement.Button3Click(Sender: TObject);
Var
sname:string;
bfouned : boolean;
begin
//search for the product
sname := InputBox('Search for products','Enter product name :', '');
bfouned:= objproduct.searchtable(sname);

//displaying the product  if it is found
if bfouned= true then
Begin
//i'm here
showmessage ('product found and will be displayed on the form componets ');
objproduct.tblloaditems ;
Edtname.Text :=  objproduct.getname ;
Cbxcategory.Text := objproduct.getcategory;
edtprice.Text := FloatToStr( objproduct.getPrice )  ;
Sedtquanity.Value := objproduct.getQuantity;
scode:= objproduct.getcode;
btnpicture.Visible:= false;
//checking if a file exixts
if FileExists('picturepath.txt')<> true then
begin
  showmessage('File does not exists');
  Exit;
end;
objproduct.readfile;
imgproduct.Picture.LoadFromFile(objproduct.getpath);
spath:= objproduct.getpath;
end else
showmessage ('product found not found ');

end;

procedure Tfrmmanagement.Button5Click(Sender: TObject);
begin
 //verifing product detials
 if (spath = '' ) or (Edtname.text = '') or(Cbxcategory.text = '')
 or (edtprice.Text ='')or (Sedtquanity.Value = 0) then
 Begin
   ShowMessage('Enter Detials correct');
   exit;
 End;
 //upadting the changes made of the the product
btnpicture.Visible:= true;
objproduct.loaditmes(scode,Edtname.Text,Cbxcategory.Text,spath,'',
strtofloat(edtprice.Text),Sedtquanity.Value,false);
objproduct.editrecored;
showmessage('Product detials have been up dated ')
end;

procedure Tfrmmanagement.FormActivate(Sender: TObject);
begin
//conneceting the tables to the from
dbCONN := Tconnection.Create;
dbCONN.dbconnect;
tblproduct := dbCONN.tblproducts;
//create the object
objproduct:= tproduct.create;
end;

procedure Tfrmmanagement.FormClose(Sender: TObject; var Action: TCloseAction);
begin
//disconnecting the database
dbCONN.dbdisconnect;
end;

end.
