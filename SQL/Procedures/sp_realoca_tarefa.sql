CREATE OR REPLACE PROCEDURE sp_realoca_tarefa
(
    p_nCdUsuarioSubstituto DECIMAL(10,0),
    p_nCdTarefa            DECIMAL(10,0),
    p_nCdUsuarioAusente    DECIMAL(10,0)
)
AS $$
BEGIN
    UPDATE TarefaUsuario
       SET nCdUsuarioAtuante = p_nCdUsuarioSubstituto
     WHERE TarefaUsuario.nCdTarefa = p_nCdTarefa
       AND (  TarefaUsuario.nCdUsuarioOriginal = p_nCdUsuarioAusente
           OR TarefaUsuario.nCdUsuarioAtuante  = p_nCdUsuarioAusente
           );
END;
$$
    LANGUAGE plpgsql;