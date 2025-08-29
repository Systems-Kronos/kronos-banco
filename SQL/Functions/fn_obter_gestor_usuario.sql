CREATE OR REPLACE FUNCTION fn_obter_gestor_usuario
(
    p_nCdUsuario DECIMAL
)
    RETURNS TABLE ( cNmGestor VARCHAR(100)
                  , cEmailGestor VARCHAR(255)
                  )
AS $$
BEGIN
RETURN QUERY
SELECT Gestor.cNmUsuario AS cNmGestor
     , Gestor.cEmail     AS cEmailGestor
FROM Usuario
         JOIN Usuario AS Gestor ON Usuario.nCdGestor = Gestor.nCdUsuario
WHERE Usuario.nCdUsuario = p_nCdUsuario;
END;
$$
LANGUAGE plpgsql;