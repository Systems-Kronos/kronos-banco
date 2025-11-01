CREATE OR REPLACE VIEW vw_tarefa_formatada AS
SELECT nCdTarefa
     , cNmTarefa
	 , nCdUsuarioRelator 
	 , iGravidade
	 , iUrgencia
	 , iTendencia
	 , iTempoEstimado
	 , cDescricao      
	 , cStatus         :: VARCHAR(20)
	 , dDataAtribuicao :: DATE
	 , dDataPrazo      :: DATE
	 , dDataConclusao  :: DATE
  FROM public.Tarefa