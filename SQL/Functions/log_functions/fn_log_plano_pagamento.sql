CREATE OR REPLACE FUNCTION fn_log_plano_pagamento()
    RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
    INSERT INTO table_log.PlanoPagamento ( nCdLog
										 , nCdPlano     
                                         , cNmPlano      
                                         , nPreco        
                                         , cOperacao       
                                         , dOperacao   
							  		     )
                                  VALUES ( DEFAULT
									     , NEW.nCdPlano
                                         , NEW.cNmPlano
							  		     , NEW.nPreco									  
                                         , TG_OP       
                                         , CURRENT_TIMESTAMP
                                         );
    RETURN NEW;								   
  ELSIF TG_OP = 'DELETE' THEN
    INSERT INTO table_log.PlanoPagamento ( nCdLog
										 , nCdPlano     
                                         , cNmPlano      
                                         , nPreco        
                                         , cOperacao       
                                         , dOperacao   
                                         )
                                  VALUES ( DEFAULT
									     , OLD.nCdPlano
                                         , OLD.cNmPlano
										 , OLD.nPreco									  
                                         , TG_OP       
                                         , CURRENT_TIMESTAMP
                                         );
    RETURN OLD;
  END IF;
END;
$$
LANGUAGE plpgsql;