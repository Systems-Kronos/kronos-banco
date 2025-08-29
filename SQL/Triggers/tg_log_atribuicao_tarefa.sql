CREATE OR REPLACE TRIGGER tg_log_atribuicao_tarefa
    AFTER INSERT
       OR UPDATE
       ON TarefaUsuario
    FOR EACH ROW
        EXECUTE FUNCTION fn_log_atribuicao_tarefa();