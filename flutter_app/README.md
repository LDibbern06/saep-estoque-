# SAEP - Sistema de Almoxarifado (Protótipo Flutter)

Este repositório contém um protótipo em Flutter do SAEP — Sistema para controle de estoque (entrada/saída), cadastro de produtos e autenticação de usuários. O projeto usa SQLite para persistência local (protótipo desktop/mobile).

## Visão geral
- Autenticação de usuários (login/registro).
- Cadastro completo de produtos (nome, descrição, tamanho, peso, estoque mínimo, quantidade).
- Gestão de estoque: registrar movimentos de entrada/saída com data, alertas de estoque mínimo e histórico de movimentações.
- Persistência: SQLite (`sqflite`) com DB inicializado em `lib/services/db_provider.dart` (seed com usuário `admin/admin123` e alguns produtos).

## Estrutura principal
- `lib/main.dart` — roteamento e inicialização.
- `lib/screens/` — telas: `login_screen.dart`, `register_screen.dart`, `home_screen.dart`, `products_screen.dart`, `stock_screen.dart`.
- `lib/models/` — modelos: `user.dart`, `product.dart`, `movement.dart`.
- `lib/services/db_provider.dart` — criação e seed do banco SQLite.
- `lib/services/db_repository.dart` — acesso ao banco via métodos assíncronos (exportado como `dbRepo`).
- `lib/services/mock_repository.dart` — repositório em memória (mantido como fallback/testes internos).
- `deliverables/` — documentos gerados (requisitos, DER em `der.md`, script SQL, casos de teste, infraestrutura, README de entrega).

## Diagrama 

```
+----------------+        1    *        +--------------------+       *    1    +-------------+
|    Usuario     |----------------------|   Movimentacao     |-------------------|   Produto   |
|----------------|                      |--------------------|                   |-------------|
| id (PK)        |                      | id (PK)            |                   | id (PK)     |
| nome           |                      | produto_id (FK)    |                   | nome        |
| login          |                      | usuario_id (FK)    |                   | descricao   |
| senha          |                      | tipo (entrada/saida)|                  | tamanho     |
+----------------+                      | quantidade         |                   | peso        |
										| data               |                   | estoque_min |
										+--------------------+                   | quantidade  |
																				 +-------------+

Relacionamentos:
- Usuario 1..* Movimentacao (um usuário registra muitas movimentações)
- Produto 1..* Movimentacao (um produto tem muitas movimentações)
```

## Diagrama de Classes

```
+----------------+
|     User      |
+----------------+
| - id: int     |
| - nome: String|
| - login: String|
| - senha: String|
+----------------+
| + authenticate()|
| + register()   |
+----------------+

+----------------+
|    Product    |
+----------------+
| - id: int     |
| - nome: String|
| - descricao: String|
| - tamanho: String|
| - peso: double|
| - estoqueMinimo: int|
| - quantidadeEstoque: int|
+----------------+
| + save()      |
| + update()    |
| + delete()    |
+----------------+

+----------------+
|   Movement    |
+----------------+
| - id: int     |
| - produtoId: int|
| - usuarioId: int|
| - tipo: String|
| - quantidade: int|
| - data: DateTime|
+----------------+
| + register()  |
+----------------+

+-----------------+
| DBRepository   |
+-----------------+
| + authenticate()|
| + addUser()    |
| + listProducts()|
| + addProduct() |
| + updateProduct()|
| + deleteProduct()|
| + addMovement() |
| + listMovements()|
+-----------------+
```

## Requisitos Funcionais

1. **Autenticação de Usuários**
   - RF01: Sistema deve permitir login com usuário e senha
   - RF02: Sistema deve permitir registro de novos usuários
   - RF03: Sistema deve validar credenciais antes do acesso

2. **Gestão de Produtos**
   - RF04: Sistema deve permitir cadastro de produtos com todos os campos
   - RF05: Sistema deve permitir edição de produtos existentes
   - RF06: Sistema deve permitir exclusão de produtos
   - RF07: Sistema deve permitir busca de produtos por nome

