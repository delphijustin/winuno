unit serialPlot1;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, EasyGraph,MDParser10,printers;

type
  TSerialPlotter = class(TForm)
    EasyGraph1: TEasyGraph;
    MainMenu1: TMainMenu;
    SaveDialog1: TSaveDialog;
    File1: TMenuItem;
    SaveGraph1: TMenuItem;
    Exit1: TMenuItem;
    CopyToClipboard1: TMenuItem;
    Print1: TMenuItem;
    PrintDialog1: TPrintDialog;
    Zoom1: TMenuItem;
    Showactualtime1: TMenuItem;
    GotoTheEnd1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure EasyGraph1XLabeling(Sender: TObject; Val: Extended;
      var Lbl: String);
    procedure SaveGraph1Click(Sender: TObject);
    procedure CopyToClipboard1Click(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Print1Click(Sender: TObject);
    procedure Zoom1Click(Sender: TObject);
    procedure Showactualtime1Click(Sender: TObject);
    procedure GotoTheEnd1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
 TPlotInfo=record
Time:TDatetime;
analog:extended;
end;
PPlotInfo=^TPlotinfo;

var
  SerialPlotter: TSerialPlotter;
  started:boolean;
  plots:tlist;
 MAX_PLOTS:integer=MaxListSize;
 implementation

{$R *.DFM}

procedure GetPlot(Anop:poperation);far;
begin
if plots.count=0then exit;
anop^.dest^:=PPlotInfo(plots[abs(trunc(anop^.arg1^))mod plots.count]).analog;
end;

procedure TSerialPlotter.FormCreate(Sender: TObject);
begin
plots:=tlist.create;
Easygraph1.Parser.AddFunctionOneParam('plot',getplot);
easygraph1.Series.BeginUpdate;
easygraph1.Series.Add;
easygraph1.Series.Series[0].func:='plot(x)';
easygraph1.Series.EndUpdate;
end;

procedure TSerialPlotter.EasyGraph1XLabeling(Sender: TObject;
  Val: Extended; var Lbl: String);
begin
if plots.count=0then exit;
if showactualtime1.Checked then
lbl:=TimeToStr(pplotinfo(plots[abs(trunc(val))mod plots.count]).time)else
lbl:=format('%n',[val]);
end;

procedure TSerialPlotter.SaveGraph1Click(Sender: TObject);
begin
if not savedialog1.Execute then exit;
case savedialog1.FilterIndex of
1:easygraph1.SaveAsJpeg(savedialog1.filename);
2:easygraph1.SaveAsBmp(savedialog1.filename);
3:easygraph1.saveaswmf(savedialog1.filename);
4:easygraph1.saveasemf(savedialog1.filename);
end;
end;

procedure TSerialPlotter.CopyToClipboard1Click(Sender: TObject);
begin
easygraph1.CopyToClipboard;
end;

procedure TSerialPlotter.Exit1Click(Sender: TObject);
begin
close;
end;

procedure TSerialPlotter.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
action:=cahide;
end;

procedure TSerialPlotter.Print1Click(Sender: TObject);
begin
printer.Title:='WinUno SerialPlotter';
printer.BeginDoc;
printer.Canvas.StretchDraw(rect(0,0,printer.pagewidth,printer.pageheight),
easygraph1.bitmap);
printer.EndDoc;
end;

procedure TSerialPlotter.Zoom1Click(Sender: TObject);
var rec:trect2d;
sx1,sx2,sy1,sy2:ansistring;
begin
rec:=easygraph1.VisRect;
sx1:=floattostr(rec.X1);
sy1:=floattostr(rec.Y1);
sx2:=floattostr(rec.x2);
sy2:=floattostr(rec.y2);
if not inputquery('Zoom','Enter X1',sx1)then exit;
if not inputquery('Zoom','Enter Y1',sy1)then exit;
if not inputquery('Zoom','Enter X2',sx2)then exit;
if not inputquery('Zoom','Enter Y2',sy2)then exit;
if not(texttofloat(pchar(sx1),rec.x1,fvextended)and texttofloat(pchar(sy1),
rec.y1,fvextended)and texttofloat(pchar(sx2),rec.x2,fvextended)and
texttofloat(pchar(sy2),rec.y2,fvextended))then exit;
easygraph1.VisRect:=rec;
end;
procedure TSerialPlotter.Showactualtime1Click(Sender: TObject);
begin
showactualtime1.Checked:=not showactualtime1.Checked;
end;

procedure TSerialPlotter.GotoTheEnd1Click(Sender: TObject);
var rec:trect2d;
begin
rec:=easygraph1.VisRect;
rec.X1:=plots.count-100;
rec.X2:=plots.count;
easygraph1.VisRect:=rec;
end;

end.
