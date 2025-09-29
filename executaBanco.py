import os
import re
import psycopg2
from psycopg2.extras import execute_values
import pandas as pd
import io
from dotenv import load_dotenv

def importar_cargos_cbo(cursor):
    """
    Lê os arquivos cbo2002-ocupacao.csv e cbo2002-subgrupo.csv, cruza as informações
    e insere o resultado no banco de dados usando a conexão fornecida.
    """
    # --- Configurações da importação ---
    ocupacao_file = 'cbo2002-ocupacao.csv'
    subgrupo_file = 'cbo2002-subgrupo.csv'
    nome_tabela_alvo = 'cargo'

    try:
        print(f"   - Lendo o arquivo '{ocupacao_file}'...")
        # ALTERAÇÃO AQUI: Adicionado encoding='latin1' para ler o arquivo com acentuação
        df_ocupacao = pd.read_csv(ocupacao_file, sep=';', dtype=str, encoding='latin1')
        
        print(f"   - Lendo o arquivo '{subgrupo_file}'...")
        # ALTERAÇÃO AQUI: Adicionado encoding='latin1' também
        df_subgrupo = pd.read_csv(subgrupo_file, sep=';', dtype=str, encoding='latin1')
    
    except FileNotFoundError as e:
        print(f"   - ERRO: Arquivo não encontrado: {e.filename}.")
        print("   - Por favor, certifique-se que os arquivos .csv estão na mesma pasta do script.")
        return False
    except Exception as e:
        print(f"   - ERRO ao ler os arquivos CSV: {e}")
        return False

    # --- Tratamento e Cruzamento dos Dados ---
    df_subgrupo['TITULO'] = df_subgrupo['TITULO'].str.strip()
    df_ocupacao['COD_SUBGRUPO'] = df_ocupacao['CODIGO'].str[:3]
    
    df_merged = pd.merge(
        df_ocupacao,
        df_subgrupo,
        left_on='COD_SUBGRUPO',
        right_on='CODIGO',
        how='left',
        suffixes=('_ocupacao', '_subgrupo')
    )
    
    df_final = df_merged[['TITULO_ocupacao', 'CODIGO_ocupacao', 'TITULO_subgrupo']].rename(columns={
        'TITULO_ocupacao': 'nome_cargo',
        'CODIGO_ocupacao': 'cbo_codigo',
        'TITULO_subgrupo': 'familia_ocupacional'
    })
    
    df_final = df_final[df_final['cbo_codigo'].str.startswith(('7', '8'))].copy()

    if df_final.empty:
        print("   - Nenhum cargo de indústria (grupos 7 ou 8) encontrado para importar.")
        return True

    print(f"   - {len(df_final)} cargos de indústria prontos para inserção...")
    
    # --- Inserção no banco de dados (psycopg2) ---
    try:
        sql_insert_query = f"""
            INSERT INTO {nome_tabela_alvo} (cNmCargo, cCdCBO, cNmFamiliaOcupacional) 
            VALUES %s
        """
        data_to_insert = [tuple(row) for row in df_final.itertuples(index=False)]

        execute_values(cursor, sql_insert_query, data_to_insert)

        print(f"   - SUCESSO! {len(df_final)} cargos foram inseridos na tabela '{nome_tabela_alvo}'.")
        return True
    except (Exception, psycopg2.DatabaseError) as error:
        print(f"   - ERRO durante a inserção dos cargos: {error}")
        return False

def get_sql_files(sql_dir="."):
    sql_files = []
    for root, _, files in os.walk(sql_dir):
        if "SQL" not in root:
            continue
        for file in files:
            if file.endswith(".sql"):
                sql_files.append(os.path.join(root, file))
    return sql_files

def separate_files_by_phase(sql_files):
    creation_files, deletion_files, job_files = [], [], []
    strikethrough_char = '\u0336'
    
    for file_path in sql_files:
        if "JOBS" in file_path.split(os.sep):
            job_files.append(file_path)
        elif strikethrough_char in os.path.basename(file_path):
            deletion_files.append(file_path)
        else:
            creation_files.append(file_path)
            
    return creation_files, deletion_files, job_files

