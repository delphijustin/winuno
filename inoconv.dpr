program inoconv;
{$RESOURCE INOCONV32.RES}
{$APPTYPE CONSOLE}

uses
  SysUtils,
  windows,
  shellapi,
  Classes;

type
EComments=class(exception);
ENoCppBuilder=class(exception);
ECopyExe=class(exception);
EMakeFailed=class(exception);
ERunSketch=class(exception);
const
inoconv_log='inoconv.log';
headerwin='.hwin';
SWITCH_RUN=' /RUN';
defaultpath='\\VBOXSVR\Documents\winuno32';//The path where i created the files
ID_BEGIN='//BEGIN ARDUINO CODE';
SWITCH_NOMAKE=' /NOMAKE';
ID_END='//END ARDUINO CODE';
ID_SKETCH='//Filename';
LIBS0_USED='LIBS0_USED';
SWITCH_ALLSTRUCTS=' /ALLSTRUCTS';
alpha='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
switch_32bit=' /32BIT';

var syntaxlist,source,dest,defsource,makefile,compilelog:tstringlist;
I:integer;
ec:dword=0;
rs,Libs0:dword;
shellexe:shellexecuteinfo;
shortmake,shortdir,cbuilderv,make_exe:array[0..max_path]of char;
cbuilderkey,cbuildervkey:hkey;

function Included(headerf:string):integer;
begin
Result:=ord(source.indexof('#include <'+headerf+'>')>-1)or ord(source.indexof(
'#include "'+headerf+'"')>-1);
end;

