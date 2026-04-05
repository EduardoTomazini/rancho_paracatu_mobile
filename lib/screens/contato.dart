import 'package:flutter/material.dart';
import 'core/theme/app_colors.dart';
import '../widgets/custom_drawer.dart';

class ContatoScreen extends StatefulWidget {
  const ContatoScreen({super.key});

  @override
  State<ContatoScreen> createState() => _ContatoScreenState();
}

class _ContatoScreenState extends State<ContatoScreen> {
  
  final _formKey = GlobalKey<FormState>();

  
  final Color corTitulo = const Color(0xFF2E2414);
  final Color corTexto = const Color(0xFF4D5A2A);
  final Color corFundoInput = const Color(0xFFFAF5EE);
  final Color corBordaInput = const Color(0xFFC6B7A2);
  final Color corBotao = const Color(0xFF4D3820);

  
  bool _enviadoComSucesso = false;

  
  void _enviarMensagem() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _enviadoComSucesso = true;
      });

     
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _enviadoComSucesso = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fundo,
      appBar: AppBar(
        title: const Text('Contato'),
      ),
      drawer: const CustomDrawer(),
      
      
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          
          FloatingActionButton(
            heroTag: 'btnInsta',
            onPressed: () {}, 
            backgroundColor: Colors.pink, 
            child: const Icon(Icons.camera_alt, color: Colors.white),
          ),
          const SizedBox(height: 16), 
          
          FloatingActionButton(
            heroTag: 'btnWhats',
            onPressed: () {}, 
            backgroundColor: Colors.green,
            child: const Icon(Icons.chat, color: Colors.white),
          ),
        ],
      ),

      
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contate-nos',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: corTitulo),
            ),
            const SizedBox(height: 8),
            Text(
              'Ficaremos felizes em ouvir sua opinião, sugestão ou mensagem!',
              style: TextStyle(fontSize: 18, color: corTexto, height: 1.5),
            ),
            const SizedBox(height: 24),

            
            if (_enviadoComSucesso)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5EFE6),
                  border: Border.all(color: const Color(0xFFD9C7B3)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'Sua mensagem foi enviada com sucesso!',
                  style: TextStyle(color: Color(0xFF4D3820), fontWeight: FontWeight.bold),
                ),
              ),

            
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE7DFD3)),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   
                    Text('Nome', style: TextStyle(fontWeight: FontWeight.bold, color: corTitulo)),
                    const SizedBox(height: 8),
                    TextFormField(
                      decoration: _estiloInput(),
                      validator: (value) {
                        if (value == null || value.trim().length < 2) {
                          return 'O nome deve ter pelo menos 2 caracteres.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    
                    Text('E-mail', style: TextStyle(fontWeight: FontWeight.bold, color: corTitulo)),
                    const SizedBox(height: 8),
                    TextFormField(
                      decoration: _estiloInput(),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || !value.contains('@') || !value.contains('.')) {
                          return 'Digite um e-mail válido (ex: nome@exemplo.com).';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                   
                    Text('Mensagem', style: TextStyle(fontWeight: FontWeight.bold, color: corTitulo)),
                    const SizedBox(height: 8),
                    TextFormField(
                      maxLines: 4,
                      decoration: _estiloInput(),
                      validator: (value) {
                        if (value == null || value.trim().length < 5) {
                          return 'A mensagem deve ter pelo menos 5 caracteres.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _enviarMensagem,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: corBotao,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Enviar mensagem', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 80), 
          ],
        ),
      ),
    );
  }

  
  InputDecoration _estiloInput() {
    return InputDecoration(
      filled: true,
      fillColor: corFundoInput,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: corBordaInput),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFFBFA98D), width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.red, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}