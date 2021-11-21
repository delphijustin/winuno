unit winunomanserial;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TWinUnoSerial = class(TForm)
    Memo1: TMemo;
    Timer1: TTimer;
    procedure Memo1KeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Timer1Timer(Sender: TObject);
  private
  hserialout,hserialin:thandle;
  portNumber:byte;
    { Private declarations }
  procedure setport(value:byte);
  public
  property Port:byte read portnumber write setport;
    { Public declarations }
  end;

implementation

uses winunomanager;

{$R *.DFM}

procedure twinunoserial.setport;
begin
portnumber:=value;
hserialin:=createfile(pchar(changefileext(winunoman.opendialog1.filename,
'.serialin'+inttostr(port))),generic_read or generic_write,file_share_read or
file_share_write,nil,open_always,file_attribute_normal,0);
hserialout:=createfile(pchar(changefileext(winunoman.opendialog1.filename,
'.serialout'+inttostr(port))),generic_read or generic_write,file_share_read or
file_share_write,nil,open_always,file_attribute_normal,0);
caption:=format(caption,[value]);
timer1.enabled:=true;
end;

procedure TWinUnoSerial.Memo1KeyPress(Sender: TObject; var Key: Char);
var wrote:dword;
begin
writefile(hserialin,key,1,wrote,nil);
key:=#0;
end;

procedure TWinUnoSerial.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
timer1.enabled:=false;
closehandle(hserialin);closehandle(hserialout);
action:=cafree;
end;

procedure TWinUnoSerial.Timer1Timer(Sender: TObject);
var bytesread:dword;
buffer:array[0..2048]of ansichar;
begin
bytesread:=0;
zeromemory(@buffer,sizeof(buffer));
readfile(hserialout,buffer,high(buffer),bytesread,nil);
if bytesread>0then memo1.Lines.Append(buffer);
end;

end.
