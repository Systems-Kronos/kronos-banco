import redis
import random

#Buscando chaves do .env
from dotenv import load_dotenv
import os
load_dotenv()

try:
    r = redis.Redis(
        host=os.getenv("HOSTREDIS"),
        port=int(os.getenv("PORTREDIS")),
        decode_responses=True,
        username="default",
        password=os.getenv("PASSWORDREDIS"),
    )
    r.ping()
    print("Conexão com o Redis estabelecida com sucesso!")
except redis.exceptions.ConnectionError as e:
    print(f"Erro ao conectar ao Redis: {e}")
    exit()


TOTAL_USUARIOS = 31  
TOTAL_MENSAGENS = 10 
NUM_NOTIFICACOES_POR_USUARIO = 50
total_notificacoes = TOTAL_USUARIOS * NUM_NOTIFICACOES_POR_USUARIO

pipeline = r.pipeline()

print(f"Iniciando a geração e inserção de {total_notificacoes} notificações...")

for i in range(1, TOTAL_USUARIOS + 1):
    for j in range(NUM_NOTIFICACOES_POR_USUARIO):
        notificacao_id = (i - 1) * NUM_NOTIFICACOES_POR_USUARIO + j + 1
        
        # Chaves para o Redis
        notificacao_key = f"notificacao:{notificacao_id}"
        usuario_key = f"usuario:{i}:notificacoes"

        # Atributos da notificação
        mensagem_id = random.randint(1, TOTAL_MENSAGENS)
        
        # Insere a notificação como um hash
        pipeline.hset(notificacao_key, mapping={
            "nCdUsuario": i,
            "nCdMensagem": mensagem_id
        })

result = pipeline.execute()

print("Inserção concluída com sucesso!")
print(f"Total de comandos executados pelo pipeline: {len(result)}")

