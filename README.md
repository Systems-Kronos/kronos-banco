# Banco de Dados do Kronos
Este repositório contém a configuração completa de bancos de dados para o projeto Kronos, incluindo o modelo relacional em SQL, scripts de carga de dados e scripts para bancos de dados NoSQL, como MongoDB e Redis.

## Conteúdo

* **SQL/**: Scripts para o banco de dados relacional (PostgreSQL).
    * **Modelo/**: Contém o modelo de dados e o script de carga inicial.
        * `modelo.sql`: Define o esquema do banco de dados com tabelas, chaves primárias, chaves estrangeiras e sequências.
        * `data_load.sql`: Script de carga de dados de exemplo para popular as tabelas.
    * **Procedures/**: Procedimentos armazenados para automatizar tarefas.
        * `sp_desativar_empresa_completo.sql`: Um procedimento para desativar uma empresa e todos os seus usuários associados.
    * **Functions/**: Funções para lógica de negócios e validações.
        * `fn_altera_status_tarefa.sql`: Altera o status de uma tarefa para 'Em Andamento' após sua atribuição.
        * `fn_calcular_prioridade_tarefa.sql`: Calcula a prioridade de uma tarefa com base em sua gravidade, urgência e tendência.
        * `fn_get_user_permissions.sql`: Recupera as permissões (vantagens) de um usuário com base no seu plano de pagamento.
        * `fn_log_atribuicao_tarefa.sql`: Insere um registro no log quando uma tarefa é atribuída ou realocada.
        * `fn_obter_gestor_usuario.sql`: Retorna o nome e e-mail do gestor de um usuário específico.
        * `fn_tarefas_ativas_usuario.sql`: Lista as tarefas ativas de um usuário, ordenadas por prioridade.
        * `fn_valida_atribuicao_tarefa.sql`: Valida a atribuição de tarefas para evitar conflitos de papéis.
        * `fn_validar_usuario_gestor.sql`: Impede que um usuário seja o gestor de si mesmo.
    * **Triggers/**: Gatilhos que executam as funções automaticamente.
        * `tg_altera_status_tarefa.sql`: Ativa a função `fn_altera_status_tarefa` após a inserção de uma nova tarefa para um usuário.
        * `tg_log_atribuicao_tarefa.sql`: Ativa a função `fn_log_atribuicao_tarefa` após a inserção ou atualização na tabela `TarefaUsuario`.
        * `tg_valida_atribuicao_tarefa.sql`: Ativa a função `fn_valida_atribuicao_tarefa` antes de inserir ou atualizar na tabela `TarefaUsuario`.
        * `tg_validar_usuario_gestor.sql`: Ativa a função `fn_validar_usuario_gestor` antes de inserir ou atualizar um usuário.
* **MongoDB/**: Scripts para o banco de dados NoSQL.
    * `DataLoad_MongoDB.py`: Script Python para carregar dados de calendário para cada usuário no MongoDB, com diferentes tipos de eventos (atestados, faltas, presenças).
* **Redis/**: Scripts para o banco de dados de cache.
    * `DataLoad_Redis.py`: Script Python para gerar e carregar dados de notificações no Redis, usando chaves de hash e conjuntos (sets).

## Licença

Este repositório está sob a licença MIT. O texto completo da licença pode ser encontrado abaixo:
