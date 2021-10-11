object Form_rechercher: TForm_rechercher
  Left = 471
  Top = 356
  Width = 462
  Height = 82
  Caption = 'Rechercher'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object Label_chaine_a_rechercher: TLabel
    Left = 20
    Top = 20
    Width = 126
    Height = 16
    Caption = 'Chaine a rechercher :'
  end
  object Edit_chaine_a_rechercher: TEdit
    Left = 158
    Top = 15
    Width = 188
    Height = 21
    TabOrder = 0
    OnChange = Edit_chaine_a_rechercherChange
  end
  object BitBtn_chercher: TBitBtn
    Left = 359
    Top = 7
    Width = 93
    Height = 34
    Caption = 'Chercher'
    Default = True
    ModalResult = 1
    TabOrder = 1
    OnClick = BitBtn_chercherClick
  end
end
