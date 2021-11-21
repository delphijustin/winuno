unit custboard;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, StdCtrls, CheckLst, ExtCtrls, ComCtrls, Tabnotbk,math;
const comportskey='SYSTEM\CurrentControlSet\Control\COM Name Arbiter\Devices';
type
  TWinUnoCustom = class(TForm)
    TabbedNotebook1: TTabbedNotebook;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    RadioGroup1: TRadioGroup;
    Label3: TLabel;
    Edit3: TEdit;
    Label4: TLabel;
    CheckListBox1: TCheckListBox;
    Label5: TLabel;
    MainMenu1: TMainMenu;
    Start1: TMenuItem;
    Edit4: TEdit;
    UpDown1: TUpDown;
    UpDown2: TUpDown;
    UpDown3: TUpDown;
    GroupBox1: TGroupBox;
    Edit5: TEdit;
    CheckBox1: TCheckBox;
    Label6: TLabel;
    Label7: TLabel;
    Edit6: TEdit;
    GroupBox2: TGroupBox;
    Label8: TLabel;
    Edit7: TEdit;
    Label9: TLabel;
    Edit8: TEdit;
    CheckBox2: TCheckBox;
    RadioGroup2: TRadioGroup;
    Label10: TLabel;
    Edit9: TEdit;
    CheckListBox2: TCheckListBox;
    Label11: TLabel;
    Edit10: TEdit;
    procedure Start1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure RadioGroup2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  WinUnoCustom: TWinUnoCustom;
  hkcomports:hkey;
implementation

uses winunomanager;

{$R *.DFM}

procedure updateParams;
var i,pwmmask:integer;
pwm:tstringlist;
begin
with winunocustom do begin
Edit4.Text:='/DIG'+Edit1.text+' /ANA'+edit2.Text;
if radiogroup1.itemindex>0then edit4.text:=edit4.text+' /EEPROM'+
radiogroup1.Items[radiogroup1.Itemindex];
edit4.Text:=edit4.Text+' /RAM'+Edit3.Text+' /'+
radiogroup2.items[radiogroup2.itemindex];
for i:=0to checklistbox1.Items.Count-1do
if checklistbox1.Checked[i]then edit4.Text:=edit4.Text+#32+checklistbox1.Items[i
];
if checkbox1.Checked then edit4.Text:=edit4.Text+' /INP'+edit5.Text+#32+
edit6.Text+',END';
if checkbox2.Checked then edit4.Text:=edit4.Text+' /OUT'+edit7.Text+#32+
edit8.Text+',END';
pwm:=tstringlist.Create;
pwm.CommaText:=edit10.Text;
pwmmask:=0;
for i:=0to pwm.Count-1do pwmmask:=pwmmask or trunc(power(2,strtointdef(
pwm[i],0)));
if pwmmask<>0then
edit4.Text:=edit4.Text+' /PWM'+INTTOSTR(PWMMask);
edit9.Clear;
FOR I:=0to checklistbox2.Items.Count-1do
if checklistbox2.Checked[i]then edit9.Text:=edit9.Text+#32+checklistbox2.Items[i
];
end;
end;

procedure TWinUnoCustom.Start1Click(Sender: TObject);
begin
etcparams:=edit4.text;
winunoman.listbox1dblclick(nil);
close;
end;

procedure TWinUnoCustom.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
action:=cahide;
end;

procedure TWinUnoCustom.FormCreate(Sender: TObject);
var comname:array[0..15]of char;
comcount,ns:dword;
i:integer;
begin
updateparams;
tabbednotebook1.PageIndex:=0;
end;

procedure TWinUnoCustom.RadioGroup2Click(Sender: TObject);
begin
updateparams;
end;

end.
