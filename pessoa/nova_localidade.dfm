object formNovaLocalidade: TformNovaLocalidade
  Left = 389
  Top = 276
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Nova Localidade'
  ClientHeight = 207
  ClientWidth = 459
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Verdana'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  Position = poScreenCenter
  OnKeyDown = FormKeyDown
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 459
    Height = 207
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Panel1'
    TabOrder = 0
    object Bevel1: TBevel
      Left = 0
      Top = 164
      Width = 459
      Height = 2
      Align = alBottom
      Shape = bsBottomLine
      ExplicitTop = 143
      ExplicitWidth = 443
    end
    object pnlBotoes: TPanel
      Left = 0
      Top = 166
      Width = 459
      Height = 41
      Align = alBottom
      BevelOuter = bvNone
      TabOrder = 0
      object cxButton1: TcxButton
        Left = 136
        Top = 8
        Width = 91
        Height = 25
        Cursor = crHandPoint
        Caption = 'OK'
        ModalResult = 1
        TabOrder = 0
        LookAndFeel.Kind = lfStandard
        LookAndFeel.NativeStyle = True
      end
      object cxButton2: TcxButton
        Left = 240
        Top = 8
        Width = 91
        Height = 25
        Cursor = crHandPoint
        Cancel = True
        Caption = 'Cancelar'
        TabOrder = 1
        OnClick = cxButton2Click
        LookAndFeel.Kind = lfStandard
        LookAndFeel.NativeStyle = True
      end
    end
    object pnlDados: TPanel
      Left = 0
      Top = 0
      Width = 459
      Height = 164
      Align = alClient
      BevelOuter = bvNone
      Color = clCream
      ParentBackground = False
      TabOrder = 1
      object lbLogradouro: TLabel
        Left = 120
        Top = 32
        Width = 283
        Height = 13
        Caption = 'Logradouro (somente nome da rua, avenida, etc)'
        FocusControl = edLogradouro
      end
      object Image1: TImage
        Left = 24
        Top = 38
        Width = 65
        Height = 70
        Picture.Data = {
          0954474946496D6167654749463839613B003C00F700008CB2DB878CBA9196C4
          4B556F696F944D50518BADD9A9AAA9E2E4E5D2ECFED8E1E5B7D2EC37536E99C1
          E7A9D6F585B4E5A6C3B4567596EAEDF1A8AA9982A1D1DBDDE1FDFEFF83A5C479
          B0F05C6489B9E2FD85BAF2CAC5B1D1D2D4A6C3D37AA6B04E698CEAFDFFCCD2D5
          CBEAFFEAEBECA5BDD8E7E3DBA3CEFE9BBBE1C4E5FCD9DADEDBF0FF88ABA386A6
          9D759C95C6CCD395BBE38BC1F779A6D7C2DAF3BAC3C6F2F2F29CB9DE496C92F8
          F3E87AA5CB7A9DC3E9F6FE8A8A7B8BACD15E82AC33394E6C8CB3C1C2C4C0D7E7
          B9DAF43A455C7178A494C8D6F1FFFEA9D1EC9AA999ACCBEBB2CDEAD3D5D7CBCB
          CC9A96857296BBADB2B7446285A8B5A699B5DCB5C4D6EFF4F9ADC4E490ADD9E4
          EAEDD5F1FF678887656767A0C6E991B4DDE3FBFFB1D3F091C3FBD8EDFF9CCAFE
          526E90E4F2FE83AAD3D5D8DCCFE6E969827DEDF1F6F9FFFEB9BAC599B5A96B48
          3543658983B4BA4A6789A3C1E3445E7D90BAC5587BA1B0B0B09C9C9F5B7B78C1
          E8FFE2D9C9ADC8E5B3D8F496A0A94865856E91B77B9ED04B6773797A7B6488B0
          84AEDB3E5D808FB0DAC5C6C8A5C9EBE5E7E8C2BAA7848888C9E7FE72968EA0BC
          E099B3C895B5DE6B95C28EBCF46A7C715A61686887A0C4C9CBBABDBFA6B8CB94
          ADC97FA298BBD5F079859767919C57627AF6FFFE5E8B8FB6B7A7FDFCF48B8E93
          8FB2DCACADB0A1A5CB99BBBA8FC2E4DCF7FF94C1F2EFF9FF90A3B9506B66A49D
          8D6A9AD695B2DC577086D9D3C3819C93A3CDDFB6B9BC63736E7D83AF909D8CED
          EAE19BC5F3585C5BF8F9F99BC7FC58726C94C9FF4F383335363E88A5CF748F8D
          74736C6C9EA6B2B5B962635D95B8E095BAD3766C699AB4D4BED1D48FB3D16770
          7FB0DEFCBAD3BFF6F6F893BDE694B1DC4E698496B5DB46688F837F7398BDD450
          6F8CB6AF9ECFEFFF83A6D66A8F8CD1E5FAA9C6E79BB5DF638BBFE6F0F391B3DA
          7D96ADF5F9FBF2F7FAC9C9C98EB6E188A8D7424442D9D8D2DFE0E1ABCDCE4167
          6A8EA7BAF9F6EF8CAFAAB5BFAFC4E0F4BEDEF8CAE0F86D5A5198CFEABDCBBEF0
          EFEB94B59CB0D2F99BBCEA4F70948CAD9B497579FFFFFF21F90400000000002C
          000000003B003C000008FF00FF09A401049C410AC11222A440E1C21F8614FE3C
          5C98B0A2C58A0C27320C061161B01E572E9911F80FDA383F3A285C79454D5A0F
          03E8B65190A971E2B69BE8D05DD97945E71503067AC6C49913664E7441A57D6B
          7469978555297B14B261634AA19C448FC6ECB80D9DB4423CAF802D54489AD89D
          64C98A355A549A0D14362EBD08864999B24625AC54350B346CCE323771167AF5
          6ACAB72988A93D224C581AE12936147F7B354A2CD22EDF6C3CEAB1EAE3AB4671
          AC58D163A5115596365EFD84191869DF57361AC9A66AE330E26F99A9C2A52DCD
          40A12EE2C05ED0114C9C8DBCA249C7313DE55117B240B146FC63805A23696564
          18886D9A766DDC9965C3FF7D4416C0A841327400C1C47DB495E5D4D2A67D5EC8
          000003DBAE58519086441A2C690881DE20E73CE2DC818F1CF3D66C8F8CE2607D
          DBB8028E0FC118200E35DC99D6C57D406D63DF2B8FA0304A302F2080480DF82C
          73811ECBCC50851EAE6020C320A348E3E0285D18A860838500509F013248E803
          26C1FD06DC86400135886F21C6C199191588A08E09889860023E08C078482A32
          60B001064B2E99A4010E02E0E37DE80959C272A0A1704C175D8C82A601627681
          492F8090D2821649242185145494610A3B1E0030480C3160E0A50C38C209278E
          379A879F848294A0C412982EE14D1C6E3ABA6117288C03482FBDB022092077A0
          214B0B90B8720104103CFFF3CC2C0F6C0086A21B1C78CCAEBC76710C0C300020
          0324957AE3CD120B2CB0841E4AC4C1E9868FC4E1C33477C8C2472F77B4E30F37
          C2C8C2021B73CC01011B6F18318B2F1B6C80EE036E3E728EA3BBBA790C7A3AF8
          5102B3C82EA0871EC6EECBA9127EC8810D088444700703EDB473C71D1FB8204B
          262EB0004FB9A76C10832FB7C610C95B30ECFAEE3966FE7A4E30179480E9029A
          68B28012FBE63B032605F353CDCCED30902A1B8C68C10D2739BCF101319C9C12
          831862A40BC6AD0DA00083D2BF027B0EB00F50F084327178A3C70233CCA0B2B2
          C8CE304D146EB81145147DF8C34A3B68FCD902239F10532E311F8801462416FB
          82AEC59A1E1247037CA3FFB00FB083E4E0470FD14413C72197A29CF202F40021
          073F37CC0C42E468D4C2CA2D1324F1303CB07E62C40374DB0D86AD626090CB0C
          2B1FB26903717011CD037FF891C38CE734C085374AE47EC8129AC00107216083
          ED060392DC22491299B7D0820BF07CF2C91BA95C3CFAC5274C4F8FD64B287108
          17AE3FF0400E3AF43088F7A7F0CD3DE243E840C80D61B73FBC24A0642E493CB2
          08F3090B9C4060442AB56E20C609BE8801184AA78F1574236B9AF8C221B6C705
          665CE01A5CE05B030A673BEE69820E84685F35C2B6C15A38810713E0419F9607
          8F4C40E00D1878C0D04E908B54F8A27A18E00519C21086032670017BD0470930
          1107242061095F506004FF6D7788286CD00D8448E2CCDC008B094CA015894884
          1464C18D0F202307B338051840978A13FC4F63B722C30A6AD88D6ED0831EF398
          87151CA187216862083318C217B4C70524F42083339BD90DF6E8861BC0420A4E
          98403692C08D1CE4E00183388511ECB1815C88411F7303C3092281816ECC9086
          344C4002BAB18012606D1EF290C70CE631843D7C411EEAE3E011DD0002388CA1
          0FC210862412C1817E185206140080221D300B7B3C2017BC9824DDF4A18A1D18
          930CC81CA3103CA0077D7C610F43180229A399822730007290ABC60DF811816E
          460008C2D0C22D38200B1DE880191FA89D3A53D1C548DE4A1F9E50C511C87104
          5514330C42A0821E1CF0FF4C6846339AF2F00321C600071060839BDD04412B6F
          10011F3471021F28033188D10390ED631FFA38C42C667182499ACE9E20DD8118
          F1498559EC019A6924E549E5010442D0819B63180336B03106108C611AFCE007
          1D2220CE5B08030DDCC8C41BA2718E38982256103085294EF051638A548C2B48
          C032E3E080935A959F0E988740B1D1CD9AF2C3A60A05013FFA50503AD0811217
          B880234C11D11EBCA11FCFF8D6B7D8F106248C14936394AA070EE10C07F81509
          7EF52B1E9E20870828741A7D000159131B05DF71930E40100424FC000973CEE1
          1A6F90021B2226B14CB0E01061588468479B82792CA1044248410A16515A0D68
          E0A47860861C6011D3DAFFDA740C5FAD2908E83006B30A02087E40470ECE2103
          53E02C132D8047C4E03184D02660049A0C83269729044DAE600559C8E4084620
          8F3E1054B15100811CE020873E8C170451A8291D7CF0044800A15E392803045C
          E0824C78F613FD784318C688C94C2E0209D758001E16A18D046883B5AA856E04
          5C09D6567E37B137004104AAB1D36A0001084FD0411990210546300262DCF844
          3EE6205DBC4A37051A6820129CC162D73AC3B51A70C6087430DEF2C281AC056D
          6C62E5A0D06C4ED69C9080452BF6C408177CB805B3C8822635B9DD11E0010F0B
          F0803CB491056D6CF7C94F86AE3C783C36DD16D4BB391E43046456807A8CC107
          39700311D690843B7C98FF11FDF8401694ECE44560F9C900FE021EB441E539F3
          99CFA8D84133140B3C573218049D68466309C18002FCA20DC3A0C30D18408400
          DC8303F1C80437B8D10054FCD9C07DAEF23291A0813B97FAC99E46453388B0C1
          3E802DB1649D46206C91C4E13D3A1951B8411F2A9D834B98A01F77A0430250E1
          052F646105A820B6B2CFB08C798CE0CF7F9EB32214200460D0810185F65D41C5
          FA8322F8200AEB4B471B9A71E622144100958DC51D3EC10735A8A109B40881BC
          43B08310149BD9F240C59C939DEC10400118D61800116A10012210020EFC1883
          1CE44008F3FE80080A9543068A40005B08A014021004381C010A564CC30EBBC0
          473A7E61827F58C0DD6AFFF0C41110208233F0FBE521B8470174010C3E980118
          C3C3B64DB1D1879E33E00740FF412708D0892204400040F0810F0EC08A0F50E1
          070A68C22F7E810B9298FC1F6A404407CE506C2FD85BDE4778C1C30780850274
          221C636000B86B1AD308289C08401F401106408000F4D6ACC2E08404FEA18B0C
          ACA10081B080D50562014488000B213882E28F90F8703CFC079BE80430C26101
          095C3BBD0A35343FC80B77A29FFB0692AE051FC8E0090B500118B6C038164C2E
          7893AB81E558F084BBAD6E8687C3FD072F50C3113CE10977308001314D784D23
          408701FC80EEE79E193668B07BC5AB81063F204011A8F08FE62F1EF68A97BDBB
          2D507BB86FC2292ADFFDFF3F144089DF8737A60785C3F1EB1E00068C030BBA5F
          FC11FEB1096010A114F15F7C08988DF8ECF3FE1F22F0033FC704FFC07BBC377B
          16A000E3000B7DC04A484408C7970116A70029E77FB3C707C03000A530781650
          781D800527A70621F80FD007771210821DD881222810BBD009C0370DAB400011
          786E2AB87D29F80F50707C02D07A56A77524307802C1078FB70B40C8819D4004
          45B081FF9601045077445884FF2076031000E500843E588418F87308008524B1
          0B053000A9F70FCD107D45307169C085C5908101708683778540480A0F070C50
          C0852C480412280055300944D00901300019500150080D05208045B07A6DD801
          3F0884525800224087FFFF2001C07000759706C6500FA0D00444A008D00085BB
          A08703200A7B7788893878355000C6500092C083455876B8B005A25003008703
          88000CD9F00E50D801E9A00BC39007AA28106E38785EA80B93900E23C1858890
          0E3870003C800BB1180AE9E004B6088416B005C6D00AC6900745F88B56378DBA
          B005E9400A74888BEF6006C3100BE9900D26670C3C8003D9488B665000D86885
          885884C550005B1008D9800F745809C6100A65C70105C00126970CD9C08E40E8
          85D9E085D6108D3D8888ADD781FF708C05A000C32090297891576706BA100A2F
          600CEB708E1DB805898003177983A2300CA1F09189D08B5A570169500555500E
          E5400E81A00B965003BAFF100BE500933CC99333B90EC6000DC5600D35900EAD
          F00EE52092F8400E32A90A325905160005C650757C500026B0933099062A5009
          FC91065E590EEBB00526600115600DB8500312100E12B0966C2901FF1108EF40
          0A7C000DC6E004F820015BC001B880052480055820017E490E95300C265005E4
          D00CAD80968089052240039610042F200291490BBA200A3440035B6007952002
          22C0046660062AA002EBA00008800093A00266F08AA2609769A0941240027D89
          0808C098CDA00BEA200198590BB3299B2A1004B4400B95D0049CC9045B690841
          500176C00750C00415A0001550019F69064CE0999D59012A80088A609BEB1008
          4EA0021DF09D1DE09966E0500CB4500C4CB00E50500986B00E08B00E15600896
          500CEB8008EEA9024C109ED32902CF5901F7F99D22009EE2299DE2A9088A6022
          41400AA56922A5E99EEBC09EEBA002090A9D4CE09BF169014D809AF799A1001A
          9E2AF09CEEF99CA8D9A11DFA9CB0890888800F58D2A0F5A9A22CAAA2D2099F96
          600975F00FBB600EF7D904C61904C699A396F09B31FA983A6A0E4130A486600E
          396A084D90A44A6AA4496A0E4ADA044C8AA3433AA475B08902D101A470000760
          075CDAA55AAAA5A490A5617A00A450075F0AA6659AA6695A07665AA675E0A66C
          5A07C5500C71DA01021110003B}
        Transparent = True
      end
      object lbBairro: TLabel
        Left = 120
        Top = 72
        Width = 35
        Height = 13
        Caption = 'Bairro'
        FocusControl = edBairro
      end
      object lbCEP: TLabel
        Left = 120
        Top = 112
        Width = 23
        Height = 13
        Caption = 'CEP'
        FocusControl = edCEP
      end
      object lbTitulo: TLabel
        Left = 24
        Top = 8
        Width = 53
        Height = 16
        Caption = 'lbTitulo'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Verdana'
        Font.Style = [fsBold]
        ParentFont = False
      end
      object edLogradouro: TcxTextEdit
        Left = 119
        Top = 47
        Properties.CharCase = ecUpperCase
        TabOrder = 0
        OnEnter = edLogradouroEnter
        OnExit = edLogradouroExit
        Width = 306
      end
      object edBairro: TcxTextEdit
        Left = 119
        Top = 87
        Properties.CharCase = ecUpperCase
        TabOrder = 1
        OnEnter = edLogradouroEnter
        OnExit = edLogradouroExit
        Width = 306
      end
      object edCEP: TcxTextEdit
        Left = 119
        Top = 127
        Properties.CharCase = ecUpperCase
        TabOrder = 2
        OnEnter = edLogradouroEnter
        OnExit = edLogradouroExit
        Width = 130
      end
    end
  end
end
