unit storecatalogue_U;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, jpeg, ExtCtrls, Buttons, Spin, pngimage, ComCtrls  ,
  ConnectDB_U,db,ADODB,sproduct_u,help_U;

type
  TfrmcatalogeP1 = class(TForm)
    Image9: TImage;
    Label1: TLabel;
    Shape1: TShape;
    lblcategory: TLabel;
    imgproduct: TImage;
    Label2: TLabel;
    Lblproduct1: TLabel;
    lblprice1: TLabel;
    reddetials1: TRichEdit;
    Image4: TImage;
    lblcategory2: TLabel;
    Shape2: TShape;
    Imgproduct2: TImage;
    LblLname2: TLabel;
    Label8: TLabel;
    lblprice2: TLabel;
    reddetials2: TRichEdit;
    Shape3: TShape;
    BitBtn2: TBitBtn;
    BitBtn1: TBitBtn;
    Image3: TImage;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button1: TButton;
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    objproduct : Tproduct;
    dbCONN : Tconnection;
    tblproduct : TADOTable;
    dscebf : TDataSource;
    myfile : TextFile;
    iscount,ihcount,iwcount,ilcount,iecount,igcount: integer;
  end;

var
  frmcatalogeP1: TfrmcatalogeP1;
  iarray,iarray2: integer;
  arrproducts: array[1..6,1..100] of string ;
  arrcategory : array[1..6] of string =('Solar Power','Water Heating','Lighting',
'Energy Efficiency','Water Saving','Green Home');
icount : integer;

implementation

{$R *.dfm}

