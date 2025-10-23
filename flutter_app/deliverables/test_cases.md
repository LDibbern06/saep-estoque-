Descritivo de Casos de Teste de Software (Entrega 8)

Ambiente e Ferramentas
- Plataforma: Flutter 3.x (ou versão compatível com o projeto)
- SGBD (para versão com persistência): SQLite/PostgreSQL
- Ferramentas: flutter test, debugger, emulador/Chrome

Casos de Teste por Requisito

RF01 - Autenticação
- CT01: Login válido
  - Pré: usuário 'admin' com senha 'admin123' existe
  - Passos: preencher login e senha, clicar Entrar
  - Resultado esperado: Redireciona para Home e exibe nome do usuário
- CT02: Usuário inexistente
  - Passos: usar login não cadastrado
  - Resultado: Mensagem 'Usuário não encontrado'
- CT03: Senha incorreta
  - Passos: preencher login existente com senha errada
  - Resultado: Mensagem 'Senha incorreta'

RF04-RF09 - Cadastro de Produto
- CT04: Listagem inicial
  - Verificar se produtos seed aparecem na listagem
- CT05: Inserção válida
  - Inserir produto com todos os campos válidos
  - Resultado: registro aparece na lista com dados corretos
- CT06: Validação de nome
  - Tentar inserir sem nome -> mensagem de validação
- CT07: Edição
  - Editar campo nome e salvar -> dados atualizados
- CT08: Exclusão
  - Excluir produto -> não deve mais aparecer

RF10-RF15 - Gestão de Estoque
- CT09: Ordenação alfabética
  - Verificar que a listagem está em ordem alfabética (case-insensitive)
- CT10: Entrada
  - Selecionar produto, tipo entrada, quantidade positiva, aplicar
  - Resultado: quantidade aumenta e movimentação gravada
- CT11: Saída
  - Selecionar produto, tipo saída menor que estoque, aplicar
  - Resultado: quantidade diminui e movimentação gravada
- CT12: Saída maior que estoque
  - Resultado: bloquear e mostrar erro
- CT13: Alerta de estoque mínimo
  - Deixar estoque abaixo do mínimo via saída -> alerta apresentado

Histórico
- CT14: Histórico grava usuário, data e tipo corretamente

Testes de Integração
- TI01: Fluxo completo: login -> cadastro -> saída -> alerta -> histórico

Observações
- Testes manuais com emulador e testes automatizados com flutter test para funções de serviço (mockRepository).
