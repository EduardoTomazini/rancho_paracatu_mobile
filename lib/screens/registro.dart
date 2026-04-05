import 'package:flutter/material.dart';
import 'core/theme/app_colors.dart';
import '../widgets/custom_drawer.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  
  final Color corTexto = const Color(0xFF2E2414);
  final Color corBorda = const Color(0xFFC4B69C);
  final Color corFoco = const Color(0xFF6B4F28);
  final Color corBotao = const Color(0xFF6B4F28);

 
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

 
  bool _isLoading = false;
  bool _ok = false;
  String? _error;

  
  void _submit() async {
    // Esconde o teclado
    FocusScope.of(context).unfocus();

    setState(() {
      _error = null;
      _ok = false;
    });

    
    if (_nomeController.text.isEmpty || _emailController.text.isEmpty || _senhaController.text.length < 6) {
      setState(() {
        _error = 'Preencha todos os campos corretamente.';
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
        _ok = true;
      });

      
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          
          Navigator.pushReplacementNamed(context, '/'); 
        }
      });
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
            constraints: const BoxConstraints(maxWidth: 400), 
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16), // rounded-xl
              border: Border.all(color: const Color(0xFFE6DCC7)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 15,
                  offset: const Offset(0, 5), // shadow-lg
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título
                Center(
                  child: Text(
                    'Criar Conta',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: corTexto, fontFamily: 'serif'),
                  ),
                ),
                const SizedBox(height: 24),

                
                Text('Nome', style: TextStyle(fontSize: 14, color: corTexto)),
                const SizedBox(height: 4),
                TextField(
                  controller: _nomeController,
                  decoration: _estiloInput('Seu nome completo'),
                ),
                const SizedBox(height: 16),

               
                Text('Email', style: TextStyle(fontSize: 14, color: corTexto)),
                const SizedBox(height: 4),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _estiloInput('exemplo@email.com'),
                ),
                const SizedBox(height: 16),

                
                Text('Senha', style: TextStyle(fontSize: 14, color: corTexto)),
                const SizedBox(height: 4),
                TextField(
                  controller: _senhaController,
                  obscureText: true, // Transforma em bolinhas
                  decoration: _estiloInput('Mínimo 6 caracteres'),
                ),
                const SizedBox(height: 24),

                
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Text(_error!, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                  ),

                
                if (_ok)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 12.0),
                    child: Text('Conta criada com sucesso! Redirecionando...', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
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
                        : const Text('Registrar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),

                const SizedBox(height: 16),

                
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Já tem conta? ', style: TextStyle(fontSize: 14, color: corFoco)),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                        child: Text(
                          'Fazer login',
                          style: TextStyle(fontSize: 14, color: corFoco, decoration: TextDecoration.underline, fontWeight: FontWeight.bold),
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
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: corBorda), borderRadius: BorderRadius.circular(8)),
      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: corFoco, width: 2), borderRadius: BorderRadius.circular(8)),
    );
  }
}