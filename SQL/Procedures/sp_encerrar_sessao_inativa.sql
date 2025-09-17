CREATE OR REPLACE PROCEDURE sp_encerrar_sessao_inativa
(
    p_intervalo_minutos INTEGER DEFAULT 30
)
AS $$
BEGIN
  UPDATE RegistroDAU
     SET dDataSaida = dUltimoHeartbeat
       , iDuracaoMinutos = EXTRACT(EPOCH FROM (dUltimoHeartbeat - dDataEntrada)) / 60
   WHERE dDataSaida IS NULL
     AND dUltimoHeartbeat < NOW() - (p_intervalo_minutos || ' minutes')::INTERVAL;
END;
$$
LANGUAGE plpgsql;