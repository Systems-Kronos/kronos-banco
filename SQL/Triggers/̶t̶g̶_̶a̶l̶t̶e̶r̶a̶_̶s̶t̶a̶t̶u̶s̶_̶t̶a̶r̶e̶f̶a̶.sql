DROP TRIGGER IF EXISTS tg_altera_status_tarefa ON TarefaUsuario;

-- CREATE OR REPLACE TRIGGER tg_altera_status_tarefa
--     AFTER INSERT
--        ON TarefaUsuario
--     FOR EACH ROW
--         EXECUTE FUNCTION fn_altera_status_tarefa();

