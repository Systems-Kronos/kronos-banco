CREATE OR REPLACE FUNCTION fn_log_habilidade()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
    INSERT INTO table_log.Habilidade ( nCdLog 
									 , nCdHabilidade
                                     , nCdEmpresa
                                     , cNmHabilidade
                                     , cDescricao
                                     , cOperacao
                                     , dOperacao
                                     )
                              VALUES ( DEFAULT
								     , NEW.nCdHabilidade
                                     , NEW.nCdEmpresa
                                     , NEW.cNmHabilidade
                                     , NEW.cDescricao
                                     , TG_OP
                                     , CURRENT_TIMESTAMP
                                     );
    RETURN NEW;
  ELSIF TG_OP = 'DELETE' THEN
    INSERT INTO table_log.Habilidade ( nCdLog
									 , nCdHabilidade
                                     , nCdEmpresa
                                     , cNmHabilidade
                                     , cDescricao
                                     , cOperacao
                                     , dOperacao
                                     )
                              VALUES ( DEFAULT
									 , OLD.nCdHabilidade
                                     , OLD.nCdEmpresa
                                     , OLD.cNmHabilidade
                                     , OLD.cDescricao
                                     , TG_OP
                                     , CURRENT_TIMESTAMP
                                     );
    RETURN OLD;
  END IF;
END;
$$ LANGUAGE plpgsql;
