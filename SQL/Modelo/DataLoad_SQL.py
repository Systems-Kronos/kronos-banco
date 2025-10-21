import random
from datetime import timedelta
import time
from decimal import Decimal

# Banco de dados
import psycopg2
from psycopg2.extras import execute_values
# Faker
from faker import Faker
# Criptografia de senhas
import bcrypt 
# Carregar variáveis de ambiente
import os
from dotenv import load_dotenv

load_dotenv() 

# URL do banco de dados para conexão
DB_URL = os.getenv("DATA_LOAD_DB_URL")

# Quantidades
NUM_PLANOS = 5
NUM_CARGOS = 25
NUM_EMPRESAS = 50
SECTORS_PER_EMPRESA = 2
USUARIOS_POR_EMPRESA = 10
HABILIDADES_POR_EMPRESA = 3
TAREFAS_POR_USUARIO = 5

SENHA_PADRAO = "senha123" # Senha padrão para todos os usuários (será criptografada)

BCRYPT_ROUNDS = 12 # Custo do bcrypt (padrão seguro é 12)

# Configurações do Bulk Insert (inserir em lote para melhorar performance) 
BATCH_SIZE = 500

# Máximo de tentativas em caso ocorra deadlock (duas ou mais transações se bloqueando, quando tentam acesssar os mesmos dados)
MAX_RETRIES = 3 

# Dados voltados para indústria alimentícia e manufatura
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
    "HACCP (APPCC)", "Boas Práticas de Fabricação (BPF)", "Manuseio de Faca",
    "Conhecimento ISO 9001", "Calibração de Balanças", "Segurança em Máquinas (NR-12)",
    "Controle de Temperatura", "Leitura de Diagramas Elétricos", "Primeiros Socorros"
]
HABILIDADE_DESCRICOES = [ 
    "Capacidade de aplicar análise de perigos e pontos críticos de controle.",
    "Conhecimento em regulamentos de higiene e manipulação de alimentos.",
    "Proficiência no uso de ferramentas de corte em linhas de produção.",
    "Entendimento dos requisitos da norma ISO para sistemas de gestão de qualidade.",
    "Habilidade técnica para ajustar e validar equipamentos de pesagem.",
    "Conhecimento avançado em procedimentos de segurança para operadores de máquinas pesadas.",
    "Domínio de sistemas de medição e registro de temperaturas críticas.",
    "Interpretação de esquemas elétricos e solução de problemas em painéis.",
    "Treinamento certificado para atendimento a emergências e lesões no ambiente de trabalho."
]
TAREFAS_INDUSTRIAIS = [
    "Realizar Limpeza e Desinfecção de Esteira X",
    "Calibrar Termômetros da Câmara Fria #3",
    "Verificar Nível de Amônia no Sistema de Refrigeração",
    "Inspeção de Rotulagem de Lote 56/2025",
    "Auditoria de Rastreabilidade de Suínos",
    "Treinamento de EPIs para Novos Contratados",
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
    "Vazamento no Duto de Gás (Área de Manutenção)",
    "Falha Crítica na Etiquetadora automática",
    "Contaminação Cruzada - Alerta de Lote Suspeito",
    "Quebra Súbita na Linha de Produção Principal",
    "Problema de Congelamento na Câmara de Choque",
    "Documentação de Lote Incompleta"
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
    "Módulo avançado de rastreabilidade de lotes de matéria-prima até o produto final.",
    "Acesso a relatórios de não-conformidade e desvios de BPF em tempo real.",
    "Ferramenta de cálculo de OEE (Eficiência Global do Equipamento) por linha de produção.",
    "Geração automática de ordens de serviço para manutenção corretiva e preventiva.",
    "Biblioteca completa de check-lists de inspeção de segurança NR-12 para máquinas.",
    "Dashboard de monitoramento da vida útil de ativos e agendamento preditivo de peças.",
    "Suporte prioritário 24/7 para paralisações críticas na linha de abate ou envase.",
    "Integração com sistemas ERP para controle de inventário e insumos de estoque.",
    "Análise de gargalos no fluxo de expedição e otimização de rotas internas.",
    "Gerenciamento de certificações sanitárias (S.I.F., HACCP) e datas de validade.",
    "Funcionalidade de treinamento digital para novos operadores de empilhadeira."
]

