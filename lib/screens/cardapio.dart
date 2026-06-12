import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_colors.dart';
import '../widgets/custom_drawer.dart';
import '../providers/carrinho_provider.dart';
import '../services/cardapio_service.dart';

class CardapioScreen extends StatefulWidget {
  const CardapioScreen({super.key});

  @override
  State<CardapioScreen> createState() => _CardapioScreenState();
}

class _CardapioScreenState extends State<CardapioScreen> {
  final Color corTitulo = const Color(0xFF2E2414);
  final Color corFiltro = const Color(0xFF6B4F28);

  // As categorias atualizadas para bater com a sua API
  final List<String> categorias = ['Todos', 'Porções', 'Bebidas', 'Drinks'];
  String categoriaAtiva = 'Todos';

  late Future<List<Map<String, dynamic>>> _produtosFuture;

  @override
  void initState() {
    super.initState();
    // Puxa os dados da sua API real no GitHub
    _produtosFuture = CardapioService().fetchProdutos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fundo,
      appBar: AppBar(
        title: const Text('Cardápio'),
        backgroundColor: AppColors.verdePrincipal,
      ),
      drawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cardápio',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: corTitulo),
            ),
            const SizedBox(height: 24),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categorias.map((cat) {
                  bool isAtivo = categoriaAtiva == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: ElevatedButton(
                      onPressed: () => setState(() => categoriaAtiva = cat),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isAtivo ? corFiltro : Colors.white,
                        foregroundColor: isAtivo ? Colors.white : corFiltro,
                        side: BorderSide(color: corFiltro),
                      ),
                      child: Text(cat),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _produtosFuture,
                builder: (context, snapshot) {
                  // Mostra o loading enquanto baixa da API
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Erro ao carregar o cardápio: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Nenhum produto encontrado.'));
                  }

                  final todosProdutos = snapshot.data!;
                  final produtosFiltrados = categoriaAtiva == 'Todos'
                      ? todosProdutos
                      : todosProdutos.where((p) => p['cat'] == categoriaAtiva).toList();

                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 300,
                      childAspectRatio: 0.65, 
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                    itemCount: produtosFiltrados.length,
                    itemBuilder: (context, index) {
                      final p = produtosFiltrados[index];
                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                child: p['imagem'] != null && p['imagem'].toString().isNotEmpty
                                    ? Image.network(
                                        p['imagem'],
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) =>
                                            Container(color: Colors.grey[300], child: const Icon(Icons.image, size: 50)),
                                      )
                                    : Container(color: Colors.grey[300], child: const Icon(Icons.fastfood, size: 50)),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(p['nome'], style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                                  const SizedBox(height: 4),
                                  Text(p['desc'], style: const TextStyle(fontSize: 12, color: Colors.grey), maxLines: 2, overflow: TextOverflow.ellipsis),
                                  const SizedBox(height: 8),
                                  Text('R\$ ${p['preco'].toStringAsFixed(2).replaceAll('.', ',')}', style: TextStyle(color: corFiltro, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        // Envia o item para o Provider Global do Carrinho
                                        Provider.of<CarrinhoProvider>(context, listen: false).adicionarItem(
                                          p['id'].toString(),
                                          p['nome'],
                                          (p['preco'] as num).toDouble(),
                                        );
                                        
                                        // Feedback visual
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('${p['nome']} adicionado ao pedido!'),
                                            duration: const Duration(seconds: 2),
                                            behavior: SnackBarBehavior.floating,
                                            backgroundColor: AppColors.verdePrincipal,
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.add_shopping_cart, size: 16),
                                      label: const Text('Adicionar', style: TextStyle(fontSize: 12)),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: corFiltro,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(vertical: 8),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}