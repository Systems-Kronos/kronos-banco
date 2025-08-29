--CREATE DATABASE dbKronos;
DROP TABLE IF EXISTS PlanoPagamento      CASCADE;
DROP TABLE IF EXISTS Empresa             CASCADE;
DROP TABLE IF EXISTS HabilidadeUsuario   CASCADE;
DROP TABLE IF EXISTS LogAtribuicaoTarefa CASCADE;
DROP TABLE IF EXISTS Mensagem            CASCADE;
DROP TABLE IF EXISTS PlanoVantagens      CASCADE;
DROP TABLE IF EXISTS Report              CASCADE;
DROP TABLE IF EXISTS Setor               CASCADE;
DROP TABLE IF EXISTS Tarefa              CASCADE;
DROP TABLE IF EXISTS TarefaHabilidade    CASCADE;
DROP TABLE IF EXISTS TarefaUsuario       CASCADE;
DROP TABLE IF EXISTS Usuario             CASCADE;
DROP TABLE IF EXISTS Habilidade          CASCADE;

DROP SEQUENCE  sq_planopagamento;
DROP SEQUENCE  sq_empresa;
DROP SEQUENCE  sq_logatribuicaotarefa;
DROP SEQUENCE  sq_mensagem;
DROP SEQUENCE  sq_planovantagens;
DROP SEQUENCE  sq_report;
DROP SEQUENCE  sq_setor;
DROP SEQUENCE  sq_tarefa;
DROP SEQUENCE  sq_usuario;
DROP SEQUENCE  sq_habilidade;

-- IDs
CREATE SEQUENCE  sq_planopagamento         START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE  sq_empresa                START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE  sq_logatribuicaotarefa    START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE  sq_mensagem               START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE  sq_planovantagens         START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE  sq_report                 START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE  sq_setor                  START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE  sq_tarefa                 START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE  sq_usuario                START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE  sq_habilidade             START WITH 1 INCREMENT BY 1;


-- Tabelas sem dependências
CREATE TABLE PlanoPagamento ( nCdPlano DECIMAL(10,0) NOT NULL DEFAULT NEXTVAL('sq_planopagamento')
    , cNmPlano VARCHAR(50)   NOT NULL UNIQUE
    , nPreco DECIMAL(10,2)   NOT NULL
    , PRIMARY KEY(nCdPlano)
);

CREATE TABLE Mensagem ( nCdMensagem DECIMAL(10,0) NOT NULL DEFAULT NEXTVAL('sq_mensagem')
    , cTitulo VARCHAR(50)       NOT NULL
    , cMensagem VARCHAR(255)    NOT NULL
    , cCategoria VARCHAR(70)    NOT NULL
    , PRIMARY KEY(nCdMensagem)
);

-- Tabelas com dependência de PlanoPagamento
CREATE TABLE Empresa ( nCdEmpresa        DECIMAL(10,0) NOT NULL DEFAULT NEXTVAL('sq_empresa')
    , cNmEmpresa        VARCHAR(255)  NOT NULL
    , cCNPJ             VARCHAR(18)   NOT NULL UNIQUE
    , cTelefone         VARCHAR(255)  NOT NULL UNIQUE
    , cEmail            VARCHAR(255)  NOT NULL UNIQUE
    , cCEP              VARCHAR(255)  NOT NULL
    , nCdPlanoPagamento DECIMAL(10,0) NOT NULL
    , bAtivo            BOOLEAN       NOT NULL DEFAULT True
    , PRIMARY KEY (nCdEmpresa)
    , FOREIGN KEY (nCdPlanoPagamento) REFERENCES PlanoPagamento(nCdPlano)
);

CREATE TABLE PlanoVantagens ( nCdPlanoVantagem DECIMAL(10,0) NOT NULL DEFAULT NEXTVAL('sq_planovantagens')
    , nCdPlano         DECIMAL(10,0) NOT NULL
    , nCdVantagem      DECIMAL(10,0) NOT NULL
    , cNmVantagem      VARCHAR(100)  NOT NULL UNIQUE
    , cDescricao       VARCHAR(255)  NOT NULL
    , PRIMARY KEY (nCdPlano, nCdVantagem)
    , FOREIGN KEY (nCdPlano) REFERENCES PlanoPagamento(nCdPlano)
);

-- Tabelas com dependência de Empresa
CREATE TABLE Habilidade ( nCdHabilidade DECIMAL(10,0) NOT NULL DEFAULT NEXTVAL('sq_habilidade')
    , nCdEmpresa    DECIMAL(10,0) NOT NULL
    , cNmHabilidade VARCHAR(255)  NOT NULL
    , cDescricao    VARCHAR(255)  NOT NULL
    , PRIMARY KEY (nCdHabilidade)
    , FOREIGN KEY (nCdEmpresa) REFERENCES Empresa(nCdEmpresa)
);

CREATE TABLE Setor ( nCdSetor   DECIMAL(10,0) NOT NULL DEFAULT NEXTVAL('sq_setor')
    , nCdEmpresa DECIMAL(10,0) NOT NULL
    , cNmSetor   VARCHAR(255)  NOT NULL
    , PRIMARY KEY(nCdSetor)
    , FOREIGN KEY (nCdEmpresa) REFERENCES Empresa(nCdEmpresa)
);