# Faker
fake = Faker("pt_BR")

# Armazenamento de IDs gerados para relacionamento (FKs)
GLOBAL_DATA = {
    'PlanoPagamento': [],
    'Cargo': [],
    'Empresa': [],
    'Setor': [],
    'Usuario': [],
    'Habilidade': [],
    'Tarefa': [],
    'EmpresaGestorMap': {}, 
    'UsuariosByEmpresa': {}, 
    'HabilidadesByEmpresa': {}, 
    'VantagensUsadas': set(), 
    'GestorIDs': [] 
}

# Conexão do banco 
def connect_db():
    try:
        conn = psycopg2.connect(DB_URL)
        return conn
    except Exception as e:
        print(f"Erro ao conectar ao banco de dados: {e}")
        return None
    
# Inserindo em lote para otimizar performance
def bulk_insert_execute_values(conn, table_name_camel, columns_camel, data, schema='public'):
    if not data:
        return 0
    
    # Converte o nome da tabela para minúsculo (default do PostgreSQL)
    full_table_name = f"{schema}.{table_name_camel.lower()}"

    # Converte os nomes das colunas para minúsculo e sem aspas
    quoted_cols = ','.join(c.lower() for c in columns_camel)
    sql = f"INSERT INTO {full_table_name} ({quoted_cols}) VALUES %s"
    rows_inserted = 0

    # Tentativas
    for attempt in range(MAX_RETRIES):
        try:
            with conn.cursor() as cur:
                execute_values(cur, sql, data, page_size=BATCH_SIZE)
                rows_inserted = cur.rowcount
            conn.commit()
            return rows_inserted
        except psycopg2.Error as e:
            # Detecta deadlocks ou erros (código SQLSTATE 40xxx)
            if e.pgcode and e.pgcode.startswith('40'):
                conn.rollback()
                wait_time = 2 ** attempt
                print(f"  [ATENÇÃO] Deadlock/Erro transiente no INSERT em {full_table_name}. Tentando novamente em {wait_time}s...")
                time.sleep(wait_time)
            else:
                conn.rollback()
                print(f"  [ERRO] Falha no INSERT em {full_table_name}: {e}")
                return 0
        except Exception as e:
            conn.rollback()
            print(f"  [ERRO] Falha inesperada no INSERT em {full_table_name}: {e}")
            return 0
    print(f"  [ERRO FINAL] Falha após {MAX_RETRIES} tentativas em {full_table_name}.")
    return 0

# Funções de Geração de Dados (IDs gerados em Python para rastreamento de FK) 
def generate_planos(conn):
    print("\n[1/12] Gerando PlanoPagamento...")
    planos_data = []
    current_id = 1
    for _ in range(NUM_PLANOS):
        # Colunas: (nCdPlano, cNmPlano, nPreco)
        planos_data.append((
            current_id,
            fake.unique.word().title() + " Premium",
            Decimal(random.uniform(99.90, 499.90)).quantize(Decimal('0.01'))
        ))
        GLOBAL_DATA['PlanoPagamento'].append(current_id)
        current_id += 1

    cols = ("nCdPlano", "cNmPlano", "nPreco")
    rows_inserted = bulk_insert_execute_values(conn, "PlanoPagamento", cols, planos_data)
    print(f"  -> {rows_inserted} Planos de Pagamento inseridos em public.PlanoPagamento.")
