CREATE OR REPLACE FUNCTION fn_preenche_data_conclusao()
    RETURNS TRIGGER AS $$
BEGIN

    IF (NEW.cStatus = 'Concluída' AND OLD.cStatus IS DISTINCT FROM 'Concluída') THEN
        NEW.dDataConclusao := NOW();
    END IF;

    RETURN NEW;
END;
$$
LANGUAGE plpgsql;