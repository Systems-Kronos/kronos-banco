import random
from datetime import timedelta
import time
from decimal import Decimal

# Importações de Bibliotecas
import psycopg2
from psycopg2.extras import execute_values
from faker import Faker
import bcrypt 
import os
from dotenv import load_dotenv
import pandas as pd 

load_dotenv() 

# Configuração de Conexão: Lida pelo executaBanco.py
DB_URL = os.getenv("DATA_LOAD_DB_URL")
if not DB_URL:
    raise Exception("Variável de ambiente DATA_LOAD_DB_URL não encontrada.")

# Constantes de Geração
NUM_PLANOS = 5
NUM_CARGOS = 25
NUM_EMPRESAS = 50
SECTORS_PER_EMPRESA = 2
USUARIOS_POR_EMPRESA = 10
NUM_HABILIDADES = 50
TAREFAS_POR_USUARIO = 5

SENHA_PADRAO = "senha123" 
BCRYPT_ROUNDS = 12 
BATCH_SIZE = 500
MAX_RETRIES = 3 

# Dados de Exemplo (Mantidos para a geração aleatória)
SETOR_NOMES = [
    "Corte Primário", "Desossa", "Embalagem", "Controle de Frio",
    "Sala de Máquinas", "Manutenção Industrial", "PCP (Planejamento e Controle da Produção)",
    "Controle de Qualidade", "Expedição e Logística", "P&D (Pesquisa e Desenvolvimento)"
]
CARGOS_INDUSTRIAIS = [
    "Operador de Desossa", "Técnico de Manutenção Mecânica", "Eletricista Industrial",
    "Inspetor Sanitário", "Analista de Qualidade (CQ)", "Supervisor de Produção",
    "Auxiliar de Limpeza Técnica", "Ajudante de Carga/Descarga", "Coordenador de PCP",
    "Engenheiro de Processos", "Operador de Abate", "Analista de Sustentabilidade"
]
HABILIDADES_INDUSTRIAIS = [
    "Primeiros Socorros", "Segurança em Máquinas (NR-12)", "Trabalho em Altura (NR-35)",
    "Espaço Confinado (NR-33)", "Segurança com Eletricidade (NR-10)", "Operação de Caldeiras e Vasos de Pressão (NR-13)",
    "Prevenção e Combate a Incêndio (NR-23)", "Uso e Conservação de EPIs", "LOTO (Lockout/Tagout - Bloqueio e Etiquetagem)",
    "Análise Preliminar de Risco (APR)", "Conhecimento ISO 14001 (Gestão Ambiental)", "Conhecimento ISO 45001 (Gestão de Saúde e Segurança)",
    "Gestão de Resíduos Industriais", "HACCP (APPCC - Análise de Perigos e Pontos Críticos de Controle)", "Boas Práticas de Fabricação (BPF / GMP)",
    "Conhecimento ISO 9001 (Gestão da Qualidade)", "Calibração de Balanças", "Controle de Temperatura (Processo e Armazenamento)",
    "Metodologia 5S", "CEP (Controle Estatístico de Processo)", "Ferramentas da Qualidade (Ishikawa, Pareto, 5 Porquês)",
    "Auditoria Interna (Qualidade ou Segurança de Alimentos)", "Boas Práticas de Laboratório (BPL)", "Análise Físico-Química",
    "Análise Microbiológica", "Gestão de Não Conformidades e Ações Corretivas", "Controle Integrado de Pragas",
    "Leitura de Diagramas Elétricos", "Leitura e Interpretação de Desenho Técnico Mecânico", "Manutenção Preventiva",
    "Manutenção Preditiva (Ex: Termografia, Análise de Vibração)", "Manutenção Corretiva", "Conhecimento em Hidráulica Industrial",
    "Conhecimento em Pneumática Industrial", "Programação de CLP (Nível Básico)", "Soldagem (Elétrica, MIG, TIG)",
    "Lubrificação Industrial", "Alinhamento de Máquinas (Laser ou Relógio Comparador)", "Manuseio de Faca",
    "Operação de Máquinas Específicas (Ex: Envasadoras, Prensas)", "Saneamento e Higienização Industrial", "Lean Manufacturing (Manufatura Enxuta)",
    "Cronoanálise (Estudo de Tempos e Métodos)", "Metodologia PDCA / MASP", "Operação de Empilhadeira (NR-11)",
    "Operação de Ponte Rolante (NR-11)", "Operação de Paleteira (Manual ou Elétrica)", "Gestão de Estoque (FIFO / FEFO)",
    "Planejamento e Controle da Produção (PCP)", "Conhecimento em Software ERP (Ex: SAP, TOTVS - Módulo Industrial)"
]
HABILIDADE_DESCRICOES = [ 
    "Capacidade de aplicar análise de perigos e pontos críticos de controle.", "Conhecimento em regulamentos de higiene e manipulação de alimentos.", 
    "Proficiência no uso de ferramentas de corte em linhas de produção.", "Entendimento dos requisitos da norma ISO para sistemas de gestão de qualidade.", 
    "Habilidade técnica para ajustar e validar equipamentos de pesagem.", "Conhecimento avançado em procedimentos de segurança para operadores de máquinas pesadas.", 
    "Domínio de sistemas de medição e registro de temperaturas críticas.", "Interpretação de esquemas elétricos e solução de problemas em painéis.", 
    "Treinamento certificado para atendimento a emergências e lesões no ambiente de trabalho."
]
TAREFAS_INDUSTRIAIS = [
    "Realizar Limpeza e Desinfecção de Esteira X", "Calibrar Termômetros da Câmara Fria #3",
    "Verificar Nível de Amônia no Sistema de Refrigeração", "Inspeção de Rotulagem de Lote 56/2025",
    "Auditoria de Rastreabilidade de Suínos", "Treinamento de EPIs para Novos Contratados",
    "Verificação da Pressão das Mangueiras de Vapor"
]
TAREFA_DESCRICOES = [
    "Procedimento operacional padrão (POP) 1.5. Utilize o produto químico Z para a desinfecção. Duração estimada: 45 min.",
    "Necessário o uso de kit de calibração mestre. Anexar o certificado de aferição após a conclusão do processo.",
    "Verificar os manômetros do compressor principal e registrar a leitura no formulário digital. Se a leitura > 100 PSI, acionar a manutenção.",
    "Revisar 100% das etiquetas aplicadas no Lote 56/2025 para garantir a conformidade com a data de validade e S.I.F.",
    "Rastrear a origem da matéria-prima (suínos) do Lote M-120 e verificar a documentação de chegada no sistema.",
    "Apresentação obrigatória para o novo grupo de 15 colaboradores. Foco no uso correto de luvas de malha de aço e capacetes.",
    "Checar se há desgaste excessivo ou vazamentos nas mangueiras do setor de cozimento. Preencher o check-list de manutenção preventiva."
]
PROBLEMAS_INDUSTRIAIS = [
    "Vazamento no Duto de Gás (Área de Manutenção)", "Falha Crítica na Etiquetadora automática",
    "Contaminação Cruzada - Alerta de Lote Suspeito", "Quebra Súbita na Linha de Produção Principal",
    "Problema de Congelamento na Câmara de Choque", "Documentação de Lote Incompleta"
]
REPORT_DESCRICOES = [ 
    "A mangueira de limpeza da sala de abate está com baixa pressão, dificultando a sanitização no turno.",
    "O sensor de temperatura do túnel de congelamento rápido está com leitura inconsistente. Necessita calibração urgente.",
    "Identificada presença de material estranho na embalagem secundária do produto. Lote deve ser retido.",
    "A máquina de corte 4 apresentou ruído alto e parou completamente. A correia principal parece estar rompida.",
    "O estoque de insumos químicos para higienização está abaixo do nível de segurança. Requer reposição imediata.",
    "Foi notada uma poça de óleo hidráulico perto da empilhadeira #2 na área de expedição. Risco de escorregamento.",
    "O colaborador 'José da Silva' não utilizou o capacete de segurança ao entrar na área de manutenção. Orientação necessária."
]
VANTAGENS_INDUSTRIAIS = [
    "Módulo avançado de rastreabilidade de lotes de matéria-prima até o produto final.", "Acesso a relatórios de não-conformidade e desvios de BPF em tempo real.",
    "Ferramenta de cálculo de OEE (Eficiência Global do Equipamento) por linha de produção.", "Geração automática de ordens de serviço para manutenção corretiva e preventiva.",
    "Biblioteca completa de check-lists de inspeção de segurança NR-12 para máquinas.", "Dashboard de monitoramento da vida útil de ativos e agendamento preditivo de peças.",
    "Suporte prioritário 24/7 para paralisações críticas na linha de abate ou envase.", "Integração com sistemas ERP para controle de inventário e insumos de estoque.",
    "Análise de gargalos no fluxo de expedição e otimização de rotas internas.", "Gerenciamento de certificações sanitárias (S.I.F., HACCP) e datas de validade.",
    "Funcionalidade de treinamento digital para novos operadores de empilhadeira."
]

