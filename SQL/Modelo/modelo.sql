--CREATE DATABASE dbKronos;
DROP TABLE IF EXISTS public.PlanoPagamento         CASCADE;
DROP TABLE IF EXISTS public.Empresa                CASCADE;
DROP TABLE IF EXISTS public.HabilidadeUsuario      CASCADE;
DROP TABLE IF EXISTS table_log.LogAtribuicaoTarefa CASCADE;
DROP TABLE IF EXISTS public.Mensagem               CASCADE;
DROP TABLE IF EXISTS public.PlanoVantagem          CASCADE;
DROP TABLE IF EXISTS public.Report                 CASCADE;
DROP TABLE IF EXISTS public.Setor                  CASCADE;
DROP TABLE IF EXISTS public.Tarefa                 CASCADE;
DROP TABLE IF EXISTS public.TarefaHabilidade       CASCADE;
DROP TABLE IF EXISTS public.TarefaUsuario          CASCADE;
DROP TABLE IF EXISTS public.Usuario                CASCADE;
DROP TABLE IF EXISTS public.Habilidade             CASCADE;
DROP TABLE IF EXISTS public.RegistroDAU            CASCADE;

DROP SEQUENCE IF EXISTS public.sq_PlanoPagamento;
DROP SEQUENCE IF EXISTS public.sq_Empresa;
DROP SEQUENCE IF EXISTS table_log.sq_LogAtribuicaoTarefa;
DROP SEQUENCE IF EXISTS public.sq_Mensagem;
DROP SEQUENCE IF EXISTS public.sq_PlanoVantagem;
DROP SEQUENCE IF EXISTS public.sq_Report;
DROP SEQUENCE IF EXISTS public.sq_Setor;
DROP SEQUENCE IF EXISTS public.sq_Tarefa;
DROP SEQUENCE IF EXISTS public.sq_Usuario;
DROP SEQUENCE IF EXISTS public.sq_Habilidade;
DROP SEQUENCE IF EXISTS public.sq_TarefaUsuario;
DROP SEQUENCE IF EXISTS public.sq_TarefaHabilidade;
DROP SEQUENCE IF EXISTS public.sq_HabilidadeUsuario;
DROP SEQUENCE IF EXISTS public.sq_RegistroDAU;

DROP TYPE IF EXISTS public.TIPO_LOCAL_USO;
DROP TYPE IF EXISTS public.OPCAO_STATUS;

-- IDs
CREATE SEQUENCE public.sq_PlanoPagamento         START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE public.sq_Empresa                START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE table_log.sq_LogAtribuicaoTarefa START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE public.sq_Mensagem               START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE public.sq_PlanoVantagem          START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE public.sq_Report                 START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE public.sq_Setor                  START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE public.sq_Tarefa                 START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE public.sq_Usuario                START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE public.sq_Habilidade             START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE public.sq_TarefaUsuario          START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE public.sq_TarefaHabilidade       START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE public.sq_HabilidadeUsuario      START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE public.sq_RegistroDAU            START WITH 1 INCREMENT BY 1;

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
    , cNmPlano VARCHAR(50)   NOT NULL UNIQUE
    , nPreco   DECIMAL(10,2)   NOT NULL
    , PRIMARY KEY(nCdPlano)
);

CREATE TABLE public.Mensagem ( nCdMensagem BIGINT        NOT NULL DEFAULT NEXTVAL('public.sq_Mensagem')
    , cTitulo    VARCHAR(50)       NOT NULL
    , cMensagem  VARCHAR(255)    NOT NULL
    , cCategoria VARCHAR(70)    NOT NULL
    , PRIMARY KEY(nCdMensagem)
);

-- Tabelas com dependência de PlanoPagamento
CREATE TABLE public.Empresa ( nCdEmpresa        BIGINT        NOT NULL DEFAULT NEXTVAL('public.sq_Empresa')
    , cNmEmpresa        VARCHAR(255)  NOT NULL
    , cSgEmpresa        VARCHAR(3)    NOT NULL
    , cCNPJ             VARCHAR(18)   NOT NULL UNIQUE
    , cTelefone         VARCHAR(255)  NOT NULL UNIQUE
    , cEmail            VARCHAR(255)  NOT NULL UNIQUE
    , cCEP              VARCHAR(255)  NOT NULL
    , nCdPlanoPagamento BIGINT        NOT NULL
    , bAtivo            BOOLEAN       NOT NULL DEFAULT True
    , PRIMARY KEY (nCdEmpresa)
    , FOREIGN KEY (nCdPlanoPagamento) REFERENCES public.PlanoPagamento(nCdPlano)
);

CREATE TABLE public.PlanoVantagem ( nCdPlanoVantagem BIGINT        NOT NULL DEFAULT NEXTVAL('public.sq_PlanoVantagem')
    , nCdPlano         BIGINT        NOT NULL
    , cNmVantagem      VARCHAR(100)  NOT NULL UNIQUE
    , cDescricao       VARCHAR(255)  NOT NULL
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
    , PRIMARY KEY(nCdSetor)
    , FOREIGN KEY (nCdEmpresa) REFERENCES public.Empresa(nCdEmpresa)
);

