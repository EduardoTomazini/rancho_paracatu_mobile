import 'package:flutter/material.dart';
import 'core/theme/app_colors.dart';
import '../widgets/custom_drawer.dart';

class CardapioScreen extends StatefulWidget {
  const CardapioScreen({super.key});

  @override
  State<CardapioScreen> createState() => _CardapioScreenState();
}

class _CardapioScreenState extends State<CardapioScreen> {
  
  final Color corTitulo = const Color(0xFF2E2414);
  final Color corFiltro = const Color(0xFF6B4F28);

  
  final List<String> categorias = ['Todos', 'Pratos', 'Bebidas', 'Sobremesas'];
  String categoriaAtiva = 'Todos';

  
  final List<Map<String, dynamic>> produtos = [
    {'nome': 'Feijoada', 'preco': 55.0, 'cat': 'Pratos', 'desc': 'Completa e suculenta.'},
    {'nome': 'Picanha', 'preco': 89.0, 'cat': 'Pratos', 'desc': 'Grelhada no ponto.'},
    {'nome': 'Suco', 'preco': 10.0, 'cat': 'Bebidas', 'desc': 'Natural de laranja.'},
    {'nome': 'Cerveja', 'preco': 15.0, 'cat': 'Bebidas', 'desc': 'Artesanal da casa.'},
    {'nome': 'Pudim', 'preco': 12.0, 'cat': 'Sobremesas', 'desc': 'Receita da vovó.'},
  ];

  List<Map<String, dynamic>> get produtosFiltrados {
    if (categoriaAtiva == 'Todos') return produtos;
    return produtos.where((p) => p['cat'] == categoriaAtiva).toList();
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
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 300,
                  childAspectRatio: 0.8,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: Container(color: Colors.grey[300], child: const Center(child: Icon(Icons.image)))),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(p['nome'], style: const TextStyle(fontWeight: FontWeight.bold)),
                              Text(p['desc'], style: const TextStyle(fontSize: 12, color: Colors.grey)),
                              const SizedBox(height: 8),
                              Text('R\$ ${p['preco'].toStringAsFixed(2)}', style: TextStyle(color: corFiltro, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ),
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