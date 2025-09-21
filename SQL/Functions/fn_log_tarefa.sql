CREATE OR REPLACE FUNCTION fn_log_tarefa()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
    INSERT INTO table_log.Tarefa ( nCdLog
								 , nCdTarefa
                                 , cNmTarefa
                                 , nCdUsuarioRelator
                                 , iGravidade
                                 , iUrgencia
                                 , iTendencia
                                 , iTempoEstimado
                                 , cDescricao
                                 , cStatus
								 , dDataAtribuicao
								 , dDataConclusao								  
                                 , cOperacao
                                 , dOperacao
                                 )
                          VALUES ( DEFAULT
								 , NEW.nCdTarefa 
                                 , NEW.cNmTarefa
                                 , NEW.nCdUsuarioRelator
                                 , NEW.iGravidade
                                 , NEW.iUrgencia
                                 , NEW.iTendencia
                                 , NEW.iTempoEstimado
                                 , NEW.cDescricao
                                 , NEW.cStatus
								 , NEW.dDataAtribuicao
								 , NEW.dDataConclusao									  
                                 , TG_OP
                                 , CURRENT_TIMESTAMP
                                 );
    RETURN NEW;
  ELSIF TG_OP = 'DELETE' THEN
    INSERT INTO table_log.Tarefa ( nCdLog
								 , nCdTarefa
                                 , cNmTarefa
                                 , nCdUsuarioRelator
                                 , iGravidade
                                 , iUrgencia
                                 , iTendencia
                                 , iTempoEstimado
                                 , cDescricao
                                 , cStatus
								 , dDataAtribuicao
								 , dDataConclusao									  
                                 , cOperacao
                                 , dOperacao
                                 )
                          VALUES ( DEFAULT
								 , OLD.nCdTarefa 
                                 , OLD.cNmTarefa
                                 , OLD.nCdUsuarioRelator
                                 , OLD.iGravidade
                                 , OLD.iUrgencia
                                 , OLD.iTendencia
                                 , OLD.iTempoEstimado
                                 , OLD.cDescricao
                                 , OLD.cStatus
								 , OLD.dDataAtribuicao
								 , OLD.dDataConclusao									  
                                 , TG_OP
                                 , CURRENT_TIMESTAMP
                                 );
    RETURN OLD;
  END IF;
END;
$$ LANGUAGE plpgsql;
