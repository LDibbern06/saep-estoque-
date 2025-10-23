SAEP - Deliverables

Conteúdo da pasta:
- requirements.md
- der.md
- db_script.sql
- test_cases.md
- infrastructure.md
- sistema/ (copiar o código-fonte do app Flutter aqui)

Como executar o protótipo Flutter (local)
1. Tenha Flutter SDK instalado e configurado (flutter doctor).
2. Abra o projeto em `flutter_app/` com VS Code ou Android Studio.
3. No terminal, execute:

```powershell
cd c:\Users\DevSESIB\Documents\saep-estoque-\flutter_app
flutter pub get
flutter run -d chrome
```

Notas sobre o protótipo
- O projeto usa um repositório em memória (`lib/services/mock_repository.dart`) com dados seed.
- Para persistir dados, adapte a aplicação para usar SQLite (sqflite) ou um backend com API REST e conecte ao `db_script.sql`.

Alterações importantes realizadas
- Implementado formulário completo de produtos (nome, descricao, tamanho, peso, estoque minimo, quantidade inicial).
- Implementado ordenação por insertion sort na tela de gestão de estoque.
- Registro de movimentos e histórico exibido na tela de estoque.
- Validações e mensagens de erro/alerta para login, produtos e movimentações.

Entrega
- Compacte a pasta `deliverables` junto com `sistema` com seu nome como solicitado.
