import 'package:flutter/material.dart';
import 'core/theme/app_colors.dart';
import '../widgets/custom_drawer.dart';

class MeusPedidosScreen extends StatefulWidget {
  const MeusPedidosScreen({super.key});

  @override
  State<MeusPedidosScreen> createState() => _MeusPedidosScreenState();
}

class _MeusPedidosScreenState extends State<MeusPedidosScreen> {
  
  final Color corTitulo = const Color(0xFF4D3820);
  final Color corBorda = const Color(0xFFD6C9B8);
  final Color corFundoInput = const Color(0xFFFAF5EE);
  final Color corBotao = const Color(0xFF4D3820);

  
  bool _isLoading = false;
  bool _searched = false;

  
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _mesaController = TextEditingController();

 
  List<Map<String, dynamic>> _pedidos = [];
  final List<Map<String, dynamic>> _pedidosMockados = [
    {
      'id': 142,
      'status': 'novo',
      'mesa': 8,
      'total': 85.50,
      'num_pedido': 'PED-0142',
      'created_at': '05/04/2026 12:30',
      'realtimeUpdate': true, // Simula a tag piscando
    },
    {
      'id': 141,
      'status': 'preparando',
      'mesa': 8,
      'total': 42.00,
      'num_pedido': 'PED-0141',
      'created_at': '05/04/2026 12:15',
      'realtimeUpdate': false,
    },
    {
      'id': 130,
      'status': 'entregue',
      'mesa': 8,
      'total': 112.90,
      'num_pedido': 'PED-0130',
      'created_at': '05/04/2026 11:00',
      'realtimeUpdate': false,
    },
  ];

  
  void _buscarPedidos() async {
    
    FocusScope.of(context).unfocus(); 
    
    setState(() {
      _isLoading = true;
      _searched = false;
      _pedidos = [];
    });

    
    await Future.delayed(const Duration(milliseconds: 1500));

    setState(() {
      _isLoading = false;
      _searched = true;
      
      if (_nomeController.text.isNotEmpty || _mesaController.text.isNotEmpty) {
        _pedidos = _pedidosMockados;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fundo,
      appBar: AppBar(
        title: const Text('Meus Pedidos'),
      ),
      drawer: const CustomDrawer(),
      
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            
            
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE5DCCF)),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text('Meus Pedidos', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: corTitulo)),
                  ),
                  const SizedBox(height: 24),

                  
                  Text('Seu nome', style: TextStyle(fontWeight: FontWeight.bold, color: corTitulo)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _nomeController,
                    decoration: _estiloInput('Digite seu nome'),
                  ),
                  const SizedBox(height: 16),

                  
                  Text('Número da mesa', style: TextStyle(fontWeight: FontWeight.bold, color: corTitulo)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _mesaController,
                    keyboardType: TextInputType.number,
                    decoration: _estiloInput('Ex: 8'),
                  ),
                  const SizedBox(height: 24),

                 
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _buscarPedidos,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: corBotao,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: _isLoading
                          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Text('Buscar pedidos', style: TextStyle(fontSize: 16)),
                    ),
                  ),

                  
                  if (!_isLoading && _searched && _pedidos.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: Center(child: Text('Nenhum pedido encontrado.', style: TextStyle(color: Color(0xFF7A6A5A)))),
                    ),
                ],
              ),
            ),

           
            if (_pedidos.isNotEmpty) ...[
              const SizedBox(height: 32),
              
              
              ..._pedidos.map((p) => _buildCardPedido(p)),
            ],

            const SizedBox(height: 40),

            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  
                  Navigator.pushNamed(context, '/contato');
                },
                icon: const Icon(Icons.support_agent),
                label: const Text('Precisa de ajuda? Falar com o atendimento'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: corBotao,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

 

 
  Widget _buildCardPedido(Map<String, dynamic> p) {
    
    final badgeConfig = _getCorStatus(p['status']);

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8EF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5DCCF)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none, 
        children: [
          
          
          if (p['realtimeUpdate'] == true)
            Positioned(
              top: -36, 
              right: -10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green[600],
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                ),
                child: const Text('Atualizado', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ),

          
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Pedido #${p['id']}', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: corTitulo)),
                  
                  
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: badgeConfig['bg'],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      p['status'].toString().toUpperCase(),
                      style: TextStyle(color: badgeConfig['text'], fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text('Mesa ${p['mesa']}', style: TextStyle(fontSize: 18, color: corTitulo)),
              const SizedBox(height: 8),
              Text('Total: R\$ ${p['total'].toStringAsFixed(2).replaceAll('.', ',')}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: corTitulo)),
              const SizedBox(height: 16),
              Text('Número do pedido: ${p['num_pedido']}', style: const TextStyle(fontSize: 14, color: Color(0xFF6B4F28), fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('Realizado em: ${p['created_at']}', style: const TextStyle(fontSize: 14, color: Color(0xFF6B4F28))),
            ],
          ),
        ],
      ),
    );
  }

  
  Map<String, Color> _getCorStatus(String status) {
    switch (status) {
      case 'novo':
        return {'bg': Colors.yellow[200]!, 'text': Colors.yellow[800]!};
      case 'preparando':
        return {'bg': Colors.blue[200]!, 'text': Colors.blue[800]!};
      case 'pronto':
        return {'bg': Colors.purple[200]!, 'text': Colors.purple[800]!};
      case 'entregue':
        return {'bg': Colors.green[200]!, 'text': Colors.green[800]!};
      case 'cancelado':
      default:
        return {'bg': Colors.grey[300]!, 'text': Colors.grey[700]!};
    }
  }

  
  InputDecoration _estiloInput(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF9A938A)),
      filled: true,
      fillColor: corFundoInput,
      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: corBorda), borderRadius: BorderRadius.circular(12)),
      focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFFBFA98D), width: 2), borderRadius: BorderRadius.circular(12)),
    );
  }
}