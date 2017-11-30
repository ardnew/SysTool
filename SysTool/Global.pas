unit Global;

interface

uses
  // Delphi/Windows
  Windows, Forms, Registry, Variants, Classes, Controls,
  // TPerlRegEx
  PerlRegEx
  ;

{==================================================================================================}

const
  APPLICATION_NAME    = 'SysTool';
  APPLICATION_VERSION = 1;

type
  TSysToolModule = ( stmNone = -1, stmBitPattern, stmFileAnalysis, stmConvertPathLocalUNC, stmConvertPathUNCLocal );

{==================================================================================================}

type
  TCommandLineSwitch = ( clsNone = -1, clsStartupNoMenu, clsStartupSilent );

const
  COMMAND_LINE_SWITCH_PREFIX = [ '-', '/' ];
  COMMAND_LINE_SWITCH_STR: array[TCommandLineSwitch] of String =
  (
    '',       // clsNone
    'nomenu', // clsStartupNoMenu
    'silent'  // clsStartupSilent
  );

{==================================================================================================}

const
  V_NULL = $00000000;

type
  TUTF8StringPair = record
    Key: UTF8String;
    Val: UTF8String;
  end;

{==================================================================================================}

type
  TRegistryKey = record
    KeyName: String;
    KeyType: Integer; // variant type mask
    Default: String;
  end;

function GetRegistryKeyValue(
  const Root: HKEY; const Path: String; const Key: TRegistryKey; out Value: Variant): Boolean; overload;
function GetRegistryKeyValue(
  const Key: TRegistryKey; out Value: Variant): Boolean; overload;

function SetRegistryKeyValue(
  const Root: HKEY; const Path: String; const Key: TRegistryKey; const Value: Variant): Boolean; overload;
function SetRegistryKeyValue(
  const Key: TRegistryKey; const Value: Variant): Boolean; overload;

procedure ShowRegistryAccessErrorDialog(const ModeID: Cardinal; const Key: TRegistryKey);

const
  REGKEY_ROOT_DEFAULT = HKEY_CURRENT_USER;
  REGKEY_PATH_DEFAULT = '\Software\Aircraft Performance Systems\';

  REGKEY_COMMON_STAY_ON_TOP : TRegistryKey = ( KeyName: 'Common_StayOnTop'; KeyType: varBoolean; Default: 'FALSE' );

  REGKEY_FORMBITPATTERN_FORM_X      : TRegistryKey = ( KeyName: 'FormBitPattern_X';      KeyType: varInteger; Default: '120' );
  REGKEY_FORMBITPATTERN_FORM_Y      : TRegistryKey = ( KeyName: 'FormBitPattern_Y';      KeyType: varInteger; Default: '120' );
  REGKEY_FORMBITPATTERN_FORM_WIDTH  : TRegistryKey = ( KeyName: 'FormBitPattern_Width';  KeyType: varInteger; Default: '735' );
  REGKEY_FORMBITPATTERN_FORM_HEIGHT : TRegistryKey = ( KeyName: 'FormBitPattern_Height'; KeyType: varInteger; Default: '768' );
  REGKEY_FORMBITPATTERN_GROUP_BASES : TRegistryKey = ( KeyName: 'FormBitPattern_Groups'; KeyType: varBoolean; Default: 'False' );

  REGKEY_FORMFILEANALYSIS_FORM_X          : TRegistryKey = ( KeyName: 'FormFileAnalysis_X';             KeyType: varInteger; Default: '120' );
  REGKEY_FORMFILEANALYSIS_FORM_Y          : TRegistryKey = ( KeyName: 'FormFileAnalysis_Y';             KeyType: varInteger; Default: '120' );
  REGKEY_FORMFILEANALYSIS_FORM_WIDTH      : TRegistryKey = ( KeyName: 'FormFileAnalysis_Width';         KeyType: varInteger; Default: '800' );
  REGKEY_FORMFILEANALYSIS_FORM_HEIGHT     : TRegistryKey = ( KeyName: 'FormFileAnalysis_Height';        KeyType: varInteger; Default: '420' );
  REGKEY_FORMFILEANALYSIS_BROWSER_WIDTH   : TRegistryKey = ( KeyName: 'FormFileAnalysis_BrowserWidth';  KeyType: varInteger; Default: '260' );
  REGKEY_FORMFILEANALYSIS_DIR_LIST_HEIGHT : TRegistryKey = ( KeyName: 'FormFileAnalysis_DirListHeight'; KeyType: varInteger; Default: '132' );

{==================================================================================================}

