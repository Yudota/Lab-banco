-- ALTER SESSION
alter session set "_ORACLE_SCRIPT" = true;
-- USER SQL
 create user app identified by app123 default tablespace users quota unlimited on users;
 grant connect, resource to app;


--CRIANDO O MODELO DO BANCO
    -- SYSTEM PRIVILEGES
    -- Gerado por Oracle SQL Developer Data Modeler 19.4.0.350.1424
    --   em:        2022-09-16 21:20:05 GMT-03:00
    --   site:      Oracle Database 11g
    --   tipo:      Oracle Database 11g  
    
    CREATE TABLE aeronave (
        aer_id         INTEGER NOT NULL,
        aer_matricula  VARCHAR(200)
    );
    
    COMMENT ON COLUMN aeronave.aer_id IS
        'Identificador unico da aeronave';
    
    COMMENT ON COLUMN aeronave.aer_matricula IS
        'Matricula da Aeronave';
    
    ALTER TABLE aeronave ADD CONSTRAINT pk_aer PRIMARY KEY ( aer_id );
    
    CREATE TABLE fase_operacao (
        ope_id             INTEGER NOT NULL,
        ope_fase_operacao  VARCHAR2(200)
    );
    
    COMMENT ON COLUMN fase_operacao.ope_id IS
        'Identificador unico da fase de operacao da aeronave';
    
    COMMENT ON COLUMN fase_operacao.ope_fase_operacao IS
        'Fase de operacao da aeronave';
    
    ALTER TABLE fase_operacao ADD CONSTRAINT pk_ope PRIMARY KEY ( ope_id );
    
    CREATE TABLE nivel_dano (
        dan_id          INTEGER NOT NULL,
        dan_nivel_dano  VARCHAR2(200)
    );
    
    COMMENT ON COLUMN nivel_dano.dan_id IS
        'Identificador unico do nivel de dano da aeronave	';
    
    COMMENT ON COLUMN nivel_dano.dan_nivel_dano IS
        'Nivel do dano da aeronave';
    
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
        'Identificador unico da ocorrencia';
    
    COMMENT ON COLUMN ocorrencias.oco_codigo_ocorrencia2 IS
        'Codigo da ocorrencia';
    
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
        'Identificador unico do voo de origem da aeronave';
    
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
    
    -- Relatorio do Resumo do Oracle SQL Developer Data Modeler: 
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

-- POPULANDO DADOS NAS TABELAS CRIADAS E NO TABELAO
-- Voo Origem
-- Criando sequence e trigger para mapear os ids
create sequence sq_ori nocache;
create trigger tg_sq_ori before insert on voo_origem for each row
begin
    :new.ori_id := sq_ori.nextval;
end;
/

-- Inserindo no voo origem os campos, ja com a sequence e o trigger funcionando
insert into voo_origem(ori_local_voo_origem)(
    select distinct AERONAVE_VOO_ORIGEM from tabelao
);
/

-- Apenas upando o tabelao com novos valores e testando consultas
update tabelao set 
    AERONAVE_VOO_ORIGEM = (select voo_origem.ori_id from voo_origem where voo_origem.ori_local_voo_origem = tabelao.aeronave_voo_origem);

select * from tabelao;

-- Para verificar se a sequence foi usada
SELECT sq_ori.currval from dual;
select * from voo_origem where ori_id = 730;

--Voo Destino
-- Criando sequence e trigger para mapear os ids
create sequence sq_des nocache;
create trigger tg_sq_des before insert on voo_destino for each row
begin
    :new.des_id := sq_des.nextval;
end;
/

-- Inserindo no voo origem os campos, ja com a sequence e o trigger funcionando
insert into voo_destino(des_local_voo_destino)(
    select distinct AERONAVE_VOO_DESTINO from tabelao
);

-- Apenas upando o tabelao com novos valores e testando consultas
update tabelao set 
    AERONAVE_VOO_DESTINO = (select voo_destino.des_id from voo_destino where voo_destino.des_local_voo_destino = tabelao.aeronave_voo_destino);
    
select * from tabelao;

-- Para verificar se a sequence foi usada

SELECT sq_des.currval from dual;

select * from voo_destino where des_id = 727;

-- Nivel Dano
-- Criando sequence e trigger para mapear os ids
create sequence sq_dan nocache;
create trigger tg_sq_dan before insert on nivel_dano for each row
begin
    :new.dan_id := sq_dan.nextval;
end;
/

-- Inserindo no voo origem os campos, ja com a sequence e o trigger funcionando
insert into nivel_dano(dan_nivel_dano)(
    select distinct AERONAVE_NIVEL_DANO from tabelao
);

