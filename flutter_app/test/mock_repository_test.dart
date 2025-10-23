import 'package:flutter_test/flutter_test.dart';
import 'package:saep_flutter/services/db_repository.dart';
import 'package:saep_flutter/services/mock_repository.dart' as _mock;

void main() {
  test('authenticate valid user', () async {
    final u = await dbRepo.authenticate('admin', 'admin123');
    expect(u, isNotNull);
    expect(u!.login, 'admin');
  });

  test('add product and find', () async {
    // use mock repo to avoid modifying DB schema here
    final p = _mock.mockRepo.addProduct('Teste X',
        descricao: 'desc',
        tamanho: 'P',
        peso: 1.2,
        estoqueMinimo: 2,
        quantidadeEstoque: 5);
    final list = _mock.mockRepo.listProducts();
    expect(list.any((t) => t.id == p.id), true);
  });
}
