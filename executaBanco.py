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

def analyze_dependencies(file_path, all_functions):
    """
    Analisa as dependências de uma função lendo o conteúdo do arquivo SQL.
    Retorna uma lista de nomes de funções das quais ela depende.
    """
    dependencies = set()
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read().lower()
            for func_path in all_functions:
                if file_path == func_path:
                    continue
                func_name = os.path.splitext(os.path.basename(func_path))[0].lower()
                if re.search(r'\b' + re.escape(func_name) + r'\b', content):
                    dependencies.add(func_path)
    except Exception as e:
        print(f"  - Aviso: Não foi possível analisar o arquivo {file_path}: {e}")
    return list(dependencies)

def topological_sort(graph):
    """
    Realiza uma ordenação topológica para resolver a ordem de execução.
    Retorna a lista ordenada ou lança um erro com os arquivos do ciclo de dependência.
    """
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

def order_sql_files(sql_files):
    """
    Ordena os arquivos SQL com base na prioridade e resolve as dependências das funções.
    """
    order_priority = {"Modelo": 1, "Procedures": 2, "Functions": 3, "Triggers": 4, "DataLoad": 5}
    
    def get_category(file_path):
        path_parts = file_path.split(os.sep)
        if "Modelo" in path_parts:
            return "DataLoad" if "data_load" in os.path.basename(file_path) else "Modelo"
        if "Procedures" in path_parts: return "Procedures"
        if "Functions" in path_parts: return "Functions"
        if "Triggers" in path_parts: return "Triggers"
        return "Outros"

    all_files_by_cat = {cat: [] for cat in order_priority}
    for f in sql_files:
        cat = get_category(f)
        if cat in all_files_by_cat:
            all_files_by_cat[cat].append(f)

    function_files = all_files_by_cat["Functions"]
    dependency_graph = {func: analyze_dependencies(func, function_files) for func in function_files}
    sorted_functions = topological_sort(dependency_graph)

    final_order = (
        all_files_by_cat["Modelo"] +
        all_files_by_cat["Procedures"] +
        sorted_functions +
        all_files_by_cat["Triggers"] +
        all_files_by_cat["DataLoad"]
    )
    return final_order

def execute_sql_scripts(connection_url, sql_files):
    """
    Conecta ao banco de dados e executa os scripts SQL.
    Retorna uma tupla (sucesso, contador).
    """
    conn = None
    success_count = 0
    total_count = len(sql_files)
    
    try:
        conn = psycopg2.connect(connection_url)
        cur = conn.cursor()
        
        for i, file_path in enumerate(sql_files, 1):
            with open(file_path, 'r', encoding='utf-8') as f:
                sql_script = f.read()
                if sql_script.strip():
                    cur.execute(sql_script)
                    success_count += 1
                    print(f"  ({success_count}/{total_count}) - Script '{file_path}' executado com sucesso.")
        
        conn.commit()
        return (True, success_count)
    except (Exception, psycopg2.DatabaseError) as error:
        print(f"  - ERRO ao executar o script '{sql_files[success_count]}': {error}")
        if conn:
            conn.rollback()
        return (False, success_count)
    finally:
        if conn:
            cur.close()
            conn.close()

def main():
    """Função principal que orquestra a execução."""
    load_dotenv()
    
    DATABASE_URL_QA = os.getenv("DATABASE_URL_QA")
    DATABASE_URL_DEV = os.getenv("DATABASE_URL_DEV")

    if not DATABASE_URL_QA or not DATABASE_URL_DEV:
        print("Erro: As variáveis de ambiente DATABASE_URL_QA e DATABASE_URL_DEV devem ser definidas.")
        return

    try:
        all_sql_files = get_sql_files()
        ordered_files = order_sql_files(all_sql_files)
        total_files = len(ordered_files)
        
        print(f"Total de {total_files} arquivos a serem executados na seguinte ordem:")
        for i, file in enumerate(ordered_files, 1):
            print(f"{i}. {file}")
        
        print("\n--- INICIANDO EXECUÇÃO EM QA ---")
        success_qa, count_qa = execute_sql_scripts(DATABASE_URL_QA, ordered_files)
        
        if success_qa:
            print(f"--- EXECUÇÃO EM QA CONCLUÍDA: {count_qa}/{total_files} scripts executados com sucesso. ---\n")
            
            print("--- INICIANDO EXECUÇÃO EM DEV ---")
            success_dev, count_dev = execute_sql_scripts(DATABASE_URL_DEV, ordered_files)
            
            if success_dev:
                print(f"--- EXECUÇÃO EM DEV CONCLUÍDA: {count_dev}/{total_files} scripts executados com sucesso. ---")
            else:
                print(f"--- FALHA NA EXECUÇÃO EM DEV: {count_dev}/{total_files} scripts executados antes do erro. ---")
        else:
            print(f"--- FALHA NA EXECUÇÃO EM QA: {count_qa}/{total_files} scripts executados antes do erro. O ambiente de DEV não será atualizado. ---")
            
    except Exception as e:
        print(f"\nERRO CRÍTICO NA PREPARAÇÃO DOS SCRIPTS: {e}")
        print("A execução foi interrompida.")

if __name__ == "__main__":
    main()