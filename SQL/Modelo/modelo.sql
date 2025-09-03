--CREATE DATABASE dbKronos;
DROP TABLE IF EXISTS public.PlanoPagamento         CASCADE;
DROP TABLE IF EXISTS public.Empresa                CASCADE;
DROP TABLE IF EXISTS public.HabilidadeUsuario      CASCADE;
DROP TABLE IF EXISTS table_log.LogAtribuicaoTarefa CASCADE;
DROP TABLE IF EXISTS public.Mensagem               CASCADE;
DROP TABLE IF EXISTS public.PlanoVantagens         CASCADE;
DROP TABLE IF EXISTS public.Report                 CASCADE;
DROP TABLE IF EXISTS public.Setor                  CASCADE;
DROP TABLE IF EXISTS public.Tarefa                 CASCADE;
DROP TABLE IF EXISTS public.TarefaHabilidade       CASCADE;
DROP TABLE IF EXISTS public.TarefaUsuario          CASCADE;
DROP TABLE IF EXISTS public.Usuario                CASCADE;
DROP TABLE IF EXISTS public.Habilidade             CASCADE;

DROP SEQUENCE IF EXISTS public.sq_planopagamento;
DROP SEQUENCE IF EXISTS public.sq_empresa;
DROP SEQUENCE IF EXISTS table_log.sq_logatribuicaotarefa;
DROP SEQUENCE IF EXISTS public.sq_mensagem;
DROP SEQUENCE IF EXISTS public.sq_planovantagens;
DROP SEQUENCE IF EXISTS public.sq_report;
DROP SEQUENCE IF EXISTS public.sq_setor;
DROP SEQUENCE IF EXISTS public.sq_tarefa;
DROP SEQUENCE IF EXISTS public.sq_usuario;
DROP SEQUENCE IF EXISTS public.sq_habilidade;

-- IDs
CREATE SEQUENCE public.sq_planopagamento         START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE public.sq_empresa                START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE table_log.sq_logatribuicaotarefa START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE public.sq_mensagem               START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE public.sq_planovantagens         START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE public.sq_report                 START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE public.sq_setor                  START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE public.sq_tarefa                 START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE public.sq_usuario                START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE public.sq_habilidade             START WITH 1 INCREMENT BY 1;


-- Tabelas sem dependências
CREATE TABLE public.PlanoPagamento ( nCdPlano DECIMAL(10,0) NOT NULL DEFAULT NEXTVAL('public.sq_planopagamento')
    , cNmPlano VARCHAR(50)   NOT NULL UNIQUE
    , nPreco DECIMAL(10,2)   NOT NULL
    , PRIMARY KEY(nCdPlano)
);

CREATE TABLE public.Mensagem ( nCdMensagem DECIMAL(10,0) NOT NULL DEFAULT NEXTVAL('public.sq_mensagem')
    , cTitulo VARCHAR(50)       NOT NULL
    , cMensagem VARCHAR(255)    NOT NULL
    , cCategoria VARCHAR(70)    NOT NULL
    , PRIMARY KEY(nCdMensagem)
);

-- Tabelas com dependência de PlanoPagamento
CREATE TABLE public.Empresa ( nCdEmpresa        DECIMAL(10,0) NOT NULL DEFAULT NEXTVAL('public.sq_empresa')
    , cNmEmpresa        VARCHAR(255)  NOT NULL
    , cSgEmpresa        VARCHAR(3)    NOT NULL
    , cCNPJ             VARCHAR(18)   NOT NULL UNIQUE
    , cTelefone         VARCHAR(255)  NOT NULL UNIQUE
    , cEmail            VARCHAR(255)  NOT NULL UNIQUE
    , cCEP              VARCHAR(255)  NOT NULL
    , nCdPlanoPagamento DECIMAL(10,0) NOT NULL
    , bAtivo            BOOLEAN       NOT NULL DEFAULT True
    , PRIMARY KEY (nCdEmpresa)
    , FOREIGN KEY (nCdPlanoPagamento) REFERENCES public.PlanoPagamento(nCdPlano)
);

CREATE TABLE public.PlanoVantagens ( nCdPlanoVantagem DECIMAL(10,0) NOT NULL DEFAULT NEXTVAL('public.sq_planovantagens')
    , nCdPlano         DECIMAL(10,0) NOT NULL
    , cNmVantagem      VARCHAR(100)  NOT NULL UNIQUE
    , cDescricao       VARCHAR(255)  NOT NULL
    , PRIMARY KEY (nCdPlano, nCdPlanoVantagem)
    , FOREIGN KEY (nCdPlano) REFERENCES public.PlanoPagamento(nCdPlano)
);

-- Tabelas com dependência de Empresa
CREATE TABLE public.Habilidade ( nCdHabilidade DECIMAL(10,0) NOT NULL DEFAULT NEXTVAL('public.sq_habilidade')
    , nCdEmpresa    DECIMAL(10,0) NOT NULL
    , cNmHabilidade VARCHAR(255)  NOT NULL
    , cDescricao    VARCHAR(255)  NOT NULL
    , PRIMARY KEY (nCdHabilidade)
    , FOREIGN KEY (nCdEmpresa) REFERENCES public.Empresa(nCdEmpresa)
);

CREATE TABLE public.Setor ( nCdSetor   DECIMAL(10,0) NOT NULL DEFAULT NEXTVAL('public.sq_setor')
    , nCdEmpresa DECIMAL(10,0) NOT NULL
    , cNmSetor   VARCHAR(255)  NOT NULL
    , cSgSetor   VARCHAR(3)    NOT NULL
    , PRIMARY KEY(nCdSetor)
    , FOREIGN KEY (nCdEmpresa) REFERENCES public.Empresa(nCdEmpresa)
);

