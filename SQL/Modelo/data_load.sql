-- Limpa todas as tabelas e reinicia as sequências para garantir uma carga de dados limpa (CORRIGIDO)
TRUNCATE TABLE public.PlanoPagamento, public.Mensagem, public.Empresa, public.PlanoVantagem, public.Habilidade, public.Setor, public.Usuario, public.HabilidadeUsuario, public.Tarefa, table_log.LogAtribuicaoTarefa, public.Report, public.TarefaHabilidade, public.TarefaUsuario RESTART IDENTITY CASCADE;
ALTER SEQUENCE public.sq_PlanoPagamento         RESTART WITH 1;
ALTER SEQUENCE public.sq_Empresa                RESTART WITH 1;
ALTER SEQUENCE public.sq_Mensagem               RESTART WITH 1;
ALTER SEQUENCE public.sq_PlanoVantagem          RESTART WITH 1;
ALTER SEQUENCE public.sq_Report                 RESTART WITH 1;
ALTER SEQUENCE public.sq_Setor                  RESTART WITH 1;
ALTER SEQUENCE public.sq_Tarefa                 RESTART WITH 1;
ALTER SEQUENCE public.sq_Usuario                RESTART WITH 1;
ALTER SEQUENCE public.sq_Habilidade             RESTART WITH 1;
ALTER SEQUENCE public.sq_HabilidadeUsuario      RESTART WITH 1;
ALTER SEQUENCE public.sq_TarefaHabilidade       RESTART WITH 1;
ALTER SEQUENCE public.sq_TarefaUsuario          RESTART WITH 1;

-- Inserindo dados na tabela PlanoPagamento
INSERT INTO public.PlanoPagamento (nCdPlano, cNmPlano, nPreco) VALUES
                                                                   (nextval('public.sq_PlanoPagamento'), 'Básico', 50.00),
                                                                   (nextval('public.sq_PlanoPagamento'), 'Intermediário', 150.00),
                                                                   (nextval('public.sq_PlanoPagamento'), 'Profissional', 450.00),
                                                                   (nextval('public.sq_PlanoPagamento'), 'Empresarial', 1000.00),
                                                                   (nextval('public.sq_PlanoPagamento'), 'Corporativo', 2500.00);

-- Inserindo dados na tabela Mensagem
INSERT INTO public.Mensagem (nCdMensagem, cTitulo, cMensagem, cCategoria) VALUES
                                                                              (nextval('public.sq_Mensagem'), 'Bem-vindo(a)!', 'Sua conta foi criada com sucesso! Explore todas as funcionalidades.', 'Boas-vindas'),
                                                                              (nextval('public.sq_Mensagem'), 'Tarefa Concluída', 'A Tarefa "Melhoria da Interface do Usuário" foi finalizada.', 'Notificação'),
                                                                              (nextval('public.sq_Mensagem'), 'Nova Atribuição', 'Você foi atribuído a uma nova Tarefa. Verifique seus projetos.', 'Atribuição'),
                                                                              (nextval('public.sq_Mensagem'), 'Alerta de Prazo', 'O prazo para a Tarefa "Relatório de Vendas Q3" está se esgotando!', 'Urgência'),
                                                                              (nextval('public.sq_Mensagem'), 'Atualização de Sistema', 'O sistema Kronos foi atualizado com novos recursos. Confira as novidades.', 'Informativo'),
                                                                              (nextval('public.sq_Mensagem'), 'Novo Setor', 'Um novo Setor foi adicionado na sua Empresa.', 'Informativo'),
                                                                              (nextval('public.sq_Mensagem'), 'Habilidade Adicionada', 'Uma nova Habilidade foi adicionada ao sistema.', 'Informativo'),
                                                                              (nextval('public.sq_Mensagem'), 'Report Criado', 'Um novo Report foi criado para a Tarefa "Revisão de Código".', 'Notificação'),
                                                                              (nextval('public.sq_Mensagem'), 'Reunião Agendada', 'Foi agendada uma reunião com a equipe de projetos.', 'Reunião'),
                                                                              (nextval('public.sq_Mensagem'), 'Feedback Recebido', 'Você recebeu um feedback sobre seu trabalho.', 'Feedback');

