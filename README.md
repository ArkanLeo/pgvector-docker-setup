# Banco de Dados Vetorizado para IA (PostgreSQL + pgvector)

## 📋 Descrição

Este repositório contém a infraestrutura “Plug & Play” para um banco de dados PostgreSQL com suporte a **embeddings** e **busca semântica** usando a extensão `pgvector`. É o ponto de partida para projetos que utilizam **RAG (Retrieval-Augmented Generation)** com Inteligência Artificial.

## 🚀 Como Usar

### Pré-requisitos

- Docker instalado na sua máquina
- Docker Compose instalado

### Subir o Banco de Dados

```bash
# Clone este repositório
git clone https://github.com/seu-usuario/seu-repositorio.git
cd seu-repositorio

# Suba o banco de dados
docker-compose up -d

# Aguarde 5 segundos para o banco inicializar completamente
sleep 5

# Verifique se a extensão pgvector foi criada
docker exec ia-vector-db psql -U admin -d vector_db -c "\dx"
```

Você deve ver a extensão `vector` listada.

### Conectar ao Banco de Dados

```bash
# Acesse o banco via psql
docker exec -it ia-vector-db psql -U admin -d vector_db

# Dentro do psql, teste uma query
SELECT * FROM documents;
```

### Derrubar o Banco de Dados

```bash
# Parar e remover containers
docker-compose down

# Se quiser remover também os volumes (CUIDADO: deleta os dados!)
docker-compose down -v
```

## 🔧 Configuração

### Credenciais Padrão

- **Usuário:** `admin`
- **Senha:** `senha123` (MUDE ISSO EM PRODUÇÃO!)
- **Banco de Dados:** `vector_db`
- **Porta:** `5432`

### Arquivo `docker-compose.yml`

O arquivo define:

- **Imagem:** `pgvector/pgvector:pg16` (PostgreSQL 16 com pgvector pré-compilado)
- **Volumes:** Persistência de dados em `pg_data` e injeção do script `init.sql`
- **Portas:** Mapeamento da porta 5432

### Arquivo `init.sql`

Executado automaticamente na primeira inicialização. Contém:

- Criação da extensão `pgvector`
- Criação de tabela exemplo `documents` com coluna de embeddings
- Criação de índice para buscas otimizadas

## 📚 Próximos Passos

1. **Integrar com sua aplicação:** Use a biblioteca `psycopg2` (Python) ou `pg` (Node.js) para conectar.
1. **Gerar embeddings:** Use APIs como OpenAI, Hugging Face ou modelos locais.
1. **Implementar RAG:** Armazene embeddings e implemente buscas semânticas.

## 🐛 Troubleshooting

### “Erro: porta 5432 já está em uso”

Você já tem um PostgreSQL rodando. Opções:

- Parar o PostgreSQL existente
- Mudar a porta no `docker-compose.yml` para `5433:5432`

### “Erro: extensão vector não encontrada”

Você usou a imagem `postgres:latest` em vez de `pgvector/pgvector:pg16`. Corrija o `docker-compose.yml`.

### “Erro: init.sql não foi executado”

O script só roda na primeira inicialização. Se você já tinha subido o container:

```bash
docker-compose down -v  # Remove volume
docker-compose up -d    # Sobe novamente
```

### “Erro: container sobe mas banco recusa conexão”

Aguarde 5 segundos. O PostgreSQL demora um pouco para inicializar.

## 📖 Referências

- [pgvector GitHub](https://github.com/pgvector/pgvector)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)
- [12-Factor App](https://12factor.net/)

## ✅ Checklist

- [ ] Docker e Docker Compose instalados
- [ ] Repositório clonado
- [ ] `docker-compose up -d` executado com sucesso
- [ ] Extensão pgvector verificada
- [ ] Banco de dados acessível em localhost:5432

-----

**Criado para:** Aula 16 — Arquitetura de Software (Ciclo 03)  
**Disciplina:** Arquitetura de Software  
**Instituição:** UniEVANGÉLICA  
**Período:** 2026.1