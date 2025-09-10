CREATE OR REPLACE PROCEDURE sp_desativar_tudo_empresa
(
    p_nCdEmpresa DECIMAL(10,0)
)
AS $$
BEGIN
    UPDATE Empresa
       SET bAtivo = FALSE
     WHERE nCdEmpresa = p_nCdEmpresa;

    -- Desativar todos os usuários da empresa
    UPDATE Usuario
       SET bAtivo = FALSE
     WHERE nCdEmpresa = p_nCdEmpresa;
END;
$$
    LANGUAGE plpgsql;