fake = Faker("pt_BR")

GLOBAL_DATA = {
    'PlanoPagamento': [], 'Cargo': [], 'Empresa': [], 'Setor': [], 'Usuario': [],
    'Habilidade': [], 'Tarefa': [], 'EmpresaGestorMap': {}, 'UsuariosByEmpresa': {},
    'VantagensUsadas': set(), 'GestorIDs': [] 
}

def connect_db():
    try:
        conn = psycopg2.connect(DB_URL)
        return conn
    except Exception as e:
        print(f"Erro ao conectar ao banco de dados: {e}")
        return None
    
def bulk_insert_execute_values(conn, table_name_camel, columns_camel, data, schema='public'):
    if not data: return 0
    full_table_name = f"{schema}.{table_name_camel.lower()}"
    quoted_cols = ','.join(c.lower() for c in columns_camel)
    sql = f"INSERT INTO {full_table_name} ({quoted_cols}) VALUES %s"
    rows_inserted = 0
    for attempt in range(MAX_RETRIES):
        try:
            with conn.cursor() as cur:
                execute_values(cur, sql, data, page_size=BATCH_SIZE)
            conn.commit()
            return cur.rowcount
        except psycopg2.Error as e:
            if e.pgcode and e.pgcode.startswith('40'):
                conn.rollback()
                wait_time = 2 ** attempt
                print(f"   [ATENÇÃO] Deadlock/Erro transiente no INSERT em {full_table_name}. Tentando novamente em {wait_time}s...")
                time.sleep(wait_time)
            else:
                conn.rollback()
                print(f"   [ERRO] Falha no INSERT em {full_table_name}: {e}")
                return 0
        except Exception as e:
            conn.rollback()
            print(f"   [ERRO] Falha inesperada no INSERT em {full_table_name}: {e}")
            return 0
    return 0
    