type
  TSessionVarID = ( svUser, svHost );
  TSessionVarQuery = record
    BufferSize: Cardinal;
    Subroutine: function(lpBuffer: PWideChar; var nSize: DWORD): BOOL; stdcall;
  end;

{==================================================================================================}

type
  TCommonRegExMatchType = ( creFilePath );
  TCommonRegExMatch = record
    Instance: TPerlRegEx;
    Options: TPerlRegExOptions;
    Pattern: UTF8String;
  end;

var
  CommonRegExMatch: array[TCommonRegExMatchType] of TCommonRegExMatch =
  (
    ( // creFilePath
      Instance: nil;
      Options: [ preCaseLess, preSingleLine, preExtended ];
      Pattern: '^(?:(?:[a-z]:|\\\\[a-z0-9_.$\-]+\\[a-z0-9_.$\-]+)\\|\\?[^\\/:*?"<>|\r\n]+\\?)(?:[^\\/:*?"<>|\r\n]+\\)*[^\\/:*?"<>|\r\n]*$';
    )
  );

function GetSpecialPath(const PathID: Cardinal): String; overload;
function GetSpecialPath(const Owner: Cardinal; const PathID: Cardinal): String; overload;
function GetUNCPath(const LocalPath: String): String;
function GetLocalPath(const UNCPath: String): String;
function PromptForFileOrDir(Title: String): String;
function GetSessionKey(const Key: TSessionVarID): String;
function GetSessionIdentifier(): String;
function GetApplicationNameString(): String;
function GetApplicationVersionString(): String;
function GetApplicationNameVersionString(): String;
function GetApplicationExePath(): String;
function GetCurrentDateTimeString(): String;
function GetCommandLineSwitch(const Switch: TCommandLineSwitch): Boolean;
function IsMatch(const Subject: String; const RegEx: TCommonRegExMatchType): Boolean;
procedure EnableChildControls(const Control: TWinControl; const Enable: Boolean; const EnableSelf: Boolean; const Ignore: array of TWinControl); overload;
procedure EnableChildControls(const Control: TWinControl; const Enable: Boolean; const Ignore: array of TWinControl); overload;
procedure EnableChildControls(const Control: TWinControl; const Enable: Boolean; const EnableSelf: Boolean); overload;
procedure EnableChildControls(const Control: TWinControl; const Enable: Boolean); overload;
procedure DebugLog(const Formatting: String; const Data: array of const);

type // callback typedefs
  TProcedureArg<T> = reference to procedure(const Arg: T);
  TAssertion = reference to function: Boolean;

function TryCloseConsoleProcess(hHwnd: HWND; dwData: LPARAM): Boolean; stdcall;
procedure CloseConsoleProcess(ProcessInfo: TProcessInformation);
procedure CaptureConsoleOutput(const ACommand, AParameters: String; const CReadBuffer: Cardinal;
  const HandleOutput: TProcedureArg<PAnsiChar>;
  const ContinueProcess: TAssertion);

const
  MAX_USERNAME_LENGTH = $0100; // Size field from UNLEN constant in LMCons.h
  SESSION_KEY_QUERY : array[TSessionVarID] of TSessionVarQuery =
    (
      ( BufferSize: MAX_USERNAME_LENGTH;     Subroutine: Windows.GetUserName ),
      ( BufferSize: MAX_COMPUTERNAME_LENGTH; Subroutine: Windows.GetComputerName )
    );