-- Inserindo dados na tabela Empresa
INSERT INTO public.Empresa (nCdEmpresa, cNmEmpresa, cSgEmpresa, cCNPJ, cTelefone, cEmail, cCEP, nCdPlanoPagamento, bAtivo) VALUES
                                                                                                                               (nextval('public.sq_Empresa'), 'Tech Solutions Ltda.', 'TSL', '11.111.111/0001-11', '(11) 98765-4321', 'contato@techsolutions.com.br', '01000-001', 4, true),
                                                                                                                               (nextval('public.sq_Empresa'), 'Marketing Digital S.A.', 'MDS', '22.222.222/0001-22', '(21) 98765-4322', 'contato@mktglobal.com.br', '20000-002', 3, true),
                                                                                                                               (nextval('public.sq_Empresa'), 'Consultoria Financeira', 'CFI', '33.333.333/0001-33', '(31) 98765-4323', 'contato@consultfin.com.br', '30000-003', 5, true),
                                                                                                                               (nextval('public.sq_Empresa'), 'Logística Rápida', 'LGR', '44.444.444/0001-44', '(41) 98765-4324', 'contato@logistica.com.br', '80000-004', 2, true),
                                                                                                                               (nextval('public.sq_Empresa'), 'Inovação e Tecnologia', 'IET', '55.555.555/0001-55', '(11) 95555-5555', 'contato@inovatech.com.br', '04000-005', 4, true),
                                                                                                                               (nextval('public.sq_Empresa'), 'Serviços de Design', 'SDD', '66.666.666/0001-66', '(21) 96666-6666', 'contato@artdesign.com.br', '22000-006', 3, true),
                                                                                                                               (nextval('public.sq_Empresa'), 'Indústria de Manufatura', 'IDM', '77.777.777/0001-77', '(31) 97777-7777', 'contato@manufatura.com.br', '33000-007', 5, true),
                                                                                                                               (nextval('public.sq_Empresa'), 'E-commerce Brasil', 'ECB', '88.888.888/0001-88', '(41) 98888-8888', 'contato@ecomm.com.br', '81000-008', 2, true),
                                                                                                                               (nextval('public.sq_Empresa'), 'Soluções em Saúde', 'SES', '99.999.999/0001-99', '(11) 99999-9999', 'contato@saudesolucoes.com.br', '01500-009', 4, true),
                                                                                                                               (nextval('public.sq_Empresa'), 'Fábrica de Gado JBS', 'JBS', '10.101.101/0001-10', '(51) 91010-1010', 'contato@jbsgado.com.br', '90000-010', 2, true);

-- Inserindo dados na tabela PlanoVantagem
INSERT INTO public.PlanoVantagem (nCdPlano, cNmVantagem, cDescricao) VALUES
                                                                          (1, 'Gestão de 10 Usuários', 'Permite a gestão de até 10 usuários por Empresa.'),
                                                                          (1, 'Criação de 20 Tarefas', 'Limite de 20 Tarefas em andamento.'),
                                                                          (2, 'Análise de Desempenho', 'Acesso a relatórios básicos de produtividade.'),
                                                                          (2, 'Suporte Prioritário', 'Atendimento prioritário via chat e e-mail.'),
                                                                          (3, 'Relatórios Avançados', 'Relatórios detalhados com dashboards interativos.'),
                                                                          (3, 'Integrações Externas', 'Possibilidade de integrar com outras plataformas.'),
                                                                          (4, 'Gestão de 500 Usuários', 'Capacidade para gerenciar até 500 usuários.'),
                                                                          (4, 'Tarefas Ilimitadas', 'Sem limite para a quantidade de Tarefas.'),
                                                                          (5, 'Suporte Dedicado 24/7', 'Atendimento personalizado com um gerente de contas.'),
                                                                          (5, 'Personalização Completa', 'Customização da interface e funcionalidades.'),
                                                                          (5, 'Análise Preditiva', 'Ferramentas de análise de tendência e previsão.');

