unit sevenseg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Menus;
const common_logic:array[boolean]of byte=(1,0);
type
  TSevenSegment = class(TForm)
    LabelA: TLabel;
    LabelB: TLabel;
    LabelC: TLabel;
    LabelD: TLabel;
    LabelE: TLabel;
    LabelF: TLabel;
    LabelG: TLabel;
    CheckBox1: TCheckBox;
    Label1: TLabel;
    Edit1: TEdit;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer1Timer(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
  private
    { Private declarations }
  public
  segmentpins:tstringlist;
    { Public declarations }
  end;
var segDisplayCount:integer;
implementation
uses winuno;
{$R *.DFM}

procedure TSevenSegment.FormCreate(Sender: TObject);
begin
segmentpins:=tstringlist.create;
inc(segdisplaycount);
caption:=format(caption,[segdisplaycount]);
end;

procedure TSevenSegment.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
action:=cafree;
end;

procedure TSevenSegment.Timer1Timer(Sender: TObject);
var i:integer;
begin
for i:=0to segmentpins.count-1do
if strtointdef(segmentpins[i],-16)>-16then
case i of
0:labela.visible:=(digitalread(strtoint(segmentpins[i]))=common_logic[
checkbox1.checked]);
1:labelb.visible:=(digitalread(strtoint(segmentpins[i]))=common_logic[
checkbox1.checked]);
2:labelc.visible:=(digitalread(strtoint(segmentpins[i]))=common_logic[
checkbox1.checked]);
3:labeld.visible:=(digitalread(strtoint(segmentpins[i]))=common_logic[
checkbox1.checked]);
4:labele.visible:=(digitalread(strtoint(segmentpins[i]))=common_logic[
checkbox1.checked]);
5:labelf.visible:=(digitalread(strtoint(segmentpins[i]))=common_logic[
checkbox1.checked]);
6:labelg.visible:=(digitalread(strtoint(segmentpins[i]))=common_logic[
checkbox1.checked]);
end;
end;

procedure TSevenSegment.Edit1Change(Sender: TObject);
begin
segmentpins.commatext:=edit1.text;
end;

end.
