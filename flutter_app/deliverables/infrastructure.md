Lista de Requisitos de Infraestrutura (Entrega 9)

- SGBD e versão: SQLite (embutido) para protótipo; recomendação PostgreSQL 15+ para produção.
- Linguagem e versão: Dart 3.x with Flutter 3.x+ (ajustar conforme ambiente)
- Sistema Operacional: Desenvolvimento em Windows 10/11 ou Linux/macOS (tests realizados em Windows)

Requisitos mínimos de servidor (produção):
- CPU: 2 vCPU
- RAM: 2 GB (mínimo)
- Armazenamento: 10 GB
- Rede: 1 Gbps

Observações:
- Dependências Flutter gerenciadas via `pubspec.yaml` no projeto.
- Para banco relacional, executar o `db_script.sql` e configurar conexão no app (a versão atual usa um repositório mock em memória).
