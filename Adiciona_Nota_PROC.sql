CREATE OR ALTER PROC Adiciona_Nota
		@RA varchar(15),
		@Nota1 numeric (3,1),
		@Nota2 numeric(3,1),
		@Sub numeric(3,1),
		@Faltas int,
		@Sigla varchar(4),
		@Ano int,
		@Semestre int
AS
BEGIN

		UPDATE Aluno_Disciplina
		SET
			RA_aluno = @RA,
			N1 = @Nota1,
			N2 = @Nota2,
			Sub = @Sub,
			Faltas = @Faltas
		WHERE
			RA_aluno = @RA AND Sigla_disciplina = @Sigla AND Ano = @Ano AND Semestre = @Semestre;

		EXEC Calculo_Situacao_Aluno;
		
		SELECT * FROM Aluno_Disciplina;

END


EXEC Adiciona_Nota
	'111112222233333',
	7.3,
	2.5,
	null,
	3,
	'.Net',
	2023,
	1

EXEC Adiciona_Nota
	'333332222211111',
	7.3,
	8,
	null,
	3,
	'BD',
	2023,
	2