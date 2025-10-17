CREATE OR REPLACE TRIGGER tg_log_cargo
    AFTER INSERT
       OR UPDATE
	   OR DELETE
       ON public.Cargo
    FOR EACH ROW
        EXECUTE FUNCTION fn_log_cargo();
