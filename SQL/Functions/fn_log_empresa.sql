CREATE OR REPLACE FUNCTION fn_log_empresa()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
    INSERT INTO table_log.Empresa ( nCdLog
		                          , nCdEmpresa       
                                  , cNmEmpresa       
                                  , cSgEmpresa       
                                  , cCNPJ            
                                  , cTelefone        
                                  , cEmail           
                                  , cCEP             
                                  , nCdPlanoPagamento
                                  , bAtivo           
                                  , cOperacao        
                                  , dOperacao       
                                  )
                          VALUES  ( DEFAULT
							      , NEW.nCdEmpresa       
                                  , NEW.cNmEmpresa       
                                  , NEW.cSgEmpresa       
                                  , NEW.cCNPJ            
                                  , NEW.cTelefone        
                                  , NEW.cEmail           
                                  , NEW.cCEP             
                                  , NEW.nCdPlanoPagamento
                                  , NEW.bAtivo           
                                  , TG_OP        
                                  , CURRENT_TIMESTAMP       
                                  );
    RETURN NEW;
  ELSIF TG_OP = 'DELETE' THEN
    INSERT INTO table_log.Empresa ( nCdLog
								  , nCdEmpresa       
                                  , cNmEmpresa       
                                  , cSgEmpresa       
                                  , cCNPJ            
                                  , cTelefone        
                                  , cEmail           
                                  , cCEP             
                                  , nCdPlanoPagamento
                                  , bAtivo           
                                  , cOperacao        
                                  , dOperacao       
                                  )
                          VALUES  ( DEFAULT
							      , OLD.nCdEmpresa       
                                  , OLD.cNmEmpresa       
                                  , OLD.cSgEmpresa       
                                  , OLD.cCNPJ            
                                  , OLD.cTelefone        
                                  , OLD.cEmail           
                                  , OLD.cCEP             
                                  , OLD.nCdPlanoPagamento
                                  , OLD.bAtivo           
                                  , TG_OP        
                                  , CURRENT_TIMESTAMP       
                                  );
    RETURN OLD;  
  END IF;
END;
$$
LANGUAGE plpgsql;