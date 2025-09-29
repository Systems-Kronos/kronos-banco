CREATE OR REPLACE TRIGGER tg_validar_relator
   BEFORE INSERT
       ON Tarefa
      FOR EACH ROW
        EXECUTE FUNCTION fn_valida_relator();