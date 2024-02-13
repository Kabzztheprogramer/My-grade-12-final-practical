unit help_U;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, ComCtrls, pngimage;

type
  TFrmhelp = class(TForm)
    frmaccount: TImage;
    Label1: TLabel;
    redout: TRichEdit;
    Shape1: TShape;
    Image6: TImage;
    Image7: TImage;
    Image5: TImage;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frmhelp: TFrmhelp;

implementation

{$R *.dfm}

end.
