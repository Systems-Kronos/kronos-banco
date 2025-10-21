CREATE OR REPLACE TRIGGER tg_log_empresa
    AFTER INSERT
       OR UPDATE
	   OR DELETE
       ON public.Empresa
    FOR EACH ROW
        EXECUTE FUNCTION fn_log_empresa();
