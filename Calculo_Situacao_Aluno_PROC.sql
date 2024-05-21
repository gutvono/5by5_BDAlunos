-- Criação da stored procedure Calculo_Situacao_Aluno
CREATE OR ALTER PROC Calculo_Situacao_Aluno
AS
BEGIN
	-- Declaração de variáveis para armazenar os valores dos registros
    DECLARE
        @RA_aluno VARCHAR(15),
        @sigla VARCHAR(4),
        @N1 NUMERIC(3,1),
        @N2 NUMERIC(3,1),
        @Sub NUMERIC(3,1),
        @Media NUMERIC(3,1),
        @Faltas INT;

    -- Declaração do cursor para percorrer os registros da tabela Aluno_Disciplina
    DECLARE Aux_Cursor CURSOR FOR
        SELECT 
            RA_aluno,
            Sigla_disciplina,
            N1,
            N2,
            Sub,
			Media,
            Faltas
        FROM
            Aluno_Disciplina;

    -- Abre o cursor
    OPEN Aux_Cursor;

    -- Obtém o primeiro registro
    FETCH NEXT FROM Aux_Cursor
    INTO
        @RA_aluno,
        @sigla,
        @N1,
        @N2,
        @Sub,
        @Media,
        @Faltas;

    -- Loop para processar cada registro
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Calcula a média (caso as notas não sejam nulas)
        IF (@N1 IS NULL)
            SET @N1 = 0;

        IF (@N2 IS NULL)
            SET @N2 = 0;

		IF (@Sub IS NOT NULL)
			BEGIN
				IF (@N1 > @N2)
					SET @Media = (@N1 + @Sub) / 2
				ELSE IF (@N2 > @N1)
					SET @Media = (@Sub + @N2) / 2
				ELSE
					SET @Media = (@N1 + @Sub) / 2
			END
		ELSE
			SET @Media = (@N1 + @N2) / 2;

        -- Atualiza a coluna "Media" na tabela Aluno_Disciplina
        UPDATE Aluno_Disciplina
        SET
            Media = @Media,
			Situacao = CASE WHEN @Media >= 6 THEN 'Aprovado' ELSE 'Reprovado' END
        WHERE
            RA_aluno = @RA_aluno AND Sigla_disciplina = @sigla;

		UPDATE Aluno_Disciplina
		SET
			Situacao = 'Reprovado por falta'
		WHERE
            RA_aluno = @RA_aluno AND Sigla_disciplina = @sigla AND Faltas > 5;

        -- Obtém o próximo registro
        FETCH NEXT FROM Aux_Cursor
        INTO
            @RA_aluno,
            @sigla,
            @N1,
            @N2,
            @Sub,
            @Faltas,
            @Media;
    END

    -- Fecha o cursor
    CLOSE Aux_Cursor;
    DEALLOCATE Aux_Cursor;
END;


EXEC Calculo_Situacao_Aluno