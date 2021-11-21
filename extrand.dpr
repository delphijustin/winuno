library extrand;
(*
  This file allows a seperate random seed for random noise
*)
uses
  windows;
function ExternalRandom(max:integer):integer;stdcall;
begin
randomize;
result:=random(max);
end;
exports ExternalRandom;
begin
end.
 