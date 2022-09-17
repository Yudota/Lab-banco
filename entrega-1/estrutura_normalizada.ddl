-- Gerado por Oracle SQL Developer Data Modeler 19.4.0.350.1424
--   em:        2022-09-16 21:20:05 GMT-03:00
--   site:      Oracle Database 11g
--   tipo:      Oracle Database 11g



CREATE TABLE aeronave (
    aer_id         INTEGER NOT NULL,
    aer_matricula  CHAR(10) NOT NULL,
    aer_assento    INTEGER
);

COMMENT ON COLUMN aeronave.aer_id IS
    'Identificador único da aeronave';

COMMENT ON COLUMN aeronave.aer_matricula IS
    'Matricula da Aeronave';

COMMENT ON COLUMN aeronave.aer_assento IS
    'Quantidade de Assentos';

ALTER TABLE aeronave ADD CONSTRAINT pk_aer PRIMARY KEY ( aer_id );

CREATE TABLE fase_operacao (
    ope_id             INTEGER NOT NULL,
    ope_fase_operacao  VARCHAR2(200)
);

COMMENT ON COLUMN fase_operacao.ope_id IS
    'Identificador único da fase de operação da aeronave';

COMMENT ON COLUMN fase_operacao.ope_fase_operacao IS
    'Fase de operação da aeronave';

ALTER TABLE fase_operacao ADD CONSTRAINT pk_ope PRIMARY KEY ( ope_id );

CREATE TABLE nivel_dano (
    dan_id          INTEGER NOT NULL,
    dan_nivel_dano  VARCHAR2(200)
);

COMMENT ON COLUMN nivel_dano.dan_id IS
    'Identificador unico do nivel de dano da aeronave	';

COMMENT ON COLUMN nivel_dano.dan_nivel_dano IS
    'Nível do dano da aeronave';

ALTER TABLE nivel_dano ADD CONSTRAINT pk_dan PRIMARY KEY ( dan_id );

CREATE TABLE ocorrencias (
    oco_id                          INTEGER NOT NULL,
    oco_codigo_ocorrencia2          VARCHAR2(10) NOT NULL,
    oco_aeronave_fatalidades_total  INTEGER,
    oco_aer_id                      INTEGER NOT NULL,
    oco_dan_id                      INTEGER NOT NULL,
    oco_ope_id                      INTEGER NOT NULL,
    oco_des_id                      INTEGER NOT NULL,
    oco_ori_id                      INTEGER NOT NULL
);

COMMENT ON COLUMN ocorrencias.oco_id IS
    'Identificador único da ocorrência';

COMMENT ON COLUMN ocorrencias.oco_codigo_ocorrencia2 IS
    'Código da ocorrência';

COMMENT ON COLUMN ocorrencias.oco_aeronave_fatalidades_total IS
    'Total de Fatalidades';

ALTER TABLE ocorrencias ADD CONSTRAINT pk_oco PRIMARY KEY ( oco_id );

CREATE TABLE voo_destino (
    des_id                 INTEGER NOT NULL,
    des_local_voo_destino  VARCHAR2(200)
);

COMMENT ON COLUMN voo_destino.des_id IS
    'Identificador unico do local de destino da aeronave';

COMMENT ON COLUMN voo_destino.des_local_voo_destino IS
    'Local de destino da aeronave';

ALTER TABLE voo_destino ADD CONSTRAINT pk_des PRIMARY KEY ( des_id );

CREATE TABLE voo_origem (
    ori_id                INTEGER NOT NULL,
    ori_local_voo_origem  VARCHAR2(200)
);

COMMENT ON COLUMN voo_origem.ori_id IS
    'Identificador único do voo de origem da aeronave';

COMMENT ON COLUMN voo_origem.ori_local_voo_origem IS
    'Local do  voo de origem da aeronave';

ALTER TABLE voo_origem ADD CONSTRAINT pk_ori PRIMARY KEY ( ori_id );

ALTER TABLE ocorrencias
    ADD CONSTRAINT fk_oco_aer FOREIGN KEY ( oco_aer_id )
        REFERENCES aeronave ( aer_id );

ALTER TABLE ocorrencias
    ADD CONSTRAINT fk_oco_dan FOREIGN KEY ( oco_dan_id )
        REFERENCES nivel_dano ( dan_id );

ALTER TABLE ocorrencias
    ADD CONSTRAINT fk_oco_des FOREIGN KEY ( oco_des_id )
        REFERENCES voo_destino ( des_id );

ALTER TABLE ocorrencias
    ADD CONSTRAINT fk_oco_ope FOREIGN KEY ( oco_ope_id )
        REFERENCES fase_operacao ( ope_id );

ALTER TABLE ocorrencias
    ADD CONSTRAINT fk_oco_ori FOREIGN KEY ( oco_ori_id )
        REFERENCES voo_origem ( ori_id );



-- Relatório do Resumo do Oracle SQL Developer Data Modeler: 
-- 
-- CREATE TABLE                             6
-- CREATE INDEX                             0
-- ALTER TABLE                             11
-- CREATE VIEW                              0
-- ALTER VIEW                               0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          0
-- CREATE MATERIALIZED VIEW                 0
-- CREATE MATERIALIZED VIEW LOG             0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- REDACTION POLICY                         0
-- 
-- ORDS DROP SCHEMA                         0
-- ORDS ENABLE SCHEMA                       0
-- ORDS ENABLE OBJECT                       0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0
