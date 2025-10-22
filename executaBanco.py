import os
import re
import psycopg2
import pandas as pd
from psycopg2.extras import execute_values
from dotenv import load_dotenv
import subprocess
import sys 
import time

def get_sql_files(sql_dir="."):
    """Busca todos os arquivos .sql e .py (Data Load) no diretório SQL."""
    sql_files = []
    for root, _, files in os.walk(sql_dir):
        if "SQL" not in root:
            continue
        for file in files:
            if file.endswith(".sql") or file.endswith(".py"): 
                sql_files.append(os.path.join(root, file))
    return sql_files

def separate_files_by_phase(sql_files):
    """Separa arquivos em Criação (padrão), Exclusão (nome riscado) e Jobs."""
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
    """Retorna a categoria do script para ordenação."""
    path_parts = file_path.split(os.sep)
    data_load_names = ['data_load.py', 'data_load.sql', 'DataLoad_SQL.py']
    
    if os.path.basename(file_path) in data_load_names: return "DataLoad"
    if "Modelo" in path_parts: return "Modelo"
    if "Procedures" in path_parts: return "Procedures"
    if "Functions" in path_parts: return "Functions"
    if "Triggers" in path_parts: return "Triggers"
    if "Views" in path_parts: return "Views"
    return "Outros"

def order_deletion_files(deletion_files):
    """Ordena scripts de exclusão (DROP) para garantir a ordem inversa de dependência."""
    order_priority = {"Triggers": 1, "Functions": 2, "Procedures": 3, "Views": 4}
    deletion_files.sort(key=lambda f: (order_priority.get(get_category(f), 99), f))
    return deletion_files

def analyze_dependencies(file_path, all_functions):
    """Busca dependências de funções dentro do conteúdo do arquivo."""
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
    """Realiza a ordenação topológica para garantir a criação na ordem correta de dependência."""
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
    """Ordena scripts para criação (Modelos -> Views -> Procedures -> Functions -> Triggers -> DataLoad)."""
    all_files_by_cat = {"Modelo": [], "Views": [],"Procedures": [], "Functions": [], "Triggers": [], "DataLoad": []}
    for f in creation_files:
        cat = get_category(f)
        if cat in all_files_by_cat: all_files_by_cat[cat].append(f)

    # Ordena as funções usando dependências
    function_files = all_files_by_cat["Functions"]
    dependency_graph = {func: analyze_dependencies(func, function_files) for func in function_files}
    sorted_functions = topological_sort(dependency_graph)

    return (
        all_files_by_cat["Modelo"] + all_files_by_cat["Views"] + all_files_by_cat["Procedures"] +
        sorted_functions + all_files_by_cat["Triggers"] +
        all_files_by_cat["DataLoad"]
    )

def order_job_files(job_files):
    """Ordena a execução de Jobs, priorizando 'extensoes.sql'."""
    extensoes_file = next((f for f in job_files if os.path.basename(f) == 'extensoes.sql'), None)
    if extensoes_file:
        job_files.remove(extensoes_file)
        return [extensoes_file] + sorted(job_files)
    return sorted(job_files)

def execute_python_data_load(database_url, python_script_path, environment_name):
    """Executa o script de Data Load em Python, passando a URL do banco via variável de ambiente."""
    print(f"\n[Data Load Python - {environment_name}] INICIANDO Carga de Dados...")
    try:
        # Injeta a URL do DB na variável de ambiente DATA_LOAD_DB_URL
        env = os.environ.copy()
        env['DATA_LOAD_DB_URL'] = database_url
        
        result = subprocess.run(
            [sys.executable, python_script_path], 
            check=True, 
            capture_output=True,
            text=True,
            env=env
        )
        print(result.stdout)
        
        if result.stderr:
            print(f"--- stderr/Warnings ({environment_name}) ---")
            print(result.stderr)
            
        print(f"[Data Load Python - {environment_name}] Carga de Dados CONCLUÍDA com sucesso.")
        return True
    except subprocess.CalledProcessError as e:
        print(f"[Data Load Python - {environment_name}] ERRO ao executar script Python: {e}")
        print("--- stdout ---")
        print(e.stdout)
        print("--- stderr ---")
        print(e.stderr)
        return False
    except Exception as e:
        print(f"[Data Load Python - {environment_name}] ERRO inesperado: {e}")
        return False


