import 'package:flutter/material.dart';
import 'core/theme/app_colors.dart'; 
import '../widgets/custom_drawer.dart'; 

class InicioScreen extends StatefulWidget {
  const InicioScreen({super.key});

  @override
  State<InicioScreen> createState() => _InicioScreenState();
}

class _InicioScreenState extends State<InicioScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: AppBar(
        title: const Text('Rancho Paracatu'),
      ),

      
      drawer: const CustomDrawer(), 

     
      body: SingleChildScrollView( 
        child: Column(
          children: [
            
            Container(
              width: double.infinity, 
              height: 250, 
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/rustic-bg.png'), 
                  fit: BoxFit.cover, 
                ),
              ),
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: Text(
                    'Bem-vindo ao\nRancho Paracatu',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textoAlternativo, 
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 40), 
            
           
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'O que você deseja fazer?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            
            const SizedBox(height: 20),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      
                      Navigator.pushNamed(context, '/cardapio');
                    },
                    icon: const Icon(Icons.menu_book),
                    label: const Text('Ver Cardápio'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/checkout');
                    },
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