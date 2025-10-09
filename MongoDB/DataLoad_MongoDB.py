import random
from datetime import datetime, timedelta
from pymongo.mongo_client import MongoClient
from pymongo.server_api import ServerApi
from dotenv import load_dotenv
import os
import psycopg2 

# Dados base para gerar as entradas
total_usuarios = 31  
num_entradas_por_usuario = 100 

atestados_info = [
    {"cObservacao": "Atestado Médico - Enxaqueca Crônica", "cCRM": "123456", "cCID": "G43.9"},
    {"cObservacao": "Atestado Médico - Crise de Rinite", "cCRM": "654321", "cCID": "J30.1"},
    {"cObservacao": "Atestado Médico - Gastroenterite", "cCRM": "987654", "cCID": "A09.0"},
    {"cObservacao": "Atestado Médico - Dor nas Costas", "cCRM": "555555", "cCID": "M54.9"},
    {"cObservacao": "Atestado Médico - Lesão no pulso", "cCRM": "111222", "cCID": "S69.9"}
]

outros_motivos = [
    "Motivo particular urgente",
    "Problema familiar",
    "Compromisso pessoal",
    "Viagem",
    "Manutenção residencial"
]

presenca_observacoes = [
    "Trabalhou remotamente por telemedicina",
    "Atraso de 30 minutos devido ao trânsito intenso",
    "Ficou até mais tarde para finalizar relatório",
    "Reunião externa agendada para o período da manhã",
    "Participou de workshop de treinamento"
]

# Lista de URLs de imagens aleatórias para atestados médicos (usando placehold.co)
atestado_urls = [
    "https://placehold.co/800x600/FF0000/FFFFFF/pdf.png?text=Atestado_1",
    "https://placehold.co/800x600/00FF00/000000/pdf.png?text=Atestado_2",
    "https://placehold.co/800x600/0000FF/FFFFFF/pdf.png?text=Atestado_3",
    "https://placehold.co/800x600/FF5733/000000/pdf.png?text=Atestado_4",
    "https://placehold.co/800x600/C70039/FFFFFF/pdf.png?text=Atestado_5"
]

def fetch_usuario_gestor_map(connection_url):
    """Conecta ao PostgreSQL e busca o mapeamento nCdUsuario -> nCdGestor."""
    conn = None
    usuario_gestor_map = {}
    print("Iniciando conexão com PostgreSQL para buscar o mapeamento de gestores...")
    try:
        conn = psycopg2.connect(connection_url)
        cursor = conn.cursor()
        
        cursor.execute("SELECT nCdUsuario, nCdGestor FROM public.Usuario;")
        
        # Cria o dicionário de mapeamento {nCdUsuario: nCdGestor}
        for nCdUsuario, nCdGestor in cursor.fetchall():
            usuario_gestor_map[int(nCdUsuario)] = int(nCdGestor) if nCdGestor is not None else None
            
        print("Mapeamento de gestores obtido com sucesso.")
        return usuario_gestor_map
        
    except Exception as e:
        print(f"ERRO ao buscar dados do PostgreSQL: {e}")
        return None
    finally:
        if conn:
            cursor.close()
            conn.close()
            print("Conexão com PostgreSQL fechada.")


calendario_data = []

load_dotenv()
try:

    DATABASE_URL_DEV = os.getenv("DATABASE_URL_QA")
    if not DATABASE_URL_DEV:
        raise Exception("Variável de ambiente DATABASE_URL_DEV não encontrada. Verifique o arquivo .env.")

    usuario_gestor_map = fetch_usuario_gestor_map(DATABASE_URL_DEV)

    if usuario_gestor_map is None:
        raise Exception("A carga de dados foi interrompida devido a falha na obtenção do mapeamento de gestores.")

    # Atualiza a lista de IDs de usuário para iterar sobre os IDs válidos
    valid_user_ids = list(usuario_gestor_map.keys())
    
    
    # -----------------------------------------------------
    # Loop para gerar dados para cada usuário (com nCdGestor)
    # -----------------------------------------------------
    print("\nIniciando a geração de documentos para o MongoDB...")
    for i in valid_user_ids:
        nCdGestor = usuario_gestor_map.get(i) 
        
        for j in range(num_entradas_por_usuario):
            tipo_evento = random.randint(0, 2)

            dias_aleatorios = random.randint(0, 365)
            data_evento = datetime.now() - timedelta(days=dias_aleatorios)

            evento = {}
            
            if tipo_evento == 0: 
                atestado = random.choice(atestados_info)
                evento = {
                    "nCdUsuario": i,
                    "nCdGestor": nCdGestor,
                    "dEvento": data_evento,
                    "bPresenca": False,
                    "cObservacao": atestado["cObservacao"],
                    "cCRM": atestado["cCRM"],
                    "cCID": atestado["cCID"],
                    "cAtestado": random.choice(atestado_urls), 
                    "bAceito": True
                }
            elif tipo_evento == 1: 
                motivo = random.choice(outros_motivos)
                evento = {
                    "nCdUsuario": i,
                    "nCdGestor": nCdGestor, 
                    "dEvento": data_evento,
                    "bPresenca": False,
                    "cObservacao": motivo,
                    "bAceito": True
                }
            else:  
                obs = random.choice(presenca_observacoes)
                evento = {
                    "nCdUsuario": i,
                    "nCdGestor": nCdGestor, 
                    "dEvento": data_evento,
                    "bPresenca": True,
                    "cObservacao": obs
                }
            
            calendario_data.append(evento)


    # --- CONEXÃO COM MONGODB PARA INSERIR DADOS ---
    mongo_uri = os.getenv("MONGODB_URI")
    if not mongo_uri:
        raise Exception("Variável de ambiente MONGODB_URI não encontrada. Verifique o arquivo .env.")

    client = MongoClient(mongo_uri, server_api=ServerApi('1'))
    client.admin.command('ping')
    print("Pinged your deployment. You successfully connected to MongoDB!")

    db = client['dbKronos']
    collection = db['calendario']
    
    print(f"Iniciando a inserção de {len(calendario_data)} documentos...")
    result = collection.insert_many(calendario_data)
    
    print(f"Inserção concluída com sucesso! Total de documentos inseridos: {len(result.inserted_ids)}")
except Exception as e:
    print(f"Ocorreu um erro crítico: {e}")