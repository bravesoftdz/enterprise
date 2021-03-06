/*
** PERMISSÃO PARA ESTORNO DE PEÇAS
*/

ALTER TABLE CLIENTES ADD ESTORNO_PECA SIMNAO;

SET TERM ^ ;

CREATE OR ALTER TRIGGER CLIENTES_DOCUPD FOR CLIENTES
INACTIVE BEFORE UPDATE POSITION 0
AS
DECLARE VARIABLE RETORNO INTEGER;
BEGIN

  EXECUTE PROCEDURE VALIDA_CPF(NEW.CPF)
    RETURNING_VALUES RETORNO;

  IF (RETORNO = 0) THEN
    EXCEPTION CPF_ERRADO;

  EXECUTE PROCEDURE VALIDA_CNPJ(NEW.CGC)
    RETURNING_VALUES RETORNO;

  IF (RETORNO = 0) THEN
    EXCEPTION CGC_ERRADO;

END^

SET TERM ; ^

SET TERM ^ ;

CREATE OR ALTER TRIGGER CLIENTE_FAMILIA_UPDATE FOR CLIENTES
INACTIVE BEFORE UPDATE POSITION 0
AS
BEGIN
  /* NOME DE FAMILIA */
  IF (NEW.PESSOAFISICA = 'F') THEN
     EXECUTE PROCEDURE FAMILIA(NEW.NOME)
       RETURNING_VALUES NEW.NOME_FAMILIA;
  ELSE
     NEW.NOME_FAMILIA = NEW.NOME;
END^

SET TERM ; ^

UPDATE CLIENTES SET ESTORNO_PECA = 'N';

SET TERM ^ ;

CREATE OR ALTER TRIGGER CLIENTE_FAMILIA_UPDATE FOR CLIENTES
ACTIVE BEFORE UPDATE POSITION 0
AS
BEGIN
  /* NOME DE FAMILIA */
  IF (NEW.PESSOAFISICA = 'F') THEN
     EXECUTE PROCEDURE FAMILIA(NEW.NOME)
       RETURNING_VALUES NEW.NOME_FAMILIA;
  ELSE
     NEW.NOME_FAMILIA = NEW.NOME;
END^

SET TERM ; ^

SET TERM ^ ;

CREATE OR ALTER TRIGGER CLIENTES_DOCUPD FOR CLIENTES
ACTIVE BEFORE UPDATE POSITION 0
AS
DECLARE VARIABLE RETORNO INTEGER;
BEGIN

  EXECUTE PROCEDURE VALIDA_CPF(NEW.CPF)
    RETURNING_VALUES RETORNO;

  IF (RETORNO = 0) THEN
    EXCEPTION CPF_ERRADO;

  EXECUTE PROCEDURE VALIDA_CNPJ(NEW.CGC)
    RETURNING_VALUES RETORNO;

  IF (RETORNO = 0) THEN
    EXCEPTION CGC_ERRADO;

END^

SET TERM ; ^

INSERT INTO SCRIPTVER(NUMERO, DATA) VALUES (467, CURRENT_TIMESTAMP);
COMMIT;
