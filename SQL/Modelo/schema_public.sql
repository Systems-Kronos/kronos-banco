--CREATE DATABASE dbKronos;
-- Limpa DB
DROP SCHEMA IF EXISTS public CASCADE;

-- Criações
CREATE SCHEMA public;

-- IDs
CREATE SEQUENCE public.sq_PlanoPagamento         START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE public.sq_Empresa                START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE public.sq_PlanoVantagem          START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE public.sq_Report                 START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE public.sq_Setor                  START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE public.sq_Tarefa                 START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE public.sq_Usuario                START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE public.sq_Habilidade             START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE public.sq_TarefaUsuario          START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE public.sq_TarefaHabilidade       START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE public.sq_HabilidadeUsuario      START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE public.sq_Cargo                  START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE public.sq_Administracao          START WITH 1 INCREMENT BY 1;

-- Types (Para substituit check)
CREATE TYPE public.TIPO_LOCAL_USO AS ENUM ( 'APP_MOBILE'
                                          , 'APP_WEB'
                                          );

CREATE TYPE public.OPCAO_STATUS   AS ENUM ( 'Pendente'
                                          , 'Em Andamento'
                                          , 'Concluída'
                                          , 'Concluído'
                                          , 'Cancelada'
                                          , 'Cancelado'
                                          );


-- Tabelas sem dependências
CREATE TABLE public.PlanoPagamento ( nCdPlano BIGINT        NOT NULL DEFAULT NEXTVAL('public.sq_PlanoPagamento')
                                   , cNmPlano VARCHAR(50)   NOT NULL 
                                   , nPreco   DECIMAL(10,2) NOT NULL
                                   , UNIQUE (cNmPlano)
                                   , PRIMARY KEY(nCdPlano)
                                   );

CREATE TABLE public.Cargo ( nCdCargo BIGINT NOT NULL DEFAULT NEXTVAL('public.sq_Cargo')
                          , cNmCargo                 VARCHAR(255) NOT NULL
                          , cCdCBO                   VARCHAR(10)      NULL
                          , cNmFamiliaOcupacional    VARCHAR(255)     NULL
                          , PRIMARY KEY (nCdCargo)
                          );

CREATE TABLE public.Administracao ( nCdAdm     BIGINT       NOT NULL DEFAULT NEXTVAL('sq_Administracao')
                                  , cNmAdm     VARCHAR(255) NOT NULL
                                  , cEmailAdm  VARCHAR(255) NOT NULL
                                  , cSenha     VARCHAR(255) NOT NULL DEFAULT 't33'
                                  , PRIMARY KEY (nCdAdm)
                                  );

-- Tabelas com dependência de PlanoPagamento
CREATE TABLE public.Empresa ( nCdEmpresa        BIGINT        NOT NULL DEFAULT NEXTVAL('public.sq_Empresa')
                            , cNmEmpresa        VARCHAR(255)  NOT NULL
                            , cSgEmpresa        VARCHAR(3)    NOT NULL
                            , cCNPJ             VARCHAR(18)   NOT NULL 
                            , cTelefone         VARCHAR(255)  NOT NULL 
                            , cEmail            VARCHAR(255)  NOT NULL 
                            , cCEP              VARCHAR(255)  NOT NULL
                            , nCdPlanoPagamento BIGINT        NOT NULL
                            , bAtivo            BOOLEAN       NOT NULL DEFAULT True
                            , UNIQUE (cCNPJ, cTelefone, cEmail)
                            , PRIMARY KEY (nCdEmpresa)
                            , FOREIGN KEY (nCdPlanoPagamento) REFERENCES public.PlanoPagamento(nCdPlano)
                            );

CREATE TABLE public.PlanoVantagem ( nCdPlanoVantagem BIGINT        NOT NULL DEFAULT NEXTVAL('public.sq_PlanoVantagem')
                                  , nCdPlano         BIGINT        NOT NULL
                                  , cNmVantagem      VARCHAR(100)  NOT NULL 
                                  , cDescricao       VARCHAR(255)  NOT NULL
                                  , UNIQUE      (cNmVantagem)
                                  , PRIMARY KEY (nCdPlano, nCdPlanoVantagem)
                                  , FOREIGN KEY (nCdPlano) REFERENCES public.PlanoPagamento(nCdPlano)
                                  );

-- Tabelas com dependência de Empresa
CREATE TABLE public.Habilidade ( nCdHabilidade BIGINT        NOT NULL DEFAULT NEXTVAL('public.sq_Habilidade')
                               , nCdEmpresa    BIGINT        NOT NULL
                               , cNmHabilidade VARCHAR(255)  NOT NULL
                               , cDescricao    VARCHAR(255)  NOT NULL
                               , PRIMARY KEY (nCdHabilidade)
                               , FOREIGN KEY (nCdEmpresa) REFERENCES public.Empresa(nCdEmpresa)
                               );

