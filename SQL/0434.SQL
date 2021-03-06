/*
** STATUS ANTIGOS
*/

SET TERM ^ ;

ALTER TRIGGER MOVIMENTOS_VENDEDOR_UPD
INACTIVE BEFORE UPDATE POSITION 0
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
BEGIN

   /* DATA DA ENTREGA */
   IF ((NEW.QUEM_RECEBEU IS NOT NULL) AND (OLD.QUEM_RECEBEU IS NULL)) THEN
     NEW.DATA_ENTREGA = CURRENT_TIMESTAMP;

   /* DATA DA AUTORIZA��O */
   IF ((NEW.QUEM_AUTORIZOU IS NOT NULL) AND (OLD.QUEM_AUTORIZOU IS NULL)) THEN
     NEW.DATA_AUTORIZADO = CURRENT_TIMESTAMP;

   IF (NEW.TIPO = 2) THEN
    BEGIN
      NEW.STATUS = 'OS ABERTA';

      /* VERIFICO SE O TECNICO J� INICIOU */
      SELECT
        MIN(CODVENDEDOR),
        MIN(DATAINI),
        MAX(DATAFIM)
      FROM
        OS_VENDER
      WHERE
        CODMOVIMENTO = NEW.CODIGO
      INTO
        NEW.CODTECNICO,
        NEW.DATAINICIO,
        NEW.DATATERMINO;

      IF (NEW.DATAINICIO IS NOT NULL) THEN
       BEGIN
         NEW.STATUS = 'OS INICIADA';

         IF (NEW.DATA_AUTORIZADO IS NOT NULL) THEN
          BEGIN

            IF (NEW.AUTORIZADO = 'N') THEN
              NEW.STATUS = 'OS NAO AUTO';
            ELSE
              IF (NEW.DATATERMINO IS NULL) THEN
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

END
^

SET TERM ; ^

UPDATE 
  MOVIMENTOS
SET
  CODTECNICO = NULL;

SET TERM ^ ;

ALTER TRIGGER STATUS_UPDATE
ACTIVE BEFORE UPDATE POSITION 0
AS
DECLARE VARIABLE PRIMEIRO TIMESTAMP;
DECLARE VARIABLE ULTIMO TIMESTAMP;
DECLARE VARIABLE TOTAL DOUBLE PRECISION;
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
      SELECT
        MIN(CODVENDEDOR),
        MIN(DATAINI),
        MAX(DATAFIM)
      FROM
        OS_VENDER
      WHERE
        CODMOVIMENTO = NEW.CODIGO
      INTO
        NEW.CODTECNICO,
        NEW.DATAINICIO,
        NEW.DATATERMINO;

      IF (NEW.DATAINICIO IS NOT NULL) THEN
       BEGIN
         NEW.STATUS = 'OS INICIADA';

         IF (NEW.DATA_AUTORIZADO IS NOT NULL) THEN
          BEGIN

            IF (NEW.AUTORIZADO = 'N') THEN
              NEW.STATUS = 'OS NAO AUTO';
            ELSE
              IF (NEW.DATATERMINO IS NULL) THEN
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
      NEW.DATAFECHAMENTO = CURRENT_TIMESTAMP;

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

        SELECT FIRST 1
          CODVENDEDOR
        FROM
          OS_VENDER
        WHERE
          CODMOVIMENTO = NEW.CODIGO
        INTO
          NEW.CODTECNICO;

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

INSERT INTO SCRIPTVER(NUMERO, DATA) VALUES (434, CURRENT_TIMESTAMP);
COMMIT;