-- Apenas upando o tabelao com novos valores e testando consultas
update tabelao set 
    AERONAVE_NIVEL_DANO = (select nivel_dano.dan_id from nivel_dano where nivel_dano.dan_nivel_dano = tabelao.AERONAVE_NIVEL_DANO);
    
select * from tabelao;

-- Para verificar se a sequence foi usada

SELECT sq_dan.currval from dual;

select * from nivel_dano where dan_id = 5;

--Fase Operacao
-- Criando sequence e trigger para mapear os ids
create sequence sq_ope nocache;
create trigger tg_sq_ope before insert on fase_operacao for each row
begin
    :new.ope_id := sq_ope.nextval;
end;
/

-- Inserindo no voo origem os campos, ja com a sequence e o trigger funcionando
insert into fase_operacao(ope_fase_operacao)(
    select distinct AERONAVE_FASE_OPERACAO from tabelao
);

-- Apenas upando o tabelao com novos valores e testando consultas
update tabelao set 
    AERONAVE_FASE_OPERACAO = (select fase_operacao.ope_id from fase_operacao where fase_operacao.ope_fase_operacao = tabelao.aeronave_fase_operacao);
    
select * from tabelao;

-- Para verificar se a sequence foi usada

SELECT sq_ope.currval from dual;

select * from fase_operacao where ope_id = 32;

--Aeronave
-- Criando sequence e trigger para mapear os ids
create sequence sq_aer nocache;
create trigger tg_sq_aer before insert on aeronave for each row
begin
    :new.aer_id := sq_aer.nextval;
end;
/

insert into aeronave(aer_matricula)(
    select distinct MATRICULA from tabelao
);

update tabelao set 
    MATRICULA = (select aeronave.aer_id from aeronave where aeronave.aer_matricula = tabelao.matricula);

--Ocorrencias
-- Criando sequence e trigger para mapear os ids
create sequence sq_oco nocache;
create trigger tg_sq_oco before insert on ocorrencias for each row
begin
    :new.oco_id := sq_oco.nextval;
end;
/

delete
from tabelao
where aeronave_voo_origem is null;

insert into ocorrencias (
    select
        null,
        codigo_ocorrencia2,
        aeronave_fatalidades_total,
        to_number(matricula),
        to_number(aeronave_nivel_dano),
        to_number(aeronave_fase_operacao),
        to_number(aeronave_voo_destino),
        to_number(aeronave_voo_origem)
    from
        tabelao
);

--CRIACAO DAS TABELAS DE HISTORIAMENTO

    CREATE TABLE h_aeronave (
        haer_id         INTEGER NOT NULL,
        haer_matricula  VARCHAR(200),
		haer_datahora 	date
    );
    
    ALTER TABLE h_aeronave ADD CONSTRAINT pk_haer PRIMARY KEY ( haer_id, haer_datahora );

    CREATE TRIGGER tg_haer
    BEFORE UPDATE OR DELETE ON aeronave
    FOR EACH ROW
    BEGIN
	INSERT INTO h_aeronave VALUES (:old.aer_id, :old.aer_matricula, sysdate);
    END;
    /

    
    CREATE TABLE h_fase_operacao (
        hope_id             INTEGER NOT NULL,
        hope_fase_operacao  VARCHAR2(200),
		hope_datahora		date
    );
        
    ALTER TABLE h_fase_operacao ADD CONSTRAINT pk_hope PRIMARY KEY ( hope_id, hope_datahora );
	
	CREATE TRIGGER tg_hope
    BEFORE UPDATE OR DELETE ON fase_operacao
    FOR EACH ROW
    BEGIN
	INSERT INTO h_fase_operacao VALUES (:old.ope_id, :old.ope_fase_operacao, sysdate);
    END;
    /
    
    CREATE TABLE h_nivel_dano (
        hdan_id          INTEGER NOT NULL,
        hdan_nivel_dano  VARCHAR2(200),
		hdan_datahora	date
    );
       
    ALTER TABLE h_nivel_dano ADD CONSTRAINT pk_hdan PRIMARY KEY ( hdan_id,hdan_datahora );
	
	CREATE TRIGGER tg_hdan
    BEFORE UPDATE OR DELETE ON nivel_dano
    FOR EACH ROW
    BEGIN
	INSERT INTO h_nivel_dano VALUES (:old.dan_id, :old.dan_nivel_dano, sysdate);
    END;
    /
    
    CREATE TABLE h_ocorrencias (
        hoco_id                          INTEGER NOT NULL,
        hoco_codigo_ocorrencia2          VARCHAR2(10) NOT NULL,
        hoco_aeronave_fatalidades_total  INTEGER,
        hoco_aer_id                      INTEGER NOT NULL,
        hoco_dan_id                      INTEGER NOT NULL,
        hoco_ope_id                      INTEGER NOT NULL,
        hoco_des_id                      INTEGER NOT NULL,
        hoco_ori_id                      INTEGER NOT NULL,
		hoco_datahora					date
    );
       
    ALTER TABLE h_ocorrencias ADD CONSTRAINT pk_hoco PRIMARY KEY ( hoco_id, hoco_datahora );
	
	CREATE TRIGGER tg_hoco
    BEFORE UPDATE OR DELETE ON ocorrencias
    FOR EACH ROW
    BEGIN
	INSERT INTO h_ocorrencias VALUES (:old.oco_id, :old.oco_codigo_ocorrencia2,:old.oco_aeronave_fatalidades_total,
										:old.oco_aer_id, :old.oco_dan_id, :old.oco_ope_id, :old.oco_des_id, :old.oco_ori_id, sysdate);
    END;
    /
    
    CREATE TABLE h_voo_destino (
        hdes_id                 INTEGER NOT NULL,
        hdes_local_voo_destino  VARCHAR2(200),
		hdes_datahora			date
    );
    
    ALTER TABLE h_voo_destino ADD CONSTRAINT pk_hdes PRIMARY KEY ( hdes_id, hdes_datahora );
	
	CREATE TRIGGER tg_hdes
    BEFORE UPDATE OR DELETE ON voo_destino
    FOR EACH ROW
    BEGIN
	INSERT INTO h_voo_destino VALUES (:old.des_id, :old.des_local_voo_destino, sysdate);
    END;
    /
    
    CREATE TABLE h_voo_origem (
        hori_id                INTEGER NOT NULL,
        hori_local_voo_origem  VARCHAR2(200),
		hori_datahora			date
    );
       
    ALTER TABLE h_voo_origem ADD CONSTRAINT pk_hori PRIMARY KEY ( hori_id, hori_datahora );
	
	CREATE TRIGGER tg_hori
    BEFORE UPDATE OR DELETE ON voo_origem
    FOR EACH ROW
    BEGIN
	INSERT INTO h_voo_origem VALUES (:old.ori_id, :old.ori_local_voo_origem, sysdate);
    END;
    /

