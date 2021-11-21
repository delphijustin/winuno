// Borland C++ Builder
// Copyright (c) 1995, 1999 by Borland International
// All rights reserved

// (DO NOT EDIT: machine generated header) 'HPCounter.pas' rev: 5.00

#ifndef HPCounterHPP
#define HPCounterHPP

#pragma delphiheader begin
#pragma option push -w-
#pragma option push -Vx
#include <ExtCtrls.hpp>	// Pascal unit
#include <StdCtrls.hpp>	// Pascal unit
#include <Dialogs.hpp>	// Pascal unit
#include <Forms.hpp>	// Pascal unit
#include <Controls.hpp>	// Pascal unit
#include <Graphics.hpp>	// Pascal unit
#include <Classes.hpp>	// Pascal unit
#include <Messages.hpp>	// Pascal unit
#include <Windows.hpp>	// Pascal unit
#include <SysUtils.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Hpcounter
{
//-- type declarations -------------------------------------------------------
typedef __int64 TInt64;

class DELPHICLASS THPCounter;
class PASCALIMPLEMENTATION THPCounter : public Classes::TComponent 
{
	typedef Classes::TComponent inherited;
	
private:
	__int64 Frequency;
	__int64 lpPerformanceCount1;
	__int64 lpPerformanceCount2;
	AnsiString FCopyright;
	void __fastcall SetCop(AnsiString Value);
	
public:
	__fastcall virtual THPCounter(Classes::TComponent* AOwner);
	__fastcall virtual ~THPCounter(void);
	void __fastcall Start(void);
	AnsiString __fastcall Read();
	__int64 __fastcall ReadInt(void);
	
__published:
	__property AnsiString Copyright = {read=FCopyright, write=SetCop};
};


//-- var, const, procedure ---------------------------------------------------
extern PACKAGE void __fastcall Register(void);

}	/* namespace Hpcounter */
#if !defined(NO_IMPLICIT_NAMESPACE_USE)
using namespace Hpcounter;
#endif
#pragma option pop	// -w-
#pragma option pop	// -Vx

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// HPCounter
