library serialPlot;
(*
  This library is used for plotting graphs.
  It requires the following Delphi VCL Components

  TEasyGraph
  TMDParser10
*)
{$RESOURCE serialplot32.res}
uses
  SysUtils,
  windows,
  Classes,
  serialPlot1 in 'serialPlot1.pas' {SerialPlotter},
  EasyGraph in 'egraph\EasyGraph.pas',
  MDP10Build in 'egraph\MDP10Build.pas',
  MDParser10 in 'egraph\MDParser10.pas';

procedure plotData(var data:tplotinfo);stdcall;
var lpPlot:pplotinfo;
begin
if not started then exit;
if plots.count>max_plots then begin dispose(plots[0]);plots.delete(0);end;
new(lpplot);
copymemory(lpplot,@data,sizeof(data));
plots.add(lpplot);
end;

procedure startGraph;
begin
if started then exit;
started:=true;
SerialPlotter:=tserialplotter.create(nil);
end;

procedure showGraph;
begin
Serialplotter.visible:=true;
serialplotter.BringToFront;
end;

function graphSize(newsize:integer):integer;stdcall;
begin
(*
  This functions changes or gets the maximum number of plots
  If newsize = -1 then the size is unchanged but returns with
  the current size. The return value is the old plot size.

  NOTE Usually the default plot size is good enough, you can
  use this function to change it if it gets too high really
  fast.

  NOTE BY USING THIS FUNCTION IT WILL DELETE ALL OF THE OLD PLOTS.
*)
result:=max_plots;
if newsize=-1then exit;
max_plots:=newsize;
plots.Clear;
end;

exports plotData,startGraph,showGraph,graphSize;
begin
end.
