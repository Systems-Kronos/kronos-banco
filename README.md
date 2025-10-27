# kronos-banco

## Índice
- [📓 Sobre](#-sobre)
- [🚀 Tecnologias](#-tecnologias)
- [🧱 Estrutura do Projeto](#-estrutura-do-projeto)
- [📄 Licença](#-licença)
- [💻 Autores](#-autores)

</br>

## 📓 Sobre
Este repositório contém a configuração completa de bancos de dados para o projeto Kronos, incluindo o modelo relacional em SQL, scripts de carga de dados e scripts para bancos de dados NoSQL, como MongoDB e Redis.

</br>

## 🚀 Tecnologias
- PostgreSQL
- MongoDB
- Redis
- Python
- SQL (PL/pgSQL)

</br>

## 🧱 Estrutura do Projeto
```
kronos-banco
├── /MongoDB                   # Scripts para o banco de dados NoSQL
  └── /DataLoad_MongoDB.py     # Script Python para carregar dados no MongoDB
├── /Redis                     # Scripts para o banco de dados de cache
  └── /DataLoad_Redis.py       # Script Python para carregar dados no Redis
├── /SQL                       # Scripts para o banco de dados relacional (PostgreSQL)
  └── /Functions               # Funções para lógica de negócios e validações
  └── /JOBS
  └── /Modelo                  # Contém o modelo de dados e o script de carga inicial
  └── /Procedures              # Procedimentos armazenados para automatizar tarefas
  └── /Triggers                # Gatilhos que executam as funções automaticamente.
  └── /Views
├── requirements.txt           # Lista de dependências
└── README.md                  # Documentação do projeto
```

</br>

## 📄 Licença
Este projeto está licenciado sob a licença MIT — veja o arquivo LICENSE para mais detalhes.

</br>

## 💻 Autores
- [Dmitri Kogake](https://github.com/Kogake7)
- [Theo Martins](https://github.com/TheoMGtech)
