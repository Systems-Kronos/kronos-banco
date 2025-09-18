CREATE OR REPLACE FUNCTION fn_log_mensagem()
    RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
    INSERT INTO table_log.Mensagem ( nCdLog
								   , nCdMensagem   
                                   , cTitulo       
                                   , cMensagem     
                                   , cCategoria    
						    	   , cOperacao   
                                   , dOperacao 
			     				   )
                           VALUES  ( DEFAULT
								   , NEW.nCdMensagem
                                   , NEW.cTitulo
							       , NEW.cMensagem
							       , NEW.cCategoria
								   , TG_OP
								   , CURRENT_DATE
                                   );    
    RETURN NEW;
  ELSIF TG_OP = 'DELETE' THEN
    INSERT INTO table_log.Mensagem ( nCdLog
								   , nCdMensagem   
                                   , cTitulo       
                                   , cMensagem     
                                   , cCategoria 
							       , cOperacao   
                                   , dOperacao 
			     				   )
                           VALUES  ( DEFAULT
								   , OLD.nCdMensagem
                                   , OLD.cTitulo
							       , OLD.cMensagem
								   , OLD.cCategoria
								   , TG_OP
								   , CURRENT_DATE
                                   );
    RETURN OLD;
  END IF;
END;
$$
LANGUAGE plpgsql;