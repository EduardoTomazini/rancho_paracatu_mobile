import 'package:flutter/material.dart';
import 'app_colors.dart'; // Importa o seu arquivo de cores

class AppTheme {
  // Construtor privado para evitar que a classe seja instanciada sem querer
  AppTheme._(); 

  static ThemeData get temaPadrao {
    return ThemeData(
      // 1. Configurações base
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.fundo,
      
      // 2. Esquema de cores principal
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.verdePrincipal,
        primary: AppColors.verdePrincipal,
        surface: AppColors.fundo,
      ),

      // 3. Estilo padrão da AppBar (Barra superior)
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.verdePrincipal,
        foregroundColor: Colors.white, // Cor do texto e dos ícones (ex: botão de voltar)
        centerTitle: true,
        elevation: 0, // Tira a sombrinha padrão, se preferir um design mais "flat"
      ),

      // 4. Estilo padrão dos Botões Elevados (ElevatedButton)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.verdePrincipal,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // Deixa as bordas levemente arredondadas
          ),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        ),
      ),

      // 5. Estilo padrão das caixas de texto (TextField/TextFormField) para o Checkout
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.textoSecundario),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.verdePrincipal, width: 2),
        ),
      ),
    );
  }
}