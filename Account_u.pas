unit Account_u;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Grids, DBGrids, ComCtrls, pngimage, Buttons,
   ConnectDB_U,db,ADODB,math,sproduct_U,help_u;

type
  Tfrmaccount = class(TForm)
    frmaccount: TImage;
    Label1: TLabel;
    Shape1: TShape;
    redproduct: TRichEdit;
    DBGridassets: TDBGrid;
    rgbtype: TRadioGroup;
    btnproductdetilas: TButton;
    bbtnclose: TBitBtn;
    BitBtn3: TBitBtn;
    Image6: TImage;
    Image7: TImage;
    DBGsales: TDBGrid;
    procedure rgbtypeClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnproductdetilasClick(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmaccount: Tfrmaccount;
    objproduct : Tproduct;
    dbCONN : Tconnection;
    tblusers : TAdotable;
    tblproduct : TADOTable;
    tblsales : tadotable;
    dscebf : TDataSource;
    qryefb:tadoQuery;
    dscebf3: Tdatasource;
    qryefb3: TADOQuery;
    icount: integer ;
    myfile:textfile;

implementation

{$R *.dfm}

procedure Tfrmaccount.BitBtn3Click(Sender: TObject);
begin
help_u.Frmhelp.Visible:= true;
help_u.Frmhelp.redout.Lines.Clear;
help_u.Frmhelp.redout.Lines.Add('MANGER HELP!!');
help_u.Frmhelp.redout.Lines.Add('------------------------------------------------------------');
help_u.Frmhelp.redout.Lines.Add('NAVIGATION HELP!'+#13);
help_u.Frmhelp.redout.Lines.Add('Select the type of account you would like to see'+
'by select the items on the radio grouop '+ #13 );
help_u.Frmhelp.redout.Lines.Add('To see the sales for a a record indivule click '
+ 'the button PRODUCT DETIALS and eneter the product name' + #13);
end;

procedure Tfrmaccount.btnproductdetilasClick(Sender: TObject);
var
scode ,sql1,sql2 : string;
begin
DBGridassets.Visible:= true;
DBGsales.Visible:= true;
redproduct.Visible:= false;
//showing the record individually
scode := InputBox('Product Code' , 'Eneter product code','') ;
sql1:= 'select * , Format((Price*Quantity),"CURRENCY") AS [INCOME] '
+', Format((Price*NumproductsSold),"CURRENCY") AS [Current INCOME] ' +
'FROM tblproducts where Code =' + QuotedStr(scode);
dbCONN.runSql(sql1) ;
//showing the sales for the individually record
 tblproduct.Filtered:= false;
 tblproduct.Filter:= 'Code =' + QuotedStr(scode) ;
 tblproduct.Filtered:= true;
 tblsales.First;
showmessage(tblproduct['code']);
sql2:= 'SELECT Code,Name ,KeeperID ,datesold FROM tblsales WHERE Code =' + QuotedStr(scode)    ;
dbCONN.runSQl3(sql2);
end;

procedure Tfrmaccount.FormActivate(Sender: TObject);
begin
//create the object
objproduct := Tproduct.create;
//conneceting the tables to the from
dbCONN := Tconnection.Create;
dbCONN.dbconnect;
tblusers:= dbCONN.tblusers;
tblproduct := dbCONN.tblproducts;
tblsales:= dbCONN.tblsales;
qryefb3:= dbCONN.qryEFB3;
qryefb:= dbCONN.qryEFB;
icount := 0;
redproduct.Lines.Add('Product Sales detials');
redproduct.Lines.Add('----------------------------------------------------------'
+'-----------------------------------------------------------------------------') ;
redproduct.Paragraph.TabCount:= 2;
redproduct.Paragraph.Tab[0]:= 300  ;
redproduct.Paragraph.Tab[1]:= 400;
//setup the qry
dbCONN.runSql('select * FROM tblproducts') ;
dbCONN.setupgrid3(DBGridassets);
dbCONN.runSql3('select * FROM tblsales') ;
dbCONN.setupgrid5(DBGsales);
DBGridassets.Visible:= false;
redproduct.Visible:= False;
end;

procedure Tfrmaccount.rgbtypeClick(Sender: TObject);
var
sql1,sdate,sdateold,sreal:string;
var
sline: string;
begin
case rgbtype.ItemIndex of
0:begin
redproduct.Clear;
redproduct.Lines.Add('Product Sales detials');
redproduct.Lines.Add('----------------------------------------------------------'
+'-----------------------------------------------------------------------------') ;
sdateold:= '01' ;
DBGridassets.Visible:= false;
redproduct.Visible:= true;
  if FileExists('sales.txt')<> true then
begin
  showmessage('file does not exixt');
  exit;
end;
AssignFile(myfile,'sales.txt');
Reset(myfile);
while not Eof(myfile) do
begin
Readln(myfile,sline);
sdate:= Copy(sline,1,pos('*',sline)-1) ;
redproduct.Lines.Add(Sdate +' Sale date '+#13);
Delete(sline,1,pos('*',sline));
Delete(sline,1,pos('*',sline));
sreal:= Copy(sline,1,pos('*',sline)-1);
Delete(sline,1,pos('*',sline));
repeat
 redproduct.Lines.Add(Copy(sline,1,pos(';',sline)-1)+#13) ;
 Delete(sline,1,pos(';',sline));
until (pos(';',sline)=0);
redproduct.Lines.Add('Total ' + sreal + #13 );
redproduct.Lines.Add('New sale '  + #13 );
redproduct.Lines.Add('----------------------------------------------------------'
+'----------------------'  + #13 );
end;
end;
//dispalying the product information alone
1: begin
DBGsales.Visible:= false;
DBGridassets.Visible:= true;
redproduct.Visible:= false;
sql1:= 'select * , Format((Price*Quantity),"CURRENCY") AS [INCOME] '
+', Format((Price*NumproductsSold),"CURRENCY") AS [Current INCOME] FROM tblproducts';
dbCONN.runSql(sql1) ;
end;

end;
end;

end.
