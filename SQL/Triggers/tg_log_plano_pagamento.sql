CREATE OR REPLACE TRIGGER tg_log_plano_pagamento
    AFTER INSERT
       OR UPDATE
	   OR DELETE
       ON public.PlanoPagamento
    FOR EACH ROW
        EXECUTE FUNCTION fn_log_plano_pagamento();