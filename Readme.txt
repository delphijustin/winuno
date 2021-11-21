First of all this emulator:

is not perfect.
Some of the code may need to be changed
There is no microseconds. All microseconds are milliseconds converted to microseconds.

To use the emulator you will need:
Borland C++ Builder(This may only be the way to compile it since most of the code is in Delphi)

Why does delphi code work with C++?
Borland C++ Builder allows you to use delphi code in it.

How do I use it.
First you must convert your Arduino Code to C++ Builder code.
To do this you use the inoconv.exe included in this zip file.
With inoconv.exe you can also convert the code you modified in
C++ builder back to Arduino. It will even compile the executable
for your sketch after inoconv is done.

Also inoconv.exe is compiled in Delphi 4

You can open winuno.exe and choose a board you would like to use,
a long with a sketch and it will compile and run it.