-- dbKronos: Script de Carga de Dados Corrigido

-- Adicionando TRUNCATE para garantir uma carga de dados limpa
TRUNCATE TABLE PlanoPagamento, Mensagem, Empresa, PlanoVantagens, Habilidade, Setor, Usuario, HabilidadeUsuario, Tarefa, LogAtribuicaoTarefa, Report, TarefaHabilidade, TarefaUsuario RESTART IDENTITY CASCADE;
ALTER SEQUENCE  sq_planopagamento         RESTART WITH 1;
ALTER SEQUENCE  sq_empresa                RESTART WITH 1;
ALTER SEQUENCE  sq_logatribuicaotarefa    RESTART WITH 1;
ALTER SEQUENCE  sq_mensagem               RESTART WITH 1;
ALTER SEQUENCE  sq_planovantagens         RESTART WITH 1;
ALTER SEQUENCE  sq_report                 RESTART WITH 1;
ALTER SEQUENCE  sq_setor                  RESTART WITH 1;
ALTER SEQUENCE  sq_tarefa                 RESTART WITH 1;
ALTER SEQUENCE  sq_usuario                RESTART WITH 1;
ALTER SEQUENCE  sq_habilidade             RESTART WITH 1;

-- Inserindo dados na tabela PlanoPagamento
INSERT INTO PlanoPagamento (nCdPlano, cNmPlano, nPreco) VALUES
                                                            (nextval('sq_planopagamento'), 'Básico', 50.00),
                                                            (nextval('sq_planopagamento'), 'Intermediário', 150.00),
                                                            (nextval('sq_planopagamento'), 'Profissional', 450.00),
                                                            (nextval('sq_planopagamento'), 'Empresarial', 1000.00),
                                                            (nextval('sq_planopagamento'), 'Corporativo', 2500.00);

-- Inserindo dados na tabela Mensagem
INSERT INTO Mensagem (nCdMensagem, cTitulo, cMensagem, cCategoria) VALUES
                                                                       (nextval('sq_mensagem'), 'Bem-vindo(a)!', 'Sua conta foi criada com sucesso! Explore todas as funcionalidades.', 'Boas-vindas'),
                                                                       (nextval('sq_mensagem'), 'Tarefa Concluída', 'A tarefa "Melhoria da Interface do Usuário" foi finalizada.', 'Notificação'),
                                                                       (nextval('sq_mensagem'), 'Nova Atribuição', 'Você foi atribuído a uma nova tarefa. Verifique seus projetos.', 'Atribuição'),
                                                                       (nextval('sq_mensagem'), 'Alerta de Prazo', 'O prazo para a tarefa "Relatório de Vendas Q3" está se esgotando!', 'Urgência'),
                                                                       (nextval('sq_mensagem'), 'Atualização de Sistema', 'O sistema Kronos foi atualizado com novos recursos. Confira as novidades.', 'Informativo'),
                                                                       (nextval('sq_mensagem'), 'Novo Setor', 'Um novo setor foi adicionado na sua empresa.', 'Informativo'),
                                                                       (nextval('sq_mensagem'), 'Habilidade Adicionada', 'Uma nova habilidade foi adicionada ao sistema.', 'Informativo'),
                                                                       (nextval('sq_mensagem'), 'Report Criado', 'Um novo report foi criado para a tarefa "Revisão de Código".', 'Notificação'),
                                                                       (nextval('sq_mensagem'), 'Reunião Agendada', 'Foi agendada uma reunião com a equipe de projetos.', 'Reunião'),
                                                                       (nextval('sq_mensagem'), 'Feedback Recebido', 'Você recebeu um feedback sobre seu trabalho.', 'Feedback');