def importar_cargos_cbo():
    try:
        # A leitura de CSVs foi removida para simplificar o código, assumindo que os dados são gerados
        return []
    except Exception:
        return []


def generate_planos(conn):
    print("\n[1/12] Gerando PlanoPagamento...")
    planos_data = []
    # PK nCdPlano é gerada pelo banco
    for _ in range(NUM_PLANOS):
        planos_data.append((fake.unique.word().title() + " Premium", Decimal(random.uniform(99.90, 499.90)).quantize(Decimal('0.01'))))
    
    cols = ("cNmPlano", "nPreco") 
    bulk_insert_execute_values(conn, "PlanoPagamento", cols, planos_data)
    
    # Coleta IDs gerados
    with conn.cursor() as cur:
        cur.execute("SELECT nCdPlano FROM public.planopagamento ORDER BY nCdPlano")
        GLOBAL_DATA['PlanoPagamento'] = [row[0] for row in cur.fetchall()]


def generate_cargos(conn):
    print("\n[2/12] Gerando Cargo...")
    cargos_data_sample = []
    cargos_usados = set()
    while len(cargos_data_sample) < NUM_CARGOS and len(cargos_usados) < len(CARGOS_INDUSTRIAIS):
        cargo_nome = random.choice(CARGOS_INDUSTRIAIS)
        if cargo_nome not in cargos_usados:
            cargos_data_sample.append((cargo_nome, fake.unique.numerify(text='####-##'), fake.catch_phrase().title()))
            cargos_usados.add(cargo_nome)

    cols = ("cNmCargo", "cCdCBO", "cNmFamiliaOcupacional") 
    bulk_insert_execute_values(conn, "Cargo", cols, cargos_data_sample)
    
    cbo_data_to_insert = importar_cargos_cbo()
    if cbo_data_to_insert:
        cols_cbo = ("cNmCargo", "cCdCBO", "cNmFamiliaOcupacional") 
        bulk_insert_execute_values(conn, "Cargo", cols_cbo, cbo_data_to_insert)

    with conn.cursor() as cur:
        cur.execute("SELECT nCdCargo FROM public.cargo ORDER BY nCdCargo")
        GLOBAL_DATA['Cargo'] = [row[0] for row in cur.fetchall()]
    
    if not GLOBAL_DATA['Cargo']: raise Exception("Nenhum cargo inserido.")