def execute_sql_scripts(connection_url, sql_files, action_verb, environment_name):
    """
    Executa scripts SQL em lote, ignorando arquivos de Data Load Python.
    Adicionado 'environment_name' para corrigir o TypeError.
    """
    conn = None
    success_count = 0
    total_count = len(sql_files)
    if total_count == 0: return (True, 0)

    try:
        conn = psycopg2.connect(connection_url)
        cur = conn.cursor()
        
        for file_path in sql_files:
            # Ignora arquivos de Data Load Python/SQL
            if get_category(file_path) == "DataLoad":
                 continue

            with open(file_path, 'r', encoding='utf-8') as f:
                sql_script = f.readline() if action_verb == "removido" else f.read()
                if sql_script.strip():
                    cur.execute(sql_script)
                    success_count += 1
                    # Inclui o nome do ambiente no logging
                    print(f"   [{environment_name}] ({success_count}/{total_count}) - Script '{os.path.basename(file_path)}' {action_verb} com sucesso.")
            
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
        print("Erro: As variáveis de ambiente DATABASE_URL_QA e DATABASE_URL_DEV devem ser definidas.")
        return

    try:
        all_files = get_sql_files()
        creation_files, deletion_files, job_files = separate_files_by_phase(all_files)
        
        # --- FASE 1: EXCLUSÃO --- 
        if deletion_files:
            ordered_deletions = order_deletion_files(deletion_files)
            print(f"--- FASE 1: EXCLUSÃO ({len(ordered_deletions)} arquivos) ---")
            
            print("\n[QA] INICIANDO EXCLUSÃO...")
            # Chamada corrigida: 4 argumentos
            qa_del_success, _ = execute_sql_scripts(DATABASE_URL_QA, ordered_deletions, "removido", "QA")
            if not qa_del_success: raise Exception("Falha na fase de exclusão em QA.")
            
            print("\n[DEV] INICIANDO EXCLUSÃO...")
            # Chamada corrigida: 4 argumentos
            dev_del_success, _ = execute_sql_scripts(DATABASE_URL_DEV, ordered_deletions, "removido", "DEV")
            if not dev_del_success: raise Exception("Falha na fase de exclusão em DEV.")
            
            print("--- FASE DE EXCLUSÃO CONCLUÍDA ---\n")

        # --- FASE 2: CRIAÇÃO/ALTERAÇÃO ---
        if creation_files:
            ordered_creations = order_creation_files(creation_files)
            
            # Separa o script de Data Load Python
            data_load_file = next((f for f in ordered_creations if get_category(f) == 'DataLoad'), None)
            sql_creation_files = [f for f in ordered_creations if get_category(f) != 'DataLoad']
            
            print(f"--- FASE 2: CRIAÇÃO/ALTERAÇÃO (SQL: {len(sql_creation_files)} arquivos | Python Data Load: 1 arquivo) ---")
            for i, f in enumerate(sql_creation_files, 1): print(f"{i}. {f}")
            if data_load_file: print(f"{len(sql_creation_files) + 1}. {data_load_file} (Executado separadamente)")
            
            # 1. EXECUÇÃO DOS SCRIPTS SQL (Estrutura, Funções, Triggers, Views)
            print("\n[QA] INICIANDO CRIAÇÃO/ALTERAÇÃO SQL...")
            # Chamada corrigida: 4 argumentos
            qa_creation_success, _ = execute_sql_scripts(DATABASE_URL_QA, sql_creation_files, "executado", "QA")
            if not qa_creation_success: raise Exception("Falha na fase de criação/alteração SQL em QA.")
            
            print("\n[DEV] INICIANDO CRIAÇÃO/ALTERAÇÃO SQL...")
            # Chamada corrigida: 4 argumentos
            dev_creation_success, _ = execute_sql_scripts(DATABASE_URL_DEV, sql_creation_files, "executado", "DEV")
            if not dev_creation_success: raise Exception("Falha na fase de criação/alteração SQL em DEV.")

            # 2. EXECUÇÃO DO DATA LOAD PYTHON
            if data_load_file:
                # Executa QA
                qa_data_load_success = execute_python_data_load(DATABASE_URL_QA, data_load_file, "QA")
                if not qa_data_load_success: raise Exception("Falha na carga de dados Python em QA.")

                # Executa DEV
                dev_data_load_success = execute_python_data_load(DATABASE_URL_DEV, data_load_file, "DEV")
                if not dev_data_load_success: raise Exception("Falha na carga de dados Python em DEV.")
            
            print("--- FASE DE CRIAÇÃO/ALTERAÇÃO CONCLUÍDA ---\n")

        # --- FASE 3: JOBS --- 
        if job_files:
            ordered_jobs = order_job_files(job_files)
            print(f"--- FASE 3: JOBS ({len(ordered_jobs)} arquivos) ---")
            
            # Ajusta a URL para o banco de dados de Jobs/Extensões
            JOB_DB_NAME = "defaultdb"
            JOB_URL_QA = re.sub(r'/[^/]+$', f'/{JOB_DB_NAME}', DATABASE_URL_QA)
            JOB_URL_DEV = re.sub(r'/[^/]+$', f'/{JOB_DB_NAME}', DATABASE_URL_DEV)

            print("\n[QA] INICIANDO EXECUÇÃO DE JOBS...")
            # Chamada corrigida: 4 argumentos
            qa_job_success, _ = execute_sql_scripts(JOB_URL_QA, ordered_jobs, "executado", "QA")
            if not qa_job_success: raise Exception("Falha na fase de JOBS em QA.")

            print("\n[DEV] INICIANDO EXECUÇÃO DE JOBS...")
            # Chamada corrigida: 4 argumentos
            dev_job_success, _ = execute_sql_scripts(JOB_URL_DEV, ordered_jobs, "executado", "DEV")
            if not dev_job_success: raise Exception("Falha na fase de JOBS em DEV.")
            print("--- FASE DE JOBS CONCLUÍDA ---")

    except Exception as e:
        print(f"\nERRO CRÍTICO: {e}")
        print("A execução foi interrompida.")

if __name__ == "__main__":
    main()