-- Inserindo dados na tabela Empresa
INSERT INTO Empresa (nCdEmpresa, cNmEmpresa, cSgEmpresa, cCNPJ, cTelefone, cEmail, cCEP, nCdPlanoPagamento, bAtivo) VALUES
                                                                                                                        (nextval('sq_empresa'), 'Tech Solutions Ltda.', 'TSL', '11.111.111/0001-11', '(11) 98765-4321', 'contato@techsolutions.com.br', '01000-001', 4, true),
                                                                                                                        (nextval('sq_empresa'), 'Marketing Digital S.A.', 'MDS', '22.222.222/0001-22', '(21) 98765-4322', 'contato@mktglobal.com.br', '20000-002', 3, true),
                                                                                                                        (nextval('sq_empresa'), 'Consultoria Financeira', 'CFI', '33.333.333/0001-33', '(31) 98765-4323', 'contato@consultfin.com.br', '30000-003', 5, true),
                                                                                                                        (nextval('sq_empresa'), 'Logística Rápida', 'LGR', '44.444.444/0001-44', '(41) 98765-4324', 'contato@logistica.com.br', '80000-004', 2, true),
                                                                                                                        (nextval('sq_empresa'), 'Inovação e Tecnologia', 'IET', '55.555.555/0001-55', '(11) 95555-5555', 'contato@inovatech.com.br', '04000-005', 4, true),
                                                                                                                        (nextval('sq_empresa'), 'Serviços de Design', 'SDD', '66.666.666/0001-66', '(21) 96666-6666', 'contato@artdesign.com.br', '22000-006', 3, true),
                                                                                                                        (nextval('sq_empresa'), 'Indústria de Manufatura', 'IDM', '77.777.777/0001-77', '(31) 97777-7777', 'contato@manufatura.com.br', '33000-007', 5, true),
                                                                                                                        (nextval('sq_empresa'), 'E-commerce Brasil', 'ECB', '88.888.888/0001-88', '(41) 98888-8888', 'contato@ecomm.com.br', '81000-008', 2, true),
                                                                                                                        (nextval('sq_empresa'), 'Soluções em Saúde', 'SES', '99.999.999/0001-99', '(11) 99999-9999', 'contato@saudesolucoes.com.br', '01500-009', 4, true),
                                                                                                                        (nextval('sq_empresa'), 'Fábrica de Gado JBS', 'JBS', '10.101.101/0001-10', '(51) 91010-1010', 'contato@jbsgado.com.br', '90000-010', 2, true);

-- Inserindo dados na tabela PlanoVantagens
INSERT INTO PlanoVantagens (nCdPlano, nCdVantagem, cNmVantagem, cDescricao) VALUES
                                                                                (1, nextval('sq_planovantagens'), 'Gestão de 10 Usuários', 'Permite a gestão de até 10 usuários por empresa.'),
                                                                                (1, nextval('sq_planovantagens'), 'Criação de 20 Tarefas', 'Limite de 20 tarefas em andamento.'),
                                                                                (2, nextval('sq_planovantagens'), 'Análise de Desempenho', 'Acesso a relatórios básicos de produtividade.'),
                                                                                (2, nextval('sq_planovantagens'), 'Suporte Prioritário', 'Atendimento prioritário via chat e e-mail.'),
                                                                                (3, nextval('sq_planovantagens'), 'Relatórios Avançados', 'Relatórios detalhados com dashboards interativos.'),
                                                                                (3, nextval('sq_planovantagens'), 'Integrações Externas', 'Possibilidade de integrar com outras plataformas.'),
                                                                                (4, nextval('sq_planovantagens'), 'Gestão de 500 Usuários', 'Capacidade para gerenciar até 500 usuários.'),
                                                                                (4, nextval('sq_planovantagens'), 'Tarefas Ilimitadas', 'Sem limite para a quantidade de tarefas.'),
                                                                                (5, nextval('sq_planovantagens'), 'Suporte Dedicado 24/7', 'Atendimento personalizado com um gerente de contas.'),
                                                                                (5, nextval('sq_planovantagens'), 'Personalização Completa', 'Customização da interface e funcionalidades.'),
                                                                                (5, nextval('sq_planovantagens'), 'Análise Preditiva', 'Ferramentas de análise de tendência e previsão.');


