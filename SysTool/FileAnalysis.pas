unit FileAnalysis;

interface

uses
  // Delphi/Windows
  Windows, Forms, StdCtrls, Controls, FileCtrl, ExtCtrls, Classes, Types,
  StrUtils, SysUtils, Dialogs, Messages, Buttons, ComCtrls, SyncObjs, ClipBrd,
  Grids, UITypes,
  // (J)VCL
  JvComponentBase, JvDragDrop, JvExStdCtrls, JvCombobox, JvDriveCtrls,
  JvListBox, ValEdit, JvExExtCtrls, JvExtComponent, JvPanel, JvExControls,
  JvWaitingGradient, JvExComCtrls, JvComCtrls, JvItemsPanel, JvPageList,
  JvNavigationPane, JvGroupHeader, JvExGrids, JvBitmapButton, JvSpeedButton,
  JvSpecialProgress, JvWaitingProgress, JvProgressBar, JvLabel, JvEditorCommon,
  JvEditor,
  // Indy
  IdGlobalProtocols, idHashMessageDigest, idHash,
  // TPerlRegEx
  PerlRegEx,
  // SysTool
  Global
  ;

type
  TValueListKey = (
    vlkPath = 0,
    vlkUNCPath,
    vlkTypeExtension,
    vlkTypeInspected,
    vlkSize,
    vlkCreated,
    vlkModified,
    vlkAccessed,
    vlkAttributes,
    vlkEncoding,
    vlkLineEndings,
    vlkChecksumMD5
  );

type
  TFileDateTimeAttribute = ( dtaCreated, dtaModified, dtaAccessed );

const VALUE_LIST_KEY: array[TValueListKey] of String =
(
    { vlkPath          } 'Path',
    { vlkUNCPath       } 'UNC Path',
    { vlkTypeExtension } 'Type (extension)',
    { vlkTypeInspected } 'Type (inspected)',
    { vlkSize          } 'Size',
    { vlkCreated       } 'Created',
    { vlkModified      } 'Modified',
    { vlkAccessed      } 'Accessed',
    { vlkAttributes    } 'Attributes',
    { vlkEncoding      } 'Encoding',
    { vlkLineEndings   } 'Line endings',
    { vlkChecksumMD5   } 'Checksum (MD5)'
);

const
  WM_PROGRESS_MESSAGE = WM_USER + 99;

type
  TThreadAction = function(FilePath: String): String;

type
  TPropertyThread = class(TThread)
  public
    Output   : String;
    FilePath : String;
    Action   : TThreadAction;
    Key      : TValueListKey;
    Button   : TSpeedButton;
    Progress : TJvWaitingGradient;
    Value    : TValueListEditor;
    FileList : TJvFileListBox;
    DirList  : TJvDirectoryListBox;
    procedure Execute; override;
    procedure Terminate(Sender: TObject);
  end;

const
  VALUE_UNIMPLEMENTED_PROPERTY = '-- Not implemented';
  CHECKSUM_NOT_COMPUTED = '!! Large file: click refresh button to compute';

type
  TThreadProperty = record
    Thread   : TPropertyThread;
    Action   : TThreadAction; // need a copy here too for thread restoration
    Key      : TValueListKey;
    Button   : TSpeedButton;
    Progress : TJvWaitingGradient;
    Value    : TValueListEditor;
  end;

procedure IncreaseThreadCount;
procedure DecreaseThreadCount;
function GetThreadCount: Integer;

function GetFileTime(FilePath: String; TimeAttrib: TFileDateTimeAttribute): String;

type
  TRegExItem = (
    repBeginList,
    repListBinItem,
    repListTxtItem,
    repListErrItem
  );

const
  NO_REPLACEMENT_PATTERN = ''; // TBD - distinguish matching vs replacing regex
  REGEX_PATTERN: array[TRegExItem] of TUTF8StringPair =
  (
  // TStringPair used for regex as:
  //   Key = match pattern
  //   Val = replacement pattern

    // repBeginList:
    (
      Key: '^\s*Collecting data from file:(\s+(.+))?$';
      Val: NO_REPLACEMENT_PATTERN;
    ),
    // repListBinItem:
    (
      Key: '^\s*([0-9]{1,3}\.[0-9]%)\s+\(([^\)]+)\)\s+(.*)\s+(\([\d/]*\)).*$';
      Val: '\3 (\2)';
    ),
    // repListTxtItem:
    (
      Key: '^\s*Warning: file seems to be plain text/ASCII$';
      Val: 'ASCII plain text';
    ),
    // repListErrItem:
    (
      Key: '^\s*\* Error: found no file\(s\) to analyze!$';
      Val: 'error: invalid NTFS file';
    )
  );

var
  RegEx: array[TRegExItem] of TPerlRegEx;

function GetUNCFilePath(FilePath: String): String;
function GetTypeInspected(FilePath: String): String;
function GetSize(FilePath: String): String;
function GetCreated(FilePath: String): String;
function GetModified(FilePath: String): String;
function GetAccessed(FilePath: String): String;
function GetAttributes(FilePath: String): String;
function GetEncoding(FilePath: String): String;
function GetLineEndings(FilePath: String): String;
function GetChecksumMD5(FilePath: String): String;

