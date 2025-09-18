-- Reset das tabelas e do esquema
DROP TABLE IF EXISTS table_log.PlanoPagamento    CASCADE;
DROP TABLE IF EXISTS table_log.Mensagem          CASCADE;
DROP TABLE IF EXISTS table_log.Setor             CASCADE;
DROP TABLE IF EXISTS table_log.Usuario           CASCADE;
DROP TABLE IF EXISTS table_log.HabilidadeUsuario CASCADE;
DROP TABLE IF EXISTS table_log.Tarefa            CASCADE;
DROP TABLE IF EXISTS table_log.AtribuicaoTarefa  CASCADE;
DROP TABLE IF EXISTS table_log.Report            CASCADE;
DROP TABLE IF EXISTS table_log.TarefaHabilidade  CASCADE;
DROP TABLE IF EXISTS table_log.TarefaUsuario     CASCADE;
DROP SCHEMA IF EXISTS table_log                  CASCADE;

-- Criação do Esquema
CREATE SCHEMA table_log;

-- Criação das Tabelas
CREATE TABLE table_log.PlanoPagamento ( nCdLog        BIGSERIAL
	                                  , nCdPlano      BIGINT        NOT NULL 
                                      , cNmPlano      VARCHAR(50)   NOT NULL 
                                      , nPreco        DECIMAL(10,2) NOT NULL
                                      , cOperacao     VARCHAR(50)
                                      , dOperacao     TIMESTAMP              
                                      , PRIMARY KEY (nCdLog)
                                      );

CREATE TABLE table_log.Mensagem ( nCdLog        BIGSERIAL
								, nCdMensagem   BIGINT       NOT NULL 
                                , cTitulo       VARCHAR(50)  NOT NULL
                                , cMensagem     VARCHAR(255) NOT NULL
                                , cCategoria    VARCHAR(70)  NOT NULL
                                , cOperacao     VARCHAR(50)
                                , dOperacao     TIMESTAMP                 
                                , PRIMARY KEY (nCdLog)
                                );

CREATE TABLE table_log.Empresa ( nCdLog            BIGSERIAL
							   , nCdEmpresa        BIGINT       NOT NULL 
                               , cNmEmpresa        VARCHAR(255) NOT NULL
                               , cSgEmpresa        VARCHAR(3)   NOT NULL
                               , cCNPJ             VARCHAR(18)  NOT NULL 
                               , cTelefone         VARCHAR(255) NOT NULL 
                               , cEmail            VARCHAR(255) NOT NULL 
                               , cCEP              VARCHAR(255) NOT NULL
                               , nCdPlanoPagamento BIGINT       NOT NULL
                               , bAtivo            BOOLEAN      NOT NULL 
                               , cOperacao         VARCHAR(50)
                               , dOperacao         TIMESTAMP              					
                               , PRIMARY KEY (nCdLog)
                               );

CREATE TABLE table_log.PlanoVantagens ( nCdLog           BIGSERIAL
									  , nCdPlanoVantagem BIGINT       NOT NULL 
                                      , nCdPlano         BIGINT       NOT NULL
                                      , nCdVantagem      BIGINT       NOT NULL
                                      , cNmVantagem      VARCHAR(100) NOT NULL 
                                      , cDescricao       VARCHAR(255) NOT NULL
                                      , cOperacao        VARCHAR(50)
                                      , dOperacao        TIMESTAMP              
                                      , PRIMARY KEY (nCdLog)
                                      );
									
CREATE TABLE table_log.Habilidade ( nCdLog        BIGSERIAL
								  , nCdHabilidade BIGINT       NOT NULL 
                                  , nCdEmpresa    BIGINT       NOT NULL
                                  , cNmHabilidade VARCHAR(255) NOT NULL
                                  , cDescricao    VARCHAR(255) NOT NULL
                                  , cOperacao     VARCHAR(50)
                                  , dOperacao     TIMESTAMP              									 
                                  , PRIMARY KEY (nCdLog)
                                  );

CREATE TABLE table_log.Setor ( nCdLog        BIGSERIAL
							 , nCdSetor      BIGINT       NOT NULL 
                             , nCdEmpresa    BIGINT       NOT NULL
                             , cNmSetor      VARCHAR(255) NOT NULL
                             , cSgSetor      VARCHAR(3)   NOT NULL
                             , cOperacao     VARCHAR(50)
                             , dOperacao     TIMESTAMP              			
                             , PRIMARY KEY (nCdLog)
                             );

