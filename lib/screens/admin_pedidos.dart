import 'package:flutter/material.dart';

class AdminPedidosScreen extends StatefulWidget {
  const AdminPedidosScreen({super.key});

  @override
  State<AdminPedidosScreen> createState() => _AdminPedidosScreenState();
}

class _AdminPedidosScreenState extends State<AdminPedidosScreen> {
  final Color corTitulo = const Color(0xFF4D3820);
  final Color corBorda = const Color(0xFFD6C9B8);
  final Color corFundoTabela = const Color(0xFFFFF8EF);
  final Color corCabecalhoTabela = const Color(0xFFE9DFD0);

  String _termoBusca = '';
  String _statusFiltro = '';
  int _novosPedidos = 2;

  // Lista mutável para permitir remoção de pedidos
  List<Map<String, dynamic>> _pedidosMock = [
    {
      'id': 142, 'name': 'Valdir Medeiros', 'mesa': 8,
      'created_at': '05/04/2026 12:30', 'total': 85.90,
      'status': 'novo', 'visto': false,
      'itens': [
        {'name': 'Feijoada Completa', 'quantidade': 1, 'price': 65.90},
        {'name': 'Suco de Laranja', 'quantidade': 2, 'price': 10.00},
      ],
    },
    {
      'id': 141, 'name': 'João Silva', 'mesa': 12,
      'created_at': '05/04/2026 12:15', 'total': 120.00,
      'status': 'preparando', 'visto': true,
      'itens': [
        {'name': 'Picanha na Brasa', 'quantidade': 1, 'price': 89.90},
        {'name': 'Refrigerante Lata', 'quantidade': 2, 'price': 8.00},
        {'name': 'Pão de Alho', 'quantidade': 1, 'price': 14.10},
      ],
    },
    {
      'id': 140, 'name': 'Maria Oliveira', 'mesa': 3,
      'created_at': '05/04/2026 11:45', 'total': 45.50,
      'status': 'pronto', 'visto': true,
      'itens': [
        {'name': 'Porção de Fritas', 'quantidade': 2, 'price': 18.00},
        {'name': 'Água Mineral', 'quantidade': 1, 'price': 5.00},
        {'name': 'Pudim', 'quantidade': 1, 'price': 4.50},
      ],
    },
    {
      'id': 139, 'name': 'Carlos Eduardo', 'mesa': 1,
      'created_at': '05/04/2026 10:30', 'total': 210.00,
      'status': 'entregue', 'visto': true,
      'itens': [
        {'name': 'Churrasco Misto', 'quantidade': 2, 'price': 95.00},
        {'name': 'Cerveja Long Neck', 'quantidade': 4, 'price': 10.00},
      ],
    },
    {
      'id': 138, 'name': 'Ana Paula', 'mesa': 5,
      'created_at': '05/04/2026 09:15', 'total': 32.00,
      'status': 'cancelado', 'visto': true,
      'itens': [
        {'name': 'Salada Caesar', 'quantidade': 1, 'price': 28.00},
        {'name': 'Suco de Abacaxi', 'quantidade': 1, 'price': 4.00},
      ],
    },
  ];

  List<Map<String, dynamic>> get _pedidosFiltrados {
    return _pedidosMock.where((p) {
      final matchBusca = p['name'].toString().toLowerCase().contains(_termoBusca.toLowerCase()) ||
                         p['id'].toString().contains(_termoBusca) ||
                         p['mesa'].toString().contains(_termoBusca);
      final matchStatus = _statusFiltro.isEmpty || p['status'] == _statusFiltro;
      return matchBusca && matchStatus;
    }).toList();
  }