-- Inserindo dados na tabela Habilidade
INSERT INTO Habilidade (nCdHabilidade, nCdEmpresa, cNmHabilidade, cDescricao) VALUES
                                                                                  (nextval('sq_habilidade'), 1, 'Desenvolvimento Java', 'Conhecimento em Java, Spring Boot e microserviços.'),
                                                                                  (nextval('sq_habilidade'), 1, 'Análise de Dados SQL', 'Habilidade em escrever queries complexas, otimização de consultas e modelagem de dados.'),
                                                                                  (nextval('sq_habilidade'), 1, 'Gestão de Projetos Ágeis', 'Experiência em Scrum, Kanban e liderança de equipe.'),
                                                                                  (nextval('sq_habilidade'), 2, 'Marketing Digital', 'Estratégias de SEO, SEM e mídias sociais.'),
                                                                                  (nextval('sq_habilidade'), 2, 'Criação de Conteúdo', 'Produção de textos e materiais visuais para campanhas.'),
                                                                                  (nextval('sq_habilidade'), 3, 'Contabilidade', 'Conhecimento em balanço patrimonial e demonstrações financeiras.'),
                                                                                  (nextval('sq_habilidade'), 3, 'Planejamento Tributário', 'Otimização de impostos e consultoria fiscal.'),
                                                                                  (nextval('sq_habilidade'), 4, 'Otimização de Rota', 'Definir as melhores rotas de entrega e distribuição.'),
                                                                                  (nextval('sq_habilidade'), 4, 'Gestão de Estoque', 'Controle e organização de produtos em armazéns.'),
                                                                                  (nextval('sq_habilidade'), 5, 'Desenvolvimento Python', 'Conhecimento em Python, Django e data science.'),
                                                                                  (nextval('sq_habilidade'), 5, 'Segurança da Informação', 'Análise de vulnerabilidades e proteção de dados.'),
                                                                                  (nextval('sq_habilidade'), 6, 'Design Gráfico', 'Criação de identidade visual, logotipos e peças gráficas.'),
                                                                                  (nextval('sq_habilidade'), 6, 'Experiência do Usuário (UX)', 'Pesquisa e design para otimizar a experiência do usuário.'),
                                                                                  (nextval('sq_habilidade'), 7, 'Controle de Qualidade', 'Testes e inspeção de produtos na linha de produção.'),
                                                                                  (nextval('sq_habilidade'), 7, 'Gestão da Cadeia de Suprimentos', 'Planejamento e coordenação de fluxo de produtos e informações.'),
                                                                                  (nextval('sq_habilidade'), 8, 'E-commerce', 'Operação de plataformas de e-commerce e gestão de vendas online.'),
                                                                                  (nextval('sq_habilidade'), 8, 'Logística Reversa', 'Processos de devolução e tratamento de produtos.'),
                                                                                  (nextval('sq_habilidade'), 9, 'Atendimento ao Cliente', 'Suporte e relacionamento com clientes.'),
                                                                                  (nextval('sq_habilidade'), 9, 'Análise de Saúde', 'Análise de dados de saúde e registros de pacientes.'),
                                                                                  (nextval('sq_habilidade'), 10, 'Gestão Agrícola', 'Planejamento e controle de plantio e colheita.'),
                                                                                  (nextval('sq_habilidade'), 10, 'Manejo de Gado', 'Conhecimento em criação e manejo de animais.'),
                                                                                  (nextval('sq_habilidade'), 1, 'DevOps', 'Práticas de integração e entrega contínua.'),
                                                                                  (nextval('sq_habilidade'), 1, 'Cloud Computing (AWS)', 'Conhecimento em serviços de nuvem da AWS.');


-- Inserindo dados na tabela Setor
INSERT INTO Setor (nCdSetor, nCdEmpresa, cNmSetor, cSgSetor) VALUES
                                                                 (nextval('sq_setor'), 1, 'TI - Desenvolvimento', 'TDE'),
                                                                 (nextval('sq_setor'), 1, 'TI - Infraestrutura', 'TIN'),
                                                                 (nextval('sq_setor'), 1, 'Recursos Humanos', 'RHU'),
                                                                 (nextval('sq_setor'), 2, 'Marketing', 'MKT'),
                                                                 (nextval('sq_setor'), 2, 'Comercial', 'COM'),
                                                                 (nextval('sq_setor'), 3, 'Contabilidade', 'CTB'),
                                                                 (nextval('sq_setor'), 3, 'Auditoria', 'AUD'),
                                                                 (nextval('sq_setor'), 4, 'Logística', 'LOG'),
                                                                 (nextval('sq_setor'), 4, 'Armazenamento', 'ARM'),
                                                                 (nextval('sq_setor'), 5, 'Engenharia de Software', 'EDS'),
                                                                 (nextval('sq_setor'), 5, 'Data Science', 'DSC'),
                                                                 (nextval('sq_setor'), 6, 'Design de Produto', 'DDP'),
                                                                 (nextval('sq_setor'), 6, 'UI/UX', 'UIX'),
                                                                 (nextval('sq_setor'), 7, 'Produção', 'PRO'),
                                                                 (nextval('sq_setor'), 7, 'Manutenção', 'MAN'),
                                                                 (nextval('sq_setor'), 8, 'Vendas Online', 'VON'),
                                                                 (nextval('sq_setor'), 8, 'Logística de E-commerce', 'LEC'),
                                                                 (nextval('sq_setor'), 9, 'Atendimento', 'ATD'),
                                                                 (nextval('sq_setor'), 9, 'TI - Saúde', 'TIS'),
                                                                 (nextval('sq_setor'), 10, 'Produção Agrícola', 'PAG'),
                                                                 (nextval('sq_setor'), 10, 'Pecuária', 'PEC');


