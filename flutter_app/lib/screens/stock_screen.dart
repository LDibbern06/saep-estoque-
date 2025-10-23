import 'package:flutter/material.dart';
import '../services/db_repository.dart';
import '../models/product.dart';
import '../models/movement.dart';

class StockScreen extends StatefulWidget {
  @override
  _StockScreenState createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  List<Product> products = [];
  int? selectedId;
  String tipo = 'entrada';
  final quantidadeController = TextEditingController(text: '1');
  final dataController = TextEditingController(
      text: DateTime.now().toIso8601String().split('T').first);

  @override
  void initState() {
    super.initState();
    _loadProducts();
    // insertion sort by name (case-insensitive)
    // sorting will happen after load
  }

  Future<void> _loadProducts() async {
    products = await dbRepo.listProducts();
    // insertion sort
    for (int i = 1; i < products.length; i++) {
      final key = products[i];
      int j = i - 1;
      while (j >= 0 &&
          products[j].nome.toLowerCase().compareTo(key.nome.toLowerCase()) >
              0) {
        products[j + 1] = products[j];
        j = j - 1;
      }
      products[j + 1] = key;
    }
    setState(() {});
  }

  void _apply() async {
    if (selectedId == null) return _show('Erro', 'Selecione um produto');
    final q = int.tryParse(quantidadeController.text) ?? 0;
    if (q <= 0) return _show('Validação', 'Quantidade inválida');
    final prod = products.firstWhere((p) => p.id == selectedId);
    if (tipo == 'saida' && prod.quantidadeEstoque - q < 0)
      return _show('Erro', 'Estoque insuficiente');
    // obtain user id from navigation args (user object)
    final navUser = ModalRoute.of(context)!.settings.arguments;
    int userId = 1;
    if (navUser is int)
      userId = navUser;
    else if (navUser is Map && navUser['id'] is int)
      userId = navUser['id'];
    else {
      try {
        userId = (navUser as dynamic).id as int;
      } catch (e) {}
    }
    await dbRepo.addMovement(prod.id, userId, tipo, q, dataController.text);
    await _loadProducts();
    if (prod.quantidadeEstoque < prod.estoqueMinimo)
      _show('Alerta de Estoque',
          'Produto ${prod.nome} abaixo do mínimo (${prod.quantidadeEstoque} < ${prod.estoqueMinimo})');
    else
      _show('OK', 'Movimentação registrada');
  }

  void _show(String title, String msg) => showDialog(
      context: context,
      builder: (_) => AlertDialog(
              title: Text(title),
              content: Text(msg),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context), child: Text('OK'))
              ]));

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
      appBar: AppBar(title: Text('Gestão de Estoque')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Expanded(
                child: ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (_, i) {
                      final p = products[i];
                      return ListTile(
                        title: Text(
                            '${p.nome} - Qtde: ${p.quantidadeEstoque} - Min: ${p.estoqueMinimo}'),
                        trailing: ElevatedButton(
                            onPressed: () => setState(() => selectedId = p.id),
                            child: Text('Selecionar')),
                      );
                    })),
            Text('Selecionado: ${selectedId ?? '-'}'),
            Row(children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => setState(() => tipo = 'entrada'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: tipo == 'entrada' ? Colors.green : null),
                  child: Text('Entrada'),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => setState(() => tipo = 'saida'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: tipo == 'saida' ? Colors.red : null),
                  child: Text('Saída'),
                ),
              ),
            ]),
            TextField(
                controller: quantidadeController,
                decoration: InputDecoration(labelText: 'Quantidade'),
                keyboardType: TextInputType.number),
            TextField(
                controller: dataController,
                decoration: InputDecoration(labelText: 'Data (YYYY-MM-DD)')),
            ElevatedButton(
                onPressed: _apply, child: Text('Aplicar Movimentação')),
            ElevatedButton(
                onPressed: () => Navigator.pushReplacementNamed(
                    context, '/home',
                    arguments: user),
                child: Text('Voltar')),
            SizedBox(height: 12),
            Divider(),
            Text('Histórico de Movimentações',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(child: _buildHistoryList())
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryList() {
    return FutureBuilder(
      future: dbRepo.listMovements(),
      builder: (_, AsyncSnapshot snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());
        final rev = List.from((snapshot.data as List).reversed);
        return ListView.builder(
          itemCount: rev.length,
          itemBuilder: (_, i) {
            final m = rev[i] as Movement;
            final prod = products.firstWhere((p) => p.id == m.produtoId,
                orElse: () => Product(
                    id: m.produtoId,
                    nome: 'Desconhecido',
                    descricao: '',
                    tamanho: '',
                    peso: 0.0,
                    estoqueMinimo: 0,
                    quantidadeEstoque: 0));
            return FutureBuilder(
                future: dbRepo.getUserById(m.usuarioId),
                builder: (_, AsyncSnapshot uSnap) {
                  final user = uSnap.data;
                  return ListTile(
                    title: Text('${m.tipo.toUpperCase()} - ${prod.nome}'),
                    subtitle: Text(
                        'Qtde: ${m.quantidade} - Data: ${m.data} - Usuário: ${user?.nome ?? m.usuarioId}'),
                  );
                });
          },
        );
      },
    );
  }
}
