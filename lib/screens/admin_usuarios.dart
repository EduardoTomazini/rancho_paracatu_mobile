import 'package:flutter/material.dart';

class AdminUsuariosScreen extends StatefulWidget {
  const AdminUsuariosScreen({super.key});

  @override
  State<AdminUsuariosScreen> createState() => _AdminUsuariosScreenState();
}

class _AdminUsuariosScreenState extends State<AdminUsuariosScreen> {

  final Color corTitulo = const Color(0xFF4D3820);
  final Color corBorda = const Color(0xFFD6C9B8);
  final Color corFundoTabela = const Color(0xFFFFF8EF);
  final Color corCabecalhoTabela = const Color(0xFFE9DFD0);

 
  bool _alertaVisivel = false;
  String _alertaMensagem = '';
  String _alertaTipo = 'success';

 
  String _busca = '';
  String _tipoFiltro = '';
  int _paginaAtual = 1;
  final int _totalPaginas = 2; 

  
  bool _formAberto = false;
  bool _editando = false;
  
  final TextEditingController _nomeCtrl = TextEditingController();
  final TextEditingController _emailCtrl = TextEditingController();
  String _tipoForm = 'Cliente';
  Map<String, dynamic>? _usuarioEmEdicao;

  
  final List<Map<String, dynamic>> _usuariosMock = [
    {
      'id': 1, 
      'nome': 'Eduardo', 
      'email': 'admin@ranchoparacatu.com', 
      'tipo': 'Administrador', 
      'ativo': true,
      'logs': [
        {'descricao': 'Fez login no sistema', 'data': '05/04/2026 14:00'},
        {'descricao': 'Alterou o cardápio', 'data': '05/04/2026 14:15'},
      ]
    },
    {
      'id': 2, 
      'nome': 'Felipy', 
      'email': 'joao@email.com', 
      'tipo': 'Cliente', 
      'ativo': true,
      'logs': [
        {'descricao': 'Criou a conta', 'data': '01/04/2026 10:00'},
        {'descricao': 'Fez um pedido (#141)', 'data': '05/04/2026 12:15'},
      ]
    },
    {
      'id': 3, 
      'nome': 'Mariah Oliveira', 
      'email': 'maria@email.com', 
      'tipo': 'Cliente', 
      'ativo': false,
      'logs': []
    },
  ];

  
  List<Map<String, dynamic>> get _filtrados {
    return _usuariosMock.where((u) {
      final matchBusca = u['nome'].toString().toLowerCase().contains(_busca.toLowerCase()) || 
                         u['email'].toString().toLowerCase().contains(_busca.toLowerCase());
      final matchTipo = _tipoFiltro.isEmpty || u['tipo'] == _tipoFiltro;
      return matchBusca && matchTipo;
    }).toList();
  }

 