-- Inserindo dados na tabela Habilidade
INSERT INTO public.Habilidade (nCdHabilidade, nCdEmpresa, cNmHabilidade, cDescricao) VALUES
                                                                                         (nextval('public.sq_Habilidade'), 1, 'Desenvolvimento Java', 'Conhecimento em Java, Spring Boot e microserviços.'),
                                                                                         (nextval('public.sq_Habilidade'), 1, 'Análise de Dados SQL', 'Habilidade em escrever queries complexas, otimização de consultas e modelagem de dados.'),
                                                                                         (nextval('public.sq_Habilidade'), 1, 'Gestão de Projetos Ágeis', 'Experiência em Scrum, Kanban e liderança de equipe.'),
                                                                                         (nextval('public.sq_Habilidade'), 2, 'Marketing Digital', 'Estratégias de SEO, SEM e mídias sociais.'),
                                                                                         (nextval('public.sq_Habilidade'), 2, 'Criação de Conteúdo', 'Produção de textos e materiais visuais para campanhas.'),
                                                                                         (nextval('public.sq_Habilidade'), 3, 'Contabilidade', 'Conhecimento em balanço patrimonial e demonstrações financeiras.'),
                                                                                         (nextval('public.sq_Habilidade'), 3, 'Planejamento Tributário', 'Otimização de impostos e consultoria fiscal.'),
                                                                                         (nextval('public.sq_Habilidade'), 4, 'Otimização de Rota', 'Definir as melhores rotas de entrega e distribuição.'),
                                                                                         (nextval('public.sq_Habilidade'), 4, 'Gestão de Estoque', 'Controle e organização de produtos em armazéns.'),
                                                                                         (nextval('public.sq_Habilidade'), 5, 'Desenvolvimento Python', 'Conhecimento em Python, Django e data science.'),
                                                                                         (nextval('public.sq_Habilidade'), 5, 'Segurança da Informação', 'Análise de vulnerabilidades e proteção de dados.'),
                                                                                         (nextval('public.sq_Habilidade'), 6, 'Design Gráfico', 'Criação de identidade visual, logotipos e peças gráficas.'),
                                                                                         (nextval('public.sq_Habilidade'), 6, 'Experiência do Usuário (UX)', 'Pesquisa e design para otimizar a experiência do usuário.'),
                                                                                         (nextval('public.sq_Habilidade'), 7, 'Controle de Qualidade', 'Testes e inspeção de produtos na linha de produção.'),
                                                                                         (nextval('public.sq_Habilidade'), 7, 'Gestão da Cadeia de Suprimentos', 'Planejamento e coordenação de fluxo de produtos e informações.'),
                                                                                         (nextval('public.sq_Habilidade'), 8, 'E-commerce', 'Operação de plataformas de e-commerce e gestão de vendas online.'),
                                                                                         (nextval('public.sq_Habilidade'), 8, 'Logística Reversa', 'Processos de devolução e tratamento de produtos.'),
                                                                                         (nextval('public.sq_Habilidade'), 9, 'Atendimento ao Cliente', 'Suporte e relacionamento com clientes.'),
                                                                                         (nextval('public.sq_Habilidade'), 9, 'Análise de Saúde', 'Análise de dados de saúde e registros de pacientes.'),
                                                                                         (nextval('public.sq_Habilidade'), 10, 'Gestão Agrícola', 'Planejamento e controle de plantio e colheita.'),
                                                                                         (nextval('public.sq_Habilidade'), 10, 'Manejo de Gado', 'Conhecimento em criação e manejo de animais.'),
                                                                                         (nextval('public.sq_Habilidade'), 1, 'DevOps', 'Práticas de integração e entrega contínua.'),
                                                                                         (nextval('public.sq_Habilidade'), 1, 'Cloud Computing (AWS)', 'Conhecimento em serviços de nuvem da AWS.');

-- Inserindo dados na tabela Setor
INSERT INTO public.Setor (nCdSetor, nCdEmpresa, cNmSetor, cSgSetor) VALUES
                                                                        (nextval('public.sq_Setor'), 1, 'TI - Desenvolvimento', 'TDE'),
                                                                        (nextval('public.sq_Setor'), 1, 'TI - Infraestrutura', 'TIN'),
                                                                        (nextval('public.sq_Setor'), 1, 'Recursos Humanos', 'RHU'),
                                                                        (nextval('public.sq_Setor'), 2, 'Marketing', 'MKT'),
                                                                        (nextval('public.sq_Setor'), 2, 'Comercial', 'COM'),
                                                                        (nextval('public.sq_Setor'), 3, 'Contabilidade', 'CTB'),
                                                                        (nextval('public.sq_Setor'), 3, 'Auditoria', 'AUD'),
                                                                        (nextval('public.sq_Setor'), 4, 'Logística', 'LOG'),
                                                                        (nextval('public.sq_Setor'), 4, 'Armazenamento', 'ARM'),
                                                                        (nextval('public.sq_Setor'), 5, 'Engenharia de Software', 'EDS'),
                                                                        (nextval('public.sq_Setor'), 5, 'Data Science', 'DSC'),
                                                                        (nextval('public.sq_Setor'), 6, 'Design de Produto', 'DDP'),
                                                                        (nextval('public.sq_Setor'), 6, 'UI/UX', 'UIX'),
                                                                        (nextval('public.sq_Setor'), 7, 'Produção', 'PRO'),
                                                                        (nextval('public.sq_Setor'), 7, 'Manutenção', 'MAN'),
                                                                        (nextval('public.sq_Setor'), 8, 'Vendas Online', 'VON'),
                                                                        (nextval('public.sq_Setor'), 8, 'Logística de E-commerce', 'LEC'),
                                                                        (nextval('public.sq_Setor'), 9, 'Atendimento', 'ATD'),
                                                                        (nextval('public.sq_Setor'), 9, 'TI - Saúde', 'TIS'),
                                                                        (nextval('public.sq_Setor'), 10, 'Produção Agrícola', 'PAG'),
                                                                        (nextval('public.sq_Setor'), 10, 'Pecuária', 'PEC');

