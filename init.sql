-- Habilita a extensao pgvector
CREATE EXTENSION IF NOT EXISTS vector;

-- Tabela de exemplo: documentos com embeddings de 1536 dimensoes (padrao OpenAI)
CREATE TABLE IF NOT EXISTS documents (
    id        SERIAL PRIMARY KEY,
    content   TEXT NOT NULL,
    metadata  JSONB,
    embedding vector(1536)
);

-- Indice HNSW para busca por similaridade (mais rapido que IVFFlat em leituras)
CREATE INDEX IF NOT EXISTS documents_embedding_idx
    ON documents
    USING hnsw (embedding vector_cosine_ops);

-- Registro de exemplo (embedding zerado apenas para validar o schema)
INSERT INTO documents (content, metadata, embedding)
VALUES (
    'Documento de exemplo para validar a infraestrutura pgvector.',
    '{"source": "init", "tags": ["exemplo", "pgvector"]}',
    array_fill(0, ARRAY[1536])::vector
);
