object FormMain: TFormMain
  AlignWithMargins = True
  Left = 0
  Top = 0
  Margins.Left = 0
  Margins.Top = 0
  Margins.Right = 0
  Margins.Bottom = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  ClientHeight = 183
  ClientWidth = 293
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  GlassFrame.SheetOfGlass = True
  OldCreateOrder = False
  ScreenSnap = True
  SnapBuffer = 32
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDblClick = FormDblClick
  PixelsPerInch = 96
  TextHeight = 13
  object JvTrayIcon: TJvTrayIcon
    Active = True
    IconIndex = 0
    DropDownMenu = JvPopupMenuTray
    PopupMenu = JvPopupMenuTray
    Delay = 0
    OnDblClick = JvTrayIconDblClick
    Left = 140
    Top = 48
  end
  object JvPopupMenuTray: TJvPopupMenu
    ImageMargin.Left = 0
    ImageMargin.Top = 0
    ImageMargin.Right = 0
    ImageMargin.Bottom = 0
    ImageSize.Height = 0
    ImageSize.Width = 0
    Left = 56
    Top = 48
    object TrayMenuItemSessionID: TMenuItem
      Caption = 'HOSTNAME'
      Default = True
      Enabled = False
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object TrayMenuItemFileUtilities: TMenuItem
      Caption = 'File utilities'
      OnClick = TrayMenuItemFileUtilitiesClick
    end
    object TrayMenuItemBitPattern: TMenuItem
      Caption = 'Bit patterns'
      OnClick = TrayMenuItemBitPatternClick
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object TrayMenuItemConvert: TMenuItem
      Caption = 'Convert file path'
      object TrayMenuItemConvertLocalToUNC: TMenuItem
        Caption = 'Local to UNC'
        OnClick = TrayMenuItemConvertLocalToUNCClick
      end
      object TrayMenuItemConvertUNCToLocal: TMenuItem
        Caption = 'UNC to local'
        OnClick = TrayMenuItemConvertUNCToLocalClick
      end
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object TrayMenuItemStayOnTop: TMenuItem
      AutoCheck = True
      Caption = 'Stay on top'
      Checked = True
      OnClick = TrayMenuItemStayOnTopClick
    end
    object TrayMenuItemStyle: TMenuItem
      Caption = 'Style'
      Visible = False
      object TrayMenuItemStyleBtnLowered: TMenuItem
        Caption = 'msBtnLowered'
        OnClick = TrayMenuItemStyleClick
      end
      object TrayMenuItemStyleBtnRaised: TMenuItem
        Tag = 1
        Caption = 'msBtnRaised'
        OnClick = TrayMenuItemStyleClick
      end
      object TrayMenuItemStyleItemPainter: TMenuItem
        Tag = 2
        Caption = 'msItemPainter'
        OnClick = TrayMenuItemStyleClick
      end
      object TrayMenuItemStyleOffice: TMenuItem
        Tag = 3
        Caption = 'msOffice'
        OnClick = TrayMenuItemStyleClick
      end
      object TrayMenuItemStyleOwnerDraw: TMenuItem
        Tag = 4
        Caption = 'msOwnerDraw'
        OnClick = TrayMenuItemStyleClick
      end
      object TrayMenuItemStyleStandard: TMenuItem
        Tag = 5
        Caption = 'msStandard'
        Checked = True
        OnClick = TrayMenuItemStyleClick
      end
      object TrayMenuItemStyleXP: TMenuItem
        Tag = 6
        Caption = 'msXP'
        OnClick = TrayMenuItemStyleClick
      end
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object TrayMenuItemHide: TMenuItem
      Caption = 'Hide'
      OnClick = TrayMenuItemHideClick
    end
    object TrayMenuItemQuit: TMenuItem
      Caption = 'Quit'
      OnClick = TrayMenuItemQuitClick
    end
  end
  object JvAppInstances: TJvAppInstances
    Left = 96
    Top = 116
  end
end
