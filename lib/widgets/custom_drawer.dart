import 'package:flutter/material.dart';
import '../screens/core/theme/app_colors.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          
          const DrawerHeader(
            decoration: BoxDecoration(color: AppColors.verdePrincipal),
            child: Text(
              'Menu',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Início'),
            onTap: () {
              Navigator.pop(context); 
              Navigator.pushNamed(context, '/'); 
            },
          ),
          
          ListTile(
            leading: const Icon(Icons.restaurant_menu),
            title: const Text('Cardápio'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/cardapio');
            },
          ),
          
          ListTile(
            leading: const Icon(Icons.receipt_long),
            title: const Text('Meus Pedidos'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/meus_pedidos');
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text('Fazer Pedido'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/checkout');
            },
          ),
          ListTile(
            leading: const Icon(Icons.login),
            title: const Text('Fazer Login'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/login');
            },
          ),

          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Sobre o Rancho'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/sobre');
            },
          ),
        ],
      ),
    );
  }
}