CREATE OR REPLACE FUNCTION fn_altera_status_tarefa()
    RETURNS TRIGGER AS $$
BEGIN
UPDATE Tarefa
SET cStatus   = 'Em Andamento'
WHERE nCdTarefa = NEW.nCdTarefa;

RETURN NEW;
END;
$$
LANGUAGE plpgsql;