unit BitPattern;

interface

uses
  // Delphi/Windows
  Windows, StdCtrls, Controls, ExtCtrls, Classes, Graphics, Forms, SysUtils, Dialogs,
  // (J)VCL
  JvExControls, JvLabel, Buttons, JvgSpeedButton, JvExStdCtrls, JvHtControls, JvBehaviorLabel,
  ImgList
  ;

const
  COLOR_MASTER_PANEL = clGradientActiveCaption;
  COLOR_SLAVE_PANEL = clBtnFace;
  COLOR_MASTER_EDIT = clGradientInactiveCaption;
  COLOR_SLAVE_EDIT = clBtnFace;
  COLOR_INVALID_PANEL = clYellow;
  COLOR_BIT_SET = clMaroon;
  COLOR_BIT_NOT_SET = clBtnFace;
  COLOR_FONT_BIT_SET = clWhite;
  COLOR_FONT_BIT_NOT_SET = clBlack;
  COLOR_FONT_BIT_SET_HILITE = clLime;
  COLOR_FONT_BIT_NOT_SET_HILITE = clRed;

type
  TUpdateSource = ( usNONE, usInit, usEdit, usReplace, usBitPanel );
  TBitHiliteState = ( bhNONE, bhActive, bhInactive );

type
  TFormBitPattern = class(TForm)

    GroupBoxInteger: TGroupBox;
    Panel1: TPanel;
    EditByte: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Panel2: TPanel;
    CheckBox1: TCheckBox;
    Panel3: TPanel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    EditShortInt: TEdit;
    Panel4: TPanel;
    CheckBox2: TCheckBox;
    Panel5: TPanel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    EditWord: TEdit;
    Panel6: TPanel;
    CheckBox3: TCheckBox;
    Panel7: TPanel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    EditSmallInt: TEdit;
    Panel8: TPanel;
    CheckBox4: TCheckBox;
    Panel9: TPanel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    EditCardinal: TEdit;
    Panel10: TPanel;
    CheckBox5: TCheckBox;
    Panel11: TPanel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    EditInteger: TEdit;
    Panel12: TPanel;
    CheckBox6: TCheckBox;
    Panel13: TPanel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    EditUInt64: TEdit;
    Panel14: TPanel;
    CheckBox7: TCheckBox;
    Panel15: TPanel;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Label40: TLabel;
    EditInt64: TEdit;
    Panel16: TPanel;
    CheckBox8: TCheckBox;
    Label41: TLabel;
    Label42: TLabel;
    Label43: TLabel;
    Label44: TLabel;
    Label45: TLabel;
    Label46: TLabel;
    Label47: TLabel;
    Label48: TLabel;
    Panel17: TPanel;
    JvLabel1: TJvLabel;
    JvLabel2: TJvLabel;
    JvLabel3: TJvLabel;
    JvLabel4: TJvLabel;
    JvLabel5: TJvLabel;
    JvLabel6: TJvLabel;
    JvLabel7: TJvLabel;
    JvLabel8: TJvLabel;
    GroupBoxFloat: TGroupBox;
    Panel18: TPanel;
    Label49: TLabel;
    Label50: TLabel;
    Label51: TLabel;
    Label52: TLabel;
    Label53: TLabel;
    Label54: TLabel;
    EditSingle: TEdit;
    Panel19: TPanel;
    CheckBox9: TCheckBox;
    Panel20: TPanel;
    Label55: TLabel;
    Label56: TLabel;
    Label57: TLabel;
    Label58: TLabel;
    Label59: TLabel;
    Label60: TLabel;
    EditDouble: TEdit;
    Panel21: TPanel;
    CheckBox10: TCheckBox;
    Panel34: TPanel;
    JvLabel9: TJvLabel;
    JvLabel10: TJvLabel;
    JvLabel11: TJvLabel;
    JvLabel12: TJvLabel;
    JvLabel13: TJvLabel;
    JvLabel14: TJvLabel;
    JvLabel15: TJvLabel;
    JvLabel16: TJvLabel;
    JvLabel17: TJvLabel;
    Label61: TLabel;
    Label62: TLabel;
    GroupBoxBitLayout: TGroupBox;
    Panel22: TPanel;
    B32: TPanel;
    B35: TPanel;
    B34: TPanel;
    B33: TPanel;
    Panel24: TPanel;
    B36: TPanel;
    B39: TPanel;
    B38: TPanel;
    B37: TPanel;
    Panel29: TPanel;
    B40: TPanel;
    B43: TPanel;
    B42: TPanel;
    B41: TPanel;
    Panel35: TPanel;
    B44: TPanel;
    B47: TPanel;
    B46: TPanel;
    B45: TPanel;
    Panel40: TPanel;
    B60: TPanel;
    B63: TPanel;
    B62: TPanel;
    B61: TPanel;
    Panel48: TPanel;
    B56: TPanel;
    B59: TPanel;
    B58: TPanel;
    B57: TPanel;
    Panel53: TPanel;
    B52: TPanel;
    B55: TPanel;
    B54: TPanel;
    B53: TPanel;
    Panel58: TPanel;
    B48: TPanel;
    B51: TPanel;
    B50: TPanel;
    B49: TPanel;
    Panel63: TPanel;
    B28: TPanel;
    B31: TPanel;
    B30: TPanel;
    B29: TPanel;
    Panel68: TPanel;
    B24: TPanel;
    B27: TPanel;
    B26: TPanel;
    B25: TPanel;
    Panel73: TPanel;
    B20: TPanel;
    B23: TPanel;
    B22: TPanel;
    B21: TPanel;
    Panel78: TPanel;
    B16: TPanel;
    B19: TPanel;
    B18: TPanel;
    B17: TPanel;
    Panel83: TPanel;
    B12: TPanel;
    B15: TPanel;
    B14: TPanel;
    B13: TPanel;
    Panel88: TPanel;
    B08: TPanel;
    B11: TPanel;
    B10: TPanel;
    B09: TPanel;
    Panel93: TPanel;
    B04: TPanel;
    B07: TPanel;
    B06: TPanel;
    B05: TPanel;
    Panel98: TPanel;
    B00: TPanel;
    B03: TPanel;
    B02: TPanel;
    B01: TPanel;
    JvLabel18: TJvLabel;
    JvLabel19: TJvLabel;
    Panel99: TPanel;
    CheckBoxByteMisc: TCheckBox;
    Panel103: TPanel;
    CheckBoxShortIntMisc: TCheckBox;
    Panel104: TPanel;
    CheckBoxWordMisc: TCheckBox;
    Panel105: TPanel;
    CheckBoxSmallIntMisc: TCheckBox;
    Panel106: TPanel;
    CheckBoxCardinalMisc: TCheckBox;
    Panel107: TPanel;
    CheckBoxIntegerMisc: TCheckBox;
    Panel108: TPanel;
    CheckBoxUInt64Misc: TCheckBox;
    Panel109: TPanel;
    CheckBoxInt64Misc: TCheckBox;
    Panel110: TPanel;
    CheckBoxSingleMisc: TCheckBox;
    Panel111: TPanel;
    CheckBoxDoubleMisc: TCheckBox;
    GroupBoxBase: TGroupBox;
    Panel41: TPanel;
    Label71: TLabel;
    EditHexLittle32: TEdit;
    EditOctalLittle32: TEdit;
    Panel42: TPanel;
    Label72: TLabel;
    EditHexLittle64: TEdit;
    EditOctalLittle64: TEdit;
    Panel43: TPanel;
    JvLabel33: TJvLabel;
    JvLabel34: TJvLabel;
    Panel44: TPanel;
    Label73: TLabel;
    EditBinaryLittle32: TEdit;
    Panel45: TPanel;
    Label74: TLabel;
    EditBinaryLittle64: TEdit;
    Panel47: TPanel;
    Label75: TLabel;
    EditHexBig32: TEdit;
    EditOctalBig32: TEdit;
    Panel49: TPanel;
    Label76: TLabel;
    EditHexBig64: TEdit;
    EditOctalBig64: TEdit;
    Panel51: TPanel;
    Label77: TLabel;
    EditBinaryBig32: TEdit;
    Panel52: TPanel;
    Label78: TLabel;
    EditBinaryBig64: TEdit;
    JvLabel20: TJvLabel;
    Label63: TLabel;
    Label64: TLabel;
    Label65: TLabel;
    Label66: TLabel;
    Label67: TLabel;
    Label68: TLabel;
    Label69: TLabel;
    Label70: TLabel;
    Panel23: TPanel;
    JvLabel21: TJvLabel;
    JvLabel22: TJvLabel;
    JvLabel23: TJvLabel;
    JvLabel24: TJvLabel;
    JvLabel25: TJvLabel;
    EditDecimalLittle32: TEdit;
    EditDecimalBig32: TEdit;
    EditDecimalLittle64: TEdit;
    EditDecimalBig64: TEdit;
    Panel25: TPanel;
    Label79: TLabel;
    LabelBitHiliteRange: TLabel;
    Panel27: TPanel;
    PanelBitPatternHelp: TPanel;
    SpeedButtonHelp: TSpeedButton;
    CheckBoxGroupBases: TCheckBox;
    Panel26: TPanel;
    EditBitHilite: TButtonedEdit;
    SpeedButtonClearBitHilite: TSpeedButton;
    procedure FormCreate(Sender: TObject);                                // module routine
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);     // module routine
    procedure FormShow(Sender: TObject);                                  // module routine
    procedure BitPanelClick(Sender: TObject);
    procedure EditTypeChange(Sender: TObject);
    procedure EditDblClick(Sender: TObject);
    procedure EditBaseConversionClick(Sender: TObject);
    procedure BitPanelMouseEnter(Sender: TObject);
    procedure BitPanelMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
      Y: Integer);
    procedure BitPanelMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure GroupBoxBitLayoutMouseLeave(Sender: TObject);
    procedure SpeedButtonHelpClick(Sender: TObject);
    procedure CheckBoxGroupBasesClick(Sender: TObject);
    procedure SpeedButtonClearBitHiliteClick(Sender: TObject);
    procedure EditClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

  private
    BitPanel: array[0 .. 63] of TPanel;
    BitHiliteState: TBitHiliteState;
    UpdateSource: TUpdateSource;
    procedure SetMasterEdit(Sender: TObject);
    procedure SetBitPanelAppearance(Panel: TPanel; BitSet: Boolean);
    procedure ClearBitHilite;
    procedure SetBaseGroupings;
    procedure SaveRegistrySettings;
    procedure LoadRegistrySettings;

  public
    procedure CreateParams(var Params: TCreateParams); override;          // module routine
    procedure SetFormStayOnTop(StayOnTop: Boolean);                       // module routine

  end;