def generate_cargos(conn):
    print("\n[2/12] Gerando Cargo...")
    cargos_data = []
    current_id = 1
    cargos_usados = set()

    while len(cargos_usados) < NUM_CARGOS and len(cargos_usados) < len(CARGOS_INDUSTRIAIS):
        cargo_nome = random.choice(CARGOS_INDUSTRIAIS)
        if cargo_nome not in cargos_usados:
            cargos_data.append((
                current_id,
                cargo_nome,
                fake.unique.numerify(text='####-##'),
                fake.catch_phrase().title()
            ))
            cargos_usados.add(cargo_nome)
            GLOBAL_DATA['Cargo'].append(current_id)
            current_id += 1

    # Se a lista customizada for menor que NUM_CARGOS, completar com nomes genéricos únicos
    while len(cargos_data) < NUM_CARGOS:
        cargo_nome = fake.unique.job()
        if cargo_nome not in cargos_usados:
            cargos_data.append((
                current_id,
                cargo_nome,
                fake.unique.numerify(text='####-##'),
                fake.catch_phrase().title()
            ))
            GLOBAL_DATA['Cargo'].append(current_id)
            current_id += 1

    cols = ("nCdCargo", "cNmCargo", "cCdCBO", "cNmFamiliaOcupacional")
    rows_inserted = bulk_insert_execute_values(conn, "Cargo", cols, cargos_data)
    print(f"  -> {rows_inserted} Cargos inseridos em public.Cargo.")

def generate_empresas(conn):
    print("\n[3/12] Gerando Empresa...")
    empresas_data = []
    current_id = 1
    planos = GLOBAL_DATA['PlanoPagamento']

    for _ in range(NUM_EMPRESAS):
        # Colunas: (nCdEmpresa, cNmEmpresa, cSgEmpresa, cCNPJ, cTelefone, cEmail, cCEP, nCdPlanoPagamento, bAtivo)
        plano_id = random.choice(planos)
        # Gerando nomes de empresas com foco alimentício/industrial
        nome_empresa = fake.unique.company() + " Alimentos S.A." if random.random() < 0.6 else fake.unique.company() + " Industrial Ltda."
        empresas_data.append((
            current_id,
            nome_empresa,
            fake.unique.lexify(text='???').upper(),
            fake.unique.cnpj(),
            fake.phone_number(),
            fake.unique.company_email(),
            fake.postcode(),
            plano_id,
            True
        ))

        GLOBAL_DATA['Empresa'].append(current_id)
        GLOBAL_DATA['UsuariosByEmpresa'][current_id] = [] # Inicializa o mapa de usuários
        current_id += 1

    cols = ("nCdEmpresa", "cNmEmpresa", "cSgEmpresa", "cCNPJ", "cTelefone", "cEmail", "cCEP", "nCdPlanoPagamento", "bAtivo")
    rows_inserted = bulk_insert_execute_values(conn, "Empresa", cols, empresas_data)
    print(f"  -> {rows_inserted} Empresas inseridas em public.Empresa.")

def generate_planovantagens(conn):
    print("\n[4/12] Gerando PlanoVantagem...")
    vantagens_data = []
    current_id = 1
    planos = GLOBAL_DATA['PlanoPagamento']
    
    for plano_id in planos:
        # Seleciona um conjunto de vantagens únicas para cada plano
        vantagens_para_plano = random.sample(VANTAGENS_INDUSTRIAIS, k=random.randint(2, 5))
        
        for descricao_coesa in vantagens_para_plano:
            # Usa a descrição para gerar o nome (simplificadando para tirar palavras desnecessárias)
            nome_vantagem_base = descricao_coesa.split(' para ')[0].split(' de ')[0].split(' e ')[0].replace('.', '').strip()
            
            nome_final = nome_vantagem_base
            counter = 1
            
            # Garante que o nome final seja único na tabela inteira
            while nome_final in GLOBAL_DATA['VantagensUsadas']:
                nome_final = f"{nome_vantagem_base} {counter}"
                counter += 1
            
            GLOBAL_DATA['VantagensUsadas'].add(nome_final) # Adiciona o nome único ao rastreamento global
            
            # Colunas: (nCdPlano, nCdPlanoVantagem, cNmVantagem, cDescricao)
            vantagens_data.append((
                plano_id,
                current_id,
                nome_final, 
                descricao_coesa
            ))
            current_id += 1
            
    cols = ("nCdPlano", "nCdPlanoVantagem", "cNmVantagem", "cDescricao")
    rows_inserted = bulk_insert_execute_values(conn, "PlanoVantagem", cols, vantagens_data)
    print(f"  -> {rows_inserted} Vantagens inseridas em public.PlanoVantagem.")