# Gera número de telefone formatado "(XX) 9XXXX-XXXX"
def telefone_formatado():
    ddd = random.randint(11, 99)
    
    numero = f"9{random.randint(1000_000, 9999_999)}"
    
    return f"({ddd}) {numero[:5]}-{numero[4:]}"

def generate_empresas(conn):
    print("\n[3/12] Gerando Empresa...")
    empresas_data = []
    planos = GLOBAL_DATA['PlanoPagamento']

    for _ in range(NUM_EMPRESAS):
        plano_id = random.choice(planos)
        nome_empresa = fake.unique.company() + " Industrial Ltda."
        empresas_data.append((nome_empresa, fake.unique.lexify(text='???').upper(), fake.unique.cnpj(), telefone_formatado(), fake.unique.company_email(), fake.postcode(), plano_id, True))

    cols = ("cNmEmpresa", "cSgEmpresa", "cCNPJ", "cTelefone", "cEmail", "cCEP", "nCdPlanoPagamento", "bAtivo") 
    bulk_insert_execute_values(conn, "Empresa", cols, empresas_data)

    # Coleta IDs gerados
    with conn.cursor() as cur:
        cur.execute("SELECT nCdEmpresa FROM public.empresa ORDER BY nCdEmpresa")
        GLOBAL_DATA['Empresa'] = [row[0] for row in cur.fetchall()]
        for emp_id in GLOBAL_DATA['Empresa']: GLOBAL_DATA['UsuariosByEmpresa'][emp_id] = []


def generate_planovantagens(conn):
    print("\n[4/12] Gerando PlanoVantagem...")
    vantagens_data = []
    planos = GLOBAL_DATA['PlanoPagamento']

    for plano_id in planos:
        vantagens_para_plano = random.sample(VANTAGENS_INDUSTRIAIS, k=random.randint(2, 5))
        for descricao_coesa in vantagens_para_plano:
            nome_vantagem_base = descricao_coesa.split(' para ')[0].split(' de ')[0].split(' e ')[0].replace('.', '').strip()
            nome_final = nome_vantagem_base
            counter = 1
            while nome_final in GLOBAL_DATA['VantagensUsadas']:
                nome_final = f"{nome_vantagem_base} {counter}"
                counter += 1
            GLOBAL_DATA['VantagensUsadas'].add(nome_final)
            
            # Agora o banco gera o ID automaticamente
            vantagens_data.append((plano_id, nome_final, descricao_coesa))
            
    cols = ("nCdPlano", "cNmVantagem", "cDescricao")
    bulk_insert_execute_values(conn, "PlanoVantagem", cols, vantagens_data)

    # Coleta IDs gerados automaticamente pelo banco
    with conn.cursor() as cur:
        cur.execute("SELECT nCdPlanoVantagem FROM public.planovantagem ORDER BY nCdPlanoVantagem")
        GLOBAL_DATA['PlanoVantagem'] = [row[0] for row in cur.fetchall()]



