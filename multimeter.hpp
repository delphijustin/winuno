// Borland C++ Builder
// Copyright (c) 1995, 1999 by Borland International
// All rights reserved

// (DO NOT EDIT: machine generated header) 'multimeter.pas' rev: 5.00

#ifndef multimeterHPP
#define multimeterHPP

#pragma delphiheader begin
#pragma option push -w-
#pragma option push -Vx
#include <Menus.hpp>	// Pascal unit
#include <Clipbrd.hpp>	// Pascal unit
#include <ExtCtrls.hpp>	// Pascal unit
#include <StdCtrls.hpp>	// Pascal unit
#include <Dialogs.hpp>	// Pascal unit
#include <Forms.hpp>	// Pascal unit
#include <Controls.hpp>	// Pascal unit
#include <Graphics.hpp>	// Pascal unit
#include <Classes.hpp>	// Pascal unit
#include <SysUtils.hpp>	// Pascal unit
#include <Messages.hpp>	// Pascal unit
#include <Windows.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Multimeter
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TAMultiMeter;
class PASCALIMPLEMENTATION TAMultiMeter : public Forms::TForm 
{
	typedef Forms::TForm inherited;
	
__published:
	Stdctrls::TMemo* Memo1;
	Extctrls::TTimer* Timer1;
	Menus::TMainMenu* MainMenu1;
	Menus::TMenuItem* Meter1;
	Menus::TMenuItem* CopyVoltage1;
	Menus::TMenuItem* CopyAnalogValue1;
	Menus::TMenuItem* CopyPercentage1;
	Menus::TMenuItem* Exit1;
	Menus::TMenuItem* CopyAll1;
	void __fastcall FormCreate(System::TObject* Sender);
	void __fastcall Timer1Timer(System::TObject* Sender);
	void __fastcall FormClose(System::TObject* Sender, Forms::TCloseAction &Action);
	void __fastcall CopyVoltage1Click(System::TObject* Sender);
	void __fastcall CopyAnalogValue1Click(System::TObject* Sender);
	void __fastcall CopyPercentage1Click(System::TObject* Sender);
	void __fastcall Exit1Click(System::TObject* Sender);
	void __fastcall CopyAll1Click(System::TObject* Sender);
	
private:
	int analog;
	void __fastcall setAnalog(int value);
	
public:
	__property int AnalogInput = {read=analog, write=setAnalog, nodefault};
public:
	#pragma option push -w-inl
	/* TCustomForm.Create */ inline __fastcall virtual TAMultiMeter(Classes::TComponent* AOwner) : Forms::TForm(
		AOwner) { }
	#pragma option pop
	#pragma option push -w-inl
	/* TCustomForm.CreateNew */ inline __fastcall virtual TAMultiMeter(Classes::TComponent* AOwner, int 
		Dummy) : Forms::TForm(AOwner, Dummy) { }
	#pragma option pop
	#pragma option push -w-inl
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TAMultiMeter(void) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TWinControl.CreateParented */ inline __fastcall TAMultiMeter(HWND ParentWindow) : Forms::TForm(ParentWindow
		) { }
	#pragma option pop
	
};


//-- var, const, procedure ---------------------------------------------------
#define TAG_PIN "Pin"
#define TAG_VOLTS "Volts"
#define TAG_PERCENT "Percent"
#define TAG_ADCVALUE "Value"
extern PACKAGE int metercount;

}	/* namespace Multimeter */
#if !defined(NO_IMPLICIT_NAMESPACE_USE)
using namespace Multimeter;
#endif
#pragma option pop	// -w-
#pragma option pop	// -Vx

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// multimeter