3. **Controle de Estoque**
   - RF08: Sistema deve permitir registro de entrada de produtos
   - RF09: Sistema deve permitir registro de saída de produtos
   - RF10: Sistema deve mostrar alertas quando estoque < mínimo
   - RF11: Sistema deve ordenar produtos alfabeticamente
   - RF12: Sistema deve manter histórico de movimentações

## Requisitos Técnicos Utilizados

1. **Frontend / UI**
   - Flutter SDK (última versão estável)
   - Material Design 3 (tema e componentes)
   - Widgets: DataTable, ListView, Card, AlertDialog
   - Navegação: Navigator 2.0 com rotas nomeadas

2. **Persistência**
   - SQLite via package sqflite
   - Padrão Repository para abstração do banco
   - Path provider para localização do DB
   - Migrations e seed data automatizados

3. **Funcionalidades**
   - Validação de formulários
   - Estado local com setState
   - Operações assíncronas (async/await)
   - Ordenação via insertion sort
   - Gerenciamento de sessão do usuário

4. **Desenvolvimento**
   - VS Code com Flutter extension
   - Git para controle de versão
   - Flutter DevTools para debug
   - Flutter test para testes unitários

## Como rodar (Windows PowerShell)
1. Instale o Flutter SDK e confirme com `flutter doctor`.
2. No terminal execute:

```powershell
cd C:\Users\DevSESIB\Documents\saep-estoque-\flutter_app
flutter pub get
flutter run -d chrome   # ou -d windows / -d edge / escolher um device
```

> Observação: `sqflite` funciona no mobile/desktop. Para rodar no Chrome (web) a persistência não usará sqflite — o protótipo foi testado principalmente em desktop/emulador.

## Credenciais iniciais
- Usuário: `admin`
- Senha: `admin123`

## Como testar funcionalidades principais
- Login: insira `admin` / `admin123`.
- Cadastro de usuário: use "Cadastrar" na tela de login.
- Produtos: Home → Cadastro de Produto (Adicionar / Editar / Excluir / Buscar).
- Estoque: Home → Gestão de Estoque (Selecionar produto → Entrada/Saída → Registrar). O sistema alerta quando o estoque ficar abaixo do mínimo.
- Histórico: abaixo da tela de gestão de estoque há um histórico de movimentações.

## Script SQL
- O script SQL de criação/população está em `deliverables/db_script.sql`. O DB local (SQLite) é inicializado automaticamente via `db_provider.dart` no primeiro run.

## Testes rápidos
- Há um pequeno teste em `test/mock_repository_test.dart`. Para rodar os testes:

```powershell
flutter test
```

## Empacotamento para entrega
- Para preparar a pasta `sistema/` e gerar um ZIP, copie o conteúdo do diretório atual para `sistema/` e compacte. Por exemplo (PowerShell):

```powershell
cd ..\   # entrar no diretório que contém flutter_app
mkdir sistema
Copy-Item -Recurse flutter_app\* sistema\
Compress-Archive -Path sistema -DestinationPath "<SeuNome>.zip"
```

## Próximos passos recomendados
- Melhorar UX: usar SnackBars, loaders e validação inline.
- Adicionar testes end-to-end (integration_test) cobrindo fluxo: login → cadastrar produto → saída → alerta.
- Preparar versão servidor (API + PostgreSQL) para multi-usuário e deploy em nuvem.

## Observações finais
- O protótipo foi desenvolvido como entrega prática para a disciplina/desafio SAEP. A persistência foi implementada com SQLite visando integridade e facilidade de consulta, acompanhando o DER do projeto.
- Se quiser, eu posso: gerar o ZIP final com seu nome, ou migrar para Sembast (web) ou criar backend + PostgreSQL. Diga qual opção prefere.

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------