/*
** ROTINA DE REINICIO DA BASE
*/

SET TERM ^ ;

ALTER TRIGGER MOVIMENTOS_AFTUPD
INACTIVE AFTER UPDATE POSITION 0
AS
DECLARE VARIABLE CODORIGEM INTEGER;
DECLARE VARIABLE CODUSUARIO INTEGER;
DECLARE VARIABLE TEMP_CODIGO INTEGER;
DECLARE VARIABLE TEMP_CODPRODUTO INTEGER;
DECLARE VARIABLE TEMP_SERIE VARCHAR(20);
DECLARE VARIABLE TEMP_SERIE2 VARCHAR(20);
DECLARE VARIABLE TEMP_VALOR_VENDA NUMERIC(9,2);
DECLARE VARIABLE TEMP_DESCONTO NUMERIC(9,2);
DECLARE VARIABLE TEMP_BARRA VARCHAR(20);
DECLARE VARIABLE TEMP_ICMSVENDA NUMERIC(9,4);
DECLARE VARIABLE TEMP_QUANTIDADE NUMERIC(9,2);
BEGIN

  IF (NEW.ES IN (0, 1, 2)) THEN
   BEGIN

     IF (((NEW.VALOR_TOTAL <> OLD.VALOR_TOTAL) OR
        (NEW.CONDICAO <> OLD.CONDICAO)) AND
        (NEW.TIPO IN (0, 1, 2, 5))) THEN
       EXECUTE PROCEDURE GERAPARCELAS(NEW.CODIGO);

     IF ((NEW.TIPO IN (3, 6)) AND (OLD.TIPO IN (2, 5))) THEN
      BEGIN

        EXECUTE PROCEDURE COMISSAO_CALC(NEW.CODIGO);

        EXECUTE PROCEDURE AUTOBAIXA(NEW.CODIGO);

        EXECUTE PROCEDURE CADASTRA_EQUIPAMENTO(NEW.CODIGO);

      END

   END

  /* ESTORNO */
  IF ((NEW.TIPO = 9) AND (OLD.TIPO <> 9)) THEN
   BEGIN

     /* COMPRA OU VENDA */
     IF (NEW.ES = 2) THEN
      BEGIN

        /* GUARDO OS ITENS ESTORNADOS */
        FOR
        SELECT
          CODPRODUTO,
          SERIE,
          SERIE2,
          VALOR_VENDA,
          DESCONTO,
          BARRA,
          ICMSVENDA,
          SUM(QUANTIDADE)
        FROM
          INDIVIDUAIS
        WHERE
          CODMOVSAIDA = NEW.CODIGO
        GROUP BY
          CODPRODUTO,
          SERIE,
          SERIE2,
          VALOR_VENDA,
          DESCONTO,
          BARRA,
          ICMSVENDA
        INTO
          TEMP_CODPRODUTO,
          TEMP_SERIE,
          TEMP_SERIE2,
          TEMP_VALOR_VENDA,
          TEMP_DESCONTO,
          TEMP_BARRA,
          TEMP_ICMSVENDA,
          TEMP_QUANTIDADE
        DO
        BEGIN

          /* CODIGO UNICO DO TEMPITENS */
          EXECUTE PROCEDURE SEQ_OBTER('TEMPITENS')
            RETURNING_VALUES TEMP_CODIGO;

          /* GUARDO ITEM UM A UM */
          INSERT INTO
            TEMPITENS (
              CODIGO,
              CODMOVIMENTO,
              CODPRODUTO,
              QUANTIDADE,
              VALOR_UNITARIO,
              DESCONTO,
              SITTRIBU,
              MARGEM,
              REAJUSTAR,
              VALOR_VENDA,
              ICMSCOMPRA,
              ICMSVENDA,
              IPI,
              SERIE,
              SERIE2,
              BARRA)
            VALUES (
              :TEMP_CODIGO,
              NEW.CODIGO,
              :TEMP_CODPRODUTO,
              :TEMP_QUANTIDADE,
              :TEMP_VALOR_VENDA,
              :TEMP_DESCONTO,
              '0.0',
              0,
              'N',
              (:TEMP_VALOR_VENDA - :TEMP_DESCONTO),
              :TEMP_ICMSVENDA,
              :TEMP_ICMSVENDA,
              0,
              :TEMP_SERIE,
              :TEMP_SERIE2,
              :TEMP_BARRA);

        END

        /* VERIFICO SE POSSUI MOVIMENTA��O DE ESTOQUE */
        IF (NEW.NO_ESTOQUE = 'S') THEN
         BEGIN

           /* DEVOLVO OS PRODUTOS */
           UPDATE
             INDIVIDUAIS
           SET
             VENDIDO = 'N'
           WHERE
             CODMOVSAIDA = NEW.CODIGO;

         END ELSE
         BEGIN

           /* DEVOLVO OS PRODUTOS */
           UPDATE
             INDIVIDUAIS
           SET
             VENDIDO = 'N'
           WHERE
             CODMOVSAIDA = NEW.CODIGO;

         END

        /* VERIFICO SE EXISTE MOVIMENTACAO FINANCEIRA */
        IF (NEW.NO_VENDA = 'S') THEN
         BEGIN

           /* CODIGO DO USUARIO */
           SELECT
             CODIGO
           FROM
             CLIENTES
           WHERE
             NOMEUSER = NEW.USUARIOESTORNO
           INTO
             :CODUSUARIO;

           /* VERIFICO OS PAGAMENTOS E ESTORNO 1 A 1 */
           FOR
           SELECT
             CODIGO
           FROM
             PAGAMENTOS
           WHERE
             CODMOVIMENTO = NEW.CODIGO
           INTO
             :CODORIGEM
           DO
             EXECUTE PROCEDURE FINANC_ESTORNO(:CODORIGEM, :CODUSUARIO);

         END

      END ELSE
      BEGIN

        /* SIMPLESMENTE EXCLUO OS ITENS */
        DELETE FROM
          INDIVIDUAIS
        WHERE
          CODMOVENTRADA = NEW.CODIGO;

        /* CODIGO DO USUARIO */
        SELECT
          CODIGO
        FROM
          CLIENTES
        WHERE
          NOMEUSER = NEW.USUARIOESTORNO
        INTO
          :CODUSUARIO;

        /* VERIFICO OS PAGAMENTOS E ESTORNO 1 A 1 */
        FOR
        SELECT
          CODIGO
        FROM
          PAGAMENTOS
        WHERE
          CODMOVIMENTO = NEW.CODIGO
        INTO
          :CODORIGEM
        DO
          EXECUTE PROCEDURE FINANC_ESTORNO(:CODORIGEM, :CODUSUARIO);

      END

   END

