CREATE OR REPLACE FUNCTION fn_validar_relator()
RETURNS TRIGGER AS $$
BEGIN
  IF NOT EXISTS ( SELECT bGestor 
                    FROM Usuario
                   WHERE bGestor = true 
                     AND nCdUsuario = NEW.nCdUsuarioRelator 
                ) THEN
    RAISE EXCEPTION 'Apenas gestores podem criar tarefas';
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

