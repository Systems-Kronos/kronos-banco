CREATE OR REPLACE FUNCTION fn_valida_atribuicao_tarefa()
    RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS(SELECT 1
              FROM TarefaUsuario
              WHERE nCdTarefa = NEW.nCdTarefa
                AND nCdUsuarioOriginal = NEW.nCdUsuarioAtuante
                AND nCdUsuarioAtuante = NEW.nCdUsuarioOriginal
                AND (TG_OP <> 'UPDATE' OR (nCdUsuarioOriginal, nCdUsuarioAtuante) <> (OLD.nCdUsuarioOriginal, OLD.nCdUsuarioAtuante))
    ) THEN

        RAISE EXCEPTION 'A tarefa já possui uma atribuição com os papéis de usuário invertidos (Original e Atuante).';
END IF;

    IF EXISTS(SELECT 1
              FROM TarefaUsuario
              WHERE nCdTarefa = NEW.nCdTarefa
                AND (
                  nCdUsuarioOriginal = NEW.nCdUsuarioAtuante
                      OR nCdUsuarioAtuante = NEW.nCdUsuarioOriginal
                  )
                AND (TG_OP <> 'UPDATE' OR (nCdUsuarioOriginal, nCdUsuarioAtuante) <> (OLD.nCdUsuarioOriginal, OLD.nCdUsuarioAtuante))
    ) THEN
        RAISE EXCEPTION 'A tarefa já possui uma atribuição que entra em conflito com os usuários do novo registro.';
END IF;

RETURN NEW;
END;
$$
LANGUAGE plpgsql;