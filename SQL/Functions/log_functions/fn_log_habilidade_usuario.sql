CREATE OR REPLACE FUNCTION fn_log_habilidade_usuario()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
    INSERT INTO table_log.HabilidadeUsuario ( nCdLog
											, nCdHabilidade 
                                            , nCdUsuario    
                                            , cOperacao     
                                            , dOperacao    
                                            )
                                     VALUES ( DEFAULT
											, NEW.nCdHabilidade 
                                            , NEW.nCdUsuario    
                                            , TG_OP     
                                            , CURRENT_TIMESTAMP    
                                            );
    RETURN NEW;
  ELSIF TG_OP = 'DELETE' THEN
    INSERT INTO table_log.HabilidadeUsuario ( nCdLog
											, nCdHabilidade 
                                            , nCdUsuario    
                                            , cOperacao     
                                            , dOperacao    
                                            )
                                     VALUES ( DEFAULT
											, OLD.nCdHabilidade 
                                            , OLD.nCdUsuario    
                                            , TG_OP     
                                            , CURRENT_TIMESTAMP    
                                            );
    RETURN OLD;
  END IF;
END;
$$ LANGUAGE plpgsql;
                                                      