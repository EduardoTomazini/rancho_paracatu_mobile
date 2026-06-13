import 'package:flutter/material.dart';
import 'core/theme/app_colors.dart';
import '../widgets/custom_drawer.dart';

class EsqueceuSenhaScreen extends StatefulWidget {
  const EsqueceuSenhaScreen({super.key});

  @override
  State<EsqueceuSenhaScreen> createState() => _EsqueceuSenhaScreenState();
}

class _EsqueceuSenhaScreenState extends State<EsqueceuSenhaScreen> {
  final Color corTitulo = const Color(0xFF2E2414);
  final Color corFundoInput = const Color(0xFFFFF8EF);
  final Color corBordaFoco = const Color(0xFF6B4F28);
  final Color corBordaCard = const Color(0xFFE7DFD3);
  final Color corBotao = const Color(0xFF4D3820);

  final TextEditingController _emailController = TextEditingController();

  bool _isLoading = false;
  bool _enviado = false;
  String? _error;

  // Validação de formato de e-mail (mesmo padrão das outras telas)
  final _emailRegex = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
  );

  void _solicitarRecuperacao() async {
    FocusScope.of(context).unfocus();

    setState(() {
      _error = null;
      _enviado = false;
    });

    final email = _emailController.text.trim();

    // 1. Verificar se o campo foi preenchido
    if (email.isEmpty) {
      setState(() {
        _error = 'Por favor, informe o seu e-mail.';
      });
      return;
    }

    // 2. Validar formato do e-mail
    if (!_emailRegex.hasMatch(email)) {
      setState(() {
        _error = 'O formato do e-mail é inválido. Tente novamente.';
      });
      return;
    }

    setState(() => _isLoading = true);

    // Simula o envio do e-mail de recuperação (tempo de resposta de rede)
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoading = false;
        _enviado = true;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
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
              border: Border.all(color: corBordaCard),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(13, 0, 0, 0),
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
                    'Recuperar Senha',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: corTitulo,
                      fontFamily: 'serif',
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    'Informe o e-mail cadastrado e enviaremos as\ninstruções para redefinição de senha.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: corBordaFoco,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Mensagem de sucesso
                if (_enviado)
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      border: Border.all(color: Colors.green),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.green[700], size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'E-mail enviado!',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green[700],
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Verifique a caixa de entrada de ${_emailController.text.trim()} e siga as instruções para redefinir sua senha.',
                          style: TextStyle(color: Colors.green[800], fontSize: 13, height: 1.4),
                        ),
                      ],
                    ),
                  ),

                if (!_enviado) ...[
                  Text('E-mail', style: TextStyle(fontSize: 14, color: corTitulo)),
                  const SizedBox(height: 4),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: _estiloInput('exemplo@dominio.com'),
                  ),
                  const SizedBox(height: 20),
                ],

                // Mensagem de erro
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Center(
                      child: Text(
                        _error!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                if (!_enviado)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _solicitarRecuperacao,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: corBotao,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Enviar instruções',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),

                const SizedBox(height: 20),

                Center(
                  child: GestureDetector(
                    onTap: () => Navigator.pushReplacementNamed(context, '/login'),
                    child: Text(
                      'Voltar ao login',
                      style: TextStyle(
                        fontSize: 14,
                        color: corBotao,
                        decoration: TextDecoration.underline,
                      ),
                    ),
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
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.black12),
        borderRadius: BorderRadius.circular(4),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: corBordaFoco, width: 2),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}