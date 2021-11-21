program winuno;

uses
  Forms,
  winunomanager in 'winunomanager.pas' {WinUnoMan},
  custboard in 'custboard.pas' {WinUnoCustom},
  winunomanserial in 'winunomanserial.pas' {WinUnoSerial};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TWinUnoMan, WinUnoMan);
  Application.CreateForm(TWinUnoCustom, WinUnoCustom);
  Application.Run;
end.
