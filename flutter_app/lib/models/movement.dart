class Movement {
  int id;
  int produtoId;
  int usuarioId;
  String tipo; // 'entrada' or 'saida'
  int quantidade;
  String data; // ISO date

  Movement(
      {required this.id,
      required this.produtoId,
      required this.usuarioId,
      required this.tipo,
      required this.quantidade,
      required this.data});
}
