CREATE TRIGGER tg_valida_atribuicao_tarefa
    BEFORE INSERT
        OR UPDATE
        ON TarefaUsuario
    FOR EACH ROW
        EXECUTE FUNCTION fn_valida_atribuicao_tarefa();