-- Inserindo dados na tabela Usuario
-- Gestores (IDs 1 a 10)
INSERT INTO public.Usuario (nCdUsuario, cNmUsuario, nCdGestor, bGestor, nCdEmpresa, nCdSetor, nCdCargo, cCPF, cTelefone, cEmail, cSenha, bAtivo) VALUES
                                                                                                                                                    (nextval('public.sq_Usuario'), 'Carlos Silva', NULL, true, 1, 1, 101, '111.111.111-11', '(11) 99111-1111', 'carlos.silva@techsolutions.com.br', 'senha123', true), -- Cargo: Diretor de Tecnologia da Informação
                                                                                                                                                    (nextval('public.sq_Usuario'), 'Ana Costa', NULL, true, 2, 4, 102, '222.222.222-22', '(21) 99222-2222', 'ana.costa@mktglobal.com.br', 'senha123', true), -- Cargo: Diretora de Marketing
                                                                                                                                                    (nextval('public.sq_Usuario'), 'Pedro Santos', NULL, true, 3, 6, 103, '333.333.333-33', '(31) 99333-3333', 'pedro.santos@consultfin.com.br', 'senha123', true), -- Cargo: Diretor Financeiro
                                                                                                                                                    (nextval('public.sq_Usuario'), 'Mariana Oliveira', NULL, true, 4, 8, 104, '444.444.444-44', '(41) 99444-4444', 'mariana.o@logistica.com.br', 'senha123', true), -- Cargo: Gerente de Logística
                                                                                                                                                    (nextval('public.sq_Usuario'), 'Ricardo Fernandes', NULL, true, 5, 10, 105, '555.555.555-55', '(11) 95555-5555', 'ricardo.f@inovatech.com.br', 'senha123', true), -- Cargo: Diretor de Pesquisa e Desenvolvimento (P&D)
                                                                                                                                                    (nextval('public.sq_Usuario'), 'Juliana Castro', NULL, true, 6, 12, 106, '666.666.666-66', '(21) 96666-6666', 'juliana.c@artdesign.com.br', 'senha123', true), -- Cargo: Diretora de Criação
                                                                                                                                                    (nextval('public.sq_Usuario'), 'André Guedes', NULL, true, 7, 14, 107, '777.777.777-77', '(31) 97777-7777', 'andre.g@manufatura.com.br', 'senha123', true), -- Cargo: Gerente de Produção e Operações
                                                                                                                                                    (nextval('public.sq_Usuario'), 'Daniel Martins', NULL, true, 8, 16, 108, '888.888.888-88', '(41) 98888-8888', 'daniel.m@ecomm.com.br', 'senha123', true), -- Cargo: Gerente de E-commerce
                                                                                                                                                    (nextval('public.sq_Usuario'), 'Bruna Lopes', NULL, true, 9, 18, 109, '999.999.999-99', '(11) 99999-9999', 'bruna.l@saudesolucoes.com.br', 'senha123', true), -- Cargo: Diretora de Serviços de Saúde
                                                                                                                                                    (nextval('public.sq_Usuario'), 'Gustavo Almeida', NULL, true, 10, 20, 110, '100.100.100-00', '(51) 91000-1000', 'gustavo.a@agrosul.com.br', 'senha123', true); -- Cargo: Diretor de Produção Agropecuária

