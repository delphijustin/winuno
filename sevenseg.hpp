// Borland C++ Builder
// Copyright (c) 1995, 1999 by Borland International
// All rights reserved

// (DO NOT EDIT: machine generated header) 'sevenseg.pas' rev: 5.00

#ifndef sevensegHPP
#define sevensegHPP

#pragma delphiheader begin
#pragma option push -w-
#pragma option push -Vx
#include <Menus.hpp>	// Pascal unit
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

namespace Sevenseg
{
//-- type declarations -------------------------------------------------------
class DELPHICLASS TSevenSegment;
class PASCALIMPLEMENTATION TSevenSegment : public Forms::TForm 
{
	typedef Forms::TForm inherited;
	
__published:
	Stdctrls::TLabel* LabelA;
	Stdctrls::TLabel* LabelB;
	Stdctrls::TLabel* LabelC;
	Stdctrls::TLabel* LabelD;
	Stdctrls::TLabel* LabelE;
	Stdctrls::TLabel* LabelF;
	Stdctrls::TLabel* LabelG;
	Stdctrls::TCheckBox* CheckBox1;
	Stdctrls::TLabel* Label1;
	Stdctrls::TEdit* Edit1;
	Extctrls::TTimer* Timer1;
	void __fastcall FormCreate(System::TObject* Sender);
	void __fastcall FormClose(System::TObject* Sender, Forms::TCloseAction &Action);
	void __fastcall Timer1Timer(System::TObject* Sender);
	void __fastcall Edit1Change(System::TObject* Sender);
	
public:
	Classes::TStringList* segmentpins;
public:
	#pragma option push -w-inl
	/* TCustomForm.Create */ inline __fastcall virtual TSevenSegment(Classes::TComponent* AOwner) : Forms::TForm(
		AOwner) { }
	#pragma option pop
	#pragma option push -w-inl
	/* TCustomForm.CreateNew */ inline __fastcall virtual TSevenSegment(Classes::TComponent* AOwner, int 
		Dummy) : Forms::TForm(AOwner, Dummy) { }
	#pragma option pop
	#pragma option push -w-inl
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TSevenSegment(void) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TWinControl.CreateParented */ inline __fastcall TSevenSegment(HWND ParentWindow) : Forms::TForm(
		ParentWindow) { }
	#pragma option pop
	
};


//-- var, const, procedure ---------------------------------------------------
extern PACKAGE Byte common_logic[2];
extern PACKAGE int segDisplayCount;

}	/* namespace Sevenseg */
#if !defined(NO_IMPLICIT_NAMESPACE_USE)
using namespace Sevenseg;
#endif
#pragma option pop	// -w-
#pragma option pop	// -Vx

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// sevenseg
