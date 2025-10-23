import '../models/user.dart';
import '../models/product.dart';
import '../models/movement.dart';
import 'db_provider.dart';

class DBRepository {
  final DBProvider _dbp = DBProvider();

  Future<User?> authenticate(String login, String senha) async {
    final db = await _dbp.database;
    final res = await db.query('usuario',
        where: 'login = ? AND senha = ?', whereArgs: [login, senha]);
    if (res.isEmpty) return null;
    final row = res.first;
    return User(
        id: row['id'] as int,
        nome: row['nome'] as String,
        login: row['login'] as String,
        senha: row['senha'] as String);
  }

  Future<User?> getUserById(int id) async {
    final db = await _dbp.database;
    final res = await db.query('usuario', where: 'id = ?', whereArgs: [id]);
    if (res.isEmpty) return null;
    final row = res.first;
    return User(
        id: row['id'] as int,
        nome: row['nome'] as String,
        login: row['login'] as String,
        senha: row['senha'] as String);
  }

  Future<User?> getUserByLogin(String login) async {
    final db = await _dbp.database;
    final res =
        await db.query('usuario', where: 'login = ?', whereArgs: [login]);
    if (res.isEmpty) return null;
    final row = res.first;
    return User(
        id: row['id'] as int,
        nome: row['nome'] as String,
        login: row['login'] as String,
        senha: row['senha'] as String);
  }

  Future<User> addUser(String nome, String login, String senha) async {
    final db = await _dbp.database;
    final id = DateTime.now().millisecondsSinceEpoch;
    await db.insert(
        'usuario', {'id': id, 'nome': nome, 'login': login, 'senha': senha});
    return User(id: id, nome: nome, login: login, senha: senha);
  }

  Future<List<Product>> listProducts() async {
    final db = await _dbp.database;
    final res = await db.query('produto');
    return res
        .map((r) => Product(
            id: r['id'] as int,
            nome: r['nome'] as String,
            descricao: r['descricao'] as String? ?? '',
            tamanho: r['tamanho'] as String? ?? '',
            peso: (r['peso'] as num?)?.toDouble() ?? 0.0,
            estoqueMinimo: r['estoque_minimo'] as int? ?? 0,
            quantidadeEstoque: r['quantidade_estoque'] as int? ?? 0))
        .toList();
  }

  Future<Product> addProduct(Product p) async {
    final db = await _dbp.database;
    final id = DateTime.now().millisecondsSinceEpoch;
    await db.insert('produto', {
      'id': id,
      'nome': p.nome,
      'descricao': p.descricao,
      'tamanho': p.tamanho,
      'peso': p.peso,
      'estoque_minimo': p.estoqueMinimo,
      'quantidade_estoque': p.quantidadeEstoque
    });
    p.id = id;
    return p;
  }

  Future<void> updateProduct(Product p) async {
    final db = await _dbp.database;
    await db.update(
        'produto',
        {
          'nome': p.nome,
          'descricao': p.descricao,
          'tamanho': p.tamanho,
          'peso': p.peso,
          'estoque_minimo': p.estoqueMinimo,
          'quantidade_estoque': p.quantidadeEstoque
        },
        where: 'id = ?',
        whereArgs: [p.id]);
  }

  Future<void> deleteProduct(int id) async {
    final db = await _dbp.database;
    await db.delete('produto', where: 'id = ?', whereArgs: [id]);
  }

  Future<Movement> addMovement(int produtoId, int usuarioId, String tipo,
      int quantidade, String data) async {
    final db = await _dbp.database;
    final id = DateTime.now().millisecondsSinceEpoch;
    await db.insert('movimentacao', {
      'id': id,
      'produto_id': produtoId,
      'usuario_id': usuarioId,
      'tipo': tipo,
      'quantidade': quantidade,
      'data': data
    });
    // update product stock
    final prodRes =
        await db.query('produto', where: 'id = ?', whereArgs: [produtoId]);
    if (prodRes.isNotEmpty) {
      final prod = prodRes.first;
      final current = prod['quantidade_estoque'] as int? ?? 0;
      int updated =
          tipo == 'entrada' ? current + quantidade : current - quantidade;
      await db.update('produto', {'quantidade_estoque': updated},
          where: 'id = ?', whereArgs: [produtoId]);
    }
    return Movement(
        id: id,
        produtoId: produtoId,
        usuarioId: usuarioId,
        tipo: tipo,
        quantidade: quantidade,
        data: data);
  }

  Future<List<Movement>> listMovements() async {
    final db = await _dbp.database;
    final res = await db.query('movimentacao');
    return res
        .map((r) => Movement(
            id: r['id'] as int,
            produtoId: r['produto_id'] as int,
            usuarioId: r['usuario_id'] as int,
            tipo: r['tipo'] as String,
            quantidade: r['quantidade'] as int,
            data: r['data'] as String))
        .toList();
  }
}

final dbRepo = DBRepository();
