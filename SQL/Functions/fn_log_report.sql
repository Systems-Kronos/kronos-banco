CREATE OR REPLACE FUNCTION fn_log_report()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
    INSERT INTO table_log.Report ( nCdLog 
								 , nCdReport
                                 , nCdTarefa
                                 , nCdUsuario
                                 , cDescricao
                                 , cProblema
                                 , cStatus
                                 , cOperacao
                                 , dOperacao
                                 )
                          VALUES ( DEFAULT
								 , NEW.nCdReport
                                 , NEW.nCdTarefa
                                 , NEW.nCdUsuario
                                 , NEW.cDescricao
                                 , NEW.cProblema
                                 , NEW.cStatus
                                 , TG_OP
                                 , CURRENT_TIMESTAMP
                                 );
    RETURN NEW;
  ELSIF TG_OP = 'DELETE' THEN
    INSERT INTO table_log.Report ( nCdLog
								 , nCdReport
                                 , nCdTarefa
                                 , nCdUsuario
                                 , cDescricao
                                 , cProblema
                                 , cStatus
                                 , cOperacao
                                 , dOperacao
                                 )
                          VALUES ( DEFAULT
								 , OLD.nCdReport
                                 , OLD.nCdTarefa
                                 , OLD.nCdUsuario
                                 , OLD.cDescricao
                                 , OLD.cProblema
                                 , OLD.cStatus
                                 , TG_OP
                                 , CURRENT_TIMESTAMP
                                 );
    RETURN OLD;
  END IF;
END;
$$ LANGUAGE plpgsql;