END
^

SET TERM ; ^

UPDATE
  MOVIMENTOS
SET
  FECHA_DATA_FLUXO = NULL;

SET TERM ^ ;

ALTER TRIGGER MOVIMENTOS_VENDEDOR_UPD
ACTIVE BEFORE UPDATE POSITION 0
AS
BEGIN
  /* NOME DO VENDEDOR */
  SELECT
    NOME
  FROM
    CLIENTES
  WHERE
    CODIGO = NEW.CODVENDEDOR
  INTO
    NEW.NOME_VENDEDOR;

  /* LINHA DO CLIENTE */
  SELECT
    CL.CODLINHA
  FROM
    CLIENTES CL
  WHERE
    CL.CODIGO = NEW.CODCLIENTE
  INTO
    NEW.CODLINHA;

  /* TERRITORIO DA OS */
  SELECT FIRST 1
    CE.TERRITORIO
  FROM
    CLI_EQUIP CE
  WHERE
    CE.CODCLIENTE = NEW.CODCLIENTE AND
    CE.CODMARCA = NEW.CODMARCA AND
    CE.CODMODELO = NEW.CODMODELO AND
    CE.SERIE = NEW.SERIE
  INTO
    NEW.TERRITORIO;

END
^

SET TERM ; ^

SET TERM ^ ;

