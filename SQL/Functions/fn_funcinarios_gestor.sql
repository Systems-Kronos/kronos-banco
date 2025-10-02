CREATE OR REPLACE FUNCTION fn_funcinarios_gestor
(
    p_cd_gestor  BIGINT
)
    RETURNS TABLE ( nCdUsuario     BIGINT
                  , cNmUsuario     VARCHAR(100)
                  , nCdSetor       BIGINT
                  , cNmSetor       VARCHAR(255)
                  , nCdGestor      BIGINT
                  , bGestor        BOOLEAN
                  , nCdCargo       BIGINT
                  , cNmCargo       VARCHAR(255)
                  , cCdHabilidades TEXT
                  , cNmHabilidades TEXT
                  , cCPF           VARCHAR(15)
                  , cTelefone      VARCHAR(20)
                  , cEmail         VARCHAR(255)
                  , cFoto          VARCHAR
                  , bAtivo         BOOLEAN
                  ) AS $$
BEGIN
    RETURN QUERY
        SELECT vwIF.nCdUsuario
             , vwIF.cNmUsuario
             , vwIF.nCdSetor
             , vwIF.cNmSetor
             , vwIF.nCdGestor
             , vwIF.bGestor
             , vwIF.nCdCargo
             , vwIF.cNmCargo
             , vwIF.cCdHabilidades
             , vwIF.cNmHabilidades
             , vwIF.cCPF
             , vwIF.cTelefone
             , vwIF.cEmail
             , vwIF.cFoto
             , vwIF.bAtivo
          FROM vw_info_funcionario vwIF
         WHERE vwIF.nCdGestor = p_cd_gestor;
END;
$$
    LANGUAGE plpgsql;