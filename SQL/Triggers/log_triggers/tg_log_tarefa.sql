CREATE OR REPLACE TRIGGER tg_log_tarefa
    AFTER INSERT
       OR UPDATE
	   OR DELETE
       ON public.Tarefa
    FOR EACH ROW
        EXECUTE FUNCTION fn_log_tarefa();
		