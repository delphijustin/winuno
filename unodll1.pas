unit unodll1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, CheckLst,math;
const BitOrders:array['0'..'1']of string=('MSBFIRST','LSBFIRST');
type
  TshiftInController = class(TForm)
    CheckListBox1: TCheckListBox;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
  function GetByte:byte;
    { Private declarations }
  public
  property Data:Byte read GetByte;
    { Public declarations }
  end;

var
  shiftInController: TshiftInController;
  shiftInParams:tstringlist;
implementation

{$R *.DFM}

function TShiftInController.GetByte;
var i,x,dummy:integer;
begin
result:=0;
for i:=0to 7do
begin
x:=-1;
if checklistbox1.Checked[i]then
val(checklistbox1.items[i],x,dummy);
result:=result or trunc(power(2,x));
end;
end;

procedure TshiftInController.FormCreate(Sender: TObject);
var i:integer;
begin
caption:=format(caption,[shiftinparams[0],shiftinparams[1],BitOrders[
shiftinparams[2][1]]]);
application.Title:=caption;
if strtoint(shiftinparams[2])=1then
for i:=0to 7do checklistbox1.items.add(Inttostr(i))else
for i:=7downto 0do checklistbox1.Items.Add(inttostr(i));
with checklistbox1 do begin
items[items.IndexOf('0')]:='0 LSB';
items[items.IndexOf('7')]:='7 MSB';
end;
end;

procedure TshiftInController.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
case messagebox(handle,'Shift data back into the emulator?','WinUno',
mb_yesnocancel or mb_iconquestion)of
idyes:exitprocess(data);
idno:exitprocess(maxdword);
else action:=canone;
end;
end;

end.
