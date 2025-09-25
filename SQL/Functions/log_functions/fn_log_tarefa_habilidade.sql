CREATE OR REPLACE FUNCTION fn_log_tarefa_habilidade()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
    INSERT INTO table_log.TarefaHabilidade ( nCdLog
										   , nCdTarefaHabilidade
										   , nCdHabilidade
                                           , nCdTarefa
                                           , iPrioridade
                                           , cOperacao
                                           , dOperacao
                                           )
                                    VALUES ( DEFAULT
										   , NEW.nCdTarefaHabilidade											
									       , NEW.nCdHabilidade
                                           , NEW.nCdTarefa
                                           , NEW.iPrioridade
                                           , TG_OP
                                           , CURRENT_TIMESTAMP
                                           );
    RETURN NEW;
  ELSIF TG_OP = 'DELETE' THEN
    INSERT INTO table_log.TarefaHabilidade ( nCdLog
										   , nCdTarefaHabilidade										   
										   , nCdHabilidade
                                           , nCdTarefa
                                           , iPrioridade
                                           , cOperacao
                                           , dOperacao
                                           )
                                    VALUES ( DEFAULT
										   , OLD.nCdTarefaHabilidade									
										   , OLD.nCdHabilidade
                                           , OLD.nCdTarefa
                                           , OLD.iPrioridade
                                           , TG_OP
                                           , CURRENT_TIMESTAMP
                                           );
    RETURN OLD;
  END IF;
END;
$$ LANGUAGE plpgsql;
