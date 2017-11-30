unit BitPatternHelp;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, JvExStdCtrls, JvRichEdit, ExtCtrls;

type
  TFormBitPatternHelp = class(TForm)
    JvRichEditUsage: TJvRichEdit;
    PanelMemoContainer: TPanel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormBitPatternHelp: TFormBitPatternHelp;

implementation

{$R *.dfm}

procedure TFormBitPatternHelp.FormCreate(Sender: TObject);

  procedure PutHeader(E: TJvRichEdit; S: String);
  begin

    E.SelAttributes.Style := [fsBold];
    E.SelAttributes.Size := 11;
    E.SelText := S + sLineBreak;

  end;

  procedure PutMessage(E: TJvRichEdit; S: String);
  begin

    E.SelAttributes.Style := [];
    E.SelAttributes.Size := 8;
    E.SelText := sLineBreak + S + sLineBreak;

  end;

begin

  JvRichEditUsage.Clear;

  PutHeader(JvRichEditUsage, 'Input');
  PutMessage(JvRichEditUsage, 'This tool accepts input numeric values of one data type ("source" type), and re-interprets the underlying bit pattern for that type''s value in each of the other supported data types ("target" types).');
  PutMessage(JvRichEditUsage, 'When re-interpreting the bit pattern, the following rules are used when the source size "SZ" (bytes) and target size "TZ" (bytes) are unequal:');
  PutMessage(JvRichEditUsage, '  1.)  SZ greater than TZ  =>  The least significant SZ-TZ bytes are used; discard remaining bytes.');
  PutMessage(JvRichEditUsage, '  2.)  TZ greater than SZ  =>  The most significant TZ-SZ bytes are padded with zeroes; no sign extension.');
  PutMessage(JvRichEditUsage, 'Double-click the "Interpreted value" edit box of a data type to select that type as the new source (currently selected source is indicated by the "Source" checkbox).' + ' Once selected, each of the target types are then re-interpreted accordingly.');

  PutHeader(JvRichEditUsage, sLineBreak + 'Integer and floating point');
  PutMessage(JvRichEditUsage, 'For input integer values, base 10 (decimal) is used by default.' + ' Base 16 (hexadecimal) can be forced by prepending the input string with a dollar sign ($).' + ' Additionally, any input string that contains one of the characters ''A'' .. ''F'' will be automatically interpreted as hexadecimal.');
  PutMessage(JvRichEditUsage, 'Floating point values must be specified in decimal.' + ' Note that the re-interpretation rules above for unequal-sized data types totally clobbers any meaningful relationship between the 32-bit and 64-bit floating point interpreted (IEEE-754) values.');

  PutHeader(JvRichEditUsage, sLineBreak + 'Bit layout');
  PutMessage(JvRichEditUsage, 'In addition to providing integer and floating point input values, the bit pattern to be re-interpreted may be manually specified by clicking the panel for each corresponding bit in the "Bit layout" group box.');
  PutMessage(JvRichEditUsage, 'For convenience, you may drag your cursor over the bit panels while holding down the right mouse button to select a subrange of bits.' + ' The value of this hightlighted range is interpreted as an unsigned integer and displayed in the edit box below the bit panels.');

  PutHeader(JvRichEditUsage, sLineBreak + 'Base conversions');
  PutMessage(JvRichEditUsage, 'The "Base conversions" group box displays read-only data.' + ' The interpreted 32-bit and 64-bit unsigned integer values are displayed here for base 2 (binary), 8 (octal), 10 (decimal), and 16 (hexadecimal).' + ' Various endianness (byte order) conventions are also displayed for each base and type.');
  PutMessage(JvRichEditUsage, 'The "Show digit groupings" checkbox inserts spaces between logical groups of digits for each base. This is just for the reader''s clarity.');


  HideCaret(JvRichEditUsage.Handle);
//  JvRichEditUsage.SelStart := 0;
//  JvRichEditUsage.SelLength := 0;

end;

end.