const
  CSIDL_DESKTOP                       = $0000; { <desktop> }
  CSIDL_INTERNET                      = $0001; { Internet Explorer (icon on desktop) }
  CSIDL_PROGRAMS                      = $0002; { Start Menu\Programs }
  CSIDL_CONTROLS                      = $0003; { My Computer\Control Panel }
  CSIDL_PRINTERS                      = $0004; { My Computer\Printers }
  CSIDL_PERSONAL                      = $0005; { My Documents.  This is equivalent to CSIDL_MYDOCUMENTS in XP and above }
  CSIDL_FAVORITES                     = $0006; { <user name>\Favorites }
  CSIDL_STARTUP                       = $0007; { Start Menu\Programs\Startup }
  CSIDL_RECENT                        = $0008; { <user name>\Recent }
  CSIDL_SENDTO                        = $0009; { <user name>\SendTo }
  CSIDL_BITBUCKET                     = $000a; { <desktop>\Recycle Bin }
  CSIDL_STARTMENU                     = $000b; { <user name>\Start Menu }
  CSIDL_MYDOCUMENTS                   = $000c; { logical "My Documents" desktop icon }
  CSIDL_MYMUSIC                       = $000d; { "My Music" folder }
  CSIDL_MYVIDEO                       = $000e; { "My Video" folder }
  CSIDL_DESKTOPDIRECTORY              = $0010; { <user name>\Desktop }
  CSIDL_DRIVES                        = $0011; { My Computer }
  CSIDL_NETWORK                       = $0012; { Network Neighborhood (My Network Places) }
  CSIDL_NETHOOD                       = $0013; { <user name>\nethood }
  CSIDL_FONTS                         = $0014; { windows\fonts }
  CSIDL_TEMPLATES                     = $0015;
  CSIDL_COMMON_STARTMENU              = $0016; { All Users\Start Menu }
  CSIDL_COMMON_PROGRAMS               = $0017; { All Users\Start Menu\Programs }
  CSIDL_COMMON_STARTUP                = $0018; { All Users\Startup }
  CSIDL_COMMON_DESKTOPDIRECTORY       = $0019; { All Users\Desktop }
  CSIDL_APPDATA                       = $001a; { <user name>\Application Data }
  CSIDL_PRINTHOOD                     = $001b; { <user name>\PrintHood }
  CSIDL_LOCAL_APPDATA                 = $001c; { <user name>\Local Settings\Application Data (non roaming) }
  CSIDL_ALTSTARTUP                    = $001d; { non localized startup }
  CSIDL_COMMON_ALTSTARTUP             = $001e; { non localized common startup }
  CSIDL_COMMON_FAVORITES              = $001f;
  CSIDL_INTERNET_CACHE                = $0020;
  CSIDL_COOKIES                       = $0021;
  CSIDL_HISTORY                       = $0022;
  CSIDL_COMMON_APPDATA                = $0023; { All Users\Application Data }
  CSIDL_WINDOWS                       = $0024; { GetWindowsDirectory() }
  CSIDL_SYSTEM                        = $0025; { GetSystemDirectory() }
  CSIDL_PROGRAM_FILES                 = $0026; { C:\Program Files }
  CSIDL_MYPICTURES                    = $0027; { C:\Program Files\My Pictures }
  CSIDL_PROFILE                       = $0028; { USERPROFILE }
  CSIDL_SYSTEMX86                     = $0029; { x86 system directory on RISC }
  CSIDL_PROGRAM_FILESX86              = $002a; { x86 C:\Program Files on RISC }
  CSIDL_PROGRAM_FILES_COMMON          = $002b; { C:\Program Files\Common }
  CSIDL_PROGRAM_FILES_COMMONX86       = $002c; { x86 C:\Program Files\Common on RISC }
  CSIDL_COMMON_TEMPLATES              = $002d; { All Users\Templates }
  CSIDL_COMMON_DOCUMENTS              = $002e; { All Users\Documents }
  CSIDL_COMMON_ADMINTOOLS             = $002f; { All Users\Start Menu\Programs\Administrative Tools }
  CSIDL_ADMINTOOLS                    = $0030; { <user name>\Start Menu\Programs\Administrative Tools }
  CSIDL_CONNECTIONS                   = $0031; { Network and Dial-up Connections }
  CSIDL_COMMON_MUSIC                  = $0035; { All Users\My Music }
  CSIDL_COMMON_PICTURES               = $0036; { All Users\My Pictures }
  CSIDL_COMMON_VIDEO                  = $0037; { All Users\My Video }
  CSIDL_RESOURCES                     = $0038; { Resource Directory }
  CSIDL_RESOURCES_LOCALIZED           = $0039; { Localized Resource Directory }
  CSIDL_COMMON_OEM_LINKS              = $003a; { Links to All Users OEM specific apps }
  CSIDL_CDBURN_AREA                   = $003b; { USERPROFILE\Local Settings\Application Data\Microsoft\CD Burning }
  CSIDL_COMPUTERSNEARME               = $003d; { Computers Near Me (computered from Workgroup membership) }
  CSIDL_PROFILES                      = $003e;

{==================================================================================================}

type
  TNumberType = ( ntNONE, ntByte, ntShortInt, ntWord, ntSmallInt, ntCardinal, ntInteger, ntUInt64, ntInt64, ntSingle, ntDouble );
const
  BITS_IN_TYPE: array[TNumberType] of Byte =
  (
    0,  // ntNONE
    8,  // ntByte
    8,  // ntShortInt
    16, // ntWord
    16, // ntSmallInt
    32, // ntCardinal
    32, // ntInteger
    64, // ntUInt64
    64, // ntInt64
    32, // ntSingle
    64  // ntDouble
  );

