program enterprise;

uses
  Forms,
  Sysutils,
  principal in 'principal\principal.pas' {formPrincipal},
  MODELO_CAD in 'repositorio\MODELO_CAD.PAS' {formCadModelo},
  MODELO_CONTA in 'repositorio\MODELO_CONTA.pas' {formContaModelo},
  MODELO_GRAFICO in 'repositorio\MODELO_GRAFICO.pas' {formModeloGrafico},
  MODELO_MOV in 'repositorio\MODELO_MOV.pas' {formMODELO_MOV},
  MODELO_OS in 'repositorio\MODELO_OS.pas' {formModeloOS},
  MODELO_RELATORIO in 'repositorio\MODELO_RELATORIO.pas' {formRepModelo},
  MODELO_SELCAMPOS in 'repositorio\MODELO_SELCAMPOS.pas' {formSelCampos},
  compra in 'compra\compra.pas' {formCompra},
  ativacao in 'venda\ativacao.pas' {formAtivacao},
  ativacoes in 'venda\ativacoes.pas' {formAtivacoes},
  saida in 'venda\saida.pas' {formSaida},
  saida_produtos in 'venda\saida_produtos.pas' {formSaidaProdutos},
  selpreco in 'venda\selpreco.pas' {formSelPreco},
  MODELO_VENDAS in 'repositorio\MODELO_VENDAS.pas' {formModeloVendas},
  vendas in 'venda\vendas.pas' {formVendas},
  estornovendas in 'venda\estornovendas.pas' {formEstornoVendas},
  trocasenha in 'dialogos\trocasenha.pas' {formTrocaSenha},
  connconfig in 'dialogos\connconfig.pas' {formConnConfig},
  login in 'dialogos\login.pas' {formLogin},
  reconcile in 'dialogos\reconcile.pas' {ReconcileErrorForm},
  regua in 'dialogos\regua.pas' {formRegua},
  selecionarempresa in 'dialogos\selecionarempresa.pas' {formSelecionarEmpresa},
  senha in 'dialogos\senha.pas' {formSenha},
  ecf in 'ecf\ecf.pas',
  bematech_mp20 in 'ecf\bematech_mp20.pas',
  daruma_fs345 in 'ecf\daruma_fs345.pas',
  prosoft in 'exportar\prosoft.pas' {formProsoft},
  plancontas in 'financeiro\plancontas.pas' {formPlancontas},
  baixa in 'financeiro\baixa.pas' {formBaixa},
  bancos in 'financeiro\bancos.pas' {formBancos},
  centros in 'financeiro\centros.pas' {formCentros},
  contapagaestorno in 'financeiro\contapagaestorno.pas' {formContaPagaEstorno},
  contapagar in 'financeiro\contapagar.pas' {formContaPagar},
  contapagarlixo in 'financeiro\contapagarlixo.pas' {formContaPagarLixo},
  contareceber in 'financeiro\contareceber.pas' {formContaReceber},
  contareceberlixo in 'financeiro\contareceberlixo.pas' {formContaReceberLixo},
  contarecebidaestorno in 'financeiro\contarecebidaestorno.pas' {formContaRecebidaEstorno},
  contas in 'financeiro\contas.pas' {formContas},
  contaspagas in 'financeiro\contaspagas.pas' {formContasPagas},
  contasrecebidas in 'financeiro\contasrecebidas.pas' {formContasRecebidas},
  documentos in 'financeiro\documentos.pas' {formDocumentos},
  extrato in 'financeiro\extrato.pas' {formExtrato},
  formapagamento in 'financeiro\formapagamento.pas' {formFormaPagamento},
  historicopag in 'financeiro\historicopag.pas' {formHistoricoPag},
  funcoes in 'funcoes\funcoes.pas',
  dosprint in 'funcoes\dosprint.pas',
  extenso in 'funcoes\extenso.pas',
  laycorpocampos in 'impressao\laycorpocampos.pas' {formCorpoCampos},
  laydupcampos in 'impressao\laydupcampos.pas' {formDupCampos},
  layprintmov in 'impressao\layprintmov.pas' {formImpMov},
  layprintmovcorpo in 'impressao\layprintmovcorpo.pas' {formImpMovCorpo},
  layprintmovdup in 'impressao\layprintmovdup.pas' {formImpMovDup},
  layprintmovpro in 'impressao\layprintmovpro.pas' {formImpMovPro},
  layprintmovser in 'impressao\layprintmovser.pas' {formImpMovSer},
  layprocampos in 'impressao\layprocampos.pas' {formProCampos},
  laysercampos in 'impressao\laysercampos.pas' {formSerCampos},
  printcupom in 'impressao\printcupom.pas' {formPrintCupom},
  printmov in 'impressao\printmov.pas' {formPrintmov},
  printrec in 'impressao\printrec.pas' {formPrintrec},
  impressoras in 'impressora\impressoras.pas' {formImpressoras},
  natuoper in 'natureza\natuoper.pas' {formNatuoper},
  ncm in 'ncm\ncm.pas' {formNCM},
  NFe_gerar in 'nfe\NFe_gerar.pas' {formNFeGerar},
  NFe_cancelar in 'nfe\NFe_cancelar.pas' {formNFeCancelar},
  orcamentos in 'orcamento\orcamentos.pas' {formOrcamentos},
  data_orcamentos in 'orcamento\data_orcamentos.pas' {dmoOrcamentos: TDataModule},
  orcamento in 'orcamento\orcamento.pas' {formOrcamento},
  veiculos in 'os\veiculos.pas' {formVeiculos},
  data_os in 'os\data_os.pas' {dmoOS: TDataModule},
  defeitos in 'os\defeitos.pas' {formDefeitos},
  estornoos in 'os\estornoos.pas' {formEstornoOS},
  incluirtecnico in 'os\incluirtecnico.pas' {formIncluirTecnico},
  marcas in 'os\marcas.pas' {formMarcas},
  modelos in 'os\modelos.pas' {formModelos},
  os in 'os\os.pas' {formOS},
  osged in 'os\osged.pas' {formOSGed},
  ostipos in 'os\ostipos.pas' {formOSTipos},
  perfil in 'perfil\perfil.pas' {formPerfil},
  pessoasequp in 'pessoa\pessoasequp.pas' {formPessoasEquip},
  bairros in 'pessoa\bairros.pas' {formBairros},
  cidades in 'pessoa\cidades.pas' {formCidades},
  estados in 'pessoa\estados.pas' {formEstados},
  logradouros in 'pessoa\logradouros.pas' {formLogradouros},
  nova_localidade in 'pessoa\nova_localidade.pas' {formNovaLocalidade},
  pessoas in 'pessoa\pessoas.pas' {formPessoas},
  usuarios in 'pessoa\usuarios.pas' {formUsuarios},
  unidades in 'produto\unidades.pas' {formUnidades},
  data_etiquetas in 'produto\data_etiquetas.pas' {dmoEtiquetas: TDataModule},
  grupos in 'produto\grupos.pas' {formGrupos},
  individuais in 'produto\individuais.pas' {formIndividuais},
  produtos in 'produto\produtos.pas' {formProdutos},
  reajuste in 'produto\reajuste.pas' {formReajuste},
  transferencias in 'produto\transferencias.pas' {formTransferencias},
  tributario in 'produto\tributario.pas' {formTributario},
  rep_procurvagrupo in 'relatorios\rep_procurvagrupo.pas' {formRepCurvaProGrupo},
  produtos_abc in 'relatorios\produtos_abc.pas' {formRepProdutosAbc},
  rel_estoque in 'relatorios\rel_estoque.pas' {formRelEstoque},
  rel_estoquedata in 'relatorios\rel_estoquedata.pas' {formRelEstoqueData},
  rel_estoqueminimo in 'relatorios\rel_estoqueminimo.pas' {formRelEstoqueMinimo},
  sequencias in 'sequencia\sequencias.pas' {formSequencias},
  servicos in 'servico\servicos.pas' {formServicos},
  planosservico in 'telecom\planosservico.pas' {formPlanosServico},
  operadoras in 'telecom\operadoras.pas' {formOperadoras},
  thSequencia in 'threads\thSequencia.pas',
  data_datahora in 'threads\data_datahora.pas' {dmoDataHora: TDataModule},
  data_log in 'threads\data_log.pas' {dmoLog: TDataModule},
  data_sequencia in 'threads\data_sequencia.pas' {dmoSequencia: TDataModule},
  thDataHora in 'threads\thDataHora.pas',
  lancontabil in 'contabilidade\lancontabil.pas' {formLanContabil},
  compras in 'compra\compras.pas' {formCompras},
  oslocaliza in 'os\oslocaliza.pas' {formOSLocaliza},
  status in 'os\status.pas' {formOSStatus},
  update in 'dialogos\update.pas' {formUpdate};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Enterprise Plus';
  Application.CreateForm(TformPrincipal, formPrincipal);
  Application.Run;
end.