def generate_setores(conn):
    print("\n[5/12] Gerando Setor...")
    setores_data = []
    current_id = 1

    for empresa_id in GLOBAL_DATA['Empresa']:
        # Seleciona setores da lista customizada
        setores_para_empresa = random.sample(SETOR_NOMES, k=SECTORS_PER_EMPRESA)
        for setor_nome in setores_para_empresa:
            # Colunas: (nCdSetor, nCdEmpresa, cNmSetor, cSgSetor)
            setores_data.append((
                current_id,
                empresa_id,
                setor_nome,
                setor_nome[:2].upper() + fake.lexify(text='?').upper() # Sigla de 3 letras
            ))
            GLOBAL_DATA['Setor'].append(current_id)
            current_id += 1

    cols = ("nCdSetor", "nCdEmpresa", "cNmSetor", "cSgSetor")
    rows_inserted = bulk_insert_execute_values(conn, "Setor", cols, setores_data)
    print(f"  -> {rows_inserted} Setores inseridos em public.Setor.")

def generate_usuarios(conn):
    print("\n[6/12] Gerando Usuario...")
    usuarios_data = []
    current_id = 1
    # Lista de todos os setores para mapeamento rápido (Setor ID -> Empresa ID)
    setores_por_empresa = {}

    try:
        with conn.cursor() as cur:
            cur.execute("SELECT ncdsetor, ncdempresa FROM public.setor ORDER BY ncdempresa")
            setor_map = cur.fetchall()
            for setor_id, empresa_id in setor_map:
                setores_por_empresa.setdefault(empresa_id, []).append(setor_id)
    except Exception as e:
        print(f"  [ERRO] Falha ao buscar Setores para Usuarios: {e}")
        return
    cargos = GLOBAL_DATA['Cargo']

    for empresa_id in GLOBAL_DATA['Empresa']:
        setores = setores_por_empresa.get(empresa_id, [])
        if not setores:
            continue
        gestor_id = None
        for i in range(USUARIOS_POR_EMPRESA):
            is_gestor = (i == 0) # O primeiro usuário é o gestor
            ncd_setor = random.choice(setores)
            ncd_cargo = random.choice(cargos)

            # -- Criptografia da senha com bcrypt --

            # Deixando a senha em bytes (configuração padrão para o bcrypt conseguir processar)
            senha_bytes = SENHA_PADRAO.encode('utf-8')
            
            # Gera um Salt aleatório e único para essa senha
            # Define o custo (rounds=12), tornando o cálculo [2(12) < potência] vezes mais lento (e seguro)
            # Combina a senha + o salt + o custo e cria uma única string final
            hash_bcrypt = bcrypt.hashpw(senha_bytes, bcrypt.gensalt(rounds=BCRYPT_ROUNDS)).decode('utf-8')
            # .decode('utf-8') para armazenar como string no banco

            usuario = (
                current_id,
                fake.name(),
                gestor_id, 
                is_gestor,
                empresa_id,
                ncd_setor,
                ncd_cargo,
                fake.unique.cpf(),
                fake.phone_number(),
                fake.unique.email(),
                hash_bcrypt, # Senha criptografada
                "",  # Fotos devem ser atribuidas depois, para simplificar e otimizar
                True
            )

            usuarios_data.append(usuario)
            GLOBAL_DATA['Usuario'].append(current_id)
            GLOBAL_DATA['UsuariosByEmpresa'][empresa_id].append(current_id)

            if is_gestor:
                gestor_id = current_id
                GLOBAL_DATA['EmpresaGestorMap'][empresa_id] = gestor_id
                GLOBAL_DATA['GestorIDs'].append(current_id) 
            current_id += 1

    # Segunda passagem para preencher o nCdGestor
    final_usuarios_data = []
    for usuario in usuarios_data:
        u_id, name, gestor_fk, is_gestor, emp_id, setor_id, cargo_id, *rest = usuario
        final_gestor_id = None
        if not is_gestor:
            final_gestor_id = GLOBAL_DATA['EmpresaGestorMap'].get(emp_id)
        final_usuarios_data.append((u_id, name, final_gestor_id, is_gestor, emp_id, setor_id, cargo_id, *rest))

    cols = ("nCdUsuario", "cNmUsuario", "nCdGestor", "bGestor", "nCdEmpresa", "nCdSetor", "nCdCargo", "cCPF", "cTelefone", "cEmail", "cSenha", "cFoto", "bAtivo")
    rows_inserted = bulk_insert_execute_values(conn, "Usuario", cols, final_usuarios_data)
    print(f"  -> {rows_inserted} Usuários inseridos em public.Usuario.")