var
  FormBitPattern: TFormBitPattern;

implementation

uses
  // Delphi/Windows
  Character, Math,
  // SysTool
  Main, Global, BitPatternHelp;

{$R *.dfm}

procedure TFormBitPattern.SetMasterEdit(Sender: TObject);
const
  PANEL_COLOR: array[Boolean] of TColor = ( COLOR_SLAVE_PANEL, COLOR_MASTER_PANEL );
  EDIT_COLOR: array[Boolean] of TColor = ( COLOR_SLAVE_EDIT, COLOR_MASTER_EDIT );

begin

  (EditByte.Parent as TPanel).Color      := PANEL_COLOR[EditByte = Sender];
  (EditShortInt.Parent as TPanel).Color  := PANEL_COLOR[EditShortInt = Sender];
  (EditWord.Parent as TPanel).Color      := PANEL_COLOR[EditWord = Sender];
  (EditSmallInt.Parent as TPanel).Color  := PANEL_COLOR[EditSmallInt = Sender];
  (EditCardinal.Parent as TPanel).Color  := PANEL_COLOR[EditCardinal = Sender];
  (EditInteger.Parent as TPanel).Color   := PANEL_COLOR[EditInteger = Sender];
  (EditUInt64.Parent as TPanel).Color    := PANEL_COLOR[EditUInt64 = Sender];
  (EditInt64.Parent as TPanel).Color     := PANEL_COLOR[EditInt64 = Sender];
  (EditSingle.Parent as TPanel).Color    := PANEL_COLOR[EditSingle = Sender];
  (EditDouble.Parent as TPanel).Color    := PANEL_COLOR[EditDouble = Sender];

  EditByte.Color      := EDIT_COLOR[EditByte = Sender];
  EditShortInt.Color  := EDIT_COLOR[EditShortInt = Sender];
  EditWord.Color      := EDIT_COLOR[EditWord = Sender];
  EditSmallInt.Color  := EDIT_COLOR[EditSmallInt = Sender];
  EditCardinal.Color  := EDIT_COLOR[EditCardinal = Sender];
  EditInteger.Color   := EDIT_COLOR[EditInteger = Sender];
  EditUInt64.Color    := EDIT_COLOR[EditUInt64 = Sender];
  EditInt64.Color     := EDIT_COLOR[EditInt64 = Sender];
  EditSingle.Color    := EDIT_COLOR[EditSingle = Sender];
  EditDouble.Color    := EDIT_COLOR[EditDouble = Sender];

  GroupBoxBitLayout.Color := COLOR_SLAVE_PANEL;

