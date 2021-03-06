/*
** NOTA FISCAL COM DATA CONFIGURAVEL
*/

SET TERM ^ ;

ALTER PROCEDURE NF_EMISSAO (
    codmovimento integer,
    nota_numero integer,
    nota_tipo char(3),
    data_emissao timestamp,
    data_saida timestamp)
as
BEGIN

  /* ATUALIZO O MOVIMENTO */
  UPDATE
    MOVIMENTOS MO
  SET
    MO.NOTA_NUMERO = :NOTA_NUMERO,
    MO.TIPODOC = :NOTA_TIPO,
    MO.NOTA_DATAEMISSAO = :DATA_EMISSAO,
    MO.NOTA_DATASAIDA = :DATA_SAIDA
  WHERE
    MO.CODIGO = :CODMOVIMENTO;

  /* ATUALIZO OS PAGAMENTOS */
  UPDATE
    PAGAMENTOS PA
  SET
    PA.NUMDOC = :NOTA_NUMERO,
    PA.DATADOC = CAST(:DATA_EMISSAO AS DATE),
    PA.TIPODOC = :NOTA_TIPO
  WHERE
    PA.CODMOVIMENTO = :CODMOVIMENTO;

END
^

SET TERM ; ^

INSERT INTO SCRIPTVER(NUMERO, DATA) VALUES (426, CURRENT_TIMESTAMP);
COMMIT;
