Diagrama Entidade-Relacionamento (DER) - SAEP

Entidades:

1. Usuario (User)
- id (PK)
- nome
- login
- senha

2. Produto (Product)
- id (PK)
- nome
- descricao
- tamanho
- peso
- estoque_minimo
- quantidade_estoque

3. Movimentacao (Movement)
- id (PK)
- produto_id (FK -> Produto.id)
- usuario_id (FK -> Usuario.id)
- tipo (entrada|saida)
- quantidade
- data (YYYY-MM-DD)

Relacionamentos:
- Usuario 1..* Movimentacao (um usuário pode registrar várias movimentações)
- Produto 1..* Movimentacao (um produto pode ter várias movimentações)

Representação ASCII:

Usuario (id PK)
    |
    | 1..*
Movimentacao (id PK, produto_id FK, usuario_id FK, tipo, quantidade, data)
    |
    | *..1
Produto (id PK)

Observação: índices recomendados em Produto.nome (para ordenação/busca) e Movimentacao.data (para histórico).
