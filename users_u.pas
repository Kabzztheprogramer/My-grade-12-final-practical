unit users_u;
interface
 uses
Forms , sysUtils , Classes,ConnectDB_U ,db,ADODB,windows,StdCtrls ;

type
Tuser  = class

private
FusersID : string;
Fpassword : string;

public
    dbCONN : Tconnection;
    tblusers : TAdotable;
    tblproduct : TADOTable;
    dscebf : TDataSource;
    tblsales : TADOTable;
    dscebf3 : TDataSource;
    myfile : textfile ;
  constructor create;
  procedure loadItems ;
  procedure searchbyusersID (susersname: string);
  function getuserID : string;
  function getpassword : string;
  Procedure  sksales ;
  procedure setusers ;

end;
implementation
{ Tusers }
 uses
 EFB_U, Records_U;


constructor Tuser.create;
begin
 FusersID := '';
 Fpassword := '';
 //conneceting the tables to the from
dbCONN := Tconnection.Create;
dbCONN.dbconnect;
tblusers:= dbCONN.tblusers;
tblproduct := dbCONN.tblproducts;
tblsales:= dbCONN.tblsales;
tblsales.First;
tblusers.First;

end;

function Tuser.getpassword: string;
begin
//getting the password
Result:=Fpassword ;
end;

function Tuser.getuserID: string;
begin
//getting the users users ID
 Result:= FusersID;
end;

procedure Tuser.loadItems;
begin
 FusersID:=  tblusers['userID'];
 Fpassword:= tblusers['password'];
end;

procedure Tuser.searchbyusersID(susersname: string);
begin
//searching for the users by there ID
 tblproduct.First;
  tblusers.Filtered := false ;
  tblusers.Filter := 'UserID ='+ QuotedStr(susersname);
  tblusers.Filtered:= true ;
end;

procedure Tuser.setusers;
begin
 FusersID:= EFB_U.susers
end;

Procedure Tuser.sksales;
var
sline: string;
begin
//get the code for th users sales
searchbyusersID(getuserID);
tblsales.First;
while not tblsales.Eof do
Begin
//geting a store keeper which is a user get there sales
if tblsales['KeeperID']= tblusers['UserID'] then
begin
sline:= tblsales['Code'] + #9 + tblsales['Name']  +
 #9 +tblsales['datesold'];
Records_U.FrmReports.Redout.Lines.Add(sline);
end;
tblsales.Next;
End;


end;

end.
