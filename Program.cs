using System;
using System.Collections.Generic;
using System.Diagnostics;
using Oracle.ManagedDataAccess.Client;
namespace ETL_APS
{
    class Program
    {
        static void Main(string[] args)
        {
            List<string> sqlInsert = new List<string>();
            //OracleConnection conn = new OracleConnection();

            using (OracleConnection conn = new OracleConnection("DATA SOURCE=localhost:1521;" + "PERSIST SECURITY INFO=True;USER ID=APS; password=luique; Pooling = False; ")) // connect to oracle
            {
                conn.Open(); // open the oracle connection
                //QUERY DM_DEPARTAMENTO
                string sql = "select * from DEPARTAMENTOS";
                using (OracleCommand comm = new OracleCommand(sql, conn)) // create the oracle sql command
                {
                    using (OracleDataReader rdr = comm.ExecuteReader()) // execute the oracle sql and start reading it
                    {

                        while (rdr.Read()) // loop through each row from oracle
                        {
                            sqlInsert.Add("INSERT INTO DM_DEPARTAMENTO(ID_DEPARTAMENTO, NOME) values (" + rdr[0] + ",'" + rdr[1].ToString().Replace("'", "") + "')");

                        }
                        rdr.Close(); // close the oracle reader
                    }
                }
                ////QUERY DM_DISCIPLINA
                sql = "SELECT COD_DISCIPLINA, NOME, NATUREZA FROM DISCIPLINAS";
                using (OracleCommand comm = new OracleCommand(sql, conn)) // create the oracle sql command
                {
                    using (OracleDataReader rdr = comm.ExecuteReader()) // execute the oracle sql and start reading it
                    {

                        while (rdr.Read()) // loop through each row from oracle
                        {
                            sqlInsert.Add("INSERT INTO DM_DISCIPLINA (ID_DISCIPLINA, NOME, NATUREZA) values (" + rdr[0] + ",'" + rdr[1].ToString().Replace("'", "") + "','" + rdr[2].ToString().Replace("'", "") + "')");

                        }
                        rdr.Close(); // close the oracle reader
                    }
                }
                //QUERY DM_CURSO
                sql = "select COD_CURSO, DESCRICAO from CURSOS";
                using (OracleCommand comm = new OracleCommand(sql, conn)) // create the oracle sql command
                {
                    using (OracleDataReader rdr = comm.ExecuteReader()) // execute the oracle sql and start reading it
                    {

                        while (rdr.Read()) // loop through each row from oracle
                        {
                            sqlInsert.Add("INSERT INTO DM_CURSO(ID_CURSO, NOME) values (" + rdr[0] + ",'" + rdr[1].ToString().Replace("'", "") + "')");

                        }
                        rdr.Close(); // close the oracle reader
                    }
                }
                ////QUERY DM_PROFESSOR
                sql = "SELECT MATRICULA_PROF, NOME, TITULACAO FROM PROFESSORES";
                using (OracleCommand comm = new OracleCommand(sql, conn)) // create the oracle sql command
                {
                    using (OracleDataReader rdr = comm.ExecuteReader()) // execute the oracle sql and start reading it
                    {

                        while (rdr.Read()) // loop through each row from oracle
                        {
                            sqlInsert.Add("INSERT INTO DM_PROFESSOR (ID_PROFESSOR, NOME, TITULACAO) values (" + rdr[0] + ",'" + rdr[1].ToString().Replace("'", "") + "','" + rdr[2].ToString().Replace("'", "") + "')");

                        }
                        rdr.Close(); // close the oracle reader
                    }
                }
                //QUERY DM_TEMPO
                sql = "SELECT ANO, PERIODO FROM TURMAS GROUP BY ANO, PERIODO";
                using (OracleCommand comm = new OracleCommand(sql, conn)) // create the oracle sql command
                {
                    using (OracleDataReader rdr = comm.ExecuteReader()) // execute the oracle sql and start reading it
                    {

                        while (rdr.Read()) // loop through each row from oracle
                        {
                            sqlInsert.Add("DECLARE SELEC NUMERIC(1); \n" + "BEGIN SELECT COUNT(*) INTO SELEC FROM DM_TEMPO WHERE ANO = " + rdr[0] + " AND PERIODO = " + rdr[1] + "; " + "IF (SELEC = 0) THEN "+"INSERT INTO DM_TEMPO (ID_TEMPO, ANO, PERIODO) values (tempo_seq.nextval," + rdr[0] + "," +rdr[1] + ");");

                        }
                        rdr.Close(); // close the oracle reader
                    }
                }

                // QUERY OPERACIONAL INCREMENTAL COM TOTAL DE ALUNOS -> TABELA FATOS
                sql = "SELECT PROFESSORES.MATRICULA_PROF, DEPARTAMENTOS.COD_DEP, CURSOS.COD_CURSO, DISCIPLINAS.COD_DISCIPLINA, TURMAS.ANO, TURMAS.PERIODO, COUNT(ALUNO_TURMA.MATRICULA_ALU)"
                    + " FROM PROFESSORES INNER JOIN TURMAS ON PROFESSORES.MATRICULA_PROF = TURMAS.MATRICULA_PROF"
                    + " INNER JOIN DISCIPLINAS ON TURMAS.COD_DISCIPLINA = DISCIPLINAS.COD_DISCIPLINA"
                    + " INNER JOIN CURSOS ON CURSOS.COD_CURSO = DISCIPLINAS.COD_CURSO"
                    + " INNER JOIN DEPARTAMENTOS ON DEPARTAMENTOS.COD_DEP = CURSOS.COD_DEP"
                    + " INNER JOIN ALUNO_TURMA ON(ALUNO_TURMA.COD_DISCIPLINA = DISCIPLINAS.COD_DISCIPLINA AND ALUNO_TURMA.MATRICULA_PROF = PROFESSORES.MATRICULA_PROF)"
                    + " GROUP BY PROFESSORES.MATRICULA_PROF, DEPARTAMENTOS.COD_DEP, CURSOS.COD_CURSO, DISCIPLINAS.COD_DISCIPLINA, TURMAS.ANO, TURMAS.PERIODO"
                    ;
                using (OracleCommand comm = new OracleCommand(sql, conn)) // create the oracle sql command
                {
                    using (OracleDataReader rdr = comm.ExecuteReader()) // execute the oracle sql and start reading it
                    {

                        while (rdr.Read()) // loop through each row from oracle
                        {
                            sqlInsert.Add("INSERT INTO FT_DATAMART (ID_PROFESSOR, ID_TEMPO, ID_DEPARTAMENTO, ID_DISCIPLINA, ID_CURSO,TOTAL_ALUNOS) VALUES (" + rdr[0] + "," + "(SELECT ID_TEMPO FROM DM_TEMPO WHERE(DM_TEMPO.ANO = " + rdr[4] + " AND DM_TEMPO.PERIODO = " + rdr[5] + "))," + rdr[1] + "," + rdr[3] + "," + rdr[2] + "," + rdr[6] + ")");

                        }
                        rdr.Close(); // close the oracle reader
                    }
                }

                // QUERY OPERACIONAL COM ALUNOS APROVADOS -> TABELA FATOS
                sql = "SELECT PROFESSORES.MATRICULA_PROF, DEPARTAMENTOS.COD_DEP, CURSOS.COD_CURSO, DISCIPLINAS.COD_DISCIPLINA, TURMAS.ANO, TURMAS.PERIODO, COUNT(ALUNO_TURMA.MATRICULA_ALU)"
                    + " FROM PROFESSORES INNER JOIN TURMAS ON PROFESSORES.MATRICULA_PROF = TURMAS.MATRICULA_PROF"
                    + " INNER JOIN DISCIPLINAS ON TURMAS.COD_DISCIPLINA = DISCIPLINAS.COD_DISCIPLINA"
                    + " INNER JOIN CURSOS ON CURSOS.COD_CURSO = DISCIPLINAS.COD_CURSO"
                    + " INNER JOIN DEPARTAMENTOS ON DEPARTAMENTOS.COD_DEP = CURSOS.COD_DEP"
                    + " INNER JOIN ALUNO_TURMA ON(ALUNO_TURMA.COD_DISCIPLINA = DISCIPLINAS.COD_DISCIPLINA AND ALUNO_TURMA.MATRICULA_PROF = PROFESSORES.MATRICULA_PROF)"
                    + " WHERE ALUNO_TURMA.NOTA >= 6 "
                    + " GROUP BY PROFESSORES.MATRICULA_PROF, DEPARTAMENTOS.COD_DEP, CURSOS.COD_CURSO, DISCIPLINAS.COD_DISCIPLINA, TURMAS.ANO, TURMAS.PERIODO"
                    ;
                using (OracleCommand comm = new OracleCommand(sql, conn)) // create the oracle sql command
                {
                    using (OracleDataReader rdr = comm.ExecuteReader()) // execute the oracle sql and start reading it
                    {

                        while (rdr.Read()) // loop through each row from oracle
                        {
                            sqlInsert.Add("UPDATE FT_DATAMART SET ALUNOS_APROVADOS = " + rdr[6] + " WHERE (ID_PROFESSOR = " + rdr[0] + " AND ID_DEPARTAMENTO =" + rdr[1] + " AND ID_CURSO = " + rdr[2] + " AND ID_DISCIPLINA = " + rdr[3] + " AND ID_TEMPO = (SELECT ID_TEMPO FROM DM_TEMPO WHERE (ANO = " + rdr[4] + " AND PERIODO = " + rdr[5] + ")))");

                        }
                        rdr.Close(); // close the oracle reader
                    }
                }



                conn.Close(); // close the oracle connection
            }
            OracleConnection conndw = new OracleConnection("DATA SOURCE=localhost:1521;" + "PERSIST SECURITY INFO=True;USER ID=APS_DW; password=luique; Pooling = False; ");
            conndw.Open();
            foreach (string insert in sqlInsert)
            {
                try
                {
                    Debug.WriteLine(insert);
                    OracleCommand commdw = new OracleCommand(insert, conndw);
                    commdw.ExecuteReader();
                }

                catch (Exception ex)
                {
                    Debug.WriteLine(ex.ToString());
                }
            }
            conndw.Close();
        }
        
    }
}
