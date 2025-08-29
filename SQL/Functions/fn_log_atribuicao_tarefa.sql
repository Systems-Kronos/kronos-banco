CREATE OR REPLACE FUNCTION fn_log_atribuicao_tarefa()
    RETURNS TRIGGER AS $$
BEGIN
INSERT INTO LogAtribuicaoTarefa ( nCdTarefa
                                , nCdUsuarioAtuante
                                , dRealocacao
)
VALUES ( NEW.nCdTarefa
       , NEW.nCdUsuarioAtuante
       , CURRENT_DATE
       );
RETURN NEW;
END;
$$
LANGUAGE plpgsql;