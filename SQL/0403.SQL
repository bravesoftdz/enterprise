/*
** TRADUTOR
*/

ALTER TABLE PLANCONTAS ADD TRADUTOR INTEIRO;

INSERT INTO
  SEQUENCIA 
VALUES (
  75,
  'TRADUTOR',
  1);
  
CREATE UNIQUE INDEX TRADUTOR_UI1 ON PLANCONTAS (TRADUTOR);

INSERT INTO SCRIPTVER(NUMERO, DATA) VALUES (403, CURRENT_TIMESTAMP);
COMMIT;