CREATE TABLE table_log.Usuario ( nCdLog        BIGSERIAL
							   , nCdUsuario    BIGINT       NOT NULL 
                               , cNmUsuario    VARCHAR(100) NOT NULL
                               , cSbrUsuario   VARCHAR(255) NOT NULL
                               , cSgUsuario    VARCHAR(50)      NULL
                               , nCdGestor     BIGINT           NULL
                               , bGestor       BOOLEAN      NOT NULL
                               , nCdEmpresa    BIGINT       NOT NULL
                               , nCdSetor      BIGINT       NOT NULL
                               , nCPF          VARCHAR(15)  NOT NULL
                               , cTelefone     VARCHAR(20)      NULL
                               , cEmail        VARCHAR(255)     NULL
                               , cSenha        VARCHAR(50)  NOT NULL 
                               , cFoto         VARCHAR          NULL
                               , bAtivo        BOOLEAN      NOT NULL 
                               , cOperacao     VARCHAR(50)
                               , dOperacao     TIMESTAMP              											  
                               , PRIMARY KEY (nCdLog)
                               , UNIQUE (nCdUsuario)
                               );

CREATE TABLE table_log.HabilidadeUsuario ( nCdLog        BIGSERIAL
	                                     , nCdHabilidade BIGINT NOT NULL
                                         , nCdUsuario    BIGINT NOT NULL
                                         , cOperacao     VARCHAR(50)
                                         , dOperacao     TIMESTAMP     
                                         , PRIMARY KEY (nCdLog)
                                         );
									
CREATE TABLE table_log.Tarefa ( nCdLog            BIGSERIAL
							  , nCdTarefa         BIGINT       NOT NULL
                              , cNmTarefa         VARCHAR(255) NOT NULL
                              , nCdUsuarioRelator BIGINT       NOT NULL
                              , nCdHabilidade     BIGINT       NOT NULL
                              , iGravidade        INTEGER      NOT NULL
                              , iUrgencia         INTEGER      NOT NULL
                              , iTendencia        INTEGER      NOT NULL
                              , nTempoEstimado    BIGINT       NOT NULL
                              , cDescricao        VARCHAR(255) NOT NULL
                              , cStatus           VARCHAR(15)  NOT NULL 
                              , cOperacao         VARCHAR(50)
                              , dOperacao         TIMESTAMP              														 
                              , PRIMARY KEY (nCdLog)
                              );

CREATE TABLE table_log.AtribuicaoTarefa ( nCdLog
	                                    , nCdLogAtribuicao  BIGINT NOT NULL 
                                        , nCdTarefa         BIGINT NOT NULL
                                        , nCdUsuarioAtuante BIGINT NOT NULL
                                        , dRealocacao       DATE   NOT NULL 
                                        , cOperacao         VARCHAR(50)
                                        , dOperacao         TIMESTAMP              		  
                                        , PRIMARY KEY (nCdLogAtribuicao)
                                        );

CREATE TABLE table_log.Report ( nCdLog        BIGSERIAL
							  , nCdReport     BIGINT       NOT NULL 
                              , nCdTarefa     BIGINT       NOT NULL
                              , cDescricao    VARCHAR(255) NOT NULL
                              , cProblema     VARCHAR(255) NOT NULL
                              , cOperacao     VARCHAR(50)
                              , dOperacao     TIMESTAMP              													 
                              , PRIMARY KEY (nCdLog)
                              );

CREATE TABLE table_log.TarefaHabilidade ( nCdLog              BIGSERIAL
										, nCdTarefaHabilidade BIGINT  NOT NULL
										, nCdHabilidade       BIGINT  NOT NULL
                                        , nCdTarefa           BIGINT  NOT NULL
                                        , iPrioridade         INTEGER NOT NULL
                                        , cOperacao           VARCHAR(50)
                                        , dOperacao           TIMESTAMP   													   
                                        , PRIMARY KEY (nCdLog)
                                        );

CREATE TABLE table_log.TarefaUsuario ( nCdLog             BIGSERIAL
									 , nCdTarefaUsuario   BIGINT NOT NULL 
									 , nCdTarefa          BIGINT NOT NULL
                                     , nCdUsuarioOriginal BIGINT NOT NULL
                                     , nCdUsuarioAtuante  BIGINT NOT NULL
                                     , cOperacao          VARCHAR(50)
                                     , dOperacao          TIMESTAMP     																		
                                     , PRIMARY KEY (nCdLog)
                                     );									
