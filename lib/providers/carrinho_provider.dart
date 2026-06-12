import 'package:flutter/material.dart';
import '../models/cart_item.dart';

class CarrinhoProvider with ChangeNotifier {
  final Map<String, CartItem> _itens = {};

  Map<String, CartItem> get itens => {..._itens};

  int get quantidadeItens => _itens.length;

  double get valorTotal {
    var total = 0.0;
    _itens.forEach((key, item) {
      total += item.preco * item.quantidade;
    });
    return total;
  }

  void adicionarItem(String produtoId, String titulo, double preco) {
    if (_itens.containsKey(produtoId)) {
      _itens.update(
        produtoId,
        (itemExistente) => CartItem(
          id: itemExistente.id,
          titulo: itemExistente.titulo,
          preco: itemExistente.preco,
          quantidade: itemExistente.quantidade + 1,
        ),
      );
    } else {
      _itens.putIfAbsent(
        produtoId,
        () => CartItem(
          id: DateTime.now().toString(),
          titulo: titulo,
          preco: preco,
        ),
      );
    }
    notifyListeners();
  }

  void decrementarItem(String produtoId) {
    if (!_itens.containsKey(produtoId)) return;

    if (_itens[produtoId]!.quantidade > 1) {
      _itens.update(
        produtoId,
        (itemExistente) => CartItem(
          id: itemExistente.id,
          titulo: itemExistente.titulo,
          preco: itemExistente.preco,
          quantidade: itemExistente.quantidade - 1,
        ),
      );
    } else {
      _itens.remove(produtoId);
    }
    notifyListeners();
  }

  void removerItem(String produtoId) {
    _itens.remove(produtoId);
    notifyListeners();
  }

  void limparCarrinho() {
    _itens.clear();
    notifyListeners();
  }
}