def generate_habilidades(conn):
    print("\n[7/12] Gerando Habilidade...")
    habilidades_data = []
    current_id = 1

    # Cria uma lista de habilidades a serem usadas para garantir a unicidade
    habilidades_disponiveis = HABILIDADES_INDUSTRIAIS.copy()
    descricoes_disponiveis = HABILIDADE_DESCRICOES.copy()

    for empresa_id in GLOBAL_DATA['Empresa']:
        GLOBAL_DATA['HabilidadesByEmpresa'][empresa_id] = []

        # Seleciona habilidades únicas para a empresa
        habilidades_da_empresa = random.sample(habilidades_disponiveis, k=min(random.randint(HABILIDADES_POR_EMPRESA, HABILIDADES_POR_EMPRESA + 2), len(habilidades_disponiveis)))

        for hab_nome in habilidades_da_empresa:
            # Colunas: (nCdHabilidade, nCdEmpresa, cNmHabilidade, cDescricao)
            habilidades_data.append((
                current_id,
                empresa_id,
                hab_nome, 
                random.choice(descricoes_disponiveis) 
            ))
            GLOBAL_DATA['Habilidade'].append(current_id)
            GLOBAL_DATA['HabilidadesByEmpresa'][empresa_id].append(current_id)
            current_id += 1

    cols = ("nCdHabilidade", "nCdEmpresa", "cNmHabilidade", "cDescricao")
    rows_inserted = bulk_insert_execute_values(conn, "Habilidade", cols, habilidades_data)
    print(f"  -> {rows_inserted} Habilidades inseridas em public.Habilidade.")

def generate_habilidade_usuario(conn):
    print("\n[8/12] Gerando HabilidadeUsuario...")
    habilidade_usuario_data = set() # Usar set para garantir tuplas únicas de (nCdHabilidade, nCdUsuario)

    for empresa_id, usuario_ids in GLOBAL_DATA['UsuariosByEmpresa'].items():
        habilidade_ids = GLOBAL_DATA['HabilidadesByEmpresa'].get(empresa_id, [])
        if not habilidade_ids:
            continue
        for user_id in usuario_ids:
            # Atribui 1 a 3 habilidades da própria empresa ao usuário
            num_habilidades = random.randint(1, 3)
            for hab_id in random.sample(habilidade_ids, k=min(num_habilidades, len(habilidade_ids))):
                habilidade_usuario_data.add((hab_id, user_id))

    # Convertendo set de tuplas para a lista de inserção
    habilidade_usuario_list = []
    current_id = 1
    
    for hab_id, user_id in habilidade_usuario_data:
        # Colunas: (nCdHabilidadeUsuario, nCdHabilidade, nCdUsuario)
        habilidade_usuario_list.append((current_id, hab_id, user_id))
        current_id += 1

    cols = ("nCdHabilidadeUsuario", "nCdHabilidade", "nCdUsuario")
    rows_inserted = bulk_insert_execute_values(conn, "HabilidadeUsuario", cols, habilidade_usuario_list)
    print(f"  -> {rows_inserted} Mapeamentos HabilidadeUsuario inseridos em public.HabilidadeUsuario.")