ALTER TRIGGER STATUS_UPDATE
ACTIVE BEFORE UPDATE POSITION 0
AS
DECLARE VARIABLE PRIMEIRO TIMESTAMP;
DECLARE VARIABLE ULTIMO TIMESTAMP;
DECLARE VARIABLE TOTAL DOUBLE PRECISION;
DECLARE VARIABLE TDATAINI TIMESTAMP;
DECLARE VARIABLE TDATAFIM TIMESTAMP;
BEGIN

   /* DATA DA ENTREGA */
   IF ((NEW.QUEM_RECEBEU IS NOT NULL) AND (OLD.QUEM_RECEBEU IS NULL)) THEN
     NEW.DATA_ENTREGA = CURRENT_TIMESTAMP;

   /* DATA DA AUTORIZA��O */
   IF ((NEW.QUEM_AUTORIZOU IS NOT NULL) AND (OLD.QUEM_AUTORIZOU IS NULL)) THEN
     NEW.DATA_AUTORIZADO = CURRENT_TIMESTAMP;

   /* CONFIGURA��ES DO HIST�RIO DE PAGAMENTOS */
   IF (NEW.CODHISTORICOPAG IS NOT NULL) THEN
    BEGIN
      SELECT
        CODNATUOPER
      FROM
        HISTORICOPAG
      WHERE
        CODIGO = NEW.CODHISTORICOPAG
      INTO
        NEW.NOTA_CODNATUOPER;
    END

   /* CONFIGURA��ES DA NATUREZA DE OPERA��O */
   SELECT
     VENDA,
     ESTOQUE,
     ICMS,
     IPI
   FROM
     NATUOPER
   WHERE
     CODIGO = NEW.NOTA_CODNATUOPER
   INTO
     NEW.NO_VENDA,
     NEW.NO_ESTOQUE,
     NEW.NO_ICMS,
     NEW.NO_IPI;

   IF (NEW.TIPO = 1) THEN
    BEGIN

      IF (NEW.ES = 0) THEN
       BEGIN
         NEW.STATUS = 'ORC ABERTO';
         IF (NEW.AUTORIZADO = 'S') THEN
          BEGIN
            NEW.STATUS = 'ORC AUTORIZADO';
          END ELSE
          BEGIN
            IF (NEW.DATA_AUTORIZADO IS NOT NULL) THEN
              NEW.STATUS = 'ORC NAO AUTO';
            IF ((NEW.RETORNO = 'S') AND (NEW.DATA_RETORNO IS NOT NULL)) THEN
              NEW.STATUS = 'ORC RETORNAR';
          END
       END

      IF (NEW.ES = 1) THEN
       BEGIN
         IF (NEW.FECHADO = 'S') THEN
            NEW.STATUS = 'COMPRA';
         ELSE
            NEW.STATUS = 'PED COMPRA';
       END

    END

   IF (NEW.TIPO = 2) THEN
    BEGIN
      NEW.STATUS = 'OS ABERTA';

      /* VERIFICO SE O TECNICO J� INICIOU */
      SELECT FIRST 1
        DATAINI,
        DATAFIM
      FROM
        OS_VENDER
      WHERE
        CODMOVIMENTO = NEW.CODIGO
      INTO
        :TDATAINI,
        :TDATAFIM;

      IF (TDATAINI IS NOT NULL) THEN
       BEGIN
         NEW.STATUS = 'OS INICIADA';

         IF (NEW.DATA_AUTORIZADO IS NOT NULL) THEN
          BEGIN

            IF (NEW.AUTORIZADO = 'N') THEN
              NEW.STATUS = 'OS NAO AUTO';
            ELSE
              IF (TDATAFIM IS NULL) THEN
                NEW.STATUS = 'OS AUTORIZADA';
              ELSE
                NEW.STATUS = 'OS CONCLUIDA';
          END

         IF (NEW.DATA_ENTREGA IS NOT NULL) THEN
           NEW.STATUS = 'OS ENTREGUE';

       END
    END

   IF (NEW.TIPO = 3) THEN NEW.STATUS = 'OS FECHADA';
   IF (NEW.TIPO = 4) THEN NEW.STATUS = 'PRODU��O';
   IF (NEW.TIPO = 5) THEN NEW.STATUS = 'VENDA ABERTA';
   IF (NEW.TIPO = 6) THEN NEW.STATUS = 'VENDA FECHADA';
   IF (NEW.TIPO = 7) THEN NEW.STATUS = 'N/F';
   IF (NEW.TIPO = 8) THEN NEW.STATUS = 'REMESSA';
   IF (NEW.TIPO = 9) THEN NEW.STATUS = 'ESTORNO';

   /* VERIFICO O NUMERADOR */
   EXECUTE PROCEDURE VALIDA_NUMERADOR(NEW.NUMERADOR, NEW.CODCLIENTE,
     NEW.CODMARCA, NEW.CODMODELO, NEW.SERIE);

   /* CALCULAR IMPOSTOS */
   IF ((NEW.ES = 2)                  AND
       (NEW.TIPO IN (3, 6))          AND
       (OLD.TIPO IN (2, 5)))         THEN
    BEGIN
      /* TOTAL ICMS */
      EXECUTE PROCEDURE CALC_ICMS(NEW.CODIGO)
        RETURNING_VALUES NEW.VALOR_ICMS, NEW.VALOR_IPI_PRODUTOS,
          NEW.NOTA_BASEICMS;
      IF (NEW.NO_ICMS = 'N') THEN
        NEW.VALOR_ICMS = 0;
      IF (NEW.NO_IPI = 'N') THEN
        NEW.VALOR_IPI_PRODUTOS = 0;
      IF (NEW.NOTA_BASEICMS IS NULL) THEN
        NEW.NOTA_BASEICMS = 0;
    END

   /* FECHOU A VENDA */
   IF ((OLD.TIPO IN (2, 5)) AND (NEW.TIPO IN (3, 6))) THEN
    BEGIN

      /* USU�RIO, DATA E HORA DO FECHAMENTO */
      NEW.DATAFECHAMENTO = 'NOW';

      NEW.FECHADO = 'S';

      IF ((UDF_TRIM(NEW.USUARIOFECHAMENTO) = '') OR (NEW.USUARIOFECHAMENTO IS NULL)) THEN
        NEW.USUARIOFECHAMENTO = USER;

      /* VINCULAR SERIAL NA VENDA FECHADA */
      IF (NEW.TIPO = 6) THEN
        EXECUTE PROCEDURE VINCULO_SERIE NEW.CODIGO
          RETURNING_VALUES NEW.SERIE;

      /* TEMPOS DE ATENDIMENTO, SE FOR OS */
      IF (NEW.TIPO = 3) THEN
       BEGIN

         SELECT
           MIN(DATAINI),
           MAX(DATAFIM),
           SUM(THORAS)
         FROM
           OS_VENDER
         WHERE
           CODMOVIMENTO = NEW.CODIGO
         INTO
           :PRIMEIRO,
           :ULTIMO,
           :TOTAL;

         NEW.TEMPO_CHEGADA    = CAST(
           UDF_MINUTESBETWEEN(NEW.DATA, PRIMEIRO)
           AS DOUBLE PRECISION) / 60;

         NEW.TEMPO_CONCLUSAO  = CAST(
           UDF_MINUTESBETWEEN(NEW.DATA, ULTIMO)
           AS DOUBLE PRECISION) / 60;

         NEW.TEMPO_LANCAMENTO = CAST(
           UDF_MINUTESBETWEEN(ULTIMO, NEW.DATAFECHAMENTO)
           AS DOUBLE PRECISION) / 60;

         NEW.TEMPO_TECNICOS = TOTAL;

         NEW.DATAINICIO  = PRIMEIRO;

         NEW.DATATERMINO = ULTIMO;

         IF (PRIMEIRO > NEW.DATAPREVISAO) THEN
           NEW.TEMPO_FORADOPRAZO = CAST(
             UDF_MINUTESBETWEEN(NEW.DATAPREVISAO, PRIMEIRO)
             AS DOUBLE PRECISION) / 60;
         ELSE
           NEW.TEMPO_FORADOPRAZO = 0;

       END

      NEW.TEMPO_CICLO = CAST(
        UDF_MINUTESBETWEEN(NEW.DATA, NEW.DATAFECHAMENTO)
        AS DOUBLE PRECISION) / 60;

    END

   /* RATEIO DOS CUSTOS DE COMPRA */
   IF ((NEW.ES = 1) AND (NEW.TIPO = 1)) THEN
     EXECUTE PROCEDURE RATEIO_CUSTOS (
       NEW.CODIGO,
       NEW.VALOR_PRODUTOS,
       NEW.VALOR_RATEIO_CUSTO);

