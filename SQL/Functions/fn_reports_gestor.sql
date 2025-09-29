CREATE OR REPLACE FUNCTION fn_reports_gestor
(
    p_cd_gestor  BIGINT
)
    RETURNS TABLE ( nCdReport  BIGINT
                  , nCdTarefa  BIGINT
                  , nCdUsuario BIGINT
                  , cDescricao VARCHAR(255)
                  , cProblema  VARCHAR(255)
                  , cStatus    OPCAO_STATUS
                  ) AS $$
BEGIN
    RETURN QUERY
        SELECT r.nCdReport
             , r.nCdTarefa
             , r.nCdUsuario
             , r.cDescricao
             , r.cProblema
             , r.cStatus
          FROM public.Report r
               INNER JOIN public.Usuario u ON r.nCdUsuario = u.nCdUsuario
         WHERE u.nCdGestor = p_cd_gestor
            OR u.nCdUsuario = p_cd_gestor;
END;
$$
    LANGUAGE plpgsql;