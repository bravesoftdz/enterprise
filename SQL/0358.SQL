/*
** CAMPOS DE EXCLUSAO DO FINANCEIRO
*/

ALTER TABLE PAGAMENTOS ADD EXCLUSAO_NOMEUSER STR30;

ALTER TABLE PAGAMENTOS ADD EXCLUSAO_DATAHORA DATA;

INSERT INTO SCRIPTVER(NUMERO, DATA) VALUES (358, CURRENT_TIMESTAMP);
COMMIT;