END
^

SET TERM ; ^

SET TERM ^ ;

ALTER TRIGGER MOVIMENTOS_AFTUPD
ACTIVE AFTER UPDATE POSITION 0
AS
DECLARE VARIABLE CODORIGEM INTEGER;
DECLARE VARIABLE CODUSUARIO INTEGER;
DECLARE VARIABLE TEMP_CODIGO INTEGER;
DECLARE VARIABLE TEMP_CODPRODUTO INTEGER;
DECLARE VARIABLE TEMP_SERIE VARCHAR(20);
DECLARE VARIABLE TEMP_SERIE2 VARCHAR(20);
DECLARE VARIABLE TEMP_VALOR_VENDA NUMERIC(9,2);
DECLARE VARIABLE TEMP_DESCONTO NUMERIC(9,2);
DECLARE VARIABLE TEMP_BARRA VARCHAR(20);
DECLARE VARIABLE TEMP_ICMSVENDA NUMERIC(9,4);
DECLARE VARIABLE TEMP_QUANTIDADE NUMERIC(9,2);
BEGIN

  IF (NEW.ES IN (0, 1, 2)) THEN
   BEGIN

     IF (((NEW.VALOR_TOTAL <> OLD.VALOR_TOTAL) OR
        (NEW.CONDICAO <> OLD.CONDICAO)) AND
        (NEW.TIPO IN (0, 1, 2, 5))) THEN
       EXECUTE PROCEDURE GERAPARCELAS(NEW.CODIGO);

     IF ((NEW.TIPO IN (3, 6)) AND (OLD.TIPO IN (2, 5))) THEN
      BEGIN

        EXECUTE PROCEDURE COMISSAO_CALC(NEW.CODIGO);

        EXECUTE PROCEDURE AUTOBAIXA(NEW.CODIGO);

        EXECUTE PROCEDURE CADASTRA_EQUIPAMENTO(NEW.CODIGO);

      END

   END

  /* ESTORNO */
  IF ((NEW.TIPO = 9) AND (OLD.TIPO <> 9)) THEN
   BEGIN

     /* COMPRA OU VENDA */
     IF (NEW.ES = 2) THEN
      BEGIN

        /* GUARDO OS ITENS ESTORNADOS */
        FOR
        SELECT
          CODPRODUTO,
          SERIE,
          SERIE2,
          VALOR_VENDA,
          DESCONTO,
          BARRA,
          ICMSVENDA,
          SUM(QUANTIDADE)
        FROM
          INDIVIDUAIS
        WHERE
          CODMOVSAIDA = NEW.CODIGO
        GROUP BY
          CODPRODUTO,
          SERIE,
          SERIE2,
          VALOR_VENDA,
          DESCONTO,
          BARRA,
          ICMSVENDA
        INTO
          TEMP_CODPRODUTO,
          TEMP_SERIE,
          TEMP_SERIE2,
          TEMP_VALOR_VENDA,
          TEMP_DESCONTO,
          TEMP_BARRA,
          TEMP_ICMSVENDA,
          TEMP_QUANTIDADE
        DO
        BEGIN

          /* CODIGO UNICO DO TEMPITENS */
          EXECUTE PROCEDURE SEQ_OBTER('TEMPITENS')
            RETURNING_VALUES TEMP_CODIGO;

          /* GUARDO ITEM UM A UM */
          INSERT INTO
            TEMPITENS (
              CODIGO,
              CODMOVIMENTO,
              CODPRODUTO,
              QUANTIDADE,
              VALOR_UNITARIO,
              DESCONTO,
              SITTRIBU,
              MARGEM,
              REAJUSTAR,
              VALOR_VENDA,
              ICMSCOMPRA,
              ICMSVENDA,
              IPI,
              SERIE,
              SERIE2,
              BARRA)
            VALUES (
              :TEMP_CODIGO,
              NEW.CODIGO,
              :TEMP_CODPRODUTO,
              :TEMP_QUANTIDADE,
              :TEMP_VALOR_VENDA,
              :TEMP_DESCONTO,
              '0.0',
              0,
              'N',
              (:TEMP_VALOR_VENDA - :TEMP_DESCONTO),
              :TEMP_ICMSVENDA,
              :TEMP_ICMSVENDA,
              0,
              :TEMP_SERIE,
              :TEMP_SERIE2,
              :TEMP_BARRA);

        END

        /* VERIFICO SE POSSUI MOVIMENTA��O DE ESTOQUE */
        IF (NEW.NO_ESTOQUE = 'S') THEN
         BEGIN

           /* DEVOLVO OS PRODUTOS */
           UPDATE
             INDIVIDUAIS
           SET
             VENDIDO = 'N'
           WHERE
             CODMOVSAIDA = NEW.CODIGO;

         END ELSE
         BEGIN

           /* DEVOLVO OS PRODUTOS */
           UPDATE
             INDIVIDUAIS
           SET
             VENDIDO = 'N'
           WHERE
             CODMOVSAIDA = NEW.CODIGO;

         END

        /* VERIFICO SE EXISTE MOVIMENTACAO FINANCEIRA */
        IF (NEW.NO_VENDA = 'S') THEN
         BEGIN

           /* CODIGO DO USUARIO */
           SELECT
             CODIGO
           FROM
             CLIENTES
           WHERE
             NOMEUSER = NEW.USUARIOESTORNO
           INTO
             :CODUSUARIO;

           /* VERIFICO OS PAGAMENTOS E ESTORNO 1 A 1 */
           FOR
           SELECT
             CODIGO
           FROM
             PAGAMENTOS
           WHERE
             CODMOVIMENTO = NEW.CODIGO
           INTO
             :CODORIGEM
           DO
             EXECUTE PROCEDURE FINANC_ESTORNO(:CODORIGEM, :CODUSUARIO);

         END

      END ELSE
      BEGIN

        /* SIMPLESMENTE EXCLUO OS ITENS */
        DELETE FROM
          INDIVIDUAIS
        WHERE
          CODMOVENTRADA = NEW.CODIGO;

        /* CODIGO DO USUARIO */
        SELECT
          CODIGO
        FROM
          CLIENTES
        WHERE
          NOMEUSER = NEW.USUARIOESTORNO
        INTO
          :CODUSUARIO;

        /* VERIFICO OS PAGAMENTOS E ESTORNO 1 A 1 */
        FOR
        SELECT
          CODIGO
        FROM
          PAGAMENTOS
        WHERE
          CODMOVIMENTO = NEW.CODIGO
        INTO
          :CODORIGEM
        DO
          EXECUTE PROCEDURE FINANC_ESTORNO(:CODORIGEM, :CODUSUARIO);

      END

   END

