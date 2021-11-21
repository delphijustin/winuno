library unodll;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  SysUtils,
  windows,
  forms,
  Classes,
  unodll1 in 'unodll1.pas' {shiftInController};

procedure shiftInputA(hw:hwnd;inst:hinst;lpParams:PAnsichar;nshow:integer);stdcall;
begin
shiftinparams:=tstringlist.Create;
shiftinparams.commatext:=strpas(lpParams);
application.createhandle;
application.initialize;
Application.CreateForm(Tshiftincontroller, shiftincontroller);
  application.run;
shiftinparams.free;
exitprocess(256);
end;
exports shiftInputA;
begin
end.
