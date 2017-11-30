unit Main;

interface

uses
  // Delphi/Windows
  Windows, Menus, Forms, Classes, Controls, SysUtils,
  // (J)VCL
  JvMenus, JvComponentBase, JvTrayIcon,
  // SysTool
  Global, JvAppInst
  ;

type
  TFormMain = class(TForm)

    JvTrayIcon: TJvTrayIcon;
    JvPopupMenuTray: TJvPopupMenu;
    TrayMenuItemStayOnTop: TMenuItem;
    TrayMenuItemFileUtilities: TMenuItem;
    TrayMenuItemBitPattern: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    TrayMenuItemQuit: TMenuItem;
    N3: TMenuItem;
    TrayMenuItemSessionID: TMenuItem;
    TrayMenuItemStyle: TMenuItem;
    TrayMenuItemStyleBtnLowered: TMenuItem;
    TrayMenuItemStyleBtnRaised: TMenuItem;
    TrayMenuItemStyleItemPainter: TMenuItem;
    TrayMenuItemStyleOffice: TMenuItem;
    TrayMenuItemStyleOwnerDraw: TMenuItem;
    TrayMenuItemStyleStandard: TMenuItem;
    TrayMenuItemStyleXP: TMenuItem;
    TrayMenuItemHide: TMenuItem;
    TrayMenuItemConvert: TMenuItem;
    N4: TMenuItem;
    TrayMenuItemConvertLocalToUNC: TMenuItem;
    TrayMenuItemConvertUNCToLocal: TMenuItem;
    JvAppInstances: TJvAppInstances;
    procedure FormCreate(Sender: TObject);                                // module routine
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);     // module routine
    procedure TrayMenuItemStayOnTopClick(Sender: TObject);
    procedure TrayMenuItemQuitClick(Sender: TObject);
    procedure TrayMenuItemBitPatternClick(Sender: TObject);
    procedure TrayMenuItemFileUtilitiesClick(Sender: TObject);
    procedure FormDblClick(Sender: TObject);
    procedure JvTrayIconDblClick(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure TrayMenuItemStyleClick(Sender: TObject);
    procedure TrayMenuItemHideClick(Sender: TObject);
    procedure TrayMenuItemConvertLocalToUNCClick(Sender: TObject);
    procedure TrayMenuItemConvertUNCToLocalClick(Sender: TObject);

  private
    // none

  public
    ActiveModule: TSysToolModule;
    procedure SetFormStayOnTop(StayOnTop: Boolean);                       // module routine

  end;

var
  FormMain: TFormMain;

implementation

uses
  // Delphi/Windows
  StrUtils, ClipBrd,
  // SysTool
  BitPattern, FileAnalysis
  ;

{$R *.dfm}

procedure TFormMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin

  Global.SetRegistryKeyValue(REGKEY_COMMON_STAY_ON_TOP, TrayMenuItemStayOnTop.Checked);

end;

procedure TFormMain.FormCreate(Sender: TObject);
var
  StayOnTop : Variant;
  ProcessID : DWORD;
  CursorPos : TPoint;

begin

  ProcessID := GetCurrentProcessID;

  TrayMenuItemStayOnTop.Checked := FALSE;
  if Global.GetRegistryKeyValue(REGKEY_COMMON_STAY_ON_TOP, StayOnTop) then
  begin
    TrayMenuItemStayOnTop.Checked := StayOnTop;
    Self.SetFormStayOnTop(StayOnTop);
  end;

  TrayMenuItemSessionID.Caption :=
    Format('%s (PID %d)', [Global.GetSessionKey(svHost), ProcessID]);

  if not GetCommandLineSwitch(clsStartupSilent) and JvTrayIcon.AcceptBalloons then
  begin

    JvTrayIcon.BalloonHint(
      {   Title = } Format('%s', [Global.GetApplicationNameVersionString()]),
      { Message = } Format('Host %s, PID %d', [Global.GetSessionKey(svHost), ProcessID]),
      {   Style = } btNone // btNone btError btInfo btWarning
      {   Delay = 5000, }
      {  Cancel = FALSE }
    );

  end;

  ActiveModule := stmNone;

  if not GetCommandLineSwitch(clsStartupNoMenu) and
     not GetCommandLineSwitch(clsStartupSilent) then
  begin
    CursorPos := Mouse.CursorPos;
    JvPopupMenuTray.Popup(CursorPos.X, CursorPos.Y);
  end;

end;

procedure TFormMain.FormDblClick(Sender: TObject);
begin

//

end;

procedure TFormMain.JvTrayIconDblClick(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin


//  if JvTrayIcon.AcceptBalloons then
//  begin
//
//    JvTrayIcon.BalloonHint(
//      'SHARK ATTACK',
//      '______\o/_____/|______',
//      {   Style = } btWarning // btNone btError btInfo btWarning
//      {   Delay = 5000, }
//      {  Cancel = FALSE }
//    );
//
//  end;

  case ActiveModule of

    stmNone:
      begin
        JvPopupMenuTray.Popup(X, Y);
      end;

    stmBitPattern:
      begin
        TrayMenuItemBitPatternClick(Sender);
      end;

    stmFileAnalysis:
      begin
        TrayMenuItemFileUtilitiesClick(Sender);
      end;

  end;

end;

procedure TFormMain.TrayMenuItemBitPatternClick(Sender: TObject);
begin

  ActiveModule := stmBitPattern;

  FormBitPattern.Show;

  if FormBitPattern.WindowState = wsMinimized then
  begin
    ShowWindow(FormBitPattern.Handle, SW_RESTORE);
  end;

end;

procedure TFormMain.TrayMenuItemFileUtilitiesClick(Sender: TObject);
begin

  ActiveModule := stmFileAnalysis;

  FormFileAnalysis.Show;

  if FormFileAnalysis.WindowState = wsMinimized then
  begin
    ShowWindow(FormFileAnalysis.Handle, SW_RESTORE);
  end;

end;

procedure TFormMain.TrayMenuItemConvertLocalToUNCClick(Sender: TObject);
var
  PreviousActiveModule: TSysToolModule;
  LocalPath: String;
  UNCPath: String;
  BalloonTitle: String;
  BalloonMessage: String;
  BalloonType: TBalloonType;

begin

  // there's no form associated with this module, so save the previous and restore it
  // once we've performed our duties
  PreviousActiveModule := ActiveModule;
  ActiveModule := stmConvertPathLocalUNC;

  LocalPath := ClipBoard.AsText;
  UNCPath := GetUNCPath(LocalPath);

  if JvTrayIcon.AcceptBalloons then
  begin

    if Length(Trim(UNCPath)) > 0 then
    begin
      ClipBoard.AsText := UNCPath;
      BalloonTitle   := Format('Copied UNC path to clipboard', []);
      BalloonMessage := Format('%s', [UNCPath]);
      BalloonType    := btInfo;
    end
    else
    begin
      BalloonTitle   := Format('Clipboard contains invalid local path', []);
      BalloonMessage := Format('%s', [LocalPath]);
      BalloonType    := btError;
    end;

    JvTrayIcon.BalloonHint(
      {   Title = } BalloonTitle,
      { Message = } BalloonMessage,
      {   Style = } BalloonType, // btNone btError btInfo btWarning
      {   Delay = 5000, }
      {  Cancel = FALSE }
    );

  end
  else
  begin
    // notify user without balloons somehow?
  end;

  ActiveModule := PreviousActiveModule;

end;

procedure TFormMain.TrayMenuItemConvertUNCToLocalClick(Sender: TObject);
var
  PreviousActiveModule: TSysToolModule;
  UNCPath: String;
  LocalPath: String;
  BalloonTitle: String;
  BalloonMessage: String;
  BalloonType: TBalloonType;

begin

  // there's no form associated with this module, so save the previous and restore it
  // once we've performed our duties
  PreviousActiveModule := ActiveModule;
  ActiveModule := stmConvertPathUNCLocal;

  UNCPath := ClipBoard.AsText;
  LocalPath := GetLocalPath(UNCPath);

  if JvTrayIcon.AcceptBalloons then
  begin

    if Length(Trim(LocalPath)) > 0 then
    begin
      ClipBoard.AsText := LocalPath;
      BalloonTitle   := Format('Copied local path to clipboard', []);
      BalloonMessage := Format('%s', [LocalPath]);
      BalloonType    := btInfo;
    end
    else
    begin
      BalloonTitle   := Format('Clipboard contains invalid UNC path', []);
      BalloonMessage := Format('%s', [UNCPath]);
      BalloonType    := btError;
    end;

    JvTrayIcon.BalloonHint(
      {   Title = } BalloonTitle,
      { Message = } BalloonMessage,
      {   Style = } BalloonType, // btNone btError btInfo btWarning
      {   Delay = 5000, }
      {  Cancel = FALSE }
    );

  end
  else
  begin
    // notify user without balloons somehow?
  end;

  ActiveModule := PreviousActiveModule;

end;

procedure TFormMain.TrayMenuItemHideClick(Sender: TObject);
begin

  if FormBitPattern <> nil then
    FormBitPattern.Close;

  if FormFileAnalysis <> nil then
    FormFileAnalysis.Close;

end;

procedure TFormMain.TrayMenuItemQuitClick(Sender: TObject);
begin

  Self.Close;

end;

procedure TFormMain.TrayMenuItemStayOnTopClick(Sender: TObject);
begin

  Self.SetFormStayOnTop(TrayMenuItemStayOnTop.Checked);

  Global.SetRegistryKeyValue(REGKEY_COMMON_STAY_ON_TOP, TrayMenuItemStayOnTop.Checked);

end;

procedure TFormMain.TrayMenuItemStyleClick(Sender: TObject);
begin

  if Sender is TMenuItem then
  begin

    TrayMenuItemStyleBtnLowered.Checked  := FALSE;
    TrayMenuItemStyleBtnRaised.Checked   := FALSE;
    TrayMenuItemStyleItemPainter.Checked := FALSE;
    TrayMenuItemStyleOffice.Checked      := FALSE;
    TrayMenuItemStyleOwnerDraw.Checked   := FALSE;
    TrayMenuItemStyleStandard.Checked    := FALSE;
    TrayMenuItemStyleXP.Checked          := FALSE;

    (Sender as TMenuItem).Checked := TRUE;

    case (Sender as TMenuItem).Tag of
        0: JvPopupMenuTray.Style := msBtnLowered;
        1: JvPopupMenuTray.Style := msBtnRaised;
        2: JvPopupMenuTray.Style := msItemPainter;
        3: JvPopupMenuTray.Style := msOffice;
        4: JvPopupMenuTray.Style := msOwnerDraw;
        5: JvPopupMenuTray.Style := msStandard;
        6: JvPopupMenuTray.Style := msXP;
      else JvPopupMenuTray.Style := msStandard;
    end;

    JvPopupMenuTray.Rebuild;

  end;

end;

procedure TFormMain.SetFormStayOnTop(StayOnTop: Boolean);
begin

  if FormBitPattern <> nil then
    FormBitPattern.SetFormStayOnTop(StayOnTop);

  if FormFileAnalysis <> nil then
    FormFileAnalysis.SetFormStayOnTop(StayOnTop);

end;

end.