-- Tabela com dependência de Empresa e Setor
CREATE TABLE public.Usuario ( nCdUsuario DECIMAL(10,0) NOT NULL DEFAULT NEXTVAL('public.sq_usuario')
    , cNmUsuario  VARCHAR(100)  NOT NULL
    , nCdGestor   DECIMAL(10,0)     NULL
    , bGestor     BOOLEAN       NOT NULL
    , nCdEmpresa  DECIMAL(10,0) NOT NULL
    , nCdSetor    DECIMAL(10,0) NOT NULL
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
CREATE TABLE public.HabilidadeUsuario ( nCdHabilidade DECIMAL(10,0) NOT NULL
    , nCdUsuario    DECIMAL(10,0) NOT NULL
    , PRIMARY KEY (nCdHabilidade, nCdUsuario)
    , FOREIGN KEY (nCdHabilidade) REFERENCES public.Habilidade (nCdHabilidade)
    , FOREIGN KEY (nCdUsuario)    REFERENCES public.Usuario (nCdUsuario)
);

CREATE TABLE public.Tarefa ( nCdTarefa         DECIMAL(10,0) NOT NULL DEFAULT NEXTVAL('public.sq_tarefa')
    , cNmTarefa         VARCHAR(255)  NOT NULL
    , nCdUsuarioRelator DECIMAL(10,0) NOT NULL
    , nCdHabilidade     DECIMAL(10,0) NOT NULL
    , iGravidade        INTEGER       NOT NULL DEFAULT 1
                                 CHECK (iGravidade >= 1 AND iGravidade <= 5)
    , iUrgencia         INTEGER       NOT NULL DEFAULT 1
                                 CHECK (iUrgencia >= 1 AND iUrgencia <= 5)
    , iTendencia        INTEGER       NOT NULL DEFAULT 1
                                 CHECK (iTendencia >= 1 AND iTendencia <= 5)
    , nTempoEstimado    DECIMAL(10,0) NOT NULL
    , cDescricao        VARCHAR(255)  NOT NULL
    , cStatus           VARCHAR(15)   NOT NULL DEFAULT 'Pendente'
                                 CHECK (  cStatus = 'Pendente'
                                     OR cStatus = 'Em Andamento'
                                     OR cStatus = 'Concluída'
                                     OR cStatus = 'Cancelada'
                                     )
    , PRIMARY KEY (nCdTarefa)
    , FOREIGN KEY (nCdUsuarioRelator) REFERENCES public.Usuario (nCdUsuario)
    , FOREIGN KEY (nCdHabilidade)     REFERENCES public.Habilidade(nCdHabilidade)
);

-- Tabelas com dependência de Tarefa e Usuario
CREATE TABLE table_log.LogAtribuicaoTarefa ( nCdLogAtribuicao  DECIMAL(10,0) NOT NULL DEFAULT NEXTVAL('table_log.sq_logatribuicaotarefa')
    , nCdTarefa         DECIMAL(10,0) NOT NULL
    , nCdUsuarioAtuante DECIMAL(10,0) NOT NULL
    , dRealocacao       DATE          NOT NULL DEFAULT NOW()
    , cObservacao       VARCHAR(300)  NOT NULL DEFAULT 'Nenhum comentário para a tarefa'
    , PRIMARY KEY (nCdLogAtribuicao)
    , FOREIGN KEY (nCdTarefa)         REFERENCES public.Tarefa (nCdTarefa)
    , FOREIGN KEY (nCdUsuarioAtuante) REFERENCES public.Usuario (nCdUsuario)
);

CREATE TABLE public.Report ( nCdReport  DECIMAL(10,0) NOT NULL DEFAULT NEXTVAL('public.sq_report')
    , nCdTarefa  DECIMAL(10,0) NOT NULL
    , cDescricao VARCHAR(255)  NOT NULL
    , cProblema  VARCHAR(255)  NOT NULL
    , PRIMARY KEY (nCdReport)
    , FOREIGN KEY (nCdTarefa) REFERENCES public.Tarefa(nCdTarefa)
);

CREATE TABLE public.TarefaHabilidade ( nCdHabilidade DECIMAL(10,0) NOT NULL
    , nCdTarefa     DECIMAL(10,0) NOT NULL
    , iPrioridade   INTEGER       NOT NULL
    , PRIMARY KEY (nCdHabilidade, nCdTarefa)
    , FOREIGN KEY (nCdHabilidade) REFERENCES public.Habilidade(nCdHabilidade)
    , FOREIGN KEY (nCdTarefa)     REFERENCES public.Tarefa (nCdTarefa)
);

CREATE TABLE public.TarefaUsuario ( nCdTarefa          DECIMAL(10,0) NOT NULL
    , nCdUsuarioOriginal DECIMAL(10,0) NOT NULL
    , nCdUsuarioAtuante  DECIMAL(10,0) NOT NULL
    , PRIMARY KEY(nCdTarefa, nCdUsuarioOriginal, nCdUsuarioAtuante)
    , FOREIGN KEY (nCdTarefa)          REFERENCES public.Tarefa (nCdTarefa)
    , FOREIGN KEY (nCdUsuarioOriginal) REFERENCES public.Usuario(nCdUsuario)
    , FOREIGN KEY (nCdUsuarioAtuante)  REFERENCES public.Usuario(nCdUsuario)
);
