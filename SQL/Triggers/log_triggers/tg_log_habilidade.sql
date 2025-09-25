CREATE OR REPLACE TRIGGER tg_log_habilidade
    AFTER INSERT
       OR UPDATE
	   OR DELETE
       ON public.Habilidade
    FOR EACH ROW
        EXECUTE FUNCTION fn_log_habilidade();
		