end;

procedure TFormBitPattern.SpeedButtonHelpClick(Sender: TObject);
begin
  FormBitPatternHelp.Show;
end;

procedure TFormBitPattern.SetBitPanelAppearance(Panel: TPanel; BitSet: Boolean);
begin
  if BitSet then
  begin
    Panel.Color := COLOR_BIT_SET;
    Panel.Font.Color := COLOR_FONT_BIT_SET;
    Panel.Font.Style := [fsBold];
  end
  else
  begin
    Panel.Color := COLOR_BIT_NOT_SET;
    Panel.Font.Color := COLOR_FONT_BIT_NOT_SET;
    Panel.Font.Style := [];
  end;
end;

procedure TFormBitPattern.BitPanelMouseEnter(Sender: TObject);
const
  NO_BITS_HILITE = -1;

var
  HiliteValue          : UInt64;
  HiliteMouseButton    : UInt64;
  AsyncKeyState        : UInt16;
  MouseButtonsSwapped  : Boolean;
  LowBit               : Integer;
  HighBit              : Integer;
  i                    : Cardinal;

  function IsHiliteColor(Color: TColor): Boolean;
  begin
    Result := (COLOR_FONT_BIT_SET_HILITE= Color) or (COLOR_FONT_BIT_NOT_SET_HILITE = Color);
  end;

begin
  if Sender is TPanel then
  begin
    MouseButtonsSwapped := 0 <> GetSystemMetrics(SM_SWAPBUTTON);
    if MouseButtonsSwapped then HiliteMouseButton := VK_LBUTTON
                           else HiliteMouseButton := VK_RBUTTON;

    AsyncKeyState := GetAsyncKeyState(HiliteMouseButton);
    if (AsyncKeyState and $FFFE) > 0 then // if any bit other than LSB is set (see: GetAsyncKeyState docs on MSDN)
    begin

      if bhInactive = BitHiliteState then
        ClearBitHilite;

      LowBit := NO_BITS_HILITE;
      for i := Low(BitPanel) to High(BitPanel) do
      begin
        if IsHiliteColor(BitPanel[i].Font.Color) or (Sender = BitPanel[i]) then
        begin
          LowBit := i;
          Break;
        end;
      end;

      HighBit := NO_BITS_HILITE;
      for i := High(BitPanel) downto Low(BitPanel) do
      begin
        if IsHiliteColor(BitPanel[i].Font.Color) or (Sender = BitPanel[i]) then
        begin
          HighBit := i;
          Break;
        end;
      end;

      HiliteValue := 0;

      if (LowBit <> NO_BITS_HILITE) and (HighBit <> NO_BITS_HILITE) then
      begin
        for i := LowBit to HighBit do
        begin
          if Self.BitPanel[i].Color = COLOR_BIT_SET then
          begin
            BitPanel[i].Font.Color := COLOR_FONT_BIT_SET_HILITE;

            //
            // strange delphi compiler nuance here, from the docs:
            //
            //    [... for operation "x shl y" ...] the value of y is interpreted
            //    modulo the size of the type of x. Thus for example, if x is an
            //    integer, x shl 40 is interpreted as x shl 8 because an integer
            //    is 32 bits and 40 mod 32 is 8.
            //
            // so in our case here, we must cast the literal 1 to 64 bits so that
            // the resulting bitwise-or may have upper-32 bits set:
            HiliteValue := HiliteValue or (UInt64(1) shl (i - UInt64(LowBit)));
          end
          else
          begin
            BitPanel[i].Font.Color := COLOR_FONT_BIT_NOT_SET_HILITE;
          end;
        end;
      end;

      LabelBitHiliteRange.Caption := Format('Bit[%u] .. Bit[%u] as %d-bit int = ',
                                              [LowBit, HighBit, HighBit - LowBit + 1]);

      EditBitHilite.Text := Format('%u', [HiliteValue]);
      BitHiliteState := bhActive;
      SpeedButtonClearBitHilite.Enabled := TRUE;
      GroupBoxBitLayout.SetFocus;

    end;
  end;