-- Inserindo dados na tabela Usuario
-- Inserir gestores primeiro para referenciar em outros usuários
INSERT INTO Usuario (nCdUsuario, cNmUsuario, cSbrUsuario, cSgUsuario, nCdGestor, bGestor, nCdEmpresa, nCdSetor, nCPF, cTelefone, cEmail, cSenha, bAtivo) VALUES
                                                                                                                                                             (nextval('sq_usuario'), 'Carlos', 'Silva', 'carlossilva-tsl', NULL, true, 1, 1, '111.111.111-11', '(11) 99111-1111', 'carlos.silva@techsolutions.com.br', 'senha123', true),
                                                                                                                                                             (nextval('sq_usuario'), 'Ana', 'Costa', 'anacosta-mds', NULL, true, 2, 4, '222.222.222-22', '(21) 99222-2222', 'ana.costa@mktglobal.com.br', 'senha123', true),
                                                                                                                                                             (nextval('sq_usuario'), 'Pedro', 'Santos', 'pedrosantos-cfi', NULL, true, 3, 6, '333.333.333-33', '(31) 99333-3333', 'pedro.santos@consultfin.com.br', 'senha123', true),
                                                                                                                                                             (nextval('sq_usuario'), 'Mariana', 'Oliveira', 'marianaoliveira-lgr', NULL, true, 4, 8, '444.444.444-44', '(41) 99444-4444', 'mariana.o@logistica.com.br', 'senha123', true),
                                                                                                                                                             (nextval('sq_usuario'), 'Ricardo', 'Fernandes', 'ricardofernandes-iet', NULL, true, 5, 10, '555.555.555-55', '(11) 95555-5555', 'ricardo.f@inovatech.com.br', 'senha123', true),
                                                                                                                                                             (nextval('sq_usuario'), 'Juliana', 'Castro', 'julianacastro-sdd', NULL, true, 6, 12, '666.666.666-66', '(21) 96666-6666', 'juliana.c@artdesign.com.br', 'senha123', true),
                                                                                                                                                             (nextval('sq_usuario'), 'André', 'Guedes', 'andreguedes-idm', NULL, true, 7, 14, '777.777.777-77', '(31) 97777-7777', 'andre.g@manufatura.com.br', 'senha123', true),
                                                                                                                                                             (nextval('sq_usuario'), 'Daniel', 'Martins', 'danielmartins-ecb', NULL, true, 8, 16, '888.888.888-88', '(41) 98888-8888', 'daniel.m@ecomm.com.br', 'senha123', true),
                                                                                                                                                             (nextval('sq_usuario'), 'Bruna', 'Lopes', 'brunalopes-ses', NULL, true, 9, 18, '999.999.999-99', '(11) 99999-9999', 'bruna.l@saudesolucoes.com.br', 'senha123', true),
                                                                                                                                                             (nextval('sq_usuario'), 'Gustavo', 'Almeida', 'gustavoalmeida-jbs', NULL, true, 10, 20, '100.100.100-00', '(51) 91000-1000', 'gustavo.a@agrosul.com.br', 'senha123', true);

