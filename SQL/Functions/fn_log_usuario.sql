CREATE OR REPLACE FUNCTION fn_log_usuario()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
    INSERT INTO table_log.Usuario ( nCdLog
								  , nCdUsuario
                                  , cNmUsuario
								  , nCdGestor
                                  , bGestor
                                  , nCdEmpresa
                                  , nCdSetor
                                  , nCPF
                                  , cTelefone
                                  , cEmail
                                  , cSenha
                                  , cFoto
                                  , bAtivo
                                  , cOperacao
                                  , dOperacao
                                  )
                           VALUES ( DEFAULT
								  , NEW.nCdUsuario
                                  , NEW.cNmUsuario
                                  , NEW.nCdGestor
                                  , NEW.bGestor
                                  , NEW.nCdEmpresa
                                  , NEW.nCdSetor
                                  , NEW.nCPF
                                  , NEW.cTelefone
                                  , NEW.cEmail
                                  , NEW.cSenha
                                  , NEW.cFoto
                                  , NEW.bAtivo
                                  , TG_OP
                                  , CURRENT_TIMESTAMP
                                  );
    RETURN NEW;
  ELSIF TG_OP = 'DELETE' THEN
    INSERT INTO table_log.Usuario ( nCdLog
								  , nCdUsuario
                                  , cNmUsuario
                                  , nCdGestor
                                  , bGestor
                                  , nCdEmpresa
                                  , nCdSetor
                                  , nCPF
                                  , cTelefone
                                  , cEmail
                                  , cSenha
                                  , cFoto
                                  , bAtivo
                                  , cOperacao
                                  , dOperacao
                                  )
                           VALUES ( DEFAULT
								  , OLD.nCdUsuario
                                  , OLD.cNmUsuario
                                  , OLD.nCdGestor
                                  , OLD.bGestor
                                  , OLD.nCdEmpresa
                                  , OLD.nCdSetor
                                  , OLD.nCPF
                                  , OLD.cTelefone
                                  , OLD.cEmail
                                  , OLD.cSenha
                                  , OLD.cFoto
                                  , OLD.bAtivo
                                  , TG_OP
                                  , CURRENT_TIMESTAMP
                                  );
    RETURN OLD;
  END IF;
END;
$$ LANGUAGE plpgsql;