end;

procedure TFormBitPattern.CheckBoxGroupBasesClick(Sender: TObject);
begin

  SetBaseGroupings;

end;

procedure TFormBitPattern.SpeedButtonClearBitHiliteClick(Sender: TObject);
begin

  ClearBitHilite;
  EditBitHilite.Text := '0';
  LabelBitHiliteRange.Caption := '';

end;

procedure TFormBitPattern.ClearBitHilite;
var
  i: Cardinal;

begin
  for i := Low(BitPanel) to High(BitPanel) do
  begin
    SetBitPanelAppearance(Self.BitPanel[i], Self.BitPanel[i].Color = COLOR_BIT_SET);
  end;
  SpeedButtonClearBitHilite.Enabled := FALSE;
end;

procedure TFormBitPattern.SetBaseGroupings;
begin

  if CheckBoxGroupBases.Checked then
  begin

    EditBinaryLittle32.Text  := GroupCharsR2L(EditBinaryLittle32.Text, 8);
    EditBinaryBig32.Text     := GroupCharsR2L(EditBinaryBig32.Text, 8);
    EditBinaryLittle64.Text  := GroupCharsR2L(EditBinaryLittle64.Text, 8);
    EditBinaryBig64.Text     := GroupCharsR2L(EditBinaryBig64.Text, 8);

    EditOctalLittle32.Text   := GroupCharsR2L(EditOctalLittle32.Text, 4);
    EditOctalBig32.Text      := GroupCharsR2L(EditOctalBig32.Text, 4);
    EditOctalLittle64.Text   := GroupCharsR2L(EditOctalLittle64.Text, 4);
    EditOctalBig64.Text      := GroupCharsR2L(EditOctalBig64.Text, 4);

    EditHexLittle32.Text     := GroupCharsR2L(EditHexLittle32.Text, 2);
    EditHexBig32.Text        := GroupCharsR2L(EditHexBig32.Text, 2);
    EditHexLittle64.Text     := GroupCharsR2L(EditHexLittle64.Text, 2);
    EditHexBig64.Text        := GroupCharsR2L(EditHexBig64.Text, 2);

    EditDecimalLittle32.Text  := GroupCharsR2L(EditDecimalLittle32.Text, 3);
    EditDecimalBig32.Text     := GroupCharsR2L(EditDecimalBig32.Text, 3);
    EditDecimalLittle64.Text  := GroupCharsR2L(EditDecimalLittle64.Text, 3);
    EditDecimalBig64.Text     := GroupCharsR2L(EditDecimalBig64.Text, 3);

  end
  else
  begin

    EditBinaryLittle32.Text  := StripAllWhitespace(EditBinaryLittle32.Text);
    EditBinaryBig32.Text     := StripAllWhitespace(EditBinaryBig32.Text);
    EditBinaryLittle64.Text  := StripAllWhitespace(EditBinaryLittle64.Text);
    EditBinaryBig64.Text     := StripAllWhitespace(EditBinaryBig64.Text);

    EditOctalLittle32.Text   := StripAllWhitespace(EditOctalLittle32.Text);
    EditOctalBig32.Text      := StripAllWhitespace(EditOctalBig32.Text);
    EditOctalLittle64.Text   := StripAllWhitespace(EditOctalLittle64.Text);
    EditOctalBig64.Text      := StripAllWhitespace(EditOctalBig64.Text);

    EditHexLittle32.Text     := StripAllWhitespace(EditHexLittle32.Text);
    EditHexBig32.Text        := StripAllWhitespace(EditHexBig32.Text);
    EditHexLittle64.Text     := StripAllWhitespace(EditHexLittle64.Text);
    EditHexBig64.Text        := StripAllWhitespace(EditHexBig64.Text);

    EditDecimalLittle32.Text  := StripAllWhitespace(EditDecimalLittle32.Text);
    EditDecimalBig32.Text     := StripAllWhitespace(EditDecimalBig32.Text);
    EditDecimalLittle64.Text  := StripAllWhitespace(EditDecimalLittle64.Text);
    EditDecimalBig64.Text     := StripAllWhitespace(EditDecimalBig64.Text);

  end;