-- Inserir usuários regulares
INSERT INTO Usuario (nCdUsuario, cNmUsuario, cSbrUsuario, cSgUsuario, nCdGestor, bGestor, nCdEmpresa, nCdSetor, nCPF, cTelefone, cEmail, cSenha, bAtivo) VALUES
                                                                                                                                                             (nextval('sq_usuario'), 'João', 'Souza', 'joaosouza-tsl', 1, false, 1, 1, '111.111.111-12', '(11) 99111-1112', 'joao.souza@techsolutions.com.br', 'senha123', true),
                                                                                                                                                             (nextval('sq_usuario'), 'Beatriz', 'Lima', 'beatrizlima-tsl', 1, false, 1, 2, '111.111.111-13', '(11) 99111-1113', 'beatriz.l@techsolutions.com.br', 'senha123', true),
                                                                                                                                                             (nextval('sq_usuario'), 'Felipe', 'Mendes', 'felipemendes-tsl', 1, false, 1, 3, '111.111.111-14', '(11) 99111-1114', 'felipe.m@techsolutions.com.br', 'senha123', true),
                                                                                                                                                             (nextval('sq_usuario'), 'Julia', 'Pereira', 'juliapereira-mds', 2, false, 2, 4, '222.222.222-23', '(21) 99222-2223', 'julia.p@mktglobal.com.br', 'senha123', true),
                                                                                                                                                             (nextval('sq_usuario'), 'Ricardo', 'Neves', 'ricardoneves-mds', 2, false, 2, 5, '222.222.222-24', '(21) 99222-2224', 'ricardo.n@mktglobal.com.br', 'senha123', true),
                                                                                                                                                             (nextval('sq_usuario'), 'Laura', 'Rocha', 'laurarocha-cfi', 3, false, 3, 6, '333.333.333-34', '(31) 99333-3334', 'laura.r@consultfin.com.br', 'senha123', true),
                                                                                                                                                             (nextval('sq_usuario'), 'Guilherme', 'Castro', 'guilhermecastro-cfi', 3, false, 3, 7, '333.333.333-35', '(31) 99333-3335', 'gui.castro@consultfin.com.br', 'senha123', true),
                                                                                                                                                             (nextval('sq_usuario'), 'Isabela', 'Santos', 'isabelasantos-lgr', 4, false, 4, 8, '444.444.444-45', '(41) 99444-4445', 'isabela.s@logistica.com.br', 'senha123', true),
                                                                                                                                                             (nextval('sq_usuario'), 'Daniel', 'Gomes', 'danielgomes-lgr', 4, false, 4, 9, '444.444.444-46', '(41) 99444-4446', 'daniel.g@logistica.com.br', 'senha123', true),
                                                                                                                                                             (nextval('sq_usuario'), 'Luiza', 'Ramos', 'luizaramos-iet', 5, false, 5, 10, '555.555.555-56', '(11) 95555-5556', 'luiza.r@inovatech.com.br', 'senha123', true),
                                                                                                                                                             (nextval('sq_usuario'), 'Marcos', 'Souza', 'marcossouza-iet', 5, false, 5, 11, '555.555.555-57', '(11) 95555-5557', 'marcos.s@inovatech.com.br', 'senha123', true),
                                                                                                                                                             (nextval('sq_usuario'), 'Sofia', 'Lima', 'sofialima-sdd', 6, false, 6, 12, '666.666.666-67', '(21) 96666-6667', 'sofia.l@artdesign.com.br', 'senha123', true),
                                                                                                                                                             (nextval('sq_usuario'), 'Paulo', 'Ferreira', 'pauloferreira-sdd', 6, false, 6, 13, '666.666.666-68', '(21) 96666-6668', 'paulo.f@artdesign.com.br', 'senha123', true),
                                                                                                                                                             (nextval('sq_usuario'), 'Helena', 'Alves', 'helenaalves-idm', 7, false, 7, 14, '777.777.777-78', '(31) 97777-7778', 'helena.a@manufatura.com.br', 'senha123', true),
                                                                                                                                                             (nextval('sq_usuario'), 'José', 'Moura', 'josemoura-idm', 7, false, 7, 15, '777.777.777-79', '(31) 97777-7779', 'jose.m@manufatura.com.br', 'senha123', true),
                                                                                                                                                             (nextval('sq_usuario'), 'Fernanda', 'Costa', 'fernandacosta-ecb', 8, false, 8, 16, '888.888.888-89', '(41) 98888-8889', 'fernanda.c@ecomm.com.br', 'senha123', true),
                                                                                                                                                             (nextval('sq_usuario'), 'Lucas', 'Rocha', 'lucasrocha-ecb', 8, false, 8, 17, '888.888.888-90', '(41) 98888-8890', 'lucas.r@ecomm.com.br', 'senha123', true),
                                                                                                                                                             (nextval('sq_usuario'), 'Carolina', 'Gomes', 'carolinagomes-ses', 9, false, 9, 18, '999.999.999-00', '(11) 99999-9900', 'carolina.g@saudesolucoes.com.br', 'senha123', true),
                                                                                                                                                             (nextval('sq_usuario'), 'Pedro', 'Henrique', 'pedrohenrique-ses', 9, false, 9, 19, '999.999.999-01', '(11) 99999-9901', 'pedro.h@saudesolucoes.com.br', 'senha123', true),
                                                                                                                                                             (nextval('sq_usuario'), 'Camila', 'Viana', 'camilaviana-jbs', 10, false, 10, 20, '100.100.100-01', '(51) 91000-1001', 'camila.v@jbsgado.com.br', 'senha123', true),
                                                                                                                                                             (nextval('sq_usuario'), 'Vinicius', 'Souza', 'viniciussouza-jbs', 10, false, 10, 21, '100.100.100-02', '(51) 91000-1002', 'vinicius.s@jbsgado.com.br', 'senha123', true);