--REALIZANDO UPDATE PARA HISTORIAMENTO
update fase_operacao
    set ope_fase_operacao = 'SO BO'
    where ope_fase_operacao = '***';

update nivel_dano
    set dan_nivel_dano = 'De raspao'
    where dan_nivel_dano = '***';
    
update voo_destino
    set des_local_voo_destino = 'Ely Rego'
    where des_local_voo_destino is NULL;

update ocorrencias
    set oco_aeronave_fatalidades_total = '45' 
    where ocorrencias.oco_codigo_ocorrencia2 = '50975';
    
update ocorrencias    
    set oco_aeronave_fatalidades_total = '15' 
    where ocorrencias.oco_codigo_ocorrencia2 = '50994';

update ocorrencias
    set oco_aeronave_fatalidades_total = '99' 
    where ocorrencias.oco_codigo_ocorrencia2 = '47761';

update ocorrencias
    set oco_aeronave_fatalidades_total = '12' 
    where ocorrencias.oco_codigo_ocorrencia2 = '52956';
    
update ocorrencias
    set oco_aeronave_fatalidades_total = '15' 
    where ocorrencias.oco_codigo_ocorrencia2 = '63880';
    
update ocorrencias
    set oco_aeronave_fatalidades_total = '25' 
    where ocorrencias.oco_codigo_ocorrencia2 = '44543';

update ocorrencias
    set oco_aeronave_fatalidades_total = '33' 
    where ocorrencias.oco_codigo_ocorrencia2 = '49516';

update ocorrencias
    set oco_aeronave_fatalidades_total = '22' 
    where ocorrencias.oco_codigo_ocorrencia2 = '78887';

update ocorrencias
    set oco_aeronave_fatalidades_total = '78' 
    where ocorrencias.oco_codigo_ocorrencia2 = '80007';

update ocorrencias
    set oco_aeronave_fatalidades_total = '16' 
    where ocorrencias.oco_codigo_ocorrencia2 = '79307';
    
update ocorrencias 
    set oco_aeronave_fatalidades_total = '45' 
    where ocorrencias.oco_codigo_ocorrencia2 = '50975';

update ocorrencias 
    set oco_aeronave_fatalidades_total = '15' 
    where ocorrencias.oco_codigo_ocorrencia2 = '50994';

update ocorrencias 
    set oco_aeronave_fatalidades_total = '99' 
    where ocorrencias.oco_codigo_ocorrencia2 = '47761';

update ocorrencias 
    set oco_aeronave_fatalidades_total = '10' 
    where ocorrencias.oco_codigo_ocorrencia2 = '45596';

