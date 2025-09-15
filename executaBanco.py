import os
import re
import psycopg2
from dotenv import load_dotenv

def get_sql_files(sql_dir="SQL"):
    """Busca todos os arquivos .sql recursivamente."""
    sql_files = []
    for root, _, files in os.walk(sql_dir):
        for file in files:
            if file.endswith(".sql"):
                sql_files.append(os.path.join(root, file))
    return sql_files

def separate_files_by_action(sql_files):
    """
    Separa os arquivos em listas de criação/alteração e exclusão.
    A exclusão é identificada pelo caractere de riscado (U+0336) no nome do arquivo.
    """
    creation_files = []
    deletion_files = []
    strikethrough_char = '\u0336'
    
    for file_path in sql_files:
        if strikethrough_char in os.path.basename(file_path):
            deletion_files.append(file_path)
        else:
            creation_files.append(file_path)
            
    return creation_files, deletion_files

def get_category(file_path):
    path_parts = file_path.split(os.sep)
    if "Modelo" in path_parts:
        return "DataLoad" if "data_load" in os.path.basename(file_path) else "Modelo"
    if "Procedures" in path_parts: return "Procedures"
    if "Functions" in path_parts: return "Functions"
    if "Triggers" in path_parts: return "Triggers"
    return "Outros"

def order_deletion_files(deletion_files):
    # Prioridade inversa da criação
    order_priority = {"Triggers": 1, "Functions": 2, "Procedures": 3}
    
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
        print(f"  - Aviso: Não foi possível analisar o arquivo {file_path}: {e}")
    return list(dependencies)

def topological_sort(graph):
    in_degree = {u: 0 for u in graph}
    for u in graph:
        for v in graph[u]:
            in_degree[v] += 1
    queue = [u for u in graph if in_degree[u] == 0]
    sorted_order = []
    while queue:
        u = queue.pop(0)
        sorted_order.append(u)
        for v in graph[u]:
            in_degree[v] -= 1
            if in_degree[v] == 0:
                queue.append(v)
    if len(sorted_order) == len(graph):
        return sorted_order
    else:
        cycle_nodes = {node for node, degree in in_degree.items() if degree > 0}
        cycle_files = "\n - " + "\n - ".join([os.path.basename(f) for f in cycle_nodes])
        raise Exception(f"Erro: Ciclo de dependência detectado. Verifique os seguintes arquivos:{cycle_files}")

def order_creation_files(creation_files):
    """Ordena os arquivos de criação/alteração."""
    all_files_by_cat = {
        "Modelo": [], "Procedures": [], "Functions": [], "Triggers": [], "DataLoad": []
    }
    for f in creation_files:
        cat = get_category(f)
        if cat in all_files_by_cat:
            all_files_by_cat[cat].append(f)

    function_files = all_files_by_cat["Functions"]
    dependency_graph = {func: analyze_dependencies(func, function_files) for func in function_files}
    sorted_functions = topological_sort(dependency_graph)

    final_order = (
        all_files_by_cat["Modelo"] + all_files_by_cat["Procedures"] +
        sorted_functions + all_files_by_cat["Triggers"] +
        all_files_by_cat["DataLoad"]
    )
    return final_order

def execute_sql_scripts(connection_url, sql_files, action_verb):
    conn = None
    success_count = 0
    total_count = len(sql_files)
    if total_count == 0:
        return (True, 0)

    try:
        conn = psycopg2.connect(connection_url)
        cur = conn.cursor()
        
        for i, file_path in enumerate(sql_files, 1):
            with open(file_path, 'r', encoding='utf-8') as f:
                # Executa apenas a primeira linha para arquivos de exclusão (DROP IF EXISTS)
                sql_script = f.readline() if action_verb == "removido" else f.read()
                if sql_script.strip():
                    cur.execute(sql_script)
                    success_count += 1
                    print(f"  ({success_count}/{total_count}) - Script '{os.path.basename(file_path)}' {action_verb} com sucesso.")
        
        conn.commit()
        return (True, success_count)
    except (Exception, psycopg2.DatabaseError) as error:
        failed_file = os.path.basename(sql_files[success_count])
        print(f"  - ERRO ao processar o script '{failed_file}': {error}")
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
        all_sql_files = get_sql_files()
        creation_files, deletion_files = separate_files_by_action(all_sql_files)
        
        # --- FASE DE EXCLUSÃO ---
        ordered_deletions = order_deletion_files(deletion_files)
        total_deletions = len(ordered_deletions)
        
        if total_deletions > 0:
            print(f"--- FASE 1: EXCLUSÃO ({total_deletions} arquivos) ---")
            for i, file in enumerate(ordered_deletions, 1): print(f"{i}. {os.path.basename(file)}")

            print("\n[QA] INICIANDO EXCLUSÃO...")
            qa_del_success, qa_del_count = execute_sql_scripts(DATABASE_URL_QA, ordered_deletions, "removido")
            if not qa_del_success:
                print(f"--- FALHA NA EXCLUSÃO EM QA: {qa_del_count}/{total_deletions} scripts processados. Abortando. ---")
                return
            print(f"--- EXCLUSÃO EM QA CONCLUÍDA: {qa_del_count}/{total_deletions} scripts processados. ---\n")

            print("[DEV] INICIANDO EXCLUSÃO...")
            dev_del_success, dev_del_count = execute_sql_scripts(DATABASE_URL_DEV, ordered_deletions, "removido")
            if not dev_del_success:
                print(f"--- FALHA NA EXCLUSÃO EM DEV: {dev_del_count}/{total_deletions} scripts processados. Abortando. ---")
                return
            print(f"--- EXCLUSÃO EM DEV CONCLUÍDA: {dev_del_count}/{total_deletions} scripts processados. ---\n")
        
        ordered_creations = order_creation_files(creation_files)
        total_creations = len(ordered_creations)

        if total_creations > 0:
            print(f"--- FASE 2: CRIAÇÃO/ALTERAÇÃO ({total_creations} arquivos) ---")
            for i, file in enumerate(ordered_creations, 1): print(f"{i}. {file}")

            print("\n[QA] INICIANDO CRIAÇÃO/ALTERAÇÃO...")
            qa_creation_success, qa_creation_count = execute_sql_scripts(DATABASE_URL_QA, ordered_creations, "executado")
            if not qa_creation_success:
                print(f"--- FALHA NA CRIAÇÃO/ALTERAÇÃO EM QA: {qa_creation_count}/{total_creations} scripts executados. DEV não será atualizado. ---")
                return
            print(f"--- CRIAÇÃO/ALTERAÇÃO EM QA CONCLUÍDA: {qa_creation_count}/{total_creations} scripts executados. ---\n")

            print("[DEV] INICIANDO CRIAÇÃO/ALTERAÇÃO...")
            dev_creation_success, dev_creation_count = execute_sql_scripts(DATABASE_URL_DEV, ordered_creations, "executado")
            if not dev_creation_success:
                print(f"--- FALHA NA CRIAÇÃO/ALTERAÇÃO EM DEV: {dev_creation_count}/{total_creations} scripts executados. ---")
                return
            print(f"--- CRIAÇÃO/ALTERAÇÃO EM DEV CONCLUÍDA: {dev_creation_count}/{total_creations} scripts executados. ---")

    except Exception as e:
        print(f"\nERRO CRÍTICO NA PREPARAÇÃO DOS SCRIPTS: {e}")
        print("A execução foi interrompida.")

if __name__ == "__main__":
    main()