CREATE TABLE public.Setor ( nCdSetor   BIGINT        NOT NULL DEFAULT NEXTVAL('public.sq_Setor')
                          , nCdEmpresa BIGINT        NOT NULL
                          , cNmSetor   VARCHAR(255)  NOT NULL
                          , cSgSetor   VARCHAR(3)    NOT NULL
                          , PRIMARY KEY (nCdSetor)
                          , FOREIGN KEY (nCdEmpresa) REFERENCES public.Empresa(nCdEmpresa)
                          );

-- Tabela com dependência de Empresa e Setor
CREATE TABLE public.Usuario ( nCdUsuario  BIGINT        NOT NULL DEFAULT NEXTVAL('public.sq_Usuario')
                            , cNmUsuario  VARCHAR(200)  NOT NULL
                            , nCdGestor   BIGINT            NULL
                            , bGestor     BOOLEAN       NOT NULL
                            , nCdEmpresa  BIGINT        NOT NULL
                            , nCdSetor    BIGINT        NOT NULL
                            , nCdCargo    BIGINT        NOT NULL
                            , cCPF        VARCHAR(15)   NOT NULL
                            , cTelefone   VARCHAR(20)       NULL
                            , cEmail      VARCHAR(255)      NULL
                            , cSenha      VARCHAR(255)   NOT NULL DEFAULT 't33'
                            , cFoto       VARCHAR           NULL
                            , bAtivo      BOOLEAN       NOT NULL DEFAULT True
                            , UNIQUE      (cCPF, cTelefone, cEmail) 
                            , PRIMARY KEY (nCdUsuario)
                            , FOREIGN KEY (nCdEmpresa) REFERENCES public.Empresa (nCdEmpresa)
                            , FOREIGN KEY (nCdSetor)   REFERENCES public.Setor (nCdSetor)
                            , FOREIGN KEY (nCdGestor)  REFERENCES public.Usuario (nCdUsuario)
                            , FOREIGN KEY (nCdCargo)   REFERENCES public.Cargo (nCdCargo)
                            );

-- Tabelas com dependência de Habilidade e Usuario
CREATE TABLE public.HabilidadeUsuario ( nCdHabilidadeUsuario BIGINT NOT NULL DEFAULT NEXTVAL('public.sq_HabilidadeUsuario')
                                      , nCdHabilidade        BIGINT NOT NULL
                                      , nCdUsuario           BIGINT NOT NULL
                                      , PRIMARY KEY (nCdHabilidadeUsuario)
                                      , UNIQUE      (nCdHabilidade,nCdUsuario) 
                                      , FOREIGN KEY (nCdHabilidade) REFERENCES public.Habilidade (nCdHabilidade)
                                      , FOREIGN KEY (nCdUsuario)    REFERENCES public.Usuario (nCdUsuario)
                                      );

CREATE TABLE public.Tarefa ( nCdTarefa         BIGINT        NOT NULL DEFAULT NEXTVAL('public.sq_Tarefa')
                           , cNmTarefa         VARCHAR(255)  NOT NULL
                           , nCdUsuarioRelator BIGINT        NOT NULL
                           , iGravidade        INTEGER       NOT NULL DEFAULT 1
                                CHECK (iGravidade >= 1 AND iGravidade <= 5)
                           , iUrgencia         INTEGER       NOT NULL DEFAULT 1
                                CHECK (iUrgencia >= 1 AND iUrgencia <= 5)
                           , iTendencia        INTEGER       NOT NULL DEFAULT 1
                                CHECK (iTendencia >= 1 AND iTendencia <= 5)
                           , iTempoEstimado    INTEGER           NULL
                           , cDescricao        TEXT          NOT NULL
                           , cStatus           OPCAO_STATUS  NOT NULL DEFAULT 'Pendente'
                           , dDataAtribuicao   TIMESTAMP     NOT NULL DEFAULT NOW()
                           , dDataConclusao    TIMESTAMP         NULL
                           , PRIMARY KEY (nCdTarefa)
                           , FOREIGN KEY (nCdUsuarioRelator) REFERENCES public.Usuario (nCdUsuario)
                           );

