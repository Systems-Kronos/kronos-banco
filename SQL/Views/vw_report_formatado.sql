CREATE OR REPLACE VIEW vw_report_formatado AS
SELECT nCdReport
     , nCdTarefa
	 , nCdUsuario 
	 , cDescricao
	 , cProblema
	 , cStatus         :: VARCHAR(20)
  FROM public.Report