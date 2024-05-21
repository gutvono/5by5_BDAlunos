CREATE OR ALTER PROC Matricular_Aluno
	@RA varchar(15),
	@CPF varchar(11),
	@Nome_aluno varchar(30),
	@Data_nasc date,
	@Semestre int,
	@Ano int,
	@Sigla varchar(4)
AS
BEGIN

	INSERT INTO Aluno (RA, CPF, Nome_aluno, Data_nasc)
	VALUES 
		(@RA, @CPF, @Nome_aluno, @Data_nasc);

	INSERT INTO Aluno_Disciplina (RA_aluno, Sigla_disciplina, Semestre, Ano, N1, N2, Sub, Media, Faltas)
	VALUES 
		(@RA, @Sigla, @Semestre, @Ano, null, null, null, null, null)


	/*DECLARE Aux_Cursor CURSOR FOR
        SELECT 
            Sigla
        FROM
            Disciplina;

	OPEN Aux_Cursor;

    FETCH NEXT FROM Aux_Cursor
    INTO
        @Sigla

	WHILE @@FETCH_STATUS = 0
    BEGIN
		INSERT INTO Aluno_Disciplina (RA_aluno, Sigla_disciplina, Semestre, Ano, N1, N2, Sub, Media, Faltas)
		VALUES 
			(@RA, @Sigla, @Semestre, @Ano, null, null, null, null, null)

		FETCH NEXT FROM Aux_Cursor
			INTO
				@Sigla
    END

    CLOSE Aux_Cursor;
    DEALLOCATE Aux_Cursor;*/

	SELECT * FROM Aluno;
	SELECT * FROM Aluno_Disciplina;

END

DECLARE
	@Sig varchar(4) = (SELECT TOP 1 Sigla FROM Disciplina)

EXEC Matricular_Aluno
	'111112222233333',
	'2222222222',
	'Caboclo',
	'2000-02-02',
	1,
	2023,
	@Sig


	/*@RA varchar(15),
	@CPF varchar(11),
	@Nome_aluno varchar(30),
	@Data_nasc date,
	@Semestre int,
	@Ano int,
	@Sigla varchar(4)*/
