unit winuno;
{$RESOURCE WINUNO32.RES}
interface

uses
  Windows, Messages, SysUtils, Classes, Menus, ComCtrls, Controls,
  ShellAPI, Forms, Dialogs,StdCtrls,math,  HPcounter;

const
//supported integer bases

//Digital Pin consts
INPUT=1;
INPUT_PULLUP=2;
OUTPUT=0;
HIGH=1;
LOW=0;
PIN_NOMODE=3;//pinMode has not been called when it equals this
SERIAL_5N1=23;
SERIAL_6N1=22;
SERIAL_7N1=21;
SERIAL_8N1=0;
SERIAL_5N2=1;
SERIAL_6N2=2;
SERIAL_7N2=3;
SERIAL_8N2=4;
SERIAL_5E1=5;
SERIAL_6E1=6;
SERIAL_7E1=7;
SERIAL_8E1=8;
SERIAL_5E2=9;
SERIAL_6E2=10;
SERIAL_7E2=11;
SERIAL_8E2=12;
SERIAL_5O1=13;
SERIAL_6O1=14;
SERIAL_7O1=15;
SERIAL_8O1=16;
SERIAL_5O2=17;
SERIAL_6O2=18;
SERIAL_7O2=19;
SERIAL_8O2=20;

//Analog pin consts
A0=-1;
A1=-2;
A2=-3;
A3=-4;
A4=-5;
A5=-6;
A6=-7;
A7=-8;
A8=-9;
A9=-10;
A10=-11;
A11=-12;
A12=-13;
A13=-14;
A14=-15;

//Voltage references

    INTERNAL1V1=1.1;

    INTERNAL2V56=2.56;

    AR_INTERNAL1V0=1.0;

    AR_INTERNAL1V65=1.65;

    AR_INTERNAL2V23=2.23;
    VDEFAULT=-1;

    INTERNAL=-4;

    VDD=5;

    INTERNAL0V55=0.55;

    INTERNAL1V5= 1.5;

    INTERNAL2V5=2.5;

    INTERNAL4V3=4.3;

    VEXTERNAL=-3;

    AR_VDD= 3.3;

    AR_INTERNAL=-2;

    AR_INTERNAL1V2= 1.2;

    AR_INTERNAL2V4=2.4;

//interrupt consts
RISING=2;
FALLING=3;
CHANGE=4;

MSBFIRST=0;
LSBFIRST=1;

//WinUno Consts
LIB_EEPROM_H=1;
Switch_pwm=' /PWM';
switch_ana=' /ANA';
SWITCH_DIG=' /DIG';
SWITCH_RAM=' /RAM';
ControlChars:string=
'111111111111111111111111111111110000000000000000000000000000000000000000000000'+
'0000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000';
PuncChars:string=
'000000000000000000000000000000000111111111111111000000000011111110000000000000'+
'000000000000111111000000000000000000000000001111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000';
WhiteSpaceChars:string=
'0000000001000000000000000000000010000000000000000000000000000000000000000000000'+
'000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000';
SpaceChars:string=
'0000000001111100000000000000000010000000000000000000000000000000000000000000000'+
'000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000';
Printable:string=
'0000000000000000000000000000000011111111111111111111111111111111111111111111111'+
'111111111111111111111111111111111111111111111111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000';
GraphChars:string=
'0000000000000000000000000000000001111111111111111111111111111111111111111111111'+
'111111111111111111111111111111111111111111111111000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000';
REG_EEPROMLIFE='EEPROMLife';
IOChars='0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
appkey='Software\Justin\WinUno';
EEPROM_OUT_OF_RANGE='EEPROM.%s(): address %u is out of range';
runningsketches='VolatileSketches\';
sketchconfig='NonVolatileSketches\';
SERIAL_IN_Ext='.SerialIn%u';
CONTITLEfmt='%s Serial Terminal - %s';
Serial_Out_Ext='.SerialOut%d';
MAX_WRITELIFE=100000;
BOOL_LED_BUILTIN:array[boolean]of string=('','LED');
RegCOMPorts='SYSTEM\CurrentControlSet\Control\COM Name Arbiter\Devices';
switch_nowarn=' /NOWARN';
switch_SCREATE=' /SCREATE ';
param_create_always=SWITCH_SCREATE+'CREATE_ALWAYS';
PARAM_OPEN_ALWAYS=SWITCH_SCREATE+'OPEN_ALWAYS';
PARAM_OPEN_EXISTING=SWITCH_SCREATE+'OPEN_EXISTING';
PARAM_CREATE_NEW=SWITCH_SCREATE+'CREATE_NEW';
PARAM_TRUNCATE_EXISTING=SWITCH_SCREATE+'TRUNCATE_EXISTING';
DigitalPin='Digital%d';
switch_inp=' /INP$';
switch_out=' /OUT$';
InvalidResistance='Invalid Resistance Entered';
AnalogPin='Analog%d';
PinModeName='pinMode%d';
extadc_title='External ADC';
analogname='ANALOG';
DIGITALNAME='DIGITAL';
SWITCH_NOAUTO=' /NOAUTO';
NoModeMsg='%s(): The pin %d has been read/written to without pinMode()';
numeric='0123456789';
alpha='ABCDEFGHIJKMNOPQRSTUVWXYZ';
plotdll='serialplot.dll';
floatchars='-.'+numeric;
intchars='-'+numeric;
appname='WinUno';
CONSOLE_DEFAULT_ATTRIB=foreground_red or foreground_blue or foreground_green;
type
EshiftIn=class(exception);
TArduinoBase=(DEC,BIN,HEX,OCT);
Arduino16=Smallint;
 TPlotInfo=record