-- Inserindo dados na tabela HabilidadeUsuario
INSERT INTO HabilidadeUsuario (nCdHabilidade, nCdUsuario) VALUES
                                                              (1, 1), (2, 1), (3, 1), -- Carlos (Tech Solutions)
                                                              (4, 2), (5, 2), -- Ana (Marketing)
                                                              (6, 3), (7, 3), -- Pedro (Consultoria Fin)
                                                              (8, 4), (9, 4), -- Mariana (Logistica)
                                                              (10, 5), (11, 5), -- Ricardo F (InovaTech)
                                                              (12, 6), (13, 6), -- Juliana (Design)
                                                              (14, 7), (15, 7), -- André (Manufatura)
                                                              (16, 8), (17, 8), -- Daniel M (E-commerce)
                                                              (18, 9), (19, 9), -- Bruna (Saúde)
                                                              (20, 10), (21, 10), -- Gustavo (Fábrica de Gado JBS)
-- Usuários da Tech Solutions
                                                              (1, 11), (2, 11),
                                                              (2, 12), (22, 12),
                                                              (3, 13), (23, 13),
-- Usuários da Marketing Digital
                                                              (4, 14), (5, 14),
                                                              (5, 15),
-- Usuários da Consultoria Financeira
                                                              (6, 16),
                                                              (7, 17),
-- Usuários da Logística Rápida
                                                              (8, 18),
                                                              (9, 19),
-- Usuários da Inovação e Tecnologia
                                                              (10, 20), (11, 20),
                                                              (11, 21),
-- Usuários da Serviços de Design
                                                              (12, 22), (13, 22),
                                                              (13, 23),
-- Usuários da Indústria de Manufatura
                                                              (14, 24),
                                                              (15, 25),
-- Usuários da E-commerce Brasil
                                                              (16, 26),
                                                              (17, 27),
-- Usuários da Soluções em Saúde
                                                              (18, 28),
                                                              (19, 29),
-- Usuários da Fábrica de Gado JBS
                                                              (20, 30),
                                                              (21, 31);

