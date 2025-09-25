CREATE OR REPLACE TRIGGER tg_log_tarefa_habilidade
    AFTER INSERT
       OR UPDATE
	   OR DELETE
       ON public.TarefaHabilidade
    FOR EACH ROW
        EXECUTE FUNCTION fn_log_tarefa_habilidade();
		
		

		