import 'package:flutter/material.dart';

class AdminCardapioScreen extends StatefulWidget {
  const AdminCardapioScreen({super.key});

  @override
  State<AdminCardapioScreen> createState() => _AdminCardapioScreenState();
}

class _AdminCardapioScreenState extends State<AdminCardapioScreen> {
  final Color corTextoPrincipal = const Color(0xFF4D3820);
  final Color corTextoSecundario = const Color(0xFF6B4F28);
  final Color corBorda = const Color(0xFFD6C9B8);
  final Color corAbaInativa = const Color(0xFFE9DFD0);
  final Color corFundoTabela = const Color(0xFFFFF8EF);
  

  String _termoBusca = '';
  String _categoriaSelecionada = 'todas';
  int _paginaAtual = 1;
  final int _totalPaginas = 3; // Simulação

 
  bool _alertaVisivel = false;
  String _alertaMensagem = '';
  String _alertaTipo = 'success';

  
  bool _formAberto = false;
  bool _editando = false;
  bool _saving = false;

  
  final TextEditingController _nomeCtrl = TextEditingController();
  final TextEditingController _precoCtrl = TextEditingController();
  final TextEditingController _descCtrl = TextEditingController();
  final TextEditingController _ingredientesCtrl = TextEditingController();
  final TextEditingController _imgUrlCtrl = TextEditingController();
  String _catForm = '';

  
  final List<Map<String, dynamic>> _itensMock = [
    {
      'id': 1,
      'name': 'Feijoada Completa',
      'category': 'Pratos',
      'price': 65.90,
      'description': 'Acompanha arroz, couve, farofa, torresmo e laranja.',
      'ingredients': 'Feijão preto, carne seca, lombo, costelinha...',
      'image_url': '',
    },
    {
      'id': 2,
      'name': 'Suco de Laranja',
      'category': 'Bebidas',
      'price': 12.00,
      'description': 'Suco natural 500ml feito na hora.',
      'ingredients': 'Laranja, água, açúcar/adoçante',
      'image_url': '',
    },
  ];

  

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

  void _abrirFormulario({Map<String, dynamic>? item}) {
    setState(() {
      _formAberto = true;
      if (item != null) {
        _editando = true;
        _nomeCtrl.text = item['name'];
        _precoCtrl.text = item['price'].toString();
        _descCtrl.text = item['description'];
        _ingredientesCtrl.text = item['ingredients'];
        _imgUrlCtrl.text = item['image_url'];
        _catForm = item['category'];
      } else {
        _editando = false;
        _nomeCtrl.clear();
        _precoCtrl.clear();
        _descCtrl.clear();
        _ingredientesCtrl.clear();
        _imgUrlCtrl.clear();
        _catForm = '';
      }
    });
  }

  void _fecharFormulario() {
    setState(() {
      _formAberto = false;
    });
  }

  void _salvarItem() async {
    setState(() => _saving = true);
    await Future.delayed(const Duration(seconds: 1)); // Simula API
    setState(() {
      _saving = false;
      _formAberto = false;
    });
    _mostrarAlerta('Item salvo com sucesso!', 'success');
  }

