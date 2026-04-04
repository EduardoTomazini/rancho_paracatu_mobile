import 'package:flutter/material.dart';

// Importando o seu tema e a sua tela inicial
import 'screens/core/theme/app_theme.dart';
import 'screens/inicio.dart'; 

void main() {
  // Atualizamos o nome da classe que inicia o app
  runApp(const RanchoParacatuApp()); 
}

class RanchoParacatuApp extends StatelessWidget {
  const RanchoParacatuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Título oficial do projeto atualizado!
      title: 'Rancho Paracatu', 
      
      debugShowCheckedModeBanner: false,
      theme: AppTheme.temaPadrao, 
      home: const InicioScreen(), 
    );
  }
}