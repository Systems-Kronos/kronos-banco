CREATE OR REPLACE FUNCTION fn_log_setor()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
    INSERT INTO table_log.Setor ( nCdSetor
                                , nCdEmpresa
                                , cNmSetor
                                , cSgSetor
                                , cOperacao
                                , dOperacao
                                )
                         VALUES ( NEW.nCdSetor
                                , NEW.nCdEmpresa 
                                , NEW.cNmSetor
                                , NEW.cSgSetor
                                , TG_OP
                                , CURRENT_TIMESTAMP
                                );
    RETURN NEW;
  ELSIF TG_OP = 'DELETE' THEN
    INSERT INTO table_log.Setor ( nCdSetor
                                , nCdEmpresa
                                , cNmSetor
                                , cSgSetor
                                , cOperacao
                                , dOperacao
                                )
                         VALUES ( OLD.nCdSetor
                                , OLD.nCdEmpresa
                                , OLD.cNmSetor
                                , OLD.cSgSetor
                                , TG_OP
                                , CURRENT_TIMESTAMP
                                );
    RETURN OLD;
  END IF;
END;
$$ LANGUAGE plpgsql;
