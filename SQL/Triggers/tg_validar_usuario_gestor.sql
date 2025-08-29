CREATE OR REPLACE TRIGGER tg_validar_usuario_gestor
    BEFORE INSERT
        OR UPDATE
        ON usuario
    FOR EACH ROW
        EXECUTE FUNCTION fn_validar_usuario_gestor();