type
  TFormFileAnalysis = class(TForm)

    JvDragDrop: TJvDragDrop;
    PanelBrowser: TPanel;
    Splitter1: TSplitter;
    JvFileListBox: TJvFileListBox;
    JvDirectoryListBox: TJvDirectoryListBox;
    JvDriveCombo: TJvDriveCombo;
    Splitter2: TSplitter;
    JvPageControl: TJvPageControl;
    TabSheetProperties: TTabSheet;
    TabSheetHexDump: TTabSheet;
    ValueListEditor: TValueListEditor;
    JvPanel1: TJvPanel;
    JvPanel2: TJvPanel;
    SpeedButtonChecksumMD5: TSpeedButton;
    SpeedButtonLineEndings: TSpeedButton;
    SpeedButtonEncoding: TSpeedButton;
    SpeedButtonAttributes: TSpeedButton;
    SpeedButtonAccessed: TSpeedButton;
    SpeedButtonModified: TSpeedButton;
    SpeedButtonCreated: TSpeedButton;
    SpeedButtonSize: TSpeedButton;
    SpeedButtonTypeInspected: TSpeedButton;
    JvWaitingGradientTypeInspected: TJvWaitingGradient;
    JvWaitingGradientSize: TJvWaitingGradient;
    JvWaitingGradientCreated: TJvWaitingGradient;
    JvWaitingGradientModified: TJvWaitingGradient;
    JvWaitingGradientAccessed: TJvWaitingGradient;
    JvWaitingGradientAttributes: TJvWaitingGradient;
    JvWaitingGradientEncoding: TJvWaitingGradient;
    JvWaitingGradientLineEndings: TJvWaitingGradient;
    JvWaitingGradientChecksumMD5: TJvWaitingGradient;
    JvPanel3: TJvPanel;
    SpeedButtonChecksumMD5Copy: TSpeedButton;
    SpeedButtonLineEndingsCopy: TSpeedButton;
    SpeedButtonEncodingCopy: TSpeedButton;
    SpeedButtonAttributesCopy: TSpeedButton;
    SpeedButtonAccessedCopy: TSpeedButton;
    SpeedButtonModifiedCopy: TSpeedButton;
    SpeedButtonCreatedCopy: TSpeedButton;
    SpeedButtonSizeCopy: TSpeedButton;
    SpeedButtonTypeInspectedCopy: TSpeedButton;
    SpeedButtonPathCopy: TSpeedButton;
    SpeedButtonTypeExtensionCopy: TSpeedButton;
    SpeedButtonCopyTable: TSpeedButton;
    JvPanelCopyTable: TJvPanel;
    EditorHexDump: TJvEditor;
    EditCurrentDir: TEdit;
    PanelHexDumpProgress: TJvPanel;
    JvLabel1: TJvLabel;
    ProgressBarHexDump: TJvProgressBar;
    SpeedButtonCancelHexDump: TSpeedButton;
    SpeedButtonUNCPathCopy: TSpeedButton;
    procedure FormCreate(Sender: TObject);  // module routine
    procedure FormShow(Sender: TObject);
    procedure JvDragDropDrop(Sender: TObject; Pos: TPoint; Value: TStrings);
    procedure JvDriveComboChange(Sender: TObject);
    procedure JvDirectoryListBoxChange(Sender: TObject);
    procedure JvFileListBoxChange(Sender: TObject);
    procedure ValueListEditorSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure SpeedButtonValueListClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SpeedButtonValueListCopyClick(Sender: TObject);
    procedure ValueListEditorStringsChange(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure SpeedButtonCopyTableClick(Sender: TObject);
    procedure SpeedButtonCancelHexDumpClick(Sender: TObject);
    procedure JvPageControlChange(Sender: TObject);

  private
    ThreadProperty: array[TValueListKey] of TThreadProperty;
    PrevSelectedFile: String;
    ContinueHexDump: Boolean;
    TabSheetPropertiesSelectedFile: String;
    TabSheetHexDumpSelectedFile: String;
    procedure ShowProperties(FilePath: String);
    procedure ShowHexDump(FilePath: String);
    procedure SaveRegistrySettings;
    procedure LoadRegistrySettings;

  public
    procedure CreateParams(var Params: TCreateParams); override;       // module routine
    procedure SetFormStayOnTop(StayOnTop: Boolean);                    // module routine

  end;

var
  ActiveThreadsLock: THandle;
  ActiveThreads: Integer;
  FormFileAnalysis: TFormFileAnalysis;

implementation

uses
  // Delphi/Windows
  Graphics, ActiveX,
  // (J)VCL
  JvTrayIcon,
  // SysTool
  Main
  ;

{$R *.dfm}


procedure IncreaseThreadCount;
begin

  if WAIT_OBJECT_0 <> WaitForSingleObject(ActiveThreadsLock, INFINITE) then
  begin
    RaiseLastOSError;
  end;

  try
    ActiveThreads := ActiveThreads + 1;
  finally
    ReleaseMutex(ActiveThreadsLock);
  end;

end;

procedure DecreaseThreadCount;
begin

  if WAIT_OBJECT_0 <> WaitForSingleObject(ActiveThreadsLock, INFINITE) then
  begin
    RaiseLastOSError;
  end;

  try
    //ActiveThreads := Math.Max(ActiveThreads - 1, 0);
    ActiveThreads := ActiveThreads - 1;
    if ActiveThreads < 0 then ShowMessage('error: DecreaseThreadCount: negative thread count');
  finally
    ReleaseMutex(ActiveThreadsLock);
  end;

end;

function GetThreadCount: Integer;
begin

  if WAIT_OBJECT_0 <> WaitForSingleObject(ActiveThreadsLock, INFINITE) then
  begin
    RaiseLastOSError;
  end;

  try
    Result := ActiveThreads;
  finally
    ReleaseMutex(ActiveThreadsLock);
  end;

end;

function GetFileTime(FilePath: String; TimeAttrib: TFileDateTimeAttribute): String;
var
  Attrib: TWin32FileAttributeData;
  SystemTime: TSystemTime;
  LocalTime: TSystemTime;

begin

  if not GetFileAttributesEx(PWideChar(FilePath), GetFileExInfoStandard, @Attrib) then
    RaiseLastOSError;

  case TimeAttrib of

    dtaCreated:
      if not FileTimeToSystemTime(Attrib.ftCreationTime, SystemTime) then
        RaiseLastOSError;

    dtaModified:
      if not FileTimeToSystemTime(Attrib.ftLastWriteTime, SystemTime) then
        RaiseLastOSError;

    dtaAccessed:
      if not FileTimeToSystemTime(Attrib.ftLastAccessTime, SystemTime) then
        RaiseLastOSError;

  end;

  if not SystemTimeToTzSpecificLocalTime(nil, SystemTime, LocalTime) then
    RaiseLastOSError;

  Result := DateTimeToStr(SystemTimeToDateTime(LocalTime));

end;

procedure TFormFileAnalysis.SaveRegistrySettings;
begin

  Global.SetRegistryKeyValue(REGKEY_FORMFILEANALYSIS_FORM_X, Self.Left);
  Global.SetRegistryKeyValue(REGKEY_FORMFILEANALYSIS_FORM_Y, Self.Top);
  Global.SetRegistryKeyValue(REGKEY_FORMFILEANALYSIS_FORM_WIDTH, Self.Width);
  Global.SetRegistryKeyValue(REGKEY_FORMFILEANALYSIS_FORM_HEIGHT, Self.Height);
  Global.SetRegistryKeyValue(REGKEY_FORMFILEANALYSIS_BROWSER_WIDTH, Self.PanelBrowser.Width);
  Global.SetRegistryKeyValue(REGKEY_FORMFILEANALYSIS_DIR_LIST_HEIGHT, Self.JvDirectoryListBox.Height);

end;

procedure TFormFileAnalysis.LoadRegistrySettings;
var
  FormX         : Variant;
  FormY         : Variant;
  FormWidth     : Variant;
  FormHeight    : Variant;
  BrowserWidth  : Variant;
  DirListHeight : Variant;

begin

  FormX         := 0;
  FormY         := 0;
  FormWidth     := 0;
  FormHeight    := 0;
  BrowserWidth  := 0;
  DirListHeight := 0;

  if Global.GetRegistryKeyValue(REGKEY_FORMFILEANALYSIS_FORM_X, FormX) then
  begin
    Self.Left := FormX;
  end;

  if Global.GetRegistryKeyValue(REGKEY_FORMFILEANALYSIS_FORM_Y, FormY) then
  begin
    Self.Top := FormY;
  end;

  if Global.GetRegistryKeyValue(REGKEY_FORMFILEANALYSIS_FORM_WIDTH, FormWidth)
    then
  begin
    Self.Width := FormWidth;
  end;

  if Global.GetRegistryKeyValue(REGKEY_FORMFILEANALYSIS_FORM_HEIGHT,
    FormHeight) then
  begin
    Self.Height := FormHeight;
  end;

  if Global.GetRegistryKeyValue(REGKEY_FORMFILEANALYSIS_BROWSER_WIDTH,
    BrowserWidth) then
  begin
    PanelBrowser.Width := BrowserWidth;
  end;

  if Global.GetRegistryKeyValue(REGKEY_FORMFILEANALYSIS_DIR_LIST_HEIGHT,
    DirListHeight) then
  begin
    JvDirectoryListBox.Height := DirListHeight;
  end;

end;

procedure TFormFileAnalysis.FormCreate(Sender: TObject);
var
  Key       : TValueListKey;
  RegExItem : TRegExItem;

begin

  LoadRegistrySettings;

  Self.Caption := Format('File Analysis (%s)', [AnsiUpperCase(Global.GetSessionIdentifier())]);

  with ThreadProperty[vlkPath] do
  begin
    Key      := vlkPath;
    Button   := nil;
    Progress := nil;
    Thread   := nil;
    Action   := nil;
  end;

  with ThreadProperty[vlkUNCPath] do
  begin
    Key      := vlkUNCPath;
    Button   := nil;
    Progress := nil;
    Thread   := nil;
    Action   := nil;
  end;

  with ThreadProperty[vlkTypeExtension] do
  begin
    Key      := vlkTypeExtension;
    Button   := nil;
    Progress := nil;
    Thread   := nil;
    Action   := nil;
  end;

  with ThreadProperty[vlkTypeInspected] do
  begin
    Key      := vlkTypeInspected;
    Button   := SpeedButtonTypeInspected;
    Progress := JvWaitingGradientTypeInspected;
    Thread   := TPropertyThread.Create(TRUE);
    Action   := @GetTypeInspected;
  end;

  with ThreadProperty[vlkSize] do
  begin
    Key      := vlkSize;
    Button   := SpeedButtonSize;
    Progress := JvWaitingGradientSize;
    Thread   := TPropertyThread.Create(TRUE);
    Action   := @GetSize;
  end;

  with ThreadProperty[vlkCreated] do
  begin
    Key      := vlkCreated;
    Button   := SpeedButtonCreated;
    Progress := JvWaitingGradientCreated;
    Thread   := TPropertyThread.Create(TRUE);
    Action   := @GetCreated;
  end;

  with ThreadProperty[vlkModified] do
  begin
    Key      := vlkModified;
    Button   := SpeedButtonModified;
    Progress := JvWaitingGradientModified;
    Thread   := TPropertyThread.Create(TRUE);
    Action   := @GetModified;
  end;

  with ThreadProperty[vlkAccessed] do
  begin
    Key      := vlkAccessed;
    Button   := SpeedButtonAccessed;
    Progress := JvWaitingGradientAccessed;
    Thread   := TPropertyThread.Create(TRUE);
    Action   := @GetAccessed;
  end;

  with ThreadProperty[vlkAttributes] do
  begin
    Key      := vlkAttributes;
    Button   := SpeedButtonAttributes;
    Progress := JvWaitingGradientAttributes;
    Thread   := TPropertyThread.Create(TRUE);
    Action   := @GetAttributes;
  end;

  with ThreadProperty[vlkEncoding] do
  begin
    Key      := vlkEncoding;
    Button   := SpeedButtonEncoding;
    Progress := JvWaitingGradientEncoding;
    Thread   := TPropertyThread.Create(TRUE);
    Action   := @GetEncoding;
  end;

  with ThreadProperty[vlkLineEndings] do
  begin
    Key      := vlkLineEndings;
    Button   := SpeedButtonLineEndings;
    Progress := JvWaitingGradientLineEndings;
    Thread   := TPropertyThread.Create(TRUE);
    Action   := @GetLineEndings;
  end;

  with ThreadProperty[vlkChecksumMD5] do
  begin
    Key      := vlkChecksumMD5;
    Button   := SpeedButtonChecksumMD5;
    Progress := JvWaitingGradientChecksumMD5;
    Thread   := TPropertyThread.Create(TRUE);
    Action   := @GetChecksumMD5;
  end;

  JvDriveComboChange(Self);
  JvDirectoryListBoxChange(Self);

  ValueListEditor.Strings.Clear;
  for Key := Low(VALUE_LIST_KEY) to High(VALUE_LIST_KEY) do
  begin
    ValueListEditor.InsertRow(VALUE_LIST_KEY[Key], '', TRUE);
    ThreadProperty[Key].Value  := ValueListEditor;
    if not (Key in [vlkPath, vlkUNCPath, vlkTypeExtension]) then
    begin
      with ThreadProperty[Key] do
      begin

        Progress.Parent         := ValueListEditor;
        Progress.Top            := Button.Top;
        Progress.Left           := ValueListEditor.DefaultColWidth + 3 * ValueListEditor.GridLineWidth;
        Progress.Height         := Button.Height - 2 * ValueListEditor.GridLineWidth;
        Progress.Visible        := FALSE;
        Progress.Interval       := 8;
        Progress.GradientWidth  := 128;
        Progress.StartColor     := clWindow;
        Progress.EndColor       := clHighlight;

        Thread.Output           := '';
        Thread.FilePath         := '';
        Thread.FreeOnTerminate  := FALSE;
        Thread.Action           := Action;
        Thread.Key              := Key;
        Thread.Button           := Button;
        Thread.Progress         := Progress;
        Thread.Value            := Value;
        Thread.OnTerminate      := Thread.Terminate;
        Thread.FileList         := JvFileListBox;
        Thread.DirList          := JvDirectoryListBox;

      end;
    end;
  end;

  // hide selection
  ValueListEditor.Selection := TGridRect(Rect(-1, -1, -1, -1));

  PrevSelectedFile := '';

  // initialize thread counter
  ActiveThreadsLock := CreateMutex(nil, FALSE, PWideChar('SysTool Thread Counter'));
  ActiveThreads := 0;

  for RegExItem := Low(TRegExItem) to High(TRegExItem) do
  begin
    RegEx[RegExItem] := TPerlRegEx.Create;
    with RegEx[RegExItem] do
    begin
      RegEx := REGEX_PATTERN[RegExItem].Key;
      Replacement := REGEX_PATTERN[RegExItem].Val;
      Study;
    end;
  end;

  Self.TabSheetPropertiesSelectedFile := '';
  Self.TabSheetHexDumpSelectedFile := '';

end;

procedure TFormFileAnalysis.FormDestroy(Sender: TObject);
begin

  SaveRegistrySettings;

end;

procedure TFormFileAnalysis.FormResize(Sender: TObject);
begin

  JvPanelCopyTable.Refresh;

end;

procedure TFormFileAnalysis.FormShow(Sender: TObject);
begin

  FormMain.TrayMenuItemStayOnTopClick(nil);

end;

procedure TPropertyThread.Execute;
begin

  IncreaseThreadCount;

  Synchronize(
    procedure
    begin
      FileList.Enabled := FALSE;
      DirList.Enabled := FALSE;
      Button.Visible := FALSE;
      Progress.Restart;
      Progress.Visible := TRUE;
    end);

  Output := Action(FilePath);

  Synchronize(
    procedure
    begin
      Progress.Visible := FALSE;
      Progress.Restart;
      Button.Visible := TRUE;
      Value.Values[VALUE_LIST_KEY[Key]] := Output;
    end);

end;

procedure TPropertyThread.Terminate(Sender: TObject);
begin

  DecreaseThreadCount;

  if 0 = GetThreadCount then
  begin
    FileList.Enabled := TRUE;
    DirList.Enabled := TRUE;
  end;

end;

procedure TFormFileAnalysis.JvDragDropDrop(Sender: TObject; Pos: TPoint; Value: TStrings);
var
  Drive : Char;
  Path  : String;
  Name  : String;
  i     : Integer;

begin

  if 1 > GetThreadCount then
  begin

    if 0 < Value.Count then
    begin

      FileCtrl.ProcessPath(Value[0], Drive, Path, Name);
      JvDriveCombo.Drive := Drive;
      JvDirectoryListBox.Directory := Format('%s:%s', [Drive, Path]);

      if FileExists(Value[0]) then
      begin
        JvFileListBox.ClearSelection;
        JvFileListBox.FileName := Value[0];
        for i := 0 to JvFileListBox.Items.Count - 1 do
        begin
          if 0 = AnsiCompareText(Trim(Name), Trim(JvFileListBox.Items[i])) then
            JvFileListBox.Selected[i] := TRUE;
        end;
      end
      else if DirectoryExists(Value[0]) then
      begin
        JvDirectoryListBoxChange(Sender);
      end;

    end
    else
    begin

    MessageDlg('Invalid file', mtError, [mbOk], 0);

    end;

    Self.SetFocus;

  end
  else
  begin

    MessageDlg('Cannot select new file during analysis', mtError, [mbOk], 0);

  end;

end;

procedure TFormFileAnalysis.JvDriveComboChange(Sender: TObject);
begin

  JvDirectoryListBox.ItemIndex := -1;
  JvDirectoryListBox.Directory := IncludeTrailingPathDelimiter(Format('%s:', [JvDriveCombo.Drive]));
  JvDirectoryListBox.ItemIndex := 0;

end;

procedure TFormFileAnalysis.JvDirectoryListBoxChange(Sender: TObject);
begin


  JvFileListBox.ItemIndex := -1;
  JvFileListBox.Directory := JvDirectoryListBox.Directory;
  EditCurrentDir.Text     := JvDirectoryListBox.Directory;

end;

procedure TFormFileAnalysis.JvFileListBoxChange(Sender: TObject);
begin

  if Self.Visible then
  begin

    if FileExists(JvFileListBox.FileName) and
        (0 <> AnsiCompareText(Trim(PrevSelectedFile), Trim(JvFileListBox.FileName))) then
    begin

      // disable form controls while we perform potentially-lengthy processing
      EnableChildControls(PanelBrowser, FALSE);
      EnableChildControls(EditorHexDump, FALSE);
      EnableChildControls(TabSheetProperties, FALSE, [ValueListEditor]);

      case JvPageControl.TabIndex of

        0: // Properties
          begin
            ShowProperties(JvFileListBox.FileName);
          end;

        1: // Hex Dump
          begin
            ShowHexDump(JvFileListBox.FileName);
          end;

      end;
      PrevSelectedFile := Trim(JvFileListBox.FileName);

      EnableChildControls(TabSheetProperties, TRUE, [ValueListEditor]);
      EnableChildControls(EditorHexDump, TRUE);
      EnableChildControls(PanelBrowser, TRUE);

    end;

  end;

end;

procedure TFormFileAnalysis.JvPageControlChange(Sender: TObject);
begin

  if Self.Visible then
  begin
    if FileExists(PrevSelectedFile) then
    begin
      case JvPageControl.TabIndex of

        0: // Properties
          begin
            if 0 <> AnsiCompareText(Trim(PrevSelectedFile), Trim(TabSheetPropertiesSelectedFile)) then
              ShowProperties(PrevSelectedFile);
          end;

        1: // Hex Dump
          begin
            if 0 <> AnsiCompareText(Trim(PrevSelectedFile), Trim(TabSheetHexDumpSelectedFile)) then
              ShowHexDump(PrevSelectedFile);
          end;

      end;
    end;
  end;

end;

procedure TFormFileAnalysis.CreateParams(var Params: TCreateParams);
begin

  inherited;

  Params.ExStyle    := Params.ExStyle or WS_EX_APPWINDOW;
  Params.WndParent  := GetDesktopWindow;

  Self.PopupParent  := Self;
  Self.PopupMode    := pmExplicit;

end;

procedure TFormFileAnalysis.SetFormStayOnTop(StayOnTop: Boolean);
begin

  Self.FormStyle := fsNormal;
  if StayOnTop then Self.FormStyle := fsStayOnTop
               else Self.FormStyle := fsNormal;

end;

procedure TFormFileAnalysis.ValueListEditorSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
begin

  CanSelect := FALSE;

end;


procedure TFormFileAnalysis.ValueListEditorStringsChange(Sender: TObject);
begin

  JvPanelCopyTable.Refresh;

end;

procedure TFormFileAnalysis.ShowProperties(FilePath: String);
const
  AUTO_HASH_MAX_FILESIZE_BYTES = 1.0e6;

var
  FileSizeStr: String;
  ComputedFileSize: UInt64;

begin

  Self.TabSheetPropertiesSelectedFile := FilePath;

  ValueListEditor.Values[VALUE_LIST_KEY[vlkPath]]          := FilePath;
  ValueListEditor.Values[VALUE_LIST_KEY[vlkUNCPath]]       := GetUNCFilePath(FilePath);
  ValueListEditor.Values[VALUE_LIST_KEY[vlkTypeExtension]] := ExtractFileExt(FilePath);
  ValueListEditor.Values[VALUE_LIST_KEY[vlkTypeInspected]] := GetTypeInspected(FilePath);
  ValueListEditor.Values[VALUE_LIST_KEY[vlkSize]]          := GetSize(FilePath);
  ValueListEditor.Values[VALUE_LIST_KEY[vlkCreated]]       := GetCreated(FilePath);
  ValueListEditor.Values[VALUE_LIST_KEY[vlkModified]]      := GetModified(FilePath);
  ValueListEditor.Values[VALUE_LIST_KEY[vlkAccessed]]      := GetAccessed(FilePath);
  ValueListEditor.Values[VALUE_LIST_KEY[vlkAttributes]]    := GetAttributes(FilePath);
  ValueListEditor.Values[VALUE_LIST_KEY[vlkEncoding]]      := GetEncoding(FilePath);
  ValueListEditor.Values[VALUE_LIST_KEY[vlkLineEndings]]   := GetLineEndings(FilePath);

  // ugly hack- parsing the output file size string instead of recomputing file size on disk
  FileSizeStr := ValueListEditor.Values[VALUE_LIST_KEY[vlkSize]];
  Delete(FileSizeStr, Pos(' bytes', FileSizeStr), 6 { = Length(' bytes')});
  ComputedFileSize := StrToUInt64(FileSizeStr);

  if ComputedFileSize <= AUTO_HASH_MAX_FILESIZE_BYTES then
  begin
    ValueListEditor.Values[VALUE_LIST_KEY[vlkChecksumMD5]] := GetChecksumMD5(FilePath);
  end
  else
  begin
    ValueListEditor.Values[VALUE_LIST_KEY[vlkChecksumMD5]] := CHECKSUM_NOT_COMPUTED;
  end;

end;

procedure TFormFileAnalysis.ShowHexDump(FilePath: String);
const
  XXD_PATH_FROM_APPROOT = 'opt\msys';
  XXD_EXEC_NAME = 'xxd.exe';

var
  WorkingDir: String;
  CommandLine: String;
  CurrentLine: TStrings;
  ConsoleReadBuffer: Integer;

begin

  Self.TabSheetHexDumpSelectedFile := FilePath;

  WorkingDir := GetApplicationExePath() + XXD_PATH_FROM_APPROOT;
  CommandLine := IncludeTrailingPathDelimiter(WorkingDir) + XXD_EXEC_NAME;

  CurrentLine := TStringList.Create;
  ConsoleReadBuffer := 2400;

  EditorHexDump.Clear;
  EditorHexDump.Invalidate;
  EditorHexDump.Lines.BeginUpdate;

  ProgressBarHexDump.Position := 0;
  ProgressBarHexDump.Marquee := TRUE;
  ProgressBarHexDump.MarqueePaused := FALSE;
  ProgressBarHexDump.MarqueeDelay := 0;
  ProgressBarHexDump.MarqueeInterval := 20;
  ProgressBarHexDump.Invalidate;

  PanelHexDumpProgress.Visible := TRUE;

  Self.ContinueHexDump := TRUE;

  CaptureConsoleOutput(CommandLine, Format('"%s"', [FilePath]), ConsoleReadBuffer,
    procedure(const Line: PAnsiChar)
    var
      PrevLine: String;
      CurrLine: String;
      PrevLineLength: Integer;
      CurrLineLength: Integer;
      Start: Integer;
      i: Integer;
//      j: Integer;
//      SelStart: Integer;
//      SelEnd: Integer;

    begin

      CurrentLine.Text := String(Line);

      Start := 0;

      if EditorHexDump.Lines.Count > 1 then
      begin

        PrevLine := EditorHexDump.Lines[EditorHexDump.Lines.Count - 2];
        CurrLine := EditorHexDump.Lines[EditorHexDump.Lines.Count - 1];

        PrevLineLength := Length(PrevLine);
        CurrLineLength := Length(CurrLine);

        if CurrLineLength < PrevLineLength then
        begin

          EditorHexDump.Lines[EditorHexDump.Lines.Count - 1] :=
            CurrLine + LeftStr(CurrentLine[0], PrevLineLength - CurrLineLength);

          Start := 1;

        end;

      end;

      for i := Start to CurrentLine.Count - 1 do
      begin
        EditorHexDump.Lines.Add(CurrentLine[i]);

        {
        // TODO: distinguish line numbers and ASCII columns from the hex data
        SelEnd := Pos(': ', EditorHexDump.Lines[EditorHexDump.Lines.Count - 1]);
        if SelEnd > 0 then
        begin
          EditorHexDump.SelStart := 0;
          EditorHexDump.SelLength := SelEnd - EditorHexDump.SelStart;
          EditorHexDump.SelectRange(0, 0, 5, EditorHexDump.Lines.Count - 1);
        end;
        }

      end;

    end,
    function: Boolean
    begin
      Result := Self.ContinueHexDump;
    end);

  PanelHexDumpProgress.Visible := FALSE;

  EditorHexDump.Lines.EndUpdate;

end;

procedure TFormFileAnalysis.SpeedButtonValueListCopyClick(Sender: TObject);
var
  EditorValue: String;

begin

  EditorValue :=
    Trim(ValueListEditor.Values[VALUE_LIST_KEY[TValueListKey((Sender as TSpeedButton).Tag)]]);

  if 0 <> AnsiCompareText(EditorValue, '') then
  begin
    if 0 <> AnsiCompareText(EditorValue, VALUE_UNIMPLEMENTED_PROPERTY) then
    begin
      Clipboard.AsText := EditorValue;
    end
    else
    begin
      Clipboard.AsText := '';
    end;
  end;

end;

procedure TFormFileAnalysis.SpeedButtonCancelHexDumpClick(Sender: TObject);
begin
  Self.ContinueHexDump := FALSE;
end;

procedure TFormFileAnalysis.SpeedButtonCopyTableClick(Sender: TObject);
var
  Key: TValueListKey;
  EditorValue: String;
  TableValue: String;

begin

  if 0 = AnsiCompareText(ValueListEditor.Values[VALUE_LIST_KEY[vlkChecksumMD5]], CHECKSUM_NOT_COMPUTED) then
  begin
    if mrNo = MessageDlg('MD5 checksum not yet computed. Copy file properties without checksum?',
        mtWarning, [mbYes, mbNo], 0) then
    begin
      Exit;
    end;
  end;

  TableValue := '';
  for Key := Low(VALUE_LIST_KEY) to High(VALUE_LIST_KEY) do
  begin
    EditorValue := Trim(ValueListEditor.Values[VALUE_LIST_KEY[Key]]);
    if 0 <> AnsiCompareText(EditorValue, '') then
    begin
      if (0 <> AnsiCompareText(EditorValue, VALUE_UNIMPLEMENTED_PROPERTY)) and
         (0 <> AnsiCompareText(EditorValue, CHECKSUM_NOT_COMPUTED)) then
      begin
        TableValue :=
          TableValue +
          Format('%s: %s', [VALUE_LIST_KEY[Key], EditorValue]) +
          sLineBreak;
      end;
    end;
  end;

  if 0 <> AnsiCompareText(TableValue, '') then
  begin
    Clipboard.AsText := Trim(TableValue);

    FormMain.JvTrayIcon.BalloonHint(
      'Properties copied to clipboard',
      JvFileListBox.FileName,
      {   Style = } btInfo, { btNone btError btInfo btWarning }
      {   Delay = } 5000,
      {  Cancel = } TRUE
    );

  end;

end;

procedure TFormFileAnalysis.SpeedButtonValueListClick(Sender: TObject);
begin

  if FileExists(JvFileListBox.FileName) then
  begin

    if Sender is TSpeedButton then
    begin

      with ThreadProperty[TValueListKey((Sender as TSpeedButton).Tag)] do
      begin

        // dispatch the thread
        Thread.FilePath := JvFileListBox.FileName;
        Thread.Start;

        // and recreate one to replace it after termination
        Thread := TPropertyThread.Create(TRUE);
        Thread.Output           := '';
        Thread.FilePath         := '';
        Thread.FreeOnTerminate  := FALSE;
        Thread.Action           := Action;
        Thread.Key              := Key;
        Thread.Button           := Button;
        Thread.Progress         := Progress;
        Thread.Value            := Value;
        Thread.OnTerminate      := Thread.Terminate;
        Thread.FileList         := JvFileListBox;
        Thread.DirList          := JvDirectoryListBox;

      end;

    end;

  end
  else
  begin

    //MessageDlg('No file selected', mtError, [mbOk], 0);

  end;

end;

function GetUNCFilePath(FilePath: String): String;
begin
  Result := GetUNCPath(FilePath); // in Global.pas
end;

function GetTypeInspected(FilePath: String): String;
const
  TRID_PATH_FROM_APPROOT = 'opt\trid';
  TRID_EXEC_NAME = 'trid.exe';
  CONSOLE_READ_BUFFER = 2400;

var
  WorkingDir: String;
  CommandLine: String;
  CurrentLine: TStrings;
  Identities: TStringList;

begin

  Result := VALUE_UNIMPLEMENTED_PROPERTY;

  WorkingDir := GetApplicationExePath() + TRID_PATH_FROM_APPROOT;
  CommandLine := IncludeTrailingPathDelimiter(WorkingDir) + TRID_EXEC_NAME;

  CurrentLine := TStringList.Create;
  Identities := TStringList.Create;

  CaptureConsoleOutput(CommandLine, FilePath, CONSOLE_READ_BUFFER,
    procedure(const Line: PAnsiChar)
    var
      UTF8Line: UTF8String;
      i: Integer;
      j: TRegExItem;

    begin
      CurrentLine.Text := String(Line);
      for i := 0 to CurrentLine.Count - 1 do
      begin
        UTF8Line := UTF8String(CurrentLine[i]);
        for j := Low(TRegExItem) to High(TRegExItem) do
        begin
          // only attempt evaluation on the specified items
          if j in [repListBinItem, repListTxtItem, repListErrItem] then
          begin
            RegEx[j].Subject := UTF8Line;
            if RegEx[j].Match then
            begin
              RegEx[j].Replace;
              Identities.Add(String(RegEx[j].Subject));
            end;
          end;
        end;
      end;
    end,
    function: Boolean
    begin
      Result := TRUE; // TBD: add "cancel" button for type inspection
    end);

  if 0 = Identities.Count then Identities.Add('');
  Result := Identities[0];

end;

function GetSize(FilePath: String): String;
begin

  Result := Format('%d bytes', [FileSizeByName(FilePath)]);

end;

function GetCreated(FilePath: String): String;
begin

  Result := Format('%s', [GetFileTime(FilePath, dtaCreated)]);

end;

function GetModified(FilePath: String): String;
begin

  Result := Format('%s', [GetFileTime(FilePath, dtaModified)]);

end;

function GetAccessed(FilePath: String): String;
begin

  Result := Format('%s', [GetFileTime(FilePath, dtaAccessed)]);

end;

{$define use_win32_attributes}
function GetAttributes(FilePath: String): String;
const
  DELIM = ',';

var
  Attrib: Cardinal;

begin

  Result := '';

{$ifdef use_win32_attributes}

  Attrib := GetFileAttributes(PWideChar(FilePath));

  if 0 < (Attrib and FILE_ATTRIBUTE_READONLY) then
    Result := Result + 'READONLY' + DELIM;

  if 0 < (Attrib and FILE_ATTRIBUTE_HIDDEN) then
    Result := Result + 'HIDDEN' + DELIM;

  if 0 < (Attrib and FILE_ATTRIBUTE_SYSTEM) then
    Result := Result + 'SYSTEM' + DELIM;

  if 0 < (Attrib and FILE_ATTRIBUTE_DIRECTORY) then
    Result := Result + 'DIRECTORY' + DELIM;

  if 0 < (Attrib and FILE_ATTRIBUTE_ARCHIVE) then
    Result := Result + 'ARCHIVE' + DELIM;

  if 0 < (Attrib and FILE_ATTRIBUTE_DEVICE) then
    Result := Result + 'DEVICE' + DELIM;

  if 0 < (Attrib and FILE_ATTRIBUTE_NORMAL) then
    Result := Result + 'NORMAL' + DELIM;

  if 0 < (Attrib and FILE_ATTRIBUTE_TEMPORARY) then
    Result := Result + 'TEMPORARY' + DELIM;

  if 0 < (Attrib and FILE_ATTRIBUTE_SPARSE_FILE) then
    Result := Result + 'SPARSE_FILE' + DELIM;

  if 0 < (Attrib and FILE_ATTRIBUTE_REPARSE_POINT) then
    Result := Result + 'REPARSE_POINT' + DELIM;

  if 0 < (Attrib and FILE_ATTRIBUTE_COMPRESSED) then
    Result := Result + 'COMPRESSED' + DELIM;

  if 0 < (Attrib and FILE_ATTRIBUTE_OFFLINE) then
    Result := Result + 'OFFLINE' + DELIM;

  if 0 < (Attrib and FILE_ATTRIBUTE_NOT_CONTENT_INDEXED) then
    Result := Result + 'NOT_CONTENT_INDEXED' + DELIM;

  if 0 < (Attrib and FILE_ATTRIBUTE_ENCRYPTED) then
    Result := Result + 'ENCRYPTED' + DELIM;

  if 0 < (Attrib and FILE_ATTRIBUTE_VIRTUAL) then
    Result := Result + 'VIRTUAL' + DELIM;

{$else}

  Attrib := FileGetAttr(FilePath);

  if 0 < (Attrib and faReadOnly) then
    Result := Result + 'READONLY' + DELIM;

  if 0 < (Attrib and faHidden) then
    Result := Result + 'HIDDEN' + DELIM;

  if 0 < (Attrib and faSysFile) then
    Result := Result + 'SYSTEM' + DELIM;

  if 0 < (Attrib and faVolumeID) then
    Result := Result + 'VOLUMEID' + DELIM;

  if 0 < (Attrib and faDirectory) then
    Result := Result + 'DIRECTORY' + DELIM;

  if 0 < (Attrib and faArchive) then
    Result := Result + 'ARCHIVE' + DELIM;

  if 0 < (Attrib and faSymLink) then
    Result := Result + 'SYMLINK' + DELIM;

{$endif}

  if (Length(Result) > 0) and (Result[Length(Result)] = DELIM) then
  begin
    Delete(Result, Length(Result), Length(DELIM));
  end;

end;

//{$define use_chsdet}
function GetEncoding(FilePath: String): String;
begin

  Result := VALUE_UNIMPLEMENTED_PROPERTY;

end;

function GetLineEndings(FilePath: String): String;
begin

  Result := VALUE_UNIMPLEMENTED_PROPERTY;

end;

function GetChecksumMD5(FilePath: String): String;
var
  FileStream: TFileStream;
  MD5: TIdHashMessageDigest5;

begin

  Result := '';

  MD5 := TIdHashMessageDigest5.Create;
  FileStream := TFileStream.Create(FilePath, fmOpenRead or fmShareDenyWrite);

  try

    try

      Result := MD5.HashStreamAsHex(FileStream);

    except
      on Ex: Exception do
      begin
        ShowMessage(Ex.Message);
      end;

    end;

  finally
    FreeAndNil(FileStream);
    FreeAndNil(MD5);

  end;

end;

end.
