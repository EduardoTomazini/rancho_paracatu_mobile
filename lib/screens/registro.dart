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
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmaSenhaController = TextEditingController();

  bool _isLoading = false;
  bool _ok = false;
  String? _error;

  void _submit() async {
    FocusScope.of(context).unfocus();

    setState(() {
      _error = null;
      _ok = false;
    });

    final nome = _nomeController.text.trim();
    final telefone = _telefoneController.text.trim();
    final email = _emailController.text.trim();
    final senha = _senhaController.text.trim();
    final confirmaSenha = _confirmaSenhaController.text.trim();

    // 1. Validação de campos vazios
    if (nome.isEmpty || telefone.isEmpty || email.isEmpty || senha.isEmpty || confirmaSenha.isEmpty) {
      setState(() {
        _error = 'Por favor, preencha todos os campos.';
      });
      return;
    }

    // 2. Validação de formato de e-mail (Regex)
    final emailRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (!emailRegex.hasMatch(email)) {
      setState(() {
        _error = 'O formato do e-mail é inválido.';
      });
      return;
    }

    // 3. Validação de tamanho de senha
    if (senha.length < 6) {
      setState(() {
        _error = 'A senha deve ter pelo menos 6 caracteres.';
      });
      return;
    }

    // 4. Validação de igualdade das senhas
    if (senha != confirmaSenha) {
      setState(() {
        _error = 'As senhas não coincidem. Verifique e tente novamente.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simula o tempo de rede para criação da conta
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoading = false;
        _ok = true;
      });

      // Redireciona para o login após o sucesso do cadastro
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/login'); 
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
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE6DCC7)),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(26, 0, 0, 0), // Warning withOpacity resolvido
                  blurRadius: 15,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Criar Conta',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: corTexto, fontFamily: 'serif'),
                  ),
                ),
                const SizedBox(height: 24),

                Text('Nome Completo', style: TextStyle(fontSize: 14, color: corTexto)),
                const SizedBox(height: 4),
                TextField(
                  controller: _nomeController,
                  decoration: _estiloInput('Ex: João Silva'),
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 16),

                Text('Telefone', style: TextStyle(fontSize: 14, color: corTexto)),
                const SizedBox(height: 4),
                TextField(
                  controller: _telefoneController,
                  keyboardType: TextInputType.phone,
                  decoration: _estiloInput('(00) 00000-0000'),
                ),
                const SizedBox(height: 16),

                Text('E-mail', style: TextStyle(fontSize: 14, color: corTexto)),
                const SizedBox(height: 4),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _estiloInput('exemplo@dominio.com'),
                ),
                const SizedBox(height: 16),

                Text('Senha', style: TextStyle(fontSize: 14, color: corTexto)),
                const SizedBox(height: 4),
                TextField(
                  controller: _senhaController,
                  obscureText: true, 
                  decoration: _estiloInput('Mínimo 6 caracteres'),
                ),
                const SizedBox(height: 16),

                Text('Confirmar Senha', style: TextStyle(fontSize: 14, color: corTexto)),
                const SizedBox(height: 4),
                TextField(
                  controller: _confirmaSenhaController,
                  obscureText: true, 
                  decoration: _estiloInput('Repita a sua senha'),
                ),
                const SizedBox(height: 24),

                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Center(
                      child: Text(_error!, style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                    ),
                  ),

                if (_ok)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 12.0),
                    child: Center(
                      child: Text('Conta criada com sucesso!\nRedirecionando...', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                    ),
                  ),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading || _ok ? null : _submit,
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