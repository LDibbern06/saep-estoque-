import '../lib/services/mock_repository.dart' as repo;

void main() {
  final u = repo.mockRepo.authenticate('admin', 'admin123');
  print('Auth admin: ${u != null ? 'OK' : 'FAIL'}');
  final p = repo.mockRepo.addProduct('Teste X',
      descricao: 'desc',
      tamanho: 'P',
      peso: 1.2,
      estoqueMinimo: 2,
      quantidadeEstoque: 5);
  final exists = repo.mockRepo.listProducts().any((t) => t.id == p.id);
  print('Add product: ${exists ? 'OK' : 'FAIL'}');
}
