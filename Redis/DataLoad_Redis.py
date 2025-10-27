import redis
import random
import json
from datetime import datetime
from dotenv import load_dotenv
import os

load_dotenv()

try:
    r = redis.Redis(
        host=os.getenv("REDIS_HOST"),
        port=os.getenv("REDIS_PORT"),
        username=os.getenv("REDIS_USER"),
        password=os.getenv("REDIS_PASSWORD"),
        decode_responses=True  # para já decodificar as respostas para str
    )

    r.ping()  # testa a conexão
    print("Conexão com o Redis estabelecida com sucesso!")
except redis.exceptions.ConnectionError as e:
    print(f"Erro ao conectar ao Redis: {e}")
    exit()


TOTAL_USUARIOS = 31  
MENSAGENS_POSSIBILIDADES = ["Nova tarefa atribuída para você", "Nova tarefa realocada para você", "Gestor aceitou sua falta!", "Gestor rejeitou sua falta!"]
NUM_NOTIFICACOES_POR_USUARIO = 25
total_notificacoes = TOTAL_USUARIOS * NUM_NOTIFICACOES_POR_USUARIO

pipeline = r.pipeline()
print(f"Iniciando a geração e inserção de {total_notificacoes} notificações...")

for i in range(1, TOTAL_USUARIOS + 1):
    for j in range(NUM_NOTIFICACOES_POR_USUARIO):
        notificacao_id = (i - 1) * NUM_NOTIFICACOES_POR_USUARIO + j + 1

        notificacao_id = r.incr(f"usuario:{i}:notificacao:id")
        notificacao_key = f"usuario:{i}:notificacao:{notificacao_id}"


        # Atributos da notificação
        mensagem = random.choice(MENSAGENS_POSSIBILIDADES)
        agora = datetime.now().isoformat()

        
        # Insere a notificação como um hash
        pipeline.hset(notificacao_key, mapping={
            "nCdUsuario": i,
            "cMensagem": json.dumps(mensagem),
            "dCriacao": json.dumps(agora)   # vira "Gestor aceitou sua falta!"
        })

result = pipeline.execute()

print("Inserção concluída com sucesso!")
print(f"Total de comandos executados pelo pipeline: {len(result)}")