END
^

SET TERM ; ^

SET TERM ^ ;

ALTER TRIGGER PAGAMENTOS_BU0
INACTIVE BEFORE UPDATE POSITION 0
AS
DECLARE VARIABLE ULTIMO     INTEGER;
DECLARE VARIABLE SALDO      NUMERIC(9, 2);
DECLARE VARIABLE SALDONOVO  NUMERIC(9, 2);
BEGIN

  /* CARREGO AS OPCOES DO DOCUMENTO */
  SELECT
    TIPO_PAG,
    TIPO_DOC
  FROM
    DOCUMENTOS
  WHERE
    CODIGO = NEW.CODDOCUMENTO
  INTO
    NEW.TIPO_PAG,
    NEW.TIPO_DOC;

  /* FOI ESTORNADO? */
  IF ((OLD.ESTORNO_CODUSUARIO IS NULL) AND (NEW.ESTORNO_CODUSUARIO IS NOT NULL)) THEN
   BEGIN

     SELECT
       NOMEUSER
     FROM
       CLIENTES
     WHERE
       CODIGO = NEW.ESTORNO_CODUSUARIO
     INTO
       NEW.ESTORNO_NOMEUSER;

   END

  /* ESTA PAGO? */
  IF ((OLD.PAGO = 0) AND (NEW.PAGO = 1)) THEN
   BEGIN

     /* DESCUBRO O SALDO ANTERIOR */
     SELECT
       MAX(CODLANCTO)
     FROM
       PAGAMENTOS
     WHERE
       CODCONTA = NEW.CODCONTA AND
       CODEMPRESA = NEW.CODEMPRESA
     INTO
       :ULTIMO;

     IF (ULTIMO IS NOT NULL) THEN
      BEGIN

        SELECT
          SALDOATU
        FROM
          PAGAMENTOS
        WHERE
          CODLANCTO = :ULTIMO
        INTO
          :SALDO;

      END ELSE SALDO = 0;

     /* PEGO O NUMERO DESTE LANCAMENTO */
     SELECT
       SEQUENCIA
     FROM
       SEQ_OBTER('LANCTO')
     INTO
       :ULTIMO;

     /* GRAVO OS VALORES CORRETOS */
     NEW.SALDOANT = SALDO;

     IF (NEW.ES = 1) THEN
       SALDONOVO = SALDO - NEW.TOTAL_PAGO;

     IF (NEW.ES = 2) THEN
       SALDONOVO = SALDO + NEW.TOTAL_PAGO;

     NEW.SALDOATU = SALDONOVO;
     NEW.DATAPAGO = 'NOW';
     NEW.CODLANCTO = ULTIMO;

   END
