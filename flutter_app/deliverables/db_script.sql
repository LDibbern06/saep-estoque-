-- Script de criação e população do banco de dados (SQLite / PostgreSQL compatible SQL)

-- Tabela Usuario
CREATE TABLE usuario (
  id INTEGER PRIMARY KEY,
  nome TEXT NOT NULL,
  login TEXT NOT NULL UNIQUE,
  senha TEXT NOT NULL
);

-- Tabela Produto
CREATE TABLE produto (
  id INTEGER PRIMARY KEY,
  nome TEXT NOT NULL,
  descricao TEXT,
  tamanho TEXT,
  peso REAL,
  estoque_minimo INTEGER DEFAULT 0,
  quantidade_estoque INTEGER DEFAULT 0
);

-- Tabela Movimentacao
CREATE TABLE movimentacao (
  id INTEGER PRIMARY KEY,
  produto_id INTEGER NOT NULL REFERENCES produto(id),
  usuario_id INTEGER NOT NULL REFERENCES usuario(id),
  tipo TEXT NOT NULL CHECK (tipo IN ('entrada','saida')),
  quantidade INTEGER NOT NULL,
  data DATE NOT NULL
);

-- Dados de exemplo
INSERT INTO usuario (id, nome, login, senha) VALUES (1, 'Administrador', 'admin', 'admin123');

INSERT INTO produto (id, nome, descricao, tamanho, peso, estoque_minimo, quantidade_estoque) VALUES
(1, 'Martelo A', 'Martelo com cabeça de aço', 'Médio', 0.75, 10, 15),
(2, 'Martelo B', 'Martelo leve', 'Pequeno', 0.5, 5, 8),
(3, 'Chave 4mm', 'Ponta imantada', 'Único', 0.05, 20, 25);

-- Movimentações de amostra
INSERT INTO movimentacao (id, produto_id, usuario_id, tipo, quantidade, data) VALUES
(1, 1, 1, 'entrada', 5, '2025-10-01'),
(2, 3, 1, 'saida', 2, '2025-10-10');