def generate_setores(conn):
    print("\n[5/12] Gerando Setor...")
    setores_data = []
    # nCdSetor é gerado pelo banco
    for empresa_id in GLOBAL_DATA['Empresa']:
        setores_para_empresa = random.sample(SETOR_NOMES, k=SECTORS_PER_EMPRESA)
        for setor_nome in setores_para_empresa:
            setores_data.append((empresa_id, setor_nome, setor_nome[:2].upper() + fake.lexify(text='?').upper()))
    
    cols = ("nCdEmpresa", "cNmSetor", "cSgSetor") 
    bulk_insert_execute_values(conn, "Setor", cols, setores_data)

    # Coleta IDs gerados
    with conn.cursor() as cur:
        cur.execute("SELECT nCdSetor, nCdEmpresa FROM public.setor ORDER BY nCdSetor")
        GLOBAL_DATA['Setor'] = [row[0] for row in cur.fetchall()]


def generate_usuarios(conn):
    print("\n[6/12] Gerando Usuario...")
    usuarios_data = []
    # nCdUsuario é gerado pelo banco
    setores_por_empresa = {}
    with conn.cursor() as cur:
        cur.execute("SELECT ncdsetor, ncdempresa FROM public.setor ORDER BY ncdempresa")
        for setor_id, empresa_id in cur.fetchall(): setores_por_empresa.setdefault(empresa_id, []).append(setor_id)
        
    cargos = GLOBAL_DATA['Cargo']
    
    # Passagem 1: Criação de dados temporários e preenchimento com NULL para FK Gestor
    for empresa_id in GLOBAL_DATA['Empresa']:
        setores = setores_por_empresa.get(empresa_id, [])
        if not setores: continue
        
        for i in range(USUARIOS_POR_EMPRESA):
            is_gestor = (i == 0)
            ncd_setor = random.choice(setores)
            ncd_cargo = random.choice(cargos)
            senha_bytes = SENHA_PADRAO.encode('utf-8')
            hash_bcrypt = bcrypt.hashpw(senha_bytes, bcrypt.gensalt(rounds=BCRYPT_ROUNDS)).decode('utf-8')
            # nCdUsuario (PK) e nCdGestor (FK) são NULL no insert
            usuarios_data.append((fake.name(), None, is_gestor, empresa_id, ncd_setor, ncd_cargo, fake.unique.cpf(), telefone_formatado(), fake.unique.email(), hash_bcrypt, "", True))

    cols = ("cNmUsuario", "nCdGestor", "bGestor", "nCdEmpresa", "nCdSetor", "nCdCargo", "cCPF", "cTelefone", "cEmail", "cSenha", "cFoto", "bAtivo") 
    
    # Passagem 2: Insere e coleta IDs reais
    inserted_user_ids = []
    with conn.cursor() as cur:
        cols_insert = [c.lower() for c in cols]
        sql = f"INSERT INTO public.usuario ({','.join(cols_insert)}) VALUES %s RETURNING ncdusuario, bgestor, ncdempresa"
        execute_values(cur, sql, usuarios_data, page_size=BATCH_SIZE)
        inserted_user_ids = cur.fetchall()
    conn.commit()

    # Passagem 3: Atualiza nCdGestor e coleta GLOBAL_DATA
    gestor_map = {}
    usuarios_update_fk = []
    for u_id, is_gestor, emp_id in inserted_user_ids:
        if is_gestor: gestor_map[emp_id] = u_id
        GLOBAL_DATA['Usuario'].append(u_id)
        GLOBAL_DATA['UsuariosByEmpresa'][emp_id].append(u_id)
        if is_gestor: GLOBAL_DATA['GestorIDs'].append(u_id)

    # Coleta usuários que precisam de FK (aqueles que não são gestores)
    with conn.cursor() as cur:
        cur.execute("SELECT nCdUsuario, nCdEmpresa FROM public.usuario WHERE bGestor = FALSE")
        for u_id, emp_id in cur.fetchall():
            if emp_id in gestor_map:
                usuarios_update_fk.append((gestor_map[emp_id], u_id))
    
    # Executa o UPDATE
    if usuarios_update_fk:
        with conn.cursor() as cur:
            execute_values(cur, "UPDATE public.usuario SET nCdGestor = data.gestor_id FROM (VALUES %s) AS data(gestor_id, user_id) WHERE usuario.nCdUsuario = data.user_id", usuarios_update_fk)
        conn.commit()