end;

procedure TFormBitPattern.BitPanelMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  BitPanelMouseEnter(Sender);
end;

procedure TFormBitPattern.BitPanelMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  BitHiliteState := bhInactive;
end;

procedure TFormBitPattern.BitPanelClick(Sender: TObject);
var
  Value : UInt64;
  i     : Integer;

begin
  if Sender is TPanel then
  begin

    SetMasterEdit(nil);
    GroupBoxBitLayout.Color := COLOR_MASTER_PANEL;

    SetBitPanelAppearance(Sender as TPanel, (Sender as TPanel).Color <> COLOR_BIT_SET);

    Value := 0;
    for i := Low(BitPanel) to High(BitPanel) do
    begin
      if Self.BitPanel[i].Color = COLOR_BIT_SET then
        Value := Value or (UInt64(1) shl i);
    end;

    UpdateSource := usBitPanel;
    EditUInt64.Text := Format('%u', [Value]);
    UpdateSource := usNONE;
    GroupBoxBitLayout.SetFocus;

  end;
end;

procedure TFormBitPattern.EditBaseConversionClick(Sender: TObject);
begin
  (Sender as TEdit).SelectAll;
end;

procedure TFormBitPattern.EditClick(Sender: TObject);
begin

  if Sender is TButtonedEdit then
  begin
    if (Sender as TButtonedEdit).Color = COLOR_SLAVE_EDIT then
    begin
      (Sender as TButtonedEdit).SelectAll;
    end;
  end
  else
  begin
    if Sender is TEdit then
    begin
      if (Sender as TEdit).Color = COLOR_SLAVE_EDIT then
      begin
        (Sender as TEdit).SelectAll;
      end;
    end;
  end;

end;

procedure TFormBitPattern.EditDblClick(Sender: TObject);
begin
  (Sender as TEdit).OnChange(Sender);
  (Sender as TEdit).SelectAll;
end;

procedure TFormBitPattern.EditTypeChange(Sender: TObject);
const
  BIT_PANEL_COLOR: array[ 0 .. 1 ] of TColor = ( COLOR_BIT_NOT_SET, COLOR_BIT_SET );
  INVALID_PANEL_COLOR: array[ Boolean ] of TColor = ( COLOR_SLAVE_PANEL, {COLOR_INVALID_PANEL --TODO: fix validation coloring for hex input}COLOR_SLAVE_PANEL );
  INPUT_ALPHABET_DEC: set of AnsiChar = [ '0' .. '9' ];
  INPUT_ALPHABET_HEX: set of AnsiChar = [ '0' .. '9', 'A' .. 'F' ];

var
  Edit                : TEdit;
  NormInput           : String;
  SenderType          : TNumberType;
  UpdateSourcePrev    : TUpdateSource;
  IntParseErrorPos    : Integer;
  SingleParseErrorPos : Integer;
  DoubleParseErrorPos : Integer;
  ContainsHexChar     : Boolean;
  i                   : Integer;

  VByte        : array[0 .. 7] of Byte;
  IntValue     : UInt64 absolute VByte;
  SingleValue  : Single;
  DoubleValue  : Double;
  ValidValue   : Boolean;

  LE32Val      : UInt32;
  BE32Val      : UInt32;
  LE64Val      : UInt64;
  BE64Val      : UInt64;

  ValueAddress : Pointer;

