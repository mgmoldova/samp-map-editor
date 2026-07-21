object wnd_materials: Twnd_materials
  Left = 420
  Top = 250
  BorderStyle = bsDialog
  Caption = 'Object materials'
  ClientHeight = 330
  ClientWidth = 610
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 304
    Top = 20
    Width = 68
    Height = 13
    Caption = 'Material index'
  end
  object Label2: TLabel
    Left = 304
    Top = 68
    Width = 43
    Height = 13
    Caption = 'Model ID'
  end
  object Label3: TLabel
    Left = 304
    Top = 116
    Width = 49
    Height = 13
    Caption = 'TXD name'
  end
  object Label4: TLabel
    Left = 304
    Top = 164
    Width = 67
    Height = 13
    Caption = 'Texture name'
  end
  object Label5: TLabel
    Left = 304
    Top = 212
    Width = 104
    Height = 13
    Caption = 'Material color (ARGB)'
  end
  object lb_materials: TListBox
    Left = 12
    Top = 12
    Width = 276
    Height = 265
    ItemHeight = 13
    TabOrder = 0
    OnClick = lb_materialsClick
  end
  object inp_index: TEdit
    Left = 304
    Top = 36
    Width = 130
    Height = 21
    TabOrder = 1
    Text = '0'
  end
  object inp_model: TEdit
    Left = 304
    Top = 84
    Width = 130
    Height = 21
    TabOrder = 2
    Text = '0'
  end
  object cb_txd: TComboBox
    Left = 304
    Top = 132
    Width = 290
    Height = 21
    ItemHeight = 13
    Sorted = True
    TabOrder = 3
  end
  object cb_texture: TComboBox
    Left = 304
    Top = 180
    Width = 290
    Height = 21
    ItemHeight = 13
    Sorted = True
    TabOrder = 4
  end
  object inp_color: TEdit
    Left = 304
    Top = 228
    Width = 130
    Height = 21
    TabOrder = 5
    Text = '0x00000000'
  end
  object btn_add: TButton
    Left = 12
    Top = 288
    Width = 80
    Height = 25
    Caption = 'Add'
    TabOrder = 6
    OnClick = btn_addClick
  end
  object btn_delete: TButton
    Left = 100
    Top = 288
    Width = 80
    Height = 25
    Caption = 'Delete'
    TabOrder = 7
    OnClick = btn_deleteClick
  end
  object btn_apply: TButton
    Left = 304
    Top = 272
    Width = 90
    Height = 25
    Caption = 'Apply'
    TabOrder = 8
    OnClick = btn_applyClick
  end
  object btn_close: TButton
    Left = 504
    Top = 288
    Width = 90
    Height = 25
    Caption = 'Close'
    Default = True
    ModalResult = 1
    TabOrder = 9
    OnClick = btn_closeClick
  end
end
