-- Criação da stored procedure Calculo_Situacao_Aluno
CREATE OR ALTER PROC Calculo_Situacao_Aluno
AS
BEGIN
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

    -- Declaração de variáveis para armazenar os valores dos registros
    DECLARE
        @RA_aluno VARCHAR(15),
        @sigla VARCHAR(4),
        @N1 NUMERIC(3,1),
        @N2 NUMERIC(3,1),
        @Sub NUMERIC(3,1),
        @Media NUMERIC(3,1),
        @Faltas INT;

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

        SET @Media = (@N1 + @N2) / 2;

        -- Atualiza a coluna "Media" na tabela Aluno_Disciplina
        UPDATE Aluno_Disciplina
        SET
            Media = @Media
        WHERE
            RA_aluno = @RA_aluno AND Sigla_disciplina = @sigla;

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

    -- Imprime linha em branco
    PRINT('');

    -- Fecha o cursor
    CLOSE Aux_Cursor;
    DEALLOCATE Aux_Cursor;
END;


EXEC Calculo_Situacao_Aluno