-- Usuários Regulares (IDs 11 a 31)
INSERT INTO public.Usuario (nCdUsuario, cNmUsuario, nCdGestor, bGestor, nCdEmpresa, nCdSetor, nCdCargo, cCPF, cTelefone, cEmail, cSenha, bAtivo) VALUES
                                                                                                                                                    (nextval('public.sq_Usuario'), 'João Souza', 1, false, 1, 1, 201, '111.111.111-12', '(11) 99111-1112', 'joao.souza@techsolutions.com.br', 'senha123', true), -- Cargo: Analista de Desenvolvimento de Sistemas
                                                                                                                                                    (nextval('public.sq_Usuario'), 'Beatriz Lima', 1, false, 1, 2, 202, '111.111.111-13', '(11) 99111-1113', 'beatriz.l@techsolutions.com.br', 'senha123', true), -- Cargo: Administradora de Redes
                                                                                                                                                    (nextval('public.sq_Usuario'), 'Felipe Mendes', 1, false, 1, 3, 203, '111.111.111-14', '(11) 99111-1114', 'felipe.m@techsolutions.com.br', 'senha123', true), -- Cargo: Analista de Suporte Computacional
                                                                                                                                                    (nextval('public.sq_Usuario'), 'Julia Pereira', 2, false, 2, 4, 204, '222.222.222-23', '(21) 99222-2223', 'julia.p@mktglobal.com.br', 'senha123', true), -- Cargo: Analista de Marketing
                                                                                                                                                    (nextval('public.sq_Usuario'), 'Ricardo Neves', 2, false, 2, 5, 205, '222.222.222-24', '(21) 99222-2224', 'ricardo.n@mktglobal.com.br', 'senha123', true), -- Cargo: Assistente de Vendas
                                                                                                                                                    (nextval('public.sq_Usuario'), 'Laura Rocha', 3, false, 3, 6, 206, '333.333.333-34', '(31) 99333-3334', 'laura.r@consultfin.com.br', 'senha123', true), -- Cargo: Analista Financeiro
                                                                                                                                                    (nextval('public.sq_Usuario'), 'Guilherme Castro', 3, false, 3, 7, 207, '333.333.333-35', '(31) 99333-3335', 'gui.castro@consultfin.com.br', 'senha123', true), -- Cargo: Contador
                                                                                                                                                    (nextval('public.sq_Usuario'), 'Isabela Santos', 4, false, 4, 8, 208, '444.444.444-45', '(41) 99444-4445', 'isabela.s@logistica.com.br', 'senha123', true), -- Cargo: Analista de Logística
                                                                                                                                                    (nextval('public.sq_Usuario'), 'Daniel Gomes', 4, false, 4, 9, 209, '444.444.444-46', '(41) 99444-4446', 'daniel.g@logistica.com.br', 'senha123', true), -- Cargo: Almoxarife
                                                                                                                                                    (nextval('public.sq_Usuario'), 'Luiza Ramos', 5, false, 5, 10, 210, '555.555.555-56', '(11) 95555-5556', 'luiza.r@inovatech.com.br', 'senha123', true), -- Cargo: Pesquisadora de Engenharia e Tecnologia
                                                                                                                                                    (nextval('public.sq_Usuario'), 'Marcos Souza', 5, false, 5, 11, 211, '555.555.555-57', '(11) 95555-5557', 'marcos.s@inovatech.com.br', 'senha123', true), -- Cargo: Inspetor de Qualidade
                                                                                                                                                    (nextval('public.sq_Usuario'), 'Sofia Lima', 6, false, 6, 12, 212, '666.666.666-67', '(21) 96666-6667', 'sofia.l@artdesign.com.br', 'senha123', true), -- Cargo: Designer Gráfico
                                                                                                                                                    (nextval('public.sq_Usuario'), 'Paulo Ferreira', 6, false, 6, 13, 213, '666.666.666-68', '(21) 96666-6668', 'paulo.f@artdesign.com.br', 'senha123', true), -- Cargo: Analista de Mídias Sociais
                                                                                                                                                    (nextval('public.sq_Usuario'), 'Helena Alves', 7, false, 7, 14, 214, '777.777.777-78', '(31) 97777-7778', 'helena.a@manufatura.com.br', 'senha123', true), -- Cargo: Alimentador de Linha de Produção
                                                                                                                                                    (nextval('public.sq_Usuario'), 'José Moura', 7, false, 7, 15, 215, '777.777.777-79', '(31) 97777-7779', 'jose.m@manufatura.com.br', 'senha123', true), -- Cargo: Mecânico de Manutenção de Máquinas
                                                                                                                                                    (nextval('public.sq_Usuario'), 'Fernanda Costa', 8, false, 8, 16, 216, '888.888.888-89', '(41) 98888-8889', 'fernanda.c@ecomm.com.br', 'senha123', true), -- Cargo: Analista de E-commerce
                                                                                                                                                    (nextval('public.sq_Usuario'), 'Lucas Rocha', 8, false, 8, 17, 217, '888.888.888-90', '(41) 98888-8890', 'lucas.r@ecomm.com.br', 'senha123', true), -- Cargo: Operador de Telemarketing
                                                                                                                                                    (nextval('public.sq_Usuario'), 'Carolina Gomes', 9, false, 9, 18, 218, '999.999.999-00', '(11) 99999-9900', 'carolina.g@saudesolucoes.com.br', 'senha123', true), -- Cargo: Enfermeira
                                                                                                                                                    (nextval('public.sq_Usuario'), 'Pedro Henrique', 9, false, 9, 19, 219, '999.999.999-01', '(11) 99999-9901', 'pedro.h@saudesolucoes.com.br', 'senha123', true), -- Cargo: Recepcionista de Consultório Médico
                                                                                                                                                    (nextval('public.sq_Usuario'), 'Camila Viana', 10, false, 10, 20, 220, '100.100.100-01', '(51) 91000-1001', 'camila.v@jbsgado.com.br', 'senha123', true), -- Cargo: Trabalhadora da Pecuária (Bovinos)
                                                                                                                                                    (nextval('public.sq_Usuario'), 'Vinicius Souza', 10, false, 10, 21, 221, '100.100.100-02', '(51) 91000-1002', 'vinicius.s@jbsgado.com.br', 'senha123', true); -- Cargo: Comprador
