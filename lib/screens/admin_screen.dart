import 'package:flutter/material.dart';
import 'admin_cardapio.dart';
import 'admin_config.dart';
import 'admin_pedidos.dart';
import 'admin_usuarios.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  
  final Color corFundo = const Color(0xFFF4E8D5);
  final Color corSidebar = const Color(0xFF5C3D2E);
  final Color corSidebarTexto = const Color(0xFFF5E6D3);
  final Color corSidebarAtivo = const Color(0xFF82614D);
  final Color corTopbar = const Color(0xFFE9D8C3);

 
  int _indiceAtual = 0;
  final int _novosPedidosGlobal = 3; 
  final String _userEmail = 'admin@ranchoparacatu.com';

  
  final List<Widget> _paginasInternas = [
    const AdminCardapioScreen(),
    const AdminPedidosScreen(),
    const AdminUsuariosScreen(),
    const AdminConfigScreen(),
  ];

 
  void _logout() {
    
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    
    bool isDesktop = MediaQuery.of(context).size.width >= 1024;

    return Scaffold(
      backgroundColor: corFundo,
      
      appBar: isDesktop ? null : _buildTopbar(),
      
      
      drawer: isDesktop ? null : _buildSidebar(isDesktop: false),
      
      body: Row(
        children: [
          
          if (isDesktop) _buildSidebar(isDesktop: true),
          
          
          Expanded(
            child: Column(
              children: [
                
                if (isDesktop) _buildTopbar(),
                
                
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: _paginasInternas[_indiceAtual],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  

  PreferredSizeWidget _buildTopbar() {
    
    double larguraTela = MediaQuery.of(context).size.width;
    bool isCelular = larguraTela < 600; 

    return AppBar(
      backgroundColor: corTopbar,
      elevation: 1, 
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          
          const Flexible(
            child: Text(
              'Bem-vindo(a)!',
              style: TextStyle(color: Color(0xFF5C3D2E), fontWeight: FontWeight.bold, fontSize: 18),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          
          
          if (_novosPedidosGlobal > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red[600],
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
              ),
              child: Text(
                isCelular ? '$_novosPedidosGlobal' : '$_novosPedidosGlobal novo(s)', 
                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              
              if (!isCelular) ...[
                Text(_userEmail, style: const TextStyle(color: Color(0xFF5C3D2E), fontSize: 14)),
                const SizedBox(width: 12),
              ],
              
              CircleAvatar(
                backgroundColor: corSidebar,
                child: Text(_userEmail[0].toUpperCase(), style: TextStyle(color: corSidebarTexto, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        )
      ],
      iconTheme: const IconThemeData(color: Color(0xFF5C3D2E)),
    );
  }

  Widget _buildSidebar({required bool isDesktop}) {
    Widget sidebarContent = Container(
      width: 256, // w-64
      color: corSidebar,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: const Color(0xFF8A6A55).withOpacity(0.4)))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Rancho Paracatu', style: TextStyle(color: corSidebarTexto, fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('Painel Administrativo', style: TextStyle(color: corSidebarTexto.withOpacity(0.8), fontSize: 14)),
              ],
            ),
          ),
          
          
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildMenuItem('Cardápio', 0),
                _buildMenuItem('Pedidos', 1),
                _buildMenuItem('Usuários', 2),
                _buildMenuItem('Configurações', 3),
              ],
            ),
          ),
          
          
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _logout,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[600],
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Sair', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );

    
    return isDesktop ? sidebarContent : Drawer(child: sidebarContent);
  }

  Widget _buildMenuItem(String titulo, int index) {
    bool isAtivo = _indiceAtual == index;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: InkWell(
        onTap: () {
          setState(() => _indiceAtual = index);
          
          if (MediaQuery.of(context).size.width < 1024) {
            Navigator.pop(context);
          }
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isAtivo ? corSidebarAtivo : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            titulo,
            style: TextStyle(
              color: corSidebarTexto,
              fontSize: 16,
              fontWeight: isAtivo ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}


class _PlaceholderPage extends StatelessWidget {
  final String titulo;
  final IconData icone;

  const _PlaceholderPage({required this.titulo, required this.icone});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE9D8C3)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icone, size: 80, color: const Color(0xFF8A6A55).withOpacity(0.5)),
          const SizedBox(height: 16),
          Text(titulo, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF5C3D2E))),
          const SizedBox(height: 8),
          const Text('A estrutura visual desta tela será montada em breve.', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}