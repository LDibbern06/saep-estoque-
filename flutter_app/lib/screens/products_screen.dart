import 'package:flutter/material.dart';
import '../services/db_repository.dart';
import '../models/product.dart';

class ProductsScreen extends StatefulWidget {
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List<Product> products = [];
  String search = '';

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    products = await dbRepo.listProducts();
    setState(() {});
  }

  void _addProduct() async {
    final result = await _askProductDialog();
    if (result == null) return;
    final nome = result['nome'] ?? '';
    final p = Product(
        id: 0,
        nome: nome,
        descricao: result['descricao'] ?? '',
        tamanho: result['tamanho'] ?? '',
        peso: double.tryParse(result['peso'] ?? '0.0') ?? 0.0,
        estoqueMinimo: int.tryParse(result['estoqueMinimo'] ?? '0') ?? 0,
        quantidadeEstoque:
            int.tryParse(result['quantidadeEstoque'] ?? '0') ?? 0);
    await dbRepo.addProduct(p);
    await _loadProducts();
  }

  void _editProduct(Product p) async {
    final result = await _askProductDialog(product: p);
    if (result == null) return;
    p.nome = result['nome'] as String;
    p.descricao = result['descricao'] as String;
    p.tamanho = result['tamanho'] as String;
    p.peso = double.tryParse(result['peso'] ?? '') ?? p.peso;
    p.estoqueMinimo =
        int.tryParse(result['estoqueMinimo'] ?? '') ?? p.estoqueMinimo;
    p.quantidadeEstoque =
        int.tryParse(result['quantidadeEstoque'] ?? '') ?? p.quantidadeEstoque;
    await dbRepo.updateProduct(p);
    await _loadProducts();
  }

  void _deleteProduct(int id) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
                title: Text('Confirmar'),
                content: Text('Excluir produto?'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancelar')),
                  TextButton(
                      onPressed: () async {
                        await dbRepo.deleteProduct(id);
                        await _loadProducts();
                        Navigator.pop(context);
                      },
                      child: Text('Excluir'))
                ]));
  }

  // _askString removed - replaced by _askProductDialog for full product input

  Future<Map<String, String>?> _askProductDialog({Product? product}) {
    final nomeC = TextEditingController(text: product?.nome ?? '');
    final descC = TextEditingController(text: product?.descricao ?? '');
    final tamC = TextEditingController(text: product?.tamanho ?? '');
    final pesoC = TextEditingController(
        text: product != null ? product.peso.toString() : '0.0');
    final minC = TextEditingController(
        text: product != null ? product.estoqueMinimo.toString() : '0');
    final qtC = TextEditingController(
        text: product != null ? product.quantidadeEstoque.toString() : '0');
    return showDialog<Map<String, String>>(
        context: context,
        builder: (_) => AlertDialog(
              title: Text(product == null ? 'Novo Produto' : 'Editar Produto'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                        controller: nomeC,
                        decoration: InputDecoration(labelText: 'Nome')),
                    TextField(
                        controller: descC,
                        decoration: InputDecoration(labelText: 'Descricao')),
                    TextField(
                        controller: tamC,
                        decoration: InputDecoration(labelText: 'Tamanho')),
                    TextField(
                        controller: pesoC,
                        decoration: InputDecoration(labelText: 'Peso (kg)'),
                        keyboardType: TextInputType.number),
                    TextField(
                        controller: minC,
                        decoration:
                            InputDecoration(labelText: 'Estoque Minimo'),
                        keyboardType: TextInputType.number),
                    TextField(
                        controller: qtC,
                        decoration:
                            InputDecoration(labelText: 'Quantidade Inicial'),
                        keyboardType: TextInputType.number),
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancelar')),
                TextButton(
                    onPressed: () {
                      if (nomeC.text.trim().isEmpty)
                        return _showAlert('Validacao', 'Nome obrigatorio');
                      Navigator.pop(context, {
                        'nome': nomeC.text.trim(),
                        'descricao': descC.text.trim(),
                        'tamanho': tamC.text.trim(),
                        'peso': pesoC.text.trim(),
                        'estoqueMinimo': minC.text.trim(),
                        'quantidadeEstoque': qtC.text.trim(),
                      });
                    },
                    child: Text('OK'))
              ],
            ));
  }

  void _showAlert(String title, String msg) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
                title: Text(title),
                content: Text(msg),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('OK'))
                ]));
  }

  @override
  Widget build(BuildContext context) {
    final filtered = products
        .where((p) => p.nome.toLowerCase().contains(search.toLowerCase()))
        .toList();
    final user =
        ModalRoute.of(context)!.settings.arguments; // used only for nav back
    return Scaffold(
      appBar: AppBar(title: Text('Cadastro de Produtos')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
                decoration: InputDecoration(labelText: 'Buscar'),
                onChanged: (v) => setState(() => search = v)),
            SizedBox(height: 8),
            Row(children: [
              Expanded(
                  child: ElevatedButton(
                      onPressed: _addProduct,
                      child: Text('Adicionar Produto'))),
              SizedBox(width: 12),
              Expanded(
                  child: TextField(
                      decoration: InputDecoration(labelText: 'Buscar'),
                      onChanged: (v) => setState(() => search = v))),
            ]),
            SizedBox(height: 12),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('Nome')),
                    DataColumn(label: Text('Quantidade')),
                    DataColumn(label: Text('Mínimo')),
                    DataColumn(label: Text('Ações')),
                  ],
                  rows: filtered
                      .map((p) => DataRow(cells: [
                            DataCell(Text(p.nome)),
                            DataCell(Text('${p.quantidadeEstoque}')),
                            DataCell(Text('${p.estoqueMinimo}')),
                            DataCell(Row(children: [
                              IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () => _editProduct(p)),
                              IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () => _deleteProduct(p.id))
                            ])),
                          ]))
                      .toList(),
                ),
              ),
            ),
            SizedBox(height: 8),
            ElevatedButton(
                onPressed: () => Navigator.pushReplacementNamed(
                    context, '/home',
                    arguments: user),
                child: Text('Voltar'))
          ],
        ),
      ),
    );
  }
}
