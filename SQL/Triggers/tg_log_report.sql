CREATE OR REPLACE TRIGGER tg_log_report
    AFTER INSERT
       OR UPDATE
	   OR DELETE
       ON public.Report
    FOR EACH ROW
        EXECUTE FUNCTION fn_log_report();
		