Time:TDatetime;
analog:extended;
end;
TPlotData=procedure(var data:tplotinfo);stdcall;
LookaheadMode=(lookahead_default,
SKIP_ALL,
SKIP_NONE,
SKIP_WHITESPACE);
TADCInfo=record
Base:word;
Pin:integer;
Resolution:dword;
end;
edrivererror=class(exception);
PADCInfo=^TADCInfo;
ELibraryNotLoaded=class(exception);//for trying to use a not included header
ESerialPort=class(exception);//virtual serial port errors
EUnsupported=class(exception);//For non supported functions in the emulator
EArduinoModel=class(exception);
//errors that mean it cannot work with the board specified
TInp32=function(Port:Word):word;stdcall;
TOut32=procedure(Port,Data:word);stdcall;
//External hardware I/O Exported functions
  TWinUnoWND = class(TForm)
    Memo1: TMemo;
    MainMenu1: TMainMenu;
    Arduino1: TMenuItem;
    PauseResume1: TMenuItem;
    Exit1: TMenuItem;
    Start1: TMenuItem;
    Stop1: TMenuItem;
    Reset1: TMenuItem;
    DisableInterrupts1: TMenuItem;
    Help1: TMenuItem;
    About1: TMenuItem;
    Options1: TMenuItem;
    ADCResolution1: TMenuItem;
    PWMResolution1: TMenuItem;
    ADCVoltage1: TMenuItem;
    HardReset1: TMenuItem;
    AutoRefresh1: TMenuItem;
    ToggleSwitches1: TMenuItem;
    Switch01: TMenuItem;
    Switch11: TMenuItem;
    Switch21: TMenuItem;
    Switch31: TMenuItem;
    Switch41: TMenuItem;
    Switch51: TMenuItem;
    Switch61: TMenuItem;
    Switch71: TMenuItem;
    Switch81: TMenuItem;
    Switch91: TMenuItem;
    Switch101: TMenuItem;
    Switch111: TMenuItem;
    Analog1: TMenuItem;
    A01: TMenuItem;
    A011: TMenuItem;
    A21: TMenuItem;
    A31: TMenuItem;
    A41: TMenuItem;
    A51: TMenuItem;
    A61: TMenuItem;
    A71: TMenuItem;
    A81: TMenuItem;
    A91: TMenuItem;
    A101: TMenuItem;
    A111: TMenuItem;
    A121: TMenuItem;
    A131: TMenuItem;
    A141: TMenuItem;
    StatusBar1: TStatusBar;
    RandomNoise1: TMenuItem;
    UpdateDelay1: TMenuItem;
    Start2: TMenuItem;
    Drivers1: TMenuItem;
    InpOut1: TMenuItem;
    StartReading1: TMenuItem;
    StartWriting1: TMenuItem;
    WinAPISerial1: TMenuItem;
    ChoosePort1: TMenuItem;
    Inputs1: TMenuItem;
    SetCTSPin1: TMenuItem;
    SetDSRPin1: TMenuItem;
    SetRINGPin1: TMenuItem;
    Outputs1: TMenuItem;
    SetRTSPin1: TMenuItem;
    SetDTRPin1: TMenuItem;
    EnableTX1: TMenuItem;
    Serial11: TMenuItem;
    Serial21: TMenuItem;
    Serial31: TMenuItem;
    SetRLSDPin1: TMenuItem;
    DriverDelay1: TMenuItem;
    StartADC1: TMenuItem;
    WinUnoOnTheWeb1: TMenuItem;
    SerialPlotter1: TMenuItem;
    Tools1: TMenuItem;
    N7SegmentDisplay1: TMenuItem;
    Potentiometer1: TMenuItem;
    Setcenterpin1: TMenuItem;
    Setpercentage1: TMenuItem;
    Up1: TMenuItem;
    Down1: TMenuItem;
    R11: TMenuItem;
    R21: TMenuItem;
    Properties1: TMenuItem;
    SetMaximumResistance1: TMenuItem;
    MultiMeter1: TMenuItem;
    MomentaryButtons1: TMenuItem;
    Pin21: TMenuItem;
    Pin31: TMenuItem;
    Pin41: TMenuItem;
    Pin51: TMenuItem;
    Pin61: TMenuItem;
    Pin71: TMenuItem;
    Pin81: TMenuItem;
    Pin91: TMenuItem;
    Pin101: TMenuItem;
    Pin111: TMenuItem;
    Pin121: TMenuItem;
    Pin131: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure PauseResume1Click(Sender: TObject);
    procedure Reset1Click(Sender: TObject);
    procedure Start1Click(Sender: TObject);
    procedure Stop1Click(Sender: TObject);
    procedure DisableInterrupts1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure ADCResolution1Click(Sender: TObject);
    procedure PWMResolution1Click(Sender: TObject);
    procedure ADCVoltage1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure HardReset1Click(Sender: TObject);
    procedure Memo1Change(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure AutoRefresh1Click(Sender: TObject);
    procedure Switch111Click(Sender: TObject);
    procedure A01Click(Sender: TObject);
    procedure UpdateDelay1Click(Sender: TObject);
    procedure Start2Click(Sender: TObject);
    procedure ChoosePort1Click(Sender: TObject);
    procedure Serial11Click(Sender: TObject);
    procedure SetCTSPin1Click(Sender: TObject);
    procedure DriverDelay1Click(Sender: TObject);
    procedure StartReading1Click(Sender: TObject);
    procedure StartADC1Click(Sender: TObject);
    procedure WinUnoOnTheWeb1Click(Sender: TObject);
    procedure SerialPlotter1Click(Sender: TObject);
    procedure N7SegmentDisplay1Click(Sender: TObject);
    procedure Setcenterpin1Click(Sender: TObject);
    procedure Setpercentage1Click(Sender: TObject);
    procedure Up1Click(Sender: TObject);
    procedure Down1Click(Sender: TObject);
    procedure R11Click(Sender: TObject);
    procedure R21Click(Sender: TObject);
    procedure Properties1Click(Sender: TObject);
    procedure SetMaximumResistance1Click(Sender: TObject);
    procedure MultiMeter1Click(Sender: TObject);
    procedure Pin21Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
  TIsInpOutDriverOpen=function:bool;stdcall;
  TArduinoLibs=ARRAY[0..0]OF dword;
  TIOHardware=class(TObject)
  private
  hk:hkey;
  procedure setVal(x:string;y:dword);
  function getval(X:string):DWord;
  function getText:string;
  procedure setText(S:string);
  public
  constructor Create;
  property Key:hkey read hk;
  property Text:string read gettext write settext;
  property Values[name:string]:dword read getval write setval;
  end;
  EmuString=string;
  TEEPROM=class(tobject)
  private
  Writelife,MaxSize:dword;
  Handl:Thandle;
  bEnabled:boolean;
  function DegradeWriteLife:integer;
  procedure SetEEByte(address:dword;value:byte);
  function GetEEByte(address:dword):byte;
  public
  property Enabled:boolean read benabled write benabled;
  property Handle:Thandle read Handl;
  property EEPROM[address:dword]:byte read getEEbyte write setEEbyte;
  constructor Create(Size:dword);
  function read(address:Dword):byte;
  procedure write(address:dword;value:byte);
  procedure update(address:dword;value:byte);
  function get(address:dword;var variable:dword):dword;overload;
  function put(address:dword;var variable:dword):dword;overload;
  function get(address:dword;var variable:arduino16):dword;overload;
  function put(address:dword;var variable:arduino16):dword;overload;
  function get(address:dword;var variable:byte):dword;overload;
  function put(address:dword;var variable:byte):dword;overload;
  function get(address:dword;var variable:char):dword;overload;
  function put(address:dword;var variable:char):dword;overload;
  function get(address:dword;var variable:integer):dword;overload;
  function put(address:dword;var variable:integer):dword;overload;
  function get(address:dword;var variable:word):dword;overload;
  function put(address:dword;var variable:word):dword;overload;
  end;
  TArduinoString=class(tobject)
  (*
    Arduino string object. it is created by the _STR function.
    This object is not perfect and may cause the compiler to throw
    errors if the code isn't layed out a certain way
    like for example a code like this:
    TArduinoString* s1="abc";
    TArduinoString* s2="123";
    void setup(){
    TArduinoString* s = s1+s2;
    }
    could result into errors.
  *)
  private
  data:pchar;
  function getpchar:string;
  procedure setpchar(Value:string);
  public
  property Text:string read getpchar write setpchar;
  constructor Create;
 function charAt(index:dword):char;
 function compareTo(string2:tarduinostring):integer;overload;
 function compareTo(string2:string):integer;overload;
 function concat(parameter:string):bool;overload;
function concat(parameter:dword):bool;overload;
function concat(parameter:integer):bool;overload;
function concat(parameter:single):bool;overload;
function concat(parameter:tarduinostring):bool;overload;
function concat(parameter:pchar):bool;overload;
function c_str:pchar;
function endsWith(S:string):bool;overload;
function endsWith(S:pchar):bool;overload;
function endsWith(S:TArduinoString):bool;overload;
function equals(s:string):bool;overload;
function equals(s:TArduinoString):bool;overload;
function equals(s:pchar):bool;overload;
function equalsIgnoreCase(s:string):bool;overload;
function equalsIgnoreCase(s:tarduinostring):bool;overload;
function equalsIgnoreCase(s:pchar):bool;overload;
procedure getBytes(var buf:array of byte;len:dword);
function _indexOf(S:string):integer;overload;
function _indexOf(S:pchar):integer;overload;
function _indexOf(S:tarduinostring):integer;overload;
function lastIndexOf(S:string):integer;overload;
function lastIndexOf(S:pchar):integer;overload;
function lastIndexOf(S:TArduinoString):integer;overload;
function _indexOf(S:string;from:integer):integer;overload;
function _indexOf(S:pchar;from:integer):integer;overload;
function _indexOf(S:tarduinostring;from:integer):integer;overload;
function lastIndexOf(S:string;from:integer):integer;overload;
function lastIndexOf(S:pchar;from:integer):integer;overload;
function lastIndexOf(S:TArduinoString;from:integer):integer;overload;
function length():integer;
procedure remove(index,count:integer);
procedure replace(s1,s2:string);overload;
procedure replace(s1,s2:pchar);overload;
procedure replace(s1,s2:tarduinostring);overload;
procedure reserve(size:dword);
procedure setCharAt(index:dword;C:char);
function startsWith(S:string):bool;overload;
function startsWith(S:tarduinostring):bool;overload;
function startsWith(S:pchar):bool;overload;
function subString(from:integer):string;overload;
function subString(from,nTo:integer):string;overload;
function subObjString(from:integer):tarduinostring;overload;
function subObjString(from,nTo:integer):tarduinostring;overload;
procedure toCharArray(var buf:array of char;len:integer);overload;
procedure toCharArray(buf:pchar;len:integer);overload;
function toDouble():double;
function toInt():integer;
function toFloat():single;
procedure toLowerCase();
procedure toUpperCase();
procedure trim();
end;
TInpOutInfo=record
Address:word;
Pins:tstringlist;
direction:boolean;
end;
PInpOutInfo=^TInpOutInfo;
TExternalRandom=function(Max:integer):integer;stdcall;
  TSerialConfig=DWORD;
TGraphSize=function(newSize:integer):Integer;stdcall;
  TSerial=class(TObject)
  private
  Activated:boolean;
  PortNumber:byte;
  mstimeout:longint;
  public
//WinUno only properties and methods
  serialBuffer:string;
property Port:byte read portnumber;
property Active:boolean read activated write activated;
property Timeout:longint read mstimeout;
  constructor Create(Port:byte);
//here are the arduino methods
function available():dword;
function availableForWrite():DWord;
procedure _begin(speed:dword);overload;
procedure _begin(speed:dword;config:tserialconfig);overload;
procedure _end();
function find(target:pchar;len:integer):bool;overload;
function find(target:pchar):bool;overload;
function findUntil(target,terminal:pchar):bool;
procedure flush();
function parseFloat(lookahead:LookaheadMode=lookahead_default;ignore:char=#0):single;
function parseInt(lookahead:LookaheadMode=lookahead_default;ignore:char=#0):longint;
function peek():integer;
function print(text:string):dword;overload;
function println(text:string):dword;overload;
function print(X:single;decimals:integer):dword;overload;
function println(X:single;decimals:integer):dword;overload;
function print(X:single):dword;overload;
function println(X:single):dword;overload;
function print(s:tarduinostring):dword;overload;
function println(s:tarduinostring):dword;overload;
function print(x:integer;base:tarduinobase):dword;overload;
function println(x:integer;base:tarduinobase):dword;overload;
function println:dword;overload;
function read():integer;
function readBytes(var buffer;len:integer):dword;
function readBytesUntil(character:char;var buffer;len:integer):dword;
function readString():string;
function readStringUntil(terminator:char):string;
procedure setTimeout(milliseconds:longint);
function write(buf:pointer;len:dword):Dword;overload;
function write(val:byte):Dword;overload;
function write(str:string):Dword;overload;
  end;
  TIOSerialBit=(logicDTR,logicRTS,logicDSR,logicCTS,logicRING,logicRLSD);
  TIOSerialBits=set of tioserialbit;
  TIOSerial=packed record
  Thread:thandle;
  Pin:byte;
  id:dword;
  end;
  TMatrixpins=record
  Anode,Cathode:byte;
  end;
  TMatrixPinSet=array[0..7,0..7]of TMatrixpins;
  TMatrixInfo=record
  PinSet:tmatrixpinset;
  Exec:ShellExecuteinfo;
  end;
  PMatrixInfo=^TMatrixInfo;
  TArduinoFlags=set of(arduinoOn);
  TArduinoBoot=packed record
  Setup,Loop,serialEvent,serialEvent1,serialEvent2,serialEvent3:tprocedure;
  Flags:TArduinoFlags;
  end;
  TArduinoInterrupt=packed record
  mode:integer;
  callback:TProcedure;
  Handle:thandle;
  ID,Count:DWord;
  Active:boolean;
  end;
  TArduinoSpecs=record
  VDefault,internal,vexternal,ar_internal:single;
  EEPROMSize,SRAM,PWMPins:dword;
  hardwareSS:integer;
  cbDigital,cbAnalog,microsResolution:byte;
  end;
uint8_t =byte;
uint16_t=word;
uint32_t=dword;
  TInterrupts=array[0..31]of tarduinointerrupt;
//  function _STR(X:integer;base:integer):tarduinostring;overload;
function InpOutThread(info:PInpOutInfo):dword;stdcall;
  function F(S:string):string;
function digitalRead(pin:integer):integer;
procedure digitalWrite(pin,value:integer);
procedure pinMode(pin,mode:integer);
function analogRead(pin:integer):dword;
procedure debugLine(line:integer);
function _STR(S:string):tarduinostring;overload;
function _STR(x:integer):string;overload;
function _STR(x:single;decimals:integer):tarduinostring;overload;
function _STR(X:integer;base:TArduinoBase):string;overload;
function _STR(x:dword):tarduinostring;overload;
function digitalPinToInterrupt(pin:integer):integer;
procedure analogReference(aref:single);
procedure analogWrite(pin,duty:integer);
procedure noTone(pin:integer);
function pulseIn(pin, value:integer; timeout:dword):dword;overload;
function pulseIn(pin, value:integer):dword;overload;
function random(x:integer;y:integer):integer;overload;
function random(y:integer):integer;overload;
procedure randomSeed(seed:integer);
function pulseInLong(pin, value:integer; timeout:dword):dword;overload;
function pulseInLong(pin, value:integer):dword;overload;
function shiftIn(dataPin, clockPin,bitOrder:integer):byte;
procedure shiftOut(dataPin, clockPin, bitOrder:integer; value:byte);
procedure tone(pin,freq:integer;duration:integer);overload;
procedure tone(pin,freq:integer);overload;
procedure delay(milliseconds:DWord);
function ArduinoBoot(setup,loop,serialCB,serialCB1,serialCB2,serialCB3:pointer;sketchname:string):integer;
procedure delayMicroseconds(useconds:dword);
function micros():dword;
function millis():dword;
procedure analogReadResolution(bits:integer);
procedure analogWriteResolution(PWMRef:DWord);
function abs(x:single):single;
function constrain(x,a,b:single):single;
function map(x,in_min,in_max,out_min,out_max:longint):longint;
function max(x,y:single):single;overload;
function max(x,y:longint):longint;overload;
function min(x,y:single):single;overload;
function min(x,y:longint):longint;overload;
function pow(x,y:single):single;
function sq(x:single):single;
function sqrt(x:single):single;
function cos(x:single):single;
function sin(x:single):single;
function tan(x:single):single;
function isAlpha(c:char):bool;
function isAlphaNumeric(c:char):bool;
function isAscii(c:char):bool;
function isControl(c:char):bool;
function _STR(x:double):string;overload;
function isDigit(c:char):bool;
function isGraph(c:char):bool;
procedure attachInterrupt(nInterrupt:integer; ISR:pointer; mode:integer);
procedure detachInterrupt(nInterrupt:integer);
function isHexadecimalDigit(c:char):bool;
function isLowerCase(c:char):bool;
function isPrintable(C:char):BOOL;
function isPunct(C:char):bool;
function isSpace(C:char):bool;
function isUpperCase(c:char):bool;
function isWhitespace(c:char):bool;
function bit(n:integer):integer;
function bitClear(x,n:integer):integer;
function bitRead(x,n:integer):integer;
procedure bitSet(var x:integer;n:integer);overload;
procedure bitWrite(var x:integer;n,b:integer);overload;
procedure bitSet(var x:arduino16;n:integer);overload;
function adctovoltage(X:single):single;
procedure bitWrite(var x:arduino16;n,b:integer);overload;
procedure bitSet(var x:dword;n:integer);overload;
procedure bitWrite(var x:dword;n,b:integer);overload;
procedure bitSet(var x:word;n:integer);overload;
procedure bitWrite(var x:word;n,b:integer);overload;
procedure bitSet(var x:byte;n:integer);overload;
procedure bitWrite(var x:byte;n,b:integer);overload;
function highByte(x:word):byte;
function lowByte(x:word):byte;
procedure interrupts();
procedure noInterrupts();
var
strings:tstringlist;
  WinUnoWND: TWinUnoWND;
  EEPROM:TEEPROM=nil;
  hinpout32:hmodule;
  Inp32:tinp32;
  Out32:tout32;
  GraphSize:tgraphsize;
  IsInpOutDriverOpen:TIsInpOutDriverOpen;
  RIOThread:thandle=0;
  WIOThread:thandle=0;
  VRef:Single=5.0;
  lastTonePin:integer;
  potResistance:extended=10000;
  potPercentage,potR1,potR2:extended;
  potCenter:byte=16;
  ADCRes,PWMRes:dword;
  LibrariesUsed:TArduinoLibs;
  currentSerialBits:tioserialbits=[];
  Interruptsarray:TInterrupts;
  HArduino:THandle=0;
  bInterrupts:boolean=true;
  htone:thandle=0;
  ioserials:array[tioserialbit]of tioserial;
  IORef:single=5.0;
  counter:thpcounter;
  IODelay:dword=10;
  IOList:tiohardware;
  noiseDelay:dword=500;//milliseconds for random noise delay
  SerialPortOut:array[0..3]of thandle;
  comport:thandle=invalid_handle_value;
  digitalmenus:array[2..13]of tmenuitem;
  SerialPortIn:array[0..3]of thandle;
  Serial,Serial1,Serial2,Serial3:TSerial;
  DefAnalogs:array[1..15]of dword;
  Specs:TArduinoSpecs;
  bootInfo:TArduinoBoot;
  startedtime:dword;
  microtick:dword=0;
  hkapp,hkCOMPorts,hkNVsketch:hkey;
  ExternalRandom:TExternalRandom;
  startGraph:tprocedure;
  plotData:tplotdata;
  LED_BUILTIN:INTEGER=32;
  sketch_name:string;
implementation
{$R *.DFM}
uses sevenseg,multimeter;

function IntToOct(x:integer):String;
var octalnum,placevalue,decimalNum:Integer;
begin
octalNum:=0;placeValue:=1;decimalNum:=x;
while(decimalNum<>0)do
begin
octalNum:=Octalnum+((decimalnum mod 8)*placevalue);
decimalnum:=decimalnum div 8;
placevalue:=placevalue*10;
end;
result:=inttostr(octalnum);
end;

procedure debugLine(line:integer);
begin
winunownd.statusbar1.panels[1].text:=format('%d line',[line]);
end;
procedure unoAddString(obj:pointer;txt:string);
begin
strings.addobject(txt,obj);
end;
procedure InpOutFromCommandLine(switch:string);
var invalidindex:integer;
s:string;
info:pinpoutinfo;
tid:dword;
begin
if pos(switch,uppercase(getcommandline))>0then begin
s:=copy(uppercase(getcommandline),(pos(switch,uppercase(getcommandline))+length(
switch))-1,maxint);
new(info);
val(s,info.address,invalidindex);
if(pos(',END',s)=0)or(invalidindex=1)then begin dispose(info);exit;end;
info.pins:=tstringlist.create;info.direction:=(switch=switch_inp);
info.pins.commatext:=copy(s,invalidindex+1,pos(',END',s)-1);
createthread(nil,0,@InpOutThread,info,0,tid);
end;
end;

function getMicros:DWord;
var y:tlargeinteger;
begin
y:=counter.ReadInt;
copymemory(@result,@y,4);
end;

function microsTimer(p:pointer):Dword;stdcall;
var last:dword;
begin
last:=getmicros;
while true do
if getmicros-last>=specs.microsresolution then begin inc(microtick);
last:=getmicros;end;
end;

function TSerial.print(x:single):dword;
begin
result:=print(format('%g',[x]));
end;
function TSerial.println(x:single):dword;
begin
result:=println(format('%g',[x]));
end;

function SetEscapeBits(bits:TIOSerialBits):boolean;
begin
result:=true;
if logicrts in bits then result:=result and escapecommfunction(comport,setrts)
else result:=result and escapecommfunction(comport,clrrts);
if logicdtr in bits then result:=result and escapecommfunction(comport,setdtr)
else result:=result and escapecommfunction(comport,clrdtr);
CurrentSerialBits:=bits;
end;
function GetDirection(bit:tioserialbit):boolean;
begin
result:=(bit=logiccts)or(bit=logicdsr)or(bit=logicring)or(logicrlsd=bit);
end;
function GetEscapeBits:TIOSerialbits;
var stats:dword;
begin
GetCommModemStatus(comport,stats);
result:=[];
if stats and MS_CTS_ON>0then result:=result + [logicCTS];
if stats and MS_DSR_ON>0then result:=result + [logicDSR];
if stats and MS_RING_ON>0then result:=result+ [logicRING];
if stats and MS_RLSD_ON>0THEN RESULT:=result+ [logicRLSD];
end;
function SerialBitthread(serialbit:tioserialbit):DWord;stdcall;
begin
if getdirection(serialbit)then pinmode(ioserials[serialbit].pin,output)else
pinmode(ioserials[serialbit].pin,input);
while true do
begin
if getdirection(serialbit) then digitalwrite(ioserials[serialbit].pin,ord(
serialbit in getescapebits))else begin
 if digitalread(ioserials[serialbit].pin)=1then
setescapebits(currentserialbits + [serialbit])else
 setescapebits(currentserialbits - [serialbit]);end;
 if IODelay>0then sleep(IODelay);
 end;
end;
function IntToBin(x:dword):string;
var I:integer;
begin
result:='';
for i:=31downto 0do result:=result+inttostr(ord(x and trunc(power(2,i))>0));
for i:=1to length(result)do if result[i]='0'then result[i]:=#32else break;
result:=stringreplace(result,#32,'',[rfreplaceall]);
if length(result)=0then result:='0';
end;
function RandomNoise(Pin:Integer):Dword;stdcall;
begin
while true do begin
iolist.Values[format(analogpin,[pin+1])]:=externalrandom(adcres+1);
sleep(noisedelay);
end;//while
end;
function tarduinostring.toFloat():single;
var y:extended;
begin
y:=0;
texttofloat(c_str,y,fvextended);
result:=y;
end;
procedure tarduinostring.replace(s1,s2:pchar);
begin
replace(strpas(s1),strpas(s2));
end;
function _STR(X:integer;base:TArduinoBase):string;
begin
case base of
hex:result:=lowercase(inttohex(x,0));
dec:result:=inttostr(x);
bin:result:=inttobin(x);
oct:result:=inttooct(x);
end;
end;
function _STR(x:dword):tarduinostring;
begin
result:=tarduinostring.create;
result.text:=format('%u',[x]);
end;
function _STR(x:single;decimals:integer):tarduinostring;
var I:integer;
ff:string;
begin
ff:='0.';
for i:=1to decimals do ff:=ff+'0';
if length(ff)=2then delete(ff,2,1);
result:=tarduinostring.create;
result.text:=formatfloat(ff,x);
end;
function tserial.print(X:Single;decimals:integer):DWord;
begin
result:=print(_STR(x,decimals));
end;
function tserial.println(X:Single;decimals:integer):DWord;
begin
result:=println(_str(x,decimals));
end;
{function _STR(x:single;decimals:dword):string;
var I:integer;
ff:string;
begin
ff:='0.';
for i:=1to decimals do ff:=ff+'0';
if length(ff)=2then delete(ff,2,1);
result:=formatfloat(ff,x);
end;}
function _STR(x:double):string;
begin
result:=floattostr(x);
end;
function tserial.print(s:tarduinostring):dword;
begin
result:=print(s.text);
end;
function _STR(x:integer):string;
begin
result:=inttostr(x);
end;
function _STR(S:string):tarduinostring;
begin
result:=tarduinostring.create;
result.text:=s;
end;
function tserial.println(s:tarduinostring):dword;
begin
result:=println(s.text);
end;

procedure tarduinostring.toLowerCase();
begin
text:=lowercase(text);
end;
procedure tarduinostring.trim();
begin
text:=sysutils.trim(text);
end;

function tarduinostring.toInt():integer;
begin
result:=strtointdef(text,0);
end;

procedure tarduinostring.toCharArray(var buf:array of char;len:integer);
begin
copymemory(@buf[0],data,min(len,specs.sram));
end;
function tarduinostring.substring(from,nTo:integer):string;
begin
result:=copy(text,from+1,nto-from);
end;
function tarduinostring.subobjstring(from,nTo:integer):TArduinoString;
begin
result:=tarduinostring.create;
result.text:=copy(text,from+1,nto-from);
end;
function tarduinostring.subobjstring(from:integer):TArduinoString;
begin
result:=tarduinostring.create;
result.text:=copy(text,from+1,maxint);
end;
procedure tarduinostring.toUpperCase();
begin
text:=uppercase(text);
end;
procedure tarduinostring.toCharArray(buf:pchar;len:integer);
begin
copymemory(buf,data,min(len,specs.sram));
end;
function tarduinostring.toDouble():double;
var y:extended;
begin
y:=0;
TextToFloat(c_str,y,fvextended);
result:=y;
end;
procedure tarduinostring.reserve(size:dword);
begin
if size>specs.sram then raise EArduinoModel.createfmt(
'String.reserve(%u): Not enough SRAM',[size]);
strdispose(data);
data:=stralloc(size);
end;
procedure tarduinostring.setCharAt(index:dword;C:char);
begin
if index>specs.sram-1then raise EArduinoModel.createfmt(
'setCharAt: %u Index out of range',[index]);
data[index]:=c;
end;
function tarduinostring.startsWith(S:tarduinostring):bool;
begin
result:=startswith(s.text);
end;
function tarduinostring.substring(from:integer):string;
begin
result:=copy(text,from+1,maxint);
end;

function tarduinostring.startsWith(S:string):bool;
begin
result:=(pos(s,text)=1);
end;
function tarduinostring.lastIndexOf(S:pchar;from:integer):integer;
begin
result:=lastindexof(strpas(s),from);
end;
function tarduinostring.startsWith(S:pchar):bool;
begin
result:=startswith(strpas(s));
end;
procedure tarduinostring.replace(s1,s2:tarduinostring);
begin
replace(s1.text,s2.text);
end;
function tarduinostring._indexOf(S:pchar;from:integer):integer;
begin
result:=_indexof(strpas(s),from);
end;
function tarduinostring.length():integer;
begin
result:=strlen(data);
end;
function tarduinostring._indexOf(S:tarduinostring;from:integer):integer;
begin
result:=_indexof(s.text,from);
end;
procedure tarduinostring.replace(s1,s2:string);
begin
text:=stringreplace(text,s1,s2,[rfreplaceall]);
end;
function tarduinostring.equals(s:string):bool;
begin
result:=(text=s);
end;
procedure tarduinostring.remove(index,count:integer);
var s:string;
begin
s:=text;
delete(s,index+1,count);
text:=s;
end;
function tarduinostring._indexOf(S:string):integer;
begin
result:=pos(s,text)-1;
end;
function tarduinostring._indexOf(S:tarduinostring):integer;
begin
result:=_indexof(s.text);
end;
function tarduinostring.lastIndexOf(S:pchar):integer;
begin
result:=lastindexof(strpas(S));
end;
function tarduinostring._indexOf(S:string;from:integer):integer;
begin
result:=pos(copy(s,from,maxint),text)-1;
end;
function tarduinostring.lastIndexOf(S:TArduinoString;from:integer):integer;
begin
result:=lastindexof(s.text,from);
end;
function tarduinostring._indexOf(S:pchar):integer;
begin
result:=_indexof(Strpas(s));
end;
function tarduinostring.equalsIgnoreCase(s:string):bool;
begin
result:=(comparetext(text,s)=0);
end;
function tarduinostring.lastIndexOf(S:string;from:integer):integer;
begin
result:=lastindexof(copy(s,from,maxint));
end;
function tarduinostring.endsWith(S:TArduinoString):bool;
begin
result:=endswith(s.text);
end;
function tarduinostring.lastIndexOf(S:TArduinoString):integer;
begin
result:=lastindexof(s.text);
end;
function tarduinostring.lastIndexOf(S:string):integer;
var i:integer;
begin
result:=-1;
for i:=length-1 downto 0 do begin result:=_indexof(s,i);if result>-1then exit;
end;
end;
procedure tarduinostring.getBytes(var buf:array of byte;len:dword);
begin
copymemory(@buf[0],data,min(len,length));
end;
function tarduinostring.endsWith(S:pchar):bool;
begin
result:=endswith(strpas(s));
end;
function tarduinostring.equalsIgnoreCase(s:pchar):bool;
begin
result:=equalsIgnoreCase(strpas(s));
end;
function tarduinostring.equalsIgnoreCase(s:tarduinostring):bool;
begin
result:=(comparetext(text,s.text)=0);
end;
 function tarduinostring.compareTo(string2:tarduinostring):integer;
begin
result:=comparestr(text,string2.text);
end;
function tarduinostring.concat(parameter:pchar):bool;
begin
result:=concat(strpas(parameter));
end;
 function tarduinostring.compareTo(string2:string):integer;
 begin
 result:=comparestr(text,string2);
 end;
function tarduinostring.endsWith(S:string):bool;
begin
result:=(copy(text,1+(length-system.length(s)),maxint)=s);
end;
 function tarduinostring.concat(parameter:string):bool;
 begin
 result:=(system.length(parameter+text)<specs.sram);
 if not result then exit;
 text:=text+parameter;
 end;
 function tarduinostring.c_STR:pchar;
 begin
 result:=data;
 end;
function tarduinostring.equals(s:pchar):bool;
begin
result:=equals(strpas(s));
end;
 function tarduinostring.concat(parameter:single):bool;
 begin
 result:=concat(floattostr(parameter));
 end;
 function tarduinostring.concat(parameter:dword):bool;
begin
result:=concat(format('%u',[parameter]));
end;
function tarduinostring.concat(parameter:integer):bool;
begin
result:=concat(inttostr(parameter));
end;
procedure bitSet(var x:word;n:integer);
begin
x:=x or bit(n);
end;
procedure bitSet(var x:arduino16;n:integer);
begin
x:=x or bit(n);
end;
function TSerial.write(val:byte):Dword;
var buf:byte;
begin
buf:=val;
result:=write(@buf,1);
end;
function tarduinostring.charAt(index:dword):char;
begin
if index>specs.sram-1 then raise EArduinoModel.createfmt(
'charAt: %u index out of range',[index]);
result:=data[index];
end;
function TSerial.write(str:string):Dword;
begin
result:=length(str);
if result=0then exit;
result:=write(@str[1],length(str));
end;

constructor TArduinoString.create;
begin
data:=strcopy(stralloc(specs.sram),'');
end;

procedure TArduinostring.setpchar(Value:string);
begin
strplcopy(data,value,specs.sram);
end;

procedure bitSet(var x:integer;n:integer);
begin
x:=x or bit(n);
end;
procedure bitSet(var x:dword;n:integer);overload;
begin
x:=x or bit(n);
end;
function GetArduinoBoard:string;
var dummy:integer;
begin
(*
  This loads the specs by the board commandline switch passed
  to the emulator. It returns the name of the board.

  some of the properties in the specs structure are not filled
  out but left there if anyone knows what they are since they
  are going against board spefic details.
*)
result := 'Arduino Uno';
LED_BUILTIN:=13;
specs.cbDigital:=15;
specs.sram:=2048;
specs.cbAnalog:=6;
specs.EEPROMSize:=1024;
specs.microsResolution:=4;
specs.hardwaress:=-1;
specs.PWMPins:=bit(3)or bit(5)or bit(6) or bit(9) or bit(10) or bit(11);
if pos(' /NANO',UPPERCASE(GETCOMMANDLINE))>0THEN
BEGIN
RESULT:= 'Arduino Nano';
specs.microsResolution:=4;
LED_BUILTIN:=maxint;//There is no led built-in
SPECS.cbAnalog:=8;
SPECS.cbDigital:=22;
SPECS.EEPROMSize:=1024;
specs.sram:=2048;
END;
if pos(' /LEONARDO',UPPERCASE(GETCOMMANDLINE))>0THEN
begin
specs.PWMPins:=bit(3) or bit(5) or bit(6)or bit(9)or bit(10)or bit(11)or bit(13);
RESULT:='Arduino Leonardo';
SPECS.cbDigital:=20;
SPECS.cbAnalog:=12;
LED_BUILTIN:=maxint;
specs.microsResolution:=4;
SPECS.EEPROMSize:=1024;
specs.sram:=round(2.5*1024);
end;
if pos(' /MICRO',UPPERCASE(GETCOMMANDLINE))>0THEN
begin
LED_BUILTIN:=13;
specs.PWMPins:=bit(3) or bit(5) or bit(6)or bit(9)or bit(10)or bit(11)or bit(13);
RESULT:='Arduino Micro';
SPECS.cbDigital:=20;
SPECS.cbAnalog:=12;
SPECS.EEPROMSize:=1024;
specs.microsResolution:=4;
specs.sram:=round(2.5*1024);
end;
if pos(switch_pwm,uppercase(getcommandline))>0then
val(copy(strpas(getcommandline),length(switch_pwm)+pos(switch_pwm,uppercase(
getcommandline)),maxint),specs.pwmpins,dummy);
if pos(switch_ana,uppercase(getcommandline))+pos(switch_dig,uppercase(getcommandline))+
pos(switch_ram,uppercase(getcommandline))+pos(' /EEPROM',uppercase(getcommandline))+pos
(' /MICROS8',uppercase(getcommandline))+pos(switch_pwm,uppercase(getcommandline))>0then
result:='Generic Arduino';
// The next lines in the function are for parameter overriding
if pos(SWITCH_ANA,UPPERCASE(GETCOMMANDLINE))>0THEN val(copy(strpas(
getcommandline),pos(switch_ana,uppercase(getcommandline))+length(switch_ana),
maxint),specs.cbanalog,dummy);
if pos(SWITCH_dig,UPPERCASE(GETCOMMANDLINE))>0THEN val(copy(strpas(
getcommandline),pos(switch_dig,uppercase(getcommandline))+length(switch_dig),
maxint),specs.cbdigital,dummy);
if pos(SWITCH_ram,UPPERCASE(GETCOMMANDLINE))>0THEN val(copy(strpas(
getcommandline),pos(switch_ram,uppercase(getcommandline))+length(switch_ram),
maxint),specs.sram,dummy);
if pos(' /EEPROM2K',uppercase(getcommandline))>0then specs.eepromsize:=2048;
if pos(' /EEPROM4K',uppercase(getcommandline))>0then specs.eepromsize:=4096;
if pos(' /EEPROM512',UPPERCASE(GETCOMMANDLINE))>0THEN SPECS.EEPROMSize:=512;
if pos(' /MICROS8',uppercase(getcommandline))>0then specs.microsResolution:=8;
end;

function testPin(PinName:string):integer;
var s:string;
begin
if pos(uppercase(pinname),analogname)=1then begin
s:=copy(pinname,length(analogname)+1,maxint);
result:= system.Abs(strtointdef(s,specs.cbAnalog));
if result>specs.cbAnalog-1then
raise EArduinoModel.Createfmt('%d is not a valid analog pin for this model.',[
result]);
exit;
end else if pos(uppercase(pinname),digitalname)=1then begin
s:=copy(pinname,length(digitalname)+1,maxint);
result:=system.abs(strtointdef(s,specs.cbdigital));
if result>specs.cbdigital-1then
raise EArduinoModel.Createfmt('%d is not a valid analog pin for this model.',[
result]);
exit;
end;
result:=maxint;
end;
  function TIOHardware.getText:string;
  var cbVals,cbvn,rs,data,rtype:dword;
  i:integer;
  vname:array[0..255]of char;
  begin
  result:='';
  regqueryinfokeya(hK,	// handle of key to query
    nil,	// address of buffer for class string
    nil,	// address of size of class string buffer
    nil,	// reserved
    nil,	// address of buffer for number of subkeys
    nil,	// address of buffer for longest subkey name length
    nil,	// address of buffer for longest class string length
    @cbvals,	// address of buffer for number of value entries
    nil,	// address of buffer for longest value name length
    nil,	// address of buffer for longest value data length
    nil,	// address of buffer for security descriptor length
    nil 	// address of buffer for last write time
   );
   for i:=0to cbvals-1do begin cbvn:=256;rs:=4;strcopy(vname,'');
   RegEnumValue(hk,i,vname,cbvn,nil,@rtype,@data,@rs);
   if(rtype=reg_dword)and(strlen(vname)>0) then result:=result+format('%s=%u'#13#10,[vname,data]);
   end;
  end;
  procedure tiohardware.setText(S:string);
  var sl:tstringlist;
  dw:dword;
  I:Integer;
  begin
  sl:=tstringlist.create;
  sl.text:=s;
  for i:=0to sl.count-1do begin dw:=strtointdef(sl.values[sl.names[i]],0);
  regsetvalueex(hk,pchar(sl.names[i]),0,reg_dword,@dw,4);end;
  sl.free;
  end;
function tarduinostring.equals(s:TArduinoString):bool;
begin
result:=equals(s.text);
end;
  function TIOHardware.getval(X:string):DWord;
  var rs:dword;
  begin
testpin(X);
  rs:=4;
  RegQueryValueEx(hk,pchar(x),nil,nil,@result,@rs);
  end;
procedure TIOHardware.setVal(x:string;y:dword);
var pin:integer;
begin
pin:=testpin(x);
if pos(digitalname,x)=1then
if(pin>1)and(pin<14)then digitalmenus[pin].checked:=(y>0);
regsetvalueex(hk,pchar(x),0,reg_dword,@y,4);
if(NOT WINUNOWND.AUTOREFRESH1.CHECKED)OR(pos(' /NOAUTO',UPPERCASE(GETCOMMANDLINE)
)>0)then EXIT;
winunownd.memo1.LineS.Values[x]:=format('%u',[y]);
end;
procedure SerialMonitorLog(text:string;attrib:Word);
begin
winunownd.StatusBar1.Panels[3].text:=text;
if(attrib<>foreground_green)and(pos(switch_nowarn,uppercase(getcommandline))>0)
then exit;
setconsoletextattribute(serialportout[0],attrib);
writeln(text);
setconsoletextattribute(serialportout[0],console_default_attrib);
end;
function random(y:integer):integer;
begin
result:=random(0,y);
end;
procedure tone(pin,freq:integer);
begin
tone(pin,freq,0);
end;

procedure interrupts();
var I:integer;
begin
binterrupts:=true;
for i:=0to 31do
if interruptsarray[i].active then
interruptsarray[i].count:=resumethread(interruptsarray[i].handle);
end;

function TSerial.write(buf:pointer;len:dword):Dword;
begin
result:=0;
if not activated then raise ESerialPort.Create('Serial port not activated');
writefile(serialportout[port],buf^,len,result,nil);
end;

function tarduinostring.concat(parameter:tarduinostring):bool;
begin
result:=concat(parameter.text);
end;

function TSerial.println:dword;
begin
if not activated then raise ESerialPort.Create('Serial port not activated');
result:=println('');
end;
procedure noInterrupts();
var I:integer;
begin
binterrupts:=false;
for i:=0to 31do
interruptsarray[i].count:=suspendthread(interruptsarray[i].handle);
end;
procedure TSerial._begin(speed:dword);
begin
_begin(speed,serial_8n1);
end;
function isUpperCase(c:char):bool;
begin
result:=(strscan(alpha,c)<>nil);
end;
function isWhitespace(c:char):bool;
begin
result:=(whitespacechars[1+ord(c)]='1');
end;
function lowByte(x:word):byte;
begin
result:=lobyte(x);
end;
function isSpace(C:char):bool;
begin
result:=(spacechars[ord(C)+1]='1');
end;
function isPunct(C:char):bool;
begin
result:=(puncchars[ord(C)+1]='1');
end;
function highByte(x:word):byte;
begin
result:=hibyte(x);
end;
function isLowerCase(c:char):bool;
begin
result:=(pos(c,lowercase(alpha))>0);
end;

function isPrintable(C:char):BOOL;
begin
result:=(printable[ord(C)+1]='1');
end;

function isHexadecimalDigit(c:char):bool;
begin
result:=(strtointdef('$'+c,16)<16);
end;

function isDigit(c:char):bool;
begin
result:=(Strscan(numeric,c)<>nil);
end;
function tan(x:single):single;
begin
result:=math.tan(x);
end;
procedure detachInterrupt(nInterrupt:integer);
begin
if(nInterrupt<0)or(nInterrupt>31)then begin serialmonitorlog(format(
'detachInterrupt(%d): Interrupt number out of range',[nInterrupt]),
foreground_red);exit; end;
interruptsarray[nInterrupt].count:=suspendthread(interruptsarray[nInterrupt
].handle);
interruptsarray[nInterrupt].active:=false;
end;
function isAlpha(c:char):bool;
begin
result:=(strscan(alpha,upcase(c))<>nil);
end;
function isAlphaNumeric(c:char):bool;
begin
result:=(strscan(alpha,upcase(c))<>nil)or(strscan(numeric,c)<>nil);
end;
function isAscii(c:char):bool;
begin
result:=(ord(c)<$80);
end;
function isControl(c:char):bool;
begin
result:=(controlchars[1+ord(c)]='1');
end;
function TSerial.print(x:integer;base:tarduinobase):dword;
begin
if not activated then raise ESerialPort.Create('Serial port not activated');
result:=print(_STR(x,base));
end;
function TSerial.println(x:integer;base:tarduinobase):dword;
begin
if not activated then raise ESerialPort.Create('Serial port not activated');
result:=println(_STR(x,base));
end;
function sin(x:single):single;
begin
result:=system.sin(x);
end;
function cos(x:single):single;
begin
result:=system.cos(x);
end;
function isGraph(c:char):bool;
begin
result:=(graphchars[ord(c)+1]='1');
end;
function min(x,y:single):single;overload;
begin
result:=math.min(x,y);
end;
function sq(x:single):single;
begin
result:=x*x;
end;
function sqrt(x:single):Single;
begin
result:=system.sqrt(x);
end;
function min(x,y:longint):longint;overload;
begin
result:=math.min(x,y);
end;
function max(x,y:longint):longint;
begin
result:=math.max(x,y);
end;
function pow(x,y:single):single;
begin
result:=power(x,y);
end;
function max(x,y:single):single;
begin
result:=math.max(x,y);
end;
function InterruptThread(pin:integer):dword;stdcall;
var firstvalue:integer;
begin
interruptsarray[pin].active:=true;
firstvalue:=digitalread(pin);
while true do
begin
case interruptsarray[pin].mode of
low,high:while(digitalread(pin)<>interruptsarray[pin].mode)do;
change:while(digitalread(pin)=firstvalue)do;
falling:pulsein(pin,low,maxdword);
rising:pulsein(pin,high,maxdword);
else begin serialmonitorlog(Format('Unsupported interrupt mode: %d',[
interruptsarray[pin].mode]),foreground_red);exit;end;
end;
firstvalue:=digitalread(pin);
interruptsarray[pin].callback;
end;
end;
procedure attachInterrupt(nInterrupt:integer; ISR:pointer; mode:integer);
begin
if(nInterrupt<0)or(nInterrupt>31)then begin serialmonitorlog(format(
'attachInterrupt(%d,%p,%d): Interrupt number out of range',[nInterrupt,isr,mode])
,foreground_red);exit;end;
interruptsarray[nInterrupt].mode:=mode;
interruptsarray[nInterrupt].callback:=isr;
interruptsarray[nInterrupt].count:=resumethread(interruptsarray[nInterrupt
].handle);
end;

procedure analogWriteResolution(PWMRef:DWord);
begin
pwmres:=bit(pwmref-1)-1;
end;
procedure delay(milliseconds:Dword);
begin
sleep(milliseconds);
end;
procedure shiftOut(dataPin, clockPin, bitOrder:integer; value:byte);
var sBitOrder:String;
begin
case bitOrder of
MSBFIRST:sbitorder:='M';
LSBFIRST:sBitorder:='L';
else sbitorder:='?';
end;
winunownd.memo1.lines.values['shiftOut']:=format('(%d,%d,%sSBFIRST,%u)',[datapin,
clockpin,sBitorder,value]);
end;

function shiftIn(dataPin, clockPin,bitOrder:integer):byte;
var data:dword;
cmdline:array[0..255]of char;
exec:Shellexecuteinfo;
begin
zeromemory(@exec,sizeof(exec));
exec.cbsize:=sizeof(exec);
exec.fmask:=see_mask_nocloseprocess or SEE_MASK_FLAG_NO_UI;
exec.lpfile:='rundll32.exe';
exec.lpparameters:=strfmt(cmdline,'unodll.dll,shiftInput %d %d %d',[datapin,
clockpin,bitorder]);
exec.nshow:=sw_show;
if not shellexecuteex(@exec)then
raise EshiftIn.Createfmt('Could not start shifter: %s',[syserrormessage(
getlasterror)]);
waitforsingleobject(exec.hprocess,infinite);
data:=maxdword-1;
getexitcodeprocess(exec.hprocess,data);
closehandle(exec.hprocess);
if data=maxdword then exit;
if data>255then raise EshiftIn.createfmt('0x%x is too high',[data]);
result:=data;
end;

procedure analogReadResolution(bits:integer);
begin
adcRes:=bit(bits-1)-1;
end;
function pulseInLong(pin, value:integer; timeout:dword):dword;
begin
result:=pulsein(pin,value,timeout);
end;

function pulseIn(pin, value:integer; timeout:dword):dword;
var tick:dword;
begin
result:=0;
if not bInterrupts then begin
serialmonitorlog('pulseIn(): Interrupts are not enabled',foreground_red);exit;
end;
tick:=getmicros;
while(digitalread(pin)xor value<>high xor value)do if((gettickcount*1000)-tick>
timeout)and(timeout>0)THEN exit;
while(digitalread(pin)xor value=high xor value)do if((gettickcount*1000)-tick>
timeout)and(timeout>0)THEN exit;
while(digitalread(pin)xor value<>high xor value)do if((gettickcount*1000)-tick>
timeout)and(timeout>0)THEN exit;
result:=getmicros-tick;
end;
function pulseInLong(pin, value:integer):dword;
begin
result:=pulsein(pin,value,1000*1000);
end;

function pulseIn(pin, value:integer):dword;
begin
result:=pulsein(pin,value,1000*1000);
end;

procedure analogReference(aref:single);
begin
case trunc(aref) of
VDEFAULT:VREF:=Specs.vdefault;
Internal:vref:=specs.internal;
ar_internal:vref:=specs.ar_internal;
vexternal:vref:=specs.vexternal;
else vref:=aref;
end;
end;

function digitalPinToInterrupt(pin:integer):integer;
begin
result:=pin;
end;

procedure delayMicroseconds(useconds:dword);
var startMicros:dword;
begin
startMicros:=getmicros;
while(getmicros-startMicros<useconds)do asm NOP end;
end;

function TSerial.readStringUntil(terminator:char):string;
var lasttick:dword;
begin
if not activated then raise ESerialPort.Create('Serial port not activated');
result:='';
lasttick:=gettickcount;
while(pos(terminator,result)=0)do
begin
if gettickcount-lasttick>mstimeout then exit;
if length(serialbuffer)>0then
result:=result+serialbuffer[1];
if ansilastchar(result)=terminator then begin delete(result,length(terminator),1);
exit;end
end;
end;
procedure TSerial.setTimeout(milliseconds:longint);
begin
if not activated then raise ESerialPort.Create('Serial port not activated');
mstimeout:=milliseconds;
end;

function SerialDistribution:dword;
begin
result:=create_always;
if pos(PARAM_OPEN_ALWAYS,uppercase(getcommandline))>0then result:=open_always;
if pos(PARAM_OPEN_EXISTING,uppercase(getcommandline))>0then result:=open_existing;
if pos(PARAM_CREATE_NEW,uppercase(getcommandline))>0then result:=create_new;
if pos(PARAM_TRUNCATE_EXISTING,uppercase(getcommandline))>0then result:=
TRUNCATE_EXISTING;
end;

function TSerial.readBytesUntil(character:char;var buffer;len:integer):dword;
var lastTick:DWord;
begin
if not activated then raise ESerialPort.Create('Serial port not activated');
result:=0;
lastTick:=gettickcount;
zeromemory(@buffer,len);
while(result<len)do begin
if gettickcount-lasttick>mstimeout then exit;
if length(serialbuffer)>0then begin
pchar(@buffer)[result]:=serialbuffer[1];
inc(result);
serialbuffer:=copy(serialbuffer,2,maxint);
end;
if strscan(@buffer,character)<>nil then break;
end;
if strscan(@buffer,character)<>nil then strscan(@buffer,character)[0]:=#0;
end;

procedure TSerial.flush;
begin
if not activated then raise ESerialPort.Create('Serial port not activated');

serialbuffer:='';
end;
function TSerial.readString:string;
var lasttick:dword;
begin
if not activated then raise ESerialPort.Create('Serial port not activated');
result:='';
lasttick:=gettickcount;
while length(serialbuffer)=0do begin
if gettickcount-lasttick>mstimeout then exit;
end;
result:=serialbuffer;
serialbuffer:='';
end;
function tserial.read():integer;
begin
if not activated then raise ESerialPort.Create('Serial port not activated');

result:=-1;
if length(serialbuffer)>0then result:=ord(serialbuffer[1]);
serialbuffer:='';
end;
function TSerial.peek;
begin
if not activated then raise ESerialPort.Create('Serial port not activated');
result:=-1;
if length(serialbuffer)>0then result:=ord(serialbuffer[1]);
end;

function ToFloat(s:string;def:extended):extended;
begin
result:=def;
TextToFloat(pchar(s),result,fvextended);
end;

function TSerial.print(text:string):dword;
var plotInfo:tplotinfo;
begin
if not activated then raise ESerialPort.Create('Serial port not activated');
result:=0;
writefile(serialportout[port],text[1],length(text),result,nil);
if port=0then begin plotinfo.Time:=now;if assigned(plotdata)and texttofloat(
pchar(text),plotinfo.analog,fvextended)then plotdata(plotinfo); end;
end;

function TSerial.println(text:string):dword;
var buff:string;
plotInfo:tplotinfo;
begin
if not activated then raise ESerialPort.Create('Serial port not activated');
buff:=text+#13#10;
result:=0;
writefile(serialportout[port],buff[1],length(buff),result,nil);
if port=0then begin plotinfo.Time:=now;if assigned(plotdata)and texttofloat(
pchar(text),plotinfo.analog,fvextended)then plotdata(plotinfo); end;
end;

function TSerial.find(target:pchar;len:integer):bool;
var leng:integer;
begin
if not activated then raise ESerialPort.Create('Serial port not activated');
leng:=len;
if leng=0then leng:=strlen(target);
result:=(pos(copy(strpas(target),1,leng),serialbuffer)>0);
end;
function tserial.find(target:pchar):bool;
begin
if not activated then raise ESerialPort.Create('Serial port not activated');
result:=find(target,0);
end;
function TSerial.readBytes(var buffer;len:integer):dword;
begin
if not activated then raise ESerialPort.Create('Serial port not activated');
result:=length(serialbuffer);strplcopy(@buffer,serialbuffer,len);
end;
function TSerial.findUntil;
begin
if not activated then raise ESerialPort.Create('Serial port not activated');
result:=find(target)or find(terminal);
end;

function tserial.parseFloat(lookahead:LookaheadMode=lookahead_default;ignore:char=#0):single;
var xs:string;
I:integer;
begin
if not activated then raise ESerialPort.Create('Serial port not activated');
xs:=serialbuffer;
result:=0;
case lookahead of
skip_none:asm nop end;
skip_all:for i:=1to length(xs)do if strscan(floatchars,xs[i])=nil then xs[i]:='*';
skip_whitespace:for i:=1to length(xs)do if iswhitespace(xs[i]) then
xs[i]:='*';
end;
try result:=strtofloat(stringreplace(xs,'*','',[rfreplaceall])); except end;
end;
function tserial.parseInt(lookahead:LookaheadMode=lookahead_default;ignore:char=#0):integer;
var xs:string;
I:integer;
begin
if not activated then raise ESerialPort.Create('Serial port not activated');
xs:=serialbuffer;
result:=0;
case lookahead of
skip_none:asm nop end;
skip_all:for i:=1to length(xs)do if strscan(intchars,xs[i])=nil then xs[i]:='*';
skip_whitespace:for i:=1to length(xs)do if iswhitespace(xs[i]) then
xs[i]:='*';
end;
try result:=strtoint(stringreplace(xs,'*','',[rfreplaceall])); except end;
end;

procedure TSerial._begin(speed:dword;config:TSerialConfig);
begin
case speed of
300, 600, 1200, 2400, 4800, 9600, 14400, 19200, 28800, 31250, 38400, 57600,
115200:asm nop end;//do nothing if speed is one of the following
else raise ESerialPort.createfmt('%u is not a valid baud rate',[speed]);
end;
activated:=true;
if(iolist.Values[format(pinmodename,[0])]<>pin_nomode)or(iolist.Values[format(
pinmodename,[1])]<>pin_nomode)then serialmonitorlog(
'WARNING! Pin 0 and/or pin 1 have modes set, they should not be used as digital pins when serial monitor is working',
foreground_red);
if port>0 then exit;
serialmonitorlog(format('[%s] Serial port start at %d',[timetostr(now),speed]),
foreground_green);
end;
procedure TSerial._end;
begin
activated:=false;
if port=0 then exit;
serialmonitorlog(format('[%s] Serial port stop',[timetostr(now)]),
foreground_green);
end;
function TSerial.available;
begin
if not activated then raise ESerialPort.Create('Serial port not activated');
result:=length(serialbuffer);
end;
function TSerial.availableForWrite;
begin
if not activated then raise ESerialPort.Create('Serial port not activated');
result:=maxint;//max write buffer size
end;

  constructor TEEPROM.Create(Size:dword);
  var tmpBuff:array of byte;
  dwWritten,rs:dword;
  Begin
  maxsize:=size;
  enabled:=(LibrariesUsed[0]and lib_eeprom_h>0);
  if not enabled then exit;
  writelife:=MAX_WRITELIFE;
  rs:=4;
  RegQueryValueExA(hknvsketch,REG_EEPROMLife,nil,nil,@writelife,@rs);
  regsetvalueex(hknvsketch,reg_eepromlife,0,reg_dword,@writelife,4);
  handl:=createfile(pchar(changefileext(sketch_name,'.EEPROM')),GENERIC_READ OR
  GENERIC_WRITE,FILE_SHARE_READ OR FILE_SHARE_WRITE,nil,OPEN_ALWAYS,
  FILE_ATTRIBUTE_NORMAL,0);
  if getfilesize(handle,nil)<>size then begin closehandle(handl);
  handl:=createfile(pchar(changefileext(sketch_name,'.EEPROM')),GENERIC_READ OR
  GENERIC_WRITE,FILE_SHARE_READ OR FILE_SHARE_WRITE,nil,create_always,
  FILE_ATTRIBUTE_NORMAL,0);setlength(tmpbuff,size);
fillmemory(@tmpbuff[0],size,255);writefile(handle,tmpbuff[0],size,dwwritten,nil);
  setlength(tmpbuff,0);
  end;
  end;
constructor TSerial.Create(port:byte);
begin
activated:=false;
portnumber:=port;
Serialbuffer:='';
mstimeout:=1000;
end;
function random(x:integer;y:integer):integer;
begin
result:=trunc(math.min(x,system.random(y)));
end;

function TEEPROM.GetEEByte(address:dword):byte;
var dwRead:dword;
begin
if not enabled then raise ELibraryNotLoaded.createfmt(
'EEPROM.EEPROM[%u]: EEPROM.h not included',[address]);
if address>maxsize then raise EArduinoModel.createfmt(eeprom_out_of_range,[
'EEPROM',address]);
setfilepointer(handle,address,nil,file_begin);
result:=0;
readfile(handle,result,1,dwRead,nil);
end;

function TEEPROM.read(address:dword):Byte;
begin
if not enabled then raise ELibraryNotLoaded.createfmt(
'EEPROM.read(%u): EEPROM.h not included',[address]);
if address>maxsize then raise EArduinoModel.createfmt(eeprom_out_of_range,[
'read',address]);
result:=geteebyte(address);
end;

function TEEPROM.DegradeWriteLife:integer;
begin
if writelife>0then
writelife:=writelife-1;
result:=writelife;
regsetvalueex(hknvsketch,reg_eepromlife,0,reg_dword,@writelife,4);
if writelife<1000then serialmonitorlog(format(
'EEPROM Writelife has %d/%d recommended max. writes left',[result,max_writelife]),
foreground_blue);
end;

function bit(n:integer):integer;
begin
result:=trunc(power(2,n));
end;

function bitRead(x,n:integer):integer;
begin
result:=ord(x and bit(n)<>0);
end;

procedure bitWrite(var x:byte;n,b:integer);
begin
x:=x or bit(n);
if b=0 then x:=x xor bit(n);
end;
procedure bitWrite(var x:arduino16;n,b:integer);
begin
x:=x or bit(n);
if b=0 then x:=x xor bit(n);
end;

procedure bitWrite(var x:word;n,b:integer);
begin
x:=x or bit(n);
if b=0 then x:=x xor bit(n);
end;
procedure bitWrite(var x:dword;n,b:integer);
begin
x:=x or bit(n);
if b=0 then x:=x xor bit(n);
end;
procedure bitWrite(var x:integer;n,b:integer);
begin
x:=x or bit(n);
if b=0 then x:=x xor bit(n);
end;

procedure bitSet(var x:byte;n:integer);
begin
x:=x or bit(n);
end;

function bitClear(x,n:integer):integer;
begin
result:=x;
if x and bit(n)<>0 then result:=result xor bit(n);
end;
procedure randomSeed(seed:integer);
begin
randseed:=seed;
end;
function constrain(x,a,b:single):single;
begin
result:=x;
if x<a then result:=a;
if x>b then result:=b;
end;

function map(x,in_min,in_max,out_min,out_max:longint):longint;
begin
result:=(x - in_min) * (out_max - out_min) div (in_max - in_min) + out_min;
end;

procedure TEEPROM.SetEEByte;
var bytetowrite:byte;
dwWritten:DWord;
begin
if not enabled then raise ELibraryNotLoaded.createfmt(
'EEPROM.EEPROM[%u]: EEPROM.h not included',[address]);
if address>maxsize then raise EArduinoModel.createfmt(eeprom_out_of_range,[
'EEPROM',address]);
bytetowrite:=value;
setfilepointer(handle,address,nil,file_begin);
writefile(handle,bytetowrite,1,dwWritten,nil);
end;
procedure TEEPROM.write(address:dword;value:byte);
begin
if not enabled then raise ELibraryNotLoaded.createfmt(
'EEPROM.write(%u): EEPROM.h not included',[address,value]);
if address>maxsize then raise EArduinoModel.createfmt(eeprom_out_of_range,[
'write',address]);
setEEbyte(address,value);
degradewritelife;
end;
function teeprom.get(address:dword;var variable:byte):DWord;
var dwBytes:dword;
begin
if not enabled then raise ELibraryNotLoaded.createfmt(
'EEPROM.get(%u,%u): EEPROM.h not included',[address,variable]);
if address+sizeof(variable)>maxsize then raise EArduinoModel.createfmt(
eeprom_out_of_range,['get',address]);
result:=setfilepointer(handle,address,nil,FILE_BEGIN);
readfile(handle,variable,sizeof(variable),dwBytes,nil);
end;

function teeprom.get(address:dword;var variable:char):dword;
var dwBytes:Dword;
begin

if not enabled then raise ELibraryNotLoaded.createfmt(
'EEPROM.get(%u,"%s"): EEPROM.h not included',[address,variable]);
if address+sizeof(variable)>maxsize then raise EArduinoModel.createfmt(
eeprom_out_of_range,['get',address]);
result:=setfilepointer(handle,address,nil,FILE_BEGIN);
readfile(handle,variable,sizeof(variable),dwBytes,nil);
end;

function teeprom.get(address:dword;var variable:dword):DWord;
var dwBytes:dword;
begin
if not enabled then raise ELibraryNotLoaded.createfmt(
'EEPROM.get(%u,%u): EEPROM.h not included',[address,variable]);
if address+sizeof(variable)>maxsize then raise EArduinoModel.createfmt(
eeprom_out_of_range,['get',address]);
result:=setfilepointer(handle,address,nil,FILE_BEGIN);
readfile(handle,variable,sizeof(variable),dwBytes,nil);
end;
function teeprom.get(address:dword;var variable:word):DWord;
var dwBytes:dword;
begin
if not enabled then raise ELibraryNotLoaded.createfmt(
'EEPROM.get(%u,%u): EEPROM.h not included',[address,variable]);
if address+sizeof(variable)>maxsize then raise EArduinoModel.createfmt(
eeprom_out_of_range,['get',address]);
result:=setfilepointer(handle,address,nil,FILE_BEGIN);
readfile(handle,variable,sizeof(variable),dwBytes,nil);
end;

function teeprom.get(address:dword;var variable:integer):DWord;
var dwBytes:dword;
begin
if not enabled then raise ELibraryNotLoaded.createfmt(
'EEPROM.get(%u,%d): EEPROM.h not included',[address,variable]);
if address+sizeof(variable)>maxsize then raise EArduinoModel.createfmt(
eeprom_out_of_range,['get',address]);
result:=setfilepointer(handle,address,nil,FILE_BEGIN);
readfile(handle,variable,sizeof(variable),dwBytes,nil);
end;
function teeprom.get(address:dword;var variable:arduino16):DWord;
var dwBytes:dword;
begin
if not enabled then raise ELibraryNotLoaded.createfmt(
'EEPROM.get(%u,%d): EEPROM.h not included',[address,variable]);
if address+sizeof(variable)>maxsize then raise EArduinoModel.createfmt(
eeprom_out_of_range,['get',address]);
result:=setfilepointer(handle,address,nil,FILE_BEGIN);
readfile(handle,variable,sizeof(variable),dwBytes,nil);
end;

function TEEPROM.put(address:dword;var variable:dword):dword;
var dwWrote:Dword;
begin
if not enabled then raise ELibraryNotLoaded.createfmt(
'EEPROM.put(%u,%u): EEPROM.h not included',[address,variable]);
if address+sizeof(variable)>maxsize then raise EArduinoModel.createfmt(
eeprom_out_of_range,['put',address]);
result:=setfilepointer(handle,address,nil,file_begin);
writefile(handle,variable,sizeof(variable),dwWrote,nil);
end;

function teeprom.put(address:dword;var variable:char):dword;
var dwwrote:dword;
begin
if not enabled then raise ELibraryNotLoaded.createfmt(
'EEPROM.put(%u,"%s"): EEPROM.h not included',[address,variable]);
if address+sizeof(variable)>maxsize then raise EArduinoModel.createfmt(
eeprom_out_of_range,['put',address]);
result:=setfilepointer(handle,address,nil,file_begin);
writefile(handle,variable,sizeof(variable),dwWrote,nil);
end;
function TEEPROM.put(address:dword;var variable:byte):dword;
var dwWrote:Dword;
begin
if not enabled then raise ELibraryNotLoaded.createfmt(
'EEPROM.put(%u,%u): EEPROM.h not included',[address,variable]);
if address+sizeof(variable)>maxsize then raise EArduinoModel.createfmt(
eeprom_out_of_range,['put',address]);
result:=setfilepointer(handle,address,nil,file_begin);
writefile(handle,variable,sizeof(variable),dwWrote,nil);
end;

function TEEPROM.put(address:dword;var variable:word):dword;
var dwWrote:Dword;
begin
if not enabled then raise ELibraryNotLoaded.createfmt(
'EEPROM.put(%u,%u): EEPROM.h not included',[address,variable]);
if address+sizeof(variable)>maxsize then raise EArduinoModel.createfmt(
eeprom_out_of_range,['put',address]);
result:=setfilepointer(handle,address,nil,file_begin);
writefile(handle,variable,sizeof(variable),dwWrote,nil);
end;

function TEEPROM.put(address:dword;var variable:integer):dword;
var dwWrote:Dword;
begin
if not enabled then raise ELibraryNotLoaded.createfmt(
'EEPROM.put(%u,%d): EEPROM.h not included',[address,variable]);
if address+sizeof(variable)>maxsize then raise EArduinoModel.createfmt(
eeprom_out_of_range,['put',address]);
result:=setfilepointer(handle,address,nil,file_begin);
writefile(handle,variable,sizeof(variable),dwWrote,nil);
end;
function TEEPROM.put(address:dword;var variable:arduino16):dword;
var dwWrote:Dword;
begin
if not enabled then raise ELibraryNotLoaded.createfmt(
'EEPROM.put(%u,%d): EEPROM.h not included',[address,variable]);
if address+sizeof(variable)>maxsize then raise EArduinoModel.createfmt(
eeprom_out_of_range,['put',address]);
result:=setfilepointer(handle,address,nil,file_begin);
writefile(handle,variable,sizeof(variable),dwWrote,nil);
end;

procedure TEEPROM.update(address:dword;value:byte);
var currentbyte:byte;
begin
if not enabled then raise ELibraryNotLoaded.createfmt(
'EEPROM.update(%u,%u): EEPROM.h not included',[address,value]);
currentbyte:=geteebyte(address);
if currentbyte<>value then seteebyte(address,value);
end;

function F(S:string):string;
begin
result:=s;
end;

function abs(x:single):single;
begin
result:=system.abs(x);
end;

function millis():dword;
begin
result:=gettickcount-startedtime;
end;

function micros():DWord;
begin
result:=microtick*specs.microsResolution;
end;

procedure analogWrite(pin,duty:integer);
begin
if specs.PWMPins and bit(Pin)=0 then serialmonitorlog(format(
'analogWrite(%d,%d): Not a valid PWM Pin',[pin,duty]),foreground_red);
if IOList.values[Format('PWMPin%d',[pin])]=duty then exit;
IOList.values[Format('PWMPin%d',[pin])]:=duty;
end;


procedure noTone(pin:integer);
begin
if(lasttonepin<>pin)then serialmonitorlog(format(
'noTone(%d): This doesn'#39't match the last pin',[pin]),foreground_red);
if htone=0then exit;
terminatethread(htone,1);
closehandle(htone);
end;

function toneforever(freq:integer):dword;stdcall;
begin
result:=dword(windows.beep(freq,maxdword));
if result=0then
serialmonitorlog('tone():'+syserrormessage(getlasterror),foreground_red);
end;

procedure tone(pin,freq:integer;duration:integer);
var tid:dword;
begin
if pos(' /NOTONE',uppercase(getcommandline))>0 then begin
if pos(switch_nowarn,uppercase(getcommandline))=0then
serialmonitorlog(format('tone(%d,%d,%d)',[pin,freq,duration]),foreground_green);
exit;
 end;
if duration=0then htone:=createthread(nil,0,@toneforever,
pointer(freq),0,tid)else if not windows.beep(freq,duration)then
serialmonitorlog(format('tone(%d,%d,%d): %s',[pin,freq,duration,syserrormessage(
getlasterror)]),foreground_red);
lasttonepin:=pin;
end;

function EEPROMSize:DWord;
begin
result:=1024;
end;

function tarduinostring.getpchar:string;
begin
result:=strpas(data);
end;

{function _STR(x:integer;base:TArduinoBase):tarduinostring;
begin
result:=tarduinostring.create;
case base of
hex:result.text:=lowercase(inttohex(x,0));
dec:result.text:=inttostr(x);
bin:result.text:=inttobin(x);
oct:result.text:=inttooct(x);
end;
end;
}
function serialThread(obj:TSerial):DWord;stdcall;
var s:string;
serialfn:array[0..max_path]of char;
dwRead,dwsize:dword;
I:integer;
serialData:array of byte;
begin
setlength(serialdata,0);
if obj.port>0 then
while true do
begin
dwsize:=getfilesize(serialportin[obj.port],nil);
if(dwsize>0)and(dwsize<>maxdword)then begin
 setlength(serialdata,dwsize+1);
 readfile(serialportin[obj.port],serialdata[0],dwsize,dwread,nil);
 closehandle(serialportin[obj.port]);
 serialportin[obj.port]:=createfile(strpcopy(serialfn,changefileext(sketch_name,
 format(serial_in_ext,[obj.port]))), generic_read or generic_write,file_share_read or
 file_share_write,nil,SerialDistribution,file_attribute_normal,0);
for i:=0to dwsize-1do
obj.serialbuffer:=obj.serialbuffer+chr(serialdata[i]);
if pos(' /NL',uppercase(getcommandline))>0then obj.serialbuffer:=
obj.serialbuffer+#13#10;
end;
if obj.Activated and(length(obj.serialbuffer)>0)then
case obj.Port of
1:if assigned(bootinfo.serialevent1)then bootinfo.serialEvent1;
2:if assigned(bootinfo.serialevent2)then bootinfo.serialevent2;
3:if assigned(bootinfo.serialevent3)then bootinfo.serialevent3;
end;
sleep(obj.timeout);
end;
while true do begin readln(s);obj.serialBuffer:=obj.serialBuffer+s;
if assigned(bootinfo.serialevent)and obj.Activated then bootinfo.serialevent;
end;
end;

function arduinoThread(P:pointer):dword;stdcall;
Var S:string;
tid,loopcount:dword;
hMicros:thandle;
begin
startedtime:=gettickcount;
counter.Start;
hMicros:=createthread(nil,0,@microstimer,nil,0,tid);
result:=0;
loopcount:=0;
try
bootinfo.Setup;
while arduinoOn in bootinfo.flags do begin inc(loopcount);bootinfo.Loop;
winunownd.statusbar1.panels[2].text:=format('%u Loops',[loopcount]);end;
except on e:exception do begin S:=e.ClassName;serialmonitorlog(format(
'%s - %s: %s',[timetostr(now),s,e.message]),foreground_red);end;end;
harduino:=0;
winunownd.PauseResume1.Enabled:=false;
terminatethread(hmicros,0);
closehandle(hmicros);
end;

function ArduinoBoot(setup,loop,serialCB,serialCB1,serialCB2,serialCB3:pointer;sketchname:string):integer;
var contitle:array[0..512]of char;
begin
result:=0;
IF STRPOS(GETCOMMANDLINE,' /?')<>NIL THEN BEGIN
writeln('Usage: ',extractfilename(paramstr(0)),
' [/EEPROM2K] [/EEPROM512] [/EEPROM4K] [/NL] [/NOAUTO] [/NOWARN] [/UNO] [/LEONARDO] [/MICRO] [/NANO] [/MICRO8] [/INP$PORT pins,END] [/OUT$PORT pins,END] [/ANAx] [/DIGx] [/RAMx] [/PWM<PINMASK>]');
writeln('Parameters:');
Writeln('/NL           Insert new line bytes on every incoming data from the serial terminal, by default the data is received with out new line and always gets data when the enter key is pressed.');
writeln('/NOAUTO       Don'#39't start emulating the sketch');
writeln('/NOWARN       Disables warnings');
writeln('/UNO          Emulates an Arduino Uno');
Writeln('/NANO         Emulates an Arduino Nano');
writeln('/MICRO        Emulates an Arduino Micro');
writeln('/LEONARDO     Emulates an Arduino Leonardo');
writeln('/EEPROM2K     Set EEPROM Image size to 2KB');
writeln('/EEPROM512    Set EEPROM Image size to 512 bytes or half a kilobyte');
writeln('/EEPROM4K     Set EEPROM Image size to 4KB');
writeln('/NOAR         No autorefresh, default is autorefresh enabled');
writeln('/MICROS8      Use micros function that is on 8 MHz boards.');
writeln('/INP$PORT     Uses a input I/O Address as a hexadecimal number "PORT" and after that there is a list of pins that end with the word "END"');
writeln('/OUT$PORT     Uses a output I/O Address as a hexadecimal number "PORT" and after that there is a list of pins that end with the word "END"');
writeln('/ANAx         Defines the number of analog pins. Replace x with the number of pins');
writeln('/DIGx         Defines the number of digital pins. Replace x with the number of pins');
writeln('/RAMx         Defines the number of bytes in SRAM');
writeln('/PWM          Defines which pins are PWM, it will be a 32-bit decimal number representing where LSB is pin 0 and MSB is the pin 31. For example /PWM3 represents pin 1 and 2 are PWM.');
exit;
END;
if win32platform<>VER_PLATFORM_WIN32_NT then fatalappexit(
0,'Needs Windows NT type windows');
bootinfo.Setup:=Setup;
bootinfo.Loop:=loop;
bootinfo.serialEvent :=serialcb;
bootinfo.serialEvent1:=serialcb1;
bootinfo.serialEvent2:=serialcb2;
bootinfo.serialEvent3:=serialcb3;
bootinfo.flags:=[arduinoOn];
sketch_name:=sketchname;
setconsoletitle(strlfmt(contitle,512,contitlefmt,[getarduinoboard,sketchname]));
application.initialize;
application.createform(TWinUnoWnd,WinUnoWnd);
application.run;
end;

function analogRead(pin:integer):dword;
var adcpin:integer;
begin
adcpin:=system.abs(pin);
if pin>-1 then
inc(adcpin);
if abs(adcpin)>specs.cbAnalog then raise EArduinoModel.CreateFmt(
'analogRead(%d): Analog pin doesn'#39't exist on this board',[system.abs(adcpin)]);
result:=IOList.values[format(analogpin,[adcpin])];
end;

function digitalRead(pin:integer):integer;
begin
if iolist.Values[format(pinmodename,[pin])]=pin_nomode then
serialmonitorlog(format(nomodemsg,['digitalRead',pin]),foreground_red);
if(pin<-specs.cbAnalog)or(pin>specs.cbDigital)then exit;
if pin>-1then
begin
result:=iolist.values[format(digitalpin,[pin])];
end else result:=Ord(trunc(analogread(pin)*(vref/(adcres-1)))>=ioref);
end;

procedure digitalWrite(pin,value:integer);
begin
if iolist.Values[format(pinmodename,[pin])]=pin_nomode then
serialmonitorlog(format(nomodemsg,['digitalWrite',pin]),foreground_red);
if pin=led_builtin then winunownd.StatusBar1.Panels[0].text:=BOOL_LED_BUILTIN[(
Value<>0)];
IOList.values[format(digitalpin,[pin])]:=ord(value<>0);
with winunownd do
case pin of
2:switch01.checked:=(value<>0);
3:switch11.checked:=(value<>0);
4:switch21.checked:=(value<>0);
5:switch31.checked:=(value<>0);
6:switch41.checked:=(value<>0);
7:switch51.checked:=(value<>0);
8:switch61.checked:=(value<>0);
9:switch71.checked:=(value<>0);
10:switch81.checked:=(value<>0);
11:switch91.checked:=(value<>0);
12:switch101.checked:=(value<>0);
13:switch111.checked:=(value<>0);
end;
end;

procedure pinMode(pin,mode:integer);
begin
if IOList.Values[format(pinmodename,[pin])]=mode then
exit;
IOList.Values[format(pinmodename,[pin])]:=mode;
end;

function ExternalADCThread(Info:PADCInfo):dword;stdcall;
var adcval:dword;
begin
while true do
begin
out32(info.base+2,(inp32(info.base+2)xor 1)or bit(5));
adcval:=inp32(info.base);
if info.resolution>=bit(8)then
adcval:=adcval or(bit(8)*ord(inp32(info.base+1)and bit(3)>0));
if info.resolution>=bit(9)then
adcval:=adcval or(bit(9)*ord(inp32(info.base+1)and bit(4)>0));
if info.resolution>=bit(10)then
adcval:=adcval or(bit(10)*ord(inp32(info.base+1)and bit(5)>0));
if info.resolution>=bit(11)then
adcval:=adcval or(bit(11)*ord(inp32(info.base+1)and bit(6)>0));
if info.resolution>=bit(12)then
adcval:=adcval or(bit(12)*ord(inp32(info.base+1)and bit(7)=0));//inverted
iolist.values[format(analogpin,[info.pin])]:=adcval;
if iodelay>0then sleep(iodelay);
end;
end;

procedure TWinUnoWND.FormCreate(Sender: TObject);
var I:integer;
disp,tid:dword;
serialfn:array[0..max_path]of char;
comparams:tstringlist;
begin
strings:=tstringlist.create;
counter:=thpcounter.create(nil);
startgraph:=getprocaddress(loadlibrary(plotdll),'startGraph');
graphsize:=getprocaddress(getmodulehandle(plotdll),'graphSize');
if assigned(startgraph)then startGraph else serialplotter1.Enabled:=false;
plotdata:=getprocaddress(loadlibrary(plotdll),'plotData');
hinpout32:=loadlibrary('InpOut32.dll');
out32:=getprocaddress(hinpout32,'Out32');
inp32:=getprocaddress(hinpout32,'Inp32');
winunownd.inpout1.enabled:=false;
IsInpOutDriverOpen:=getprocaddress(hinpout32,'IsInpOutDriverOpen');
if assigned(out32)and assigned(inp32)and assigned(IsInpOutDriverOpen)then
winunownd.InpOut1.Enabled:=IsInpOutDriverOpen;
winapiserial1.enabled:=(RegOpenKeyEx(hkey_local_machine,RegCOMPorts,0,key_read,
hkCOMPorts)=error_success);
zeromemory(@ioserials,sizeof(ioserials));
ExternalRandom:=getprocaddress(loadlibrary('extrand.dll'),'ExternalRandom');
if not assigned(externalrandom)then fatalappexit(0,'extrand.dll not loaded');
SetCTSPin1.Tag:=ord(logiccts);
setrtspin1.Tag:=ord(logicrts);
setdtrpin1.Tag:=ord(logicdtr);
setringpin1.Tag:=ord(logicring);
setdsrpin1.Tag:=ord(logicdsr);
setRLSDpin1.Tag:=ord(logicRLSD);
digitalmenus[2]:=switch01;
digitalmenus[3]:=switch11;
digitalmenus[4]:=switch21;
digitalmenus[5]:=switch31;
digitalmenus[6]:=switch41;
digitalmenus[7]:=switch51;
digitalmenus[8]:=switch61;
digitalmenus[9]:=switch71;
digitalmenus[10]:=switch81;
digitalmenus[11]:=switch91;
digitalmenus[12]:=switch101;
digitalmenus[13]:=switch111;
autorefresh1.checked:=(pos(' /NOAR',UPPERCASE(GETCOMMANDLINE))=0);
icon.handle:=loadicon(hinstance,makeintresource(1));
application.icon.handle:=icon.handle;
regcreatekeyex(hkey_current_user,appkey,0,nil,reg_option_non_volatile,
key_all_access,nil,hkapp,@disp);
regcreatekeyex(hkapp,pchar(sketchconfig+sketch_name),0,nil,
reg_option_non_volatile,key_all_access,nil,hknvsketch,@disp);
iolist:=tiohardware.create;
caption:=format(caption,[sketch_name]);
application.title:=caption;
serialportin[0]:=getstdhandle(std_input_handle);
serialportout[0]:=getstdhandle(std_output_handle);
for i:=1to 3do begin serialportin[i]:=createfile(strpcopy(serialfn,changefileext(
sketch_name,format(serial_in_ext,[i]))),generic_read,file_share_read or file_Share_write,nil,
serialdistribution,file_attribute_normal,0);serialportout[i]:=createfile(
strpcopy(serialfn,changefileext(sketch_name,format(serial_out_ext,[i]))),generic_write or generic_read,
file_share_read or file_Share_write,nil,serialdistribution,file_attribute_normal,
0);end;
serial:=tserial.create(0);createthread(nil,0,@serialThread,pointer(serial),
0,tid);
serial1:=tserial.create(1);createthread(nil,0,@serialThread,pointer(serial1),
0,tid);
serial2:=tserial.create(2);createthread(nil,0,@serialThread,pointer(serial2),
0,tid);
serial3:=tserial.create(3);createthread(nil,0,@serialThread,pointer(serial3),
0,tid);
adcres:=bit(10);
pwmres:=bit(8);
zeromemory(@interruptsarray,sizeof(interruptsarray));
randomize;
eeprom:=teeprom.create(specs.EEPROMSize);
for i:=1to specs.cbAnalog do begin defanalogs[i]:=externalrandom(adcres+1);
iolist.Values[format(analogpin,[i])]:=defanalogs[i];end;
for i:=0to specs.cbDigital-1 do begin iolist.Values[format(digitalpin,[i])]:=0;
interruptsarray[i].handle:=createthread(nil,0,@interruptthread,pointer(i),
create_suspended,interruptsarray[i].id);end;
for i:=0to specs.cbDigital-1 do iolist.Values[format(pinmodename,[i])]:=pin_nomode;
iolist.text:=memo1.text;
inpoutfromcommandline(switch_inp);
inpoutfromcommandline(switch_out);
IF POS(SWITCH_NOAUTO,UPPERCASE(GETCOMMANDLINE))=0THEN
harduino:=Createthread(nil,0,@arduinothread,nil,0,tid);
pauseresume1.Checked:=(harduino<>0);
memo1.text:=iolist.text;
end;

procedure TWinUnoWND.PauseResume1Click(Sender: TObject);
begin
if harduino=0then exit;
pauseresume1.Checked:=(not pauseresume1.Checked);
if pauseresume1.Checked then
resumethread(harduino)else
suspendthread(harduino);
end;

procedure TWinUnoWND.Reset1Click(Sender: TObject);
var tid:dword;
begin
terminatethread(harduino,1);
closehandle(harduino);
harduino:=createthread(nil,0,@arduinothread,nil,0,tid);
end;

procedure TWinUnoWND.Start1Click(Sender: TObject);
var tid:dword;
begin
if harduino<>0 then exit;
harduino:=createthread(nil,0,@arduinothread,nil,0,tid);
end;

procedure TWinUnoWND.Stop1Click(Sender: TObject);
begin
if harduino=0then exit;
terminatethread(harduino,2);
closehandle(harduino);
harduino:=0;
end;

procedure TWinUnoWND.DisableInterrupts1Click(Sender: TObject);
begin
disableinterrupts1.Checked:=not disableinterrupts1.Checked;
if disableinterrupts1.Checked then nointerrupts else interrupts;
end;

procedure TWinUnoWND.About1Click(Sender: TObject);
var msgbox:msgboxparams;
begin
zeromemory(@msgbox,sizeof(msgbox));
msgbox.cbSize:=sizeof(msgbox);
msgbox.hwndOwner:= handle;
msgbox.hInstance:=hinstance;
msgbox.lpszText:=Pchar(
'delphijustin WinUno v1.01'#13#10+
'A free arduino emulator'#13#10+
'By Justin Roeder'#13#10+
'Microsecond counter:'+counter.copyright+#13#10+
'Serial Plotter: TEasyGraph 1.92 * by Vit Kovalcik'#1310+
'In loving memory of grandpa John Engel(1930-2020)');
msgbox.lpszCaption:='About';
msgbox.dwStyle:=mb_usericon;
msgbox.lpszIcon:=makeintresource(1);
messageboxindirect(msgbox);
end;

procedure TWinUnoWND.ADCResolution1Click(Sender: TObject);
begin
adcres:=bit(strtointdef(inputbox('ADC Resolution',
'Number of bits used in ADC Convertor','10'),10));
end;

procedure TWinUnoWND.PWMResolution1Click(Sender: TObject);
begin
pwmres:=bit(strtointdef(inputbox('PWM Resolution',
'Number of bits used in Pulse Width Modulation','8'),8));
end;

procedure TWinUnoWND.ADCVoltage1Click(Sender: TObject);
begin
vref:=strtofloat(inputbox('Analog Voltage Reference',
'Enter maximum analog voltage',floattostr(vref)));
end;

constructor TIOHardware.Create;
var disp:dword;
begin
regdeletekey(hkapp,pchar(runningsketches+sketch_name));
regcreatekeyex(hkapp,pchar(runningsketches+sketch_name),0,nil,
reg_option_volatile,key_all_access,nil,hk,@disp);
end;
procedure TWinUnoWND.FormClose(Sender: TObject; var Action: TCloseAction);
var i:integer;
begin
regclosekey(hknvsketch);
if winapiserial1.enabled then regclosekey(hkCOMPorts);
regclosekey(iolist.key);
regdeletekey(hkapp,pchar(runningsketches+sketch_name));
regclosekey(hkapp);
if harduino<>0then begin terminatethread(harduino,3);closehandle(harduino);end;
closehandle(EEPROM.Handle);
for i:=1to 3do begin closehandle(serialportin[i]);closehandle(serialportout[i]);
 end;
end;

procedure TWinUnoWND.HardReset1Click(Sender: TObject);
var params:string;
I:integer;
begin
params:=paramstr(1);
for i:=2to paramcount do params:=params+#32+paramstr(i);
if ShellExecute(handle,nil,pchar(paramstr(0)),pchar(params),nil,sw_show)<33then
exit;
close;
end;

procedure TWinUnoWND.Memo1Change(Sender: TObject);
begin
iolist.Text:=memo1.Text;
end;

procedure TWinUnoWND.Exit1Click(Sender: TObject);
begin
close;
end;

procedure TWinUnoWND.AutoRefresh1Click(Sender: TObject);
begin
Autorefresh1.Checked:=not autorefresh1.Checked;
end;

procedure TWinUnoWND.Switch111Click(Sender: TObject);
begin
digitalwrite(TMenuitem(sender).tag,digitalread(tmenuitem(sender).tag)xor 1);
end;

function adctovoltage(X:single):single;
begin
result:=x*(vref/adcres);
end;

function voltagetoadc(v:single):dword;
var I:integer;
begin
result:=0;
for i:=0to adcres do if adctovoltage(i)>=v then begin result:=i;exit;end;
end;

function setvoltage(pin:integer):DWord;
var y:string;
begin
y:=floattostr(adctovoltage(analogread(pin)));
result:=voltagetoadc(strtofloat(inputbox('Analog Voltage','Enter analog voltage',
y)));
end;

function setAnalog(Pin:integer):Dword;
begin
result:=strtoint(inputbox('Analog Value',format('Enter a value between 0 and %u',[
adcres]),inttostr(analogread(pin))));
end;

procedure TWinUnoWND.A01Click(Sender: TObject);
var pin:integer;
begin
pin:=strtoint(copy(tmenuitem(sender).caption,3,2));
case messagebox(handle,
'Do you want to enter a voltage or analog value?'#13#10'Click yes for voltage'#13#10'Click no for analog value',
appname,mb_yesnocancel or mb_iconquestion) of
idyes:iolist.Values[format(analogpin,[pin])]:=setvoltage(pin);
idno:iolist.Values[format(analogpin,[pin])]:=setanalog(pin);
end;
end;

procedure TWinUnoWND.UpdateDelay1Click(Sender: TObject);
var sdelay:string;
begin
sdelay:=inttostr(noisedelay);
if not inputquery('Random Noise Delay','Enter delay in milliseconds',sdelay)then
exit;
noisedelay:=strtointdef(sdelay,noisedelay);
end;

procedure TWinUnoWND.Start2Click(Sender: TObject);
var pin:string;
tid:dword;
begin
pin:='0';
if not inputquery('Random Noise Generator','Enter pin for random noise generator',
pin)then exit;
createthread(nil,0,@randomnoise,pointer(strtointdef(pin,0)),0,tid);
end;

procedure TWinUnoWND.ChoosePort1Click(Sender: TObject);
var lpcom:array[0..15]of char;
nCOMPort:integer;
begin
if comport<>invalid_handle_value then
if messagebox(handle,
'Doing this will close the current serial port.'#13#10'Do you want to do that?',
appname,mb_iconwarning or mb_yesno)<>idyes then exit;
ncomport:=strtointdef(inputbox('Setup Serial Port','Enter ComPort Number',''),0);
if(RegQueryValueEx(hkcomports,strlfmt(lpcom,15,'COM%d',[nCOMPort]),nil,nil,nil,
nil)<>error_success)then begin messagebox(handle,
'Invalid serial port. It must be the number without the word "COM"',appname,
mb_iconerror);exit; end;
if comport<>invalid_handle_value then closehandle(comport);
comport:=createfile(strlfmt(lpcom,15,'\\.\COM%d',[ncomport]),generic_read or
generic_write,0,nil,open_existing,file_attribute_normal,0);
SetEscapeBits([]);
end;

procedure TWinUnoWND.Serial11Click(Sender: TObject);
begin
closehandle(serialportout[TMenuitem(sender).tag]);
serialportout[tmenuitem(sender).tag]:=comport;
end;

procedure TWinUnoWND.SetCTSPin1Click(Sender: TObject);
var pin:string;
serPin:TIOSerialBit;
begin
pin:='2';
serpin:=tioserialbit(tmenuitem(sender).tag);
if ioserials[serpin].thread<>0 then
if messagebox(handle,'This pin is being used, continue?',appname,mb_iconwarning
or mb_yesno)<>idyes then exit;
if not inputquery('Serial I/O','Enter digital arduino pin number',pin)then exit;
ioserials[serpin].pin:=strtointdef(pin,2);
terminatethread(ioserials[serpin].thread,0);
closehandle(IOserials[serpin].thread);
ioserials[serpin].thread:=createthread(nil,0,@serialbitthread,pointer(serpin),0,
ioserials[serpin].id);

end;

procedure TWinUnoWND.DriverDelay1Click(Sender: TObject);
begin
IODelay:=strtointdef(inputbox('Driver Delay','Enter delay in milliseconds','10'),
10);
end;

function digitalOut(pins:tstringlist):byte;
var I:integer;
begin
result:=0;
FOR I:=0to pins.count-1do
if strtointdef(pins[i],-16)>-16 then
pinmode(strtoint(pins[i]),output);
for i:=0to pins.count-1do
if strtointdef(pins[i],-16)>-16then
result:=result or(digitalread(strtoint(pins[i]))*bit(i));
end;

procedure digitalIn(pins:tstringlist;value:byte);
var I:Integer;
begin
for i:=0to pins.count-1do
if strtointdef(pins[i],-16)>-16then
pinMode(strtoint(pins[i]),INPUT);
for i:=0to pins.Count-1do
if strtointdef(pins[i],-16)>-16then
digitalwrite(strtoint(pins[i]),ord(value and bit(i)>0));
end;

function InpOutThread(info:PInpOutInfo):dword;stdcall;
begin
serialmonitorlog(format('[%s] I/O Port %x is enabled',[timetostr(now),
info.address]),foreground_green);
while true do begin
if info.direction then digitalin(info.pins,inp32(info.address))else out32(
info.address,digitalout(info.pins));
if iodelay>0then sleep(iodelay);
end;//while
end;

procedure TWinUnoWND.StartReading1Click(Sender: TObject);
var tid:dword;
info:pinpoutinfo;
sAddr,sPins:string;
begin
saddr:='$378';
spins:='2,3,unused,4';
if not inputquery('Setup I/O','Enter I/O address to use',saddr)then exit;
if not inputquery('Assign Pins','Seperate pins by commas',sPins)then exit;
new(info);
info.direction:=(sender=startreading1);
info.Pins:=tstringlist.Create;
info.Pins.CommaText:=spins;
info.Address:=strtointdef(saddr,$378);
if info.Pins.Count>8 then begin messagebox(handle,'Cannot go over 8 bits',appname,
mb_iconerror);info.Pins.Free;dispose(info);exit; end;
createthread(nil,0,@inpoutthread,info,0,tid);
end;

procedure TWinUnoWND.StartADC1Click(Sender: TObject);
var info:padcinfo;
szPin,LPTBASE,LPTRES:string;
tid:dword;
begin
szpin:='0';
LPTBASE:='$378';
LPTRES:='10';
If not inputquery(extadc_title,'Enter analog pin to use',szpin)then exit;
if not inputquery(extadc_title,'Enter LPT Base I/O Address',lptbase)then exit;
if not inputquery(extadc_title,'Enter resolution',lptres)then exit;
new(info);
info.base:=strtointdef(lptbase,$378);
info.pin :=strtointdef(szpin,0)+1;
info.resolution:=bit(strtointdef(lptres,10));
adcres:=bit(strtointdef(lptres,10));
createthread(nil,0,@externaladcthread,info,0,tid);
end;

procedure TWinUnoWND.WinUnoOnTheWeb1Click(Sender: TObject);
begin
ShellExecuteA(0,nil,'http://arduinoemulator.xyz',nil,nil,sw_show);
end;

procedure TWinUnoWND.SerialPlotter1Click(Sender: TObject);
var showGraph:tprocedure;
begin
showGraph:=getprocaddress(getmodulehandle(plotdll),'showGraph');
if assigned(showgraph)then showgraph;
end;

procedure TWinUnoWND.N7SegmentDisplay1Click(Sender: TObject);
var sevensegment:tsevensegment;
begin
sevensegment:=tsevensegment.create(nil);
sevensegment.visible:=true;
end;

procedure TWinUnoWND.Setcenterpin1Click(Sender: TObject);
var spin:string;
begin
spin:=inttostr(potcenter);
if potcenter>15then spin:='0';
if not inputquery('Set Center Pin','Enter analog pin',spin)then exit;
potcenter:=strtointdef(spin,potcenter)+1;
end;

procedure updatePot;
begin
potr1:=potresistance*0.01*potpercentage;
potr2:=potresistance*0.01*(100-potpercentage);
end;

procedure TWinUnoWND.Setpercentage1Click(Sender: TObject);
var sPercent:string;
begin
spercent:=floattostr(potpercentage);
if not inputquery('Enter Percentage','Potentiometer pecentage',spercent)then
exit;
if not texttofloat(pchar(spercent),potpercentage,fvextended)then exit;
if(potpercentage>100)or(potpercentage<0)then begin
potpercentage:=50;
messagebox(handle,'The percentage entered is not valid so using 50%',appname,
mb_iconwarning);
end;
iolist.values[format(analogpin,[potcenter])]:=round(0.01*adcres*potpercentage);
updatepot;
end;

procedure TWinUnoWND.Up1Click(Sender: TObject);
begin
if potpercentage+5>100then exit;
potpercentage:=potpercentage+5;
iolist.values[format(analogpin,[potcenter])]:=round(0.01*adcres*potpercentage);
updatepot;
end;

procedure TWinUnoWND.Down1Click(Sender: TObject);
begin
if potpercentage-5<0then exit;
potpercentage:=potpercentage-5;
iolist.values[format(analogpin,[potcenter])]:=round(0.01*adcres*potpercentage);
updatepot;
end;

procedure TWinUnoWND.R11Click(Sender: TObject);
begin
if not texttofloat(pchar(inputbox('Enter R1','Enter R1 of the voltage divider',
floattostr(potr1))),potr1,fvextended)then messagebox(handle,invalidResistance,
appname,mb_iconerror);
if(potr1<=0)or(potr2<=0)then exit;
iolist.values[format(analogpin,[potCenter])]:=voltagetoadc(vref*(potr2/(potr1+
potr2)));
end;

procedure TWinUnoWND.R21Click(Sender: TObject);
begin
if not texttofloat(pchar(inputbox('Enter R2','Enter R2 of the voltage divider',
floattostr(potr1))),potr2,fvextended)then messagebox(handle,InvalidResistance,
appname,mb_iconerror);
if(potr1<=0)or(potr2<=0)then exit;
iolist.values[format(analogpin,[potcenter])]:=voltagetoadc(vref*(potr2/(potr1+
potr2)));
end;

procedure TWinUnoWND.Properties1Click(Sender: TObject);
var msgtext:array[0..255]of char;
begin
if potcenter>15then begin messagebox(handle,
'There is no potentiometer center pin setup',appname,mb_iconerror);exit;end;
messagebox(handle,strlfmt(msgtext,255,
'Center Pin: %d'#13#10'Voltage: %n'#13#10'Resistance: %n'#13#10'R1: %n'#13#10'R2: %n',
[potcenter,adctovoltage(analogread(potcenter)),potresistance,potr1,potr2]),
'Potentiometer Properties',0);
end;

procedure TWinUnoWND.SetMaximumResistance1Click(Sender: TObject);
var oldres:extended;
begin
oldres:=potresistance;
if not texttofloat(pchar(inputbox('Choose Potentiometer','Enter Resistance',
floattostr(potresistance))),potresistance,fvextended)then messagebox(handle,
InvalidResistance,appname,mb_iconerror);
if potresistance<0then begin potresistance:=oldres; messagebox(handle,
'Resistance cannot be negative',appname,mb_iconerror);end;
end;

procedure TWinUnoWND.MultiMeter1Click(Sender: TObject);
var dmm:tamultimeter;
adcpin:integer;
begin
adcpin:=strtointdef(inputbox('Multimeter','Enter analog pin','0'),-1);
if(adcpin<0)or(adcpin>specs.cbanalog)then begin
messagebox(handle,'Invalid ADC Pin',appname,mb_iconerror);
exit;
end;
dmm:=tamultimeter.create(nil);
dmm.analoginput:=adcpin;
dmm.visible:=true;
end;

function MomentaryButton(Pin:Integer):dword;stdcall;
var pinName:string;
I:integer;
begin
pinname:=format(digitalpin,[pin]);
for i:=1to 2do begin
iolist.values[pinname]:=iolist.values[pinname]xor 1;
sleep(100);
end;
end;

procedure TWinUnoWND.Pin21Click(Sender: TObject);
var tid:dword;
pin:integer;
begin
pin:=tmenuitem(sender).tag;
createthread(nil,0,@momentarybutton,pointer(pin),0,tid);
end;

end.