function ReplaceSyntax(index:integer;isCppOut:boolean):string;
var i:integer;
code:ansistring;
begin
code:=source[index];
if pos(' /Q',uppercase(getcommandline))=0then
result:=stringreplace(code,#39,'"',[rfreplaceall]);
if iscppout and(pos(' /DEBUG',UPPERCASE(GETCOMMANDLINE))>0)then
result:=stringreplace(result,'{',format('{debugLine(%d);',[index]),[rfreplaceall]);
if iscppout and(pos(switch_allstructs,uppercase(getcommandline))>0)then
for i:=1to length(alpha)do
result:=stringreplace(result,alpha[i]+'.',alpha[i]+'->',[rfreplaceall]);
for i:=0to syntaxlist.Count-1do
if iscppout then result:=stringreplace(result,syntaxlist.Names[i],
syntaxlist.Values[syntaxlist.Names[i]],[rfreplaceall])else
result:=stringreplace(result,syntaxlist.values[syntaxlist.names[i]],
syntaxlist.names[i],[rfreplaceall]);
if pos(' /STRING',UPPERCASE(GETCOMMANDLINE))>0Then result:=stringreplace(result,
'TArduinoString*','AnsiString',[rfreplaceall]);
end;

procedure LoadCBuilder;
begin
if pos(SWITCH_NOMAKE,UPPERCASE(GETCOMMANDLINE))>0then
exit;
if regopenkeyex(HKEY_LOCAL_MACHINE,'SOFTWARE\Borland\C++Builder',0,key_read,
cbuilderkey)<>error_success then if regopenkeyex(HKEY_LOCAL_MACHINE,
'SOFTWARE\Embarcadero\BDS',0,key_read,cbuilderkey)<>error_success then raise
ENoCppBuilder.create('Borland C++ Builder not installed');
if regenumkey(cbuilderkey,0,cbuilderv,max_path)<>error_success then
raise ENoCppBuilder.Create(
'No version of Borland C++ Builder found in the registry');
if regopenkeyex(cbuilderkey,cbuilderv,0,key_read,cbuildervkey)<>error_success
then raise ENoCppBuilder.Createfmt('Failed to use version %s',[cbuilderv]);
rs:=sizeof(make_exe);regqueryvalueex(cbuildervkey,'RootDir',nil,nil,@make_Exe,
@rs);strcat(make_exe,'\Bin\make.exe');
end;

function ExtractArduino:TStringlist;
var i:integer;
begin
result:=tstringlist.Create;
for i:=source.IndexOf(id_begin)+1 to source.IndexOf(id_end)-1do
result.Add(replacesyntax(i,false));
result.Text:=stringreplace(result.text,'read_STR(','readString(',[rfreplaceall]);
end;
begin
source:=tstringlist.Create;
defsource:=tstringlist.Create;
dest:=tstringlist.Create;
makefile:=tstringlist.Create;
syntaxlist:=tstringlist.Create;
try
syntaxlist.LoadFromFile('syntax-list');
defsource.LoadFromFile('InoUnit.ch');
if comparetext('.h',extractfileext(paramstr(1)))=0then
defsource.LoadFromFile('inoheader.ch');
if(comparetext('.ino',extractfileext(paramstr(1)))=0)or(comparetext('.h',
extractfileext(paramstr(1)))=0)then begin
loadcbuilder;
source.LoadFromFile(paramstr(1));
if pos('void serialEvent(',source.text)=0then defsource.Text:=stringreplace(
defsource.text,',serialEvent,',',/* serialEvent */ NULL,',[]);
if pos('void serialEvent1(',source.text)=0then defsource.Text:=stringreplace(
defsource.text,',serialEvent1,',',/* serialEvent1 */ NULL,',[]);
if pos('void serialEvent2(',source.text)=0then defsource.Text:=stringreplace(
defsource.text,',serialEvent2,',',/* serialEvent2 */ NULL,',[]);
if pos('void serialEvent3(',source.text)=0then defsource.Text:=stringreplace(
defsource.text,',serialEvent3,',',/* serialEvent3 */ NULL,',[]);
if pos(switch_32bit,uppercase(getcommandline))=0then
source.Text:=stringreplace(source.Text,'int ','Arduino16 ',[rfreplaceall]);
libs0:=included('EEPROM.h');
defsource.Text:=stringreplace(defsource.Text,'LIBS0_USED',format('%u',[libs0]),
[rfreplaceall]);
for i:=0to source.Count-1do
source[i]:=replacesyntax(i,true);
dest.Text:=stringreplace(defsource.text,'//ARDUINO_CODE_HERE',source.text,[]);
dest.Text:=stringreplace(dest.text,'$SKETCH$',extractfilename(paramstr(1)),[
rfReplaceall]);
if comparetext('.h',extractfileext(paramstr(1)))=0then begin
dest.SaveToFile(changefileext(paramstr(1),headerwin));
writeln('Converted header to ',changefileext(paramstr(1),headerwin));
exitprocess(0);
end;
dest.SaveToFile('InoUnit.cpp');
zeromemory(@shellexe,sizeof(shellexe));
makefile.LoadFromFile('WinUnoEmu.mak');
getshortpathname(pchar(getcurrentdir),shortdir,max_path);
makefile.Text:=stringreplace(makefile.text,defaultpath,shortdir,[rfreplaceall,
rfignorecase]);
makefile.SaveToFile('inounit.mak');
shellexe.cbSize:=sizeof(shellexe);
shellexe.fMask:=SEE_MASK_NOCLOSEPROCESS or SEE_MASK_FLAG_NO_UI;
shellexe.lpFile:=stralloc(max_path);
expandenvironmentstrings('%ComSpec%',shellexe.lpfile,max_path);
getshortpathname(make_exe,shortmake,max_path);
shellexe.lpParameters:=strpcopy(stralloc(512),'/C '+strpas(shortmake)+
' -finounit.mak>inoconv.log');
shellexe.nShow:=sw_hide;
if pos(SWITCH_NOMAKE,UPPERCASE(GETCOMMANDLINE))>0THEN begin
writeln(syserrormessage(0));exitprocess(0);
end;
writeln('Compiling...');
if not shellexecuteex(@shellexe)then raise EMakeFailed.CreateFmt(
'Failed to execute %s: %s %d',[make_exe,syserrormessage(getlasterror),
getlasterror]);
waitforsingleobject(shellexe.hprocess,infinite);
getexitcodeprocess(shellexe.hprocess,ec);
closehandle(shellexe.hprocess);
compilelog:=tstringlist.Create;
if fileexists(inoconv_log)then compilelog.LoadFromFile(inoconv_log);
writeln(compilelog.text);
if ec>0then raise EMakeFailed.CreateFmt('Compiling failed(%d)',[ec]);
strpcopy(shellexe.lpfile,changefileext(paramstr(1),'.exe'));
if not copyfile('winunoemu.exe',pchar(changefileext(paramstr(1),'.exe')),false)
then raise ECopyExe.Create(
syserrormessage(getlasterror));
writeln('Created ',changefileext(paramstr(1),'.exe'));
if pos(switch_run,uppercase(getcommandline))>0then
begin
strpcopy(shellexe.lpparameters,copy(strpas(getcommandline),pos(SWITCH_RUN,
uppercase(getcommandline))+length(SWITCH_RUN)+1,512));
writeln('Run: ',shellexe.lpfile,#32,shellexe.lpparameters);
shellexe.nShow:=sw_show;
if not shellexecuteex(@shellexe)then raise ERunSketch.Create(syserrormessage(
getlasterror));
ec:=maxdword;
waitforsingleobject(shellexe.hprocess,INFINITE);
getexitcodeprocess(shellexe.hprocess,ec);
closehandle(shellexe.hprocess);
end;
end else if(comparetext(paramstr(1),'InoUnit.cpp')=0)or(comparetext(headerwin,
extractfileext(paramstr(1)))=0)then begin
source.LoadFromFile(paramstr(1));
if(source.IndexOf(id_begin)=-1)or(source.indexof(id_end)=-1)or(
source.indexofname(id_sketch)=-1)then
raise EComments.Create('One or more important comments are missing');
source.Text:=stringreplace(source.text,'Arduino16','int',[rfreplaceall]);
dest.addstrings(extractarduino);
dest.SaveToFile(source.values[id_sketch]);
writeln(syserrormessage(0));
end else begin
writeln('WinUno C Converter v1.0 By Justin Roeder');
writeln('Usage: ',extractfilename(paramstr(0)),' <source-file> [/allstructs] [/32BIT] [/NOMAKE] [/DEBUG] [/STRING] [/Q] [/RUN [ExeParams]]');
writeln('Parameters:');
writeln('<source-file>      Source file to convert, a file ending with .ino or .h extension for arduino code if its a C++ Builder code then the filename must be InoUnit.cpp if it is a .h file it will be converted to .hwin file');
writeln('/allstructs        Trys to convert all structures to the correct type, this may interfere with the orginal code');
writeln('/32BIT             Uses 32-bit integers for int type instead of 16-bit int type. This parameter is used only on converting from an .ino file, InoUnit.cpp works without this switch');
writeln('/NOMAKE            Don'#39't use make.exe after converting to inounit.cpp');
writeln('/Q                 Don'#39't try to change single quotes to double quotes.');
writeln('/DEBUG             Makes the executable able to use its own debugger. If the sketch defines any structures the compile will fail. Debug lets you see the last line that had a "{" symbol NOTE /DEBUG MAKES IT WHERE YOU CAN'#39'T CONVERT BACK');
writeln('/STRING            Uses generic string type instead of string objects');
writeln('/RUN               Opens the executable after compiling. This should be the last parameter used.');
write('Press enter to quit...');
readln;
exitprocess(0);
end;
except on e:exception do begin writeln(e.classname,': ',e.message);sleep(10000);
ec:=maxint;
 end; end;
If cbuilderkey<>0then regclosekey(cbuilderkey);
If cbuildervkey<>0then regclosekey(cbuildervkey);
exitprocess(ec);
end.
