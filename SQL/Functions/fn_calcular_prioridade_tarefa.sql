CREATE OR REPLACE FUNCTION fn_calcular_prioridade_tarefa
(
    p_nCdTarefa DECIMAL(10,0)
)
    RETURNS DECIMAL
AS $$
DECLARE v_iGravidade  INTEGER;
        v_iUrgencia   INTEGER;
        v_iTendencia  INTEGER;
        v_prioridade  DECIMAL;
BEGIN
    SELECT iGravidade
         , iUrgencia
         , iTendencia
      INTO v_iGravidade
         , v_iUrgencia
         , v_iTendencia
      FROM Tarefa
     WHERE nCdTarefa = p_nCdTarefa;

    IF NOT FOUND THEN
        RETURN NULL;
    END IF;
    v_prioridade := (v_iGravidade * 0.4) + (v_iUrgencia * 0.4) + (v_iTendencia * 0.2);

    RETURN v_prioridade;
END;
$$
LANGUAGE plpgsql;