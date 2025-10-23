import '../models/user.dart';
import '../models/product.dart';
import '../models/movement.dart';

class MockRepository {
  List<User> users = [
    User(id: 1, nome: 'Administrador', login: 'admin', senha: 'admin123')
  ];
  List<Product> products = [
    Product(
        id: 1,
        nome: 'Martelo A',
        descricao: 'Martelo com cabeça de aço',
        tamanho: 'Médio',
        peso: 0.75,
        estoqueMinimo: 10,
        quantidadeEstoque: 15),
    Product(
        id: 2,
        nome: 'Martelo B',
        descricao: 'Martelo leve',
        tamanho: 'Pequeno',
        peso: 0.5,
        estoqueMinimo: 5,
        quantidadeEstoque: 8),
    Product(
        id: 3,
        nome: 'Chave 4mm',
        descricao: 'Ponta imantada',
        tamanho: 'Único',
        peso: 0.05,
        estoqueMinimo: 20,
        quantidadeEstoque: 25),
  ];
  List<Movement> movements = [];

  User? authenticate(String login, String senha) {
    try {
      return users.firstWhere((u) => u.login == login && u.senha == senha);
    } catch (e) {
      return null;
    }
  }

  User addUser(String nome, String login, String senha) {
    final u = User(
        id: DateTime.now().millisecondsSinceEpoch,
        nome: nome,
        login: login,
        senha: senha);
    users.add(u);
    return u;
  }

  List<Product> listProducts() => products;

  Product addProduct(String nome,
      {String descricao = '',
      String tamanho = '',
      double peso = 0.0,
      int estoqueMinimo = 0,
      int quantidadeEstoque = 0}) {
    final p = Product(
        id: DateTime.now().millisecondsSinceEpoch,
        nome: nome,
        descricao: descricao,
        tamanho: tamanho,
        peso: peso,
        estoqueMinimo: estoqueMinimo,
        quantidadeEstoque: quantidadeEstoque);
    products.add(p);
    return p;
  }

  void updateProduct(Product p) {
    final idx = products.indexWhere((x) => x.id == p.id);
    if (idx >= 0) products[idx] = p;
  }

  void deleteProduct(int id) {
    products.removeWhere((p) => p.id == id);
  }

  Movement addMovement(
      int produtoId, int usuarioId, String tipo, int quantidade, String data) {
    final m = Movement(
        id: DateTime.now().millisecondsSinceEpoch,
        produtoId: produtoId,
        usuarioId: usuarioId,
        tipo: tipo,
        quantidade: quantidade,
        data: data);
    movements.add(m);
    final prod = products.firstWhere((p) => p.id == produtoId);
    if (tipo == 'entrada')
      prod.quantidadeEstoque += quantidade;
    else
      prod.quantidadeEstoque -= quantidade;
    updateProduct(prod);
    return m;
  }

  User? getUserById(int id) {
    try {
      return users.firstWhere((u) => u.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Movement> listMovementsByProduct(int produtoId) =>
      movements.where((m) => m.produtoId == produtoId).toList();
}

final mockRepo = MockRepository();