def generate_habilidades(conn):
    print("\n[7/12] Gerando Habilidade...")
    habilidades_data = []
    # nCdHabilidade é gerado pelo banco
    habilidades_disponiveis = HABILIDADES_INDUSTRIAIS.copy()
    descricoes_disponiveis = HABILIDADE_DESCRICOES.copy()

    for hab_nome in random.sample(habilidades_disponiveis, k=min(random.randint(NUM_HABILIDADES, NUM_HABILIDADES + 2), len(habilidades_disponiveis))):
        habilidades_data.append((hab_nome, random.choice(descricoes_disponiveis)))
    
    cols = ("cNmHabilidade", "cDescricao") 
    bulk_insert_execute_values(conn, "Habilidade", cols, habilidades_data)

    # Coleta IDs gerados
    with conn.cursor() as cur:
        cur.execute("SELECT nCdHabilidade FROM public.habilidade ORDER BY nCdHabilidade")
        for row in cur.fetchall():
            GLOBAL_DATA['Habilidade'].append(row[0])

def generate_habilidade_usuario(conn):
    print("\n[8/12] Gerando HabilidadeUsuario...")
    habilidade_usuario_data = set()
    # nCdHabilidadeUsuario é gerado pelo banco
    
    all_habilidade_ids = GLOBAL_DATA['Habilidade']
    
    if not all_habilidade_ids:
        print("   [AVISO] Nenhuma habilidade global foi carregada. Pulando HabilidadeUsuario.")
        return

    # Itera sobre os usuários de cada empresa
    for empresa_id, usuario_ids in GLOBAL_DATA['UsuariosByEmpresa'].items():
        
        for user_id in usuario_ids:
            num_habilidades = random.randint(1, 3)
            for hab_id in random.sample(all_habilidade_ids, k=min(num_habilidades, len(all_habilidade_ids))):
                habilidade_usuario_data.add((hab_id, user_id))

    habilidade_usuario_list = [t for t in habilidade_usuario_data]
    
    cols = ("nCdHabilidade", "nCdUsuario") 
    bulk_insert_execute_values(conn, "HabilidadeUsuario", cols, habilidade_usuario_list)


def generate_tarefas(conn):
    print("\n[9/12] Gerando Tarefa...")
    tarefas_data = []
    # nCdTarefa é gerado pelo banco
    gestor_ids = GLOBAL_DATA['GestorIDs'] 
    
    if not gestor_ids: return []
    
    total_tarefas = len(GLOBAL_DATA['Usuario']) * TAREFAS_POR_USUARIO
    
    for _ in range(total_tarefas):
        relator_id = random.choice(gestor_ids) 
        data_atribuicao = fake.date_time_between(start_date='-90d', end_date='now', tzinfo=None)
        status = random.choice(['Pendente','Em Andamento','Concluída','Cancelada']) 
        data_conclusao = None
        data_prazo = data_atribuicao + timedelta(days=random.randint(1, 30))

        if status in ['Concluída', 'Cancelada']: data_conclusao = data_atribuicao + timedelta(days=random.randint(1, 30), hours=random.randint(1, 10))

        tarefas_data.append((random.choice(TAREFAS_INDUSTRIAIS), relator_id, random.randint(1, 5), random.randint(1, 5), random.randint(1, 5), random.randint(5, 240), random.choice(TAREFA_DESCRICOES), status, data_atribuicao, data_prazo, data_conclusao))
    
    cols = ("cNmTarefa", "nCdUsuarioRelator", "iGravidade", "iUrgencia", "iTendencia", "iTempoEstimado", "cDescricao", "cStatus", "dDataAtribuicao", "dDataPrazo","dDataConclusao") 
    bulk_insert_execute_values(conn, "Tarefa", cols, tarefas_data)
    
    # Coleta IDs gerados
    with conn.cursor() as cur:
        cur.execute("SELECT nCdTarefa FROM public.tarefa ORDER BY nCdTarefa")
        GLOBAL_DATA['Tarefa'] = [row[0] for row in cur.fetchall()]


