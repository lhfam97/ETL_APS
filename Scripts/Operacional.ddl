-- Gerado por Oracle SQL Developer Data Modeler 19.2.0.182.1216
--   em:        2019-10-02 19:48:02 BRT
--   site:      Oracle Database 11g
--   tipo:      Oracle Database 11g



CREATE TABLE aluno_turma (
    matricula_alu    NUMBER(8) NOT NULL,
    matricula_prof   NUMBER(8) NOT NULL,
    cod_disciplina   NUMBER(4) NOT NULL,
    nota             NUMBER(2, 2)
);

ALTER TABLE aluno_turma
    ADD CONSTRAINT aluno_turma_pk PRIMARY KEY ( matricula_alu,
                                                matricula_prof,
                                                cod_disciplina );

CREATE TABLE alunos (
    matricula_alu   NUMBER(8) NOT NULL,
    cod_curso       NUMBER(4) NOT NULL,
    nome            VARCHAR2(40),
    estado_civil    VARCHAR2(10),
    sexo            VARCHAR2(15),
    ano_ingresso    NUMBER(4)
);

ALTER TABLE alunos ADD CONSTRAINT alunos_pk PRIMARY KEY ( matricula_alu );

CREATE TABLE cursos (
    cod_curso            NUMBER(4) NOT NULL,
    descricao            VARCHAR2(30),
    numero_de_creditos   NUMBER(3),
    duracao_normal       NUMBER(4),
    cod_dep              NUMBER(4) NOT NULL
);

ALTER TABLE cursos ADD CONSTRAINT cursos_pk PRIMARY KEY ( cod_curso );

CREATE TABLE departamentos (
    cod_dep   NUMBER(4) NOT NULL,
    nome      VARCHAR2(50)
);

ALTER TABLE departamentos ADD CONSTRAINT departamentos_pk PRIMARY KEY ( cod_dep );

CREATE TABLE disciplinas (
    cod_disciplina       NUMBER(4) NOT NULL,
    cod_curso            NUMBER(4) NOT NULL,
    numero_de_creditos   NUMBER(4),
    natureza             VARCHAR2(10),
    nome                 VARCHAR2(40)
);

ALTER TABLE disciplinas
    ADD CONSTRAINT disciplina_ck_1 CHECK ( natureza IN (
        'TEORICA',
        'PRATICA'
    ) );


ALTER TABLE disciplinas ADD CONSTRAINT disciplinas_pk PRIMARY KEY ( cod_disciplina );

CREATE TABLE professores (
    matricula_prof   NUMBER(8) NOT NULL,
    cod_dep          NUMBER(4) NOT NULL,
    nome             VARCHAR2(40),
    titulacao        VARCHAR2(20),
    endereco         VARCHAR2(100)
);


ALTER TABLE professores ADD CONSTRAINT professores_pk PRIMARY KEY ( matricula_prof );

CREATE TABLE turmas (
    matricula_prof   NUMBER(8) NOT NULL,
    cod_disciplina   NUMBER(8) NOT NULL,
    ano              NUMBER(4),
    periodo          NUMBER(2),
    sala             VARCHAR2(10)
);

ALTER TABLE turmas ADD CONSTRAINT turmas_pk PRIMARY KEY ( matricula_prof,
                                                          cod_disciplina );

ALTER TABLE aluno_turma
    ADD CONSTRAINT aluno_turma_alunos_fk FOREIGN KEY ( matricula_alu )
        REFERENCES alunos ( matricula_alu );

ALTER TABLE aluno_turma
    ADD CONSTRAINT aluno_turma_turmas_fk FOREIGN KEY ( matricula_prof,
                                                       cod_disciplina )
        REFERENCES turmas ( matricula_prof,
                            cod_disciplina );

ALTER TABLE alunos
    ADD CONSTRAINT alunos_cursos_fk FOREIGN KEY ( cod_curso )
        REFERENCES cursos ( cod_curso );

ALTER TABLE cursos
    ADD CONSTRAINT cursos_departamentos_fk FOREIGN KEY ( cod_dep )
        REFERENCES departamentos ( cod_dep );

ALTER TABLE disciplinas
    ADD CONSTRAINT disciplinas_cursos_fk FOREIGN KEY ( cod_curso )
        REFERENCES cursos ( cod_curso );

ALTER TABLE professores
    ADD CONSTRAINT professores_departamentos_fk FOREIGN KEY ( cod_dep )
        REFERENCES departamentos ( cod_dep );

ALTER TABLE turmas
    ADD CONSTRAINT turmas_disciplinas_fk FOREIGN KEY ( cod_disciplina )
        REFERENCES disciplinas ( cod_disciplina );

ALTER TABLE turmas
    ADD CONSTRAINT turmas_professores_fk FOREIGN KEY ( matricula_prof )
        REFERENCES professores ( matricula_prof );



-- Relatório do Resumo do Oracle SQL Developer Data Modeler: 
-- 
-- CREATE TABLE                             7
-- CREATE INDEX                             0
-- ALTER TABLE                             15
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
