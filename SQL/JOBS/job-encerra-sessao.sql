DO $$
    BEGIN
        BEGIN
            PERFORM cron.schedule_in_database(
                    'job-encerra-sessao-ds',
                    '*/10 * * * *',
                    'CALL public.sp_encerrar_sessao_inativa(15);',
                    'dsSegundoAno'
                    );
            RAISE NOTICE 'Job agendado com sucesso no banco de dados "dsSegundoAno".';
        EXCEPTION
            WHEN invalid_catalog_name THEN
                RAISE NOTICE 'O banco de dados "dsSegundoAno" não existe. Ignorando agendamento para este banco.';
        END;

        BEGIN
            PERFORM cron.schedule_in_database(
                    'job-encerra-sessao-db',
                    '*/10 * * * *',
                    'CALL public.sp_encerrar_sessao_inativa(15);',
                    'dbSegundoAno'
                    );
            RAISE NOTICE 'Job agendado com sucesso no banco de dados "dbSegundoAno".';
        EXCEPTION
            WHEN invalid_catalog_name THEN
                RAISE NOTICE 'O banco de dados "dbSegundoAno" não existe. Ignorando agendamento para este banco.';
        END;
    END;
$$;