-- Inserindo dados na tabela Tarefa
-- O usuário relator (gestor) e o status (Pendente ou Em Andamento) são corrigidos aqui
-- Usando nextval para a sequência de IDs
INSERT INTO Tarefa (nCdTarefa, cNmTarefa, nCdUsuarioRelator, nCdHabilidade, iGravidade, iUrgencia, iTendencia, nTempoEstimado, cDescricao, cStatus) VALUES
                                                                                                                                                        (nextval('sq_tarefa'), 'Desenvolver API de Autenticação', 1, 1, 5, 4, 5, 80.0, 'Criar uma API REST para o sistema de autenticação.', 'Em Andamento'),
                                                                                                                                                        (nextval('sq_tarefa'), 'Otimizar Query de Relatórios', 1, 2, 4, 5, 4, 25.5, 'Revisar e otimizar a consulta para o dashboard principal.', 'Pendente'),
                                                                                                                                                        (nextval('sq_tarefa'), 'Planejar Sprint 3', 1, 3, 3, 3, 4, 15.0, 'Definir as tarefas e estimativas para a próxima sprint.', 'Concluída'),
                                                                                                                                                        (nextval('sq_tarefa'), 'Campanha de E-mail de Natal', 2, 4, 5, 4, 5, 40.0, 'Criar e executar campanha de e-mail marketing para o final do ano.', 'Pendente'),
                                                                                                                                                        (nextval('sq_tarefa'), 'Revisão de Código do Módulo Financeiro', 1, 1, 5, 2, 4, 10.0, 'Revisar o código do módulo financeiro em busca de bugs.', 'Em Andamento'),
                                                                                                                                                        (nextval('sq_tarefa'), 'Auditoria Interna de Receitas', 3, 7, 4, 4, 4, 50.0, 'Conduzir uma auditoria completa das receitas do último trimestre.', 'Em Andamento'),
                                                                                                                                                        (nextval('sq_tarefa'), 'Organizar Fluxo de Armazém', 4, 9, 3, 3, 5, 30.0, 'Reorganizar o layout do armazém para otimizar o fluxo de trabalho.', 'Concluída'),
                                                                                                                                                        (nextval('sq_tarefa'), 'Proposta de Imposto Simplificado', 3, 7, 2, 3, 2, 20.0, 'Elaborar uma proposta para adesão ao Simples Nacional.', 'Cancelada'),
                                                                                                                                                        (nextval('sq_tarefa'), 'Treinamento de Equipe em Marketing de Conteúdo', 2, 5, 3, 2, 4, 12.0, 'Criar e ministrar um treinamento sobre novas técnicas de criação de conteúdo.', 'Pendente'),
                                                                                                                                                        (nextval('sq_tarefa'), 'Configurar Servidores AWS', 1, 23, 5, 5, 5, 20.0, 'Subir novos servidores e configurar ambientes na AWS.', 'Em Andamento'),
                                                                                                                                                        (nextval('sq_tarefa'), 'Desenvolvimento de Módulo de Pedidos', 5, 10, 4, 3, 5, 45.0, 'Programar o módulo de pedidos para o novo sistema.', 'Pendente'),
                                                                                                                                                        (nextval('sq_tarefa'), 'Análise de Tráfego do Site', 5, 11, 3, 4, 4, 15.0, 'Analisar o tráfego do site e identificar vulnerabilidades.', 'Em Andamento'),
                                                                                                                                                        (nextval('sq_tarefa'), 'Criação de Logo para Campanha', 6, 12, 5, 4, 5, 10.0, 'Desenhar um novo logo para a campanha de lançamento.', 'Pendente'),
                                                                                                                                                        (nextval('sq_tarefa'), 'Teste de Usabilidade do App', 6, 13, 4, 3, 4, 20.0, 'Realizar testes com usuários para validar a usabilidade do aplicativo.', 'Concluída'),
                                                                                                                                                        (nextval('sq_tarefa'), 'Revisão de Processo de Produção', 7, 14, 3, 5, 4, 35.0, 'Auditar o processo de produção para garantir a qualidade.', 'Em Andamento'),
                                                                                                                                                        (nextval('sq_tarefa'), 'Inventário da Cadeia de Suprimentos', 7, 15, 4, 4, 3, 25.0, 'Contar e registrar todos os produtos no estoque.', 'Pendente'),
                                                                                                                                                        (nextval('sq_tarefa'), 'Otimização de SEO para Produtos', 8, 16, 5, 2, 5, 18.0, 'Melhorar as descrições dos produtos para otimização de busca.', 'Concluída'),
                                                                                                                                                        (nextval('sq_tarefa'), 'Fluxo de Devoluções', 8, 17, 3, 3, 4, 12.0, 'Criar um processo de devolução mais eficiente.', 'Pendente'),
                                                                                                                                                        (nextval('sq_tarefa'), 'Treinamento de Atendimento ao Cliente', 9, 18, 2, 1, 3, 8.0, 'Ministrar treinamento para a nova equipe de suporte.', 'Concluída'),
                                                                                                                                                        (nextval('sq_tarefa'), 'Digitalizar prontuários médicos', 9, 19, 4, 4, 5, 50.0, 'Converter prontuários físicos para o formato digital.', 'Em Andamento'),
                                                                                                                                                        (nextval('sq_tarefa'), 'Plano de plantio para o próximo semestre', 10, 20, 5, 5, 5, 60.0, 'Desenvolver o plano de plantio com base em previsões climáticas.', 'Em Andamento'),
                                                                                                                                                        (nextval('sq_tarefa'), 'Criação de Pastagem para Gado', 10, 21, 3, 2, 4, 25.0, 'Preparar nova área para pastagem do rebanho.', 'Pendente'),
                                                                                                                                                        (nextval('sq_tarefa'), 'Desenvolver front-end do dashboard', 1, 1, 5, 4, 5, 70.0, 'Implementar a interface do usuário para o dashboard principal.', 'Em Andamento'),
                                                                                                                                                        (nextval('sq_tarefa'), 'Criar relatório de performance de marketing', 2, 4, 4, 5, 4, 30.0, 'Gerar relatório mensal de performance das campanhas.', 'Pendente'),
                                                                                                                                                        (nextval('sq_tarefa'), 'Revisar balanço trimestral', 3, 6, 5, 5, 4, 45.0, 'Conferir e validar o balanço patrimonial.', 'Em Andamento'),
                                                                                                                                                        (nextval('sq_tarefa'), 'Otimização de rotas de entrega', 4, 8, 4, 5, 5, 20.0, 'Calcular e aplicar novas rotas para a frota.', 'Pendente'),
                                                                                                                                                        (nextval('sq_tarefa'), 'Atualização de código', 5, 10, 3, 2, 3, 15.0, 'Aplicar patches e atualizações de segurança.', 'Concluída'),
                                                                                                                                                        (nextval('sq_tarefa'), 'Analise de mercado', 8, 16, 3, 3, 2, 16.0, 'Realizar pesquisa e análise da concorrência.', 'Pendente'),
                                                                                                                                                        (nextval('sq_tarefa'), 'Plano de expansão de mercado', 2, 4, 5, 4, 5, 30.0, 'Definir plano de expansão de mercado para o próximo ano.', 'Em Andamento');


