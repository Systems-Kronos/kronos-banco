import os
import psycopg2
import sys
import subprocess
from dotenv import load_dotenv

# Carrega as variáveis de ambiente do arquivo .env para desenvolvimento local
# No GitHub Actions, as variáveis serão injetadas diretamente no ambiente
load_dotenv()

# --- Conexão com PostgreSQL ---
DATABASE_URL_DEV = os.getenv("DATABASE_URL_DEV")  
DATABASE_URL_QA = os.getenv("DATABASE_URL_QA")  

def get_conn_dev():
    return psycopg2.connect(DATABASE_URL_DEV)

def get_conn_qa():
    return psycopg2.connect(DATABASE_URL_QA)

sql_dir = 'kronos-banco/SQL'

execution_order_map = {
    'Modelo': 1,
    'Functions': 2,
    'Procedures': 3,
    'Triggers': 4
}

sql_files_to_run = []
for root, _, files in os.walk(sql_dir):
    for file in files:
        if file.endswith('.sql'):
            sql_files_to_run.append(os.path.join(root, file))

def get_execution_order(filename):
    for dir_name, order in execution_order_map.items():
        if dir_name in filename:
            # Prioriza o data_load.sql por último dentro do diretório Modelo
            if 'data_load.sql' in filename:
                return order + 0.5
            return order
    return 99 

sorted_sql_files = sorted(sql_files_to_run, key=get_execution_order)

def run_script(command):
    print(f"--- Executando comando: {' '.join(command)} ---")
    try:
        result = subprocess.run(command, check=True, capture_output=True, text=True, encoding='utf-8')
        print(result.stdout)
        print(f"--- Script {' '.join(command)} executado com sucesso! ---")
    except subprocess.CalledProcessError as e:
        print(f"Erro ao executar o script {' '.join(command)}:")
        print(e.stderr)
        sys.exit(1) 

connDEV = None
connQA = None
try:
    print("Conectando ao banco de dados PostgreSQL...")
    connDEV = get_conn_dev
    cursorDEV = connDEV.cursor()

    connQA = get_conn_dev
    cursorQA = connQA.cursor()
    print("Conexão com PostgreSQL bem-sucedida.")

    for sql_file in sorted_sql_files:
        print(f"Executando script SQL: {sql_file}")
        with open(sql_file, 'r', encoding='utf-8') as f:
            sql_script = f.read()
            if not sql_script.strip():
                print(f"Script {sql_file} está vazio, pulando.")
                continue
            try:
                cursorDEV.execute(sql_script)
                connDEV.commit()

                cursorQA.execute(sql_script)
                connQA.commit()
                print("Script SQL executado com sucesso.")
            except psycopg2.Error as e:
                connDEV.rollback()
                connQA.rollback()
                print(f"Erro ao executar o script SQL {sql_file}: {e}")
                sys.exit(1)

except psycopg2.Error as e:
    print(f"Erro de conexão com o PostgreSQL: {e}")
    sys.exit(1)

finally:
    if connDEV:
        cursorDEV.close()
        connDEV.close()
        print("Conexão com o PostgreSQL encerrada.")
        
    if connQA:
        cursorQA.close()
        connQA.close()
        print("Conexão com o PostgreSQL encerrada.")

# --- Execução dos Scripts Adicionais ---
run_script(['python', 'kronos-banco/MongoDB/DataLoad_MongoDB.py'])
run_script(['python', 'kronos-banco/Redis/DataLoad_Redis.py'])

print("\nWorkflow concluído com sucesso!")