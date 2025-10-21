CREATE OR REPLACE FUNCTION fn_log_administracao()
    RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
    INSERT INTO table_log.Administracao ( nCdLog
                                        , nCdAdm
                                        , cNmAdm
                                        , cEmailAdm
                                        , cSenha
                                        , cOperacao
                                        , dOperacao
                                        )
                                VALUES  ( DEFAULT
                                        , NEW.nCdAdm
                                        , NEW.cNmAdm
                                        , NEW.cEmailAdm
                                        , NEW.cSenha
                                        , TG_OP
                                        , CURRENT_TIMESTAMP
                                        );
    RETURN NEW;
  ELSIF TG_OP = 'DELETE' THEN
    INSERT INTO table_log.Administracao ( nCdLog
                                        , nCdAdm
                                        , cNmAdm
                                        , cEmailAdm
                                        , cSenha
                                        , cOperacao
                                        , dOperacao
                                        )
                                 VALUES ( DEFAULT
                                        , OLD.nCdAdm
                                        , OLD.cNmAdm
                                        , OLD.cEmailAdm
                                        , OLD.cSenha
                                        , TG_OP
                                        , CURRENT_TIMESTAMP
                                        );
    RETURN OLD;
  END IF;
END;
$$
LANGUAGE plpgsql;