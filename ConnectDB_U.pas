unit ConnectDB_U;

interface

uses
Forms , sysUtils , Classes , DB ,ADODB ,StdCtrls ,DBGrids,DBCtrls,windows ;
type
Tconnection = class(tobject)
  private
  public
  conEFB : TADOConnection;
  tblusers  , tblproducts ,tblsales :  TADOTable;
  dscebf,dscebf2,dscebf3,dsrQry,dsrQry2,dsrQry3: TDataSource;
  qryEFB,qryEFB2,qryEFB3 : TADOQuery;
  procedure dbconnect;
  procedure dbdisconnect;
  procedure setupGrids(var Gridone: TDBGrid);
  procedure setupgrid2(var Gridtwo : TDBGrid);
  procedure setupgrid3(var gridsql : TDBGrid);
  procedure setupgrid4(var gridsql : TDBGrid);
  procedure setupgrid5(var gridsql : TDBGrid);
  procedure runSql(sSQL:string);
  procedure runSQl2(sSQl: string);
  procedure runSQl3(sSQl: string);
  procedure executeSQL3(sSQL:string);
  procedure displayAllprofiles3(var QrX:TADOQuery ; Tablex :string);

end;
var
Myform: Tform;
const
DBfileName : string = 'DBMEFB.mdb';
Dbmefbtb : string = 'tblusers';
Dbmefbtb2 : string = 'tblproducts';
Dbmefbtb3 : string = 'tblsales';
implementation

{ Tconnection }
uses
controls,dialogs;

procedure Tconnection.dbconnect;
begin
//create objects
conEFB := TADOConnection.Create(Myform);
conefb.LoginPrompt:= False;
//setup our connection
conefb.ConnectionString := 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source='+DBfileName
+';'+'Mode=ReadWrite;Persist Security Info=False';
conEFB.Provider := 'Provider=Microsoft.Jet.OLEDB.4.0;';
conEFB.Open;
//create objects  tblusers
tblusers := TADOTable.Create(Myform);
//setup table(s)
tblusers.Connection := conEFB   ;
tblusers.TableName := Dbmefbtb;
Tblusers.Open;
tblusers.Sort := 'UserID';
tblusers.First;
//setup data source
dscebf := TDataSource.Create(Myform);
dscebf.DataSet := tblusers;


//create objects  tblproducts
tblproducts := TADOTable.Create(Myform);
//setup table(s)
tblproducts.Connection := conEFB   ;
tblproducts.TableName := Dbmefbtb2;
tblproducts.Open;
tblproducts.Sort := 'code';
tblproducts.First;
//setup data source
dscebf2 := TDataSource.Create(Myform);
dscebf2.DataSet := tblproducts;
//Qry on the table product
qryEFB := TADOQuery.Create(myForm);
qryEFB.Connection := conEFB;
dsrQry:= TDataSource.Create(MyForm);
dsrQry.DataSet:= qryEFB;
//qry on users
qryEFB2 := TADOQuery.Create(myForm);
qryEFB2.Connection := conEFB;
dsrQry2:= TDataSource.Create(MyForm);
dsrQry2.DataSet:= qryEFB2;


//create objects  tblsales
tblsales := TADOTable.Create(Myform);
//setup table(s)
tblsales.Connection := conEFB   ;
tblsales.TableName := Dbmefbtb3;
tblsales.Open;
tblsales.Sort := 'ID';
tblsales.First;
//setup data source
dscebf3 := TDataSource.Create(Myform);
dscebf3.DataSet := tblsales;
//Qry on the table sales
qryEFB3 := TADOQuery.Create(myForm);
qryEFB3.Connection := conEFB;
dsrQry3:= TDataSource.Create(MyForm);
dsrQry3.DataSet:= qryEFB3;



end;

procedure Tconnection.dbdisconnect;
begin
//disconnecting tblusers  & tblproducts
  qryEFB.Free;
  qryEFB := nil;
  tblusers.Free;
  tblusers:= nil;
  tblproducts.Free;
  tblproducts := nil ;
  conEFB.Close;
  conEFB.Free;
  conEFB:= nil;
end;
procedure Tconnection.displayAllprofiles3(var QrX: TADOQuery; Tablex: string);
begin
QrX.Close;
Qrx.SQL.Text := Format('SELECT * FROM %s',[TableX] );
Qrx.Open;
end;

procedure Tconnection.executeSQL3(sSQL: string);
begin
if Length(sSQl)<>0 then
begin
  qryEFB.Close;
  qryEFB.SQL.Text:= sSQL;
  qryEFB.ExecSQL;
  displayAllprofiles3(QryEFB3,'tblsales');
  ShowMessage('database changed.');
end else
ShowMessage('No SQL statement enetered');
end;

procedure Tconnection.runSql(sSQL: string);
begin
 if length(sSQl)<> 0  then
 begin
   qryEFB.Close;
   qryEFB.SQL.Text := sSQL;
   qryEFB.Open;
 end
 else
 showmessage('No SQL statement entered');
end;

procedure Tconnection.runSQl2(sSQl: string);
begin
 if length(sSQl)<> 0  then
 begin
   qryEFB2.Close;
   qryEFB2.SQL.Text := sSQL;
   qryEFB2.Open;
 end
 else
 showmessage('No SQL statement entered');
end;

procedure Tconnection.runSQl3(sSQl: string);
begin
  if length(sSQl)<> 0  then
 begin
   qryEFB3.Close;
   qryEFB3.SQL.Text := sSQL;
   qryEFB3.Open;
 end
 else
 showmessage('No SQL statement entered');
end;

//connecting the grid
procedure Tconnection.setupgrid2(var Gridtwo: TDBGrid);
begin
 Gridtwo.DataSource:= dscebf2;
 Gridtwo.Columns[0].Width:=100;
 Gridtwo.Columns[1].Width:=100;
 Gridtwo.Columns[2].Width:=100;
 Gridtwo.Columns[3].Width:=100;
 Gridtwo.Columns[4].Width:=100;
end;

procedure Tconnection.setupgrid3(var gridsql: TDBGrid);
begin
gridsql.DataSource:= dsrQry;
end;

procedure Tconnection.setupgrid4(var gridsql: TDBGrid);
begin
gridsql.DataSource:= dsrQry2;
end;

procedure Tconnection.setupgrid5(var gridsql: TDBGrid);
begin
 gridsql.DataSource:= dsrQry3;
end;

procedure Tconnection.setupGrids(var Gridone : TDBGrid);
begin
Gridone.DataSource:= dscebf;
Gridone.Columns[0].Width:=100;
Gridone.Columns[1].Width:=100;
Gridone.Columns[2].Width:=100;
Gridone.Columns[3].Width:=100;
Gridone.Columns[4].Width:=100;
end;

end.
