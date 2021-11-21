// Borland C++ Builder
// Copyright (c) 1995, 1999 by Borland International
// All rights reserved

// (DO NOT EDIT: machine generated header) 'winuno.pas' rev: 5.00

#ifndef winunoHPP
#define winunoHPP

#pragma delphiheader begin
#pragma option push -w-
#pragma option push -Vx
#include <HPCounter.hpp>	// Pascal unit
#include <Math.hpp>	// Pascal unit
#include <StdCtrls.hpp>	// Pascal unit
#include <Dialogs.hpp>	// Pascal unit
#include <Forms.hpp>	// Pascal unit
#include <ShellAPI.hpp>	// Pascal unit
#include <Controls.hpp>	// Pascal unit
#include <ComCtrls.hpp>	// Pascal unit
#include <Menus.hpp>	// Pascal unit
#include <Classes.hpp>	// Pascal unit
#include <SysUtils.hpp>	// Pascal unit
#include <Messages.hpp>	// Pascal unit
#include <Windows.hpp>	// Pascal unit
#include <SysInit.hpp>	// Pascal unit
#include <System.hpp>	// Pascal unit

//-- user supplied -----------------------------------------------------------

namespace Winuno
{
//-- type declarations -------------------------------------------------------
typedef AnsiString winuno__1[2];

class DELPHICLASS EshiftIn;
class PASCALIMPLEMENTATION EshiftIn : public Sysutils::Exception 
{
	typedef Sysutils::Exception inherited;
	
public:
	#pragma option push -w-inl
	/* Exception.Create */ inline __fastcall EshiftIn(const AnsiString Msg) : Sysutils::Exception(Msg) { }
		
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateFmt */ inline __fastcall EshiftIn(const AnsiString Msg, const System::TVarRec * 
		Args, const int Args_Size) : Sysutils::Exception(Msg, Args, Args_Size) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateRes */ inline __fastcall EshiftIn(int Ident)/* overload */ : Sysutils::Exception(
		Ident) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResFmt */ inline __fastcall EshiftIn(int Ident, const System::TVarRec * Args, const 
		int Args_Size)/* overload */ : Sysutils::Exception(Ident, Args, Args_Size) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateHelp */ inline __fastcall EshiftIn(const AnsiString Msg, int AHelpContext) : Sysutils::Exception(
		Msg, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateFmtHelp */ inline __fastcall EshiftIn(const AnsiString Msg, const System::TVarRec 
		* Args, const int Args_Size, int AHelpContext) : Sysutils::Exception(Msg, Args, Args_Size, AHelpContext
		) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResHelp */ inline __fastcall EshiftIn(int Ident, int AHelpContext)/* overload */
		 : Sysutils::Exception(Ident, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResFmtHelp */ inline __fastcall EshiftIn(System::PResStringRec ResStringRec, const 
		System::TVarRec * Args, const int Args_Size, int AHelpContext)/* overload */ : Sysutils::Exception(
		ResStringRec, Args, Args_Size, AHelpContext) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~EshiftIn(void) { }
	#pragma option pop
	
};


#pragma option push -b-
enum TArduinoBase { DEC, BIN, HEX, OCT };
#pragma option pop

typedef short Arduino16;

struct TPlotInfo
{
	System::TDateTime Time;
	Extended analog;
} ;

typedef void __stdcall (*TPlotData)(TPlotInfo &data);

#pragma option push -b-
enum LookaheadMode { lookahead_default, SKIP_ALL, SKIP_NONE, SKIP_WHITESPACE };
#pragma option pop

struct TADCInfo
{
	Word Base;
	int Pin;
	unsigned Resolution;
} ;

class DELPHICLASS edrivererror;
class PASCALIMPLEMENTATION edrivererror : public Sysutils::Exception 
{
	typedef Sysutils::Exception inherited;
	
public:
	#pragma option push -w-inl
	/* Exception.Create */ inline __fastcall edrivererror(const AnsiString Msg) : Sysutils::Exception(Msg
		) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateFmt */ inline __fastcall edrivererror(const AnsiString Msg, const System::TVarRec 
		* Args, const int Args_Size) : Sysutils::Exception(Msg, Args, Args_Size) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateRes */ inline __fastcall edrivererror(int Ident)/* overload */ : Sysutils::Exception(
		Ident) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResFmt */ inline __fastcall edrivererror(int Ident, const System::TVarRec * Args
		, const int Args_Size)/* overload */ : Sysutils::Exception(Ident, Args, Args_Size) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateHelp */ inline __fastcall edrivererror(const AnsiString Msg, int AHelpContext) : 
		Sysutils::Exception(Msg, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateFmtHelp */ inline __fastcall edrivererror(const AnsiString Msg, const System::TVarRec 
		* Args, const int Args_Size, int AHelpContext) : Sysutils::Exception(Msg, Args, Args_Size, AHelpContext
		) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResHelp */ inline __fastcall edrivererror(int Ident, int AHelpContext)/* overload */
		 : Sysutils::Exception(Ident, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResFmtHelp */ inline __fastcall edrivererror(System::PResStringRec ResStringRec, 
		const System::TVarRec * Args, const int Args_Size, int AHelpContext)/* overload */ : Sysutils::Exception(
		ResStringRec, Args, Args_Size, AHelpContext) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~edrivererror(void) { }
	#pragma option pop
	
};


typedef TADCInfo *PADCInfo;

class DELPHICLASS ELibraryNotLoaded;
class PASCALIMPLEMENTATION ELibraryNotLoaded : public Sysutils::Exception 
{
	typedef Sysutils::Exception inherited;
	
public:
	#pragma option push -w-inl
	/* Exception.Create */ inline __fastcall ELibraryNotLoaded(const AnsiString Msg) : Sysutils::Exception(
		Msg) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateFmt */ inline __fastcall ELibraryNotLoaded(const AnsiString Msg, const System::TVarRec 
		* Args, const int Args_Size) : Sysutils::Exception(Msg, Args, Args_Size) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateRes */ inline __fastcall ELibraryNotLoaded(int Ident)/* overload */ : Sysutils::Exception(
		Ident) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResFmt */ inline __fastcall ELibraryNotLoaded(int Ident, const System::TVarRec * 
		Args, const int Args_Size)/* overload */ : Sysutils::Exception(Ident, Args, Args_Size) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateHelp */ inline __fastcall ELibraryNotLoaded(const AnsiString Msg, int AHelpContext
		) : Sysutils::Exception(Msg, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateFmtHelp */ inline __fastcall ELibraryNotLoaded(const AnsiString Msg, const System::TVarRec 
		* Args, const int Args_Size, int AHelpContext) : Sysutils::Exception(Msg, Args, Args_Size, AHelpContext
		) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResHelp */ inline __fastcall ELibraryNotLoaded(int Ident, int AHelpContext)/* overload */
		 : Sysutils::Exception(Ident, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResFmtHelp */ inline __fastcall ELibraryNotLoaded(System::PResStringRec ResStringRec
		, const System::TVarRec * Args, const int Args_Size, int AHelpContext)/* overload */ : Sysutils::Exception(
		ResStringRec, Args, Args_Size, AHelpContext) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~ELibraryNotLoaded(void) { }
	#pragma option pop
	
};


class DELPHICLASS ESerialPort;
class PASCALIMPLEMENTATION ESerialPort : public Sysutils::Exception 
{
	typedef Sysutils::Exception inherited;
	
public:
	#pragma option push -w-inl
	/* Exception.Create */ inline __fastcall ESerialPort(const AnsiString Msg) : Sysutils::Exception(Msg
		) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateFmt */ inline __fastcall ESerialPort(const AnsiString Msg, const System::TVarRec 
		* Args, const int Args_Size) : Sysutils::Exception(Msg, Args, Args_Size) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateRes */ inline __fastcall ESerialPort(int Ident)/* overload */ : Sysutils::Exception(
		Ident) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResFmt */ inline __fastcall ESerialPort(int Ident, const System::TVarRec * Args, 
		const int Args_Size)/* overload */ : Sysutils::Exception(Ident, Args, Args_Size) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateHelp */ inline __fastcall ESerialPort(const AnsiString Msg, int AHelpContext) : 
		Sysutils::Exception(Msg, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateFmtHelp */ inline __fastcall ESerialPort(const AnsiString Msg, const System::TVarRec 
		* Args, const int Args_Size, int AHelpContext) : Sysutils::Exception(Msg, Args, Args_Size, AHelpContext
		) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResHelp */ inline __fastcall ESerialPort(int Ident, int AHelpContext)/* overload */
		 : Sysutils::Exception(Ident, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResFmtHelp */ inline __fastcall ESerialPort(System::PResStringRec ResStringRec, 
		const System::TVarRec * Args, const int Args_Size, int AHelpContext)/* overload */ : Sysutils::Exception(
		ResStringRec, Args, Args_Size, AHelpContext) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~ESerialPort(void) { }
	#pragma option pop
	
};


class DELPHICLASS EUnsupported;
class PASCALIMPLEMENTATION EUnsupported : public Sysutils::Exception 
{
	typedef Sysutils::Exception inherited;
	
public:
	#pragma option push -w-inl
	/* Exception.Create */ inline __fastcall EUnsupported(const AnsiString Msg) : Sysutils::Exception(Msg
		) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateFmt */ inline __fastcall EUnsupported(const AnsiString Msg, const System::TVarRec 
		* Args, const int Args_Size) : Sysutils::Exception(Msg, Args, Args_Size) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateRes */ inline __fastcall EUnsupported(int Ident)/* overload */ : Sysutils::Exception(
		Ident) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResFmt */ inline __fastcall EUnsupported(int Ident, const System::TVarRec * Args
		, const int Args_Size)/* overload */ : Sysutils::Exception(Ident, Args, Args_Size) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateHelp */ inline __fastcall EUnsupported(const AnsiString Msg, int AHelpContext) : 
		Sysutils::Exception(Msg, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateFmtHelp */ inline __fastcall EUnsupported(const AnsiString Msg, const System::TVarRec 
		* Args, const int Args_Size, int AHelpContext) : Sysutils::Exception(Msg, Args, Args_Size, AHelpContext
		) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResHelp */ inline __fastcall EUnsupported(int Ident, int AHelpContext)/* overload */
		 : Sysutils::Exception(Ident, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResFmtHelp */ inline __fastcall EUnsupported(System::PResStringRec ResStringRec, 
		const System::TVarRec * Args, const int Args_Size, int AHelpContext)/* overload */ : Sysutils::Exception(
		ResStringRec, Args, Args_Size, AHelpContext) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~EUnsupported(void) { }
	#pragma option pop
	
};


class DELPHICLASS EArduinoModel;
class PASCALIMPLEMENTATION EArduinoModel : public Sysutils::Exception 
{
	typedef Sysutils::Exception inherited;
	
public:
	#pragma option push -w-inl
	/* Exception.Create */ inline __fastcall EArduinoModel(const AnsiString Msg) : Sysutils::Exception(
		Msg) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateFmt */ inline __fastcall EArduinoModel(const AnsiString Msg, const System::TVarRec 
		* Args, const int Args_Size) : Sysutils::Exception(Msg, Args, Args_Size) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateRes */ inline __fastcall EArduinoModel(int Ident)/* overload */ : Sysutils::Exception(
		Ident) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResFmt */ inline __fastcall EArduinoModel(int Ident, const System::TVarRec * Args
		, const int Args_Size)/* overload */ : Sysutils::Exception(Ident, Args, Args_Size) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateHelp */ inline __fastcall EArduinoModel(const AnsiString Msg, int AHelpContext) : 
		Sysutils::Exception(Msg, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateFmtHelp */ inline __fastcall EArduinoModel(const AnsiString Msg, const System::TVarRec 
		* Args, const int Args_Size, int AHelpContext) : Sysutils::Exception(Msg, Args, Args_Size, AHelpContext
		) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResHelp */ inline __fastcall EArduinoModel(int Ident, int AHelpContext)/* overload */
		 : Sysutils::Exception(Ident, AHelpContext) { }
	#pragma option pop
	#pragma option push -w-inl
	/* Exception.CreateResFmtHelp */ inline __fastcall EArduinoModel(System::PResStringRec ResStringRec
		, const System::TVarRec * Args, const int Args_Size, int AHelpContext)/* overload */ : Sysutils::Exception(
		ResStringRec, Args, Args_Size, AHelpContext) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~EArduinoModel(void) { }
	#pragma option pop
	
};


typedef Word __stdcall (*TInp32)(Word Port);

typedef void __stdcall (*TOut32)(Word Port, Word Data);

class DELPHICLASS TWinUnoWND;
class PASCALIMPLEMENTATION TWinUnoWND : public Forms::TForm 
{
	typedef Forms::TForm inherited;
	
__published:
	Stdctrls::TMemo* Memo1;
	Menus::TMainMenu* MainMenu1;
	Menus::TMenuItem* Arduino1;
	Menus::TMenuItem* PauseResume1;
	Menus::TMenuItem* Exit1;
	Menus::TMenuItem* Start1;
	Menus::TMenuItem* Stop1;
	Menus::TMenuItem* Reset1;
	Menus::TMenuItem* DisableInterrupts1;
	Menus::TMenuItem* Help1;
	Menus::TMenuItem* About1;
	Menus::TMenuItem* Options1;
	Menus::TMenuItem* ADCResolution1;
	Menus::TMenuItem* PWMResolution1;
	Menus::TMenuItem* ADCVoltage1;
	Menus::TMenuItem* HardReset1;
	Menus::TMenuItem* AutoRefresh1;
	Menus::TMenuItem* ToggleSwitches1;
	Menus::TMenuItem* Switch01;
	Menus::TMenuItem* Switch11;
	Menus::TMenuItem* Switch21;
	Menus::TMenuItem* Switch31;
	Menus::TMenuItem* Switch41;
	Menus::TMenuItem* Switch51;
	Menus::TMenuItem* Switch61;
	Menus::TMenuItem* Switch71;
	Menus::TMenuItem* Switch81;
	Menus::TMenuItem* Switch91;
	Menus::TMenuItem* Switch101;
	Menus::TMenuItem* Switch111;
	Menus::TMenuItem* Analog1;
	Menus::TMenuItem* A01;
	Menus::TMenuItem* A011;
	Menus::TMenuItem* A21;
	Menus::TMenuItem* A31;
	Menus::TMenuItem* A41;
	Menus::TMenuItem* A51;
	Menus::TMenuItem* A61;
	Menus::TMenuItem* A71;
	Menus::TMenuItem* A81;
	Menus::TMenuItem* A91;
	Menus::TMenuItem* A101;
	Menus::TMenuItem* A111;
	Menus::TMenuItem* A121;
	Menus::TMenuItem* A131;
	Menus::TMenuItem* A141;
	Comctrls::TStatusBar* StatusBar1;
	Menus::TMenuItem* RandomNoise1;
	Menus::TMenuItem* UpdateDelay1;
	Menus::TMenuItem* Start2;
	Menus::TMenuItem* Drivers1;
	Menus::TMenuItem* InpOut1;
	Menus::TMenuItem* StartReading1;
	Menus::TMenuItem* StartWriting1;
	Menus::TMenuItem* WinAPISerial1;
	Menus::TMenuItem* ChoosePort1;
	Menus::TMenuItem* Inputs1;
	Menus::TMenuItem* SetCTSPin1;
	Menus::TMenuItem* SetDSRPin1;
	Menus::TMenuItem* SetRINGPin1;
	Menus::TMenuItem* Outputs1;
	Menus::TMenuItem* SetRTSPin1;
	Menus::TMenuItem* SetDTRPin1;
	Menus::TMenuItem* EnableTX1;
	Menus::TMenuItem* Serial11;
	Menus::TMenuItem* Serial21;
	Menus::TMenuItem* Serial31;
	Menus::TMenuItem* SetRLSDPin1;
	Menus::TMenuItem* DriverDelay1;
	Menus::TMenuItem* StartADC1;
	Menus::TMenuItem* WinUnoOnTheWeb1;
	Menus::TMenuItem* SerialPlotter1;
	Menus::TMenuItem* Tools1;
	Menus::TMenuItem* N7SegmentDisplay1;
	Menus::TMenuItem* Potentiometer1;
	Menus::TMenuItem* Setcenterpin1;
	Menus::TMenuItem* Setpercentage1;
	Menus::TMenuItem* Up1;
	Menus::TMenuItem* Down1;
	Menus::TMenuItem* R11;
	Menus::TMenuItem* R21;
	Menus::TMenuItem* Properties1;
	Menus::TMenuItem* SetMaximumResistance1;
	Menus::TMenuItem* MultiMeter1;
	Menus::TMenuItem* MomentaryButtons1;
	Menus::TMenuItem* Pin21;
	Menus::TMenuItem* Pin31;
	Menus::TMenuItem* Pin41;
	Menus::TMenuItem* Pin51;
	Menus::TMenuItem* Pin61;
	Menus::TMenuItem* Pin71;
	Menus::TMenuItem* Pin81;
	Menus::TMenuItem* Pin91;
	Menus::TMenuItem* Pin101;
	Menus::TMenuItem* Pin111;
	Menus::TMenuItem* Pin121;
	Menus::TMenuItem* Pin131;
	void __fastcall FormCreate(System::TObject* Sender);
	void __fastcall PauseResume1Click(System::TObject* Sender);
	void __fastcall Reset1Click(System::TObject* Sender);
	void __fastcall Start1Click(System::TObject* Sender);
	void __fastcall Stop1Click(System::TObject* Sender);
	void __fastcall DisableInterrupts1Click(System::TObject* Sender);
	void __fastcall About1Click(System::TObject* Sender);
	void __fastcall ADCResolution1Click(System::TObject* Sender);
	void __fastcall PWMResolution1Click(System::TObject* Sender);
	void __fastcall ADCVoltage1Click(System::TObject* Sender);
	void __fastcall FormClose(System::TObject* Sender, Forms::TCloseAction &Action);
	void __fastcall HardReset1Click(System::TObject* Sender);
	void __fastcall Memo1Change(System::TObject* Sender);
	void __fastcall Exit1Click(System::TObject* Sender);
	void __fastcall AutoRefresh1Click(System::TObject* Sender);
	void __fastcall Switch111Click(System::TObject* Sender);
	void __fastcall A01Click(System::TObject* Sender);
	void __fastcall UpdateDelay1Click(System::TObject* Sender);
	void __fastcall Start2Click(System::TObject* Sender);
	void __fastcall ChoosePort1Click(System::TObject* Sender);
	void __fastcall Serial11Click(System::TObject* Sender);
	void __fastcall SetCTSPin1Click(System::TObject* Sender);
	void __fastcall DriverDelay1Click(System::TObject* Sender);
	void __fastcall StartReading1Click(System::TObject* Sender);
	void __fastcall StartADC1Click(System::TObject* Sender);
	void __fastcall WinUnoOnTheWeb1Click(System::TObject* Sender);
	void __fastcall SerialPlotter1Click(System::TObject* Sender);
	void __fastcall N7SegmentDisplay1Click(System::TObject* Sender);
	void __fastcall Setcenterpin1Click(System::TObject* Sender);
	void __fastcall Setpercentage1Click(System::TObject* Sender);
	void __fastcall Up1Click(System::TObject* Sender);
	void __fastcall Down1Click(System::TObject* Sender);
	void __fastcall R11Click(System::TObject* Sender);
	void __fastcall R21Click(System::TObject* Sender);
	void __fastcall Properties1Click(System::TObject* Sender);
	void __fastcall SetMaximumResistance1Click(System::TObject* Sender);
	void __fastcall MultiMeter1Click(System::TObject* Sender);
	void __fastcall Pin21Click(System::TObject* Sender);
public:
	#pragma option push -w-inl
	/* TCustomForm.Create */ inline __fastcall virtual TWinUnoWND(Classes::TComponent* AOwner) : Forms::TForm(
		AOwner) { }
	#pragma option pop
	#pragma option push -w-inl
	/* TCustomForm.CreateNew */ inline __fastcall virtual TWinUnoWND(Classes::TComponent* AOwner, int Dummy
		) : Forms::TForm(AOwner, Dummy) { }
	#pragma option pop
	#pragma option push -w-inl
	/* TCustomForm.Destroy */ inline __fastcall virtual ~TWinUnoWND(void) { }
	#pragma option pop
	
public:
	#pragma option push -w-inl
	/* TWinControl.CreateParented */ inline __fastcall TWinUnoWND(HWND ParentWindow) : Forms::TForm(ParentWindow
		) { }
	#pragma option pop
	
};


typedef BOOL __stdcall (*TIsInpOutDriverOpen)(void);

typedef unsigned TArduinoLibs[1];

class DELPHICLASS TIOHardware;
class PASCALIMPLEMENTATION TIOHardware : public System::TObject 
{
	typedef System::TObject inherited;
	
private:
	HKEY hk;
	void __fastcall setVal(AnsiString x, unsigned y);
	unsigned __fastcall getval(AnsiString X);
	AnsiString __fastcall getText();
	void __fastcall setText(AnsiString S);
	
public:
	__fastcall TIOHardware(void);
	__property HKEY Key = {read=hk, nodefault};
	__property AnsiString Text = {read=getText, write=setText};
	__property unsigned Values[AnsiString name] = {read=getval, write=setVal};
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TIOHardware(void) { }
	#pragma option pop
	
};


typedef AnsiString EmuString;

class DELPHICLASS TEEPROM;
class PASCALIMPLEMENTATION TEEPROM : public System::TObject 
{
	typedef System::TObject inherited;
	
private:
	unsigned Writelife;
	unsigned MaxSize;
	unsigned Handl;
	bool bEnabled;
	int __fastcall DegradeWriteLife(void);
	void __fastcall SetEEByte(unsigned address, Byte value);
	Byte __fastcall GetEEByte(unsigned address);
	
public:
	__property bool Enabled = {read=bEnabled, write=bEnabled, nodefault};
	__property unsigned Handle = {read=Handl, nodefault};
	__property Byte EEPROM[unsigned address] = {read=GetEEByte, write=SetEEByte};
	__fastcall TEEPROM(unsigned Size);
	Byte __fastcall read(unsigned address);
	void __fastcall write(unsigned address, Byte value);
	void __fastcall update(unsigned address, Byte value);
	unsigned __fastcall get(unsigned address, unsigned &variable)/* overload */;
	unsigned __fastcall put(unsigned address, unsigned &variable)/* overload */;
	unsigned __fastcall get(unsigned address, short &variable)/* overload */;
	unsigned __fastcall put(unsigned address, short &variable)/* overload */;
	unsigned __fastcall get(unsigned address, Byte &variable)/* overload */;
	unsigned __fastcall put(unsigned address, Byte &variable)/* overload */;
	unsigned __fastcall get(unsigned address, char &variable)/* overload */;
	unsigned __fastcall put(unsigned address, char &variable)/* overload */;
	unsigned __fastcall get(unsigned address, int &variable)/* overload */;
	unsigned __fastcall put(unsigned address, int &variable)/* overload */;
	unsigned __fastcall get(unsigned address, Word &variable)/* overload */;
	unsigned __fastcall put(unsigned address, Word &variable)/* overload */;
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TEEPROM(void) { }
	#pragma option pop
	
};


class DELPHICLASS TArduinoString;
class PASCALIMPLEMENTATION TArduinoString : public System::TObject 
{
	typedef System::TObject inherited;
	
private:
	char *data;
	AnsiString __fastcall getpchar();
	void __fastcall setpchar(AnsiString Value);
	
public:
	__property AnsiString Text = {read=getpchar, write=setpchar};
	__fastcall TArduinoString(void);
	char __fastcall charAt(unsigned index);
	int __fastcall compareTo(TArduinoString* string2)/* overload */;
	int __fastcall compareTo(AnsiString string2)/* overload */;
	BOOL __fastcall concat(AnsiString parameter)/* overload */;
	BOOL __fastcall concat(unsigned parameter)/* overload */;
	BOOL __fastcall concat(int parameter)/* overload */;
	BOOL __fastcall concat(float parameter)/* overload */;
	BOOL __fastcall concat(TArduinoString* parameter)/* overload */;
	BOOL __fastcall concat(char * parameter)/* overload */;
	char * __fastcall c_str(void);
	BOOL __fastcall endsWith(AnsiString S)/* overload */;
	BOOL __fastcall endsWith(char * S)/* overload */;
	BOOL __fastcall endsWith(TArduinoString* S)/* overload */;
	BOOL __fastcall equals(AnsiString s)/* overload */;
	BOOL __fastcall equals(TArduinoString* s)/* overload */;
	BOOL __fastcall equals(char * s)/* overload */;
	BOOL __fastcall equalsIgnoreCase(AnsiString s)/* overload */;
	BOOL __fastcall equalsIgnoreCase(TArduinoString* s)/* overload */;
	BOOL __fastcall equalsIgnoreCase(char * s)/* overload */;
	void __fastcall getBytes(Byte * buf, const int buf_Size, unsigned len);
	int __fastcall _indexOf(AnsiString S)/* overload */;
	int __fastcall _indexOf(char * S)/* overload */;
	int __fastcall _indexOf(TArduinoString* S)/* overload */;
	int __fastcall lastIndexOf(AnsiString S)/* overload */;
	int __fastcall lastIndexOf(char * S)/* overload */;
	int __fastcall lastIndexOf(TArduinoString* S)/* overload */;
	int __fastcall _indexOf(AnsiString S, int from)/* overload */;
	int __fastcall _indexOf(char * S, int from)/* overload */;
	int __fastcall _indexOf(TArduinoString* S, int from)/* overload */;
	int __fastcall lastIndexOf(AnsiString S, int from)/* overload */;
	int __fastcall lastIndexOf(char * S, int from)/* overload */;
	int __fastcall lastIndexOf(TArduinoString* S, int from)/* overload */;
	int __fastcall length(void);
	void __fastcall remove(int index, int count);
	void __fastcall replace(AnsiString s1, AnsiString s2)/* overload */;
	void __fastcall replace(char * s1, char * s2)/* overload */;
	void __fastcall replace(TArduinoString* s1, TArduinoString* s2)/* overload */;
	void __fastcall reserve(unsigned size);
	void __fastcall setCharAt(unsigned index, char C);
	BOOL __fastcall startsWith(AnsiString S)/* overload */;
	BOOL __fastcall startsWith(TArduinoString* S)/* overload */;
	BOOL __fastcall startsWith(char * S)/* overload */;
	AnsiString __fastcall subString(int from)/* overload */;
	AnsiString __fastcall subString(int from, int nTo)/* overload */;
	TArduinoString* __fastcall subObjString(int from)/* overload */;
	TArduinoString* __fastcall subObjString(int from, int nTo)/* overload */;
	void __fastcall toCharArray(char * buf, const int buf_Size, int len)/* overload */;
	void __fastcall toCharArray(char * buf, int len)/* overload */;
	double __fastcall toDouble(void);
	int __fastcall toInt(void);
	float __fastcall toFloat(void);
	void __fastcall toLowerCase(void);
	void __fastcall toUpperCase(void);
	void __fastcall trim(void);
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TArduinoString(void) { }
	#pragma option pop
	
};


struct TInpOutInfo
{
	Word Address;
	Classes::TStringList* Pins;
	bool direction;
} ;

typedef TInpOutInfo *PInpOutInfo;

typedef int __stdcall (*TExternalRandom)(int Max);

typedef unsigned TSerialConfig;

typedef int __stdcall (*TGraphSize)(int newSize);

class DELPHICLASS TSerial;
class PASCALIMPLEMENTATION TSerial : public System::TObject 
{
	typedef System::TObject inherited;
	
private:
	bool Activated;
	Byte PortNumber;
	int mstimeout;
	
public:
	AnsiString serialBuffer;
	__property Byte Port = {read=PortNumber, nodefault};
	__property bool Active = {read=Activated, write=Activated, nodefault};
	__property int Timeout = {read=mstimeout, nodefault};
	__fastcall TSerial(Byte Port);
	unsigned __fastcall available(void);
	unsigned __fastcall availableForWrite(void);
	void __fastcall _begin(unsigned speed)/* overload */;
	void __fastcall _begin(unsigned speed, unsigned config)/* overload */;
	void __fastcall _end(void);
	BOOL __fastcall find(char * target, int len)/* overload */;
	BOOL __fastcall find(char * target)/* overload */;
	BOOL __fastcall findUntil(char * target, char * terminal);
	void __fastcall flush(void);
	float __fastcall parseFloat(LookaheadMode lookahead, char ignore);
	int __fastcall parseInt(LookaheadMode lookahead, char ignore);
	int __fastcall peek(void);
	unsigned __fastcall print(AnsiString text)/* overload */;
	unsigned __fastcall println(AnsiString text)/* overload */;
	unsigned __fastcall print(float X, int decimals)/* overload */;
	unsigned __fastcall println(float X, int decimals)/* overload */;
	unsigned __fastcall print(float X)/* overload */;
	unsigned __fastcall println(float X)/* overload */;
	unsigned __fastcall print(TArduinoString* s)/* overload */;
	unsigned __fastcall println(TArduinoString* s)/* overload */;
	unsigned __fastcall print(int x, TArduinoBase base)/* overload */;
	unsigned __fastcall println(int x, TArduinoBase base)/* overload */;
	unsigned __fastcall println(void)/* overload */;
	int __fastcall read(void);
	unsigned __fastcall readBytes(void *buffer, int len);
	unsigned __fastcall readBytesUntil(char character, void *buffer, int len);
	AnsiString __fastcall readString();
	AnsiString __fastcall readStringUntil(char terminator);
	void __fastcall setTimeout(int milliseconds);
	unsigned __fastcall write(void * buf, unsigned len)/* overload */;
	unsigned __fastcall write(Byte val)/* overload */;
	unsigned __fastcall write(AnsiString str)/* overload */;
public:
	#pragma option push -w-inl
	/* TObject.Destroy */ inline __fastcall virtual ~TSerial(void) { }
	#pragma option pop
	
};


#pragma option push -b-
enum TIOSerialBit { logicDTR, logicRTS, logicDSR, logicCTS, logicRING, logicRLSD };
#pragma option pop

typedef Set<TIOSerialBit, logicDTR, logicRLSD>  TIOSerialBits;

#pragma pack(push, 1)
struct TIOSerial
{
	unsigned Thread;
	Byte Pin;
	unsigned id;
} ;
#pragma pack(pop)

#pragma pack(push, 1)
struct TMatrixpins
{
	Byte Anode;
	Byte Cathode;
} ;
#pragma pack(pop)

typedef TMatrixpins TMatrixPinSet[8][8];

struct TMatrixInfo
{
	TMatrixpins PinSet[8][8];
	_SHELLEXECUTEINFOA Exec;
} ;

typedef TMatrixInfo *PMatrixInfo;

#pragma option push -b-
enum winuno__31 { arduinoOn };
#pragma option pop

typedef Set<winuno__31, arduinoOn, arduinoOn>  TArduinoFlags;

#pragma pack(push, 1)
struct TArduinoBoot
{
	Sysutils::TProcedure Setup;
	Sysutils::TProcedure Loop;
	Sysutils::TProcedure serialEvent;
	Sysutils::TProcedure serialEvent1;
	Sysutils::TProcedure serialEvent2;
	Sysutils::TProcedure serialEvent3;
	TArduinoFlags Flags;
} ;
#pragma pack(pop)

#pragma pack(push, 1)
struct TArduinoInterrupt
{
	int mode;
	Sysutils::TProcedure callback;
	unsigned Handle;
	unsigned ID;
	unsigned Count;
	bool Active;
} ;
#pragma pack(pop)

struct TArduinoSpecs
{
	float VDefault;
	float internal;
	float vexternal;
	float ar_internal;
	unsigned EEPROMSize;
	unsigned SRAM;
	unsigned PWMPins;
	int hardwareSS;
	Byte cbDigital;
	Byte cbAnalog;
	Byte microsResolution;
} ;

typedef Byte uint8_t;

typedef Word uint16_t;

typedef unsigned uint32_t;

typedef TArduinoInterrupt TInterrupts[32];

//-- var, const, procedure ---------------------------------------------------
static const Shortint INPUT = 0x1;
static const Shortint INPUT_PULLUP = 0x2;
static const Shortint OUTPUT = 0x0;
static const Shortint HIGH = 0x1;
static const Shortint LOW = 0x0;
static const Shortint PIN_NOMODE = 0x3;
static const Shortint SERIAL_5N1 = 0x17;
static const Shortint SERIAL_6N1 = 0x16;
static const Shortint SERIAL_7N1 = 0x15;
static const Shortint SERIAL_8N1 = 0x0;
static const Shortint SERIAL_5N2 = 0x1;
static const Shortint SERIAL_6N2 = 0x2;
static const Shortint SERIAL_7N2 = 0x3;
static const Shortint SERIAL_8N2 = 0x4;
static const Shortint SERIAL_5E1 = 0x5;
static const Shortint SERIAL_6E1 = 0x6;
static const Shortint SERIAL_7E1 = 0x7;
static const Shortint SERIAL_8E1 = 0x8;
static const Shortint SERIAL_5E2 = 0x9;
static const Shortint SERIAL_6E2 = 0xa;
static const Shortint SERIAL_7E2 = 0xb;
static const Shortint SERIAL_8E2 = 0xc;
static const Shortint SERIAL_5O1 = 0xd;
static const Shortint SERIAL_6O1 = 0xe;
static const Shortint SERIAL_7O1 = 0xf;
static const Shortint SERIAL_8O1 = 0x10;
static const Shortint SERIAL_5O2 = 0x11;
static const Shortint SERIAL_6O2 = 0x12;
static const Shortint SERIAL_7O2 = 0x13;
static const Shortint SERIAL_8O2 = 0x14;
static const Shortint A0 = 0xffffffff;
static const Shortint A1 = 0xfffffffe;
static const Shortint A2 = 0xfffffffd;
static const Shortint A3 = 0xfffffffc;
static const Shortint A4 = 0xfffffffb;
static const Shortint A5 = 0xfffffffa;
static const Shortint A6 = 0xfffffff9;
static const Shortint A7 = 0xfffffff8;
static const Shortint A8 = 0xfffffff7;
static const Shortint A9 = 0xfffffff6;
static const Shortint A10 = 0xfffffff5;
static const Shortint A11 = 0xfffffff4;
static const Shortint A12 = 0xfffffff3;
static const Shortint A13 = 0xfffffff2;
static const Shortint A14 = 0xfffffff1;
#define INTERNAL1V1  (1.100000E+00)
#define INTERNAL2V56  (2.560000E+00)
#define AR_INTERNAL1V0  (1.000000E+00)
#define AR_INTERNAL1V65  (1.650000E+00)
#define AR_INTERNAL2V23  (2.230000E+00)
static const Shortint VDEFAULT = 0xffffffff;
static const Shortint INTERNAL = 0xfffffffc;
static const Shortint VDD = 0x5;
#define INTERNAL0V55  (5.500000E-01)
#define INTERNAL1V5  (1.500000E+00)
#define INTERNAL2V5  (2.500000E+00)
#define INTERNAL4V3  (4.300000E+00)
static const Shortint VEXTERNAL = 0xfffffffd;
#define AR_VDD  (3.300000E+00)
static const Shortint AR_INTERNAL = 0xfffffffe;
#define AR_INTERNAL1V2  (1.200000E+00)
#define AR_INTERNAL2V4  (2.400000E+00)
static const Shortint RISING = 0x2;
static const Shortint FALLING = 0x3;
static const Shortint CHANGE = 0x4;
static const Shortint MSBFIRST = 0x0;
static const Shortint LSBFIRST = 0x1;
static const Shortint LIB_EEPROM_H = 0x1;
#define Switch_pwm " /PWM"
#define switch_ana " /ANA"
#define SWITCH_DIG " /DIG"
#define SWITCH_RAM " /RAM"
extern PACKAGE AnsiString ControlChars;
extern PACKAGE AnsiString PuncChars;
extern PACKAGE AnsiString WhiteSpaceChars;
extern PACKAGE AnsiString SpaceChars;
extern PACKAGE AnsiString Printable;
extern PACKAGE AnsiString GraphChars;
#define REG_EEPROMLIFE "EEPROMLife"
#define IOChars "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
#define appkey "Software\\Justin\\WinUno"
#define EEPROM_OUT_OF_RANGE "EEPROM.%s(): address %u is out of range"
#define runningsketches "VolatileSketches\\"
#define sketchconfig "NonVolatileSketches\\"
#define SERIAL_IN_Ext ".SerialIn%u"
#define CONTITLEfmt "%s Serial Terminal - %s"
#define Serial_Out_Ext ".SerialOut%d"
static const int MAX_WRITELIFE = 0x186a0;
extern PACKAGE AnsiString BOOL_LED_BUILTIN[2];
#define RegCOMPorts "SYSTEM\\CurrentControlSet\\Control\\COM Name Arbiter\\Devi"\
	"ces"
#define switch_nowarn " /NOWARN"
#define switch_SCREATE " /SCREATE "
#define param_create_always " /SCREATE CREATE_ALWAYS"
#define PARAM_OPEN_ALWAYS " /SCREATE OPEN_ALWAYS"
#define PARAM_OPEN_EXISTING " /SCREATE OPEN_EXISTING"
#define PARAM_CREATE_NEW " /SCREATE CREATE_NEW"
#define PARAM_TRUNCATE_EXISTING " /SCREATE TRUNCATE_EXISTING"
#define DigitalPin "Digital%d"
#define switch_inp " /INP$"
#define switch_out " /OUT$"
#define InvalidResistance "Invalid Resistance Entered"
#define AnalogPin "Analog%d"
#define PinModeName "pinMode%d"
#define extadc_title "External ADC"
#define analogname "ANALOG"
#define DIGITALNAME "DIGITAL"
#define SWITCH_NOAUTO " /NOAUTO"
#define NoModeMsg "%s(): The pin %d has been read/written to without pinMode("\
	")"
#define numeric "0123456789"
#define alpha "ABCDEFGHIJKMNOPQRSTUVWXYZ"
#define plotdll "serialplot.dll"
#define floatchars "-.0123456789"
#define intchars "-0123456789"
#define appname "WinUno"
static const Shortint CONSOLE_DEFAULT_ATTRIB = 0x7;
extern PACKAGE Classes::TStringList* strings;
extern PACKAGE TWinUnoWND* WinUnoWND;
extern PACKAGE TEEPROM* EEPROM;
extern PACKAGE Windows::HINST hinpout32;
extern PACKAGE TInp32 Inp32;
extern PACKAGE TOut32 Out32;
extern PACKAGE TGraphSize GraphSize;
extern PACKAGE TIsInpOutDriverOpen IsInpOutDriverOpen;
extern PACKAGE unsigned RIOThread;
extern PACKAGE unsigned WIOThread;
extern PACKAGE float VRef;
extern PACKAGE int lastTonePin;
extern PACKAGE Extended potResistance;
extern PACKAGE Extended potPercentage;
extern PACKAGE Extended potR1;
extern PACKAGE Extended potR2;
extern PACKAGE Byte potCenter;
extern PACKAGE unsigned ADCRes;
extern PACKAGE unsigned PWMRes;
extern PACKAGE unsigned LibrariesUsed[1];
extern PACKAGE TIOSerialBits currentSerialBits;
extern PACKAGE TArduinoInterrupt Interruptsarray[32];
extern PACKAGE unsigned HArduino;
extern PACKAGE bool bInterrupts;
extern PACKAGE unsigned htone;
extern PACKAGE TIOSerial ioserials[6];
extern PACKAGE float IORef;
extern PACKAGE Hpcounter::THPCounter* counter;
extern PACKAGE unsigned IODelay;
extern PACKAGE TIOHardware* IOList;
extern PACKAGE unsigned noiseDelay;
extern PACKAGE unsigned SerialPortOut[4];
extern PACKAGE unsigned comport;
extern PACKAGE Menus::TMenuItem* digitalmenus[12];
extern PACKAGE unsigned SerialPortIn[4];
extern PACKAGE TSerial* Serial;
extern PACKAGE TSerial* Serial1;
extern PACKAGE TSerial* Serial2;
extern PACKAGE TSerial* Serial3;
extern PACKAGE unsigned DefAnalogs[15];
extern PACKAGE TArduinoSpecs Specs;
extern PACKAGE TArduinoBoot bootInfo;
extern PACKAGE unsigned startedtime;
extern PACKAGE unsigned microtick;
extern PACKAGE HKEY hkapp;
extern PACKAGE HKEY hkCOMPorts;
extern PACKAGE HKEY hkNVsketch;
extern PACKAGE TExternalRandom ExternalRandom;
extern PACKAGE Sysutils::TProcedure startGraph;
extern PACKAGE TPlotData plotData;
extern PACKAGE int LED_BUILTIN;
extern PACKAGE AnsiString sketch_name;
extern PACKAGE void __fastcall debugLine(int line);
extern PACKAGE AnsiString __fastcall _STR(int X, TArduinoBase base)/* overload */;
extern PACKAGE TArduinoString* __fastcall _STR(unsigned x)/* overload */;
extern PACKAGE TArduinoString* __fastcall _STR(float x, int decimals)/* overload */;
extern PACKAGE AnsiString __fastcall _STR(double x)/* overload */;
extern PACKAGE AnsiString __fastcall _STR(int x)/* overload */;
extern PACKAGE TArduinoString* __fastcall _STR(AnsiString S)/* overload */;
extern PACKAGE void __fastcall bitSet(Word &x, int n)/* overload */;
extern PACKAGE void __fastcall bitSet(short &x, int n)/* overload */;
extern PACKAGE void __fastcall bitSet(int &x, int n)/* overload */;
extern PACKAGE void __fastcall bitSet(unsigned &x, int n)/* overload */;
extern PACKAGE int __fastcall random(int y)/* overload */;
extern PACKAGE void __fastcall tone(int pin, int freq)/* overload */;
extern PACKAGE void __fastcall interrupts(void);
extern PACKAGE void __fastcall noInterrupts(void);
extern PACKAGE BOOL __fastcall isUpperCase(char c);
extern PACKAGE BOOL __fastcall isWhitespace(char c);
extern PACKAGE Byte __fastcall lowByte(Word x);
extern PACKAGE BOOL __fastcall isSpace(char C);
extern PACKAGE BOOL __fastcall isPunct(char C);
extern PACKAGE Byte __fastcall highByte(Word x);
extern PACKAGE BOOL __fastcall isLowerCase(char c);
extern PACKAGE BOOL __fastcall isPrintable(char C);
extern PACKAGE BOOL __fastcall isHexadecimalDigit(char c);
extern PACKAGE BOOL __fastcall isDigit(char c);
extern PACKAGE float __fastcall tan(float x);
extern PACKAGE void __fastcall detachInterrupt(int nInterrupt);
extern PACKAGE BOOL __fastcall isAlpha(char c);
extern PACKAGE BOOL __fastcall isAlphaNumeric(char c);
extern PACKAGE BOOL __fastcall isAscii(char c);
extern PACKAGE BOOL __fastcall isControl(char c);
extern PACKAGE float __fastcall sin(float x);
extern PACKAGE float __fastcall cos(float x);
extern PACKAGE BOOL __fastcall isGraph(char c);
extern PACKAGE float __fastcall min(float x, float y)/* overload */;
extern PACKAGE float __fastcall sq(float x);
extern PACKAGE float __fastcall sqrt(float x);
extern PACKAGE int __fastcall min(int x, int y)/* overload */;
extern PACKAGE int __fastcall max(int x, int y)/* overload */;
extern PACKAGE float __fastcall pow(float x, float y);
extern PACKAGE float __fastcall max(float x, float y)/* overload */;
extern PACKAGE void __fastcall attachInterrupt(int nInterrupt, void * ISR, int mode);
extern PACKAGE void __fastcall analogWriteResolution(unsigned PWMRef);
extern PACKAGE void __fastcall delay(unsigned milliseconds);
extern PACKAGE void __fastcall shiftOut(int dataPin, int clockPin, int bitOrder, Byte value);
extern PACKAGE Byte __fastcall shiftIn(int dataPin, int clockPin, int bitOrder);
extern PACKAGE void __fastcall analogReadResolution(int bits);
extern PACKAGE unsigned __fastcall pulseInLong(int pin, int value, unsigned timeout)/* overload */;
extern PACKAGE unsigned __fastcall pulseIn(int pin, int value, unsigned timeout)/* overload */;
extern PACKAGE unsigned __fastcall pulseInLong(int pin, int value)/* overload */;
extern PACKAGE unsigned __fastcall pulseIn(int pin, int value)/* overload */;
extern PACKAGE void __fastcall analogReference(float aref);
extern PACKAGE int __fastcall digitalPinToInterrupt(int pin);
extern PACKAGE void __fastcall delayMicroseconds(unsigned useconds);
extern PACKAGE int __fastcall random(int x, int y)/* overload */;
extern PACKAGE int __fastcall bit(int n);
extern PACKAGE int __fastcall bitRead(int x, int n);
extern PACKAGE void __fastcall bitWrite(Byte &x, int n, int b)/* overload */;
extern PACKAGE void __fastcall bitWrite(short &x, int n, int b)/* overload */;
extern PACKAGE void __fastcall bitWrite(Word &x, int n, int b)/* overload */;
extern PACKAGE void __fastcall bitWrite(unsigned &x, int n, int b)/* overload */;
extern PACKAGE void __fastcall bitWrite(int &x, int n, int b)/* overload */;
extern PACKAGE void __fastcall bitSet(Byte &x, int n)/* overload */;
extern PACKAGE int __fastcall bitClear(int x, int n);
extern PACKAGE void __fastcall randomSeed(int seed);
extern PACKAGE float __fastcall constrain(float x, float a, float b);
extern PACKAGE int __fastcall map(int x, int in_min, int in_max, int out_min, int out_max);
extern PACKAGE AnsiString __fastcall F(AnsiString S);
extern PACKAGE float __fastcall abs(float x);
extern PACKAGE unsigned __fastcall millis(void);
extern PACKAGE unsigned __fastcall micros(void);
extern PACKAGE void __fastcall analogWrite(int pin, int duty);
extern PACKAGE void __fastcall noTone(int pin);
extern PACKAGE void __fastcall tone(int pin, int freq, int duration)/* overload */;
extern PACKAGE int __fastcall ArduinoBoot(void * setup, void * loop, void * serialCB, void * serialCB1
	, void * serialCB2, void * serialCB3, AnsiString sketchname);
extern PACKAGE unsigned __fastcall analogRead(int pin);
extern PACKAGE int __fastcall digitalRead(int pin);
extern PACKAGE void __fastcall digitalWrite(int pin, int value);
extern PACKAGE void __fastcall pinMode(int pin, int mode);
extern PACKAGE float __fastcall adctovoltage(float X);
extern PACKAGE unsigned __stdcall InpOutThread(PInpOutInfo info);

}	/* namespace Winuno */
#if !defined(NO_IMPLICIT_NAMESPACE_USE)
using namespace Winuno;
#endif
#pragma option pop	// -w-
#pragma option pop	// -Vx

#pragma delphiheader end.
//-- end unit ----------------------------------------------------------------
#endif	// winuno
