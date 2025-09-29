CREATE OR REPLACE FUNCTION fn_lista_tarefa_usuario
(
    p_cd_usuario  BIGINT
,   p_ctptarefa   CHAR(1) DEFAULT '1' -- 1-Todas / 2-Realocadas / 3-Original
,   p_cstatus     CHAR(1) DEFAULT '1' -- 1-Não concluídas / 2-Concluídas / 3-Canceladas / 4-Todas
)
    RETURNS TABLE ( ncdtarefa           BIGINT
                  , cnmtarefa           VARCHAR(255)
                  , ncdusuariorelator   BIGINT
                  , igravidade          INTEGER
                  , iurgencia           INTEGER
                  , itendencia          INTEGER
                  , itempoestimado      INTEGER
                  , cdescricao          TEXT
                  , cstatus             OPCAO_STATUS
                  , ddataatribuicao     TIMESTAMP
                  , ddataconclusao      TIMESTAMP
                  , cOrigemTarefa        TEXT
                  ) AS $$
BEGIN
    RETURN QUERY
        SELECT tarefa.ncdtarefa
             , tarefa.cnmtarefa
             , tarefa.ncdusuariorelator
             , tarefa.igravidade
             , tarefa.iurgencia
             , tarefa.itendencia
             , tarefa.itempoestimado
             , tarefa.cdescricao
             , tarefa.cstatus
             , tarefa.ddataatribuicao
             , tarefa.ddataconclusao
             , CASE
                 WHEN tarefausuario.ncdusuariooriginal = p_cd_usuario THEN 'Original'
                 ELSE 'Realocada'
                END AS OrigemTarefa
          FROM tarefausuario
                INNER JOIN tarefa ON tarefausuario.ncdtarefa = tarefa.ncdtarefa
         WHERE tarefausuario.ncdusuarioatuante = p_cd_usuario
           AND (  (p_cstatus = '1' AND tarefa.cstatus IN ('Pendente', 'Em Andamento'))
               OR (p_cstatus = '2' AND tarefa.cstatus = 'Concluída')
               OR (p_cstatus = '3' AND tarefa.cstatus = 'Cancelada')
               OR (p_cstatus = '4')
               )
           AND (  (p_ctptarefa = '3' AND tarefausuario.ncdusuariooriginal == p_cd_usuario)
               OR (p_ctptarefa = '2' AND tarefausuario.ncdusuariooriginal != p_cd_usuario)
               OR (p_ctptarefa = '1')
               );
END;
$$
    LANGUAGE plpgsql;