--CONSULTAS SQL COM HISTORIAMENTO
--CONSULTA SQL - ERIKA SILVA
--CONSULTA 01 - ES
-- Quanto subiu numero de fatalidades da ocorrencia 50994 com todas as atualizacoes realizadas?
WITH TB_OCO AS (
    SELECT 
        OCO_AERONAVE_FATALIDADES_TOTAL AS FAT
    FROM 
        APP.OCORRENCIAS 
    WHERE 
        OCO_CODIGO_OCORRENCIA2 = 50994
    UNION
    SELECT 
        HOCO_AERONAVE_FATALIDADES_TOTAL
    FROM 
    APP.H_OCORRENCIAS 
    WHERE HOCO_CODIGO_OCORRENCIA2 = 50994
)
SELECT 
    TRUNC(MAX(FAT)-MIN(FAT)) AS ALTERACOES_FATALIDADES
FROM TB_OCO

--CONSULTA 02 - ES 
-- Quantos danos estavam registrados como '***'?
WITH TB_ND AS (
    SELECT 
        DAN_NIVEL_DANO AS DAN
    FROM 
        APP.NIVEL_DANO 
    WHERE 
        DAN_NIVEL_DANO = '***'
    UNION
    SELECT 
        HDAN_NIVEL_DANO
    FROM
    APP.H_NIVEL_DANO 
    WHERE HDAN_NIVEL_DANO = '***'
)
SELECT 
    COUNT (DAN) AS NIVEL_DANO_ALTERADO
FROM TB_ND;


--CONSULTA SQL - GUARACY GARCIA LOUREIRO JUNIOR
--CONSULTA 01 - GL
-- Quanto subiu em % as fatalidades do ID 33297 com todas as atualizacoes realizadas?
WITH TB_OCO AS (
    SELECT 
        OCO_AERONAVE_FATALIDADES_TOTAL AS FAT
    FROM 
        APP.OCORRENCIAS 
    WHERE 
        OCO_ID = 33297
    UNION
    SELECT 
        HOCO_AERONAVE_FATALIDADES_TOTAL
    FROM 
    APP.H_OCORRENCIAS 
    WHERE HOCO_ID = 33297
)
SELECT 
    TRUNC(((MAX(FAT)-MIN(FAT))/MIN(FAT))*100,2) || '%' AS AUMENTO_VITIMAS
FROM TB_OCO

--CONSULTA 02 - GL
-- Qual a media de fatalidades e o numero que aumentaram apos a ocorrencia
WITH TB_OCO AS (
    SELECT 
        OCO_AERONAVE_FATALIDADES_TOTAL AS OCO
    FROM 
        APP.OCORRENCIAS 
    WHERE 
        OCO_AERONAVE_FATALIDADES_TOTAL <= '100'
    UNION
    SELECT 
        HOCO_AERONAVE_FATALIDADES_TOTAL
    FROM
    APP.H_OCORRENCIAS
    WHERE HOCO_AERONAVE_FATALIDADES_TOTAL <= '100'
)
SELECT 
    TRUNC(AVG (OCO),2) AS MEDIA_FATALIDADES,
    COUNT (OCO) AS QUANTIDADES_FATALIDADES
FROM TB_OCO;

-- criacao do usuario de auditoria (executar no usuario system)
-- ALTER SESSION
alter session set "_ORACLE_SCRIPT" = true;
-- USER SQL
 create user auditor identified by aud123 default tablespace users quota unlimited on users;
 
 --criacao da tabela de auditoria (executar no usuario system)
 create table auditor.auditoria (
    aud_id integer,
    aud_tabela varchar(30),
    aud_linha_hist INTEGER,
    aud_date_hist date,
    aud_coluna varchar(30),
    aud_valor_antigo varchar(2000),
    aud_valor_novo varchar(2000),
    aud_operacao char(1),
    aud_data date,
    aud_usu_bd varchar(30),
    aud_usu_so varchar(200),
    constraint pk_aud primary key (aud_id)
 );
 
 --criacao da sequence de auditoria (executar no usuario system)
 create sequence auditor.sq_aud nocache;
 
 --criacao do trigger de auditoria (executar no usuario system)
 create trigger auditor.tg_sq_aud 
 before insert on auditor.auditoria
 for each row
 begin
    :new.aud_id := auditor.sq_aud.nextval;
 end;
 /
 
 --criacao da procedure de auditoria (executar no usuario system)
 create or replace noneditionable procedure auditor.proc_insere(
    pr_tabela in varchar2,
    pr_linha_hist in number,
    pr_date_hist in date,
    pr_coluna in varchar2,
    pr_valor_antigo in varchar2,
    pr_valor_novo in varchar2,
    pr_operacao in varchar2,
    pr_data in date,
    pr_usu_bd in varchar2,
    pr_usu_so in varchar2
 ) as
 begin
    insert into auditor.auditoria values (null, pr_tabela, pr_linha_hist, pr_date_hist, pr_coluna, pr_valor_antigo, pr_valor_novo, pr_operacao, pr_data, pr_usu_bd, pr_usu_so);
 end proc_insere;

