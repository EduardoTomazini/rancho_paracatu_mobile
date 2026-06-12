import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_colors.dart';
import '../widgets/custom_drawer.dart';
import '../providers/carrinho_provider.dart';
import '../models/cart_item.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final Color corTitulo = const Color(0xFF2E2414);
  final Color corSubtitulo = const Color(0xFF4D3820);
  final Color corBorda = const Color(0xFFD6C9B8);
  final Color corBotaoAcao = const Color(0xFFE8E1D6);
  final Color corFundoInput = const Color(0xFFFAF5EE);
  final Color corBordaInput = const Color(0xFFCBBFAA);
  final Color corBotaoEnviar = const Color(0xFF4D3820);

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _mesaController = TextEditingController();
  final TextEditingController _mensagemController = TextEditingController();

  bool _sending = false;

  void _enviarPedido(CarrinhoProvider carrinho) async {
    FocusScope.of(context).unfocus();
    setState(() => _sending = true);

    // Simulando tempo de requisição de rede para envio do pedido (Cumpre RF009)
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _sending = false);

    String mesaDigitada = _mesaController.text.isNotEmpty ? _mesaController.text : 'Não informada';
    
    // Gerador de número de pedido dinâmico (não é mais fixo)
    String numeroPedido = 'PED-${Random().nextInt(9000) + 1000}';

    // Limpa o carrinho global após o envio
    carrinho.limparCarrinho();

    if (mounted) {
      _mostrarModalConfirmacao(mesaDigitada, numeroPedido);
    }
  }

  void _mostrarModalConfirmacao(String mesa, String numeroPedido) {
    showDialog(
      context: context,
      barrierDismissible: false, 
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent, 
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFAF3),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: corBorda),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, 
              children: [
                Text('Pedido enviado!', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: corSubtitulo, fontFamily: 'serif')),
                const SizedBox(height: 20),
                Text('Número do Pedido:', style: TextStyle(fontSize: 18, color: corSubtitulo)),
                const SizedBox(height: 4),
                Text(numeroPedido, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: corTitulo)),
                const SizedBox(height: 12),
                Text('Mesa: $mesa', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: corSubtitulo)),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); 
                      Navigator.of(context).pushNamed('/'); 
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: corBotaoEnviar,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Ok', style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fundo,
      appBar: AppBar(
        title: const Text('Fazer Pedido'),
      ),
      drawer: const CustomDrawer(),
      
      // Consumer injeta o estado do carrinho nesta tela em tempo real
      body: Consumer<CarrinhoProvider>(
        builder: (context, carrinho, child) {
          final itens = carrinho.itens.values.toList();
          final total = carrinho.valorTotal;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: corBorda),
                boxShadow: const [
                  BoxShadow(color: Color.fromARGB(13, 0, 0, 0), blurRadius: 15, offset: Offset(0, 5)), // Aviso withOpacity corrigido
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text('Seu Carrinho', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: corTitulo, fontFamily: 'serif')),
                  ),
                  const SizedBox(height: 24),

                  if (itens.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: corBorda),
                      ),
                      child: const Text(
                        'Seu carrinho está vazio.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ),

                  if (itens.isNotEmpty)
                    Column(
                      children: itens.map((item) => _buildItemCarrinho(item, carrinho)).toList(),
                    ),

                  if (itens.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Total: R\$ ${total.toStringAsFixed(2).replaceAll('.', ',')}',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: corTitulo),
                        ),
                      ),
                    ),

                  const SizedBox(height: 48),

                  Text('Dados do Pedido', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: corTitulo, fontFamily: 'serif')),
                  const SizedBox(height: 24),

                  TextField(
                    controller: _nomeController,
                    decoration: _estiloInput('Nome', 'Ex: João'),
                  ),
                  const SizedBox(height: 16),
                  
                  TextField(
                    controller: _mesaController,
                    keyboardType: TextInputType.number,
                    decoration: _estiloInput('Mesa', 'Ex: 12'),
                  ),
                  const SizedBox(height: 16),
                  
                  TextField(
                    controller: _mensagemController,
                    maxLines: 3,
                    decoration: _estiloInput('Observações', 'Ex: Tirar cebola, bebida sem gelo...'),
                  ),

                  const SizedBox(height: 32),

                  Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: (_sending || itens.isEmpty) ? null : () => _enviarPedido(carrinho),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: corBotaoEnviar,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: _sending
                              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                              : const Text('Enviar Pedido', style: TextStyle(fontSize: 16, color: Colors.white)),
                        ),
                      ),
                      
                      if (itens.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: carrinho.limparCarrinho,
                            style: OutlinedButton.styleFrom(
                              backgroundColor: corBorda,
                              side: BorderSide.none,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text('Esvaziar Carrinho', style: TextStyle(fontSize: 16, color: corTitulo, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ]
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildItemCarrinho(CartItem item, CarrinhoProvider carrinho) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: corBorda),
        boxShadow: const [
          BoxShadow(color: Color.fromARGB(8, 0, 0, 0), blurRadius: 5, offset: Offset(0, 2)), // Aviso withOpacity corrigido
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.titulo, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: corTitulo)),
                const SizedBox(height: 4),
                Text('R\$ ${item.preco.toStringAsFixed(2).replaceAll('.', ',')}', style: TextStyle(fontSize: 14, color: corSubtitulo)),
              ],
            ),
          ),
          Row(
            children: [
              _botaoQtd('-', () => carrinho.decrementarItem(item.id)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text('${item.quantidade}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: corTitulo)),
              ),
              _botaoQtd('+', () => carrinho.adicionarItem(item.id, item.titulo, item.preco)),
              
              IconButton(
                onPressed: () => carrinho.removerItem(item.id),
                icon: const Icon(Icons.delete_outline, color: Colors.red),
                tooltip: 'Remover',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _botaoQtd(String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: corBotaoAcao,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(label, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: corSubtitulo)),
      ),
    );
  }

  InputDecoration _estiloInput(String label, String hint) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF9A938A)),
      filled: true,
      fillColor: corFundoInput,
      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: corBordaInput), borderRadius: BorderRadius.circular(12)),
      focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFFBFA98D), width: 2), borderRadius: BorderRadius.circular(12)),
    );
  }
}