def generate_tarefa_usuario(conn):
    print("\n[10/12] Gerando TarefaUsuario...")
    tarefa_usuario_data = set()
    all_user_ids = GLOBAL_DATA['Usuario']
    all_tarefa_ids = GLOBAL_DATA['Tarefa']

    if not all_tarefa_ids: return
        
    for tarefa_id in all_tarefa_ids:
        original_user = random.choice(GLOBAL_DATA['GestorIDs'])
        atuante_user = random.choice(all_user_ids)
        tarefa_usuario_data.add((tarefa_id, original_user, atuante_user))

    tarefa_usuario_list = [t for t in tarefa_usuario_data]
    
    cols = ("nCdTarefa", "nCdUsuarioOriginal", "nCdUsuarioAtuante") 
    bulk_insert_execute_values(conn, "TarefaUsuario", cols, tarefa_usuario_list)


def generate_tarefa_habilidade(conn):
    print("\n[11/12] Gerando TarefaHabilidade...")
    tarefa_habilidade_data = set()
    all_habilidade_ids = GLOBAL_DATA['Habilidade']
    all_tarefa_ids = GLOBAL_DATA['Tarefa']

    if not all_tarefa_ids or not all_habilidade_ids: return
        
    for tarefa_id in all_tarefa_ids:
        num_habilidades = random.randint(1, 3)
        for hab_id in random.sample(all_habilidade_ids, k=min(num_habilidades, len(all_habilidade_ids))):
            prioridade = random.randint(1, 5)
            tarefa_habilidade_data.add((hab_id, tarefa_id, prioridade))

    tarefa_habilidade_list = [t for t in tarefa_habilidade_data]
    
    cols = ("nCdHabilidade", "nCdTarefa", "iPrioridade") 
    bulk_insert_execute_values(conn, "TarefaHabilidade", cols, tarefa_habilidade_list)

def generate_reports(conn):
    print("\n[12/12] Gerando Report...")
    reports_data = []
    # nCdReport é gerado pelo banco
    all_tarefa_ids = GLOBAL_DATA['Tarefa']
    all_user_ids = GLOBAL_DATA['Usuario']

    if not all_tarefa_ids: return
        
    tarefas_com_report = random.sample(all_tarefa_ids, k=int(len(all_tarefa_ids) * 0.5))
    for tarefa_id in tarefas_com_report:
        reports_data.append((tarefa_id, random.choice(all_user_ids), random.choice(REPORT_DESCRICOES), random.choice(PROBLEMAS_INDUSTRIAIS), random.choice(['Pendente','Em Andamento','Concluído'])))

    cols = ("nCdTarefa", "nCdUsuario", "cDescricao", "cProblema", "cStatus") 
    bulk_insert_execute_values(conn, "Report", cols, reports_data)

if __name__ == "__main__":
    conn = connect_db()
    if not conn: exit(1)
    try:
        tables_to_truncate = [
            "public.Report", "public.TarefaHabilidade", "public.TarefaUsuario", "public.Tarefa",
            "public.HabilidadeUsuario", "public.Habilidade", "public.Usuario", "public.Setor",
            "public.PlanoVantagem", "public.Empresa", "public.Cargo", "public.PlanoPagamento"
        ]
        quoted_tables = [t.lower() for t in tables_to_truncate]
        print("\n[SETUP] Iniciando TRUNCATE de tabelas principais...")
        cur = conn.cursor()
        cur.execute(f"TRUNCATE TABLE {', '.join(quoted_tables)} RESTART IDENTITY CASCADE;")
        conn.commit()
        print("TRUNCATE de tabelas completado. Início do Data Load:")

        generate_planos(conn)
        generate_cargos(conn)
        generate_empresas(conn)
        generate_planovantagens(conn)
        generate_setores(conn)
        generate_usuarios(conn) 
        generate_habilidades(conn)
        generate_habilidade_usuario(conn)
        generate_tarefas(conn) 
        generate_tarefa_usuario(conn) 
        generate_tarefa_habilidade(conn)
        generate_reports(conn)
        print("\n=== Data Load Concluído com Sucesso! ===")

    except Exception as e:
        if conn: conn.rollback()
        print(f"\n[ERRO] Uma exceção não tratada ocorreu durante o dataload: {e}")
        exit(1)

    finally:
        if conn: conn.close()
        print("Fechando conexão com o banco de dados...")