unit sproduct_u;
interface
uses
Forms , sysUtils , Classes,ConnectDB_U ,db,ADODB,windows,StdCtrls ;
type
Tproduct  = class
  private
  Fcode :string ;
  Fname : string ;
  FPrice : real ;
  Fcategory: string;
  FQuantity : integer;
  Fpath: string;
  FcustomerID : string ;
  fsold : Boolean;
  Fdescription : string;
  public
    dbCONN : Tconnection;
    tblproduct: TADOTable;
    dscebf: TDataSource;
    myfile ,myfile2 : TextFile;
  constructor create;
  procedure createcode ;
  procedure addtoDM ;
  procedure addtofile;
  procedure adddescription (sdescription : string);
  procedure editrecored ;
  procedure loaditmes (scode,sname,scategory,spath,scustomerID:string;rprice:real;
  iquantity:integer; bsold:boolean);
  procedure readfile;
  procedure readdescription;
  procedure tblloaditems ;
  Function sold ( sname :string) : string ;
  Function searchtable (sname:string) : boolean ;
  function getcode : string ;
  function getname : string;
  function getPrice : real ;
  function getcategory: string;
  function getQuantity : integer;
  function getpath: string;
  function getcustomerID : string ;
  function getsold : Boolean ;
  procedure setupgrid ;
  function searchbycode(scode:string) : boolean;
  function getdescription : string;
  procedure runsql(sql:string);
  procedure givecode (scode:string);
end;

implementation
uses
manger_u;

{ Tproduct }


procedure Tproduct.adddescription(sdescription : string);
begin
AssignFile(Myfile2,'description.txt');
Append(myfile2);
Writeln(myfile2,fcode+'*'+sdescription);
CloseFile(myfile2);
end;

procedure Tproduct.addtoDM;
var
i : integer;
begin
//add to the data base
tblproduct.Last;
tblproduct.Insert;
tblproduct['Code']:= fcode;
tblproduct['Name'] := fname;
tblproduct['category'] := fcategory;
tblproduct['price']  := fprice  ;
tblproduct['Quantity']:= fquantity;
tblproduct.Post;

end;

procedure Tproduct.addtofile;
begin
//add the file path
AssignFile(Myfile,'picturepath.txt');
Append(myfile);
Writeln(myfile,fcode+'*'+fpath);
CloseFile(myfile);
end;

constructor Tproduct.create;
begin
  Fcode := '' ;
  Fname := ''  ;
  FPrice := 0; ;
  FQuantity := 0 ;
  Fpath:= '' ;
  FcustomerID := ''  ;
  fsold := false ;
  fcategory:= '';
//conneceting the tables to the from
dbCONN := Tconnection.Create;
dbCONN.dbconnect;
tblproduct := dbCONN.tblproducts;
//dbconn.setupGrids(DBGEFB);
end;

procedure Tproduct.createcode;
var
inum,icount,inum2: integer;
sletter : string;
begin
//creating the product code where by the product category will be the first symbol
//then 10000+ the record number it was add to the database
//eg S100001

icount:= 0;
inum:= 0;
tblproduct.first;
while not tblproduct.Eof do
begin
icount:= strtoint(copy(tblproduct['code'],2,5));
if icount > inum  then
begin
  inum:= icount;
end;
 tblproduct.Next
end;
if fcategory = 'Water Heating' then
sletter := 'H'
else
sletter:= copy(fcategory,1,1);
inum:= inum +1 ;
Fcode:= UpperCase(sletter)+IntToStr(inum) ;
end;

procedure Tproduct.editrecored;
var
icount,i: integer;
begin
icount:= 0;
tblproduct.Last;
tblproduct.edit;
tblproduct['Code']:= fcode;
tblproduct['Name'] := fname;
tblproduct['category'] := fcategory;
tblproduct['price']  := fprice  ;
tblproduct['Quantity']:= fquantity;
tblproduct.Post;

