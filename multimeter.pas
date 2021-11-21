unit multimeter;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls,clipbrd, Menus;
const
TAG_PIN='Pin';
TAG_VOLTS='Volts';
TAG_PERCENT='Percent';
TAG_ADCVALUE='Value';
type
  TAMultiMeter = class(TForm)
    Memo1: TMemo;
    Timer1: TTimer;
    MainMenu1: TMainMenu;
    Meter1: TMenuItem;
    CopyVoltage1: TMenuItem;
    CopyAnalogValue1: TMenuItem;
    CopyPercentage1: TMenuItem;
    Exit1: TMenuItem;
    CopyAll1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CopyVoltage1Click(Sender: TObject);
    procedure CopyAnalogValue1Click(Sender: TObject);
    procedure CopyPercentage1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure CopyAll1Click(Sender: TObject);
  private
  analog:integer;
  procedure setAnalog(value:integer);
    { Private declarations }
  public
  property AnalogInput:integer read analog write setanalog;
    { Public declarations }
  end;

var
  metercount:integer;

implementation
uses winuno;

{$R *.DFM}

procedure TAMultiMeter.FormCreate(Sender: TObject);
begin
memo1.clear;
inc(metercount);
caption:=format(caption,[metercount]);
end;

procedure TAMultimeter.setAnalog;
begin
analog:=value;
timer1.enabled:=true;
end;

procedure TAMultiMeter.Timer1Timer(Sender: TObject);
begin
memo1.lines.values[tag_pin]:=format('%u',[analog]);
memo1.lines.values[tag_adcvalue]:=format('%u',[analogread(analog)]);
memo1.lines.values[tag_volts]:=format('%nVDC',[adctovoltage(analogread(analog))]);
memo1.lines.values[tag_percent]:=format('%n%%',[(analogread(analog)/adcres)*100]);
end;

procedure TAMultiMeter.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
action:=cafree;
end;

procedure TAMultiMeter.CopyVoltage1Click(Sender: TObject);
begin
clipboard.astext:=memo1.lines.values[tag_volts];
end;

procedure TAMultiMeter.CopyAnalogValue1Click(Sender: TObject);
begin
clipboard.astext:=memo1.lines.values[tag_adcvalue];
end;

procedure TAMultiMeter.CopyPercentage1Click(Sender: TObject);
begin
clipboard.astext:=memo1.lines.values[tag_percent];
end;

procedure TAMultiMeter.Exit1Click(Sender: TObject);
begin
close;
end;

procedure TAMultiMeter.CopyAll1Click(Sender: TObject);
begin
clipboard.astext:=memo1.text;
end;

end.
