# 🐘 PostgreSQL + pgvector — Infraestrutura Plug & Play

Repositório de infraestrutura pronta para projetos que precisam de **IA + busca semântica**.  
Clone, rode um comando e tenha um banco PostgreSQL com suporte a vetores funcionando localmente.

-----

## O que está aqui

|Arquivo             |Descrição                                                      |
|--------------------|---------------------------------------------------------------|
|`docker-compose.yml`|Sobe o PostgreSQL 16 com pgvector via Docker                   |
|`init.sql`          |Ativa a extensão `vector`, cria tabela de exemplo e índice HNSW|
|`README.md`         |Este arquivo                                                   |

-----

## Pré-requisitos

- [Docker](https://docs.docker.com/get-docker/) instalado
- [Docker Compose](https://docs.docker.com/compose/) (já incluído no Docker Desktop)

-----

## Subindo a infraestrutura

```bash
docker-compose up -d
```

O banco ficará disponível em `localhost:5432` após ~5 segundos.

-----

## Derrubando a infraestrutura

```bash
docker-compose down -v
```

> ⚠️ O flag `-v` remove o volume de dados. Use apenas quando quiser um ambiente limpo.  
> Para parar sem apagar os dados: `docker-compose down`

-----

## Credenciais padrão

|Parâmetro|Valor      |
|---------|-----------|
|Host     |`localhost`|
|Porta    |`5432`     |
|Usuário  |`admin`    |
|Senha    |`admin123` |
|Banco    |`vector_db`|

String de conexão:

```
postgresql://admin:admin123@localhost:5432/vector_db
```

-----

## Verificando se o pgvector está ativo

```bash
docker exec ia-vector-db psql -U admin -d vector_db -c "\dx"
```

Você deve ver `vector` na lista de extensões instaladas.

-----

## Tabela de exemplo criada pelo init.sql

```sql
CREATE TABLE documents (
    id        SERIAL PRIMARY KEY,
    content   TEXT NOT NULL,
    metadata  JSONB,
    embedding vector(1536)   -- dimensão padrão OpenAI text-embedding-3-small
);
```

Um índice **HNSW** (`vector_cosine_ops`) é criado automaticamente para buscas por similaridade de cosseno.

### Exemplo de busca semântica

```sql
-- Busca os 5 documentos mais similares a um vetor de consulta
SELECT id, content, 1 - (embedding <=> '[0.1, 0.2, ...]'::vector) AS similaridade
FROM documents
ORDER BY embedding <=> '[0.1, 0.2, ...]'::vector
LIMIT 5;
```

-----

## Troubleshooting

|Erro                            |Causa                         |Solução                                         |
|--------------------------------|------------------------------|------------------------------------------------|
|Porta 5432 já em uso            |PostgreSQL rodando localmente |Mude para `5433:5432` no `docker-compose.yml`   |
|Extensão `vector` não encontrada|Imagem errada                 |Confirme que usa `pgvector/pgvector:pg16`       |
|`init.sql` não foi executado    |Container já existia antes    |`docker-compose down -v && docker-compose up -d`|
|Banco recusa conexão            |PostgreSQL ainda inicializando|Aguarde ~5s e tente novamente                   |

-----

## Casos de uso

- **RAG (Retrieval-Augmented Generation)** — armazene embeddings de documentos e recupere contexto relevante antes de chamar um LLM
- **Busca semântica** — encontre conteúdos por significado, não por palavras-chave
- **Sistemas de recomendação** — calcule similaridade entre itens usando vetores
- **Detecção de duplicatas** — identifique textos semanticamente equivalentes

-----

## Referências

- [pgvector — repositório oficial](https://github.com/pgvector/pgvector)
- [A Guide to Embeddings and pgvector](https://dev.to/googleai/a-guide-to-embeddings-and-pgvector-df0)
- [Introduction to RAG and Vector Databases](https://medium.com/@sachinsoni600517/introduction-to-rag-retrieval-augmented-generation-and-vector-database-b593e8eb6a94)