begin

  SenderType       := ntNONE;
  UpdateSourcePrev := UpdateSource;
  IntParseErrorPos := -1;
  ValueAddress     := nil;

  if not (UpdateSource in [ usReplace ]) then
  begin

    if Sender is TEdit then
    begin

      if not (UpdateSource in [ usBitPanel ]) then
        SetMasterEdit(Sender);

      UpdateSource := usReplace;

      Edit       := Sender as TEdit;
      SenderType := TNumberType(Edit.Tag);
      Edit.Text  := StripAllWhitespace(Edit.Text);
      NormInput  := RemoveLeadingZeros(Edit.Text);

      if not (SenderType in TYPE_FLOAT) then
      begin
        ContainsHexChar := FALSE;
        for i := 1 to Length(NormInput) do
        begin
          ContainsHexChar :=
            ContainsHexChar or CharInSet(ToUpper(NormInput[i]), INPUT_ALPHABET_HEX - INPUT_ALPHABET_DEC);
        end;
        if ContainsHexChar and (NormInput[1] <> '$') then // short-circuited, safe indexing
        begin
          NormInput := '$' + NormInput;
        end;
      end;

      if NormInput <> Edit.Text then
      begin
        Edit.Text     := NormInput;
        Edit.SelStart := Length(NormInput);
      end;

      if Length(Edit.Text) = 0 then
      begin
        Edit.Text     := '0';
        NormInput     := Edit.Text;
        Edit.SelStart := Length(Edit.Text);
      end;

      ValidValue := (NormInput = '-') or (NormInput = '$');

      try

        Val(NormInput, SingleValue, SingleParseErrorPos);
        Val(NormInput, DoubleValue, DoubleParseErrorPos);

        if SenderType = ntSingle then
        begin
          ValueAddress := @SingleValue;
        end
        else
        if SenderType = ntDouble then
        begin
          ValueAddress := @DoubleValue;
        end
        else
        begin
          try
            if 0 = Pos('-', NormInput)
            then
              IntValue := StrToUInt64(NormInput)
            else
              Val(NormInput, IntValue, IntParseErrorPos);
          except
            on Ex: EConvertError do
            begin
              Val(NormInput, IntValue, IntParseErrorPos); // retry with Val if StrToUInt64() error'd out
              if IntParseErrorPos > 0 then
              begin
                IntValue      := 0;
                Edit.Text     := '0';
                NormInput     := Edit.Text;
                Edit.SelStart := Length(Edit.Text);
              end;
            end;
          end;
          ValueAddress := @IntValue;
        end;

        case SenderType of

              ntByte: begin
                        IntValue := UInt64(ValueAddress^) and $00000000000000FF;
                        ValidValue := ValidValue or (Format('%u', [Byte(ValueAddress^)]) = StripAllWhitespace(EditByte.Text));
                        EditByte.Color := INVALID_PANEL_COLOR[not ValidValue];
                        CheckBoxByteMisc.Checked := TRUE;
                      end;

          ntShortInt: begin
                        IntValue := UInt64(ValueAddress^) and $00000000000000FF;
                        ValidValue := ValidValue or (Format('%d', [ShortInt(ValueAddress^)]) = StripAllWhitespace(EditShortInt.Text));
                        EditShortInt.Color := INVALID_PANEL_COLOR[not ValidValue];
                        CheckBoxShortIntMisc.Checked := TRUE;
                      end;

              ntWord: begin
                        IntValue := UInt64(ValueAddress^) and $000000000000FFFF;
                        ValidValue := ValidValue or (Format('%u', [Word(ValueAddress^)]) = StripAllWhitespace(EditWord.Text));
                        EditWord.Color := INVALID_PANEL_COLOR[not ValidValue];
                        CheckBoxWordMisc.Checked := TRUE;
                      end;

          ntSmallInt: begin
                        IntValue := UInt64(ValueAddress^) and $000000000000FFFF;
                        ValidValue := ValidValue or (Format('%d', [SmallInt(ValueAddress^)]) = StripAllWhitespace(EditSmallInt.Text));
                        EditSmallInt.Color := INVALID_PANEL_COLOR[not ValidValue];
                        CheckBoxSmallIntMisc.Checked := TRUE;
                      end;

          ntCardinal: begin
                        IntValue := UInt64(ValueAddress^) and $00000000FFFFFFFF;
                        ValidValue := ValidValue or (Format('%u', [Cardinal(ValueAddress^)]) = StripAllWhitespace(EditCardinal.Text));
                        EditCardinal.Color := INVALID_PANEL_COLOR[not ValidValue];
                        CheckBoxCardinalMisc.Checked := TRUE;
                      end;

           ntInteger: begin
                        IntValue := UInt64(ValueAddress^) and $00000000FFFFFFFF;
                        ValidValue := ValidValue or (Format('%d', [Integer(ValueAddress^)]) = StripAllWhitespace(EditInteger.Text));
                        EditInteger.Color := INVALID_PANEL_COLOR[not ValidValue];
                        CheckBoxIntegerMisc.Checked := TRUE;
                      end;

            ntUInt64: begin
                        IntValue := UInt64(ValueAddress^) and $FFFFFFFFFFFFFFFF;
                        ValidValue := ValidValue or (Format('%u', [UInt64(ValueAddress^)]) = StripAllWhitespace(EditUInt64.Text));
                        EditUInt64.Color := INVALID_PANEL_COLOR[not ValidValue];
                        CheckBoxUInt64Misc.Checked := TRUE;
                      end;

             ntInt64: begin
                        IntValue := UInt64(ValueAddress^) and $FFFFFFFFFFFFFFFF;
                        ValidValue := ValidValue or (Format('%d', [Int64(ValueAddress^)]) = StripAllWhitespace(EditInt64.Text));
                        EditInt64.Color := INVALID_PANEL_COLOR[not ValidValue];
                        CheckBoxInt64Misc.Checked := TRUE;
                      end;

            ntSingle: begin
                        ValidValue := TRUE; // TODO: validate input float
                        EditSingle.Color := INVALID_PANEL_COLOR[not ValidValue];
                        CheckBoxSingleMisc.Checked := TRUE;
                      end;

            ntDouble: begin
                        ValidValue := TRUE; // TODO: validate input float
                        EditDouble.Color := INVALID_PANEL_COLOR[not ValidValue];
                        CheckBoxDoubleMisc.Checked := TRUE;
                      end;

        end;

        if SenderType <> ntByte then
        begin
          EditByte.Text := Format('%u', [Byte(ValueAddress^)]);
          CheckBoxByteMisc.Checked := FALSE;
        end;
        if SenderType <> ntShortInt then
        begin
          EditShortInt.Text := Format('%d', [ShortInt(ValueAddress^)]);
          CheckBoxShortIntMisc.Checked := FALSE;
        end;
        if SenderType <> ntWord then
        begin
          EditWord.Text := Format('%u', [Word(ValueAddress^)]);
          CheckBoxWordMisc.Checked := FALSE;
        end;
        if SenderType <> ntSmallInt then
        begin
          EditSmallInt.Text := Format('%d', [SmallInt(ValueAddress^)]);
          CheckBoxSmallIntMisc.Checked := FALSE;
        end;
        if SenderType <> ntCardinal then
        begin
          EditCardinal.Text := Format('%u', [Cardinal(ValueAddress^)]);
          CheckBoxCardinalMisc.Checked := FALSE;
        end;
        if SenderType <> ntInteger then
        begin
          EditInteger.Text := Format('%d', [Integer(ValueAddress^)]);
          CheckBoxIntegerMisc.Checked := FALSE;
        end;
        if SenderType <> ntUInt64 then
        begin
          EditUInt64.Text := Format('%u', [UInt64(ValueAddress^)]);
          CheckBoxUInt64Misc.Checked := FALSE;
        end;
        if SenderType <> ntInt64 then
        begin
          EditInt64.Text := Format('%d', [Int64(ValueAddress^)]);
          CheckBoxInt64Misc.Checked := FALSE;
        end;
        if SenderType <> ntSingle then
        begin
          EditSingle.Text := Format('%e', [Single(ValueAddress^)]);
          CheckBoxSingleMisc.Checked := FALSE;
        end;
        if SenderType <> ntDouble then
        begin
          EditDouble.Text := Format('%e', [Double(ValueAddress^)]);
          CheckBoxDoubleMisc.Checked := FALSE;
        end;

        SpeedButtonClearBitHiliteClick(EditBitHilite);

      except
        on Ex: Exception do
        begin
          ShowMessage('error: ' + Ex.Message);
        end;
      end;

      UpdateSource := UpdateSourcePrev;

    end;

    for i := Low(BitPanel) to High(BitPanel) do
    begin
      SetBitPanelAppearance(
        Self.BitPanel[i],
        ((UInt64(ValueAddress^) shr i) and 1 = 1)
          and
        (i < BITS_IN_TYPE[SenderType])
      );
    end;

    if SenderType in TYPE_FLOAT then
    begin
      VByte[0] := (UInt64(ValueAddress^) shr $00) and $FF;
      VByte[1] := (UInt64(ValueAddress^) shr $08) and $FF;
      VByte[2] := (UInt64(ValueAddress^) shr $10) and $FF;
      VByte[3] := (UInt64(ValueAddress^) shr $18) and $FF;
      if SenderType in TYPE_64_BIT then
      begin
        VByte[4] := (UInt64(ValueAddress^) shr $20) and $FF;
        VByte[5] := (UInt64(ValueAddress^) shr $28) and $FF;
        VByte[6] := (UInt64(ValueAddress^) shr $30) and $FF;
        VByte[7] := (UInt64(ValueAddress^) shr $38) and $FF;
      end
      else
      begin
        VByte[4] := 0;
        VByte[5] := 0;
        VByte[6] := 0;
        VByte[7] := 0;
      end;
    end;

    BE32Val :=
      (UInt32(VByte[0]) shl $00) or
      (UInt32(VByte[1]) shl $08) or
      (UInt32(VByte[2]) shl $10) or
      (UInt32(VByte[3]) shl $18);

    LE32Val :=
      (UInt32(VByte[3]) shl $00) or
      (UInt32(VByte[2]) shl $08) or
      (UInt32(VByte[1]) shl $10) or
      (UInt32(VByte[0]) shl $18);

    BE64Val :=
      (UInt64(VByte[0]) shl $00) or
      (UInt64(VByte[1]) shl $08) or
      (UInt64(VByte[2]) shl $10) or
      (UInt64(VByte[3]) shl $18) or
      (UInt64(VByte[4]) shl $20) or
      (UInt64(VByte[5]) shl $28) or
      (UInt64(VByte[6]) shl $30) or
      (UInt64(VByte[7]) shl $38);

    LE64Val :=
      (UInt64(VByte[7]) shl $00) or
      (UInt64(VByte[6]) shl $08) or
      (UInt64(VByte[5]) shl $10) or
      (UInt64(VByte[4]) shl $18) or
      (UInt64(VByte[3]) shl $20) or
      (UInt64(VByte[2]) shl $28) or
      (UInt64(VByte[1]) shl $30) or
      (UInt64(VByte[0]) shl $38);


    EditBinaryLittle32.Text  := BinaryString(LE32Val, 32);
    EditBinaryBig32.Text     := BinaryString(BE32Val, 32);
    EditBinaryLittle64.Text  := BinaryString(LE64Val, 64);
    EditBinaryBig64.Text     := BinaryString(BE64Val, 64);

    EditOctalLittle32.Text   := Format('%s', [UInt64ToOct(LE32Val, 11)]);
    EditOctalBig32.Text      := Format('%s', [UInt64ToOct(BE32Val, 11)]);
    EditOctalLittle64.Text   := Format('%s', [UInt64ToOct(LE64Val, 22)]);
    EditOctalBig64.Text      := Format('%s', [UInt64ToOct(BE64Val, 22)]);

    EditHexLittle32.Text     := Format('%s', [IntToHex(LE32Val, 8)]);
    EditHexBig32.Text        := Format('%s', [IntToHex(BE32Val, 8)]);
    EditHexLittle64.Text     := Format('%s%s', [IntToHex((LE64Val shr $20) and $FFFFFFFF, 8),
                                                IntToHex(LE64Val and $FFFFFFFF, 8)]);
    EditHexBig64.Text        := Format('%s%s', [IntToHex((BE64Val shr $20) and $FFFFFFFF, 8),
                                                IntToHex(BE64Val and $FFFFFFFF, 8)]);

    EditDecimalLittle32.Text  := Format('%.10u', [LE32Val]);
    EditDecimalBig32.Text     := Format('%.10u', [BE32Val]);
    EditDecimalLittle64.Text  := Format('%.20u', [LE64Val]);
    EditDecimalBig64.Text     := Format('%.20u', [BE64Val]);

    SetBaseGroupings;

  end;

