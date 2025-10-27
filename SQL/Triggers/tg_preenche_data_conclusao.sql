CREATE OR REPLACE TRIGGER tg_preenche_data_conclusao
       BEFORE UPDATE
          ON public.Tarefa
         FOR EACH ROW
             EXECUTE FUNCTION fn_preenche_data_conclusao();