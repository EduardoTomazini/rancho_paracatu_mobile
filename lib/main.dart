import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/core/theme/app_theme.dart';
import 'screens/inicio.dart'; 
import 'screens/sobre.dart';
import 'screens/cardapio.dart';
import 'screens/contato.dart';
import 'screens/meus_pedidos.dart';
import 'screens/checkout.dart';
import 'screens/registro.dart';
import 'screens/login.dart';
import 'screens/admin_screen.dart';
import 'providers/carrinho_provider.dart';

void main() {
  runApp(const RanchoParacatuApp()); 
}

class RanchoParacatuApp extends StatelessWidget {
  const RanchoParacatuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CarrinhoProvider()),
      ],
      child: MaterialApp(
        title: 'Rancho Paracatu', 
        debugShowCheckedModeBanner: false,
        
        theme: AppTheme.temaPadrao, 
        
        initialRoute: '/', 
        
        routes: {
          '/': (context) => const InicioScreen(),
          '/sobre': (context) => const SobreScreen(),
          '/cardapio': (context) => const CardapioScreen(),
          '/contato': (context) => const ContatoScreen(),
          '/meus_pedidos': (context) => const MeusPedidosScreen(),
          '/checkout': (context) => const CheckoutScreen(),
          '/registro': (context) => const RegistroScreen(),
          '/login': (context) => const LoginScreen(),
          '/admin': (context) => const AdminScreen(),
        },
      ),
    );
  }
}