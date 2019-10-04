-- Gerado por Oracle SQL Developer Data Modeler 19.2.0.182.1216
--   em:        2019-10-02 21:38:23 BRT
--   site:      Oracle Database 11g
--   tipo:      Oracle Database 11g



CREATE TABLE dm_curso (
    id_curso   NUMBER(4) NOT NULL,
    nome       VARCHAR2(40)
);

ALTER TABLE dm_curso ADD CONSTRAINT dm_curso_pk PRIMARY KEY ( id_curso );

CREATE TABLE dm_departamento (
    id_departamento   NUMBER(4) NOT NULL,
    nome              VARCHAR2(30)
);

ALTER TABLE dm_departamento ADD CONSTRAINT dm_departamento_pk PRIMARY KEY ( id_departamento );

CREATE TABLE dm_disciplina (
    id_disciplina   NUMBER(4) NOT NULL,
    nome            VARCHAR2(40),
    natureza        VARCHAR2(40)
);
ALTER TABLE dm_disciplina
    ADD CONSTRAINT natureza_check CHECK ( natureza IN (
        'TEORICA',
        'PRATICA'
    ) );

ALTER TABLE dm_disciplina ADD CONSTRAINT dm_disciplina_pk PRIMARY KEY ( id_disciplina );

CREATE TABLE dm_professor (
    id_professor   NUMBER(8) NOT NULL,
    nome           VARCHAR2(50),
    titulacao      VARCHAR2(20)
);

ALTER TABLE dm_professor ADD CONSTRAINT dm_professor_pk PRIMARY KEY ( id_professor );

CREATE TABLE dm_tempo (
    id_tempo   NUMBER(4) NOT NULL,
    ano        NUMBER(4),
    periodo    NUMBER(2)
);

ALTER TABLE dm_tempo ADD CONSTRAINT dm_tempo_pk PRIMARY KEY ( id_tempo );

CREATE TABLE ft_datamart (
    id_professor       NUMBER(8) NOT NULL,
    id_tempo           NUMBER(4) NOT NULL,
    id_departamento    NUMBER(4) NOT NULL,
    id_disciplina      NUMBER(4) NOT NULL,
    id_curso           NUMBER(4) NOT NULL,
    total_alunos       NUMBER(4),
    alunos_aprovados   NUMBER(4)
);

ALTER TABLE ft_datamart
    ADD CONSTRAINT ft_datamart_pk PRIMARY KEY ( id_professor,
                                                id_tempo,
                                                id_departamento,
                                                id_disciplina,
                                                id_curso );

ALTER TABLE ft_datamart
    ADD CONSTRAINT ft_datamart_dm_curso_fk FOREIGN KEY ( id_curso )
        REFERENCES dm_curso ( id_curso );

ALTER TABLE ft_datamart
    ADD CONSTRAINT ft_datamart_dm_departamento_fk FOREIGN KEY ( id_departamento )
        REFERENCES dm_departamento ( id_departamento );

ALTER TABLE ft_datamart
    ADD CONSTRAINT ft_datamart_dm_disciplina_fk FOREIGN KEY ( id_disciplina )
        REFERENCES dm_disciplina ( id_disciplina );

ALTER TABLE ft_datamart
    ADD CONSTRAINT ft_datamart_dm_professor_fk FOREIGN KEY ( id_professor )
        REFERENCES dm_professor ( id_professor );

ALTER TABLE ft_datamart
    ADD CONSTRAINT ft_datamart_dm_tempo_fk FOREIGN KEY ( id_tempo )
        REFERENCES dm_tempo ( id_tempo );



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
