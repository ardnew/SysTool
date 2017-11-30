program SysTool;

uses
  Forms,
  Main in 'Main.pas' {FormMain},
  Global in 'Global.pas',
  BitPattern in 'BitPattern.pas' {FormTypeConversion},
  FileAnalysis in 'FileAnalysis.pas' {FormFileAnalysis},
  PerlRegEx in 'opt\TPerlRegEx\PerlRegEx.pas',
  pcre in 'opt\TPerlRegEx\pcre.pas',
  BitPatternHelp in 'BitPatternHelp.pas' {FormBitPatternHelp};

{$R *.res}

begin

  Application.Initialize;
  Application.MainFormOnTaskbar := TRUE;
  Application.ShowMainForm := FALSE;

  Application.Title := Global.APPLICATION_NAME;
  Application.CreateForm(TFormMain, FormMain);
  Application.CreateForm(TFormBitPattern, FormBitPattern);
  Application.CreateForm(TFormFileAnalysis, FormFileAnalysis);
  Application.CreateForm(TFormBitPatternHelp, FormBitPatternHelp);
  Application.Run;

end.