-- Tabela com dependência de Empresa e Setor
CREATE TABLE Usuario ( nCdUsuario DECIMAL(10,0) NOT NULL DEFAULT NEXTVAL('sq_usuario')
    , cNmUsuario VARCHAR(100)  NOT NULL
    , nCdGestor  DECIMAL(10,0)     NULL
    , bGestor    BOOLEAN       NOT NULL
    , nCdEmpresa DECIMAL(10,0) NOT NULL
    , nCdSetor   DECIMAL(10,0) NOT NULL
    , nCPF       VARCHAR(15)   NOT NULL
    , cTelefone  VARCHAR(20)       NULL
    , cEmail     VARCHAR(255)      NULL
    , cSenha     VARCHAR(50)   NOT NULL DEFAULT 't33'
    , cFoto      VARCHAR           NULL
    , bAtivo     BOOLEAN       NOT NULL DEFAULT True
    , PRIMARY KEY (nCdUsuario)
    , FOREIGN KEY (nCdEmpresa) REFERENCES Empresa (nCdEmpresa)
    , FOREIGN KEY (nCdSetor)   REFERENCES Setor (nCdSetor)
    , FOREIGN KEY (nCdGestor)  REFERENCES Usuario (nCdUsuario)
);

-- Tabelas com dependência de Habilidade, Usuario e Mensagem
CREATE TABLE HabilidadeUsuario ( nCdHabilidade DECIMAL(10,0) NOT NULL
    , nCdUsuario    DECIMAL(10,0) NOT NULL
    , PRIMARY KEY (nCdHabilidade, nCdUsuario)
    , FOREIGN KEY (nCdHabilidade) REFERENCES Habilidade (nCdHabilidade)
    , FOREIGN KEY (nCdUsuario)    REFERENCES Usuario (nCdUsuario)
);

CREATE TABLE Tarefa ( nCdTarefa         DECIMAL(10,0) NOT NULL DEFAULT NEXTVAL('sq_tarefa')
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
                          CHECK (cStatus = 'Pendente' OR cStatus = 'Em Andamento' OR cStatus = 'Concluída' OR cStatus = 'Cancelada')
    , PRIMARY KEY (nCdTarefa)
    , FOREIGN KEY (nCdUsuarioRelator) REFERENCES Usuario (nCdUsuario)
    , FOREIGN KEY (nCdHabilidade)     REFERENCES Habilidade(nCdHabilidade)
);

-- Tabelas com dependência de Tarefa e Usuario
CREATE TABLE LogAtribuicaoTarefa ( nCdLogAtribuicao  DECIMAL(10,0) NOT NULL DEFAULT NEXTVAL('sq_logatribuicaotarefa')
    , nCdTarefa         DECIMAL(10,0) NOT NULL
    , nCdUsuarioAtuante DECIMAL(10,0) NOT NULL
    , dRealocacao       DATE          NOT NULL DEFAULT NOW()
    , PRIMARY KEY (nCdLogAtribuicao)
    , FOREIGN KEY (nCdTarefa)         REFERENCES Tarefa (nCdTarefa)
    , FOREIGN KEY (nCdUsuarioAtuante) REFERENCES Usuario (nCdUsuario)
);

CREATE TABLE Report ( nCdReport  DECIMAL(10,0) NOT NULL DEFAULT NEXTVAL('sq_report')
    , nCdTarefa  DECIMAL(10,0) NOT NULL
    , cDescricao VARCHAR(255)  NOT NULL
    , cProblema  VARCHAR(255)  NOT NULL
    , PRIMARY KEY (nCdReport)
    , FOREIGN KEY (nCdTarefa) REFERENCES Tarefa(nCdTarefa)
);

CREATE TABLE TarefaHabilidade ( nCdHabilidade DECIMAL(10,0) NOT NULL
    , nCdTarefa     DECIMAL(10,0) NOT NULL
    , iPrioridade   INTEGER       NOT NULL
    , PRIMARY KEY (nCdHabilidade, nCdTarefa)
    , FOREIGN KEY (nCdHabilidade) REFERENCES Habilidade(nCdHabilidade)
    , FOREIGN KEY (nCdTarefa)     REFERENCES Tarefa (nCdTarefa)
);

CREATE TABLE TarefaUsuario ( nCdTarefa          DECIMAL(10,0) NOT NULL
    , nCdUsuarioOriginal DECIMAL(10,0) NOT NULL
    , nCdUsuarioAtuante  DECIMAL(10,0) NOT NULL
    , PRIMARY KEY(nCdTarefa, nCdUsuarioOriginal, nCdUsuarioAtuante)
    , FOREIGN KEY (nCdTarefa)          REFERENCES Tarefa (nCdTarefa)
    , FOREIGN KEY (nCdUsuarioOriginal) REFERENCES Usuario(nCdUsuario)
    , FOREIGN KEY (nCdUsuarioAtuante)  REFERENCES Usuario(nCdUsuario)
);
