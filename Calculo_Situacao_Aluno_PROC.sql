-- Cria��o da stored procedure Calculo_Situacao_Aluno
CREATE OR ALTER PROC Calculo_Situacao_Aluno
AS
BEGIN
    -- Declara��o do cursor para percorrer os registros da tabela Aluno_Disciplina
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

    -- Declara��o de vari�veis para armazenar os valores dos registros
    DECLARE
        @RA_aluno VARCHAR(15),
        @sigla VARCHAR(4),
        @N1 NUMERIC(3,1),
        @N2 NUMERIC(3,1),
        @Sub NUMERIC(3,1),
        @Faltas INT,
        @Media NUMERIC(3,1);

    -- Obt�m o primeiro registro
    FETCH NEXT FROM Aux_Cursor
    INTO
        @RA_aluno,
        @sigla,
        @N1,
        @N2,
        @Sub,
        @Faltas,
        @Media;

    -- Imprime cabe�alho
    PRINT('Dados do registro:');
    PRINT('');

    -- Loop para processar cada registro
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- Calcula a m�dia (caso as notas n�o sejam nulas)
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

        -- Imprime informa��es do registro
        PRINT(
            'Id: ' + @RA_aluno + 
            ', Codigo: ' + CONVERT(VARCHAR(10), @sigla) + 
            ', Nota 1: ' + CONVERT(VARCHAR(10), ISNULL(@N1, 0)) + 
            ', Nota 2: ' + CONVERT(VARCHAR(10), ISNULL(@N2, 0)) + 
            ', M�dia: ' + CONVERT(VARCHAR(20), @Media)
        );

        -- Obt�m o pr�ximo registro
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