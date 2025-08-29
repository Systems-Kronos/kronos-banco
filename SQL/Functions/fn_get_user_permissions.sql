CREATE OR REPLACE FUNCTION fn_get_user_permissions
(
    p_cd_usuario DECIMAL
)
    RETURNS TABLE (vantagem_id DECIMAL) AS $$
BEGIN
RETURN QUERY
SELECT pv.cNmVantagem
FROM Usuario u
         JOIN Empresa        e  ON u.nCdEmpresa        = e.nCdEmpresa
         JOIN PlanoPagamento pp ON e.nCdPlanoPagamento = pp.nCdPlano
         JOIN PlanoVantagens pv ON pp.nCdPlano         = pv.nCdPlano
WHERE u.nCdUsuario = p_cd_usuario;
END;
$$
LANGUAGE plpgsql;