def get_category(file_path):
    path_parts = file_path.split(os.sep)
    if "data_load.sql" in os.path.basename(file_path): return "DataLoad"
    if "Modelo" in path_parts: return "Modelo"
    if "Procedures" in path_parts: return "Procedures"
    if "Functions" in path_parts: return "Functions"
    if "Triggers" in path_parts: return "Triggers"
    if "Views" in path_parts: return "Views"
    return "Outros"

def order_deletion_files(deletion_files):
    order_priority = {"Triggers": 1, "Functions": 2, "Procedures": 3, "Views": 4}
    deletion_files.sort(key=lambda f: (order_priority.get(get_category(f), 99), f))
    return deletion_files

def analyze_dependencies(file_path, all_functions):
    dependencies = set()
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read().lower()
            for func_path in all_functions:
                if file_path == func_path: continue
                func_name = os.path.splitext(os.path.basename(func_path))[0].lower()
                if re.search(r'\b' + re.escape(func_name) + r'\b', content):
                    dependencies.add(func_path)
    except Exception as e:
        print(f"   - Aviso: Não foi possível analisar o arquivo {file_path}: {e}")
    return list(dependencies)

def topological_sort(graph):
    in_degree = {u: 0 for u in graph}
    for u in graph:
        for v in graph[u]: in_degree[v] += 1
    queue = [u for u in graph if in_degree[u] == 0]
    sorted_order = []
    while queue:
        u = queue.pop(0)
        sorted_order.append(u)
        for v in graph[u]:
            in_degree[v] -= 1
            if in_degree[v] == 0: queue.append(v)
    if len(sorted_order) == len(graph):
        return sorted_order
    else:
        cycle_nodes = {node for node, degree in in_degree.items() if degree > 0}
        cycle_files = "\n - " + "\n - ".join([os.path.basename(f) for f in cycle_nodes])
        raise Exception(f"Erro: Ciclo de dependência detectado. Verifique os seguintes arquivos:{cycle_files}")

def order_creation_files(creation_files):
    all_files_by_cat = {"Modelo": [], "Views": [],"Procedures": [], "Functions": [], "Triggers": [], "DataLoad": []}
    for f in creation_files:
        cat = get_category(f)
        if cat in all_files_by_cat: all_files_by_cat[cat].append(f)

    function_files = all_files_by_cat["Functions"]
    dependency_graph = {func: analyze_dependencies(func, function_files) for func in function_files}
    sorted_functions = topological_sort(dependency_graph)

    return (
        all_files_by_cat["Modelo"] + all_files_by_cat["Views"] + all_files_by_cat["Procedures"] +
        sorted_functions + all_files_by_cat["Triggers"] +
        all_files_by_cat["DataLoad"]
    )

def order_job_files(job_files):
    extensoes_file = next((f for f in job_files if os.path.basename(f) == 'extensoes.sql'), None)
    if extensoes_file:
        job_files.remove(extensoes_file)
        return [extensoes_file] + sorted(job_files)
    return sorted(job_files)

def execute_sql_scripts(connection_url, sql_files, action_verb):
    conn = None
    success_count = 0
    total_count = len(sql_files)
    if total_count == 0: return (True, 0)

    try:
        conn = psycopg2.connect(connection_url)
        cur = conn.cursor()
        
        for file_path in sql_files:
            if get_category(file_path) == "DataLoad":
                qa_cbo_success = importar_cargos_cbo(cur)
                if not qa_cbo_success: raise Exception("Falha na carga de cargos em QA.")

            with open(file_path, 'r', encoding='utf-8') as f:
                sql_script = f.readline() if action_verb == "removido" else f.read()
                if sql_script.strip():
                    cur.execute(sql_script)
                    success_count += 1
                    print(f"   ({success_count}/{total_count}) - Script '{os.path.basename(file_path)}' {action_verb} com sucesso.")
            
        conn.commit()
        return (True, success_count)
    except (Exception, psycopg2.DatabaseError) as error:
        failed_file = os.path.basename(sql_files[success_count])
        print(f"   - ERRO ao processar o script '{failed_file}': {error}")
        if conn: conn.rollback()
        return (False, success_count)
    finally:
        if conn:
            cur.close()
            conn.close()

