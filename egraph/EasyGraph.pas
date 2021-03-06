unit EasyGraph;
{by Vit Kovalcik}

interface

{$DEFINE Allow_SavetoJPEG_Func}
{Because using unit JPEG cause problems, when you are also using RX Library,
it is possible to turn off saving as JPEG}


uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  MDParser10, Math, StdCtrls, ExtCtrls, ClipBrd
{$IFDEF Allow_SavetoJPEG_Func}
  ,JPEG
{$ENDIF}
  ;

const
  MaxPoints=10000;
  MaxSeries=1000;
  MinVisRectLength=0.01;
    {This component sometimes didn't draw series correctly
     because of too small numbers. This constant defines minimal
     distance between VisRect.X1-VisRect.X2 or VisRect.Y1-VisRect.Y2
     You shouldn't modify this.}
    {Well, 0.000001 works perfectly for grid and mathematical
     formulas, but series with points connected with lines are still
     not drawn correctly}     

  MaxVisRectLength=10000;
    {Maximum distance between VisRect.X1-VisRect.X2 or
     VisRect.Y1-VisRect.Y2}

  {Log10(MaxVisRectLength) and Log10(MinVisRectLength) should/must be
   integral numbers !}

  MinMousePointsMove=3;
    {Minimum number of pixels, which must cursor cover to begin move
     with view}

type
  TDrawStyle=(dsLines,dsPoints);
  TBorderStyle=(bstNone,bstSingle,bstRaised,bstLowered);
  TMouseAction=(maNone,maRight,maShift,maCtrl,maAlt);
    {Action can be zooming or moving view.
     User can zoom IN with mouse, when MouseZoom isn't maNone
     and can zoon OUT by pressing mouse button and key depending
     on following constants:

       maNone - specified action cannot be done
       maRight - action will occur when user presses right
                    mouse button
       maShift - do action when left button with Shift is pressed
       maCtrl - left button + Ctrl
       maAlt - left button + Alt}
  TGridStyle=(gsNone,gsXAxis,gsYAxis,gsAxises,gsXGrid,gsYGrid,gsFull);
  TBgStyle=(bgsSolid,bgsLineHoriz,bgsLineVert,bgsImageStretch,bgsImageTile);
    {bgsLineHoriz means vertical blend between two colors}
  TEGQuadrant=(egqAll, egqFirst, egqSecond, egqThird, egqFourth, egqRight, egqLeft);

  TPoint2D=record
    X,Y:Extended;
  end;
  TPoint2DArray=Array [0..MaxPoints-1] of TPoint2D;
  PPoint2DArray=^TPoint2DArray;

  TRect2D=record
    X1,Y1,X2,Y2:Extended;
  end;

  TPoints=class {Max. = MaxPoints (= 10000)}
  private
    FAllocBy:Integer;
    FOnChange:TNotifyEvent;
    FCount:Integer;
    FColor:TColor;
    FFunc:AnsiString;
    FFuncDomX1, FFuncDomX2:Extended;
    FCaption:String;
    FPoints:PPoint2DArray;
    FPointSymbol:Char;
    FDrawStyle:TDrawStyle;
    FVisible:Boolean;
    XParseFunc:String;
    XAllocatedPoints:Integer;
  protected
    function GetPoints (AIndex:Integer):TPoint2D;
    procedure SetAllocBy (AValue:Integer);
    procedure SetCaption (AValue:String);
    procedure SetColor (AValue:TColor);
    procedure SetDrawStyle (AValue:TDrawStyle);
    procedure SetFunc (AValue:AnsiString);
    procedure SetVisible (AValue:Boolean);
    procedure SetPointSymbol (ASymbol:Char);
    procedure SetFuncDomX1 (AValue:Extended);
    procedure SetFuncDomX2 (AValue:Extended);
  public
    procedure Add (AX,AY:Extended);
    constructor Create;
    destructor Destroy; override;
    procedure Delete (AIndex:Integer);
    procedure Clear;
    property Points[AIndex:Integer]:TPoint2D read GetPoints; default;
  published
    property AllocBy:Integer read FAllocBy write SetAllocBy;
    property Caption:String read FCaption write SetCaption;
    property Color:TColor read FColor write SetColor default clRed;
    property Count:Integer read FCount;
    property DrawStyle:TDrawStyle read FDrawStyle write SetDrawStyle default dsLines;
    property Func:AnsiString read FFunc write SetFunc;
    property FuncDomX1:Extended read FFuncDomX1 write SetFuncDomX1;
    property FuncDomX2:Extended read FFuncDomX2 write SetFuncDomX2; 
    property OnChange:TNotifyEvent read FOnChange write FOnChange;
    property PointSymbol:Char read FPointSymbol write SetPointSymbol;
      { #0 = don't use this}
    property Visible:Boolean read FVisible write SetVisible;
  end;
  TPointsArr=Array [0..MaxSeries-1] of TPoints;
  PPointsArr=^TPointsArr;

  TSeries=class {Max. = MaxSeries (= 1000)}
  private
    FCount:Integer;
    FOnChange:TNotifyEvent;
    FSeries:PPointsArr;
    XNeedUpdate:Boolean;
    XUpdateCounter:Integer;
  protected
    function GetSeries (AIndex:Integer):TPoints;
    procedure PointsChange (Sender:TObject);
  public
    procedure Add;
    procedure BeginUpdate;
    constructor Create;
    procedure Delete (AIndex:Integer);
    procedure Clear;
    destructor Destroy; override;
    procedure EndUpdate;
    property Series[AIndex:Integer]:TPoints read GetSeries; default;
  published
    property Count:Integer read FCount;
    property OnChange:TNotifyEvent read FOnChange write FOnChange;
  end;

  TEasyGraph = class;

  TZoomThread=class(TThread)
  private
    Graph:TEasyGraph;
    ToRect:TRect2D;
    NowRect:TRect2D;
    ZoomTime,TimeToDraw:Integer;
  public
    constructor Create (AGraph:TEasyGraph;ANowRect,AToRect:TRect2D;AZoomTime,ATimeToDraw:Integer);
    procedure Execute; override;
    procedure DrawGraph;
  end;

  TEGHintForm = class (TCustomForm)
  private
    XColor:TColor;
    XFunction,XX,XY:String;
    XBitmap:TBitmap;
    XDisplaySeries:Boolean;
  protected
    procedure Render;
    procedure Paint; override;
    procedure CreateParams(var Params: TCreateParams); override;
  public
    constructor Create (AOwner:TComponent); override;
    destructor Destroy; override;
  end;

  TEGLegendList = class;

  TEGLabelingEvent = procedure (Sender:TObject; Val:Extended; var Lbl:String) of object;

  TEasyGraph = class(TGraphicControl)
  private
    FAspectRatio:Extended; {X/Y}
    FBgImage:String;
    FBgStyle:TBgStyle;
    FBorderStyle:TBorderStyle;
    FGraphBorder:TBorderStyle;
    FColorBg:TColor;
    FColorBg2:TColor;
    FColorGrid:TColor;
    FColorAxis:TColor;
    FColorBorder:TColor;
    FColorNumb:TColor;
    FSeries:TSeries;
    FGridStyle:TGridStyle;
    FMaintainRatio:Boolean;
    FNumbHoriz:Boolean;
    FNumbVert:Boolean;
    FOnChange:TNotifyEvent;
    FOnVisChange:TNotifyEvent;
    FOnXLabeling:TEGLabelingEvent;
    FOnYLabeling:TEGLabelingEvent;
    FQuadrant:TEGQuadrant;
    FZoomTime:Integer;
    FMouseZoom:TMouseAction;
    FMousePan:TMouseAction;
    FMouseFuncHint:TMouseAction;
    FVisRect:TRect2D;
    XLegend:TEGLegendList;
    XTempBmp:TBitmap;
    XBgBmp:TBitmap;
    XRenderNeed:Boolean;
    XBgRedraw:Boolean;
    XGraphRect:TRect;
    XMouseAction:Byte;
      {0..no action
       1..zooming out
       2..moving (can be set together with zooming out)
       4..zooming in
       8..showing function hint}
    XMousePos:TPoint;
    XMousePointsMove:Integer;
    XLastZoomR:TRect;
    XLastBPP:Integer;
    XZoomThread:TZoomThread;
    XTimeToDraw:Integer; {in ms, time to draw last frame}
    XParser:TMDParser;
    XHintForm:TEGHintForm;
    XWnd:HWnd;
    XUpdateCounter:Integer;
  protected
    procedure MyWndProc (var Message:TMessage);
    procedure SetAspectRatio (AValue:Extended);
    procedure SetBgImage (AValue:String);
    procedure SetBgStyle (AValue:TBgStyle);
    procedure SetBorderStyle (AValue:TBorderStyle);
    procedure SetGridStyle (AValue:TGridStyle);
    procedure SetSeries (AValue:TSeries);
    procedure SetVisRect (AValue:TRect2D);
    procedure SetColorAxis (AValue:TColor);
    procedure SetColorBg (AValue:TColor);
    procedure SetColorBg2 (AValue:TColor);
    procedure SetColorGrid (AValue:TColor);
    procedure SetColorBorder (AValue:TColor);
    procedure SetColorNumb (AValue:TColor);
    procedure SetGraphBorder (AValue:TBorderStyle);
    procedure SetNumbHoriz (AValue:Boolean);
    procedure SetNumbVert (AValue:Boolean);
    procedure SetOnXLabeling (AValue:TEGLabelingEvent);
    procedure SetOnYLabeling (AValue:TEGLabelingEvent);
    procedure SetQuadrant (AValue:TEGQuadrant);
    procedure PointsChanged (Sender:TObject);
    procedure Render  (ACanvas:TCanvas);
    procedure Paint; override;
    procedure SeriesChange (Sender:TObject);
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure LineRect (X1,Y1,X2,Y2:Integer);
    procedure GraphZoom;
    procedure AdjustZoom (var R:TRect2D);
    procedure CalculateHint;
  public
    constructor Create (AOwner:TComponent);override;
    destructor Destroy; override;
    property Series:TSeries read FSeries write SetSeries;
    property Parser:TMDParser read XParser;
    property Bitmap:TBitmap read xtempbmp;
    property VisRect:TRect2D read FVisRect write SetVisRect;
    procedure SaveAsBmp (FileName:String);
{$IFDEF Allow_SavetoJPEG_Func}
    procedure SaveAsJpeg (FileName:String);
{$ENDIF}
    procedure SaveAsWMF(Filename:string);
    procedure SaveAsEMF(Filename:string);
    procedure CopyToClipboard;
    function GetGraphCoords (X, Y:Integer; GX, GY:PExtended):Boolean;
      // input: [X,Y] are the pixel coordinates relative to upper left corner of the component
      // output: [GX, GY] are "graph-coordinates" of that point
      //    if the input point is outside of the graph (on numbers around it),
      //    the function will return false and will not retrun proper GX and GY
    procedure BeginUpdate;
      // No Invalidate will be called when points/series are updated
    procedure EndUpdate;
  published
    property Align;
    property AspectRatio:Extended read FAspectRatio write SetAspectRatio;
    property BgImage:String read FBgImage write SetBgImage;
    property BgStyle:TBgStyle read FBgStyle write SetBgStyle default bgsSolid;
    property BorderStyle:TBorderStyle read FBorderStyle write SetBorderStyle default bstNone;
    property ColorAxis:TColor read FColorAxis write SetColorAxis default clBlack;
    property ColorBg:TColor read FColorBg write SetColorBg default clBtnFace;
    property ColorBg2:TColor read FColorBg2 write SetColorBg2 default clBtnShadow;
    property ColorBorder:TColor read FColorBorder write SetColorBorder default clBlack;
    property ColorGrid:TColor read FColorGrid write SetColorGrid default clGray;
    property ColorNumb:TColor read FColorNumb write SetColorNumb default clBlack;
    property GraphBorder:TBorderStyle read FGraphBorder write SetGraphBorder default bstLowered;
    property GridStyle:TGridStyle read FGridStyle write SetGridStyle default gsFull;
    property MaintainRatio:Boolean read FMaintainRatio write FMaintainRatio;
    property MousePan:TMouseAction read FMousePan write FMousePan;
    property MouseZoom:TMouseAction read FMouseZoom write FMouseZoom;
    property MouseFuncHint:TMouseAction read FMouseFuncHint write FMouseFuncHint;
    property NumbHoriz:Boolean read FNumbHoriz write SetNumbHoriz default True;
    property NumbVert:Boolean read FNumbVert write SetNumbVert default True;
    property OnChange:TNotifyEvent read FOnChange write FOnChange;
    property OnClick;
    property OnDblClick;
    property OnMouseDown;
    property OnMouseUp;
    property OnVisChange:TNotifyEvent read FOnVisChange write FOnVisChange;
    property OnXLabeling:TEGLabelingEvent read FOnXLabeling write SetOnXLabeling;
    property OnYLabeling:TEGLabelingEvent read FOnYLabeling write SetOnYLabeling;
    property Quadrant:TEGQuadrant read FQuadrant write SetQuadrant;
    property ZoomTime:Integer read FZoomTime write FZoomTime; {In ms}
  end;

  TEGLegendList = class(TCustomListBox)
  private
    FEasyGraph:TEasyGraph;
    FCheckBoxes:Boolean;
    FOnChange:TNotifyEvent;
  protected
    procedure UpdateList (ASeries:Integer);
    procedure SetEasyGraph (AValue:TEasyGraph);
    procedure SetCheckBoxes (AValue:Boolean);
    procedure WndProc(var Message: TMessage); override;
    procedure DrawItem(Index: Integer; Rect: TRect;
                       State: TOwnerDrawState); override;
  public
    constructor Create (AOwner:TComponent); override;
    destructor Destroy; override;
  published
    property Color;
    property Ctl3D;
    property DragMode;
    property DragCursor;
    property EasyGraph:TEasyGraph read FEasyGraph write SetEasyGraph;
    property Enabled;
    property Font;
    property CheckBoxes:Boolean read FCheckBoxes write SetCheckBoxes;
    property ItemHeight;
    property Items;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Text;
    property Visible;
    property OnChange:TNotifyEvent read FOnChange write FOnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnStartDrag;
  end;

procedure Register;
function Rect2D (x1,y1,x2,y2:Extended):TRect2D;

implementation

function Rect2D (x1,y1,x2,y2:Extended):TRect2D;
begin
  Result.x1:=x1;
  Result.y1:=y1;
  Result.x2:=x2;
  Result.y2:=y2;
end;

{*****************************************}
{*****************************************}
{*               TPoints                 *}
{*****************************************}
{*****************************************}

constructor TPoints.Create;
begin
  FAllocBy:=100;
  FColor:=clRed;
  FCount:=0;
  XAllocatedPoints:=0;
  FPoints:=nil;
  FDrawStyle:=dsLines;
  FVisible:=True;
  FFuncDomX1 := -MaxExtended;
  FFuncDomX2 := MaxExtended;
end;

destructor TPoints.Destroy;
begin
  FreeMem(FPoints);
  inherited Destroy;
end;

procedure TEasyGraph.SaveAsEMF;
var MFile:tmetafile;
MFCanvas:tmetafilecanvas;
begin
  MFile:=TMetaFile.Create;
  MFile.Enhanced:=true;
  MFile.Width:=Width;
  MFile.Height:=Height;
    MFCanvas:=TMetaFileCanvas.CreateWithComment(mfile,0,'WinUno Emulator',
    'Serial Graph');
    try
      Render (MFCanvas);
    finally
      MFCanvas.Free;
    end;
    Mfile.SaveToFile(filename);
    MFile.Free;
end;

procedure TEasyGraph.SaveAsWMF;
var MFile:tmetafile;
MFCanvas:tmetafilecanvas;
begin
  MFile:=TMetaFile.Create;
  MFile.Width:=Width;
  MFile.Height:=Height;
    MFCanvas:=TMetaFileCanvas.CreateWithComment(mfile,0,'WinUno Emulator',
    'Serial Graph');
    try
      Render (MFCanvas);
    finally
      MFCanvas.Free;
    end;
    Mfile.SaveToFile(filename);
    MFile.Free;
end;

procedure TPoints.Add (AX,AY:Extended);
var A,B,C:Integer;

  procedure AllocNextPoint;
  begin
    If XAllocatedPoints<=FCount then
    begin
      Inc (XAllocatedPoints,FAllocBy);
      ReallocMem (FPoints,XAllocatedPoints*SizeOf(TPoint2D));
    end;
  end;

begin
  If (FCount=0) OR (AX>FPoints[FCount-1].X) then
  begin
    AllocNextPoint;
    FPoints[FCount].X:=AX;
    FPoints[FCount].Y:=AY;
    Inc (FCount);
  end
  else
  begin
(*    A:=FCount div 2;
    step := (FCount div 4)+1;
    while(abs(step) > 2)do
    begin
      if(AX>FPoints[A].X) then
      begin
        Inc(A,step);
        step := step div 2;
      end
      else
      begin
        Dec(A,step);
        step := step div 2;
      end;
    end;
    A := A-4;
    if A < 0 then
      A := 0;*)
    A := 0;
    B := FCount - 1;
    while (A < B) do
    begin
      C := (B - A) div 2 + A;
      If (AX > FPoints[C].X) then
        A := C + 1
      else
        B := C;
    end;

    If AX<>FPoints[A].X then
    begin
      AllocNextPoint;
      Move (FPoints[A],FPoints[A+1],(FCount-A)*SizeOf(TPoint2D));
      FPoints[A].X:=AX;
      FPoints[A].Y:=AY;
      Inc (FCount);
    end
    else
      FPoints[A].Y:=AY;
  end;

  If Assigned (FOnChange) then
    FOnChange (Self);
end;

function TPoints.GetPoints (AIndex:Integer):TPoint2D;
begin
  If (AIndex<FCount) AND (AIndex>=0) then
    Result:=FPoints[AIndex]
  else
    raise Exception.Create ('');
end;

procedure TPoints.SetAllocBy (AValue:Integer);
begin
  If (AValue<>FAllocBy) AND (AValue>0) then
    FAllocBy:=AValue;
end;

procedure TPoints.Delete (AIndex:Integer);
begin
  If (AIndex<FCount) AND (AIndex>=0) then
  begin
    If AIndex<FCount-1 then
      Move (FPoints[AIndex+1],FPoints[AIndex],(FCount-AIndex-1)*SizeOf(TPoint2D));
    Dec (FCount);
    If FCount<XAllocatedPoints-FAllocBy*2 then
    begin
      Dec (XAllocatedPoints,FAllocBy);
      If (XAllocatedPoints <= 0) then
      begin
        FreeMem (FPoints);
        FPoints := nil;
      end
      else
        // Theoretically, there is no need to add FreeMem as
        // ReallocMem could do the same thing, but there is
        // probably a bug, for which it doesn't free allocated memory.
        ReallocMem (FPoints,XAllocatedPoints*SizeOf(TPoint2D));
    end;
  end
  else
    raise Exception.Create ('Index is greater than Count!');
  If Assigned (FOnChange) then
    FOnChange (Self);
end;

procedure TPoints.Clear;
begin
  FCount:=0;
  XAllocatedPoints:=0;
  FreeMem (FPoints);
  FPoints := nil;
  If Assigned (FOnChange) then
    FOnChange (Self);
end;

procedure TPoints.SetColor (AValue:TColor);
begin
  If FColor<>AValue then
  begin
    FColor:=AValue;
    If Assigned (FOnChange) then
      FOnChange (Self);
  end;
end;


procedure TPoints.SetCaption (AValue:String);
begin
  If (FCaption <> AValue) then
  begin
    FCaption := AValue;
    If (Assigned (FOnChange)) then
      FOnChange (Self);
  end;
end;


procedure TPoints.SetFunc (AValue:AnsiString);
const AllowedChars=['a'..'z','A'..'Z','0'..'9','.',',','+','-','(',')','^',
         '*','/'];
var A:Integer;
begin
  FFunc:=AValue;
  XParseFunc:='';
  For A:=1 to Length(AValue) do
    If AValue[A] in AllowedChars then
      XParseFunc:=XParseFunc+AValue[A];
  If Assigned (FOnChange) then
    FOnChange (Self);
end;


procedure TPoints.SetDrawStyle (AValue:TDrawStyle);
begin
  If FDrawStyle<>AValue then
  begin
    FDrawStyle:=AValue;
    If Assigned(OnChange) then
      OnChange (Self);
  end;
end;

procedure TPoints.SetVisible (AValue:Boolean);
begin
  If FVisible<>AValue then
  begin
    FVisible:=AValue;
    If Assigned(OnChange) then
      OnChange (Self);
  end;
end;

procedure TPoints.SetPointSymbol (ASymbol:Char);
begin
  FPointSymbol:=ASymbol;
  If Assigned (FOnChange) then
    FOnChange (Self);
end;

procedure TPoints.SetFuncDomX1 (AValue:Extended);
begin
  FFuncDomX1 := AValue;
  If Assigned (FOnChange) then
    FOnChange (Self);
end;

procedure TPoints.SetFuncDomX2 (AValue:Extended);
begin
  FFuncDomX2 := AValue;
  If Assigned (FOnChange) then
    FOnChange (Self);
end;


{*****************************************}
{*****************************************}
{*              TSeries                  *}
{*****************************************}
{*****************************************}

constructor TSeries.Create;
begin
  FCount:=0;
  FSeries:=nil;
  XNeedUpdate:=False;
end;

destructor TSeries.Destroy;
begin
  FreeMem (FSeries);
  inherited Destroy;
end;

function TSeries.GetSeries (AIndex:Integer):TPoints;
begin
  If (AIndex<FCount) AND (AIndex>=0) then
    Result:=FSeries[AIndex]
  else
    raise Exception.Create ('');
end;

procedure TSeries.Add;
begin
  Inc (FCount);
  ReallocMem (FSeries,FCount*SizeOf(TPoints));
  FSeries[FCount-1]:=TPoints.Create;
  FSeries[FCount-1].OnChange:=PointsChange;
  If XUpdateCounter=0 then
  begin
    If Assigned (FOnChange) then
      FOnChange (Self);
  end
  else
    XNeedUpdate:=True;
end;

procedure TSeries.Delete (AIndex:Integer);
begin
  If (AIndex<0) OR (AIndex>=FCount) then
    raise Exception.Create ('');
  FSeries[AIndex].Free;
  If AIndex<FCount-1 then
    Move (FSeries[AIndex+1],FSeries[AIndex],(FCount-AIndex-1)*SizeOf(TPoints));
  Dec (FCount);
  If (FCount = 0) then
  begin
    FreeMem (FSeries);
    FSeries := nil;
  end
  else
    // Theoretically, there is no need to add FreeMem as
    // ReallocMem could do the same thing, but there is
    // probably a bug, for which it doesn't free allocated memory.
    ReallocMem (FSeries,FCount*SizeOf(TPoints));
  If XUpdateCounter=0 then
  begin
    If Assigned (FOnChange) then
      FOnChange (Self);
  end
  else
    XNeedUpdate:=True;
end;

procedure TSeries.Clear;
var A:Integer;
begin
  For A := 0 to FCount - 1 do
    FSeries[A].Free;
  FCount:=0;
  FreeMem (FSeries);
  FSeries := nil;
  If XUpdateCounter=0 then
  begin
    If Assigned (FOnChange) then
      FOnChange (Self);
  end
  else
    XNeedUpdate:=True;
end;

procedure TSeries.PointsChange (Sender:TObject);
begin
  If XUpdateCounter=0 then
  begin
    If Assigned(OnChange) then
      OnChange (Self);
  end
  else
    XNeedUpdate:=True;
end;

procedure TSeries.BeginUpdate;
begin
  Inc (XUpdateCounter);
  XNeedUpdate:=False;
end;

procedure TSeries.EndUpdate;
begin
  If XUpdateCounter>0 then
    Dec (XUpdateCounter);
  If (XUpdateCounter=0) AND (XNeedUpdate) then
  begin
    XNeedUpdate:=False;
    FOnChange (Self);
  end;
end;

{*****************************************}
{*****************************************}
{*             TEGHintForm               *}
{*****************************************}
{*****************************************}

constructor TEGHintForm.Create (AOwner:TComponent);
begin
  inherited CreateNew (AOwner);
  XBitmap:=TBitmap.Create;
  XBitmap.Width:=Width;
  XBitmap.Height:=Height;
end;

destructor TEGHintForm.Destroy;
begin
  XBitmap.Free;
  inherited Destroy;
end;

procedure TEGHintForm.Render;
var R:TRect;
begin
  with XBitmap.Canvas do
  begin
    Brush.Color:=clBtnFace;
    Pen.Color:=clBtnHighlight;
    MoveTo (0,Height-1);
    LineTo (0,0);
    LineTo (Width,0);
    Pen.Color:=clBtnShadow;
    MoveTo (0,Height-1);
    LineTo (Width-1,Height-1);
    LineTo (Width-1,0);
    R.Left:=1;
    R.Top:=1;
    R.Right:=Width-1;
    R.Bottom:=Height-1;
    FillRect (R);
    TextOut (2,2,'X:');
    TextOut (2,17,'Y:');
    TextOut (75-TextWidth(XX),2,XX);
    TextOut (75-textWidth(XY),17,XY);
    if XDisplaySeries=True then
    begin
      R.Top:=31;
      R.Left:=13;
      R.Right:=Width-2;
      R.Bottom:=Height-2;
      TextRect (R,75-TextWidth(XFunction),32,XFunction);
      R.Left:=3;
      R.Right:=11;
      Pen.Color:=clBlack;
      Brush.Color:=XColor;
      Rectangle (R.Left,R.Top,R.Right,R.Bottom);
    end;
  end;
end;

procedure TEGHintForm.Paint;
begin
  Canvas.CopyRect (Canvas.ClipRect,XBitmap.Canvas,Canvas.ClipRect);
end;

procedure TEGHintForm.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams (Params);
  Params.WindowClass.style := Params.WindowClass.style OR CS_SAVEBITS;
end;

{*****************************************}
{*****************************************}
{*             TEasyGraph                *}
{*****************************************}
{*****************************************}

procedure TEasyGraph.MyWndProc (var Message:TMessage);
var P:TPoint;
begin
  case Message.Msg of
    WM_MOUSEMOVE:
      begin
        P:=ClientToScreen (Point(0,0));
        XMousePos:=Point(LOWORD(Message.lParam)-P.X,HIWORD(Message.lParam)-P.Y);
        If not PtInRect (XGraphRect,XMousePos) then
        begin
          XMouseAction:=0;
          XHintForm.Hide;
        end
        else
          CalculateHint;
      end;
    WM_LBUTTONDOWN,
    WM_RBUTTONDOWN,
    WM_MBUTTONDOWN,
    WM_LBUTTONUP,
    WM_RBUTTONUP,
    WM_MBUTTONUP,
    WM_LBUTTONDBLCLK,
    WM_RBUTTONDBLCLK,
    WM_MBUTTONDBLCLK:
      begin
        XMouseAction:=0;
        XHintForm.Hide;
        ReleaseCapture;
        DeallocateHWnd (XWnd);
      end;
  end;
end;


constructor TEasyGraph.Create (AOwner:TComponent);
begin
  inherited Create (AOwner);
  XParser:=TMDParser.Create (Self);
  XLastBPP:=0;
  XZoomThread:=nil;
  XMouseAction:=0;
  FAspectRatio:=1;
  FBgImage:='';
  FBgStyle:=bgsSolid;
  FMaintainRatio:=False;
  FMouseZoom:=maRight;
  FMousePan:=maRight;
  FMouseFuncHint:=maShift;
  FZoomTime:=200;
  FColorAxis:=clBlack;
  FColorBg:=clBtnFace;
  FColorBg2:=clBtnShadow;
  FColorGrid:=clGray;
  FColorBorder:=clBlack;
  FColorNumb:=clBlack;
  FGridStyle:=gsFull;
  FNumbHoriz:=True;
  FNumbVert:=True;
  FOnChange:=nil;
  FOnVisChange:=nil;
  FOnXLabeling:=nil;
  FOnYLabeling:=nil;
  FQuadrant:=egqAll;
  FSeries:=TSeries.Create;
  FSeries.OnChange:=SeriesChange;
  FBorderStyle:=bstNone;
  FGraphBorder:=bstLowered;
  Width:=60;
  Height:=40;
  XRenderNeed:=True;
  XBgRedraw:=True;
  XTempBmp:=nil;
  XBgBmp:=nil;
  XLegend:=nil;
  with FVisRect do
  begin
    X1:=-10;
    X2:=10;
    Y1:=-10;
    Y2:=10;
  end;
  XHintForm:=TEGHintForm.Create (Self);
  XHintForm.Width:=80;
  XHintForm.Height:=50;
  XHintForm.BorderStyle:=bsNone;
  XUpdateCounter := 0;
end;

procedure TEasyGraph.SetAspectRatio (AValue:Extended);
begin
  If (FAspectRatio<>AValue) AND (AValue<>0) then
  begin
    FAspectRatio:=AValue;
    XRenderNeed:=True;
    Invalidate;
    If Assigned (OnChange) then
      OnChange (Self);
  end;
end;

procedure TEasyGraph.SetBgImage (AValue:String);
begin
  If FBgImage<>AValue then
  begin
    FBgImage:=AValue;
    If (FBgStyle=bgsImageStretch) OR (FBgStyle=bgsImageTile) then
    begin
      XRenderNeed:=True;
      XBgRedraw:=True;
      Invalidate;
    end;
    If Assigned (OnChange) then
      OnChange (Self);
  end;
end;

procedure TEasyGraph.SetBgStyle (AValue:TBgStyle);
begin
  If FBgStyle<>AValue then
  begin
    FBgStyle:=AValue;
    XRenderNeed:=True;
    XBgRedraw:=True;    
    Invalidate;
    If Assigned (OnChange) then
      OnChange (Self);
  end;
end;

procedure TEasyGraph.SetBorderStyle (AValue:TBorderStyle);
begin
  If FBorderStyle<>AValue then
  begin
    FBorderStyle:=AValue;
    XRenderNeed:=True;
    Invalidate;
    If Assigned (OnChange) then
      OnChange (Self);
  end;
end;

procedure TEasyGraph.SetSeries (AValue:TSeries);
begin
  If (AValue<>FSeries) AND (AValue<>nil) then
  begin
    FSeries:=AValue;
    XRenderNeed:=True;
    Invalidate;
    If Assigned (OnChange) then
      OnChange (Self);
  end;
end;

procedure TEasyGraph.PointsChanged (Sender:TObject);
begin
  XRenderNeed:=True;
  If (XUpdateCounter = 0) then
    Invalidate;
end;

procedure TEasyGraph.SetVisRect (AValue:TRect2D);
var Z:Extended;
begin
  If (AValue.X1<>AValue.X2) AND (AValue.Y1<>AValue.Y2) then
  begin
    FVisRect:=AValue;
    with FVisRect do
    begin
      If X2<X1 then
      begin
        Z:=X1;
        X1:=X2;
        X2:=Z;
      end;
      If Y2<Y1 then
      begin
        Z:=Y1;
        Y1:=Y2;
        Y2:=Z;
      end;
    end;
    XRenderNeed:=True;
    If Assigned (FOnVisChange) then
      FOnVisChange (Self);
    Paint;
  end;
end;

procedure TEasyGraph.Render (ACanvas:TCanvas);
var R:TRect;
    A,B,C:Integer;
    S, S2:String;
    ParseOK:Boolean;
    DC:HDC;
    XBmp:TBitmap;
    DrawCanvas:TCanvas;
    Rgn:HRgn;
    TempR:TRect;

  procedure DrawLineHoriz;
  var R,G,B,Rx,Bx,Gx:Integer;
      X:Integer;
  begin
    X := ColorToRGB (FColorBg);
    R:=X AND $FF;
    G:=(X SHR 8) AND $FF;
    B:=(X SHR 16) AND $FF;
    X := ColorToRGB (FColorBg2);
    Rx:=(((X AND $FF)-R) shl 20) div Height;
    Gx:=((((X SHR 8) AND $FF)-G) shl 20) div Height;
    Bx:=((((X SHR 16) AND $FF)-B) shl 20) div Height;
    XBgBmp.Canvas.Pen.Style:=psSolid;
    R:=R shl 20;
    G:=G shl 20;
    B:=B shl 20;
    For X:=0 to Height-1 do
    begin
      XBgBmp.Canvas.Pen.Color:=
        (R SHR 20) OR
        ((G SHR 12) AND $FF00) OR
        ((B SHR 4) AND $FF0000);
      XBgBmp.Canvas.MoveTo (0,X);
      XBgBmp.Canvas.Lineto (XBgBmp.Width,X);
      Inc (R,Rx);
      Inc (G,Gx);
      Inc (B,Bx);
    end;
  end;

  procedure DrawLineVert;
  var R,G,B,Rx,Bx,Gx:Integer;
      X:Integer;
  begin
    X := ColorToRGB (FColorBg);
    R:=X AND $FF;
    G:=(X SHR 8) AND $FF;
    B:=(X SHR 16) AND $FF;
    X := ColorToRGB (FColorBg2);
    Rx:=(((X AND $FF)-R) shl 20) div Height;
    Gx:=((((X SHR 8) AND $FF)-G) shl 20) div Height;
    Bx:=((((X SHR 16) AND $FF)-B) shl 20) div Height;
    XBgBmp.Canvas.Pen.Style:=psSolid;
    R:=R shl 20;
    G:=G shl 20;
    B:=B shl 20;
    For X:=0 to Width-1 do
    begin
      XBgBmp.Canvas.Pen.Color:=
        (R SHR 20) OR
        ((G SHR 12) AND $FF00) OR
        ((B SHR 4) AND $FF0000);
      XBgBmp.Canvas.MoveTo (X,0);
      XBgBmp.Canvas.Lineto (X,XBgBmp.Height);
      Inc (R,Rx);
      Inc (G,Gx);
      Inc (B,Bx);
    end;
  end;

  procedure DrawBorder (ABS:TBorderStyle;AClr:TColor);

    procedure DrawUp;
    begin
      with DrawCanvas do
      begin
        MoveTo (R.Left,R.Bottom-1);
        LineTo (R.Left,R.Top);
        LineTo (R.Right+1,R.Top);
      end;
    end;

    procedure DrawDown;
    begin
      with DrawCanvas do
      begin
        MoveTo (R.Left,R.Bottom);
        LineTo (R.Right,R.Bottom);
        LineTo (R.Right,R.Top);
      end;
    end;

  begin
    with DrawCanvas do
    begin
      Pen.Style:=psSolid;
      Case ABS of
        bstSingle:
          begin
            Pen.Color:=AClr;
            Rectangle (R.Left,R.Top,R.Right+1,R.Bottom+1);
          end;
        bstRaised:
          begin
            Pen.Color:=clBtnHighlight;
            DrawUp;
            Pen.Color:=clBtnShadow;
            DrawDown;
          end;
        bstLowered:
          begin
            Pen.Color:=clBtnHighlight;
            DrawDown;
            Pen.Color:=clBtnShadow;
            DrawUp;
          end;
      end;
      If ABS<>bstNone then
        InflateRect (R,-1,-1);
    end;
  end;

  procedure DrawGridAndNumbers;
  var A:Integer;
      B:Integer;
      Re,Re2,Re3:Extended;
      Two:Boolean;
      TR:TRect;
  begin
    with DrawCanvas do
    begin
{Vertical numbers}
      If (FGridStyle<>gsNone) OR
         (FNumbVert) then
      begin
        C:=DrawCanvas.TextHeight ('Xy');
        A:=Round(((XGraphRect.Bottom-XGraphRect.Top)/(FVisRect.Y2-FVisRect.Y1)*MaxVisRectLength)/C);
          {'A' now means maximum number of numbers in range 1..MaxVisRectLength}
          {Don't try to understand it :) }
        Re:=MaxVisRectLength;
        B:=1;
        Two:=True;
        while B<A do
        begin
          If Two then
          begin
            B:=B*2;
            If B<A then
              Re:=Re/2;
          end
          else
          begin
            B:=B*5;
            If B<A then
              Re:=Re/5;
          end;
          Two:=not Two;
        end;
        Re2:=FVisRect.Y1/Re;
        If Re2<=0 then
          Re2:=Trunc (Re2)*Re-Re
        else
          Re2:=Trunc (Re2)*Re+Re;
        Re3:=(XGraphRect.Bottom-XGraphRect.Top)/(FVisRect.Y2-FVisRect.Y1);
        DrawCanvas.Pen.Color:=FColorGrid;
        DrawCanvas.Font.Color:=FColorNumb;
        C:=C div 2;
        TR.Left:=R.Left;
        TR.Top:=R.Top;
        TR.Right:=XGraphRect.Left;
        TR.Bottom:=XGraphRect.Bottom;
        DrawCanvas.Brush.Style:=bsClear;
        while Re2<=FVisRect.Y2 do
          {Warning: Should be probably '=' but then it sometimes does stange things}
        begin
{          A:=Round((Re2-FVisRect.Y1)*Re3);}
          A:=Trunc((Re2-FVisRect.Y1)*Re3);
          If A>=0 then
          begin
            A:=XGraphRect.Bottom-A;
            If (FGridStyle=gsXAxis) OR (FGridStyle=gsAxises) OR
               (FGridStyle=gsXGrid) OR (FGridStyle=gsFull) then
            begin
              If Abs(Re2)<0.00001 then
                {Warning : This depends on MinVisRectLength}
                {...this should be 0, but computer isn't 100% accurate}
              begin
                DrawCanvas.Pen.Color:=FColorAxis;
                DrawCanvas.MoveTo (XGraphRect.Left,A);
                DrawCanvas.LineTo (XGraphRect.Right+1,A);
                DrawCanvas.Pen.Color:=FColorGrid;
              end
              else
              begin
                If (FGridStyle=gsXGrid) OR (FGridStyle=gsFull) then
                begin
                  DrawCanvas.MoveTo (XGraphRect.Left,A);
                  DrawCanvas.LineTo (XGraphRect.Right+1,A);
                end;
              end;
            end;
            If NumbVert then
            begin
              If Assigned(FOnYLabeling) then
              begin
                S := '';
                FOnYLabeling (Self,Re2,S);
              end
              else
                S:=FloatToStrF (Re2,ffFixed,16,Abs(Round(Log10(MinVisRectLength)))+1);
              B:=DrawCanvas.TextWidth (S);
              DrawCanvas.TextRect (TR,XGraphRect.Left-B-3,A-C,S);
            end;
          end;
          Re2:=Re2+Re;
        end;
      end;
{Horizontal numbers}
      If (FGridStyle<>gsNone) OR
         (FNumbHoriz) then
      begin
        If Assigned(FOnXLabeling) then
        begin
          S := '';
          FOnXLabeling (Self,FVisRect.X1,S);
          A:=Length(S);
          S2 := '';
          FOnXLabeling (Self,FVisRect.X2,S2);
          B:=Length(S2);
          If B>A then
          begin
            A:=B;
            S := S2;
          end;
          For B:=1 to A do
            If S[B] in ['0'..'9'] then
              S[B]:='8';
        end
        else
        begin
          S:='';
          If ((FVisRect.X1 < 0.00001) AND (FVisRect.X1 > -0.00001)) then
            A := 5
          else
            A := Round(Abs(log10(Abs(FVisRect.X1))));
          If ((FVisRect.X2 < 0.00001) AND (FVisRect.X2 > -0.00001)) then
            B := 5
          else
            B := Round(Abs(log10(Abs(FVisRect.X2))));
          If B>A then
            A:=B;
          For B:=0 to A do
            S:=S+'8';
          A:=Round(-log10(MinVisRectLength))+1;
          If A>0 then
          begin
            S:=S+',';
            For B:=1 to A do
              S:=S+'8';
          end;
        end;
        If (Length (S) > 0) then
        begin
          C:=DrawCanvas.TextWidth (S);
          A:=Round(((XGraphRect.Right-XGraphRect.Left)/(FVisRect.X2-FVisRect.X1)*MaxVisRectLength)/C);
        end
        else
          A:=10;   
        Re:=MaxVisRectLength;
        B:=1;
        Two:=True;
        while B<A do
        begin
          If Two then
          begin
            B:=B*2;
            If B<A then
              Re:=Re/2;
          end
          else
          begin
            B:=B*5;
            If B<A then
              Re:=Re/5;
          end;
          Two:=not Two;
        end;
        Re2:=FVisRect.X1/Re;
        If Re2<=0 then
          Re2:=Trunc (Re2)*Re-Re
        else
          Re2:=Trunc (Re2)*Re+Re;
        Re3:=(XGraphRect.Right-XGraphRect.Left)/(FVisRect.X2-FVisRect.X1);
        DrawCanvas.Pen.Color:=FColorGrid;
        C:=C div 2;
        TR.Left:=XGraphRect.Left;
        TR.Top:=XGraphRect.Bottom+1;
        TR.Right:=R.Right;
        TR.Bottom:=R.Bottom;
        DrawCanvas.Brush.Style:=bsClear;
        while Re2<=FVisRect.X2 do
          {Warning: Should be probably '=' but then it sometimes does stange things}
        begin
{          A:=Round((Re2-FVisRect.X1)*Re3);}
          A:=Trunc((Re2-FVisRect.X1)*Re3);
          If A>=0 then
          begin
            A:=A+XGraphRect.Left;
            If (FGridStyle=gsYAxis) OR (FGridStyle=gsAxises) OR
               (FGridStyle=gsYGrid) OR (FGridStyle=gsFull) then
            begin
              If Abs(Re2)<0.00001 then
                {Warning : This depends on MinVisRectLength}
                {...this should be 0, but computer isn't 100% accurate}
              begin
                DrawCanvas.Pen.Color:=FColorAxis;
                DrawCanvas.MoveTo (A,XGraphRect.Top);
                DrawCanvas.LineTo (A,XGraphRect.Bottom+1);
                DrawCanvas.Pen.Color:=FColorGrid;
              end
              else
              begin
                If (FGridStyle=gsYGrid) OR (FGridStyle=gsFull) then
                begin
                  DrawCanvas.MoveTo (A,XGraphRect.Top);
                  DrawCanvas.LineTo (A,XGraphRect.Bottom+1);
                end;
              end;
            end;
            If NumbHoriz then
            begin
              If Assigned (FOnXLabeling) then
              begin
                S := '';
                FOnXLabeling (Self,Re2,S);
              end
              else
                S:=FloatToStrF (Re2,ffFixed,16,Abs(Round(Log10(MinVisRectLength)))+1);
              B:=DrawCanvas.TextWidth (S);
              DrawCanvas.TextRect (TR,A-B div 2,XGraphRect.Bottom+4,S);
            end;
          end;
          Re2:=Re2+Re;
        end;
      end;
      R:=XGraphRect;
      InflateRect(R,1,1);
      DrawBorder (FGraphBorder,FColorBorder);
    end;
  end;

  procedure DrawFuncLines (Ind:Integer);
  Var A:Integer;
      RY,Incr:Extended;
      Clr:TColor;
      ZY:Integer;
      PrevDef:Boolean;
         {If the previous value was correctly computed and now is in graph.
          For example: It is not possible to display function ln(x) for x<0.}
      Ext:Extended;
      FuncOK:Boolean;
      TP:Array [0..1] of TPoint;
      MinY, MaxY:Extended;

  begin
    Clr:=FSeries[Ind].Color;
    RY:=(R.Bottom-R.Top)/(FVisRect.Y2-FVisRect.Y1);
    Incr:=(FVisRect.X2-FVisRect.X1)/(R.Right-R.Left);
    MinY:=FVisRect.Y1-Incr/2;
    MaxY:=FVisRect.Y2+Incr/2;
    Ext := MaxY - MinY;
    MinY := MinY - Ext * 20; // estimation
    MaxY := MaxY + Ext * 20;
    XParser.X:=FVisRect.X1;
    PrevDef:=False;
    with DrawCanvas do
    begin
      Pen.Style:=psSolid;
      Pen.Color:=Clr;
      ZY:=0;
      For A:=R.Left to R.Right do
      begin
        If (XParser.X > FSeries[Ind].FFuncDomX2) then
          break;

        If (XParser.X < FSeries[Ind].FFuncDomX1) then
          FuncOK := False
        else
        begin
          try
            Ext:=XParser.Value;
            FuncOK:=not XParser.CalcError;
            If (FuncOK) then
            begin
              If (Ext < MinY) OR (Ext > MaxY) then
                FuncOK := False
              else
                ZY:=R.Bottom-Round((Ext-FVisRect.Y1)*RY);
            end;
          except
            FuncOK:=False;
          end;
        end;

        If FuncOK then
        begin
          If NOT PrevDef then
          begin
            TP[0].X:=A;
            TP[0].Y:=ZY;
          end
          else
          begin
            TP[1].X:=A;
            TP[1].Y:=ZY;
            If NOT
               (((TP[0].Y<0) AND (TP[1].Y<0)) OR
               ((TP[0].Y>Height) AND (TP[1].Y>Height))) then
              DrawCanvas.PolyLine (TP);
            TP[0]:=TP[1];
          end;
          PrevDef:=True;
        end
        else
          PrevDef:=False;
        XParser.X:=XParser.X+Incr;
      end; {For A:=R.Left to R.Right}
      If PrevDef then
        Pixels [R.Right,ZY]:=Clr;
    end; {with DrawCanvas}
  end;

  procedure DrawFuncPoints (Ind:Integer);
  Var A,Y:Integer;
      RY,Incr:Extended;
      Clr:TColor;
      MinY,MaxY:Extended;
      Ext:Extended;
      FuncOK:Boolean;

  begin
    Clr:=FSeries[Ind].Color;
    RY:=(R.Bottom-R.Top)/(FVisRect.Y2-FVisRect.Y1);
    Incr:=(FVisRect.X2-FVisRect.X1)/(R.Right-R.Left);
    XParser.X:=FVisRect.X1;
    MinY:=FVisRect.Y1-Incr/2;
    MaxY:=FVisRect.Y2+Incr/2;
    Y:=0;
    For A:=R.Left to R.Right do
    begin
      If (XParser.X > FSeries[Ind].FFuncDomX2) then
        break;

      If (XParser.X < FSeries[Ind].FFuncDomX1) then
        FuncOK := False
      else
      begin
        try
          Ext:=XParser.Value;
          FuncOK:=not XParser.CalcError;
          If (FuncOK) then
          begin
            If (Ext <= MinY) OR (Ext >= MaxY) then
              FuncOK := False
            else
              Y := R.Bottom-Round((Ext-FVisRect.Y1)*RY);
          end;
        except
          FuncOK:=False;
        end;
      end;

      If (FuncOK) then
        DrawCanvas.Pixels [A,Y]:=Clr;
      XParser.X:=XParser.X+Incr;
    end; {For A:=R.Left to R.Right}
  end;

  procedure DrawLines (Ind:Integer);
  Var A:Integer;
      RX,RY:Extended;
      P:TPoint2D;
      First:Boolean;
  begin
    with DrawCanvas do
    begin
      with FSeries[Ind] do
      begin
        RX:=(R.Right-R.Left)/(FVisRect.X2-FVisRect.X1);
        RY:=(R.Bottom-R.Top)/(FVisRect.Y2-FVisRect.Y1);
        First:=True;
        Pen.Style:=psSolid;
        Pen.Color:=Color;
        For A:=0 to Count-1 do
        begin
          P:=FPoints[A];
          If P.X>=FVisRect.X1 then
          begin
            If P.X>FVisRect.X2 then
            begin
              If not First then
                LineTo (R.Left+Round((P.X-FVisRect.X1)*RX),R.Bottom-Round((P.Y-FVisRect.Y1)*RY));
              Break;
            end
            else
            begin
              If (Count=1) then
                Pixels[R.Left+Round((FPoints[0].X-FVisRect.X1)*RX),R.Bottom-Round((FPoints[0].Y-FVisRect.Y1)*RY)]:=Color
              else
              begin
                If First then
                  MoveTo (R.Left+Round((P.X-FVisRect.X1)*RX),R.Bottom-Round((P.Y-FVisRect.Y1)*RY))
                else
                  LineTo (R.Left+Round((P.X-FVisRect.X1)*RX),R.Bottom-Round((P.Y-FVisRect.Y1)*RY));
              end;
            end;
            First:=False;
          end {If FPoints[A].X>=FVisRect.X1}
          else
            If Count>A+1 then
              If FPoints[A+1].X>FVisRect.X1 then
              begin
                MoveTo (R.Left+Round((P.X-FVisRect.X1)*RX),R.Bottom-Round((P.Y-FVisRect.Y1)*RY));
                First:=False;
              end;
        end; {For A:=0 to Count-1}
      end; {with FSeries[Ind]}
    end; {with DrawCanvas}
  end;

  procedure DrawPoints (Ind:Integer);
  Var A:Integer;
      RX,RY:Extended;
      P:TPoint2D;
      OldClr:TColor;
      TW,TH:Integer;
      PS:Char;
  begin
    with FSeries[Ind] do
    begin
      RX:=(R.Right-R.Left)/(FVisRect.X2-FVisRect.X1);
      RY:=(R.Bottom-R.Top)/(FVisRect.Y2-FVisRect.Y1);
      OldClr := DrawCanvas.Font.Color;
      DrawCanvas.Font.Color := Color;
      DrawCanvas.Brush.Style := bsClear;
      PS := FSeries[Ind].PointSymbol;
      TW := DrawCanvas.TextWidth (PS) div 2;
      TH := DrawCanvas.TextHeight (PS) div 2;
      For A:=0 to Count-1 do
      begin
        P:=Points[A];
        If P.X>=FVisRect.X1 then
        begin
          If P.X>FVisRect.X2 then
            Break;
          If (P.Y>=FVisRect.Y1) AND (P.Y<=FVisRect.Y2) then
          begin
            If FSeries[Ind].PointSymbol = #0 then
              DrawCanvas.Pixels [R.Left+Round((P.X-FVisRect.X1)*RX),R.Bottom-Round((P.Y-FVisRect.Y1)*RY)]:=Color
            else
            begin
              DrawCanvas.TextOut (R.Left+Round((P.X-FVisRect.X1)*RX) - TW,
                                  R.Bottom-Round((P.Y-FVisRect.Y1)*RY) - TH, PS);
            end;
          end;
        end; {If FPoints[A].X>=FVisRect.X1}
      end; {For A:=0 to Count-1}
      DrawCanvas.Font.Color := OldClr;
      DrawCanvas.Brush.Style := bsSolid;
    end; {with FSeries[Ind]}
  end;

begin
  DC:=GetDC (0);
  A:=GetDeviceCaps (DC,BITSPIXEL);
  ReleaseDC (0,DC);
  If ACanvas=nil then
  begin
    If A<>XLastBPP then
    begin
      XTempBmp.Free;
      XTempBmp:=TBitmap.Create;
      If XBgBmp<>nil then
      begin
        XBgBmp.Free;
        XBgBmp:=TBitmap.Create;
        XBgRedraw:=True;
      end;
      XLastBPP:=A;
    end;
    If Width<>XTempBmp.Width then
    begin
      XTempBmp.Width:=Width;
      If XBgBmp<>nil then
      begin
        XBgBmp.Width:=Width;
        XBgRedraw:=True;
      end;
    end;
    If Height<>XTempBmp.Height then
    begin
      XTempBmp.Height:=Height;
      If XBgBmp<>nil then
      begin
        XBgBmp.Height:=Height;
        XBgRedraw:=True;
      end;
    end;
    DrawCanvas:=XTempBmp.Canvas
  end
  else
    DrawCanvas:=ACanvas;
  If XBgRedraw then
  begin
    XBgRedraw:=False;
    If (XBgBmp=nil) then
    begin
      XBgBmp:=TBitmap.Create;
      XBgBmp.Width:=Width;
      XBgBmp.Height:=Height;
    end;
    If (FBgStyle=bgsLineHoriz) then
      DrawLineHoriz;
    If (FBgStyle=bgsLineVert) then
      DrawLineVert;
  end;
  If (ACanvas=nil) then
  begin
    If (FBgStyle=bgsSolid) OR
       (XBgBmp=nil) then
    begin
      with DrawCanvas do
      begin
        Brush.Color:=FColorBg;
        Brush.Style:=bsSolid;
        FillRect (Rect(0,0,Width,Height));
      end;
    end
    else
    begin
      If (FBgStyle=bgsImageStretch) OR
         (FBgStyle=bgsImageTile) then
      begin
        If FBgImage='' then
        begin
          XBgBmp.Free;
          XBgBmp:=nil;
        end
        else
        begin
          XBmp:=TBitmap.Create;
          try
            XBmp.LoadFromFile (FBgImage);
          except
            XBgBmp.Free;
            XBGBmp:=nil;
          end;
          If XBgBmp<>nil then
          begin
            If FBgStyle=bgsImageStretch then
              DrawCanvas.StretchDraw (Rect(0,0,XBgBmp.Width,XBgBmp.Height),XBmp)
            else
            begin
              B:=0;
              while B<XTempBmp.Height do
              begin
                C:=0;
                while C<XTempBmp.Width do
                begin
                  DrawCanvas.Draw (C,B,XBmp);
                  Inc (C,XBmp.Width);
                end;
                Inc (B,XBmp.Height);
              end;
            end;
            XBmp.Free;
          end;
        end;
      end
      else
        XTempBmp.Canvas.Draw (0,0,XBgBmp);
    end;
  end;

{  XBgBmp.LoadFromFile ('C:\!Vit\aplane.bmp');
  XTempBmp.Canvas.Draw (0,0,XBgBmp);}
  If ACanvas=nil then
    XRenderNeed:=False;
  R:=Rect(0,0,Width-1,Height-1);
  with XTempBmp.Canvas do
  begin
    DrawBorder (FBorderStyle,FColorBorder);
    XGraphRect:=R;
    If NumbHoriz then
      Dec (XGraphRect.Bottom,TextHeight ('Xy')+4);
    If NumbVert then
    begin
      S:='';
      A:=Round(log10(MaxVisRectLength))+1;
      For B:=1 to A do
        S:=S+'8';
      A:=Round(-log10(MinVisRectLength))+1;
      If A<0 then
        A:=0;
      If A>0 then
      begin
        S:=S+',';
        For B:=1 to A do
          S:=S+'8';
      end;
      Inc (XGraphRect.Left,TextWidth(S)+4);
    end;
    If GraphBorder<>bstNone then
      InflateRect (XGraphRect,-1,-1);
    AdjustZoom (FVisRect);
    DrawGridAndNumbers;
    R:=XGraphRect;

    Rgn := 0;
    try
      TempR:=Rect (R.Left,R.Top,R.Right+1,R.Bottom+1);
      Case (FQuadrant) of
        egqAll:
          begin
            // no problems
          end;
        egqFirst:
          begin
            If ((VisRect.X2 < 0) OR (VisRect.Y2 < 0)) then
              // nothing is displayed
              TempR.Left := TempR.Right + 1
            else
            begin
              If (VisRect.X1 < 0) then
                TempR.Left := TempR.Right - Round (VisRect.X2 * (TempR.Right - TempR.Left) / (VisRect.X2 - VisRect.X1)) - 1;
              If (VisRect.Y1 < 0) then
                TempR.Bottom := TempR.Top + Round (VisRect.Y2 * (TempR.Bottom - TempR.Top) / (VisRect.Y2 - VisRect.Y1));
            end;
          end;
        egqSecond:
          begin
            If ((VisRect.X1 > 0) OR (VisRect.Y2 < 0)) then
              TempR.Left := TempR.Right + 1
            else
            begin
              If (VisRect.X2 > 0) then
                TempR.Right := TempR.Left + Round ((-VisRect.X1) * (TempR.Right - TempR.Left) / (VisRect.X2 - VisRect.X1)) + 1;
              If (VisRect.Y1 < 0) then
                TempR.Bottom := TempR.Top + Round (VisRect.Y2 * (TempR.Bottom - TempR.Top) / (VisRect.Y2 - VisRect.Y1)) + 1;
            end;
          end;
        egqThird:
          begin
            If ((VisRect.X1 > 0) OR (VisRect.Y1 > 0)) then
              TempR.Left := TempR.Right + 1
            else
            begin
              If (VisRect.X2 > 0) then
                TempR.Right := TempR.Left + Round ((-VisRect.X1) * (TempR.Right - TempR.Left) / (VisRect.X2 - VisRect.X1));
              If (VisRect.Y2 > 0) then
                TempR.Top := TempR.Bottom - Round ((-VisRect.Y1) * (TempR.Bottom - TempR.Top) / (VisRect.Y2 - VisRect.Y1));
            end;
          end;
        egqFourth:
          begin
            If ((VisRect.X2 < 0) OR (VisRect.Y1 > 0)) then
              TempR.Left := TempR.Right + 1
            else
            begin
              If (VisRect.X1 < 0) then
                TempR.Left := TempR.Right - Round (VisRect.X2 * (TempR.Right - TempR.Left) / (VisRect.X2 - VisRect.X1)) - 1;
              If (VisRect.Y2 > 0) then
                TempR.Top := TempR.Bottom - Round ((-VisRect.Y1) * (TempR.Bottom - TempR.Top) / (VisRect.Y2 - VisRect.Y1));
            end;
          end;
        egqRight:
          begin
            If (VisRect.X2 < 0) then
              TempR.Left := TempR.Right + 1
            else
            begin
              If (VisRect.X1 < 0) then
                TempR.Left := TempR.Right - Round (VisRect.X2 * (TempR.Right - TempR.Left) / (VisRect.X2 - VisRect.X1)) - 1;
            end;
          end;
        egqLeft:
          begin
            If (VisRect.X1 > 0) then
              TempR.Left := TempR.Right + 1
            else
            begin
              If (VisRect.X2 > 0) then
                TempR.Right := TempR.Left + Round ((-VisRect.X1) * (TempR.Right - TempR.Left) / (VisRect.X2 - VisRect.X1));
            end;
          end;
      end;
      If (TempR.Left <= TempR.Right) then
      begin
        Rgn:=CreateRectRgnIndirect (TempR);
        SelectClipRgn (DrawCanvas.Handle,Rgn);

        For A:=0 to FSeries.Count-1 do
        begin
          If FSeries[A].Visible then
          begin
            If FSeries[A].XParseFunc<>'' then
            begin
              try
                ParseOK:=XParser.ParseExpression (FSeries[A].XParseFunc);
              except
                ParseOK:=False;
              end;
              If ParseOK=True then
                Case FSeries[A].DrawStyle of
                  dsLines:
                    DrawFuncLines (A);
                  dsPoints:
                    DrawFuncPoints (A);
                end;
            end
            else
              Case FSeries[A].DrawStyle of
                dsLines:
                  begin
                    DrawLines (A);
                    If FSeries[A].FPointSymbol <> #0 then
                      DrawPoints (A);
                  end;
                dsPoints:
                  DrawPoints (A);
              end;
          end;
        end;
      end;
    finally
      SelectClipRgn (DrawCanvas.Handle,0);
      DeleteObject (Rgn);
    end;
  end; {with XTempBmp.Canvas}
end;

procedure TEasyGraph.SetGridStyle (AValue:TGridStyle);
begin
  If FGridStyle<>AValue then
  begin
    FGridStyle:=AValue;
    XRenderNeed:=True;
    If Assigned (OnChange) then
      OnChange (Self);
    Invalidate;
  end;
end;

procedure TEasyGraph.Paint;
var RN:Boolean;
    DC:HDC;
begin
  If not XRenderNeed then
  begin
    If (XTempBmp.Width<>Width) OR (XTempBmp.Height<>Height) then
      XRenderNeed:=True
    else
    begin
      DC:=GetDC(0);
      If GetDeviceCaps (DC,BITSPIXEL)<>XLastBPP then
        XRenderNeed:=True;
      ReleaseDC (0,DC);
    end;
  end;
  RN:=XRenderNeed;
  If XRenderNeed then
  begin
    XTimeToDraw:=GetTickCount;
    Render (nil);
  end;
  Canvas.CopyRect (Canvas.ClipRect,XTempBmp.Canvas,Canvas.ClipRect);
  If RN then
    XTimeToDraw:=Integer(GetTickCount) - XTimeToDraw;
end;

procedure TEasyGraph.SetColorAxis (AValue:TColor);
begin
  If FColorAxis<>AValue then
  begin
    FColorAxis:=AValue;
    XRenderNeed:=True;
    If Assigned(OnChange) then
      OnChange (Self);
    Invalidate;
  end;
end;

procedure TEasyGraph.SetColorBg (AValue:TColor);
begin
  If FColorBg<>AValue then
  begin
    FColorBg:=AValue;
    XRenderNeed:=True;
    XBgRedraw:=True;
    If Assigned (OnChange) then
      OnChange (Self);
    Invalidate;
  end;
end;

procedure TEasyGraph.SetColorBg2 (AValue:TColor);
begin
  If FColorBg2<>AValue then
  begin
    FColorBg2:=AValue;
    XRenderNeed:=True;
    XBgRedraw:=True;
    If Assigned (OnChange) then
      OnChange (Self);
    Invalidate;
  end;
end;

procedure TEasyGraph.SetColorGrid (AValue:TColor);
begin
  If FColorGrid<>AValue then
  begin
    FColorGrid:=AValue;
    XRenderNeed:=True;
    If Assigned (OnChange) then
      OnChange (Self);
    Invalidate;
  end;
end;

procedure TEasyGraph.SetColorBorder (AValue:TColor);
begin
  If FColorBorder<>AValue then
  begin
    FColorBorder:=AValue;
    XRenderNeed:=True;
    If Assigned (OnChange) then
      OnChange (Self);
    Invalidate;
  end;
end;

procedure TEasyGraph.SetColorNumb (AValue:TColor);
begin
  If AValue<>FColorNumb then
  begin
    FColorNumb:=AValue;
    XRenderNeed:=True;
    If Assigned (OnChange) then
      OnChange (Self);
    Invalidate;
  end;
end;

procedure TEasyGraph.SetGraphBorder (AValue:TBorderStyle);
begin
  If FGraphBorder<>AValue then
  begin
    FGraphBorder:=AValue;
    XRenderNeed:=True;
    If Assigned (OnChange) then
      OnChange (Self);
    Invalidate;
  end;
end;

procedure TEasyGraph.SetNumbHoriz (AValue:Boolean);
begin
  If FNumbHoriz<>AValue then
  begin
    FNumbHoriz:=AValue;
    XRenderNeed:=True;
    If Assigned (OnChange) then
      OnChange (Self);
    Invalidate;
  end;
end;

procedure TEasyGraph.SetNumbVert (AValue:Boolean);
begin
  If FNumbVert<>AValue then
  begin
    FNumbVert:=AValue;
    XRenderNeed:=True;
    If Assigned (OnChange) then
      OnChange (Self);
    Invalidate;
  end;
end;

procedure TEasyGraph.SetOnXLabeling (AValue:TEGLabelingEvent);
begin
  FOnXLabeling := AValue;
  XRenderNeed:=True;
  If Assigned (OnChange) then
    OnChange (Self);
  Invalidate;
end;

procedure TEasyGraph.SetOnYLabeling (AValue:TEGLabelingEvent);
begin
  FOnYLabeling := AValue;
  XRenderNeed:=True;
  If Assigned (OnChange) then
    OnChange (Self);
  Invalidate;
end;

procedure TEasyGraph.SetQuadrant (AValue:TEGQuadrant);
begin
  FQuadrant := AValue;
  XRenderNeed:=True;
  If Assigned (OnChange) then
    OnChange (Self);
  Invalidate;
end;

destructor TEasyGraph.Destroy;
begin
  If XZoomThread<>nil then
    XZoomThread.Free;
  If XLegend<>nil then
    If XLegend.FEasyGraph=Self then
      XLegend.FEasyGraph:=nil;
  Series.Free;
  XParser.Free;
  XHintForm.Free;
  inherited Destroy;
end;

procedure TEasyGraph.SeriesChange (Sender:TObject);
begin
  If XLegend<>nil then
    XLegend.UpdateList (-1);
  XRenderNeed:=True;
  If Assigned(OnChange) then
    OnChange (Self);
  If (XUpdateCounter = 0) then
    Invalidate;
end;

procedure TEasyGraph.MouseDown(Button: TMouseButton; Shift: TShiftState;X, Y: Integer);
begin
  inherited MouseDown (Button,Shift,X,Y);
  If XMouseAction<>0 then
    Exit;
  XMousePointsMove:=0;
  If (XZoomThread=nil) AND (PtInRect (XGraphRect,Point(X,Y))) AND
     (XMouseAction=0) then
  begin
    If ((Button=mbRight) AND (FMouseFuncHint=maRight)) OR
       ((Button=mbLeft) AND (
        ((ssAlt in Shift) AND (FMouseFuncHint=maAlt)) OR
        ((ssCtrl in Shift) AND (FMouseFuncHint=maCtrl)) OR
        ((ssShift in Shift) AND (FMouseFuncHint=maShift)))) then
      {Activate showing hint?}
    begin
      XMouseAction:=8;
      XMousePos:=Point(X,Y);
      XHintForm.Show;
      CalculateHint;
      XWnd:=AllocateHWnd (MyWndProc);
      SetCapture (XWnd);
      Exit;
    end;
    If ((Button=mbRight) AND (FMouseZoom=maRight)) OR
       ((Button=mbLeft) AND (
        ((ssAlt in Shift) AND (FMouseZoom=maAlt)) OR
        ((ssCtrl in Shift) AND (FMouseZoom=maCtrl)) OR
        ((ssShift in Shift) AND (FMouseZoom=maShift)))) then
      {Activate zoom out?}
    begin
      XMouseAction:=1;
    end;
    If ((Button=mbRight) AND (FMousePan=maRight)) OR
       ((Button=mbLeft) AND (
        ((ssAlt in Shift) AND (FMousePan=maAlt)) OR
        ((ssCtrl in Shift) AND (FMousePan=maCtrl)) OR
        ((ssShift in Shift) AND (FMousePan=maShift)))) then
      {Activate moving?}
    begin
      XMouseAction:=XMouseAction OR 2;
      XMousePos:=Point (X,Y);
    end;
    If (Button=mbLeft) AND (XMouseAction=0) AND (FMouseZoom<>maNone) then
      {Activate zoom in?}
    begin
      XMouseAction:=4;
      XLastZoomR:=Rect (X,Y,X,Y);
    end;
  end;
end;

procedure TEasyGraph.MouseMove(Shift: TShiftState; X, Y: Integer);
var X2,Y2:Integer;
    R:Extended;
{    P:TPoint;}
begin
  Inc (XMousePointsMove);
  If (XMouseAction AND 2=2) AND (XMousePointsMove>=MinMousePointsMove) then
    {moving}
  begin
    If (FMousePan=maRight) AND not (ssRight in Shift) then
      XMouseAction:=0
    else
    begin
{      P:=ClientToScreen (Point(XMousePos.X,XMousePos.Y));
      SetCursorPos (P.X,P.Y);}
      XMouseAction:=2;
      R:=(FVisRect.X2-FVisRect.X1)/(XGraphRect.Right-XGraphRect.Left);
      FVisRect.X1:=FVisRect.X1-(X-XMousePos.X)*R;
      FVisRect.X2:=FVisRect.X2-(X-XMousePos.X)*R;
      R:=(FVisRect.Y2-FVisRect.Y1)/(XGraphRect.Bottom-XGraphRect.Top);
      FVisRect.Y1:=FVisRect.Y1+(Y-XMousePos.Y)*R;
      FVisRect.Y2:=FVisRect.Y2+(Y-XMousePos.Y)*R;
      XRenderNeed:=True;
      XMousePos:=Point(X,Y);
      If Assigned(FOnVisChange) then
        FOnVisChange (Self);
      Paint;
    end;
  end;
  If XMouseAction=4 then
    {zooming in}
  begin
    LineRect (XLastZoomR.Left,XLastZoomR.Top,XLastZoomR.Right,XLastZoomR.Bottom);
    X2:=X;
    Y2:=Y;
    If X2<XGraphRect.Left then
      X2:=XGraphRect.Left;
    If X2>XGraphRect.Right then
      X2:=XGraphRect.Right;
    If Y2<XGraphRect.Top then
      Y2:=XGraphRect.Top;
    If Y2>XGraphRect.Bottom then
      Y2:=XGraphRect.Bottom;
    XLastZoomR.Right:=X2;
    XLastZoomR.Bottom:=Y2;
    LineRect (XLastZoomR.Left,XLastZoomR.Top,X2,Y2);
  end;
  inherited MouseMove (Shift,X,Y);
end;

procedure TEasyGraph.MouseUp(Button: TMouseButton; Shift: TShiftState;X, Y: Integer);
var R:Extended;
    ToRect:TRect2D;
begin
  If (XMouseAction=4) then
    {zooming in}
  begin
    LineRect (XLastZoomR.Left,XLastZoomR.Top,XLastZoomR.Right,XLastZoomR.Bottom);
{    If (XLastZoomR.Left<>XLastZoomR.Right) AND (XLastZoomR.Top<>XLastZoomR.Bottom) then}
    If (Button=mbLeft) then
      GraphZoom;
  end;
  If (XMouseAction AND 1=1) AND (XMousePointsMove<MinMousePointsMove) then
    {zooming out}
  begin
    R:=(FVisRect.X2-FVisRect.X1)/2;
    ToRect.X1:=FVisRect.X1-R;
    ToRect.X2:=FVisRect.X2+R;
    R:=(FVisRect.Y2-FVisRect.Y1)/2;
    ToRect.Y1:=FVisRect.Y1-R;
    ToRect.Y2:=FVisRect.Y2+R;
    If FZoomTime<=0 then
    begin
      FVisRect:=ToRect;
      XRenderNeed:=True;
      If Assigned (FOnVisChange) then
        FOnVisChange (Self);      
      Paint;
    end
    else
      XZoomThread:=TZoomThread.Create (Self,FVisRect,ToRect,FZoomTime,XTimeToDraw);
  end;
  XMouseAction:=0;
  inherited MouseUp (Button,Shift,X,Y);
end;

procedure TEasyGraph.LineRect (X1,Y1,X2,Y2:Integer);
var A:Integer;
begin
  Canvas.Pen.Style:=psSolid;
  Canvas.Pen.Mode:=pmXor;
  Canvas.Pen.Color:=clWhite;
  Canvas.Brush.Style:=bsClear;
  If X1>X2 then
  begin
    A:=X1;
    X1:=X2;
    X2:=A;
  end;
  If Y1>Y2 then
  begin
    A:=Y1;
    Y1:=Y2;
    Y2:=A;
  end;
  Canvas.Rectangle (X1,Y1,X2+1,Y2+1);
end;

procedure TEasyGraph.GraphZoom;
var ToRect:TRect2D;
    R:Extended;
    X:Integer;
begin
  If (XLastZoomR.Right=XLastZoomR.Left) OR (XLastZoomR.Top=XLastZoomR.Bottom) then
  begin
    R:=(FVisRect.X2-FVisRect.X1)/4;
    ToRect.X1:=FVisRect.X1+R;
    ToRect.X2:=FVisRect.X2-R;
    R:=(FVisRect.Y2-FVisRect.Y1)/4;
    ToRect.Y1:=FVisRect.Y1+R;
    ToRect.Y2:=FVisRect.Y2-R;
  end
  else
  begin
    If XLastZoomR.Right<XLastZoomR.Left then
    begin
      X:=XLastZoomR.Left;
      XLastZoomR.Left:=XLastZoomR.Right;
      XLastZoomR.Right:=X;
    end;
    If XLastZoomR.Bottom<XLastZoomR.Top then
    begin
      X:=XLastZoomR.Top;
      XLastZoomR.Top:=XLastZoomR.Bottom;
      XLastZoomR.Bottom:=X;
    end;
    R:=(FVisRect.X2-FVisRect.X1)/(XGraphRect.Right-XGraphRect.Left);
    ToRect.X1:=(XLastZoomR.Left-XGraphRect.Left)*R+FVisRect.X1;
    ToRect.X2:=(XLastZoomR.Right-XGraphRect.Left)*R+FVisRect.X1;
    R:=(FVisRect.Y2-FVisRect.Y1)/(XGraphRect.Bottom-XGraphRect.Top);
    ToRect.Y1:=(XGraphRect.Bottom-XLastZoomR.Bottom)*R+FVisRect.Y1;
    ToRect.Y2:=(XGraphRect.Bottom-XLastZoomR.Top)*R+FVisRect.Y1;
  end;
  AdjustZoom (ToRect);
  If ((ToRect.X2-ToRect.X1)<(FVisRect.X2-FVisRect.X1)) OR
     ((ToRect.Y2-ToRect.Y1)<(FVisRect.Y2-FVisRect.Y1)) then
  begin
    If FZoomTime<=0 then
    begin
      FVisRect:=ToRect;
      XRenderNeed:=True;
      If Assigned(FOnVisChange) then
        FOnVisChange (Self);
      Paint;
    end
    else
      XZoomThread:=TZoomThread.Create (Self,FVisRect,ToRect,FZoomTime,XTimeToDraw);
  end;
end;

procedure TEasyGraph.AdjustZoom (var R:TRect2D);
var Rl,Rl2:Extended;
begin
  If R.X2-R.X1<MinVisRectLength then
  begin
    Rl:=(MinVisRectLength-(R.X2-R.X1))/2;
    R.X1:=R.X1-Rl;
    R.X2:=R.X2+Rl;
  end
  else
  begin
    If R.X2-R.X1>MaxVisRectLength then
    begin
      Rl:=((R.X2-R.X1)-MaxVisRectLength)/2;
      R.X1:=R.X1+Rl;
      R.X2:=R.X2-Rl;
    end
  end;
  If R.Y2-R.Y1<MinVisRectLength then
  begin
    Rl:=(MinVisRectLength-(R.Y2-R.Y1))/2;
    R.Y1:=R.Y1-Rl;
    R.Y2:=R.Y2+Rl;
  end
  else
  begin
    If R.Y2-R.Y1>MaxVisRectLength then
    begin
      Rl:=((R.Y2-R.Y1)-MaxVisRectLength)/2;
      R.Y1:=R.Y1+Rl;
      R.Y2:=R.Y2-Rl;
    end;
  end;
{ Old code - worked good with this exception:
  when you reached maximum zoom in and have MaintainRatio
  set to FALSE, it can sometimes zoom out instead of zooming in
  or doing nothing when you draw "zoom rectangle" which is much
  wider than high (or vice-versa).
  (This was found by Michael Keppler)

  If R.X2-R.X1<MinVisRectLength then
  begin
    Rl:=(MinVisRectLength-(R.X2-R.X1))/2;
    Rl2:=(R.X2-R.X1)/(R.Y2-R.Y1);
    R.X1:=R.X1-Rl;
    R.X2:=R.X2+Rl;
    Rl:=((R.X2-R.X1)/Rl2-(R.Y2-R.Y1))/2;
    R.Y1:=R.Y1-Rl;
    R.Y2:=R.Y2+Rl;
  end
  else
  begin
    If R.X2-R.X1>MaxVisRectLength then
    begin
      Rl:=((R.X2-R.X1)-MaxVisRectLength)/2;
      Rl2:=(R.X2-R.X1)/(R.Y2-R.Y1);
      R.X1:=R.X1+Rl;
      R.X2:=R.X2-Rl;
      Rl:=((R.X2-R.X1)/Rl2-(R.Y2-R.Y1))/2;
      R.Y1:=R.Y1-Rl;
      R.Y2:=R.Y2+Rl;
    end
  end;
  If R.Y2-R.Y1<MinVisRectLength then
  begin
    Rl:=(MinVisRectLength-(R.Y2-R.Y1))/2;
    Rl2:=(R.Y2-R.Y1)/(R.X2-R.X1);
    R.Y1:=R.Y1-Rl;
    R.Y2:=R.Y2+Rl;
    Rl:=((R.Y2-R.Y1)/Rl2-(R.X2-R.X1))/2;
    R.X1:=R.X1-Rl;
    R.X2:=R.X2+Rl;
  end
  else
  begin
    If R.Y2-R.Y1>MaxVisRectLength then
    begin
      Rl:=((R.Y2-R.Y1)-MaxVisRectLength)/2;
      Rl2:=(R.Y2-R.Y1)/(R.X2-R.X1);
      R.Y1:=R.Y1+Rl;
      R.Y2:=R.Y2-Rl;
      Rl:=((R.Y2-R.Y1)/Rl2-(R.X2-R.X1))/2;
      R.X1:=R.X1-Rl;
      R.X2:=R.X2+Rl;
    end;
  end;}



  If FMaintainRatio then
  begin
    Rl:=(R.X2-R.X1)/(R.Y2-R.Y1);
    Rl2:=((XGraphRect.Right-XGraphRect.Left)/(XGraphRect.Bottom-XGraphRect.Top))*FAspectRatio;
    If Rl2<Rl then
    begin
      Rl:=((R.X2-R.X1)/Rl2-(R.Y2-R.Y1))/2;
      R.Y1:=R.Y1-Rl;
      R.Y2:=R.Y2+Rl;
    end
    else
      If Rl2>Rl then
      begin
        Rl:=((R.Y2-R.Y1)*Rl2-(R.X2-R.X1))/2;
        R.X1:=R.X1-Rl;
        R.X2:=R.X2+Rl;
      end;
  end;
end;

procedure TEasyGraph.CalculateHint;
var P:TPoint;
var A,B,C,D:Integer;
    SecondPass:Bool;
    X,YExt:Extended;

  function GetFXAtPoint (S,X:Integer):Integer;
  var E,RX:Extended;
      A,G,H:Integer;
  begin
    If Series[S].Func='' then
    begin
      E:=FVisRect.X1+(FVisRect.X2-FVisRect.X1)/(XGraphRect.Right-XGraphRect.Left)*(X-XGraphRect.Left);
      If Series[S].Count=0 then
        Result:=-1000000
      else
      begin
        If Series[S].Count<2 then
        begin
          Result:=-1000000;
          Exit;
        end;
        A:=0;
        while A<Series[S].Count do
        begin
          If not (Series[S].Points[A].X<E) then
            break;
          Inc (A);
        end;
        If A=0 then
          A:=1;
        If A=Series[S].Count then
          Dec (A);
        with Series[S] do
        begin
          RX:=(XGraphRect.Right-XGraphRect.Left)/(FVisRect.X2-FVisRect.X1);
          G:=XGraphRect.Left+Round((Points[A-1].X-FVisRect.X1)*RX);
          H:=XGraphRect.Left+Round((Points[A].X-FVisRect.X1)*RX);
          If (G+1>=X) AND (H-1<=X) AND
             ( ((Points[A-1].Y>=YExt) AND (Points[A].Y<=YExt)) OR
               ((Points[A-1].Y<=YExt) AND (Points[A].Y>=YExt))) then
          begin
             SecondPass:=True;
             Result:=0;
          end
          else
          begin
            E:=Points[A-1].Y+
                 (Points[A].Y-Points[A-1].Y)/(Points[A].X-Points[A-1].X)*(E-Points[A-1].X);
            Result:=Round(XGraphRect.Bottom-(XGraphRect.Bottom-XGraphRect.Top)/(FVisRect.Y2-FVisRect.Y1)*(E-FVisRect.Y1));
          end;
        end;
      end;
    end
    else
    begin
      XParser.X:=FVisRect.X1+(FVisRect.X2-FVisRect.X1)/(XGraphRect.Right-XGraphRect.Left)*(X-XGraphRect.Left);
      try
        XParser.Expression:=Series[S].XParseFunc;
        E:=XParser.Value;
        If XParser.CalcError then
          Result:=-1000000
        else
          Result:=Round(XGraphRect.Bottom-(XGraphRect.Bottom-XGraphRect.Top)/(FVisRect.Y2-FVisRect.Y1)*(E-FVisRect.Y1));
      except
        Result:=-1000000;
      end;
    end;
  end;

  function PtBetween (Z,C,D:Integer):Boolean;
  begin
    If SecondPass then
      Result:=True
    else
      If C<D then
        Result:=(Z+3>C) AND (Z-3<D)
      else
        Result:=(Z+3>D) AND (Z-3<C);
  end;

  {This function is from Delphi 3\Source\VCL\Forms.pas}
  function GetCursorHeightMargin: Integer;
(*  var
    IconInfo: TIconInfo;
    BitmapInfoSize: Integer;
    BitmapBitsSize: DWORD;
    Bitmap: PBitmapInfoHeader;
    Bits: Pointer;
    BytesPerScanline, ImageSize: Integer;

      function FindScanline(Source: Pointer; MaxLen: Cardinal;
        Value: Cardinal): Cardinal; assembler;
      asm
              PUSH    ECX
              MOV     ECX,EDX
              MOV     EDX,EDI
              MOV     EDI,EAX
              POP     EAX
              REPE    SCASB
              MOV     EAX,ECX
              MOV     EDI,EDX
      end;*)

  begin
    Result := GetSystemMetrics(SM_CYCURSOR);
{    if GetIconInfo(GetCursor, IconInfo) then
    try
      GetDIBSizes(IconInfo.hbmMask, BitmapInfoSize, BitmapBitsSize);
      Bitmap := AllocMem(BitmapInfoSize + Integer(BitmapBitsSize));
      try
        Bits := Pointer(Integer(Bitmap) + BitmapInfoSize);
        if GetDIB(IconInfo.hbmMask, 0, Bitmap^, Bits^) and
          (Bitmap^.biBitCount = 1) then
        begin
          with Bitmap^ do
          begin
            BytesPerScanline := ((biWidth * biBitCount + 31) and not 31) div 8;
            ImageSize := biWidth * BytesPerScanline;
            Bits := Pointer(Integer(Bits) + Integer(BitmapBitsSize) - ImageSize);
            Result := FindScanline(Bits, ImageSize, $FF);
            if (Result = 0) and (biHeight >= 2 * biWidth) then
              Result := FindScanline(Pointer(Integer(Bits) - ImageSize),
                ImageSize, $00);
            Result := Result div BytesPerScanline;
          end;
          Dec(Result, IconInfo.yHotSpot);
        end;
      finally
        FreeMem(Bitmap, BitmapInfoSize + Integer(BitmapBitsSize));
      end;
    finally
      if IconInfo.hbmColor <> 0 then DeleteObject(IconInfo.hbmColor);
      if IconInfo.hbmMask <> 0 then DeleteObject(IconInfo.hbmMask);
    end;}
  end;


begin
  P:=Self.ClientToScreen(Point(0,0));
  with XHintForm do
  begin
    If (GetGraphCoords (XMousePos.X, XMousePos.Y, @X, @YExt) = False) then
      Exit;

    If (Assigned (FOnXLabeling)) then
    begin
      XX := '';
      FOnXLabeling (self, X, XX);
    end
    else
      XX := FloatToStrF (X,ffFixed,15,4);

    YExt:=FVisRect.Y1+(FVisRect.Y2-FVisRect.Y1)/(XGraphRect.Bottom-XGraphRect.Top)*(XGraphRect.Bottom-XMousePos.Y);

    If (Assigned (FOnYLabeling)) then
    begin
      XY := '';
      FOnYLabeling (self, YExt, XY);
    end
    else
      XY:=FloatToStrF (YExt,ffFixed,15,4);

    XDisplaySeries:=False;
    For A:=0 to Series.Count-1 do
    begin
      If Series[A].Visible then
      begin
        C:=GetFXAtPoint (A,XMousePos.X-2);
        For B:=XMousePos.X-1 to XMousePos.X+2 do
        begin
          SecondPass:=False;
          D:=GetFXAtPoint (A,B);
          If (D<>-1000000) AND (C<>-1000000) then
          begin
            If PtBetween (XMousePos.Y,C,D) then
            begin
              XColor:=Series[A].Color;
              If (Series[A].Func <> '') then
                XFunction := Series[A].Func
              else
                XFunction := Series[A].Caption;
              XDisplaySeries:=True;
              Break;
            end;
          end;
          C:=D;
        end;
        If XDisplaySeries then
          break;
      end;
    end;
    Render;
    Paint;
    SetBounds (P.X+XMousePos.X,P.Y+XMousePos.Y+GetCursorHeightMargin+5,Width,Height);
  end;
end;

procedure TEasyGraph.SaveAsBmp (FileName:String);
var Pic:TPicture;
begin
  If XRenderNeed then
    Render (nil);
  Pic:=TPicture.Create;
  try
    Pic.Bitmap.Assign (XTempBmp);
    Pic.SaveToFile (FileName);
  finally
    Pic.Free;
  end;
end;

procedure TEasyGraph.CopyToClipboard;
var MFile:TMetaFile;
    MFCanvas:TMetaFileCanvas;
    AData:THandle;
    APalette:HPALETTE;
    AFormat:Word;
begin
  MFile:=TMetaFile.Create;
  MFile.Width:=Width;
  MFile.Height:=Height;
  try
    MFCanvas:=TMetaFileCanvas.Create (MFile,0);
    try
      Render (MFCanvas);
    finally
      MFCanvas.Free;
    end;
    MFile.SaveToClipboardFormat (AFormat, AData, APalette);
    ClipBoard.SetAsHandle (AFormat, AData);
  finally
    MFile.Free;
  end;
end;

{$IFDEF Allow_SavetoJPEG_Func}
procedure TEasyGraph.SaveAsJpeg (FileName:String);
var Pic:TJPEGImage;
begin
  If XRenderNeed then
    Render (nil);
  Pic:=TJPEGImage.Create;
  try
    Pic.Assign (XTempBmp);
    Pic.SaveToFile (FileName);
  finally
    Pic.Free;
  end;
end;
{$ENDIF}


function TEasyGraph.GetGraphCoords (X, Y:Integer; GX, GY:PExtended):Boolean;
var P:TPoint;
begin
  P.X := X;
  P.Y := Y;
  If not PtInRect (XGraphRect, P) then
  begin
    Result := False;
    Exit;
  end;

  GX^ := FVisRect.X1+(FVisRect.X2-FVisRect.X1)/(XGraphRect.Right-XGraphRect.Left)*(X-XGraphRect.Left);
  GY^ := FVisRect.Y1+(FVisRect.Y2-FVisRect.Y1)/(XGraphRect.Bottom-XGraphRect.Top)*(XGraphRect.Bottom-Y);
  Result := True;
end;


procedure TEasyGraph.BeginUpdate;
begin
  Inc (XUpdateCounter);
end;


procedure TEasyGraph.EndUpdate;
begin
  If (XUpdateCounter <= 1) then
  begin
    XUpdateCounter := 0;
    Paint;
    Exit;
  end;
  Dec (XUpdateCounter);
end;


{*****************************************}
{*****************************************}
{*             TZoomThread               *}
{*****************************************}
{*****************************************}

constructor TZoomThread.Create (AGraph:TEasyGraph;ANowRect,AToRect:TRect2D;AZoomTime,ATimeToDraw:Integer);
begin
  inherited Create (False);
  FreeOnTerminate:=True;
  Graph:=AGraph;
  NowRect:=ANowRect;
  ToRect:=AToRect;
  ZoomTime:=AZoomTime;
  TimeToDraw:=ATimeToDraw;
end;

procedure TZoomThread.Execute;
var RX1,RX2,RY1,RY2:Extended;
    NowTime,T:Integer;
    ZoomEnd:Boolean;
    FirstRect:TRect2D;
begin
  ZoomEnd:=False;
  RX1:=(ToRect.X1-NowRect.X1)/ZoomTime;
  RX2:=(ToRect.X2-NowRect.X2)/ZoomTime;
  RY1:=(ToRect.Y1-NowRect.Y1)/ZoomTime;
  RY2:=(ToRect.Y2-NowRect.Y2)/ZoomTime;
  NowTime:=TimeToDraw;
  FirstRect:=NowRect;
  while (not ZoomEnd) AND (not Terminated) do
  begin
    If Terminated then
      break;
    T:=GetTickCount;
    If NowTime>=ZoomTime then
    begin
      ZoomEnd:=True;
      NowTime:=ZoomTime;
    end;
    NowRect.X1:=FirstRect.X1+NowTime*RX1;
    NowRect.X2:=FirstRect.X2+NowTime*RX2;
    NowRect.Y1:=FirstRect.Y1+NowTime*RY1;
    NowRect.Y2:=FirstRect.Y2+NowTime*RY2;
    Synchronize (DrawGraph);
    Inc (NowTime,Integer(GetTickCount) - T);
  end;
  If not Terminated then
    Graph.XZoomThread:=nil
  else
    FreeOnTerminate:=False;
end;

procedure TZoomThread.DrawGraph;
begin
  If not Terminated then
  begin
    Graph.FVisRect:=NowRect;
    Graph.XRenderNeed:=True;
    If Assigned(Graph.FOnVisChange) then
      Graph.FOnVisChange (Graph);
    Graph.Paint;
  end;
end;

{*****************************************}
{*****************************************}
{*            TEGLegendList              *}
{*****************************************}
{*****************************************}

procedure TEGLegendList.DrawItem(Index: Integer; Rect: TRect;
                       State: TOwnerDrawState);
var
  Rect2: TRect;
  Clr:TColor;
begin
  if Assigned(OnDrawItem) then
    OnDrawItem(Self, Index, Rect, State)
  else
    with Canvas do
    begin
      FillRect(Rect);
      Clr:=Brush.Color;
      Pen.Color:=clBlack;
      Rect2.Top := Rect.Top + 1;
      Rect2.Bottom := Rect.Bottom - 1;
      Rect2.Left:=Rect.Left + 1;
      If FCheckBoxes then
      begin
        Rect2.Right:=Rect2.Left + (Rect2.Bottom - Rect2.Top+1);
        Brush.Color := clWhite;
        Brush.Style:=bsSolid;
        FillRect (Rect2);
        Brush.Color := clBlack;
        FrameRect (Rect2);
        If Integer(Items.Objects[Index]) AND $04000000>0 then
        begin
          MoveTo (Rect2.Left,Rect2.Top);
          LineTo (Rect2.Right-1,Rect2.Bottom-1);
          MoveTo (Rect2.Right-1,Rect2.Top);
          LineTo (Rect2.Left,Rect2.Bottom-1);
        end;
        Rect2.Left:=Rect2.Right+5;
        Brush.Color:=Clr;
      end;
      Rect2.Right := Rect2.Left + 20;
      Brush.Color := TColor(Integer(Items.Objects[Index]) AND $03FFFFFF);
      Rectangle(Rect2.Left, Rect2.Top, Rect2.Right, Rect2.Bottom);
      Rect2.Left := Rect2.Right + 5;
      Rect2.Top := Rect.Top + 1;
      Rect2.Right := Rect.Right;
      Rect2.Bottom := Rect.Bottom - 1;
      Brush.Color:=Clr;
      If Items[Index]='' then
      begin
        Clr:=Font.Color;
        Font.Color:=clSilver;
        DrawText(Handle, PChar('----'), -1, Rect2, DT_VCENTER or DT_SINGLELINE);
        Font.Color:=Clr;
      end
      else
        DrawText(Handle, PChar(Items[Index]), -1, Rect2, DT_VCENTER or DT_SINGLELINE);
    end;
end;

procedure TEGLegendList.WndProc(var Message: TMessage);
var A:Integer;
    R,R2:TRect;
    Pt:TPoint;
begin
  if (Message.Msg = WM_LBUTTONDOWN) AND FCheckBoxes then
  begin
    Pt:=Point(LOWORD(Message.lParam),HIWORD(Message.lParam));
    A:=ItemAtPos (Pt,True);
    If A<>-1 then
    begin
      R:=ItemRect (A);
      R2:=R;
      Inc (R.Left);
      Inc (R.Top);
      Dec (R.Bottom);
      R.Right:=R.Left + (R.Bottom - R.Top+1);
      If PtInRect (R,Pt) then
      begin
        Items.Objects[A]:=Pointer(Integer(Items.Objects[A]) XOR $04000000);
        If FEasyGraph<>nil then
          FEasyGraph.Series[A].Visible:=Integer(Items.Objects[A]) AND $04000000>0;
        If Assigned(FOnChange) then
          FOnChange (Self);
        Invalidate;
      end;
    end;
  end;
  inherited WndProc(Message);
end;

procedure TEGLegendList.SetCheckBoxes (AValue:Boolean);
begin
  If FCheckBoxes<>AValue then
  begin
    FCheckBoxes:=AValue;
    Invalidate;
  end;
end;

procedure TEGLegendList.UpdateList (ASeries:Integer);
var A:Integer;
    Cnt,Pos:Integer;
begin
  If ASeries=-1 then
  begin
    Cnt:=Items.Count;
    Pos:=ItemIndex;
    Items.BeginUpdate;
    try
      Items.Clear;
      If FEasyGraph<>nil then
      begin
        If FEasyGraph.XLegend=Self then
        begin
          For A:=0 to FEasyGraph.Series.Count-1 do
          begin
            If (FEasyGraph.Series[A].Func <> '') then
            begin
              If (FEasyGraph.Series[A].Caption <> '') then
                Items.Add (FEasyGraph.Series[A].Caption + ' ('+FEasyGraph.Series[A].Func+')')
              else
                Items.Add ('('+FEasyGraph.Series[A].Func+')');
            end
            else
              Items.Add (FEasyGraph.Series[A].Caption);
            Items.Objects[A]:=TObject((FEasyGraph.Series[A].Color) OR (Integer(FEasyGraph.Series[A].Visible) SHL 26));
          end;
        end
        else
          FEasyGraph:=nil;
      end;
    finally
      Items.EndUpdate;
      If Assigned (FOnChange) then
        FOnChange (Self);
    end;
    If Items.Count=Cnt then
    begin
      ItemIndex:=Pos;
      If Assigned (OnClick) then
        OnClick (Self);
    end;
  end;
end;

constructor TEGLegendList.Create (AOwner:TComponent);
begin
  inherited Create (AOwner);
  FEasyGraph:=nil;
  FCheckBoxes:=True;
  Style := lbOwnerDrawFixed;
  Canvas.Pen.Color:=clBlack;
end;

destructor TEGLegendList.Destroy;
begin
  If FEasyGraph<>nil then
    If FEasyGraph.XLegend=Self then
      FEasyGraph.XLegend:=nil;
  inherited Destroy;
end;

procedure TEGLegendList.SetEasyGraph (AValue:TEasyGraph);
begin
  If FEasyGraph<>AValue then
  begin
    If FEasyGraph<>nil then
      If FEasyGraph.XLegend=Self then
        FEasyGraph.XLegend:=nil;
    FEasyGraph:=AValue;
    FEasyGraph.XLegend:=Self;
    UpdateList (-1);
  end;
end;

procedure Register;
begin
  RegisterComponents('Samples', [TEasyGraph,TEGLegendList]);
end;

end.