procedure TfrmcatalogeP1.BitBtn2Click(Sender: TObject);
begin
help_u.Frmhelp.Visible:= true;
help_u.Frmhelp.redout.Lines.Clear;
help_u.Frmhelp.redout.Lines.Add('STORE CATALOGUE HELP!!');
help_u.Frmhelp.redout.Lines.Add('------------------------------------------------------------');
help_u.Frmhelp.redout.Lines.Add('NAVIGATION HELP!'+#13);
help_u.Frmhelp.redout.Lines.Add('Click Next Category to change the product category'+
'Then the Next product to change the product '+ #13 );
help_u.Frmhelp.redout.Lines.Add('all product information is displayed on the  '
+ 'componets of the from' + #13);
end;

procedure TfrmcatalogeP1.Button1Click(Sender: TObject);
var
iclick : integer ;
scode : string;
begin
 case iarray2  of
 4:begin
    reddetials2.Clear;
    if icount = iecount then
     icount := 0;
//reading displaying the detials
     icount:= icount +1 ;
     scode:=arrproducts[iarray2,icount];
     if scode = '' then
      showmessage('there are no items in this Category')
      else
      begin
     objproduct.searchbycode(scode);
     objproduct.tblloaditems;
     objproduct.readfile;
     objproduct.readdescription;
     LblLname2.Caption:= objproduct.getname;
     lblprice2.Caption:= FloatToStrF(objproduct.getPrice,ffCurrency,15,2);
     reddetials2.Lines.Add(objproduct.getdescription);
     imgproduct2.Picture.LoadFromFile(objproduct.getpath);
      end;
  end;
5:  begin
        reddetials2.Clear;
    if icount = iwcount then
     icount := 0;
//reading displaying the detials
     icount:= icount +1 ;
     scode:=arrproducts[iarray2,icount];
     if scode = '' then
      showmessage('there are no items in this Category')
      else
      begin
     objproduct.searchbycode(scode);
     objproduct.tblloaditems;
     objproduct.readfile;
     objproduct.readdescription;
     LblLname2.Caption:= objproduct.getname;
     lblprice2.Caption:= FloatToStrF(objproduct.getPrice,ffCurrency,15,2);
     reddetials2.Lines.Add(objproduct.getdescription);
     imgproduct2.Picture.LoadFromFile(objproduct.getpath);
      end;
end;
 6: begin
          reddetials2.Clear;
    if icount = igcount then
     icount := 0;
//reading displaying the detials
     icount:= icount +1 ;
     scode:=arrproducts[iarray2,icount];
     ShowMessage(scode);
     if scode = '' then
      showmessage('there are no items in this Category')
      else
      begin
     objproduct.searchbycode(scode);
     objproduct.tblloaditems;
     objproduct.readfile;
     objproduct.readdescription;
     LblLname2.Caption:= objproduct.getname;
     lblprice2.Caption:= FloatToStrF(objproduct.getPrice,ffCurrency,15,2);
     reddetials2.Lines.Add(objproduct.getdescription);
     imgproduct2.Picture.LoadFromFile(objproduct.getpath);
      end;
      end;
 end;
end;

procedure TfrmcatalogeP1.Button4Click(Sender: TObject);
begin
icount := 0;
if iarray = 3 then
iarray:= 0;
iarray:= iarray+1;
lblcategory.Caption:= arrcategory[iarray];
end;

procedure TfrmcatalogeP1.Button5Click(Sender: TObject);
begin
if iarray2 = 6 then
iarray2:= 3;
iarray2:= iarray2+1;
lblcategory2.Caption:= arrcategory[iarray2];
icount:= 0;
end;

procedure TfrmcatalogeP1.Button6Click(Sender: TObject);
var
iclick : integer ;
scode : string;
begin
 case iarray  of
 1:begin
    reddetials1.Clear;
    if icount = iscount then
     icount := 0;
//reading displaying the detials
     icount:= icount +1 ;
     scode:=arrproducts[iarray,icount];
     if scode = '' then
      showmessage('there are no items in this Category')
      else
      begin
     objproduct.searchbycode(scode);
     objproduct.tblloaditems;
     objproduct.readfile;
     objproduct.readdescription;
     Lblproduct1.Caption:= objproduct.getname;
     lblprice1.Caption:= FloatToStrF(objproduct.getPrice,ffCurrency,15,2);
     reddetials1.Lines.Add(objproduct.getdescription);
     imgproduct.Picture.LoadFromFile(objproduct.getpath);
      end;
  end;
2:  begin
    reddetials1.Clear;
    if icount = ihcount then
     icount := 0;
//reading displaying the detials
     icount:= icount +1 ;
     scode:=arrproducts[iarray,icount];
     if scode = '' then
      showmessage('there are no items in this Category')
      else
      begin
     objproduct.searchbycode(scode);
     objproduct.tblloaditems;
     objproduct.readfile;
     objproduct.readdescription;
     Lblproduct1.Caption:= objproduct.getname;
     lblprice1.Caption:= FloatToStrF(objproduct.getPrice,ffCurrency,15,2);
     reddetials1.Lines.Add(objproduct.getdescription);
     imgproduct.Picture.LoadFromFile(objproduct.getpath);
      end;
end;
 3: begin
      reddetials1.Clear;
     if icount = ilcount then
     icount := 0;
//reading displaying the detials
     icount:= icount +1 ;
     scode:=arrproducts[iarray,icount];
     if scode = '' then
      showmessage('there are no items in this Category')
      else
      begin
     objproduct.searchbycode(scode);
     objproduct.tblloaditems;
     objproduct.readfile;
     objproduct.readdescription;
     Lblproduct1.Caption:= objproduct.getname;
     lblprice1.Caption:= FloatToStrF(objproduct.getPrice,ffCurrency,15,2);
     reddetials1.Lines.Add(objproduct.getdescription);
     imgproduct.Picture.LoadFromFile(objproduct.getpath);
      end;
 end;
 end;
end;

procedure TfrmcatalogeP1.FormActivate(Sender: TObject);
var
sline: string;
  I,j: Integer;
begin
//conneceting the tables to the from
dbCONN := Tconnection.Create;
dbCONN.dbconnect;
tblproduct := dbCONN.tblproducts;
//loading the arrproduct with the different products in the store
iscount:= 0;
ihcount:=0;
ilcount:=0;
iecount:=0;
iwcount:=0;
igcount:=0;
{We will be loading  the array accoriding to each products category .The array
will be holding the products code each product Code has a letter in it which shows
it category this is the first letter of the code. Row 1 will hold the category S
row 2 = category H ,row 3 = category L, row 4 = category E ,row 5 = category W ,
row 6 = category G    }
tblproduct.First;
while not tblproduct.Eof do
begin
  if  tblproduct['Category']=   'Solar Power' then
   Begin
                  iscount:= iscount+1;
                  arrproducts[1,iscount]:= tblproduct['Code'];
  end else if tblproduct['Category']='Water Heating' then
   Begin
                  ihcount:= ihcount+1;
                  arrproducts[2,ihcount]:= tblproduct['Code'];
  End else if tblproduct['Category']='Lighting' then
  Begin
  ilcount:= ilcount+1;
  arrproducts[3,ilcount]:= tblproduct['Code'];
  End else if tblproduct['Category']= 'Energy Efficiency' then
  Begin
  iecount:= iecount+1;
  arrproducts[4,iecount]:= tblproduct['Code'];
  End else if tblproduct['Category']=  'Water Saving' then
  Begin
  iWcount:= iWcount+1;
  arrproducts[5,iWcount]:= tblproduct['Code'];
  End else if tblproduct['Category']='Green Home' then
  Begin
  iGcount:= iGcount+1;
  arrproducts[6,igcount]:= tblproduct['Code'];
  End;
  tblproduct.Next;
end;
//setting the array counters
iarray:= 1;
iarray2:= 4;
icount:= 0;
//create the object
 objproduct := Tproduct.create;

end;

procedure TfrmcatalogeP1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
//disconnecting the database
dbCONN.dbdisconnect;
end;

end.
