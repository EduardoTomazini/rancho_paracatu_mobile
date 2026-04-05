import 'package:flutter/material.dart';
import 'core/theme/app_colors.dart';
import '../widgets/custom_drawer.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  
  final Color corTitulo = const Color(0xFF2E2414);
  final Color corFundoInput = const Color(0xFFFFF8EF);
  final Color corBordaFoco = const Color(0xFF6B4F28);
  final Color corBordaCard = const Color(0xFFE7DFD3);
  final Color corBotao = const Color(0xFF4D3820);

  
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  
  bool _isLoading = false;
  String? _error;

  
  void _submit() async {
    
    FocusScope.of(context).unfocus();

    setState(() {
      _error = null;
    });

    if (_emailController.text.isEmpty || _senhaController.text.isEmpty) {
      setState(() {
        _error = 'Por favor, preencha email e senha.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      
      
      Navigator.pushReplacementNamed(context, '/admin');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fundo,
      appBar: AppBar(
        title: const Text('Rancho Paracatu'),
      ),
      drawer: const CustomDrawer(),
      
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400), // max-w-md
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16), // rounded-xl
              border: Border.all(color: corBordaCard),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 5), // shadow-lg
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                Center(
                  child: Text(
                    'Entrar',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: corTitulo, fontFamily: 'serif'),
                  ),
                ),
                const SizedBox(height: 32),

                
                Text('Email', style: TextStyle(fontSize: 14, color: corTitulo)),
                const SizedBox(height: 4),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _estiloInput('exemplo@dominio.com'),
                ),
                const SizedBox(height: 20),

                
                Text('Senha', style: TextStyle(fontSize: 14, color: corTitulo)),
                const SizedBox(height: 4),
                TextField(
                  controller: _senhaController,
                  obscureText: true, 
                  decoration: _estiloInput('••••••••'),
                ),
                const SizedBox(height: 24),

                
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Center(
                      child: Text(_error!, style: const TextStyle(color: Colors.red, fontSize: 14, fontWeight: FontWeight.bold)),
                    ),
                  ),

                
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: corBotao,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: _isLoading
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text('Entrar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),

                const SizedBox(height: 20),

                
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Não tem conta? ', style: TextStyle(fontSize: 14, color: corTitulo)),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(context, '/registro');
                        },
                        child: Text(
                          'Criar conta',
                          style: TextStyle(fontSize: 14, color: corBordaFoco, decoration: TextDecoration.underline, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  
  InputDecoration _estiloInput(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF9A938A), fontSize: 14),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      filled: true,
      fillColor: corFundoInput,
      enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.black12), borderRadius: BorderRadius.circular(4)),
      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: corBordaFoco, width: 2), borderRadius: BorderRadius.circular(4)),
    );
  }
}