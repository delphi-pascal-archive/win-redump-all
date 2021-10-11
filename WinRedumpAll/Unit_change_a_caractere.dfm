object Form_change_a_char: TForm_change_a_char
  Left = 469
  Top = 369
  Width = 267
  Height = 86
  Caption = 'Changer un caractere'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  PixelsPerInch = 120
  TextHeight = 16
  object Edit_change: TEdit
    Left = 16
    Top = 16
    Width = 94
    Height = 27
    TabOrder = 0
    Text = 'Edit_change'
    OnChange = Edit_changeChange
  end
  object Button_change: TButton
    Left = 131
    Top = 14
    Width = 112
    Height = 30
    Caption = '&Changer'
    ModalResult = 1
    TabOrder = 1
    OnClick = Button_changeClick
  end
end