const
  TYPE_8_BIT  = [ ntByte, ntShortInt ];
  TYPE_16_BIT = [ ntWord, ntSmallInt ];
  TYPE_32_BIT = [ ntCardinal, ntInteger, ntSingle ];
  TYPE_64_BIT = [ ntUInt64, ntInt64, ntDouble ];
  TYPE_FLOAT  = [ ntSingle, ntDouble ];
  TYPE_SIGNED = [ ntShortInt, ntSmallInt, ntInteger, ntInt64 ];

function BinaryString(Value: UInt64; Width: Byte): String;
function UInt64ToOct(Value: UInt64; Width: Byte): String;
function RemoveLeadingZeros(const Value: String): String;
function TryStrToUInt64(SValue: String; var UValue: UInt64): Boolean;
function StrToUInt64(Value: String): UInt64;
function IsValidIntOfType(IntType: TNumberType; ValueAddress: Pointer): Boolean;
function GroupCharsL2R(SValue: String; Width: Byte): String;
function GroupCharsR2L(SValue: String; Width: Byte): String;
function StripAllWhitespace(SValue: String): String;

{==================================================================================================}

implementation

uses
  // Delphi/Windows
  SysUtils, StrUtils, ShlObj, ShLwApi, Messages, Dialogs, Character;

function GetSpecialPath(const PathID: Cardinal): String;
const
  DEFAULT_OWNER_ID = 0;

begin
  Result := GetSpecialPath(DEFAULT_OWNER_ID, PathID);
end;

function GetSpecialPath(const Owner: Cardinal; const PathID: Cardinal): String;
var
  Length: Cardinal;

begin
  Length := MAX_PATH - 1;
  Result := StringOfChar(Char(V_NULL), Length);
  SHGetSpecialFolderPath(Owner, PWideChar(Result), PathID, False);
  Result := Trim(Result);
end;

function GetUNCPath(const LocalPath: String): String;
var
  PromptedPath: String;
  CanonicalPath: array[0 .. MAX_PATH - 1] of Char;

begin

  Result := '';

  // verify the string is somewhat passable as a (Windows) file path
  if IsMatch(LocalPath, creFilePath) then
  begin
    if PathIsRelative(PChar(LocalPath)) then
    begin
      PathCanonicalize(@CanonicalPath[0], PChar(LocalPath));
      Result := CanonicalPath;
    end
    else
    begin
      // returns local path for local drives, UNC path for network drives
      Result := ExpandUNCFileName(LocalPath);
    end;
  end
  else
  begin
    // prompt for filepath
    PromptedPath := PromptForFileOrDir('Select file or directory...');
    if FileExists(PromptedPath) or DirectoryExists(PromptedPath) then
      Result := GetUNCPath(PromptedPath);
  end;

end;

function GetLocalPath(const UNCPath: String): String;
var
  PromptedPath: String;
  CanonicalPath: array[0 .. MAX_PATH - 1] of Char;
  ShareName: String;
  CurrDrive: Char;
  R: TPerlRegEx;