-- Inserindo dados na tabela LogAtribuicaoTarefa
-- Os nCdUsuarioAtuante correspondem aos colaboradores que receberam a tarefa
INSERT INTO LogAtribuicaoTarefa (nCdTarefa, nCdUsuarioAtuante, dRealocacao) VALUES
                                                                                (1, 11, '2025-08-20'),
                                                                                (5, 11, '2025-08-22'),
                                                                                (6, 17, '2025-08-19'),
                                                                                (10, 13, '2025-08-23'),
                                                                                (12, 21, '2025-08-24'),
                                                                                (15, 24, '2025-08-20'),
                                                                                (20, 29, '2025-08-25'),
                                                                                (21, 30, '2025-08-20'),
                                                                                (23, 11, '2025-08-26'),
                                                                                (25, 16, '2025-08-28'),
                                                                                (29, 14, '2025-09-01');


-- Inserindo dados na tabela Report
-- Os nCdUsuarioAtuante correspondem aos colaboradores que receberam a tarefa
INSERT INTO Report (nCdReport, nCdTarefa, cDescricao, cProblema) VALUES
                                                                     (nextval('sq_report'), 1, 'A autenticação por token está com falhas intermitentes.', 'Falha de token'),
                                                                     (nextval('sq_report'), 2, 'A query está retornando dados inconsistentes com o dashboard.', 'Inconsistência de dados'),
                                                                     (nextval('sq_report'), 3, 'Foram encontradas discrepâncias na apuração de impostos.', 'Discrepância fiscal'),
                                                                     (nextval('sq_report'), 4, 'O módulo de pedidos está com erro ao conectar com o banco de dados.', 'Erro de conexão'),
                                                                     (nextval('sq_report'), 5, 'O novo processo de produção está resultando em mais produtos com defeito.', 'Aumento de defeitos'),
                                                                     (nextval('sq_report'), 6, 'Alguns prontuários digitalizados estão ilegíveis.', 'Qualidade da imagem');

-- Inserindo dados na tabela TarefaHabilidade
-- Prioridade única por habilidade na mesma tarefa (de 1 a N)
INSERT INTO TarefaHabilidade (nCdHabilidade, nCdTarefa, iPrioridade) VALUES
                                                                         (1, 1, 1),
                                                                         (2, 1, 2),
                                                                         (22, 1, 3),
                                                                         (2, 2, 1),
                                                                         (3, 3, 1),
                                                                         (4, 4, 1),
                                                                         (5, 4, 2),
                                                                         (1, 5, 1),
                                                                         (7, 6, 1),
                                                                         (6, 6, 2),
                                                                         (9, 7, 1),
                                                                         (8, 7, 2),
                                                                         (7, 8, 1),
                                                                         (6, 8, 2),
                                                                         (5, 9, 1),
                                                                         (4, 9, 2),
                                                                         (23, 10, 1),
                                                                         (10, 11, 1),
                                                                         (11, 12, 1),
                                                                         (12, 13, 1),
                                                                         (13, 13, 2),
                                                                         (13, 14, 1),
                                                                         (12, 14, 2),
                                                                         (14, 15, 1),
                                                                         (15, 16, 1),
                                                                         (16, 17, 1),
                                                                         (17, 18, 1),
                                                                         (18, 19, 1),
                                                                         (19, 20, 1),
                                                                         (20, 21, 1),
                                                                         (21, 22, 1),
                                                                         (1, 23, 1),
                                                                         (22, 23, 2),
                                                                         (4, 24, 1),
                                                                         (5, 24, 2),
                                                                         (6, 25, 1),
                                                                         (7, 25, 2),
                                                                         (8, 26, 1),
                                                                         (9, 26, 2),
                                                                         (10, 27, 1),
                                                                         (11, 27, 2),
                                                                         (16, 28, 1),
                                                                         (17, 28, 2),
                                                                         (4, 29, 1),
                                                                         (5, 29, 2);


-- Inserindo dados na tabela TarefaUsuario
-- Apenas tarefas com status 'Em Andamento' têm registros aqui
INSERT INTO TarefaUsuario (nCdTarefa, nCdUsuarioOriginal, nCdUsuarioAtuante) VALUES
                                                                                 (1, 1, 11),
                                                                                 (5, 1, 11),
                                                                                 (6, 3, 17),
                                                                                 (10, 1, 13),
                                                                                 (12, 5, 21),
                                                                                 (15, 7, 24),
                                                                                 (20, 9, 29),
                                                                                 (21, 10, 30),
                                                                                 (23, 1, 11),
                                                                                 (25, 3, 16),
                                                                                 (29, 2, 14);