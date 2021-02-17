object frmServidor: TfrmServidor
  Left = 0
  Top = 0
  ClientHeight = 145
  ClientWidth = 340
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object edtPorta: TLabeledEdit
    Left = 16
    Top = 24
    Width = 121
    Height = 21
    EditLabel.Width = 26
    EditLabel.Height = 13
    EditLabel.Caption = 'Porta'
    TabOrder = 0
    Text = '7000'
  end
  object btnIniciar: TButton
    Left = 168
    Top = 24
    Width = 75
    Height = 25
    Caption = 'Iniciar'
    TabOrder = 1
    OnClick = mitIniciarClick
  end
  object btnParar: TButton
    Left = 263
    Top = 24
    Width = 75
    Height = 25
    Caption = 'Parar'
    TabOrder = 2
    OnClick = mitPararClick
  end
  object btnFechar: TButton
    Left = 263
    Top = 110
    Width = 75
    Height = 25
    Caption = 'Fechar'
    TabOrder = 3
    OnClick = mitFecharClick
  end
  object AppEvents: TApplicationEvents
    OnMinimize = AppEventsMinimize
    Left = 135
    Top = 48
  end
  object PopupTrayIcon: TPopupMenu
    Left = 134
    Top = 99
    object mitIniciar: TMenuItem
      Caption = 'Iniciar'
    end
    object mitParar: TMenuItem
      Caption = 'Parar'
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object mitFechar: TMenuItem
      Caption = 'Fechar'
    end
  end
  object TrayIcon: TTrayIcon
    PopupMenu = PopupTrayIcon
    Visible = True
    OnDblClick = TrayIconDblClick
    Left = 39
    Top = 98
  end
  object FDPhysPgDriverLink1: TFDPhysPgDriverLink
    DriverID = 'PG_DRIVER'
    VendorLib = 
      'F:\Arquivos Desenvolvimento Geral\Reposit'#243'rios GitHub\Aprendizad' +
      'os-Geral\ProjetoHorse-React\backend\lib\libpq.dll'
    Left = 40
    Top = 48
  end
end
