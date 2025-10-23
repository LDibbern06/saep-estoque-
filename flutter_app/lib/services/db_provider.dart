import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  static final DBProvider _instance = DBProvider._internal();
  factory DBProvider() => _instance;
  DBProvider._internal();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'saep.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  FutureOr<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE usuario (
        id INTEGER PRIMARY KEY,
        nome TEXT NOT NULL,
        login TEXT NOT NULL UNIQUE,
        senha TEXT NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE produto (
        id INTEGER PRIMARY KEY,
        nome TEXT NOT NULL,
        descricao TEXT,
        tamanho TEXT,
        peso REAL,
        estoque_minimo INTEGER DEFAULT 0,
        quantidade_estoque INTEGER DEFAULT 0
      );
    ''');

    await db.execute('''
      CREATE TABLE movimentacao (
        id INTEGER PRIMARY KEY,
        produto_id INTEGER NOT NULL,
        usuario_id INTEGER NOT NULL,
        tipo TEXT NOT NULL,
        quantidade INTEGER NOT NULL,
        data TEXT NOT NULL,
        FOREIGN KEY(produto_id) REFERENCES produto(id),
        FOREIGN KEY(usuario_id) REFERENCES usuario(id)
      );
    ''');

    // seed sample data
    await db.insert('usuario', {
      'id': 1,
      'nome': 'Administrador',
      'login': 'admin',
      'senha': 'admin123'
    });
    await db.insert('produto', {
      'id': 1,
      'nome': 'Martelo A',
      'descricao': 'Martelo com cabeça de aço',
      'tamanho': 'Médio',
      'peso': 0.75,
      'estoque_minimo': 10,
      'quantidade_estoque': 15
    });
    await db.insert('produto', {
      'id': 2,
      'nome': 'Martelo B',
      'descricao': 'Martelo leve',
      'tamanho': 'Pequeno',
      'peso': 0.5,
      'estoque_minimo': 5,
      'quantidade_estoque': 8
    });
    await db.insert('produto', {
      'id': 3,
      'nome': 'Chave 4mm',
      'descricao': 'Ponta imantada',
      'tamanho': 'Único',
      'peso': 0.05,
      'estoque_minimo': 20,
      'quantidade_estoque': 25
    });
  }
}
