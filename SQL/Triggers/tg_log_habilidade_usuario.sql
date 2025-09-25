CREATE OR REPLACE TRIGGER tg_log_habilidade_usuario
    AFTER INSERT
       OR UPDATE
	   OR DELETE
       ON public.HabilidadeUsuario
    FOR EACH ROW
        EXECUTE FUNCTION fn_log_habilidade_usuario();
		