CREATE TABLE public.Report ( nCdReport  BIGINT        NOT NULL DEFAULT NEXTVAL('public.sq_Report')
                           , nCdTarefa  BIGINT        NOT NULL
                           , nCdUsuario BIGINT        NOT NULL
                           , cDescricao VARCHAR(255)  NOT NULL
                           , cProblema  VARCHAR(255)  NOT NULL
                           , cStatus    OPCAO_STATUS  NOT NULL DEFAULT 'Pendente'
                           , PRIMARY KEY (nCdReport)
                           , FOREIGN KEY (nCdTarefa)  REFERENCES public.Tarefa(nCdTarefa)
                           , FOREIGN KEY (nCdUsuario) REFERENCES public.Usuario(nCdUsuario)
                           );

CREATE TABLE public.TarefaHabilidade ( nCdTarefaHabilidade BIGINT  NOT NULL DEFAULT NEXTVAL('public.sq_TarefaHabilidade')
                                     , nCdHabilidade       BIGINT  NOT NULL
                                     , nCdTarefa           BIGINT  NOT NULL
                                     , iPrioridade         INTEGER NOT NULL
                                     , UNIQUE      (nCdTarefa, nCdHabilidade)
                                     , PRIMARY KEY (nCdTarefaHabilidade)
                                     , FOREIGN KEY (nCdHabilidade) REFERENCES public.Habilidade(nCdHabilidade)
                                     , FOREIGN KEY (nCdTarefa)     REFERENCES public.Tarefa (nCdTarefa)
                                     );

CREATE TABLE public.TarefaUsuario ( nCdTarefaUsuario   BIGINT        NOT NULL DEFAULT NEXTVAL('public.sq_TarefaUsuario')
                                  , nCdTarefa          BIGINT        NOT NULL
                                  , nCdUsuarioOriginal BIGINT        NOT NULL
                                  , nCdUsuarioAtuante  BIGINT        NOT NULL
                                  , UNIQUE      (nCdTarefa, nCdUsuarioOriginal, nCdUsuarioAtuante)
                                  , PRIMARY KEY (nCdTarefaUsuario)
                                  , FOREIGN KEY (nCdTarefa)          REFERENCES public.Tarefa (nCdTarefa)
                                  , FOREIGN KEY (nCdUsuarioOriginal) REFERENCES public.Usuario(nCdUsuario)
                                  , FOREIGN KEY (nCdUsuarioAtuante)  REFERENCES public.Usuario(nCdUsuario)
                                  );

-- Índices
CREATE EXTENSION IF NOT EXISTS pg_trgm;

-- Empresas
CREATE INDEX idx_empresa_plano_pagamento ON public.Empresa(nCdPlanoPagamento);
CREATE INDEX idx_empresa_ativo           ON public.Empresa(bAtivo);

-- Setor
CREATE INDEX idx_setor_empresa ON public.Setor(nCdEmpresa);

-- Habilidade
CREATE INDEX idx_habilidade_empresa ON public.Habilidade(nCdEmpresa);

-- Usuário (FKs)
CREATE INDEX idx_usuario_empresa ON public.Usuario(nCdEmpresa);
CREATE INDEX idx_usuario_setor   ON public.Usuario(nCdSetor);
CREATE INDEX idx_usuario_gestor  ON public.Usuario(nCdGestor);
CREATE INDEX idx_usuario_ativo   ON public.Usuario(bAtivo);

-- Tarefa
CREATE INDEX idx_tarefa_status          ON public.Tarefa(cStatus);
CREATE INDEX idx_tarefa_usuario_relator ON public.Tarefa(nCdUsuarioRelator);

-- Report
CREATE INDEX idx_report_usuario ON public.Report(nCdUsuario);
CREATE INDEX idx_report_tarefa  ON public.Report(nCdTarefa);
CREATE INDEX idx_report_status  ON public.Report(cStatus);

-- TarefaHabilidade
CREATE INDEX idx_tarefa_habilidade_prioridade ON public.TarefaHabilidade(iPrioridade);

-- Tabela TarefaUsuario: Críticos para listagem (fn_lista_tarefa_usuario) e realocação (sp_realoca_tarefa)
CREATE INDEX idx_tu_usuario_atuante  ON public.TarefaUsuario(nCdUsuarioAtuante);
CREATE INDEX idx_tu_tarefa_id        ON public.TarefaUsuario(nCdTarefa);
CREATE INDEX idx_tu_usuario_original ON public.TarefaUsuario(nCdUsuarioOriginal);

-- Tabela HabilidadeUsuario
CREATE INDEX idx_hu_usuario_id ON public.HabilidadeUsuario(nCdUsuario);

-- GIN
CREATE INDEX idx_usuario_nome_trgm ON public.Usuario USING GIN (cNmUsuario gin_trgm_ops);
CREATE INDEX idx_tarefa_nome_trgm  ON public.Tarefa  USING GIN (cNmTarefa  gin_trgm_ops);