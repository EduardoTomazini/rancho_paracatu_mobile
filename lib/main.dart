import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'config/app_config.dart';
// Importações padrão do seu tema e telas existentes
import 'screens/core/theme/app_theme.dart';
import 'screens/inicio.dart';
import 'screens/cardapio.dart';
import 'screens/checkout.dart';
import 'screens/login.dart';
import 'screens/registro.dart';
import 'screens/sobre.dart';
import 'screens/esqueceu_senha.dart';
import 'screens/contato.dart';
import 'screens/admin_screen.dart';
import 'screens/admin_pedidos.dart';
import 'screens/admin_cardapio.dart';
import 'screens/admin_usuarios.dart';
import 'screens/admin_config.dart';
import 'screens/meus_pedidos.dart';
import 'providers/carrinho_provider.dart';

void main() async {
  // Garante que o Flutter inicialize os serviços antes de rodar o app
  WidgetsFlutterBinding.ensureInitialized();

  // O prototipo so inicializa o servico quando a configuracao e fornecida
  // externamente. Nenhum identificador de infraestrutura fica no repositorio.
  if (AppConfig.hasSupabaseConfiguration) {
    await Supabase.initialize(
      url: AppConfig.supabaseUrl,
      publishableKey: AppConfig.supabasePublishableKey,
    );
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CarrinhoProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rancho Paracatu',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.temaPadrao,
      initialRoute: '/',
      routes: {
        '/': (context) => const InicioScreen(),
        '/cardapio': (context) => const CardapioScreen(),
        '/checkout': (context) => const CheckoutScreen(),
        '/login': (context) => const LoginScreen(),
        '/registro': (context) => const RegistroScreen(),
        '/sobre': (context) => const SobreScreen(),
        '/esqueceu_senha': (context) => const EsqueceuSenhaScreen(),
        '/contato': (context) => const ContatoScreen(),
        '/admin': (context) => const AdminScreen(),
        '/admin/pedidos': (context) => const AdminPedidosScreen(),
        '/admin/cardapio': (context) => const AdminCardapioScreen(),
        '/admin/usuarios': (context) => const AdminUsuariosScreen(),
        '/admin/config': (context) => const AdminConfigScreen(),
        '/meus_pedidos': (context) => const MeusPedidosScreen(),
      },
    );
  }
}
