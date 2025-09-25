CREATE OR REPLACE TRIGGER tg_log_mensagem
    AFTER INSERT
       OR UPDATE
	   OR DELETE
       ON public.Mensagem
    FOR EACH ROW
        EXECUTE FUNCTION fn_log_mensagem();
		