-- Tabela com dependência de Empresa e Setor
CREATE TABLE public.Usuario ( nCdUsuario BIGINT        NOT NULL DEFAULT NEXTVAL('public.sq_Usuario')
    , cNmUsuario  VARCHAR(100)  NOT NULL
    , nCdGestor   BIGINT            NULL
    , bGestor     BOOLEAN       NOT NULL
    , nCdEmpresa  BIGINT        NOT NULL
    , nCdSetor    BIGINT        NOT NULL
    , nCPF        VARCHAR(15)   NOT NULL
    , cTelefone   VARCHAR(20)       NULL
    , cEmail      VARCHAR(255)      NULL
    , cSenha      VARCHAR(50)   NOT NULL DEFAULT 't33'
    , cFoto       VARCHAR           NULL
    , bAtivo      BOOLEAN       NOT NULL DEFAULT True
    , PRIMARY KEY (nCdUsuario)
    , FOREIGN KEY (nCdEmpresa) REFERENCES public.Empresa (nCdEmpresa)
    , FOREIGN KEY (nCdSetor)   REFERENCES public.Setor (nCdSetor)
    , FOREIGN KEY (nCdGestor)  REFERENCES public.Usuario (nCdUsuario)
);

-- Tabelas com dependência de Habilidade, Usuario e Mensagem
CREATE TABLE public.HabilidadeUsuario ( nCdTarefaHabilidade BIGINT NOT NULL DEFAULT NEXTVAL('public.sq_HabilidadeUsuario')
    , nCdHabilidade BIGINT        NOT NULL
    , nCdUsuario    BIGINT        NOT NULL
    , UNIQUE  (nCdHabilidade, nCdUsuario)
    , PRIMARY KEY (nCdHabilidade, nCdUsuario)
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
    , iTempoEstimado    INTEGER       NOT NULL
    , cDescricao        TEXT          NOT NULL
    , cStatus           OPCAO_STATUS   NOT NULL DEFAULT 'Pendente'
    , dDataAtribuicao   TIMESTAMP     NOT NULL DEFAULT NOW()
    , dDataConclusao    TIMESTAMP         NULL
    , PRIMARY KEY (nCdTarefa)
    , FOREIGN KEY (nCdUsuarioRelator) REFERENCES public.Usuario (nCdUsuario)
);

CREATE TABLE public.RegistroDAU ( nCdSessao BIGINT        NOT NULL DEFAULT NEXTVAL('public.sq_RegistroDAU')
    , nCdUsuario          BIGINT          NOT NULL
    , dDataEntrada        TIMESTAMPTZ     NOT NULL
    , dDataSaida          TIMESTAMPTZ         NULL
    , dUltimoHeartbeat    TIMESTAMPTZ     NOT NULL
    , cLocalUso           TIPO_LOCAL_USO  NOT NULL
    , iDuracaoMinutos     INTEGER             NULL
    , PRIMARY KEY (nCdSessao)
    , FOREIGN KEY (nCdUsuario) REFERENCES public.Usuario(nCdUsuario)
);

-- Tabelas com dependência de Tarefa e Usuario
CREATE TABLE table_log.LogAtribuicaoTarefa ( nCdLogAtribuicao  BIGINT        NOT NULL DEFAULT NEXTVAL('table_log.sq_LogAtribuicaoTarefa')
    , nCdTarefa         BIGINT        NOT NULL
    , nCdUsuarioAtuante BIGINT        NOT NULL
    , dRealocacao       DATE          NOT NULL DEFAULT NOW()
    , cObservacao       VARCHAR(300)  NOT NULL DEFAULT 'Nenhum comentário para a Tarefa'
    , PRIMARY KEY (nCdLogAtribuicao)
    , FOREIGN KEY (nCdTarefa)         REFERENCES public.Tarefa (nCdTarefa)
    , FOREIGN KEY (nCdUsuarioAtuante) REFERENCES public.Usuario (nCdUsuario)
);

CREATE TABLE public.Report ( nCdReport  BIGINT        NOT NULL DEFAULT NEXTVAL('public.sq_Report')
    , nCdTarefa  BIGINT        NOT NULL
    , cDescricao VARCHAR(255)  NOT NULL
    , cProblema  VARCHAR(255)  NOT NULL
    , cStatus    OPCAO_STATUS   NOT NULL DEFAULT 'Pendente'
    , PRIMARY KEY (nCdReport)
    , FOREIGN KEY (nCdTarefa) REFERENCES public.Tarefa(nCdTarefa)
);

CREATE TABLE public.TarefaHabilidade ( nCdTarefaHabilidade BIGINT NOT NULL DEFAULT NEXTVAL('public.sq_TarefaHabilidade')
    , nCdHabilidade BIGINT        NOT NULL
    , nCdTarefa     BIGINT        NOT NULL
    , iPrioridade   INTEGER       NOT NULL
    , UNIQUE  (nCdTarefa, nCdHabilidade)
    , PRIMARY KEY (nCdHabilidade, nCdTarefa)
    , FOREIGN KEY (nCdHabilidade) REFERENCES public.Habilidade(nCdHabilidade)
    , FOREIGN KEY (nCdTarefa)     REFERENCES public.Tarefa (nCdTarefa)
);

CREATE TABLE public.TarefaUsuario ( nCdTarefaUsuario BIGINT NOT NULL DEFAULT NEXTVAL('public.sq_TarefaUsuario')
    , nCdTarefa          BIGINT        NOT NULL
    , nCdUsuarioOriginal BIGINT        NOT NULL
    , nCdUsuarioAtuante  BIGINT        NOT NULL
    , UNIQUE  (nCdTarefa, nCdUsuarioOriginal, nCdUsuarioAtuante)
    , PRIMARY KEY(nCdTarefa, nCdUsuarioOriginal, nCdUsuarioAtuante)
    , FOREIGN KEY (nCdTarefa)          REFERENCES public.Tarefa (nCdTarefa)
    , FOREIGN KEY (nCdUsuarioOriginal) REFERENCES public.Usuario(nCdUsuario)
    , FOREIGN KEY (nCdUsuarioAtuante)  REFERENCES public.Usuario(nCdUsuario)
);
