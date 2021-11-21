unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  HPCounter, StdCtrls;

type
  TForm1 = class(TForm)
    HPCounter1: THPCounter;
    Button1: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.Button1Click(Sender: TObject);
var x, n: integer;
begin
  HPCounter1.Start;
  // Place code to measure here
  Sleep(1000);
  // Place code to measure here
  Edit1.Text:=HPCounter1.Read;
end;

end.
