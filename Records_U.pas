unit Records_U;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, pngimage, ExtCtrls, ComCtrls, Buttons, Grids, DBGrids,
  ConnectDB_U,db,ADODB,math,sproduct_U,help_u,users_U;

type
  TFrmReports = class(TForm)
    Image2: TImage;
    Image3: TImage;
    Image6: TImage;
    Label1: TLabel;
    Shape1: TShape;
    Redout: TRichEdit;
    Button1: TButton;
    cbxreports: TComboBox;
    Label2: TLabel;
    bbtnclose: TBitBtn;
    DBGridusers: TDBGrid;
    BitBtn1: TBitBtn;
    mysales: TButton;
    procedure FormActivate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure mysalesClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrmReports: TFrmReports;
    objproduct : Tproduct;
    objusers : Tuser ;
    dbCONN : Tconnection;
    tblusers : TAdotable;
    tblproduct : TADOTable;
    tblsales : TADOTable;
    dscebf : TDataSource;
    dscebf3 : TDataSource;
    qryefb:tadoQuery;
    icount: integer ;
    myfile ,myfile2 :textfile;

implementation

{$R *.dfm}

procedure TFrmReports.BitBtn1Click(Sender: TObject);
begin
//help text
help_u.Frmhelp.Visible:= true;
help_u.Frmhelp.redout.Lines.Clear;
help_u.Frmhelp.redout.Lines.Add('Reports HELP!!');
help_u.Frmhelp.redout.Lines.Add('------------------------------------------------------------');
help_u.Frmhelp.redout.Lines.Add('NAVIGATION HELP!'+#13);
help_u.Frmhelp.redout.Lines.Add('Select the type of report you would like to see'+
' by selecting the items in the combo box'+ #13 );
help_u.Frmhelp.redout.Lines.Add('Then press the SELECT button to '
+ 'Display the report  ' + #13);
end;

procedure TFrmReports.Button1Click(Sender: TObject);
var
sline ,susers,sdate,stime : string;
begin
//dislpay different records
Redout.Clear;
DBGridusers.Visible:= true ;

if cbxreports.Text = 'Male Users' then
begin
 dbCONN.runSQl2('select Name,Gender FROM tblusers Where Gender ="M"')
end else
if cbxreports.Text = 'Female Users' then
begin
  dbCONN.runSQl2('select Name,Gender FROM tblusers Where Gender ="F"')
end else
if cbxreports.Text = 'Schedule' then
begin
DBGridusers.Visible:= false ;
Redout.Lines.Add('SCHEDULE'+#9+'Upadeted on the '+datetostr(now)+#13) ;
Redout.Lines.Add('------------------------------------------------------------');
Redout.Lines.Add('Monday to Fridays '+ #13);
Redout.Lines.Add('Database Manger 07:30am ----- 09:00 am '+#13);
Redout.Lines.Add('Store Keeper 09:10am ----- 12:30 am Break 02:00pm----05:00pm'+#13);
Redout.Lines.Add('Store Manger 12:30am ----- 01:45Pm '+#13);
Redout.Lines.Add('Accountend Manger 05:15pm  '+#13);
Redout.Lines.Add('If schedule is compromised please look at aduit trail');

end else
if cbxreports.Text = 'Audit trails' then
begin
Redout.Lines.Clear;
Redout.Lines.Add('AUDIT TRAILS') ;
Redout.Lines.Add('-------------------------------------------------------------'+
'--------------------------------------');
Redout.Paragraph.TabCount:= 2;
Redout.Paragraph.Tab[0]:= 100;
Redout.Paragraph.Tab[1]:= 200;
Redout.Lines.Add('UserID'+#9  +'Loging in Date'+#9 + 'Loging in Time') ;
AssignFile(myfile2,'Audittrail.txt');
Reset(myfile2);
while not eof(myfile2) do
begin
DBGridusers.Visible:= false ;
  Readln(myfile2,sline);
  susers:= Copy(sline,1,pos('#',sline)-1);
  Delete(sline,1 , Pos('#',sline));
  sdate:= Copy(sline,1,pos('#',sline)-1);
  Delete(sline,1 , Pos('#',sline));
 Redout.Lines.Add(susers+ #9 + sdate +#9 + sline) ;
end;
end ;


end;

procedure TFrmReports.FormActivate(Sender: TObject);
begin
//create the object
objproduct := Tproduct.create;
//conneceting the tables to the from
dbCONN := Tconnection.Create;
dbCONN.dbconnect;
tblusers:= dbCONN.tblusers;
tblproduct := dbCONN.tblproducts;
objusers:= Tuser.create;
qryefb:= dbCONN.qryEFB;
//setup the qry
dbCONN.setupgrid4(DBGridusers);
end;

procedure TFrmReports.mysalesClick(Sender: TObject);
begin
DBGridusers.Visible:= false;
Redout.Clear;
Redout.Visible:= true;
objusers.setusers;
showmessage('heyy');
Redout.Lines.Add('SALES' + #9 +#9 + 'made by '+ UpperCase(objusers.getuserID));
Redout.Lines.Add('-------------------------------------------------------------'
+'----------------------------------------------------------')  ;
Redout.Paragraph.TabCount:=3;
Redout.Paragraph.tab[0]:= 100;
Redout.Paragraph.tab[1]:= 200;
Redout.Paragraph.tab[2]:= 400;
Redout.Lines.Add('CODE' + #9 + 'NAME' + #9+#9 + 'DATA SOLD'+ #13 );
objusers.sksales;

end;


end.
