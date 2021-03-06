/*
** TABELA DE INTEGRA��O
*/

CREATE TABLE CONTABIL (
    CODIGO INTEGER NOT NULL,
    DESCRICAO VARCHAR(50) NOT NULL,
    OBSERVACOES VARCHAR(254),
    CONTADEBITO INTEGER,
    CONTACREDITO INTEGER);

ALTER TABLE CONTABIL
ADD CONSTRAINT PK_CONTABIL
PRIMARY KEY (CODIGO);

ALTER TABLE CONTABIL
ADD CONSTRAINT FK_CONTABIL_1
FOREIGN KEY (CONTADEBITO)
REFERENCES PLANCONTAS(CODIGO)
ON UPDATE CASCADE;

ALTER TABLE CONTABIL
ADD CONSTRAINT FK_CONTABIL_2
FOREIGN KEY (CONTACREDITO)
REFERENCES PLANCONTAS(CODIGO)
ON UPDATE CASCADE;

GRANT ALL ON CONTABIL TO PUBLIC;

INSERT INTO
  SEQUENCIA
VALUES (
  80,
  'CONTABIL',
  1);
  
SET TERM ^ ;

CREATE TRIGGER CONTABIL_BI0 FOR CONTABIL
ACTIVE BEFORE INSERT POSITION 0
AS
BEGIN

  IF (NEW.CONTADEBITO = NEW.CONTACREDITO) THEN
   BEGIN

     EXCEPTION ERRO 'AS CONTAS N�O PODEM SER IGUAIS';

   END

END
^

SET TERM ; ^

SET TERM ^ ;

CREATE TRIGGER CONTABIL_BU0 FOR CONTABIL
ACTIVE BEFORE UPDATE POSITION 0
AS
BEGIN

  IF (NEW.CONTADEBITO = NEW.CONTACREDITO) THEN
   BEGIN

     EXCEPTION ERRO 'AS CONTAS N�O PODEM SER IGUAIS';

   END

END
^

SET TERM ; ^
  
INSERT INTO SCRIPTVER(NUMERO, DATA) VALUES (406, CURRENT_TIMESTAMP);
COMMIT;