def main():
    load_dotenv()
    
    DATABASE_URL_QA = os.getenv("DATABASE_URL_QA")
    DATABASE_URL_DEV = os.getenv("DATABASE_URL_DEV")

    if not DATABASE_URL_QA or not DATABASE_URL_DEV:
        print("Erro: As variáveis de ambiente devem ser definidas.")
        return

    try:
        all_sql_files = get_sql_files()
        creation_files, deletion_files, job_files = separate_files_by_phase(all_sql_files)
        
        # --- FASE 1: EXCLUSÃO --- #
        if deletion_files:
            ordered_deletions = order_deletion_files(deletion_files)
            print(f"--- FASE 1: EXCLUSÃO ({len(ordered_deletions)} arquivos) ---")
            
            print("\n[QA] INICIANDO EXCLUSÃO...")
            qa_del_success, _ = execute_sql_scripts(DATABASE_URL_QA, ordered_deletions, "removido")
            if not qa_del_success: raise Exception("Falha na fase de exclusão em QA.")
            
            print("\n[DEV] INICIANDO EXCLUSÃO...")
            dev_del_success, _ = execute_sql_scripts(DATABASE_URL_DEV, ordered_deletions, "removido")
            if not dev_del_success: raise Exception("Falha na fase de exclusão em DEV.")
            print("--- FASE DE EXCLUSÃO CONCLUÍDA ---\n")

        # --- FASE 2: CRIAÇÃO/ALTERAÇÃO --- #
        if creation_files:
            ordered_creations = order_creation_files(creation_files)
            print(f"--- FASE 2: CRIAÇÃO/ALTERAÇÃO ({len(ordered_creations)} arquivos) ---")
            for i, f in enumerate(ordered_creations, 1): print(f"{i}. {f}")
            
            print("\n[QA] INICIANDO CRIAÇÃO/ALTERAÇÃO...")
            qa_creation_success, _ = execute_sql_scripts(DATABASE_URL_QA, ordered_creations, "executado")
            if not qa_creation_success: raise Exception("Falha na fase de criação/alteração em QA.")
            
            print("\n[DEV] INICIANDO CRIAÇÃO/ALTERAÇÃO...")
            dev_creation_success, _ = execute_sql_scripts(DATABASE_URL_DEV, ordered_creations, "executado")
            if not dev_creation_success: raise Exception("Falha na fase de criação/alteração em DEV.")
            print("--- FASE DE CRIAÇÃO/ALTERAÇÃO CONCLUÍDA ---\n")

        # --- FASE 3: JOBS --- #
        if job_files:
            ordered_jobs = order_job_files(job_files)
            print(f"--- FASE 3: JOBS ({len(ordered_jobs)} arquivos) ---")
            
            JOB_DB_NAME = "defaultdb"
            JOB_URL_QA = re.sub(r'/[^/]+$', f'/{JOB_DB_NAME}', DATABASE_URL_QA)
            JOB_URL_DEV = re.sub(r'/[^/]+$', f'/{JOB_DB_NAME}', DATABASE_URL_DEV)

            print("\n[QA] INICIANDO EXECUÇÃO DE JOBS...")
            qa_job_success, _ = execute_sql_scripts(JOB_URL_QA, ordered_jobs, "executado")
            if not qa_job_success: raise Exception("Falha na fase de JOBS em QA.")

            print("\n[DEV] INICIANDO EXECUÇÃO DE JOBS...")
            dev_job_success, _ = execute_sql_scripts(JOB_URL_DEV, ordered_jobs, "executado")
            if not dev_job_success: raise Exception("Falha na fase de JOBS em DEV.")
            print("--- FASE DE JOBS CONCLUÍDA ---")

    except Exception as e:
        print(f"\nERRO CRÍTICO: {e}")
        print("A execução foi interrompida.")

if __name__ == "__main__":
    main()