
 -------------------------------------
 * TEasyGraph 1.92 * by Vit Kovalcik *
 -------------------------------------
      released 10 Feb 2003


This component can draw graph which displays series of points
and/or functions defined with complicated mathematical formulas.
You can use mouse to zoom or pan with view.

TEasyGraph works with Delphi 3, 4, 5 and 6 and it is freeware.
(But any donations are welcomed. ;-)

I used great and fast (and free) component TParser version 10.1
for evaluating formulas, but I modified it for better work
with this component. If you want to use it separately, please
use original TParser, which is included in this archive, because
my modifications made it slightly incompatible with another
versions. (It is possible to have both parsers - modified
TMDParser and original TParser - installed in Delphi at the
same time)


And of course if you find some bug or if you have a question,
e-mail me.


My e-mail address is :  vit.kovalcik@volny.cz

WWW : http://www.fi.muni.cz/~xkovalc
(or after several years : http://www.geocities.com/vkovalcik/ )


Installation
------------

Experienced programmers can skip this section. There are not
any unusual steps.

This is way to install this or any other component as I do it.
The installation procedure is not hard. The descrition is for
Delphi 6, but it is very similar in previous versions.
First thing I want to say is that components are "grouped"
in packages. Packages can be simply created or modified.
For example, I have one "main" package, where I put my
or others' components, which I use. If you want to install
new component, do the following:
1) Unpack archive into some directory
2) Go to menu - Components / Install Component.
3) If you already created some package, stay on "Into existing
   package" tab and select it in "Package file name" combo box.
   If this is the first component, you are installing, go to "Into
   new package" tab and create new package by entering
   "Package file name" (with full path) and "Package description".
4) "Unit file name" must point to the new component. In this case
    "X:\...\EasyGraph.pas" (Some components doesn't come
    with source. In such cases, select "X:\...\NewComponent.dcu")
5) Press OK and Package window will appear.
6) There are several useful buttons. You will have to "Compile"
    package and then "Install" it. If it is already installed,
    the button will be grayed.
7) If everything went correctly, you are done here.



Disclaimer
----------

This component is provided as is and without warranties or guaranties
of any kind. Any loss or damage resulting from the use of the software
is not the responsibility of the author.


History
-------
1.92 - added description of installation procedure
     - (simple) function domain can be defined: Points[X].FuncDomX1 - Points[X].FuncDomX2
     - corrected setting OnYLabeling event (thanks to Neil Reid - and also thanks to him
       for his generous donation :-) )
     - add note to labelling - user have to generate whole string, he can't modify it
     - added function TSeries.Clear
1.90 - Align property is now published (by Serge Astaf'ev)
     - fixed setting background color #2 (by Serge Astaf'ev)
     - changed default background colors
       (ColorBg: clSilver -> clBtnFace; ColorBg2: clBlue -> clBtnShadow)
     - fixed drawing background when BgStyle is bgsLineVert or bgsLineHoriz (it worked
       incorrectly in some cases)
     - HintForm didn't use OnXLabeling/OnYLabeling events and still printed numbers
       instead of user-defined strings (by Martin Kozusky)
     - fixed drawing graph of function made with lines (thanks goes to Fabiano Ferreira Nunes)
     - fixed not freeing memory in TSeries.Delete  (and probably in TPoints.Delete too)
       (solved by Jean-François Coupat, big thanks to him)
     - added Quadrant property (requested by Nicolas Paisant)
     - added BeginUpdate and EndUpdate functions (requested by Helmut Strickner)
1.70 - added function GetGraphCoords (by Andriy Nich)
     - fixed setting second color of background (by Andriy Nich)
     - fixed drawing numbers around graph - ColorNumb property wasn't used
       at all (again by Andriy Nich)
     - added TPoints.Caption, changed behaviour of TEGLegendList.UpdateList,
       so Caption is now shown in list, also changed hint behaviour -
       now it shows Caption only if Func string is empty (by Michael Keppler)
     - fixed bug when zooming in by mouse with MaintainRatio = false
       (by Michael Keppler)
     - fixed bad algorithm for drawing horizontal numbers, which could hang
       the program previously (by David Wright)
1.61 - fixed bug in numbers-drawing algorithm (by Michael Keppler)
1.60 - added property TPoints.PointSymbol
     - added property Parser - now it is possible to declare own variables etc.
     - change in function TPoints.Add, that speed it up many times (by Richard Mustakos)
     - changed function DrawGridAndNumbers to be much more reliable (by Richard Mustakos)
1.52 - added TMDParser to archive, I forgot to do it in previous version,
       so TEasyGraph can't be run. Sorry, sorry, sorry, ...
1.51 - changed status to freeware
1.50 - it isn't freeware anymore (sorry)
     - background can be of another style (properties BgStyle, BgImage, ColorBg2)
     - hints about mouse position and nearest series (property MouseFuncHint)
     - added option to hide any of series (TEasyGraph.Series[X].Visible)
     - added legend component (TEGLegendList)
     - graph can be saved to BMP file
     - graph can be copied to clipborad
1.00 - initial version


Note
----

EasyGraph is for displaying CONTINUOUS functions.

It works a little wrong, when series contain NON-continuous
 function and DrawStyle is dsLines.

 For example: log10 (x)
 Should be:              But component draws this:
   ----------------        ----------------
   |              |        |              |
   |              |        |              |
   |      / ------|        |      / ------|
   |      |       |        |      |       |
   |      |       |        |              |
   ----------------        ----------------

 It is more visible when function is: tan(x)
 This should be:         But component draws this:
   ----------------        ----------------
   |    |    |    |        |    ||   ||   |     Because there is only one point (per pi),
   |   /    /     |        |   / |  / |   |     where the function is not defined
   |  /    /     /|        |  /  | /  |  /|     it is highly probable, that it won't
   | /    /     / |        | /   |/   | / |     be found and the graph will be drawn
   | |    |    |  |        | |   ||   ||  |     as the function was consecutive.
   ----------------        ----------------