end;

function Tproduct.getcategory: string;
begin
Result:= Fcategory;
end;

function Tproduct.getcode: string;
begin
Result:= Fcode;
end;

function Tproduct.getcustomerID: string;
begin
 Result:= FcustomerID;
end;

function Tproduct.getdescription: string;
begin
Result:= Fdescription;
end;

function Tproduct.getname: string;
begin
 result := Fname;
end;

function Tproduct.getpath: string;
begin
 Result:= Fpath;
end;

function Tproduct.getPrice: real;
begin
Result:= FPrice;
end;

function Tproduct.getQuantity: integer;
begin
 Result := FQuantity;
end;

function Tproduct.getsold: Boolean;
begin
Result:= Fsold;
end;

procedure Tproduct.givecode(scode: string);
begin
Fcode:=scode;
end;

procedure Tproduct.loaditmes( scode,sname, scategory, spath,
  scustomerID: string; rprice: real; iquantity: integer; bsold: boolean);
begin
//giving the varibles values
fcode := scode;
fname := sname;
fcategory:= scategory;
fpath:= spath;
//FcustomerID:= scustomerID;
FPrice:= rprice;
FQuantity := iquantity;
//fsold:= bsold;

end;
procedure Tproduct.readdescription;
var
sline,srcode: string;
begin
//reading the file to get the file path o the picture
//checking if the file exits
AssignFile(Myfile2,'description.txt');
Reset(myfile2);
while not Eof(myfile2) do
begin
Readln(myfile2,sline);
srcode:= copy(sline,1,Pos('*',sline)-1);
Delete(sline,1,pos('*',sline));
if srcode=tblproduct['code'] then
begin
 Fdescription:= sline;
end;


end;
end;

procedure Tproduct.readfile;
var
sline,srcode: string;
begin
//reading the file to get the file path o the picture
//checking if the file exits
AssignFile(Myfile,'picturepath.txt');
Reset(myfile);
while not Eof(myfile) do
begin
Readln(myfile,sline);
srcode:= copy(sline,1,Pos('*',sline)-1);
Delete(sline,1,pos('*',sline));
if srcode=tblproduct['code'] then
begin
 Fpath:= sline;
end;


end;
end;

procedure Tproduct.runsql(sql: string);
begin
dbCONN.runSql(sql);
end;

Function Tproduct.searchbycode(scode:string) : boolean ;
begin
   tblproduct.First;
  tblproduct.Filtered := false ;
  tblproduct.Filter := 'Code ='+ QuotedStr( scode);
  tblproduct.Filtered:= true ;
  if tblproduct['Code'] =scode  then
  Result:= true
  else
  result := false;

end;

Function  Tproduct.searchtable(sname: string) : boolean ;
begin
  tblproduct.First;
  tblproduct.Filtered := false ;
  tblproduct.Filter := 'Name ='+ QuotedStr( sname);
  tblproduct.Filtered:= true ;
  if tblproduct['Name'] =sname  then
  Result:= true
  else
  result := false;
end;

procedure Tproduct.setupgrid;
begin
dbconn.setupGrid2( manger_u.FrmDataM.DBGEFB);
end;

Function Tproduct.sold(sname: string) :string ;
var
bfound:boolean;
begin
//change the quainty of the object
bfound := searchtable(sname) ;
tblloaditems;
if FQuantity = tblproduct['NumproductsSold'] then
begin
Result:= 'sold out '
end else
begin
tblproduct.Edit;
tblproduct['NumproductsSold']:=tblproduct['NumproductsSold']+1;
tblproduct.Post;
Result:= 'instock';
end;

end;

procedure Tproduct.tblloaditems;
begin
Fname :=  tblproduct['Name'] ;
Fcategory :=  tblproduct['category'];
Fprice := tblproduct['price']   ;
FQuantity :=tblproduct['Quantity'];
Fcode := tblproduct['Code'];

end;

end.