-- Inserindo dados na tabela HabilidadeUsuario
INSERT INTO public.HabilidadeUsuario (nCdHabilidade, nCdUsuario) VALUES
                                                                     (1, 1), (2, 1), (3, 1), -- Carlos (Gestor)
                                                                     (4, 2), (5, 2), -- Ana (Gestor)
                                                                     (6, 3), (7, 3), -- Pedro (Gestor)
                                                                     (8, 4), (9, 4), -- Mariana (Gestor)
                                                                     (10, 5), (11, 5), -- Ricardo F (Gestor)
                                                                     (12, 6), (13, 6), -- Juliana (Gestor)
                                                                     (14, 7), (15, 7), -- André (Gestor)
                                                                     (16, 8), (17, 8), -- Daniel M (Gestor)
                                                                     (18, 9), (19, 9), -- Bruna (Gestor)
                                                                     (20, 10), (21, 10), -- Gustavo (Gestor)
                                                                     (1, 11), (2, 11), -- João
                                                                     (2, 12), (22, 12), -- Beatriz
                                                                     (3, 13), (23, 13), -- Felipe
                                                                     (4, 14), (5, 14), -- Julia
                                                                     (5, 15), -- Ricardo N
                                                                     (6, 16), -- Laura
                                                                     (7, 17), -- Guilherme
                                                                     (8, 18), -- Isabela
                                                                     (9, 19), -- Daniel G
                                                                     (10, 20), (11, 20), -- Luiza
                                                                     (11, 21), -- Marcos
                                                                     (12, 22), (13, 22), -- Sofia
                                                                     (13, 23), -- Paulo
                                                                     (14, 24), -- Helena
                                                                     (15, 25), -- José
                                                                     (16, 26), -- Fernanda
                                                                     (17, 27), -- Lucas
                                                                     (18, 28), -- Carolina
                                                                     (19, 29), -- Pedro H
                                                                     (20, 30), -- Camila
                                                                     (21, 31); -- Vinicius

