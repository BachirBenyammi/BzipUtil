object Form1: TForm1
  Left = 224
  Top = 149
  Width = 555
  Height = 446
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'BZIP Utility -BENBAC SOFT-'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 8
    Top = 8
    Width = 45
    Height = 13
    Caption = 'Filename:'
  end
  object SpeedButton1: TSpeedButton
    Left = 512
    Top = 24
    Width = 23
    Height = 22
    Caption = '...'
    OnClick = SpeedButton1Click
  end
  object Button1: TButton
    Left = 72
    Top = 200
    Width = 75
    Height = 25
    Caption = 'Launch'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 312
    Top = 200
    Width = 75
    Height = 25
    Caption = 'Help'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 392
    Top = 200
    Width = 75
    Height = 25
    Caption = 'About'
    TabOrder = 2
    OnClick = Button3Click
  end
  object Edit_Filename: TEdit
    Left = 32
    Top = 24
    Width = 473
    Height = 21
    TabOrder = 3
  end
  object Button4: TButton
    Left = 232
    Top = 200
    Width = 75
    Height = 25
    Caption = 'View output'
    TabOrder = 4
    OnClick = Button4Click
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 393
    Width = 547
    Height = 19
    Panels = <
      item
        Width = 150
      end
      item
        Width = 150
      end
      item
        Width = 150
      end>
  end
  object Button6: TButton
    Left = 152
    Top = 200
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 6
    OnClick = Button6Click
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 48
    Width = 529
    Height = 145
    Caption = 'Options'
    TabOrder = 7
    object cb_compression: TCheckBox
      Left = 16
      Top = 24
      Width = 113
      Height = 17
      Caption = 'Force compression'
      TabOrder = 0
    end
    object cb_decompression: TCheckBox
      Left = 16
      Top = 48
      Width = 121
      Height = 17
      Caption = 'Force decompression'
      TabOrder = 1
    end
    object cb_keep: TCheckBox
      Left = 16
      Top = 72
      Width = 97
      Height = 17
      Caption = 'Keep input files'
      Checked = True
      State = cbChecked
      TabOrder = 2
    end
    object cb_overwrite: TCheckBox
      Left = 16
      Top = 96
      Width = 121
      Height = 17
      Caption = 'Overwrite output files'
      TabOrder = 3
    end
    object cb_test: TCheckBox
      Left = 16
      Top = 120
      Width = 161
      Height = 17
      Caption = 'Test compressed file integrity'
      TabOrder = 4
    end
    object cb_output: TCheckBox
      Left = 192
      Top = 24
      Width = 129
      Height = 17
      Caption = 'Output to standard out'
      TabOrder = 5
    end
    object cb_suppress: TCheckBox
      Left = 192
      Top = 48
      Width = 193
      Height = 17
      Caption = 'Suppress noncritical error messages'
      TabOrder = 6
    end
    object cb_memory: TCheckBox
      Left = 192
      Top = 96
      Width = 185
      Height = 17
      Caption = 'Use small memory (at most 2500k)'
      TabOrder = 7
    end
    object cb_block: TComboBox
      Left = 272
      Top = 112
      Width = 57
      Height = 21
      Style = csDropDownList
      Enabled = False
      ItemHeight = 13
      TabOrder = 8
      Items.Strings = (
        '100 K'
        '200'#13' K'
        '300 K'
        '400 K'
        '500 K'
        '600 K'
        '700 K'
        '800 K'
        '900 K')
    end
    object cb_blocksize: TCheckBox
      Left = 192
      Top = 120
      Width = 73
      Height = 17
      Caption = 'Block size'
      TabOrder = 9
      OnClick = cb_blocksizeClick
    end
    object rb_none: TRadioButton
      Left = 192
      Top = 72
      Width = 49
      Height = 17
      Caption = 'none'
      TabOrder = 10
    end
    object rb_simple: TRadioButton
      Left = 248
      Top = 72
      Width = 49
      Height = 17
      Caption = 'simple'
      TabOrder = 11
    end
    object rb_more: TRadioButton
      Left = 304
      Top = 72
      Width = 49
      Height = 17
      Caption = 'more'
      Checked = True
      TabOrder = 12
      TabStop = True
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 232
    Width = 529
    Height = 161
    Caption = 'Output'
    TabOrder = 8
    object Memo1: TMemo
      Left = 8
      Top = 16
      Width = 505
      Height = 137
      Color = clScrollBar
      ReadOnly = True
      ScrollBars = ssBoth
      TabOrder = 0
    end
  end
  object OD: TOpenDialog
    Left = 504
    Top = 24
  end
end