end;

procedure TFormBitPattern.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin

  FormBitPatternHelp.Close;
  SaveRegistrySettings;

end;

procedure TFormBitPattern.SaveRegistrySettings;
begin

  Global.SetRegistryKeyValue(REGKEY_FORMBITPATTERN_FORM_X, Self.Left);
  Global.SetRegistryKeyValue(REGKEY_FORMBITPATTERN_FORM_Y, Self.Top);
  Global.SetRegistryKeyValue(REGKEY_FORMBITPATTERN_FORM_WIDTH, Self.Width);
  Global.SetRegistryKeyValue(REGKEY_FORMBITPATTERN_FORM_HEIGHT, Self.Height);
  Global.SetRegistryKeyValue(REGKEY_FORMBITPATTERN_GROUP_BASES, CheckBoxGroupBases.Checked);

end;

procedure TFormBitPattern.LoadRegistrySettings;
var
  FormX      : Variant;
  FormY      : Variant;
  FormWidth  : Variant;
  FormHeight : Variant;
  GroupBases : Variant;

begin

  FormX      := 0;
  FormY      := 0;
  FormWidth  := 0;
  FormHeight := 0;
  GroupBases := FALSE;

  if Global.GetRegistryKeyValue(REGKEY_FORMBITPATTERN_FORM_X, FormX) then
  begin
    Self.Left := FormX;
  end;

  if Global.GetRegistryKeyValue(REGKEY_FORMBITPATTERN_FORM_Y, FormY) then
  begin
    Self.Top := FormY;
  end;

  if Global.GetRegistryKeyValue(REGKEY_FORMBITPATTERN_FORM_WIDTH, FormWidth) then
  begin
    Self.Width := FormWidth;
  end;

  if Global.GetRegistryKeyValue(REGKEY_FORMBITPATTERN_FORM_HEIGHT, FormHeight) then
  begin
    Self.Height := FormHeight;
  end;

  if Global.GetRegistryKeyValue(REGKEY_FORMBITPATTERN_GROUP_BASES, GroupBases) then
  begin
    CheckBoxGroupBases.Checked := GroupBases;
  end;