-- dar acesso ao usuario auditor (executar no usuario system)
grant execute on auditor.proc_insere to app;

-- criando os triggers de auditoria para cada tabela
--aeronave

CREATE OR REPLACE TRIGGER tg_in_aer
AFTER DELETE OR UPDATE ON h_aeronave
FOR EACH ROW
DECLARE
	v_usu_bd VARCHAR(30) := sys_context('USERENV','CURRENT_USER');
	v_usu_so VARCHAR(30) := sys_context('USERENV', 'OS_USER');
	v_tabela VARCHAR(30) := 'H_AERONAVE';
	v_evento CHAR(1);
BEGIN
	IF deleting THEN
		v_evento := 'D';
		auditor.proc_insere(
            v_tabela, 
            :OLD.haer_id, 
            :OLD.haer_datahora, 
            NULL, 
            NULL, 
            NULL, 
            v_evento, 
            sysdate, 
            v_usu_bd, 
            v_usu_so
        );
	ELSE
		v_evento := 'U';
		IF (:OLD.haer_id <> :NEW.haer_id) THEN
			auditor.proc_insere(v_tabela, 
                :OLD.haer_id, 
                :OLD.haer_datahora, 
                'HAER_ID', 
                :OLD.haer_id, 
                :NEW.haer_id,
                v_evento, 
                sysdate, 		
                v_usu_bd, 
                v_usu_so
            );
		END IF;
        IF (:OLD.haer_matricula <> :NEW.haer_matricula) THEN
			auditor.proc_insere(v_tabela, 
                :OLD.haer_id, 
                :OLD.haer_datahora, 
                'HAER_MATRICULA', 
                :OLD.haer_matricula, 
                :NEW.haer_matricula,
                v_evento, 
                sysdate, 		
                v_usu_bd, 
                v_usu_so
            );
		END IF;
        IF (:OLD.haer_datahora <> :NEW.haer_datahora) THEN
			auditor.proc_insere(v_tabela, 
                :OLD.haer_id, 
                :OLD.haer_datahora, 
                'HAER_DATAHORA', 
                :OLD.haer_datahora, 
                :NEW.haer_datahora,
                v_evento, 
                sysdate, 		
                v_usu_bd, 
                v_usu_so
            );
		END IF;
    END IF;
END;
/

--trigger fase operacao
CREATE OR REPLACE TRIGGER tg_in_ope
AFTER DELETE OR UPDATE ON h_fase_operacao
FOR EACH ROW
DECLARE
	v_usu_bd VARCHAR(30) := sys_context('USERENV','CURRENT_USER');
	v_usu_so VARCHAR(30) := sys_context('USERENV', 'OS_USER');
	v_tabela VARCHAR(30) := 'H_FASE_OPERACAO';
	v_evento CHAR(1);
BEGIN
	IF deleting THEN
		v_evento := 'D';
		auditor.proc_insere(
            v_tabela, 
            :OLD.hope_id, 
            :OLD.hope_datahora, 
            NULL, 
            NULL, 
            NULL, 
            v_evento, 
            sysdate, 
            v_usu_bd, 
            v_usu_so
        );
	ELSE
		v_evento := 'U';
		IF (:OLD.hope_id <> :NEW.hope_id) THEN
			auditor.proc_insere(v_tabela, 
                :OLD.hope_id, 
                :OLD.hope_datahora, 
                'HOPE_ID', 
                :OLD.hope_id, 
                :NEW.hope_id,
                v_evento, 
                sysdate, 		
                v_usu_bd, 
                v_usu_so
            );
		END IF;
        IF (:OLD.hope_fase_operacao <> :NEW.hope_fase_operacao) THEN
			auditor.proc_insere(v_tabela, 
                :OLD.hope_id, 
                :OLD.hope_datahora, 
                'HOPE_FASE_OPERACAO', 
                :OLD.hope_fase_operacao, 
                :NEW.hope_fase_operacao,
                v_evento, 
                sysdate, 		
                v_usu_bd, 
                v_usu_so
            );
		END IF;
        IF (:OLD.hope_datahora <> :NEW.hope_datahora) THEN
			auditor.proc_insere(v_tabela, 
                :OLD.hope_id, 
                :OLD.hope_datahora, 
                'HOPE_DATAHORA', 
                :OLD.hope_datahora, 
                :NEW.hope_datahora,
                v_evento, 
                sysdate, 		
                v_usu_bd, 
                v_usu_so
            );
		END IF;
    END IF;