def generate_tarefas(conn):
    print("\n[9/12] Gerando Tarefa...")
    tarefas_data = []
    current_id = 1
    
    # Apenas gestores podem criar tarefas (configuração da trigger fn_validar_relator)
    gestor_ids = GLOBAL_DATA['GestorIDs'] 
    
    if not gestor_ids:
        print("  [ERRO LÓGICO] Nenhuma ID de Gestor encontrada. Pulando a geração de Tarefas.")
        return []
    
    # Calcular o número total de tarefas
    total_tarefas = len(GLOBAL_DATA['Usuario']) * TAREFAS_POR_USUARIO
    
    for _ in range(total_tarefas):
        # Seleciona um relator aleatório dentre os gestores
        relator_id = random.choice(gestor_ids) 
        data_atribuicao = fake.date_time_between(start_date='-90d', end_date='now', tzinfo=None)
        status = random.choice(['Pendente','Em Andamento','Concluída','Cancelada']) 
        data_conclusao = None
        data_prazo = data_atribuicao + timedelta(days=random.randint(1, 30))

        if status in ['Concluída', 'Cancelada']:
            # Data de conclusão deve ser posterior à atribuição
            data_conclusao = data_atribuicao + timedelta(days=random.randint(1, 30), hours=random.randint(1, 10))
        # Colunas: (nCdTarefa, cNmTarefa, nCdUsuarioRelator, iGravidade, iUrgencia, iTendencia, iTempoEstimado, cDescricao, cStatus, dDataAtribuicao, dDataPrazo, dDataConclusao)
        tarefas_data.append((
            current_id,
            random.choice(TAREFAS_INDUSTRIAIS), # Título da tarefa 
            relator_id, # AGORA É UM GESTOR
            random.randint(1, 5), # iGravidade
            random.randint(1, 5), # iUrgencia
            random.randint(1, 5), # iTendencia
            random.randint(1, 60), # iTempo Estimado (horas)
            random.choice(TAREFA_DESCRICOES), # cDescricao > Descrição das tarefas
            status,
            data_atribuicao,
            data_prazo,
            data_conclusao
        ))
        GLOBAL_DATA['Tarefa'].append(current_id)
        current_id += 1
        
    cols = ("nCdTarefa", "cNmTarefa", "nCdUsuarioRelator", "iGravidade", "iUrgencia", "iTendencia", "iTempoEstimado", "cDescricao", "cStatus", "dDataAtribuicao", "dDataPrazo","dDataConclusao")
    rows_inserted = bulk_insert_execute_values(conn, "Tarefa", cols, tarefas_data)
    print(f"  -> {rows_inserted} Tarefas inseridas em public.Tarefa.")
    return tarefas_data

def generate_tarefa_usuario(conn):
    print("\n[10/12] Gerando TarefaUsuario...")
    tarefa_usuario_data = set()
    all_user_ids = GLOBAL_DATA['Usuario']
    all_tarefa_ids = GLOBAL_DATA['Tarefa']

    # Aviso caso não gerar
    if not all_tarefa_ids:
        print("  [AVISO] Nenhuma Tarefa gerada, pulando TarefaUsuario.")
        return
        
    for tarefa_id in all_tarefa_ids:
        # Usuário Original (quem atribuiu - DEVE SER UM GESTOR - nCdUsuarioOriginal)
        original_user = random.choice(GLOBAL_DATA['GestorIDs'])
        # Usuário Atuante (quem está executando a tarefa- nCdUsuarioAtuante)
        atuante_user = random.choice(all_user_ids)
        tarefa_usuario_data.add((tarefa_id, original_user, atuante_user))

    tarefa_usuario_list = []
    current_id = 1

    for tarefa_id, original, atuante in tarefa_usuario_data:
        # Colunas: (nCdTarefaUsuario, nCdTarefa, nCdUsuarioOriginal, nCdUsuarioAtuante)
        tarefa_usuario_list.append((current_id, tarefa_id, original, atuante))
        current_id += 1

    cols = ("nCdTarefaUsuario", "nCdTarefa", "nCdUsuarioOriginal", "nCdUsuarioAtuante")
    rows_inserted = bulk_insert_execute_values(conn, "TarefaUsuario", cols, tarefa_usuario_list)
    print(f"  -> {rows_inserted} Mapeamentos TarefaUsuario inseridos em public.TarefaUsuario.")

