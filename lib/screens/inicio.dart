import 'package:flutter/material.dart';
// Descomente a linha abaixo se quiser usar as cores do seu tema no Header do menu
import 'core/theme/app_colors.dart'; 

class InicioScreen extends StatefulWidget {
  const InicioScreen({super.key});

  @override
  State<InicioScreen> createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 1. A BARRA SUPERIOR
      appBar: AppBar(
        title: const Text('Rancho Paracatu'),
        // O menu hambúrguer é gerado automaticamente pelo Flutter por causa do 'drawer' abaixo.
      ),

      // 2. O MENU HAMBÚRGUER LATERAL
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green, // Pode trocar por AppColors.verdePrincipal
              ),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.restaurant_menu),
              title: const Text('Cardápio'),
              onTap: () {
                // Futuramente: Navigator.pushNamed(context, '/cardapio');
              },
            ),
            ListTile(
              leading: const Icon(Icons.receipt_long),
              title: const Text('Meus Pedidos'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('Sobre o Rancho'),
              onTap: () {},
            ),
          ],
        ),
      ),

      // 3. O CORPO DA PÁGINA
      // Usamos SingleChildScrollView para a tela rolar caso o celular seja pequeno
      body: SingleChildScrollView( 
        child: Column(
          children: [
            // --- BLOCO DA IMAGEM RÚSTICA ---
            Container(
              width: double.infinity, // Ocupa toda a largura da tela
              height: 250, // Altura do banner
              decoration: const BoxDecoration(
                image: DecorationImage(
                  // Ajuste o caminho abaixo dependendo de onde a pasta core ficou!
                  image: AssetImage('assets/images/rustic-bg.png'), 
                  fit: BoxFit.cover, // Faz a imagem cobrir o espaço sem distorcer
                ),
              ),
              child: Container(
                // Uma película escura transparente por cima da foto para o texto branco aparecer bem
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: Text(
                    'Bem-vindo ao\nRancho Paracatu',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 40), // Espaçamento
            
            // --- BLOCO DOS BOTÕES PLACEHOLDER ---
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'O que você deseja fazer?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Botões lado a lado simulando as ações do app
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.menu_book),
                    label: const Text('Ver Cardápio'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.shopping_cart_checkout),
                    label: const Text('Fazer Pedido'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}