-- Reset das tabelas e do esquema
DROP SCHEMA table_log CASCADE ;

-- Criação do SCHEMA table_log
CREATE SCHEMA table_log;

-- Criação das Tabelas
CREATE TABLE table_log.RegistroDAU ( nCdSessao           BIGSERIAL       NOT NULL
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
CREATE TABLE table_log.LogAtribuicaoTarefa ( nCdLogAtribuicao  BIGSERIAL     NOT NULL
                                           , nCdTarefa         BIGINT        NOT NULL
                                           , nCdUsuarioAtuante BIGINT        NOT NULL
                                           , dRealocacao       DATE          NOT NULL DEFAULT NOW()
                                           , cObservacao       VARCHAR(300)  NOT NULL DEFAULT 'Nenhum comentário para a Tarefa'
                                           , PRIMARY KEY (nCdLogAtribuicao)
                                           , FOREIGN KEY (nCdTarefa)         REFERENCES public.Tarefa (nCdTarefa)
                                           , FOREIGN KEY (nCdUsuarioAtuante) REFERENCES public.Usuario (nCdUsuario)
                                           );


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
                              , cStatus           OPCAO_STATUS NOT NULL
                              , cOperacao         VARCHAR(50)
                              , dOperacao         TIMESTAMP              														 
                              , PRIMARY KEY (nCdLog)
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
