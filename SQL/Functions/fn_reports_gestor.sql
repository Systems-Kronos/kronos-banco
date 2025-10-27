CREATE OR REPLACE FUNCTION fn_reports_gestor
(
    p_cd_gestor  BIGINT
)
    RETURNS TABLE ( nCdReport  BIGINT
                  , nCdTarefa  BIGINT
                  , cNmTarefa  VARCHAR(100)
                  , nCdUsuario BIGINT
                  , cNmUsuario VARCHAR(100)
                  , cFoto      VARCHAR
                  , cDescricao VARCHAR(255)
                  , cProblema  VARCHAR(255)
                  , cStatus    OPCAO_STATUS
                  ) AS $$
BEGIN
    RETURN QUERY
        SELECT r.nCdReport
             , r.nCdTarefa
             , t.cNmTarefa
             , r.nCdUsuario
             , u.cNmUsuario
             , u.cFoto
             , r.cDescricao
             , r.cProblema
             , r.cStatus
          FROM public.Report r
               INNER JOIN public.Usuario u ON r.nCdUsuario = u.nCdUsuario
               INNER JOIN public.tarefa  t ON r.ncdtarefa  = t.ncdtarefa
         WHERE u.nCdGestor = p_cd_gestor
            OR u.nCdUsuario = p_cd_gestor;
END;
$$
    LANGUAGE plpgsql;
