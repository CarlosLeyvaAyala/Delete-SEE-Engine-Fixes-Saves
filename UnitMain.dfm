object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Delete saves'
  ClientHeight = 276
  ClientWidth = 793
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  ShowHint = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object ctgrypnlgrp1: TCategoryPanelGroup
    Left = 0
    Top = 0
    Width = 209
    Height = 276
    VertScrollBar.Tracking = True
    HeaderFont.Charset = DEFAULT_CHARSET
    HeaderFont.Color = clWindowText
    HeaderFont.Height = -11
    HeaderFont.Name = 'Tahoma'
    HeaderFont.Style = []
    TabOrder = 0
    object ctgrypnlOptions: TCategoryPanel
      Top = 0
      Height = 249
      Caption = 'Options'
      TabOrder = 0
      object lbl1: TLabel
        Left = 16
        Top = 38
        Width = 11
        Height = 13
        Caption = 'All'
      end
      object lbl2: TLabel
        Left = 16
        Top = 8
        Width = 29
        Height = 13
        Caption = 'Leave'
      end
      object lbl3: TLabel
        Left = 112
        Top = 8
        Width = 70
        Height = 13
        Caption = 'Before (hours)'
      end
      object lbl4: TLabel
        Left = 16
        Top = 73
        Width = 51
        Height = 13
        Caption = '2 min span'
      end
      object lbl41: TLabel
        Left = 16
        Top = 113
        Width = 51
        Height = 13
        Caption = '5 min span'
      end
      object lbl411: TLabel
        Left = 16
        Top = 153
        Width = 57
        Height = 13
        Caption = '10 min span'
      end
      object lbl412: TLabel
        Left = 16
        Top = 193
        Width = 57
        Height = 13
        Caption = '15 min span'
      end
      object nmbrbxLeaveAlone: TNumberBox
        Left = 112
        Top = 35
        Width = 70
        Height = 21
        Mode = nbmFloat
        MaxValue = 9999.000000000000000000
        TabOrder = 0
        Value = 0.250000000000000000
        SpinButtonOptions.Placement = nbspCompact
      end
      object nmbrbx2min: TNumberBox
        Left = 112
        Top = 70
        Width = 70
        Height = 21
        Mode = nbmFloat
        MaxValue = 9999.000000000000000000
        TabOrder = 1
        Value = 1.000000000000000000
        SpinButtonOptions.Placement = nbspCompact
      end
      object nmbrbx5min: TNumberBox
        Left = 112
        Top = 110
        Width = 70
        Height = 21
        Mode = nbmFloat
        MaxValue = 9999.000000000000000000
        TabOrder = 2
        Value = 3.000000000000000000
        SpinButtonOptions.Placement = nbspCompact
      end
      object nmbrbx10min: TNumberBox
        Left = 112
        Top = 150
        Width = 70
        Height = 21
        Mode = nbmFloat
        MaxValue = 9999.000000000000000000
        TabOrder = 3
        Value = 6.000000000000000000
        SpinButtonOptions.Placement = nbspCompact
      end
      object nmbrbx15min: TNumberBox
        Left = 112
        Top = 193
        Width = 70
        Height = 21
        Mode = nbmFloat
        MaxValue = 9999.000000000000000000
        TabOrder = 4
        Value = 24.000000000000000000
        SpinButtonOptions.Placement = nbspCompact
      end
    end
  end
  object lstOutput: TListBox
    Left = 209
    Top = 0
    Width = 584
    Height = 276
    Align = alClient
    ItemHeight = 13
    TabOrder = 1
  end
end
