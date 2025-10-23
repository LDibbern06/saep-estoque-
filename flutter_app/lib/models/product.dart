class Product {
  int id;
  String nome;
  String descricao;
  String tamanho;
  double peso;
  int estoqueMinimo;
  int quantidadeEstoque;

  Product({
    required this.id,
    required this.nome,
    this.descricao = '',
    this.tamanho = '',
    this.peso = 0.0,
    this.estoqueMinimo = 0,
    this.quantidadeEstoque = 0,
  });
}