END;
/

--trigger nivel dano
CREATE OR REPLACE TRIGGER tg_in_dan
AFTER DELETE OR UPDATE ON h_nivel_dano
FOR EACH ROW
DECLARE
	v_usu_bd VARCHAR(30) := sys_context('USERENV','CURRENT_USER');
	v_usu_so VARCHAR(30) := sys_context('USERENV', 'OS_USER');
	v_tabela VARCHAR(30) := 'H_NIVEL_DANO';
	v_evento CHAR(1);
BEGIN
	IF deleting THEN
		v_evento := 'D';
		auditor.proc_insere(
            v_tabela, 
            :OLD.hdan_id, 
            :OLD.hdan_datahora, 
            NULL, 
            NULL, 
            NULL, 
            v_evento, 
            sysdate, 
            v_usu_bd, 
            v_usu_so
        );
	ELSE
		v_evento := 'U';
		IF (:OLD.hdan_id <> :NEW.hdan_id) THEN
			auditor.proc_insere(v_tabela, 
                :OLD.hdan_id, 
                :OLD.hdan_datahora, 
                'HDAN_ID', 
                :OLD.hdan_id, 
                :NEW.hdan_id,
                v_evento, 
                sysdate, 		
                v_usu_bd, 
                v_usu_so
            );
		END IF;
        IF (:OLD.hdan_nivel_dano <> :NEW.hdan_nivel_dano) THEN
			auditor.proc_insere(v_tabela, 
                :OLD.hdan_id, 
                :OLD.hdan_datahora, 
                'HDAN_NIVEL_DANO', 
                :OLD.hdan_nivel_dano, 
                :NEW.hdan_nivel_dano,
                v_evento, 
                sysdate, 		
                v_usu_bd, 
                v_usu_so
            );
		END IF;
        IF (:OLD.hdan_datahora <> :NEW.hdan_datahora) THEN
			auditor.proc_insere(v_tabela, 
                :OLD.hdan_id, 
                :OLD.hdan_datahora, 
                'HDAN_DATAHORA', 
                :OLD.hdan_datahora, 
                :NEW.hdan_datahora,
                v_evento, 
                sysdate, 		
                v_usu_bd, 
                v_usu_so
            );
		END IF;
    END IF;
END;
/

--trigger ocorrencias
CREATE OR REPLACE TRIGGER tg_in_oco
AFTER DELETE OR UPDATE ON h_ocorrencias
FOR EACH ROW
DECLARE
	v_usu_bd VARCHAR(30) := sys_context('USERENV','CURRENT_USER');
	v_usu_so VARCHAR(30) := sys_context('USERENV', 'OS_USER');
	v_tabela VARCHAR(30) := 'H_OCORRENCIAS';
	v_evento CHAR(1);