END
^

SET TERM ; ^


SET TERM ^ ;

ALTER TRIGGER PAGAMENTOS_BU100
ACTIVE BEFORE UPDATE POSITION 100
AS
DECLARE VARIABLE DIA_FLUXO INTEGER;
BEGIN

  /* STATUS */
  IF (NEW.PAGO = 0) THEN
   BEGIN
     IF (NEW.ES IN (3, 4)) THEN
       NEW.STATUS = 'LIXEIRA';
     ELSE
       NEW.STATUS = 'ABERTO';
   END ELSE
     NEW.STATUS = 'PAGO';

  /* ANALISE DE VALORES */
  IF (NEW.ES = 1) THEN
    NEW.VALOR_FLUXO = (NEW.TOTAL_PAGO * -1);

  IF (NEW.ES = 2) THEN
    NEW.VALOR_FLUXO = NEW.TOTAL_PAGO;

  /* VALOR POR EXTENSO */
  EXECUTE PROCEDURE MOEDAEXTENSO NEW.TOTAL_PAGO, NEW.CODEMPRESA
    RETURNING_VALUES NEW.EXTENSO;

  /* ANALISE DE DATAS - CADASTRO */
  IF (NEW.DATACADAST IS NOT NULL) THEN
    EXECUTE PROCEDURE ANALISE_DATA(NEW.DATACADAST)
      RETURNING_VALUES
        NEW.CAD_DATA_FLUXO,
        DIA_FLUXO,
        NEW.CAD_SEMANA_FLUXO,
        NEW.CAD_MES_FLUXO,
        NEW.CAD_BIMESTRE_FLUXO,
        NEW.CAD_TRIMESTRE_FLUXO,
        NEW.CAD_QUADRIMESTRE_FLUXO,
        NEW.CAD_SEMESTRE_FLUXO,
        NEW.CAD_ANO_FLUXO,
        NEW.CAD_STR_SEMANA_FLUXO,
        NEW.CAD_STR_MES_FLUXO,
        NEW.CAD_STR_BIMESTRE_FLUXO,
        NEW.CAD_STR_TRIMESTRE_FLUXO,
        NEW.CAD_STR_QUADRIMESTRE_FLUXO,
        NEW.CAD_STR_SEMESTRE_FLUXO;

  /* ANALISE DE DATAS - VENCIMENTO */
  IF (NEW.DATAVENCIMENTO IS NOT NULL) THEN
    EXECUTE PROCEDURE ANALISE_DATA(NEW.DATAVENCIMENTO)
      RETURNING_VALUES
        NEW.VEN_DATA_FLUXO,
        DIA_FLUXO,
        NEW.VEN_SEMANA_FLUXO,
        NEW.VEN_MES_FLUXO,
        NEW.VEN_BIMESTRE_FLUXO,
        NEW.VEN_TRIMESTRE_FLUXO,
        NEW.VEN_QUADRIMESTRE_FLUXO,
        NEW.VEN_SEMESTRE_FLUXO,
        NEW.VEN_ANO_FLUXO,
        NEW.VEN_STR_SEMANA_FLUXO,
        NEW.VEN_STR_MES_FLUXO,
        NEW.VEN_STR_BIMESTRE_FLUXO,
        NEW.VEN_STR_TRIMESTRE_FLUXO,
        NEW.VEN_STR_QUADRIMESTRE_FLUXO,
        NEW.VEN_STR_SEMESTRE_FLUXO;

  /* ANALISE DE DATAS - PAGAMENTO */
  IF (NEW.DATAPAGO IS NOT NULL) THEN
    EXECUTE PROCEDURE ANALISE_DATA(NEW.DATAPAGO)
      RETURNING_VALUES
        NEW.PAG_DATA_FLUXO,
        DIA_FLUXO,
        NEW.PAG_SEMANA_FLUXO,
        NEW.PAG_MES_FLUXO,
        NEW.PAG_BIMESTRE_FLUXO,
        NEW.PAG_TRIMESTRE_FLUXO,
        NEW.PAG_QUADRIMESTRE_FLUXO,
        NEW.PAG_SEMESTRE_FLUXO,
        NEW.PAG_ANO_FLUXO,
        NEW.PAG_STR_SEMANA_FLUXO,
        NEW.PAG_STR_MES_FLUXO,
        NEW.PAG_STR_BIMESTRE_FLUXO,
        NEW.PAG_STR_TRIMESTRE_FLUXO,
        NEW.PAG_STR_QUADRIMESTRE_FLUXO,
        NEW.PAG_STR_SEMESTRE_FLUXO;

