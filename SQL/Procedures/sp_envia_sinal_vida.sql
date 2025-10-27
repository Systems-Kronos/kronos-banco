CREATE OR REPLACE PROCEDURE sp_envia_sinal_vida
(
    p_nCdUsuario BIGINT
,   p_LocalUso   TIPO_LOCAL_USO
,   p_dHeartbeat TIMESTAMP      DEFAULT NOW()
)
AS $$
BEGIN
    IF EXISTS(
        SELECT 1
          FROM RegistroDAU
         WHERE nCdUsuario  = p_nCdUsuario
           AND dDataSaida IS NULL
           AND cLocalUso   = p_LocalUso
    ) THEN
        UPDATE RegistroDAU
           SET dUltimoHeartbeat = p_dHeartbeat
         WHERE nCdUsuario  = p_nCdUsuario
           AND dDataSaida IS NULL;
    ELSE
        INSERT INTO RegistroDAU (nCdUsuario, dDataEntrada, cLocalUso, dUltimoHeartbeat)
                         VALUES (p_nCdUsuario, p_dHeartbeat, p_LocalUso, p_dHeartbeat);
    END IF;
END;
$$
LANGUAGE plpgsql;