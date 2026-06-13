import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/theme/app_colors.dart';
import '../widgets/custom_drawer.dart';
import '../providers/carrinho_provider.dart';

class CardapioScreen extends StatefulWidget {
  const CardapioScreen({super.key});

  @override
  State<CardapioScreen> createState() => _CardapioScreenState();
}

class _CardapioScreenState extends State<CardapioScreen> {
  final Color corTitulo = const Color(0xFF2E2414);
  final Color corFiltro = const Color(0xFF6B4F28);

  final List<String> categorias = ['Todos', 'Porções', 'Bebidas', 'Drinks'];
  String categoriaAtiva = 'Todos';

  // Instância do cliente Supabase para ler os dados reais
  final _supabase = Supabase.instance.client;

  // Função para buscar os produtos direto do Supabase em tempo real
  Future<List<Map<String, dynamic>>> _fetchProdutos() async {
    final response = await _supabase
        .from('produtos')
        .select()
        .order('nome', ascending: true);
    return List<Map<String, dynamic>>.from(response);
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
            
            // Barra Horizontal de Filtros por Categoria
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
            
            // Grid de Exibição dos Produtos Consumindo do Supabase
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _fetchProdutos(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Erro ao carregar o cardápio: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text(
                        'Nenhum produto cadastrado.\nVá até a área admin para adicionar!',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    );
                  }

                  final todosProdutos = snapshot.data!;
                  
                  // Aplica o filtro selecionado na barra superior
                  final produtosFiltrados = categoriaAtiva == 'Todos'
                      ? todosProdutos
                      : todosProdutos.where((p) => p['cat'] == categoriaAtiva).toList();

                  if (produtosFiltrados.isEmpty) {
                    return const Center(child: Text('Nenhum item nesta categoria.'));
                  }

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
                      final double precoDinamico = (p['preco'] as num).toDouble();

                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Imagem Puxada Diretamente da URL Pública do Storage do Supabase
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
                                  Text(p['nome'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                                  const SizedBox(height: 4),
                                  Text(p['desc'] ?? '', style: const TextStyle(fontSize: 12, color: Colors.grey), maxLines: 2, overflow: TextOverflow.ellipsis),
                                  const SizedBox(height: 8),
                                  Text('R\$ ${precoDinamico.toStringAsFixed(2).replaceAll('.', ',')}', style: TextStyle(color: corFiltro, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        // Adiciona o item real ao estado global do carrinho
                                        Provider.of<CarrinhoProvider>(context, listen: false).adicionarItem(
                                          p['id'].toString(),
                                          p['nome'] ?? '',
                                          precoDinamico,
                                        );
                                        
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