begin

  Result := '';
  
  // verify the string is somewhat passable as a (Windows) file path
  if IsMatch(UNCPath, creFilePath) then
  begin
    if PathIsRelative(PChar(UNCPath)) then
    begin
      PathCanonicalize(@CanonicalPath[0], PChar(UNCPath));
      Result := CanonicalPath;
    end
    else
    begin
      R := TPerlRegex.Create;
      // step through each drive letter and get its fully-qual'd UNC name
      for CurrDrive := 'A' to 'Z' do
      begin
        // if this drive is currently mapped and identified as a remote resource
        case GetDriveType(PChar(CurrDrive + ':\')) of
          DRIVE_REMOTE:
            begin
              // compare our local path's fully-qual'd UNC name to this drive's
              ShareName     := ExpandUNCFileName(CurrDrive + ':\');
              R.Subject     := UTF8String(UNCPath);
              R.Regex       := UTF8String(TPerlRegEx.EscapeRegExChars(ShareName)); // match pattern
              R.Replacement := UTF8String(CurrDrive + ':\');
              // and replace the share name with the current drive letter
              if R.Match then
              begin
                R.Replace;
                Result := Trim(String(R.Subject));
                break;
              end;
            end;
        end;
      end;
    end;
  end
  else
  begin
    // prompt for filepath
    PromptedPath := PromptForFileOrDir('Select file or directory...');
    if FileExists(PromptedPath) or DirectoryExists(PromptedPath) then
      Result := GetLocalPath(PromptedPath);
  end;

end;

function GetSessionKey(const Key: TSessionVarID): String;
var
  Length: Cardinal;

begin
  Length := SESSION_KEY_QUERY[Key].BufferSize;
  Result := StringOfChar(Char(V_NULL), Length);
  SESSION_KEY_QUERY[Key].Subroutine(PChar(Result), Length);
  Result := Trim(Result);
end;

function GetSessionIdentifier(): String;
begin
  Result := Format('%s@%s',
    [
      GetSessionKey(svUser),
      GetSessionKey(svHost)
    ]);
end;

function GetApplicationNameString(): String;
begin
  Result := Format('%s',
    [
      APPLICATION_NAME
    ]);
end;

function GetApplicationVersionString(): String;
begin
  Result := Format('v%d',
    [
      APPLICATION_VERSION
    ]);
end;

function GetApplicationNameVersionString(): String;
begin
  Result := Format('%s %s',
    [
      GetApplicationNameString(),
      GetApplicationVersionString()
    ]);
end;

function GetApplicationExePath(): String;
begin
  Result := Format('%s', [ExtractFilePath(Application.ExeName)]);
end;

function GetCurrentDateTimeString(): String;
begin
  Result := DateTimeToStr(Now);
end;

function GetCommandLineSwitch(const Switch: TCommandLineSwitch): Boolean;
begin
  Result := FindCmdLineSwitch(
    COMMAND_LINE_SWITCH_STR[Switch], COMMAND_LINE_SWITCH_PREFIX, FALSE{IgnoreCase});
end;

function IsMatch(const Subject: String; const RegEx: TCommonRegExMatchType): Boolean;
begin
  if not Assigned(CommonRegExMatch[RegEx].Instance) then
  begin
    CommonRegExMatch[RegEx].Instance := TPerlRegex.Create;
    CommonRegExMatch[RegEx].Instance.Regex := CommonRegExMatch[RegEx].Pattern;
    CommonRegExMatch[RegEx].Instance.Options := CommonRegExMatch[RegEx].Options;
    CommonRegExMatch[RegEx].Instance.Study;
  end;
  CommonRegExMatch[RegEx].Instance.Subject := UTF8String(Subject);
  Result := CommonRegExMatch[RegEx].Instance.Match;
end;

procedure EnableChildControls(const Control: TWinControl; const Enable: Boolean; const EnableSelf: Boolean; const Ignore: array of TWinControl);
var
  Child: TWinControl;
  IgnoreCount: Integer;
  Ignored: Boolean;
  i: Integer;
  j: Integer;

begin
  IgnoreCount := Length(Ignore);
  for i := 0 to Control.ControlCount - 1 do
  begin

    Ignored := FALSE;
    for j := 0 to IgnoreCount - 1 do
      Ignored := Ignored or (Control.Controls[i] = Ignore[j]);

    if not Ignored then
    try
      Child := Control.Controls[i] as TWinControl;
      EnableChildControls(Child, Enable, Enable{do NOT pass EnableSelf to children!}, Ignore);
      Child.Enabled := Enable;
    except
      on Ex: EInvalidCast do
      begin
        Continue;
      end;
    end;

  end;
  Control.Enabled := EnableSelf;
end;

procedure EnableChildControls(const Control: TWinControl; const Enable: Boolean; const Ignore: array of TWinControl);
begin
  EnableChildControls(Control, Enable, Enable, Ignore);
end;

procedure EnableChildControls(const Control: TWinControl; const Enable: Boolean; const EnableSelf: Boolean);
begin
  EnableChildControls(Control, Enable, EnableSelf, []);
end;

procedure EnableChildControls(const Control: TWinControl; const Enable: Boolean);
begin
  EnableChildControls(Control, Enable, Enable, []);
end;

procedure DebugLog(const Formatting: String; const Data: array of const);
begin
  OutputDebugString(PWideChar(Format(Formatting, Data)));
end;

function TryCloseConsoleProcess(hHwnd: HWND; dwData: LPARAM): Boolean; stdcall;
var
  dID: DWORD;

begin

  GetWindowThreadProcessID(hHwnd, @dID);
  if dID = DWORD(dwData) then
  begin
    PostMessage(hHwnd, WM_CLOSE, 0, 0); // graceful request to DIE IN A FIRE
    Result := FALSE;
  end
  else
  begin
    Result := TRUE;
  end;

end;

procedure CloseConsoleProcess(ProcessInfo: TProcessInformation);
var
  vExitCode: UINT;

begin

  GetExitCodeProcess(ProcessInfo.hProcess, vExitCode);

  if STILL_ACTIVE = vExitCode then
  begin
    EnumWindows(@TryCloseConsoleProcess, ProcessInfo.dwProcessId);
    if WAIT_OBJECT_0 <> WaitForSingleObject(ProcessInfo.hProcess, 100) then
    begin
      if not TerminateProcess(ProcessInfo.hProcess, 0) then
      begin
        // didn't close!
      end;
    end;
  end;
  CloseHandle(ProcessInfo.hProcess);
  CloseHandle(ProcessInfo.hThread);

end;

//
// procedure CaptureConsoleOutput taken from:
//   http://thundaxsoftware.blogspot.co.uk/2012/12/capturing-console-output-with-delphi.html
//
// author: Jordi Corbilla
// retrieved: 01 December 2014
//
// changes:
//   - changed read buffer size from constant to function parameter
//   - added callback to provide caller a way to kill the process
//
procedure CaptureConsoleOutput(
  const ACommand, AParameters: String;
  const CReadBuffer: Cardinal;
  const HandleOutput: TProcedureArg<PAnsiChar>;
  const ContinueProcess: TAssertion);
var
  saSecurity : TSecurityAttributes;
  hRead      : THandle;
  hWrite     : THandle;
  suiStartup : TStartupInfo;
  piProcess  : TProcessInformation;
  dRead      : DWORD;
  dRunning   : DWORD;
  dAvailable : DWORD;
  pBuffer    : array of AnsiChar;
  dBuffer    : array of AnsiChar;
  bContinue  : Boolean;

begin

  SetLength(pBuffer, CReadBuffer);
  SetLength(dBuffer, CReadBuffer);

  saSecurity.nLength := SizeOf(TSecurityAttributes);
  saSecurity.bInheritHandle := true;
  saSecurity.lpSecurityDescriptor := nil;

  if CreatePipe(hRead, hWrite, @saSecurity, 0) then
  begin

    try
      FillChar(suiStartup, SizeOf(TStartupInfo), #0);
      suiStartup.cb := SizeOf(TStartupInfo);
      suiStartup.hStdInput := hRead;
      suiStartup.hStdOutput := hWrite;
      suiStartup.hStdError := hWrite;
      suiStartup.dwFlags := STARTF_USESTDHANDLES or STARTF_USESHOWWINDOW;
      suiStartup.wShowWindow := SW_HIDE;

      if CreateProcess(
            nil,                                  // lpApplicationName
            PChar(ACommand + ' ' + AParameters),  // lpCommandLine
            @saSecurity,                          // lpProcessAttributes
            @saSecurity,                          // lpThreadAttributes
            TRUE,                                 // bInheritHandles
            NORMAL_PRIORITY_CLASS,                // dwCreationFlags
            nil,                                  // lpEnvironment
            nil,                                  // lpCurrentDirectory
            suiStartup,                           // lpStartupInfo
            piProcess                             // lpProcessInformation
        )
        then try
          repeat

            dRunning := WaitForSingleObject(piProcess.hProcess, 100);
            PeekNamedPipe(hRead, nil, 0, nil, @dAvailable, nil);

            bContinue := TRUE;

            if (dAvailable > 0) then
            begin
              repeat
                dRead := 0;
                ReadFile(hRead, pBuffer[0], CReadBuffer, dRead, nil);
                pBuffer[dRead] := #0;
                OemToCharA(PAnsiChar(pBuffer), PAnsiChar(dBuffer));
                HandleOutput(PAnsiChar(dBuffer));
                bContinue := ContinueProcess;
              until not bContinue or (dRead < CReadBuffer);
            end;

            Application.ProcessMessages;

          until not bContinue or (dRunning <> WAIT_TIMEOUT);

        finally
          CloseConsoleProcess(piProcess);
        end;

    finally
      CloseHandle(hRead);
      CloseHandle(hWrite);
    end;

  end;

end;

function BinaryString(Value: UInt64; Width: Byte): String;
begin
  Result := '';
  while Width > 0 do
  begin
    Dec(Width);
    Result := Result + IntToStr((Value shr Width) and 1);
  end;
end;

function PromptForFileOrDir(Title: String): String;
var
  BrowseInfo   : TBrowseInfo;
  ItemID       : PItemIDList;
  DisplayName  : array[0 .. MAX_PATH - 1] of Char;
  SelectedPath : array[0 .. MAX_PATH - 1] of Char;

begin

  Result := '';

  FillChar(BrowseInfo, sizeof(BrowseInfo), #0);
  with BrowseInfo do
  begin
    hwndOwner      := Application.Handle;
    pszDisplayName := @DisplayName;
    lpszTitle      := PChar(Title);
    ulFlags        := BIF_BROWSEINCLUDEFILES;
  end;

  ItemID := SHBrowseForFolder(BrowseInfo);
  if ItemID <> nil then
  begin
    SHGetPathFromIDList(ItemID, SelectedPath);
    Result := SelectedPath;
    GlobalFreePtr(ItemID);
  end;

end;

function UInt64ToOct(Value: UInt64; Width: Byte): String;
var
  Rem: UInt64;

begin
  Result := '';
  while Value > 0 do
  begin
    Rem   := Value mod 8;
    Value := Value div 8;
    Result := Format('%d%s', [Rem, Result]);
  end;
  while Length(Result) < Width do
  begin
    Result := Format('0%s', [Result]);
  end;
end;

function RemoveLeadingZeros(const Value: String): String;
var
  i: Integer;

begin
  for i := 1 to Length(Value) do
  begin
    if Value[i] <> '0' then
    begin
      Result := Copy(Value, i, MaxInt);
      Exit;
    end;
  end;
  Result := '';
end;

function TryStrToUInt64(SValue: String; var UValue: UInt64): Boolean;
var
  Start: Integer;
  Base: Integer;
  Digit: Integer;
  n: Integer;
  Nextvalue: UInt64;

begin

  Result := FALSE;
  Digit  := 0;
  Base   := 10;
  Start  := 1;
  SValue := Trim(UpperCase(SValue));

  if (SValue = '') or (SValue[1] = '-') then Exit;

  if SValue[1] = '$' then
  begin
    Base  := 16;
    Start := 2;
    // $+16 hex digits = max hex length.
    if Length(SValue) > 17 then Exit;
  end;

  UValue := 0;
  for n := Start to Length(SValue) do
  begin
      if Character.IsDigit(SValue[n]) then
        Digit := Ord(SValue[n]) - Ord('0')
      else if (Base = 16) and (SValue[n] >= 'A') and (SValue[n] <= 'F') then
        Digit := (Ord(SValue[n]) - Ord('A')) + 10
      else
        Exit; // invalid digit.

      NextValue := (UValue * Base) + Digit;
      if (NextValue < UValue) then Exit;
      UValue := NextValue;
  end;
  Result := TRUE; // success.

end;

function StrToUInt64(Value: String): UInt64;
begin

  if not TryStrToUInt64(Value, Result) then
    raise EConvertError.Create('Invalid UInt64 value');

end;

function IsValidIntOfType(IntType: TNumberType; ValueAddress: Pointer): Boolean;
var
  MaxSigned,   MinSigned   : Int64;
  MaxUnsigned, MinUnsigned : UInt64;

begin

  Result := FALSE;

  if not (IntType in TYPE_FLOAT) then
  begin

    MaxSigned   :=  Int64( ( UInt64(1) shl (BITS_IN_TYPE[IntType] - 1) ) - 1 );
    MinSigned   := -Int64( ( UInt64(1) shl (BITS_IN_TYPE[IntType] - 1) )     );
    MaxUnsigned := UInt64( ( UInt64(1) shl (BITS_IN_TYPE[IntType]    ) ) - 1 );
    MinUnsigned := 0;

    case IntType of
      ntByte:
        //Result := Value = (Value and $00000000000000FF);
        Result := (Byte(ValueAddress^) >= MinUnsigned) and (Byte(ValueAddress^) <= MaxUnsigned);

      ntShortInt:
        //Result := Value = (Value and $00000000000000FF);
        Result := (ShortInt(ValueAddress^) >= MinSigned) and (ShortInt(ValueAddress^) <= MaxSigned);

      ntWord:
        //Result := Value = (Value and $000000000000FFFF);
        Result := (Word(ValueAddress^) >= MinUnsigned) and (Word(ValueAddress^) <= MaxUnsigned);

      ntSmallInt:
        //Result := Value = (Value and $000000000000FFFF);
        Result := (SmallInt(ValueAddress^) >= MinSigned) and (SmallInt(ValueAddress^) <= MaxSigned);

      ntCardinal:
        //Result := Value = (Value and $00000000FFFFFFFF);
        Result := (Cardinal(ValueAddress^) >= MinUnsigned) and (Cardinal(ValueAddress^) <= MaxUnsigned);

      ntInteger:
        //Result := Value = (Value and $00000000FFFFFFFF);
        Result := (Integer(ValueAddress^) >= MinSigned) and (Integer(ValueAddress^) <= MaxSigned);

      ntUInt64:
        //Result := Value = (Value and $FFFFFFFFFFFFFFFF);
        Result := (UInt64(ValueAddress^) >= MinUnsigned) and (UInt64(ValueAddress^) <= MaxUnsigned);

      ntInt64:
        //Result := Value = (Value and $FFFFFFFFFFFFFFFF);
        Result := (Int64(ValueAddress^) >= MinSigned) and (Int64(ValueAddress^) <= MaxSigned);

    end;

  end;

end;

function GroupCharsL2R(SValue: String; Width: Byte): String;
var
  R: TPerlRegEx;

begin

  R := TPerlRegex.Create;

  R.Subject     := UTF8String(SValue);
  R.Regex       := UTF8String(Format('(.{%d})', [Width])); // match pattern
  R.Replacement := UTF8String('\1 ');
  R.ReplaceAll;

  Result := Trim(String(R.Subject));

end;

function GroupCharsR2L(SValue: String; Width: Byte): String;
begin

  Result := ReverseString(GroupCharsL2R(ReverseString(SValue), Width));

end;

function StripAllWhitespace(SValue: String): String;
var
  R: TPerlRegEx;

begin

  R := TPerlRegex.Create;

  R.Subject     := UTF8String(SValue);
  R.Regex       := UTF8String('\s'); // match pattern
  R.Replacement := UTF8String('');
  R.ReplaceAll;

  Result := String(R.Subject);

end;

function GetRegistryKeyValue(
  const Root: HKEY; const Path: String; const Key: TRegistryKey; out Value: Variant): Boolean;
var
  Registry: TRegistry;

begin

  try
    Registry := TRegistry.Create(KEY_READ);
    try
      Registry.RootKey := Root;
      if Registry.OpenKey(Path, TRUE) then
      begin
        case Key.KeyType of
          varBoolean:
            if Registry.ValueExists(Key.KeyName) then Value := Registry.ReadBool(Key.KeyName)
                                                 else Value := SysUtils.StrToBool(Key.Default);
          varInteger:
            if Registry.ValueExists(Key.KeyName) then Value := Registry.ReadInteger(Key.KeyName)
                                                 else Value := SysUtils.StrToInt(Key.Default);
          varDouble:
            if Registry.ValueExists(Key.KeyName) then Value := Registry.ReadFloat(Key.KeyName)
                                                 else Value := SysUtils.StrToFloat(Key.Default);
          varString:
            if Registry.ValueExists(Key.KeyName) then Value := Registry.ReadString(Key.KeyName)
                                                 else Value := Key.Default;
          else
            Value := NULL;
        end;
        Result := TRUE;
      end
      else
      begin
        Value  := NULL;
        Result := FALSE;
      end;
    finally
      Registry.CloseKey();
      Registry.Free();
    end;

  except
    on Ex: Exception do
    begin
      Value  := NULL;
      Result := FALSE;
    end;
  end;

  if not Result then ShowRegistryAccessErrorDialog(KEY_READ, Key);

end;

function SetRegistryKeyValue(
  const Root: HKEY; const Path: String; const Key: TRegistryKey; const Value: Variant): Boolean;
var
  Registry: TRegistry;

begin

  try
    Registry := TRegistry.Create(KEY_WRITE);
    try
      Registry.RootKey := Root;
      if Registry.OpenKey(Path, TRUE) then
      begin
        case Key.KeyType of
          varBoolean: Registry.WriteBool(Key.KeyName, Value);
          varInteger: Registry.WriteInteger(Key.KeyName, Value);
           varDouble: Registry.WriteFloat(Key.KeyName, Value);
           varString: Registry.WriteString(Key.KeyName, Value);
        end;
        Result := TRUE;
      end
      else
      begin
        Result := FALSE;
      end;
    finally
      Registry.CloseKey();
      Registry.Free();
    end;

  except
    on Ex: Exception do
    begin
      Result := FALSE;
    end;
  end;

  if not Result then ShowRegistryAccessErrorDialog(KEY_WRITE, Key);

end;

function GetRegistryKeyValue(const Key: TRegistryKey; out Value: Variant): Boolean;
begin
  Result := GetRegistryKeyValue(REGKEY_ROOT_DEFAULT, REGKEY_PATH_DEFAULT, Key, Value);
end;

function SetRegistryKeyValue(const Key: TRegistryKey; const Value: Variant): Boolean;
begin
  Result := SetRegistryKeyValue(REGKEY_ROOT_DEFAULT, REGKEY_PATH_DEFAULT, Key, Value);
end;

procedure ShowRegistryAccessErrorDialog(const ModeID: Cardinal; const Key: TRegistryKey);
var
  Mode: String;

begin
  case ModeID of
    KEY_READ:  Mode := 'READ';
    KEY_WRITE: Mode := 'WRITE';
    else       Mode := 'ACCESS';
  end;
  MessageDlg(Format('Unable to "%s" registry key "%s"', [Mode, Key.KeyName]), mtError, [mbOk], 0);
end;

end.