end;

procedure TFormBitPattern.FormCreate(Sender: TObject);
var
  i: Integer;

begin

  LoadRegistrySettings;

  Self.Caption := Format('Bit Patterns (%s)', [AnsiUpperCase(Global.GetSessionIdentifier())]);

  EditByte.Tag      := Integer(ntByte);
  EditShortInt.Tag  := Integer(ntShortInt);
  EditWord.Tag      := Integer(ntWord);
  EditSmallInt.Tag  := Integer(ntSmallInt);
  EditCardinal.Tag  := Integer(ntCardinal);
  EditInteger.Tag   := Integer(ntInteger);
  EditUInt64.Tag    := Integer(ntUInt64);
  EditInt64.Tag     := Integer(ntInt64);
  EditSingle.Tag    := Integer(ntSingle);
  EditDouble.Tag    := Integer(ntDouble);

  for i := Low(BitPanel) to High(BitPanel) do
  begin
    Self.BitPanel[i] := TPanel(FindComponent(Format('B%.2d', [i])));
    Self.BitPanel[i].OnClick := Self.BitPanelClick;
    Self.BitPanel[i].OnMouseDown := Self.BitPanelMouseDown;
    Self.BitPanel[i].OnMouseUp := Self.BitPanelMouseUp;
    Self.BitPanel[i].OnMouseEnter := Self.BitPanelMouseEnter;
    Self.BitPanel[i].ParentBackground := FALSE;
    Self.BitPanel[i].Color := COLOR_BIT_NOT_SET;
  end;

  UpdateSource := usInit;
  EditByte.Text := Format('%u', [0]);
  UpdateSource := usNONE;
  BitHiliteState := bhInactive;

end;

procedure TFormBitPattern.FormDestroy(Sender: TObject);
begin

  SaveRegistrySettings;

end;

procedure TFormBitPattern.CreateParams(var Params: TCreateParams);
begin

  inherited;
  Params.ExStyle := Params.ExStyle or WS_EX_APPWINDOW;
  Params.WndParent := GetDesktopWindow;

  Self.PopupParent := Self;
  Self.PopupMode   := pmExplicit;

end;

procedure TFormBitPattern.FormShow(Sender: TObject);
begin

  GroupBoxInteger.SetFocus;
  FormMain.TrayMenuItemStayOnTopClick(nil);

end;

procedure TFormBitPattern.GroupBoxBitLayoutMouseLeave(Sender: TObject);
var
  GroupBox: TGroupBox;

begin

  if Sender is TGroupBox then
  begin
    GroupBox := Sender as TGroupBox;
    if not PtInRect(GroupBox.ClientRect, GroupBox.ScreenToClient(Mouse.CursorPos)) then
    begin
      BitPanelMouseUp(Sender, mbRight, [], 0, 0);
    end;
  end;

end;

procedure TFormBitPattern.SetFormStayOnTop(StayOnTop: Boolean);
begin

  Self.FormStyle := fsNormal;
  if StayOnTop then Self.FormStyle := fsStayOnTop
               else Self.FormStyle := fsNormal;

end;

end.
