CREATE OR REPLACE TRIGGER tg_log_setor
    AFTER INSERT
       OR UPDATE
	   OR DELETE
       ON public.Setor
    FOR EACH ROW
        EXECUTE FUNCTION fn_log_setor();