  void _excluirItem(Map<String, dynamic> item) {
    
    _mostrarAlerta('${item['name']} excluído com sucesso.', 'error'); // error = vermelho
  }

  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width >= 1024;

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
              Text('Gerenciar Cardápio', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: corTextoPrincipal)),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  Container(
                    width: 200,
                    height: 45,
                    decoration: BoxDecoration(color: Colors.white, border: Border.all(color: corBorda), borderRadius: BorderRadius.circular(8)),
                    child: TextField(
                      onChanged: (val) => setState(() => _termoBusca = val),
                      decoration: const InputDecoration(
                        hintText: 'Buscar item...',
                        hintStyle: TextStyle(color: Color(0xFFBBAEA0)),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _abrirFormulario(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: corTextoPrincipal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      minimumSize: const Size(0, 45),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('+ Adicionar Item', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),

          
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildAba('Todas', 'todas'),
              _buildAba('Pratos', 'Pratos'),
              _buildAba('Bebidas', 'Bebidas'),
              _buildAba('Sobremesas', 'Sobremesas'),
            ],
          ),
          const SizedBox(height: 24),

          
          if (_alertaVisivel)
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: _alertaTipo == 'success' ? Colors.green[600] : Colors.red[600],
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
              ),
              child: Text(_alertaMensagem, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),

          
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
                headingRowColor: WidgetStateProperty.all(corAbaInativa),
                dataRowMinHeight: 60,
                dataRowMaxHeight: 80,
                columns: const [
                  DataColumn(label: Text('Imagem', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Nome', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Categoria', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Preço', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Descrição', style: TextStyle(fontWeight: FontWeight.bold))),
                  DataColumn(label: Text('Ações', style: TextStyle(fontWeight: FontWeight.bold))),
                ],
                rows: _itensMock.map((item) {
                  return DataRow(
                    cells: [
                      DataCell(
                        Container(
                          width: 50, height: 50,
                          decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(4)),
                          child: const Icon(Icons.image, color: Colors.white),
                        ),
                      ),
                      DataCell(Text(item['name'], style: TextStyle(color: corTextoPrincipal, fontWeight: FontWeight.bold))),
                      DataCell(Text(item['category'], style: TextStyle(color: corTextoPrincipal))),
                      DataCell(Text('R\$ ${item['price'].toStringAsFixed(2)}', style: TextStyle(color: corTextoPrincipal))),
                      DataCell(
                        SizedBox(
                          width: 200,
                          child: Text(item['description'], maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(color: corTextoSecundario)),
                        ),
                      ),
                      DataCell(
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () => _abrirFormulario(item: item),
                              style: ElevatedButton.styleFrom(backgroundColor: corTextoPrincipal, foregroundColor: Colors.white),
                              child: const Text('Editar'),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () => _excluirItem(item),
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

          
          Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown, // Reduz proporcionalmente se faltar espaço
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _paginaAtual > 1 ? () => setState(() => _paginaAtual--) : null,
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFB59A80), foregroundColor: Colors.white),
                      child: const Text('← Anterior'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Text(
                        'Página $_paginaAtual / $_totalPaginas', 
                        style: TextStyle(fontWeight: FontWeight.bold, color: corTextoPrincipal, fontSize: 16),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _paginaAtual < _totalPaginas ? () => setState(() => _paginaAtual++) : null,
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFB59A80), foregroundColor: Colors.white),
                      child: const Text('Próxima →'),
                    ),
                  ],
                ),
              ),
            ),
          ),

          
          if (_formAberto) ...[
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: corBorda),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
              ),
              child: isDesktop 
                  ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [_buildCamposForm(), const SizedBox(width: 40), _buildPreview()])
                  : Column(children: [_buildCamposForm(), const SizedBox(height: 40), _buildPreview()]),
            ),
          ]
        ],
      ),
    );
  }

  

  Widget _buildAba(String titulo, String valor) {
    bool isAtivo = _categoriaSelecionada == valor;
    return InkWell(
      onTap: () => setState(() => _categoriaSelecionada = valor),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isAtivo ? corTextoPrincipal : corAbaInativa,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))],
        ),
        child: Text(titulo, style: TextStyle(color: isAtivo ? Colors.white : corTextoPrincipal, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildCamposForm() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_editando ? 'Editar Item' : 'Adicionar Item', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              TextButton(onPressed: _fecharFormulario, child: const Text('Fechar', style: TextStyle(color: Colors.grey))),
            ],
          ),
          const SizedBox(height: 16),
          
          TextField(controller: _nomeCtrl, decoration: _inputDeco('Nome do item')),
          const SizedBox(height: 16),
          
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(border: Border.all(color: Colors.grey[400]!), borderRadius: BorderRadius.circular(4)),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: _catForm.isEmpty ? null : _catForm,
                hint: const Text('Selecione a categoria'),
                items: ['Pratos', 'Bebidas', 'Sobremesas'].map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (val) => setState(() => _catForm = val!),
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          TextField(controller: _precoCtrl, keyboardType: TextInputType.number, decoration: _inputDeco('Preço')),
          const SizedBox(height: 16),
          
          TextField(controller: _descCtrl, maxLines: 3, decoration: _inputDeco('Descrição do prato')),
          const SizedBox(height: 16),
          
          TextField(controller: _ingredientesCtrl, maxLines: 2, decoration: _inputDeco('Ingredientes (separados por vírgula)')),
          const SizedBox(height: 24),
          
          Row(
            children: [
              ElevatedButton(
                onPressed: _saving ? null : _salvarItem,
                style: ElevatedButton.styleFrom(backgroundColor: corTextoPrincipal, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16)),
                child: Text(_saving ? 'Salvando...' : 'Salvar'),
              ),
              const SizedBox(width: 12),
              TextButton(
                onPressed: _fecharFormulario,
                style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16), backgroundColor: Colors.grey[300], foregroundColor: Colors.black87),
                child: const Text('Cancelar'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPreview() {
    
    return AnimatedBuilder(
      animation: Listenable.merge([_nomeCtrl, _precoCtrl, _descCtrl, _ingredientesCtrl]),
      builder: (context, _) {
        return Container(
          width: 300,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, border: Border.all(color: corTextoSecundario), borderRadius: BorderRadius.circular(12), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Pré-visualização', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Container(
                height: 150, width: double.infinity,
                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.image, size: 50, color: Colors.white),
              ),
              const SizedBox(height: 16),
              Text(_nomeCtrl.text.isEmpty ? 'Nome do item' : _nomeCtrl.text, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: corTextoPrincipal)),
              const SizedBox(height: 8),
              Text('R\$ ${_precoCtrl.text.isEmpty ? '0,00' : _precoCtrl.text}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: corTextoSecundario)),
              const SizedBox(height: 8),
              Text(_descCtrl.text.isEmpty ? 'Descrição do produto...' : _descCtrl.text, style: TextStyle(color: corTextoSecundario)),
              const SizedBox(height: 8),
              Text(_ingredientesCtrl.text.isEmpty ? 'Ingredientes...' : _ingredientesCtrl.text, style: const TextStyle(color: Colors.grey, fontStyle: FontStyle.italic, fontSize: 12)),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: _catForm == 'Pratos' ? corTextoPrincipal : _catForm == 'Bebidas' ? Colors.blue[700] : _catForm == 'Sobremesas' ? Colors.pink[600] : Colors.grey[500],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(_catForm.isEmpty ? 'Categoria' : _catForm, style: const TextStyle(color: Colors.white, fontSize: 12)),
              ),
            ],
          ),
        );
      }
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