BEGIN
	IF deleting THEN
		v_evento := 'D';
		auditor.proc_insere(
            v_tabela, 
            :OLD.hoco_id, 
            :OLD.hoco_datahora, 
            NULL, 
            NULL, 
            NULL, 
            v_evento, 
            sysdate, 
            v_usu_bd, 
            v_usu_so
        );
	ELSE
		v_evento := 'U';
		IF (:OLD.hoco_id <> :NEW.hoco_id) THEN
			auditor.proc_insere(v_tabela, 
                :OLD.hoco_id, 
                :OLD.hoco_datahora, 
                'HOCO_ID', 
                :OLD.hoco_id, 
                :NEW.hoco_id,
                v_evento, 
                sysdate, 		
                v_usu_bd, 
                v_usu_so
            );
		END IF;
		IF (:OLD.hoco_codigo_ocorrencia2 <> :NEW.hoco_codigo_ocorrencia2) THEN
			auditor.proc_insere(v_tabela, 
                :OLD.hoco_id, 
                :OLD.hoco_datahora, 
                'HOCO_CODIGO_OCORRENCIA2', 
                :OLD.hoco_codigo_ocorrencia2, 
                :NEW.hoco_codigo_ocorrencia2,
                v_evento, 
                sysdate, 		
                v_usu_bd, 
                v_usu_so
            );
		END IF;
        IF (:OLD.hoco_aeronave_fatalidades_total <> :NEW.hoco_aeronave_fatalidades_total) THEN
			auditor.proc_insere(v_tabela, 
                :OLD.hoco_id, 
                :OLD.hoco_datahora, 
                'HOCO_AERONAVE_FATALIDADES_TOTAL', 
                :OLD.hoco_aeronave_fatalidades_total, 
                :NEW.hoco_aeronave_fatalidades_total,
                v_evento, 
                sysdate, 		
                v_usu_bd, 
                v_usu_so
            );
		END IF;
        IF (:OLD.hoco_aer_id <> :NEW.hoco_aer_id) THEN
			auditor.proc_insere(v_tabela, 
                :OLD.hoco_id, 
                :OLD.hoco_datahora, 
                'HOCO_AER_ID', 
                :OLD.hoco_aer_id, 
                :NEW.hoco_aer_id,
                v_evento, 
                sysdate, 		
                v_usu_bd, 
                v_usu_so
            );
		END IF;
        IF (:OLD.hoco_dan_id <> :NEW.hoco_dan_id) THEN
			auditor.proc_insere(v_tabela, 
                :OLD.hoco_id, 
                :OLD.hoco_datahora, 
                'HOCO_DAN_ID', 
                :OLD.hoco_dan_id, 
                :NEW.hoco_dan_id,
                v_evento, 
                sysdate, 		
                v_usu_bd, 
                v_usu_so
            );
		END IF;
        IF (:OLD.hoco_ope_id <> :NEW.hoco_ope_id) THEN
			auditor.proc_insere(v_tabela, 
                :OLD.hoco_id, 
                :OLD.hoco_datahora, 
                'HOCO_OPE_ID', 
                :OLD.hoco_ope_id, 
                :NEW.hoco_ope_id,
                v_evento, 
                sysdate, 		
                v_usu_bd, 
                v_usu_so
            );
		END IF;
        IF (:OLD.hoco_des_id <> :NEW.hoco_des_id) THEN
			auditor.proc_insere(v_tabela, 
                :OLD.hoco_id, 
                :OLD.hoco_datahora, 
                'HOCO_DES_ID', 
                :OLD.hoco_des_id, 
                :NEW.hoco_des_id,
                v_evento, 
                sysdate, 		
                v_usu_bd, 
                v_usu_so
            );
		END IF;
        IF (:OLD.hoco_ori_id <> :NEW.hoco_ori_id) THEN
			auditor.proc_insere(v_tabela, 
                :OLD.hoco_id, 
                :OLD.hoco_datahora, 
                'HOCO_ORI_ID', 
                :OLD.hoco_ori_id, 
                :NEW.hoco_ori_id,
                v_evento, 
                sysdate, 		
                v_usu_bd, 
                v_usu_so
            );
		END IF;
        IF (:OLD.hoco_datahora <> :NEW.hoco_datahora) THEN
			auditor.proc_insere(v_tabela, 
                :OLD.hoco_id, 
                :OLD.hoco_datahora, 
                'HOCO_DATAHORA', 
                :OLD.hoco_datahora, 
                :NEW.hoco_datahora,
                v_evento, 
                sysdate, 		
                v_usu_bd, 
                v_usu_so
            );
		END IF;
	END IF;

END;
/

--trigger voo destino
CREATE OR REPLACE TRIGGER tg_in_des
AFTER DELETE OR UPDATE ON h_voo_destino
FOR EACH ROW
DECLARE
	v_usu_bd VARCHAR(30) := sys_context('USERENV','CURRENT_USER');
	v_usu_so VARCHAR(30) := sys_context('USERENV', 'OS_USER');
	v_tabela VARCHAR(30) := 'H_VOO_DESTINO';
	v_evento CHAR(1);
BEGIN
	IF deleting THEN
		v_evento := 'D';
		auditor.proc_insere(
            v_tabela, 
            :OLD.hdes_id, 
            :OLD.hdes_datahora, 
            NULL, 
            NULL, 
            NULL, 
            v_evento, 
            sysdate, 
            v_usu_bd, 
            v_usu_so
        );
	ELSE
		v_evento := 'U';
		IF (:OLD.hdes_id <> :NEW.hdes_id) THEN
			auditor.proc_insere(v_tabela, 
                :OLD.hdes_id, 
                :OLD.hdes_datahora, 
                'HDES_ID', 
                :OLD.hdes_id, 
                :NEW.hdes_id,
                v_evento, 
                sysdate, 		
                v_usu_bd, 
                v_usu_so
            );
		END IF;
        IF (:OLD.hdes_local_voo_destino <> :NEW.hdes_local_voo_destino) THEN
			auditor.proc_insere(v_tabela, 
                :OLD.hdes_id, 
                :OLD.hdes_datahora, 
                'HDES_LOCAL_VOO_DESTINO', 
                :OLD.hdes_local_voo_destino, 
                :NEW.hdes_local_voo_destino,
                v_evento, 
                sysdate, 		
                v_usu_bd, 
                v_usu_so
            );
		END IF;
        IF (:OLD.hdes_datahora <> :NEW.hdes_datahora) THEN
			auditor.proc_insere(v_tabela, 
                :OLD.hdes_id, 
                :OLD.hdes_datahora, 
                'HDES_DATAHORA', 
                :OLD.hdes_datahora, 
                :NEW.hdes_datahora,
                v_evento, 
                sysdate, 		
                v_usu_bd, 
                v_usu_so
            );
		END IF;
    END IF;
