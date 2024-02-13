unit DMEFB_U;

interface

uses
  forms,SysUtils, Classes, DB, ADODB;

type
  TDMEFB = class(TDataModule)
  procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
  conEFB : TADOConnection;
  tblproducts :  TADOTable;
  tblusers :  TADOTable;
  dscebf,dscebf2 : TDataSource;
   end;

var
  DMEFB: TDMEFB;

implementation

{$R *.dfm}

procedure TDMEFB.DataModuleCreate(Sender: TObject);
begin
//create objects
conEFB := TADOConnection.Create(dmefb);
tblproducts := TADOTable.Create(DMEFB);
tblusers := TADOTable.Create(DMEFB);
dscebf := TDataSource.Create(DMEFB);
dscebf2 := TDataSource.Create(DMEFB);
//setup our connection
conefb.ConnectionString := 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=DBMEFB.mdb;Mode=ReadWrite;Persist Security Info=False';
conefb.LoginPrompt:= False;
conEFB.Open;
//setup table(s)
tblproducts.Connection:= conEFB;
tblproducts.TableName := 'tblproducts' ;
tblproducts.Open;
tblproducts.First;
tblusers.Connection := conEFB   ;
tblusers.TableName := 'tblusers';
Tblusers.Open;
tblusers.First;

//setup data source
dscebf.DataSet:= tblproducts;
tblproducts.Open;
dscebf2.DataSet := tblusers;
tblusers.Open;
end;

end.
