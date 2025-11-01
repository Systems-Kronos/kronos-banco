CREATE OR REPLACE PROCEDURE sp_envia_sinal_vida
(
    p_nCdUsuario BIGINT
,   p_LocalUso   VARCHAR(10)
,   p_dHeartbeat TIMESTAMP  = NOW()
)
AS $$
BEGIN
    IF p_LocalUso NOT IN ('APP_WEB', 'APP_MOBILE') OR p_LocalUso IS NULL THEN
       RAISE INFO 'O Local de uso não existe, sinal inválido';
       RETURN;
    END IF;

    IF EXISTS(
        SELECT 1
          FROM table_log.RegistroDAU
         WHERE nCdUsuario  = p_nCdUsuario
           AND dDataSaida IS NULL
           AND cLocalUso   = p_LocalUso
    ) THEN
        UPDATE table_log.RegistroDAU
           SET dUltimoHeartbeat = p_dHeartbeat
         WHERE nCdUsuario  = p_nCdUsuario
           AND dDataSaida IS NULL;
    ELSE
        INSERT INTO table_log.RegistroDAU (nCdUsuario, dDataEntrada, cLocalUso, dUltimoHeartbeat)
                                   VALUES (p_nCdUsuario, p_dHeartbeat, p_LocalUso, p_dHeartbeat);
    END IF;
END;
$$
LANGUAGE plpgsql;