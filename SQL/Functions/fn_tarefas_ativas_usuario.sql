CREATE OR REPLACE FUNCTION fn_tarefas_ativas_usuario
(
    p_nCdUsuario DECIMAL
)
    RETURNS TABLE ( nCDTarefa     DECIMAL
        , nCdHabilidade DECIMAL
                  )
AS $$
BEGIN
RETURN QUERY
SELECT t.nCdTarefa
     , t.nCdHabilidade
FROM TarefaUsuario tu
         JOIN Tarefa t ON t.nCdTarefa = tu.nCdTarefa
WHERE tu.nCdUsuarioAtuante = p_nCdUsuario
  AND t.cStatus            = 'Em Andamento'
ORDER BY fn_calcular_prioridade_tarefa(t.nCdTarefa) DESC;
END;
$$
LANGUAGE plpgsql;