-- Inserindo dados na tabela Tarefa
INSERT INTO public.Tarefa (nCdTarefa, cNmTarefa, nCdUsuarioRelator, iGravidade, iUrgencia, iTendencia, iTempoEstimado, cDescricao, cStatus, dDataAtribuicao, dDataConclusao) VALUES
                                                                                                                                                                                 (nextval('public.sq_Tarefa'), 'Desenvolver API de Autenticação', 1, 5, 4, 5, 80, 'Criar uma API REST para o sistema de autenticação.', 'Em Andamento', '2025-08-20', NULL),
                                                                                                                                                                                 (nextval('public.sq_Tarefa'), 'Otimizar Query de Relatórios', 1, 4, 5, 4, 25, 'Revisar e otimizar a consulta para o dashboard principal.', 'Pendente', '2025-08-21', NULL),
                                                                                                                                                                                 (nextval('public.sq_Tarefa'), 'Planejar Sprint 3', 1, 3, 3, 4, 15, 'Definir as Tarefas e estimativas para a próxima sprint.', 'Concluída', '2025-08-15', '2025-08-19'),
                                                                                                                                                                                 (nextval('public.sq_Tarefa'), 'Campanha de E-mail de Natal', 2, 5, 4, 5, 40, 'Criar e executar campanha de e-mail marketing para o final do ano.', 'Pendente', '2025-08-22', NULL),
                                                                                                                                                                                 (nextval('public.sq_Tarefa'), 'Revisão de Código do Módulo Financeiro', 1, 5, 2, 4, 10, 'Revisar o código do módulo financeiro em busca de bugs.', 'Em Andamento', '2025-08-23', NULL),
                                                                                                                                                                                 (nextval('public.sq_Tarefa'), 'Auditoria Interna de Receitas', 3, 4, 4, 4, 50, 'Conduzir uma auditoria completa das receitas do último trimestre.', 'Em Andamento', '2025-08-24', NULL),
                                                                                                                                                                                 (nextval('public.sq_Tarefa'), 'Organizar Fluxo de Armazém', 4, 3, 3, 5, 30, 'Reorganizar o layout do armazém para otimizar o fluxo de trabalho.', 'Concluída', '2025-08-18', '2025-08-24'),
                                                                                                                                                                                 (nextval('public.sq_Tarefa'), 'Proposta de Imposto Simplificado', 3, 2, 3, 2, 20, 'Elaborar uma proposta para adesão ao Simples Nacional.', 'Cancelada', '2025-08-25', NULL),
                                                                                                                                                                                 (nextval('public.sq_Tarefa'), 'Treinamento de Equipe em Marketing de Conteúdo', 2, 3, 2, 4, 12, 'Criar e ministrar um treinamento sobre novas técnicas de criação de conteúdo.', 'Pendente', '2025-08-26', NULL),
                                                                                                                                                                                 (nextval('public.sq_Tarefa'), 'Configurar Servidores AWS', 1, 5, 5, 5, 20, 'Subir novos servidores e configurar ambientes na AWS.', 'Em Andamento', '2025-08-27', NULL),
                                                                                                                                                                                 (nextval('public.sq_Tarefa'), 'Desenvolvimento de Módulo de Pedidos', 5, 4, 3, 5, 45, 'Programar o módulo de pedidos para o novo sistema.', 'Pendente', '2025-08-28', NULL),
                                                                                                                                                                                 (nextval('public.sq_Tarefa'), 'Análise de Tráfego do Site', 5, 3, 4, 4, 15, 'Analisar o tráfego do site e identificar vulnerabilidades.', 'Em Andamento', '2025-08-29', NULL),
                                                                                                                                                                                 (nextval('public.sq_Tarefa'), 'Criação de Logo para Campanha', 6, 5, 4, 5, 10, 'Desenhar um novo logo para a campanha de lançamento.', 'Pendente', '2025-08-30', NULL),
                                                                                                                                                                                 (nextval('public.sq_Tarefa'), 'Teste de Usabilidade do App', 6, 4, 3, 4, 20, 'Realizar testes com usuários para validar a usabilidade do aplicativo.', 'Concluída', '2025-08-20', '2025-08-28'),
                                                                                                                                                                                 (nextval('public.sq_Tarefa'), 'Revisão de Processo de Produção', 7, 3, 5, 4, 35, 'Auditar o processo de produção para garantir a qualidade.', 'Em Andamento', '2025-08-31', NULL),
                                                                                                                                                                                 (nextval('public.sq_Tarefa'), 'Inventário da Cadeia de Suprimentos', 7, 4, 4, 3, 25, 'Contar e registrar todos os produtos no estoque.', 'Pendente', '2025-09-01', NULL),
                                                                                                                                                                                 (nextval('public.sq_Tarefa'), 'Otimização de SEO para Produtos', 8, 5, 2, 5, 18, 'Melhorar as descrições dos produtos para otimização de busca.', 'Concluída', '2025-08-15', '2025-08-20'),
                                                                                                                                                                                 (nextval('public.sq_Tarefa'), 'Fluxo de Devoluções', 8, 3, 3, 4, 12, 'Criar um processo de devolução mais eficiente.', 'Pendente', '2025-09-02', NULL),
                                                                                                                                                                                 (nextval('public.sq_Tarefa'), 'Treinamento de Atendimento ao Cliente', 9, 2, 1, 3, 8, 'Ministrar treinamento para a nova equipe de suporte.', 'Concluída', '2025-08-25', '2025-08-27'),
                                                                                                                                                                                 (nextval('public.sq_Tarefa'), 'Digitalizar prontuários médicos', 9, 4, 4, 5, 50, 'Converter prontuários físicos para o formato digital.', 'Em Andamento', '2025-09-03', NULL),
                                                                                                                                                                                 (nextval('public.sq_Tarefa'), 'Plano de plantio para o próximo semestre', 10, 5, 5, 5, 60, 'Desenvolver o plano de plantio com base em previsões climáticas.', 'Em Andamento', '2025-09-04', NULL),
                                                                                                                                                                                 (nextval('public.sq_Tarefa'), 'Criação de Pastagem para Gado', 10, 3, 2, 4, 25, 'Preparar nova área para pastagem do rebanho.', 'Pendente', '2025-09-05', NULL),
                                                                                                                                                                                 (nextval('public.sq_Tarefa'), 'Desenvolver front-end do dashboard', 1, 5, 4, 5, 70, 'Implementar a interface do usuário para o dashboard principal.', 'Em Andamento', '2025-09-06', NULL),
                                                                                                                                                                                 (nextval('public.sq_Tarefa'), 'Criar relatório de performance de marketing', 2, 4, 5, 4, 30, 'Gerar relatório mensal de performance das campanhas.', 'Pendente', '2025-09-07', NULL),
                                                                                                                                                                                 (nextval('public.sq_Tarefa'), 'Revisar balanço trimestral', 3, 5, 5, 4, 45, 'Conferir e validar o balanço patrimonial.', 'Em Andamento', '2025-09-08', NULL),
                                                                                                                                                                                 (nextval('public.sq_Tarefa'), 'Otimização de rotas de entrega', 4, 4, 5, 5, 20, 'Calcular e aplicar novas rotas para a frota.', 'Pendente', '2025-09-09', NULL),
                                                                                                                                                                                 (nextval('public.sq_Tarefa'), 'Atualização de código', 5, 3, 2, 3, 15, 'Aplicar patches e atualizações de segurança.', 'Concluída', '2025-08-29', '2025-09-01'),
                                                                                                                                                                                 (nextval('public.sq_Tarefa'), 'Analise de mercado', 8, 3, 3, 2, 16, 'Realizar pesquisa e análise da concorrência.', 'Pendente', '2025-09-10', NULL),
                                                                                                                                                                                 (nextval('public.sq_Tarefa'), 'Plano de expansão de mercado', 2, 5, 4, 5, 30, 'Definir plano de expansão de mercado para o próximo ano.', 'Em Andamento', '2025-09-11', NULL);