  void _atualizar() {
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Lista de pedidos atualizada!'), backgroundColor: Colors.green),
    );
  }

  void _excluir(Map<String, dynamic> pedido) {
    setState(() => _pedidosMock.remove(pedido));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Pedido #${pedido['id']} excluído.'), backgroundColor: Colors.red),
    );
  }

  void _abrirModal(Map<String, dynamic> pedido) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return _ModalPedido(
          pedido: pedido,
          onStatusChange: (novoStatus) {
            setState(() => pedido['status'] = novoStatus);
          },
          onVisto: () {
            setState(() {
              pedido['visto'] = true;
              if (_novosPedidos > 0) _novosPedidos--;
            });
            Navigator.pop(context);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 16,
            runSpacing: 16,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Gerenciar Pedidos', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: corTitulo)),
                  if (_novosPedidos > 0) ...[
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: Colors.red[600], borderRadius: BorderRadius.circular(20), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)]),
                      child: Text('$_novosPedidos novo(s)', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                  ]
                ],
              ),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Container(
                    width: 200, height: 45,
                    decoration: BoxDecoration(color: Colors.white, border: Border.all(color: corBorda), borderRadius: BorderRadius.circular(8)),
                    child: TextField(
                      onChanged: (val) => setState(() => _termoBusca = val),
                      decoration: const InputDecoration(
                        hintText: 'Buscar...',
                        hintStyle: TextStyle(color: Color(0xFFBBAEA0)),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Container(
                    height: 45,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(color: Colors.white, border: Border.all(color: corBorda), borderRadius: BorderRadius.circular(8)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _statusFiltro.isEmpty ? null : _statusFiltro,
                        hint: const Text('Todos'),
                        items: const [
                          DropdownMenuItem(value: '', child: Text('Todos')),
                          DropdownMenuItem(value: 'novo', child: Text('Novo')),
                          DropdownMenuItem(value: 'preparando', child: Text('Preparando')),
                          DropdownMenuItem(value: 'pronto', child: Text('Pronto')),
                          DropdownMenuItem(value: 'entregue', child: Text('Entregue')),
                          DropdownMenuItem(value: 'cancelado', child: Text('Cancelado')),
                        ],
                        onChanged: (val) => setState(() => _statusFiltro = val ?? ''),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _atualizar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: corTitulo,
                      minimumSize: const Size(0, 45),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Atualizar', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: corFundoTabela,
              border: Border.all(color: corBorda),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
            ),
            clipBehavior: Clip.antiAlias,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(corCabecalhoTabela),
                dataRowMinHeight: 60,
                dataRowMaxHeight: 70,
                columns: const [
                  DataColumn(label: Text('#', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Cliente', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Mesa', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Data/Hora', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Total', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Ações', style: TextStyle(fontWeight: FontWeight.bold))),
                ],
                rows: _pedidosFiltrados.map((pedido) {
                  final bool isVisto = pedido['visto'];
                  final corTexto = isVisto ? corTitulo.withValues(alpha: 0.7) : corTitulo;

                  return DataRow(
                    cells: [
                      DataCell(Text('#${pedido['id']}', style: TextStyle(color: corTexto, fontWeight: FontWeight.bold))),
                      DataCell(Text(pedido['name'], style: TextStyle(color: corTexto))),
                      DataCell(Text(pedido['mesa'].toString(), style: TextStyle(color: corTexto))),
                      DataCell(Text(pedido['created_at'], style: TextStyle(color: corTexto, fontSize: 13))),
                      DataCell(Text('R\$ ${pedido['total'].toStringAsFixed(2)}', style: TextStyle(color: corTexto, fontWeight: FontWeight.bold))),
                      DataCell(_badgeStatus(pedido['status'])),
                      DataCell(
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () => _abrirModal(pedido),
                              style: ElevatedButton.styleFrom(backgroundColor: corTitulo, foregroundColor: Colors.white),
                              child: const Text('Ver'),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () => _excluir(pedido),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.red[600], foregroundColor: Colors.white),
                              child: const Text('Excluir'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),

          if (_pedidosFiltrados.isEmpty)
            const Padding(
              padding: EdgeInsets.all(32.0),
              child: Center(child: Text('Nenhum pedido encontrado.', style: TextStyle(color: Colors.grey, fontSize: 16))),
            ),
        ],
      ),
    );
  }

  Widget _badgeStatus(String status) {
    Color bg; Color text;
    switch (status) {
      case 'novo': bg = Colors.yellow[200]!; text = Colors.yellow[800]!; break;
      case 'preparando': bg = Colors.blue[200]!; text = Colors.blue[800]!; break;
      case 'pronto': bg = Colors.purple[200]!; text = Colors.purple[900]!; break;
      case 'entregue': bg = Colors.green[200]!; text = Colors.green[800]!; break;
      case 'cancelado': bg = Colors.grey[300]!; text = Colors.grey[700]!; break;
      default: bg = Colors.grey[200]!; text = Colors.black;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
      child: Text(status.toUpperCase(), style: TextStyle(color: text, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }
}


class _ModalPedido extends StatefulWidget {
  final Map<String, dynamic> pedido;
  final Function(String) onStatusChange;
  final VoidCallback onVisto;

  const _ModalPedido({required this.pedido, required this.onStatusChange, required this.onVisto});

  @override
  State<_ModalPedido> createState() => _ModalPedidoState();
}

class _ModalPedidoState extends State<_ModalPedido> {
  late String _statusLocal;

  @override
  void initState() {
    super.initState();
    _statusLocal = widget.pedido['status'];
  }

  void _atualizarStatus() {
    widget.onStatusChange(_statusLocal);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Status atualizado!'), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Lê os itens diretamente do mapa do pedido passado
    final List<dynamic> itens = widget.pedido['itens'] ?? [];

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600),
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.start,
                spacing: 16,
                runSpacing: 16,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Pedido #${widget.pedido['id']}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF4D3820))),
                      const SizedBox(height: 4),
                      Text(widget.pedido['name'], style: const TextStyle(color: Color(0xFF6B4F28), fontSize: 14)),
                      Text('Mesa: ${widget.pedido['mesa']}', style: const TextStyle(color: Color(0xFF6B4F28), fontSize: 14)),
                      Text('Feito em: ${widget.pedido['created_at']}', style: const TextStyle(color: Color(0xFF6B4F28), fontSize: 14, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('Total: R\$ ${widget.pedido['total'].toStringAsFixed(2)}', style: const TextStyle(color: Color(0xFF6B4F28), fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Container(
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(border: Border.all(color: const Color(0xFFD6C9B8)), borderRadius: BorderRadius.circular(4)),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _statusLocal,
                            items: const [
                              DropdownMenuItem(value: 'novo', child: Text('Novo')),
                              DropdownMenuItem(value: 'preparando', child: Text('Preparando')),
                              DropdownMenuItem(value: 'pronto', child: Text('Pronto')),
                              DropdownMenuItem(value: 'entregue', child: Text('Entregue')),
                              DropdownMenuItem(value: 'cancelado', child: Text('Cancelado')),
                            ],
                            onChanged: (val) => setState(() => _statusLocal = val!),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _atualizarStatus,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4D3820),
                          foregroundColor: Colors.white,
                          minimumSize: const Size(0, 40),
                        ),
                        child: const Text('Atualizar'),
                      ),
                    ],
                  ),
                ],
              ),

              const Divider(height: 32, color: Color(0xFFD6C9B8)),

              const Text('Itens do Pedido', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF4D3820))),
              const SizedBox(height: 12),

              if (itens.isEmpty)
                const Text('Nenhum item registrado.', style: TextStyle(color: Colors.grey))
              else
                ...itens.map((it) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFADF),
                    border: Border.all(color: const Color(0xFFE2D9C8)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(it['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text(
                            'Qtd: ${it['quantidade']} — R\$ ${(it['price'] as double).toStringAsFixed(2)} cada',
                            style: const TextStyle(color: Color(0xFF6B4F28), fontSize: 13),
                          ),
                        ],
                      ),
                      Text(
                        'R\$ ${(it['quantidade'] * (it['price'] as double)).toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF4D3820)),
                      ),
                    ],
                  ),
                )),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(foregroundColor: Colors.black87),
                    child: const Text('Fechar'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: widget.onVisto,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green[600], foregroundColor: Colors.white),
                    child: const Text('Marcar como visto'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}