Lista de Requisitos Funcionais (Entrega 1)

1. Autenticação
- RF01: O sistema deve permitir que usuários façam login com usuário e senha.
- RF02: Em caso de falha, exibir razão (usuário não encontrado ou senha incorreta) e permanecer/redirecionar para tela de login.

2. Gestão de Usuários (mínimo: leitura)
- RF03: O sistema deve armazenar usuários com id, nome, login e senha.

3. Cadastro de Produtos
- RF04: Permitir cadastro de produto com campos: id, nome, descricao, tamanho, peso, estoqueMinimo, quantidadeEstoque.
- RF05: Listar produtos em tabela automaticamente ao acessar a tela.
- RF06: Buscar produtos por termo (nome).
- RF07: Inserir novo produto com validações (nome obrigatório, peso numérico, estoqueMinimo inteiro >=0, quantidade inicial >=0).
- RF08: Editar produto existente com mesmas validações.
- RF09: Excluir produto.

4. Gestão de Estoque
- RF10: Listar produtos em ordem alfabética (algoritmo de ordenação implementado explicitamente).
- RF11: Selecionar produto e escolher tipo de movimentação: entrada ou saída.
- RF12: Informar data da movimentação.
- RF13: Ao registrar saída, verificar estoque disponível e impedir saídas maiores que o estoque.
- RF14: Após qualquer saída, verificar se estoque < estoqueMinimo e emitir alerta.
- RF15: Registrar histórico completo de movimentações (id, produtoId, usuarioId, tipo, quantidade, data).

5. Interface Principal
- RF16: Exibir nome do usuário logado.
- RF17: Permitir logout redirecionando à tela de login.
- RF18: A partir da tela principal, acessar Cadastro de Produto e Gestão de Estoque.

6. Outras
- RF19: Interfaces com design responsivo para desktop/web via Flutter.
- RF20: Aplicar validações em formulários e mensagens de erro claras.

Observações:
- A autenticação e persistência no protótipo atual são feitas em memória (MockRepository). Para produção, usar um SGBD relacional.
