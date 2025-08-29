CREATE OR REPLACE FUNCTION fn_validar_usuario_gestor()
    RETURNS TRIGGER
AS $$
BEGIN
    IF NEW.nCdUsuario = NEW.nCdGestor
    THEN
        RAISE EXCEPTION 'Um usuário não pode ser gestor de si mesmo';
END IF;
RETURN NEW;
END;
$$
LANGUAGE plpgsql;