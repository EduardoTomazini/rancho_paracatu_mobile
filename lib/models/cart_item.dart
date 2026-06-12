class CartItem {
  final String id;
  final String titulo;
  final double preco;
  int quantidade;

  CartItem({
    required this.id,
    required this.titulo,
    required this.preco,
    this.quantidade = 1,
  });
}