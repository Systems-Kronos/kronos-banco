CREATE OR REPLACE FUNCTION fn_busca_substituto
(
    p_nCdUsuarioAusente BIGINT
)
    RETURNS TABLE ( nCdTarefa            BIGINT
                  , nCdUsuarioSubstituto BIGINT
                  )
AS $$
BEGIN
    RETURN QUERY
        WITH TarefasPendentes AS (
            SELECT TarefaUsuario.nCdTarefa
                 , (SELECT fn_calcula_prioridade_tarefa(TarefaUsuario.nCdTarefa)) AS iPrioridadeTarefa
                 , TarefaHabilidade.nCdHabilidade
                 , TarefaHabilidade.iPrioridade AS iProridadeHabilidade
                 , Usuario.nCdEmpresa           AS nCdEmpresaUsuarioAtuante
              FROM TarefaUsuario
                   INNER JOIN TarefaHabilidade ON TarefaUsuario.nCdTarefa                = TarefaHabilidade.nCdTarefa
                   INNER JOIN Usuario          ON TarefaUsuario.nCdUsuarioAtuante = Usuario.nCdUsuario
             WHERE TarefaUsuario.nCdUsuarioAtuante = p_nCdUsuarioAusente
        ),
             SubstitutosQualificados AS (
                 SELECT TarefasPendentes.nCdTarefa
                      , TarefasPendentes.nCdHabilidade
                      , HabilidadeUsuario.nCdUsuario AS nCdUsuarioSubstituto
                      , COALESCE(COUNT(TarefaUsuario.nCdTarefa), 0) AS tarefas_atribuidas
                      , ROW_NUMBER() OVER( PARTITION BY TarefasPendentes.nCdTarefa
                                               ORDER BY CASE
                                                          WHEN TarefasPendentes.iPrioridadeTarefa > 4.5 THEN TarefasPendentes.iProridadeHabilidade
                                                          ELSE COALESCE(COUNT(TarefaUsuario.nCdTarefa), 0)
                                                         END
                                         ) AS rank_substituto
                  FROM TarefasPendentes
                       INNER JOIN HabilidadeUsuario ON TarefasPendentes.nCdHabilidade = HabilidadeUsuario.nCdHabilidade
                       INNER JOIN Usuario           ON HabilidadeUsuario.nCdUsuario   = Usuario.nCdUsuario
                       LEFT  JOIN TarefaUsuario     ON HabilidadeUsuario.nCdUsuario   = TarefaUsuario.nCdUsuarioAtuante
                 WHERE Usuario.bAtivo                = TRUE
                   AND HabilidadeUsuario.nCdUsuario <> p_nCdUsuarioAusente
                   AND Usuario.nCdEmpresa            = TarefasPendentes.nCdEmpresaUsuarioAtuante
                   AND Usuario.bGestor               = FALSE
                 GROUP BY TarefasPendentes.nCdTarefa
                        , TarefasPendentes.nCdHabilidade
                        , HabilidadeUsuario.nCdUsuario
                        , TarefasPendentes.iPrioridadeTarefa
                        , TarefasPendentes.iProridadeHabilidade
             )
        SELECT DISTINCT
               TarefasPendentes.nCdTarefa
             , SubstitutosQualificados.nCdUsuarioSubstituto
          FROM TarefasPendentes
               LEFT JOIN SubstitutosQualificados ON TarefasPendentes.nCdTarefa = SubstitutosQualificados.nCdTarefa
         WHERE SubstitutosQualificados.rank_substituto = 1
            OR SubstitutosQualificados.nCdTarefa      IS NULL;
END;
$$
    LANGUAGE plpgsql;
