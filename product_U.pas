unit product_U;

interface
uses
Forms , sysUtils , Classes,ConnectDB_U , ConnectDB_U,db,ADODB
,windows;
type
Tproduct  = class(tobject)
  private
  Fcode :string ;
  Fname : string ;
  FPrice : real ;
  FQuanity : integer;
  Fpath: string;
  FcustomerID : string ;
  fsold : Boolean;
  public
    dbCONN : Tconnection;
    tblproduct : TADOTable;
    dscebf : TDataSource;
    myfile : TextFile;
  constructor create;
  Function Getname : string ;
  Function Getprice : real ;
  Function Getquanity : integer;
  Function Getpath: string ;
  procedure setdetails ;
  procedure editdetails ;
  procedure createcode ;
  Function getcode : string ;
  procedure addtoDM ;
  procedure addtofile;


end;


implementation

{ Tproduct }


procedure Tproduct.addtoDM;
begin
//add to the data base
tblproduct.Last;
tblproduct.Insert;
tblproduct['Code']:= fcode;
tblproduct['Name'] := fname;
tblproduct['category'] := fcategory;
tblproduct['price']  := fprice  ;
tblproduct['Quantity']:= fquantity;
tblproduct['customerID']:= FcustomerID;
tblproduct['sold']:= fsold;
tblproduct.Post;
end;

procedure Tproduct.addtofile;
begin
//add the file path
if FileExists('picturepath.txt')<> true then
begin
  showmessage('File does not exists');
  Exit;
end;
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
  FQuanity := 0 ;
  Fpath:= '' ;
  FcustomerID := ''  ;
  fsold := false ;
//conneceting the tables to the from
dbCONN := Tconnection.Create;
dbCONN.dbconnect;
tblproduct := dbCONN.tblproducts;
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

if Cbxcategory.Text = 'Water Heating' then
sletter := 'H'
else
sletter:= copy(Cbxcategory.Text,1,1);
inum:= inum +1 ;
Fcode:= UpperCase(sletter)+IntToStr(inum) ;
end;

procedure Tproduct.editdetails;
begin

end;

function Tproduct.getcode: string;
begin
Result:= fcode;
end;

function Tproduct.Getname: string;
begin

end;

function Tproduct.Getpath: string;
begin

end;

function Tproduct.Getprice: real;
begin

end;

function Tproduct.Getquanity: integer;
begin

end;

procedure Tproduct.setdetails;
begin

end;

end.
