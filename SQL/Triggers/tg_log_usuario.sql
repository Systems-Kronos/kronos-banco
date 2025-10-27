CREATE OR REPLACE TRIGGER tg_log_usuario
    AFTER INSERT
       OR UPDATE
	   OR DELETE
       ON public.Usuario
    FOR EACH ROW
        EXECUTE FUNCTION fn_log_usuario();