END;
/

--trigger voo origem
CREATE OR REPLACE TRIGGER tg_in_ori
AFTER DELETE OR UPDATE ON h_voo_origem
FOR EACH ROW
DECLARE
	v_usu_bd VARCHAR(30) := sys_context('USERENV','CURRENT_USER');
	v_usu_so VARCHAR(30) := sys_context('USERENV', 'OS_USER');
	v_tabela VARCHAR(30) := 'H_VOO_ORIGEM';
	v_evento CHAR(1);
BEGIN
	IF deleting THEN
		v_evento := 'D';
		auditor.proc_insere(
            v_tabela, 
            :OLD.hori_id, 
            :OLD.hori_datahora, 
            NULL, 
            NULL, 
            NULL, 
            v_evento, 
            sysdate, 
            v_usu_bd, 
            v_usu_so
        );
	ELSE
		v_evento := 'U';
		IF (:OLD.hori_id <> :NEW.hori_id) THEN
			auditor.proc_insere(v_tabela, 
                :OLD.hori_id, 
                :OLD.hori_datahora, 
                'HORI_ID', 
                :OLD.hori_id, 
                :NEW.hori_id,
                v_evento, 
                sysdate, 		
                v_usu_bd, 
                v_usu_so
            );
		END IF;
        IF (:OLD.hori_local_voo_origem <> :NEW.hori_local_voo_origem) THEN
			auditor.proc_insere(v_tabela, 
                :OLD.hori_id, 
                :OLD.hori_datahora, 
                'HORI_LOCAL_VOO_ORIGEM', 
                :OLD.hori_local_voo_origem, 
                :NEW.hori_local_voo_origem,
                v_evento, 
                sysdate, 		
                v_usu_bd, 
                v_usu_so
            );
		END IF;
        IF (:OLD.hori_datahora <> :NEW.hori_datahora) THEN
			auditor.proc_insere(v_tabela, 
                :OLD.hori_id, 
                :OLD.hori_datahora, 
                'HORI_DATAHORA', 
                :OLD.hori_datahora, 
                :NEW.hori_datahora,
                v_evento, 
                sysdate, 		
                v_usu_bd, 
                v_usu_so
            );
		END IF;
    END IF;
END;
/

--grant acesso a tabelas do APP a novo usuario
ALTER SESSION SET "_ORACLE_SCRIPT" = true;

SELECT
    'grant select, update, delete on '
    || 'app.'
    || table_name
    || ' to "GRACE";'
FROM
    all_tables
WHERE
        owner = 'APP'
    AND table_name LIKE 'H_%';

GRANT SELECT, UPDATE, DELETE ON app.h_aeronave TO "GRACE";

GRANT SELECT, UPDATE, DELETE ON app.h_fase_operacao TO "GRACE";

GRANT SELECT, UPDATE, DELETE ON app.h_nivel_dano TO "GRACE";

GRANT SELECT, UPDATE, DELETE ON app.h_ocorrencias TO "GRACE";

GRANT SELECT, UPDATE, DELETE ON app.h_voo_destino TO "GRACE";

GRANT SELECT, UPDATE, DELETE ON app.h_voo_origem TO "GRACE";

--Alteracoes na base de dados para gerar conteudo para analises de auditoria
update aeronave
Set aer_matricula = 'ATLHOJE'
WHERE aer_id = 241 OR aer_id = 300;

UPDATE fase_operacao
SET ope_fase_operacao = 'NAO E PAIRADO E PARADO'
WHERE ope_fase_operacao = 'PAIRADO';

UPDATE nivel_dano
SET nivel_dano.dan_nivel_dano = 'IMPOSSIVEL'
WHERE nivel_dano.dan_nivel_dano = 'NENHUM';

INSERT INTO VOO_ORIGEM (voo_origem.ori_local_voo_origem)
VALUES ('FATEC MOGI DAS CRUIZ - HELIPONTO');

INSERT INTO VOO_DESTINO (voo_destino.des_local_voo_destino)
VALUES ('FATEC MOGI DAS CRUIZ - HELIPONTO');

UPDATE voo_destino
SET voo_destino.des_local_voo_destino = 'NEM GPS LOCALIZA'
WHERE voo_destino.des_local_voo_destino = 'ABA';

UPDATE voo_ORIGEM
SET voo_origem.ori_local_voo_origem = 'A VOLTA DOS QUE NAO FORAM'
WHERE voo_origem.ori_local_voo_origem = 'LÁBREA';