-- Inserindo dados na tabela LogAtribuicaoTarefa
INSERT INTO table_log.LogAtribuicaoTarefa (nCdTarefa, nCdUsuarioAtuante, dRealocacao) VALUES
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
INSERT INTO public.Report (nCdReport, nCdTarefa, cDescricao, cProblema, cStatus) VALUES
                                                                                     (nextval('public.sq_Report'), 1, 'A autenticação por token está com falhas intermitentes.', 'Falha de token', 'Concluído'),
                                                                                     (nextval('public.sq_Report'), 2, 'A query está retornando dados inconsistentes com o dashboard.', 'Inconsistência de dados', 'Pendente'),
                                                                                     (nextval('public.sq_Report'), 6, 'Foram encontradas discrepâncias na apuração de impostos.', 'Discrepância fiscal', 'Concluído'),
                                                                                     (nextval('public.sq_Report'), 11, 'O módulo de pedidos está com erro ao conectar com o banco de dados.', 'Falha de conexão','Pendente'),
                                                                                     (nextval('public.sq_Report'), 15, 'O novo processo de produção está resultando em mais produtos com defeito.', 'Atualização defeituosa','Concluído'),
                                                                                     (nextval('public.sq_Report'), 20, 'Alguns prontuários digitalizados estão ilegíveis.', 'Qualidade da imagem', 'Pendente');

-- Inserindo dados na tabela TarefaHabilidade
INSERT INTO public.TarefaHabilidade (nCdHabilidade, nCdTarefa, iPrioridade) VALUES
                                                                                (1, 1, 1), (2, 1, 2), (22, 1, 3),
                                                                                (2, 2, 1),
                                                                                (3, 3, 1),
                                                                                (4, 4, 1), (5, 4, 2),
                                                                                (1, 5, 1),
                                                                                (7, 6, 1), (6, 6, 2),
                                                                                (9, 7, 1), (8, 7, 2),
                                                                                (7, 8, 1), (6, 8, 2),
                                                                                (5, 9, 1), (4, 9, 2),
                                                                                (23, 10, 1),
                                                                                (10, 11, 1),
                                                                                (11, 12, 1),
                                                                                (12, 13, 1), (13, 13, 2),
                                                                                (13, 14, 1), (12, 14, 2),
                                                                                (14, 15, 1),
                                                                                (15, 16, 1),
                                                                                (16, 17, 1),
                                                                                (17, 18, 1),
                                                                                (18, 19, 1),
                                                                                (19, 20, 1),
                                                                                (20, 21, 1),
                                                                                (21, 22, 1),
                                                                                (1, 23, 1), (22, 23, 2),
                                                                                (4, 24, 1), (5, 24, 2),
                                                                                (6, 25, 1), (7, 25, 2),
                                                                                (8, 26, 1), (9, 26, 2),
                                                                                (10, 27, 1), (11, 27, 2),
                                                                                (16, 28, 1), (17, 28, 2),
                                                                                (4, 29, 1), (5, 29, 2);

-- Inserindo dados na tabela TarefaUsuario
INSERT INTO public.TarefaUsuario (nCdTarefa, nCdUsuarioOriginal, nCdUsuarioAtuante) VALUES
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
    