END
^

SET TERM ; ^

UPDATE
  PAGAMENTOS
SET
  PAG_DATA_FLUXO = NULL;
  
SET TERM ^ ;

ALTER TRIGGER PAGAMENTOS_BU0
ACTIVE BEFORE UPDATE POSITION 0
AS
DECLARE VARIABLE ULTIMO     INTEGER;
DECLARE VARIABLE SALDO      NUMERIC(9, 2);
DECLARE VARIABLE SALDONOVO  NUMERIC(9, 2);
BEGIN

  /* CARREGO AS OPCOES DO DOCUMENTO */
  SELECT
    TIPO_PAG,
    TIPO_DOC
  FROM
    DOCUMENTOS
  WHERE
    CODIGO = NEW.CODDOCUMENTO
  INTO
    NEW.TIPO_PAG,
    NEW.TIPO_DOC;

  /* FOI ESTORNADO? */
  IF ((OLD.ESTORNO_CODUSUARIO IS NULL) AND (NEW.ESTORNO_CODUSUARIO IS NOT NULL)) THEN
   BEGIN

     SELECT
       NOMEUSER
     FROM
       CLIENTES
     WHERE
       CODIGO = NEW.ESTORNO_CODUSUARIO
     INTO
       NEW.ESTORNO_NOMEUSER;

   END

  /* ESTA PAGO? */
  IF ((OLD.PAGO = 0) AND (NEW.PAGO = 1)) THEN
   BEGIN

     /* DESCUBRO O SALDO ANTERIOR */
     SELECT
       MAX(CODLANCTO)
     FROM
       PAGAMENTOS
     WHERE
       CODCONTA = NEW.CODCONTA AND
       CODEMPRESA = NEW.CODEMPRESA
     INTO
       :ULTIMO;

     IF (ULTIMO IS NOT NULL) THEN
      BEGIN

        SELECT
          SALDOATU
        FROM
          PAGAMENTOS
        WHERE
          CODLANCTO = :ULTIMO
        INTO
          :SALDO;

      END ELSE SALDO = 0;

     /* PEGO O NUMERO DESTE LANCAMENTO */
     SELECT
       SEQUENCIA
     FROM
       SEQ_OBTER('LANCTO')
     INTO
       :ULTIMO;

     /* GRAVO OS VALORES CORRETOS */
     NEW.SALDOANT = SALDO;

     IF (NEW.ES = 1) THEN
       SALDONOVO = SALDO - NEW.TOTAL_PAGO;

     IF (NEW.ES = 2) THEN
       SALDONOVO = SALDO + NEW.TOTAL_PAGO;

     NEW.SALDOATU = SALDONOVO;
     NEW.DATAPAGO = 'NOW';
     NEW.CODLANCTO = ULTIMO;

   END