def generate_tarefa_habilidade(conn):
    print("\n[11/12] Gerando TarefaHabilidade...")
    tarefa_habilidade_data = set()
    all_habilidade_ids = GLOBAL_DATA['Habilidade']
    all_tarefa_ids = GLOBAL_DATA['Tarefa']

    # Aviso caso não gerar
    if not all_tarefa_ids or not all_habilidade_ids:
        print("  [AVISO] Nenhuma Tarefa ou Habilidade gerada, pulando TarefaHabilidade.")
        return
        
    for tarefa_id in all_tarefa_ids:
        # Pelo menos 1 habilidade por tarefa ( pode ter mais )
        num_habilidades = random.randint(1, 3)
        for hab_id in random.sample(all_habilidade_ids, k=min(num_habilidades, len(all_habilidade_ids))):
            prioridade = random.randint(1, 5)
            tarefa_habilidade_data.add((hab_id, tarefa_id, prioridade))

    tarefa_habilidade_list = []
    current_id = 1

    for hab_id, tarefa_id, prioridade in tarefa_habilidade_data:
        # Colunas: (nCdTarefaHabilidade, nCdHabilidade, nCdTarefa, iPrioridade)
        tarefa_habilidade_list.append((current_id, hab_id, tarefa_id, prioridade))
        current_id += 1

    cols = ("nCdTarefaHabilidade", "nCdHabilidade", "nCdTarefa", "iPrioridade")
    rows_inserted = bulk_insert_execute_values(conn, "TarefaHabilidade", cols, tarefa_habilidade_list)
    print(f"  -> {rows_inserted} Mapeamentos TarefaHabilidade inseridos em public.TarefaHabilidade.")

def generate_reports(conn):
    print("\n[12/12] Gerando Report...")
    reports_data = []
    current_id = 1
    all_tarefa_ids = GLOBAL_DATA['Tarefa']
    all_user_ids = GLOBAL_DATA['Usuario']

    # Aviso caso não gerar
    if not all_tarefa_ids:
        print("  [AVISO] Nenhuma Tarefa gerada, pulando Report.")
        return
        
    # Gerar um Report para 50% das tarefas
    tarefas_com_report = random.sample(all_tarefa_ids, k=int(len(all_tarefa_ids) * 0.5))
    for tarefa_id in tarefas_com_report:
        # Colunas: (nCdReport, nCdTarefa, nCdUsuario, cDescricao, cProblema, cStatus)
        reports_data.append((
            current_id,
            tarefa_id,
            random.choice(all_user_ids), # Usuário que reporta (pode ser qualquer um)
            random.choice(REPORT_DESCRICOES), # Descrições
            random.choice(PROBLEMAS_INDUSTRIAIS), # Problemas
            random.choice(['Pendente','Em Andamento','Concluída']) # Status do Report
        ))
        current_id += 1

    cols = ("nCdReport", "nCdTarefa", "nCdUsuario", "cDescricao", "cProblema", "cStatus")
    rows_inserted = bulk_insert_execute_values(conn, "Report", cols, reports_data)
    print(f"  -> {rows_inserted} Reports inseridos em public.Report.")

# Começo do script 
conn = connect_db()
if not conn:
    exit(1)
try:
    tables_to_truncate = [
        "public.Report", "public.TarefaHabilidade", "public.TarefaUsuario", "public.Tarefa",
        "public.HabilidadeUsuario", "public.Habilidade", "public.Usuario", "public.Setor",
        "public.PlanoVantagem", "public.Empresa", "public.Cargo", "public.PlanoPagamento"
    ]

    # Converte o nome da tabela para minúsculo, já que o PostgreSQL usa por padrão
    quoted_tables = [t.lower() for t in tables_to_truncate]
    print("\n[SETUP] Iniciando TRUNCATE de tabelas principais...")

    cur = conn.cursor()

    # O comando TRUNCATE CASCADE é usado para garantir a limpeza em tabelas com FKs.
    cur.execute(f"TRUNCATE TABLE {', '.join(quoted_tables)} RESTART IDENTITY CASCADE;")
    conn.commit()
    print("TRUNCATE de tabelas completado. Início do Data Load:")

    # EXECUÇÃO SEQUENCIAL
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

# Se der algum erro, não altera o banco de dados
except Exception as e:
    if conn:
        conn.rollback()
        print(f"\n[ERRO] Uma exceção não tratada ocorreu durante o dataload: {e}")

finally:
    if conn:
        conn.close()
        print("Fechando conexão com o banco de dados...")