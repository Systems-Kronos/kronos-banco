CREATE OR REPLACE FUNCTION fn_log_cargo()
    RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
    INSERT INTO table_log.Cargo ( nCdLog                
                                , nCdCargo              
                                , cNmCargo              
                                , cCdCBO                
                                , cNmFamiliaOcupacional 
                                , cOperacao     
                                , dOperacao        
                                )
                        VALUES  ( DEFAULT                
                                , NEW.nCdCargo              
                                , NEW.cNmCargo              
                                , NEW.cCdCBO                
                                , NEW.cNmFamiliaOcupacional 
                                , TG_OP
                                , CURRENT_TIMESTAMP
                                );    
    RETURN NEW;
  ELSIF TG_OP = 'DELETE' THEN
    INSERT INTO table_log.Cargo ( nCdLog                
                                , nCdCargo              
                                , cNmCargo              
                                , cCdCBO                
                                , cNmFamiliaOcupacional 
                                , cOperacao     
                                , dOperacao 
                                )
                         VALUES ( DEFAULT                
                                , OLD.nCdCargo              
                                , OLD.cNmCargo              
                                , OLD.cCdCBO                
                                , OLD.cNmFamiliaOcupacional 
                                , TG_OP
                                , CURRENT_TIMESTAMP
                                );
    RETURN OLD;
  END IF;
END;
$$
LANGUAGE plpgsql;