  void _mostrarAlerta(String mensagem, String tipo) {
    setState(() {
      _alertaMensagem = mensagem;
      _alertaTipo = tipo;
      _alertaVisivel = true;
    });
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _alertaVisivel = false);
    });
  }

  void _carregarUsuarios() {
    FocusScope.of(context).unfocus();
    _mostrarAlerta('Lista de usuários atualizada!', 'success');
  }

  void _abrirAdicionar() {
    setState(() {
      _editando = false;
      _formAberto = true;
      _usuarioEmEdicao = null;
      _nomeCtrl.clear();
      _emailCtrl.clear();
      _tipoForm = 'Cliente';
    });
  }

  void _editar(Map<String, dynamic> usuario) {
    setState(() {
      _editando = true;
      _formAberto = true;
      _usuarioEmEdicao = usuario;
      _nomeCtrl.text = usuario['nome'];
      _emailCtrl.text = usuario['email'];
      _tipoForm = usuario['tipo'];
    });
  }

  void _cancelar() {
    setState(() => _formAberto = false);
  }

  void _salvar() {
    if (_nomeCtrl.text.isEmpty || _emailCtrl.text.isEmpty) return;
    
    setState(() {
      if (_editando && _usuarioEmEdicao != null) {
        _usuarioEmEdicao!['nome'] = _nomeCtrl.text;
        _usuarioEmEdicao!['email'] = _emailCtrl.text;
        _usuarioEmEdicao!['tipo'] = _tipoForm;
      } else {
        _usuariosMock.add({
          'id': _usuariosMock.length + 1,
          'nome': _nomeCtrl.text,
          'email': _emailCtrl.text,
          'tipo': _tipoForm,
          'ativo': true,
          'logs': [],
        });
      }
      _formAberto = false;
    });
    _mostrarAlerta('Usuário salvo com sucesso!', 'success');
  }

  void _toggleAtivo(Map<String, dynamic> usuario) {
    setState(() => usuario['ativo'] = !usuario['ativo']);
    _mostrarAlerta(usuario['ativo'] ? 'Usuário ativado.' : 'Usuário desativado.', 'success');
  }

  void _excluir(Map<String, dynamic> usuario) {
    if (usuario['tipo'] == 'Administrador') {
      _mostrarAlerta('Você não pode excluir um administrador.', 'error');
      return;
    }
    setState(() => _usuariosMock.remove(usuario));
    _mostrarAlerta('Usuário excluído.', 'error');
  }

  
  void _abrirLogs(Map<String, dynamic> usuario) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        List logs = usuario['logs'];
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Atividades de ${usuario['nome']}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: corTitulo)),
                const SizedBox(height: 16),
                
                if (logs.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(child: Text('Nenhuma atividade registrada para este usuário.', style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic))),
                  )
                else
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: logs.length,
                      itemBuilder: (context, index) {
                        final log = logs[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: corFundoTabela, border: Border.all(color: const Color(0xFFE8DDCD)), borderRadius: BorderRadius.circular(8)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(log['descricao'], style: TextStyle(fontWeight: FontWeight.bold, color: corTitulo)),
                              const SizedBox(height: 4),
                              Text(log['data'], style: const TextStyle(fontSize: 12, color: Color(0xFF6B4F28))),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(backgroundColor: corTitulo, foregroundColor: Colors.white),
                    child: const Text('Fechar'),
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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          if (_alertaVisivel)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: _alertaTipo == 'success' ? Colors.green[600] : Colors.red[600],
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
              ),
              child: Text(_alertaMensagem, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),

          Text('Gerenciar Usuários', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: corTitulo)),
          const SizedBox(height: 24),

          
          Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _abrirAdicionar,
                style: ElevatedButton.styleFrom(backgroundColor: corTitulo, foregroundColor: Colors.white, minimumSize: const Size(0, 45)),
                child: const Text('+ Adicionar Usuário'),
              ),
              ElevatedButton(
                onPressed: _carregarUsuarios,
                style: ElevatedButton.styleFrom(backgroundColor: corTitulo, foregroundColor: Colors.white, minimumSize: const Size(0, 45)),
                child: const Text('⟳ Atualizar'),
              ),
              
              
              const SizedBox(width: 8),

              Container(
                width: 250, height: 45,
                decoration: BoxDecoration(color: Colors.white, border: Border.all(color: corBorda), borderRadius: BorderRadius.circular(8)),
                child: TextField(
                  onChanged: (val) => setState(() => _busca = val),
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
                    value: _tipoFiltro.isEmpty ? null : _tipoFiltro,
                    hint: const Text('Todos os tipos'),
                    items: const [
                      DropdownMenuItem(value: '', child: Text('Todos os tipos')),
                      DropdownMenuItem(value: 'Cliente', child: Text('Cliente')),
                      DropdownMenuItem(value: 'Administrador', child: Text('Administrador')),
                    ],
                    onChanged: (val) => setState(() => _tipoFiltro = val ?? ''),
                  ),
                ),
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
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
            ),
            clipBehavior: Clip.antiAlias,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(corCabecalhoTabela),
                dataRowMinHeight: 60,
                dataRowMaxHeight: 70,
                columns: const [
                  DataColumn(label: Text('Avatar', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Nome', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Email', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Tipo', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Ações', style: TextStyle(fontWeight: FontWeight.bold))),
                ],
                rows: _filtrados.map((u) {
                  
                  String letraAvatar = u['nome'].toString().isNotEmpty ? u['nome'].toString()[0].toUpperCase() : '?';

                  return DataRow(
                    cells: [
                      DataCell(CircleAvatar(backgroundColor: corTitulo, foregroundColor: Colors.white, child: Text(letraAvatar))),
                      DataCell(Text(u['nome'], style: TextStyle(color: corTitulo, fontWeight: FontWeight.bold))),
                      DataCell(Text(u['email'], style: TextStyle(color: corTitulo))),
                      DataCell(_badgeTipo(u['tipo'])),
                      DataCell(
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () => _abrirLogs(u),
                              style: ElevatedButton.styleFrom(backgroundColor: corTitulo, foregroundColor: Colors.white),
                              child: const Text('Logs'),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () => _editar(u),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[600], foregroundColor: Colors.white),
                              child: const Text('Editar'),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () => _toggleAtivo(u),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: u['ativo'] ? Colors.yellow[700] : Colors.green[600], 
                                foregroundColor: Colors.white
                              ),
                              child: Text(u['ativo'] ? 'Desativar' : 'Ativar'),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () => _excluir(u),
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
          
          if (_filtrados.isEmpty)
             Container(
               width: double.infinity,
               color: corFundoTabela,
               padding: const EdgeInsets.all(24.0),
               child: const Center(child: Text('Nenhum usuário encontrado.', style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic))),
             ),

          
          Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _paginaAtual > 1 ? () => setState(() => _paginaAtual--) : null,
                      style: ElevatedButton.styleFrom(backgroundColor: corTitulo, foregroundColor: Colors.white),
                      child: const Text('⟵ Anterior'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Text('Página $_paginaAtual / $_totalPaginas', style: TextStyle(fontWeight: FontWeight.bold, color: corTitulo, fontSize: 16)),
                    ),
                    ElevatedButton(
                      onPressed: _paginaAtual < _totalPaginas ? () => setState(() => _paginaAtual++) : null,
                      style: ElevatedButton.styleFrom(backgroundColor: corTitulo, foregroundColor: Colors.white),
                      child: const Text('Próxima ⟶'),
                    ),
                  ],
                ),
              ),
            ),
          ),

         
          if (_formAberto) ...[
            const SizedBox(height: 40),
            Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 600),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: corBorda),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_editando ? 'Editar Usuário' : 'Adicionar Usuário', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: corTitulo)),
                    const SizedBox(height: 24),
                    
                    TextField(controller: _nomeCtrl, decoration: _inputDeco('Nome completo')),
                    const SizedBox(height: 16),
                    
                    TextField(controller: _emailCtrl, keyboardType: TextInputType.emailAddress, decoration: _inputDeco('Email')),
                    const SizedBox(height: 16),
                    
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(border: Border.all(color: Colors.grey[400]!), borderRadius: BorderRadius.circular(4)),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: _tipoForm,
                          items: const [
                            DropdownMenuItem(value: 'Cliente', child: Text('Cliente')),
                            DropdownMenuItem(value: 'Administrador', child: Text('Administrador')),
                          ],
                          onChanged: (val) => setState(() => _tipoForm = val!),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: _salvar,
                          style: ElevatedButton.styleFrom(backgroundColor: corTitulo, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16)),
                          child: const Text('Salvar'),
                        ),
                        const SizedBox(width: 12),
                        TextButton(
                          onPressed: _cancelar,
                          style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16), backgroundColor: Colors.grey[300], foregroundColor: Colors.black87),
                          child: const Text('Cancelar'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ]
        ],
      ),
    );
  }

  

  
  Widget _badgeTipo(String tipo) {
    bool isAdmin = tipo == 'Administrador';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(color: isAdmin ? Colors.green[200] : Colors.blue[200], borderRadius: BorderRadius.circular(12)),
      child: Text(tipo.toUpperCase(), style: TextStyle(color: isAdmin ? Colors.green[800] : Colors.blue[800], fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }

  InputDecoration _inputDeco(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFFBBAEA0)),
      border: const OutlineInputBorder(),
      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey[400]!)),
      contentPadding: const EdgeInsets.all(12),
    );
  }
}