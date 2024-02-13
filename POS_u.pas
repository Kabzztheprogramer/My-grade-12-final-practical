unit POS_u;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, pngimage, ExtCtrls, StdCtrls, ComCtrls, Buttons,sproduct_U,
  ConnectDB_U,db,ADODB,math, Grids, DBGrids,users_U,help_u;

type
  TFrmPOS = class(TForm)
    Image2: TImage;
    Image6: TImage;
    Lblheading: TLabel;
    Shape1: TShape;
    imgproduct: TImage;
    LblLname2: TLabel;
    Label2: TLabel;
    lblprice1: TLabel;
    Edtsearch: TEdit;
    Button3: TButton;
    Button1: TButton;
    redproduct: TRichEdit;
    Button2: TButton;
    BitBtn2: TBitBtn;
    BitBtn1: TBitBtn;
    BitBtn3: TBitBtn;
    Label1: TLabel;
    Image7: TImage;
    Button4: TButton;
    Image5: TImage;
    Button5: TButton;
    procedure FormActivate(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmPOS: TFrmPOS;
    objproduct : Tproduct;
    objusers : Tuser;
    dbCONN : Tconnection;
    tblusers : TAdotable;
    tblproduct : TADOTable;
    tblsales : TADOTable ;
    dscebf : TDataSource;
    qryefb:tadoQuery;
    dscebf3: Tdatasource;
    qryefb3: TADOQuery;
    arrproducts: array[1..20] of string ;
    arrprice : array[1..20] of real;
    arrcode: array[1..20] of string;
    icount: integer ;
    myfile:textfile;
implementation

{$R *.dfm}

procedure TFrmPOS.BitBtn3Click(Sender: TObject);
begin
//help text
help_u.Frmhelp.Visible:= true;
help_u.Frmhelp.redout.Lines.Clear;
help_u.Frmhelp.redout.Lines.Add('MANGER HELP!!');
help_u.Frmhelp.redout.Lines.Add('------------------------------------------------------------');
help_u.Frmhelp.redout.Lines.Add('NAVIGATION HELP!'+#13);
 help_u.Frmhelp.redout.Lines.Add(' Enter the product code in the edit box'+
 ' PRESS the SEARCH button !'+#13);
 help_u.Frmhelp.redout.Lines.Add('Now dislpay the record by pressing'+
'the dislpay button the record will be displayed in its respective componets on'+
 'the form and to the RICHEDIT CART'+ #13+'Press the CASH OUT onces all items'+
 'are add to the Cart' +#13+ 'Press the NEW CUSTOMER for a new customer cart');
end;

procedure TFrmPOS.Button1Click(Sender: TObject);
begin
icount:= icount +1;
arrproducts[icount]:= objproduct.getname;
arrprice[icount]:= objproduct.getPrice;
arrcode[icount]:= objproduct.getcode;
redproduct.Lines.Add(arrproducts[icount]+#9+
FloatToStrF(arrprice[icount],ffCurrency,20,2));
end;

procedure TFrmPOS.Button2Click(Sender: TObject);
var
instock ,sscode ,ssale ,skeeperID ,sline,sql1,sdate : string;
rtotal : real;
i:integer;
ddate: TDateTime;
begin
//calculating the total and change the quaity of the told in the program
for i := 1 to icount do
begin
 instock := objproduct.sold(arrproducts[i]);
 if instock = 'instock' then
 begin
 rtotal:= rtotal+ arrprice[i];
 ssale:=ssale + arrproducts[i]+';' ;
 end else
 begin
 rtotal := rtotal;
 redproduct.Lines.Add(arrproducts[icount] + 'product is out of stock');
 end;
end;
//assing items so we can add it to the file and
redproduct.Lines.Add('Total = '+FloatToStrF(rtotal,ffCurrency,20,2));
sdate:=DateToStr( date()) ;
sscode:= inttostr(RandomRange(1,1000))+copy(datetostr(ddate),9,2);
objusers.setusers;
skeeperID:= objusers.getuserID;
//add the sale to the text file
if FileExists('sales.txt')<> true  then
begin
  showmessage('file not found ');
  Exit;
end;
AssignFile(myfile,'sales.txt');
Append(myfile);
//the for mate of how it will be add to the text file
sline:= datetostr(ddate)+'*'+skeeperID+'*' + FloatToStrF(rtotal,ffCurrency,20,2)
+'*'+ssale;
Writeln(myfile,sline);
closefile(myfile);
//add to sales table
  for i := 1 to icount do
    begin
    //help to with the date
       sql1:='INSERT INTO tblsales(Code,Name,KeeperID,datesold)'+
('VALUES('+QuotedStr(arrcode[i])+','+QuotedStr(arrproducts[i])+','+QuotedStr(skeeperID)+','+ QuotedStr(sdate)+ ' )');
       dbCONN.executeSQL3(sql1)
    end;
end;

procedure TFrmPOS.Button3Click(Sender: TObject);
var
scode: string;
bfound: boolean;
sSQL1: string;
begin
scode := Edtsearch.Text ;
//sSQL1:='SELECT * FROM Tblproducts WHERE Code = '+QuotedStr(scode);
//dbCONN.runSql(sSQL1);
Bfound := objproduct.searchbycode(scode) ;
if tblproduct['code'] ='' then
showmessage('product found')
else
showmessage('Product found');

end;

procedure TFrmPOS.Button4Click(Sender: TObject);
begin
objproduct.tblloaditems;
LblLname2.Caption:= objproduct.getname;
lblprice1.Caption:= FloatToStrF(objproduct.getPrice,ffCurrency,15,2);
objproduct.readfile;
imgproduct.Picture.LoadFromFile(objproduct.getpath);
end;

procedure TFrmPOS.Button5Click(Sender: TObject);
begin
redproduct.Clear;
redproduct.Lines.Add('CART');
redproduct.Lines.Add('----------------------------------------------------------') ;
redproduct.Paragraph.TabCount:= 2;
redproduct.Paragraph.Tab[0]:= 300  ;
redproduct.Paragraph.Tab[1]:= 400;
redproduct.Lines.Add('Item' +#9+#9+#9+#9 +'Price');
icount:= 0;
end;

procedure TFrmPOS.FormActivate(Sender: TObject);
begin
//create the object
objusers:= Tuser.create;
objproduct := Tproduct.create;
//conneceting the tables to the from
dbCONN := Tconnection.Create;
dbCONN.dbconnect;
tblusers:= dbCONN.tblusers;
tblproduct := dbCONN.tblproducts;
tblsales:= dbCONN.tblsales;
qryefb:= dbCONN.qryEFB;
qryefb3:= dbCONN.qryEFB3;
icount := 0;
redproduct.Lines.Add('CART');
redproduct.Lines.Add('----------------------------------------------------------') ;
redproduct.Paragraph.TabCount:= 2;
redproduct.Paragraph.Tab[0]:= 300  ;
redproduct.Paragraph.Tab[1]:= 400;
redproduct.Lines.Add('Item' +#9+#9+#9+#9 +'Price');
dbCONN.runSql('select * FROM tblproducts') ;
end;

end.
