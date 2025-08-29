import random
from datetime import datetime, timedelta
from pymongo.mongo_client import MongoClient
from pymongo.server_api import ServerApi
from dotenv import load_dotenv
import os

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

# Lista para armazenar todos os documentos a serem inseridos
calendario_data = []

# Loop para gerar dados para cada usuário
for i in range(1, total_usuarios + 1):
    for j in range(num_entradas_por_usuario):
        tipo_evento = random.randint(0, 2)

        dias_aleatorios = random.randint(0, 365)
        data_evento = datetime.now() - timedelta(days=dias_aleatorios)

        evento = {}
        
        if tipo_evento == 0:  # Falta por atestado
            atestado = random.choice(atestados_info)
            evento = {
                "nCdUsuario": i,
                "dEvento": data_evento,
                "bPresenca": False,
                "cObservacao": atestado["cObservacao"],
                "cCRM": atestado["cCRM"],
                "cCID": atestado["cCID"],
                "cAtestado": random.choice(atestado_urls), 
                "bAceito": True
            }
        elif tipo_evento == 1:  # Falta por outro motivo
            motivo = random.choice(outros_motivos)
            evento = {
                "nCdUsuario": i,
                "dEvento": data_evento,
                "bPresenca": False,
                "cObservacao": motivo,
                "bAceito": True
            }
        else:  # Presença com observação
            obs = random.choice(presenca_observacoes)
            evento = {
                "nCdUsuario": i,
                "dEvento": data_evento,
                "bPresenca": True,
                "cObservacao": obs
            }
        
        calendario_data.append(evento)


# Buscando a URI do MongoDB no .env
load_dotenv()
try:
    # Conecta-se ao MongoDB Atlas
    
    client = MongoClient(os.getenv("MONGODB_URI"), server_api=ServerApi('1'))
    client.admin.command('ping')
    print("Pinged your deployment. You successfully connected to MongoDB!")

    db = client['dbKronos']
    collection = db['calendario']
    
    print("Iniciando a inserção dos documentos...")
    result = collection.insert_many(calendario_data)
    
    print(f"Inserção concluída com sucesso! Total de documentos inseridos: {len(result.inserted_ids)}")
except Exception as e:
    print(f"Ocorreu um erro ao conectar ou inserir os dados: {e}")

