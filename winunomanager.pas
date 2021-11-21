unit winunomanager;
{$RESOURCE WinUnoMan.res}
interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls,math,shellapi, Menus;

type
  TWinUnoMan = class(TForm)
    ListBox1: TListBox;
    Memo1: TMemo;
    OpenDialog1: TOpenDialog;
    MainMenu1: TMainMenu;
    Tools1: TMenuItem;
    SerialTerminal1: TMenuItem;
    Serial11: TMenuItem;
    Serial21: TMenuItem;
    Serial31: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    File1: TMenuItem;
    Exit1: TMenuItem;
    procedure ListBox1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure Serial11Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
  TArduinoSpecs=record
  EEPROMSize,SRAM,PWMPins:dword;
  hardwareSS,LED_BUILTIN:integer;
  cbDigital,cbAnalog,microsResolution:byte;
  end;
  PArduinoSpecs=^TArduinoSpecs;

var
  WinUnoMan: TWinUnoMan;
 boardSpecs:array[0..3]of parduinospecs;
 execParams:Array[0..512]of char;
 etcparams:string;
implementation

uses custboard,winunomanserial;

{$R *.DFM}

function GetOtherBoard:integer;
begin
result:=1+high(boardspecs);
end;

procedure TWinUnoMan.ListBox1Click(Sender: TObject);
var specs:parduinospecs;
pwm:tstringlist;
I:integer;
begin
memo1.Text:=
'This lets you choose your analog pins,digital pins,EEPROM size and much more!';
if listbox1.ItemIndex=getotherboard then exit;
memo1.Clear;
specs:=boardspecs[listbox1.itemindex];
with specs^ do begin
if led_builtin<maxint then memo1.Lines.Add(format('Builtin-LED Pin: %d',[
led_builtin]));
memo1.Lines.Add(format('SRAM: %u bytes',[sram]));
memo1.Lines.Add(format('EEPROM: %u bytes',[eepromsize]));
pwm:=tstringlist.Create;
for i:=0to 31do if pwmpins and trunc(power(2,i))>0then pwm.Add(inttostr(i));
if pwm.Count=0then pwm.Add('None');
memo1.Lines.Add(format('PWM Pins: %s',[pwm.commatext]));
pwm.Free;
memo1.Lines.Add(format('Digital Pins: %d',[cbdigital]));
memo1.Lines.add(format('Analog Pins: %d',[cbanalog]));
end;
end;

procedure TWinUnoMan.FormCreate(Sender: TObject);
begin
//Arduino Uno
new(boardspecs[0]);
Boardspecs[0].LED_BUILTIN:=13;
boardspecs[0].cbDigital:=15;
boardspecs[0].sram:=2048;
boardspecs[0].cbAnalog:=6;
boardspecs[0].EEPROMSize:=1024;
boardspecs[0].microsResolution:=4;
boardspecs[0].hardwaress:=-1;
boardspecs[0].PWMPins:=trunc(power(2,3))or trunc(power(2,5))or trunc(power(2,6))
 or trunc(power(2,9)) or trunc(power(2,10)) or trunc(power(2,11));
new(boardspecs[1]);copymemory(boardspecs[1],boardspecs[0],sizeof(tarduinospecs));
//nano
boardspecs[1].microsResolution:=4;
boardspecs[1].LED_BUILTIN:=maxint;//There is no led built-in
boardspecs[1].cbAnalog:=8;
boardspecs[1].cbDigital:=22;
boardspecs[1].EEPROMSize:=1024;
boardspecs[1].sram:=2048;
//leonardo
new(boardspecs[2]);copymemory(boardspecs[2],boardspecs[0],sizeof(tarduinospecs));
boardspecs[2].PWMPins:=trunc(power(2,3)) or trunc(power(2,5)) or trunc(power(2,6)
)or trunc(power(2,9))or trunc(power(2,10))or trunc(power(2,11))or trunc(power(2,
13));
boardspecs[2].cbDigital:=20;
boardspecs[2].cbAnalog:=12;
boardspecs[2].LED_BUILTIN:=maxint;
boardspecs[2].microsResolution:=4;
boardspecs[2].EEPROMSize:=1024;
boardspecs[2].sram:=round(2.5*1024);
boardspecs[2].LED_BUILTIN:=13;
boardspecs[2].PWMPins:=trunc(power(2,3)) or trunc(power(2,5)) or trunc(power(2,6)
)or trunc(power(2,9))or trunc(power(2,10))or trunc(power(2,11))or trunc(power(2,
13));
//micro
new(boardspecs[3]);copymemory(boardspecs[3],boardspecs[0],sizeof(tarduinospecs));
boardspecs[3].cbDigital:=20;
boardspecs[3].cbAnalog:=12;
boardspecs[3].EEPROMSize:=1024;
boardspecs[3].microsResolution:=4;
boardspecs[3].sram:=round(2.5*1024);
application.Title:=caption;
end;

procedure TWinUnoMan.ListBox1DblClick(Sender: TObject);
var model:string;
begin
model:='custom';
if sender<>nil then begin
if listbox1.ItemIndex<getotherboard then model:=listbox1.Items[listbox1.itemindex]else
begin winunocustom.visible:=true;exit;end;
if not opendialog1.Execute then exit;
end else if not opendialog1.Execute then exit;
shellexecute(handle,nil,'cmd.exe',strlfmt(execparams,512,
'/C inoconv.exe "%s" /RUN /%s %s&pause',[
opendialog1.filename,model,etcparams]),nil,sw_show);
serialterminal1.Enabled:=true;
end;

procedure TWinUnoMan.Serial11Click(Sender: TObject);
var term:TWinUnoSerial;
begin
if not fileexists(opendialog1.filename)then exit;
term:=twinunoserial.create(nil);
term.port:=tmenuitem(sendeR).tag;
term.visible:=true;
term.bringtofront;
end;

procedure TWinUnoMan.About1Click(Sender: TObject);
var msgbox:msgboxparams;
begin
zeromemory(@msgbox,sizeof(msgbox));
msgbox.cbSize:=sizeof(msgbox);
msgbox.hwndOwner:=handle;
msgbox.hInstance:=hinstance;
msgbox.lpszText:=pchar(
'delphijustin WinUno Manager v1.0'#13#10+
'By Justin Roeder'
);
msgbox.lpszCaption:='About';
msgbox.dwStyle:=mb_usericon;
msgbox.lpszIcon:=makeintresource(1);
messageboxindirect(msgbox);
end;

procedure TWinUnoMan.Exit1Click(Sender: TObject);
begin
close;
end;

end.