END
^

SET TERM ; ^

SET TERM ^ ;

ALTER PROCEDURE REINICIAR (
    ROTINA INTEGER)
AS
DECLARE VARIABLE CODCLIENTE1 INTEGER;
DECLARE VARIABLE CODCLIENTE2 INTEGER;
BEGIN

  /* DETERMINO A ROTINA */
  IF (ROTINA IS NULL) THEN
    ROTINA = 0;

  /* LIMPAR TUDO */
  IF (ROTINA = 0) THEN
   BEGIN

     /* SEQUENCIA */
     DELETE FROM
       ITSEQUENCIA;

     /* PAGAMENTOS */
     UPDATE
       PAGAMENTOS
     SET PAGO = 0;

     DELETE FROM
       COMISSOES;

     DELETE FROM
       CAIXAS;

     DELETE FROM
       PAGAMENTOS;

     UPDATE
       SEQUENCIA
     SET
       SEQUENCIA = 1
     WHERE
       TABELA = 'PAGAMENTOS';

     /* ESTOQUE */
     UPDATE
       INDIVIDUAIS
     SET
       VENDIDO = 'N';

     DELETE FROM
       MOVESTOQUE;

     DELETE FROM
       INDIVIDUAIS;

     DELETE FROM
       TEMPITENS;

     UPDATE
       SEQUENCIA
     SET
       SEQUENCIA = 1
     WHERE
       TABELA = 'INDIVIDUAIS';

     UPDATE
       SEQUENCIA
     SET
       SEQUENCIA = 1
     WHERE
       TABELA = 'TEMPITENS';

     /* PRODUTOS */
     DELETE FROM
       VARIACAO_VALOR;

     DELETE FROM
       CONTRATOS;

     DELETE FROM
       COMPOSICAO;

     DELETE FROM
       PRODUTOS;

     UPDATE
       SEQUENCIA
     SET
       SEQUENCIA = 10000
     WHERE
       TABELA = 'PRODUTOS';

     /* MOVIMENTOS */
     DELETE FROM
       OS_VENDER;

     DELETE FROM
       MOVIMENTOS;

     UPDATE
       SEQUENCIA
     SET
       SEQUENCIA = 10000
     WHERE
       TABELA = 'MOVIMENTOS';

     /* EMPRESAS */
     DELETE FROM
       TRANSFERENCIAS;

     DELETE FROM
       SISCONFIG
     WHERE
       CODIGO > 1;

     /* CLIENTES */
     SELECT
       SI.CODCLIENTE,
       SI.CODCLIENTE_PADRAO
     FROM
       SISCONFIG SI
     WHERE
       SI.CODIGO = 1
     INTO
       :CODCLIENTE1,
       :CODCLIENTE2;

     DELETE FROM
       MENSAGENS;

     DELETE FROM
       CLIENTES
     WHERE
       CODIGO NOT IN (:CODCLIENTE1, :CODCLIENTE2);

     UPDATE
       SEQUENCIA
     SET
       SEQUENCIA = UDF_MAX(:CODCLIENTE1, :CODCLIENTE2) + 1
     WHERE
       TABELA = 'CLIENTES';

     UPDATE
       CLIENTES
     SET
       NOMEUSER = 'SYSDBA',
       SENHAWEB = 'MORAIS77',
       DESCONTO = 0,
       FINANCEIRO = 'S',
       ESTORNO = 'S',
       TROCAVENDEDOR = 'S',
       INTERNET = 'S',
       MUDAEMPRESA = 'S',
       COMISSAO = 0,
       TIPO = 'A',
       RECEBIMENTO = 'S',
       CUSTO = 'S',
       SEQUENCIAS = 'S',
       RECALCULO = 'S',
       COMPRAS = 'S',
       TRANSFERENCIA = 'S',
       RELATORIOS = 'S',
       VENDADIRETA = 'S',
       TECNICOLOGIN = 'N',
       FECHAMENTO = 'S'
     WHERE
       CODIGO = :CODCLIENTE1;


   END

END
^

SET TERM ; ^

INSERT INTO SCRIPTVER(NUMERO, DATA) VALUES (373, CURRENT_TIMESTAMP);
COMMIT;

